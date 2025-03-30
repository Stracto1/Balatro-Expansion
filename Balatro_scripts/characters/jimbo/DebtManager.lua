local mod = Balatro_Expansion

local Game = Game()


local PastCoins = 0
---@param Player EntityPlayer
function mod:MoneyCounterFix(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.Saved.Other.HasDebt then
        return
    end

    local CurrentCoins = Player:GetNumCoins()
    local MoneyGained = CurrentCoins - PastCoins

    if MoneyGained == 0 then
        return
    end

    local TrueGain = -MoneyGained*2

    if CurrentCoins <= -TrueGain then --if the player gains more than its debt value
        mod.Saved.Other.HasDebt = false

        local Difference = CurrentCoins + TrueGain

        Player:AddCoins((MoneyGained-CurrentCoins)*2)

        PastCoins = Difference

    else
        Player:AddCoins(TrueGain)

        CurrentCoins = Player:GetNumCoins()
        PastCoins = CurrentCoins

    end





end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.MoneyCounterFix)


---@param Player Entity
---@param Item EntityPickup
function mod:LimitShopping(Item,Player,_)


    ---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()

    if not Player or Item.Price <= 0 then
        return
    end

    local NumCredit = 0

    for _,player in ipairs(PlayerManager.GetPlayers()) do
        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == mod.Jokers.CREDIT_CARD then

                NumCredit = NumCredit + 1

            end
        end
    end

    local MaxShopDebt = 20*NumCredit

    if mod.Saved.Other.HasDebt then

        if Player:GetNumCoins() > MaxShopDebt then
            return false
        end
        
        Player:AddCoins(Item.Price*2)
        PastCoins = Player:GetNumCoins() - Item.Price

    elseif Item.Price > Player:GetNumCoins() then --costs more than the current non-debt coin value
        
        local Difference = Item.Price - Player:GetNumCoins()
    
        Player:AddCoins(Difference*2)
        PastCoins = Difference

        mod.Saved.Other.HasDebt = true
        
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.LimitShopping)




---@param Player Entity
---@param Slot EntitySlot
function mod:NoGambleWithoutCredit(Slot,Player,_)

---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()

    if not Player or (not mod.Saved.Other.HasDebt and Player:GetNumCoins() ~= 0) or Slot:GetState() ~= 1 then
        return
    end

    local HasCredit = false

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == mod.Jokers.CREDIT_CARD then

                HasCredit = true
                break

            end
        end
    end

    if not HasCredit then
        return false
    end

    if Player:GetNumCoins() == 0 then
        
        Player:AddCoins(2) --allows the player to start a debt even at 0 coins

        PastCoins = Player:GetNumCoins() - 1

        mod.Saved.Other.HasDebt = true

    end

end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.BATTERY_BUM)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.BEGGAR)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.ROTTEN_BEGGAR)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.SHELL_GAME)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.SLOT_MACHINE)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.SHOP_RESTOCK_MACHINE)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.FORTUNE_TELLING_MACHINE)

