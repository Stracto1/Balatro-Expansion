local mod = Balatro_Expansion
local JimboCards = {PlayingCards = Sprite() , R_PlayingCards = Sprite()
}
JimboCards.PlayingCards:Load("gfx/ui/HUD/PlayingCards.anm2", true)
JimboCards.R_PlayingCards:Load("gfx/ui/HUD/ReadableCards.anm2", true)

local ENHANCEMENTS_ANIMATIONS = {"Base","Mult"}
local HAND_TYPE_NAMES = {"high card","pair","Two pair","three of a kind","straight","flush","full house","four of a kind", "straight flush", "royal flush","five of a kind","fluah house","flush five"}
HAND_TYPE_NAMES[0] = "none"

local HandCooldown = 75  -- can be changed to lower/increase the charge time
local CHARGED_ANIMATION = 11 --the length of an animation for chargebars
local CHARGED_LOOP_ANIMATION = 5

local DECK_RENDERING_POSITION = Vector(10,247) --in screen coordinates
--local DECK_RENDERING_POSITION = Isaac.WorldToRenderPosition(Isaac.ScreenToWorld(Vector(760,745)))


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
local PACK_CARD_DISTANCE = 9

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

---@param Player EntityPlayer
function mod:PlayerHeartsRender(_,HeartSprite,Position,HasCoTU,Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
    
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.PlayerHeartsRender)



function mod:OnJimboPocketRender(Player,ItemSlot,Position,_,Scale)
    if ItemSlot == ActiveSlot.SLOT_POCKET then 

        

        
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.OnJimboPocketRender)

--renders the entirety of the extra HUD for Jimbo
function mod:JimboDeckHUD()
    ----DECK RENERING----
    for i, Pointer in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
        local Card = mod.SavedValues.Jimbo.FullDeck[Pointer]
        if Card then
            local RenderPos = DECK_RENDERING_POSITION + Vector(19 * i, 0)
            
            if mod.CardSelectionParams.SelectedCards[i] then
                RenderPos.Y = -10 --moves up selected cards
            end

            if mod.SavedValues.ModConfig.ExtraReadability then
            --SEE THE anm2 FILE TO UNDERSTAND BETTER THIS PART--
                JimboCards.R_PlayingCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.R_PlayingCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                -------------------------------------------------------------
                JimboCards.R_PlayingCards:Render(RenderPos)
            else
                JimboCards.PlayingCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.PlayingCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                -------------------------------------------------------------
                JimboCards.PlayingCards:Render(RenderPos)
            --150 // 10.4
            --360//122
            end
        end
    end

    if mod.CardSelectionParams.IsSelecting and mod.CardSelectionParams.Mode == mod.CardSelectionParams.SelectionModes.HAND then
        
        local RenderPos = DECK_RENDERING_POSITION + Vector(19 * mod.CardSelectionParams.Index, 0)
        
        --re-renders the currently indexed card so it goes over the others--
        if mod.CardSelectionParams.SelectedCards[mod.CardSelectionParams.Index] then

            RenderPos.Y = -10
            
            local Card = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[mod.CardSelectionParams.Index]]
            if Card then
                if mod.SavedValues.ModConfig.ExtraReadability then
                    --SEE THE anm2 FILE TO UNDERSTAND BETTER THIS PART--
                    JimboCards.R_PlayingCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                    JimboCards.R_PlayingCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                    -------------------------------------------------------------
                    JimboCards.R_PlayingCards:Render(RenderPos)
                else
                    JimboCards.PlayingCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false)
                    JimboCards.PlayingCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1)

                    JimboCards.PlayingCards:Render(RenderPos)
                end
            end
        end
        
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = DECK_RENDERING_POSITION + Vector(19 * (#mod.SavedValues.Jimbo.CurrentHand + 1), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(RenderPos)

        --HAND TYPE TEXT RENDER--
        mod.Fonts.upheavalmini:DrawString(HAND_TYPE_NAMES[mod.CardSelectionParams.HandType],DECK_RENDERING_POSITION.X + 50,DECK_RENDERING_POSITION.Y -100,KColor(1,1,1,1))

        --allows mouse controls to be used as a way to select cards--
        local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
        if MousePosition.X >= DECK_RENDERING_POSITION.X and MousePosition.Y >= DECK_RENDERING_POSITION.Y  then
            local HandMousePosition = math.ceil((MousePosition.X - (DECK_RENDERING_POSITION.X))/CardHUDWidth)
            if HandMousePosition <= #mod.SavedValues.Jimbo.CurrentHand + 1 then
                mod.CardSelectionParams.Index = HandMousePosition
            end
        end
    else
        local CardsLeft = (#mod.SavedValues.Jimbo.FullDeck - mod.SavedValues.Jimbo.DeckPointer) + 1
        --shows how many cards are left in the deck
        if CardsLeft > 0 then
        local RenderPos = DECK_RENDERING_POSITION + Vector(19 * (#mod.SavedValues.Jimbo.CurrentHand + 1) -7,-3)
            mod.Fonts.upheavalmini:DrawString("+"..tostring(CardsLeft),RenderPos.X + Minimap:GetShakeOffset().X,RenderPos.Y + Minimap:GetShakeOffset().Y,KColor(1,1,1,1))

        end
    end

    --BLIND COUNTER--
    if Minimap:GetState()== MinimapState.NORMAL then
        if not mod.SavedValues.Jimbo.SmallCleared then
            mod.Fonts.upheavalmini:DrawString(tostring(mod.SavedValues.Jimbo.ClearedRooms).."/"..tostring(mod.SavedValues.Jimbo.SmallBlind),320 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,KColor(1,1,1,1))
            --mod.Fonts.upheavalmini:DrawString(tostring(ClearedRooms).."/"..tostring(BigBlind),Isaac.WorldToScreen(Player.Position).X+20,Isaac.WorldToScreen(Player.Position).Y+30,KColor(1,1,1,1))        

        elseif not mod.SavedValues.Jimbo.BigCleared then
            mod.Fonts.upheavalmini:DrawString(tostring(mod.SavedValues.Jimbo.ClearedRooms).."/"..tostring(mod.SavedValues.Jimbo.BigBlind),320 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,KColor(1,1,1,1))        
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_HUD_RENDER,CallbackPriority.LATE, mod.JimboDeckHUD)


--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboPackRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    if mod.CardSelectionParams.IsSelecting then

        if mod.CardSelectionParams.Mode == mod.CardSelectionParams.SelectionModes.PackSelection then
            --SHOWS THE CHOICES AVAILABLE
            local PlayerPos = Isaac.WorldToScreen(Player.Position)

            for i,Card in ipairs(mod.CardSelectionParams.PackOptions) do

            local RenderPosition = Vector(0,0)
            RenderPosition.X = ((PlayerPos.X - CardHUDWidth * #mod.CardSelectionParams.PackOptions /2) + PACK_CARD_DISTANCE * (i - #mod.CardSelectionParams.PackOptions + 1 )) + CardHUDWidth * (i-1)
            RenderPosition.X = RenderPosition.X + 9.5
            RenderPosition.Y = PlayerPos.Y + 20

            if mod.SavedValues.ModConfig.ExtraReadability then
                JimboCards.R_PlayingCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.R_PlayingCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit

                JimboCards.R_PlayingCards:Render(RenderPosition)
            else
                JimboCards.PlayingCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.PlayingCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit

                JimboCards.PlayingCards:Render(RenderPosition)
            end

            if i == mod.CardSelectionParams.Index then
                --RENDERS THE SELECTOR
                CardFrame:SetFrame(HUD_FRAME.Frame)
                CardFrame:Render(RenderPosition)

            end
            end
        end
        --[[
        --renders a timer as a charge bar next to the player
        mod.CardSelectionParams.Frames = mod.CardSelectionParams.Frames + 1
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
    else
        mod.CardSelectionParams.Frames = 0]]--
    end

    


    DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JimboPackRender)


---------------PLAYER MECHANICS----------------------
-----------------------------------------------------

--code for using The Hand
---@param player EntityPlayer
function mod:TheHandUse(_,_, player, _,_,_)
    print("hand")
    if player:GetPlayerType() == mod.Characters.JimboType then
        if not mod.CardSelectionParams.IsSelecting then

            --IsSelectingcard = false
            --Game:GetRoom():SetPauseTimer(0)
    
            mod:SwitchCardSelectionStates(player,true,0)
            player:AnimateCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
        end
       
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHandUse, CollectibleType.COLLECTIBLE_THE_HAND)


--allows jimbo to shoot
---@param Player EntityPlayer
function mod:OnJimboUpdate(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local Data = Player:GetData()

    -----------DISCARD COOLDOWN-------------
    if Data.PlayCooldown <= HandCooldown + CHARGED_ANIMATION + CHARGED_LOOP_ANIMATION then
        Data.PlayCooldown = Data.PlayCooldown + 1
    else
        Data.PlayCooldown = HandCooldown + CHARGED_ANIMATION
    end

    if Data.PlayCooldown < HandCooldown then --charging frames needed

        DiscardChargeSprite:SetAnimation("Charging")
        DiscardChargeSprite:SetFrame(math.floor(Data.PlayCooldown * 1.33))

    elseif Data.PlayCooldown < HandCooldown + CHARGED_ANIMATION then --Charging frames + StartCharged frames
        DiscardChargeSprite:SetAnimation("StartCharged")
        DiscardChargeSprite:SetFrame(Data.PlayCooldown - HandCooldown)

    else
        DiscardChargeSprite:SetAnimation("Charged")
        DiscardChargeSprite:SetFrame(Data.PlayCooldown - (HandCooldown + CHARGED_ANIMATION + CHARGED_LOOP_ANIMATION))
    end

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    if mod.CardSelectionParams.IsSelecting then --while in the card selection menu
        
        --------------HAND SELECTION COOLDOWN------------------
        HandHoldingFrames = HandHoldingFrames + 1
        HandChargeSprite:SetFrame(100 - math.ceil(HandHoldingFrames/3))

        if HandChargeSprite:GetFrame() == 0 then
            mod:SwitchCardSelectionStates(Player,false,nil)
            sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE)
        end
    
        -------------INPUT HANDLING-------------------
        if Data.Cooldown >= 8 then --applies a small cooldown to the inputs
            
            --confirming/canceling
            if (Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)) or Input.IsMouseBtnPressed(MouseButton.LEFT) then
                print("Button")
                mod:Select(Player)

                Data.Cooldown = 0
            --pressing left moving the selection
            elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) and mod.CardSelectionParams.Index > 1 then
                mod.CardSelectionParams.Index = mod.CardSelectionParams.Index - 1
                Data.Cooldown = 0

            --pressing right moving the selection
            elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) and mod.CardSelectionParams.Index <= mod.CardSelectionParams.OptionsNum then
                mod.CardSelectionParams.Index = mod.CardSelectionParams.Index + 1
                Data.Cooldown = 0
            end

        end
        Player.Velocity = Vector.Zero

    else --not selecting anything
        HandHoldingFrames = 0

            -----------SHOOTING HANDLING---------------
        local AimDirection = Player:GetAimDirection()
        if Data.PlayCooldown >= HandCooldown and (AimDirection.X ~= 0 or AimDirection.Y ~= 0) and Data.Cooldown >= 8 then
            
            mod:JimboShootCardTear(Player, AimDirection)
        end
    end
    Data.Cooldown = Data.Cooldown + 1

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnJimboUpdate)

---@param Pickup EntityPickup
function mod:ShopItemChanger(Pickup, Variant, SubType, ReqVariant, ReqSubType, RNG)
    print("si")
    if ReqSubType == 0 or ReqVariant == 0 then
        print("ok")
        if Pickup:IsShopItem() then
            print("shop:"..tostring(Pickup.ShopItemId))
            if Pickup.ShopItemId == 0 then
                return{100,169,true}
            end
            if Pickup.ShopItemId == 2 then
                return{100,1,false}
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, mod.ShopItemChanger)



--makes every item a paid shop item (also see SetItemPrices)
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
        local RoomIndex = RoomLevel:Column() + RoomLevel:Row()*13
        if RoomConfig.Type == RoomType.ROOM_TREASURE or RoomConfig.Type == RoomType.ROOM_SHOP then
            
            local RoomDesc = Game:GetLevel():GetRoomByIdx(RoomIndex)
            RoomDesc.DisplayFlags = 1 << 2 | 1 << 0 --shows the room

            print(RoomDesc.DisplayFlags)
            --varies a bit the "quality" of the shop used
            local RoomRNG = RNG(Seed)
            --local ChosenSubType = RoomRNG:RandomInt(RoomSubType.SHOP_KEEPER_LEVEL_3-1, RoomSubType.SHOP_KEEPER_LEVEL_5)
            local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, RoomSubType.SHOP_KEEPER_LEVEL_5)

            return NewRoom --replaces the room with the new one

        elseif RoomConfig.Type == RoomType.ROOM_DEFAULT and (RoomIndex ~= Game:GetLevel():GetStartingRoomIndex())  then
            --adds a shop in floors where there usually wouldn't be
            if not mod:FloorHasShopOrTreasure().Shop and RoomLevel:IsDeadEnd() and not ShopAddedThisFloor and RoomLevel:Shape()==RoomShape.ROOMSHAPE_1x1 then
                local RoomRNG = RNG(Seed)
                local ChosenSubType = RoomRNG:RandomInt(RoomSubType.SHOP_KEEPER_LEVEL_3-1, RoomSubType.SHOP_KEEPER_LEVEL_5)
                
                local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ChosenSubType)
                ShopAddedThisFloor = true
                return NewRoom --replaces the room with the new one
            end
            
            BasicRoomNum = BasicRoomNum + 1
        elseif RoomConfig.Type == RoomType.ROOM_BOSS then
            
            local RoomDesc = Game:GetLevel():GetRoomByIdx(RoomIndex)
            RoomDesc.DisplayFlags = 3 --shows the room
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

--handles the shooting considering the possible ammounts of tears fired
---@param Player EntityPlayer
---@param Direction Vector
function mod:JimboShootCardTear(Player,Direction)
    local CardShot = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[1]]

    Data = Player:GetData()
    Data.PlayCooldown = 0
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
                TearData.Enhancement = CardShot.Enhancement
                mod:AddCardTearFalgs(Tear)
            end
        end
    else
        for i=0, NumTears-1 do
            local FireAngle = (MaxSpread - Spread*i) + Direction:GetAngleDegrees()
            local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10*Player.ShotSpeed

            local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
            local TearData = Tear:GetData()
            TearData.Enhancement = CardShot.Enhancement
            mod:AddCardTearFalgs(Tear)
        end
    end
    --increases the chips basing on the value
    if not Game:GetRoom():IsClear() then
        local Value = mod:GetActualCardValue(CardShot.Value)
        mod:IncreaseJimboStats(Player,CacheFlag.CACHE_FIREDELAY, Value / 50)
    
        --print(CardShot.Enhancement)
        if CardShot.Enhancement == 2 then
            mod:IncreaseJimboStats(Player,CacheFlag.CACHE_DAMAGE, 0.1)
        
        end
    end
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

    if mod.SavedValues.Jimbo.DeckPointer > #mod.SavedValues.Jimbo.FullDeck + #mod.SavedValues.Jimbo.CurrentHand then
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
    --print(BlindType)

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
            mod:StatReset(Player, CacheFlag.CACHE_DAMAGE)
            mod:StatReset(Player, CacheFlag.CACHE_FIREDELAY)

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


function mod:AddCardsEffects()
    for i=#mod.CardSelectionParams.SelectedCards, 1, -1 do
        if mod.CardSelectionParams.SelectedCards[i] then
            mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Enhancement = 2
        end
    end
end

function mod:ActivateHandEffect(Player)
    Isaac.RunCallback("HAND_TYPE_UPDATE") --updates a last time to be sure
    if mod.CardSelectionParams.HandType == mod.HandTypes.HIGH_CARD then
        mod:IncreaseJimboStats(Player,CacheFlag.CACHE_DAMAGE, 0.5)
    end
end

function mod:ChangeCurrentHandType()
    
    mod.CardSelectionParams.PossibleHandTypes = mod:DeterminePokerHand()
    mod.CardSelectionParams.HandType = mod:GetMax(mod.CardSelectionParams.PossibleHandTypes)

end
mod:AddCallback("HAND_TYPE_UPDATE", mod.ChangeCurrentHandType)
-----------------------JIMBO STATS-----------------------
----------------------------------------------------------

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

    local TearsMult = 1 --works a little funky, even i don't exactly know how it work
    local DamageMult = 1

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        mod.SavedValues.Jimbo.MinimumTears = 0.6
        PositiveDamageMult = 0.25
        TearsMult = 0.7
    elseif Player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        mod.SavedValues.Jimbo.MinimumTears = 0.7
        PositiveDamageMult = 0.125
        TearsMult = 0.7
        DamageMult = 0.85
    end

    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local AddedDamage = Player.Damage - 1

        if AddedDamage >= 0 then
            Player.Damage = AddedDamage * PositiveDamageMult + 1 *DamageMult
        else
            Player.Damage = AddedDamage * NegativeDamageMult + 1 *DamageMult
        end
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local JimboBaseTears = 1
        local JimboBaseDelay = mod:CalculateMaxFireDelay(JimboBaseTears)
        local AddedTears = (mod:CalculateTearsValue(Player) - JimboBaseTears)
        
        AddedTears = AddedTears * TearsMult

        if AddedTears < 0 then
            if AddedTears < -0.4 then
                Player.MaxFireDelay = JimboBaseDelay + mod:CalculateTearsUp(JimboBaseDelay, AddedTears + (1/(0.15*AddedTears + 0.2))*(-AddedTears))*TearsMult
            else
                Player.MaxFireDelay = JimboBaseDelay + mod:CalculateTearsUp(JimboBaseDelay, AddedTears + (1/(0.35*AddedTears + 0.5))*(-AddedTears))*TearsMult
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
        if Player.Damage < mod.SavedValues.Jimbo.MinimumDamage then
            Player.Damage = mod.SavedValues.Jimbo.MinimumDamage
        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.Damage = 4.5 / Tears
        end]]--
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local Tears = mod:CalculateTearsValue(Player)
        if Tears < mod.SavedValues.Jimbo.MinimumTears then
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(mod.SavedValues.Jimbo.MinimumTears)

        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.MaxFireDelay =  mod:CalculateMaxFireDelay(4.5 / Player.Damage)
        end]]--
    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.JimboMinimumStats)
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE + 1, mod.JimboMinimumStats)

---@param Player EntityPlayer
function mod:StatReset(Player, Cache)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            mod.SavedValues.Jimbo.StatsToAdd.Damage = 0
        end
        if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            mod.SavedValues.Jimbo.StatsToAdd.Tears = 0
        end
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.StatReset)

function mod:StatGiver(Player, Cache)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        
        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            Player.Damage = Player.Damage + mod.SavedValues.Jimbo.StatsToAdd.Damage * Player.Damage
        end
        if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            --print(mod.CalculateTearsValue(Player))
            Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, mod.SavedValues.Jimbo.StatsToAdd.Tears * mod:CalculateTearsValue(Player))
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.StatGiver)


-------------CARD TEARS-----------------------
----------------------------------------------

function mod:SwitchCardSelectionStates(Player,NextState,NewSelectionMode)

    if NextState then
        if mod.CardSelectionParams.IsSelecting then
            mod:UseSelection(Player)
        end
        mod.CardSelectionParams.Index = 1
        Game:GetRoom():SetPauseTimer(600)
    else
        mod:UseSelection(Player)
        mod.CardSelectionParams.Index = 0
        mod.CardSelectionParams.SelectionNum = 0
        Game:GetRoom():SetPauseTimer(0)
    end

    if NewSelectionMode == mod.CardSelectionParams.SelectionModes.HAND then
        mod.CardSelectionParams.MaxSelectionNum = 5
        mod.CardSelectionParams.OptionsNum = #mod.SavedValues.Jimbo.CurrentHand
    elseif NewSelectionMode == mod.CardSelectionParams.SelectionModes.PackSelection then
        mod.CardSelectionParams.MaxSelectionNum = 1
        mod.CardSelectionParams.OptionsNum = 3
    end


    mod.CardSelectionParams.Mode = NewSelectionMode
    mod.CardSelectionParams.IsSelecting = NextState
end

function mod:UseSelection(Player)
    print("Selection Used")
    if mod.CardSelectionParams.Mode == mod.CardSelectionParams.SelectionModes.HAND then
        --effects
        mod:ActivateHandEffect(Player)
        --card substitution
        mod:SubstituteCards(mod.CardSelectionParams.SelectedCards)
    else
        mod:AddCardsEffects()
    end
    for i=1,#mod.CardSelectionParams.SelectedCards do
        mod.CardSelectionParams.SelectedCards[i] = false
    end
end

---@param Player EntityPlayer
function mod:Select(Player)

    if mod.CardSelectionParams.Mode == mod.CardSelectionParams.SelectionModes.HAND then
    --if its an actual option
        if mod.CardSelectionParams.Index <= #mod.SavedValues.Jimbo.CurrentHand then
            local Choice = mod.CardSelectionParams.SelectedCards[mod.CardSelectionParams.Index]
            --if it's not currently selected...
            if Choice then
    
                mod.CardSelectionParams.SelectedCards[mod.CardSelectionParams.Index] = false                       
                mod.CardSelectionParams.SelectionNum = mod.CardSelectionParams.SelectionNum - 1
            --...and it doesn't surpass the limit
            elseif mod.CardSelectionParams.SelectionNum < mod.CardSelectionParams.MaxSelectionNum then                    
    
                --confirm the selection
                mod.CardSelectionParams.SelectedCards[mod.CardSelectionParams.Index] = true
                mod.CardSelectionParams.SelectionNum = mod.CardSelectionParams.SelectionNum + 1
            end
    
        else--if its the additional confirm button
            print("confirm")
            mod:SwitchCardSelectionStates(Player,false,0)
        end

    elseif mod.CardSelectionParams.Mode == mod.CardSelectionParams.SelectionModes.PackSelection then
        local SelectedCard = mod.CardSelectionParams.PackOptions[mod.CardSelectionParams.Index]
        table.insert(mod.SavedValues.Jimbo.FullDeck, SelectedCard)
        mod:SwitchCardSelectionStates(Player,false,0)
    end
end

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
    Tear.Color = Color.Default

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
        Tear.Scale = 1
        local TearSuit = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[1]].Suit
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
        Data.PlayCooldown = 0
        Data.Cooldown = 0
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)


--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local HandRNG = Player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
        mod.SavedValues.Jimbo.FullDeck = mod:Shuffle(mod.SavedValues.Jimbo.FullDeck, HandRNG)
        mod.SavedValues.Jimbo.DeckPointer = 6
        mod.SavedValues.Jimbo.CurrentHand = {1,2,3,4,5}
    end
    local Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_DEFAULT then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",false)
    elseif Room == RoomType.ROOM_BOSS then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.FullDeckShuffle)



-----------SHADERS----------------
----------------------------------
--man i hate working with shaders...
function mod:PackShader(Name)
    if Name == "Balatro_Pack_Opened" then
        if Game:GetHUD():IsVisible() then
            Game:GetHUD():Render()
            Isaac.RunCallback(ModCallbacks.MC_POST_HUD_RENDER)
        end
        --time is the amount of seconds the player has been choosing for
        local Time = math.min(255, mod.CardSelectionParams.Frames)
        local BackgroundColor = {200,0,0,1}

        local Params = {Time, BackgroundColor}
        return Params
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.PackShader)