---@diagnostic disable: need-check-nil
local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local JactivateLength = TrinketSprite:GetAnimationData("Effect"):GetLength()
local JidleLength = TrinketSprite:GetAnimationData("Idle"):GetLength()

local BlindChips = Sprite("gfx/ui/Blind Chips.anm2")
local BlindInicator = Sprite("gfx/ui/Blind_indicator.anm2")
BlindInicator:SetFrame("Full",0)

local InventoryFrame = {0,0,0}

local SpecialCards = Sprite("gfx/ui/PackSpecialCards.anm2")
local DeckSprite = Sprite("gfx/ui/Deck Stages.anm2")


local DiscardChargeSprite = Sprite("gfx/chargebar.anm2")
DiscardChargeSprite.Offset = Vector(-17,-25)

local HandChargeSprite = Sprite("gfx/ui/chargebar_the_hand.anm2")
local CHARGE_BAR_OFFSET = Vector(17,-25)

local HandsBarV2 = Sprite("gfx/Cards_Bar V2.anm2")

local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")

local CHARGED_ANIMATION = HandChargeSprite:GetAnimationData("StartCharged"):GetLength() - 1 --the length of an animation for chargebars
local CHARGED_LOOP_ANIMATION = HandChargeSprite:GetAnimationData("Charged"):GetLength() - 1

local INVENTORY_RENDERING_POSITION = Vector(10,10)

--local DECK_RENDERING_POSITION = Isaac.WorldToRenderPosition(Isaac.ScreenToWorld(Vector(760,745)))

local HUD_FRAME = {}
HUD_FRAME.CardFrame = 0
HUD_FRAME.JokerFrame = 1
HUD_FRAME.Dollar = 2
HUD_FRAME.Hand = 3
HUD_FRAME.Confirm = 4
HUD_FRAME.Skip = 5

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10


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

    HeartSprite.Offset = PIndex == 0 and Vector(-35,0) or Vector.Zero

    local PlayerRenderMult = Player:GetPlayerIndex()%2 == 1 and -1 or 1

    TrinketSprite.Scale = ScaleMult

    local BasePos = Vector(0,0)
    BasePos.X = INVENTORY_RENDERING_POSITION.X + 20*Options.HUDOffset
    BasePos.Y = Isaac.GetScreenHeight() - INVENTORY_RENDERING_POSITION.Y - 14*Options.HUDOffset


    if IsCoop then
        BasePos = HeartPosition + Vector(0,8)

        if Player:GetPlayerIndex()%2 == 0 then --adds heart offset
            BasePos = BasePos + (Game:GetLevel():GetCurses()&LevelCurse.CURSE_OF_THE_UNKNOWN ~= 0 and Vector(15,0) or (math.min(12,Player:GetEffectiveMaxHearts())* Vector(6,0))) * PlayerRenderMult
        
        else --adds offset if player has an active
        
            BasePos.X = BasePos.X - 4
        
            if Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= CollectibleType.COLLECTIBLE_NULL then
                BasePos.X = BasePos.X - 37
            end
        end
    end

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

                TrinketSprite:SetFrame("Effect", mod.Counters.Activated[i])

                if mod.Counters.Activated[i] == JactivateLength then --stops the animation
                    mod.Counters.Activated[i] = nil
                end
            else

                InventoryFrame[i] = InventoryFrame[i] or 0

                if Isaac.GetFrameCount() % 2 == 0 then
                    InventoryFrame[i] = InventoryFrame[i] + 1

                    InventoryFrame[i] = InventoryFrame[i] > JidleLength and 0 or InventoryFrame[i]
                end

                TrinketSprite:SetFrame("Idle", InventoryFrame[i])
            end

            TrinketSprite:SetCustomShader(mod.EditionShaders[mod.Saved.Player[PIndex].Inventory[i].Edition])
            
        end

        --RenderPos.Y = RenderPos.Y + 8*ScaleMult.Y

        TrinketSprite:Render(RenderPos)

        mod.JokerFullPosition[Slot.RenderIndex] = RenderPos
    end

    if Isaac.GetFrameCount()% 2 == 0 then
        TrinketSprite:Update()
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        local Slot = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index]

        local RenderPos

        if Slot then

            RenderPos = mod.JokerFullPosition[Slot.RenderIndex]
        else
            RenderPos = BasePos + Vector(23 * mod.SelectionParams[PIndex].Index , 0)*ScaleMult* PlayerRenderMult
        end

        CardFrame:SetFrame(HUD_FRAME.JokerFrame)
        CardFrame.Scale = ScaleMult
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = BasePos + Vector(23 * (#mod.Saved.Player[PIndex].Inventory + 1), -8) * ScaleMult * PlayerRenderMult
        
        
        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SELLING then
            CardFrame:SetFrame(HUD_FRAME.Dollar)
        else
            CardFrame:SetFrame(HUD_FRAME.Confirm)
        end
        
        CardFrame:Render(RenderPos)
    end

    mod:JimboStatsHUD(offset,HeartSprite,HeartPosition,_,Player)
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboInventoryHUD)


---@param Player EntityPlayer
function mod:JimboStatsHUD(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local IsPlayer2 = PIndex == 2

    -------STATS COUNTER RENDERING---------
    
    local ChipsPos = Vector(26,115) + offset
    local MultPos = ChipsPos + Vector(0,12)

    
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

        local pos = string.find(ChipsString, ".", nil, true)

        if not pos then
            ChipsString = ChipsString..".00"
        else
            for i=1, 2 + pos - string.len(ChipsString) do

                ChipsString = ChipsString.."0"
            end
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

        local pos = string.find(MultString, ".", nil, true)

        if not pos then
            MultString = MultString..".00"
        else
            for i=1, 2 + pos - string.len(MultString) do

                MultString = MultString.."0"
            end
        end
    end

    local ChipsScale
    local MultScale

    do
        local String = math.floor(mod:CalculateTearsValue(Player))..".00"
        ChipsScale = Vector(math.max(mod.Fonts.luamini:GetStringWidth(String)),9)

        String = math.floor(Player.Damage)..".00"
        MultScale = Vector(math.max(mod.Fonts.luamini:GetStringWidth(String)),9)
    end

    if IsPlayer2 then
        ChipsPos = ChipsPos + Vector(8, 10)
        MultPos = MultPos + Vector(8, 10)
    end

    mod:RenderGenericButton(ChipsPos, ChipsScale, mod.EffectColors.BLUE, false, ChipsString, Vector(0.5,0.5), false, 0)
    mod:RenderGenericButton(MultPos, MultScale, mod.EffectColors.RED, false, MultString, Vector(0.5,0.5), false, 0)
end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboStatsHUD)


local BlindPos
local SINCE_CLEAR = {[mod.BLINDS.SMALL] = 0,
                     [mod.BLINDS.BIG] = 0,
                     [mod.BLINDS.BOSS] = 0}
local BLIND_WIDTH = 22
local function BlindProgressHUD(_,offset,_,Position,_,Player)

    --------BLIND PROGRESS-----------
    
    if Game:GetLevel():GetStage() == LevelStage.STAGE8
       or not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    local SmallAvailable, BigAvailable, BossAvailable = mod:GetJimboBlindAvailability()

    if not BossAvailable then
        return
    end

    local NumAvailable = 1

    if SmallAvailable then
        NumAvailable = NumAvailable + 1
    end
    if BigAvailable then
        NumAvailable = NumAvailable + 1
    end

    local TargetPos = Vector(Isaac.GetScreenWidth()/2 - (BLIND_WIDTH/2)*(NumAvailable-1),0) + Vector(0, offset.Y) + Minimap:GetShakeOffset()

    if Minimap:GetState() == MinimapState.EXPANDED then

        TargetPos.Y = 48 + offset.Y
    else
        TargetPos.Y = -20
    end

    BlindPos = BlindPos or TargetPos

    local BaseRenderPos = BlindPos + (TargetPos - BlindPos)/10
    BlindPos = BaseRenderPos + Vector.Zero

    if BlindPos.Y < -15 then
        return
    end

    if SmallAvailable then --and mod.Saved.SmallCleared ~= mod.BlindProgress.DEFEATED then
    
        BlindChips:SetFrame("Chips", 0)
        
        BlindInicator:Render(BaseRenderPos)

        local RenderPos = BaseRenderPos + Vector.Zero
        local Rotation = 0

        RenderPos.Y, Rotation = mod:JokerWobbleEffect(mod.BLINDS.SMALL, RenderPos.Y, 0.5)

        BlindChips.Rotation = Rotation

        local TriggerCounter = SINCE_CLEAR[mod.BLINDS.SMALL] * 12

        BlindChips.Scale = Vector.One * (1 + math.min(0.5, 1.5*(1 - math.abs(math.cos(math.rad(TriggerCounter)))^0.5)))


        BlindChips:Render(RenderPos)

        if mod.Saved.SmallCleared == mod.BlindProgress.DEFEATED then

            SINCE_CLEAR[mod.BLINDS.SMALL] = math.min(SINCE_CLEAR[mod.BLINDS.SMALL] + 1, 15)

            BlindChips:SetCustomShader(mod.EditionShaders.DEBUFF_SMALL)
            BlindChips:Render(RenderPos)
            BlindChips:ClearCustomShader()

        else
            SINCE_CLEAR[mod.BLINDS.SMALL] = 0
        end
    
        BaseRenderPos.X = BaseRenderPos.X + BLIND_WIDTH
    end


    ---BIG BLIND
    
    if BigAvailable then
    
        BlindChips:SetFrame("Chips", 1)
        
        BlindInicator:Render(BaseRenderPos)

        local RenderPos = BaseRenderPos + Vector.Zero
        local Rotation = 0

        RenderPos.Y, Rotation = mod:JokerWobbleEffect(mod.BLINDS.BIG, RenderPos.Y, 0.5)
        
        BlindChips.Rotation = Rotation

        local TriggerCounter = SINCE_CLEAR[mod.BLINDS.BIG] * 12

        BlindChips.Scale = Vector.One * (1 + math.min(0.5, 1.5*(1 - math.abs(math.cos(math.rad(TriggerCounter)))^0.5)))


        BlindChips:Render(RenderPos)

        if mod.Saved.BigCleared == mod.BlindProgress.DEFEATED then

            SINCE_CLEAR[mod.BLINDS.BIG] = math.min(15, SINCE_CLEAR[mod.BLINDS.BIG] + 1)

            BlindChips:SetCustomShader(mod.EditionShaders.DEBUFF_SMALL)
            BlindChips:Render(RenderPos)
            BlindChips:ClearCustomShader()
        else
            SINCE_CLEAR[mod.BLINDS.BIG] = 0
        end
    
        BaseRenderPos.X = BaseRenderPos.X + BLIND_WIDTH
    end

    --BOSS BLIND (always available if rendering)
        
   BlindChips:SetFrame("Chips", 2)
   
   BlindInicator:Render(BaseRenderPos)

   local RenderPos = BaseRenderPos + Vector.Zero
   local Rotation = 0

   RenderPos.Y, Rotation = mod:JokerWobbleEffect(mod.BLINDS.BOSS, RenderPos.Y, 0.5)
   
   BlindChips.Rotation = Rotation

   local TriggerCounter = SINCE_CLEAR[mod.BLINDS.BOSS] * 12

   BlindChips.Scale = Vector.One * (1 + math.min(0.5, 1.5*(1 - math.abs(math.cos(math.rad(TriggerCounter)))^0.5)))


   BlindChips:Render(RenderPos)

   if mod.Saved.BossCleared == mod.BlindProgress.DEFEATED then

       SINCE_CLEAR[mod.BLINDS.BOSS] = math.min(15, SINCE_CLEAR[mod.BLINDS.BOSS] + 1)

       BlindChips:SetCustomShader(mod.EditionShaders.DEBUFF_SMALL)
       BlindChips:Render(RenderPos)
       BlindChips:ClearCustomShader()
   else
       SINCE_CLEAR[mod.BLINDS.BOSS] = 0
   end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, BlindProgressHUD)



function mod:HandBarV2Render(offset,_,Position,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local PlayerRenderMult = Player:GetPlayerIndex()%2 == 1 and -1 or 1

    ----if true then return end
    
    local Offset = Vector(0, 14)*PlayerRenderMult-- + Vector(2, 2)*Options.HUDOffset

    local TotalHands = Player:GetCustomCacheValue(mod.CustomCache.HAND_NUM)
    local RemainingHands = mod:GetJimboTriggerableCards(Player)

    if mod.Saved.Player[PIndex].FirstDeck
       and not Game:GetRoom():IsClear() then

        HandsBarV2.Color = mod.EffectColors.BLUE
    else
        HandsBarV2.Color = mod.EffectColors.RED

        if mod.Saved.Player[PIndex].FirstDeck then
            RemainingHands = TotalHands
        end
    end


    for Partial = 0, TotalHands-1, 5 do

        local Frame = RemainingHands - Partial
        if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
            Frame = 5
        end

        
        if Frame <= 0 then
            break
        end

        HandsBarV2:SetFrame("Idle", Frame)

        HandsBarV2:Render(Position + Offset)

        Offset = Offset + Vector(10,0)

        if Partial == 20 then
            
            Offset = Offset + Vector(-50,9)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.HandBarV2Render)


--rendere the player's current hand below them
local ScaleMult = 0.5
---@param Player EntityPlayer
function mod:JimboHandRender(Player, Offset)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    if mod.Saved.DSS.Jimbo.HandHUDPosition ~= 1 then
        return
    end
    
    local PIndex = Player:GetData().TruePlayerIndex

    local PlayerScreenPos = Isaac.WorldToRenderPosition(Player.Position)


    local TargetScale = mod.Saved.DSS.Jimbo.HandScale
    
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        TargetScale = 1 --while selecting the the cards gets bigger
    end
    if ScaleMult ~= TargetScale then
        --ScaleMult = mod:Lerp(ScaleMult,TargetScale, mod.SelectionParams[PIndex].Frames/100)
        ScaleMult = mod:Lerp(1.5 - TargetScale,TargetScale, mod.SelectionParams[PIndex].Frames/5)
    end

    local BaseRenderPos = PlayerScreenPos + Offset + Vector(-7 *(#mod.Saved.Player[PIndex].CurrentHand-1), 26)* ScaleMult


    local RenderPos = BaseRenderPos + Vector.Zero
    local TrueOffset = {}

    
    for i, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if Card then

            if mod.SelectionParams[PIndex].SelectedCards[i] and mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
                RenderPos.Y = RenderPos.Y -  8
            end
             --moves up selected cards

            mod.CardFullPoss[Pointer] = mod.CardFullPoss[Pointer] or RenderPos --check nil

            TrueOffset[Pointer] = Vector(mod:Lerp(mod.CardFullPoss[Pointer].X, RenderPos.X, mod.Counters.SinceShift/5)
                               ,mod:Lerp(mod.CardFullPoss[Pointer].Y, RenderPos.Y, mod.Counters.SinceSelect/1.25))
            

            if TrueOffset[Pointer].X == RenderPos.X and TrueOffset[Pointer].Y == RenderPos.Y then
                mod.CardFullPoss[Pointer] = RenderPos + Vector.Zero
            end


            -------------------------------------------------------------

            local Rotation = 0
            local ValueOffset = mod.Saved.Player[PIndex].CurrentHand[i+1] and Vector(-2,0) or Vector.Zero
            local Scale = Vector.One*ScaleMult
            local ForceCovered = false
            local Thin = false

            mod:RenderCard(Card, TrueOffset[Pointer], ValueOffset, Scale,Rotation, ForceCovered, Thin)
        end

        RenderPos = Vector(RenderPos.X + 14*ScaleMult, BaseRenderPos.Y)
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        --last confirm option
        RenderPos = BaseRenderPos + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(RenderPos)


        RenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1) * ScaleMult, 0)

        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] then
            RenderPos.Y = RenderPos.Y - 8
        end

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.CardFrame)
        CardFrame:Render(RenderPos)
    else
        ------DECK RENDERING----------

        local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

        --shows how many cards are left in the deck
        DeckSprite:SetFrame("idle", math.ceil(CardsLeft/8))

        DeckSprite.Scale = Vector.One*ScaleMult

        DeckSprite:Render(BaseRenderPos - Vector(18,0)*ScaleMult)


        RenderPos = BaseRenderPos + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand - 1) * ScaleMult, 0)

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.CardFrame)
        CardFrame:Render(RenderPos)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JimboHandRender,PlayerVariant.PLAYER)


local ScaleMult = 0.5
---@param Player EntityPlayer
function mod:JimboHandRender2(Offset, Sprite, Position, _, Player)

    if mod.Saved.DSS.Jimbo.HandHUDPosition ~= 2 then
        return
    end

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end
    
    local PIndex = Player:GetData().TruePlayerIndex
    local RenderMult = Player:GetPlayerIndex()%2 == 1 and -1 or 1

    local TargetScale = mod.Saved.DSS.Jimbo.HandScale
    
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        TargetScale = 1 --while selecting the the cards gets bigger
    end
    if ScaleMult ~= TargetScale then
        --ScaleMult = mod:Lerp(ScaleMult,TargetScale, mod.SelectionParams[PIndex].Frames/100)
        ScaleMult = mod:Lerp(1.5 - TargetScale,TargetScale, mod.SelectionParams[PIndex].Frames/5)
    end

    local BaseRenderPos = Position -- + Vector(-7 *(#mod.Saved.Player[PIndex].CurrentHand-1), 26)* ScaleMult
    
    if PIndex <= 2 then --top of the screen
        BaseRenderPos.Y = 12
    else
        BaseRenderPos.Y = Isaac.GetScreenHeight() - 12
    end
    
    BaseRenderPos = BaseRenderPos + Offset + (Vector(12, -3) + Vector(16, 0)*TargetScale)*RenderMult

    local RenderPos = BaseRenderPos + Vector.Zero
    local TrueOffset = {}

    
    for i, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local Card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if Card then

            if mod.SelectionParams[PIndex].SelectedCards[i] and mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
                RenderPos.Y = RenderPos.Y - 8
            end
             --moves up selected cards

            mod.CardFullPoss[Pointer] = mod.CardFullPoss[Pointer] or RenderPos --check nil

            TrueOffset[Pointer] = Vector(mod:Lerp(mod.CardFullPoss[Pointer].X, RenderPos.X, mod.Counters.SinceShift/5)
                               ,mod:Lerp(mod.CardFullPoss[Pointer].Y, RenderPos.Y, mod.Counters.SinceSelect/1.25))
            

            if TrueOffset[Pointer].X == RenderPos.X and TrueOffset[Pointer].Y == RenderPos.Y then
                mod.CardFullPoss[Pointer] = RenderPos + Vector.Zero
            end


            -------------------------------------------------------------

            local Rotation = 0
            local ValueOffset = mod.Saved.Player[PIndex].CurrentHand[i+1] and Vector(-2*RenderMult,0) or Vector.Zero
            local Scale = Vector.One*ScaleMult
            local ForceCovered = false
            local Thin = false

            mod:RenderCard(Card, TrueOffset[Pointer], ValueOffset, Scale,Rotation, ForceCovered, Thin)
        end

        RenderPos = Vector(RenderPos.X + 14*ScaleMult, BaseRenderPos.Y)
    end

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        --last confirm option
        RenderPos = BaseRenderPos + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(RenderPos)


        RenderPos = BaseRenderPos + Vector(14 * (mod.SelectionParams[PIndex].Index - 1) * ScaleMult, 0)

        if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] then
            RenderPos.Y = RenderPos.Y - 8
        end

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.CardFrame)
        CardFrame:Render(RenderPos)
    else
        ------DECK RENDERING----------

        local CardsLeft = math.max((#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer)+1, 0)

        --shows how many cards are left in the deck
        DeckSprite:SetFrame("idle", math.ceil(CardsLeft/8))

        DeckSprite.Scale = Vector.One*ScaleMult

        DeckSprite:Render(BaseRenderPos - Vector(18,0)*ScaleMult)


        RenderPos = BaseRenderPos + Vector(14 * (#mod.Saved.Player[PIndex].CurrentHand - 1) * ScaleMult, 0)

        CardFrame.Scale = Vector(ScaleMult, ScaleMult)
        CardFrame:SetFrame(HUD_FRAME.CardFrame)
        CardFrame:Render(RenderPos)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, mod.JimboHandRender2)


--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboPackRender(_,_,_,_,Player)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
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

            local Rotation = 0
            local ValueOffset = Vector(0,0)
            local Scale = Vector.One
            local ForceCovered = false
            local Thin = false

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)
            local ActualRenderPos = mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10)

            mod:RenderCard(Card, ActualRenderPos, ValueOffset, Scale,Rotation, ForceCovered, Thin)
        
            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth
        end--end FOR

        CardFrame:SetFrame(HUD_FRAME.CardFrame)


    elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        
        for i,card in ipairs(mod.SelectionParams[PIndex].PackOptions) do
    
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(card.Joker).GfxFileName, false)
            TrinketSprite:ReplaceSpritesheet(2, ItemsConfig:GetTrinket(card.Joker).GfxFileName, true)
            TrinketSprite:SetFrame("Idle", 0)

            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            local TrinketPos = mod:CoolVectorLerp(PlayerPos, RenderPos + WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10)

            TrinketSprite:SetCustomShader(mod.EditionShaders[card.Edition])
            TrinketSprite:Render(TrinketPos + Vector(0, 8))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end

        CardFrame:SetFrame(HUD_FRAME.JokerFrame)


    else--TAROT, PLANET or SPECTRAL
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
            if Option == 53 then --equivalent to the soul card
                SpecialCards:SetFrame("Soul Stone",mod.SelectionParams[PIndex].Frames % 47) --sets the frame corresponding to the value and suit
            else
                SpecialCards:SetFrame("idle",  Option)
            end
            WobblyEffect[i] = Vector(0,math.sin(math.rad(mod.SelectionParams[PIndex].Frames*5+i*95))*1.5)

            SpecialCards:Render(mod:CoolVectorLerp(PlayerPos, RenderPos+WobblyEffect[i], mod.SelectionParams[PIndex].Frames/10))

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

        CardFrame:SetFrame(HUD_FRAME.CardFrame)

    end--end PURPOSES


    CardFrame.Scale = Vector.One
    CardFrame:SetFrame(HUD_FRAME.Skip)
    CardFrame:Render(RenderPos)

    RenderPos.X = BaseRenderPos.X + (mod.SelectionParams[PIndex].Index - 1)*(PACK_CARD_DISTANCE + CardHUDWidth)
    RenderPos = RenderPos + (WobblyEffect[mod.SelectionParams[PIndex].Index] or Vector.Zero)

    if TruePurpose == mod.SelectionParams.Purposes.BuffonPack then
        CardFrame:SetFrame(HUD_FRAME.JokerFrame)
        RenderPos.Y = RenderPos.Y + 8
    else
        CardFrame:SetFrame(HUD_FRAME.CardFrame)
    end
    CardFrame:Render(RenderPos)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboPackRender)


local ChargeBarWeaponTypes = WeaponModifier.CHOCOLATE_MILK | WeaponModifier.MONSTROS_LUNG | WeaponModifier.CURSED_EYE | WeaponModifier.NEPTUNUS
--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboBarRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType
       or not Options.ChargeBars then
        return
    end

    --if true then return end

    local PIndex = Player:GetData().TruePlayerIndex

    local Weapon = Player:GetWeapon(1)
    local WeaponModifiers = Player:GetWeaponModifiers()

    if Weapon and Weapon:GetWeaponType() == WeaponType.WEAPON_TEARS
       and WeaponModifiers & ChargeBarWeaponTypes == 0 then --renders a timer as a charge bar next to the player

        local TrueMadDelay = Player:GetCustomCacheValue(mod.CustomCache.HAND_COOLDOWN)
       
        local Firedelay = TrueMadDelay - math.max(Player.FireDelay, 0) -- the minimum value is -1, but that would fuck up calculations

        local Frame = math.floor(100 * Firedelay/TrueMadDelay)

        HandChargeSprite.Offset = CHARGE_BAR_OFFSET * Player.SpriteScale

        if Frame < 100 then --charging frames needed
            HandChargeSprite:SetFrame("Charging", Frame)

            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            HandChargeSprite:SetFrame(0)

        elseif HandChargeSprite:GetAnimation() ~= "Charged" then
        
            HandChargeSprite:SetAnimation("StartCharged", false)

            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))

            if Game:GetFrameCount()%2 == 0 and not Game:IsPaused() then
                --HandChargeSprite:Update()
                HandChargeSprite:SetFrame(HandChargeSprite:GetFrame()+1) --for whatever reson Update() doesn't do the job
            end

            if HandChargeSprite:GetFrame() == CHARGED_ANIMATION then
                HandChargeSprite:SetAnimation("Charged")
            end

        else
            if HandChargeSprite:GetFrame() == CHARGED_LOOP_ANIMATION then --again Update() is lazy so i loop over ir myself
                HandChargeSprite:SetFrame(0)

            elseif Game:GetFrameCount()%2 == 0 and not Game:IsPaused() then
                HandChargeSprite:SetFrame(HandChargeSprite:GetFrame()+1) --for whatever reson Update() doesn't do the job
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


---@param Player EntityPlayer
function mod:DebtIndicator(_,_,_,_,Player)

    if mod.Saved.DebtAmount <= 0 then
        return
    end

    local Coins = mod.Saved.DebtAmount
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



function mod:DiscardSwoosh(Player)
    local PIndex = Player:GetData().TruePlayerIndex

    local BaseRenderOff = Vector(-3.5 *(Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)-1), 13 )

    for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

        mod.CardFullPoss[v] = BaseRenderOff --does a cool swoosh effect
    end
end

