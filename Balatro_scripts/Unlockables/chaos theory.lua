local mod = Balatro_Expansion
local Game = Game()

local VARIANT_WHITELIST = {PickupVariant.PICKUP_BOMB,
                           PickupVariant.PICKUP_KEY,
                           PickupVariant.PICKUP_HEART,
                           PickupVariant.PICKUP_LIL_BATTERY,
                           PickupVariant.PICKUP_COIN,
                           PickupVariant.PICKUP_TAROTCARD,
                           PickupVariant.PICKUP_PILL,
                           PickupVariant.PICKUP_GRAB_BAG,
                           PickupVariant.PICKUP_TRINKET,
                           PickupVariant.PICKUP_SHOPITEM}
          

--local RandomizedPickups = {}
local NewPickupSpawned = false


---comment
---@param Pickup EntityPickup
local function Randomize(_, Pickup, Variant, SubType, ReqVariant, ReqSubType, Rng)

    if ReqVariant ~= 0 and ReqSubType ~= 0 then
        return
    end

    if not mod:Contained(VARIANT_WHITELIST, ReqVariant) 
       or NewPickupSpawned then
        return
    end

    if mod:GetTotalTrinketAmount(mod.Jokers.CHAOS_THEORY) ~= 0 then

        NewPickupSpawned = true

        Game:Spawn(5, PickupVariant.PICKUP_NULL, Pickup.Position, Pickup.Velocity, Pickup.SpawnerEntity,
                   NullPickupSubType.NO_COLLECTIBLE_CHEST, mod:RandomSeed(Rng)):ToPickup()

        NewPickupSpawned = false

        return {PickupVariant.PICKUP_NULL, NullPickupSubType.NO_COLLECTIBLE_CHEST, true} --actually makes the original pickup disappear
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, CallbackPriority.EARLY, Randomize)

local function AddGoldenEffect(_, Player, Trinket, _)

    if Player:HasGoldenTrinket(Trinket) then
        
        local PIndex = Player:GetData().TruePlayerIndex

        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CHAOS, 1)
        mod.Saved.Player[PIndex].InnateItems.General[#mod.Saved.Player[PIndex].InnateItems.General+1] = CollectibleType.COLLECTIBLE_CHAOS
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, AddGoldenEffect, mod.Jokers.CHAOS_THEORY)


local function RemoveGoldenEffect(_, Player, Trinket)

    if not Player:HasGoldenTrinket(Trinket) then
        
        local PIndex = Player:GetData().TruePlayerIndex

        local ChaosI = mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_CHAOS, true)

        if ChaosI then

            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CHAOS, -1)

            table.remove(mod.Saved.Player[PIndex].InnateItems.General, ChaosI)

            --mod.Saved.Player[PIndex].InnateItems.General[#mod.Saved.Player[PIndex].InnateItems.General+1] = CollectibleType.COLLECTIBLE_CHAOS
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, RemoveGoldenEffect, mod.Jokers.CHAOS_THEORY)