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
                              [mod.BLINDS.BOSS_MOUTH] = "dontremember",
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


---@param Plate GridEntityPressurePlate
local function UpdateBalatroPlate(Init,Plate)


    if Plate:GetVariant() ~= mod.Grids.PLATE_VARIANT then
        return
    end

    local Sprite = Plate:GetSprite()
    --local PlateBlindLevel = mod:GetBlindLevel(Plate.VarData)

    if Init == true then

        local SuffixIndex = Plate.VarData + 0

        if SuffixIndex & mod.BLINDS.CASHOUT ~= 0 then
            SuffixIndex = SuffixIndex & mod.BLINDS.CASHOUT
        end

        Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[SuffixIndex]..".png", true)
    end


    local ShouldPlateBeAvailable = false
    
    if Plate.VarData & mod.BLINDS.CASHOUT ~= 0 then

        if Init == true then
            Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.CASHOUT_BUBBLE, Plate.Position, Vector.Zero, nil, 0, 1)
        end
        ShouldPlateBeAvailable = true

    elseif Plate.VarData & mod.BLINDS.SMALL ~= 0 then
        
        ShouldPlateBeAvailable = not mod.Saved.SmallCleared

    elseif Plate.VarData & mod.BLINDS.BIG ~= 0 then

        ShouldPlateBeAvailable = mod.Saved.SmallCleared and not mod.Saved.BigCleared

    elseif Plate.VarData & mod.BLINDS.BOSS ~= 0 then

        ShouldPlateBeAvailable = mod.Saved.SmallCleared and mod.Saved.BigCleared

    else
    
        ShouldPlateBeAvailable = true
    end

    local AnyoneOnTop = Isaac.FindInRadius(Plate.Position, 10, EntityPartition.PLAYER)[1]

    ShouldPlateBeAvailable = ShouldPlateBeAvailable
                             and Plate.VarData ~= mod.Saved.BlindBeingPlayed
                             and not mod.AnimationIsPlaying
                             and not AnyoneOnTop


    if ShouldPlateBeAvailable then
        
        Plate.State = PlateState.OFF
        if Init == true then
            Plate.NextGreedAnimation = "0"
        end
        Sprite:Play("Off", false)

    else
        Plate.State = PlateState.PRESSED
        if Init == true then
            Plate.NextGreedAnimation = "3"
        end
        Sprite:Play("Switched", false)
    end


    if Plate.State ~= tonumber(Plate.NextGreedAnimation) then
    --if it just got pressed and someone is on top of it

        if AnyoneOnTop and Plate.State == PlateState.PRESSED then

            Isaac.RunCallback(mod.Callbalcks.BALATRO_PLATE_PRESSED, Plate.VarData)
        end

        Plate.NextGreedAnimation = tostring(Plate.State)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_PRESSUREPLATE_UPDATE, UpdateBalatroPlate)


function mod:SpawnBalatroPressurePlate(Position, VarData)
    VarData = VarData or 0

    local Plate = Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, mod.Grids.PLATE_VARIANT, Game:GetRoom():FindFreeTilePosition(Position, -1))

    if Plate then

        Plate.VarData = VarData

        --Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[VarData]..".png", true)
        
        UpdateBalatroPlate(true,Plate:ToPressurePlate())
    else
        print("something went wrong in plate spawning!")
    end

    return Plate
end



function mod:ResetPlatesData()

    if not mod.GameStarted then
        Isaac.CreateTimer(function ()
            mod:ResetPlatesData()
        end, 1,1, true)

        return
    end

    local Room = Game:GetRoom()

    for i = 0, Room:GetGridSize() do
        local Plate = Room:GetGridEntity(i)
        if Plate and Plate:GetType() == GridEntityType.GRID_PRESSURE_PLATE and Plate:GetVariant() == mod.Grids.PLATE_VARIANT then
            
            UpdateBalatroPlate(true,Plate:ToPressurePlate())
            --Plate:GetSprite():ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[Plate.VarData]..".png", true)
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ResetPlatesData)




--STATE = 3 IF PRESSED
---@param Plate GridEntityPressurePlate
local function BalatroPostPlateUpdate(_, Plate)

    if Plate:GetVariant() ~= mod.Grids.PLATE_VARIANT  then
        return
    end

    
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
--mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_PRESSUREPLATE_UPDATE, BalatroPostPlateUpdate)

