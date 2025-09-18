---@diagnostic disable: need-check-nil, undefined-field
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
TrinketSprite.Offset = Vector(0, 8)
local SellChargeSprite = Sprite("gfx/chargebar.anm2")

local BlindChipsSprite = Sprite("gfx/ui/Blind Chips.anm2")

local SkipTagsSprite = Sprite("gfx/ui/Skip Tags.anm2")

--local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()
local JidleLength = TrinketSprite:GetAnimationData("Idle"):GetLength()

local TriggerAnimationLength = 30
local TriggerCounterMult = 180 / TriggerAnimationLength

local BlindInicator = Sprite("gfx/ui/Blind_indicator.anm2")
BlindInicator:SetFrame("Full",0)


local HUD_FRAME = {}
HUD_FRAME.CardFrame = 0
HUD_FRAME.JokerFrame = 1
HUD_FRAME.Dollar = 2
HUD_FRAME.Hand = 3
HUD_FRAME.Confirm = 4
HUD_FRAME.Skip = 5

local LeftSideHUD = Sprite("gfx/ui/Balatro_left_side_HUD.anm2")
LeftSideHUD:SetFrame("Idle", 0)

local LeftSideLayers = {Base = 0, Blind_Info = 1, General_Info = 2, Fixed_Color = 3, Lines = 4, Q_Button = 5, E_Button = 6}

local CHIPS_TEXEL_POS = Vector(5,0)

local LeftSideStringFrames = {
                              CurrentBlindName = 0, BlindChip = 1, ScoreRequirement = 2,
                              Reward = 3, BossEffect = 4, ShopSlogan = 5,
                              Score = 6, CurrentScore = 7, HandType = 8,
                              Chips = 9, Mult = 10, RunInfo = 11,
                              Options = 12, Hands = 13, HandsRemaining = 14,
                              Discards = 15, DiscardsRemaining = 16, Money = 17,
                              Ante = 18, AnteLevel = 19, Rounds = 20, CurrentRound = 21,
                              ChooseNextBlind = 22, EnemyMaxHP = 23, EnemyPortrait = 24,
                              Q_Action = 25, Q_Bind = 26, E_Action = 27, E_Bind = 28
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


local RunInfoHUD = Sprite("gfx/ui/Balatro_run_info_HUD.anm2")
RunInfoHUD:SetFrame("Full deck", 0)

local GenericButtonSprite = Sprite("gfx/ui/Balatro_Generic_button.anm2")
GenericButtonSprite:SetFrame("Normal", 0)
--GenericButtonSprite:GetLayer(0):GetBlendMode():SetMode(BlendType.OVERLAY)

local BlindBubbleSprite = Sprite("gfx/effects/blind_info_bubble.anm2")
local CashoutBubbleSprite = Sprite("gfx/effects/cashout_bubble.anm2")
local RerollBubbleSprite = Sprite("gfx/effects/reroll_price_bubble.anm2")
RerollBubbleSprite:SetFrame("Idle", 0)


local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")


local HAND_RENDERING_HEIGHT = 30 --in screen coordinates
--local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}

local SCREEN_TO_WORLD_RATIO = 4 --idk why this is needed but it is

local BASE_BUBBLE_HEIGHT = 11
local CASHOUT_STRING_X_OFFSET = -39
local BALATRO_BASE_LINE_HEIGHT = mod.Fonts.Balatro:GetBaselineHeight()
local BALATRO_LINE_HEIGHT = mod.Fonts.Balatro:GetLineHeight()



local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10
local DECK_RENDERING_POSITION = Vector(-15,-20) --in screen coordinates
--local DECK_RENDERING_POSITION = Vector(450,250) --in screen coordinates
local INVENTORY_RENDERING_HEIGHT = 25
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


local BalatroMapOffset = Vector(228, -291) --just a random high vector
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

local BossIntroTime = 0
local OldCameraStyle
local BaseRoomWidth = 15 * 26
local CameraOffset = Vector.Zero

function mod:BossIntroIsPlaying()

    local Level = Game:GetLevel()

    return BossIntroTime >= 60
           or (Level:GetStage() == LevelStage.STAGE4_2 and Level:IsAltStage()
               or Level:GetStage() == LevelStage.STAGE8) and BossIntroTime > 0

end

function mod:WorldToScreen(Position)
    return Isaac.WorldToScreen(Position) + CameraOffset
end

local function MoveCameraToRightBorder()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then

        Options.CameraStyle = OldCameraStyle or Options.CameraStyle
        OldCameraStyle = nil

        CameraOffset = Vector.Zero

        return
    end

    OldCameraStyle = OldCameraStyle or Options.CameraStyle

    Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF

    local FreeRightSpace = (Isaac.GetScreenWidth() - BaseRoomWidth) / 2 - 7

    CameraOffset = Vector(FreeRightSpace,0)


    if RoomTransition:IsRenderingBossIntro() then
        
        BossIntroTime = BossIntroTime + 1

        --CameraOffset = mod:VectorLerp(CameraOffset, Vector.Zero, BossIntroTime/60)

        --Params.CameraOffset = {CameraOffset.X, CameraOffset.Y}

        --return Params
    else
        BossIntroTime = 0
    end


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

        local Params = {CameraOffset = {0,0}}

        if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo)
           or mod:BossIntroIsPlaying()
           or (Game:IsPaused() and not Game:IsPauseMenuOpen()) then

            return Params

        else
            Params.CameraOffset = {CameraOffset.X, CameraOffset.Y}
        end



        

        local HUD = Game:GetHUD()

        HUD:SetVisible(true)
        HUD:Render()
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

    if Params & mod.StringRenderingParams.EID ~= 0 then
        --this part was taken from EID api's RenderString() to the get modified quite a lot in order to work
        --all this cools stuff probably wouldn't be here if the api wasn't so good

        local renderBulletPointIcon = false


        local Offset = Vector.Zero
        local NumLines = 1

        local Lines = {[1] = {Offset = Vector.Zero}}

	    String = EID:replaceShortMarkupStrings(String)
	    local textPartsTable = EID:filterColorMarkup(String, Kcolor)

	    for _, textPart in ipairs(textPartsTable) do

	    	local strFiltered = EID:filterIconMarkup(textPart[1], renderBulletPointIcon)
	    	--EID:renderInlineIcons(spriteTable, position.X + offsetX, position.Y)

	    	if not strFiltered then -- prevent possible crash when strFiltered is nil
                goto SKIP_PART
            end

            local RenderKcolor = textPart[2]
            RenderKcolor.Alpha = 1 --always fully opaque

            --subdivides the filtered string in words to make it go new line when needed
            for Word in string.gmatch(strFiltered, "%g+") do

                --local RenderPos = Vector(125,100) + offset

                local s, e = string.find(Word, "#", 1, true)


                local Before = Word --before the #
                local After = "" --after the #

                if s then --if an # is actually present

                    Before = string.sub(Word, 1, s-1)
                    After = string.sub(Word, e+1, string.len(Word))
                end

                Word = Before.." " --adds a space to delimit from other words
                
                local WordWidth = mod.Fonts.Balatro:GetStringWidth(Word)*Scale.X

                if Offset.X + WordWidth > BoxWidth then --if it goes too far go to new line

                    if Params & mod.StringRenderingParams.Centered ~= 0 then
                        local TotalWidth = 0
                        
                        for _,Word in ipairs(Lines[NumLines]) do
                        
                            TotalWidth = TotalWidth + mod.Fonts.Balatro:GetStringWidth(Word.String)*Scale.X
                        end

                        Lines[NumLines].Offset.X = -TotalWidth/2
                    end

                    
                    NumLines = NumLines + 1

                    Lines[NumLines] = {Offset = Vector.Zero}

                    Offset.X = 0
                    Offset.Y = Offset.Y + mod.Fonts.Balatro:GetLineHeight()*Scale.Y
                    StartFrame = StartFrame + string.len(Word)*2
                end

                Lines[NumLines][#Lines[NumLines]+1] = {String = Word,
                                                       Position = Position + Offset,
                                                       Kcolor = RenderKcolor}

                Offset.X = Offset.X + WordWidth/2

                if s then --puts the word after # in a new line and prints them

                    if Params & mod.StringRenderingParams.Centered ~= 0 then
                        local TotalWidth = 0
                        
                        for _,Word in ipairs(Lines[NumLines]) do
                        
                            TotalWidth = TotalWidth + mod.Fonts.Balatro:GetStringWidth(Word.String)*Scale.X
                        end

                        Lines[NumLines].Offset.X = -TotalWidth/2
                    end

                
                    NumLines = NumLines + 1

                    Lines[NumLines] = {Offset = Vector.Zero}

                    Offset.X = 0
                    Offset.Y = Offset.Y + mod.Fonts.Balatro:GetLineHeight()*Scale.Y*1.5
                    StartFrame = StartFrame + string.len(Word)*2

                    if string.len(After) > 0 then
                        Word = After.." "
                    else
                        Word = After
                    end

                    Lines[NumLines][#Lines[NumLines]+1] = {String = Word,
                                                           Position = Position + Offset, 
                                                           Kcolor = RenderKcolor}
                
                    Offset.X = mod.Fonts.Balatro:GetStringWidth(Word)*Scale.X
                else
                    Offset.X = Offset.X + WordWidth/2
                end

               
            end

            --removes space from last word
            --local LastWord = Lines[NumLines][#Lines[NumLines]].String
--
            --Lines[NumLines][#Lines[NumLines - 1]].String = string.sub(LastWord, 1, string.len(LastWord)-1)

            --EID.font:DrawStringScaledUTF8(strFiltered, position.X + offsetX, position.Y, scale.X, scale.Y, textPart[2], 0, false)
	    	if EID.CachingDescription then
	    		table.insert(EID.CachedStrings[#EID.CachedStrings], {strFiltered, Position.X, Position.Y, textPart[2], textPart[4], EID.Config["Transparency"]})
	    	end

            ::SKIP_PART::
        end

        --last line wouldn't be considered
        if Params & mod.StringRenderingParams.Centered ~= 0 then
            local TotalWidth = 0
            
            for _,Word in ipairs(Lines[NumLines]) do
            
                TotalWidth = TotalWidth + mod.Fonts.Balatro:GetStringWidth(Word.String)*Scale.X
            end

            Lines[NumLines].Offset.X = -TotalWidth/2
        end


        Params = Params & ~ (mod.StringRenderingParams.EID | mod.StringRenderingParams.Wrap | mod.StringRenderingParams.Centered)

        for _,Line in ipairs(Lines) do
            
            for _,Word in ipairs(Line) do
            
                mod:RenderBalatroStyle(Word.String, Word.Position + Line.Offset, Params, StartFrame, Scale, Word.Kcolor, BoxWidth, Sound)
            
                StartFrame = StartFrame + 2*string.len(Word.String)
            end
        end


        return NumLines
    end


    if Params & mod.StringRenderingParams.Wrap ~= 0 then

        Params = Params & ~mod.StringRenderingParams.Wrap
        
        local Lines = {}

        local CurrentSection = ""
        for Word in string.gmatch(String, "%g+") do

            local ShouldNewLine = mod.Fonts.Balatro:GetStringWidth(CurrentSection..Word)*Scale.X > BoxWidth

            if ShouldNewLine then
                
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


        local RenderedLines = 0

        local FutureStartFrame = StartFrame + 0

        for i,Line in ipairs(Lines) do

            RenderedLines = RenderedLines + 1

            FutureStartFrame = FutureStartFrame + 2*string.len(Line)

            if Params & mod.StringRenderingParams.Swoosh ~= 0
               and FutureStartFrame > Isaac.GetFrameCount() then
    
                break --lines wouldn't be rendered anyway
            end
        end


        Position.Y = Position.Y - ((RenderedLines - 1) * BALATRO_LINE_HEIGHT*0.75* Scale.Y)

        for i = 1, RenderedLines do
            
            mod:RenderBalatroStyle(Lines[i], Position, Params, StartFrame, Scale, Kcolor, BoxWidth, Sound)

            Position.Y = Position.Y + BALATRO_LINE_HEIGHT*1.5 * Scale.Y

            StartFrame = StartFrame + 2*string.len(Lines[i])
        end



        return RenderedLines
    end

    local StringScaledWidth = mod.Fonts.Balatro:GetStringWidth(String) * Scale.X

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

        local Y_Offset = 0
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

            --Y_Offset = Y_Offset - BALATRO_BASE_LINE_HEIGHT*BaseScale.Y * EnlargedScale/2 --*Scale.Y
        end

        Y_Offset = Y_Offset - BALATRO_BASE_LINE_HEIGHT*Scale.Y/2 --centers the letter height wise

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


function mod:GetNumLines(String, BoxWidth, Scale)
    
    local Lines = 1

    local CurrentSection = ""
    for Word in string.gmatch(String, "%g+") do

        local ShouldNewLine = mod.Fonts.Balatro:GetStringWidth(CurrentSection..Word)*Scale.X > BoxWidth

        if ShouldNewLine then
            
            Lines = Lines+1

            CurrentSection = Word

            --mod:RenderBalatroStyle(CurrentSection, Position, Params, StartFrame, Scale, Kcolor, Sound, BoxWidth)

            --StartFrame = StartFrame + 2*string.len(CurrentSection)
        elseif string.len(CurrentSection) == 0 then
            
            CurrentSection = Word
        else

            CurrentSection = CurrentSection.." "..Word
        end
    end

    return Lines
end





---@param Position Vector
---@param Scale Vector
---@param BaseColor Color
---@param Pressed boolean
---@param Text string?
---@param TextScale Vector? Default: Vector(0.5, 0.5)
---@param AdaptToTextSize boolean? makes it as long as the text itself (scale becomes the max size of the button)
---@param TextParams integer? I don't reccomend using Wrap here
function mod:RenderGenericButton(Position, Scale, BaseColor, Pressed, Text, TextScale, AdaptToTextSize, TextParams, TextKcolor, SubText)

    TextParams = TextParams or 0
    TextParams = TextParams | mod.StringRenderingParams.Centered
    TextKcolor = TextKcolor or KColor.White

    TextScale = TextScale or (Vector.One/2)

    if Text and AdaptToTextSize then
        
        Scale.X = math.min(Scale.X, mod.Fonts.Balatro:GetStringWidth(Text)*TextScale.X)


        local TextHeight = BALATRO_BASE_LINE_HEIGHT*TextScale.Y

        if SubText then
            
            TextHeight = TextHeight + BALATRO_LINE_HEIGHT*0.75 + BALATRO_BASE_LINE_HEIGHT*0.5
        end

        Scale.Y = math.max(Scale.Y, TextHeight + 5)
    end

    local BorderSize

    if Scale.X <= 10 or Scale.Y <= 10 then
        GenericButtonSprite:SetFrame("Small", 0)

        Scale.X = math.max(Scale.X, 4)
        Scale.Y = math.max(Scale.Y, 4)

        BorderSize = 4
    else
        GenericButtonSprite:SetFrame("Normal", 0)

        BorderSize = 8
    end

    GenericButtonSprite.Color = BaseColor

    if Pressed then
        GenericButtonSprite.Color:SetTint(GenericButtonSprite.Color.R*0.8,GenericButtonSprite.Color.G*0.8,GenericButtonSprite.Color.B*0.8, GenericButtonSprite.Color.A)
    
        Position = Position + Vector(1,1)
    end

    Position = mod:FixScreenPosition(Position)


    --GenericButtonSprite.Scale.X = Scale.X/10
    GenericButtonSprite.Scale = (Scale - Vector.One*BorderSize)/10

    GenericButtonSprite:RenderLayer(0, Position) --center part 1


    local BorderOffset = Vector(0, Scale.Y/2 - BorderSize/4)

    BorderOffset = mod:FixScreenPosition(BorderOffset)

    --GenericButtonSprite.Scale.X = (Scale.X - BorderSize + 0.5)/10
    GenericButtonSprite.Scale.Y = BorderSize/20
    
    GenericButtonSprite:RenderLayer(0, Position + BorderOffset) --bottom

---@diagnostic disable-next-line: cast-local-type
    BorderOffset = -BorderOffset
    GenericButtonSprite:RenderLayer(0, Position + BorderOffset) --top


    BorderOffset = Vector(Scale.X/2 - BorderSize/4, 0)
    BorderOffset = mod:FixScreenPosition(BorderOffset)

    GenericButtonSprite.Scale.X = BorderSize/20
    GenericButtonSprite.Scale.Y = (Scale.Y - BorderSize)/10
    
    GenericButtonSprite:RenderLayer(0, Position + BorderOffset) --right

---@diagnostic disable-next-line: cast-local-type
    BorderOffset = -BorderOffset
    GenericButtonSprite:RenderLayer(0, Position + BorderOffset) --left



    GenericButtonSprite.Scale = Vector.One

    local AngleOffset = Scale/2 - Vector.One*BorderSize/2
    GenericButtonSprite:RenderLayer(4, Position + AngleOffset) --bottom left part

    AngleOffset.X = -AngleOffset.X
    GenericButtonSprite:RenderLayer(3, Position + AngleOffset) --bottom right part

    AngleOffset.Y = -AngleOffset.Y
    GenericButtonSprite:RenderLayer(1, Position + AngleOffset) --top right part

    AngleOffset.X = -AngleOffset.X
    GenericButtonSprite:RenderLayer(2, Position + AngleOffset) --top left part

    if Text then

        local TextPos = Position + GenericButtonSprite:GetNullFrame("Text Position"):GetPos()

        if SubText then
            TextPos.Y = TextPos.Y - BALATRO_LINE_HEIGHT*0.375
        end

        mod:RenderBalatroStyle(Text, TextPos, TextParams, 0, TextScale, TextKcolor, Scale.X - 2)

        if SubText then
            TextPos.Y = TextPos.Y + BALATRO_LINE_HEIGHT*0.75

            mod:RenderBalatroStyle(SubText, TextPos, TextParams, 0, Vector.One * 0.5, TextKcolor, Scale.X - 2)
        end
    end
end


local function BRScreenWithOffset(VectorOffset)

    return Vector(Isaac.GetScreenWidth() + VectorOffset.X, Isaac.GetScreenHeight() + VectorOffset.Y)
end


local function JokerWobbleEffect(OffestVar, VerticalBase)

    return (VerticalBase or 0) + math.sin(math.rad(Isaac.GetFrameCount()*1.75+OffestVar*219)), 

           math.sin(math.rad(Isaac.GetFrameCount()*1.15+OffestVar*137)) * 3

end


function mod:GetBLindChipFrame(Blind)

    return Blind & mod.BLINDS.BOSS ~= 0 and (Blind+12)/8 or (Blind - 1)
end

function mod:GetSkipTagFrame(Tag)

    local Frame

    if Tag & mod.SkipTags.ORBITAL ~= 0 then
        Frame = SkipTagsSprite:GetAnimationData("Tags"):GetLength()-1
    else
        Frame = Tag
    end

    return Frame
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

    local IsVulnerable = mod:IsTJimboVulnerable()


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
        local CardColor

        if IsVulnerable then
            CardColor = Color(1,1,1,0.5)
        end
    


        mod.CardFullPoss[Pointer] = mod.CardFullPoss[Pointer] or BRScreenWithOffset(DECK_RENDERING_POSITION) --check nil



        if not mod.Saved.EnableHand then --mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

            local TimeOffset = math.max(NumCardsInHand, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)) - 0.75*i
            local LerpTime = math.max(mod.Counters.SinceSelect/5 - TimeOffset, 0)

            if LerpTime > 0 or Card.Modifiers & mod.Modifier.COVERED ~= 0 then
                ForceCovered = true
            end

            mod.CardFullPoss[Pointer] = mod.CardFullPoss[Pointer] or BaseRenderPos + Vector(CardStep,0)*(i-1)

            TargetRenderPos = BRScreenWithOffset(DECK_RENDERING_POSITION)

            RenderPos[Pointer] = mod:VectorLerp(mod.CardFullPoss[Pointer], TargetRenderPos, LerpTime)
            
            if RenderPos[Pointer].X == TargetRenderPos.X and RenderPos[Pointer].Y == TargetRenderPos.Y then

                mod.CardFullPoss[Pointer] = nil
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

        if mod.CardFullPoss[Pointer] then

            Rotation = 10 * math.sin(math.rad(180*(RenderPos[Pointer].X-mod.CardFullPoss[Pointer].X)/math.max(1,TargetRenderPos.X-mod.CardFullPoss[Pointer].X)))

            if mod.CardFullPoss[Pointer].X > TargetRenderPos.X then
                Rotation = -Rotation
            end
        else
            Rotation = 0
        end

        RenderPos[Pointer].Y = RenderPos[Pointer].Y + math.sin(math.rad(Isaac.GetFrameCount()*1.75+i*22))

        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.HAND
           or mod.SelectionParams[PIndex].Index ~= i
           or mod.AnimationIsPlaying then

            mod:RenderCard(Card, RenderPos[Pointer], ValueOffset, Scale, Rotation, ForceCovered, IsThin, CardColor)
        end

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
            CardFrame:SetFrame(HUD_FRAME.CardFrame)
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



local function BlindProgressHUD(offset,_,Position,_,Player)

    --------BLIND PROGRESS-----------
    
    if Minimap:GetState() ~= MinimapState.NORMAL or Game:GetLevel():GetStage() == LevelStage.STAGE8
       or not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local SmallAvailable, BigAvailable, BossAvailable = mod:GetJimboBlindAvailability()

    if not BossAvailable then
        return
    end


    if BigAvailable then
        
        if SmallAvailable then
            
            BlindInicator:SetFrame("Full", 0)

        else
            BlindInicator:SetFrame("Big Boss", 0)
        end
    else
        BlindInicator:SetFrame("Boss", 0)
    end


    local ScreenWidth = Isaac.GetScreenWidth()
    local RenderPos = Vector(ScreenWidth - 55 ,25) + Vector(-20, 14)*Options.HUDOffset + Minimap:GetShakeOffset()

    BlindInicator:Render(RenderPos)


    local String
    local Position
    local Params = mod.StringRenderingParams.Centered
    local StartFrame = 0 --doesn't matter
    local Scale
    local Kcolor
    local BoxWidth

    ---SMALL BLIND
    
    if SmallAvailable then
        BlindInicator:SetFrame(0)
        local Frame = BlindInicator:GetNullFrame("String Positions")

        Position = RenderPos + Frame:GetPos()
        Scale = Vector.One * 100 * Frame:GetScale().Y
        BoxWidth = Frame:GetScale().X * 100
    
        if mod.Saved.SmallCleared == mod.BlindProgress.DEFEATED then
            Kcolor = mod.EffectKColors.YELLOW
            String = mod:GetEIDString("Other","Cleared")

        else
            Kcolor = KColor.White
            String = mod:GetEIDString("Other","NotCleared")
        end
    
        mod:RenderBalatroStyle(String, Position, Params, StartFrame, Scale, Kcolor, BoxWidth)
    end


    ---BIG BLIND
    
    if BigAvailable then
        BlindInicator:SetFrame(1)
        local Frame = BlindInicator:GetNullFrame("String Positions")

        Position = RenderPos + Frame:GetPos()
        Scale = Vector.One * 100 * Frame:GetScale().Y
        BoxWidth = Frame:GetScale().X * 100
        
        if mod.Saved.BigCleared == mod.BlindProgress.DEFEATED then
            Kcolor = mod.EffectKColors.YELLOW
            String = mod:GetEIDString("Other","Cleared")

        else
            Kcolor = KColor.White
            String = mod:GetEIDString("Other","NotCleared")
        end
    
        mod:RenderBalatroStyle(String, Position, Params, StartFrame, Scale, Kcolor, BoxWidth)
    end

    --BOSS BLINDS (always available if rendering)
    
    BlindInicator:SetFrame(2)
    local Frame = BlindInicator:GetNullFrame("String Positions")

    Position = RenderPos + Frame:GetPos()
    Scale = Vector.One * 100 * Frame:GetScale().Y
    BoxWidth = Frame:GetScale().X * 100
    
    if mod.Saved.BossCleared == mod.BlindProgress.DEFEATED then
        Kcolor = mod.EffectKColors.YELLOW
        String = mod:GetEIDString("Other","Cleared")

    else
        Kcolor = KColor.White
        String = mod:GetEIDString("Other","NotCleared")
    end

    mod:RenderBalatroStyle(String, Position, Params, StartFrame, Scale, Kcolor, BoxWidth)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, BlindProgressHUD)



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
    local IsVulnerable = mod:IsTJimboVulnerable()


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
        local CardColor

        if IsVulnerable then
            CardColor = Color(1,1,1,0.5)
        end

        
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

        mod:RenderCard(Card, RenderPos[Pointer], ValueOffset, Scale, Rotation, ForceCovered, IsThin, CardColor)
        
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
            CardFrame:SetFrame(HUD_FRAME.CardFrame)
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


    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.PACK
       or mod.AnimationIsPlaying then
        return
    end

    local Index = mod.SelectionParams[PIndex].Index

    CardScale[Index] = CardScale[Index] or 1

    --renders the frame on the selected card
    RenderPos = mod.PackOptionFullPosition[Index]

    CardFrame.Scale = Vector.One * CardScale[Index]

    if TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        CardFrame:SetFrame(HUD_FRAME.JokerFrame)
    else
        CardFrame:SetFrame(HUD_FRAME.CardFrame)
    end


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

    local BasePos = Vector(130 - JOKER_AREA_WIDTH/2, 
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
        
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.INVENTORY
           or mod.SelectionParams[PIndex].Index ~= i then


            if Slot.Modifiers & mod.Modifier.COVERED ~= 0 then
                
                local Params = {} --no need for params if forceCovered is true
                local Pos = RenderPos[Slot.RenderIndex] - Vector(0, 7)
                local Offset = nil
                local Scale = TrinketSprite.Scale
                local Rotation = TrinketSprite.Rotation
                local ForceCovered = true

                mod:RenderCard(Params, Pos, Offset, Scale, Rotation, ForceCovered)

            else

                TrinketSprite:Render(RenderPos[Slot.RenderIndex])

                if Slot.Modifiers & mod.Modifier.DEBUFFED ~= 0 then

                    TrinketSprite:SetCustomShader(mod.EditionShaders.DEBUFF)

                    TrinketSprite:Render(RenderPos[Slot.RenderIndex])
                end
            end


        end
        ::SKIP_JOKER::
    end


    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        local Slot = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index]

        RenderPos[Slot.RenderIndex] = RenderPos[Slot.RenderIndex] or Vector(-100, 0) --out of screen for a frame

        local FrameRenderPos = RenderPos[Slot.RenderIndex]


        local JokerConfig = ItemsConfig:GetTrinket(Slot.Joker)

        TrinketSprite:ReplaceSpritesheet(0, JokerConfig.GfxFileName, true)
        TrinketSprite:ReplaceSpritesheet(2, JokerConfig.GfxFileName, true)

        TrinketSprite:SetCustomShader(mod.EditionShaders[Slot.Edition])


        TrinketSprite:SetFrame("Idle", math.ceil(Isaac.GetFrameCount()/2 + Slot.RenderIndex*36)%JidleLength)
        TrinketSprite.Rotation = 0

        if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) then
            
            TrinketSprite.Scale = Vector.One * 1.1
            CardFrame.Scale = Vector.One * 1.1
        else
            TrinketSprite.Scale = Vector.One
            CardFrame.Scale = Vector.One
        end

        if Slot.Modifiers & mod.Modifier.COVERED ~= 0 then
                
            local Params = {} --no need for params if forceCovered is true
            local Pos = RenderPos[Slot.RenderIndex] - Vector(0, 7)
            local Offset = nil
            local Scale = TrinketSprite.Scale
            local Rotation = TrinketSprite.Rotation
            local ForceCovered = true

            mod:RenderCard(Params, Pos, Offset, Scale, Rotation, ForceCovered)

        else

            TrinketSprite:Render(RenderPos[Slot.RenderIndex])

            if Slot.Modifiers & mod.Modifier.DEBUFFED ~= 0 then

                TrinketSprite:SetCustomShader(mod.EditionShaders.DEBUFF)

                TrinketSprite:Render(RenderPos[Slot.RenderIndex])
            end
        end


        CardFrame:SetFrame(HUD_FRAME.JokerFrame)

        CardFrame:Render(FrameRenderPos)
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



        local CardTriggerCounter = (mod.Counters.SinceConsumableTriggered[i] or 0) * TriggerCounterMult


        local AnimationValue = 1 - math.abs(math.cos(math.rad(CardTriggerCounter)))^0.5 --the graph is kind of like this [_^_]

        TrinketSprite.Scale = Vector.One * (1 + math.min(0.8, 2.5*AnimationValue))


        SpecialCardsSprite:Render(RenderPos[i])

        ::SKIP_CARD::
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.CONSUMABLES then

        local Index = mod.SelectionParams[PIndex].Index

        local Slot = mod.Saved.Player[PIndex].Consumables[Index]

        local FrameRenderPos = RenderPos[Index]


        SpecialCardsSprite:SetFrame("idle", Slot.Card)

        if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) then
            
            SpecialCardsSprite.Scale = Vector.One * 1.1
            CardFrame.Scale = Vector.One * 1.1
        else
            SpecialCardsSprite.Scale = Vector.One
            CardFrame.Scale = Vector.One
        end



        SpecialCardsSprite:Render(FrameRenderPos)


        --FrameRenderPos.Y = FrameRenderPos.Y + (mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][mod.SelectionParams[PIndex].Index] and 6 or 0)

        CardFrame:SetFrame(HUD_FRAME.CardFrame)

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

        local Frame = mod:GetSkipTagFrame(Tag)

        SkipTagsSprite:SetFrame("Tags", Frame)
        SkipTagsSprite:Render(RenderPos)

    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, SkipTagsHUD)


--local LastPortraiedSprite
--local LastPortraiedEnemy

local PreviousBlindDuration = 0
local PreviousBlindType
local PreviousBlindName
local BlindChipColor = mod.BalatroColorBlack    --= Color.Default

--BIG ASS render functions
---@param Player EntityPlayer
local function TJimbosLeftSideHUD(_,offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo
       or BossIntroTime >= 60 then
        return
    end

    local SCREEN_SHAKE = Game.ScreenShakeOffset

    local PIndex = Player:GetData().TruePlayerIndex 

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

        if mod:IsBeastBossRoom() then --needes to be a bit faster

            BlindInfoOffset.Y = mod:Lerp(-260, 0, math.min(math.max(SinceBlindChange-115, 0)/20, 1))
            PreviousBlindInfoOffset.Y = -BlindInfoOffset.Y - 260
        else
            BlindInfoOffset.Y = mod:Lerp(-400, 0, math.min(math.max(SinceBlindChange-175, 0)/20, 1))
            PreviousBlindInfoOffset.Y = -BlindInfoOffset.Y - 400
        end
    end

    local NeededColor

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.SHOP then

        NeededColor = mod.EffectKColors.RED

        NeededColor = Color(NeededColor.Red, NeededColor.Green, NeededColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
    
    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.NONE
           or mod.Saved.BlindBeingPlayed & mod.BLINDS.WAITING_CASHOUT ~= 0 then

        NeededColor = mod.BalatroColorBlack--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
    else
        
        BlindChipsSprite:SetFrame("Chips", mod:GetBLindChipFrame(mod.Saved.BlindBeingPlayed))

        LeftSideHUD:SetFrame(LeftSideStringFrames.BlindChip)

        NeededColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS +SCREEN_SHAKE, Vector.Zero, 1)

        NeededColor = Color(NeededColor.Red, NeededColor.Green, NeededColor.Blue, 1)
        --print(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
    
        --BlindChipColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
    end


    if SinceBlindChange >= 150 or Game:GetFrameCount() <= 25 then

        BlindChipColor = mod:ColorLerp(BlindChipColor, NeededColor, 0.045)
    end

    --BlindChipColor = Color(EndingKColor.Red, EndingKColor.Green, EndingKColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)



    ------------BASE-------------
    -----------------------------
    
    do

    LeftSideHUD:GetLayer(LeftSideLayers.Base):SetColor(BlindChipColor)

    LeftSideHUD:RenderLayer(LeftSideLayers.Base, -SCREEN_SHAKE)


    end
    
    --------FIXED COLOR HUD---------
    --------------------------------

    do
        
    LeftSideHUD:GetLayer(LeftSideLayers.Lines):SetColor(BlindChipColor)
    LeftSideHUD:RenderLayer(LeftSideLayers.Lines, -SCREEN_SHAKE)

    
    LeftSideHUD:RenderLayer(LeftSideLayers.Fixed_Color, -SCREEN_SHAKE)


    LeftSideHUD:SetFrame(LeftSideStringFrames.RunInfo)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    --BoxWidth = NullFrame:GetScale().X * 100
    Scale = NullFrame:GetScale() * 100
    local Pressed = mod.Saved.RunInfoMode ~= mod.RunInfoModes.OFF

    Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "RunInfo")

    mod:RenderGenericButton(CenterPos, Scale, mod.EffectColors.RED, Pressed, String, nil, nil, Params)
    --mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    LeftSideHUD:SetFrame(LeftSideStringFrames.Options)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    --BoxWidth = NullFrame:GetScale().X * 100
    Scale = NullFrame:GetScale() * 100
    Pressed = Game:IsPaused()

    --Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "Options")

    mod:RenderGenericButton(CenterPos, Scale, mod.EffectColors.YELLOW, Pressed, String)

    --mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)


    local HasCovered = false

    
    if mod.Saved.EnableHand then

        for i, Chosen in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do

            if Chosen then

                local Card = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]]

                if Card and Card.Modifiers & mod.Modifier.COVERED ~= 0 then

                    HasCovered = true
                    break
                end
            end
        end

        HasCovered = HasCovered and mod.Saved.HandType ~= mod.HandTypes.NONE --no need to hide the nothingness
    end

    local StatToShow = {}

    --local ShouldRenderStats = mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND and mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.NONE
    --                          or mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE and (mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND or mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AIMING)
    --                          or mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack

    if HasCovered then
        StatToShow.Mult = "???"
        StatToShow.Chips = "???"
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



    if HasCovered then

        String = "?????"
    
    elseif mod.Saved.HandType ~= mod.HandTypes.NONE then

        local LV = mod:GetEIDString("Other", "LV")

        local Hand = mod:GetEIDString("HandTypeName", mod.Saved.HandType)

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

        if mod.Saved.BlindBeingPlayed & mod.BLINDS.WAITING_CASHOUT == 0 then
            LeftSideHUD:RenderLayer(LeftSideLayers.Blind_Info, BlindInfoOffset-SCREEN_SHAKE)
        end

        

        if mod.Saved.BlindBeingPlayed == mod.BLINDS.SHOP then

            LeftSideHUD:SetFrame(LeftSideStringFrames.ShopSlogan)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = mod.EffectKColors.YELLOW
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking
            StartFrame = Isaac.GetFrameCount() - SinceBlindChange

            String = mod:GetEIDString("T_Jimbo", "LeftHUD", "ShopSlogan")

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)

        elseif mod.Saved.BlindBeingPlayed & mod.BLINDS.WAITING_CASHOUT == 0
               and mod.Saved.BlindBeingPlayed & mod.BLINDS.SHOP == 0 then

            LeftSideHUD:SetFrame(LeftSideStringFrames.BlindChip)

            local Pos = LeftSideHUD:GetNullFrame("String Positions"):GetPos() + BlindInfoOffset

            BlindChipsSprite:Render(Pos -SCREEN_SHAKE)



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

                if mod:IsValidScalingEnemy(Enemy) then
 
                    if not MaxHPEnemy or Enemy.HitPoints > MaxHPEnemy.HitPoints then
                        MaxHPEnemy = Enemy
                    end
                end
            end

            String = mod:RoundBalatroStyle(MaxHPEnemy and math.max(MaxHPEnemy.HitPoints,0) or 0, 9)

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)

            --[[ small enemy portrait 
            if MaxHPEnemy then

                --print("Toughest Enemy:","("..tostring(MaxHPEnemy.Type).."."..tostring(MaxHPEnemy.Variant).."."..tostring(MaxHPEnemy.SubType)..")")

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

                --local EnemyScale = Vector(Frame:GetWidth(), Frame:GetHeight())*Frame:GetScale()
                local EnemyScale = Vector(MaxHPEnemy.Size, MaxHPEnemy.Size) * 2.5

                if EnemyScale.X ~= 0 and EnemyScale.Y ~= 0 then

                    EnemyScale.X = math.min(EnemyScale.X, EnemyScale.Y)
                    EnemyScale.Y = math.min(EnemyScale.X, EnemyScale.Y)

                    LastPortraiedSprite.Scale = MaxScale / EnemyScale --adapts the sprite size to the icon's max size

                    LastPortraiedEnemy.Color = Color.Default

                    LastPortraiedSprite:Render(CenterPos)

                    local sin = math.sin(Isaac.GetFrameCount()/12)^2

                    LastPortraiedEnemy.Color = Color(1 + sin, 1,1,1, sin*0.1) --modifies R tint and R offset

                end

                LastPortraiedSprite.Scale = OldScale
            end]]



            LeftSideHUD:SetFrame(LeftSideStringFrames.EnemyMaxHP)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = KColor.White
            Params = mod.StringRenderingParams.Centered

            String = mod:GetEIDString("T_Jimbo", "LeftHUD", "EnemyMaxHP")


            LeftSideHUD:SetFrame(LeftSideStringFrames.Reward)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            BoxWidth = NullFrame:GetScale().X * 100

            K_Color = mod.EffectKColors.YELLOW
            Params = mod.StringRenderingParams.Centered

            --String = mod:GetEIDString("T_Jimbo","LeftHUD","Reward")

        
            local DollarsString = ""
            if mod.Saved.CurrentBlindReward <= 0 then

                DollarsString = DollarsString.."No reward"
            else
                DollarsString = string.rep("$", mod.Saved.CurrentBlindReward)
            end

            String = DollarsString
        
            --CenterPos.X = CenterPos.X - mod.Fonts.Balatro:GetStringWidth(String..DollarsString)*Scale.X/2
        --
            --mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)
        
            --K_Color = mod.EffectKColors.YELLOW
                
            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)
        
        
        
            LeftSideHUD:SetFrame(LeftSideStringFrames.BossEffect)
        
            NullFrame = LeftSideHUD:GetNullFrame("String Positions")
        
            CenterPos = NullFrame:GetPos() + BlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = KColor.White
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Peaking
        
            String = mod:GetEIDString("BossEffects", mod.Saved.BlindBeingPlayed)
        
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

        String = mod:GetEIDString("T_Jimbo", "LeftHUD", "ChooseNextBlind")

        local NumLines = mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame + 145, Scale, KColor.White, BoxWidth)
    
    
        --boss reroll button

        if Player:HasCollectible(mod.Vouchers.Director)
           or Player:HasCollectible(mod.Vouchers.Retcon) then
            
            local ButtonPos = NullFrame:GetPos() + BlindInfoOffset

            ButtonPos.Y = ButtonPos.Y - 20 - BALATRO_BASE_LINE_HEIGHT*Scale.Y*0.5*math.ceil(NumLines/2) - BALATRO_LINE_HEIGHT*Scale.Y*math.max(NumLines-1, 1)*0.75

            local Pressed = Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)
                            or (mod.Saved.NumBossRerolls > 0 and not Player:HasCollectible(mod.Vouchers.Retcon))


            local TextScale = Vector.One * 0.5

            local Text = mod:GetEIDString("T_Jimbo", "LeftHUD", "RerollBoss")
            local SubText = mod:GetEIDString("T_Jimbo", "LeftHUD", "SPACE_KeyBind")

            mod:RenderGenericButton(ButtonPos, Vector(50, 25), mod.EffectColors.RED, Pressed, Text, TextScale, false, nil, nil, SubText)
        end
    end


    --previous' blind info (kind of the same as above but not really)

    if PreviousBlindType and PreviousBlindType ~= mod.BLINDS.NONE then
        
        if PreviousBlindType == mod.BLINDS.SHOP then

            LeftSideHUD:GetLayer(LeftSideLayers.Blind_Info):SetColor(Color.Default)

            LeftSideHUD:SetLayerFrame(LeftSideLayers.Blind_Info, 1 +((Isaac.GetFrameCount() % 32)//8))

        else

            local PreviousBlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS +SCREEN_SHAKE, Vector.Zero, 1)
            
            PreviousBlindColor = Color(PreviousBlindKColor.Red, PreviousBlindKColor.Green, PreviousBlindKColor.Blue, 1)--:SetColorize(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, 1)
    

            LeftSideHUD:GetLayer(LeftSideLayers.Blind_Info):SetColor(PreviousBlindColor)
            LeftSideHUD:SetLayerFrame(LeftSideLayers.Blind_Info, 0)
        end

        if PreviousBlindType & mod.BLINDS.WAITING_CASHOUT == 0 then
            LeftSideHUD:RenderLayer(LeftSideLayers.Blind_Info, PreviousBlindInfoOffset -SCREEN_SHAKE)
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

            String = mod:GetEIDString("T_Jimbo", "LeftHUD", "ShopSlogan")

            mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, K_Color, BoxWidth)

        elseif PreviousBlindType & mod.BLINDS.WAITING_CASHOUT == 0 then

            LeftSideHUD:SetFrame(LeftSideStringFrames.BlindChip)

            local Pos = LeftSideHUD:GetNullFrame("String Positions"):GetPos() + PreviousBlindInfoOffset

            BlindChipsSprite:SetFrame("Chips",mod:GetBLindChipFrame(PreviousBlindType))

            BlindChipsSprite:Render(Pos -SCREEN_SHAKE)



            LeftSideHUD:SetFrame(LeftSideStringFrames.CurrentBlindName)

            NullFrame = LeftSideHUD:GetNullFrame("String Positions")

            CenterPos = NullFrame:GetPos() + PreviousBlindInfoOffset
            Scale = Vector.One * NullFrame:GetScale().Y * 100
            K_Color = KColor.White
            BoxWidth = NullFrame:GetScale().X * 100
            Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Swoosh | mod.StringRenderingParams.Wavy

            String = PreviousBlindName

            StartFrame = Isaac.GetFrameCount() - SinceBlindChange - PreviousBlindDuration

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

            String = mod:GetEIDString("T_Jimbo", "LeftHUD", "EnemyMaxHP")



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
        
            String = mod:GetEIDString("BossEffects", PreviousBlindType)
            
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

        String = mod:GetEIDString("T_Jimbo", "LeftHUD", "ChooseNextBlind")

        local NumLines = mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame - PreviousBlindDuration, Scale, KColor.White, BoxWidth)
    
    
        if Player:HasCollectible(mod.Vouchers.Director)
           or Player:HasCollectible(mod.Vouchers.Retcon) then
            
            local ButtonPos = NullFrame:GetPos() + PreviousBlindInfoOffset

            ButtonPos.Y = ButtonPos.Y - 20 - BALATRO_BASE_LINE_HEIGHT*Scale.Y*0.5*math.ceil(NumLines/2) - BALATRO_LINE_HEIGHT*Scale.Y*math.max(NumLines-1, 1)*0.75

            local Pressed = true
            local TextScale = Vector.One * 0.5

            local Text = mod:GetEIDString("T_Jimbo", "LeftHUD", "RerollBoss")
            local SubText = mod:GetEIDString("T_Jimbo", "LeftHUD", "SPACE_KeyBind")

            mod:RenderGenericButton(ButtonPos, Vector(50, 25), mod.EffectColors.RED, Pressed, Text, TextScale, false, nil, nil, SubText)
        end
    
    end

    end

    --------------GENERAL INFO----------------
    ------------------------------------------
    
    do

    if mod.Saved.BlindBeingPlayed & mod.BLINDS.BOSS ~= 0 then
        LeftSideHUD:GetLayer(LeftSideLayers.General_Info):SetColor(BlindChipColor)
    else
        LeftSideHUD:GetLayer(LeftSideLayers.General_Info):SetColor(BlindChipColor)
    end

    LeftSideHUD:RenderLayer(LeftSideLayers.General_Info, -SCREEN_SHAKE)


    LeftSideHUD:SetFrame(LeftSideStringFrames.Score)

    NullFrame = LeftSideHUD:GetNullFrame("String Positions")

    CenterPos = NullFrame:GetPos()
    BoxWidth = NullFrame:GetScale().X * 100
    Scale = Vector.One * NullFrame:GetScale().Y * 100

    Params = mod.StringRenderingParams.Centered

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "HandScore")


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

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "Hands")


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

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "Discards")


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

    Params = mod.StringRenderingParams.Centered

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "Ante")


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

    Params = mod.StringRenderingParams.Centered

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "Round")


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


        local ChosenIndex = mod:GetValueIndex(SelectedCards, true, true)

        if SelectParams.Purpose == mod.SelectionParams.Purposes.SECRET_EXIT then
               

            local Slot = mod.Saved.Player[PIndex].Inventory[ChosenIndex]

            E_ActionString = "Cancel"
            E_Layer:SetColor(mod.EffectColors.RED)


            if Slot then

                Q_Layer:SetColor(mod.EffectColors.RED)

                Q_ActionString = "Sacrifice"
            else
                Q_Layer:SetColor(DefaultColor)
            end

        else
            Q_Layer:SetColor(DefaultColor) --does nothing

            local Slot = mod.Saved.Player[PIndex].Inventory[ChosenIndex]

            E_ActionString = "Sell"

            if Slot then

                E_Layer:SetColor(mod.EffectColors.GREEN) --E is for selling a joker

                E_ActionString = "Sell [$"..mod:GetJokerCost(Slot.Joker, Slot.Edition, ChosenIndex, Player).."]"
            else
                E_Layer:SetColor(DefaultColor)
            end
        end

    elseif SelectParams.Mode == mod.SelectionParams.Modes.CONSUMABLES then

        local ChosenIndex = mod:GetValueIndex(SelectedCards, true, true)
        local Consumable = mod.Saved.Player[PIndex].Consumables[ChosenIndex]

        Q_ActionString = "Use"

        E_ActionString = "Sell"

        if Consumable then

            if mod:PlayerIsAbleToUseCard(Player, Consumable.Card) then

                Q_Layer:SetColor(mod.EffectColors.RED) --Q is for card use
            else
                Q_Layer:SetColor(DefaultColor)
            end


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


        local PackPurpose = SelectParams.PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag

        if PackPurpose == mod.SelectionParams.Purposes.BuffonPack
           or PackPurpose == mod.SelectionParams.Purposes.StandardPack then

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

        E_Layer:SetColor(Color(0.75, 0.75, 0.75)) --E is for pack skipping

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

    if (mod.Saved.RunInfoMode ~= mod.RunInfoModes.OFF
       and mod.Saved.RunInfoMode ~= mod.RunInfoModes.PARTIAL_DECK)
       or(mod.AnimationIsPlaying
          and SelectParams.PackPurpose ~= mod.SelectionParams.Purposes.AIMING) then
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

    LeftSideHUD:RenderLayer(LeftSideLayers.Q_Button, Q_Offset -SCREEN_SHAKE)
    LeftSideHUD:RenderLayer(LeftSideLayers.E_Button, E_Offset -SCREEN_SHAKE)
    
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

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "Q_KeyBind")


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

    String = mod:GetEIDString("T_Jimbo", "LeftHUD", "E_KeyBind")


    mod:RenderBalatroStyle(String, CenterPos, Params, StartFrame, Scale, KColor.White, BoxWidth)



    end

    --------BORDER LINES---------
    -----------------------------
    
    do

    LeftSideHUD:GetLayer(LeftSideLayers.Lines):SetColor(BlindChipColor)
    LeftSideHUD:RenderLayer(LeftSideLayers.Lines, -SCREEN_SHAKE)

    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, TJimbosLeftSideHUD)


local DeckOverviewPos = Vector(1000, 0)

local function TJimboRunInfo(_,offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local TargetPos

    if mod.Saved.RunInfoMode == mod.RunInfoModes.OFF then
        
        TargetPos = Vector(Isaac.GetScreenWidth() + 100, 50)

    elseif mod.Saved.RunInfoMode == mod.RunInfoModes.PARTIAL_DECK then

        RunInfoHUD:SetFrame("Full deck", 0)
        
        TargetPos = Vector(Isaac.GetScreenWidth() - 69, 50)

    else
        TargetPos = Vector(Isaac.GetScreenWidth()/2 - 115, 50)

        if mod.Saved.RunInfoMode == mod.RunInfoModes.FULL_DECK then

            RunInfoHUD:SetFrame("Full deck", 0)

        elseif mod.Saved.RunInfoMode == mod.RunInfoModes.BLINDS then

            RunInfoHUD:SetFrame("Blinds", 0)

        else --if mod.Saved.RunInfoMode == mod.RunInfoModes.POKER_HANDS then

            RunInfoHUD:SetFrame("Poker hands", 0)
        end

    end

    local HUD_Pos

    if not mod.GameStarted then
        
        HUD_Pos = TargetPos
    else
        HUD_Pos = DeckOverviewPos + (TargetPos - DeckOverviewPos)/12
    end

    DeckOverviewPos = HUD_Pos

    RunInfoHUD:RenderLayer(0, HUD_Pos)


    if mod.Saved.RunInfoMode == mod.RunInfoModes.OFF then
        --no more rendering needed
        return
    end

    -------------TOP OPTIONS-------------
    -------------------------------------

    do

    RunInfoHUD:SetFrame(0)

    local PokerHandsButton = RunInfoHUD:GetNullFrame("Button Positions")

    local ButtonPos = PokerHandsButton:GetPos() + HUD_Pos
    local Size = PokerHandsButton:GetScale() * 100
    local IsPressed = mod.Saved.RunInfoMode == mod.RunInfoModes.POKER_HANDS

    local Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Hands")
    local TextScale = Vector.One * 0.5
    
    mod:RenderGenericButton(ButtonPos, Size, mod.EffectColors.RED, IsPressed, Text, TextScale)


    RunInfoHUD:SetFrame(1)

    PokerHandsButton = RunInfoHUD:GetNullFrame("Button Positions")

    ButtonPos = PokerHandsButton:GetPos() + HUD_Pos
    Size = PokerHandsButton:GetScale() * 100
    IsPressed = mod.Saved.RunInfoMode == mod.RunInfoModes.FULL_DECK

    Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Deck")
    
    mod:RenderGenericButton(ButtonPos, Size, mod.EffectColors.RED, IsPressed, Text, TextScale)


    RunInfoHUD:SetFrame(2)

    PokerHandsButton = RunInfoHUD:GetNullFrame("Button Positions")

    ButtonPos = PokerHandsButton:GetPos() + HUD_Pos
    Size = PokerHandsButton:GetScale() * 100
    IsPressed = mod.Saved.RunInfoMode == mod.RunInfoModes.BLINDS

    Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Blinds")
    
    mod:RenderGenericButton(ButtonPos, Size, mod.EffectColors.RED, IsPressed, Text, TextScale)

    end

    -----------ACTUAL HUD----------
    -------------------------------
    ---

    if mod.Saved.RunInfoMode == mod.RunInfoModes.FULL_DECK
        or mod.Saved.RunInfoMode == mod.RunInfoModes.PARTIAL_DECK then


        local Deck = mod.Saved.Player[PIndex].FullDeck
        local DeckOrder = mod:GetCardTableOrder(Deck, mod.HandOrderingModes.Suit)
            
        --a way to organise the cards
        local Pointers = {[mod.Suits.Spade] = {},
                       [mod.Suits.Heart] = {},
                       [mod.Suits.Club] = {},
                       [mod.Suits.Diamond] = {}}

        for _,Pointer in ipairs(DeckOrder) do

            local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]

            Pointers[Card.Suit][#Pointers[Card.Suit] + 1] = Pointer
        end

        local CoveredSeen = false

        --only counts the ramaining cards (didn't want to create the full deck option cause its not as useful)
        local CardCount = {Total = 0,
                           Stone = 0, --separate counter for stone cards
                           [mod.Suits.Spade] = {},
                           [mod.Suits.Heart] = {},
                           [mod.Suits.Club] = {},
                           [mod.Suits.Diamond] = {}}

        local TotalSuitCount = {[mod.Suits.Spade] = 0,
                            [mod.Suits.Heart] = 0,
                            [mod.Suits.Club] = 0,
                                [mod.Suits.Diamond] = 0}

        local TotalRankCount = {[1] = 0,
                            [2] = 0,
                            [3] = 0,
                            [4] = 0,
                            [5] = 0,
                            [6] = 0,
                            [7] = 0,
                            [8] = 0,
                            [9] = 0,
                            [10] = 0,
                            [mod.Values.JACK] = 0,
                            [mod.Values.QUEEN] = 0,
                                [mod.Values.KING] = 0}

        --count the remaining cards in the deck
        for Pointer, Card in ipairs(Deck) do

        if Pointer < mod.Saved.Player[PIndex].DeckPointer then --card is alredy in hand/used

            if Card.Modifiers & mod.Modifier.COVERED ~= 0 then --player can't know what the card is so count it anyway
                CoveredSeen = true
            else
                goto CONTINUE --go to the next card
            end
        end

        CardCount.Total = CardCount.Total + 1

        if Card.Enhancement == mod.Enhancement.STONE then
            CardCount.Stone = CardCount.Stone + 1
        
        else
            TotalSuitCount[Card.Suit] = TotalSuitCount[Card.Suit] + 1
            TotalRankCount[Card.Value] = TotalRankCount[Card.Value] + 1

            CardCount[Card.Suit][Card.Value] = CardCount[Card.Suit][Card.Value] or 0
            CardCount[Card.Suit][Card.Value] = CardCount[Card.Suit][Card.Value] + 1
        end
        
        ::CONTINUE::
        end



        RunInfoHUD:SetFrame(0)
        local TotalCountPos = RunInfoHUD:GetNullFrame("Overlay Positions 2"):GetPos() + HUD_Pos


        local String
        local RenderPos
        local Params = mod.StringRenderingParams.Centered
        local Scale = Vector.One/2
        local Kcolor 
        local Width

        if CoveredSeen then
            Kcolor = mod.EffectKColors.YELLOW
        else
            Kcolor = KColor.White
        end

        ------TOTAL SUIT--------

        RenderPos = TotalCountPos + Vector.Zero

        for Suit=1, mod.Suits.Diamond do

        RunInfoHUD:SetFrame(Suit)
        local Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos.X = HUD_Pos.X + Frame:GetPos().X
        Width = Frame:GetScale().X * 100

        if TotalSuitCount[Suit] == 0 then
            Kcolor.Alpha = 0.5
        else
            Kcolor.Alpha = 1
        end

        String = tostring(TotalSuitCount[Suit])

        mod:RenderBalatroStyle(String, RenderPos, Params, 0, Scale, Kcolor, Width)
        end


        ------TOTAL RANK--------

        RenderPos = TotalCountPos + Vector.Zero

        for Rank=1, mod.Values.KING do

        RunInfoHUD:SetFrame(Rank)
        local Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos.Y = HUD_Pos.Y + Frame:GetPos().Y
        Width = Frame:GetScale().X * 100

        if TotalRankCount[Rank] == 0 then
            Kcolor.Alpha = 0.5
        else
            Kcolor.Alpha = 1
        end


        String = tostring(TotalRankCount[Rank])

        mod:RenderBalatroStyle(String, RenderPos, Params, 0, Scale, Kcolor, Width)

        local RankName = mod:CardValueToName(Rank, false, true)
        local RankPos = Frame:GetPos() + HUD_Pos

        Kcolor.Alpha = 1 --upvalues shenedigans

        mod:RenderBalatroStyle(RankName, RankPos, Params, 0, Scale, KColor.White, Width)
        end

        -------TOTAL SUIT|RANK--------

        for Suit=1, mod.Suits.Diamond do

        RunInfoHUD:SetFrame(Suit)
        local Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos.X = HUD_Pos.X + Frame:GetPos().X

        for Rank=1, mod.Values.KING do

            RunInfoHUD:SetFrame(Rank)
            local Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

            RenderPos.Y = HUD_Pos.Y + Frame:GetPos().Y
            Width = Frame:GetScale().X * 100

            CardCount[Suit][Rank] = CardCount[Suit][Rank] or 0

            if CardCount[Suit][Rank] <= 0 then
                Kcolor.Alpha = 0.5
            else
                Kcolor.Alpha = 1
            end

            String = tostring(CardCount[Suit][Rank])

            mod:RenderBalatroStyle(String, RenderPos, Params, 0, Scale, Kcolor, Width)
        end
        end

        Kcolor.Alpha = 1 --these mf upvalues raaaahh



        if mod.Saved.RunInfoMode ~= mod.RunInfoModes.FULL_DECK then
            return
        end


        ------FULL DECK RENDERING--------

        local MousePos = Isaac.WorldToScreen(Input.GetMousePosition(true))

        local HoveredCard
        local HoveredPos


        for Suit = 1, mod.Suits.Diamond do

        local SuitNum = TotalSuitCount[Suit]

        RunInfoHUD:SetFrame(Suit)
        local Layer = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        local Width = Layer:GetScale().X * 100

        local RenderPos = Layer:GetPos() + HUD_Pos
        RenderPos.X = RenderPos.X - Width/2

        local CardStep = Width/(SuitNum + 1)

        local ValueOffset = Vector.Zero
        local Thin = false

        ValueOffset.X = math.min(CardStep - 13, 0)

        if ValueOffset.X < -2.5 then

            ValueOffset.X = ValueOffset.X + 1
            
            Thin = true

            ValueOffset.X = math.max(ValueOffset.X, -3.5)
        end

        for _, Pointer in ipairs(Pointers[Suit]) do

            if Pointer < mod.Saved.Player[PIndex].DeckPointer then
                goto CONTINUE
            end

            local Card = Deck[Pointer]

            RenderPos.X = RenderPos.X + CardStep


            local MouseDistance = MousePos - RenderPos

            --MouseDistance.X = math.abs(MouseDistance.X)
            MouseDistance.Y = math.abs(MouseDistance.Y)

            if MouseDistance.Y <= 13
               and (MouseDistance.X >= -9
                    and MouseDistance.X <= (22 - CardStep))   then
                
                HoveredCard = Card
                HoveredPos = RenderPos + Vector.Zero

                goto CONTINUE --don't render it now, since glass cards would look funky
            end


            local Scale = Vector.One
            local Rotation = 0
            local ForceCovered = false
            

            mod:RenderCard(Card, RenderPos, ValueOffset, Scale, Rotation, ForceCovered, Thin)

            ::CONTINUE::
        end
        end

        if HoveredCard then


            mod:RenderCard(HoveredCard, HoveredPos, Vector.Zero, Vector.One*1.1, 0, false, false)
        end

    elseif mod.Saved.RunInfoMode == mod.RunInfoModes.BLINDS then

        local Frame
        local RenderPos
        local Size
        local ButtonColor
        local TextKcolor
        local IsPressed
        local Text
        local TextScale
        local TextParams

        -----------SMALL BLIND-------------

        do
        RunInfoHUD:SetFrame(0)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        RenderPos = Frame:GetPos() + HUD_Pos


        BlindChipsSprite:SetFrame("Big chips", mod:GetBLindChipFrame(mod.BLINDS.SMALL))
        BlindChipsSprite:Render(RenderPos)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100

        Text = mod:GetEIDString("BlindNames", mod.BLINDS.SMALL)
        TextScale = Vector.One
        

        if mod.Saved.BlindBeingPlayed == mod.BLINDS.SMALL then

            ButtonColor = mod.EffectColors.RED
            IsPressed = false
            TextKcolor = KColor.White

        elseif mod.Saved.SmallCleared == mod.BlindProgress.DEFEATED then

            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
            TextKcolor = KColor(0.8, 0.8, 0.8, 1)
            IsPressed = true

        elseif mod.Saved.SmallCleared == mod.BlindProgress.SKIPPED then

            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = mod.EffectColors.BLUE
            TextKcolor = KColor.White
            IsPressed = true
        else 
            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
            IsPressed = false
            TextKcolor = KColor.White
        end

        TextScale = Vector.One
        
        mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale, false, nil, TextKcolor)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.EID


        Text = mod:GetEIDString("T_Jimbo", "LeftHUD", "Reward").." {{ColorYellorange}}"..string.rep("$", mod:GetBlindReward(mod.BLINDS.SMALL))

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 4")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = mod.EffectKColors.RED
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.EID


        Text = mod:RoundBalatroStyle(mod:GetBlindScoreRequirement(mod.BLINDS.SMALL), 11)

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)



        RunInfoHUD:SetFrame(1)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        RenderPos = Frame:GetPos() + HUD_Pos


        SkipTagsSprite:SetFrame("Tags", mod:GetSkipTagFrame(mod.Saved.SmallSkipTag))
        SkipTagsSprite:Render(RenderPos)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*0.5

        ButtonColor = mod.EffectColors.RED
        IsPressed = false
        TextKcolor = KColor.White
        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Skip")
            
        mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered


        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Or")

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 4")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered


        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "DamageRequirement")

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, KColor.White, Size.X)


        if mod.Saved.SmallCleared == mod.BlindProgress.SKIPPED then
            
            RunInfoHUD:SetFrame(2)


            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            RenderPos = Frame:GetPos() + HUD_Pos
            Size = Frame:GetScale() * 100
            TextScale = Vector.One
            TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Peaking

            ButtonColor = Color(0.1,0.1,0.13, 0.40)
            IsPressed = false
            TextKcolor = KColor.White
            Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Skipped")

            mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale, false, TextParams)

        end

        end


        -----------BIG BLIND-------------

        do
        RunInfoHUD:SetFrame(2)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        RenderPos = Frame:GetPos() + HUD_Pos


        BlindChipsSprite:SetFrame("Big chips", mod:GetBLindChipFrame(mod.BLINDS.BIG))
        BlindChipsSprite:Render(RenderPos)


        RunInfoHUD:SetFrame(3)
        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100

        Text = mod:GetEIDString("BlindNames", mod.BLINDS.BIG)
        TextScale = Vector.One
        

        if mod.Saved.BlindBeingPlayed == mod.BLINDS.BIG then

            ButtonColor = mod.EffectColors.RED
            IsPressed = false
            TextKcolor = KColor.White

        elseif mod.Saved.BigCleared == mod.BlindProgress.DEFEATED then

            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
            TextKcolor = KColor(0.8, 0.8, 0.8, 1)
            IsPressed = true

        elseif mod.Saved.BigCleared == mod.BlindProgress.SKIPPED then

            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = mod.EffectColors.BLUE
            TextKcolor = KColor.White
            IsPressed = true
        else 
            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
            IsPressed = false
            TextKcolor = KColor.White
        end

        TextScale = Vector.One
        
        mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale, false, nil, TextKcolor)

        RunInfoHUD:SetFrame(2)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.EID


        Text = mod:GetEIDString("T_Jimbo", "LeftHUD", "Reward").." {{ColorYellorange}}"..string.rep("$", mod:GetBlindReward(mod.BLINDS.BIG))

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 4")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = mod.EffectKColors.RED
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.EID


        Text = mod:RoundBalatroStyle(mod:GetBlindScoreRequirement(mod.BLINDS.BIG), 11)

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)



        RunInfoHUD:SetFrame(3)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        RenderPos = Frame:GetPos() + HUD_Pos


        SkipTagsSprite:SetFrame("Tags", mod:GetSkipTagFrame(mod.Saved.BigSkipTag))
        SkipTagsSprite:Render(RenderPos)

        RunInfoHUD:SetFrame(4)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*0.5

        ButtonColor = mod.EffectColors.RED
        IsPressed = false
        TextKcolor = KColor.White
        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Skip")
            
        mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale)


        RunInfoHUD:SetFrame(3)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered


        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Or")

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 4")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered


        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "DamageRequirement")

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, KColor.White, Size.X)


        if mod.Saved.BigCleared == mod.BlindProgress.SKIPPED then
            
            RunInfoHUD:SetFrame(5)


            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            RenderPos = Frame:GetPos() + HUD_Pos
            Size = Frame:GetScale() * 100
            TextScale = Vector.One
            TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Peaking

            ButtonColor = Color(0.1,0.1,0.13, 0.40)
            IsPressed = false
            TextKcolor = KColor.White
            Text = mod:GetEIDString("T_Jimbo", "RunInfo", "Skipped")

            mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale, false, TextParams)

        end

        end


        -----------BOSS BLIND-------------

        do
        RunInfoHUD:SetFrame(4)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        RenderPos = Frame:GetPos() + HUD_Pos


        BlindChipsSprite:SetFrame("Big chips", mod:GetBLindChipFrame(mod.Saved.AnteBoss))
        BlindChipsSprite:Render(RenderPos)


        RunInfoHUD:SetFrame(6)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100

        Text = mod:GetEIDString("BlindNames", mod.Saved.AnteBoss)
        TextScale = Vector.One
        IsPressed = false
        TextKcolor = KColor.White
        

        if mod.Saved.BlindBeingPlayed == mod.Saved.AnteBoss then

            ButtonColor = mod.EffectColors.RED
            
        else
            BlindChipsSprite:SetAnimation("Chips", false)
            local BlindKColor = BlindChipsSprite:GetTexel(CHIPS_TEXEL_POS, Vector.Zero, 1)

            ButtonColor = Color(BlindKColor.Red, BlindKColor.Green, BlindKColor.Blue, BlindKColor.Alpha)
        end

        TextScale = Vector.One
        
        mod:RenderGenericButton(RenderPos, Size, ButtonColor, IsPressed, Text, TextScale)


        RunInfoHUD:SetFrame(4)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.EID


        Text = mod:GetEIDString("T_Jimbo", "LeftHUD", "Reward").." {{ColorYellorange}}"..string.rep("$", mod:GetBlindReward(mod.Saved.AnteBoss))

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)


        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 4")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = mod.EffectKColors.RED
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.EID


        Text = mod:RoundBalatroStyle(mod:GetBlindScoreRequirement(mod.Saved.AnteBoss), 11)

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, TextKcolor, Size.X)


        RunInfoHUD:SetFrame(6)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 4")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered


        Text = mod:GetEIDString("T_Jimbo", "RunInfo", "DamageRequirement")

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, KColor.White, Size.X)


        RunInfoHUD:SetFrame(5)

        Frame = RunInfoHUD:GetNullFrame("Overlay Positions 3")

        RenderPos = Frame:GetPos() + HUD_Pos
        Size = Frame:GetScale() * 100
        TextScale = Vector.One*Size.Y
        TextKcolor = KColor.White
        TextParams = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap


        Text = mod:GetEIDString("BossEffects", mod.Saved.AnteBoss)

        mod:RenderBalatroStyle(Text, RenderPos, TextParams, 0, TextScale, KColor.White, Size.X)


        end

    else --if mod.Saved.RunInfoMode == mod.RunInfoModes.POKER_HANDS then


        local UnlockedHands = {mod.HandTypes.HIGH_CARD,
                               mod.HandTypes.PAIR,
                               mod.HandTypes.TWO_PAIR,
                               mod.HandTypes.THREE,
                               mod.HandTypes.STRAIGHT,
                               mod.HandTypes.FLUSH,
                               mod.HandTypes.FOUR,
                               mod.HandTypes.STRAIGHT_FLUSH} --these are always unlocked
    
        --these might not be

        local NumSpecialHands = 0

        for SpecialHand = mod.HandTypes.FIVE, mod.HandTypes.FIVE_FLUSH do
            
            if mod.Saved.HandsTypeUsed[SpecialHand] > 0 then
                
                UnlockedHands[#UnlockedHands+1] = SpecialHand
                NumSpecialHands = NumSpecialHands + 1
            end
        end


        local NumHands = #UnlockedHands

        local RowsDistance = 10 + math.min(4 - NumSpecialHands, 3)

        local TextScale = Vector.One * 0.5


        RunInfoHUD:SetFrame(0)

        local Frame = RunInfoHUD:GetNullFrame("Overlay Positions 1")

        local RenderPos = Frame:GetPos() + HUD_Pos

        RenderPos.Y = RenderPos.Y + RowsDistance * (NumHands - 1) / 2

        for _, HandType in ipairs(UnlockedHands) do
            
            RunInfoHUD:RenderLayer(1, RenderPos)


            RunInfoHUD:SetFrame(0)

            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            local StringPos = RenderPos + Frame:GetPos()
            local TextKcolor = mod.BalatroKColorBlack
            local Width = Frame:GetScale().X*100
            local Params = mod.StringRenderingParams.Centered


            local Text = mod:GetEIDString("T_Jimbo", "RunInfo", "LVL")..tostring(mod.Saved.HandLevels[HandType])

            mod:RenderBalatroStyle(Text, StringPos, Params, 0, TextScale, TextKcolor, Width)



            RunInfoHUD:SetFrame(1)

            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            StringPos = RenderPos + Frame:GetPos()
            TextKcolor = KColor.White
            Width = Frame:GetScale().X*100
            Params = mod.StringRenderingParams.Centered

            Text = mod:GetEIDString("HandTypeName", HandType)

            mod:RenderBalatroStyle(Text, StringPos, Params, 0, TextScale, TextKcolor, Width)



            RunInfoHUD:SetFrame(2)

            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            StringPos = RenderPos + Frame:GetPos()
            TextKcolor = KColor.White
            Width = Frame:GetScale().X*100
            Params = mod.StringRenderingParams.RightAllinged

            Text = mod:RoundBalatroStyle(mod.Saved.HandsStat[HandType].Chips, 6)

            mod:RenderBalatroStyle(Text, StringPos, Params, 0, TextScale, TextKcolor, Width)



            RunInfoHUD:SetFrame(3)

            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            StringPos = RenderPos + Frame:GetPos()
            TextKcolor = KColor.White
            Width = Frame:GetScale().X*100
            Params = 0

            Text = mod:RoundBalatroStyle(mod.Saved.HandsStat[HandType].Mult, 6)

            mod:RenderBalatroStyle(Text, StringPos, Params, 0, TextScale, TextKcolor, Width)



            RunInfoHUD:SetFrame(4)

            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            StringPos = RenderPos + Frame:GetPos()
            TextKcolor = KColor.White
            Width = Frame:GetScale().X*100
            Params = mod.StringRenderingParams.Centered

            Text = "#"

            mod:RenderBalatroStyle(Text, StringPos, Params, 0, TextScale, TextKcolor, Width)



            RunInfoHUD:SetFrame(5)

            Frame = RunInfoHUD:GetNullFrame("Overlay Positions 2")

            StringPos = RenderPos + Frame:GetPos()
            TextKcolor = mod.BalatroKColorBlack
            Width = Frame:GetScale().X*100
            Params = mod.StringRenderingParams.Centered

            Text = tostring(mod.Saved.HandsTypeUsed[HandType])

            mod:RenderBalatroStyle(Text, StringPos, Params, 0, TextScale, TextKcolor, Width)


            RenderPos.Y = RenderPos.Y - RowsDistance 
        end
        
    
    
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, TJimboRunInfo)







---@param Effect EntityEffect
local function CashoutBubbleRender(_,Effect, Offset)

    if Effect.SubType ~= mod.DialogBubbleSubType.CASHOUT 
       or mod.Saved.BlindBeingPlayed == (mod.BLINDS.SHOP | mod.BLINDS.WAITING_CASHOUT) then
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

    local MiddleScale = (mod:Clamp(NumStrings-1, 5, 1) * BALATRO_BASE_LINE_HEIGHT * 1.5 + BALATRO_BASE_LINE_HEIGHT*0.25)/10 --maximum of 4 strings at a time

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

        CurrentStringOffset.Y = CurrentStringOffset.Y -- BALATRO_BASE_LINE_HEIGHT/4

        mod:RenderBalatroStyle(BlindString.String, TopPos + CurrentStringOffset, DefaultParams, BlindString.StartFrame + string.len(BlindString.Name)*2 + 40, Vector.One, mod.EffectKColors.YELLOW)

        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_BASE_LINE_HEIGHT
    end
    --------DIVIDER----------

    local DivideString = mod.ScreenStrings.CashOut[2]

    if DivideString then
        CurrentStringOffset.X = CASHOUT_STRING_X_OFFSET

        mod:RenderBalatroStyle(DivideString.Name, TopPos + CurrentStringOffset, DefaultParams, DivideString.StartFrame, Vector.One*0.5, KColor.White)

        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_BASE_LINE_HEIGHT
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

        CurrentStringOffset.Y = CurrentStringOffset.Y -- BALATRO_BASE_LINE_HEIGHT/4

        mod:RenderBalatroStyle(ScreenString.String, TopPos + CurrentStringOffset, DefaultParams, ScreenString.StartFrame + string.len(ScreenString.Name)*2 + 40, Vector.One, Color)
    
        CurrentStringOffset.Y = CurrentStringOffset.Y + BALATRO_BASE_LINE_HEIGHT*1.75
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, CashoutBubbleRender, mod.Effects.DIALOG_BUBBLE)


---@param Effect EntityEffect
local function BlindBubbleRender(_,Effect, Offset)

    if Effect.SubType ~= mod.DialogBubbleSubType.BLIND_INFO then
        return
    end

    local BlindType = Effect.InitSeed


    local PlatePos = Isaac.WorldToScreen(Effect.Position)
    PlatePos.Y = PlatePos.Y + 2.5 * math.sin(Isaac.GetFrameCount()/20)

    if BlindType & mod.BLINDS.BOSS ~= 0 then
        BlindBubbleSprite:SetFrame("Boss", 0)

    else
        BlindBubbleSprite:SetFrame("General", 0)
    end

    BlindBubbleSprite:RenderLayer(0, PlatePos)


    BlindBubbleSprite:SetFrame(1)

    local Frame = BlindBubbleSprite:GetNullFrame("String Positions")

    local TextScale = Vector.One * Frame:GetScale().Y*100
    local TextPos = Frame:GetPos() + PlatePos
    local Width = Frame:GetScale().X*100
    local TextKcolor = mod.EffectKColors.RED
    local Params = mod.StringRenderingParams.Centered

    local Text = mod:RoundBalatroStyle(mod:GetBlindScoreRequirement(BlindType), 10)

    mod:RenderBalatroStyle(Text, TextPos, Params, 0, TextScale, TextKcolor, Width)



    if BlindType & mod.BLINDS.BOSS ~= 0 then

        BlindBubbleSprite:SetFrame(2)

        Frame = BlindBubbleSprite:GetNullFrame("String Positions")

        TextScale = Vector.One * Frame:GetScale().Y*100
        Width = Frame:GetScale().X*100
        TextKcolor = mod.EffectKColors.YELLOW
        Params = mod.StringRenderingParams.Centered | mod.StringRenderingParams.Wrap


        Text = mod:ReplaceBalatroMarkups(mod:GetEIDString("BossEffects", BlindType), mod.EID_DescType.NONE, BlindType, true)

        local NumLines = mod:GetNumLines(Text, Width, TextScale)


        local MiddleSpace = BALATRO_BASE_LINE_HEIGHT*1.5*NumLines
        MiddleSpace = MiddleSpace - MiddleSpace%0.5

        local TextMiddleSpace = BALATRO_BASE_LINE_HEIGHT*1.5*(NumLines - 1)

        local TopOffset = Vector(0, -MiddleSpace)
        local TextOffset = Vector(0, -TextMiddleSpace/2)

        BlindBubbleSprite.Scale.Y = MiddleSpace/10 + 0.1

        BlindBubbleSprite:RenderLayer(1, PlatePos - Vector(0, 41))

        BlindBubbleSprite.Scale.Y = 1

        BlindBubbleSprite:RenderLayer(2, PlatePos + TopOffset)



        TextPos = Frame:GetPos() + PlatePos + TextOffset

        --rerenders the text since the first render was needed to count the lines
        mod:RenderBalatroStyle(Text, TextPos, Params, 0, TextScale, TextKcolor, Width)

    end



    BlindBubbleSprite:SetFrame(0)


    Frame = BlindBubbleSprite:GetNullFrame("String Positions")

    TextScale = Vector.One * Frame:GetScale().Y*100
    TextPos = Frame:GetPos() + PlatePos
    Width = Frame:GetScale().X*100
    TextKcolor = KColor.White
    Params = mod.StringRenderingParams.Centered

    Text = mod:GetEIDString("T_Jimbo", "RunInfo", "AtLeast")

    mod:RenderBalatroStyle(Text, TextPos, Params, 0, TextScale, TextKcolor, Width)


end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, BlindBubbleRender, mod.Effects.DIALOG_BUBBLE)

---@param Effect EntityEffect
local function RerollPriceRender(_,Effect, Offset)

    if Effect.SubType ~= mod.DialogBubbleSubType.REROLL_PRICE then
        return
    end

    local PlatePos = Isaac.WorldToScreen(Effect.Position)
    PlatePos.Y = PlatePos.Y + 2.5 * math.sin(Isaac.GetFrameCount()/20)

    local Price = Game:GetRoom():GetGridEntityFromPos(Effect.Position).VarData


    RerollBubbleSprite:Render(PlatePos)


    local Frame = RerollBubbleSprite:GetNullFrame("String Positions")

    local TextPos = PlatePos + Frame:GetPos()
    local Params = mod.StringRenderingParams.Centered
    local TextScale = Vector.One * Frame:GetScale().Y * 100
    local Width = Frame:GetScale().X * 100

    local TextKcolor

    if mod:PlayerCanAfford(Price) then
        
        TextKcolor = mod.EffectKColors.YELLOW
    else
        TextKcolor = mod.EffectKColors.RED
    end

    local Text

    if Price <= 0 then
        
        Text = mod:GetEIDString("Other", "FREE")
    else
        Text = tostring(Price).."$"
    end


    mod:RenderBalatroStyle(Text, TextPos, Params, 0, TextScale, TextKcolor, Width )



end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, RerollPriceRender, mod.Effects.DIALOG_BUBBLE)



---@param Pickup EntityPickup
local function CustomPickupSprites(_, Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    if Pickup.Variant == mod.Pickups.PLAYING_CARD then

        Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        local CardSprite = Pickup:GetSprite()

        CardSprite:Load("gfx/ui/Card Body.anm2", true)

        CardSprite:SetAnimation("Base")

        local Params = mod:PlayingCardSubTypeToParams(Pickup.SubType)


        CardSprite:GetLayer(1):SetCustomShader(mod.EditionShaders[Params.Edition])
        CardSprite:GetLayer(2):SetCustomShader(mod.EditionShaders[Params.Edition])
        
        CardSprite:SetLayerFrame(0, 4* Params.Value + Params.Suit - 5)
        CardSprite:SetLayerFrame(1, Params.Enhancement)
        CardSprite:SetLayerFrame(2, Params.Enhancement)
        CardSprite:SetLayerFrame(3, Params.Seal)

    elseif Pickup.Variant == PickupVariant.PICKUP_TAROTCARD then

        if mod:Contained(mod.Packs, Pickup.SubType) then

            local PackSprite = Pickup:GetSprite()
            
            PackSprite:Load("gfx/ui/Booster Packs.anm2")

            local PackAnimation = ItemsConfig:GetCard(Pickup.SubType).Name

            --print(".."..PackAnimation.."..")

            PackSprite:SetFrame(PackAnimation, math.random(PackSprite:GetAnimationData(PackAnimation):GetLength()) - 1)


        else

            local CardSprite = Pickup:GetSprite()

            CardSprite:Load("gfx/ui/PackSpecialCards.anm2", true)

            CardSprite:SetFrame("idle",  mod:SpecialCardToFrame(Pickup.SubType))
        end

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
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, PickupWobble)




local LastBlindType = mod.BLINDS.NONE
local LastBlindName = ""

local LastChipValue = 0
local LastMultValue = 0
local LastHandType = mod.HandTypes.NONE


local function Counters()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) or not mod.GameStarted then
        return
    end

    if mod.Saved.BlindBeingPlayed == LastBlindType then
        SinceBlindChange = SinceBlindChange + 1

    elseif LastBlindType then

        PreviousBlindDuration = SinceBlindChange + 0

        SinceBlindChange = 0
        
        PreviousBlindType = LastBlindType + 0
        LastBlindType = mod.Saved.BlindBeingPlayed + 0


        PreviousBlindName = string.sub(LastBlindName, 1)
        LastBlindName = string.sub(mod.Saved.CurrentBlindName, 1)

        --print("Blind Changed to", mod.Saved.BlindBeingPlayed)

    else 
        LastBlindType = mod.BLINDS.NONE
        LastBlindName = ""
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



local function ResetPreviousBlind()

    PreviousBlindType = nil
---@diagnostic disable-next-line: cast-local-type
    LastBlindType = nil
    SinceBlindChange = 0

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ResetPreviousBlind)

