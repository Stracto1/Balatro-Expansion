---@diagnostic disable: need-check-nil
local mod = Balatro_Expansion
local Game = Game()

--local FirtsEffect = true --to prevent errors (was used for EntityEffects)

local FIRST_EFFECT_POS = Vector(5,225)
local EFFECT_SLOT_DISTANCE = Vector(19, 0)
local EffectsInterval = 23 --frames between 2 different effect on a same entity

local PartVariant = Isaac.GetEntityVariantByName("Pack Particle")
local PartHelpVariant = Isaac.GetEntityVariantByName("Pack Particle Helper")
local PartSub = Isaac.GetEntitySubTypeByName("Pack Particle")
local PartHelpSub = Isaac.GetEntitySubTypeByName("Pack Particle Helper")

local EffectParams = {}
EffectParams[1] = {}
EffectParams[1].Frames = 17
EffectParams[1].Color = 0
EffectParams[1].Text = 0
EffectParams[1].Position = Vector.Zero
--local TEXT_TYPES = {"+","X","ACTIVATE!","EXTINCT!","VALUE UP!","UPGRADE!","SAFE!","INTERESTS!","$"," REMAINING"}

local EffectAnimations = Sprite("gfx/ActivateAnimation.Anm2")

local AnimLength = EffectAnimations:GetAnimationData("idle"):GetLength()

local sfx = SFXManager()

--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off in MOD CONFIG MENU)
--initially this system was based on EntityEffects but i had many problems regarding lighting and the screen=>world coordinate conversion

local StackedEffects = 0
--here Position colud be an entity, in that case 
function mod:CreateBalatroEffect(Slot, Colour, Sound, Text, Offset, Volume)

    if EffectParams[Slot] then --if an effect is already playing on the same target

        StackedEffects = StackedEffects + 1
        Isaac.CreateTimer(function()
                        mod:CreateBalatroEffect(Slot, Colour, Sound, Text, Offset)
                        end, EffectsInterval - EffectParams[Slot].Frames, 1, false)
        return
    else
        StackedEffects = 0
        EffectParams[Slot] = {}
    end

    EffectParams[Slot].Frames = 0
    EffectParams[Slot].Color = Colour
    EffectParams[Slot].Text = Text
    EffectParams[Slot].Rotation = math.random(90)

    if type(Slot) == "userdata" then --basically checks if it's an entity
        EffectParams[Slot].Position = Slot
        EffectParams[Slot].Offset = Offset or Vector(0,20)
    else
        EffectParams[Slot].Position = FIRST_EFFECT_POS + EFFECT_SLOT_DISTANCE * Slot
        EffectParams[Slot].Offset = Offset or Vector.Zero
    end

    if Sound then
        sfx:Play(Sound, Volume or 1, 2, false, 0.95 + math.random()*0.1 + 0.05*StackedEffects)
    end
    --print("created")
end


function mod:RenderEffect()

    for _, Params in pairs(EffectParams) do
        --local Sprite = EffectAnimations[Params.Color]
        
        if Params.Frames < 17 then
            --print(" Render frame: "..tostring(Params.Frames))
            local Sprite = EffectAnimations

            Sprite.Color = Params.Color
            Sprite:SetFrame("idle", Params.Frames)

            local RenderPos
            if Params.Position.Color then --sees if it's an entity (otherwise it's a vector)
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



function mod:PackParticleHelper(Player, _)

    sfx:Play(mod.Sounds.EXPLOSION)
    for i=1, 3 do
        local Helper = Game:Spawn(EntityType.ENTITY_EFFECT, PartHelpVariant, Player.Position, Vector.Zero, nil, PartHelpSub, 1):ToEffect()
        
        Helper:GetData().Time = 0 --used as a substitute for .FrameCount since opening a pack disables entity updates with pause

        Helper:FollowParent(Player)
    end
end
mod:AddCallback("PACK_OPENED", mod.PackParticleHelper)



---@param Effect EntityEffect
function mod:PackParticle(Effect)
    local Data = Effect:GetData()

    Data.Time = (Data.Time) or 0

    Data.Time = Data.Time + 1 

    if Data.Time % 3 == 0 then
        
        local Particle = Game:Spawn(EntityType.ENTITY_EFFECT, PartVariant, Effect.Position, Vector.Zero, nil, PartSub, 1):ToEffect()

        
        Particle:GetData().Velocity = RandomVector() * (math.random()*3.5 + 2)
        
        --Particle:GetSprite():Play("Float 1")

    elseif Effect.FrameCount >= 30 then
        Effect:Remove()
    end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.PackParticle, PartHelpVariant)


---@param Effect EntityEffect
function mod:PackParticleRemove(Effect)

    if Effect.FrameCount == 1 then
        Effect.Velocity = Effect:GetData().Velocity
    end

    if Effect.FrameCount >= Effect:GetSprite():GetAnimationData("Float 1"):GetLength() then
        Effect:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.PackParticleRemove, PartVariant)