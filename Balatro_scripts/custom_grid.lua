local mod = Balatro_Expansion

local Game = Game()

local PlateState = {PRESSED = 3,
                    OFF = 0}

local BALATRO_PLATE_SUFFIX = {
                              [mod.Grids.PlateVariant.BLIND] = {[mod.BLINDS.SMALL] = "small",
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
                                                                [mod.BLINDS.BOSS_LEAF] = "leaf"},
                              [mod.Grids.PlateVariant.CASHOUT] = "cashout",
                              [mod.Grids.PlateVariant.SHOP_EXIT] = "shop_exit",
                              [mod.Grids.PlateVariant.REROLL] = "reroll",
                              [mod.Grids.PlateVariant.SMALL_BLIND_SKIP] = {[mod.SkipTags.BOSS] = "boss",
                                                                           [mod.SkipTags.BUFFON] = "buffon",
                                                                           [mod.SkipTags.CHARM] = "charm",
                                                                           [mod.SkipTags.COUPON] = "coupon",
                                                                           [mod.SkipTags.D6] = "D6",
                                                                           [mod.SkipTags.DOUBLE] = "double",
                                                                           [mod.SkipTags.ECONOMY] = "economy",
                                                                           [mod.SkipTags.ETHEREAL] = "ethereal",
                                                                           [mod.SkipTags.FOIL] = "foil",
                                                                           [mod.SkipTags.GARBAGE] = "garbage",
                                                                           [mod.SkipTags.HANDY] = "handy",
                                                                           [mod.SkipTags.HOLO] = "holo",
                                                                           [mod.SkipTags.POLYCHROME] = "polychrome",
                                                                           [mod.SkipTags.INVESTMENT] = "investment",
                                                                           [mod.SkipTags.JUGGLE] = "juggle",
                                                                           [mod.SkipTags.METEOR] = "meteor",
                                                                           [mod.SkipTags.NEGATIVE] = "negative",
                                                                           [mod.SkipTags.ORBITAL] = "orbital",
                                                                           [mod.SkipTags.RARE] = "rare",
                                                                           [mod.SkipTags.SPEED] = "speed",
                                                                           [mod.SkipTags.STANDARD] = "standard",
                                                                           [mod.SkipTags.TOP_UP] = "topup",
                                                                           [mod.SkipTags.UNCOMMON] = "uncommon",
                                                                           [mod.SkipTags.VOUCHER] = "voucher",},
}


---@param Plate GridEntityPressurePlate
function mod:UpdateBalatroPlate(Plate,Init)

    local Variant = Plate:GetVariant()

    if not mod:Contained(mod.Grids.PlateVariant, Variant) then
        return
    end

    local Sprite = Plate:GetSprite()
    --local PlateBlindLevel = mod:GetBlindLevel(Plate.VarData)

    if Init == true then

        if Variant == mod.Grids.PlateVariant.BLIND then

            local SuffixIndex = Plate.VarData

            Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[Variant][SuffixIndex]..".png", true)

        elseif Variant == mod.Grids.PlateVariant.BIG_BLIND_SKIP
               or Variant == mod.Grids.PlateVariant.SMALL_BLIND_SKIP then

            local SuffixVariant = mod.Grids.PlateVariant.SMALL_BLIND_SKIP
            local SuffixIndex = Plate.VarData

            Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_tag_"..BALATRO_PLATE_SUFFIX[SuffixVariant][SuffixIndex]..".png", true)
        else
            Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[Variant]..".png", true)
        end

        if Variant == mod.Grids.PlateVariant.CASHOUT then

            Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.DIALOG_BUBBLE, Plate.Position,
                       Vector.Zero, nil, mod.DialogBubbleSubType.CASHOUT, mod.Saved.BlindBeingPlayed)

        elseif Variant == mod.Grids.PlateVariant.REROLL then

            Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.DIALOG_BUBBLE, Plate.Position,
                       Vector.Zero, nil, mod.DialogBubbleSubType.REROLL_PRICE, mod.Saved.BlindBeingPlayed)


        elseif Variant == mod.Grids.PlateVariant.BLIND then

            Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.DIALOG_BUBBLE, Plate.Position,       
                       Vector.Zero, nil, mod.DialogBubbleSubType.BLIND_INFO, Plate.VarData)

        end

    end


    local ShouldPlateBeAvailable = false
    
    if Variant == mod.Grids.PlateVariant.CASHOUT then

        ShouldPlateBeAvailable = true

    elseif Variant == mod.Grids.PlateVariant.BLIND then

        if Plate.VarData & mod.BLINDS.SMALL ~= 0 then

            ShouldPlateBeAvailable = mod.Saved.SmallCleared == mod.BlindProgress.NOT_CLEARED

        elseif Plate.VarData & mod.BLINDS.BIG ~= 0 then

            ShouldPlateBeAvailable = mod.Saved.SmallCleared ~= mod.BlindProgress.NOT_CLEARED 
                                     and mod.Saved.BigCleared == mod.BlindProgress.NOT_CLEARED

        elseif Plate.VarData & mod.BLINDS.BOSS ~= 0 then

            ShouldPlateBeAvailable = mod.Saved.SmallCleared ~= mod.BlindProgress.NOT_CLEARED 
                                     and mod.Saved.BigCleared ~= mod.BlindProgress.NOT_CLEARED 

        end

        ShouldPlateBeAvailable = ShouldPlateBeAvailable and Plate.VarData ~= mod.Saved.BlindBeingPlayed
    
    elseif Variant == mod.Grids.PlateVariant.SMALL_BLIND_SKIP then
        
        ShouldPlateBeAvailable = mod.Saved.SmallCleared == mod.BlindProgress.NOT_CLEARED
    
    elseif Variant == mod.Grids.PlateVariant.BIG_BLIND_SKIP then
            
        ShouldPlateBeAvailable = mod.Saved.SmallCleared ~= mod.BlindProgress.NOT_CLEARED 
                                 and mod.Saved.BigCleared == mod.BlindProgress.NOT_CLEARED
    else
    
        ShouldPlateBeAvailable = true
    end

    local AnyoneOnTop = Isaac.FindInRadius(Plate.Position, 10, EntityPartition.PLAYER)[1]

    local SomeoneIsSelecting = false

    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        
        local PIndex = Player:GetData().TruePlayerIndex

        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then
            SomeoneIsSelecting = true

            break
        end
    end

    ShouldPlateBeAvailable = ShouldPlateBeAvailable
                             and not mod.AnimationIsPlaying
                             and not AnyoneOnTop
                             and not SomeoneIsSelecting


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

            Isaac.RunCallback(mod.Callbalcks.BALATRO_PLATE_PRESSED, Plate)
        end

        Plate.NextGreedAnimation = tostring(Plate.State)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_PRESSUREPLATE_UPDATE, mod.UpdateBalatroPlate)


function mod:SpawnBalatroPressurePlate(Position, PlateVariant, VarData)
    VarData = VarData or 0

    local Plate = Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, PlateVariant, Game:GetRoom():FindFreeTilePosition(Position, 10000))

    if Plate then

        Plate.VarData = VarData

        --Sprite:ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[VarData]..".png", true)
        
        mod:UpdateBalatroPlate(Plate:ToPressurePlate(), true)
    else
        print("something went wrong in plate spawning!")

        --just try again and pray i guess
        return mod:SpawnBalatroPressurePlate(Position, PlateVariant, VarData)
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
        if Plate and Plate:GetType() == GridEntityType.GRID_PRESSURE_PLATE and mod:Contained(mod.Grids.PlateVariant, Plate:GetVariant()) then
            
            mod:UpdateBalatroPlate(Plate:ToPressurePlate(), true)
            --Plate:GetSprite():ReplaceSpritesheet(0, "gfx/grid/grid_balatro_pressureplate_"..BALATRO_PLATE_SUFFIX[Plate.VarData]..".png", true)
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ResetPlatesData)


