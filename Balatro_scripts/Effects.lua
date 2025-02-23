local mod = Balatro_Expansion

--local FirtsEffect = true --to prevent errors (was used for EntityEffects)

local FIRST_EFFECT_POS = Vector(5,225)
local EFFECT_SLOT_DISTANCE = Vector(19, 0)
local EffectsInterval = 20 --frames between 2 different effect on a same entity

local EffectParams = {}
EffectParams[1] = {}
EffectParams[1].Frames = 17
EffectParams[1].Type = 0
EffectParams[1].Text = 0
EffectParams[1].Position = Vector.Zero
--local TEXT_TYPES = {"+","X","ACTIVATE!","EXTINCT!","VALUE UP!","UPGRADE!","SAFE!","INTERESTS!","$"," REMAINING"}

local EffectAnimations = {Sprite("gfx/MultAnimation.Anm2"),
                          Sprite("gfx/ChipsAnimation.Anm2"),
                          Sprite("gfx/ActivateAnimation.Anm2")}

local AnimLength = EffectAnimations[1]:GetAnimationData("idle"):GetLength()

local sfx = SFXManager()

--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off in MOD CONFIG MENU)
--initially this system was based on EntityEffects but i had many problems regarding lighting and the screen=>world coordinate conversion


--here Position colud be an entity, in that case 
function mod:CreateBalatroEffect(Slot, Type, Sound, Text, Offset)

    if EffectParams[Slot] then --if an effect is already playing on the same target

        Isaac.CreateTimer(function()
                        mod:CreateBalatroEffect(Slot, Type, Sound, Text, Offset)
                        end, 20 - EffectParams[Slot].Frames, 1, false)
        return
    else

        EffectParams[Slot] = {}
    end

    EffectParams[Slot].Frames = 0
    EffectParams[Slot].Type = Type
    EffectParams[Slot].Text = Text
    EffectParams[Slot].Rotation = math.random(90)

    if type(Slot) == "userdata" then --basically checks if it's an entity
        EffectParams[Slot].Position = Slot
        EffectParams[Slot].Offset = Offset or Vector(0,20)
    else
        EffectParams[Slot].Position = FIRST_EFFECT_POS + EFFECT_SLOT_DISTANCE * Slot
        EffectParams[Slot].Offset = Offset or Vector.Zero
    end

    sfx:Play(Sound, 1, 0, false, 1, 0)
    --print("created")
end


function mod:RenderEffect()

    for _, Params in pairs(EffectParams) do
        --local Sprite = EffectAnimations[Params.Type]
        
        if Params.Frames < 17 then
            --print(" Render frame: "..tostring(Params.Frames))
            local Sprite = EffectAnimations[Params.Type]
            Sprite:SetFrame("idle", Params.Frames)

            local RenderPos
            if Params.Position.Type then --sees if it's an entity (otherwise it's a vector)
                RenderPos = Isaac.WorldToScreen(Params.Position.Position) + Params.Offset
            else
                RenderPos = Params.Position + Params.Offset
            end

            Sprite.Rotation = Params.Rotation

            Sprite:Render(RenderPos)
            local TextWidthOff = mod.Fonts.Balatro:GetStringWidth(Params.Text) /2
            local LineHeightOff = mod.Fonts.Balatro:GetBaselineHeight() / 2
            if Params.Frames < 15 then
                mod.Fonts.Balatro:DrawString(Params.Text, RenderPos.X - TextWidthOff + 0.5, RenderPos.Y -LineHeightOff + 0.5, KColor(0.6,0.6,0.6,0.7),0,true) -- emulates little text shadow
                mod.Fonts.Balatro:DrawString(Params.Text, RenderPos.X - TextWidthOff, RenderPos.Y - LineHeightOff, KColor(1,1,1,1),0,true)

            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_HUD_RENDER, mod.RenderEffect)


function mod:Increaseframes()
    for Slot, _ in pairs(EffectParams) do
        if EffectParams[Slot].Frames < AnimLength then
            EffectParams[Slot].Frames = EffectParams[Slot].Frames + 1
        else
            EffectParams[Slot] = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_HUD_UPDATE, mod.Increaseframes)