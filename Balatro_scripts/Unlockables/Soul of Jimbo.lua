local mod = Balatro_Expansion
local Game = Game()
local sfx = SFXManager()



local function OnSoulUse(_, card, Player, Flags)

    if card ~= mod.JIMBO_SOUL then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if Flags & UseFlag.USE_CARBATTERY ~= 0 then
        
        mod.Saved.Player[PIndex].JimboSoulCharge = mod.Saved.Player[PIndex].JimboSoulCharge + 2
    else
        mod.Saved.Player[PIndex].JimboSoulCharge = mod.Saved.Player[PIndex].JimboSoulCharge + 1
    end

    sfx:Play(mod.Sounds.PLASMA)
    Game:MakeShockwave(Player.Position, 0.025, 0.025, 10)


    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, OnSoulUse)



--tears eval always comes before damage eval (from what I was able to test), so force a damage eval after it to be sure to get both of the fully evaled stats
local function FirstSoulEval(_, Player, Flag) 

    if not mod.GameStarted then 
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    if mod.Saved.Player[PIndex].JimboSoulCharge > 0 then
        
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE) --might make the damage eval happen twice but i'm not sure
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE + 1, FirstSoulEval, CacheFlag.CACHE_FIREDELAY)



--damage comes after tears in eval, to putting it in LATE gives us both the fully evaled stats to use for the total
local function SecondSoulEval(_, Player, Flag)

    if not mod.GameStarted then 
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if not mod.Saved.Player[Player:GetData().TruePlayerIndex] then
        return
    end

    if mod.Saved.Player[PIndex].JimboSoulCharge > 0 then
        
        if Player:GetPlayerType() == mod.Characters.JimboType then

            local Total = mod.Saved.Player[PIndex].TrueDamageValue + mod.Saved.Player[PIndex].TrueTearsValue

            mod.Saved.Player[PIndex].TrueDamageValue = Total / 2
            mod.Saved.Player[PIndex].TrueTearsValue = Total / 2
        else
            local Total = Player.Damage + mod:CalculateTears(Player.MaxFireDelay)

            Player.Damage = Total / 2
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(Player.Damage)
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboStatPriority.GIVE + 1, SecondSoulEval, CacheFlag.CACHE_DAMAGE)


local function RemoveSoulEffect(_, Player)

    if not mod.GameStarted then 
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.Saved.Player[PIndex].JimboSoulCharge > 0 then

        mod.Saved.Player[PIndex].JimboSoulCharge = mod.Saved.Player[PIndex].JimboSoulCharge - 1

        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, RemoveSoulEffect)
