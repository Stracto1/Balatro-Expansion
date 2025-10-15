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

    if PlayerManager.AnyoneHasTrinket(mod.Jokers.CHAOS_THEORY) then

        NewPickupSpawned = true

        Game:Spawn(5, PickupVariant.PICKUP_NULL, Pickup.Position, Pickup.Velocity, Pickup.SpawnerEntity,
                   NullPickupSubType.NO_COLLECTIBLE_CHEST, mod:RandomSeed(Rng)):ToPickup()

        NewPickupSpawned = false

        return {PickupVariant.PICKUP_NULL, NullPickupSubType.NO_COLLECTIBLE_CHEST, true} --actually makes the original pickup disappear
    end


end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, CallbackPriority.EARLY, Randomize)
