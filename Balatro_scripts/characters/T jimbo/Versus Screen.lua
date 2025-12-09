local mod = Balatro_Expansion

local AnimationPicker = WeightedOutcomePicker()
AnimationPicker:AddOutcomeFloat(1, 1)
AnimationPicker:AddOutcomeFloat(2, 1)
AnimationPicker:AddOutcomeFloat(3, 1)
AnimationPicker:AddOutcomeFloat(4, 1)
AnimationPicker:AddOutcomeFloat(5, 0.5)

local PortraitAnimations = {"Spade", "Heart", "Club", "Diamond", ISAAC = "Isaac"}


local PORTRAIT_TIME = 0


local function ChangePortraitSprite(T_Jimbo)

    --print(RoomTransition:GetPlayerExtraPortraitSprite():GetAnimation())

    if math.random() <= 0.01 then

        local Sprite = RoomTransition:GetPlayerExtraPortraitSprite()

        Sprite:SetFrame("Isaac", 0)
    else

        local Sprite = RoomTransition:GetPlayerExtraPortraitSprite()

        if Sprite then

            Sprite:SetFrame(PortraitAnimations[math.random(1,4)], 0)
        end
    end
end




local function BossVersus()

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not (T_Jimbo and mod.GameStarted) then
        return
    end

    local BossScreenActive = RoomTransition:IsRenderingBossIntro()

    if BossScreenActive then --and not PORTRAIT_ACTIVE_OLD then

        PORTRAIT_TIME = PORTRAIT_TIME + 1

        if PORTRAIT_TIME == 63 then --I have no idea why this has to be so specific but OK (anything lower will always play the default animation)
        
            ChangePortraitSprite(T_Jimbo)
        end
    else
        PORTRAIT_TIME = 0
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_RENDER, BossVersus)



local function ResetFloorTransition()

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        return
    end

    ChangePortraitSprite(T_Jimbo)

end
--mod:AddCallback(ModCallbacks.MC_POST_NIGHTMARE_SCENE_RENDER, ResetFloorTransition) sadly no work