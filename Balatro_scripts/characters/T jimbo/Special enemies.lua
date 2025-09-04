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



local function StartBlindInMotherRoom()

    if mod:IsMotherBossRoom() then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS
        mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

        mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
        end, Interval, 1, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, StartBlindInMotherRoom)
