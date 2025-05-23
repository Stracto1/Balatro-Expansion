local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local music = MusicManager()


local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Gold","Lucky"}
local SUIT_ANIMATIONS = {"Spade","Heart","Club","Diamond"}
local HAND_TYPE_NAMES = {"high card","pair","Two pair","three of a kind","straight","flush","full house","four of a kind", "straight flush", "royal flush","five of a kind","fluah house","flush five"}
HAND_TYPE_NAMES[0] = "none"

local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local JOKER_OVERLAY_LENGTH = TrinketSprite:GetAnimationData("Idle"):GetLength()

local CHARGED_ANIMATION = 22 --the length of an animation for chargebars
local CHARGED_LOOP_ANIMATION = 10


local BasicRoomNum = 0
local DeathCopyCard

--local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
--local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root
local Game = Game()
local Level = Game:GetLevel()
local ItemPool = Game:GetItemPool()




---------------PLAYER MECHANICS----------------------
-----------------------------------------------------

--setups variables for jimbo
---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.JimboType then
        local Data = player:GetData()

        Data.NotAlrPressed = {} --general controls stuff
        Data.NotAlrPressed.left = true
        Data.NotAlrPressed.right = true
        Data.NotAlrPressed.confirm = true
        Data.NotAlrPressed.ctrl = true
        Data.ALThold = 0 --used to activate the inventory selection

        --player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)

        player:AddCustomCacheTag(mod.CustomCache.HAND_COOLDOWN, true)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)



local GoodWeaponTypes = {
    WeaponType.WEAPON_TEARS,
    WeaponType.WEAPON_MONSTROS_LUNGS,
    WeaponType.WEAPON_NOTCHED_AXE,
    WeaponType.WEAPON_URN_OF_SOULS
}
--makes basically every input possible when using jimbo (+ other stuff)
---@param Player EntityPlayer
function mod:JimboInputHandle(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    -- got this from "sybil pseudoregalia" on the modding of isaac discord (my savior tbh) and modified it a bit
    ---------------------------------------
    local Weapon = Player:GetWeapon(1)
    
    if Weapon then
        if Weapon:GetWeaponType() == WeaponType.WEAPON_SPIRIT_SWORD then

            local newWeapon
            local OldWeaponMod = Weapon:GetModifiers()


            if Player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                newWeapon = Isaac.CreateWeapon(WeaponType.WEAPON_MONSTROS_LUNGS, Player)

            else
                newWeapon = Isaac.CreateWeapon(WeaponType.WEAPON_TEARS, Player)
            end

            Player:SetWeapon(Weapon, 2)
            Player:SetWeapon(newWeapon, 1)
            Player:GetWeapon(2):SetModifiers(OldWeaponMod)
            Player:EnableWeaponType(newWeapon:GetWeaponType(), true)


        elseif not mod:Contained(GoodWeaponTypes, Weapon:GetWeaponType()) then

            local OldWeaponMod = Weapon:GetModifiers()
            local newWeapon

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                newWeapon = Isaac.CreateWeapon(WeaponType.WEAPON_MONSTROS_LUNGS, Player)

            else
                newWeapon = Isaac.CreateWeapon(WeaponType.WEAPON_TEARS, Player)
            end

            Isaac.DestroyWeapon(Weapon)
            Player:EnableWeaponType(newWeapon:GetWeaponType(), true)
            Player:SetWeapon(newWeapon, 1)
            Player:GetWeapon(1):SetModifiers(OldWeaponMod)
        end
    end
    ----------------------------------------

    local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then --while in the card selection menu cheks for inputs
        -------------INPUT HANDLING-------------------(big ass if statements ik lol)

        --confirming/canceling 
        if  Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
            and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)--usually they share buttons
            or Input.IsMouseBtnPressed(MouseButton.LEFT) then

            mod:Select(Player)

        end


        --pressing left moving the selection
        if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) then

            if mod.SelectionParams[PIndex].Index > 1 then
                mod.SelectionParams[PIndex].Index = mod.SelectionParams[PIndex].Index - 1

            end
        end

        --pressing right moving the selection
        if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then
            if mod.SelectionParams[PIndex].Index <= mod.SelectionParams[PIndex].OptionsNum then

                mod.SelectionParams[PIndex].Index = mod.SelectionParams[PIndex].Index + 1
            end
        end
    
        Player.Velocity = Vector.Zero
    else --not selecting anything
    
        
        if Input.IsActionTriggered(ButtonAction.ACTION_DROP, Player.ControllerIndex) then

            local LastCard = mod.Saved.Jimbo[PIndex].CurrentHand[#mod.Saved.Jimbo[PIndex].CurrentHand]

            table.remove(mod.Saved.Jimbo[PIndex].CurrentHand)
            table.insert(mod.Saved.Jimbo[PIndex].CurrentHand,1 ,LastCard)

            mod.Counters.SinceShift = 0
        end
    
        if Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, Player.ControllerIndex)
           or Input.IsButtonPressed(Keyboard.KEY_RIGHT_ALT, Player.ControllerIndex) then

            Data.ALThold = Data.ALThold + 1
            if Data.ALThold == 40 then --if held long enough starts the inventory selection
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
                Data.ALThold = 0
            end
        else
            Data.ALThold = 0
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.JimboInputHandle)


function mod:CountersUpdate()

    for i,v in pairs(mod.Counters) do
        if type(v) == "table" then
            for j,_ in pairs(v) do
                mod.Counters[i][j] = mod.Counters[i][j] + 1
            end
        else
            mod.Counters[i] = mod.Counters[i] + 1
        end
    end

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        local PIndex = Player:GetData().TruePlayerIndex

        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then
            mod.SelectionParams[PIndex].Frames = mod.SelectionParams[PIndex].Frames + 1
        else
            mod.SelectionParams[PIndex].Frames = mod.SelectionParams[PIndex].Frames - 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.CountersUpdate)


local CoinQuality = {[CoinSubType.COIN_PENNY] = 1, 
                    [CoinSubType.COIN_DOUBLEPACK] = 2, 
                    [CoinSubType.COIN_STICKYNICKEL] = 3, 
                    [CoinSubType.COIN_NICKEL] = 3, 
                    [CoinSubType.COIN_LUCKYPENNY] = 4, 
                    [CoinSubType.COIN_GOLDEN] = 0.5, 
                    [CoinSubType.COIN_DIME] = 5}
--removes some coins spawnned by the game and players
---@param Pickup EntityPickup
function mod:LessCoins(Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    --try to remove if spawned by a player or if it's bigger than a penny 
    if Pickup.SpawnerEntity and Pickup.SpawnerType == EntityType.ENTITY_PLAYER
        then
        return
    end

    local MaxLuck
    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if not MaxLuck or Player.Luck > MaxLuck then
            MaxLuck = Player.Luck
        end
    end

    local RemoveChance = (1/(2 + MaxLuck/4)) * CoinQuality[Pickup.SubType]^0.333

    if Pickup:GetDropRNG():RandomFloat() <= RemoveChance then
        
        local Player = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)

        ---@diagnostic disable-next-line: need-check-nil
        Player:AddBlueFlies(CoinQuality[Pickup.SubType], Pickup.Position, Player)
        Pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.LessCoins, PickupVariant.PICKUP_COIN)



--changes the shop items to be in a specific pattern and rolls for the edition
---@param Pickup EntityPickup
---@param rNG RNG
function mod:ShopItemChanger(Pickup,Variant, SubType, ReqVariant, ReqSubType, rNG)

    local ReturnTable = {Variant, SubType, true} --basic return equal to not returning anything

    local RollRNG = mod.Saved.GeneralRNG --tried using the rng from the callback but it gave the same results each time


    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       or not (ReqSubType == 0 or ReqVariant == 0) then

        return
    end

    
    if Game:GetRoom():GetType() == RoomType.ROOM_SHOP and Pickup:IsShopItem() then

        if Pickup.ShopItemId <= 1 then --card pack
            ReturnTable = {PickupVariant.PICKUP_TAROTCARD,mod:GetRandom(mod.Packs, mod.Saved.GeneralRNG),false}

        elseif Pickup.ShopItemId == 2 then --voucher / joker if already bought
            --ngl i'm really proud of the algorithm i wrote on this section

            ---@type boolean | integer
            local VoucherPresent = false
            for i,v in ipairs(Isaac.FindByType(5, 100)) do
                if v:ToPickup().ShopItemId == Pickup.ShopItemId then --if yes, the item voucher wasn't bought
                    VoucherPresent = v.SubType
                    break
                end
            end

            if not Game:GetRoom():IsInitialized() then --if room is just being entered
                --predicts the current voucher so it can exit the /repeat until/ statement
                VoucherPresent = mod:GetRandom(mod.Saved.Pools.Vouchers, rNG, true)
            end

            if VoucherPresent then --voucher still here with us

                local Rvoucher
                repeat
                    Rvoucher = mod:GetRandom(mod.Saved.Pools.Vouchers, rNG) --using this rng basically makes it un rerollable with mechines
                    --PLEASE tell me if the RNG not advancing gets patched cause it'll break the voucher generation 

                until not mod:Contained(mod.Saved.FloorVouchers, Rvoucher) --no dupes per floor
                      or Rvoucher == VoucherPresent --if it's getting rerolled (kinda)

                table.insert(mod.Saved.FloorVouchers, Rvoucher)

                ReturnTable = {PickupVariant.PICKUP_COLLECTIBLE,Rvoucher, false}

            else --replace with a joker if already bought instead

                ReturnTable = {PickupVariant.PICKUP_TRINKET, 1, false}
            end

        elseif Pickup.ShopItemId == 3 then --basic shop item
        
            if Game:IsGreedMode() then
                ReturnTable = {PickupVariant.PICKUP_COLLECTIBLE,
                    ItemPool:GetCollectible(ItemPoolType.POOL_GREED_SHOP, true, RollRNG:GetSeed()), false}
            else
                ReturnTable = {PickupVariant.PICKUP_COLLECTIBLE,
                    ItemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, RollRNG:GetSeed()), false}

            end
            
        
        else
            ReturnTable = {PickupVariant.PICKUP_TRINKET, 1 ,false}
        end

    elseif ReturnTable[1] ~= PickupVariant.PICKUP_COLLECTIBLE then

        local PlanetChance = PlayerManager.GetNumCollectibles(mod.Vouchers.PlanetMerch) * 0.07 + PlayerManager.GetNumCollectibles(mod.Vouchers.PlanetTycoon) * 0.1
        local TarotChance = PlayerManager.GetNumCollectibles(mod.Vouchers.TarotMerch) * 0.07 + PlayerManager.GetNumCollectibles(mod.Vouchers.TarotTycoon) * 0.1

        TarotChance = TarotChance + 0.05*#mod:GetJimboJokerIndex(Game:GetPlayer(0),mod.Jokers.CARTOMANCER)


        if TarotChance + PlanetChance > 1 then --if the sum of the chances is higher than 1 even it out
            local Rapporto = PlanetChance / TarotChance

            TarotChance = 1/(Rapporto+1)
            PlanetChance = 1-PlanetChance
        end


        --MULTIPLAYER - PLACEHOLDER
        --[[
        for i,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType then
                for i=1, mod:GetValueRepetitions(mod.Saved.Jimbo[PIndex].Inventory.Jokers, TrinketType.OOPS) do
                    PlanetChance = PlanetChance * 2
                    TarotChance = TarotChance * 2
                end
            end
        end]]--
        TarotChance = TarotChance + PlanetChance

        local CardRoll = Game:GetPlayer(0):GetDropRNG():RandomFloat()

        if CardRoll <= PlanetChance then
            ReturnTable = {PickupVariant.PICKUP_TAROTCARD, Game:GetPlayer(0):GetDropRNG():RandomInt(mod.Planets.PLUTO, mod.Planets.SUN), false}

        elseif CardRoll <= TarotChance then
            ReturnTable = {PickupVariant.PICKUP_TAROTCARD, Game:GetPlayer(0):GetDropRNG():RandomInt(1, 22), false}

        end

    end

    --if a trinket is selected, then roll for joker and edition
    if ReturnTable[1] == PickupVariant.PICKUP_TRINKET then


        local RandomJoker = mod:RandomJoker(RollRNG, {}, true)

        ReturnTable = {PickupVariant.PICKUP_TRINKET, RandomJoker.Joker ,false}

        mod.Saved.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(RandomJoker.Joker).Name] = RandomJoker.Edition
    
    --reverse tarot become their non-reverse variant
    elseif ReturnTable[1] == PickupVariant.PICKUP_TAROTCARD 
           and ReturnTable[2] >= Card.CARD_REVERSE_FOOL and ReturnTable[2] <= Card.CARD_REVERSE_WORLD then

        ReturnTable[2] = ReturnTable[2] - 55

    end
    
    return ReturnTable
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, mod.ShopItemChanger)


--makes every item a paid shop item (also see SetItemPrices)
---@param Pickup EntityPickup
function mod:SetItemAsShop(Pickup)

    --print(Pickup.SpawnerType)

    --sadly not every spawning items via other items doesn't always put the correct SpawnerEntity,
    --so this won't always work (ex. magic skin/alabasterbox)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) or Pickup:IsShopItem()
       or ItemsConfig:GetCollectible(Pickup.SubType):HasTags(ItemConfig.TAG_QUEST) 
       or Pickup.SpawnerEntity then
        return
    end

    Pickup:MakeShopItem(-2)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.SetItemAsShop, PickupVariant.PICKUP_COLLECTIBLE)


--makes every item a paid shop item (also see SetItemPrices)
---@param Pickup EntityPickup
function mod:EnableJokerAnimations(Pickup)

    local Config = ItemsConfig:GetTrinket(Pickup.SubType)
    if not Config:HasCustomTag("balatro") then
        return
    end

    --using this an,2 enables the various joker animations such as the wobble for legendaries 
    local Tsprite = Pickup:GetSprite()
    local InitialAnimation = Tsprite:GetAnimation()

    Tsprite:Load("gfx/005.350_trinket_custom.anm2", false)
    Tsprite:ReplaceSpritesheet(0,Config.GfxFileName, false)
    Tsprite:ReplaceSpritesheet(2,Config.GfxFileName, true)
    Tsprite:Play(InitialAnimation, true)

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.EnableJokerAnimations, PickupVariant.PICKUP_TRINKET)


--sets the price for every item basing on quality and room
function mod:SetItemPrices(Variant,SubType,ShopID,Price)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    Level:GetCurrentRoomDesc().ShopItemDiscountIdx = -1 --no discounts ever

    local Cost = 1
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local Item = ItemsConfig:GetCollectible(SubType)

        if Item and Item:HasCustomTag("balatro") then --vouchers
            Cost = 10
        else --any item in the game
            Cost = Item.Quality *2 + 1
        end

    elseif Variant == PickupVariant.PICKUP_TRINKET then --jokers
    
        Cost = mod:GetJokerCost(SubType)

    else --prob stuff like booster packs
        Cost = 5
    end

    if Variant ~= PickupVariant.PICKUP_TRINKET then --these are already included in GetJokerCost()

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Liquidation) then --50% off
        
            Cost = Cost * 0.5

        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Clearance) then --25% off
            Cost = Cost * 0.75

        end
    end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
        Cost = Cost * 2 - 1 --nullifies the usual steam sale effect and subratcts 1 instead
    end

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        if mod:JimboHasTrinket(Player, mod.Jokers.ASTRONOMER) then
            if Variant == PickupVariant.PICKUP_COLLECTIBLE then
                if ItemsConfig:GetCollectible(SubType):HasTags(ItemConfig.TAG_STARS) then
                    Cost = 0
                else
                    break
                end

            elseif Variant == PickupVariant.PICKUP_TAROTCARD then
                if (SubType > mod.Planets.PLUTO and SubType < mod.Planets.SUN)
                    or SubType == mod.Packs.CELESTIAL then
                    Cost = 0
                else
                    break
                end
            else
                break
            end
        end
    end


    Cost = math.floor(Cost) --rounds it down 
    Cost = math.max(Cost, 1)

    return Cost
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.SetItemPrices)


--modifies the floor generation and calculates the number of normal rooms
---@param RoomConfig RoomConfigRoom
---@param LevelGen LevelGeneratorRoom
function mod:FloorModifier(LevelGen,RoomConfig,Seed)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end
    mod.ShopAddedThisFloor = false
    local RoomIndex = LevelGen:Column() + LevelGen:Row()*13
    
    --print(RoomIndex)

    if RoomConfig.Type == RoomType.ROOM_SHOP then
        --("s")
        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3
            if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
                ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_4
            elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
                ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_5
            end
        local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

        Isaac.CreateTimer(
        function()
            Level:GetRoomByIdx(RoomIndex).DisplayFlags = 5

            Level:UpdateVisibility()
        end, 1, 1, true)

        return NewRoom --replaces the room with the new one

    elseif RoomConfig.Type == RoomType.ROOM_DEFAULT then
        --adds an extra shop on every floor (on basement I/II has a ~8% to fail due to lack of options)

        if RoomIndex ~= Level:GetStartingRoomIndex() then
            BasicRoomNum = BasicRoomNum + 1
        end

        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
            ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_5
        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
            ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_4
        end

        local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

        for Slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
            if RoomConfig.Doors & (1 << Slot) ~= 0 then --if door is available
                --print("door at "..tostring(Slot))
                Isaac.CreateTimer(
                function()
                    if mod.ShopAddedThisFloor then
                        return
                    end

                    ---@diagnostic disable-next-line: redundant-parameter
                    local YeRoom = Level:TryPlaceRoomAtDoor(NewRoom, Level:GetRoomByIdx(RoomIndex), Slot,Seed, false, false)
                    if YeRoom then
                        YeRoom.DisplayFlags = 5
                        mod.ShopAddedThisFloor = true
                    end
                end,1,1,true)
            end
        end
    elseif RoomConfig.Type == RoomType.ROOM_BOSS then
        Isaac.CreateTimer(
        function()
            Level:GetRoomByIdx(RoomIndex).DisplayFlags = 5

            Level:UpdateVisibility()
        end, 1, 1, true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, mod.FloorModifier)


--calculates how big the blinds are 
function mod:CalculateBlinds()

    mod.Saved.SmallCleared = false
    mod.Saved.BigCleared = false
    mod.Saved.BossCleared = 0
    mod.Saved.ClearedRooms = 0

    if Game:IsGreedMode() then

        if Game:GetLevel():GetName() == "shop" then
            mod.Saved.SmallBlind = 0
            mod.Saved.BigBlind = 0
        else
            mod.Saved.SmallBlind = 8
            mod.Saved.BigBlind = 2
            if Game:IsHardMode() then
                mod.Saved.SmallBlind = mod.Saved.SmallBlind + 1
            end
        end

    else
        --the more rooms, the less you need to complete
        if BasicRoomNum < 40 then
            BasicRoomNum = math.floor(BasicRoomNum * (0.9 - BasicRoomNum/100))
        else
            BasicRoomNum =  math.floor(BasicRoomNum * 0.55) --the minimum is 55% of rooms
        end
 
        mod.Saved.SmallBlind = math.floor(BasicRoomNum/2) -- about half of the rooms
        mod.Saved.BigBlind = BasicRoomNum - mod.Saved.SmallBlind --about half of the rooms
    end
    BasicRoomNum = 0 --resets the counter
    ShopAddedThisFloor = false

    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.SMALL)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.CalculateBlinds)
--mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE,mod.CalculateBlinds)


--handles the rooms which are cleared by default and shuffels if they are not
function mod:HandleNoHarmRoomsClear()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    local Desc = Level:GetCurrentRoomDesc()
    
    if Desc.VisitedCount ~= 1 or Desc.GridIndex == Level:GetStartingRoomIndex() then
        return
    end


    if Desc.Clear then --if the room is not hostile
        --print("clear")
        if Desc.Data.Type == RoomType.ROOM_DEFAULT then
            Isaac.RunCallback("TRUE_ROOM_CLEAR",false, false)

        elseif Desc.Data.Type == RoomType.ROOM_SHOP then
            local Seed = Game:GetRoom():GetSpawnSeed()
            
            if Game:IsGreedMode() then
                
                for _,Slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE)) do
                    Slot:Remove()
                end


                Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                       Vector(580,400),Vector.Zero, nil, 0, Seed)


                if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then

                    local ExtraTrinket = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                                                    Vector(840,320),Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(mod.Saved.GeneralRNG).Joker, Seed):ToPickup()

                    ---@diagnostic disable-next-line: need-check-nil
                    ExtraTrinket:MakeShopItem(-2) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()

                    ---@diagnostic disable-next-line: need-check-nil
                    local JokerData = ExtraTrinket:GetData()
                    JokerData.OverstockGreed = true
                end
                if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then

                    local ExtraTrinket = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                                                    Vector(940,320),Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(mod.Saved.GeneralRNG).Joker, Seed):ToPickup()
                    
                    ---@diagnostic disable-next-line: need-check-nil
                    ExtraTrinket:MakeShopItem(-2) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()

                    ---@diagnostic disable-next-line: need-check-nil
                    local JokerData = ExtraTrinket:GetData()
                    JokerData.OverstockGreed = true
                end


            else
                Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                       Game:GetRoom():GetGridPosition(25),Vector.Zero, nil, 0, Seed)
            end
            
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HandleNoHarmRoomsClear)


local ShopRestock = false
function mod:OverstockGreedHelper(Partial)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) or not Game:IsGreedMode() or Partial then
        return
    end

    ShopRestock = true

    Isaac.CreateTimer(function()
        ShopRestock = false
    end,2,1, true)

end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OverstockGreedHelper)



function mod:OverstockGreedJokerFix2(Pickup, Player, _)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) or not Game:IsGreedMode() then
        return
    end
    local PickupData = Pickup:GetData()

    if not PickupData.OverstockGreed then
        return
    end
    
    local Position = Pickup.Position

    Isaac.CreateTimer(function ()

        local NewPickup = Isaac.FindInRadius(Position, 2)[1]

        local NewPickupData = NewPickup:GetData()

        NewPickupData.OverstockGreed = true
    end, 31,1,false)


end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OverstockGreedJokerFix2, PickupVariant.PICKUP_TRINKET)


--using restock machines makes the extra jokers disappear so just put a new one
function mod:OverstockGreedJokerFix(Pickup)

    --exiting the room shouldn't spawn a new trinket
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) or not Game:IsGreedMode() then
        return
    end

    Pickup = Pickup:ToPickup()

    local PickupData = Pickup:GetData()

    Isaac.CreateTimer(function ()
        
        --print(PickupData.OverstockGreed)
        --print(ShopRestock)

        if not PickupData.OverstockGreed or not ShopRestock then
            return
        end

        local ExtraTrinket = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                                                Pickup.Position,Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(mod.Saved.GeneralRNG).Joker, Pickup.InitSeed):ToPickup() or Pickup

        ExtraTrinket:MakeShopItem(6) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()

        local JokerData = ExtraTrinket:GetData()
        JokerData.OverstockGreed = true

    end,0,1,false)

    
    

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.OverstockGreedJokerFix, EntityType.ENTITY_PICKUP)




function mod:AddRoomsCleared(IsBoss, Hostile)


    if not Game:IsGreedMode() then
        for i,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType then
                ---@diagnostic disable-next-line: param-type-mismatch
                mod:StatReset(Player, true, true, true, false, true)

                if Hostile then
                    mod:FullDeckShuffle(Player)
                end
            end
        end
    end


    if Game:GetLevel():GetDimension() ~= Dimension.NORMAL then
        return
    end

    if not Game:IsGreedMode() then

        for i,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType then

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, Player.Position + Vector(0,7),Vector.Zero,nil,0,1)
                Player:AddHearts(2)
                mod:FullDeckShuffle(Player)
            end
        end
    end


    if IsBoss and mod.Saved.BossCleared ~= 2
       and (Game:GetLevel():GetStage() ~= LevelStage.STAGE7 or Game:GetRoom():GetDeliriumDistance() == 0) then

        
        if Game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH
           and mod.Saved.BossCleared == 0 then

            mod.Saved.BossCleared = 1 --basically serves as a "third state" symbolising that 1 of 2 bossrooms were completed
        else
            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BOSS)
            mod.Saved.BossCleared = 2 -- all bosses completed
        end
    else
        mod.Saved.ClearedRooms = mod.Saved.ClearedRooms + 1
        if not mod.Saved.SmallCleared then
            if mod.Saved.ClearedRooms == mod.Saved.SmallBlind then
                Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.SMALL)
                mod.Saved.SmallCleared = true
                mod.Saved.ClearedRooms = 0
            end
        
        elseif mod.Saved.ClearedRooms == mod.Saved.BigBlind and not mod.Saved.BigCleared then
            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BIG)
            mod.Saved.BigCleared = true
            mod.Saved.ClearedRooms = 0
        end
    end
end
mod:AddPriorityCallback("TRUE_ROOM_CLEAR",CallbackPriority.LATE, mod.AddRoomsCleared)


--activates whenever the deckpointer is shifted (has the steel cards effect)
---@param Player EntityPlayer
function mod:OnDeckShift(Player)

    local PIndex = Player:GetData().TruePlayerIndex
    --shuffle the deck if finished
    if not next(mod.Saved.Jimbo[PIndex].CurrentHand) then

        if mod.Saved.Jimbo[PIndex].FirstDeck and mod.Saved.Jimbo[PIndex].Progress.Room.Shots < Player:GetCustomCacheValue("hands") then
            mod.Saved.Jimbo[PIndex].FirstDeck = false --no more stat boosts from cards in the cuurent room
            Player:AnimateSad()
        end
        mod:FullDeckShuffle(Player)
    end

    mod.Counters.SinceShift = 0
end
mod:AddCallback("DECK_SHIFT", mod.OnDeckShift)



function mod:GiveRewards(BlindType)

    local Seed = Game:GetSeeds():GetStartSeed()

    --calculates the ammount of interests BEFORE giving the clear reward
    local MaxInterests = 5
    MaxInterests = PlayerManager.AnyoneHasCollectible(mod.Vouchers.MoneySeed) and 10 or MaxInterests
    MaxInterests = PlayerManager.AnyoneHasCollectible(mod.Vouchers.MoneyTree) and 20 or MaxInterests

    local Interests = math.floor(Game:GetPlayer(0):GetNumCoins()/5)
    Interests = math.min(MaxInterests, Interests)

    local ToTheMoonNum = 0




    --gives coins basing on the blind cleared and finds jimbo
    for _,Player in ipairs(PlayerManager:GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then

            ToTheMoonNum = ToTheMoonNum + #mod:GetJimboJokerIndex(Player, mod.Jokers.TO_THE_MOON)

            --Jimbo:AddHearts(Jimbo:GetHeartLimit()) --fully heals 

            Isaac.CreateTimer(function ()
                if BlindType == mod.BLINDS.SMALL then
                    
                    Player:AddCoins(4)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+4 $",0)
                    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BIG)

                elseif BlindType == mod.BLINDS.BIG then
                    Player:AddCoins(5)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+5 $",0)
                    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BOSS)
                    
                elseif BlindType == mod.BLINDS.BOSS then
                    Player:AddCoins(6)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+6 $",0)
    
                end
            end, 15,1, true)
            
        end
    end

    Interests = Interests * (ToTheMoonNum+1)

    --if mod.Saved.Jimbo[PIndex].FirstDeck then
        --Jimbo:AddCoins(2)
    --end

    --gives interest
    Isaac.CreateTimer(function ()
        local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType) or Game:GetPlayer(0)

        for i = 1, Interests do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Jimbo.Position,
            RandomVector() * 4, PlayerManager.FirstPlayerByType(mod.Characters.JimboType),
            CoinSubType.COIN_PENNY, Seed)

            --Balatro_Expansion:EffectConverter(8,0,Jimbo,4) a relic from old times
        end
        mod:CreateBalatroEffect(Jimbo,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+"..tostring(Interests).." $",0)
    end, 30, 1, true)


end
mod:AddPriorityCallback("BLIND_CLEARED",CallbackPriority.LATE, mod.GiveRewards)


---@param Player EntityPlayer
---@param StopEvaluation boolean this is only set when called in mod:AddJoker (Utility.lua)
function mod:JimboAddTrinket(Player, Trinket, _, StopEvaluation)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
        
    Player:TryRemoveTrinket(Trinket) -- a custom table is used instead since he needs to hold many of them

    local JokerEdition = mod.Saved.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Trinket).Name] or mod.Edition.BASE 


    local EmptySlot = mod:GetJimboJokerIndex(Player, 0,true)[1]
    
    if not EmptySlot then
        Isaac.CreateTimer(function ()
            Player:AnimateSad()
        end,0,1,false)
        
        return false
    end

    mod.Saved.Jimbo[PIndex].Inventory[EmptySlot].Joker = Trinket
    mod.Saved.Jimbo[PIndex].Inventory[EmptySlot].Edition = JokerEdition

    local InitialProg = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[2]
    mod.Saved.Jimbo[PIndex].Progress.Inventory[EmptySlot] = tonumber(InitialProg)

    if not StopEvaluation then
        Isaac.RunCallback("JOKER_ADDED", Player, Trinket, JokerEdition, EmptySlot)
        Isaac.RunCallback("INVENTORY_CHANGE", Player)
    end

    return true
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED,CallbackPriority.IMPORTANT, mod.JimboAddTrinket)


---@param RNG RNG 
function mod:JimboTrinketPool(_, RNG)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end


    return mod:RandomJoker(RNG, {}, true).Joker

    --[[
    local RarityRoll = RNG:RandomFloat()
    if RarityRoll < 0.70 then --common
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.common, RNG)
        until not mod:JimboHasTrinket(nil, Joker) --no duplicates
        return Joker
    elseif RarityRoll < 0.95 then --uncommon
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.uncommon, RNG)
        until not mod:JimboHasTrinket(nil, Joker)
        return Joker
    else --rare
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.rare, RNG)
        until not mod:JimboHasTrinket(nil, Joker)
        return Joker
    end]]
end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.JimboTrinketPool)


---@param Trinket EntityPickup
function mod:TrinketEditionsRender(Trinket, Offset)
    local Index = Level:GetCurrentRoomDesc().ListIndex
    local JokerConfig = ItemsConfig:GetTrinket(Trinket.SubType)

    --some precautions
    mod.Saved.FloorEditions[Index] = mod.Saved.FloorEditions[Index] or {}
    mod.Saved.FloorEditions[Index][JokerConfig.Name] = mod.Saved.FloorEditions[Index][JokerConfig.Name] or 0

    local Edition = mod.Saved.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name]
    
    Trinket:GetSprite():SetCustomShader(mod.EditionShaders[Edition])

    --Trinket:GetSprite():SetCustomShader(mod.EditionShaders[mod.Edition.NEGATIVE])
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.TrinketEditionsRender, PickupVariant.PICKUP_TRINKET)


function mod:EnableTrinketEditions()
    mod.Saved.FloorEditions = {}
    Isaac.CreateTimer(function()
        local AllRoomsDesc = Level:GetRooms()
        for i=1, Level:GetRoomCount()-1 do
            local RoomDesc = AllRoomsDesc:Get(i)
            mod.Saved.FloorEditions[RoomDesc.ListIndex] = {}
        end
    end, 1,1,true )
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.EnableTrinketEditions)


local DamagedThisFrame = {}
DamagedThisFrame[0] = false
DamagedThisFrame[1] = false
DamagedThisFrame[2] = false
DamagedThisFrame[3] = false

--jimbo can only take one heart container worth of damage per time
--makes jimbo discard whenever he takes damage in a not cleared room
---@param Player Entity
function mod:JimboTakeDamage(Player,Amount,_,Source,_)
    ---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType 
       or DamagedThisFrame[Player:GetPlayerIndex()] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if Amount ~= 0 then
        --at this point always returns false to swap the normal damage with a "custom" one

        --only remove one eternal/rotten heart if he has any
        if Player:GetEternalHearts() ~= 0  then

            Player:AddEternalHearts(-1)

        elseif Player:GetRottenHearts() ~= 0 then

            Player:AddRottenHearts(-1)   
            Player:AddHearts(-1) --rotten hearts leave you with half a red heart(??)

        elseif Player:GetBoneHearts() ~= 0 then

            if Player:GetHearts() > Player:GetMaxHearts() then --if a bone heart is filled
                Player:AddHearts(-2)
            else
                Player:AddBoneHearts(-2)
                sfx:Play(SoundEffect.SOUND_BONE_SNAP)
            end

        else
            Player:AddHearts(-2)
        end
        Player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, Source, 0) --take fake damage
        Player:SetMinDamageCooldown(80)

        return false
    end


    --||DISCARD MECHANIC||
    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

        Isaac.RunCallback("HAND_DISCARD", Player, #mod.Saved.Jimbo[PIndex].CurrentHand) --various joker/card effects

        mod:DiscardSwoosh(Player)
        
        for i = #mod.Saved.Jimbo[PIndex].CurrentHand, 1, -1 do

            local RandomDirection = RandomVector()
            
            mod.TearCardEnable = false
            mod.Counters.SinceShoot = 0

            local Tear = Player:FireTear(Player.Position, 10*Player.ShotSpeed * RandomDirection + Player:GetTearMovementInheritance(RandomDirection), true, true, true, Player)
            mod:AddCardTearFalgs(Tear, false, true)
            Tear:GetData().WasDiscarded = true

            mod.Saved.Jimbo[PIndex].CurrentHand[i] = nil
        end

        for i=1, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) do

            table.insert(mod.Saved.Jimbo[PIndex].CurrentHand, 1, mod.Saved.Jimbo[PIndex].DeckPointer)
            mod.Saved.Jimbo[PIndex].DeckPointer = mod.Saved.Jimbo[PIndex].DeckPointer + 1
        end


        Isaac.RunCallback("DECK_SHIFT", Player)

    end

    DamagedThisFrame[Player:GetPlayerIndex()] = true
    Isaac.CreateTimer(function ()
        DamagedThisFrame[Player:GetPlayerIndex()] = false
    end,0,1,true)

end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.JimboTakeDamage, EntityType.ENTITY_PLAYER)


---@param Player EntityPlayer
---@param HpType AddHealthType
function mod:JimboOnlyRedHearts(Player, Amount, HpType, _)

    if Amount == 0 or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    if (HpType | AddHealthType.SOUL == AddHealthType.SOUL or
       HpType | AddHealthType.BLACK == AddHealthType.BLACK) then

        Player:AddBlueFlies(Amount * 2, Player.Position, Player)
        return 0 -- no hearts given

    elseif HpType & AddHealthType.MAX == AddHealthType.MAX and not mod.HpEnable and mod.GameStarted then --can't get hp us normally
       
        if Amount > 0 then
    
            for i = 1, Amount do
                local RPack = mod:GetRandom(mod.Packs, Player:GetDropRNG())
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, nil, RPack, Player:GetDropRNG():GetSeed())
            end
            Isaac.CreateTimer(function ()
                Player:StopExtraAnimation() --PLACEHOLDER
            Player:AnimateSad()
            end,0,1,false)
            
        end
        return 0

    elseif HpType & AddHealthType.RED == AddHealthType.RED then

        if Amount > 0 and mod:JimboHasTrinket(Player, mod.Jokers.DRUNKARD) then

            if Player:HasFullHearts() then
                Game:SetDizzyAmount(math.min(Game:GetDizzyAmount() + 0.02*(1-Game:GetDizzyAmount()), 1))
                sfx:Play(SoundEffect.SOUND_GULP)
            end
        end

        return Amount + (Amount % 2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, mod.JimboOnlyRedHearts)


---@param Player EntityPlayer
function mod:JimboDeadCatFix(Player, Amount, HpType,_)
    if Amount == 0 or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    if HpType & AddHealthType.MAX == AddHealthType.MAX and mod.GameStarted then --can't get hp ups normally
        if Player:GetMaxHearts() == 0 and Player:GetBrokenHearts() < Player:GetHeartLimit() then
            Player:AddMaxHearts(2)
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_HEARTS, mod.JimboDeadCatFix)



---@param Familiar EntityFamiliar
function mod:JimboBlueFliesSpiders(Familiar)

    local Player = Familiar.Player
    if Player:GetPlayerType() == mod.Characters.JimboType then

        --for whaterver reason i need to set a timer or it won't do anything
        Isaac.CreateTimer(function () 
            Familiar.CollisionDamage = (Player.Damage * mod:CalculateTearsValue(Player)) * 2
        end, 1,1,true)

        --print(Familiar.CollisionDamage)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.JimboBlueFliesSpiders, FamiliarVariant.BLUE_FLY)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.JimboBlueFliesSpiders, FamiliarVariant.BLUE_SPIDER)


--shuffles the deck
---@param Player EntityPlayer
function mod:JimboRoomClear(Player)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    if Game:IsGreedMode() then

        local CurrentWave = Level.GreedModeWave
        local WantedWaves
        if Game:IsHardMode() then
            WantedWaves = {9,11,12} --greedier last waves
        else
            WantedWaves = {8,10,11} --greed last waves
        end

        local IsFirstWave = CurrentWave == 1 or CurrentWave == WantedWaves[2]-1 or CurrentWave == WantedWaves[3]

        Isaac.RunCallback("TRUE_ROOM_CLEAR", CurrentWave == WantedWaves[3], IsFirstWave)

        
        --as the button is first pressed, reset stats and deck
        if IsFirstWave then
            for i,Player in ipairs(PlayerManager.GetPlayers()) do
                if Player:GetPlayerType() == mod.Characters.JimboType then
                    ---@diagnostic disable-next-line: param-type-mismatch
                    mod:StatReset(Player, true, true, true, false, true)
                    mod:FullDeckShuffle(Player)
                end
            end
        end
    else
        local Room = Game:GetRoom():GetType()

        if Room == RoomType.ROOM_DEFAULT then
            Isaac.RunCallback("TRUE_ROOM_CLEAR",false, true)
        elseif Room == RoomType.ROOM_BOSS then
            Isaac.RunCallback("TRUE_ROOM_CLEAR",true, true)
        else
            for i,Player in ipairs(PlayerManager.GetPlayers()) do
                if Player:GetPlayerType() == mod.Characters.JimboType then
                    Player:AddHearts(2)
                    mod:FullDeckShuffle(Player)
                end
            end
        end


    end
    
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.JimboRoomClear)


---@param Player EntityPlayer
function mod:DiscardEffects(Player)

    local PlayerRNG = Player:GetDropRNG()
    local SealTriggers = 1

    local PIndex = Player:GetData().TruePlayerIndex

    for i,index in ipairs(mod.Saved.Jimbo[PIndex].CurrentHand) do
        local card = mod.Saved.Jimbo[PIndex].FullDeck[index]

        if card then --could be nil
            if card.Seal == mod.Seals.PURPLE and PlayerRNG:RandomFloat() <= 1/SealTriggers then

                --spawns a random basic tarotcard
                local RandomSeed = Random()
                if RandomSeed == 0 then RandomSeed = 1 end
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, PlayerRNG:RandomInt(1,22), RandomSeed)
                SealTriggers = SealTriggers + 1 --decreases the chance the more trigger at the same time
            end
        end
    end
end
mod:AddCallback("HAND_DISCARD", mod.DiscardEffects)


-----------------------JIMBO STATS-----------------------
----------------------------------------------------------

--these calculations are used for normal items, NOT stats given by jokers or mod related stuff, as they are flat stat ups


function mod:JokerStatReset(Player, Cache)

    if not mod.GameStarted then
        return
    end

    --resets the jokers stat boosts every evaluation since otherwise they would infinitely stack
    mod:StatReset(Player, Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE,
                  Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY,
                  false, true, false)
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.JokerStatReset)

---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboStatCalculator(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end
    --literally spent hours making calculations for stats just to realize that 1 single ratio is the best thing to do

    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then

        Player.Damage = (Player.Damage / 3.50)^0.75
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then

        Player.MaxFireDelay = mod:CalculateMaxFireDelay((mod:CalculateTears(Player.MaxFireDelay)/ 2.73)^0.75)
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboStatCalculator)


---@param Player EntityPlayer
function mod:StatReset(Player, Damage, Tears, Evaluate, Jokers, Basic)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if Damage then
        if Basic then
            mod.Saved.Jimbo[PIndex].StatsToAdd.Damage = 0
            mod.Saved.Jimbo[PIndex].StatsToAdd.Mult = 1
        end
        if Jokers then
            mod.Saved.Jimbo[PIndex].StatsToAdd.JokerDamage = 0
            mod.Saved.Jimbo[PIndex].StatsToAdd.JokerMult = 1
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
    if Tears then
        if Basic then
            mod.Saved.Jimbo[PIndex].StatsToAdd.Tears = mod.JimboStartTears
        end
        if Jokers then
            mod.Saved.Jimbo[PIndex].StatsToAdd.JokerTears = 0
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end
end


local LibraEnable = true
--finally gives the actual stat changes to jimbo, also used for always active buffs
---@param Player EntityPlayer
function mod:StatGiver(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local stats = mod.Saved.Jimbo[PIndex].StatsToAdd

    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then

        --Player.Damage = (Player.Damage + (stats.Damage + stats.JokerDamage) * Player.Damage) * stats.JokerMult * stats.Mult
        mod.Saved.Jimbo[PIndex].TrueDamageValue = (Player.Damage + (stats.Damage + stats.JokerDamage) * Player.Damage) * stats.JokerMult * stats.Mult

        Player.Damage = 1

    elseif Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then

        mod.Saved.Jimbo[PIndex].TrueTearsValue = mod:CalculateTearsValue(Player) + (stats.Tears +  stats.JokerTears)* mod:CalculateTearsValue(Player)

        Player.MaxFireDelay = Player:GetCustomCacheValue(mod.CustomCache.HAND_COOLDOWN)
    end

    --changing stats the next frame sadly causes some "jiggling" fpr the stats values, but it's needed due to
    --how libra and the minimum damage cap (0.5) work, but these ifs at leat limit the ammount of situations they can appear in
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_LIBRA) then

        local HalfStat = (mod.Saved.Jimbo[PIndex].TrueDamageValue + mod.Saved.Jimbo[PIndex].TrueTearsValue)/2
        --local HalfStat = ((mod.Saved.Jimbo[PIndex].TrueDamageValue + mod.Saved.Jimbo[PIndex].TrueTearsValue)/4)^0.5 --halfes the total card damage

        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE 
           or Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY
           and LibraEnable then
            
            Isaac.CreateTimer(function ()
                mod.Saved.Jimbo[PIndex].TrueDamageValue = HalfStat
                mod.Saved.Jimbo[PIndex].TrueTearsValue = HalfStat
                LibraEnable = true
            end,0,1,true)
            LibraEnable = false
        end

        Isaac.CreateTimer(function ()
            Player.Damage = 1
            Player.MaxFireDelay = Player:GetCustomCacheValue(mod.CustomCache.HAND_COOLDOWN)
        end,0,1,true)

    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE + 1, mod.StatGiver)


function mod:IncreaseJimboStats(Player,TearsUp,DamageUp,Mult, Evaluate, Basic)

    local PIndex = Player:GetData().TruePlayerIndex

    if Basic then
        mod.Saved.Jimbo[PIndex].StatsToAdd.Damage = mod.Saved.Jimbo[PIndex].StatsToAdd.Damage + DamageUp
        mod.Saved.Jimbo[PIndex].StatsToAdd.Tears = mod.Saved.Jimbo[PIndex].StatsToAdd.Tears + TearsUp
        mod.Saved.Jimbo[PIndex].StatsToAdd.Mult = mod.Saved.Jimbo[PIndex].StatsToAdd.Mult * Mult
    else
        mod.Saved.Jimbo[PIndex].StatsToAdd.JokerDamage = mod.Saved.Jimbo[PIndex].StatsToAdd.JokerDamage + DamageUp
        mod.Saved.Jimbo[PIndex].StatsToAdd.JokerTears = mod.Saved.Jimbo[PIndex].StatsToAdd.JokerTears + TearsUp
        mod.Saved.Jimbo[PIndex].StatsToAdd.JokerMult = mod.Saved.Jimbo[PIndex].StatsToAdd.JokerMult * Mult
    end
    
    if Evaluate then
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        --print(mod.Saved.Jimbo[PIndex].StatsToAdd.Tears)
    end

end


function mod:AlwaysMaxCoins(Player, CustomCache, _)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return 999
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.AlwaysMaxCoins, "maxcoins")



---@param Player EntityPlayer
function mod:PlayCDCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    Value = 30 --base starting point (1 second charge time)

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
        Value = Value * (1 + 0.66 * Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)^0.5)
    end
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        Value = Value * (1 + 0.5 * Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)^0.5)
    end

    Value = math.floor(Value)

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.PlayCDCache, mod.CustomCache.HAND_COOLDOWN)



---@param Player EntityPlayer
function mod:InventorySizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 3 --base starting point

    if Player:HasCollectible(mod.Vouchers.Antimatter) then
        Value = Value + 1
    end

    for _,Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
        if Slot.Edition == mod.Edition.NEGATIVE then
            Value = Value + 1
        end
    end

    mod:AddJimboInventorySlots(Player, Value-#mod.Saved.Jimbo[PIndex].Inventory)

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.InventorySizeCache, mod.CustomCache.INVENTORY_SIZE)


---@param Player EntityPlayer
function mod:HandSizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 5 --base starting point

    if Player:HasCollectible(mod.Vouchers.Brush) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Palette) then
        Value = Value + 1
    end

    Value = Value - 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.MERRY_ANDY)

    Value = Value + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)

    Value = Value - 3*#mod:GetJimboJokerIndex(Player, mod.Jokers.STUNTMAN, true)

    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.TURTLE_BEAN)) do
        Value = Value + mod.Saved.Jimbo[PIndex].Progress.Inventory[Index]
    end

    Value = Value + #mod:GetJimboJokerIndex(Player, mod.Jokers.JUGGLER)
 


    Value = Value - mod.Saved.Jimbo[PIndex].EctoUses

    Value = math.max(1, Value) --minimum 1 card in hand

    local SizeDifference = Value - #mod.Saved.Jimbo[PIndex].CurrentHand

    if SizeDifference > 0 then
        mod:ChangeJimboHandSize(Player, SizeDifference)
    end

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.HandSizeCache, mod.CustomCache.HAND_SIZE)


---@param Player EntityPlayer
function mod:DiscardNumCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    Value = 3 --base starting point

    if Player:HasCollectible(mod.Vouchers.Wasteful) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Recyclomancy) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Petroglyph) then
        Value = Value - 1
    end

    Value = Value + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.MERRY_ANDY)
    
    Value = Value + #mod:GetJimboJokerIndex(Player, mod.Jokers.DRUNKARD)



    if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
        Value = 1
    end

    --Value = math.max(1, Value) --minimum 1 discard

    mod.HpEnable = true
    Player:AddMaxHearts(Value*2 - Player:GetMaxHearts())
    mod.HpEnable = false

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.DiscardNumCache, mod.CustomCache.DISCARD_NUM)


---@param Player EntityPlayer
function mod:HandsCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    Value = 25 --starting point

    if Player:HasCollectible(mod.Vouchers.Grabber) then
        Value = Value + 5
    end
    if Player:HasCollectible(mod.Vouchers.NachoTong) then
        Value = Value + 5
    end

    Value = Value - 5* #mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)
    
    if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
        Value = 5
    end

    Value = math.max(Value ,5)

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.HandsCache, mod.CustomCache.HAND_NUM)

-------------CARD TEARS-----------------------
----------------------------------------------




--applies the additional effects for the card tears
---@param Tear EntityTear
---@param Collider Entity
function mod:OnTearCardCollision(Tear,Collider,_)

    local Player = Tear.Parent:ToPlayer() or Tear.Parent
    local TearData = Tear:GetData()
    TearData.CollidedWith = TearData.CollidedWith or {}


    if not Collider:IsActiveEnemy() or mod:Contained(TearData.CollidedWith, GetPtrHash(Collider)) then
        return
    end


    table.insert(TearData.CollidedWith, GetPtrHash(Collider))

    local TearRNG = Tear:GetDropRNG()

    if mod:IsSuit(Player, TearData.Params, mod.Suits.Heart) then --Hearts

        local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Tear.Position, Vector.Zero, Tear, 0, TearRNG:GetSeed()):ToEffect()
        Creep.SpriteScale = Vector(1.2,1.2)
        Creep.CollisionDamage = Tear.CollisionDamage / 6
        ---@diagnostic disable-next-line: need-check-nil
        Creep:Update()
    end
    if mod:IsSuit(Player, TearData.Params, mod.Suits.Club) then --Clubs
        if TearRNG:RandomFloat() < 0.2 then
            Game:BombExplosionEffects(Tear.Position, Tear.CollisionDamage / 2, Player:GetBombFlags(), Color.Default, Tear.Parent, 0.5)
            --Isaac.Explode(Tear.Position, Tear, Tear.CollisionDamage / 2)
        end
    end

    Isaac.RunCallback("CARD_HIT", Tear, Collider)
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.OnTearCardCollision, mod.Tears.CARD_TEAR_VARIANT)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.OnTearCardCollision, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.OnTearCardCollision, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.OnTearCardCollision, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.OnTearCardCollision, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Diamond])


--Split is only given when called in mod:SplitTears()
--ForceCard is Used in mod:JimboTakeDamage(), forcing the tear to be a card and preventig it from giving stats
---@param Tear EntityTear
function mod:AddCardTearFalgs(Tear, Split, ForceCard)

    local Player = Tear.Parent:ToPlayer()

    --print(Tear.Variant, mod.Tears.BANANA_VARIANT)

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType
       or Tear.Variant == TearVariant.ERASER or Tear.Variant == TearVariant.BOBS_HEAD
       or Tear.Variant == TearVariant.KEY or Tear.Variant == TearVariant.KEY_BLOOD
       or Tear.Variant == TearVariant.FETUS or (Tear.Variant == TearVariant.BONE and not Tear:HasTearFlags(TearFlags.TEAR_BONE))
       or Tear.Variant == mod.Tears.BANANA_VARIANT then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local Weapon = Player:GetWeapon(1)
    
    local CardShot
    if Split then
        CardShot = mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].LastShotIndex]
        CardShot.Index = mod.Saved.Jimbo[PIndex].LastShotIndex --could be useful
    else
        CardShot = mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[#mod.Saved.Jimbo[PIndex].CurrentHand]]
        CardShot.Index = mod.Saved.Jimbo[PIndex].CurrentHand[#mod.Saved.Jimbo[PIndex].CurrentHand] --could be useful
    end



    local TearData = Tear:GetData()
    TearData.Params = CardShot
    TearData.Num = mod.Saved.Jimbo[PIndex].Progress.Blind.Shots + 1
    if ForceCard then
        TearData.Num = 0
    end

    TearData.EnableSpawn = not Split

    --damage dealt = Damage * TearRate of the player
    Tear.CollisionDamage = mod.Saved.Jimbo[PIndex].TrueDamageValue * mod.Saved.Jimbo[PIndex].TrueTearsValue

    if Weapon and Weapon:GetModifiers() & WeaponModifier.CHOCOLATE_MILK == WeaponModifier.CHOCOLATE_MILK then
        Tear.CollisionDamage = Tear.CollisionDamage *(0.1 + 0.0527*Weapon:GetCharge())
    end



    if mod:IsSuit(Player, TearData.Params, mod.Suits.Spade, false) then --SPADES
        Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
        Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)

    elseif mod:IsSuit(Player, TearData.Params, mod.Suits.Diamond, false) then
        --Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
        Tear:AddTearFlags(TearFlags.TEAR_BOUNCE)
    end



    if mod.Counters.SinceShoot >= 4 then
        mod.TearCardEnable = true
    end


    --if (mod.TearCardEnable and not Init) or (not mod.TearCardEnable and Init and mod.Counters.SinceShoot > 2) then
    if (ForceCard or mod.TearCardEnable) and not Split then
        
        Tear:ChangeVariant(mod.Tears.CARD_TEAR_VARIANT)

        local TearSprite = Tear:GetSprite()
        TearSprite:Play(ENHANCEMENTS_ANIMATIONS[TearData.Params.Enhancement], true)
        if TearData.Params.Enhancement ~= mod.Enhancement.STONE
           and TearData.Params.Enhancement ~= mod.Enhancement.WILD then

            TearSprite:PlayOverlay(SUIT_ANIMATIONS[TearData.Params.Suit], true)
        end

        Tear.Scale = (Player.SpriteScale.Y + Player.SpriteScale.X) / 2
        Tear.Scale = mod:Clamp(Tear.Scale, 3, 0.75)

        Isaac.CreateTimer(function ()
            if #mod.Saved.Jimbo[PIndex].CurrentHand > Player:GetCustomCacheValue("handsize")
               or not mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].DeckPointer] then
                --having more cards than you should removes the last card

                table.remove(mod.Saved.Jimbo[PIndex].CurrentHand)

            elseif mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].DeckPointer] then
                
                mod:AddValueToTable(mod.Saved.Jimbo[PIndex].CurrentHand, mod.Saved.Jimbo[PIndex].DeckPointer,false,true)
                mod.Saved.Jimbo[PIndex].DeckPointer = mod.Saved.Jimbo[PIndex].DeckPointer + 1
            end
            
            Isaac.RunCallback("DECK_SHIFT",Player)
        end,0,1,true)


        mod.TearCardEnable = false
        mod.Counters.SinceShoot = 0

        if not ForceCard then

            mod.Saved.Jimbo[PIndex].Progress.Room.Shots = mod.Saved.Jimbo[PIndex].Progress.Room.Shots + 1

            if (mod.Saved.Jimbo[PIndex].Progress.Room.Shots == Player:GetCustomCacheValue("hands")
                and not mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR)) --with burglar you can play all your deck
                or not mod.Saved.Jimbo[PIndex].FirstDeck then

                Player:AnimateSad()
            end

            if not Game:GetRoom():IsClear()
               and mod.Saved.Jimbo[PIndex].FirstDeck
               and (mod.Saved.Jimbo[PIndex].Progress.Room.Shots < Player:GetCustomCacheValue("hands")
                    or mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR)) then

                Isaac.RunCallback("CARD_SHOT", Player, CardShot, true)
            end

        end

        mod.Saved.Jimbo[PIndex].LastShotIndex = CardShot.Index

    else
        Tear:ChangeVariant(mod.Tears.SUIT_TEAR_VARIANTS[TearData.Params.Suit])

        local TearSprite = Tear:GetSprite()
        TearSprite:Play("Rotate3", true)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.AddCardTearFalgs)



---@param Bomb EntityBomb
function mod:BombFix(Bomb)

    Isaac.CreateTimer(function ()
        if Bomb.SpawnerEntity:ToTear() then
            return
        end
    
        local Player = Bomb.Parent:ToPlayer() or Bomb.Parent
    
        local Tear = Player:FireTear(Player.Position, Bomb.Velocity)
        Tear.FallingSpeed = Bomb:GetFallingSpeed()
        
        Bomb:Remove()
    end,0,1,false)
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BOMB, mod.BombFix)


function mod:SplitTears(Tear)
    Isaac.CreateTimer(function ()
        if not Tear:GetData().Num then
            mod:AddCardTearFalgs(Tear, true)
        end
    end,0,1,true)
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.SplitTears)


---@param Tear EntityTear
function mod:CardSpoof(Tear)


    if mod.CARD_TEAR_VARIANT == Tear.Variant  then

        local Impact = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, Tear.Position + Vector(0, Tear.Height), Vector.Zero, Tear, 0, 1):ToEffect()
        Impact.SpriteScale = Vector(Tear.Scale, Tear.Scale)

        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.3, 2, false, math.random()*0.5 + 2)

    elseif mod:Contained(mod.Tears.SUIT_TEAR_VARIANTS, Tear.Variant) then

        local Impact = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, Tear.Position + Vector(0, Tear.Height), Vector.Zero, Tear, 0, 1):ToEffect()
        Impact.SpriteScale = Vector(Tear.Scale, Tear.Scale)

        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.3, 2, false, math.random()*0.5 + 2)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.CardSpoof)



--adjusts the card rotation basing on its movement every few frames
---@param Tear EntityTear
function mod:AdjustCardRotation(Tear)
    local Data = Tear:GetData()
    local TearSprite = Tear:GetSprite()
    Tear.Color = Color.Default

    Data.Counter = Data.Counter or 2

    if Data.Counter ~= 2 then
        Data.Counter = Data.Counter + 1
        TearSprite.Rotation = Data.LastRotation or TearSprite.Rotation
        return
    end


    if Tear.WaitFrames == 0 then --travelling like normal
        
        TearSprite.Rotation = (Tear.Velocity + Vector(0,math.min(Tear.FallingSpeed, 0))):GetAngleDegrees()

        Data.LastRotation = TearSprite.Rotation
        Data.Counter = 0

    elseif Tear.WaitFrames == 86 then --just shot with anti-gravity

        local Player = Tear.Parent:ToPlayer()

    
---@diagnostic disable-next-line: need-check-nil
        Data.LastRotation = Player:GetAimDirection():GetAngleDegrees()
        TearSprite.Rotation = Data.LastRotation

    else --stopped in mid-air with anti-gravity
        TearSprite.Rotation = Data.LastRotation or TearSprite.Rotation
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANT)



------------------VARIOUS/UTILITY------------------
------------------------------------------------

--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then

        local PIndex = Player:GetData().TruePlayerIndex
        local PlayerRNG = Player:GetDropRNG()
        mod.Saved.Jimbo[PIndex].FullDeck = mod:Shuffle(mod.Saved.Jimbo[PIndex].FullDeck, PlayerRNG)

        mod.Saved.Jimbo[PIndex].DeckPointer = Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) + 1
        for i=1, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) do
            mod.Saved.Jimbo[PIndex].CurrentHand[i] = i
        end

        Isaac.RunCallback("DECK_SHIFT", Player)
    end
end

--VV sorry, didn't put many comments on these functions and I'm too lazy to do so now (I'll def regret this)

local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")

--allows to activate/disable selection states easily
---@param Player EntityPlayer
function mod:SwitchCardSelectionStates(Player,NewMode,NewPurpose)
    local PIndex = Player:GetData().TruePlayerIndex

    mod.SelectionParams[PIndex].Frames = 0

    if NewMode == mod.SelectionParams.Modes.NONE then

        for i,v in ipairs(Isaac.FindByType(1000, DescriptionHelperVariant, DescriptionHelperSubType)) do
            v:Remove()
        end

        Player:SetCanShoot(true)

        if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STOP_WATCH) then
            music:PitchSlide(0.9)
        else
            music:PitchSlide(1)
        end
        music:VolumeSlide(1, 0.04)

        for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
            mod.SelectionParams[PIndex].SelectedCards[i] = false 
        end
        mod.SelectionParams[PIndex].Index = 1
        mod.SelectionParams[PIndex].SelectionNum = 0
        Game:GetRoom():SetPauseTimer(0)

    else
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE
           and mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.DEATH1 then
            --if changing from an "active" state to another
            mod:UseSelection(Player)
        end

        Game:GetRoom():SetPauseTimer(225)
        Player:SetCanShoot(false)

        Game:Spawn(EntityType.ENTITY_EFFECT, DescriptionHelperVariant, Player.Position
                       ,Vector.Zero, nil, DescriptionHelperSubType, 1)
        
        if NewMode == mod.SelectionParams.Modes.HAND then
            mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Jimbo[PIndex].CurrentHand
            if NewPurpose == mod.SelectionParams.Purposes.HAND then
                mod.SelectionParams[PIndex].MaxSelectionNum = 5
                mod.SelectionParams[PIndex].HandType = mod.HandTypes.NONE
                return
            elseif NewPurpose >= mod.SelectionParams.Purposes.DEJA_VU then
                mod.SelectionParams[PIndex].MaxSelectionNum = 1

            else --various tarot cards
                if NewPurpose == mod.SelectionParams.Purposes.DEATH1 then

                    mod.SelectionParams[PIndex].MaxSelectionNum = 2

                elseif NewPurpose >= mod.SelectionParams.Purposes.WORLD then --any suit based tarot
                    --WORLD, SUN, MOON, STAR
                    mod.SelectionParams[PIndex].MaxSelectionNum = 3

                else --any other card
                    local Size = -(NewPurpose % 2) + 2 --se main.lua to understand why this works
                    if Player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
                        Size = Size + 1
                    end
                    mod.SelectionParams[PIndex].MaxSelectionNum = Size
                end
            end
                
        elseif NewMode == mod.SelectionParams.Modes.PACK then

            music:PitchSlide(1.1)
            music:VolumeSlide(0.45, 0.02)

            mod.SelectionParams[PIndex].MaxSelectionNum = 1
            mod.SelectionParams[PIndex].OptionsNum = #mod.SelectionParams[PIndex].PackOptions

        elseif NewMode == mod.SelectionParams.Modes.INVENTORY then

            if NewPurpose == mod.SelectionParams.Purposes.SMELTER then
                mod.SelectionParams[PIndex].MaxSelectionNum = 1
            else
                mod.SelectionParams[PIndex].MaxSelectionNum = 2
            end

            mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Jimbo[PIndex].Inventory
        end
    end
    mod.SelectionParams[PIndex].Mode = NewMode
    mod.SelectionParams[PIndex].Purpose = NewPurpose

end

--handles the single card selection
---@param Player EntityPlayer
function mod:Select(Player)
    mod.Counters.SinceSelect = 0
    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        --if its an actual option
        if mod.SelectionParams[PIndex].Index <= mod.SelectionParams[PIndex].OptionsNum then
            local Choice = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index]
            
            if Choice then

                sfx:Play(mod.Sounds.DESELECT)

                mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] = false                    
                mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum - 1

            --if it's not currently selected and it doesn't surpass the limit
            elseif mod.SelectionParams[PIndex].SelectionNum < mod.SelectionParams[PIndex].MaxSelectionNum then   
                
                sfx:Play(mod.Sounds.SELECT)
                --confirm the selection
                mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] = true

                mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum + 1

                if mod.SelectionParams[PIndex].MaxSelectionNum == mod.SelectionParams[PIndex].SelectionNum then --DSS TO BE ADDED
                    --makes things faster by automatically activating if you chose the maximum number of cards
                    mod:UseSelection(Player)
                    mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
                    return

                elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.DEATH1 then
                    for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                        if v then
                            DeathCopyCard = mod.Saved.Jimbo[PIndex].CurrentHand[i]
                            break
                        end
                    end
                end 
            end
            if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND then
                --Isaac.RunCallback("HAND_TYPE_UPDATE")
            end

        else--if its the additional confirm button
            --print("confirm")
            mod:UseSelection(Player)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
        end

    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.PACK then

        if mod.SelectionParams[PIndex].Index > mod.SelectionParams[PIndex].OptionsNum then--skip button
            
            Isaac.RunCallback("PACK_SKIPPED", Player, mod.SelectionParams[PIndex].Purpose)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
            return
        end

        local TruePurpose = mod.SelectionParams[PIndex].Purpose & (~mod.SelectionParams.Purposes.MegaFlag) --removes it for pack checks

        sfx:Play(mod.Sounds.SELECT)

        if TruePurpose == mod.SelectionParams.Purposes.StandardPack then
            local SelectedCard = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index]

            mod:AddCardToDeck(Player, SelectedCard, 1, true)

            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, nil, "Added!",mod.Packs.STANDARD)

        elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then

            local Joker = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index].Joker
            local Edition = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index].Edition
            local Index = Level:GetCurrentRoomDesc().ListIndex

            Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET, Player.Position, RandomVector()*3,nil,Joker,Game:GetSeeds():GetStartSeed())
            
            mod.Saved.FloorEditions[Index] = mod.Saved.FloorEditions[Index] or {}
            
            mod.Saved.FloorEditions[Index][ItemsConfig:GetTrinket(Joker).Name] = Edition


        else --tarot/planet/Spectral pack
            local card = mod:FrameToSpecialCard(mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index])
            local RndSeed = Random()
            if RndSeed == 0 then RndSeed = 1 end
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position, RandomVector()* 2, nil, card, RndSeed)
            
        end
        if Player:HasCollectible(mod.Vouchers.MagicTrick) and mod:TryGamble(Player, Player:GetCollectibleRNG(mod.Vouchers.MagicTrick), 0.25)
           and mod.SelectionParams[PIndex].OptionsNum > 1 then

            table.remove(mod.SelectionParams[PIndex].PackOptions, mod.SelectionParams[PIndex].Index)
            mod.SelectionParams[PIndex].OptionsNum = mod.SelectionParams[PIndex].OptionsNum - 1
            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "1 more!",mod.Vouchers.MagicTrick)
            return
        end
        if mod.SelectionParams[PIndex].Purpose & mod.SelectionParams.Purposes.MegaFlag == mod.SelectionParams.Purposes.MegaFlag 
           and mod.SelectionParams[PIndex].OptionsNum then
            
            mod.SelectionParams[PIndex].OptionsNum = mod.SelectionParams[PIndex].OptionsNum - 1
            mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose - mod.SelectionParams.Purposes.MegaFlag
            table.remove(mod.SelectionParams[PIndex].PackOptions, mod.SelectionParams[PIndex].Index)
            return
        end

        mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
        
    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        if mod.SelectionParams[PIndex].Index <= #mod.Saved.Jimbo[PIndex].Inventory then --a joker is selected
            
            local Choice = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index]

            if Choice then
                sfx:Play(mod.Sounds.DESELECT)

                mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] = false
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.NONE

            
            else --if it's not currently selected

                if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SMELTER then --DSS TO BE ADDED
                    mod:UseSelection(Player)
                    mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)
    
                elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SELLING then
                    local FirstI
                    local SecondI = mod.SelectionParams[PIndex].Index
                    for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                        if v then
                           FirstI = i
                           mod.SelectionParams[PIndex].SelectedCards[i] = false
                           break
                        end
                    end

                    sfx:Play(mod.Sounds.SELECT)
                    Isaac.CreateTimer(function ()
                        sfx:Play(mod.Sounds.SELECT,1,2,false, 1.2)
                    end, 3, 1, false)

                    mod.Saved.Jimbo[PIndex].Inventory[FirstI].Joker,mod.Saved.Jimbo[PIndex].Inventory[SecondI].Joker =
                    mod.Saved.Jimbo[PIndex].Inventory[SecondI].Joker,mod.Saved.Jimbo[PIndex].Inventory[FirstI].Joker

                    mod.Saved.Jimbo[PIndex].Progress.Inventory[FirstI],mod.Saved.Jimbo[PIndex].Progress.Inventory[SecondI] =
                    mod.Saved.Jimbo[PIndex].Progress.Inventory[SecondI],mod.Saved.Jimbo[PIndex].Progress.Inventory[FirstI]

                    for _,GiftSlot in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.GIFT_CARD, true)) do

                        mod.Saved.Jimbo[PIndex].Progress.Inventory[GiftSlot][FirstI],mod.Saved.Jimbo[PIndex].Progress.Inventory[GiftSlot][SecondI] = 
                        mod.Saved.Jimbo[PIndex].Progress.Inventory[GiftSlot][SecondI],mod.Saved.Jimbo[PIndex].Progress.Inventory[GiftSlot][FirstI]    
                    
                    end


                    Isaac.RunCallback("INVENTORY_CHANGE", Player)

                    mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.NONE

                elseif mod.Saved.Jimbo[PIndex].Inventory[mod.SelectionParams[PIndex].Index].Joker ~= 0 then
                       
                    sfx:Play(mod.Sounds.DESELECT)

                    mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Index] = true

                    if mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.SMELTER then

                        mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.SELLING
                    end

                end


            end

        else--the confirm button is pressed
        
            if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SMELTER then
                mod:UseSelection(Player)
                mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)

            elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SELLING then
                local SoldSlot
                for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                    if v then
                        SoldSlot = i
                        mod.SelectionParams[PIndex].SelectedCards[i] = false
                       break
                    end
                end
                --print(FirstI)
                local Trinket = mod.Saved.Jimbo[PIndex].Inventory[SoldSlot].Joker

                mod:SellJoker(Player, Trinket, SoldSlot)
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.NONE
            else
                mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)
            end
        end
    end
end


local PurposeEnh = {nil,2,4,9,5,3,6,nil,7,nil,8}
--activates the current selection when finished
---@param Player EntityPlayer
function mod:UseSelection(Player)
    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        --could've done something nicer then these elseifs but works anyways
        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND then
            --effects
            --mod:ActivateHandEffect(Player)
            --card substitution
            --mod:SubstituteCards(mod.SelectionParams[PIndex].SelectedCards)

        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.DEATH1 then --then the card that will become a copy
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    local selection = mod.Saved.Jimbo[PIndex].CurrentHand[i] --gets the card that will be modified
                    mod.Saved.Jimbo[PIndex].FullDeck[selection] = mod.Saved.Jimbo[PIndex].FullDeck[DeathCopyCard]
                    Isaac.RunCallback("DECK_MODIFY", Player)
                end
            end
        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HANGED then
            local selection = {}
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    table.insert(selection, mod.Saved.Jimbo[PIndex].CurrentHand[i]) --gets the card that will be modified
                end
            end

            mod:DestroyCards(Player, selection, true)

        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.STRENGTH then
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    if mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Value == 13 then
                        mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Value = 1 --kings become aces
                    else
                        mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Value = 
                        mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Value + 1
                    end
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)
        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.CRYPTID then
            local Chosen
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    Chosen = mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]]
                    break
                end
            end

            mod:AddCardToDeck(Player, Chosen, 2, true)

        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AURA then
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    local EdRoll = Player:GetCardRNG(mod.Spectrals.AURA):RandomFloat()
                    if EdRoll <= 0.5 then
                        sfx:Play(mod.Sounds.FOIL, 0.6)
                        mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Edition = mod.Edition.FOIL
                    elseif EdRoll <= 0.85 then
                        sfx:Play(mod.Sounds.HOLO, 0.6)
                        mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Edition = mod.Edition.HOLOGRAPHIC
                    else
                        sfx:Play(mod.Sounds.POLY, 0.6)
                        mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Edition = mod.Edition.POLYCROME
                    end
                    break
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player, 0)

        --didn't want to put ~20 more elseifs so did this instead
        elseif mod.SelectionParams[PIndex].Purpose >= mod.SelectionParams.Purposes.DEJA_VU then
            local NewSeal = mod.SelectionParams[PIndex].Purpose - 16 --put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Seal = NewSeal --kings become aces
                    sfx:Play(mod.Sounds.SEAL)
                    break
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)

        elseif mod.SelectionParams[PIndex].Purpose >= mod.SelectionParams.Purposes.WORLD then 
            local NewSuit = mod.SelectionParams[PIndex].Purpose - mod.SelectionParams.Purposes.WORLD + 1--put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Suit = NewSuit
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)
        elseif mod.SelectionParams[PIndex].Purpose >= mod.SelectionParams.Purposes.EMPRESS then
            local NewEnh = PurposeEnh[mod.SelectionParams[PIndex].Purpose] --put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                if v then
                    mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[i]].Enhancement = NewEnh

                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)
        end


    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SMELTER then

            local SelectedSlot = mod:GetValueIndex(mod.SelectionParams[PIndex].SelectedCards, true, true) --finds the first true

            local Joker = mod.Saved.Jimbo[PIndex].Inventory[SelectedSlot].Joker

            if Joker == mod.Jokers.GOLDEN_JOKER then --or Joker == mod.Jokers.GOLDEN_TICKET then
                for i=1, 2 do --gives money 2 golden pennies
                    local Seed = Random()
                    Seed = Seed==0 and 1 or Seed

                    Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,Player.Position,RandomVector()*2,Player,CoinSubType.COIN_GOLDEN,Seed)
                end

                mod:SellJoker(Player, Joker, SelectedSlot)
            else
                mod:SellJoker(Player, Joker, SelectedSlot, 2)
            end

            
        end
    end

    for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
        mod.SelectionParams[PIndex].SelectedCards[i] = false
    end
end



------------ TRASH BIN -------------
-----------------------------------
--[[
function mod:ChangeCurrentHandType()
    
    mod.SelectionParams[PIndex].PossibleHandTypes = mod:DeterminePokerHand()
    mod.SelectionParams[PIndex].HandType = mod:GetMax(mod.SelectionParams[PIndex].PossibleHandTypes)
    if mod.SelectionParams[PIndex].HandType == 10 then
        mod.Saved.Jimbo[PIndex].FiveUnlocked = true
    elseif mod.SelectionParams[PIndex].HandType == 11 then
        mod.Saved.Jimbo[PIndex].FlushHouseUnlocked = true
    elseif mod.SelectionParams[PIndex].HandType == 12 then
        mod.Saved.Jimbo[PIndex].FiveFlushUnlocked = true
    end

end
mod:AddCallback("HAND_TYPE_UPDATE", mod.ChangeCurrentHandType)


function mod:ActivateHandEffect(Player)
    Isaac.RunCallback("HAND_TYPE_UPDATE") --updates a last time to be sure

    --print(mod.SelectionParams[PIndex].HandType)
    --print(mod.Saved.Jimbo[PIndex].HandsStat[1])
    local StatsToGain = mod.Saved.Jimbo[PIndex].HandsStat[mod.SelectionParams[PIndex].HandType]

    
    --local StatsToGain = mod:HandStatCalculatorA(Player)

    --mod:IncreaseJimboStats(Player, StatsToGain.X , StatsToGain.Y)
end

-----------SHADERS----------------
----------------------------------
--man i hate working with shaders... jk i like it now
function mod:PackShader(Name)
    if Name == "Balatro_Pack_Opened" then
        if Game:GetHUD():IsVisible() then
            Game:GetHUD():Render()
            Isaac.RunCallback(ModCallbacks.MC_POST_HUD_RENDER)
        end
        --time is the amount of seconds the player has been choosing for
        local Time = math.min(255, mod.SelectionParams[PIndex].Frames)
        local BackgroundColor = {200,0,0,1}

        local Params = {Time, BackgroundColor}
        return Params
    end
end
--mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.PackShader)



local ShopRestock = false
function mod:OverstockGreedHelper(Partial)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) and not Partial then
        ShopRestock = true

        Isaac.CreateTimer(function()
            ShopRestock = false
        end,1,1, true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_RESTOCK_SHOP, mod.OverstockGreedHelper)




function mod:OverstockGreedJokerFix(Pickup)

    print("remove")

    --exiting the room shouldn't spawn a new trinket
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    Pickup = Pickup:ToPickup()

    local PickupData = Pickup:GetData()

    if not PickupData.OverstockGreed then
        return
    end

    --Isaac.CreateTimer(function ()
        print("try")
        if ShopRestock then
            local ExtraTrinket = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                                                    Pickup.Position,Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(mod.Saved.GeneralRNG).Joker, Pickup.InitSeed):ToPickup()
    
            ExtraTrinket:MakeShopItem(6) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()
        
            local JokerData = ExtraTrinket:GetData()
            JokerData.OverstockGreed = true
        end
    --end, 1,1, true)
    

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.OverstockGreedJokerFix, EntityType.ENTITY_PICKUP)

--handles the shooting 
function mod:JimboShootCardTear(Player,Direction)

    if true then
        return
    end

    local CardShot = mod.Saved.Jimbo[PIndex].FullDeck[mod.Saved.Jimbo[PIndex].CurrentHand[mod.Saved.Jimbo[PIndex].HandSize] ]
    CardShot.Index = mod.Saved.Jimbo[PIndex].CurrentHand[mod.Saved.Jimbo[PIndex].HandSize] --could be useful

    LastCardFullPoss[CardShot.Index] = nil --needed to make the Hand HUD work properly

    --considers the possible ammounts of tears fired
    local ShotParams = Player:GetMultiShotParams()

    local MaxSpread = ShotParams:GetSpreadAngle(WeaponType.WEAPON_TEARS) --half the total angle the tears spread 
    local EyeAngle = ShotParams:GetMultiEyeAngle() --angle used to determine if player has Wiz or not
    local NumTears = ShotParams:GetNumTears() --tears the player fires simultaneusly
    local NumLanes = ShotParams:GetNumLanesPerEye() --similar to numtears, but dicates how the tears get shot

    local Spread = 0
    if NumLanes > 1 then
        Spread = (MaxSpread / (NumLanes - 1)) * 2
    end
    if EyeAngle == 45 then --if player has the wiz
        for i=1,-1,-2 do 
            local BaseAngle = EyeAngle * i --sets +45° and -45° as the base angle

            for j=0, NumTears/2 -1 do --for each eye
                --modifies additionally the angle if you also have stuff like QuadShot
                local FireAngle = (BaseAngle+(MaxSpread - Spread*j)) + Direction:GetAngleDegrees()
                local ShootDirection = (Vector.FromAngle(FireAngle) *10 + Player.Velocity)*Player.ShotSpeed

                local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)


            end
        end
    else --player does not have the wiz
        for i=0, NumTears-1 do
            local FireAngle = (MaxSpread - Spread*i) + Direction:GetAngleDegrees()
            local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10*Player.ShotSpeed


            if Player:GetWeaponModifiers() & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG then
                
                for i = 0, Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)*13 do
                    local TrueDirection = ShootDirection:Rotated(math.random(-12,12))

                    Player:FireTear(Player.Position, TrueDirection, true, false, true, Player)
                end
                
            else
                Player:FireTear(Player.Position, ShootDirection, true, false, true, Player)
            end

            
            
            --mod:AddCardTearFalgs(Tear, CardShot)
        end
    end

    mod.Counters.SinceShoot = 0

    
    mod.Saved.Jimbo[PIndex].CurrentHand[mod.Saved.Jimbo[PIndex].HandSize -mod.Saved.Jimbo[PIndex].Progress.Hand] = 0 --removes the used card
    mod.Saved.Jimbo[PIndex].Progress.Hand = mod.Saved.Jimbo[PIndex].Progress.Hand + 1

    if mod.Saved.Jimbo[PIndex].Progress.Hand > mod.Saved.Jimbo[PIndex].HandSize then--if all the hand is empty replace it with a new one
        for i=1, mod.Saved.Jimbo[PIndex].HandSize do
            mod.Saved.Jimbo[PIndex].CurrentHand[i] = mod.Saved.Jimbo[PIndex].DeckPointer
            mod.Saved.Jimbo[PIndex].DeckPointer = mod.Saved.Jimbo[PIndex].DeckPointer +1
        end
        mod.Saved.Jimbo[PIndex].Progress.Hand = 1
    end
end



]]--


