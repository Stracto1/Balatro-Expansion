local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local music = MusicManager()


local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Gold","Lucky"}
local SUIT_ANIMATIONS = {"Spade","Heart","Club","Diamond"}

local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
local JOKER_OVERLAY_LENGTH = TrinketSprite:GetAnimationData("Idle"):GetLength()

local JIMBO_BASE_TEARS = 3 --it's actually 1+ this value


local BasicRoomNum = 0
local NumShops = 0

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
        Data.SinceCardShoot = 0

        Data.EnableFireDelayModify = true

        --player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)

        player:AddCustomCacheTag(mod.CustomCache.HAND_COOLDOWN, true)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)


local function SetupTJimboUnlock()

    local Room = Game:GetRoom()

    if not mod:IsSecretCloset() 
       or Isaac.GetPersistentGameData():Unlocked(mod.Achievements.T_JIMBO)
       or not Room:IsFirstVisit() then
        return
    end

    local FirstPlayerType = Game:GetPlayer(0):GetPlayerType() --specifically needs the first player to determine wheter to spawn jimbo or not

    if FirstPlayerType ~= mod.Characters.JimboType then
        return
    end


    local RoomCenter = Room:GetCenterPos()

    Isaac.CreateTimer(function () --freakin timers man
        Isaac.CreateTimer(function ()
            for _,Entity in ipairs(Isaac.GetRoomEntities()) do
            
                if Entity.Type == 5 and Entity.Variant == PickupVariant.PICKUP_COLLECTIBLE
                   or Entity.Type == EntityType.ENTITY_SHOPKEEPER then
                    Entity:Remove() --removes the inner child/shopkeeper that normally spawns
                end
            end
        end, 1, 1, true)
    end, 0, 1, true)
        


    local DeadDude = Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER, RoomCenter,
                                Vector.Zero, nil, mod.Entities.CLOSET_JIMBO_SUBTYPE, 1)

    local SkinSheet = EntityConfig.GetPlayer(mod.Characters.TaintedJimbo):GetSkinPath()
    SkinSheet = string.gsub(SkinSheet, "%.png", "_white.png") --the other sheets are useless for this character 


    DeadDude:GetSprite():ReplaceSpritesheet(0, SkinSheet, true)

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SetupTJimboUnlock)

local function TJimboUnlock(_, Slot)

    if Slot.Variant ~= SlotVariant.HOME_CLOSET_PLAYER
       and Slot.SubType ~= mod.Entities.CLOSET_JIMBO_SUBTYPE then
        return
    end

    if Slot:GetSprite():IsEventTriggered("Poof") then
        Isaac.GetPersistentGameData():TryUnlock(mod.Achievements.T_JIMBO)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, TJimboUnlock)



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

    Data.SinceCardShoot = Data.SinceCardShoot + 1

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

            local LastCard = mod.Saved.Player[PIndex].CurrentHand[#mod.Saved.Player[PIndex].CurrentHand]

            table.remove(mod.Saved.Player[PIndex].CurrentHand)
            table.insert(mod.Saved.Player[PIndex].CurrentHand,1 ,LastCard)

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


local CoinQuality = {[CoinSubType.COIN_PENNY] = 1, 
                    [CoinSubType.COIN_DOUBLEPACK] = 2, 
                    [CoinSubType.COIN_STICKYNICKEL] = 3, 
                    [CoinSubType.COIN_NICKEL] = 3, 
                    [CoinSubType.COIN_LUCKYPENNY] = 4, 
                    [CoinSubType.COIN_GOLDEN] = 0.5, 
                    [CoinSubType.COIN_DIME] = 5}
--removes some coins spawned by the game
---@param Pickup EntityPickup
function mod:LessCoins(Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    --try to remove if not spawned by a player
    if Pickup.SpawnerEntity and Pickup.SpawnerType == EntityType.ENTITY_PLAYER then
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

    local RollRNG = Game:GetPlayer(0):GetTrinketRNG(mod.Jokers.JOKER) --tried using the rng from the callback but it gave the same results each time


    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       or not (ReqSubType == 0 or ReqVariant == 0) then

        return
    end

    
    if Game:GetRoom():GetType() == RoomType.ROOM_SHOP and Pickup:IsShopItem() then

        if Pickup.ShopItemId <= 1 then --card pack
            ReturnTable = {PickupVariant.PICKUP_TAROTCARD, mod:RandomPack(RollRNG), false}

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
                for i=1, mod:GetValueRepetitions(mod.Saved.Player[PIndex].Inventory.Jokers, TrinketType.OOPS) do
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


        local RandomJoker = mod:RandomJoker(RollRNG, true, false, false)

        --print(RandomJoker.Joker, RandomJoker.Edition, RandomJoker.Joker | mod.EditionFlag[RandomJoker.Edition])

        ReturnTable = {PickupVariant.PICKUP_TRINKET, RandomJoker.Joker | mod.EditionFlag[RandomJoker.Edition] ,false}

        --mod.Saved.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(RandomJoker.Joker).Name] = RandomJoker.Edition
    
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
    
        local Joker = SubType & ~mod.EditionFlag.ALL
        local Edition = (SubType & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT

        Cost = mod:GetJokerCost(Joker, Edition)
    
        --Cost = mod:GetJokerCost(SubType, mod.Saved.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(SubType).Name] or 0)

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
        Cost = Cost * 2 - PlayerManager.GetNumCollectibles(CollectibleType.COLLECTIBLE_STEAM_SALE) --nullifies the usual steam sale effect and subratcts 1 instead
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        
        Cost = Cost - #mod:GetJimboJokerIndex(Player, mod.Jokers.GIFT_CARD)
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



local function ResetNumFloorShops()

    NumShops = 0
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, ResetNumFloorShops)




--modifies the floor generation and calculates the number of normal rooms
---@param RoomConfig RoomConfigRoom
---@param LevelGen LevelGeneratorRoom
function mod:FloorModifier(LevelGen,RoomConfig,Seed)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end
    local RoomIndex = LevelGen:Column() + LevelGen:Row()*13
    
    --print(RoomIndex)

    if RoomConfig.Type == RoomType.ROOM_SHOP then

        NumShops = NumShops + 1

        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
            ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_4
        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
            ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_5
        end

        if RoomConfig.Subtype ~= ShopQuality then --get anew shop if  the one got isn't good

            local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

            Isaac.CreateTimer(
            function()
                Level:GetRoomByIdx(RoomIndex).DisplayFlags = 5

                Level:UpdateVisibility()
            end, 1, 1, true)

            return NewRoom --replaces the room with the new one
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



local function AddOneMoreShop()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       or Game:IsGreedMode() then
        return    
    end

    local NeededShops = 0

    local SmallAvailable, BigAvailable = mod:GetJimboBlindAvailability()

    if SmallAvailable then
        NeededShops = NeededShops + 1
    end
    if BigAvailable then
        NeededShops = NeededShops + 1
    end

    NeededShops = math.max(1, NeededShops) --at least one every floor even without blinds to defeat


    local MissingShops = NeededShops - NumShops
    
    for i = 1, MissingShops do

        local Level = Game:GetLevel()

        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
            ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_5
        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
            ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_4
        end

        local Seed = Level:GetDungeonPlacementSeed()

        local ExtraShop = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

        local IsSmallFloor = Level:GetStage() <= LevelStage.STAGE1_2 or Level:IsAscent()

        local StartIndex = Level:GetStartingRoomIndex()
        local StartPos = Vector(StartIndex % 13, StartIndex // 13)

        local ValidIndexes = Level:FindValidRoomPlacementLocations(ExtraShop, Dimension.NORMAL, false, false)


        local RoomDesc

        for _,Index in ipairs(ValidIndexes) do

            local RoomPos = Vector(Index % 13, Index // 13)

            if IsSmallFloor
               or math.abs(RoomPos.X - StartPos.X) > 1
                  and math.abs(RoomPos.Y - StartPos.Y) > 1 then --keep a slight distance from the starting room if possible


                RoomDesc = Level:TryPlaceRoom(ExtraShop, Index, Dimension.NORMAL)

                if RoomDesc then
                    break
                end
            end
        end

        Isaac.CreateTimer(
            function()
                RoomDesc.DisplayFlags = 5

                Level:UpdateVisibility()
            end, 1, 1, true)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, AddOneMoreShop)



--calculates how big the blinds are 
function mod:CalculateBlinds()

    local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)

    if not Jimbo or not mod.GameStarted then
        return
    end


    local NumPacks = 1
    local BlindsSkipped = 0
    local SkippedFlag = 0

    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        
        if Player:GetPlayerType() == mod.Characters.JimboType then
            NumPacks = NumPacks + 1
        end
    end

    if mod.Saved.SmallCleared == mod.BlindProgress.NOT_CLEARED then
        BlindsSkipped = BlindsSkipped + 1
        SkippedFlag = SkippedFlag & mod.BLINDS.SMALL
    end
    if mod.Saved.BigBlind == mod.BlindProgress.NOT_CLEARED then
        BlindsSkipped = BlindsSkipped + 1
        SkippedFlag = SkippedFlag & mod.BLINDS.BIG
    end
    if mod.Saved.BossCleared == mod.BlindProgress.NOT_CLEARED then
        BlindsSkipped = BlindsSkipped + 1
        SkippedFlag = SkippedFlag & mod.BLINDS.BOSS
    end




    Isaac.CreateTimer(function ()
        
    local Interval = 10
    local PACK_INTEVAL = 5

    if mod.Saved.SmallCleared == mod.BlindProgress.NOT_CLEARED then

        Isaac.CreateTimer(function ()
            Isaac.CreateTimer(function ()

                local Pack = mod:RandomPack(mod.RNGs.SKIP_TAGS, false)

                Game:Spawn(5, 300, Jimbo.Position, RandomVector()*5, Jimbo, Pack, mod:RandomSeed(mod.RNGs.SKIP_TAGS))

            end, PACK_INTEVAL, NumPacks, true)
            sfx:Play(mod.Sounds.SKIP_TAG, 1, 2, false, 0.95 + math.random()*0.1)
        end, Interval, 1, true)

        Interval = Interval + PACK_INTEVAL*NumPacks + 15

        mod:CreateBalatroEffect(Jimbo, mod.EffectColors.YELLOW ,mod.Sounds.ACTIVATE, "Skipped!", mod.EffectType.ENTITY, Jimbo)
    end
    if mod.Saved.BigBlind == mod.BlindProgress.NOT_CLEARED then

        Isaac.CreateTimer(function ()
            Isaac.CreateTimer(function ()
                
                local Pack = mod:RandomPack(mod.RNGs.SKIP_TAGS, false)
            
                Game:Spawn(5, 300, Jimbo.Position, RandomVector()*5, Jimbo, Pack, mod:RandomSeed(mod.RNGs.SKIP_TAGS))
            
            end, PACK_INTEVAL, NumPacks, true)

            sfx:Play(mod.Sounds.SKIP_TAG, 1, 2, false, 0.95 + math.random()*0.1)
        end, Interval, 1, true)

        Interval = Interval + PACK_INTEVAL*NumPacks + 15

        mod:CreateBalatroEffect(Jimbo, mod.EffectColors.YELLOW ,mod.Sounds.ACTIVATE, "Skipped!", mod.EffectType.ENTITY, Jimbo)
    
    end
    if mod.Saved.BossCleared == mod.BlindProgress.NOT_CLEARED then

        Isaac.CreateTimer(function ()
            Isaac.CreateTimer(function ()
                
                local Pack = mod:RandomPack(mod.RNGs.SKIP_TAGS, false)
            
                Game:Spawn(5, 300, Jimbo.Position, RandomVector()*5, Jimbo, Pack, mod:RandomSeed(mod.RNGs.SKIP_TAGS))
            
            end, PACK_INTEVAL, NumPacks, true)
            sfx:Play(mod.Sounds.SKIP_TAG, 1, 2, false, 0.95 + math.random()*0.1)
        end, Interval, 1, true)

        Interval = Interval + PACK_INTEVAL*NumPacks + 15

        mod:CreateBalatroEffect(Jimbo, mod.EffectColors.YELLOW ,mod.Sounds.ACTIVATE, "Skipped!", mod.EffectType.ENTITY, Jimbo)
    
    end

    end,0,1,true)


    if BlindsSkipped ~= 0 then

        mod.Saved.RunSkippedBlinds = mod.Saved.RunSkippedBlinds + BlindsSkipped

        Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, SkippedFlag)
    end


    local SmallAvailable, BigAvailable, BossAvailable = mod:GetJimboBlindAvailability()

    mod.Saved.SmallCleared = SmallAvailable and mod.BlindProgress.NOT_CLEARED or mod.BlindProgress.CLEARED
    mod.Saved.BigCleared = BigAvailable and mod.BlindProgress.NOT_CLEARED or mod.BlindProgress.CLEARED
    mod.Saved.BossCleared = BossAvailable and mod.BlindProgress.NOT_CLEARED or mod.BlindProgress.CLEARED
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.CalculateBlinds)
--mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE,mod.CalculateBlinds)


--handles the rooms which are cleared by default and shuffles if they are not
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
                                                    Vector(840,320),Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(Game:GetPlayer(0):GetCollectibleRNG(mod.Vouchers.Overstock), true, false, false).Joker, Seed):ToPickup()

                    ---@diagnostic disable-next-line: need-check-nil
                    ExtraTrinket:MakeShopItem(-2) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()

                    ---@diagnostic disable-next-line: need-check-nil
                    local JokerData = ExtraTrinket:GetData()
                    JokerData.OverstockGreed = true
                end
                if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then

                    local ExtraTrinket = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                                                    Vector(940,320),Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(Game:GetPlayer(0):GetCollectibleRNG(mod.Vouchers.OverstockPlus), true, false, false).Joker, Seed):ToPickup()
                    
                    ---@diagnostic disable-next-line: need-check-nil
                    ExtraTrinket:MakeShopItem(-2) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()

                    ---@diagnostic disable-next-line: need-check-nil
                    local JokerData = ExtraTrinket:GetData()
                    JokerData.OverstockGreed = true
                end


            else
                Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                       Game:GetRoom():GetGridPosition(25),Vector.Zero, nil, 0, Seed)

                Isaac.CreateTimer(function ()
                    if mod.Saved.SmallCleared == mod.BlindProgress.DEFEATED then
                    
                        Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BIG)
                    else
                        Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.SMALL)
                    end
                end, 8, 1, true)
                
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
                                                Pickup.Position,Vector.Zero, PlayerManager.FirstPlayerByType(mod.Characters.JimboType), mod:RandomJoker(Game:GetPlayer(0):GetCollectibleRNG(mod.Vouchers.Overstock), true, false, false).Joker, Pickup.InitSeed):ToPickup() or Pickup

        ExtraTrinket:MakeShopItem(6) -- for whatever reason i can't make this turn into an joker with the usual callback, so i made mod:GreedJokerFix()

        local JokerData = ExtraTrinket:GetData()
        JokerData.OverstockGreed = true

    end,0,1,false)

    
    

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.OverstockGreedJokerFix, EntityType.ENTITY_PICKUP)




function mod:AddRoomsCleared(IsBoss, Hostile)

    --Isaac.DebugString("BALATRO Room cleared")

    local IsGreed = Game:IsGreedMode()

    if IsGreed then

        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            if Player:GetPlayerType() == mod.Characters.JimboType then

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, Player.Position + RandomVector() * 5,Vector.Zero,nil,0,1)
                
                local Hearts = 2

                Hearts = Hearts + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.DRUNKARD)
                Hearts = Hearts + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.MERRY_ANDY)

                Player:AddHearts(Hearts)

                if Hostile then
                    mod:FullDeckShuffle(Player)
                end
            end
        end
    else
        for i,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType then

                if not Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                    ---@diagnostic disable-next-line: param-type-mismatch
                    mod:StatReset(Player, true, true, true, false, true)
                end

                if Hostile then
                    mod:FullDeckShuffle(Player)
                end

                if mod:IsBeastBossRoom() then
                    Player:SetFullHearts()
                else

                    local Hearts = 2

                    Hearts = Hearts + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.DRUNKARD)
                    Hearts = Hearts + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.MERRY_ANDY)

                    Player:AddHearts(Hearts)
                end

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, Player.Position + Vector(0,7),Vector.Zero,nil,0,1) 
            end
        end
    end


    if Game:GetLevel():GetDimension() ~= Dimension.NORMAL or IsGreed then
        return
    end


    if IsBoss and mod.Saved.BossCleared ~= mod.BlindProgress.DEFEATED then
       --and (Game:GetLevel():GetStage() ~= LevelStage.STAGE7 or Game:GetRoom():GetDeliriumDistance() == 0) then

        
        if Game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == 0
           or Game:GetRoom():IsCurrentRoomLastBoss() then

            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BOSS)
        end
    end
end
mod:AddPriorityCallback("TRUE_ROOM_CLEAR",CallbackPriority.LATE, mod.AddRoomsCleared)


--activates whenever the deckpointer is shifted
---@param Player EntityPlayer
function mod:OnDeckShift(Player)

    Isaac.DebugString("BALATRO deck shift")

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    --shuffle the deck if finished
    if not next(mod.Saved.Player[PIndex].CurrentHand) then

        mod.Saved.Player[PIndex].FirstDeck = false

        if mod.Saved.Player[PIndex].FirstDeck and mod:GetJimboTriggerableCards(Player) > 0 then
             --no more stat boosts from cards in the cuurent room
            Player:AnimateSad()
        end
        mod:FullDeckShuffle(Player)
    end

    mod.Counters.SinceShift = 0
end
mod:AddCallback("DECK_SHIFT", mod.OnDeckShift)



function mod:GiveRewards(BlindType)

    --Isaac.DebugString("BALATRO blind clear")

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    sfx:Play(mod.Sounds.TIMPANI)
    if BlindType == mod.BLINDS.SMALL then
        mod.Saved.SmallCleared = mod.BlindProgress.DEFEATED
    elseif BlindType == mod.BLINDS.BIG then
        mod.Saved.BigCleared = mod.BlindProgress.DEFEATED
    elseif BlindType == mod.BLINDS.BOSS then
        mod.Saved.BossCleared = mod.BlindProgress.DEFEATED
    end

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

            if not Game:IsGreedMode() 
               and Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            
                mod:StatReset(Player, true, true, true, false, true)
            end

            ToTheMoonNum = ToTheMoonNum + #mod:GetJimboJokerIndex(Player, mod.Jokers.TO_THE_MOON)

            --Jimbo:AddHearts(Jimbo:GetHeartLimit()) --fully heals 

            Isaac.CreateTimer(function ()
                if BlindType == mod.BLINDS.SMALL then

                    mod.Saved.SmallCleared = mod.BlindProgress.DEFEATED
                    
                    Player:AddCoins(4)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+4 $", mod.EffectType.ENTITY, Player)
                    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BIG)

                elseif BlindType == mod.BLINDS.BIG then

                    mod.Saved.BigCleared = mod.BlindProgress.DEFEATED

                    Player:AddCoins(5)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+5 $", mod.EffectType.ENTITY, Player)
                    --Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BOSS)
                    
                elseif BlindType == mod.BLINDS.BOSS then

                    mod.Saved.BossCleared = mod.BlindProgress.DEFEATED

                    Player:AddCoins(6)
                    mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+6 $", mod.EffectType.ENTITY, Player)
    
                end
            end, 15,1, true)
            
        end
    end

    Interests = Interests * (ToTheMoonNum+1)


    --gives interest
    Isaac.CreateTimer(function ()
        local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType) or Game:GetPlayer(0)

        for i = 1, Interests do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Jimbo.Position,
                       RandomVector() * 4, PlayerManager.FirstPlayerByType(mod.Characters.JimboType),
                       CoinSubType.COIN_PENNY, Seed)

            --Balatro_Expansion:EffectConverter(8,0,Jimbo,4) a relic from old times
        end
        mod:CreateBalatroEffect(Jimbo,mod.EffectColors.YELLOW ,mod.Sounds.MONEY, "+"..tostring(Interests).." $", mod.EffectType.ENTITY, Jimbo)
    end, 30, 1, true)
end
mod:AddCallback(mod.Callbalcks.BLIND_CLEAR, mod.GiveRewards)


---@param RNG RNG 
function mod:JimboTrinketPool(_, RNG)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    local Joker = mod:RandomJoker(RNG, true, false, false).Joker

    return Joker
end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.JimboTrinketPool)


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

        Isaac.RunCallback("HAND_DISCARD", Player, #mod.Saved.Player[PIndex].CurrentHand) --various joker/card effects

        mod:DiscardSwoosh(Player)
        
        for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do

            local RandomDirection = RandomVector()
            
            mod.TearCardEnable = false
            Player:GetData().SinceCardShoot = 0

            local Tear = Player:FireTear(Player.Position, 10*Player.ShotSpeed * RandomDirection + Player:GetTearMovementInheritance(RandomDirection), true, true, true, Player)
            mod:AddCardTearFalgs(Tear, false, true)
            Tear:GetData().WasDiscarded = true

            mod.Saved.Player[PIndex].CurrentHand[i] = nil
        end

        for i=1, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) do

            table.insert(mod.Saved.Player[PIndex].CurrentHand, 1, mod.Saved.Player[PIndex].DeckPointer)
            mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 1
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
                local RPack = mod:RandomPack(Player:GetDropRNG())

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


function mod:JimboRoomClear(Player)

    local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)

    if not Jimbo 
       or Player:GetData().TruePlayerIndex ~= Jimbo:GetData().TruePlayerIndex then
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

        local IsFloorStarter = CurrentWave == 1
        local IsFirstWave = IsFloorStarter or CurrentWave == WantedWaves[2]-1 or CurrentWave == WantedWaves[3]

        if IsFirstWave then

            Isaac.CreateTimer(function ()
                mod:OnNewRoomJokers()
            end, 0, 1, true)
        end

        Isaac.RunCallback("TRUE_ROOM_CLEAR", CurrentWave == WantedWaves[3], false)
        
    else
        local Room = Game:GetRoom():GetType()

        Isaac.RunCallback("TRUE_ROOM_CLEAR", Room == RoomType.ROOM_BOSS, true)


        --if Room == RoomType.ROOM_DEFAULT
        --   or Room == RoomType.ROOM_MINIBOSS then
        --
        --    Isaac.RunCallback("TRUE_ROOM_CLEAR",false, true)
        --elseif Room == RoomType.ROOM_BOSS then
        --    Isaac.RunCallback("TRUE_ROOM_CLEAR",true, true)
        --else
        --    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        --        if Player:GetPlayerType() == mod.Characters.JimboType then
        --            Player:AddHearts(2)
        --            mod:FullDeckShuffle(Player)
        --        end
        --    end
        --end


    end
    
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.JimboRoomClear)


function GreedmodeLastWaveClear()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       or not Game:IsGreedMode() then
        return
    end

    local CurrentWave = Level.GreedModeWave
    local WantedWaves
    if Game:IsHardMode() then
        WantedWaves = {9,11,12} --greedier last waves
    else
        WantedWaves = {8,10,11} --greed last waves
    end

    
    local BlindCleared

    if CurrentWave == WantedWaves[1] then
        
        BlindCleared = mod.BLINDS.SMALL

    elseif CurrentWave == WantedWaves[2] then
        BlindCleared = mod.BLINDS.BIG

    elseif CurrentWave == WantedWaves[3] then
        BlindCleared = mod.BLINDS.BOSS
    end


    if BlindCleared then

        Isaac.RunCallback("TRUE_ROOM_CLEAR", BlindCleared == mod.BLINDS.BOSS, true)

        Isaac.RunCallback("BLIND_CLEARED", BlindCleared)

        --as the button is first pressed, reset stats and deck
        for i,Player in ipairs(PlayerManager.GetPlayers()) do
        
            if Player:GetPlayerType() == mod.Characters.JimboType then
            
                if not Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                   or BlindCleared == mod.BLINDS.BOSS then
                
                    ---@diagnostic disable-next-line: param-type-mismatch
                    mod:StatReset(Player, true, true, true, false, true)
                end
            
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, GreedmodeLastWaveClear)



-----------------------JIMBO STATS-----------------------
----------------------------------------------------------

--these calculations are used for normal items, NOT stats given by jokers or mod related stuff, as they are flat stat ups


function mod:JokerStatReset(Player, Cache)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo
       or not mod.GameStarted then
        return
    end

    if not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    --Isaac.DebugString("-----START RESET------")

    --resets the jokers stat boosts every evaluation since otherwise they would infinitely stack
    mod:StatReset(Player, Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE,
                  Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY,
                  false, true, false)

    --Isaac.DebugString("-----END RESET------")
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,mod.JimboStatPriority.JOKER_RESET, mod.JokerStatReset)

---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboStatCalculator(Player, Cache)

    --Isaac.DebugString("BALATRO stat calculator")

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    if not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    --literally spent hours making calculations for stats just to realize that 1 single ratio is the best thing to do

    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then

        Player.Damage = (Player.Damage / 3.50)
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then

        Player.MaxFireDelay = mod:CalculateMaxFireDelay((mod:CalculateTears(Player.MaxFireDelay)/ 2.7272))
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,mod.JimboStatPriority.CALCULATE, mod.JimboStatCalculator)


---@param Player EntityPlayer
function mod:StatReset(Player, Damage, Tears, Evaluate, Jokers, Basic)

    --Isaac.DebugString("BALATRO stat reset  ("..tostring(Evaluate)..")")

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if not mod.Saved.Player[PIndex] then
        return
    end

    if Damage then
        if Basic then
            mod.Saved.Player[PIndex].StatsToAdd.Damage = 0
            mod.Saved.Player[PIndex].StatsToAdd.Mult = 1
        end
        if Jokers then
            mod.Saved.Player[PIndex].StatsToAdd.JokerDamage = 0
            mod.Saved.Player[PIndex].StatsToAdd.JokerMult = 1
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
    if Tears then
        if Basic then
            mod.Saved.Player[PIndex].StatsToAdd.Tears = 0
        end
        if Jokers then
            mod.Saved.Player[PIndex].StatsToAdd.JokerTears = 0
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end

    if Basic then
        
        local EffectColor
        if Damage then
            
            if Tears then
                EffectColor = mod.EffectColors.YELLOW
            else
                EffectColor = mod.EffectColors.RED
            end

        elseif Tears then

            EffectColor = mod.EffectColors.BLUE
        else
            return
        end

        mod:CreateBalatroEffect(Player, EffectColor ,mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.ENTITY, Player)
    end
end


--local LibraEnable = true
--finally gives the actual stat changes to jimbo, also used for always active buffs
---@param Player EntityPlayer
function mod:StatGiver(Player, Cache)

    --Isaac.DebugString("BALATRO stat giver")

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if not mod.Saved.Player[PIndex] then
        return
    end

    local stats = mod.Saved.Player[PIndex].StatsToAdd

    if Player:GetPlayerType() == mod.Characters.JimboType then
        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then

        local BaseDamage = Player.Damage + 0

        --Player.Damage = (Player.Damage + (stats.Damage + stats.JokerDamage) * Player.Damage) * stats.JokerMult * stats.Mult
        mod.Saved.Player[PIndex].TrueDamageValue = (BaseDamage + stats.Damage + stats.JokerDamage) * stats.JokerMult * stats.Mult

        mod.Saved.Player[PIndex].TrueDamageValue = math.max(mod.Saved.Player[PIndex].TrueDamageValue, BaseDamage)

        elseif Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then

            local BaseTears = JIMBO_BASE_TEARS * mod:CalculateTearsValue(Player)
            
            mod.Saved.Player[PIndex].TrueTearsValue = BaseTears + (stats.Tears +  stats.JokerTears)
        end

        --changing stats the next frame sadly causes some "jiggling" fpr the stats values, but it's needed due to
        --how libra and the minimum damage cap (0.5) work, but these ifs at leat limit the ammount of situations they can appear in
        if Player:HasCollectible(CollectibleType.COLLECTIBLE_LIBRA) then

            local HalfStat = (mod.Saved.Player[PIndex].TrueDamageValue + mod.Saved.Player[PIndex].TrueTearsValue)/2
            --local HalfStat = ((mod.Saved.Player[PIndex].TrueDamageValue + mod.Saved.Player[PIndex].TrueTearsValue)/4)^0.5 --halfes the total card damage

            if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE 
               or Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then

                mod.Saved.Player[PIndex].TrueDamageValue = HalfStat
                mod.Saved.Player[PIndex].TrueTearsValue = HalfStat
            end
        end

        Player.Damage = mod.Saved.Player[PIndex].TrueDamageValue
        Player.MaxFireDelay = mod:CalculateMaxFireDelay(mod.Saved.Player[PIndex].TrueTearsValue)

        Isaac.CreateTimer(function ()
            Player.Damage = mod.Saved.Player[PIndex].TrueDamageValue
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(mod.Saved.Player[PIndex].TrueTearsValue)
        end,0,1,true)
    else

        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then

            --Player.Damage = (Player.Damage + (stats.Damage + stats.JokerDamage) * Player.Damage) * stats.JokerMult * stats.Mult
            Player.Damage = (Player.Damage + stats.Damage + stats.JokerDamage) * stats.JokerMult * stats.Mult

        elseif Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            
            Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, stats.Tears +  stats.JokerTears)
        end

    end

end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,mod.JimboStatPriority.GIVE, mod.StatGiver)


function mod:IncreaseJimboStats(Player,TearsUp,DamageUp,Mult, Evaluate, Basic)

    local PIndex = Player:GetData().TruePlayerIndex

    if Basic then
        mod.Saved.Player[PIndex].StatsToAdd.Damage = mod.Saved.Player[PIndex].StatsToAdd.Damage + DamageUp
        mod.Saved.Player[PIndex].StatsToAdd.Tears = mod.Saved.Player[PIndex].StatsToAdd.Tears + TearsUp
        mod.Saved.Player[PIndex].StatsToAdd.Mult = mod.Saved.Player[PIndex].StatsToAdd.Mult * Mult
    else
        mod.Saved.Player[PIndex].StatsToAdd.JokerDamage = mod.Saved.Player[PIndex].StatsToAdd.JokerDamage + DamageUp
        mod.Saved.Player[PIndex].StatsToAdd.JokerTears = mod.Saved.Player[PIndex].StatsToAdd.JokerTears + TearsUp
        mod.Saved.Player[PIndex].StatsToAdd.JokerMult = mod.Saved.Player[PIndex].StatsToAdd.JokerMult * Mult
    end

    mod:EnsurePlayCD(Player)
    
    
    if Evaluate then
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        --print(mod.Saved.Player[PIndex].StatsToAdd.Tears)
    end

end


function mod:AlwaysMaxCoins(Player, CustomCache, _)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then

        if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DEEP_POCKETS) then
            return 9999
        else
            return 999
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.AlwaysMaxCoins, "maxcoins")



---@param Player EntityPlayer
function mod:PlayCDCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted
       or not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
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
function mod:EnsurePlayCD(Player)

    if not mod.GameStarted then return end

    local Data = Player:GetData()

    if Player.FireDelay <= 0 then 
        Data.EnableFireDelayModify = true
        return 
    end

    if Player:GetPlayerType() == mod.Characters.JimboType then

        local IsEqual = math.abs(Player.FireDelay - Player.MaxFireDelay) < 0.005 --prevents big floating errors

        if IsEqual and Data.EnableFireDelayModify then

            local TrueMaxDelay = Player:GetCustomCacheValue(mod.CustomCache.HAND_COOLDOWN)

            Player.FireDelay =  TrueMaxDelay

            Data.EnableFireDelayModify = false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.EnsurePlayCD)


---@param Player EntityPlayer
function mod:InventorySizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted
       or not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 3 --base starting point

    if Player:HasCollectible(mod.Vouchers.Antimatter) then
        Value = Value + 1
    end

    for _,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        if Slot.Edition == mod.Edition.NEGATIVE then
            Value = Value + 1
        end
    end

    mod:AddJimboInventorySlots(Player, Value-#mod.Saved.Player[PIndex].Inventory)

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.InventorySizeCache, mod.CustomCache.INVENTORY_SIZE)


---@param Player EntityPlayer
function mod:HandSizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted
       or not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
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

    Value = Value - 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.STUNTMAN, true)

    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.TURTLE_BEAN)) do
        Value = Value + mod.Saved.Player[PIndex].Inventory[Index].Progress
    end

    Value = Value + #mod:GetJimboJokerIndex(Player, mod.Jokers.JUGGLER)
 


    Value = Value - mod.Saved.Player[PIndex].EctoUses

    Value = math.max(1, Value) --minimum 1 card in hand

    local SizeDifference = Value - #mod.Saved.Player[PIndex].CurrentHand

    if SizeDifference > 0 then
        mod:ChangeJimboHandSize(Player, SizeDifference)
    end

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.HandSizeCache, mod.CustomCache.HAND_SIZE)


---@param Player EntityPlayer
function mod:DiscardNumCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted
       or not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    Value = 4 --base starting point

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

    --Value = Value - 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.BURGLAR)


    if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
        Value = 2
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

    if not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    Value = 25 --starting point

    if Player:HasCollectible(mod.Vouchers.Grabber) then
        Value = Value + 5
    end
    if Player:HasCollectible(mod.Vouchers.NachoTong) then
        Value = Value + 5
    end
    if Player:HasCollectible(mod.Vouchers.Hieroglyph) then
        Value = Value - 5
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


    if Player:GetPlayerType() ~= mod.Characters.JimboType or
       mod:Contained(TearData.CollidedWith, GetPtrHash(Collider)) then

        return
    end

    if Collider.Type == EntityType.ENTITY_FIREPLACE then
        Collider:Kill()
    end

    table.insert(TearData.CollidedWith, GetPtrHash(Collider))

    local TearRNG = Tear:GetDropRNG()

    if mod:IsSuit(Player, TearData.Params, mod.Suits.Heart) then --Hearts

        local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Tear.Position, Vector.Zero, Tear, 0, TearRNG:GetSeed()):ToEffect()
        
        local NumBlood = mod:GetPlayerTrinketAmount(Player, mod.Jokers.BLOODSTONE)
        
        local CreepScale = Vector.One * (1.25 + 0.25*NumBlood)
        local DamageMult = 0.17 + 0.1*NumBlood
        
        Creep.SpriteScale = CreepScale
        Creep.CollisionDamage = Tear.CollisionDamage * DamageMult
        ---@diagnostic disable-next-line: need-check-nil
        Creep:Update()
    end
    if mod:IsSuit(Player, TearData.Params, mod.Suits.Club) then --Clubs

        local NumOnix = mod:GetPlayerTrinketAmount(Player, mod.Jokers.ONIX_AGATE)
    
        local ExplodeChance = 0.2 + 0.25*NumOnix

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_EXPLOSIVO)
           or Player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND)
           or math.random() < ExplodeChance then

            local DamageMult = 0.5 + 0.4*NumOnix
            local RadiusMult = 0.5 + 0.25*NumOnix

            Game:BombExplosionEffects(Tear.Position, Tear.CollisionDamage * DamageMult, Player:GetBombFlags(), mod.EffectColors.BLUE, Tear.Parent, RadiusMult)
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


--applies the additional effects for the card tears
---@param Tear EntityTear
---@param Grid GridEntity?
function InstaKillPoops(_, Tear, Index, Grid)

    if not Grid or Grid:GetType() ~= GridEntityType.GRID_POOP then
        return
    end

    Grid = Grid:ToPoop()

    if not Grid then
        return
    end

    Grid:Destroy()
end
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, InstaKillPoops, mod.Tears.CARD_TEAR_VARIANT)
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, InstaKillPoops, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, InstaKillPoops, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, InstaKillPoops, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, InstaKillPoops, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Diamond])


--Split is only given when called in mod:SplitTears()
--ForceCard is Used in mod:JimboTakeDamage(), forcing the tear to be a card and preventig it from giving stats
---@param Tear EntityTear
function mod:AddCardTearFalgs(Tear, Split, ForceCard)

    local Player = Tear.Parent and Tear.Parent:ToPlayer() or nil

    if not Player then
        Player = Tear.SpawnerEntity and Tear.SpawnerEntity:ToPlayer() or nil
    end

    if not Player then
        return
    end

    --print(Tear.Variant, mod.Tears.BANANA_VARIANT)

    local ValidCardTear = not (Player:GetPlayerType() ~= mod.Characters.JimboType
                               or Tear.Variant == TearVariant.ERASER or Tear.Variant == TearVariant.BOBS_HEAD
                               or Tear.Variant == TearVariant.KEY or Tear.Variant == TearVariant.KEY_BLOOD
                               or Tear.Variant == TearVariant.FETUS or (Tear.Variant == TearVariant.BONE and not Tear:HasTearFlags(TearFlags.TEAR_BONE))
                               or Tear.Variant == mod.Tears.BANANA_VARIANT)



    local PlayerData = Player:GetData()
    local PIndex = PlayerData.TruePlayerIndex

        
    local NumSenses = mod:GetPlayerTrinketAmount(Player, mod.Jokers.SIXTH_SENSE)

    if Tear.TearIndex % 4 <= (NumSenses - 1) then
        
        Tear:AddTearFlags(TearFlags.TEAR_HOMING)
    end

    local TearData = Tear:GetData()

    if ValidCardTear then

        Tear:ClearTearFlags(TearFlags.TEAR_SHIELDED) --since 1 card is shot every pope death its better to not destroy it (will still block projectiles (see synergies.lua))

        local Weapon = Player:GetWeapon(1)

        local CardShot
        if Split then --if the card (probably) generated from a tear splitting

            CardShot = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].LastShotIndex]
            CardShot.Index = mod.Saved.Player[PIndex].LastShotIndex --could be useful
        else
            CardShot = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[#mod.Saved.Player[PIndex].CurrentHand]]
            CardShot.Index = mod.Saved.Player[PIndex].CurrentHand[#mod.Saved.Player[PIndex].CurrentHand] --could be useful
        end



        TearData.Params = CardShot
        TearData.Num = mod.Saved.Player[PIndex].Progress.Blind.Shots + 1
        if ForceCard then
            TearData.Num = 0
        end

        TearData.EnableSpawn = not Split

        --damage dealt = Damage * TearRate of the player
        Tear.CollisionDamage = mod.Saved.Player[PIndex].TrueDamageValue * mod.Saved.Player[PIndex].TrueTearsValue

        if Weapon and Weapon:GetModifiers() & WeaponModifier.CHOCOLATE_MILK == WeaponModifier.CHOCOLATE_MILK then
            Tear.CollisionDamage = Tear.CollisionDamage *(0.1 + 0.0527*Weapon:GetCharge())
        end

        local CompatibleSuits = mod:IsSuit(Player, TearData.Params)

        if CompatibleSuits[mod.Suits.Spade] then --SPADES
        
            Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)

            local NumArrows = mod:GetPlayerTrinketAmount(Player, mod.Jokers.ARROWHEAD)

            local Chance = 0.5 * NumArrows

            if math.random() <= Chance then
                Tear:AddTearFlags(TearFlags.TEAR_SLOW)
            end
            if math.random() <= Chance then
                Tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
            end


            if Player:HasCollectible(CollectibleType.COLLECTIBLE_CUPIDS_ARROW) then
                
                local CharmChance = NumArrows > 0 and 1 or 0.5

                if math.random() <= CharmChance then
                    Tear:AddTearFlags(TearFlags.TEAR_CHARM)
                end
            end

            local EvilItems = 0

            for _,v in ipairs(mod.EVIL_ITEMS) do --black feather's items
                EvilItems = EvilItems + Player:GetCollectibleNum(v, true)
            end

            Tear.CollisionDamage = Tear.CollisionDamage * (1 + 0.1*EvilItems)
        end
        if CompatibleSuits[mod.Suits.Diamond] then
            --Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
            Tear:AddTearFlags(TearFlags.TEAR_BOUNCE)

            if mod:JimboHasTrinket(Player, mod.Jokers.ROUGH_GEM) then
                Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
            end

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_HALO) then
                Tear:AddTearFlags(TearFlags.TEAR_GLOW)
            end
        end
        if CompatibleSuits[mod.Suits.Heart] then
            --Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)

            local NumBlood = mod:GetPlayerTrinketAmount(Player, mod.Jokers.BLOODSTONE)

            local Chance = 0.1 * NumBlood

            if math.random() <= Chance then
                Tear:AddTearFlags(TearFlags.TEAR_CHARM)
            end

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_HYPERCOAGULATION) then
                
                Tear:AddTearFlags(TearFlags.TEAR_QUADSPLIT)
            end

        end
        if CompatibleSuits[mod.Suits.Club] then
            --Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_IRON_BAR) then
                Tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
            end
        end


        if PlayerData.SinceCardShoot >= 4 then
            mod.TearCardEnable = true
        end


        --if (mod.TearCardEnable and not Init) or (not mod.TearCardEnable and Init and Data.SinceCardShoot > 2) then
        if (ForceCard or mod.TearCardEnable) and not Split then

            Tear:ChangeVariant(mod.Tears.CARD_TEAR_VARIANT)

            local TearSprite = Tear:GetSprite()
            TearSprite:Play(ENHANCEMENTS_ANIMATIONS[TearData.Params.Enhancement], true)

            if TearData.Params.Enhancement ~= mod.Enhancement.STONE
               and TearData.Params.Enhancement ~= mod.Enhancement.WILD then

                TearSprite:PlayOverlay(SUIT_ANIMATIONS[TearData.Params.Suit], true)
            end

            Tear.Scale = (Player.SpriteScale.Y + Player.SpriteScale.X) / 2
            Tear.Scale = mod:Clamp(Tear.Scale, 0.75, 3)

            Isaac.CreateTimer(function ()
                if #mod.Saved.Player[PIndex].CurrentHand > Player:GetCustomCacheValue("handsize")
                   or not mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].DeckPointer] then
                    --having more cards than you should removes the last card

                    table.remove(mod.Saved.Player[PIndex].CurrentHand)

                elseif mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].DeckPointer] then

                    mod:AddValueToTable(mod.Saved.Player[PIndex].CurrentHand, mod.Saved.Player[PIndex].DeckPointer,false,true)
                    mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 1
                end

                Isaac.RunCallback("DECK_SHIFT",Player)
            end,0,1,true)


            mod.TearCardEnable = false
            PlayerData.SinceCardShoot = 0

            if not ForceCard then

                if not Game:GetRoom():IsClear()
                   and mod.Saved.Player[PIndex].FirstDeck
                   and (mod.Saved.Player[PIndex].Progress.Room.Shots < Player:GetCustomCacheValue("hands")
                        or mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR)) then

                    mod.Saved.Player[PIndex].Progress.Room.Shots = mod.Saved.Player[PIndex].Progress.Room.Shots + 1

                    --print(mod.Saved.Player[PIndex].FirstDeck)

                    if (mod.Saved.Player[PIndex].Progress.Room.Shots == Player:GetCustomCacheValue("hands")
                        and not mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR)) --with burglar you can play all your deck
                        or not mod.Saved.Player[PIndex].FirstDeck then 

                        Player:AnimateSad()
                    end

                    Isaac.RunCallback("CARD_SHOT", Player, CardShot.Index, true)
                end
            end

            mod.Saved.Player[PIndex].LastShotIndex = CardShot.Index

        else
            Tear:ChangeVariant(mod.Tears.SUIT_TEAR_VARIANTS[TearData.Params.Suit])

            local TearSprite = Tear:GetSprite()
            TearSprite:Play("Rotate5", true)

        end
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


    if mod.Tears.CARD_TEAR_VARIANT == Tear.Variant  then

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
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.Tears.CARD_TEAR_VARIANT)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Diamond])





------------ TRASH BIN -------------
-----------------------------------
--[[
function mod:ChangeCurrentHandType()
    
    mod.Saved.PossibleHandTypes = mod:DeterminePokerHand()
    mod.Saved.HandType = mod:GetMax(mod.Saved.PossibleHandTypes)
    if mod.Saved.HandType == 10 then
        mod.Saved.Player[PIndex].FiveUnlocked = true
    elseif mod.Saved.HandType == 11 then
        mod.Saved.Player[PIndex].FlushHouseUnlocked = true
    elseif mod.Saved.HandType == 12 then
        mod.Saved.Player[PIndex].FiveFlushUnlocked = true
    end

end
mod:AddCallback("HAND_TYPE_UPDATE", mod.ChangeCurrentHandType)


function mod:ActivateHandEffect(Player)
    Isaac.RunCallback("HAND_TYPE_UPDATE") --updates a last time to be sure

    --print(mod.Saved.HandType)
    --print(mod.Saved.Player[PIndex].HandsStat[1])
    local StatsToGain = mod.Saved.Player[PIndex].HandsStat[mod.Saved.HandType]

    
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

    local CardShot = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.Saved.Player[PIndex].HandSize] ]
    CardShot.Index = mod.Saved.Player[PIndex].CurrentHand[mod.Saved.Player[PIndex].HandSize] --could be useful

    CardFullPoss[CardShot.Index] = nil --needed to make the Hand HUD work properly

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

    Data.SinceCardShoot = 0

    
    mod.Saved.Player[PIndex].CurrentHand[mod.Saved.Player[PIndex].HandSize -mod.Saved.Player[PIndex].Progress.Hand] = 0 --removes the used card
    mod.Saved.Player[PIndex].Progress.Hand = mod.Saved.Player[PIndex].Progress.Hand + 1

    if mod.Saved.Player[PIndex].Progress.Hand > mod.Saved.Player[PIndex].HandSize then--if all the hand is empty replace it with a new one
        for i=1, mod.Saved.Player[PIndex].HandSize do
            mod.Saved.Player[PIndex].CurrentHand[i] = mod.Saved.Player[PIndex].DeckPointer
            mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer +1
        end
        mod.Saved.Player[PIndex].Progress.Hand = 1
    end
end



]]--


