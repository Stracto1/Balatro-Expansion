---@diagnostic disable: need-check-nil
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

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    if mod:IsMotherBossRoom() then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_MOTHER
        mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.BLINDS.BOSS_MOTHER)

        mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS_MOTHER)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS_MOTHER)
        end, Interval, 1, true)

    elseif mod:IsTaintedHeartBossRoom() then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS
        mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

        mod.Saved.CurrentBlindReward = 0

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
        end, Interval, 1, true)


    elseif mod:IsMegaSatanBossRoom() then

        --mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_VESSEL
        --mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)
--
        --mod.Saved.CurrentBlindReward = 0

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

        Isaac.CreateTimer(function ()
            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
        end, Interval, 1, true)

    --elseif mod:IsDogmaBossRoom() then   aparently no room is entered as the bossfight starts

    elseif mod:IsBeastBossRoom() then

        local INITIAL_WAIT = 55

        Isaac.CreateTimer(function ()
                
            mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_ACORN --famine's boss
            Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, mod.BLINDS.BOSS)

            local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

            mod.Saved.HandsRemaining = math.ceil(T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM))
            mod.Saved.DiscardsRemaining = math.ceil(T_Jimbo:GetCustomCacheValue(mod.CustomCache.DISCARD_NUM))


            mod.Saved.CurrentRound = mod.Saved.CurrentRound + 1

            mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_ACORN
            mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

            mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

            local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

            Isaac.CreateTimer(function ()
                Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
            end, Interval, 1, true)

        end, INITIAL_WAIT, 1, true)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, StartBlindInSpecificRooms)


local function StartDogmaBossfight(_, NPC)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

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


local function StartMegaSatanBossFight(_, NPC)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    
    mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_LAMB --mod.Saved.AnteBoss
    mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

    mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)

    local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS_LAMB)

    Isaac.CreateTimer(function ()
        Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS_LAMB)
    end, Interval, 1, true)
    
    
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, StartMegaSatanBossFight, EntityType.ENTITY_MEGA_SATAN_2)


local function MakeKnifeDull(_, Familiar)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    Familiar.CollisionDamage = 0

end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, MakeKnifeDull, FamiliarVariant.KNIFE_FULL)


local function UltraHorsemanBlindSwap(_, Entity)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        return
    end

    local HorsemenKilled = Entity.Variant == 10 or Entity.Variant == 20 or Entity.Variant == 30 or Entity.Variant == 40


    if not HorsemenKilled then
        return
    end


    local INITIAL_WAIT = 30

    Isaac.CreateTimer(function()

        mod.Saved.BlindBeingPlayed = mod.BLINDS.WAITING_CASHOUT

        local PIndex = T_Jimbo:GetData().TruePlayerIndex
    
        local HandInterval = 17 + 5 * #mod.Saved.Player[PIndex].CurrentHand
        HandInterval = math.max(HandInterval, 90)


        local NEW_BOSS_WAIT = 60

        Isaac.CreateTimer(function ()

            if Entity.Variant == 10 then --ultra famine
            
                mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_BELL

                --Isaac.CreateTimer(function ()
                    Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, mod.BLINDS.BOSS_BELL)
                --end, HandInterval + 10, 1, false)

                mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)
            
            elseif Entity.Variant == 20 then --ultra pestilence
            
                mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_HEART
                Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, mod.BLINDS.BOSS_HEART)

                mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)
            
            elseif Entity.Variant == 30 then --ultra war
            
                mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_VESSEL
                Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, mod.BLINDS.BOSS_VESSEL)

                mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)
            
            elseif Entity.Variant == 40 then --ultra death
            
                mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS_BEAST
                Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, mod.BLINDS.BOSS_BEAST)

                mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.BLINDS.BOSS_BEAST)
            end


        end, NEW_BOSS_WAIT, 1, true)


        mod:SwitchCardSelectionStates(T_Jimbo, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)

        Isaac.CreateTimer(function ()

            --sfx:Play(SoundEffect.SOUND_MEGA_BLAST_START)
        
            mod.Saved.DiscardsWasted = mod.Saved.DiscardsWasted + mod.Saved.DiscardsRemaining

            mod:SwitchCardSelectionStates(T_Jimbo, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)

            mod.Saved.HandsRemaining = math.ceil(T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM))
            mod.Saved.DiscardsRemaining = math.ceil(T_Jimbo:GetCustomCacheValue(mod.CustomCache.DISCARD_NUM))


        end, HandInterval, 1, true)

    end, INITIAL_WAIT, 1, true)

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, UltraHorsemanBlindSwap, EntityType.ENTITY_BEAST)


---@param NPC EntityNPC
local function AutoKillMegaSatan(_, NPC)

    if NPC.Variant == 0 then

        local pos = Isaac.WorldToScreen(Game:GetPlayer(0).Position) + Vector(0, 20)

        Isaac.RenderText(tostring(NPC:GetSprite():IsFinished("Appear")), pos.X, pos.Y, 1,1,1,1)

        local Sprite = NPC:GetSprite()

        --for whatever reason Sprite:IsFinished("Appear") spawns like 10k jimbos even with 1 true return
        if Sprite:IsFinished("Appear") and not NPC:GetData().SpawnedKillerJimbo then
            
            local Jimbo = Game:Spawn(1000, mod.Effects.JIMBO_THE_KILLER.VARIANT, NPC.Position,
                                     Vector.Zero, nil, mod.Effects.JIMBO_THE_KILLER.SUBTYPE.ENEMIES, 1)

            Jimbo.DepthOffset = 1000

            NPC:GetData().SpawnedKillerJimbo = true


            --print("Spawn")
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, AutoKillMegaSatan, EntityType.ENTITY_MEGA_SATAN)



---@param Jimbo EntityEffect
local function JimboTheKillerStrikes(_, Jimbo)

    if not Jimbo:GetSprite():IsFinished("Kill") then
        return
    end
    
    local KillPlayers = Jimbo.SubType & mod.Effects.JIMBO_THE_KILLER.SUBTYPE.PLAYERS ~= 0
    local KillEnemies = Jimbo.SubType & mod.Effects.JIMBO_THE_KILLER.SUBTYPE.ENEMIES ~= 0

    Jimbo:Remove()


    local Room = Game:GetRoom()

    Room:MamaMegaExplosion(Jimbo.Position)

    for i,v in ipairs(Isaac.GetRoomEntities()) do

        if KillEnemies and v:IsActiveEnemy()
           or KillPlayers and v:ToPlayer() then
            v:Kill()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, JimboTheKillerStrikes, mod.Effects.JIMBO_THE_KILLER.VARIANT)



