local mod = Balatro_Expansion

local Game = Game()
local sfx = SFXManager()

local JimboCards = {PlayingCards = Sprite("gfx/ui/PlayingCards.anm2"),
                    Pack_PlayingCards = Sprite("gfx/ui/PackPlayCards.anm2"),
                    SpecialCards = Sprite("gfx/ui/PackSpecialCards.anm2")}
local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")
local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local SellChargeSprite = Sprite("gfx/chargebar.anm2")

local MultCounter = Sprite("gfx/ui/Mult Counter.anm2")
local ChipsCounter = Sprite("gfx/ui/Chips Counter.anm2")



local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()
local JidleLength = TrinketSprite:GetAnimationData("Idle"):GetLength()

MultCounter:SetFrame("Idle",0)
ChipsCounter:SetFrame("Idle",0)


local InventoryFrame = {0,0,0,0,0}


local HUD_FRAME = {}
HUD_FRAME.Frame = 0
HUD_FRAME.Dollar = 1
HUD_FRAME.Hand = 2
HUD_FRAME.Confirm = 3
HUD_FRAME.Skip = 4


local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")


local HAND_RENDERING_HEIGHT = 30 --in screen coordinates
local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}

local SCREEN_TO_WORLD_RATIO = 4 --idk why this is needed

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10
--local DECK_RENDERING_POSITION = Vector(110,15) --in screen coordinates
local DECK_RENDERING_POSITION = Vector(450,250) --in screen coordinates
local INVENTORY_RENDERING_HEIGHT = 30
local JOKER_AREA_WIDTH = 125
local CONSUMABLE_CENTER_OFFSET = 200
local CONSUMABLE_AREA_WIDTH = 75
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

local function CancelMinimapHUD()

    Minimap.SetShakeOffset(Vector(200, -100))
    Minimap.SetShakeDuration(2)
    return true
end
mod:AddCallback(ModCallbacks.MC_PRE_MINIMAP_RENDER, CancelMinimapHUD)





--rendere the player's current hand below them
---@param Player EntityPlayer
local function JimboHandRender(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.Saved.Player[0] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumPlayed = #mod.SelectionParams[PIndex].PlayedCards

    local BaseRenderPos = Vector(Isaac.GetScreenWidth()/2 - 7 *(#mod.Saved.Player[PIndex].CurrentHand -1 -NumPlayed),
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

        mod.LastCardFullPoss[Pointer] = mod.LastCardFullPoss[Pointer] or DECK_RENDERING_POSITION --check nil


        --moves up selected cards
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] then
            TargetRenderPos.Y = TargetRenderPos.Y -  8
        end


        if not mod.Saved.EnableHand then --mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

            local TimeOffset = math.max(#mod.Saved.Player[PIndex].CurrentHand, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)) - i*0.75
            local LerpTime = math.max(mod.Counters.SinceSelect/5 - TimeOffset, 0)

            if LerpTime > 0 then
                JimboCards.PlayingCards:SetFrame("Covered", 0)
            else

                JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                --JimboCards.PlayingCards:PlayOverlay("Seals")
                JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
                
                if Card.Edition ~= mod.Edition.BASE then
                    JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
                end
            end


            mod.LastCardFullPoss[Pointer] = BaseRenderPos + Vector(14,0)*(i-1)

            TargetRenderPos = DECK_RENDERING_POSITION + Vector.Zero

            RenderPos[Pointer] = Vector(mod:Lerp(mod.LastCardFullPoss[Pointer].X, TargetRenderPos.X, LerpTime),
                                        mod:Lerp(mod.LastCardFullPoss[Pointer].Y, TargetRenderPos.Y, LerpTime))
            

            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
                sfx:Play(mod.Sounds.SELECT)
            end

        
        else

            RenderPos[Pointer] = Vector(mod:Lerp(mod.LastCardFullPoss[Pointer].X, TargetRenderPos.X, mod.Counters.SinceSelect/4)
                                        ,mod:Lerp(mod.LastCardFullPoss[Pointer].Y, TargetRenderPos.Y, mod.Counters.SinceSelect/1.25))

            if Card.Modifiers & mod.Modifier.COVERED ~= 0 then
                JimboCards.PlayingCards:SetFrame("Covered", 0)
            else

                JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                --JimboCards.PlayingCards:PlayOverlay("Seals")
                JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
                
                if Card.Edition ~= mod.Edition.BASE then
                    JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
                end
            end

            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                --print(Pointer, "assigned")
                mod.LastCardFullPoss[Pointer] = TargetRenderPos  + Vector.Zero
            end

        end
        -------------------------------------------------------------

        JimboCards.PlayingCards.Scale = Vector.One


        JimboCards.PlayingCards:Render(RenderPos[Pointer])


        TargetRenderPos = Vector(TargetRenderPos.X + 14, BaseRenderPos.Y)


        ::SKIP::

    end


    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        TargetRenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1), 0)
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][mod.SelectionParams[PIndex].Index] then --realised just now how big these tables are getting...
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end
        local FramePosition = RenderPos[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]] or TargetRenderPos


        local Card = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]

        if Card then
            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
            
            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            JimboCards.PlayingCards:Render(FramePosition)


            CardFrame.Scale = Vector.One
            CardFrame:SetFrame(HUD_FRAME.Frame)
            CardFrame:Render(FramePosition)
        end

    end

    ------DECK RENDERING----------

    local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

    --shows how many cards are left in the deck
    DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))
    --local HeartsOffset = Vector(3.5 * math.min(Player:GetMaxHearts(),12),0)

    DeckSprite:Render(DECK_RENDERING_POSITION)
    --DeckSprite:Render(PlayerScreenPos + Offset + BaseRenderOff - Vector(9.5,0))
    
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboHandRender)



--rendere the player's current hand below them
local ScaleMult = 1
---@param Player EntityPlayer
local function JimboPlayedHandRender(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.Saved.Player[0] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE 
       or mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.HAND
          and mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.AIMING then 
        --not during scoring animation

        return
    end

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


        JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
        --JimboCards.PlayingCards:PlayOverlay("Seals")
        JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
        
        if Card.Edition ~= mod.Edition.BASE then
            JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
        end

        
        mod.LastCardFullPoss[Pointer] = mod.LastCardFullPoss[Pointer] or DECK_RENDERING_POSITION --check nil

        --print(i, mod.SelectionParams[PIndex].ScoringCards & 2^(i-1) ~= 0)
        if mod.SelectionParams[PIndex].ScoringCards & 2^(i-1) ~= 0 then
            
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end

        local TimeOffset = i

        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AIMING then
            
            TargetRenderPos.X = Isaac.GetScreenWidth() + 50
            TimeOffset = 0
        end


        

        RenderPos[Pointer] = mod:Lerp(mod.LastCardFullPoss[Pointer], TargetRenderPos, mod.Counters.SinceSelect/4 - TimeOffset)
                                        

        if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
            --print(Pointer, "played assigned")
            mod.LastCardFullPoss[Pointer] = TargetRenderPos + Vector.Zero
        end
    
        -------------------------------------------------------------
        JimboCards.PlayingCards:Render(RenderPos[Pointer])
        
        TargetRenderPos = Vector(TargetRenderPos.X + 21, BaseRenderPos.Y)

        ::SKIP::
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        TargetRenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1) * ScaleMult, 0)
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][mod.SelectionParams[PIndex].Index] then --realised just now how big these tables are getting...
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end
        local FramePosition = RenderPos[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]] or TargetRenderPos


        local Card = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]

        if Card then
            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
            
            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            JimboCards.PlayingCards:Render(FramePosition)


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


    local TruePurpose = mod.SelectionParams[PIndex].PackPurpose & (~mod.SelectionParams.Purposes.MegaFlag) --removes it for pack checks
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
        
            JimboCards.Pack_PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            JimboCards.Pack_PlayingCards:SetOverlayFrame("Seals", Card.Seal)

            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.Pack_PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            --JimboCards.Pack_PlayingCards.Scale = Vector.One * mod:Lerp(CardScale[i], TargetScale, mod.Counters.SinceSelect)

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

    else--TAROT or SPECTRAL packs
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
            local TargetScale = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] and 1.25 or 1
            CardScale[i] = CardScale[i] or TargetScale + 0

            if Option == 53 then --equivalent to the soul card
                JimboCards.SpecialCards:SetFrame("Soul Stone",mod.SelectionParams[PIndex].Frames % 47) 
            else
                JimboCards.SpecialCards:SetFrame("idle",  Option)
            end

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)


            local LerpedScale = mod:Lerp(CardScale[i], TargetScale, mod.Counters.SinceSelect/5)

            CardScale[i] = LerpedScale == TargetScale and TargetScale+0 or CardScale[i]

            JimboCards.SpecialCards.Scale = Vector.One * LerpedScale
            JimboCards.SpecialCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams[PIndex].Frames/25))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES

    

    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end

    local Index = mod.SelectionParams[PIndex].Index

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
    local ScaleMult = Vector.One --smaller when in coop
    local PIndex = Player:GetData().TruePlayerIndex

    local NumJokers = 0
    for i, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        
        if Slot.Joker ~= 0 then
            NumJokers = NumJokers + 1
        end
    end
    if NumJokers == 0 then
        return
    end

    --HeartSprite.Offset = PIndex == 1 and Vector(-35,0) or Vector.Zero

    TrinketSprite.Scale = ScaleMult

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
            TargetRenderPos.Y = TargetRenderPos.Y + 6*ScaleMult.Y
        end

        mod.JokerFullPosition[i] = mod.JokerFullPosition[i] or TargetRenderPos

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
        
        local RenderPos = Vector(mod:ExponentLerp(mod.JokerFullPosition[i].X, TargetRenderPos.X, mod.Counters.SinceSelect/10, 0.5),
                                 TargetRenderPos.Y)

        if RenderPos.Y == TargetRenderPos.Y and RenderPos.X == TargetRenderPos.X then
            mod.JokerFullPosition[i] = RenderPos
        end


        TrinketSprite:Render(RenderPos)

        ::SKIP_JOKER::
    end

    if Isaac.GetFrameCount()% 2 == 0 then
        TrinketSprite:Update()
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        local RenderPos = mod.JokerFullPosition[mod.SelectionParams[PIndex].Index] + Vector(0, -8)

        RenderPos.Y = RenderPos.Y + (mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][mod.SelectionParams[PIndex].Index] and 6 or 0)

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = ScaleMult
        CardFrame:Render(RenderPos)

        CardFrame:Render(RenderPos)
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

        JimboCards.SpecialCards:SetFrame("idle", Slot.Card)


        JimboCards.SpecialCards:SetCustomShader(mod.EditionShaders[Slot.Edition])

        local RenderPos = mod:ExponentLerp(mod.ConsumableFullPosition[i], TargetRenderPos, mod.Counters.SinceSelect/10, 0.75)

        if RenderPos.X == TargetRenderPos.X and RenderPos.Y == TargetRenderPos.Y then
            mod.ConsumableFullPosition[i] = RenderPos
        end
        
        JimboCards.SpecialCards.Scale = Vector.One * mod:Lerp(ConsumableScale[i], TargetScale, mod.Counters.SinceSelect/5)

        JimboCards.SpecialCards:Render(RenderPos)

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
    
    if not ShouldRenderStats then

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

    local StatToShow = Vector(0,0)

    if mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack then
        
        StatToShow = mod.Saved.Player[PIndex].HandsStat[mod.SelectionParams[PIndex].HandType]
    else
        StatToShow[mod.Stats.MULT] = mod.Saved.Player[PIndex].MultValue
        StatToShow[mod.Stats.CHIPS] = mod.Saved.Player[PIndex].ChipsValue
    end

    local Log = StatToShow[mod.Stats.CHIPS] == 0 and 2 or math.floor(math.log(StatToShow[mod.Stats.CHIPS], 10)) 

    if Log <= 2 then

        ChipsString = tostring(mod:round(StatToShow[mod.Stats.CHIPS], 2 -Log))

    else
        ChipsString = tostring(mod:round(StatToShow[mod.Stats.CHIPS] /10^Log, 1)).." e"..tostring(Log)
    end


    Log = StatToShow[mod.Stats.MULT] == 0 and 2 or math.floor(math.log(StatToShow[mod.Stats.MULT], 10)) 

    if Log <= 2 then --ex. 500

        MultString = tostring(mod:round(StatToShow[mod.Stats.MULT], 2-Log))

    else
        MultString = tostring(mod:round(StatToShow[mod.Stats.MULT] /10^Log, 1)).." e"..tostring(Log)
    end
   

    mod.Fonts.Balatro:DrawStringScaled(ChipsString, ChipsPos.X-6,ChipsPos.Y-3,0.5,0.5,KColor.White)
    mod.Fonts.Balatro:DrawStringScaled(MultString, MultPos.X-6,MultPos.Y-3,0.5,0.5,KColor.White)


    
     --HAND TYPE TEXT RENDER--
    mod.Fonts.Balatro:DrawString(HAND_TYPE_NAMES[mod.SelectionParams[PIndex].HandType],100,25,KColor(1,1,1,1))



end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboStatsHUD)

