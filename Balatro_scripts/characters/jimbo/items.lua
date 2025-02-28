local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()


--SOME VOUCHERS HAVE THEIR EFFECT IN mechanics.lua 
--(Wasteful/recyclomancy - clearance/liquidation - Overstock/plus - Hone/Glow Up)

--OTHERS HAVE IT IN Custom_Cards.lua
--(magic trick/Illusion - Crystal Ball/Omen Globe)


---@param Player EntityPlayer
function mod:VoucherPool(Type,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not ItemsConfig:GetCollectible(Type):HasCustomTag("balatro") then
        return
    end

    if Player:HasCollectible(Type) then --there shouldn't be duplicate vouchers

        if Type % 2 == mod.VoucherOff then --if it's a base voucher

            Type = Type + 1 --gives its upgraded version instead

            if Player:HasCollectible(Type) then --but again no duplicates
                Type = 0

            else--if it's new then remove it form the pool

                table.remove(mod.Saved.Pools.Vouchers, mod:GetValueIndex(mod.Saved.Pools.Vouchers, Type, true))

                if mod.Saved.Pools.Vouchers == {} then
                    table.insert(mod.Saved.Pools.Vouchers, mod.Vouchers.Blank) --the breakfasting of balatro
                end
            end

        else
            Type = CollectibleType.COLLECTIBLE_NULL
        end

    else

        table.remove(mod.Saved.Pools.Vouchers, mod:GetValueIndex(mod.Saved.Pools.Vouchers, Type, true))
        if Type % 2 == mod.VoucherOff then --if it's a base voucher

            if not next(mod.Saved.Pools.Vouchers) then
                table.insert(mod.Saved.Pools.Vouchers, mod.Vouchers.Blank) --the breakfasting of balatro
            else
                table.insert(mod.Saved.Pools.Vouchers, Type + 1) --add it's upgraded counterpart to the pool
            end

        end
    end

    return Type
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.VoucherPool)

---@param Player EntityPlayer
function mod:VoucherPool2(Player, Type)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not ItemsConfig:GetCollectible(Type):HasCustomTag("balatro") then
        return
    end

    if Type % 2 == mod.VoucherOff then --if it's a base voucher

        if Player:HasCollectible(Type + 1) then --if he has its upgraded version
        
            --remove the upgreded one for the base one
            Player:AddCollectible(Type)
            Player:RemoveCollectible(Type + 1)

            --brings the upgraded one back into the pool
            table.insert(mod.Saved.Pools.Vouchers, Type + 1)

            return
        end
    end
    table.insert(mod.Saved.Pools.Vouchers, Type)

    
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.VoucherPool2)




---@param Player EntityPlayer
function mod:VouchersAdded(Item,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Item == mod.Vouchers.Wasteful or Item == mod.Vouchers.Recyclomancy then
        mod.HpEnable = true
        Player:AddMaxHearts(2)
        Player:AddHearts(2)
        mod.HpEnable = false

    elseif Item == mod.Vouchers.Brush or Item == mod.Vouchers.Palette then

        mod:ChangeJimboHandSize(Player, 1)
    
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.VouchersAdded)


function mod:VouchersRemoved(Player, Item)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Item == mod.Vouchers.Wasteful or Item == mod.Vouchers.Recyclomancy then
        mod.HpEnable = true
        Player:AddMaxHearts(-2)
        mod.HpEnable = false

    elseif Item == mod.Vouchers.Brush or Item == mod.Vouchers.Palette then

        mod:ChangeJimboHandSize(Player, -1)
    
    end


end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.VouchersRemoved)


function mod:RerollVoucher(Partial)
    if Partial or not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    local DidSomething = false --needs to reroll a shop item to work

    for i,Pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP,-1,-1, true)) do
        if Pickup:ToPickup():IsShopItem() then
            DidSomething = true
            break
        end
    end

    if not DidSomething then
        return
    end


    local GlutOwner = PlayerManager.FirstCollectibleOwner(mod.Vouchers.RerollGlut)

    if GlutOwner then
        GlutOwner:AddCoins(2)
        mod:CreateBalatroEffect(GlutOwner, mod.EffectColors.YELLOW,
        mod.Sounds.MONEY, "+2 $")
        return
    end
    
    local SurplusOwner = PlayerManager.FirstCollectibleOwner(mod.Vouchers.RerollSurplus)
    
    if SurplusOwner then
        Game:GetPlayer(0):AddCoins(1)
        mod:CreateBalatroEffect(SurplusOwner, mod.EffectColors.YELLOW,
        mod.Sounds.MONEY, "+1 $")
        return
    end
    
end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.RerollVoucher)



---@param Player EntityPlayer
function mod:HandsCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    if Player:HasCollectible(mod.Vouchers.Grabber) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.NachoTong) then
        Value = Value + 1
    end

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.HandsCache, "hands")



---@param Player EntityPlayer
function mod:FinalHandsCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    Value = Value + 5

    Value = math.max(Value ,1)
    mod.Saved.Jimbo.MaxCards = math.ceil(5 * Value)

end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE,CallbackPriority.LATE, mod.FinalHandsCache, "hands")

