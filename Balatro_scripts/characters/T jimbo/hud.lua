---@diagnostic disable: need-check-nil
local mod = Balatro_Expansion

local Game = Game()
local sfx = SFXManager()
local math = math --makes stuff faster from what i read (pretty nice since a LOT of functions are used every render frame)

local SinceBlindChange = 0
local SinceChipChange = 0
local SinceMultChange = 0
local SinceHandTypeChange = 0

local SpecialCardsSprite = Sprite("gfx/ui/PackSpecialCards.anm2")

local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")
local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local SellChargeSprite = Sprite("gfx/chargebar.anm2")

local MultCounter = Sprite("gfx/ui/Mult Counter.anm2")
local ChipsCounter = Sprite("gfx/ui/Chips Counter.anm2")

local BlindChipsSprite = Sprite("gfx/ui/Blind Chips.anm2")

local SkipTagsSprite = Sprite("gfx/ui/Skip Tags.anm2")

--local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()
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

local LeftSideHUD = Sprite("gfx/ui/Balatro_left_side_HUD.anm2")
LeftSideHUD:SetFrame("Idle", 0)
LeftSideHUD:PlayOverlay("Strings", true)

local LeftSideLayers = {Base = 0, Blind_Info = 1, General_Info = 2, Fixed_Color = 3, Lines = 4, Q_Button = 5, E_Button = 6}

local BlindChipTexelPos = Vector(0,5)

local LeftSideStringFrames = {
                              CurrentBlindName = 0, BlindChip = 1, ScoreRequirement = 2,
                              Reward = 3, BossEffect = 4, ShopSlogan = 5,
                              Score = 6, CurrentScore = 7, HandType = 8,
                              Chips = 9, Mult = 10, RunInfo = 11,
                              Options = 12, Hands = 13, HandsRemaining = 14,
                              Discards = 15, DiscardsRemaining = 16, Money = 17,
                              Ante = 18, AnteLevel = 19, Rounds = 20, CurrentRound = 21,
                              ChooseNextBlind = 22, EnemyMaxHP = 23, EnemyPortrait = 24,
                              Q_Action = 25, Q_Bind = 26, E_Action = 27, E_Bind = 28,
                              }
--[[
local LeftSideStringPositions = {}

for _,Frame in pairs(LeftSideStringFrames) do

    LeftSideHUD:SetOverlayFrame(Frame)

    LeftSideStringPositions[Frame] = LeftSideHUD:GetOverlayNullFrame("String Positions"):GetPos()
end


local LeftSideStringKColors = {[LeftSideStringFrames.ScoreRequirement] = mod.EffectKColors.RED,
                               [LeftSideStringFrames.Reward] = mod.EffectKColors.YELLOW,
                               [LeftSideStringFrames.ShopSlogan] = mod.EffectKColors.YELLOW,
                               [LeftSideStringFrames.ScoreRequirement] = mod.EffectKColors.RED,
                               [LeftSideStringFrames.HandsRemaining] = mod.EffectKColors.BLUE,
                               [LeftSideStringFrames.DiscardsRemaining] = mod.EffectKColors.RED,
                               [LeftSideStringFrames.Money] = mod.EffectKColors.YELLOW,
                               [LeftSideStringFrames.AnteLevel] = mod.EffectKColors.YELLOW}

local LeftSideStringParams = {[LeftSideStringFrames.ChooseNextBlind] = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Centered,
                              [LeftSideStringFrames.ShopSlogan] = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking | mod.StringRenderingParams.Centered,
                              [LeftSideStringFrames.HandType] = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Enlarge | mod.StringRenderingParams.Centered,
                              [LeftSideStringFrames.ShopSlogan] = mod.StringRenderingParams.Peaking | mod.StringRenderingParams.Centered}
]]



local CashoutBubbleSprite = Sprite("gfx/ui/cashout_bubble.anm2")
local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")


local HAND_RENDERING_HEIGHT = 30 --in screen coordinates
--local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}

local SCREEN_TO_WORLD_RATIO = 4 --idk why this is needed but it is

local BASE_BUBBLE_HEIGHT = 11
local CASHOUT_STRING_X_OFFSET = -39
local BALATRO_LINE_HEIGHT = mod.Fonts.Balatro:GetBaselineHeight()

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10
local DECK_RENDERING_POSITION = Vector(-15,-20) --in screen coordinates
--local DECK_RENDERING_POSITION = Vector(450,250) --in screen coordinates
local INVENTORY_RENDERING_HEIGHT = 32
local JOKER_AREA_WIDTH = 125
local CONSUMABLE_CENTER_OFFSET = 150
local CONSUMABLE_AREA_WIDTH = 75
local CARD_AREA_WIDTH = 175
local CHARGE_BAR_OFFSET = Vector(17,-30)

local ItemsConfig = Isaac.GetItemConfig()



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


local BalatroMapOffset = Vector(228, -291) --just a random high number
--puts the map so far away it's basically impossible to see it
local function CancelMinimapHUD()

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        Minimap.SetShakeOffset(BalatroMapOffset)
        --Minimap.SetShakeDuration(2)

        return true
    else
        local Shake = Minimap.GetShakeOffset()

        if Shake.X == BalatroMapOffset.X and Shake.Y == BalatroMapOffset.Y then
            Minimap.SetShakeOffset(Vector.Zero)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_MINIMAP_RENDER, CancelMinimapHUD)

--jimbo travel around with buttons, so no door needed
local function CancelDoorRendering(_, Door)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, CancelDoorRendering)

local OldCameraStyle
local BaseRoomWidth = Isaac.WorldToScreenDistance(Vector(15 * 40, 0)).X
local CameraOffset = Vector.Zero

local function MoveCameraToRightBorder()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then

        Options.CameraStyle = OldCameraStyle or Options.CameraStyle
        OldCameraStyle = nil

        CameraOffset = Vector.Zero

        return
    end

    OldCameraStyle = OldCameraStyle or Options.CameraStyle

    Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF

    local FreeRightSpace = (Isaac.GetScreenWidth() - BaseRoomWidth) / 2

    CameraOffset = Isaac.WorldToScreenDistance(Vector(FreeRightSpace,0))/2

    CameraOffset.X = math.ceil(CameraOffset.X)
    CameraOffset.Y = math.ceil(CameraOffset.Y)

    --local ScreenCenter = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2)
    --local CurrentCameraPos = Isaac.ScreenToWorld(ScreenCenter) * SCREEN_TO_WORLD_RATIO

    
    --Game:GetRoom():GetCamera():SnapToPosition(CurrentCameraPos + CameraOffset)

end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, MoveCameraToRightBorder)

local TJIMBO_SHADER = "Right Border Shift"

local function RightMoveShader(_,Name) --this shader makes the whole game shifted closer to the right screen border, this allows for larger HUDs on the left side
    if Name == TJIMBO_SHADER then

        local Params = {}


        if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
            Params.CameraOffset = {CameraOffset.X*2, CameraOffset.Y*2}
        else
            Params.CameraOffset = {0,0}
        end

        local HUD = Game:GetHUD()

        HUD:SetVisible(true)
        Game:GetHUD():Render()
        HUD:SetVisible(false)

        return Params
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, RightMoveShader)



---@param String string
---@param Position Vector
---@param StartFrame integer
---@param Scale Vector
---@param Kcolor KColor
---@return integer --gives the number of lines that need to be rendered
function mod:RenderBalatroStyle(String, Position, Params, StartFrame, Scale, Kcolor, BoxWidth, Sound)

    if Params & mod.StringRenderingParams.Wrap ~= 0 then

        Params = Params & ~mod.StringRenderingParams.Wrap
        
        local Lines = {}

        local CurrentSection = ""
        for Word in string.gmatch(String, "%g+") do

            if mod.Fonts.Balatro:GetStringWidth(CurrentSection..Word)*Scale.X > BoxWidth then
                
                Lines[#Lines+1] = CurrentSection

                CurrentSection = Word
                --mod:RenderBalatroStyle(CurrentSection, Position, Params, StartFrame, Scale, Kcolor, Sound, BoxWidth)

                --StartFrame = StartFrame + 2*string.len(CurrentSection)
            elseif string.len(CurrentSection) == 0 then
                
                CurrentSection = Word
            else

                CurrentSection = CurrentSection.." "..Word
            end
        end

        Lines[#Lines+1] = CurrentSection

        --[[
        local ScaleModifier = 1

        for i,Line in ipairs(Lines) do

            print(i, BoxWidth / (mod.Fonts.Balatro:GetStringWidth(Line)*Scale.X), Line)

            print(i, "modifier was", ScaleModifier)

            ScaleModifier = math.min(ScaleModifier, math.min(BoxWidth / (mod.Fonts.Balatro:GetStringWidth(Line)*Scale.X), 1)) --adapts the scale to the box size if it's too big (only scaled DOWN)

            print(i, "modifier is now:", ScaleModifier)
        end

        print(ScaleModifier)


        Scale = Scale * ScaleModifier]]

        Position.Y = Position.Y - mod.Fonts.Balatro:GetLineHeight()*0.75* Scale.Y*(#Lines - 1)

        for _,Line in ipairs(Lines) do

            mod:RenderBalatroStyle(Line, Position, Params, StartFrame, Scale, Kcolor, BoxWidth, Sound)

            Position.Y = Position.Y + mod.Fonts.Balatro:GetLineHeight()*1.5 * Scale.Y

            StartFrame = StartFrame + 8*string.len(CurrentSection)
        end

        return #Lines
    end

    local StringScaledWidth = mod.Fonts.Balatro:GetStringWidth(String) * Scale.X
    local IsCentered = Params & mod.StringRenderingParams.Centered ~= 0


    BoxWidth = BoxWidth or mod.Fonts.Balatro:GetStringWidth(String)*Scale.X

    Scale = Scale * math.min(BoxWidth / (mod.Fonts.Balatro:GetStringWidth(String)*Scale.X), 1) --adapts the scale to the box size if it's too big (only scaled DOWN)
    StringScaledWidth = mod.Fonts.Balatro:GetStringWidth(String) * Scale.X

    --or math.ceil((BoxWidth or StringScaledWidth)/2)

    local XPos

    if Params & mod.StringRenderingParams.Centered ~= 0 then
        
        XPos = Position.X - StringScaledWidth/2

    elseif Params & mod.StringRenderingParams.RightAllinged ~= 0 then

        XPos = Position.X - StringScaledWidth
    else
        XPos = Position.X
    end

    --print(String, XPos)

    local FrameCount = Isaac.GetFrameCount()

    local RenderLength

    if Params & mod.StringRenderingParams.Swoosh ~= 0 then

        RenderLength = (FrameCount - StartFrame)/2
        
        local MaxRenderLength = string.len(String)

        if RenderLength <= MaxRenderLength then

            if Sound then

                sfx:Play(Sound, 1, 2)
            end
        else
            RenderLength = MaxRenderLength
        end
    else
        RenderLength = string.len(String)
    end


    local BaseScale = Scale + Vector.Zero

    for i = 1, RenderLength do
        
        local c = string.sub(String, i,i)

        local CharWidth = mod.Fonts.Balatro:GetCharacterWidth(c)*BaseScale.X

        local Y_Offset = -BALATRO_LINE_HEIGHT*Scale.Y/2

        local X_Offset = 0

        if Params & mod.StringRenderingParams.Peaking ~= 0 then

            local LetterSpace = 7
            local Speed = 25 --lower is faster
            local TotalTime = Speed*LetterSpace

            Y_Offset = Y_Offset + ((((FrameCount + StartFrame) % TotalTime) // Speed == i % LetterSpace) and -0.5 or 0)
        end

        if Params & mod.StringRenderingParams.Wavy ~= 0 then
            Y_Offset = Y_Offset + math.sin((FrameCount + XPos*4 + Position.Y)/24)--*Scale.Y
        end

        if Params & mod.StringRenderingParams.Enlarge ~= 0 then

            local FramesInRendering = FrameCount - StartFrame --how long the word has been rendering for

            local EnlargedScale = math.sin(mod:Clamp((FramesInRendering - i*2)/4, math.pi, 0))*0.33 --*Scale.Y

            Scale = BaseScale * (1 + EnlargedScale)

            X_Offset = X_Offset - CharWidth * EnlargedScale/2 --* Scale.X

            Y_Offset = Y_Offset - BALATRO_LINE_HEIGHT*BaseScale.Y * EnlargedScale/2 --*Scale.Y
        end

        mod.Fonts.Balatro:DrawStringScaled(c,
                                           XPos + X_Offset,
                                           Position.Y + Y_Offset,
                                           Scale.X,
                                           Scale.Y,
                                           Kcolor,
                                           0, --dude i have no idea how the box width works for DrawString (instead of using the Centered parameter i just shift the position)
                                           false) 

        

        XPos = XPos + CharWidth

    end

    return 1
end


local function BRScreenWithOffset(VectorOffset)

    return Vector(Isaac.GetScreenWidth() + VectorOffset.X, Isaac.GetScreenHeight() + VectorOffset.Y)
end




local function JokerWobbleEffect(OffestVar, VerticalBase)

    return (VerticalBase or 0) + math.sin(math.rad(Isaac.GetFrameCount()*1.75+OffestVar*219)), 

           math.sin(math.rad(Isaac.GetFrameCount()*1.15+OffestVar*137)) * 3

end


--renders the player's current hand below them
---@param Player EntityPlayer
local function JimboHandRender(_,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo 
       or not mod.GameStarted or Game:IsPaused() then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumCardsInHand = #mod.Saved.Player[PIndex].CurrentHand

    local CardStep = CARD_AREA_WIDTH / (NumCardsInHand + 1)

    local BaseRenderPos = Vector((Isaac.GetScreenWidth() - CARD_AREA_WIDTH)/2 + CardStep,
                                 Isaac.GetScreenHeight() - HAND_RENDERING_HEIGHT) + CameraOffset

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


        mod.CardFullPoss[Pointer] = mod.CardFullPoss[Pointer] or BRScreenWithOffset(DECK_RENDERING_POSITION) --check nil


        


        if not mod.Saved.EnableHand then --mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

            local TimeOffset = math.max(NumCardsInHand, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)) - i*0.75
            local LerpTime = math.max(mod.Counters.SinceSelect/5 - TimeOffset, 0)

            if LerpTime > 0 or Card.Modifiers & mod.Modifier.COVERED ~= 0 then
                ForceCovered = true
            end

            mod.CardFullPoss[Pointer] = BaseRenderPos + Vector(CardStep,0)*(i-1)

            TargetRenderPos = BRScreenWithOffset(DECK_RENDERING_POSITION)

            RenderPos[Pointer] = mod:VectorLerp(mod.CardFullPoss[Pointer], TargetRenderPos, LerpTime)
            

            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
                sfx:Play(mod.Sounds.SELECT)
            end

        else

            RenderPos[Pointer] = mod:VectorLerp(mod.CardFullPoss[Pointer], TargetRenderPos, mod.Counters.SinceSelect/4)


            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
                --print(Pointer, "assigned")
                mod.CardFullPoss[Pointer] = TargetRenderPos  + Vector.Zero
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

        --moves up selected cards
        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] then
            RenderPos[Pointer].Y = RenderPos[Pointer].Y -  8
        end


        -------------------------------------------------------------
        
        local CardTriggerCounter = (mod.Counters.SinceCardTriggered[Pointer] or 0) * TriggerCounterMult

        Scale = Vector.One * (1 + math.min(0.8, 2.5*(1 - math.abs(math.cos(math.rad(CardTriggerCounter)))^0.5)))

        if CardTriggerCounter >= TriggerAnimationLength then
            mod.Counters.SinceCardTriggered[Pointer] = nil
        end


        Rotation = 10 * math.sin(math.rad(180*(RenderPos[Pointer].X-mod.CardFullPoss[Pointer].X)/math.max(1,TargetRenderPos.X-mod.CardFullPoss[Pointer].X)))

        if mod.CardFullPoss[Pointer].X < TargetRenderPos.X then
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
            local Scale = Vector.One 
            
            if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) then
               Scale = Scale * 1.1
            end
            
            local ForceCovered = Card.Modifiers & mod.Modifier.COVERED ~= 0 or Game:IsPaused()
            local ValueOffset = Vector.Zero
            local IsThin = false

            mod:RenderCard(Card, FramePosition, ValueOffset, Scale, Rotation, ForceCovered, IsThin)


            CardFrame.Scale = Scale
            CardFrame:SetFrame(HUD_FRAME.Frame)
            CardFrame:Render(FramePosition)
        end

    end
    
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboHandRender)


local function JimboDeckRender(_,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.Saved.Player[1] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

    --shows how many cards are left in the deck
    DeckSprite:SetFrame("idle", math.ceil(CardsLeft/7))
    --local HeartsOffset = Vector(3.5 * math.min(Player:GetMaxHearts(),12),0)

    DeckSprite:Render(BRScreenWithOffset(DECK_RENDERING_POSITION))

    
    --DeckSprite:Render(PlayerScreenPos + Offset + BaseRenderOff - Vector(9.5,0))
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboDeckRender)



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
                          Isaac.GetScreenHeight())/2 + CameraOffset


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

        
        mod.CardFullPoss[Pointer] = mod.CardFullPoss[Pointer] or BRScreenWithOffset(DECK_RENDERING_POSITION) --check nil

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

        RenderPos[Pointer] = mod:Lerp(mod.CardFullPoss[Pointer], TargetRenderPos, mod.Counters.SinceSelect/4 - TimeOffset)
                                        

        if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then
            --print(Pointer, "played assigned")
            mod.CardFullPoss[Pointer] = TargetRenderPos + Vector.Zero
        end

        Rotation = 10 * math.sin(math.rad(180*(RenderPos[Pointer].X-mod.CardFullPoss[Pointer].X)/math.max(1,TargetRenderPos.X-mod.CardFullPoss[Pointer].X)))

        if mod.CardFullPoss[Pointer].X > TargetRenderPos.X then
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

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo
       or Game:IsPaused() then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.NONE then
        return
    end


    local TruePurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag --removes it for pack checks
    local PlayerPos = Isaac.WorldToScreen(Player.Position)

    local NumOptions = #mod.SelectionParams[PIndex].PackOptions

    --base point, increased while rendering 
    local BaseRenderPos = Vector(Isaac.GetScreenWidth() - CardHUDWidth * NumOptions - PACK_CARD_DISTANCE * (NumOptions - 1),
                                 Isaac.GetScreenHeight() - HAND_RENDERING_HEIGHT - 23)

    BaseRenderPos.X = BaseRenderPos.X/2 --centers the cards

    BaseRenderPos.X = BaseRenderPos.X + 6.5--makes it centered

    BaseRenderPos = BaseRenderPos + CameraOffset

    local RenderPos = BaseRenderPos + Vector.Zero
    local WobblyEffect = {}

    if TruePurpose == mod.SelectionParams.Purposes.StandardPack then
        --SHOWS THE CHOICES AVAILABLE

        for i,Card in ipairs(mod.SelectionParams[PIndex].PackOptions) do --for every option
        
            local Rotation = 0
            local ForceCovered = Game:IsPaused()
            local ValueOffset = Vector.Zero
            local IsThin = false

            --JimboCards.Pack_PlayingCards.Scale = Vector.One * mod:Lerp(CardScale[i], TargetScale, mod.Counters.SinceSelect)

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            
            CardScale[i] = 1

            if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
               and mod.SelectionParams[PIndex].Index == i then
                CardScale[i] = 1.1
            end
            
            if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] then
                WobblyEffect[i].Y = WobblyEffect[i].Y - 8
            end

            TrinketSprite.Scale = Vector.One * CardScale[i]

            local ActualRenderPos = mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10)

            mod.PackOptionFullPosition[i] = ActualRenderPos


            mod:RenderCard(Card, ActualRenderPos, ValueOffset, TrinketSprite.Scale, Rotation, ForceCovered, IsThin)


            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth
        end--end FOR

    elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        
        for i,card in ipairs(mod.SelectionParams[PIndex].PackOptions) do
    
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)
            TrinketSprite:ReplaceSpritesheet(2, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)

            TrinketSprite:SetFrame("Idle", math.ceil(Isaac.GetFrameCount()/2 + i*37)%JidleLength)

            TrinketSprite:SetCustomShader(mod.EditionShaders[card.Edition])

            TrinketSprite.Rotation = 0


            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            CardScale[i] = 1

            if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
               and mod.SelectionParams[PIndex].Index == i then
                CardScale[i] = 1.1
            end

            if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] then
                WobblyEffect[i].Y = WobblyEffect[i].Y - 8
            end
            
            TrinketSprite.Scale = Vector.One * CardScale[i]


            local ActualRenderPos = mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10)

            mod.PackOptionFullPosition[i] = ActualRenderPos + Vector.Zero

            ActualRenderPos = ActualRenderPos + Vector(-1,8) --fixes a pivot displacement


            TrinketSprite:Render(ActualRenderPos)

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end

    else--TAROT or SPECTRAL packs
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
            if Option == 53 then --equivalent to the soul card
                SpecialCardsSprite:SetFrame("Soul Stone",mod.SelectionParams[PIndex].Frames % 47) 
            else
                SpecialCardsSprite:SetFrame("idle",  Option)
            end

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] then

                WobblyEffect[i].Y = WobblyEffect[i].Y - 8
            end


            CardScale[i] = 1

            if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
               and mod.SelectionParams[PIndex].Index == i then
                CardScale[i] = 1.1
            end

            SpecialCardsSprite.Scale = Vector.One * CardScale[i]
            

            local ActualRenderPos = mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams[PIndex].Frames/25)

            mod.PackOptionFullPosition[i] = ActualRenderPos

            SpecialCardsSprite:Render(ActualRenderPos)

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES


    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end

    local Index = mod.SelectionParams[PIndex].Index

    CardScale[Index] = CardScale[Index] or 1

    --renders the frame on the selected card
    RenderPos = mod.PackOptionFullPosition[Index]

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
                                    INVENTORY_RENDERING_HEIGHT) + Vector(0, -14)*Options.HUDOffset + CameraOffset

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
            TargetRenderPos.Y = TargetRenderPos.Y - 6
        end

        mod.JokerFullPosition[Slot.RenderIndex] = mod.JokerFullPosition[Slot.RenderIndex] or TargetRenderPos

        TrinketSprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
        TrinketSprite:ReplaceSpritesheet(2, JokerConfig.GfxFileName, true)
        

        TrinketSprite:SetFrame("Idle", math.ceil(Isaac.GetFrameCount()/2 + Slot.RenderIndex*36)%JidleLength)
        --TrinketSprite:SetAnimation("Idle", false)
        

        TrinketSprite:SetCustomShader(mod.EditionShaders[mod.Saved.Player[PIndex].Inventory[i].Edition])
        
        RenderPos[Slot.RenderIndex] = Vector(mod:ExponentLerp(mod.JokerFullPosition[Slot.RenderIndex].X, TargetRenderPos.X, mod.Counters.SinceSelect/8, 0.5),
                                 TargetRenderPos.Y)

        if RenderPos[Slot.RenderIndex].Y == TargetRenderPos.Y and RenderPos[Slot.RenderIndex].X == TargetRenderPos.X then
            mod.JokerFullPosition[Slot.RenderIndex] = RenderPos[Slot.RenderIndex] + Vector.Zero
        end

        ----WOBBLE--------
        
        RenderPos[Slot.RenderIndex].Y, TrinketSprite.Rotation = JokerWobbleEffect(Slot.RenderIndex, RenderPos[Slot.RenderIndex].Y)
        
        
        local CardTriggerCounter = (mod.Counters.Activated[Slot.RenderIndex] or 0) * TriggerCounterMult


        local AnimationValue = 1 - math.abs(math.cos(math.rad(CardTriggerCounter)))^0.5 --the graph is kind of like this [_^_]

        TrinketSprite.Scale = Vector.One * (1 + math.min(0.8, 2.5*AnimationValue))

        if AnimationValue ~= 0 then
            TrinketSprite.Rotation = TrinketSprite.Rotation * (2.5 + AnimationValue*3)
        end

        if CardTriggerCounter >= TriggerAnimationLength then
            mod.Counters.Activated[Slot.RenderIndex] = nil
        end
        
        -------------------
        
        TrinketSprite:Render(RenderPos[Slot.RenderIndex])

        ::SKIP_JOKER::
    end


    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        local Slot = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index]

        local FrameRenderPos = RenderPos[Slot.RenderIndex] + Vector(0, -9.6)


        local JokerConfig = ItemsConfig:GetTrinket(Slot.Joker)

        TrinketSprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
        TrinketSprite:ReplaceSpritesheet(2, JokerConfig.GfxFileName, true)

        TrinketSprite:SetFrame("Idle", math.ceil(Isaac.GetFrameCount()/2 + Slot.RenderIndex*36)%JidleLength)
        TrinketSprite.Rotation = 0
        TrinketSprite.Scale = Vector.One * 1.25

        TrinketSprite:Render(RenderPos[Slot.RenderIndex])

        --if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][mod.SelectionParams[PIndex].Index] then
--
        --    FrameRenderPos.Y = FrameRenderPos.Y - 6
        --end

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = Vector.One * 1.25

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

    local BasePos = Vector(Isaac.GetScreenWidth()/2 + CONSUMABLE_CENTER_OFFSET, 
                                    INVENTORY_RENDERING_HEIGHT - 8) + Vector(0, 14)*Options.HUDOffset

    local TargetRenderPos = BasePos

    local RenderPos = {}

    --print(BasePos)

    for i,Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do

        --print(Slot.Joker)
        if Slot.Card == -1 then

            goto SKIP_CARD
        end


        --ConsumableScale[i] = ConsumableScale[i] or TargetScale + 0

        TargetRenderPos.X = TargetRenderPos.X + CardStep
        TargetRenderPos.Y = BasePos.Y


        mod.ConsumableFullPosition[i] = mod.ConsumableFullPosition[i] or TargetRenderPos

        SpecialCardsSprite:SetFrame("idle", Slot.Card)
        SpecialCardsSprite:SetCustomShader(mod.EditionShaders[Slot.Edition])

        RenderPos[i] = Vector(mod:ExponentLerp(mod.ConsumableFullPosition[i].X, TargetRenderPos.X, mod.Counters.SinceSelect/10, 0.75),
                              TargetRenderPos.Y)

        if RenderPos[i].X == TargetRenderPos.X and RenderPos[i].Y == TargetRenderPos.Y then
            mod.ConsumableFullPosition[i] = RenderPos[i]
        end


        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.CONSUMABLES][i] then
                
            RenderPos[i].Y = RenderPos[i].Y - 6
        end


        --if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.CONSUMABLES
        --   and i == mod.SelectionParams[PIndex].Index then
        --    
        --    SpecialCardsSprite.Scale = Vector.One * 1.25
        --else
        --    SpecialCardsSprite.Scale = Vector.One
        --end
        
        --SpecialCardsSprite.Scale = Vector.One * mod:Lerp(ConsumableScale[i], TargetScale, mod.Counters.SinceSelect/5)

        SpecialCardsSprite.Scale = Vector.One

        SpecialCardsSprite:Render(RenderPos[i])

        ::SKIP_CARD::
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.CONSUMABLES then

        local Index = mod.SelectionParams[PIndex].Index

        local Slot = mod.Saved.Player[PIndex].Consumables[Index]

        local FrameRenderPos = RenderPos[Index]


        SpecialCardsSprite:SetFrame("idle", Slot.Card)
        SpecialCardsSprite.Scale = Vector.One * 1.25


        SpecialCardsSprite:Render(FrameRenderPos)


        FrameRenderPos.Y = FrameRenderPos.Y + (mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][mod.SelectionParams[PIndex].Index] and 6 or 0)

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame.Scale = Vector.One * 1.25

        CardFrame:Render(FrameRenderPos)
        --CardFrame:Render(FrameRenderPos)

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

        SellChargeSprite:Render(Isaac.WorldToScreen(Player.Position) + CameraOffset)
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, JimboChargeBarRender)



local function SkipTagsHUD(_,offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    --local PIndex = Player:GetData().TruePlayerIndex

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


local LastPortraiedSprite
local LastPortraiedEnemy

local PreviousBlindDuration = 0
local PreviousBlindType
local BlindChipColor = mod.BalatroColorBlack    --= Color.Default

--BIG ASS render function
---@param Player EntityPlayer
local function TJimbosLeftSideHUD(_,offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex 


    local Lang = mod:GetEIDLanguage()

    local NullFrame
    local CenterPos
    local Scale
    local BoxWidth
    local StartFrame = Isaac.GetFrameCount()
    local K_Color
    local Params

    local String


    local BlindInfoOffset = Vector.Zero
    local PreviousBlindInfoOffset = Vector.Zero

    if PreviousBlindType then
        BlindInfoOffset.Y = mod:Lerp(-400, 0, math.min(math.max(SinceBlindChange-175, 0)/20, 1))
        PreviousBlindInfoOffset.Y = -BlindInfoOffset.Y - 400
    end

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.SHOP then

        if SinceBlindChange == 80 then
            local BlindKColor = mod.EffectKColors.RED

            BlindChipColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
        end
    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.NONE
           or mod.Saved.BlindBeingPlayed == mod.BLINDS.WAITING_CASHOUT then

        if SinceBlindChange == 80 then
            BlindChipColor = mod.BalatroColorBlack--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
        end
    else --if mod.Saved.BlindBeingPlayed == mod.BLINDS.SHOP then
        
        BlindChipsSprite:SetFrame("Chips", mod:GetBLindChipFrame(mod.Saved.BlindBeingPlayed))

        LeftSideHUD:SetFrame(LeftSideStringFrames.BlindChip)

        local Pos = LeftSideHUD:GetNullFrame("String Positions"):GetPos() + BlindInfoOffset

        if SinceBlindChange == 80 then
            local BlindKColor = BlindChipsSprite:GetTexel(BlindChipTexelPos, Vector.Zero, 1)

            --print(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
        
            BlindChipColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
        
        end
    end

    ------------BASE-------------
    -----------------------------
    
    do

    if mod.Saved.BlindBeingPlayed & mod.BLINDS.BOSS ~= 0 then

        LeftSideHUD:GetLayer(LeftSideLayers.Base):SetColor(BlindChipColor)
    else
        LeftSideHUD:GetLayer(LeftSideLayers.Base):SetColor(mod.BalatroColorBlack)
    end
    LeftSideHUD:RenderLayer(LeftSideLayers.Base, Vector.Zero)


    end
    
    --------FIXED COLOR HUD---------
    --------------------------------

    do
        
    LeftSideHUD:GetLayer(LeftSideLayers.Lines):SetColor(BlindChipColor)
    LeftSideHUD:RenderLayer(LeftSideLayers.Lines, Vector.Zero)

    
    LeftSideHUD:RenderLayer(LeftSideLayers.Fixed_Color, Vector.Zero)


    LeftSideHUD:SetFrame(LeftSideStringFrames.RunInfo)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap

    String = mod.Descriptions.T_Jimbo.LeftHUD.RunInfo[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.RunInfo.en_us


    

    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.Options)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.Options[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.Options.en_us


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    local StatToShow = {}

    local ShouldRenderStats = mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND and mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.NONE
                              or mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE and (mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND or mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AIMING)
                              or mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack
    

    if not ShouldRenderStats then
        StatToShow = {Mult = 0, Chips = 0}

    --elseif mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack then
    --    
    --    StatToShow = mod.Saved.HandsStat[mod.Saved.HandType]
    else
        StatToShow.Mult = mod.Saved.MultValue
        StatToShow.Chips = mod.Saved.ChipsValue
    end

    local MultString
    local ChipsString

    --in certain cases the value is a string (planet upgrade animations mostly)
    if type(StatToShow.Chips) == "string" then

        ChipsString = StatToShow.Chips
    else

        ChipsString = mod:RoundBalatroStyle(StatToShow.Chips, 10)
    end

    if type(StatToShow.Mult) == "string" then

        MultString = StatToShow.Mult
    else

        MultString = mod:RoundBalatroStyle(StatToShow.Mult, 10)
    end

    LeftSideHUD:SetFrame(LeftSideStringFrames.Chips)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100
    StartFrame = Isaac.GetFrameCount() - SinceChipChange

    Params = mod.StringRenderingParams.Enlarge | mod.StringRenderingParams.RightAllinged

    String = ChipsString


---@diagnostic disable-next-line: param-type-mismatch
    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.Mult)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100
    StartFrame = Isaac.GetFrameCount() - SinceMultChange

    Params = mod.StringRenderingParams.Enlarge

    String = MultString


---@diagnostic disable-next-line: param-type-mismatch
    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)




    LeftSideHUD:SetFrame(LeftSideStringFrames.HandType)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100
    StartFrame = Isaac.GetFrameCount() - SinceHandTypeChange

    Params = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Enlarge | mod.StringRenderingParams.Centered

    

    if mod.Saved.HandType ~= mod.HandTypes.NONE then

        local LV = mod.Descriptions.Other.LV[Language] or mod.Descriptions.Other.LV["en_us"]

        local Hand = mod.Descriptions.HandTypeName[mod.Saved.HandType][Lang] or mod.Descriptions.HandTypeName[mod.Saved.HandType]["en_us"]

        String = Hand.." "..LV..tostring(mod.Saved.HandLevels[mod.Saved.HandType])
    else
        String = ""
    end
    


---@diagnostic disable-next-line: param-type-mismatch
    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)
    

    end

    --------------BLIND INFO-------------
    -------------------------------------
    
    do
    
    --current info
    if mod.Saved.BlindBeingPlayed ~= mod.BLINDS.NONE then
        
        if mod.Saved.BlindBeingPlayed == mod.BLINDS.SHOP then

            LeftSideHUD:GetLayer(LeftSideLayers.Blind_Info):SetColor(Color.Default)

            LeftSideHUD:SetLayerFrame(LeftSideLayers.Blind_Info, 1 +((Isaac.GetFrameCount() % 32)//8))

        else
            LeftSideHUD:GetLayer(LeftSideLayers.Blind_Info):SetColor(BlindChipColor)
            LeftSideHUD:SetLayerFrame(LeftSideLayers.Blind_Info, 0)

        end

        if mod.Saved.BlindBeingPlayed ~= mod.BLINDS.WAITING_CASHOUT then
            LeftSideHUD:RenderLayer(LeftSideLayers.Blind_Info, BlindInfoOffset)
        end

        

        if mod.Saved.BlindBeingPlayed == mod.BLINDS.SHOP then

            LeftSideHUD:SetFrame(LeftSideStringFrames.ShopSlogan)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = mod.EffectKColors.YELLOW
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking

            String = mod.Descriptions.T_Jimbo.LeftHUD.ShopSlogan[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.ShopSlogan["en_us"]

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)

        elseif mod.Saved.BlindBeingPlayed ~= mod.BLINDS.WAITING_CASHOUT then

            LeftSideHUD:SetFrame(LeftSideStringFrames.BlindChip)

            local Pos = LeftSideHUD:GetNullFrame("String Positions"):GetPos() + BlindInfoOffset

            BlindChipsSprite:Render(Pos)



            LeftSideHUD:SetFrame(LeftSideStringFrames.CurrentBlindName)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = KColor.White
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Wavy

            String = mod.Saved.CurrentBlindName

            StartFrame = Isaac.GetFrameCount() - SinceBlindChange

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)



            LeftSideHUD:SetFrame(LeftSideStringFrames.ScoreRequirement)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = mod.EffectKColors.RED
            Params = mod.StringRenderingParams.Centered

            ---@type Entity
            local MaxHPEnemy

            for _,Enemy in ipairs(Isaac.GetRoomEntities()) do
                if Enemy:IsActiveEnemy() then
                    
                    if not MaxHPEnemy or Enemy.HitPoints > MaxHPEnemy.HitPoints then
                        MaxHPEnemy = Enemy
                    end
                end
            end

            String = mod:RoundBalatroStyle(MaxHPEnemy and MaxHPEnemy.HitPoints or 0, 9)

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)

            --small enemy portrait
            if MaxHPEnemy then

                LeftSideHUD:SetFrame(LeftSideStringFrames.EnemyPortrait)

                NullFrame = LeftSideHUD:GetNullFrame("String Positions")
                CenterPos = NullFrame:GetPos() + BlindInfoOffset

                local MaxScale = NullFrame:GetScale()*100

                --use the cached sprite object if the enemy is the same (this render callback already has too much shit)
                if not LastPortraiedEnemy or GetPtrHash(MaxHPEnemy) ~= GetPtrHash(LastPortraiedEnemy) then

                    if LastPortraiedEnemy then
                        LastPortraiedEnemy.Color = Color.Default
                    end
                    
                    LastPortraiedEnemy = MaxHPEnemy
                    LastPortraiedSprite = MaxHPEnemy:GetSprite()
                end

                

                local OldScale = LastPortraiedSprite.Scale + Vector.Zero

                local Frame 
                
                for i = 0, LastPortraiedSprite:GetLayerCount()-1 do
                    
                    Frame = LastPortraiedSprite:GetLayerFrameData(i)

                    if Frame then --gets the frame of the lowest layer possible
                        break
                    end
                end
                local EnemyScale = Vector(Frame:GetWidth(), Frame:GetHeight())*Frame:GetScale()

                LastPortraiedSprite.Scale = MaxScale / EnemyScale --adapts the sprite size to the icon's max size

                LastPortraiedEnemy.Color = Color.Default

                LastPortraiedSprite:Render(CenterPos)

                local sin = math.sin(Isaac.GetFrameCount()/12)^2

                LastPortraiedEnemy.Color = Color(1 + sin, 1,1,1, sin*0.2) --modifies R tint and R offset


                LastPortraiedSprite.Scale = OldScale
            end



            LeftSideHUD:SetFrame(LeftSideStringFrames.EnemyMaxHP)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = KColor.White
            Params = mod.StringRenderingParams.Centered

            String = mod.Descriptions.T_Jimbo.LeftHUD.EnemyMaxHP[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.EnemyMaxHP["en_us"]



            LeftSideHUD:SetFrame(LeftSideStringFrames.Reward)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = mod.EffectKColors.YELLOW
            Params = mod.StringRenderingParams.Centered

            String = "Reward: "

            

            local DollarsString = ""
            if mod.Saved.CurrentBlindReward <= 0 then

                DollarsString = DollarsString.."No reward"
            else
                DollarsString = string.rep("$", mod.Saved.CurrentBlindReward)
            end
        
            --CenterPos.X = CenterPos.X - mod.Fonts.Balatro:GetStringWidth(String..DollarsString)*Scale.X/2
        --
            --mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)
        
            --K_Color = mod.EffectKColors.YELLOW
                
            mod:RenderBalatroStyle(DollarsString, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)
        
        
        
            LeftSideHUD:SetFrame(LeftSideStringFrames.BossEffect)
        
            NullFrame = LeftSideHUD:GetNullFrame("String Positions")
        
            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = KColor.White
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking
        
            String = mod.Descriptions.BossEffects[mod.Saved.BlindBeingPlayed][Lang] or mod.Descriptions.BossEffects[mod.Saved.BlindBeingPlayed]["en_us"]
        
            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame + 25, Scale, K_Color, BoxWidth)
        
        end
    
    else

        LeftSideHUD:SetFrame(LeftSideStringFrames.ChooseNextBlind)

        NullFrame = LeftSideHUD:GetNullFrame("String Positions")

        CenterPos = NullFrame:GetPos() + BlindInfoOffset
        BoxWidth = NullFrame:GetScale().X * 100
        Scale = Vector.One * NullFrame:GetScale().Y * 50
        StartFrame = Isaac.GetFrameCount() - SinceBlindChange

        Params = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Wrap

        String = mod.Descriptions.T_Jimbo.LeftHUD.ChooseNextBlind[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.ChooseNextBlind.en_us

        mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame + 145, Scale, KColor.White, BoxWidth)
    end


    --previous' blind info (kind of the same as above but not really)

    if PreviousBlindType and PreviousBlindType ~= mod.BLINDS.NONE then
        
        if PreviousBlindType == mod.BLINDS.SHOP then

            LeftSideHUD:GetLayer(LeftSideLayers.Blind_Info):SetColor(Color.Default)

            LeftSideHUD:SetLayerFrame(LeftSideLayers.Blind_Info, 1 +((Isaac.GetFrameCount() % 32)//8))

        else

            local PreviousBlindKColor = BlindChipsSprite:GetTexel(BlindChipTexelPos, Vector.Zero, 1)
            
            PreviousBlindColor = Color(PreviousBlindKColor.Red, PreviousBlindKColor.Green, PreviousBlindKColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
    

            LeftSideHUD:GetLayer(LeftSideLayers.Blind_Info):SetColor(PreviousBlindColor)
            LeftSideHUD:SetLayerFrame(LeftSideLayers.Blind_Info, 0)
        end

        if PreviousBlindType ~= mod.BLINDS.WAITING_CASHOUT then
            LeftSideHUD:RenderLayer(LeftSideLayers.Blind_Info, PreviousBlindInfoOffset)
        end

        

        if PreviousBlindType == mod.BLINDS.SHOP then

            LeftSideHUD:SetFrame(LeftSideStringFrames.ShopSlogan)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = mod.EffectKColors.YELLOW
            BoxWidth = NullFrame:GetScale().X * 100
            StartFrame = Isaac.GetFrameCount() - SinceBlindChange - PreviousBlindDuration
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking

            String = mod.Descriptions.T_Jimbo.LeftHUD.ShopSlogan[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.ShopSlogan["en_us"]

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)

        elseif PreviousBlindType ~= mod.BLINDS.WAITING_CASHOUT then

            LeftSideHUD:SetFrame(LeftSideStringFrames.BlindChip)

            local Pos = LeftSideHUD:GetNullFrame("String Positions"):GetPos() + PreviousBlindInfoOffset

            BlindChipsSprite:SetFrame("Chips",mod:GetBLindChipFrame(PreviousBlindType))

            BlindChipsSprite:Render(Pos)



            LeftSideHUD:SetFrame(LeftSideStringFrames.CurrentBlindName)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = KColor.White
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Wavy

            String = mod.Saved.CurrentBlindName

            StartFrame = Isaac.GetFrameCount() - SinceBlindChange

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)



            LeftSideHUD:SetFrame(LeftSideStringFrames.ScoreRequirement)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = mod.EffectKColors.RED
            Params = mod.StringRenderingParams.Centered


            String = mod:RoundBalatroStyle(0, 9)

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)



            LeftSideHUD:SetFrame(LeftSideStringFrames.EnemyMaxHP)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = KColor.White
            Params = mod.StringRenderingParams.Centered

            String = mod.Descriptions.T_Jimbo.LeftHUD.EnemyMaxHP[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.EnemyMaxHP["en_us"]



            LeftSideHUD:SetFrame(LeftSideStringFrames.Reward)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = mod.EffectKColors.YELLOW
            Params = mod.StringRenderingParams.Centered

            String = "Reward: "

            

            local DollarsString = ""
            if mod.Saved.CurrentBlindReward <= 0 then

                DollarsString = DollarsString.."No reward"
            else
                DollarsString = string.rep("$", mod.Saved.CurrentBlindReward)
            end
        
                
            mod:RenderBalatroStyle(DollarsString, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)
        
        
        
            LeftSideHUD:SetFrame(LeftSideStringFrames.BossEffect)
        
            NullFrame = LeftSideHUD:GetNullFrame("String Positions")
        
            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = KColor.White
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking
        
            String = mod.Descriptions.BossEffects[PreviousBlindType][Lang] or mod.Descriptions.BossEffects[PreviousBlindType]["en_us"]
        
            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame + 25, Scale, K_Color, BoxWidth)
        
        end
    
    elseif PreviousBlindType == mod.BLINDS.NONE then

        LeftSideHUD:SetFrame(LeftSideStringFrames.ChooseNextBlind)

        NullFrame = LeftSideHUD:GetNullFrame("String Positions")

        CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
        BoxWidth = NullFrame:GetScale().X * 100
        Scale = Vector.One * NullFrame:GetScale().Y * 50
        StartFrame = Isaac.GetFrameCount() - SinceBlindChange

        Params = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Wrap

        String = mod.Descriptions.T_Jimbo.LeftHUD.ChooseNextBlind[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.ChooseNextBlind.en_us

        mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame - PreviousBlindDuration, Scale, KColor.White, BoxWidth)
    end

    end

    --------------GENERAL INFO----------------
    ------------------------------------------
    
    do

    if mod.Saved.BlindBeingPlayed & mod.BLINDS.BOSS ~= 0 then

        LeftSideHUD:GetLayer(LeftSideLayers.General_Info):SetColor(BlindChipColor)
    else
        LeftSideHUD:GetLayer(LeftSideLayers.General_Info):SetColor(mod.BalatroColorBlack)
    end
    LeftSideHUD:RenderLayer(LeftSideLayers.General_Info, Vector.Zero)


    LeftSideHUD:SetFrame(LeftSideStringFrames.Score)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.HandScore[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.HandScore["en_us"]


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)


    LeftSideHUD:SetFrame(LeftSideStringFrames.CurrentScore)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 50

    Params = mod.StringRenderingParams.Centered

    String = mod:RoundBalatroStyle(mod.Saved.TotalScore, 9)


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)





    LeftSideHUD:SetFrame(LeftSideStringFrames.Hands)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.Hands[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.Hands.en_us


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.HandsRemaining)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Centered

    String = tostring(mod.Saved.HandsRemaining)


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, mod.EffectKColors.BLUE, BoxWidth)


    LeftSideHUD:SetFrame(LeftSideStringFrames.Discards)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.Discards[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.Discards.en_us


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.DiscardsRemaining)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()

    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Centered

    String = tostring(mod.Saved.DiscardsRemaining)


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, mod.EffectKColors.RED, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.Money)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    if mod.Saved.HasDebt then
        K_Color = mod.EffectKColors.RED
        String = "$"..tostring(-Player:GetNumCoins())
    else
        K_Color = mod.EffectKColors.YELLOW
        String = "$"..tostring(Player:GetNumCoins())
    end

    Params = mod.StringRenderingParams.Peaking | mod.StringRenderingParams.Centered


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.Ante)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Peaking | mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.Ante[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.Ante.en_us


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.AnteLevel)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Centered

    String = tostring(mod.Saved.AnteLevel)


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, mod.EffectKColors.YELLOW, BoxWidth)


    LeftSideHUD:SetFrame(LeftSideStringFrames.Rounds)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Peaking | mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.Round[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.Round.en_us


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.CurrentRound)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Wavy | mod.StringRenderingParams.Centered

    String = tostring(mod.Saved.CurrentRound)


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, mod.EffectKColors.YELLOW, BoxWidth)

    --------------------------------
    end


    -----------ACTION BUTTONS--------------------
    ---------------------------------------------
    
    do

    local Q_Layer = LeftSideHUD:GetLayer(LeftSideLayers.Q_Button)
    local E_Layer = LeftSideHUD:GetLayer(LeftSideLayers.E_Button)

    local Q_ActionString
    local E_ActionString

    local DefaultColor = Color(0.5, 0.5, 0.55) --slightly blue-ish grey

    local SelectParams = mod.SelectionParams[PIndex]
    local SelectedCards = SelectParams.SelectedCards[SelectParams.Mode]

    if SelectParams.Mode == mod.SelectionParams.Modes.INVENTORY then

        Q_Layer:SetColor(DefaultColor) --does nothing

        local ChosenIndex = mod:GetValueIndex(SelectedCards, true, true)
        local Slot = mod.Saved.Player[PIndex].Inventory[ChosenIndex]

        if Slot then

            E_Layer:SetColor(mod.EffectColors.GREEN) --E is for selling a joker

            E_ActionString = "Sell [$"..mod:GetJokerCost(Slot.Joker, Slot.Edition, ChosenIndex, Player).."]"
        else
            E_Layer:SetColor(DefaultColor)
        end

    elseif SelectParams.Mode == mod.SelectionParams.Modes.CONSUMABLES then

        local ChosenIndex = mod:GetValueIndex(SelectedCards, true, true)
        local Consumable = mod.Saved.Player[PIndex].Consumables[ChosenIndex]


        if Consumable then

            if mod:PlayerIsAbleToUseCard(Player, Consumable) then

                Q_Layer:SetColor(mod.EffectColors.RED) --Q is for card use
            else
                Q_Layer:SetColor(DefaultColor)
            end

            Q_ActionString = "Use"

            E_Layer:SetColor(mod.EffectColors.GREEN) --E is for selling a consumable

            E_ActionString = "Sell [$"..tostring(mod:GetConsumableCost(Consumable.Card, Consumable.Edition, ChosenIndex, Player)).."]"
        
        else
            Q_Layer:SetColor(DefaultColor)
            E_Layer:SetColor(DefaultColor)
        end
    
    elseif SelectParams.PackPurpose ~= mod.SelectionParams.Purposes.NONE then
         --SelectParams.Mode == mod.SelectionParams.Modes.PACK then

        SelectedCards = SelectParams.SelectedCards[mod.SelectionParams.Modes.PACK]

        local Consumable = SelectParams.PackOptions[mod:GetValueIndex(SelectedCards, true, true)]

        if SelectParams.PackPurpose == mod.SelectionParams.Purposes.BuffonPack
           or SelectParams.PackPurpose == mod.SelectionParams.Purposes.StandardPack then

            Q_Layer:SetColor(mod.EffectColors.RED) --Q is for card use

            Q_ActionString = "Add"

        else
            if Consumable and mod:PlayerIsAbleToUseCard(Player, mod:FrameToSpecialCard(Consumable)) then

                Q_Layer:SetColor(mod.EffectColors.RED) --Q is for card use
            else
                Q_Layer:SetColor(DefaultColor)
            end

            Q_ActionString = "Use"
        end

        E_Layer:SetColor(Color(0.9, 0.9, 0.9)) --E is for pack skipping

        E_ActionString = "Skip"


    elseif SelectParams.Mode == mod.SelectionParams.Modes.HAND then


        if SelectParams.PackPurpose == mod.SelectionParams.Purposes.AIMING then
            
            Q_Layer:SetColor(mod.EffectColors.BLUE) --Q is for hand damage
            E_Layer:SetColor(DefaultColor)

            Q_ActionString = "Hit"
        else

            if mod:GetValueIndex(SelectedCards, true, true) then

                if mod.Saved.HandsRemaining > 0 then
                    Q_Layer:SetColor(mod.EffectColors.BLUE) --Q is for hand play
                else
                    Q_Layer:SetColor(DefaultColor)
                end

                if mod.Saved.DiscardsRemaining > 0 then
                    E_Layer:SetColor(mod.EffectColors.RED) --E is for hand discard
                else
                    E_Layer:SetColor(DefaultColor)
                end
            else
                Q_Layer:SetColor(DefaultColor)
                E_Layer:SetColor(DefaultColor)
            end

            Q_ActionString = "Play"
            E_ActionString = "Discard"
        end

    else
        Q_Layer:SetColor(DefaultColor)
        E_Layer:SetColor(DefaultColor)
    end

    if mod.AnimationIsPlaying
       and SelectParams.PackPurpose ~= mod.SelectionParams.Purposes.AIMING then
        Q_Layer:SetColor(DefaultColor)
        E_Layer:SetColor(DefaultColor)
    end

    local E_Offset = Vector.Zero
    local Q_Offset = Vector.Zero

    if Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then
        
        Q_Offset = Vector.One

        local StartColor = Q_Layer:GetColor()

        StartColor:SetColorize(StartColor.R*0.85,StartColor.G*0.85,StartColor.B*0.85,1)

        Q_Layer:SetColor(StartColor)
    end

    if Input.IsActionPressed(ButtonAction.ACTION_BOMB, Player.ControllerIndex) then
        
        E_Offset = Vector.One

        local StartColor = E_Layer:GetColor()

        StartColor:SetColorize(StartColor.R*0.85,StartColor.G*0.85,StartColor.B*0.85,1)

        E_Layer:SetColor(StartColor)
    end

    LeftSideHUD:RenderLayer(LeftSideLayers.Q_Button, Q_Offset)
    LeftSideHUD:RenderLayer(LeftSideLayers.E_Button, E_Offset)
    
    if Q_ActionString then

        LeftSideHUD:SetFrame(LeftSideStringFrames.Q_Action)

        NullFrame = LeftSideHUD:GetNullFrame("String Positions")

        CenterPos = NullFrame:GetPos() + Q_Offset
        BoxWidth = NullFrame:GetScale().X * 100
        Scale = Vector.One * NullFrame:GetScale().Y * 100

        Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Peaking

        String = Q_ActionString


        mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)
    end

    LeftSideHUD:SetFrame(LeftSideStringFrames.Q_Bind)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos() + Q_Offset
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.Q_KeyBind[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.Q_KeyBind["en_us"]


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)


    if E_ActionString then

        LeftSideHUD:SetFrame(LeftSideStringFrames.E_Action)

        NullFrame = LeftSideHUD:GetNullFrame("String Positions")

        CenterPos = NullFrame:GetPos() + E_Offset
        BoxWidth = NullFrame:GetScale().X * 100
        Scale = Vector.One * NullFrame:GetScale().Y * 100

        Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Peaking

        String = E_ActionString


        mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)
    end

    LeftSideHUD:SetFrame(LeftSideStringFrames.E_Bind)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos() + E_Offset
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod.Descriptions.T_Jimbo.LeftHUD.E_KeyBind[Lang] or mod.Descriptions.T_Jimbo.LeftHUD.E_KeyBind["en_us"]


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    end

    --------BORDER LINES---------
    -----------------------------
    
    do

    LeftSideHUD:GetLayer(LeftSideLayers.Lines):SetColor(BlindChipColor)
    LeftSideHUD:RenderLayer(LeftSideLayers.Lines, Vector.Zero)

    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, TJimbosLeftSideHUD)



function mod:GetBLindChipFrame(Blind)

    return Blind & mod.BLINDS.BOSS ~= 0 and (Blind+4)/8 or Blind - 1
end


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

    local DefaultParams = mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking

    if BlindString then

        BlindChipsSprite:SetFrame("Chips", mod:GetBLindChipFrame(BlindString.Type))
        BlindChipsSprite:Render(TopPos + CurrentStringOffset)

        CurrentStringOffset.X = CurrentStringOffset.X + 11

        mod:RenderBalatroStyle(BlindString.Name, TopPos + CurrentStringOffset, DefaultParams, BlindString.StartFrame, Vector.One*0.5, KColor.White)


        CurrentStringOffset.X = -CASHOUT_STRING_X_OFFSET - mod.Fonts.Balatro:GetStringWidth(BlindString.String)

        CurrentStringOffset.Y = CurrentStringOffset.Y -- BALATRO_LINE_HEIGHT/4

        mod:RenderBalatroStyle(BlindString.String, TopPos + CurrentStringOffset, DefaultParams, BlindString.StartFrame + string.len(BlindString.Name)*2 + 40, Vector.One, mod.EffectKColors.YELLOW)

        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_LINE_HEIGHT
    end
    --------DIVIDER----------

    local DivideString = mod.ScreenStrings.CashOut[2]

    if DivideString then
        CurrentStringOffset.X = CASHOUT_STRING_X_OFFSET

        mod:RenderBalatroStyle(DivideString.Name, TopPos + CurrentStringOffset, DefaultParams, DivideString.StartFrame, Vector.One*0.5, KColor.White)

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

        mod:RenderBalatroStyle(ScreenString.Name, TopPos + CurrentStringOffset, DefaultParams, ScreenString.StartFrame, Vector.One*0.5, Color)

        ---MONEY AMOUNT

        Color = mod.EffectKColors.YELLOW

        CurrentStringOffset.X = -CASHOUT_STRING_X_OFFSET - mod.Fonts.Balatro:GetStringWidth(ScreenString.String) --+ DollarWidth

        CurrentStringOffset.Y = CurrentStringOffset.Y -- BALATRO_LINE_HEIGHT/4

        mod:RenderBalatroStyle(ScreenString.String, TopPos + CurrentStringOffset, DefaultParams, ScreenString.StartFrame + string.len(ScreenString.Name)*2 + 40, Vector.One, Color)
    
        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_LINE_HEIGHT*1.75
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, CashoutBubbleRender, mod.Effects.DIALOG_BUBBLE)



---@param Pickup EntityPickup
local function CustomPickupSprites(_, Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

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




local LastBlindType = mod.BLINDS.NONE

local LastChipValue = 0
local LastMultValue = 0
local LastHandType = mod.HandTypes.NONE


local function Counters()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) or not mod.GameStarted then
        return
    end

    if mod.Saved.BlindBeingPlayed == LastBlindType then
        SinceBlindChange = SinceBlindChange + 1
    else
        PreviousBlindDuration = SinceBlindChange + 0
        PreviousBlindType = LastBlindType + 0
        
        SinceBlindChange = 0
        LastBlindType = mod.Saved.BlindBeingPlayed + 0
    end 


    if mod.Saved.HandType == LastHandType then
        SinceHandTypeChange = SinceHandTypeChange + 1

    else
        SinceHandTypeChange = 0

        if mod.Saved.HandType ~= mod.HandTypes.NONE then
            SinceMultChange = 0
            SinceChipChange = 0

            LastChipValue = mod.Saved.ChipsValue
            LastMultValue = mod.Saved.MultValue
        end

        LastHandType = mod.Saved.HandType + 0
    end

    if type(mod.Saved.ChipsValue) ~= "string" then
        if mod.Saved.ChipsValue > LastChipValue then

        SinceChipChange = 0

        LastChipValue = mod.Saved.ChipsValue
        else
        SinceChipChange = SinceChipChange + 1
        end
    end

    if type(mod.Saved.MultValue) ~= "string" then
        if mod.Saved.MultValue > LastMultValue then

        SinceMultChange = 0

        LastMultValue = mod.Saved.MultValue

        else
        SinceMultChange = SinceMultChange + 1
        end
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_RENDER, Counters)

