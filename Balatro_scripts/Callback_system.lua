local mod = Balatro_Expansion
local json = require("json")

local Game = Game()

local Challenges = {}
Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
local ItemsConfig = Isaac.GetItemConfig()

--VVVVV-- big ass code wall incoming -VVVVV-
function mod:OnGameStart(Continued)
    mod.GameStarted = true
    --[[
    --removes every callback to prevent double callbacks on continues and to remove all of them on new runs
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)
    mod:RemoveCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)
    mod:RemoveCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)
    mod:RemoveCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)
    mod:RemoveCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate) 
    mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnSpecificRoomEnter)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)
    mod:RemoveCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)
    mod:RemoveCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)
    mod:RemoveCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)
    mod:RemoveCallback(ModCallbacks.MC_USE_ITEM, mod.OnCardUse)]]--
    --this got screpped cause it got more difficult to mantain when jimbo came in town


    --sadly due to the unholy amount of values the mod needs to store i'll need to reset the all at once

    if Continued then 

        if mod:HasData() then
            mod.Saved = json.decode(mod:LoadData()) --restores every saved progress from the run
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

        mod.Pools = {}
        mod.Pools.Vouchers = {
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
        mod.Vouchers.MoneySeed
        }
    
        mod.Saved.Jimbo.FullDeck = {}
        local index = 1
        for i = 1, 4, 1 do --cycles between the suits
            for j = 1, 13, 1 do --cycles for all the values
                mod.Saved.Jimbo.FullDeck[index] = {}
                mod.Saved.Jimbo.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
                mod.Saved.Jimbo.FullDeck[index].Value = j --1 ~ 13
                mod.Saved.Jimbo.FullDeck[index].Enhancement = mod.Enhancement.NONE
                mod.Saved.Jimbo.FullDeck[index].Seal = mod.Seals.NONE
                mod.Saved.Jimbo.FullDeck[index].Edition = mod.Edition.BASE
                index = index +1
            end
        end

        local HandRNG = Game:GetPlayer(0):GetDropRNG()

        mod.Saved.Jimbo.FullDeck = mod:Shuffle(mod.Saved.Jimbo.FullDeck, HandRNG)

        mod.Saved.Jimbo.DeckPointer = 6
        mod.Saved.Jimbo.CurrentHand = {5,4,3,2,1} --basically 5 different cards
        mod.Saved.Jimbo.Inventory= {}
        mod.Saved.Jimbo.Inventory.Jokers = {0,0,0}
        mod.Saved.Jimbo.Inventory.Editions = {0,0,0}
        mod.Saved.Jimbo.MichelDestroyed = false

        mod.Saved.Jimbo.HandSize = 5
        mod.Saved.Jimbo.InventorySize = 3
        mod.Saved.Jimbo.MaxCards = 25


        mod.Saved.Jimbo.StatsToAdd = {}
        mod.Saved.Jimbo.StatsToAdd.Damage = 0
        mod.Saved.Jimbo.StatsToAdd.Tears = 0
        mod.Saved.Jimbo.StatsToAdd.Mult = 1
        mod.Saved.Jimbo.StatsToAdd.JokerDamage = 0
        mod.Saved.Jimbo.StatsToAdd.JokerTears = 0
        mod.Saved.Jimbo.StatsToAdd.JokerMult = 1

        mod.Saved.Jimbo.FirstDeck = true

        mod.Saved.Jimbo.MinimumTears = 0.8
        mod.Saved.Jimbo.MinimumDamage = 0.5

        mod.Saved.Jimbo.CardLevels = {}
        for i=1, 13 do
            mod.Saved.Jimbo.CardLevels[i] = 0
        end

        --[[
        mod.Saved.Jimbo.HandLevels = {}
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.HIGH_CARD] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.PAIR] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.TWO_PAIR] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.THREE] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.STRAIGHT] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.FLUSH] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.FULL_HOUSE] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.FOUR] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.STRAIGHT_FLUSH] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.ROYAL_FLUSH] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.FIVE] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.FLUSH_HOUSE] = 1
        mod.Saved.Jimbo.HandLevels[mod.HandTypes.FIVE_FLUSH] = 1
        
        mod.Saved.Jimbo.HandsStat = {}
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.NONE] = Vector(0,0)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.HIGH_CARD] = Vector(0.05,0.2)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.PAIR] = Vector(0.1,0.4)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.TWO_PAIR] = Vector(0.1,0.8)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.THREE] = Vector(0.15,1.2)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.STRAIGHT] = Vector(0.2,1.2)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.FLUSH] = Vector(0.2,1.4)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.FULL_HOUSE] = Vector(0.2,1.6)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.FOUR] = Vector(0.35,2.4)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.STRAIGHT_FLUSH] = Vector(0.4,4)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.ROYAL_FLUSH] = Vector(0.4,4)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.FIVE] = Vector(0.6,4.8)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.FLUSH_HOUSE] = Vector(0.7,5.6)
        mod.Saved.Jimbo.HandsStat[mod.HandTypes.FIVE_FLUSH] = Vector(0.8,6.4)

        mod.Saved.Jimbo.FiveUnlocked = false
        mod.Saved.Jimbo.FlushHouseUnlocked = false
        mod.Saved.Jimbo.FiveFlushUnlocked = false]]--

        mod.Saved.Jimbo.ClearedRooms = 0
        mod.Saved.Jimbo.SmallCleared = false
        mod.Saved.Jimbo.BigCleared = false
        mod.Saved.Jimbo.BossCleared = false

        mod.Saved.Jimbo.Progress = {} --values used for jokers
        mod.Saved.Jimbo.Progress.Inventory = {0,0,0} --never reset, changed in different ways basing on the joker
        mod.Saved.Jimbo.Progress.Cards = 0

        mod.Saved.Jimbo.Progress.Blind = {} --reset every new blind
        mod.Saved.Jimbo.Progress.Blind.Shots = 0

        mod.Saved.Jimbo.Progress.Room = {} --reset every new room
        mod.Saved.Jimbo.Progress.Room.SuitUsed = {}
        mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Spade] = 0
        mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Heart] = 0
        mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Club] = 0
        mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Diamond] = 0
        mod.Saved.Jimbo.Progress.Room.ValueUsed = {}
        for Value =1, 13 do
            mod.Saved.Jimbo.Progress.Room.ValueUsed[Value] = 0
        end
        mod.Saved.Jimbo.Progress.Room.Shots = 0

        mod.Saved.Jimbo.Progress.Floor = {}
        mod.Saved.Jimbo.Progress.Floor.Vouchers = {}



        mod.Saved.Jimbo.LastUsed = {}
        mod.Saved.Jimbo.EctoUses = 0
    
        do
            local RandomSeed = Random()
            if RandomSeed == 0 then RandomSeed = 1 end
            mod.Saved.GeneralRNG = RNG(RandomSeed) --RNG object used in various ways 
        end
        mod.HpEnable = false
        mod.ShopAddedThisFloor = false
        if mod:Contained(Challenges, Game.Challenge) then
            mod.Saved.Other.ShopEntered = true
        else
            mod.Saved.Other.ShopEntered = false
        end
        mod.Saved.Other.DamageTakenRoom = 0
        mod.Saved.Other.DamageTakenFloor = 0
        mod.Saved.Other.TreasureEntered = false
        mod.Saved.Other.Picked = {0}  --to prevent weird shenadigans
        mod.Saved.Other.Tags = {}


        mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE
        mod.SelectionParams.Mode = mod.SelectionParams.Modes.NONE


    end
    
    
    for _, player in ipairs(PlayerManager.GetPlayers()) do  --evaluates again for the mod's trinkets since closing the game
        --resets stuff
        mod.StatEnable = true
        mod:StatReset(player,true,true,false,true,true)
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        mod.StatEnable = false
    end



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


---@param trinket TrinketType
function mod:TrinketPickup(_,trinket,_)
    --print("trinket")
    --[[
    local Trinket = ItemsConfig:GetTrinket(trinket)
    mod.WantedEffect = trinket
    --these only make effects (only one per trinket)
    if not (Trinket:HasCustomTag("mult") or Trinket:HasCustomTag("chips") or Trinket:HasCustomTag("multm") or Trinket:HasCustomTag("mult/chips") or Trinket:HasCustomTag("activate")) then
        return --not a mod's trinket
    end
    --print("mod")
    if mod:Contained(mod.Saved.Other.Picked, trinket) then --checks if the trinket was already taken this run
        return
    else
        mod.Saved.Other.Picked[#mod.Saved.Other.Picked+1] = trinket
        --table.insert((mod.Saved.Other.Picked), trinket)
        --dude i swear to god, table.insert just won't work
    end
    --print("not contained")
    for i=1, #Trinket:GetCustomTags(), 1 do --needed since certain trinkets have the same tags, whick would double the callbacks
        local TagX = Trinket:GetCustomTags()[i]
        if not mod:Contained(mod.Saved.Other.Tags, TagX) then
            mod.Saved.Other.Tags[#mod.Saved.Other.Tags+1] =  TagX
            if not (TagX == "mult" or TagX == "chips" or TagX == "multm" or TagX == "mult/chips") then
                --print("idk")
                if TagX == "newroom" then
                    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
            
                elseif TagX == "newfloor" then
                    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)
                
                elseif TagX == "items" then
                    --print("callback")
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
                    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
                    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)
                
                elseif TagX == "rocks" then
                    mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy)
                
                elseif TagX == "pickupnum" then 
                    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate)
                
                elseif TagX == "roomclear" then
                    mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)
                elseif TagX == "taken" then --damage taken
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
                elseif TagX == "activeuse" then
                    mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnActiveUse)
                end
            end
            
        end

    end
    --print(mod.Saved.Other.Tags)]]--
end
--mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.TrinketPickup)
--this got screpped cause it got more difficult to mantain when jimbo came in town


function mod:SaveStorage(IsExit)
    if mod.GameStarted then --needed since POST_NEW_LEVEL goes before GAME_STARTED 
        mod:SaveData(json.encode(mod.Saved))
    end
    if IsExit ~= nil then --this variable exists only when the GAME_EXIT callback is called
        mod.GameStarted = false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL,CallbackPriority.LATE, mod.SaveStorage)