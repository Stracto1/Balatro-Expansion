local mod = Balatro_Expansion

local JimboCards = {PlayingCards = Sprite("gfx/ui/PlayingCards.anm2"),
                    Pack_PlayingCards = Sprite("gfx/ui/PackPlayCards.anm2"),
                    SpecialCards = Sprite("gfx/ui/PackSpecialCards.anm2")}
local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")


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

local SCREEN_TO_WORLD_RATIO = 4

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10
local DECK_RENDERING_POSITION = Vector(110,15) --in screen coordinates

local ItemsConfig = Isaac.GetItemConfig()



--rendere the player's current hand below them
local ScaleMult = 1
---@param Player EntityPlayer
local function JimboHandRender(_,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.Saved.Player[0] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local PlayerScreenPos = Isaac.WorldToRenderPosition(Player.Position)


    local TargetScale = 1
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        TargetScale = 1 --while selecting the the cards gets bigger
    end
    if ScaleMult ~= TargetScale then
        --ScaleMult = mod:Lerp(ScaleMult,TargetScale, mod.SelectionParams[PIndex].Frames/100)
        ScaleMult = mod:Lerp(1.5 - TargetScale,TargetScale, mod.SelectionParams[PIndex].Frames/5)
    end

    local BaseRenderPos = Vector(Isaac.GetScreenWidth()/2 - 7 *(#mod.Saved.Player[PIndex].CurrentHand-1),
                                 Isaac.GetScreenHeight() - HAND_RENDERING_HEIGHT) * ScaleMult

    if #mod.SelectionParams[PIndex].PackOptions > 0 then
        
        BaseRenderPos.Y = BaseRenderPos.Y - 75
    end

    local TargetRenderPos = BaseRenderPos + Vector.Zero
    local RenderPos = {}

    
    for i, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if Card then

            --moves up selected cards
            if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] then
                TargetRenderPos.Y = TargetRenderPos.Y -  8
            end
            

            mod.LastCardFullPoss[Pointer] = mod.LastCardFullPoss[Pointer] or TargetRenderPos --check nil


            RenderPos[Pointer] = Vector(mod:Lerp(mod.LastCardFullPoss[Pointer].X, TargetRenderPos.X, mod.Counters.SinceShift/5)
                               ,mod:Lerp(mod.LastCardFullPoss[Pointer].Y, TargetRenderPos.Y, mod.Counters.SinceSelect/1.25))
            

            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                mod.LastCardFullPoss[Pointer] = TargetRenderPos + Vector.Zero
            end


            -------------------------------------------------------------

            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)

            JimboCards.PlayingCards.Scale = Vector.One*ScaleMult

            if Card.Edition ~= mod.Edition.BASE then
                JimboCards.PlayingCards:SetCustomShader(mod.EditionShaders[Card.Edition])
            end

            JimboCards.PlayingCards:Render(RenderPos[Pointer])
        end

        

        TargetRenderPos = Vector(TargetRenderPos.X + 14*ScaleMult, BaseRenderPos.Y)
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        --last confirm option
        --RenderOff = BaseRenderOff + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand), 0)
        --CardFrame:SetFrame(HUD_FRAME.Hand)
        --CardFrame:Render(PlayerScreenPos + RenderOff)



        TargetRenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1) * ScaleMult, 0)

        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][mod.SelectionParams[PIndex].Index] then --realised just now how big these tables are getting...
            TargetRenderPos.Y = TargetRenderPos.Y - 8
        end

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(RenderPos[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]] or TargetRenderPos)


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

    end

    ------DECK RENDERING----------

    local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

    --shows how many cards are left in the deck
    DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))

    DeckSprite.Scale = Vector.One/2
    --local HeartsOffset = Vector(3.5 * math.min(Player:GetMaxHearts(),12),0)

    DeckSprite:Render(DECK_RENDERING_POSITION)
    --DeckSprite:Render(PlayerScreenPos + Offset + BaseRenderOff - Vector(9.5,0))
    
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, JimboHandRender)




local CardScale = {}
--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
local function JimboPackRender(_,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if #mod.SelectionParams[PIndex].PackOptions <= 0 then
        return
    end


    local TruePurpose = mod.SelectionParams[PIndex].Purpose & (~mod.SelectionParams.Purposes.MegaFlag) --removes it for pack checks
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

    elseif TruePurpose == mod.SelectionParams.Purposes.CelestialPack then
    

    
    else--TAROT or SPECTRAL packs
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
            local TargetScale = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] and 1.25 or 1
            CardScale[i] = CardScale[i] or TargetScale+0

            if Option == 53 then --equivalent to the soul card
                JimboCards.SpecialCards:SetFrame("Soul Stone",mod.SelectionParams[PIndex].Frames % 47) --sets the frame corresponding to the value and suit
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


    local Index = mod.SelectionParams[PIndex].Index
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        --here the params.index points to the card in hand, so use the pack selected card as a pointer

        Index = mod:GetValueIndex(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK], true, true)

        if not Index then --no pack card got selected
            return
        end
    end

    --renders the frame on the selected card
    RenderPos.X = BaseRenderPos.X + (Index - 1)*(PACK_CARD_DISTANCE + CardHUDWidth)
    RenderPos.Y = RenderPos.Y - 8 * CardScale[Index] --fises the pivot displacement

    RenderPos = RenderPos + (WobblyEffect[Index] or Vector.Zero)
    CardFrame.Scale = Vector.One * CardScale[Index]

    CardFrame:SetFrame(HUD_FRAME.Frame)
    CardFrame:Render(RenderPos)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboPackRender)
