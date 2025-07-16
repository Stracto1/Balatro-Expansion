local mod = Balatro_Expansion

local Game = Game()
local sfx = SFXManager()

local SpecialCardsSprite = Sprite("gfx/ui/PackSpecialCards.anm2")

local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")
local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local SellChargeSprite = Sprite("gfx/chargebar.anm2")

local MultCounter = Sprite("gfx/ui/Mult Counter.anm2")
local ChipsCounter = Sprite("gfx/ui/Chips Counter.anm2")

local BlindChipsSprite = Sprite("gfx/ui/Blind Chips.anm2")

local SkipTagsSprite = Sprite("gfx/ui/Skip Tags.anm2")

local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()
local JidleLength = TrinketSprite:GetAnimationData("Idle"):GetLength()

local TriggerAnimationLength = 30
local TriggerCounterMult = 180 / TriggerAnimationLength

MultCounter:SetFrame("Idle",0)
ChipsCounter:SetFrame("Idle",0)


local InventoryFrame = {0,0,0,0,0}


local HUD_FRAME = {}
HUD_FRAME.Frame = 0
HUD_FRAME.Dollar = 1
HUD_FRAME.Hand = 2
HUD_FRAME.Confirm = 3
HUD_FRAME.Skip = 4

local CashoutBubbleSprite = Sprite("gfx/ui/cashout_bubble.anm2")
local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")


local HAND_RENDERING_HEIGHT = 30 --in screen coordinates
local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}

local SCREEN_TO_WORLD_RATIO = 4 --idk why this is needed

local BASE_BUBBLE_HEIGHT = 11
local CASHOUT_STRING_X_OFFSET = -39
local BALATRO_LINE_HEIGHT = mod.Fonts.Balatro:GetBaselineHeight()

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10
local DECK_RENDERING_POSITION = Vector(-15,-20) --in screen coordinates
--local DECK_RENDERING_POSITION = Vector(450,250) --in screen coordinates
local INVENTORY_RENDERING_HEIGHT = 30
local JOKER_AREA_WIDTH = 125
local CONSUMABLE_CENTER_OFFSET = 200
local CONSUMABLE_AREA_WIDTH = 75
local CARD_AREA_WIDTH = 175
local CHARGE_BAR_OFFSET = Vector(17,-30)

local ItemsConfig = Isaac.GetItemConfig()

local HAND_TYPE_NAMES = {[mod.HandTypes.NONE] = "None",
                         [mod.HandTypes.HIGH_CARD] = "High Card",
                         [mod.HandTypes.PAIR] = "Pair",
                         [mod.HandTypes.TWO_PAIR] = "Two Pair",
                         [mod.HandTypes.THREE] = "Three of a Kind",
                         [mod.HandTypes.STRAIGHT] = "Striaght",
                         [mod.HandTypes.FLUSH] = "Flush",
                         [mod.HandTypes.FULL_HOUSE] = "Full House",
                         [mod.HandTypes.FOUR] = "Four of a Kind",
                         [mod.HandTypes.STRAIGHT_FLUSH] = "Straight Flush",
                         [mod.HandTypes.ROYAL_FLUSH] = "Royal Flush",
                         [mod.HandTypes.FIVE] = "Five of a Kind",
                         [mod.HandTypes.FLUSH_HOUSE] = "Flush House",
                         [mod.HandTypes.FIVE_FLUSH] = "Flush Five",}



local function CancelActiveHUD(_,Player)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
        return true
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, CallbackPriority.LATE, CancelActiveHUD)



local function CancelHeartsHUD(_,_,_,_,_,Player)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
        return true
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, CallbackPriority.LATE, CancelHeartsHUD)



local function CancelTrinketHUD(_,_,_,_,Player)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then

        return true
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, CallbackPriority.LATE, CancelTrinketHUD)





--puts the map so far away it's basically impossible to see it
local function CancelMinimapHUD()

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        Minimap.SetShakeOffset(Vector(200, -200))
        Minimap.SetShakeDuration(2)
    end
    return true
end
mod:AddCallback(ModCallbacks.MC_PRE_MINIMAP_RENDER, CancelMinimapHUD)

--jimbo travel around with buttons, so no door needed
local function CancelDoorRendering(_, Door)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, CancelDoorRendering)





---@param String string
---@param Position Vector
---@param StartFrame integer
---@param Scale Vector
---@param Kcolor KColor
local function RenderBalatroStyle(String, Position, StartFrame, Scale, Kcolor, Sound)

    local XPos = Position.X + 0
    local FrameCount = (Isaac.GetFrameCount() - StartFrame)/2

    local MaxFrameCount = string.len(String)

    if FrameCount <= MaxFrameCount then
        
        if Sound then
            
            sfx:Play(Sound, 1, 2)
        end
    else
        FrameCount = MaxFrameCount
    end

    for i = 1, FrameCount do
        
        local c = string.sub(String, i,i)

        local WaveOffset = (((Isaac.GetFrameCount() + StartFrame) % 240) // 20 == i % 12) and -0.5 or 0  

        mod.Fonts.Balatro:DrawStringScaled(c,
                                           XPos,
                                           Position.Y + WaveOffset,
                                           Scale.X,
                                           Scale.Y,
                                           Kcolor)

        XPos = XPos + mod.Fonts.Balatro:GetCharacterWidth(c)*Scale.X

    end
    
end


local function BRScreenWithOffset(VectorOffset)

    return Vector(Isaac.GetScreenWidth() + VectorOffset.X, Isaac.GetScreenHeight() + VectorOffset.Y)
end




local function JokerWobbleEffect(OffestVar, VerticalBase)

    return (VerticalBase or 0) + math.sin(math.rad(Isaac.GetFrameCount()*1.75+OffestVar*219)), 

           math.sin(math.rad(Isaac.GetFrameCount()*1.15+OffestVar*137)) * 3

end


--rendere the player's current hand below them
---@param Player EntityPlayer
local function JimboHandRender(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.Saved.Player[1] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumCardsInHand = #mod.Saved.Player[PIndex].CurrentHand

    local CardStep = CARD_AREA_WIDTH / (NumCardsInHand + 1)

    local BaseRenderPos = Vector((Isaac.GetScreenWidth() - CARD_AREA_WIDTH)/2 + CardStep,
                                 Isaac.GetScreenHeight() - HAND_RENDERING_HEIGHT)

    if mod.SelectionParams[PIndex].PackPurpose ~= mod.SelectionParams.Purposes.NONE then
        
        BaseRenderPos.Y = BaseRenderPos.Y - 75
    end

    local TargetRenderPos = BaseRenderPos + Vector.Zero
    local RenderPos = {}

    for i, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

        local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]

        if not Card
           or (mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE 
               and (mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND
                    or mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AIMING)
               and mod:Contained(mod.SelectionParams[PIndex].PlayedCards, Pointer)) then 

            --print(Pointer, "skipped")
            goto SKIP
        end

        local Rotation
        local Scale
        local ForceCovered = Game:IsPaused()
        local ValueOffset
        local IsThin


        mod.LastCardFullPoss[Pointer] = mod.LastCardFullPoss[Pointer] or BRScreenWithOffset(DECK_RENDERING_POSITION) --check nil


        --moves up selected cards
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] then
            TargetRenderPos.Y = TargetRenderPos.Y -  8
        end


        if not mod.Saved.EnableHand then --mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

            local TimeOffset = math.max(NumCardsInHand, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)) - i*0.75
            local LerpTime = math.max(mod.Counters.SinceSelect/5 - TimeOffset, 0)

            if LerpTime > 0 or Card.Modifiers & mod.Modifier.COVERED ~= 0 then
                ForceCovered = true
            end

            mod.LastCardFullPoss[Pointer] = BaseRenderPos + Vector(CardStep,0)*(i-1)

            TargetRenderPos = BRScreenWithOffset(DECK_RENDERING_POSITION)

            RenderPos[Pointer] = mod:VectorLerp(mod.LastCardFullPoss[Pointer], TargetRenderPos, LerpTime)
            

            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
                sfx:Play(mod.Sounds.SELECT)
            end

        else

            RenderPos[Pointer] = Vector(mod:Lerp(mod.LastCardFullPoss[Pointer].X, TargetRenderPos.X, mod.Counters.SinceSelect/4)
                                        ,mod:Lerp(mod.LastCardFullPoss[Pointer].Y, TargetRenderPos.Y, mod.Counters.SinceSelect/1.25))


            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                --print(Pointer, "assigned")
                mod.LastCardFullPoss[Pointer] = TargetRenderPos  + Vector.Zero
            end

             --[[                        
            if Card.Modifiers & mod.Modifier.COVERED ~= 0 or Game:IsPaused() then
                JimboCards.PlayingCards:SetFrame("Covered", 0)
            else

                JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                --JimboCards.PlayingCards:PlayOverlay("Seals")
                JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
                
                if Card.Edition ~= mod.Edition.BASE then
                    JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
                end
            end]]

            
        end
        -------------------------------------------------------------
        
        local CardTriggerCounter = (mod.Counters.SinceCardTriggered[Pointer] or 0) * TriggerCounterMult

        Scale = Vector.One * (1 + math.min(0.8, 2.5*(1 - math.abs(math.cos(math.rad(CardTriggerCounter)))^0.5)))

        if CardTriggerCounter >= TriggerAnimationLength then
            mod.Counters.SinceCardTriggered[Pointer] = nil
        end


        Rotation = 10 * math.sin(math.rad(180*(RenderPos[Pointer].X-mod.LastCardFullPoss[Pointer].X)/math.max(1,TargetRenderPos.X-mod.LastCardFullPoss[Pointer].X)))

        if mod.LastCardFullPoss[Pointer].X > TargetRenderPos.X then
            Rotation = -Rotation
        end

        RenderPos[Pointer].Y = RenderPos[Pointer].Y + math.sin(math.rad(Isaac.GetFrameCount()*1.75+i*22))


        mod:RenderCard(Card, RenderPos[Pointer], ValueOffset, Scale, Rotation, ForceCovered, IsThin)

        --JimboCards.PlayingCards:Render(RenderPos[Pointer])


        TargetRenderPos = Vector(TargetRenderPos.X + CardStep, BaseRenderPos.Y)


        ::SKIP::

    end


    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND
       and not mod.AnimationIsPlaying then

        TargetRenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1), 0)
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][mod.SelectionParams[PIndex].Index] then --realised just now how big these tables are getting...
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end
        local FramePosition = RenderPos[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]] or TargetRenderPos


        local Card = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]

        if Card then


            local Rotation = 0
            local Scale = Vector.One * 1.1
            local ForceCovered = Card.Modifiers & mod.Modifier.COVERED ~= 0 or Game:IsPaused()
            local ValueOffset = Vector.Zero
            local IsThin = false

            mod:RenderCard(Card, FramePosition, ValueOffset, Scale, Rotation, ForceCovered, IsThin)


            CardFrame.Scale = Vector.One * 1.1
            CardFrame:SetFrame(HUD_FRAME.Frame)
            CardFrame:Render(FramePosition)
        end

    end

    ------DECK RENDERING----------

    local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

    --shows how many cards are left in the deck
    DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))
    --local HeartsOffset = Vector(3.5 * math.min(Player:GetMaxHearts(),12),0)

    DeckSprite:Render(BRScreenWithOffset(DECK_RENDERING_POSITION))
    --DeckSprite:Render(PlayerScreenPos + Offset + BaseRenderOff - Vector(9.5,0))
    
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboHandRender)



--rendere the player's current hand below them
local ScaleMult = 1
---@param Player EntityPlayer
local function JimboPlayedHandRender(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.Saved.Player[1] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE 
       or mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.HAND
          and mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.AIMING then 
        --not during scoring animation

        return
    end

    local IsDuringScoring = mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE 
                            and mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND

    local NumPlayed = #mod.SelectionParams[PIndex].PlayedCards

    local BaseRenderPos = Vector((Isaac.GetScreenWidth() -21*(NumPlayed - 1)), 
                          Isaac.GetScreenHeight())/2


    local TargetRenderPos = BaseRenderPos + Vector.Zero
    local RenderPos = {}

    for i, Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do
        local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]

        if not Card then
            goto SKIP
        end
        
        local Rotation
        local Scale
        local ForceCovered = false
        local ValueOffset = Vector.Zero
        local IsThin = false

        
        mod.LastCardFullPoss[Pointer] = mod.LastCardFullPoss[Pointer] or BRScreenWithOffset(DECK_RENDERING_POSITION) --check nil

        --print(i, mod.SelectionParams[PIndex].ScoringCards & 2^(i-1) ~= 0)
        if mod.SelectionParams[PIndex].ScoringCards & 2^(i-1) ~= 0 then
            
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end

        local TimeOffset = i

        if not IsDuringScoring then
            
            TargetRenderPos.X = Isaac.GetScreenWidth() + 50
            TimeOffset = 0
        end


        local CardTriggerCounter = (mod.Counters.SinceCardTriggered[Pointer] or 0) * TriggerCounterMult

        Scale = Vector.One * (1 + math.min(0.8, 2.5*(1 - math.abs(math.cos(math.rad(CardTriggerCounter)))^0.5)))

        if CardTriggerCounter >= TriggerAnimationLength then
            mod.Counters.SinceCardTriggered[Pointer] = nil
        end

        RenderPos[Pointer] = mod:Lerp(mod.LastCardFullPoss[Pointer], TargetRenderPos, mod.Counters.SinceSelect/4 - TimeOffset)
                                        

        if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
            --print(Pointer, "played assigned")
            mod.LastCardFullPoss[Pointer] = TargetRenderPos + Vector.Zero
        end

        Rotation = 10 * math.sin(math.rad(180*(RenderPos[Pointer].X-mod.LastCardFullPoss[Pointer].X)/math.max(1,TargetRenderPos.X-mod.LastCardFullPoss[Pointer].X)))

        if mod.LastCardFullPoss[Pointer].X > TargetRenderPos.X then
            Rotation = -Rotation
        end
    
        -------------------------------------------------------------

        mod:RenderCard(Card, RenderPos[Pointer], ValueOffset, Scale, Rotation, ForceCovered, IsThin)
        
        TargetRenderPos = Vector(TargetRenderPos.X + 21, BaseRenderPos.Y)

        ::SKIP::
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        local Rotation = 0
        local Scale = Vector.One
        local ForceCovered = false
        local ValueOffset = Vector.Zero
        local IsThin = false

        TargetRenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1) * ScaleMult, 0)
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][mod.SelectionParams[PIndex].Index] then --realised just now how big these tables are getting...
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end

        local FramePosition = RenderPos[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]] or TargetRenderPos


        local Card = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]

        if Card then

            mod:RenderCard(Card, FramePosition, ValueOffset, Scale, Rotation, ForceCovered, IsThin)


            CardFrame.Scale = Vector(ScaleMult, ScaleMult)
            CardFrame:SetFrame(HUD_FRAME.Frame)
            CardFrame:Render(FramePosition)
        end

    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboPlayedHandRender)



local CardScale = {}
--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
local function JimboPackRender(_,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.NONE then
        CardScale = {}
        return
    end


    local TruePurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag --removes it for pack checks
    local PlayerPos = Isaac.WorldToScreen(Player.Position)

    local NumOptions = #mod.SelectionParams[PIndex].PackOptions

    --base point, increased while rendering 
    local BaseRenderPos = Vector(Isaac.GetScreenWidth() - CardHUDWidth * NumOptions - PACK_CARD_DISTANCE * (NumOptions - 1),
                                 Isaac.GetScreenHeight() - HAND_RENDERING_HEIGHT - 30)

    BaseRenderPos.X = BaseRenderPos.X/2 --centers the cards

    BaseRenderPos.X = BaseRenderPos.X + 6.5--makes it centered

    local RenderPos = BaseRenderPos + Vector.Zero
    local WobblyEffect = {}

    if TruePurpose == mod.SelectionParams.Purposes.StandardPack then
        --SHOWS THE CHOICES AVAILABLE

        for i,Card in ipairs(mod.SelectionParams[PIndex].PackOptions) do --for every option
        
            local Rotation = 0
            local Scale = Vector.One
            local ForceCovered = Game:IsPaused()
            local ValueOffset = Vector.Zero
            local IsThin = false

            --JimboCards.Pack_PlayingCards.Scale = Vector.One * mod:Lerp(CardScale[i], TargetScale, mod.Counters.SinceSelect)

            CardScale[i] = 1
            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            local RenderPos = mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10)

            mod:RenderCard(Card, RenderPos, ValueOffset, Scale, Rotation, ForceCovered, IsThin)


            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth
        end--end FOR

    elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        
        for i,card in ipairs(mod.SelectionParams[PIndex].PackOptions) do
    
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)
            TrinketSprite:SetFrame("Idle", 0)

            CardScale[i] = 1
            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            TrinketSprite:SetCustomShader(mod.EditionShaders[card.Edition])
            TrinketSprite:Render(mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end

    else--TAROT or SPECTRAL packs
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
            local TargetScale = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] and 1.25 or 1
            CardScale[i] = CardScale[i] or TargetScale + 0

            if Option == 53 then --equivalent to the soul card
                SpecialCardsSprite:SetFrame("Soul Stone",mod.SelectionParams[PIndex].Frames % 47) 
            else
                SpecialCardsSprite:SetFrame("idle",  Option)
            end

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)


            local LerpedScale = mod:Lerp(CardScale[i], TargetScale, mod.Counters.SinceSelect/5)

            CardScale[i] = LerpedScale == TargetScale and TargetScale+0 or CardScale[i]

            SpecialCardsSprite.Scale = Vector.One * LerpedScale
            SpecialCardsSprite:Render(mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams[PIndex].Frames/25))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES


    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end

    local Index = mod.SelectionParams[PIndex].Index

    CardScale[Index] = CardScale[Index] or 1

    --renders the frame on the selected card
    RenderPos.X = BaseRenderPos.X + (Index - 1)*(PACK_CARD_DISTANCE + CardHUDWidth)
    RenderPos.Y = RenderPos.Y - 8 * CardScale[Index] --fises the pivot displacement

    RenderPos = RenderPos + (WobblyEffect[Index] or Vector.Zero)
    CardFrame.Scale = Vector.One * CardScale[Index]

    CardFrame:SetFrame(HUD_FRAME.Frame)
    CardFrame:Render(RenderPos)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboPackRender)


--rendered the currently held jokers
---@param Player EntityPlayer
local function JimboInventoryHUD(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    --local IsCoop = Game:GetNumPlayers() > 1
    local PIndex = Player:GetData().TruePlayerIndex

    local NumJokers = 0
    for _, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        
        if Slot.Joker ~= 0 then
            NumJokers = NumJokers + 1
        end
    end
    if NumJokers == 0 then
        return
    end

    local RenderPos = {}


    local JokerStep = JOKER_AREA_WIDTH / (NumJokers + 1)

    local BasePos = Vector((Isaac.GetScreenWidth() - JOKER_AREA_WIDTH)/2, 
                                    INVENTORY_RENDERING_HEIGHT) + Vector(0, -14)*Options.HUDOffset

    local TargetRenderPos = BasePos + Vector.Zero

    --print(BasePos)

    for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        --print(Slot.Joker)
        if Slot.Joker == 0 then

            goto SKIP_JOKER
        end

        TargetRenderPos.X = TargetRenderPos.X + JokerStep
        TargetRenderPos.Y = BasePos.Y

        
        local JokerConfig = ItemsConfig:GetTrinket(Slot.Joker)

        if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY and
           mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][i] then
            TargetRenderPos.Y = TargetRenderPos.Y + 6
        end

        mod.JokerFullPosition[Slot.RenderIndex] = mod.JokerFullPosition[Slot.RenderIndex] or TargetRenderPos

        TrinketSprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
        TrinketSprite:ReplaceSpritesheet(2, JokerConfig.GfxFileName, true)


        if Isaac.GetFrameCount() % 2 == 0 then
            InventoryFrame[i] = InventoryFrame[i] and (InventoryFrame[i] + 1 or 0)

            InventoryFrame[i] = InventoryFrame[i] > JidleLength and 0 or InventoryFrame[i]
        end


        local CardTriggerCounter = (mod.Counters.Activated[i] or 0) * TriggerCounterMult

        TrinketSprite.Scale = Vector.One * (1 + math.min(0.8, 2.5*(1 - math.abs(math.cos(math.rad(CardTriggerCounter)))^0.5)))

        if CardTriggerCounter >= TriggerAnimationLength then
            mod.Counters.Activated[i] = nil
        end
        

        TrinketSprite:SetFrame("Idle", InventoryFrame[i])
        --TrinketSprite:SetAnimation("Idle", false)
        

        TrinketSprite:SetCustomShader(mod.EditionShaders[mod.Saved.Player[PIndex].Inventory[i].Edition])
        
        RenderPos[Slot.RenderIndex] = Vector(mod:ExponentLerp(mod.JokerFullPosition[Slot.RenderIndex].X, TargetRenderPos.X, mod.Counters.SinceSelect/8, 0.5),
                                 TargetRenderPos.Y)

        if RenderPos[Slot.RenderIndex].Y == TargetRenderPos.Y and RenderPos[Slot.RenderIndex].X == TargetRenderPos.X then
            mod.JokerFullPosition[Slot.RenderIndex] = RenderPos[Slot.RenderIndex]
        end

        ----WOBBLE--------
        
        RenderPos[Slot.RenderIndex].Y, TrinketSprite.Rotation = JokerWobbleEffect(i, RenderPos[Slot.RenderIndex].Y)
        -------------------
        
        TrinketSprite:Render(RenderPos[Slot.RenderIndex])

        ::SKIP_JOKER::
    end

    if Isaac.GetFrameCount()% 2 == 0 then
        TrinketSprite:Update()
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        local Slot = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index]

        local FrameRenderPos = RenderPos[Slot.RenderIndex] + Vector(0.5, -8)

        FrameRenderPos.Y = FrameRenderPos.Y + (mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][mod.SelectionParams[PIndex].Index] and 6 or 0)

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = Vector.One

        CardFrame:Render(FrameRenderPos)
        --CardFrame:Render(FrameRenderPos)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboInventoryHUD)


local ConsumableScale = {}
---@param Player EntityPlayer
local function JimboConsumableRender(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    --local IsCoop = Game:GetNumPlayers() > 1
    local PIndex = Player:GetData().TruePlayerIndex

    local NumCards = 0
    for i, Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do
        
        if Slot.Card ~= -1 then
            NumCards = NumCards + 1
        end
    end
    if NumCards == 0 then
        return
    end


    local CardStep = CONSUMABLE_AREA_WIDTH / (NumCards + 1)

    local BasePos = Vector((Isaac.GetScreenWidth() + CONSUMABLE_AREA_WIDTH)/2 + CONSUMABLE_CENTER_OFFSET, 
                                    INVENTORY_RENDERING_HEIGHT) + Vector(0, 14)*Options.HUDOffset

    local TargetRenderPos = BasePos + Vector.Zero

    --print(BasePos)

    for i,Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do

        --print(Slot.Joker)
        if Slot.Card == -1 then

            goto SKIP_CARD
        end


        local TargetScale = i == #mod.Saved.Player[PIndex].Consumables and 1.25 or 1
        ConsumableScale[i] = ConsumableScale[i] or TargetScale + 0

        TargetRenderPos.X = TargetRenderPos.X - CardStep
        TargetRenderPos.Y = BasePos.Y


        mod.ConsumableFullPosition[i] = mod.ConsumableFullPosition[i] or TargetRenderPos

        SpecialCardsSprite:SetFrame("idle", Slot.Card)


        SpecialCardsSprite:SetCustomShader(mod.EditionShaders[Slot.Edition])

        local RenderPos = mod:ExponentLerp(mod.ConsumableFullPosition[i], TargetRenderPos, mod.Counters.SinceSelect/10, 0.75)

        if RenderPos.X == TargetRenderPos.X and RenderPos.Y == TargetRenderPos.Y then
            mod.ConsumableFullPosition[i] = RenderPos
        end
        
        SpecialCardsSprite.Scale = Vector.One * mod:Lerp(ConsumableScale[i], TargetScale, mod.Counters.SinceSelect/5)

        SpecialCardsSprite:Render(RenderPos)

        ::SKIP_CARD::
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboConsumableRender)



---@param Player EntityPlayer
local function JimboChargeBarRender(_,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local Data = Player:GetData()

    if Data.ALThold ~= 0 then
        
        SellChargeSprite.Offset = CHARGE_BAR_OFFSET * Player.SpriteScale

        local Frame = math.ceil(Data.ALThold * 1.33)

        SellChargeSprite:SetFrame("Charging", Frame)

        SellChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboChargeBarRender)



--renders the deck on top of the screen and the blind progress
---@param Player EntityPlayer
local function JimboStatsHUD(_,offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex


    local ShouldRenderStats = mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND and mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.NONE
                              or mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE and (mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND or mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AIMING)
                              or mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack
    

    -------STATS COUNTER RENDERING---------
    
    local ChipsPos = Vector(24,108) + Vector(20, 13)*Options.HUDOffset
    local MultPos = ChipsPos + Vector(0,12)


    --local ChipsPos = Vector(44,122)
    --local MultPos = Vector(44,134)

    ChipsCounter:Render(ChipsPos)
    MultCounter:Render(MultPos)

    local MultString
    local ChipsString

    local StatToShow = {}

    if not ShouldRenderStats then
        StatToShow = {Mult = 0, Chips = 0}

    elseif mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack then
        
        StatToShow = mod.Saved.Player[PIndex].HandsStat[mod.SelectionParams[PIndex].HandType]
    else
        StatToShow.Mult = mod.Saved.MultValue
        StatToShow.Chips = mod.Saved.ChipsValue
    end

    local Log

    --in certain cases the value is a string (planet upgrade animations mostly)
    if tonumber(StatToShow.Mult) == "fail" then 
        goto RENDER
    end

    Log = StatToShow.Chips == 0 and 2 or math.floor(math.log(StatToShow.Chips, 10)) 

    if Log <= 2 then

        ChipsString = tostring(mod:round(StatToShow.Chips, 2 - Log))

    else
        ChipsString = tostring(mod:round(StatToShow.Chips /10^Log, 1)).." e"..tostring(Log)
    end


    Log = StatToShow.Mult == 0 and 2 or math.floor(math.log(StatToShow.Mult, 10)) 

    if Log <= 2 then --ex. 500

        MultString = tostring(mod:round(StatToShow.Mult, 2-Log))

    else
        MultString = tostring(mod:round(StatToShow.Mult /10^Log, 1)).." e"..tostring(Log)
    end
   
    ::RENDER::

    mod.Fonts.Balatro:DrawStringScaled(ChipsString, ChipsPos.X-6,ChipsPos.Y-3,0.5,0.5,KColor.White)
    mod.Fonts.Balatro:DrawStringScaled(MultString, MultPos.X-6,MultPos.Y-3,0.5,0.5,KColor.White)


    
     --HAND TYPE TEXT RENDER--
    mod.Fonts.Balatro:DrawString(HAND_TYPE_NAMES[mod.SelectionParams[PIndex].HandType],100,25,KColor(1,1,1,1))

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboStatsHUD)



local function SkipTagsHUD(_,offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local RenderPos = BRScreenWithOffset(DECK_RENDERING_POSITION)
    RenderPos.Y = RenderPos.Y - 15

    for i, Tag in ipairs(mod.Saved.SkipTags) do

        RenderPos.Y = RenderPos.Y - 14

        local Frame

        if Tag & mod.SkipTags.ORBITAL ~= 0 then
            Frame = 23
        else
            Frame = Tag
        end

        SkipTagsSprite:SetFrame("Tags", Frame)
        SkipTagsSprite:Render(RenderPos)

    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, SkipTagsHUD)




---@param Effect EntityEffect
local function CashoutBubbleRender(_,Effect, Offset)

    if Effect.SubType ~= mod.DIalogBubbleSubType.CASHOUT then
        return
    end

    local NumStrings = #mod.ScreenStrings.CashOut

    if NumStrings <= 0 then
        return
    end

    local PlatePos = Isaac.WorldToScreen(Effect.Position)
    PlatePos.Y = PlatePos.Y + 2.5 * math.sin(Isaac.GetFrameCount()/20)


    CashoutBubbleSprite:SetFrame("Bottom", 0)
    CashoutBubbleSprite.Scale = Vector.One
    CashoutBubbleSprite.Offset = Vector.Zero
    CashoutBubbleSprite:Render(PlatePos)

    local MiddleScale = 1 + math.min(NumStrings, 5) --maximum of 6 strings at a time

    local TopPos = PlatePos - Vector(0, BASE_BUBBLE_HEIGHT * MiddleScale)

    CashoutBubbleSprite:SetFrame("Top", 0)
    CashoutBubbleSprite:Render(TopPos)

    CashoutBubbleSprite:SetFrame("Middle", 0)
    CashoutBubbleSprite.Scale = Vector(1, MiddleScale)
    CashoutBubbleSprite.Offset = Vector(0, 36*(MiddleScale-1))
    CashoutBubbleSprite:Render(PlatePos)
    
    local CurrentStringOffset = Vector(CASHOUT_STRING_X_OFFSET + 8, -31) --Vector(CASHOUT_STRING_X_OFFSET + 5, -36*(MiddleScale-3) - 10)

    -------BLIND CLEAR-----------

    local BlindString = mod.ScreenStrings.CashOut[1]

    if BlindString then

        BlindChipsSprite:SetFrame("Chips", BlindString.Type & mod.BLINDS.BOSS ~= 0 and (BlindString.Type+4)/8 or BlindString.Type - 1)
        BlindChipsSprite:Render(TopPos + CurrentStringOffset)

        CurrentStringOffset.X = CurrentStringOffset.X + 11

        RenderBalatroStyle(BlindString.Name, TopPos + CurrentStringOffset, BlindString.StartFrame, Vector.One*0.5, KColor.White)


        CurrentStringOffset.X = -CASHOUT_STRING_X_OFFSET - mod.Fonts.Balatro:GetStringWidth(BlindString.String)

        CurrentStringOffset.Y = CurrentStringOffset.Y - BALATRO_LINE_HEIGHT/4

        RenderBalatroStyle(BlindString.String, TopPos + CurrentStringOffset, BlindString.StartFrame + string.len(BlindString.Name)*2 + 40, Vector.One, mod.EffectKColors.YELLOW)

        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_LINE_HEIGHT
    end
    --------DIVIDER----------

    local DivideString = mod.ScreenStrings.CashOut[2]

    if DivideString then
        CurrentStringOffset.X = CASHOUT_STRING_X_OFFSET

        RenderBalatroStyle(DivideString.Name, TopPos + CurrentStringOffset, DivideString.StartFrame, Vector.One*0.5, KColor.White)

        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_LINE_HEIGHT
    end
    ----------------------------
    ---------------------------

    for i = math.max(3, NumStrings - 2), NumStrings do
        
        ScreenString = mod.ScreenStrings.CashOut[i]

        local Color

        if ScreenString.Type == mod.StringTypes.Hand then

            Color = mod.EffectKColors.BLUE

        elseif ScreenString.Type == mod.StringTypes.Interest 
               or ScreenString.Type == mod.StringTypes.Joker then

            Color = mod.EffectKColors.YELLOW

        else
            Color = KColor.White
        end



        CurrentStringOffset.X = CASHOUT_STRING_X_OFFSET

        RenderBalatroStyle(ScreenString.Name, TopPos + CurrentStringOffset, ScreenString.StartFrame, Vector.One*0.5, Color)

        ---MONEY AMOUNT

        Color = mod.EffectKColors.YELLOW

        CurrentStringOffset.X = -CASHOUT_STRING_X_OFFSET - mod.Fonts.Balatro:GetStringWidth(ScreenString.String) --+ DollarWidth

        CurrentStringOffset.Y = CurrentStringOffset.Y - BALATRO_LINE_HEIGHT/4

        RenderBalatroStyle(ScreenString.String, TopPos + CurrentStringOffset, ScreenString.StartFrame + string.len(ScreenString.Name)*2 + 40, Vector.One, Color)
    
        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_LINE_HEIGHT*1.75
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, CashoutBubbleRender, mod.Effects.DIALOG_BUBBLE)



---@param Pickup EntityPickup
local function CustomPickupSprites(_, Pickup)

    if Game:GetRoom():GetType() ~= RoomType.ROOM_SHOP then
        Pickup:Remove()
        return
    end

    if Pickup.Variant ~= PickupVariant.PICKUP_TAROTCARD then
        return
    end


    if mod:Contained(mod.Packs, Pickup.SubType) then

        local PackSprite = Pickup:GetSprite()
        
        PackSprite:Load("gfx/ui/Booster Packs.anm2")

        local PackAnimation = ItemsConfig:GetCard(Pickup.SubType).Name

        --print(".."..PackAnimation.."..")

        PackSprite:SetFrame(PackAnimation, math.random(PackSprite:GetAnimationData(PackAnimation):GetLength()) - 1)

    else

        local CardSprite = Pickup:GetSprite()
        
        CardSprite:Load("gfx/ui/PackSpecialCards.anm2")

        SpecialCardsSprite:SetFrame("idle",  mod:SpecialCardToFrame(Pickup.SubType))

    end
    --Pickup.SpriteOffset.Y = -8
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, CustomPickupSprites)


---@param Pickup EntityPickup
local function PickupWobble(_, Pickup, Offset)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local BaseOffset = Pickup.Variant == PickupVariant.PICKUP_TAROTCARD and -16 or -8
    
    Pickup.SpriteOffset.Y, Pickup.SpriteRotation = JokerWobbleEffect(Pickup.InitSeed % 20, BaseOffset)

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, PickupWobble)

