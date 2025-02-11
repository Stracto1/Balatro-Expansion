local mod = Balatro_Expansion

local LastWanted = 0
local FirtsEffect = true --to prevent errors
local LastEffect

local FIRST_EFFECT_POS = Vector(20,213)
local EFFECT_SLOT_DISTANCE = Vector(16, 0)

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

local sfx = SFXManager()

--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off in MOD CONFIG MENU)
--initially this system was based on EntityEffects but i had many problems regarding lighting and the screen=>world coordinete conversion


--here Position colud be an entity, in that case 
--ID: 1 = +Mult | 2 = *Mult | 3 = Chips | 4 = Activate | 5 = slice | 6 = money
function mod:CreateBalatroEffect(Slot, Type, Sound, Text, Offset)
    if EffectParams[Slot] then
        --effects from different sources are displayed at an interval from each other instead of overriding
        --effects from the same source are cut off during the animation to spawn the second one
        if (EffectParams[Slot].Frames > 0) and (LastWanted ~= mod.WantedEffect and LastWanted ~= 0) then
            --print("delayed")
            Isaac.CreateTimer(function()
                            mod:SpawnTheEffect(Slot, Type, Sound, Text, Offset)
                            end, 20, 1, false)
            --return
        end
    else
        
        EffectParams[Slot] = {}
    end
    
    EffectParams[Slot].Frames = 0
    EffectParams[Slot].Type = Type
    EffectParams[Slot].Text = Text
    EffectParams[Slot].Offset = Offset or Vector.Zero

    if type(Slot) == "userdata" then --basically checks if it's an entity
        EffectParams[Slot].Position = Slot
    else
        EffectParams[Slot].Position = FIRST_EFFECT_POS + EFFECT_SLOT_DISTANCE * Slot
    end
    
    if mod.WantedEffect ~= "MCdestroyed" and mod.WantedEffect ~= "MCsafe" then
        ---@diagnostic disable-next-line: cast-local-type
        LastWanted = mod.WantedEffect
    end
    mod.WantedEffect = 0

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
            Sprite:Render(RenderPos)
            local TextWidthOff = mod.Fonts.Balatro:GetStringWidth(Params.Text) * 0.4
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
        if EffectParams[Slot].Frames < 17 then
            EffectParams[Slot].Frames = EffectParams[Slot].Frames + 1
        else
            EffectParams[Slot] = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_HUD_UPDATE, mod.Increaseframes)