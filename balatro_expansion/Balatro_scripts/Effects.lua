local mod = Balatro_Expansion

local PlayerWithEffect
local LastWanted = 0
local FirtsEffect = true --to prevent errors
local LastEffect = EntityEffect
local EffectRotation
local EffectText = " "
local TEXT_TYPES = {"+","X","ACTIVATE!","EXTINCT!","VALUE UP!","UPGRADE!","SAFE!","INTERESTS!","$"," REMAINING"}
local EFFECT_COLOR_TYPES = {Color(238, 49, 66),Color(49, 140, 238),Color(238, 186, 49),}
--local MultEffect = Isaac.GetEntityVariantByName("MultEffect")
--local ChipsEffect = Isaac.GetEntityVariantByName("ChipsEffect")
local ActivateEffect = Isaac.GetEntityVariantByName("ActivateEffect")

local ADDMULTSOUND = Isaac.GetSoundIdByName("ADDMULTSFX")
local TIMESMULTSOUND = Isaac.GetSoundIdByName("TIMESMULTSFX")
local ACTIVATESOUND = Isaac.GetSoundIdByName("ACTIVATESFX")
local CHIPSSOUND = Isaac.GetSoundIdByName("CHIPSSFX")
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")

local sfx = SFXManager()

--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off in MOD CONFIG MENU)


---@param effect EntityEffect
function mod:EffectSpawning(effect)
    --sets the offset from the player
    if PlayerWithEffect.CanFly then
        effect.SpriteOffset = Vector(0, -39) * PlayerWithEffect.SpriteScale   --adjusts the position to over Isaac's head and scales it basing on how many effects there are
    else
        effect.SpriteOffset = Vector(0, -35) * PlayerWithEffect.SpriteScale
    end
    effect:FollowParent(PlayerWithEffect) --makes the effect follow Isaac
    EffectRotation = math.random(90)    --slightly changes the rotation to give a little life
    --tha first time always shows, then if another effect already exists it cancels it
    if not FirtsEffect and LastEffect.Exists(LastEffect) then
        LastEffect:Remove()
    else
        FirtsEffect = false
    end
    LastEffect = effect
end
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectSpawning, MultEffect)
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectSpawning, ChipsEffect)    --calls every time the custom effects are spawned
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectSpawning, ActivateEffect)

---@param effect EntityEffect
function mod:OnEffectUpdate(effect)
    local sprite = effect:GetSprite()
    sprite.Rotation = EffectRotation      --slightly changes the rotation to give a little life
    if not sprite:IsPlaying("idle") then  --removes the entity as the animation is finished
        effect:Remove()
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate, MultEffect)
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate, ChipsEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate, ActivateEffect)

function mod:OnEffectRender(_) 
    local TextWidth = mod.Fonts.upheavalmini:GetStringWidth(EffectText)
    local position
    if PlayerWithEffect.CanFly then
        position = Isaac.WorldToScreen(PlayerWithEffect.Position) + Vector(-TextWidth/2 ,(-39 * PlayerWithEffect.SpriteScale.Y )-4)    
    else
        position = Isaac.WorldToScreen(PlayerWithEffect.Position) + Vector(-TextWidth/2 ,(-35 * PlayerWithEffect.SpriteScale.Y )-4)
    end
    mod.Fonts.upheavalmini:DrawString(EffectText, position.X, position.Y + 1, KColor(0.6,0.6,0.6,0.7),0,true) -- emulates little text shadow
    mod.Fonts.upheavalmini:DrawString(EffectText, position.X, position.Y, KColor(1,1,1,1),0,true) --remember, always put these in render callbacks

end
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.OnEffectRender, MultEffect)
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.OnEffectRender, ChipsEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.OnEffectRender, ActivateEffect)

--used to spawn the effect along with checking stuff easily
--TYPE | 1 = + | 2 = X | 3 = activate | 4 = DESTROYED | 5 = VALUE UP
function mod:EffectConverter(TextType, Text, player, EffectID)     
    if not mod.SavedValues.ModConfig.EffectsAllowed then
        return
    end

    if Text == 0 then --would be 0.00 otherwise
        Text = "0"
    end

    if TextType == #TEXT_TYPES then
        Text = tostring(Text)..TEXT_TYPES[TextType]
    else
        if TextType == 9 then --money excaption
            Text = TEXT_TYPES[1]..tostring(Text)..TEXT_TYPES[9]

        elseif TextType >= 3 then --no need for numbers on certain occasions
            Text = TEXT_TYPES[TextType]
        else
            Text = TEXT_TYPES[TextType]..tostring(Text)
        end
    end
    mod:SpawnTheEffect(player, EffectID, Text)
end


--ID: 1 = +Mult | 2 = *Mult | 3 = Chips | 4 = Activate | 5 = slice | 6 = money
function mod:SpawnTheEffect(PlayerEffect, effectID, Text) 
    PlayerWithEffect = PlayerEffect  --needed for followparent [see on effect init]
    
    --effects from different sources are displayed at an interval from each other instead of overriding
    --effects from the same source are cut off during the animation to spawn the second one
    if (not FirtsEffect and LastEffect:Exists()) and (LastWanted ~= mod.WantedEffect and 0) then
        --print("delayed")
        Isaac.CreateTimer(function()
                        mod:SpawnTheEffect(PlayerEffect, effectID, Text)
                        end, 25, 1, false)
        return
    end
    EffectText = Text
    --print(mod.WantedEffect)
    --print("spawned")
    if effectID == 1 then --mult
        Isaac.Spawn(1000, ActivateEffect, 1, PlayerEffect.Position, Vector.Zero, PlayerEffect):GetData()
        sfx:Play(ADDMULTSOUND, 1, 0, false, 1, 0)

    elseif effectID == 2 then --times mult
        Isaac.Spawn(1000, ActivateEffect, 1, PlayerEffect.Position, Vector.Zero, PlayerEffect):GetData()
        sfx:Play(TIMESMULTSOUND, 1, 0, false, 1, 0)

    elseif effectID == 3 then --chips
        Isaac.Spawn(1000, ActivateEffect, 2, PlayerEffect.Position, Vector.Zero, PlayerEffect):GetData()
        sfx:Play(CHIPSSOUND, 1, 0, false, 1, 0)

    elseif effectID == 4 then --activate
        Isaac.Spawn(1000, ActivateEffect, 3, PlayerEffect.Position, Vector.Zero, PlayerEffect):GetData()
        sfx:Play(ACTIVATESOUND, 1, 0, false, 1, 0)

    elseif effectID == 5 then --slice
        Isaac.Spawn(1000, ActivateEffect, 1, PlayerEffect.Position, Vector.Zero, PlayerEffect):GetData()
        sfx:Play(SLICESOUND, 1, 0, false, 1, 0)

    elseif effectID == 6 then --money
        Isaac.Spawn(1000, ActivateEffect, 3, PlayerEffect.Position, Vector.Zero, PlayerEffect):GetData()
        sfx:Play(ACTIVATESOUND, 1, 0, false, 1, 0) --placeholdersound

    else
        return
    end
    if mod.WantedEffect ~= "MCdestroyed" and mod.WantedEffect ~= "MCsafe" then
        ---@diagnostic disable-next-line: cast-local-type
        LastWanted = mod.WantedEffect
    end
    mod.WantedEffect = 0
end