local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()


local DiscardChargeSprite = Sprite("gfx/chargebar.anm2")
local HandChargeSprite = Sprite("gfx/chargebar.anm2")

local HandsBar = Sprite("gfx/Cards_Bar.anm2")
HandsBar.Scale=Vector(0.5,0.5)

local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")

local TrinketSprite = Sprite("gfx/005.350_custom.anm2")
local JimboCards = {PlayingCards = Sprite("gfx/ui/PlayingCards.anm2"),
                    Pack_PlayingCards = Sprite("gfx/ui/PackPlayCards.anm2"),
                    SpecialCards = Sprite("gfx/ui/PackSpecialCards.anm2")}
local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")

local Edition_Overlay = Sprite("gfx/ui/Edition Overlay.anm2", true) --used on the cards sprites instead of the shaders

local EditionShaders ={ --sadly these don't work for the bigger card spritesheet, if you know how to fix this please let me know!!
    "shaders/Foil_effect",
    "shaders/Holographic_effect",
    "shaders/Polychrome_effect",
    "shaders/Negative_effect"
}
EditionShaders[0] = "shaders/Nothing" --prevents extra if statements on render


local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}
local HAND_TYPE_NAMES = {"high card","pair","Two pair","three of a kind","straight","flush","full house","four of a kind", "straight flush", "royal flush","five of a kind","fluah house","flush five"}
HAND_TYPE_NAMES[0] = "none"

local HandCooldown = 60  -- can be changed to lower/increase the charge time
local CHARGED_ANIMATION = 11 --the length of an animation for chargebars
local CHARGED_LOOP_ANIMATION = 5

local DECK_RENDERING_POSITION = Vector(155,25) --in screen coordinates
local INVENTORY_RENDERING_POSITION = Vector(5,250)
--local DECK_RENDERING_POSITION = Isaac.WorldToRenderPosition(Isaac.ScreenToWorld(Vector(760,745)))

local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()



local HUD_FRAME = {}
HUD_FRAME.Frame = 0
HUD_FRAME.Arrow = 1
HUD_FRAME.Hand = 2
HUD_FRAME.Confirm = 3

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10

local BasicRoomNum = 0
local DeathCopyCard


--charge bars color modifiers
do
    --SETS THE COLOR FOR THE DISCARD CHARGE BAR
    local DiscardProgressBar = DiscardChargeSprite:GetLayer(1)
    
    ---@diagnostic disable-next-line: need-check-nil
    local BarColor = DiscardProgressBar:GetColor()
    BarColor.BO = -1
    BarColor.GO = -0.8
    BarColor.RO = 1

    ---@diagnostic disable-next-line: need-check-nil
    DiscardProgressBar:SetColor(BarColor)
    DiscardChargeSprite.Offset = Vector(-20,-20)

    --SETS THE COLOR FOR THE HAND CHARGE BAR
    local HandProgressBar = HandChargeSprite:GetLayer(1)

    ---@diagnostic disable-next-line: need-check-nil
    BarColor = HandProgressBar:GetColor()
    BarColor.BO = 0.9
    BarColor.GO = -0.3
    BarColor.RO = -1

    ---@diagnostic disable-next-line: need-check-nil
    HandProgressBar:SetColor(BarColor)
    HandChargeSprite.Offset = Vector(20,-20)
end

--local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
--local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root
local Game = Game()
local Level = Game:GetLevel()
local ItemPool = Game:GetItemPool()


--------------HUD RENDER-----------------
-----------------------------------------

function mod:JimboInventoryHUD(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    for i,trinket in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        if trinket ~= 0 then
            local RenderPos = INVENTORY_RENDERING_POSITION + Vector(19*i , 0)

            if mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY and 
               mod.SelectionParams.SelectedCards[i] then
                RenderPos.Y = RenderPos.Y - 9
            end
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(trinket).GfxFileName, true)
            if mod.Counters.Activated[i] then
                TrinketSprite:SetFrame("Effect", mod.Counters.Activated[i])

                if mod.Counters.Activated[i] == JactivateLength then --stops the animation
                    mod.Counters.Activated[i] = nil
                end
            else
                TrinketSprite:SetFrame("Idle", 0)
            end
            TrinketSprite:SetCustomShader(EditionShaders[mod.Saved.Jimbo.Inventory.Editions[i]])
            TrinketSprite:Render(RenderPos)
        end
    end

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY then
        local RenderPos
        if mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] then
            RenderPos = INVENTORY_RENDERING_POSITION + Vector(16 * mod.SelectionParams.Index, -9)
        else
            RenderPos = INVENTORY_RENDERING_POSITION + Vector(16 * mod.SelectionParams.Index, 0)
        end

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = Vector.One
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = INVENTORY_RENDERING_POSITION + Vector(16 * (mod.Saved.Jimbo.InventorySize + 1) + 4, 0)
        CardFrame:SetFrame(HUD_FRAME.Confirm)
        CardFrame:Render(RenderPos)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboInventoryHUD)


--renders the entirety of the extra HUD for Jimbo
function mod:JimboDeckHUD(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local CardsLeft = mod:Clamp((#mod.Saved.Jimbo.FullDeck - mod.Saved.Jimbo.DeckPointer)+1,1000,0)

    --shows how many cards are left in the deck
    DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))

    DeckSprite:Render(DECK_RENDERING_POSITION)


    if Minimap:GetState()== MinimapState.NORMAL then
        if not mod.Saved.Jimbo.SmallCleared then
            mod.Fonts.Balatro:DrawStringScaled(tostring(mod.Saved.Jimbo.ClearedRooms).."/"..tostring(mod.Saved.Jimbo.SmallBlind),380 + Minimap:GetShakeOffset().X,51 +Minimap:GetShakeOffset().Y,0.5,0.5,KColor(0.7,0.7,0.7,1))
            mod.Fonts.Balatro:DrawStringScaled(tostring(mod.Saved.Jimbo.ClearedRooms).."/"..tostring(mod.Saved.Jimbo.SmallBlind),380 + Minimap:GetShakeOffset().X,50 +Minimap:GetShakeOffset().Y,0.5,0.5,KColor(1,1,1,1))
            --mod.Fonts.Balatro:DrawString(tostring(ClearedRooms).."/"..tostring(BigBlind),Isaac.WorldToScreen(PlayerScreenPos).X+20,Isaac.WorldToScreen(PlayerScreenPos).Y+30,KColor(1,1,1,1))        

        elseif not mod.Saved.Jimbo.BigCleared then
            mod.Fonts.Balatro:DrawStringScaled(tostring(mod.Saved.Jimbo.ClearedRooms).."/"..tostring(mod.Saved.Jimbo.BigBlind),100 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,0.5,0.5,KColor(1,1,1,1))        
        end
    end
    
    --local String = "+"..tostring(CardsLeft)

    --mod.Fonts.Balatro:DrawStringScaled(String, 
    --DECK_RENDERING_POSITION.X - mod.Fonts.Balatro:GetStringWidth(String)/2 + Minimap:GetShakeOffset().X,
    --DECK_RENDERING_POSITION.Y + 15 + Minimap:GetShakeOffset().Y,0.33,0.33,KColor(1,1,1,1))


    --[[
    ---DECK RENERING----
    for i, Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local Card = mod.Saved.Jimbo.FullDeck[Pointer]
        if Card then
            local RenderPos = DECK_RENDERING_POSITION + Vector(14 * i, 0)
            --JimboCards.R_PlayingCards.Scale=Vector(0.8,0.8)
            --JimboCards.PlayingCards.Scale=Vector(0.8,0.8)

            if mod.SelectionParams.SelectedCards[i] and mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
                RenderPos.Y = RenderPos.Y - 9 --moves up selected cards
            end

            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
            Edition_Overlay:SetFrame("Editions", Card.Edition)

            -------------------------------------------------------------
            JimboCards.PlayingCards:Render(RenderPos)
            Edition_Overlay:Render(RenderPos)
            --150 // 10.4
            --360//122

        end
    end

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        local RenderPos = DECK_RENDERING_POSITION + Vector(14 * mod.SelectionParams.Index, 0)
        
        if mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] then

            RenderPos.Y = RenderPos.Y - 9
        end    

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = DECK_RENDERING_POSITION + Vector(14 * (mod.Saved.Jimbo.HandSize + 1), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(RenderPos)


        --HAND TYPE TEXT RENDER--
        mod.Fonts.Balatro:DrawString(HAND_TYPE_NAMES[mod.SelectionParams.HandType],DECK_RENDERING_POSITION.X + 50,DECK_RENDERING_POSITION.Y -100,KColor(1,1,1,1))

        --allows mouse controls to be used as a way to select cards--
        local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
        if MousePosition.X >= DECK_RENDERING_POSITION.X and MousePosition.Y >= DECK_RENDERING_POSITION.Y  then
            local HandMousePosition = math.ceil((MousePosition.X - (DECK_RENDERING_POSITION.X))/CardHUDWidth)
            if HandMousePosition <= mod.Saved.Jimbo.HandSize + 1 then
                mod.SelectionParams.Index = HandMousePosition
            end
        end

    else--not selecting
        local CardsLeft = (#mod.Saved.Jimbo.FullDeck - mod.Saved.Jimbo.DeckPointer) + 1
        --shows how many cards are left in the deck
        if CardsLeft > 0 then
            local RenderPos = DECK_RENDERING_POSITION + Vector(14 * (mod.Saved.Jimbo.HandSize + 1),-3)
            mod.Fonts.Balatro:DrawStringScaled("+"..tostring(CardsLeft),RenderPos.X + Minimap:GetShakeOffset().X,RenderPos.Y + Minimap:GetShakeOffset().Y,0.8,1,KColor(1,1,1,1))
        end
    end

    --BLIND COUNTER--
    if Minimap:GetState()== MinimapState.NORMAL then
        if not mod.Saved.Jimbo.SmallCleared then
            mod.Fonts.Balatro:DrawString(tostring(mod.Saved.Jimbo.ClearedRooms).."/"..tostring(mod.Saved.Jimbo.SmallBlind),100 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,KColor(1,1,1,1))
            --mod.Fonts.Balatro:DrawString(tostring(ClearedRooms).."/"..tostring(BigBlind),Isaac.WorldToScreen(PlayerScreenPos).X+20,Isaac.WorldToScreen(PlayerScreenPos).Y+30,KColor(1,1,1,1))        

        elseif not mod.Saved.Jimbo.BigCleared then
            mod.Fonts.Balatro:DrawString(tostring(mod.Saved.Jimbo.ClearedRooms).."/"..tostring(mod.Saved.Jimbo.BigBlind),100 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,KColor(1,1,1,1))        
        end
    end]]
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboDeckHUD)

local ScaleMult = 0.5
local LastCardFullPoss = {}
---@param Player EntityPlayer
function mod:JimboHandRender(Player, Offset)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local TargetScale = 0.5
    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        TargetScale = 1 --while selecting the the cards gets bigger
    end
    if ScaleMult ~= TargetScale then
        --ScaleMult = mod:Lerp(ScaleMult,TargetScale, mod.SelectionParams.Frames/100)
        ScaleMult = mod:Lerp(1.5 - TargetScale,TargetScale, mod.SelectionParams.Frames/5)
    end

    local PlayerScreenPos = Isaac.WorldToRenderPosition(Player.Position)
    local BaseRenderOff = Vector( (-7*mod.Saved.Jimbo.HandSize + 3.5) * ScaleMult + 1.5*(5-mod.Saved.Jimbo.HandSize),26 * ScaleMult)

    local RenderOff = BaseRenderOff + Vector.Zero
    local TrueOffset = {}

    
    for i, Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local Card = mod.Saved.Jimbo.FullDeck[Pointer]
        if Card then

            if mod.SelectionParams.SelectedCards[i] and mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
                RenderOff.Y = RenderOff.Y -  8
            end
             --moves up selected cards


            LastCardFullPoss[Pointer] = LastCardFullPoss[Pointer] or RenderOff --check nil

            TrueOffset[Pointer] = Vector(mod:Lerp(LastCardFullPoss[Pointer].X, RenderOff.X, mod.Counters.SinceShift/5)
                               ,mod:Lerp(LastCardFullPoss[Pointer].Y, RenderOff.Y, mod.Counters.SinceSelect/1.25))
            

            if TrueOffset[Pointer].X == RenderOff.X and TrueOffset[Pointer].Y == RenderOff.Y then
                LastCardFullPoss[Pointer] = RenderOff + Vector.Zero
            end


            -------------------------------------------------------------

            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
            Edition_Overlay:SetFrame("Editions", Card.Edition)

            JimboCards.PlayingCards.Scale = Vector(ScaleMult,ScaleMult)
            Edition_Overlay.Scale = Vector(ScaleMult,ScaleMult)


            JimboCards.PlayingCards:Render(PlayerScreenPos + TrueOffset[Pointer] + Offset)
            Edition_Overlay:Render(PlayerScreenPos + TrueOffset[Pointer] + Offset)

        end

        RenderOff = Vector(RenderOff.X + 14*ScaleMult, BaseRenderOff.Y)
    end

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then

        --last confirm option
        RenderOff = BaseRenderOff + Vector(14 * (mod.Saved.Jimbo.HandSize), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(PlayerScreenPos + RenderOff + Offset)



        RenderOff = BaseRenderOff + Vector(14 * (mod.SelectionParams.Index - 1) * ScaleMult, 0)

        if mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] then
            RenderOff.Y = RenderOff.Y - 8
        end

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(PlayerScreenPos + (TrueOffset[mod.Saved.Jimbo.CurrentHand[mod.SelectionParams.Index]] or RenderOff)  + Offset)


        --HAND TYPE TEXT RENDER--
        --mod.Fonts.Balatro:DrawString(HAND_TYPE_NAMES[mod.SelectionParams.HandType],DECK_RENDERING_POSITION.X + 50,DECK_RENDERING_POSITION.Y -100,KColor(1,1,1,1))

        --allows mouse controls to be used as a way to select cards--
        local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
        if MousePosition.X >= DECK_RENDERING_POSITION.X and MousePosition.Y >= DECK_RENDERING_POSITION.Y  then
            local HandMousePosition = math.ceil((MousePosition.X - (DECK_RENDERING_POSITION.X))/CardHUDWidth)
            if HandMousePosition <= mod.Saved.Jimbo.HandSize + 1 then
                mod.SelectionParams.Index = HandMousePosition
            end
        end

    else
        local Frame = math.ceil((mod.Saved.Jimbo.Progress.Room.Shots/mod.Saved.Jimbo.MaxCards) * -26 + 26)
        if mod.Saved.Jimbo.FirstDeck and not Game:GetRoom():IsClear() then
            HandsBar:SetFrame("Charge On", Frame) 
        else
            HandsBar:SetFrame("Charge Off", Frame) 
        end
        HandsBar:PlayOverlay("overlay_"..tostring(mod.Saved.Jimbo.MaxCards))
        --HandsBar:SetOverlayFrame(0)

        HandsBar:Render(PlayerScreenPos + RenderOff + Offset)



        RenderOff = BaseRenderOff + Vector(14 * (mod.Saved.Jimbo.HandSize - 1) * ScaleMult, 0)

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(PlayerScreenPos + RenderOff + Offset)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, mod.JimboHandRender,PlayerVariant.PLAYER)


--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboPackRender(_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType 
       or mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end
    
    local PlayerPos = Isaac.WorldToScreen(Player.Position)

    --base point, increased while rendering 
    local BaseRenderPos = Vector(PlayerPos.X - CardHUDWidth * mod.SelectionParams.OptionsNum /2 - PACK_CARD_DISTANCE * (mod.SelectionParams.OptionsNum - 1) /2,
                                 PlayerPos.Y + 20)
    BaseRenderPos.X = BaseRenderPos.X + 6.5--makes it centered

    local RenderPos = BaseRenderPos + Vector.Zero
    local WobblyEffect = {}

    if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.StandardPack then
        --SHOWS THE CHOICES AVAILABLE

        for i,Card in ipairs(mod.SelectionParams.PackOptions) do --for every option


        
            JimboCards.Pack_PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            JimboCards.Pack_PlayingCards:SetOverlayFrame("Seals", Card.Seal)
            Edition_Overlay:SetFrame("Editions", Card.Edition)
            Edition_Overlay.Scale = Vector.One

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams.Frames*4+i*60))*2)

            JimboCards.Pack_PlayingCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams.Frames/10))
            Edition_Overlay:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams.Frames/10))


            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.BuffonPack then
        
        for i,card in ipairs(mod.SelectionParams.PackOptions) do
    
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)
            TrinketSprite:SetFrame("Idle", 0)

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams.Frames*4+i*60))*2)

            TrinketSprite:SetCustomShader(EditionShaders[card.Edition])
            TrinketSprite:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams.Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end

    else--TAROT, PLANET or SPECTRAL
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams.PackOptions) do
            
            if Option == 53 then --equivalent to the soul card
                JimboCards.SpecialCards:SetFrame("Soul Stone",mod.SelectionParams.Frames % 47) --sets the frame corresponding to the value and suit
            else
                JimboCards.SpecialCards:SetFrame("idle",  Option)
            end
            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams.Frames*4+i*60))*2)

            JimboCards.SpecialCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams.Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES

    CardFrame.Scale = Vector.One
    CardFrame:SetFrame(HUD_FRAME.Confirm)
    CardFrame:Render(RenderPos)

    RenderPos.X = BaseRenderPos.X + (mod.SelectionParams.Index - 1)*(PACK_CARD_DISTANCE + CardHUDWidth)
    RenderPos = RenderPos + WobblyEffect[mod.SelectionParams.Index]

    CardFrame:SetFrame(HUD_FRAME.Frame)
    CardFrame:Render(RenderPos)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboPackRender)



--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboBarRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    

    local Data = Player:GetData()
    if Data.PlayCD < HandCooldown then --charging frames needed

        HandChargeSprite:SetFrame("Charging", math.floor(Data.PlayCD * 1.66))

    elseif Data.PlayCD < HandCooldown + CHARGED_ANIMATION then --Charging frames + StartCharged frames
        HandChargeSprite:SetFrame("StartCharged", Data.PlayCD - HandCooldown)

    else
        HandChargeSprite:SetFrame("Charged", Data.PlayCD - (HandCooldown + CHARGED_ANIMATION + CHARGED_LOOP_ANIMATION))
    end

    --renders a timer as a charge bar next to the player
    HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))


    --------------HAND SELECTION COOLDOWN------------------
    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.NONE then
        return
    end

    local HandFrame = 100 - math.ceil(mod.SelectionParams.Frames/2.25)
    
    if HandFrame == 0 then
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE) --PLACEHOLDER
        
    elseif HandFrame > 0 then
        DiscardChargeSprite:SetFrame("Charging", HandFrame)
        --makes the bar flicker more as the timer runs out
        if HandFrame < 25 then
            if HandFrame % 3 == 0 then  
                DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        
        elseif HandFrame < 40 then
            if HandFrame % 3 ~= 0 then

                DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        
        elseif HandFrame < 70 then
            if HandFrame % 5 ~= 0 then

                DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        else
            DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JimboBarRender)


---------------PLAYER MECHANICS----------------------
-----------------------------------------------------

--setups variables for jimbo
---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.JimboType then
        local Data = player:GetData()
        Data.PlayCD = 0 --shoot cooldown

        Data.NotAlrPressed = {} --general controls stuff
        Data.NotAlrPressed.left = true
        Data.NotAlrPressed.right = true
        Data.NotAlrPressed.confirm = true
        Data.NotAlrPressed.ctrl = true
        Data.CTRLhold = 0 --used to activate the inventory selection

        Data.JustPickedEdition = 0 --used for inventory jokers' edition

        --player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)


--makes basically every input possible when using jimbo (+ other stuff)
---@param Player EntityPlayer
function mod:JimboInputHandle(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    -----------DISCARD COOLDOWN-------------
    if Data.PlayCD <= HandCooldown + CHARGED_ANIMATION + CHARGED_LOOP_ANIMATION then
        Data.PlayCD = Data.PlayCD + 1
    else
        Data.PlayCD = HandCooldown + CHARGED_ANIMATION
    end


    ----------SELECTION INPUT / INPUT COOLDOWN------------
    if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.NONE then --while in the card selection menu cheks for inputs
        -------------INPUT HANDLING-------------------(big ass if statements ik lol)
        
        --confirming/canceling 
        if  Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
            and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)--usually they share buttons
            or Input.IsMouseBtnPressed(MouseButton.LEFT) then

            if  Data.NotAlrPressed.confirm then
                mod:Select(Player)
                Data.NotAlrPressed.confirm = false
            end
        else --not pressed
            Data.NotAlrPressed.confirm = true
        end


        --pressing left moving the selection
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) then

            if  Data.NotAlrPressed.left and mod.SelectionParams.Index > 1 then
                mod.SelectionParams.Index = mod.SelectionParams.Index - 1
                Data.NotAlrPressed.left = false
            end
        else--not pressed
            Data.NotAlrPressed.left = true
        end

        --pressing right moving the selection
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then
            if Data.NotAlrPressed.right and mod.SelectionParams.Index <= mod.SelectionParams.OptionsNum then

            mod.SelectionParams.Index = mod.SelectionParams.Index + 1
            Data.NotAlrPressed.right = false
            end
        else --not pressed
            Data.NotAlrPressed.right = true
        end
    
        Player.Velocity = Vector.Zero
    else --not selecting anything
    
        if Input.IsActionPressed(ButtonAction.ACTION_DROP, Player.ControllerIndex) then
            
            if Data.CTRLhold == 0 then
                local LastCard = mod.Saved.Jimbo.CurrentHand[mod.Saved.Jimbo.HandSize]

                table.remove(mod.Saved.Jimbo.CurrentHand, mod.Saved.Jimbo.HandSize)
                table.insert(mod.Saved.Jimbo.CurrentHand,1 ,LastCard)

                mod.Counters.SinceShift = 0
            elseif Data.CTRLhold == 40 then --if held long enough starts the inventory selection
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
                Data.CTRLhold = 0
            end

            Data.CTRLhold = Data.CTRLhold + 1

        else
            Data.CTRLhold = 0
        end

        -----------SHOOTING HANDLING---------------
        local AimDirection = Player:GetAimDirection()
        if Data.PlayCD >= HandCooldown and (AimDirection.X ~= 0 or AimDirection.Y ~= 0) then
            mod:JimboShootCardTear(Player, AimDirection)
            Data.PlayCD = 0
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.JimboInputHandle)


function mod:CountersUpdate()
    for i,v in pairs(mod.Counters) do
        if type(v) == "table" then
            for j,w in ipairs(v) do
                mod.Counters[i][j] = mod.Counters[i][j] + 1
            end
        else
            mod.Counters[i] = mod.Counters[i] + 1
        end
    end

    if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.NONE then
        mod.SelectionParams.Frames = mod.SelectionParams.Frames + 1
    else
        mod.SelectionParams.Frames = mod.SelectionParams.Frames - 1
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.CountersUpdate)


local CoinQuality = {[CoinSubType.COIN_PENNY] = 1, 
                    [CoinSubType.COIN_DOUBLEPACK] = 1.5, 
                    [CoinSubType.COIN_STICKYNICKEL] = 3.5, 
                    [CoinSubType.COIN_NICKEL] = 4, 
                    [CoinSubType.COIN_LUCKYPENNY] = 5, 
                    [CoinSubType.COIN_GOLDEN] = 5, 
                    [CoinSubType.COIN_DIME] = 6}
--removes some coins spawnned by the game and players
---@param Pickup EntityPickup
function mod:LessCoins(Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    --try to remove if spawned by a player or if it's bigger than a penny 
    if (Pickup.SpawnerEntity or Pickup.SubType == CoinSubType.COIN_PENNY)
       and Pickup.SpawnerType ~= EntityType.ENTITY_PLAYER
        then
        return
    end

    local MaxLuck
    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if not MaxLuck or Player.Luck > MaxLuck then
            MaxLuck = Player.Luck
        end
    end

    local RemoveChance = (1/(2 + MaxLuck/4)) * CoinQuality[Pickup.SubType]^0.333

    if Pickup:GetDropRNG():RandomFloat() <= RemoveChance then
        
        local Player = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)

        ---@diagnostic disable-next-line: need-check-nil
        Player:AddBlueFlies(CoinQuality[Pickup.SubType], Pickup.Position, Player)
        Pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.LessCoins, PickupVariant.PICKUP_COIN)



--changes the shop items to be in a specific pattern and rolls for the edition
---@param Pickup EntityPickup
---@param rNG RNG
function mod:ShopItemChanger(Pickup,Variant, SubType, ReqVariant, ReqSubType, rNG)

    local ReturnTable = {Variant, SubType, true} --basic return equal to not returning anything

    local RollRNG = Game:GetPlayer(0):GetDropRNG() --tried using the rng from the callback but it gave the same results each time


    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       and (ReqSubType == 0 or ReqVariant == 0) then
        
        if Game:GetRoom():GetType() == RoomType.ROOM_SHOP and Pickup:IsShopItem() then


            if Pickup.ShopItemId <= 1 then --card pack
                ReturnTable = {PickupVariant.PICKUP_TAROTCARD,mod:GetRandom(mod.Packs, mod.Saved.GeneralRNG),false}

            elseif Pickup.ShopItemId == 2 then --voucher / joker if already bought
                --ngl i'm really proud of the algorithm i wrote on this section

                ---@type boolean | integer
                local VoucherPresent = false
                for i,v in ipairs(Isaac.FindByType(5, 100)) do
                    if v:ToPickup().ShopItemId == Pickup.ShopItemId then --if yes, the item voucher wasn't bought
                        VoucherPresent = v.SubType
                        break
                    end
                end

                if not Game:GetRoom():IsInitialized() then --if room is just being entered
                    --predicts the current voucher so it can exit the /repeat until/ statement
                    VoucherPresent = mod:GetRandom(mod.Saved.Pools.Vouchers, rNG, true)
                end

                if VoucherPresent then --voucher still here with us

                    local Rvoucher
                    repeat
                        Rvoucher = mod:GetRandom(mod.Saved.Pools.Vouchers, rNG) --using this rng basically makes it un rerollable with mechines
                        --PLEASE tell me if the RNG not advancing gets patched cause it'll break the voucher generation 

                    until not mod:Contained(mod.Saved.Jimbo.Progress.Floor.Vouchers, Rvoucher) --no dupes per floor
                          or Rvoucher == VoucherPresent --if it's getting rerolled (kinda)

                    table.insert(mod.Saved.Jimbo.Progress.Floor.Vouchers, Rvoucher)

                    ReturnTable = {PickupVariant.PICKUP_COLLECTIBLE,Rvoucher, false}

                else --replace with a joker if already bought instead

                    ReturnTable = {PickupVariant.PICKUP_TRINKET, 1, false}
                end

            elseif Pickup.ShopItemId == 3 then --basic shop item
                ReturnTable = {PickupVariant.PICKUP_COLLECTIBLE,
                        ItemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, RollRNG:GetSeed()), false}

            else
                ReturnTable = {PickupVariant.PICKUP_TRINKET, 1 ,false}
            end
        end

        --if a trinket is selected, then roll for joker and edition
        if ReturnTable[1] == PickupVariant.PICKUP_TRINKET then

            local ExistingJokers = {}
            for i, Trinket in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
                table.insert(ExistingJokers, Trinket.SubType)
            end

            local RandomJoker = mod:RandomJoker(RollRNG, ExistingJokers, true)

            ReturnTable = {PickupVariant.PICKUP_TRINKET, RandomJoker.Joker ,false}

            mod.Saved.Jimbo.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(RandomJoker.Joker).Name] = RandomJoker.Edition
        
        --reverse tarot become their non-reverse variant
        elseif ReturnTable[1] == PickupVariant.PICKUP_TAROTCARD 
               and ReturnTable[2] >= Card.CARD_REVERSE_FOOL and ReturnTable[2] <= Card.CARD_REVERSE_WORLD then

            ReturnTable[2] = ReturnTable[2] - 55
    
        end
    end

    --print(tostring(Pickup.ShopItemId).." "..tostring(ReturnTable[1]).." "..tostring(ReturnTable[2]))
    return ReturnTable
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, mod.ShopItemChanger)


--makes every item a paid shop item (also see SetItemPrices)
--removes coins that are not spwned by jimbo
---@param Pickup EntityPickup
function mod:SetItemAsShop(Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) or Pickup:IsShopItem() then
        return
    end

    Pickup:MakeShopItem(-2)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.SetItemAsShop, PickupVariant.PICKUP_COLLECTIBLE)


--sets the price for every item basing on quality and room
function mod:SetItemPrices(Variant,SubType,ShopID,Price)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    Level:GetCurrentRoomDesc().ShopItemDiscountIdx = -1 --no discounts ever

    local Cost = 1
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local Item = ItemsConfig:GetCollectible(SubType)
        if Item:HasCustomTag("balatro") then --vouchers
            Cost = 10
        else --any item in the game
            Cost = Item.Quality *2 + 2
        end

    elseif Variant == PickupVariant.PICKUP_TRINKET then --jokers
        Cost = mod:GetJokerCost(SubType)

    else --prob stuff like booster packs
        Cost = 5
    end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
        Cost = Cost * 2 - 1 --nullifies the usual steam sale effect and subratcts 1 instead
    end
    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Liquidation) then --50% off
        Cost = Cost * 0.5

    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Clearance) then --25% off
        Cost = Cost * 0.75

    end
    Cost = math.floor(Cost) --rounds it down 
    Cost = math.max(Cost, 1)

    return Cost
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.SetItemPrices)


--modifies the floor generation and calculates the number of normal rooms
---@param RoomConfig RoomConfigRoom
---@param LevelGen LevelGeneratorRoom
function mod:FloorModifier(LevelGen,RoomConfig,Seed)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end
    mod.ShopAddedThisFloor = false
    local RoomIndex = LevelGen:Column() + LevelGen:Row()*13
    
    --print(RoomIndex)

    if RoomConfig.Type == RoomType.ROOM_SHOP then
        --("s")
        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3
            if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
                ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_4
            elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
                ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_5
            end
        local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

        Isaac.CreateTimer(
        function()
            Level:GetRoomByIdx(RoomIndex).DisplayFlags = 5

            Level:UpdateVisibility()
        end, 1, 1, true)

        return NewRoom --replaces the room with the new one

    elseif RoomConfig.Type == RoomType.ROOM_DEFAULT then
        --adds an extra shop on every floor (on basement I/II has a ~8% to fail due to lack of options)

        if RoomIndex ~= Level:GetStartingRoomIndex() then
            BasicRoomNum = BasicRoomNum + 1
        end

        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
            ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_5
        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
            ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_4
        end

        local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

        for Slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
            if RoomConfig.Doors & (1 << Slot) ~= 0 then --if door is available
                --print("door at "..tostring(Slot))
                Isaac.CreateTimer(
                function()
                    if mod.ShopAddedThisFloor then
                        return
                    end

                    ---@diagnostic disable-next-line: redundant-parameter
                    local YeRoom = Level:TryPlaceRoomAtDoor(NewRoom, Level:GetRoomByIdx(RoomIndex), Slot,Seed, false, false)
                    if YeRoom then
                        YeRoom.DisplayFlags = 5
                        mod.ShopAddedThisFloor = true
                    end
                end,1,1,true)
            end
        end
    elseif RoomConfig.Type == RoomType.ROOM_BOSS then
        Isaac.CreateTimer(
        function()
            Level:GetRoomByIdx(RoomIndex).DisplayFlags = 5

            Level:UpdateVisibility()
        end, 1, 1, true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, mod.FloorModifier)

--calculates how big the blinds are 
function mod:CalculateBlinds()

    mod.Saved.Jimbo.SmallCleared = false
    mod.Saved.Jimbo.BigCleared = false
    mod.Saved.Jimbo.BossCleared = false
    mod.Saved.Jimbo.ClearedRooms = 0

    --the more rooms, the less you need to complete
    if BasicRoomNum < 40 then
        BasicRoomNum = math.floor(BasicRoomNum * (0.9 - BasicRoomNum/100))
    else
        BasicRoomNum =  math.floor(BasicRoomNum * 0.55) --the minimum is 55% of rooms
    end
 
    mod.Saved.Jimbo.SmallBlind = math.floor(BasicRoomNum/2) -- about half of the rooms
    mod.Saved.Jimbo.BigBlind = BasicRoomNum - mod.Saved.Jimbo.SmallBlind --about half of the rooms
    
    BasicRoomNum = 0 --resets the counter
    ShopAddedThisFloor = false

    Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.SMALL)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.CalculateBlinds)
--mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE,mod.CalculateBlinds)

--handles the rooms which are cleared by default and shuffels if they are not
function mod:HandleNoHarmRoomsClear()
    local Desc = Level:GetCurrentRoomDesc()
    
    if Desc.VisitedCount ~= 1 or Desc.GridIndex == Level:GetStartingRoomIndex()
       or not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end


    if Desc.Clear then --if the room is not hostile
        --print("clear")
        if Desc.Data.Type == RoomType.ROOM_DEFAULT then
            Isaac.RunCallback("TRUE_ROOM_CLEAR",false, false)

        elseif Desc.Data.Type == RoomType.ROOM_SHOP then
            local Seed = Game:GetRoom():GetSpawnSeed()
            Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                       Game:GetRoom():GetGridPosition(25),Vector.Zero, nil, 0, Seed)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HandleNoHarmRoomsClear)


function mod:AddRoomsCleared(IsBoss, _)

    ---@diagnostic disable-next-line: param-type-mismatch
    mod:StatReset(PlayerManager.FirstPlayerByType(mod.Characters.JimboType), true, true, true, false, true)

    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then
            Player:AddHearts(2)
            mod:FullDeckShuffle(Player)
        end
    end

    if IsBoss and not mod.Saved.Jimbo.BossCleared then
        Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BOSS)
        mod.Saved.Jimbo.BossCleared = true
    else
        mod.Saved.Jimbo.ClearedRooms = mod.Saved.Jimbo.ClearedRooms + 1
        if mod.Saved.Jimbo.ClearedRooms == mod.Saved.Jimbo.SmallBlind and not mod.Saved.Jimbo.SmallCleared then
            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.SMALL)
            mod.Saved.Jimbo.SmallCleared = true
            mod.Saved.Jimbo.ClearedRooms = 0
        elseif mod.Saved.Jimbo.ClearedRooms == mod.Saved.Jimbo.BigBlind and not mod.Saved.Jimbo.BigCleared then
            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BIG)
            mod.Saved.Jimbo.BigCleared = true
            mod.Saved.Jimbo.ClearedRooms = 0
        end
    end
end
mod:AddPriorityCallback("TRUE_ROOM_CLEAR",CallbackPriority.LATE, mod.AddRoomsCleared)


--activates whenever the deckpointer is shifted (has the steel cards effect)
---@param Player EntityPlayer
function mod:OnDeckShift(Player)

    --shuffle the deck if finished
    if mod.Saved.Jimbo.DeckPointer > #mod.Saved.Jimbo.FullDeck + mod.Saved.Jimbo.HandSize then

        if mod.Saved.Jimbo.FirstDeck and mod.Saved.Jimbo.Progress.Room.Shots < mod.Saved.Jimbo.MaxCards then
            mod.Saved.Jimbo.FirstDeck = false --no more stat boosts from cards in the cuurent room
            Player:AnimateSad()
        end
        mod:FullDeckShuffle(Player)
    end

    mod.Counters.SinceShift = 0

    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)
    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)

end
mod:AddCallback("DECK_SHIFT", mod.OnDeckShift)


function mod:SteelStatBoosts(Player, Cache)
    for _,index in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local Triggers = 0
        if mod.Saved.Jimbo.FullDeck[index]
           and mod.Saved.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.STEEL then

            Triggers = Triggers + 1

            if mod.Saved.Jimbo.FullDeck[index].Seal == mod.Seals.RED then
                Triggers = Triggers + 1
            end
            --if mod:JimboHasTrinket(Player, TrinkrtType.MIME) then Triggers = Triggers + 1

            --steel cards use the joker stats cause they are variable and need to be reset each time
            mod:IncreaseJimboStats(Player,0, 0, 1.1^Triggers, false,false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SteelStatBoosts, CacheFlag.CACHE_DAMAGE)

function mod:GiveRewards(BlindType)


    local Seed = Game:GetSeeds():GetStartSeed()
    local Jimbo

    --calculates the ammount of interests BEFORE giving the clear reward
    local Interests = math.floor(Game:GetPlayer(0):GetNumCoins()/5)
    if Interests > 5 then Interests = 5 end

    --gives coins basing on the blind cleared and finds jimbo
    for _,Player in ipairs(PlayerManager:GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then

            Jimbo = Player

            Jimbo:AddHearts(Jimbo:GetHeartLimit()) --fully heals 

            Isaac.CreateTimer(function ()
                if BlindType == mod.BLINDS.SMALL then
                    
                    Player:AddCoins(3)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+3 $", Vector(0,20))
                    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BIG)

                elseif BlindType == mod.BLINDS.BIG then
                    Player:AddCoins(4)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+4 $", Vector(0,20))
                    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BOSS)
                    
                elseif BlindType == mod.BLINDS.BOSS then
                    Player:AddCoins(5)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+5 $", Vector(0,20))
    
                end
            end, 15,1, true)
            
        end
    end
    for _,index in ipairs(mod.Saved.Jimbo.CurrentHand) do
        if mod.Saved.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.GOLDEN then
            Jimbo:AddCoins(3)
        end
    end

    if mod.Saved.Jimbo.FirstDeck then
        Jimbo:AddCoins(2)
    end

    --gives interest
    Isaac.CreateTimer(function ()
        for i = 1, Interests, 1 do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Jimbo.Position, RandomVector() * 4, nil, CoinSubType.COIN_PENNY, Seed)
            --Balatro_Expansion:EffectConverter(8,0,Jimbo,4)
        end 
        mod:CreateBalatroEffect(Jimbo,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+"..tostring(Interests).." $", Vector(0,20))
    end, 15, 1, true)
end
mod:AddPriorityCallback("BLIND_CLEARED",CallbackPriority.LATE, mod.GiveRewards)


---@param Player EntityPlayer
function mod:JimboAddTrinket(Player, Trinket, _)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        
        Player:TryRemoveTrinket(Trinket) -- a custom array is used instead since he needs to hold many of them

        local Slot = mod:AddValueToTable(mod.Saved.Jimbo.Inventory.Jokers, Trinket, true, false)
        local JokerEdition = mod.Saved.Jimbo.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Trinket).Name] or mod.Edition.BASE 

        mod.Saved.Jimbo.Inventory.Editions[Slot] = JokerEdition --gives the correct edition to the inventory slot

        if JokerEdition == mod.Edition.NEGATIVE then
            mod:AddJimboInventorySlots(Player, 1)
        end

        local InitialProg = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[2]
        mod.Saved.Jimbo.Progress.Inventory[Slot] = tonumber(InitialProg)

        Isaac.RunCallback("INVENTORY_CHANGE", Player)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.JimboAddTrinket)

---@param RNG RNG 
function mod:JimboTrinketPool(_, RNG)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end
    print("pool")

    local RarityRoll = RNG:RandomFloat()
    if RarityRoll < 0.70 then --common
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.common, RNG)
        until not mod:JimboHasTrinket(nil, Joker) --no duplicates
        return Joker
    elseif RarityRoll < 0.95 then --uncommon
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.uncommon, RNG)
        until not mod:JimboHasTrinket(nil, Joker)
        return Joker
    else --rare
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.rare, RNG)
        until not mod:JimboHasTrinket(nil, Joker)
        return Joker
    end
end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.JimboTrinketPool)

---@param Trinket EntityPickup
function mod:TrinketEditionsRender(Trinket, Offset)
    local Index = Level:GetCurrentRoomDesc().ListIndex

    if mod.Saved.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] then --just a precaution

        Trinket:GetSprite():SetCustomShader(EditionShaders[mod.Saved.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name]])
    else
        mod.Saved.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.TrinketEditionsRender, PickupVariant.PICKUP_TRINKET)


function mod:EnableTrinketEditions()
    mod.Saved.Jimbo.FloorEditions = {}
    Isaac.CreateTimer(function()
        local AllRoomsDesc = Level:GetRooms()
        for i=1, Level:GetRoomCount()-1 do
            local RoomDesc = AllRoomsDesc:Get(i)
            mod.Saved.Jimbo.FloorEditions[RoomDesc.ListIndex] = {}
        end
    end, 1,1,true )
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.EnableTrinketEditions)

--jimbo can only take one heart container worth of damage per time
--makes jimbo discard whenever he takes damage in a not cleared room
---@param Player Entity
function mod:JimboTakeDamage(Player,Amount,_,Source,_)
    ---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()
    if Player and Player:GetPlayerType() == mod.Characters.JimboType and Amount ~= 0 then

        --only remove one eternal/rotten heart if he has any
        if Player:GetEternalHearts() ~= 0  then

            Player:AddEternalHearts(-1)

        elseif Player:GetRottenHearts() ~= 0 then

            Player:AddRottenHearts(-1)   
            Player:AddHearts(-1) --rotten hearts leave you with half a red heart(??)

        elseif Player:GetBoneHearts() ~= 0 then

            if Player:GetHearts() > Player:GetMaxHearts() then --if a bone heart is filled
                Player:AddHearts(-2)
            else
                Player:AddBoneHearts(-2)
                sfx:Play(SoundEffect.SOUND_BONE_SNAP)
            end
            
        else
            Player:AddHearts(-2)
        end
        Player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, Source, 0) --take fake damage
        Player:SetMinDamageCooldown(80)

        --||DISCARD MECHANIC||
        --if not Game:GetRoom():IsClear() then

            local BaseRenderOff = Vector( (-7*mod.Saved.Jimbo.HandSize + 3.5) * ScaleMult + 1.5*(5-mod.Saved.Jimbo.HandSize),26 * ScaleMult)
            
            Isaac.RunCallback("HAND_DISCARD", Player) --various joker/card effects
            for i=1, mod.Saved.Jimbo.HandSize do
                
                --discards all the cards in hand
                mod:AddValueToTable(mod.Saved.Jimbo.CurrentHand, mod.Saved.Jimbo.DeckPointer,false,true)
                mod.Saved.Jimbo.DeckPointer = mod.Saved.Jimbo.DeckPointer + 1

                --adding these two lines make the game freak out for no reason
                LastCardFullPoss[mod.Saved.Jimbo.CurrentHand[i]] = BaseRenderOff + Vector.Zero --does a cool swoosh effect
                mod.Counters.SinceShift = 0
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        --end

        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.JimboTakeDamage)





---@param Player EntityPlayer
---@param HpType AddHealthType
function mod:JimboOnlyRedHearts(Player, Amount, HpType, _)

    if Amount == 0 or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    if (HpType | AddHealthType.SOUL == AddHealthType.SOUL or
       HpType | AddHealthType.BLACK == AddHealthType.BLACK) then

        Player:AddBlueFlies(Amount * 2, Player.Position, Player)
        return 0 -- no hearts given

    elseif HpType | AddHealthType.MAX == AddHealthType.MAX and not mod.HpEnable and mod.GameStarted then --can't get hp us normally
        for i = 1, Amount do
            local RPack = mod:GetRandom(mod.Packs, Player:GetDropRNG())
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*2.5, nil, RPack, Player:GetDropRNG():GetSeed())
        end
        Player:StopExtraAnimation() --PLACEHOLDER
        Player:AnimateSad()
        return 0

    elseif HpType | AddHealthType.RED == AddHealthType.RED and Amount % 2 == 1 then
        return Amount + 1
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, mod.JimboOnlyRedHearts)



---@param Familiar EntityFamiliar
function mod:JimboBlueFliesSpiders(Familiar)

    local Player = Familiar.Player
    if Player:GetPlayerType() == mod.Characters.JimboType then

        --for whaterver reason i need to set a timer or it won't do anything
        Isaac.CreateTimer(function () 
            Familiar.CollisionDamage = (Player.Damage * mod:CalculateTearsValue(Player)) * 2
        end, 1,1,true)

        --print(Familiar.CollisionDamage)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.JimboBlueFliesSpiders, FamiliarVariant.BLUE_FLY)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.JimboBlueFliesSpiders, FamiliarVariant.BLUE_SPIDER)


--shuffles the deck
---@param Player EntityPlayer
function mod:JimboRoomClear(Player)

    local Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_DEFAULT then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",false, true)
    elseif Room == RoomType.ROOM_BOSS then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",true, true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.JimboRoomClear)


---@param Player EntityPlayer
function mod:DiscardEffects(Player)

    local PlayerRNG = Player:GetDropRNG()
    local SealTriggers = 1
    for i,index in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local card = mod.Saved.Jimbo.FullDeck[index]

        if card then --could be nil
            if card.Seal == mod.Seals.PURPLE and PlayerRNG:RandomFloat() <= 1/SealTriggers then

                --spawns a random basic tarotcard
                local RandomSeed = Random()
                if RandomSeed == 0 then RandomSeed = 1 end
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, nil, PlayerRNG:RandomInt(1,22), RandomSeed)
                SealTriggers = SealTriggers + 1 --decreases the chance the more trigger at the same time
            end
        end
    end
end
mod:AddCallback("HAND_DISCARD", mod.DiscardEffects)


-----------------------JIMBO STATS-----------------------
----------------------------------------------------------

--these calculations are used for normal items, NOT stats given by jokers or mod related stuff, as they are flat stat ups
---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboStatCalculator(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    --i swear to god making tear stat calculations is one of the hardest things to understand 
    --so PLEASE if you're looking at this and have some suggestions tell me
    local PositiveDamageMult = 0.15
    local NegativeDamageMult = 0.55

    local TearsMult = 1 --works a little funky, even i don't exactly know how it performs
    local DamageMult = 0.15

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        mod.Saved.Jimbo.MinimumTears = 0.6
        PositiveDamageMult = 0.3
        TearsMult = 0.7
    elseif Player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        mod.Saved.Jimbo.MinimumTears = 0.55
        TearsMult = 0.55
    end

    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local AddedDamage = Player.Damage - 1

        if AddedDamage >= 0 then
            Player.Damage = 1 + AddedDamage* PositiveDamageMult
        else
            Player.Damage = 1 + AddedDamage* NegativeDamageMult
        end
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local JimboBaseTears = 1
        local JimboBaseDelay = mod:CalculateMaxFireDelay(JimboBaseTears)
        local AddedTears = (mod:CalculateTearsValue(Player) - JimboBaseTears)
        
        AddedTears = AddedTears * TearsMult

        if AddedTears < 0 then
            if AddedTears < -0.4 then
                Player.MaxFireDelay = JimboBaseDelay + mod:CalculateTearsUp(JimboBaseDelay, AddedTears + (1/(0.15*AddedTears + 0.2))*(-AddedTears))
            else
                Player.MaxFireDelay = JimboBaseDelay + mod:CalculateTearsUp(JimboBaseDelay, AddedTears + (1/(0.35*AddedTears + 0.5))*(-AddedTears))
            end
        elseif AddedTears <= 4 then
            Player.MaxFireDelay = JimboBaseDelay - mod:CalculateTearsUp(JimboBaseDelay, (1/(0.75*AddedTears+1))*AddedTears)
        else
            AddedTears = AddedTears - 4
            JimboBaseDelay = JimboBaseDelay - mod:CalculateTearsUp(JimboBaseDelay, 1)
            Player.MaxFireDelay = JimboBaseDelay - mod:CalculateTearsUp(JimboBaseDelay, (1/(0.5*AddedTears+1))*AddedTears)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboStatCalculator)


---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboMinimumStats(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    --print(mod:CalculateMaxFireDelay(Tears))
    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        if Player.Damage < mod.Saved.Jimbo.MinimumDamage then
            Player.Damage = mod.Saved.Jimbo.MinimumDamage
        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.Damage = 4.5 / Tears
        end]]--
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local Tears = mod:CalculateTearsValue(Player)
        if Tears < mod.Saved.Jimbo.MinimumTears then
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(mod.Saved.Jimbo.MinimumTears)

        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.MaxFireDelay =  mod:CalculateMaxFireDelay(4.5 / Player.Damage)
        end]]--
    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.JimboMinimumStats)
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE + 1, mod.JimboMinimumStats)

---@param Player EntityPlayer
function mod:StatReset(Player, Damage, Tears, Evaluate, Jokers, Basic)
    if Damage then
        if Basic then
            mod.Saved.Jimbo.StatsToAdd.Damage = 0
            mod.Saved.Jimbo.StatsToAdd.Mult = 1
        end
        if Jokers then
            mod.Saved.Jimbo.StatsToAdd.JokerDamage = 0
            mod.Saved.Jimbo.StatsToAdd.JokerMult = 1
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
    if Tears then
        if Basic then
            mod.Saved.Jimbo.StatsToAdd.Tears = 0
        end
        if Jokers then
            mod.Saved.Jimbo.StatsToAdd.JokerTears = 0
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end
end

function mod:JokerStatReset(Player, Cache)

    --resets the jokers stat boosts every evaluation since otherwise they would infinitely stack
    mod:StatReset(Player, Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE,
                  Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY,
                  false, true, false)
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.JokerStatReset)

--finally gives the actual stat changes to jimbo, also used for always active buffs
function mod:StatGiver(Player, Cache)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local stats = mod.Saved.Jimbo.StatsToAdd

        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            --print(stats.Damage + stats.JokerDamage)
            --print(Player.Damage * stats.JokerMult * stats.Mult)

            Player.Damage = (Player.Damage + (stats.Damage + stats.JokerDamage) * Player.Damage) * stats.JokerMult * stats.Mult

        end
        if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            --print(mod.CalculateTearsValue(Player))
            Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, (stats.Tears +  stats.JokerTears)* mod:CalculateTearsValue(Player))
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.StatGiver)


function mod:IncreaseJimboStats(Player,TearsUp,DamageUp,Mult, Evaluate, Basic)
    if Basic then
        mod.Saved.Jimbo.StatsToAdd.Damage = mod.Saved.Jimbo.StatsToAdd.Damage + DamageUp
        mod.Saved.Jimbo.StatsToAdd.Tears = mod.Saved.Jimbo.StatsToAdd.Tears + TearsUp
        mod.Saved.Jimbo.StatsToAdd.Mult = mod.Saved.Jimbo.StatsToAdd.Mult * Mult
    else
        mod.Saved.Jimbo.StatsToAdd.JokerDamage = mod.Saved.Jimbo.StatsToAdd.JokerDamage + DamageUp
        mod.Saved.Jimbo.StatsToAdd.JokerTears = mod.Saved.Jimbo.StatsToAdd.JokerTears + TearsUp
        mod.Saved.Jimbo.StatsToAdd.JokerMult = mod.Saved.Jimbo.StatsToAdd.JokerMult * Mult
    end
    
    if Evaluate then
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        --print(mod.Saved.Jimbo.StatsToAdd.Tears)
    end

end

-------------CARD TEARS-----------------------
----------------------------------------------

--handles the shooting 
---@param Player EntityPlayer
---@param Direction Vector
function mod:JimboShootCardTear(Player,Direction)
    local CardShot = mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[mod.Saved.Jimbo.HandSize]]
    CardShot.Index = mod.Saved.Jimbo.CurrentHand[mod.Saved.Jimbo.HandSize] --could be useful

    LastCardFullPoss[CardShot.Index] = nil --needed to make the Hand HUD work properly

    --considers the possible ammounts of tears fired
    local ShotParams = Player:GetMultiShotParams()

    local MaxSpread = ShotParams:GetSpreadAngle(WeaponType.WEAPON_TEARS) --half the total angle the tears spread 
    local EyeAngle = ShotParams:GetMultiEyeAngle() --angle used to determine if player has Wiz or not
    local NumTears = ShotParams:GetNumTears() --tears the player fires simultaneusly
    local NumLanes = ShotParams:GetNumLanesPerEye() --similar to numtears, but dicates how the tears get shot

    local Spread = 0
    if NumLanes > 1 then
        Spread = (MaxSpread / (NumLanes - 1)) * 2
    end
    if EyeAngle == 45 then --if player has the wiz
        for i=1,-1,-2 do 
            local BaseAngle = EyeAngle * i --sets +45° and -45° as the base angle

            for j=0, NumTears/2 -1 do --for each eye
                --modifies additionally the angle if you also have stuff like QuadShot
                local FireAngle = (BaseAngle+(MaxSpread - Spread*j)) + Direction:GetAngleDegrees()
                local ShootDirection = (Vector.FromAngle(FireAngle) *10 + Player.Velocity)*Player.ShotSpeed

                local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
                local TearData = Tear:GetData()
                TearData.Enhancement = CardShot.Enhancement
                TearData.Suit = CardShot.Suit

                mod:AddCardTearFalgs(Tear, CardShot)
            end
        end
    else --player does not have the wiz
        for i=0, NumTears-1 do
            local FireAngle = (MaxSpread - Spread*i) + Direction:GetAngleDegrees()
            local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10*Player.ShotSpeed

            local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
            local TearData = Tear:GetData()
            TearData.Enhancement = CardShot.Enhancement
            TearData.Suit = CardShot.Suit

            mod:AddCardTearFalgs(Tear, CardShot)
        end
    end

    mod:AddValueToTable(mod.Saved.Jimbo.CurrentHand, mod.Saved.Jimbo.DeckPointer,false,true)
    mod.Saved.Jimbo.DeckPointer = mod.Saved.Jimbo.DeckPointer + 1
    mod.Saved.Jimbo.Progress.Room.Shots = mod.Saved.Jimbo.Progress.Room.Shots + 1
    if mod.Saved.Jimbo.Progress.Room.Shots == mod.Saved.Jimbo.MaxCards and mod.Saved.Jimbo.FirstDeck then
        Player:AnimateSad()
    end

    Isaac.RunCallback("DECK_SHIFT",Player)
    Isaac.RunCallback("CARD_SHOT", Player, CardShot, 
    not Game:GetRoom():IsClear() and mod.Saved.Jimbo.FirstDeck and mod.Saved.Jimbo.Progress.Room.Shots < mod.Saved.Jimbo.MaxCards)

    --[[mod.Saved.Jimbo.CurrentHand[mod.Saved.Jimbo.HandSize -mod.Saved.Jimbo.Progress.Hand] = 0 --removes the used card
    mod.Saved.Jimbo.Progress.Hand = mod.Saved.Jimbo.Progress.Hand + 1

    if mod.Saved.Jimbo.Progress.Hand > mod.Saved.Jimbo.HandSize then--if all the hand is empty replace it with a new one
        for i=1, mod.Saved.Jimbo.HandSize do
            mod.Saved.Jimbo.CurrentHand[i] = mod.Saved.Jimbo.DeckPointer
            mod.Saved.Jimbo.DeckPointer = mod.Saved.Jimbo.DeckPointer +1
        end
        mod.Saved.Jimbo.Progress.Hand = 1
    end]]
end



--applies the additional effects for the card tears
---@param Tear EntityTear
---@param Collider Entity
function mod:OnTearCardCollision(Tear,Collider,_)
    if not mod:Contained(mod.CARD_TEAR_VARIANTS, Tear.Variant) then
        return
    end

    local TearData = Tear:GetData()
    TearData.CollidedWith = (TearData.CollidedWith) or {}

    
    if Collider:IsActiveEnemy() and not mod:Contained(TearData.CollidedWith, GetPtrHash(Collider)) then

        table.insert(TearData.CollidedWith, GetPtrHash(Collider))
        
        local TearRNG = Tear:GetDropRNG()

        if mod:IsSuit(nil, TearData.Suit, TearData.Enhancement, mod.Suits.Heart) then --Hearts
        
            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Tear.Position, Vector.Zero, Tear, 0, TearRNG:GetSeed()):ToEffect()
            Creep.SpriteScale = Vector(1.2,1.2)
            Creep.CollisionDamage = Tear.CollisionDamage / 8
            ---@diagnostic disable-next-line: need-check-nil
            Creep:Update()
        end
        if mod:IsSuit(nil, TearData.Suit, TearData.Enhancement, mod.Suits.Club) then --Clubs
            if TearRNG:RandomFloat() < 0.2 then
                Game:BombExplosionEffects(Tear.Position, Tear.CollisionDamage / 2, TearFlags.TEAR_NORMAL, Color.Default, Tear.Parent, 0.5)
                --Isaac.Explode(Tear.Position, Tear, Tear.CollisionDamage / 2)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.OnTearCardCollision)


---@param Tear EntityTear
function mod:AddCardTearFalgs(Tear, CardShot)
    local Player = Tear.Parent:ToPlayer()
    local Incubus = Tear.Parent:ToFamiliar()
    if Tear.SpawnerType == EntityType.ENTITY_PLAYER then
        --print("from player")
    end
    if Incubus then
        --print("Incubus")
    end
    if Player then
       -- print("player")
    end

    if Player and Player:GetPlayerType() == mod.Characters.JimboType then
        --damage dealt = Damage * TearRate of the player
        Tear.CollisionDamage = Player.Damage * mod:CalculateTearsValue(Player)
        Tear.Scale = (Player.SpriteScale.Y + Player.SpriteScale.X) / 2
        --local TearSuit = mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[mod.Saved.Jimbo.HandSize]].Suit
        Tear:ChangeVariant(mod.CARD_TEAR_VARIANTS[CardShot.Suit])

        if mod:IsSuit(Player, CardShot.Suit, CardShot.Enhancement, mod.Suits.Spade, false) then --SPADES
            Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        elseif mod:IsSuit(Player, CardShot.Suit, CardShot.Enhancement, mod.Suits.Diamond, false) then
            Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
            Tear:AddTearFlags(TearFlags.TEAR_BOUNCE)
        end

        local TearSprite = Tear:GetSprite()
        TearSprite:Play(ENHANCEMENTS_ANIMATIONS[CardShot.Enhancement], true)
    end
end


--adjusts the card rotation basing on its movement every few frames
---@param Tear EntityTear
function mod:AdjustCardRotation(Tear)
    local Data = Tear:GetData()
    local TearSprite = Tear:GetSprite()
    Tear.Color = Color.Default

    if not Data.Counter then
        Data.Counter = 2
    end
    if Data.Counter == 2 then
        TearSprite.Rotation = Tear.Velocity:GetAngleDegrees()

        Data.LastRotation = TearSprite.Rotation
        Data.Counter = 0
    else
        TearSprite.Rotation = Data.LastRotation
        Data.Counter = Data.Counter + 1
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Diamond])


------------------VARIOUS/UTILITY------------------
------------------------------------------------

--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local PlayerRNG = Player:GetDropRNG()
        mod.Saved.Jimbo.FullDeck = mod:Shuffle(mod.Saved.Jimbo.FullDeck, PlayerRNG)

        mod.Saved.Jimbo.DeckPointer = 1
        for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do
            mod.Saved.Jimbo.CurrentHand[i] = mod.Saved.Jimbo.DeckPointer
            mod.Saved.Jimbo.DeckPointer = mod.Saved.Jimbo.DeckPointer + 1
        end
    end
end


local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")

--allows to activate/disable selection states easly
function mod:SwitchCardSelectionStates(Player,NewMode,NewPurpose)

    mod.SelectionParams.Frames = 0
    if NewMode == mod.SelectionParams.Modes.NONE then

        for i,v in ipairs(Isaac.FindByType(1000, DescriptionHelperVariant, DescriptionHelperSubType)) do
            v:Remove()
        end

        for i,v in ipairs(mod.SelectionParams.SelectedCards) do
            mod.SelectionParams.SelectedCards[i] = false 
        end
        mod.SelectionParams.Index = 1
        mod.SelectionParams.SelectionNum = 0
        Game:GetRoom():SetPauseTimer(0)

    else
        if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.NONE
           and mod.SelectionParams.Purpose ~= mod.SelectionParams.Purposes.DEATH1 then
            --if changing from an "active" state to another
            mod:UseSelection(Player)
        end
        Game:GetRoom():SetPauseTimer(225)

        Game:Spawn(EntityType.ENTITY_EFFECT, DescriptionHelperVariant, Player.Position
                       ,Vector.Zero, nil, DescriptionHelperSubType, 1)
        
        if NewMode == mod.SelectionParams.Modes.HAND then
            mod.SelectionParams.OptionsNum = mod.Saved.Jimbo.HandSize

            if NewPurpose == mod.SelectionParams.Purposes.HAND then
                mod.SelectionParams.MaxSelectionNum = 5
                mod.SelectionParams.HandType = mod.HandTypes.NONE
                return
            elseif NewPurpose >= mod.SelectionParams.Purposes.DEJA_VU then
                mod.SelectionParams.MaxSelectionNum = 1

            else --various tarot cards
                if NewPurpose == mod.SelectionParams.Purposes.DEATH1 then

                    mod.SelectionParams.MaxSelectionNum = 2

                elseif NewPurpose >= mod.SelectionParams.Purposes.WORLD then --any suit based tarot
                    --WORLD, SUN, MOON, STAR
                    mod.SelectionParams.MaxSelectionNum = 3

                else --any other card
                    local Size = -(NewPurpose % 2) + 2 --se main.lua to understand why this works
                    if Player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
                        Size = Size + 1
                    end
                    mod.SelectionParams.MaxSelectionNum = Size
                end
            end
                
        elseif NewMode == mod.SelectionParams.Modes.PACK then

            if NewPurpose == mod.SelectionParams.Purposes.StandardPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 3
    
            elseif NewPurpose == mod.SelectionParams.Purposes.TarotPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 3

            elseif NewPurpose == mod.SelectionParams.Purposes.CelestialPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 3

            elseif NewPurpose == mod.SelectionParams.Purposes.BuffonPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 2

            elseif NewPurpose == mod.SelectionParams.Purposes.SpectralPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 2
            end

        elseif NewMode == mod.SelectionParams.Modes.INVENTORY then

            mod.SelectionParams.MaxSelectionNum = 2
            mod.SelectionParams.OptionsNum = #mod.Saved.Jimbo.Inventory.Jokers
        end
    end
    mod.SelectionParams.Mode = NewMode
    mod.SelectionParams.Purpose = NewPurpose

end

--handles the single card selection
---@param Player EntityPlayer
function mod:Select(Player)
    mod.Counters.SinceSelect = 0

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then

        --if its an actual option
        if mod.SelectionParams.Index <= mod.Saved.Jimbo.HandSize then
            local Choice = mod.SelectionParams.SelectedCards[mod.SelectionParams.Index]
            
            if Choice then

                sfx:Play(mod.Sounds.DESELECT)

                mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = false                    
                mod.SelectionParams.SelectionNum = mod.SelectionParams.SelectionNum - 1

            --if it's not currently selected and it doesn't surpass the limit
            elseif mod.SelectionParams.SelectionNum < mod.SelectionParams.MaxSelectionNum then   
                
                sfx:Play(mod.Sounds.SELECT)
                --confirm the selection
                mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = true

                mod.SelectionParams.SelectionNum = mod.SelectionParams.SelectionNum + 1

                if mod.SelectionParams.MaxSelectionNum == mod.SelectionParams.SelectionNum then
                    --makes things faster by automatically activating if you chose the maximum number of cards
                    mod:UseSelection(Player)
                    mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
                    return

                elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.DEATH1 then
                    for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                        if v then
                            DeathCopyCard = mod.Saved.Jimbo.CurrentHand[i]
                            break
                        end
                    end
                end 
            end
            if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.HAND then
                --Isaac.RunCallback("HAND_TYPE_UPDATE")
            end

        else--if its the additional confirm button
            --print("confirm")
            mod:UseSelection(Player)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
        end

    elseif mod.SelectionParams.Mode == mod.SelectionParams.Modes.PACK then

        if mod.SelectionParams.Index > mod.SelectionParams.OptionsNum then--skip button
            
            Isaac.RunCallback("PACK_SKIPPED", Player, mod.SelectionParams.Purpose)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
            return
        end

        sfx:Play(mod.Sounds.SELECT)

        if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.StandardPack then
            local SelectedCard = mod.SelectionParams.PackOptions[mod.SelectionParams.Index]
            table.insert(mod.Saved.Jimbo.FullDeck, SelectedCard)

            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, nil, "Added!")
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)

        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.BuffonPack then

            local Joker = mod.SelectionParams.PackOptions[mod.SelectionParams.Index].Joker
            local Edition = mod.SelectionParams.PackOptions[mod.SelectionParams.Index].Edition
            local Index = Level:GetCurrentRoomDesc().ListIndex

            Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET, Player.Position, RandomVector()*3,nil,Joker,Game:GetSeeds():GetStartSeed())
            mod.Saved.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Joker).Name] = Edition
            
            
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)

        else --tarot/planet/Spectral pack
            local card = mod:FrameToSpecialCard(mod.SelectionParams.PackOptions[mod.SelectionParams.Index])
            local RndSeed = Random()
            if RndSeed == 0 then RndSeed = 1 end
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position, RandomVector()* 2, nil, card, RndSeed)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
        end
        
    elseif mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY then

        if  mod.SelectionParams.Index <= #mod.Saved.Jimbo.Inventory.Jokers then --a joker is selected
            
            local Choice = mod.SelectionParams.SelectedCards[mod.SelectionParams.Index]

            if Choice then
                sfx:Play(mod.Sounds.DESELECT)

                mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = false
                mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE

            
            else --if it's not currently selected
            
                if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.SELLING then
                    local FirstI
                    local SecondI = mod.SelectionParams.Index
                    for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                        if v then
                           FirstI = i
                           mod.SelectionParams.SelectedCards[i] = false
                           break
                        end
                    end

                    sfx:Play(mod.Sounds.SELECT)
                    Isaac.CreateTimer(function ()
                        sfx:Play(mod.Sounds.SELECT,1,2,false, 1.2)
                    end, 3, 1, false)

                    mod.Saved.Jimbo.Inventory.Jokers[FirstI],mod.Saved.Jimbo.Inventory.Jokers[SecondI] =
                    mod.Saved.Jimbo.Inventory.Jokers[SecondI],mod.Saved.Jimbo.Inventory.Jokers[FirstI]

                    mod.Saved.Jimbo.Progress.Inventory[FirstI],mod.Saved.Jimbo.Progress.Inventory[SecondI] =
                    mod.Saved.Jimbo.Progress.Inventory[SecondI],mod.Saved.Jimbo.Progress.Inventory[FirstI]

                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                    
                    mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE

                elseif mod.Saved.Jimbo.Inventory.Jokers[mod.SelectionParams.Index] ~= 0 then

                    sfx:Play(mod.Sounds.DESELECT)

                    mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = true
                    mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.SELLING
                    
                end
            end

        else--the confirm button is pressed
            
            if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.SELLING then
                local SoldSlot
                for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                    if v then
                        SoldSlot = i
                       v = false
                       break
                    end
                end
                --print(FirstI)
                local Trinket = mod.Saved.Jimbo.Inventory.Jokers[SoldSlot]

                mod:SellJoker(Player, Trinket, SoldSlot)
                mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE
            else
                mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)
            end
        end
    end
end


local PurposeEnh = {nil,2,4,9,5,3,6,nil,7,8}
--activates the current selection when finished
---@param Player EntityPlayer
function mod:UseSelection(Player)
    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        --could've done something nicer then these elseifs but works anyways
        if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.HAND then
            --effects
            mod:ActivateHandEffect(Player)
            --card substitution
            mod:SubstituteCards(mod.SelectionParams.SelectedCards)

        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.DEATH1 then --then the card that will become a copy
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    local selection = mod.Saved.Jimbo.CurrentHand[i] --gets the card that will be modified
                    mod.Saved.Jimbo.FullDeck[selection] = mod.Saved.Jimbo.FullDeck[DeathCopyCard]
                    Isaac.RunCallback("DECK_SHIFT", Player)
                end
            end
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.HANGED then
            local selection
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    table.insert(selection, mod.Saved.Jimbo.CurrentHand[i]) --gets the card that will be modified
                end
            end
            table.sort(selection, function (a, b) --sorts it so table.remove doesn't move needed values
                if a > b then
                    return true
                end
                return false
            end)
            for _,v in ipairs(selection) do
                table.remove(mod.Saved.Jimbo.FullDeck, v)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.STRENGTH then
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    if mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Value == 13 then
                        mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Value = 1 --kings become aces
                    else
                        mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Value = 
                        mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Value + 1
                    end
                end
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.CRYPTID then
            local Chosen
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    Chosen =mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]]
                    break
                end
            end
            for i=1, 2 do
                table.insert(mod.Saved.Jimbo.FullDeck, Chosen)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.AURA then
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    local EdRoll = Player:GetCardRNG(mod.Spectrals.AURA):RandomFloat()
                    if EdRoll <= 0.5 then
                        sfx:Play(mod.Sounds.FOIL, 0.6)
                        mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Edition = mod.Edition.FOIL
                    elseif EdRoll <= 0.85 then
                        sfx:Play(mod.Sounds.HOLO, 0.6)
                        mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Edition = mod.Edition.HOLOGRAPHIC
                    else
                        sfx:Play(mod.Sounds.POLY, 0.6)
                        mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Edition = mod.Edition.POLYCROME
                    end
                    break
                end
            end
            Isaac.RunCallback("INVENTORY_CHANGE", Player)

        --didn't want to put ~20 more elseifs so did this instead
        elseif mod.SelectionParams.Purpose >= mod.SelectionParams.Purposes.DEJA_VU then
            local NewSeal = mod.SelectionParams.Purpose - 16 --put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Seal = NewSeal --kings become aces
                    sfx:Play(mod.Sounds.SEAL)
                    break
                end
            end
            Isaac.RunCallback("DECK_SHIFT", Player)

        elseif mod.SelectionParams.Purpose >= mod.SelectionParams.Purposes.WORLD then 
            local NewSuit = mod.SelectionParams.Purpose - mod.SelectionParams.Purposes.WORLD + 1--put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Suit = NewSuit
                end
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif mod.SelectionParams.Purpose >= mod.SelectionParams.Purposes.EMPRESS then
            local NewEnh = PurposeEnh[mod.SelectionParams.Purpose] --put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]].Enhancement = NewEnh
                end
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        end
    end
    for i,_ in ipairs(mod.SelectionParams.SelectedCards) do
        mod.SelectionParams.SelectedCards[i] = false
    end
end


------------ TRASH BIN -------------
-----------------------------------
--[[
function mod:ChangeCurrentHandType()
    
    mod.SelectionParams.PossibleHandTypes = mod:DeterminePokerHand()
    mod.SelectionParams.HandType = mod:GetMax(mod.SelectionParams.PossibleHandTypes)
    if mod.SelectionParams.HandType == 10 then
        mod.Saved.Jimbo.FiveUnlocked = true
    elseif mod.SelectionParams.HandType == 11 then
        mod.Saved.Jimbo.FlushHouseUnlocked = true
    elseif mod.SelectionParams.HandType == 12 then
        mod.Saved.Jimbo.FiveFlushUnlocked = true
    end

end
mod:AddCallback("HAND_TYPE_UPDATE", mod.ChangeCurrentHandType)


function mod:ActivateHandEffect(Player)
    Isaac.RunCallback("HAND_TYPE_UPDATE") --updates a last time to be sure

    --print(mod.SelectionParams.HandType)
    --print(mod.Saved.Jimbo.HandsStat[1])
    local StatsToGain = mod.Saved.Jimbo.HandsStat[mod.SelectionParams.HandType]

    
    --local StatsToGain = mod:HandStatCalculatorA(Player)

    --mod:IncreaseJimboStats(Player, StatsToGain.X , StatsToGain.Y)
end

-----------SHADERS----------------
----------------------------------
--man i hate working with shaders... jk i like it now
function mod:PackShader(Name)
    if Name == "Balatro_Pack_Opened" then
        if Game:GetHUD():IsVisible() then
            Game:GetHUD():Render()
            Isaac.RunCallback(ModCallbacks.MC_POST_HUD_RENDER)
        end
        --time is the amount of seconds the player has been choosing for
        local Time = math.min(255, mod.SelectionParams.Frames)
        local BackgroundColor = {200,0,0,1}

        local Params = {Time, BackgroundColor}
        return Params
    end
end
--mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.PackShader)
]]--


