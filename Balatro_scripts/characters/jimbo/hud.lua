local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()
local JidleLength = TrinketSprite:GetAnimationData("Idle"):GetLength()

local InventoryFrame = {0,0,0}

local JimboCards = {PlayingCards = Sprite("gfx/ui/PlayingCards.anm2"),
                    Pack_PlayingCards = Sprite("gfx/ui/PackPlayCards.anm2"),
                    SpecialCards = Sprite("gfx/ui/PackSpecialCards.anm2")}
local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")

local MultCounter = Sprite("gfx/ui/Mult Counter.anm2")
local ChipsCounter = Sprite("gfx/ui/Chips Counter.anm2")
MultCounter:SetFrame("Idle",0)
ChipsCounter:SetFrame("Idle",0)

local DiscardChargeSprite = Sprite("gfx/chargebar.anm2")
local HandChargeSprite = Sprite("gfx/chargebar.anm2")

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

end
local CHARGE_BAR_OFFSET = Vector(17,-30)



local HandsBar = Sprite("gfx/Cards_Bar.anm2")
local HandsBarFilling = Sprite("gfx/Cards_Bar_Filling.anm2")

local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")

local CHARGED_ANIMATION = 11 --the length of an animation for chargebars
local CHARGED_LOOP_ANIMATION = 5

local DECK_RENDERING_POSITION = Vector(110,15) --in screen coordinates
local HAND_RENDERING_POSITION = Vector(40,30) --in screen coordinates
local INVENTORY_RENDERING_POSITION = Vector(10,258)

local INVENTORY_COOP_OFFSET = {[0]=Vector(-10,0), [1]=Vector(0,0)}

--local DECK_RENDERING_POSITION = Isaac.WorldToRenderPosition(Isaac.ScreenToWorld(Vector(760,745)))

local HUD_FRAME = {}
HUD_FRAME.Frame = 0
HUD_FRAME.Dollar = 1
HUD_FRAME.Hand = 2
HUD_FRAME.Confirm = 3
HUD_FRAME.Skip = 4

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10

local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}




--------------HUD RENDER-----------------
-----------------------------------------

local function PreventErrors()
    if not mod.GameStarted then
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, PreventErrors)

--rendered the currently held jokers
---@param Player EntityPlayer
---@param HeartSprite Sprite
function mod:JimboInventoryHUD(offset,HeartSprite,HeartPosition,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local IsCoop = Game:GetNumPlayers() > 1
    local ScaleMult = Vector.One *(IsCoop and 0.5 or 1) --smaller when in coop
    local PIndex = Player:GetData().TruePlayerIndex

    HeartSprite.Offset = PIndex == 1 and Vector(-35,0) or Vector.Zero

    local PlayerRenderMult = 2*(PIndex%2) - 1

    TrinketSprite.Scale = ScaleMult

    local BasePos = INVENTORY_RENDERING_POSITION + Vector(20, -14)*Options.HUDOffset
    if IsCoop then
        BasePos = HeartPosition + INVENTORY_COOP_OFFSET[PIndex%2]

        if PIndex%2 == 1 then --adds heart offset
            BasePos = BasePos + (Game:GetLevel():GetCurses()&LevelCurse.CURSE_OF_THE_UNKNOWN ~= 0 and Vector(15,0) or (math.min(12,Player:GetEffectiveMaxHearts())* Vector(5,0))) * PlayerRenderMult
        
        else --adds offset if player has an active
        
            if Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 then
                BasePos.X = BasePos.X -25
            end
        end
    end
    --print(BasePos)

    for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local RenderPos = BasePos + Vector(23*i , 0) * ScaleMult * PlayerRenderMult
        local JokerConfig = ItemsConfig:GetTrinket(Slot.Joker)

        if Slot.Joker == 0 then

            TrinketSprite:ClearCustomShader()
            TrinketSprite:SetFrame("Empty", 0)
        else

            if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY and
               mod.SelectionParams[PIndex].SelectedCards[i] then
                RenderPos.Y = RenderPos.Y - 9*ScaleMult.Y
            end

            TrinketSprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
            TrinketSprite:ReplaceSpritesheet(2, JokerConfig.GfxFileName, true)

            if mod.Counters.Activated[i] then
                --print(mod.Counters.Activated[i], i)

                TrinketSprite:SetFrame("Effect", mod.Counters.Activated[i])

                if mod.Counters.Activated[i] == JactivateLength then --stops the animation
                    mod.Counters.Activated[i] = nil
                end
            else

                if Isaac.GetFrameCount() % 2 == 0 then
                    InventoryFrame[i] = InventoryFrame[i] and (InventoryFrame[i] + 1 or 0)

                    InventoryFrame[i] = InventoryFrame[i] > JidleLength and 0 or InventoryFrame[i]
                end

                TrinketSprite:SetFrame("Idle", InventoryFrame[i])
                --TrinketSprite:SetAnimation("Idle", false)
            end

            TrinketSprite:SetCustomShader(mod.EditionShaders[mod.Saved.Player[PIndex].Inventory[i].Edition])
            
        end

        TrinketSprite:Render(RenderPos)

        mod.JokerFullPosition[i] = RenderPos
    end

    if Isaac.GetFrameCount()% 2 == 0 then
        TrinketSprite:Update()
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        local RenderPos = mod.JokerFullPosition[mod.SelectionParams[PIndex].Index]

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = ScaleMult
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = BasePos + Vector(23 * (#mod.Saved.Player[PIndex].Inventory + 1), 0) * ScaleMult * PlayerRenderMult
        
        
        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SELLING then
            CardFrame:SetFrame(HUD_FRAME.Dollar)
        else
            CardFrame:SetFrame(HUD_FRAME.Confirm)
        end
        
        CardFrame:Render(RenderPos)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboInventoryHUD)


--renders the deck on top of the screen and the blind progress
---@param Player EntityPlayer
function mod:JimboDeckHUD(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    -------STATS COUNTER RENDERING---------
    
    local ChipsPos = Vector(24,108) + Vector(20, 13)*Options.HUDOffset
    local MultPos = ChipsPos + Vector(0,12)


    --local ChipsPos = Vector(44,122)
    --local MultPos = Vector(44,134)

    ChipsCounter:Render(ChipsPos)
    MultCounter:Render(MultPos)

    local MultString
    local ChipsString

    do
        local Log = math.floor(math.log(mod.Saved.Player[PIndex].TrueTearsValue, 10))

        if Log <= 0 then --ex. 5.00
            ChipsString = tostring(mod:round(mod.Saved.Player[PIndex].TrueTearsValue, 2))

        elseif Log == 1 then --ex. 50.0
            ChipsString = tostring(mod:round(mod.Saved.Player[PIndex].TrueTearsValue, 1))

        elseif Log == 2 then

            ChipsString = tostring(mod:round(mod.Saved.Player[PIndex].TrueTearsValue, 0))

        else
            ChipsString = tostring(mod:round(mod.Saved.Player[PIndex].TrueTearsValue /10^Log, 1)).." e"..tostring(Log)
        end

        Log = math.floor(math.log(mod.Saved.Player[PIndex].TrueDamageValue, 10))

        if Log <= 0 then --ex. 5.05
            MultString = tostring(mod:round(mod.Saved.Player[PIndex].TrueDamageValue, 2))

        elseif Log == 1 then --ex. 50.0
            MultString = tostring(mod:round(mod.Saved.Player[PIndex].TrueDamageValue, 1))

        elseif Log == 2 then --ex. 500

            MultString = tostring(mod:round(mod.Saved.Player[PIndex].TrueDamageValue, 0))

        else
            MultString = tostring(mod:round(mod.Saved.Player[PIndex].TrueDamageValue /10^Log, 1)).." e"..tostring(Log)
        end
    end
   

    mod.Fonts.Balatro:DrawStringScaled(ChipsString, ChipsPos.X-6,ChipsPos.Y-3,0.5,0.5,KColor.White)
    mod.Fonts.Balatro:DrawStringScaled(MultString, MultPos.X-6,MultPos.Y-3,0.5,0.5,KColor.White)





    --------BLIND PROGRESS-----------
    
    if Minimap:GetState() ~= MinimapState.NORMAL or Game:GetLevel():GetStage() == LevelStage.STAGE8 then
        return
    end

    local ScreenWidth = Isaac.GetScreenWidth()
    local RenderPos = Vector(ScreenWidth - 80 ,10) + Vector(-20, 14)*Options.HUDOffset + Minimap:GetShakeOffset()

    local SmallProgress
    local BigProgress
    local BossProgress
    local ProgressString


    ---SMALL BLIND
    local Color = KColor.White
    local DarkColor = KColor(0.7,0.7,0.7,1)

    if not mod.Saved.SmallCleared then
        Color = KColor(238/255, 186/255, 49/255, 1)
        DarkColor = KColor(166/255,130/255,34/255,1)

        SmallProgress = mod.Saved.ClearedRooms
    else
        SmallProgress = mod.Saved.SmallBlind
    end
    ProgressString = tostring(SmallProgress).."/"..tostring(mod.Saved.SmallBlind)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X ,RenderPos.Y, 0.5, 0.5, DarkColor)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X ,RenderPos.Y - 1, 0.5, 0.5, Color)



    --BIG BLIND
    RenderPos.Y = RenderPos.Y + 12
    Color = KColor.White
    DarkColor = KColor(0.7,0.7,0.7,1)

    if mod.Saved.SmallCleared then
    
        if mod.Saved.BigCleared then
            BigProgress = mod.Saved.BigBlind
        else
            Color = KColor(238/255, 186/255, 49/255, 1)
            DarkColor = KColor(166/255,130/255,34/255,1)

            BigProgress = mod.Saved.ClearedRooms
        end
    else
        BigProgress = 0
    end
    ProgressString = tostring(BigProgress).."/"..tostring(mod.Saved.BigBlind)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X, RenderPos.Y, 0.5, 0.5, DarkColor)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X, RenderPos.Y - 1, 0.5, 0.5, Color)        
    


    if not Game:GetLevel():IsAscent() then --ascents don't have any boss blind
        --BOSS BLIND
        RenderPos = RenderPos + Vector(-19,14)
        Color = KColor.White
        DarkColor = KColor(0.7,0.7,0.7,1)

        if mod.Saved.SmallCleared and mod.Saved.BigCleared and mod.Saved.BossCleared ~= 2 then
            Color = KColor(238/255, 186/255, 49/255, 1)
            DarkColor = KColor(166/255,130/255,34/255,1)
        end

        BossProgress = "Not Cleared"
        if mod.Saved.BossCleared == 2 then
            RenderPos.X = RenderPos.X + 13
            BossProgress = "Cleared"
        end

        mod.Fonts.Balatro:DrawStringScaled(BossProgress,
        RenderPos.X ,RenderPos.Y , 0.5, 0.5, DarkColor)  

        mod.Fonts.Balatro:DrawStringScaled(BossProgress,
        RenderPos.X ,RenderPos.Y -1, 0.5, 0.5, Color)        
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboDeckHUD)


function mod:HandBarRender(offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    --print(mod.Saved.Player[PIndex])
    if mod.Saved.Player[PIndex].FirstDeck and not Game:GetRoom():IsClear() then
        --HandsBar:SetFrame("Charge On", Frame)
        HandsBarFilling.Color:SetColorize(0.25,0.51,1,1)
    else
        --HandsBar:SetFrame("Charge Off", Frame)
        HandsBarFilling.Color:SetColorize(1,0,0,1)
    end

    local HandsRemaining = Player:GetCustomCacheValue("hands")
    local PartialHands = nil
    local Offset = Vector(20, 12)*Options.HUDOffset

    while HandsRemaining > 0 do --up to 35 are displayed in 1 bar, then a sencond one appears and so on

        PartialHands = math.min(HandsRemaining, 35.0)
        local FullBarShots =  PartialHands - HandsRemaining + mod.Saved.Player[PIndex].Progress.Room.Shots

        local Animation = HandsBarFilling:GetAnimationData("Charge On_"..tostring(PartialHands))

    ---@diagnostic disable-next-line: need-check-nil
        local Frame = Animation:GetLength() --full bar

        if not mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
    ---@diagnostic disable-next-line: need-check-nil
            Frame = Animation:GetLength() - math.ceil(math.min(FullBarShots/PartialHands, 1)*Animation:GetLength())
        end

        --HandsBar:PlayOverlay("overlay_"..tostring(Player:GetCustomCacheValue("hands")))

    ---@diagnostic disable-next-line: need-check-nil
        HandsBar:SetFrame(Animation:GetName(), 0)
    ---@diagnostic disable-next-line: need-check-nil
        HandsBarFilling:SetFrame(Animation:GetName(), Frame)


        HandsBar:Render(HAND_RENDERING_POSITION + Offset)
        HandsBarFilling:Render(HAND_RENDERING_POSITION + Offset)

        HandsRemaining = HandsRemaining - PartialHands
        Offset = Offset + Vector(0,10)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.HandBarRender)



--rendere the player's current hand below them
local ScaleMult = 0.5
---@param Player EntityPlayer
function mod:JimboHandRender(Player, Offset)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.Saved.Player[1] then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local PlayerScreenPos = Isaac.WorldToRenderPosition(Player.Position)


    local TargetScale = 0.5
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        TargetScale = 1 --while selecting the the cards gets bigger
    end
    if ScaleMult ~= TargetScale then
        --ScaleMult = mod:Lerp(ScaleMult,TargetScale, mod.SelectionParams[PIndex].Frames/100)
        ScaleMult = mod:Lerp(1.5 - TargetScale,TargetScale, mod.SelectionParams[PIndex].Frames/5)
    end

    local BaseRenderOff = Vector(-7 *(#mod.Saved.Player[PIndex].CurrentHand-1), 26 ) * ScaleMult

    local RenderOff = BaseRenderOff + Vector.Zero
    local TrueOffset = {}

    
    for i, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if Card then

            if mod.SelectionParams[PIndex].SelectedCards[i] and mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
                RenderOff.Y = RenderOff.Y -  8
            end
             --moves up selected cards


            mod.LastCardFullPoss[Pointer] = mod.LastCardFullPoss[Pointer] or RenderOff --check nil

            TrueOffset[Pointer] = Vector(mod:Lerp(mod.LastCardFullPoss[Pointer].X, RenderOff.X, mod.Counters.SinceShift/5)
                               ,mod:Lerp(mod.LastCardFullPoss[Pointer].Y, RenderOff.Y, mod.Counters.SinceSelect/1.25))
            

            if TrueOffset[Pointer].X == RenderOff.X and TrueOffset[Pointer].Y == RenderOff.Y then
                mod.LastCardFullPoss[Pointer] = RenderOff + Vector.Zero
            end


            -------------------------------------------------------------

            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)

            JimboCards.PlayingCards.Scale = Vector(ScaleMult,ScaleMult)

            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            JimboCards.PlayingCards:Render(PlayerScreenPos + TrueOffset[Pointer] + Offset)
        end

        RenderOff = Vector(RenderOff.X + 14*ScaleMult, BaseRenderOff.Y)
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        --last confirm option
        RenderOff = BaseRenderOff + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(PlayerScreenPos + RenderOff + Offset)



        RenderOff = BaseRenderOff + Vector(14 * (mod.SelectionParams[PIndex].Index - 1) * ScaleMult, 0)

        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] then
            RenderOff.Y = RenderOff.Y - 8
        end

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(PlayerScreenPos + (TrueOffset[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]] or RenderOff)  + Offset)


        --HAND TYPE TEXT RENDER--
        --mod.Fonts.Balatro:DrawString(HAND_TYPE_NAMES[mod.SelectionParams[PIndex].HandType],DECK_RENDERING_POSITION.X + 50,DECK_RENDERING_POSITION.Y -100,KColor(1,1,1,1))

        --[[allows mouse controls to be used as a way to select cards--
        local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
        if MousePosition.X >= DECK_RENDERING_POSITION.X and MousePosition.Y >= DECK_RENDERING_POSITION.Y  then
            local HandMousePosition = math.ceil((MousePosition.X - (DECK_RENDERING_POSITION.X))/CardHUDWidth)
            if HandMousePosition <= mod.Saved.Player[PIndex].HandSize + 1 then
                mod.SelectionParams[PIndex].Index = HandMousePosition
            end
        end]]

    else
        ------DECK RENDERING----------

        local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

        --shows how many cards are left in the deck
        DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))

        DeckSprite.Scale = Vector.One/2
        --local HeartsOffset = Vector(3.5 * math.min(Player:GetMaxHearts(),12),0)

        --DeckSprite:Render(DECK_RENDERING_POSITION + Vector(20, 14)*Options.HUDOffset + HeartsOffset)
        DeckSprite:Render(PlayerScreenPos + Offset + BaseRenderOff - Vector(9.5,0))



        RenderOff = BaseRenderOff + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand - 1) * ScaleMult, 0)

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(PlayerScreenPos + RenderOff + Offset)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JimboHandRender,PlayerVariant.PLAYER)


--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboPackRender(_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end


    local TruePurpose = mod.SelectionParams[PIndex].Purpose & (~mod.SelectionParams.Purposes.MegaFlag) --removes it for pack checks
    
    local PlayerPos = Isaac.WorldToScreen(Player.Position)

    --base point, increased while rendering 
    local BaseRenderPos = Vector(PlayerPos.X - CardHUDWidth * mod.SelectionParams[PIndex].OptionsNum /2 - PACK_CARD_DISTANCE * (mod.SelectionParams[PIndex].OptionsNum - 1) /2,
                                 PlayerPos.Y + 28)
    BaseRenderPos.X = BaseRenderPos.X + 6.5--makes it centered

    local RenderPos = BaseRenderPos + Vector.Zero
    local WobblyEffect = {}

    if TruePurpose == mod.SelectionParams.Purposes.StandardPack then
        --SHOWS THE CHOICES AVAILABLE

        for i,Card in ipairs(mod.SelectionParams[PIndex].PackOptions) do --for every option

            JimboCards.Pack_PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            JimboCards.Pack_PlayingCards:SetOverlayFrame("Seals", Card.Seal)

            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.Pack_PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            JimboCards.Pack_PlayingCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth
        end--end FOR

    elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        
        for i,card in ipairs(mod.SelectionParams[PIndex].PackOptions) do
    
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)
            TrinketSprite:SetFrame("Idle", 0)

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            TrinketSprite:SetCustomShader(mod.EditionShaders[card.Edition])
            TrinketSprite:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end

    else--TAROT, PLANET or SPECTRAL
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
            if Option == 53 then --equivalent to the soul card
                JimboCards.SpecialCards:SetFrame("Soul Stone",mod.SelectionParams[PIndex].Frames % 47) --sets the frame corresponding to the value and suit
            else
                JimboCards.SpecialCards:SetFrame("idle",  Option)
            end
            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            JimboCards.SpecialCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES

    RenderPos.Y = RenderPos.Y - 8 --adjusts the difference in pivots
    CardFrame.Scale = Vector.One
    CardFrame:SetFrame(HUD_FRAME.Skip)
    CardFrame:Render(RenderPos)

    RenderPos.X = BaseRenderPos.X + (mod.SelectionParams[PIndex].Index - 1)*(PACK_CARD_DISTANCE + CardHUDWidth)
    RenderPos = RenderPos + (WobblyEffect[mod.SelectionParams[PIndex].Index] or Vector.Zero)

    CardFrame:SetFrame(HUD_FRAME.Frame)
    CardFrame:Render(RenderPos)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboPackRender)


local ChargeBarWeaponTypes = WeaponModifier.CHOCOLATE_MILK | WeaponModifier.MONSTROS_LUNG | WeaponModifier.CURSED_EYE | WeaponModifier.NEPTUNUS
--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboBarRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local Weapon = Player:GetWeapon(1)
    local WeaponModifiers = Player:GetWeaponModifiers()

    if Weapon and Weapon:GetWeaponType() == WeaponType.WEAPON_TEARS
       and WeaponModifiers & ChargeBarWeaponTypes == 0 then --renders a timer as a charge bar next to the player

        local Firedelay = Player.MaxFireDelay - (Player.FireDelay + 1) -- the minimum value is -1, but that would fuck up calculations

        local Frame = math.floor(100 * Firedelay/Player.MaxFireDelay)

        HandChargeSprite.Offset = CHARGE_BAR_OFFSET * Player.SpriteScale

        if Frame < 100 then --charging frames needed
            HandChargeSprite:SetFrame("Charging", Frame)

            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            HandChargeSprite:SetFrame(0)

        elseif HandChargeSprite:GetAnimation() ~= "Charged" then
        
            HandChargeSprite:SetAnimation("StartCharged", false)

            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))

            if Game:GetFrameCount()%2 == 0 then
                --HandChargeSprite:Update()
                HandChargeSprite:SetFrame(HandChargeSprite:GetFrame()+1) --for whatever reson Update() doesn't do the job
            end

            if HandChargeSprite:GetFrame() >= CHARGED_ANIMATION then
                HandChargeSprite:SetAnimation("Charged")
            end

        else
            if HandChargeSprite:GetFrame() >= CHARGED_LOOP_ANIMATION then --again Update() is lazy so i loop over ir myself
                HandChargeSprite:SetFrame(0)

            elseif Game:GetFrameCount()%2 == 0 then
                HandChargeSprite:SetFrame(HandChargeSprite:GetFrame()+1)
            end
            
            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
        end
    end

    
    --------------HAND SELECTION COOLDOWN------------------
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then
        return
    end

    local HandFrame = 100 - math.ceil(mod.SelectionParams[PIndex].Frames/2.25)
    
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



function mod:DiscardSwoosh(Player)
    local PIndex = Player:GetData().TruePlayerIndex

    local BaseRenderOff = Vector(-3.5 *(Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)-1), 13 )

    for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

        mod.LastCardFullPoss[v] = BaseRenderOff --does a cool swoosh effect
    end
end


---@param Player EntityPlayer
function mod:DebtIndicator(_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.Saved.Other.HasDebt then
        return
    end

    local Coins = Player:GetNumCoins()
    local RenderPos = Vector(16,33) + Vector(20, 12)*Options.HUDOffset

    local ExtraZeros = 2
    if Coins ~= 0 then
        ExtraZeros = 2 - math.floor(math.log(Coins,10))
    end

    for i=1, ExtraZeros do --puts the needed 0s before the number to fullt cover the original counter
        mod.Fonts.pftempest:DrawString("0",RenderPos.X,RenderPos.Y,KColor.Red)
        RenderPos.X = RenderPos.X + 6
    end

    mod.Fonts.pftempest:DrawString(tostring(Coins),RenderPos.X,RenderPos.Y,KColor.Red)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.DebtIndicator)

