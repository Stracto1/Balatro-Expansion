local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()


---@param Player EntityPlayer
function mod:VoucherPool(Type,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    --if its a voucher remove it from the custom pool and add the other if needed
    if ItemsConfig:GetCollectible(Type):HasCustomCacheTag("balatro") then
        table.remove(mod.Saved.Pools.Vouchers, mod:GetValueIndex(mod.Saved.Pools.Vouchers, Type, true))
        if Type % 2 == mod.VoucherOff then --if it's a base voucher
            if mod.Saved.Pools.Vouchers == {} then
                table.insert(mod.Saved.Pools.Vouchers, mod.Vouchers.Blank)
            else
                table.insert(mod.Saved.Pools.Vouchers, Type + 1)
            end
            
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.VoucherPool)