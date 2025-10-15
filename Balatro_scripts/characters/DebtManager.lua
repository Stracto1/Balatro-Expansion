local mod = Balatro_Expansion

local Game = Game()


local PastCoins = 0
---@param Player EntityPlayer
function mod:MoneyCounterFix(Player)

    if not mod.GameStarted then
        --print("stop money")
        PastCoins = 0
        return
    end

    if mod.Saved.DebtAmount == 0 then
        return
    end

    local MoneyGained = Player:GetNumCoins() - PastCoins

    if MoneyGained == 0 then

        if mod.Saved.DebtAmount ~= 0 then --poorify while in debt

            local DebtMoney = math.floor(Player:GetMaxCoins()/2)
            
            Player:AddCoins(DebtMoney - Player:GetNumCoins())
            PastCoins = Player:GetNumCoins()
        end

        return
    end    

    --local TrueGain = -MoneyGained*2

    if mod.Saved.DebtAmount <= MoneyGained then --if the player gains more than its debt value
    
        local Extra = MoneyGained - mod.Saved.DebtAmount
    
        mod:SetMoney(Extra)

    else --still needs to cover up the debt

        mod.Saved.DebtAmount = mod.Saved.DebtAmount - MoneyGained
    end

    if mod.Saved.DebtAmount ~= 0 then --poorify while in debt

        local DebtMoney = math.floor(Player:GetMaxCoins()/2)
    
        Player:AddCoins(DebtMoney - Player:GetNumCoins())
    end

    PastCoins = Player:GetNumCoins()

    Player:AddCustomCacheTag("maxcoins", true)

end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.MoneyCounterFix)



---@param Player Entity
---@param Item EntityPickup
function mod:LimitShopping(Item,Player,_)


    ---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()

    if not Player or Item.Price <= 0 then
        return
    end

    if mod.Saved.DebtAmount ~= 0 then

        if not mod:PlayerCanAfford(Item.Price) then --surpasses the debt limit
            return true
        end
        
        --mod.Saved.DebtAmount = mod.Saved.DebtAmount + Item.Price

    elseif Item.Price > Player:GetNumCoins() then --costs more than the current non-debt coin value
    
        if not mod:PlayerCanAfford(Item.Price) then
            return
        end
        
        local Difference = Item.Price - Player:GetNumCoins()
    
        mod:SetMoney(Item.Price)

        PastCoins = 0
        mod.Saved.DebtAmount = Difference
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.LimitShopping)




---@param Player Entity
---@param Slot EntitySlot
function mod:NoGambleWithoutCredit(Slot,Player,_)

---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()

    if not Player 
       or Player:GetNumCoins() ~= 0
       or Slot:GetState() ~= 1 then
        return
    end

    local HasCredit = false

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        HasCredit = mod:JimboHasTrinket(Player, mod.Jokers.CREDIT_CARD)
        if HasCredit then
            break
        end
    end

    if not HasCredit then
        return
    end

        
    --allows the player to start a debt even at 0 coins

    local DebtMoney = math.floor(Player:GetMaxCoins()/2)

    Player:AddCoins(DebtMoney)
    PastCoins = DebtMoney - 1
    mod.Saved.DebtAmount = 1

end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.BATTERY_BUM)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.BEGGAR)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.ROTTEN_BEGGAR)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.SHELL_GAME)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.SLOT_MACHINE)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.SHOP_RESTOCK_MACHINE)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.NoGambleWithoutCredit, SlotVariant.FORTUNE_TELLING_MACHINE)


--safer way to spend money, (doesn't not consider the max coin limit)
function mod:SpendMoney(Price)

    local Player = Game:GetPlayer(0)

    local HadDebt = mod.Saved.DebtAmount ~= 0

    if HadDebt then

        mod.Saved.DebtAmount = mod.Saved.DebtAmount + Price
        
        if mod.Saved.DebtAmount <= 0 then --extinguished the debt
            
            local Extra = -mod.Saved.DebtAmount

            Player:AddCoins(Extra - Player:GetNumCoins())

            mod.Saved.DebtAmount = 0
        end
    else
        local NewBalance = Player:GetNumCoins() - Price
        Player:AddCoins(-Price)

        if NewBalance < 0 then
            mod.Saved.DebtAmount = -NewBalance
            Player:AddCoins(math.floor(Player:GetMaxCoins()/2))
        end

    end

    PastCoins = Player:GetNumCoins()
end

function mod:SetMoney(Balance)

    local Player = Game:GetPlayer(0)

    if Balance < 0 then
        mod.Saved.DebtAmount = -Balance
        Player:AddCoins(math.floor(Player:GetMaxCoins()/2) - Player:GetNumCoins())
    else
        mod.Saved.DebtAmount = 0

        Player:AddCoins(Balance - Player:GetNumCoins())
    end

    Player:AddCustomCacheTag("maxcoins", true)
    PastCoins = Player:GetNumCoins()
end


--technically no money cap
local function DebtHelp(_,Player, CustomCache, Value)

    if mod.Saved.DebtAmount ~= 0
       and not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       and not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then

        return Value*10
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, DebtHelp, "maxcoins")
