local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local TrinketSprite = Sprite("gfx/005.350_custom.anm2")
local JokerOverlaySprite = Sprite("gfx/Specia_Joker_Overlay.anm2")
JokerOverlaySprite:Play("Idle")
local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()

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
local INVENTORY_RENDERING_POSITION = Vector(5,250)
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

--rendered the currently hald jokers
function mod:JimboInventoryHUD(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local BasePos = INVENTORY_RENDERING_POSITION + Vector(20, -14)*Options.HUDOffset

    for i,Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local RenderPos = BasePos + Vector(23*i , 0)
        local JokerConfig = ItemsConfig:GetTrinket(Slot.Joker)

        if Slot.Joker == 0 then

            TrinketSprite:ClearCustomShader()
            TrinketSprite:SetFrame("Empty", 0)
        else

            if mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY and
               mod.SelectionParams.SelectedCards[i] then
                RenderPos.Y = RenderPos.Y - 9
            end
            TrinketSprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
            if mod.Counters.Activated[i] then
                TrinketSprite:SetFrame("Effect", mod.Counters.Activated[i])

                if mod.Counters.Activated[i] == JactivateLength then --stops the animation
                    mod.Counters.Activated[i] = nil
                end
            else
                TrinketSprite:SetFrame("Idle", 0)
            end

            TrinketSprite:SetCustomShader(mod.EditionShaders[mod.Saved.Jimbo.Inventory[i].Edition])
            
        end

        TrinketSprite:Render(RenderPos)

        if Slot.Joker == mod.Jokers.HOLOGRAM then
            JokerOverlaySprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
            JokerOverlaySprite:Render(RenderPos)
        end
    end

    if Isaac.GetFrameCount()% 2 == 0 then
        JokerOverlaySprite:Update()
    end

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY then
        local RenderPos
        if mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] then
            RenderPos = INVENTORY_RENDERING_POSITION + Vector(23 * mod.SelectionParams.Index, -9)
        else
            RenderPos = INVENTORY_RENDERING_POSITION + Vector(23 * mod.SelectionParams.Index, 0)
        end

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = Vector.One
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = INVENTORY_RENDERING_POSITION + Vector(24 * (mod.Saved.Jimbo.InventorySize + 1), 0)
        
        
        if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.SELLING then
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
        local Log = math.floor(math.log(mod.Saved.Jimbo.TrueTearsValue, 10))

        if Log <= 0 then --ex. 5.00
            ChipsString = tostring(mod:round(mod.Saved.Jimbo.TrueTearsValue, 2))

        elseif Log == 1 then --ex. 50.0
            ChipsString = tostring(mod:round(mod.Saved.Jimbo.TrueTearsValue, 1))

        elseif Log == 2 then

            ChipsString = tostring(mod:round(mod.Saved.Jimbo.TrueTearsValue, 0))

        else
            ChipsString = tostring(mod:round(mod.Saved.Jimbo.TrueTearsValue /10^Log, 1)).." e"..tostring(Log)
        end

        Log = math.floor(math.log(mod.Saved.Jimbo.TrueDamageValue, 10))

        if Log <= 0 then --ex. 5.05
            MultString = tostring(mod:round(mod.Saved.Jimbo.TrueDamageValue, 2))

        elseif Log == 1 then --ex. 50.0
            MultString = tostring(mod:round(mod.Saved.Jimbo.TrueDamageValue, 1))

        elseif Log == 2 then --ex. 500

            MultString = tostring(mod:round(mod.Saved.Jimbo.TrueDamageValue, 0))

        else
            MultString = tostring(mod:round(mod.Saved.Jimbo.TrueDamageValue /10^Log, 1)).." e"..tostring(Log)
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

    if not mod.Saved.Jimbo.SmallCleared then
        Color = KColor(238/255, 186/255, 49/255, 1)
        DarkColor = KColor(166/255,130/255,34/255,1)

        SmallProgress = mod.Saved.Jimbo.ClearedRooms
    else
        SmallProgress = mod.Saved.Jimbo.SmallBlind
    end
    ProgressString = tostring(SmallProgress).."/"..tostring(mod.Saved.Jimbo.SmallBlind)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X ,RenderPos.Y, 0.5, 0.5, DarkColor)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X ,RenderPos.Y - 1, 0.5, 0.5, Color)



    --BIG BLIND
    RenderPos.Y = RenderPos.Y + 12
    Color = KColor.White
    DarkColor = KColor(0.7,0.7,0.7,1)

    if mod.Saved.Jimbo.SmallCleared then
    
        if mod.Saved.Jimbo.BigCleared then
            BigProgress = mod.Saved.Jimbo.BigBlind
        else
            Color = KColor(238/255, 186/255, 49/255, 1)
            DarkColor = KColor(166/255,130/255,34/255,1)

            BigProgress = mod.Saved.Jimbo.ClearedRooms
        end
    else
        BigProgress = 0
    end
    ProgressString = tostring(BigProgress).."/"..tostring(mod.Saved.Jimbo.BigBlind)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X, RenderPos.Y, 0.5, 0.5, DarkColor)

    mod.Fonts.Balatro:DrawStringScaled(ProgressString,
    RenderPos.X, RenderPos.Y - 1, 0.5, 0.5, Color)        
    


    if not Game:GetLevel():IsAscent() then --ascents don't have any boss blind
        --BOSS BLIND
        RenderPos = RenderPos + Vector(-19,14)
        Color = KColor.White
        DarkColor = KColor(0.7,0.7,0.7,1)

        if mod.Saved.Jimbo.SmallCleared and mod.Saved.Jimbo.BigCleared and mod.Saved.Jimbo.BossCleared ~= 2 then
            Color = KColor(238/255, 186/255, 49/255, 1)
            DarkColor = KColor(166/255,130/255,34/255,1)
        end

        BossProgress = "Not Cleared"
        if mod.Saved.Jimbo.BossCleared == 2 then
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

    if mod.Saved.Jimbo.FirstDeck and not Game:GetRoom():IsClear() then
        --HandsBar:SetFrame("Charge On", Frame)
        HandsBarFilling.Color:SetColorize(0.25,0.51,1,1)
    else
        --HandsBar:SetFrame("Charge Off", Frame)
        HandsBarFilling.Color:SetColorize(1,0,0,1)
    end

    local HandsRemaining = Player:GetCustomCacheValue("hands")
    local PartialHands = nil
    local Offset = Vector.Zero

    while HandsRemaining > 0 do --up to 35 are displayed in 1 bar, then a sencond one appears and so on

        PartialHands = math.min(HandsRemaining, 35.0)
        local FullBarShots =  PartialHands - HandsRemaining + mod.Saved.Jimbo.Progress.Room.Shots

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
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PlayerScreenPos = Isaac.WorldToRenderPosition(Player.Position)


    local TargetScale = 0.5
    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        TargetScale = 1 --while selecting the the cards gets bigger
    end
    if ScaleMult ~= TargetScale then
        --ScaleMult = mod:Lerp(ScaleMult,TargetScale, mod.SelectionParams.Frames/100)
        ScaleMult = mod:Lerp(1.5 - TargetScale,TargetScale, mod.SelectionParams.Frames/5)
    end

    local BaseRenderOff = Vector(-7 *(#mod.Saved.Jimbo.CurrentHand-1), 26 ) * ScaleMult

    local RenderOff = BaseRenderOff + Vector.Zero
    local TrueOffset = {}

    
    for i, Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local Card = mod.Saved.Jimbo.FullDeck[Pointer]
        if Card then

            if mod.SelectionParams.SelectedCards[i] and mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
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

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then

        --last confirm option
        RenderOff = BaseRenderOff + Vector(14 * (#mod.Saved.Jimbo.CurrentHand), 0)
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

        --[[allows mouse controls to be used as a way to select cards--
        local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
        if MousePosition.X >= DECK_RENDERING_POSITION.X and MousePosition.Y >= DECK_RENDERING_POSITION.Y  then
            local HandMousePosition = math.ceil((MousePosition.X - (DECK_RENDERING_POSITION.X))/CardHUDWidth)
            if HandMousePosition <= mod.Saved.Jimbo.HandSize + 1 then
                mod.SelectionParams.Index = HandMousePosition
            end
        end]]

    else
        ------DECK RENDERING----------

        local CardsLeft = math.max((#mod.Saved.Jimbo.FullDeck - mod.Saved.Jimbo.DeckPointer)+1, 0)

        --shows how many cards are left in the deck
        DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))

        DeckSprite.Scale = Vector.One/2
        --local HeartsOffset = Vector(3.5 * math.min(Player:GetMaxHearts(),12),0)

        --DeckSprite:Render(DECK_RENDERING_POSITION + Vector(20, 14)*Options.HUDOffset + HeartsOffset)
        DeckSprite:Render(PlayerScreenPos + Offset + BaseRenderOff - Vector(9.5,0))



        RenderOff = BaseRenderOff + Vector(14 * (#mod.Saved.Jimbo.CurrentHand - 1) * ScaleMult, 0)

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(PlayerScreenPos + RenderOff + Offset)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JimboHandRender,PlayerVariant.PLAYER)


--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboPackRender(_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType 
       or mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end
    local TruePurpose = mod.SelectionParams.Purpose & (~mod.SelectionParams.Purposes.MegaFlag) --removes it for pack checks
    
    local PlayerPos = Isaac.WorldToScreen(Player.Position)

    --base point, increased while rendering 
    local BaseRenderPos = Vector(PlayerPos.X - CardHUDWidth * mod.SelectionParams.OptionsNum /2 - PACK_CARD_DISTANCE * (mod.SelectionParams.OptionsNum - 1) /2,
                                 PlayerPos.Y + 20)
    BaseRenderPos.X = BaseRenderPos.X + 6.5--makes it centered

    local RenderPos = BaseRenderPos + Vector.Zero
    local WobblyEffect = {}

    if TruePurpose == mod.SelectionParams.Purposes.StandardPack then
        --SHOWS THE CHOICES AVAILABLE

        for i,Card in ipairs(mod.SelectionParams.PackOptions) do --for every option

            JimboCards.Pack_PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            JimboCards.Pack_PlayingCards:SetOverlayFrame("Seals", Card.Seal)

            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.Pack_PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams.Frames*5+i*95))*1.5)

            JimboCards.Pack_PlayingCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams.Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth
        end--end FOR

    elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        
        for i,card in ipairs(mod.SelectionParams.PackOptions) do
    
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)
            TrinketSprite:SetFrame("Idle", 0)

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams.Frames*5+i*95))*1.5)

            TrinketSprite:SetCustomShader(mod.EditionShaders[card.Edition])
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
            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams.Frames*5+i*95))*1.5)

            JimboCards.SpecialCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams.Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES

    CardFrame.Scale = Vector.One
    CardFrame:SetFrame(HUD_FRAME.Skip)
    CardFrame:Render(RenderPos)

    RenderPos.X = BaseRenderPos.X + (mod.SelectionParams.Index - 1)*(PACK_CARD_DISTANCE + CardHUDWidth)
    RenderPos = RenderPos + (WobblyEffect[mod.SelectionParams.Index] or Vector.Zero)

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



function mod:DiscardSwoosh(Player)

    local BaseRenderOff = Vector(-3.5 *(mod.Saved.Jimbo.HandSize-1), 13 )

    for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do

        mod.LastCardFullPoss[v] = BaseRenderOff --does a cool swoosh effect
        
    end
end


---@param Player EntityPlayer
function mod:DebtIndicator(_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.Saved.Other.HasDebt then
        return
    end

    local Coins = Player:GetNumCoins()
    local RenderPos = Vector(18,34)

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