local mod = Balatro_Expansion
local JimboCards = {BaseCards = Sprite()
}
JimboCards.BaseCards:Load("gfx/ui/HUD/BaseCards.anm2", true)
local ENHANCEMENTS_ANIMATIONS = {"Base","Mult"}
local DISCARD_MAX_COOLDOWN = 75

local HandHoldingFrames = 0
local IsSelectingcard = false
local SelectedCards = {false,false,false,false,false}
local SelectIndex = 1
local SelectionMode = 0
local SelectionModes = {}
SelectionModes.HAND = 0
SelectionModes[Card.CARD_FOOL] = Card.CARD_FOOL
SelectionModes[Card.CARD_MAGICIAN] = Card.CARD_MAGICIAN
SelectionModes[Card.CARD_HIGH_PRIESTESS] = Card.CARD_HIGH_PRIESTESS
SelectionModes[Card.CARD_EMPRESS] = Card.CARD_EMPRESS
SelectionModes[Card.CARD_EMPEROR] = Card.CARD_EMPEROR
SelectionModes[Card.CARD_HIEROPHANT] = Card.CARD_HIEROPHANT




local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local DiscardChargeSprite = Sprite("gfx/chargebar.anm2")
local HandChargeSprite = Sprite("gfx/chargebar.anm2")
local CardFrame = Sprite("gfx/ui/HUD/CardSelection.anm2")
CardFrame:SetAnimation("Frame")
local HUD_FRAME = {}
HUD_FRAME.Frame = 0
HUD_FRAME.Arrow = 1
HUD_FRAME.Hand = 2
HUD_FRAME.Confirm = 3
local CardHUDWidth = 19

local BasicRoomNum = 0

local ShopAddedThisFloor = false

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
    HandChargeSprite:SetAnimation("Charging")
end

--local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
--local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root
local Game = Game()
local ItemPool = Game:GetItemPool()

--------------HUD RENDER-----------------
-----------------------------------------


--renders the deck overlay and replaces the hearts
---@param Player EntityPlayer
function mod:PlayerHeartsRender(_,HeartSprite,Position,HasCoTU,Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        --local Pindex = Player:GetPlayerIndex()

        ----DECK RENERING----
        JimboCards.BaseCards.Scale = Vector.One
        for i, Pointer in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
            local Card = mod.SavedValues.Jimbo.FullDeck[Pointer]
            if Card then
                if SelectedCards[i] then
                    JimboCards.BaseCards.Offset = Vector(50 + 19 * i, -3)
                else
                    JimboCards.BaseCards.Offset = Vector(50 + 19 * i, 7)
                end
                --SEE THE anm2 FILE TO UNDERSTAND BETTER THIS PART--
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                -------------------------------------------------------------
                --JimboCards.BaseCards.Color.A = JimboCards.BaseCards.Color.A / i --reduces the transparency based on its order position
                
                --JimboCards.BaseCards:Render(Isaac.WorldToRenderPosition(Player.Position))
                JimboCards.BaseCards:Render(Position)
                --150 // 10.4
                --360//122
                --JimboCards.BaseCards.Color:Reset()
            end
        end

        if IsSelectingcard then
            local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
            if MousePosition.X >= 120 and MousePosition.Y <= 45 then
                local HandMousePosition = math.ceil((MousePosition.X - 120)/CardHUDWidth)
                if HandMousePosition <= #mod.SavedValues.Jimbo.CurrentHand + 1 then
                    SelectIndex = HandMousePosition
                end
            end


            if SelectedCards[SelectIndex] then
                CardFrame.Offset = Vector(50 + 19 * SelectIndex, -3)
                JimboCards.BaseCards.Offset = Vector(50 + 19 * SelectIndex, -3)
            else
                CardFrame.Offset = Vector(50 + 19 * SelectIndex, 7)
                JimboCards.BaseCards.Offset = Vector(50 + 19 * SelectIndex, 7)   
            end
            local Card = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[SelectIndex]]
            if Card then
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false)
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1)
                JimboCards.BaseCards:Render(Position)
            end
            CardFrame:SetFrame(HUD_FRAME.Frame)
            CardFrame:Render(Position)

            CardFrame.Offset = Vector(50 + 19 * (#mod.SavedValues.Jimbo.CurrentHand + 1), 7)
            CardFrame:SetFrame(HUD_FRAME.Hand)
            CardFrame:Render(Position)
        end

        if Minimap:GetState()== MinimapState.NORMAL then
            if not mod.SavedValues.Jimbo.SmallCleared then
                mod.Fonts.upheavalmini:DrawString(tostring(mod.SavedValues.Jimbo.ClearedRooms).."/"..tostring(mod.SavedValues.Jimbo.SmallBlind),Position.X  + 320 + Minimap:GetShakeOffset().X,Position.Y + Minimap:GetShakeOffset().Y,KColor(1,1,1,1))
                --mod.Fonts.upheavalmini:DrawString(tostring(ClearedRooms).."/"..tostring(BigBlind),Isaac.WorldToScreen(Player.Position).X+20,Isaac.WorldToScreen(Player.Position).Y+30,KColor(1,1,1,1))        

            elseif not mod.SavedValues.Jimbo.BigCleared then
                mod.Fonts.upheavalmini:DrawString(tostring(mod.SavedValues.Jimbo.ClearedRooms).."/"..tostring(mod.SavedValues.Jimbo.BigBlind),Position.X  + 320 + Minimap:GetShakeOffset().X,Position.Y + Minimap:GetShakeOffset().Y,KColor(1,1,1,1))        
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.PlayerHeartsRender)


--renders the CurrentHand table as cards on top of the active
function mod:OnJimboPocketRender(Player,ItemSlot,Position,_,Scale)
    if ItemSlot == ActiveSlot.SLOT_PRIMARY then
        ----HAND RENDERING----
        JimboCards.BaseCards.Scale = Vector(0.8,0.8) * Scale

        if Scale < 1 then --scale is lower if it's in a seconary slot
            JimboCards.BaseCards.Color.A = 0.5
        end
        for i=1, 5, 1 do --cycles between cards the plyer's hand
            local Card = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]]
            if Card then
                JimboCards.BaseCards.Offset = Vector(-30 + 13 * i, -15) * Scale
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the suit of the rendered card
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the value of the randered card

                JimboCards.BaseCards:Render(Position)
            end
        end
        JimboCards.BaseCards.Color:Reset()
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.OnJimboPocketRender)

--handles the charge bar and the isHoldingCard variable basin on the player's animation
---@param Player EntityPlayer
function mod:OnJimboRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
  
    if IsSelectingcard then
        --renders a timer as a charge bar next to the player
        local Frame = HandChargeSprite:GetFrame()
        --makes the bar flicker more as the timer runs out
        if Frame < 40 then
            if Frame % 3 ~=0 then
                HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end

        elseif Frame < 66 then
            if Frame % 5 ~= 0 then
                HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        else
            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
        end
    end


    DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.OnJimboRender)


---------------PLAYER MECHANICS----------------------
-----------------------------------------------------

--code for using The Hand
---@param player EntityPlayer
function mod:TheHandUse(_,_, player, _,_,_)
    if player:GetPlayerType() == mod.Characters.JimboType then
    if not IsSelectingcard then
        --mod:SwitchCardSelectionStates(false,0)

        --IsSelectingcard = false
        --Game:GetRoom():SetPauseTimer(0)
    
        mod:SwitchCardSelectionStates(true,0)
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
    --[[
    if mod.SavedValues.Jimbo.DeckPointer <= #mod.SavedValues.Jimbo.FullDeck then
        mod:AddCardToHand(mod.SavedValues.Jimbo.CurrentHand, mod.SavedValues.Jimbo.DeckPointer)
        
        local Card = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.DeckPointer]
        local CardSprite = JimboCards.BaseCards

        CardSprite:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement])
        CardSprite:SetFrame(4 * (Card.Value - 1) + Card.Suit-1)
        player:AnimatePickup(CardSprite, true, "HideItem")

        mod.SavedValues.Jimbo.DeckPointer = mod.SavedValues.Jimbo.DeckPointer + 1
        Isaac.RunCallback("DECK_SHIFT")
    end]]--
                
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHandUse, CollectibleType.COLLECTIBLE_THE_HAND)


--allows jimbo to shoot
---@param Player EntityPlayer
function mod:OnJimboUpdate(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local Data = Player:GetData()

        -----------DISCARD COOLDOWN-------------
        if Data.DiscardCooldown <= 91 then
            Data.DiscardCooldown = Data.DiscardCooldown + 1
        else
            Data.DiscardCooldown = 86
        end

        --0 ~ 40 --progress bar is charging
        --40 ~ 51 -- initial animation for fully charged bar
        --51 ~ XX -- fully charged loop
        if Data.DiscardCooldown < DISCARD_MAX_COOLDOWN then --charging frames needed

            DiscardChargeSprite:SetAnimation("Charging")
            DiscardChargeSprite:SetFrame(math.floor(Data.DiscardCooldown * 1.33))

        elseif Data.DiscardCooldown < DISCARD_MAX_COOLDOWN + 11 then --Charging frames + StartCharged frames
            DiscardChargeSprite:SetAnimation("StartCharged")
            DiscardChargeSprite:SetFrame(Data.DiscardCooldown - DISCARD_MAX_COOLDOWN)

        else
            DiscardChargeSprite:SetAnimation("Charged")
            DiscardChargeSprite:SetFrame(Data.DiscardCooldown - (DISCARD_MAX_COOLDOWN + 16))
        end

        ----------SELECTION INPUT / INPUT COOLDOWN------------
        if IsSelectingcard then --while in the card selection menu
            
            --------------HAND SELECTION COOLDOWN------------------
            HandHoldingFrames = HandHoldingFrames + 1
            HandChargeSprite:SetFrame(100 - math.ceil(HandHoldingFrames/3))

            if HandChargeSprite:GetFrame() == 0 then
                mod:UseSelection()
                mod:SwitchCardSelectionStates(false,nil)
                sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE)
            end
        
            -------------INPUT HANDLING-------------------
            if Data.Cooldown >= 8 then --applies a small cooldown to the inputs
                
                --confirming/canceling
                if (Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)) or Input.IsMouseBtnPressed(MouseButton.LEFT) then
                    --selecting a card
                    if SelectIndex <= #mod.SavedValues.Jimbo.CurrentHand then
                        SelectedCards[SelectIndex] = not SelectedCards[SelectIndex]
                    --confirming the selection of cards
                    else
                        mod:UseSelection()
                        mod:SwitchCardSelectionStates(false,0)
                    end
                    Data.Cooldown = 0
                
                --pressing left moving the selection
                elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) and SelectIndex > 1 then
                    SelectIndex = SelectIndex - 1
                    Data.Cooldown = 0

                --pressing right moving the selection
                elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) and SelectIndex <= #mod.SavedValues.Jimbo.CurrentHand then
                    SelectIndex = SelectIndex + 1
                    Data.Cooldown = 0                
                end

            end
            Player.Velocity = Vector.Zero
        else
            HandHoldingFrames = 0
        end
        Data.Cooldown = Data.Cooldown + 1
        -----------SHOOTING HANDLING---------------
        local AimDirection = Player:GetAimDirection()
        if Data.DiscardCooldown >= DISCARD_MAX_COOLDOWN and (AimDirection.X ~= 0 or AimDirection.Y ~= 0) and Data.Cooldown >= 8 then
            
            mod:JimboShootCardTear(Player, AimDirection)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnJimboUpdate)

--makes every item a paid shop item (also see set item prices)
---@param Pickup EntityPickup
function mod:SetItemAsShop(Pickup)
    if not Pickup:IsShopItem() then
        Pickup:MakeShopItem(-1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.SetItemAsShop, PickupVariant.PICKUP_COLLECTIBLE)

--sets the price for every item basing on quality and room
function mod:SetItemPrices(Variant,SubType,_,Price)
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local Quality = ItemsConfig:GetCollectible(SubType).Quality
        return (Quality+2)*2

    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.SetItemPrices)

--madifies the floor generation and calculates the number of normal rooms
---@param RoomConfig RoomConfigRoom
---@param RoomLevel LevelGeneratorRoom
function mod:FloorModifier(RoomLevel,RoomConfig,Seed)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        --changes all the shops and treasures with Tkeeper's shops
        if RoomConfig.Type == RoomType.ROOM_TREASURE or RoomConfig.Type == RoomType.ROOM_SHOP then
            --varies a bit the "quality" of the shop used
            local RoomRNG = RNG(Seed)
            local ChosenSubType = RoomRNG:RandomInt(RoomSubType.SHOP_KEEPER_LEVEL_3-1, RoomSubType.SHOP_KEEPER_LEVEL_5)
        
            local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ChosenSubType)

            return NewRoom --replaces the room with the new one

        elseif RoomConfig.Type == RoomType.ROOM_DEFAULT and (RoomLevel:Column() + RoomLevel:Row()*13 ~= Game:GetLevel():GetStartingRoomIndex())  then
            --adds a shop in floors where there usually wouldn't be
            if not mod:FloorHasShopOrTreasure().Shop and RoomLevel:IsDeadEnd() and not ShopAddedThisFloor and RoomLevel:Shape()==RoomShape.ROOMSHAPE_1x1 then
                local RoomRNG = RNG(Seed)
                local ChosenSubType = RoomRNG:RandomInt(RoomSubType.SHOP_KEEPER_LEVEL_3-1, RoomSubType.SHOP_KEEPER_LEVEL_5)
                
                local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ChosenSubType)
                ShopAddedThisFloor = true
                return NewRoom --replaces the room with the new one
            end
            
            BasicRoomNum = BasicRoomNum + 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, mod.FloorModifier)

--calculates how big the blinds are 
function mod:CalculateBlinds()
    --print(Game:GetLevel():GetCurrentRoomDesc().Data.Difficulty)
    if BasicRoomNum < 40 then
        BasicRoomNum = math.ceil(BasicRoomNum * (1 - BasicRoomNum/100))
    else
        BasicRoomNum = BasicRoomNum * 0.60
    end
    mod.SavedValues.Jimbo.SmallBlind = math.ceil(BasicRoomNum/3) --1/3 of the rooms
    mod.SavedValues.Jimbo.BigBlind = BasicRoomNum - mod.SavedValues.Jimbo.SmallBlind --2/3 of the rooms
    
    BasicRoomNum = 0 --resets the counter
    ShopAddedThisFloor = false
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.CalculateBlinds)

--handles the rooms which cleared by default 
function mod:NoHarmRooms()
    local Desc = Game:GetLevel():GetCurrentRoomDesc()
    
    if Desc.VisitedCount == 1 and Desc.Clear and Desc.GridIndex ~= Game:GetLevel():GetStartingRoomIndex() then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",false)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NoHarmRooms)

--handles the shooting considering the possible ammount of tears fired
---@param Player EntityPlayer
---@param Direction Vector
function mod:JimboShootCardTear(Player,Direction)
    Data = Player:GetData()
    Data.DiscardCooldown = 0
    local ShotParams = Player:GetMultiShotParams()

    local MaxSpread = ShotParams:GetSpreadAngle(WeaponType.WEAPON_TEARS) --half the total angle the tears spread 
    local EyeAngle = ShotParams:GetMultiEyeAngle() --angle used to determine if player has Wiz or not
    local NumTears = ShotParams:GetNumTears() --tears the player fires simultaneusly
    local NumLanes = ShotParams:GetNumLanesPerEye() --similar to numtears, but dicates how the tears get shot

    local Spread = 0
    if NumLanes > 1 then
        Spread = (MaxSpread / (ShotParams:GetNumLanesPerEye() - 1)) * 2
    end
    if EyeAngle == 45 then --if player has the wiz
        for i=1,-1,-2 do 
            local BaseAngle = EyeAngle * i --sets +45° and -45° as the base angle

            for j=0, NumTears/2 -1 do --for each eye
                --modifies additionally the angle if you also have stuff like QuadShot
                local FireAngle = (BaseAngle+(MaxSpread - Spread*j)) + Direction:GetAngleDegrees()
                local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10*Player.ShotSpeed

                local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
                local TearData = Tear:GetData()
                TearData.Enhancement = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.DeckPointer].Enhancement
                mod:AddCardTearFalgs(Tear)
            end
        end
    else
        for i=0, NumTears-1 do
            local FireAngle = (MaxSpread - Spread*i) + Direction:GetAngleDegrees()
            local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10*Player.ShotSpeed

            local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
            local TearData = Tear:GetData()
            TearData.Enhancement = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.DeckPointer].Enhancement
            mod:AddCardTearFalgs(Tear)
        end
    end
    local Value = mod:GetActualCardValue(mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.DeckPointer].Value)
    mod:IncreaseJimboStats(CacheFlag.CACHE_FIREDELAY, Value / 100)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

    mod:AddCardToHand( mod.SavedValues.Jimbo.CurrentHand, mod.SavedValues.Jimbo.DeckPointer)
    mod.SavedValues.Jimbo.DeckPointer = mod.SavedValues.Jimbo.DeckPointer + 1
    Isaac.RunCallback("DECK_SHIFT")
    
end


function mod:AddRoomsCleared(IsBoss)
    if IsBoss and not mod.SavedValues.Jimbo.BossCleard then
        Isaac.RunCallback("MONEY_REWARDS", mod.BLINDS.BOSS)
        mod.SavedValues.Jimbo.BossCleard = true
    else
        mod.SavedValues.Jimbo.ClearedRooms = mod.SavedValues.Jimbo.ClearedRooms + 1
        if mod.SavedValues.Jimbo.ClearedRooms == mod.SavedValues.Jimbo.SmallBlind and not mod.SavedValues.Jimbo.SmallCleared then
            Isaac.RunCallback("MONEY_REWARDS", mod.BLINDS.SMALL)
            mod.SavedValues.Jimbo.SmallCleared = true
            mod.SavedValues.Jimbo.ClearedRooms = 0
        elseif mod.SavedValues.Jimbo.ClearedRooms == mod.SavedValues.Jimbo.BigBlind and not mod.SavedValues.Jimbo.BigCleared then
            Isaac.RunCallback("MONEY_REWARDS", mod.BLINDS.BIG)
            mod.SavedValues.Jimbo.BigCleared = true
            mod.SavedValues.Jimbo.ClearedRooms = 0
        end
    end
end
mod:AddCallback("TRUE_ROOM_CLEAR", mod.AddRoomsCleared)


--activates whenever the deckpointer is shifted
function mod:OnDeckShift()
    if mod.SavedValues.Jimbo.DeckPointer > #mod.SavedValues.Jimbo.FullDeck then
        for _,Player in ipairs(PlayerManager:GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType then
                Player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL, EntityRef(Player), 0)
                local HandRNG = Player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
                mod.SavedValues.Jimbo.FullDeck = mod:Shuffle(mod.SavedValues.Jimbo.FullDeck, HandRNG)
                mod.SavedValues.Jimbo.DeckPointer = 1
            end
        end
    end
end
mod:AddCallback("DECK_SHIFT", mod.OnDeckShift)

function mod:GiveRewards(BlindType)
    print(BlindType)
    local Seed = Game:GetSeeds():GetStartSeed()
    local Jimbo

    --calculates the ammount of interests BEFORE giving the clear money
    local Interests = math.floor(Game:GetPlayer(0):GetNumCoins()/5)
    if Interests > 5 then
        Interests = 5
    end
    --gives coins basing on the blind cleared and finds jimbo
    for _,Player in ipairs(PlayerManager:GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then
            Jimbo = Player
            if BlindType == mod.BLINDS.SMALL then
                Player:AddCoins(3)
                Balatro_Expansion:EffectConverter(9, 3,Player,4)
            elseif BlindType == mod.BLINDS.BIG then
                Player:AddCoins(4)
                Balatro_Expansion:EffectConverter(9, 3,Player,4)
            elseif BlindType == mod.BLINDS.BOSS then
                Player:AddCoins(5)
                Balatro_Expansion:EffectConverter(9, 3,Player,4)
            end
        end
    end
    --gives interest
    Isaac.CreateTimer(function ()
        for i = 1, Interests, 1 do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Jimbo.Position , RandomVector() * 4, Jimbo, CoinSubType.COIN_PENNY, Seed)
            Balatro_Expansion:EffectConverter(8,0,Jimbo,4)
        end 
    end, 21, 1, true)
end
mod:AddCallback("MONEY_REWARDS", mod.GiveRewards)


function mod:SwitchCardSelectionStates(NextState,NewSelectionMode)

    if NextState then
        if IsSelectingcard then
            mod:UseSelection()
        end
        SelectIndex = 1
        Game:GetRoom():SetPauseTimer(600)
    else
        SelectIndex = 0
        Game:GetRoom():SetPauseTimer(0)
    end

    SelectionMode = NewSelectionMode
    IsSelectingcard = NextState
end

function mod:UseSelection()
    print("Selection Used")
    if SelectionMode == SelectionModes.HAND then
        mod:SubstituteCards(SelectedCards)
        --effects
    else
        mod:AddCardsEffects(SelectedCards)
    end
    for i=1,#SelectedCards do
        SelectedCards[i] = false
    end
end

function mod:AddCardsEffects(ChosenCards)
    for i=#ChosenCards, 1, -1 do
        if ChosenCards[i] then
            mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Enhancement = 2
        end
    end
end


-----------------------JIMBO STATS-----------------------
----------------------------------------------------------

---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboStatCalculator(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local AddedDamage = Player.Damage - 1

        if AddedDamage >= 0 then
            Player.Damage = AddedDamage * 0.2 + 1
        else
            Player.Damage = AddedDamage + 1
        end
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        --Player.MaxFireDelay = Player.MaxFireDelay - 1
        --Player.MaxFireDelay = Player.MaxFireDelay * 3
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
        if Player.Damage < 0.35 then
            Player.Damage = 0.35
        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.Damage = 4.5 / Tears
        end]]--
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local Tears = mod:CalculateTearsValue(Player)
        if Tears < 1 then
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(1)

        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.MaxFireDelay =  mod:CalculateMaxFireDelay(4.5 / Player.Damage)
        end]]--
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.JimboMinimumStats)


function mod:StatReset(Player, Cache)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            mod.SavedValues.Jimbo.StatsToAdd.Damage = 0
        end
        if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            mod.SavedValues.Jimbo.StatsToAdd.Tears = 0
        end
    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.StatReset)

function mod:StatGiver(Player, Cache)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        
        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            Player.Damage = Player.Damage + mod.SavedValues.Jimbo.StatsToAdd.Damage * Player.Damage
        end
        if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            print(mod.CalculateTearsValue(Player.MaxFireDelay))
            Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, mod.SavedValues.Jimbo.StatsToAdd.Tears * mod:CalculateTearsValue(Player))
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.StatGiver)


-------------CARD TEARS-----------------------
----------------------------------------------

--applies the additional effects for the card tears
---@param Tear EntityTear
---@param Collider Entity
function mod:OnTearCardCollision(Tear,Collider,_)
    if not mod:Contained(mod.CARD_TEAR_VARIANTS, Tear.Variant) then
        return
    end

    if Collider:IsActiveEnemy() then
        local TearRNG = Tear:GetDropRNG()
        if Tear.Variant == mod.CARD_TEAR_VARIANTS[mod.Suits.Heart] then --Hearts
            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Tear.Position, Vector.Zero, Tear, 0, TearRNG:GetSeed()):ToEffect()
            Creep.SpriteScale = Vector(1.2,1.2)
            ---@diagnostic disable-next-line: need-check-nil
            Creep:Update()
            if TearRNG:RandomFloat() < 0.2 then
                Collider:AddCharmed(EntityRef(Tear.Parent), 120)
            end
        end
        if Tear.Variant == mod.CARD_TEAR_VARIANTS[mod.Suits.Club] then --Clubs
            if TearRNG:RandomFloat() < 0.2 then
                Game:BombExplosionEffects(Tear.Position, Tear.CollisionDamage / 2, TearFlags.TEAR_NORMAL, Color.Default, Tear.Parent, 0.5)
                --Isaac.Explode(Tear.Position, Tear, Tear.CollisionDamage / 2)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.OnTearCardCollision)


--adjusts the card rotation basing on its movement every few frames
---@param Tear EntityTear
function mod:AdjustCardRotation(Tear)
    local Data = Tear:GetData()
    local TearSprite = Tear:GetSprite()

    if not Data.Counter then
        Data.Counter = 2
    end
    if Data.Counter == 2 then
        TearSprite.Rotation = Tear.Velocity:GetAngleDegrees()
        --TearSprite.Rotation = math.deg(math.atan(Tear.Velocity.Y,Tear.Velocity.X))
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

---@param Tear EntityTear
function mod:AddCardTearFalgs(Tear)
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

        local TearSuit = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.DeckPointer].Suit
        Tear:ChangeVariant(mod.CARD_TEAR_VARIANTS[TearSuit])

        if TearSuit == mod.Suits.Spade then --SPADES
            Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        elseif TearSuit == mod.Suits.Diamond then
            Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
            Tear:AddTearFlags(TearFlags.TEAR_BOUNCE)
        end

        local TearSprite = Tear:GetSprite()
        TearSprite:Play("Mult", true)
    end
end


------------------VARIOUS/UTILITY------------------
------------------------------------------------


---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.JimboType then
        local Data = player:GetData()
        Data.DiscardCooldown = 0
        Data.Cooldown = 0
        ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)


--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local HandRNG = Player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
        mod.SavedValues.Jimbo.FullDeck = mod:Shuffle(mod.SavedValues.Jimbo.FullDeck, HandRNG)
        mod.SavedValues.Jimbo.DeckPointer = 1
        mod.SavedValues.Jimbo.CurrentHand = {0,0,0,0,0}
    end
    local Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_DEFAULT then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",false)
    elseif Room == RoomType.ROOM_BOSS then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.FullDeckShuffle)
