local mod = Balatro_Expansion
local json = require("json")

local Game = Game()

local Challenges = {}
Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
--local ItemsConfig = Isaac.GetItemConfig()


---@param InitPlayer EntityPlayer
local function PlayerIndexUpdate(InitPlayer)

    local ControllersFound = {}
    local TrueIndex = 0

    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        local Data = Player:GetData()

        Data.TruePlayerIndex = TrueIndex
        if not mod:Contained(ControllersFound, Player.ControllerIndex) then
            ControllersFound[#ControllersFound+1] = Player.ControllerIndex
            TrueIndex = TrueIndex + 1
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PlayerIndexUpdate)


function mod:OnGameStart(Continued)

    if Continued then

        if mod:HasData() then
            mod.Saved = json.decode(mod:LoadData()) --restores every saved progress from the last run

            --mod.ItemManager:LoadData(mod.Saved.HiddenItemsData)


            --also restores the invisible collectibles added previously
            for _,Player in ipairs(PlayerManager.GetPlayers()) do

                local PIndex = Player:GetData().TruePlayerIndex
                if not PIndex then
                    PlayerIndexUpdate(Player)
                    PIndex = Player:GetData().TruePlayerIndex
                end

                print(PIndex, mod.Saved.Player[PIndex])

                for _,Group in pairs(mod.Saved.Player[PIndex].InnateItems or {}) do
                    for _,Item in ipairs(Group) do
                        Player:AddInnateCollectible(Item)
                    end
                end
            end
        end
    else

        --all of this only happens on new runs--
        ---------------------------------------------

        --[[reset most of the saved values
        mod.Saved.TrinketValues.LastMisprintDMG = 0
        mod.Saved.TrinketValues.Fortune_Teller = 0
        mod.Saved.TrinketValues.Stone_joker = 0
        mod.Saved.TrinketValues.Ice_cream = 1
        mod.Saved.TrinketValues.Popcorn = 2
        mod.Saved.TrinketValues.Ramen = 1.3
        mod.Saved.TrinketValues.Rocket = 3
        mod.Saved.TrinketValues.Green_joker = 0
        mod.Saved.TrinketValues.Red_card = 0
        mod.Saved.TrinketValues.Blueprint = 0
        mod.Saved.TrinketValues.Brainstorm = 0
        mod.Saved.TrinketValues.Madness = 1
        mod.Saved.TrinketValues.LastBPitem = 0
        mod.Saved.TrinketValues.Flash_card = 0
        mod.Saved.TrinketValues.MichaelDestroyed = false
        mod.Saved.TrinketValues.GoldenMichelGone = false
        mod.Saved.TrinketValues.FirstBrain = true
        mod.Saved.TrinketValues.Cloud_9 = 9
        mod.Saved.TrinketValues.Loyalty_card = 6
        mod.Saved.TrinketValues.Labyrinth = 1
        mod.Saved.TrinketValues.Sacrificial_dagger = 0
        mod.Saved.TrinketValues.Swashbuckler = 0
        mod.Saved.TrinketValues.Egg = 3
        mod.Saved.TrinketValues.Supernova = {}
        mod.Saved.TrinketValues.Dna = true]]

        mod.Saved.ShowmanRemovedItems = {}
        mod.HpEnable = false
        mod.ShopAddedThisFloor = false

        mod.Saved.Pools = {}
        mod.Saved.Pools.Vouchers = {
        mod.Vouchers.Grabber,
        mod.Vouchers.Overstock,
        mod.Vouchers.Wasteful,
        mod.Vouchers.RerollSurplus,
        mod.Vouchers.TarotMerch,
        mod.Vouchers.PlanetMerch,
        mod.Vouchers.Clearance,
        mod.Vouchers.Hone,
        mod.Vouchers.Crystal,
        mod.Vouchers.Blank,
        mod.Vouchers.Telescope,
        mod.Vouchers.Brush,
        mod.Vouchers.Director,
        mod.Vouchers.Hieroglyph,
        mod.Vouchers.MagicTrick,
        mod.Vouchers.MoneySeed}

        mod.Saved.FloorVouchers = {}

        mod.Saved.FloorSkippedSpecials = 0
        mod.Saved.RunSkippedSpecials = 0
        mod.Saved.GlassBroken = 0
        mod.Saved.TarotsUsed = 0
        mod.Saved.PlanetTypesUsed = 0

        mod.Saved.HasDebt = false

        mod.Saved.CardLevels = {}
        for i=1, 13 do
            mod.Saved.CardLevels[i] = 0
        end

        if mod:Contained(Challenges, Game.Challenge) then
            mod.Saved.Other.ShopEntered = true
        else
            mod.Saved.Other.ShopEntered = false
        end
    end

    mod.GameStarted = true

    
    for _, player in ipairs(PlayerManager.GetPlayers()) do  --evaluates again for the mod's trinkets since closing the game
        --resets stuff
        mod:InitJimboValues(player, not Continued) -- on new run always initialise jimbo values

        if player:GetPlayerType() == mod.Characters.JimboType then
            mod:StatReset(player,true,true,false,true,true)

            for _, Cache in pairs(mod.CustomCache) do
                player:AddCustomCacheTag(Cache, true)
            end

            Isaac.RunCallback("INVENTORY_CHANGE", player) --this evaluates everithing anyway
            --player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        end
    end

    --[[
    for i, Joker in pairs(mod.Jokers) do
        Isaac.CreateTimer(function ()
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Isaac.GetRandomPosition(), Vector.Zero, nil, Joker, 1)
        end, Counter, 1, false)

        Counter = Counter + Counter2
        Counter2 = math.max(Counter2 - 3, 3)
    end]]
    --print(mod.Saved.ModConfig.ExtraReadability)

    --[[
    --print(#mod.Saved.Other.Tags)
    for j = 1, #mod.Saved.Other.Tags, 1 do
        local TagX = mod.Saved.Other.Tags[j]
        --print(TagX)
        if not (TagX == "mult" or TagX == "chips" or TagX == "multm") then
            if TagX == "newroom" then
                mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
            
            elseif TagX == "newfloor" then
                mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)

            elseif TagX == "items" then
                mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)
                mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)
                
            elseif TagX == "coins" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_COIN)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_COIN)
            elseif TagX == "bombs" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_BOMB)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_BOMB)
            elseif TagX == "keys" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_KEY)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_KEY)
            elseif TagX == "hearts" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_HEART)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_HEART)
            elseif TagX == "cards" then --also includes runes and pills
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_TAROTCARD)
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_PILL)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_PILL)
            elseif TagX == "cardremove" then --also includes runes and pills
                mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
                mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)
            
            elseif TagX == "rocks" then
                mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy)
                
            elseif TagX == "pickupnum" then --they all give the same callvack
                mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate)
            
            elseif TagX == "roomclear" then
                mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)
                
            elseif TagX == "taken" then
                mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)
                
            elseif TagX == "specificroom" then
                mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnSpecificRoomEnter)
                
            elseif TagX == "bought" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)
                
            elseif TagX == "removal" then
                mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)
            elseif TagX == "revive" then
                mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)
            elseif TagX == "restock" then
                mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)                
            elseif TagX == "carduse" then
                mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)
                mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnPillUse)
            elseif TagX == "activeuse" then
                mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnActiveUse)
            end
        end
    end
    --print(mod.Saved.Other.Tags)]]--
    --this got screpped cause it got more difficult to mantain when jimbo came in town
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED ,mod.OnGameStart)
                                        --btw putting IMPORTANT as the prioriry here makes it not happen

--Counter = 60
--Counter2 = 36


function mod:InitJimboValues(Player, Force)

    
    local PIndex = Player:GetData().TruePlayerIndex
    if not PIndex then
        PlayerIndexUpdate(Player)
        PIndex = Player:GetData().TruePlayerIndex
    end

    mod.Saved.Player[PIndex] = {}
    
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto shared_values
    end

    if mod.Saved.Player[Player:GetData().TruePlayerIndex] and not Force then
        return
    end

    --SFXManager():Play(SoundEffect.SOUND_MEGA_BLAST_START)

    --for i=0, PIndex do
        --Game:Spawn(EntityType.ENTITY_GAPER,0, Isaac.GetRandomPosition(), Vector.Zero, nil, 0, 1)
    --end
    --print(PIndex)

    mod.SelectionParams[PIndex].Frames = 0 -- in update frames
    mod.SelectionParams[PIndex].SelectedCards = {false,false,false,false,false}
    mod.SelectionParams[PIndex].Index = 1
    mod.SelectionParams[PIndex].Mode = 0
    mod.SelectionParams[PIndex].Purpose = 0
    mod.SelectionParams[PIndex].PackOptions = {} --the options for the selection inside of a pack
    mod.SelectionParams[PIndex].OptionsNum = 0 --total amount of options
    mod.SelectionParams[PIndex].MaxSelectionNum = 0 --how many things you can choose at a time
    mod.SelectionParams[PIndex].SelectionNum = 0 --how many things you chose
    mod.SelectionParams[PIndex].PlayerChoosing = 0 --the true player index of who is choosing

    mod.Saved.Player[PIndex].FullDeck = {}
    do
        
    local index = 1
    for i = 1, 4, 1 do --cycles between the suits
        for j = 1, 13, 1 do --cycles for all the values
            mod.Saved.Player[PIndex].FullDeck[index] = {}
            mod.Saved.Player[PIndex].FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
            mod.Saved.Player[PIndex].FullDeck[index].Value = j --1 ~ 13
            mod.Saved.Player[PIndex].FullDeck[index].Enhancement = mod.Enhancement.NONE
            mod.Saved.Player[PIndex].FullDeck[index].Seal = mod.Seals.NONE
            mod.Saved.Player[PIndex].FullDeck[index].Edition = mod.Edition.BASE
            mod.Saved.Player[PIndex].FullDeck[index].Upgrades = 0 --only used for the Hiker joker
            index = index +1
        end
    end

    local HandRNG = Game:GetPlayer(0):GetDropRNG()

    mod.Saved.Player[PIndex].FullDeck = mod:Shuffle(mod.Saved.Player[PIndex].FullDeck, HandRNG)

    end
    mod.Saved.Player[PIndex].DeckPointer = 6
    mod.Saved.Player[PIndex].CurrentHand = {5,4,3,2,1} --basically 5 different cards
    mod.Saved.Player[PIndex].LastShotIndex = 0

    mod.Saved.Player[PIndex].Inventory = {}
    for i=1,3 do
        mod.Saved.Player[PIndex].Inventory[i] = {}
        mod.Saved.Player[PIndex].Inventory[i].Joker = 0
        mod.Saved.Player[PIndex].Inventory[i].Edition = mod.Edition.BASE
    end
    mod.Saved.MichelDestroyed = false

    mod.Saved.Player[PIndex].StatsToAdd = {}
    mod.Saved.Player[PIndex].StatsToAdd.Damage = 0
    mod.Saved.Player[PIndex].StatsToAdd.Tears = 1.5
    mod.Saved.Player[PIndex].StatsToAdd.Mult = 1
    mod.Saved.Player[PIndex].StatsToAdd.JokerDamage = 0
    mod.Saved.Player[PIndex].StatsToAdd.JokerTears = 0
    mod.Saved.Player[PIndex].StatsToAdd.JokerMult = 1

    mod.Saved.Player[PIndex].InnateItems = {}
    mod.Saved.Player[PIndex].InnateItems.General = {}
    mod.Saved.Player[PIndex].InnateItems.Hack = {}

    mod.Saved.Player[PIndex].FirstDeck = true

    mod.Saved.Player[PIndex].TrueDamageValue = 1 --used to surpass the usual 0.5 minimum damage cap
    mod.Saved.Player[PIndex].TrueTearsValue = 1

    --[[
        mod.Saved.Player[PIndex].HandLevels = {}
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.HIGH_CARD] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.PAIR] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.TWO_PAIR] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.THREE] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.STRAIGHT] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.FLUSH] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.FULL_HOUSE] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.FOUR] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.STRAIGHT_FLUSH] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.ROYAL_FLUSH] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.FIVE] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.FLUSH_HOUSE] = 1
        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.FIVE_FLUSH] = 1
        
        mod.Saved.Player[PIndex].HandsStat = {}
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.NONE] = Vector(0,0)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.HIGH_CARD] = Vector(0.05,0.2)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.PAIR] = Vector(0.1,0.4)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.TWO_PAIR] = Vector(0.1,0.8)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.THREE] = Vector(0.15,1.2)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.STRAIGHT] = Vector(0.2,1.2)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.FLUSH] = Vector(0.2,1.4)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.FULL_HOUSE] = Vector(0.2,1.6)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.FOUR] = Vector(0.35,2.4)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.STRAIGHT_FLUSH] = Vector(0.4,4)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.ROYAL_FLUSH] = Vector(0.4,4)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.FIVE] = Vector(0.6,4.8)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.FLUSH_HOUSE] = Vector(0.7,5.6)
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.FIVE_FLUSH] = Vector(0.8,6.4)

        mod.Saved.Player[PIndex].FiveUnlocked = false
        mod.Saved.Player[PIndex].FlushHouseUnlocked = false
    mod.Saved.Player[PIndex].FiveFlushUnlocked = false]]--

    mod.Saved.ClearedRooms = 0
    mod.Saved.SmallCleared = false
    mod.Saved.BigCleared = false
    mod.Saved.BossCleared = 0

    mod.Saved.Player[PIndex].Progress = {} --values used for jokers
    mod.Saved.Player[PIndex].Progress.Inventory = {0,0,0} --never reset, changed in different ways basing on the joker
    mod.Saved.Player[PIndex].Progress.GiftCardExtra = {0,0,0}

    mod.Saved.Player[PIndex].Progress.Blind = {} --reset every new blind
    mod.Saved.Player[PIndex].Progress.Blind.Shots = 0

    mod.Saved.Player[PIndex].Progress.Room = {} --reset every new room
    mod.Saved.Player[PIndex].Progress.Room.SuitUsed = {}
    mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Spade] = 0
    mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Heart] = 0
    mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Club] = 0
    mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Diamond] = 0
    mod.Saved.Player[PIndex].Progress.Room.ValueUsed = {}
    for Value =1, 14 do
        mod.Saved.Player[PIndex].Progress.Room.ValueUsed[Value] = 0
    end
    mod.Saved.Player[PIndex].Progress.Room.Shots = 0
    mod.Saved.Player[PIndex].Progress.Room.ChampKills = 0
    mod.Saved.Player[PIndex].Progress.Room.KingsAtStart = 0


    mod.Saved.Player[PIndex].Progress.Floor = {}
    mod.Saved.Player[PIndex].Progress.Floor.CardsUsed = 0

    mod.Saved.Player[PIndex].EctoUses = 0
    mod.Saved.Player[PIndex].LastCardUsed = nil --the last card a player used
    mod.Saved.Player[PIndex].NumActiveCostumes = 0

    
    ::shared_values::

    mod.Saved.Player[PIndex].ComedicState = 0


end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_PRE_LEVEL_INIT_STATS, mod.InitJimboValues)



function mod:SaveStorage(IsExit)

    if mod.GameStarted then --needed since POST_NEW_LEVEL goes before GAME_STARTED 

        --mod.Saved.HiddenItemsData = mod.ItemManager:GetSaveData()

        mod:SaveData(json.encode(mod.Saved))
    end
    if type(IsExit) ~= "nil" then --this variable exists only when the GAME_EXIT callback is called
        mod.GameStarted = false
        --print("is now false")
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL,CallbackPriority.LATE, mod.SaveStorage)


local function ResetJimboValues()
    mod.Saved.Player = {}
    if mod.GameStarted then
        for _, Player in ipairs(PlayerManager.GetPlayers()) do
            mod:InitJimboValues(Player, true)

        end
    end
    mod.GameStarted = false --prevents errors when using luamod in the console
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ResetJimboValues)
