---@diagnostic disable: undefined-field, need-check-nil, inject-field, cast-local-type, param-type-mismatch
local mod = Balatro_Expansion

local BASE_TEETH_PATH = "gfx/familiar/teeth_familiar.png"
local TEETH_COSTUMES = {[CollectibleType.COLLECTIBLE_APPLE] = {PATH = "gfx/familiar/teeth_apple_costume.png", LAYER = 3},
                        [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = {PATH = "gfx/familiar/teeth_cable_costume.png", LAYER = 4},
                        [CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = {PATH = "gfx/familiar/teeth_cookie_costume.png", LAYER = 3},
                        [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = {PATH = "gfx/familiar/teeth_tomato_costume.png", LAYER = 3},
                        [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = {PATH = "gfx/familiar/teeth_midas_costume.png", LAYER = 2},
                        [CollectibleType.COLLECTIBLE_DEAD_TOOTH] = {PATH = "gfx/familiar/teeth_stinky_costume.png", LAYER = 2},
                        [CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = {PATH = "gfx/familiar/teeth_vampire_costume.png", LAYER = 1},
                        [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = {PATH = "gfx/familiar/teeth_serpent_costume.png", LAYER = 1},
                        [CollectibleType.COLLECTIBLE_DOG_TOOTH] = {PATH = "gfx/familiar/teeth_dog_costume.png", LAYER = 1},
                        [CollectibleType.COLLECTIBLE_TOUGH_LOVE] = {PATH = "gfx/familiar/teeth_tooth_costume.png", LAYER = 0},
                        [CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = {PATH = "gfx/familiar/teeth_maw_costume.png", LAYER = 0}}

---@param Teeth EntityFamiliar
local function UpdateCostumes(Teeth)

    local Sprite = Teeth:GetSprite()
    local Player = Teeth.Player

    Sprite:ReplaceSpritesheet(0, BASE_TEETH_PATH, false)
    for i=1, 4 do
        Sprite:ReplaceSpritesheet(i, "")
    end

    for Item, Costume in pairs(TEETH_COSTUMES) do

        local Layer = Sprite:GetLayer(Costume.LAYER)
        
        if Player:HasCollectible(Item) then--and not Layer:IsVisible() then
            
            Sprite:ReplaceSpritesheet(Costume.LAYER, Costume.PATH)
        end
    end

    Sprite:LoadGraphics()

    for i,Layer in ipairs(Sprite:GetAllLayers()) do
        print(Layer:GetLayerID(), Layer:GetSpritesheetPath(), Layer:IsVisible())
    end
end


---@param Player EntityPlayer
local function OnItemAdded(_, Item, Charge, FirstTime, Slot, Var, Player)

    --local Costume = TEETH_COSTUMES[Item]

    if TEETH_COSTUMES[Item] then

        print("costume")

        for _,Teeth in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.TEETH)) do

            Teeth = Teeth:ToFamiliar()
            if Teeth.Player:GetPlayerIndex() == Player:GetPlayerIndex() then
                UpdateCostumes(Teeth)
            end
        end
    end

    --[[
    for _,Teeth in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.TEETH)) do
        
        Teeth = Teeth:ToFamiliar()
        if Teeth.Player:GetPlayerIndex() == Player:GetPlayerIndex() then

            local Sprite = Teeth:GetSprite()

            Sprite:ReplaceSpritesheet(Costume.LAYER, Costume.PATH, true)
            Sprite:GetLayer(Costume.LAYER):SetVisible(true)
        end
    end]]
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, OnItemAdded)


---@param Player EntityPlayer
local function OnItemRemoved(_, Item, Charge, FirstTime, Slot, Var, Player)

    --local Costume = TEETH_COSTUMES[Item]

    if TEETH_COSTUMES[Item] then
        
        for _,Teeth in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.TEETH)) do

            Teeth = Teeth:ToFamiliar()
            if Teeth.Player:GetPlayerIndex() == Player:GetPlayerIndex() then
                UpdateCostumes(Teeth)
            end
        end
    end

    --[[
    for _,Teeth in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.TEETH)) do
        
        Teeth = Teeth:ToFamiliar()
        if Teeth.Player:GetPlayerIndex() == Player:GetPlayerIndex() then

            local Sprite = Teeth:GetSprite()

            Sprite:ReplaceSpritesheet(Costume.LAYER, Costume.PATH, true)
            Sprite:GetLayer(Costume.LAYER):SetVisible(true)
        end
    end]]
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, OnItemRemoved)



---@param Familiar EntityFamiliar
function mod:FamiliarInit(Familiar)
    UpdateCostumes(Familiar)
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.FamiliarInit, mod.Familiars.TEETH)