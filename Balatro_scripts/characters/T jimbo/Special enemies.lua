local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()


local LIVES_I1 = {[1] = "middle",
                  [3] = "Middle but cool i guess",
                  [4] = "going middle",
                  [5] = "top",
}

---@param NPC EntityNPC
local function HeartTest(_, NPC)

    if NPC.Variant == 10 then --guts on top of the screen
        return
    end

    print(NPC.State, NPC.I1, NPC.I2)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        --return
    end

    local Data = NPC:GetData()

    local IsVulnerable = NPC:IsVulnerableEnemy()

    if Data.PreviousVulnerableState == nil then
        Data.PreviousVulnerableState = not IsVulnerable
    end

    if IsVulnerable ~= Data.PreviousVulnerableState and IsVulnerable == false then
        --print("ye")
        --mod.Saved.HandsRemaining = math.min(mod.Saved.HandsRemaining, T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM)) + 1
    end

    Data.PreviousVulnerableState = IsVulnerable
end
--mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HeartTest, EntityType.ENTITY_MOMS_HEART)



local function StartBlindInSpecificRooms()

    if mod:IsMotherBossRoom() then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS
        mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

        mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
        end, Interval, 1, true)

    elseif mod:IsTaintedHeartBossRoom() then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS
        mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

        mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
        end, Interval, 1, true)

    --elseif mod:IsDogmaBossRoom() then aparently no room is entered as the bossfight starts

        


    elseif mod:IsBeastBossRoom() then

        mod.Saved.CurrentRound = mod.Saved.CurrentRound + 1

        mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS
        mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

        mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
        end, Interval, 1, true)


    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, StartBlindInSpecificRooms)


local function StartDogmaBossfight(_, NPC)

    if NPC.Variant ~= 1 then --dogma's TV
        return
    end
    
    mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS --mod.Saved.AnteBoss
    mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

    mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

    local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

    Isaac.CreateTimer(function ()
        Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
    end, Interval, 1, true)
    
    
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, StartDogmaBossfight, EntityType.ENTITY_DOGMA)


local function MakeKnifeDull(_, Familiar)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    Familiar.CollisionDamage = 0

end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, MakeKnifeDull, FamiliarVariant.KNIFE_FULL)

