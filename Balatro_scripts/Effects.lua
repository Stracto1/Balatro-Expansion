---@diagnostic disable: need-check-nil
local mod = Balatro_Expansion
local Game = Game()

--local FirtsEffect = true --to prevent errors (was used for EntityEffects)

local EffectAnimations = Sprite("gfx/ActivateAnimation.Anm2")
EffectAnimations:SetFrame("Idle", 0)

--local AnimLength = EffectAnimations:GetAnimationData("idle"):GetLength()
local AnimLength = 27
local MaxAnimFrames = 30

local FIRST_EFFECT_POS = Vector(10,225)
local EFFECT_SLOT_DISTANCE = Vector(23, 0)
local EffectsInterval = AnimLength + 5 --frames between 2 different effect on a same entity

local PartVariant = Isaac.GetEntityVariantByName("Pack Particle")
local PartHelpVariant = Isaac.GetEntityVariantByName("Pack Particle Helper")
local PartSub = Isaac.GetEntitySubTypeByName("Pack Particle")
local PartHelpSub = Isaac.GetEntitySubTypeByName("Pack Particle Helper")

local EffectParams = {}

--[[
EffectParams[1] = {}
EffectParams[1].Frames = 17
EffectParams[1].Color = Color(1,1,1,0)
EffectParams[1].Text = ""
EffectParams[1].Position = Vector.Zero
EffectParams[1].Offset = Vector.Zero
EffectParams[1].IsEntity = false
EffectParams[1].Source = mod.Jokers.JOKER
]]

--local TEXT_TYPES = {"+","X","ACTIVATE!","EXTINCT!","VALUE UP!","UPGRADE!","SAFE!","INTERESTS!","$"," REMAINING"}



local sfx = SFXManager()

--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off in MOD CONFIG MENU)
--initially this system was based on EntityEffects but i had many problems regarding lighting and the screen=>world coordinate conversion

--here Position colud be an entity, in that case 

function mod:CreateBalatroEffect(Position, Colour, Sound, Text, EffectType, Speed)--Source, Offset, Volume)

    Speed = Speed or 1
    EffectType = EffectType or mod.EffectType.NULL
    local IsEntity = EffectType == mod.EffectType.ENTITY
    local EffectSlot = Position

    if IsEntity then --basically checks if it's an entity

        EffectSlot = GetPtrHash(Position)
        IsEntity = true
    end

    for Position, Params in pairs(EffectParams) do

        --effetcts are separated between entities and inventory, where only one of each can be on screen at a time

        if EffectType == Params.Type
           and Params.Type ~= mod.EffectType.ENTITY then --entities effects are delayed only if the same entity has more than one effect

            Isaac.CreateTimer(function()
                            mod:CreateBalatroEffect(Position, Colour, Sound, Text, EffectType)--Source, Offset, Volume)
                            end,  EffectsInterval - EffectParams[Position].Frames, 1, false)

            return
        end
    end
    StackedEffects = 0

    do --rounds the number to 2 decimals so it doesn't get too long

    local Xpos = string.find(Text,"X",1,true) --tells if it's "X num" or "+num X"

    local Number,NumX = Text, 0

    if Xpos then
        Number,NumX = string.gsub(Text,"X","",1),10 --removes X to use tonumber()  
    end

---@diagnostic disable-next-line: cast-local-type
    Number = tonumber(Number)

    if Number then

        Text = tostring(mod:round(Number, 2)) --rounded number

        if NumX == 0 then
            --something without X
        
            Text = mod:GetSignString(Number)..Text
        
        elseif Xpos ~= 1 then
            --"+-num X"

            Text = mod:GetSignString(Number)..Text.."X"

        else --if Xpos == 1
            --"Xnum"

            Text = "X"..Text
        end
    end


    end

    EffectParams[EffectSlot] = {}
    if IsEntity then
        
        EffectParams[EffectSlot].Position = EntityPtr(Position)
        EffectParams[EffectSlot].Offset = Vector(0,20)
    else
        EffectParams[EffectSlot].Position = Position
        EffectParams[EffectSlot].Offset = Vector(0,-30)

        mod.Counters.Activated[Position] = 0
    end

    EffectParams[EffectSlot].Speed = Speed
    EffectParams[EffectSlot].Frames = 0
    EffectParams[EffectSlot].Color = Colour
    EffectParams[EffectSlot].Text = Text
    EffectParams[EffectSlot].Rotation = math.random(90)
    --EffectParams[EffectSlot].Source = Source
    EffectParams[EffectSlot].Type = EffectType


    if Sound then
        sfx:Play(Sound, 1, 2, false, 0.95 + math.random()*0.1 + mod:Lerp(0, 2, (Speed-1)/2))
    end
    --print("created")
end


local function EffectFramesToScale(Frames)

    return Vector.One * mod:Lerp(0, 1, Frames/AnimLength)
end

local function EffectFramesToAlpha(Frames)

    return mod:ExponentLerp(1, 0, Frames/AnimLength, 4)
end


function mod:RenderEffect(_,_,_,_,_)

    for Slot, Params in pairs(EffectParams) do

        --local Sprite = EffectAnimations[Params.Color]
        
        --print(" Render frame: "..tostring(Params.Frames))
        local Sprite = EffectAnimations

        Sprite.Color = Params.Color
        Sprite.Scale = EffectFramesToScale(Params.Frames)
        Sprite.Color.A = EffectFramesToAlpha(Params.Frames)

        local RenderPos
        if Params.Type == mod.EffectType.ENTITY then

            local Entity = Params.Position.Ref

            if Entity:Exists() then
                RenderPos = Isaac.WorldToScreen(Params.Position.Ref.Position) + Params.Offset
            else
                EffectParams[Slot] = nil
                return
            end
        else
            RenderPos = Params.Position + Params.Offset
        end

        Sprite.Rotation = Params.Rotation

        Sprite:Render(RenderPos)
        local TextWidthOff = mod.Fonts.Balatro:GetStringWidth(Params.Text) /2
        local LineHeightOff = mod.Fonts.Balatro:GetBaselineHeight() / 2
        if Params.Frames < AnimLength-2 then
            mod.Fonts.Balatro:DrawString(Params.Text, RenderPos.X - TextWidthOff + 0.5, RenderPos.Y -LineHeightOff + 0.5, KColor(0.6,0.6,0.6,0.7),0,true) -- emulates little text shadow
            mod.Fonts.Balatro:DrawString(Params.Text, RenderPos.X - TextWidthOff, RenderPos.Y - LineHeightOff, KColor(1,1,1,1),0,true)

        end        
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.RenderEffect)


function mod:Increaseframes()
    for Slot, _ in pairs(EffectParams) do
        if EffectParams[Slot].Frames < AnimLength then
            EffectParams[Slot].Frames = math.min(EffectParams[Slot].Frames + EffectParams[Slot].Speed, MaxAnimFrames)
        else
            EffectParams[Slot] = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_HUD_RENDER, mod.Increaseframes)





--[[
function mod:RenderEffect(_,_,_,_,_)

    for Slot, Params in pairs(EffectParams) do

        --local Sprite = EffectAnimations[Params.Color]
        
        --print(" Render frame: "..tostring(Params.Frames))
        local Sprite = EffectAnimations

        Sprite.Color = Params.Color
        Sprite:SetFrame("idle", Params.Frames)

        local RenderPos
        if Params.Type == mod.EffectType.ENTITY then

            local Entity = Params.Position.Ref

            if Entity:Exists() then
                RenderPos = Isaac.WorldToScreen(Params.Position.Ref.Position) + Params.Offset
            else
                EffectParams[Slot] = nil
                return
            end
        else
            RenderPos = Params.Position + Params.Offset
        end

        Sprite.Rotation = Params.Rotation

        Sprite:Render(RenderPos)
        local TextWidthOff = mod.Fonts.Balatro:GetStringWidth(Params.Text) /2
        local LineHeightOff = mod.Fonts.Balatro:GetBaselineHeight() / 2
        if Params.Frames < AnimLength-2 then
            mod.Fonts.Balatro:DrawString(Params.Text, RenderPos.X - TextWidthOff + 0.5, RenderPos.Y -LineHeightOff + 0.5, KColor(0.6,0.6,0.6,0.7),0,true) -- emulates little text shadow
            mod.Fonts.Balatro:DrawString(Params.Text, RenderPos.X - TextWidthOff, RenderPos.Y - LineHeightOff, KColor(1,1,1,1),0,true)

        end        
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.RenderEffect)


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

    --mod.Counters.SincePackOpen = 0
    sfx:Play(mod.Sounds.EXPLOSION)
    for i=1, 3 do
        local Helper = Game:Spawn(EntityType.ENTITY_EFFECT, PartHelpVariant, Player.Position, Vector.Zero, nil, PartHelpSub, 1):ToEffect()
        
        Helper:GetData().Time = 0 --used as a substitute for .FrameCount since opening a pack disables entity updates with pause

        Helper:FollowParent(Player)
    end
end
mod:AddCallback("PACK_OPENED", mod.PackParticleHelper)
]]


---@param Effect EntityEffect
function mod:PackParticle(Effect)

    Effect.DepthOffset = -1
    local Data = Effect:GetData()

    Data.Time = (Data.Time) or 0

    Data.Time = Data.Time + 1 

    if Data.Time % 3 == 0 and not Game:IsPaused() then
        
        local Particle = Game:Spawn(EntityType.ENTITY_EFFECT, PartVariant, Effect.Position, Vector.Zero, nil, PartSub, 1):ToEffect()

    
        Particle:GetData().Velocity = RandomVector() * (math.random()*3.5 + 2)
        Particle:SetTimeout(Particle:GetSprite():GetAnimationData("Float 1"):GetLength())
        
        --Particle:GetSprite():Play("Float 1")

    elseif Effect.FrameCount >= 30 then
        Effect:Remove()
    end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.PackParticle, PartHelpVariant)


---@param Effect EntityEffect
function mod:PackParticleRemove(Effect)

    if Effect.FrameCount == 1 then
        Effect.Velocity = Effect:GetData().Velocity or Vector.Zero
    end

    if Effect.Timeout == 0 then
        Effect:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.PackParticleRemove, PartVariant)