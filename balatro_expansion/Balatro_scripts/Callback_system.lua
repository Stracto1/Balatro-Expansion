local json = require("json")
local Game = Game()

local Challenges = {}
Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
local ItemsConfig = Isaac.GetItemConfig()

--VVVVV-- big ass code wall incoming -VVVVV-
function Balatro_Expansion:OnGameStart(Continued)

    --removes every callback to prevent double callbacks on continues and to remove all of them on new runs
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnNewRoom)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_NEW_LEVEL, Balatro_Expansion.OnNewFloor)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Balatro_Expansion.OnItemPickup)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, Balatro_Expansion.OnItemRemoval)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, Balatro_Expansion.OnConsumableRemove)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, Balatro_Expansion.OnConsumableRemove)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_USE_CARD, Balatro_Expansion.OnCardUse)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, Balatro_Expansion.OnRockDestroy)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Balatro_Expansion.OnUpdate) 
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Balatro_Expansion.OnTakenDamage, EntityType.ENTITY_PLAYER)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnSpecificRoomEnter)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, Balatro_Expansion.OnShopPurchase)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, Balatro_Expansion.OnTrinketRemoval)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, Balatro_Expansion.OnDeath)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, Balatro_Expansion.OnRestock)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.OnRoomClear)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_USE_ITEM, Balatro_Expansion.OnCardUse)
    
    if  Continued then
        if Balatro_Expansion:HasData() then
            --print("data")
            TrinketValues = json.decode(Balatro_Expansion:LoadData())
        end
        --print(TrinketValues.DeckPointer)
    else --new run (reset all the saved values)
        Balatro_Expansion:RemoveData()     --removes the saved trinket progress
        TrinketValues.LastMisprintDMG = 0
        TrinketValues.Fortune_Teller = 0
        TrinketValues.Stone_joker = 0
        TrinketValues.Ice_cream = 1
        TrinketValues.Popcorn = 2
        TrinketValues.Ramen = 1.3
        TrinketValues.Rocket = 3
        TrinketValues.Green_joker = 0
        TrinketValues.Red_card = 0
        TrinketValues.Blueprint = 0
        TrinketValues.Brainstorm = 0
        TrinketValues.Madness = 1
        TrinketValues.LastBPitem = 0
        TrinketValues.Flash_card = 0
        TrinketValues.MichaelDestroyed = false
        TrinketValues.GoldenMichelGone = false
        TrinketValues.FirstBrain = true
        TrinketValues.Cloud_9 = 9
        TrinketValues.Loyalty_card = 6
        TrinketValues.Labyrinth = 1
        TrinketValues.Sacrificial_dagger = 0
        TrinketValues.Swashbuckler = 0
        TrinketValues.Egg = 3
        TrinketValues.Supernova = {}
        TrinketValues.Dna = true
        TrinketValues.FullDeck = {}
        if PlayerManager.AnyoneIsPlayerType(Balatro_Expansion.JimboType) then
            local index = 1
            for i = 0, 3, 1 do --cycles between the suits
                for j = 1, 13, 1 do --cycles for all the values
                    TrinketValues.FullDeck[index] = {}
                    TrinketValues.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
                    TrinketValues.FullDeck[index].Value = j
                    TrinketValues.FullDeck[index].Enhancement = 1
                    TrinketValues.FullDeck[index].Edition = 1
                    index = index +1
                end
            end
            for i = 0, Game:GetNumPlayers()-1, 1 do
                local Player = Game:GetPlayer(i)
                if Player:GetPlayerType() == Balatro_Expansion.JimboType then
                    local HandRNG = Player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
                    TrinketValues.FullDeck = Balatro_Expansion:Shuffle(TrinketValues.FullDeck, HandRNG)
                    break
                end
            end
        end
        TrinketValues.DeckPointer = 1
        TrinketValues.CurrentHand = {0,0,0,0,0} --basically 5 different cards

        if Balatro_Expansion:Contained(Challenges, Game.Challenge) then
            TrinketValues.ShopEntered = true
        else
            TrinketValues.ShopEntered = false
        end
        TrinketValues.DamageTakenRoom = 0
        TrinketValues.DamageTakenFloor = 0
        TrinketValues.TreasureEntered = false
        TrinketValues.Picked = {0}  --to prevent weird shenadigans
        TrinketValues.Tags = {}
        TrinketValues.EffectsAllowed = true
        return
    end

    --all of this only happens on continue runs--
    ---------------------------------------------
    --Game:GetPlayer(0):UseCard(Card.CARD_HIEROPHANT)  just tests

    for i = 0, Game:GetNumPlayers() - 1, 1 do   --evaluates again for the mod's trinkets since closing the game
                                                --resets the callbacks and the pickedTrinkets table
        local player = Game:GetPlayer(i)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end    
    --print(#TrinketValues.Tags)
    for j = 1, #TrinketValues.Tags, 1 do
        local TagX = TrinketValues.Tags[j]
        --print(TagX)
        if not (TagX == "mult" or TagX == "chips" or TagX == "multm") then
            if TagX == "newroom" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnNewRoom)
            
            elseif TagX == "newfloor" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Balatro_Expansion.OnNewFloor)

            elseif TagX == "items" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Balatro_Expansion.OnItemPickup)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, Balatro_Expansion.OnItemRemoval)
                
            elseif TagX == "coins" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_COIN)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_COIN)
            elseif TagX == "bombs" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_BOMB)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_BOMB)
            elseif TagX == "keys" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_KEY)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_KEY)
            elseif TagX == "hearts" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_HEART)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_HEART)
            elseif TagX == "cards" then --also includes runes and pills
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_TAROTCARD)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_PILL)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_PILL)
            elseif TagX == "cardremove" then --also includes runes and pills
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, Balatro_Expansion.OnConsumableRemove)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, Balatro_Expansion.OnConsumableRemove)
            
            elseif TagX == "rocks" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, Balatro_Expansion.OnRockDestroy)
                
            elseif TagX == "pickupnum" then --they all give the same callvack
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Balatro_Expansion.OnUpdate)
            
            elseif TagX == "roomclear" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.OnRoomClear)
                
            elseif TagX == "taken" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Balatro_Expansion.OnTakenDamage, EntityType.ENTITY_PLAYER)
                
            elseif TagX == "specificroom" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnSpecificRoomEnter)
                
            elseif TagX == "bought" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, Balatro_Expansion.OnShopPurchase)
                
            elseif TagX == "removal" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, Balatro_Expansion.OnTrinketRemoval)
            elseif TagX == "revive" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, Balatro_Expansion.OnDeath)
            elseif TagX == "restock" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, Balatro_Expansion.OnRestock)                
            elseif TagX == "carduse" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_CARD, Balatro_Expansion.OnCardUse)
                Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_PILL, Balatro_Expansion.OnPillUse)
            elseif TagX == "activeuse" then
                Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_ITEM, Balatro_Expansion.OnActiveUse)
            end
        end
    end
    --print(TrinketValues.Tags)
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE ,Balatro_Expansion.OnGameStart)
                                        --btw putting IMPORTANT as the prioriry here makes it not happen


---@param trinket TrinketType
function Balatro_Expansion:TrinketPickup(_,trinket,_)
    --print("trinket")
    local Trinket = ItemsConfig:GetTrinket(trinket)
    Balatro_Expansion.WantedEffect = trinket
    --these only make effects (only one per trinket)
    if not (Trinket:HasCustomTag("mult") or Trinket:HasCustomTag("chips") or Trinket:HasCustomTag("multm") or Trinket:HasCustomTag("mult/chips") or Trinket:HasCustomTag("activate")) then
        return --not a mod's trinket
    end
    --print("mod")
    if Balatro_Expansion:Contained(TrinketValues.Picked, trinket) then --checks if the trinket was already taken this run
        return
    else
        TrinketValues.Picked[#TrinketValues.Picked+1] = trinket
        --table.insert((TrinketValues.Picked), trinket)
        --dude i swear to god, table.insert just won't work
    end
    --print("not contained")
    for i=1, #Trinket:GetCustomTags(), 1 do --needed since certain trinkets have the same tags, whick would double the callbacks
        local TagX = Trinket:GetCustomTags()[i]
        if not Balatro_Expansion:Contained(TrinketValues.Tags, TagX) then
            TrinketValues.Tags[#TrinketValues.Tags+1] =  TagX
            if not (TagX == "mult" or TagX == "chips" or TagX == "multm" or TagX == "mult/chips") then
                --print("idk")
                if TagX == "newroom" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnNewRoom)
            
                elseif TagX == "newfloor" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Balatro_Expansion.OnNewFloor)
                
                elseif TagX == "items" then
                    --print("callback")
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Balatro_Expansion.OnItemPickup)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, Balatro_Expansion.OnItemRemoval)

                
                elseif TagX == "coins" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_COIN)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_COIN)
                elseif TagX == "bombs" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_BOMB)                    
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_BOMB)
                elseif TagX == "keys" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_KEY)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_KEY)
                elseif TagX == "hearts" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_HEART)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_HEART)
                elseif TagX == "cards" then --also includes runes and pills
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_TAROTCARD)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision, PickupVariant.PICKUP_PILL)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision, PickupVariant.PICKUP_PILL)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, Balatro_Expansion.OnConsumableRemove)
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, Balatro_Expansion.OnConsumableRemove)
                
                elseif TagX == "rocks" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, Balatro_Expansion.OnRockDestroy)
                
                elseif TagX == "pickupnum" then 
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Balatro_Expansion.OnUpdate)
                
                elseif TagX == "roomclear" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.OnRoomClear)
                elseif TagX == "taken" then --damage taken
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Balatro_Expansion.OnTakenDamage, EntityType.ENTITY_PLAYER)
                elseif TagX == "specificroom" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnSpecificRoomEnter)
                elseif TagX == "bought" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, Balatro_Expansion.OnShopPurchase)
                elseif TagX == "removal" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, Balatro_Expansion.OnTrinketRemoval)
                elseif TagX == "revive" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, Balatro_Expansion.OnDeath)
                elseif TagX == "restock" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, Balatro_Expansion.OnRestock)
                elseif TagX == "carduse" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_CARD, Balatro_Expansion.OnCardUse)
                elseif TagX == "activeuse" then
                    Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_ITEM, Balatro_Expansion.OnActiveUse)
                end
            end
            
        end

    end
    --print(TrinketValues.Tags)
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, Balatro_Expansion.TrinketPickup)
