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
            mod.SavedValues = json.decode(mod:LoadData())
        end
        for _, player in ipairs(PlayerManager.GetPlayers()) do   --evaluates again for the mod's trinkets since closing the game
            --resets the callbacks and the pickedTrinkets table
            mod.StatEnable = true
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
            mod.StatEnable = false
        end
        return
    end
    
    --all of this only happens on new runs--
    ---------------------------------------------

    --reset most of the saved values
    mod.SavedValues.TrinketValues.LastMisprintDMG = 0
        mod.SavedValues.TrinketValues.Fortune_Teller = 0
        mod.SavedValues.TrinketValues.Stone_joker = 0
        mod.SavedValues.TrinketValues.Ice_cream = 1
        mod.SavedValues.TrinketValues.Popcorn = 2
        mod.SavedValues.TrinketValues.Ramen = 1.3
        mod.SavedValues.TrinketValues.Rocket = 3
        mod.SavedValues.TrinketValues.Green_joker = 0
        mod.SavedValues.TrinketValues.Red_card = 0
        mod.SavedValues.TrinketValues.Blueprint = 0
        mod.SavedValues.TrinketValues.Brainstorm = 0
        mod.SavedValues.TrinketValues.Madness = 1
        mod.SavedValues.TrinketValues.LastBPitem = 0
        mod.SavedValues.TrinketValues.Flash_card = 0
        mod.SavedValues.TrinketValues.MichaelDestroyed = false
        mod.SavedValues.TrinketValues.GoldenMichelGone = false
        mod.SavedValues.TrinketValues.FirstBrain = true
        mod.SavedValues.TrinketValues.Cloud_9 = 9
        mod.SavedValues.TrinketValues.Loyalty_card = 6
        mod.SavedValues.TrinketValues.Labyrinth = 1
        mod.SavedValues.TrinketValues.Sacrificial_dagger = 0
        mod.SavedValues.TrinketValues.Swashbuckler = 0
        mod.SavedValues.TrinketValues.Egg = 3
        mod.SavedValues.TrinketValues.Supernova = {}
        mod.SavedValues.TrinketValues.Dna = true

    
        mod.SavedValues.Jimbo.FullDeck = {}
        local index = 1
        for i = 1, 4, 1 do --cycles between the suits
            for j = 1, 13, 1 do --cycles for all the values
                mod.SavedValues.Jimbo.FullDeck[index] = {}
                mod.SavedValues.Jimbo.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
                mod.SavedValues.Jimbo.FullDeck[index].Value = j --1 ~ 13
                mod.SavedValues.Jimbo.FullDeck[index].Enhancement = 1
                mod.SavedValues.Jimbo.FullDeck[index].Seal = 1
                mod.SavedValues.Jimbo.FullDeck[index].Edition = 2
                index = index +1
            end
        end
        local AnyJimbo
        for _, Player in ipairs(PlayerManager:GetPlayers()) do --finds the first jimbo and uses its rng
            if Player:GetPlayerType() == mod.Characters.JimboType then
                mod:StatReset(Player, true, true)
                AnyJimbo = Player
            end
        end
        local HandRNG = AnyJimbo:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
        mod.SavedValues.Jimbo.FullDeck = mod:Shuffle(mod.SavedValues.Jimbo.FullDeck, HandRNG)

        mod.SavedValues.Jimbo.DeckPointer = 6
        mod.SavedValues.Jimbo.CurrentHand = {5,4,3,2,1} --basically 5 different cards
        mod.SavedValues.Jimbo.Inventory= {}
        mod.SavedValues.Jimbo.Inventory.Jokers = {0,0,0}
        mod.SavedValues.Jimbo.Inventory.Editions = {0,0,0}

        mod.SavedValues.Jimbo.Progress = {} --values used for jokers (reset every blind)
        mod.SavedValues.Jimbo.Progress.SuitUsed = {}
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Spade] = 0
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Heart] = 0
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Club] = 0
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Diamond] = 0


        mod.SavedValues.Jimbo.StatsToAdd = {}
        mod.SavedValues.Jimbo.StatsToAdd.Damage = 0
        mod.SavedValues.Jimbo.StatsToAdd.Tears = 0
        mod.SavedValues.Jimbo.StatsToAdd.Mult = 1
        mod.SavedValues.Jimbo.StatsToAdd.JokerDamage = 0
        mod.SavedValues.Jimbo.StatsToAdd.JokerTears = 0
        mod.SavedValues.Jimbo.StatsToAdd.JokerMult = 1
        
        mod.SavedValues.Jimbo.MinimumTears = 0.8
        mod.SavedValues.Jimbo.MinimumDamage = 0.5
        mod.SavedValues.Jimbo.MaxDiscards = 2
        mod.SavedValues.Jimbo.AvailableDiscards = 2
        
        mod.SavedValues.Jimbo.HandLevels = {}
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.HIGH_CARD] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.PAIR] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.TWO_PAIR] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.THREE] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.STRAIGHT] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.FLUSH] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.FULL_HOUSE] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.FOUR] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.STRAIGHT_FLUSH] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.ROYAL_FLUSH] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.FIVE] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.FLUSH_HOUSE] = 1
        mod.SavedValues.Jimbo.HandLevels[mod.HandTypes.FIVE_FLUSH] = 1
        
        mod.SavedValues.Jimbo.HandsStat = {}
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.NONE] = Vector(0,0)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.HIGH_CARD] = Vector(0.05,0.2)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.PAIR] = Vector(0.1,0.4)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.TWO_PAIR] = Vector(0.1,0.8)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.THREE] = Vector(0.15,1.2)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.STRAIGHT] = Vector(0.2,1.2)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.FLUSH] = Vector(0.2,1.4)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.FULL_HOUSE] = Vector(0.2,1.6)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.FOUR] = Vector(0.35,2.4)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.STRAIGHT_FLUSH] = Vector(0.4,4)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.ROYAL_FLUSH] = Vector(0.4,4)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.FIVE] = Vector(0.6,4.8)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.FLUSH_HOUSE] = Vector(0.7,5.6)
        mod.SavedValues.Jimbo.HandsStat[mod.HandTypes.FIVE_FLUSH] = Vector(0.8,6.4)

        mod.SavedValues.Jimbo.FiveUnlocked = false
        mod.SavedValues.Jimbo.FlushHouseUnlocked = false
        mod.SavedValues.Jimbo.FiveFlushUnlocked = false

        mod.SavedValues.Jimbo.ClearedRooms = 0
        mod.SavedValues.Jimbo.SmallCleared = false
        mod.SavedValues.Jimbo.BigCleared = false
        mod.SavedValues.Jimbo.BossCleard = false

        mod.SavedValues.Jimbo.Progress = {} --values used for jokers (reset every blind)
        mod.SavedValues.Jimbo.Progress.Inventory = {0,0,0}
        mod.SavedValues.Jimbo.Progress.SuitUsed = {}
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Spade] = 0
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Heart] = 0
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Club] = 0
        mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Diamond] = 0

        mod.SavedValues.Jimbo.LastUsed = {}
    

        if mod:Contained(Challenges, Game.Challenge) then
            mod.SavedValues.Other.ShopEntered = true
        else
            mod.SavedValues.Other.ShopEntered = false
        end
        mod.SavedValues.Other.DamageTakenRoom = 0
        mod.SavedValues.Other.DamageTakenFloor = 0
        mod.SavedValues.Other.TreasureEntered = false
        mod.SavedValues.Other.Picked = {0}  --to prevent weird shenadigans
        mod.SavedValues.Other.Tags = {}


        mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE
        mod.SelectionParams.Mode = mod.SelectionParams.Modes.NONE
        --print(mod.SavedValues.ModConfig.ExtraReadability)

    --[[
    --print(#mod.SavedValues.Other.Tags)
    for j = 1, #mod.SavedValues.Other.Tags, 1 do
        local TagX = mod.SavedValues.Other.Tags[j]
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
    --print(mod.SavedValues.Other.Tags)]]--
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
    if mod:Contained(mod.SavedValues.Other.Picked, trinket) then --checks if the trinket was already taken this run
        return
    else
        mod.SavedValues.Other.Picked[#mod.SavedValues.Other.Picked+1] = trinket
        --table.insert((mod.SavedValues.Other.Picked), trinket)
        --dude i swear to god, table.insert just won't work
    end
    --print("not contained")
    for i=1, #Trinket:GetCustomTags(), 1 do --needed since certain trinkets have the same tags, whick would double the callbacks
        local TagX = Trinket:GetCustomTags()[i]
        if not mod:Contained(mod.SavedValues.Other.Tags, TagX) then
            mod.SavedValues.Other.Tags[#mod.SavedValues.Other.Tags+1] =  TagX
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
    --print(mod.SavedValues.Other.Tags)]]--
end
--mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.TrinketPickup)
--this got screpped cause it got more difficult to mantain when jimbo came in town


function mod:SaveStorage(IsExit)
    if mod.GameStarted then --needed since POST_NEW_LEVEL goes before GAME_STARTED 
        mod:SaveData(json.encode(mod.SavedValues))
    end
    if IsExit ~= nil then --this variable exists only when the GAME_EXIT callback is called
        mod.GameStarted = false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.SaveStorage)