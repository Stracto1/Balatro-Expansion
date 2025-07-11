local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()



---@param Player EntityPlayer
local function VouchersAdded(Item,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    --if the reoll price is set lower by stuff like D6 tag then don't make it higher
    --(it will be set anyway on the next shop entered)

    if Item == mod.Vouchers.RerollSurplus then
        mod.Saved.RerollStartingPrice = math.min(mod.Saved.RerollStartingPrice, 3)

    elseif Item == mod.Vouchers.RerollGlut then
        mod.Saved.RerollStartingPrice = math.min(mod.Saved.RerollStartingPrice, 1)
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,CallbackPriority.LATE, VouchersAdded)


local function VouchersRemoved(Player, Item)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED,CallbackPriority.LATE, VouchersRemoved)

