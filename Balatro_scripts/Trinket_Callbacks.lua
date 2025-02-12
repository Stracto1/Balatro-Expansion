local mod = Balatro_Expansion
local TrinketValues = mod.Saved.TrinketValues

-----------------------------------
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")

local INVENTORY_RENDERING_POSITION = Vector(20,250)

local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local Game = Game()
---------------------------------------
local PastCoins
local PastBombs
local PastKeys


function mod:OnGetTrinket(Selected, SEED)
    if TrinketValues.MichaelDestroyed then--michael was destroyed previously

        if TrinketValues.GoldenMichelGone then --3% to replace with cavendish if a golden michael was destroyed
            local RNG = RNG(SEED)

            if RNG:RandomFloat() <= 0.03 then
                return TrinketType.TRINKET_CAVENDISH
            end
        end
        if Selected == TrinketType.TRINKET_GROS_MICHAEL  then
            local Trinket
            repeat
                Trinket = ItemPool:GetTrinket()
            until Trinket ~= TrinketType.TRINKET_GROS_MICHAEL
            return Trinket
        end

    else--michael was not destroyed

        if Selected == TrinketType.TRINKET_CAVENDISH then  --prevents cavemdish from being chosen
            local Trinket
            repeat
                Trinket = ItemPool:GetTrinket()
            until Trinket ~= TrinketType.TRINKET_CAVENDISH
            return Trinket
        end
    end
    
end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.OnGetTrinket)

---@param player EntityPlayer
function mod:SpecificTrinket(player,trinket,_)
    if trinket == TrinketType.TRINKET_BLUEPRINT then 
        mod:BluePrint(player, true)
    end
    if trinket == TrinketType.TRINKET_BRAINSTORM then
        mod:BrainStorm(player, true)
    end
    if trinket == TrinketType.TRINKET_SUPERNOVA then
        for i = 0, 1, 1 do
            local Active = player:GetActiveItem(i)
            if not TrinketValues.Supernova[Active] then
                TrinketValues.Supernova[Active] = 0
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.SpecificTrinket)


function mod:OnItemRemoval(player,item)
    if player:HasTrinket(TrinketType.TRINKET_ABSTRACT_JOKER) then
        mod.WantedEffect = TrinketType.TRINKET_ABSTRACT_JOKER
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_EVENSTEVEN) then
        mod.WantedEffect = TrinketType.TRINKET_EVENSTEVEN
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then
        mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_ODDTODD) then
        mod.WantedEffect = TrinketType.TRINKET_ODDTODD
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_SUPERNOVA) then
        local itemsconfig = ItemsConfig:GetCollectible(item)
        if itemsconfig.Type == ItemType.ITEM_ACTIVE then
            mod.WantedEffect = TrinketType.TRINKET_SUPERNOVA
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)


function mod:OnTrinketRemoval(player,trinket)
    --print("removed")
    if trinket == TrinketType.TRINKET_BLUEPRINT then
        mod:BluePrint(player, false)
        TrinketValues.LastBPitem = 0
    end
    if trinket == TrinketType.TRINKET_BLUEPRINT then
        mod:BrainStorm(player,false)
    end
    if trinket == TrinketType.TRINKET_EGG then
        mod:EGG(player, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)

function mod:OnItemPickup(item,_,first,_,_,player)
    local itemconfig = ItemsConfig:GetCollectible(item)
    --if Player:HasCollectible(The_Hand, false, true)
    if itemconfig.Type ~= ItemType.ITEM_ACTIVE and itemconfig.Type ~= ItemType.ITEM_TRINKET then
        --print("passive")
        --print("picked up")
        if TrinketValues.Brainstorm == 0 then
            TrinketValues.Brainstorm = item
        end
        TrinketValues.Blueprint = item
    end
    --print(TrinketValues.Brainstormitem)


    if player:HasTrinket(TrinketType.TRINKET_BLUEPRINT) and first then
        mod.WantedEffect = TrinketType.TRINKET_BLUEPRINT
        mod:BluePrint(player, true)
    end
    if TrinketValues.FirstBrain and player:HasTrinket(TrinketType.TRINKET_BRAINSTORM) then
        mod.WantedEffect = TrinketType.TRINKET_BRAINSTORM
        mod:BrainStorm(player, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_ABSTRACT_JOKER) then
        mod.WantedEffect = TrinketType.TRINKET_ABSTRACT_JOKER
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_EVENSTEVEN) then
        mod.WantedEffect = TrinketType.TRINKET_EVENSTEVEN
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then
        mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_ODDTODD) then
        mod.WantedEffect = TrinketType.TRINKET_ODDTODD
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_SUPERNOVA) then
        local itemconfig = ItemsConfig:GetCollectible(item)
        if itemconfig.Type == ItemType.ITEM_ACTIVE then
            if not TrinketValues.Supernova[item] then
                TrinketValues.Supernova[item] = 0
            end
            mod.WantedEffect = TrinketType.TRINKET_SUPERNOVA
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end 
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)

function mod:AlwaysOnNewRoom()
    Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_SHOP then
        TrinketValues.ShopEntered = true
    elseif Room == RoomType.ROOM_TREASURE then
        TrinketValues.TreasureEntered = true
    end
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if TrinketValues.Cloud_9 == 0 then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_CLOUD_NINE) > 1 then
                TrinketValues.Cloud_9 = 5
            else
                TrinketValues.Cloud_9 = 9
            end
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM,CallbackPriority.LATE, mod.AlwaysOnNewRoom)

function mod:OnNewRoom()
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if player:HasTrinket(TrinketType.TRINKET_MISPRINT) then --plus mult jokers
            mod.WantedEffect = TrinketType.TRINKET_MISPRINT
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(TrinketType.TRINKET_BLOODSTONE) then
            mod.WantedEffect = TrinketType.TRINKET_BLOODSTONE
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if TrinketValues.Cloud_9 == 0 then
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
    Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_SHOP then
        TrinketValues.ShopEntered = true
    elseif Room == RoomType.ROOM_TREASURE then
        TrinketValues.TreasureEntered = true
    end
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if TrinketValues.Cloud_9 == 0 then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_CLOUD_NINE) > 1 then
                TrinketValues.Cloud_9 = 5
            else
                TrinketValues.Cloud_9 = 9
            end
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)


--determines if shop/treasures can be skipped this floor
function mod:AlwaysOnNewFloor()
    TrinketValues.DamageTakenFloor = 0
    TrinketValues.Dna = true
    TrinketValues.Rocks = 0
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if  player:HasTrinket(TrinketType.TRINKET_STONE_JOKER) then
            mod.WantedEffect = TrinketType.TRINKET_STONE_JOKER
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end

    local AvailableRooms = mod:FloorHasShopOrTreasure()
    TrinketValues.ShopEntered = not AvailableRooms.Shop
    TrinketValues.TreasureEntered = not AvailableRooms.Treasure
end
--mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, mod.AlwaysOnNewFloor)

function mod:OnNewFloor()
    --print("new floor")
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        
        if player:HasTrinket(TrinketType.TRINKET_INVISIBLE_JOKER) then --activate jokers
            mod.WantedEffect = TrinketType.TRINKET_INVISIBLE_JOKER
            mod:InvisibleJoker(player) --activates the invisible joker trinket
        end
        if player:HasTrinket(TrinketType.TRINKET_POPCORN) then
            TrinketValues.Popcorn = TrinketValues.Popcorn - 0.4
            mod.WantedEffect = TrinketType.TRINKET_POPCORN
            if TrinketValues.Popcorn <= 0.3 then
                repeat
                    player:TryRemoveTrinket(TrinketType.TRINKET_POPCORN)
                    player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_POPCORN)
                until not player:HasTrinket(TrinketType.TRINKET_POPCORN)
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                TrinketValues.Popcorn = 2 --resets in case the player gets another one
                return --does nothing, just stops the function
            end
                
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if  player:HasTrinket(TrinketType.TRINKET_ROCKET) then
            mod.WantedEffect = TrinketType.TRINKET_ROCKET
            mod:rocket(player)
        end
        if player:HasTrinket(TrinketType.TRINKET_RED_CARD) then
            if TrinketValues.ShopEntered == false then
                TrinketValues.Red_card = TrinketValues.Red_card + 0.20
            end
            if TrinketValues.TreasureEntered == false then
                TrinketValues.Red_card = TrinketValues.Red_card + (0.20 * TrinketValues.Labyrinth)
            end
            mod.WantedEffect = TrinketType.TRINKET_RED_CARD
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(TrinketType.TRINKET_RIFF_RAFF) then
            mod.WantedEffect = TrinketType.TRINKET_RIFF_RAFF
            mod:RiffRaff(player)
        end
        if player:HasTrinket(TrinketType.TRINKET_GOLDEN_JOKER) then
            mod.WantedEffect = TrinketType.TRINKET_GOLDEN_JOKER
            mod:Goldenjoker(player)
        end
        if player:HasTrinket(TrinketType.TRINKET_MADNESS) then
            RNG = player:GetTrinketRNG(TrinketType.TRINKET_MADNESS)
            if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B and  player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
                    if player:GetNumCoins() > 0 then
                        for i = 1, player:GetTrinketMultiplier(TrinketType.TRINKET_MADNESS), 1 do
                            TrinketValues.Madness = TrinketValues.Madness + (math.floor(player:GetNumCoins()/5) / 100)
                            player:AddCoins(- player:GetNumCoins())
                        end
                    end
                else --NON KEEPER ONLY
                    
                    for i = 1, player:GetTrinketMultiplier(TrinketType.TRINKET_MADNESS), 1 do
                        if player:GetMaxHearts() > 2 then
                    
                            player:AddMaxHearts(-2, true)
                            TrinketValues.Madness = TrinketValues.Madness + 0.05
                        elseif player:GetMaxHearts() == 0 then
                    
                            if player:GetSoulHearts() > 2 then
                                player:AddSoulHearts(-2)
                            TrinketValues.Madness = TrinketValues.Madness + 0.05
                            end
                        end
                    end
                end
            end
            for i = 0, player:GetTrinketMultiplier(TrinketType.TRINKET_MADNESS) , 1 do
                local ItemCount = player:GetCollectibleCount()
                if ItemCount == 0 then
                    break
                end
                local Item
                repeat
                    Item = RNG:RandomInt(1, CollectibleType.NUM_COLLECTIBLES)
                until player:HasCollectible(Item, true, false)
                player:RemoveCollectible(Item)
                TrinketValues.Madness = TrinketValues.Madness + 0.05
            end
            mod.WantedEffect = TrinketType.TRINKET_MADNESS
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end

        if player:HasTrinket(TrinketType.TRINKET_SACRIFICIAL_DAGGER) then
            local Active = player:GetActiveItem(i)
            if Active ~= 0 then
                --print("Active")
                player:RemoveCollectible(Active, true, i)
                TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                sfx:Play(SLICESOUND)
            end
            if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B and  player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
                    if player:GetNumCoins() > 0 then
                        for i = 1, player:GetTrinketMultiplier(TrinketType.TRINKET_SACRIFICIAL_DAGGER), 1 do
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + player:GetNumCoins()/100
                            player:AddCoins(- player:GetNumCoins())
                            sfx:Play(SLICESOUND)
                        end
                    end
                else --KEEPER ONLY
                    for i = 1, player:GetTrinketMultiplier(TrinketType.TRINKET_SACRIFICIAL_DAGGER), 1 do
                        if player:GetMaxHearts() > 2 or (player:GetMaxHearts() == 2 and player:GetSoulHearts() > 0)then
                    
                            player:AddMaxHearts(-2, true)
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                            sfx:Play(SLICESOUND)
                        elseif player:GetSoulHearts() > 2 then

                            player:AddSoulHearts(-2)
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                            sfx:Play(SLICESOUND)
                        end
                    end
                end
            end
            mod.WantedEffect = TrinketType.TRINKET_SACRIFICIAL_DAGGER
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(TrinketType.TRINKET_GROS_MICHAEL) then
            local RNG = player:GetTrinketRNG(TrinketType.TRINKET_GROS_MICHAEL) 
            local Chance = 0.34
            if RNG:RandomFloat() <= Chance then
                TrinketValues.MichaelDestroyed = true
                mod.WantedEffect = "MCdestroyed"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                for i=0, player:GetMaxTrinkets() - 1, 1 do
                    local Trinket = player:GetTrinket(i)
                    if Trinket == (TrinketType.TRINKET_GROS_MICHAEL + TrinketType.TRINKET_GOLDEN_FLAG) then
                        TrinketValues.GoldenMichelGone = true 
                    end
                end 
                repeat
                    player:TryRemoveTrinket(TrinketType.TRINKET_GROS_MICHAEL)
                    player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_GROS_MICHAEL)
                until not player:HasTrinket(TrinketType.TRINKET_GROS_MICHAEL)
            else
                mod.WantedEffect = "MCsafe"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(TrinketType.TRINKET_CAVENDISH) then
            local RNG = player:GetTrinketRNG(TrinketType.TRINKET_CAVENDISH) 
            local Chance = 0.002
            if RNG:RandomFloat() <= Chance and player:GetTrinketMultiplier(TrinketType.TRINKET_CAVENDISH) == 1 then --unlucky man
                mod.WantedEffect = "MCdestroyed"
                TrinketValues.MichaelDestroyed = false
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                repeat
                    player:TryRemoveTrinket(TrinketType.TRINKET_CAVENDISH)
                    player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_CAVENDISH)
                until not player:HasTrinket(TrinketType.TRINKET_CAVENDISH)
            else
                mod.WantedEffect = "MCsafe"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(TrinketType.TRINKET_CARTOMANCER) then
            mod.WantedEffect = TrinketType.TRINKET_CARTOMANCER
            mod:CArtomancer(player)
        end
        if player:HasTrinket(TrinketType.TRINKET_EGG) then
            --print("egg")
            mod.WantedEffect = TrinketType.TRINKET_EGG
            mod:EGG(player, false)
        end
    end

    TrinketValues.DamageTakenFloor = 0
    TrinketValues.Dna = true
    TrinketValues.Rocks = 0
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if  player:HasTrinket(TrinketType.TRINKET_STONE_JOKER) then
            mod.WantedEffect = TrinketType.TRINKET_STONE_JOKER
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end

    local AvailableRooms = mod:FloorHasShopOrTreasure()
    TrinketValues.ShopEntered = not AvailableRooms.Shop
    TrinketValues.TreasureEntered = not AvailableRooms.Treasure
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)


--AGGIUNGI ROBA QUANDO SERVIRà
---@param pickup EntityPickup
function mod:PrePickupCollision(pickup, collider)
    
end
--mod::AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision)



function mod:OnPickupCollision(pickup, collider,_)
    --checks who collided
    if collider.GetType(collider) == EntityType.ENTITY_PLAYER then --checks if a player collided with the pickup
        
        local player = collider:ToPlayer()
        if player:HasTrinket(TrinketType.TRINKET_CLOUD_NINE) then
            if TrinketValues.Cloud_9 == 0 then
                if player:GetTrinketMultiplier(TrinketType.TRINKET_CLOUD_NINE) == 1 then
                    TrinketValues.Cloud_9 = 5
                else
                    TrinketValues.Cloud_9 = 9
                end
            else
                TrinketValues.Cloud_9 = TrinketValues.Cloud_9 - 1
            end
            if player:GetTrinketMultiplier(TrinketType.TRINKET_CLOUD_NINE) > 1 and TrinketValues.Cloud_9 > 5 then
                TrinketValues.Cloud_9 = 5
            end
            mod.WantedEffect = TrinketType.TRINKET_CLOUD_NINE
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
        if player:HasTrinket(TrinketType.TRINKET_SMEARED_JOKER) then
            mod.WantedEffect = TrinketType.TRINKET_SMEARED_JOKER
            mod:SmearedJoker(player, pickup)
        end

        if pickup.Variant == PickupVariant.PICKUP_COIN then 
        
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB then

        elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
                
            if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then  --times mult jokers
                mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        
        elseif pickup.Variant == PickupVariant.PICKUP_PILL then
            if player.HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then  --times mult jokers
                mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        
        end

    else
        return nil
    end       
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision)



function mod:OnCardUse(card,player,_)
    --print("card used")
    --print(TrinketValues.Fortune_Teller)
    local CardConfig = ItemsConfig:GetCard(card) 
    if CardConfig.CardType == ItemConfig.CARDTYPE_TAROT then --normal tarot
        
        TrinketValues.Fortune_Teller = TrinketValues.Fortune_Teller + (0.05 * player:GetTrinketMultiplier(TrinketType.TRINKET_FORTUNETELLER))
    elseif CardConfig.CardType == ItemConfig.CARDTYPE_TAROT_REVERSE then --reverse tarot
        TrinketValues.Fortune_Teller = TrinketValues.Fortune_Teller - 0.05
        if TrinketValues.Fortune_Teller < 0 then
            TrinketValues.Fortune_Teller = 0
        end
    end
    if player:HasTrinket(TrinketType.TRINKET_FORTUNETELLER) then
        --print("fortuneteller")
        mod.WantedEffect = TrinketType.TRINKET_FORTUNETELLER
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end

    if player:HasTrinket(TrinketType.TRINKET_DNA) then
        mod:DNA(player, PickupVariant.PICKUP_TAROTCARD, card)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)


function mod:OnPillUse(pill,player,_)
    if player:HasTrinket(TrinketType.TRINKET_DNA) then
        mod:DNA(player, PickupVariant.PICKUP_PILL, pill)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnPillUse)

function mod:OnActiveUse(Active,_,player,_,_,_)
    if player:HasTrinket(TrinketType.TRINKET_DNA) then
        --needs a frame to maket the single use active items disappear
        Isaac.CreateTimer(function ()
            mod:DNA(player, PickupVariant.PICKUP_COLLECTIBLE, Active)
        end, 1, 1, true)
        
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnActiveUse)


function mod:OnConsumableRemove(player,_,_) --whenever a card/pill is lost from the player
        if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then  --times mult jokers
            mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)

---@param RockType GridEntityType
function mod:OnRockDestroy(_,RockType,_)
    
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
            if player:HasTrinket(TrinketType.TRINKET_STONE_JOKER) then
                local Multiplier = 1

                if RockType == GridEntityType.GRID_ROCKT then --tinted rocks give 3X progress
                    Multiplier = 3
                elseif RockType == GridEntityType.GRID_ROCK_SS then --super tinted rock give 5X progress
                    Multiplier = 5
                end

                if TrinketValues.Stone_joker <= 25 then
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.06 * Multiplier)
                elseif  TrinketValues.Stone_joker <= 75 then
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.03 * Multiplier)
                else
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.01 * Multiplier)
                end

                mod.WantedEffect = TrinketType.TRINKET_STONE_JOKER
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                break
            end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy, GridEntityType.GRID_ROCK)

---@param player EntityPlayer
function mod:OnUpdate(player)
    local NowCoins = player:GetNumCoins()
    local NowBombs = player:GetNumBombs()
    local NowKeys = player:GetNumKeys()
    --local NowHearts = player:GetHearts()
    if NowCoins ~= PastCoins then
        if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then
            if NowCoins == 0 or PastCoins == 0 then
                mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(TrinketType.TRINKET_BULL) or player:GetPlayerType() == mod.Characters.JimboType then
            mod.WantedEffect = TrinketType.TRINKET_BULL
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
        PastCoins = NowCoins
    end

    if NowBombs ~= PastBombs then
        if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then
            if NowBombs == 0 or PastBombs == 0 then
                mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(TrinketType.TRINKET_ONIX_AGATE) then
            mod.WantedEffect = TrinketType.TRINKET_ONIX_AGATE
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        PastBombs = NowBombs
    end

    if NowKeys ~= PastKeys then
        if player:HasTrinket(TrinketType.TRINKET_JOKER_STENCIL) then
            if NowKeys == 0 or PastKeys == 0 then
                mod.WantedEffect = TrinketType.TRINKET_JOKER_STENCIL
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(TrinketType.TRINKET_ARROWHEAD) then
            mod.WantedEffect = TrinketType.TRINKET_ARROWHEAD
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
        PastKeys = NowKeys
    end

    --if NowHearts ~= PastHearts then
        
        --PastHearts = NowHearts
    --end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate)

---@param player EntityPlayer
function mod:OnRoomClear(player)
    --print("cleared")

    --MANY TRINKETS ONLY ACTIVATE IN GREED MODE WHEN THE MAJOR WAVE CHUNKS ARE COMPLETED
    local Wave = Game:GetLevel().GreedModeWave --current wave in greed mode
    local WantedWaves = {}
    local IsGreed = Game:IsGreedMode()
    if IsGreed then
        if Game:IsHardMode() then
            WantedWaves = {9,11,12} --greedier last waves
        else
            WantedWaves = {8,10,11} --greed last waves
        end
    end
    --if greed then only on specific waves, else happens anyways
    if not IsGreed or mod:Contained(WantedWaves, Wave) or Game:GetLevel():GetName() == "shop" then
        --print("consider clear")
    if player:HasTrinket(TrinketType.TRINKET_VAGABOND) then
        --print("vagabond")
        mod.WantedEffect = TrinketType.TRINKET_VAGABOND
        mod:VAgabond(player)
    end
    if player:HasTrinket(TrinketType.TRINKET_ROUGH_GEM) then
        mod.WantedEffect = TrinketType.TRINKET_ROUGH_GEM
        mod:RoughGem(player)
    end
    if player:HasTrinket(TrinketType.TRINKET_LOYALTY_CARD) then
        if TrinketValues.Loyalty_card == 0 then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_LOYALTY_CARD) == 1 then
                TrinketValues.Loyalty_card = 5
            else
                TrinketValues.Loyalty_card = 3
            end
        else
            TrinketValues.Loyalty_card = TrinketValues.Loyalty_card - 1
        end
        if player:GetTrinketMultiplier(TrinketType.TRINKET_LOYALTY_CARD) > 1 and TrinketValues.Loyalty_card > 4 then
            TrinketValues.Loyalty_card = 4
        end
        mod.WantedEffect = TrinketType.TRINKET_LOYALTY_CARD
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_LOYALTY_CARD) then
        mod:DelayedGratification(player)
    end
    end
    --EXCEPTIONS TO THE GREED MODE WAVE CHECK
    if player:HasTrinket(TrinketType.TRINKET_ICECREAM) then
        mod.WantedEffect = TrinketType.TRINKET_ICECREAM
        TrinketValues.Ice_cream = TrinketValues.Ice_cream - 0.05
        if TrinketValues.Ice_cream <= 0 then
            repeat
                player:TryRemoveTrinket(TrinketType.TRINKET_ICECREAM)
                player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_ICECREAM)
            until not player:HasTrinket(TrinketType.TRINKET_ICECREAM)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
            TrinketValues.Ice_cream = 1 --resets in case the player find another one
            return --does nothing, just stops the function
        end
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_GREEN_JOKER) then
        mod.WantedEffect = TrinketType.TRINKET_GREEN_JOKER
        TrinketValues.Green_joker = TrinketValues.Green_joker + (0.04 * player:GetTrinketMultiplier(TrinketType.TRINKET_GREEN_JOKER))
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_SUPERNOVA) then
        for i = 0, 1, 1 do
            local Active = player:GetActiveItem(i)
            if Active ~= 0 then
                TrinketValues.Supernova[Active] = TrinketValues.Supernova[Active] + (0.04 * player:GetTrinketMultiplier(TrinketType.TRINKET_SUPERNOVA))
            end
        end
        mod.WantedEffect = TrinketType.TRINKET_SUPERNOVA
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)


function mod:OnTakenDamage(player,_,_,_,_)
    TrinketValues.DamageTakenRoom = TrinketValues.DamageTakenRoom + 1
    TrinketValues.DamageTakenFloor = TrinketValues.DamageTakenFloor + 1

    player = player:ToPlayer() --initially it's a generic entity
    if player:HasTrinket(TrinketType.TRINKET_RAMEN) then
        mod.WantedEffect = TrinketType.TRINKET_RAMEN
        TrinketValues.Ramen = TrinketValues.Ramen - 0.02
        if TrinketValues.Ramen <= 1 then
            repeat
                player:TryRemoveTrinket(TrinketType.TRINKET_RAMEN)
                player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_RAMEN)
            until not player:HasTrinket(TrinketType.TRINKET_RAMEN)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            TrinketValues.Ramen = 1.3 --resets in case the player find another one
            return
        end
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(TrinketType.TRINKET_GREEN_JOKER) then
        TrinketValues.Green_joker = TrinketValues.Green_joker - 0.5
        if TrinketValues.Green_joker < 0 then
            TrinketValues.Green_joker = 0
        end
        mod.WantedEffect = TrinketType.TRINKET_GREEN_JOKER
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function mod:OnShopPurchase(_,player,cost)
    if player:HasTrinket(TrinketType.TRINKET_HALLUCINATION) then
        mod.WantedEffect = TrinketType.TRINKET_HALLUCINATION
        mod:HAllucination(player, cost)
    end
    if player:HasTrinket(TrinketType.TRINKET_SWASHBUCKLER) then
        --print(cost)
        local increase = 0
        if cost > 0 then
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B) then
                increase = (cost * 0.01)
            else
                increase = (cost * 0.02)
            end
            
        elseif cost > PickupPrice.PRICE_FREE then
            if cost == PickupPrice.PRICE_ONE_HEART or cost == PickupPrice.PRICE_ONE_SOUL_HEART or cost == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART or cost == PickupPrice.PRICE_SOUL then
                
                increase = 0.20
            elseif cost == PickupPrice.PRICE_TWO_HEARTS or cost == PickupPrice.PRICE_TWO_SOUL_HEARTS or cost == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS then
                
                increase = 0.40
            elseif cost == PickupPrice.PRICE_THREE_SOULHEARTS then

                increase = 0.25
            elseif cost == PickupPrice.PRICE_SPIKES then

                increase = 0.10
            end
        end
        TrinketValues.Swashbuckler = TrinketValues.Swashbuckler + increase
        if increase > 0 then
            mod.WantedEffect = TrinketType.TRINKET_SWASHBUCKLER
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)

function mod:OnDeath(player)
    if player:GetPlayerType() == mod.Characters.JimboType then
        if mod:JimboHasTrinket(player, TrinketType.TRINKET_MR_BONES) then
            mod:MrBones(player, true)
        end
    else
        if player:HasTrinket(TrinketType.TRINKET_MR_BONES) then
            mod:MrBones(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)

function mod:OnRestock(partial)
    --print("restock")
    for i = 0, Game:GetNumPlayers() - 1, 1 do
        local player = Game:GetPlayer(i)
        if player:HasTrinket(TrinketType.TRINKET_FLASH_CARD) then
            mod.WantedEffect = TrinketType.TRINKET_FLASH_CARD
            if partial then
                TrinketValues.Flash_card = TrinketValues.Flash_card + 0.05
            else
                TrinketValues.Flash_card = TrinketValues.Flash_card + 0.15
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)