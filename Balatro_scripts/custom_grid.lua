local mod = Balatro_Expansion

local Game = Game()

local PlateState = {PRESSED = 3,
                    OFF = 0}

local BALATRO_PLATE_SUFFIX = {[mod.BLINDS.CASHOUT] = "cashout",
                              [mod.BLINDS.SKIP | mod.BLINDS.SMALL] = "skip",
                              [mod.BLINDS.SKIP | mod.BLINDS.BIG] = "skip",
                              [mod.BLINDS.SMALL] = "small",
                              [mod.BLINDS.BIG] = "big",
                              [mod.BLINDS.BOSS] = "big",
                              [mod.BLINDS.BOSS_HOOK] = "hook",
                              [mod.BLINDS.BOSS_OX] = "ox",
                              [mod.BLINDS.BOSS_HOUSE] = "house",
                              [mod.BLINDS.BOSS_WALL] = "wall",
                              [mod.BLINDS.BOSS_WHEEL] = "wheel",
                              [mod.BLINDS.BOSS_ARM] = "arm",
                              [mod.BLINDS.BOSS_CLUB] = "club",
                              [mod.BLINDS.BOSS_FISH] = "fish",
                              [mod.BLINDS.BOSS_PSYCHIC] = "psychic",
                              [mod.BLINDS.BOSS_GOAD] = "goad",
                              [mod.BLINDS.BOSS_WATER] = "water",
                              [mod.BLINDS.BOSS_WINDOW] = "window",
                              [mod.BLINDS.BOSS_MANACLE] = "manacle",
                              [mod.BLINDS.BOSS_EYE] = "eye",
                              [mod.BLINDS.BOSS_MOUTH] = "mouth",
                              [mod.BLINDS.BOSS_PLANT] = "plant",
                              [mod.BLINDS.BOSS_SERPENT] = "serpent",
                              [mod.BLINDS.BOSS_PILLAR] = "pillar",
                              [mod.BLINDS.BOSS_NEEDLE] = "needle",
                              [mod.BLINDS.BOSS_HEAD] = "head",
                              [mod.BLINDS.BOSS_TOOTH] = "tooth",
                              [mod.BLINDS.BOSS_FLINT] = "flint",
                              [mod.BLINDS.BOSS_MARK] = "small",
                              [mod.BLINDS.BOSS_ACORN] = "acorn",
                              [mod.BLINDS.BOSS_VESSEL] = "vessel",
                              [mod.BLINDS.BOSS_BELL] = "bell",
                              [mod.BLINDS.BOSS_HEART] = "heart",
                              [mod.BLINDS.BOSS_LEAF] = "leaf"
}


function mod:SpawnBalatroPressurePlate(Position, VarData)
    VarData = VarData or 0

    local Plate = Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, mod.Grids.PLATE_VARIANT, Position)

    if Plate then

        Plate.VarData = VarData

        local Sprite = Plate:GetSprite()
        Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[VarData]..".png", true)
        
        --Sprite:Load(mod.Grids.PLATE_PATH) loading a new anm2 makes the button freaky for no reason apparently
        --Sprite:SetFrame("Off", 0)
        --Sprite:GetLayer(1):SetColor(Color.LaserFireMind)
        --print(Plate:GetSprite():GetAnimation())
    end

    return Plate
end

--STATE = 3 IF PRESSED
---@param Plate GridEntityPressurePlate
local function BalatroPlateInit(_, Plate)

    print("ye")
    --Plate:GetSprite():SetFrame("Off", 0)
    --print(Plate.State, Plate.VarData)

end
---@diagnostic disable-next-line: undefined-field
--mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_SPAWN, BalatroPlateInit)


---@param Plate GridEntityPressurePlate
local function ResetPlateSprite(_, Plate)

    local Room = Game:GetRoom()

    for i = 0, Room:GetGridSize() do
        local Plate = Room:GetGridEntity(i)
        if Plate and Plate:GetType() == GridEntityType.GRID_PRESSURE_PLATE and Plate:GetVariant() == mod.Grids.PLATE_VARIANT then
            
            Plate:GetSprite():ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[Plate.VarData]..".png", true)
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ResetPlateSprite)


--STATE = 3 IF PRESSED
---@param Plate GridEntityPressurePlate
local function BalatroPlateUpdate(_, Plate)

    if Plate:GetVariant() ~= mod.Grids.PLATE_VARIANT  then
        return
    end

    if Plate.State == PlateState.OFF then
        for _,Player in ipairs(PlayerManager.GetPlayers()) do

            if Game:GetRoom():GetGridIndex(Player.Position - Player.Velocity*2.25) == Plate:GetGridIndex() then

                --print("uhhh")
                Player.Velocity = Vector.Zero
                mod.Saved.BlindBeingPlayed = Plate.VarData
                Plate.State = PlateState.PRESSED
                Isaac.RunCallback(mod.Callbalcks.BALATRO_PLATE_PRESSED, Plate.VarData)
                --print(Plate.VarData)
                return
                --print("yessir")
            end
        end
    end
    --Plate:GetSprite():SetFrame("Off", 0)
    --print(Plate.State, Plate.VarData)

    
    local PlateBlindLevel = mod:GetBlindLevel(Plate.VarData)

    local ShouldPlateBeAvailable = false
    
    if PlateBlindLevel == mod.BLINDS.SMALL then
        
        ShouldPlateBeAvailable = not mod.Saved.SmallCleared

    elseif PlateBlindLevel == mod.BLINDS.BIG then

        ShouldPlateBeAvailable = mod.Saved.SmallCleared and not mod.Saved.BigCleared

    elseif PlateBlindLevel == mod.BLINDS.BOSS then

        ShouldPlateBeAvailable = mod.Saved.SmallCleared and mod.Saved.BigCleared

    else --if PlateBlindLevel == mod.BLINDS.CASHOUT then
    
        ShouldPlateBeAvailable = true
    end

    ShouldPlateBeAvailable = ShouldPlateBeAvailable and mod.Saved.BlindBeingPlayed ~= PlateBlindLevel


    local Sprite = Plate:GetSprite()

    if ShouldPlateBeAvailable then
        
        Plate.State = PlateState.OFF
        Sprite:Play("Off")

    else
        Plate.State = PlateState.PRESSED
        Sprite:Play("Switched", false)
    end


end
---@diagnostic disable-next-line: undefined-field
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_PRESSUREPLATE_UPDATE, BalatroPlateUpdate)