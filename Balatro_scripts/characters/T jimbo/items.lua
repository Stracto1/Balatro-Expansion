---@diagnostic disable: cast-local-type
local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()



---@param Player EntityPlayer
local function VouchersAdded(_,Item,_,_,_,_,Player)
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

    mod:UpdateRerollPrice()
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,CallbackPriority.LATE, VouchersAdded)


local function RemoveVouchersFromPool(_, Item,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local Index = mod:GetValueIndex(mod.Saved.Pools.Vouchers, Item, true)

    if Index then
        table.remove(mod.Saved.Pools.Vouchers, Index)
    end

end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,CallbackPriority.LATE, RemoveVouchersFromPool)


--moves the shop items when an overstock item is redeemed to only get the needed amount of new items
local function AddCrystalSlot(_, Item,_,_,_,_,Player)

    if Item ~= mod.Vouchers.Crystal then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.Saved.Player[PIndex].Consumables[#mod.Saved.Player[PIndex].Consumables + 1] = {Card = -1, Edition = mod.Edition.BASE}
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddCrystalSlot)


local function AddAntimatterSlot(_, Item,_,_,_,_,Player)

    if Item ~= mod.Vouchers.Antimatter then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.Saved.Player[PIndex].Inventory[#mod.Saved.Player[PIndex].Inventory + 1] = {Joker = 0, Edition = mod.Edition.BASE, Modifiers = 0, Progress = 0}

end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AddAntimatterSlot)


--moves the shop items when an overstock item is redeemed to only get the needed amount of new items
local function MoveShopItems(_, Item,_,_,_,_,Player)
    
    if Game:GetRoom() ~= RoomType.ROOM_SHOP then
        return
    end

    local OldItemNum --number of shop items before the voucher is redeemed

    if Item == mod.Vouchers.Overstock then
        
        OldItemNum = 2

    elseif Item == mod.Vouchers.OverstockPlus then
        
        OldItemNum = 3

    else
        return
    end

    local NewItemsNum = OldItemNum + 1 --number of shop items after the voucher is redeemed


    local NumItemsFound = 0

    for i = 1, OldItemNum do

        local ShopItemPos = Game:GetRoom():GetGridPosition(66 - OldItemNum + i*2)

        local ShopItem = Isaac.FindInRadius(ShopItemPos, 10)[1]

        if ShopItem then

            NumItemsFound = NumItemsFound + 1

            local NewItemPos = Game:GetRoom():GetGridPosition(66 - NewItemsNum + NumItemsFound*2)

            ShopItem.Position = NewItemPos
            ShopItem.TargetPosition = NewItemPos --makes the shop item snap to the new positin
        
        end

    end

    mod:SpawnShopItems(false)

end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, MoveShopItems)


---@param Player EntityPlayer
local function RemoveDirectorForRetcon(_, Item,_,_,_,_,Player)

    if Item ~= mod.Vouchers.Retcon then
        return
    end

    Player:RemoveCollectible(mod.Vouchers.Director)

end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, RemoveDirectorForRetcon)




---@param Pickup EntityPickup
---@param Player Entity
local function PickupCollision(_, Pickup, Player)

    if Pickup.Type ~= EntityType.ENTITY_PICKUP then
        return
    end

    Player = Player:ToPlayer()

    if not Player then
        return
    end

    if Pickup.Variant == mod.Pickups.PLAYING_CARD then

        print("collision")
        
        if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
            
            Pickup:Remove()
            return
        end

        local card = mod:PlayingCardSubTypeToParams(Pickup.SubType)

        Game:GetHUD():ShowItemText(mod:GetCardName(card), "Better play it well!")
        
        Player:AnimatePickup(Pickup:GetSprite())


        mod:AddCardToDeck(Player, card)

        Pickup:Remove()
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PickupCollision)



local function ReplaceItems()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    return mod:RandomVoucher(mod.RNGs.VOUCHERS)
end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, ReplaceItems)

