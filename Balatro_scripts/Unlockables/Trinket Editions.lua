---@diagnostic disable: cast-local-type, need-check-nil, param-type-mismatch
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local music = MusicManager()


local EditionPicker = WeightedOutcomePicker()
EditionPicker:AddOutcomeFloat(mod.Edition.FOIL, 1)
EditionPicker:AddOutcomeFloat(mod.Edition.HOLOGRAPHIC, 1)
EditionPicker:AddOutcomeFloat(mod.Edition.POLYCROME, 0.3)

local EDITION_CHANCE = 0.02
local NEGATIVE_CHANCE = 0.003 --this is fixed regardless of vouchers

local EditionSound = {[mod.Edition.BASE] = 0,
                      [mod.Edition.FOIL] = mod.Sounds.FOIL,
                      [mod.Edition.HOLOGRAPHIC] = mod.Sounds.HOLO,
                      [mod.Edition.POLYCROME] = mod.Sounds.POLY,
                      [mod.Edition.NEGATIVE] = mod.Sounds.NEGATIVE}

local EditionCaches = {[mod.Edition.BASE] = 0,
                       [mod.Edition.FOIL] = CacheFlag.CACHE_FIREDELAY,
                       [mod.Edition.HOLOGRAPHIC] = CacheFlag.CACHE_DAMAGE,
                       [mod.Edition.POLYCROME] = CacheFlag.CACHE_DAMAGE,
                       [mod.Edition.NEGATIVE] = 0}


local DisableChecks = false

local function TrinketSlotToInventory(i)

    if i == 0 then
        return 1

    else
        if i > 1 then
            return i
        else
            return 0
        end
    end
end


local function EditionaliseTrinkets(_, Type, RNG)

    if not Isaac.GetPersistentGameData():Unlocked(mod.Achievements.TRINKET_EDITIONS)
       or PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       or PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local EditionChosen = mod.Edition.BASE


    local EditionRoll = RNG:RandomFloat()

    if EditionRoll <= NEGATIVE_CHANCE then --negative chance (fixed)
    
        EditionChosen = mod.Edition.NEGATIVE

    else

        if EditionRoll <= EDITION_CHANCE then
            
            EditionChosen = EditionPicker:PickOutcome(RNG)                
        end
    end

    sfx:Play(EditionSound[EditionChosen])


    return Type | (EditionChosen << mod.EDITION_FLAG_SHIFT)

end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, EditionaliseTrinkets)

---@param Trinket EntityPickup
function mod:EditionedTrinketSprite(Trinket)

    local TrueSubType = Trinket.SubType & ~mod.EditionFlag.ALL

    local TrinketConfig = ItemsConfig:GetTrinket(TrueSubType)

    local Sprite = Trinket:GetSprite()
    Sprite:ReplaceSpritesheet(0, TrinketConfig.GfxFileName, true)
    Sprite:ReplaceSpritesheet(1, TrinketConfig.GfxFileName, true)


    local TrinketEdition = (Trinket.SubType & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT

    Sprite:GetLayer(0):SetCustomShader(mod.EditionShaders[TrinketEdition])
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.EditionedTrinketSprite, PickupVariant.PICKUP_TRINKET)



---@param Player EntityPlayer
function mod:RegisterEditionAdded(Player, Trinket, FirstTime)

    local PlayerType = Player:GetPlayerType()
    local PIndex = Player:GetData().TruePlayerIndex

    local LastTouchedTrinket = mod.Saved.Player[PIndex].LastTouchedTrinket

    if PlayerType == mod.Characters.JimboType
       or PlayerType == mod.Characters.TaintedJimbo
       or DisableChecks
       or not LastTouchedTrinket then
        
        return
    end


    local TrinketSubType = Trinket + 0

    local TrueTrinket = LastTouchedTrinket & ~mod.EditionFlag.ALL
    local TrinketEdition = (LastTouchedTrinket & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT

    if TrinketEdition == mod.Edition.BASE then
        return
    end
    

    local TrinketSlot

    for i = 0, Player:GetMaxTrinkets()-1 do

        if Player:GetTrinket(i) == TrinketSubType
           and mod.Saved.Player[PIndex].Inventory[TrinketSlotToInventory(i)].Edition == mod.Edition.BASE then

            TrinketSlot = TrinketSlotToInventory(i)
        end
    end

    if not TrinketSlot then
        return
    end


    if TrinketEdition == mod.Edition.NEGATIVE then

        DisableChecks = true

        Player:TryRemoveTrinket(TrinketSubType)
        Player:AddSmeltedTrinket(TrinketSubType)

        DisableChecks = false

        return
    end

    mod.Saved.Player[PIndex].Inventory[TrinketSlot].Progress = mod:GetJokerInitialProgress(TrueTrinket, nil, Player)

    mod.Saved.Player[PIndex].Inventory[TrinketSlot].Joker = TrueTrinket
    mod.Saved.Player[PIndex].Inventory[TrinketSlot].Edition = TrinketEdition

    Player:AddCacheFlags(EditionCaches[TrinketEdition], true)
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.RegisterEditionAdded)


---@param Player EntityPlayer
function mod:RegisterEditionRemoved(Player, Trinket)

    local PlayerType = Player:GetPlayerType()

    if PlayerType == mod.Characters.JimboType
       or PlayerType == mod.Characters.TaintedJimbo
       or DisableChecks then
        
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex


    local TrinketSlot

    for i = 0, Player:GetMaxTrinkets()-1 do
        if Player:GetTrinket(i) == TrinketType.TRINKET_NULL
           and mod.Saved.Player[PIndex].Inventory[TrinketSlotToInventory(i)].Edition ~= mod.Edition.BASE then

            TrinketSlot = TrinketSlotToInventory(i)
            break
        end
    end

    if not TrinketSlot then

        for i = 3, #mod.Saved.Player[PIndex].Inventory do

            local Slot = mod.Saved.Player[PIndex].Inventory[i]

            if Slot.Joker == Trinket then

                TrinketSlot = i
                break
            end
        end

        if TrinketSlot then

            Isaac.CreateTimer(function ()
                table.remove(mod.Saved.Player[PIndex].Inventory, TrinketSlot) --cannot be used if called inside a loop in the inventory so wait an update to do so
            end,0,1,true)

            mod.Saved.Player[PIndex].Inventory[TrinketSlot] = {Joker = 0,
                                                               Edition = mod.Edition.BASE,
                                                               Progress = 0,
                                                               RenderIndex = 0}
        end

        return
    end

    if Player:GetMaxTrinkets() == 2 and TrinketSlot == 2 then
        
        mod.Saved.Player[PIndex].Inventory[2], mod.Saved.Player[PIndex].Inventory[1] = 
        mod.Saved.Player[PIndex].Inventory[1], mod.Saved.Player[PIndex].Inventory[2]
    end

    --print("removed", TrinketSlot)

    local EditionRemoved = mod.Saved.Player[PIndex].Inventory[TrinketSlot].Edition + 0

    mod.Saved.Player[PIndex].Inventory[TrinketSlot].Edition = mod.Edition.BASE
    mod.Saved.Player[PIndex].Inventory[TrinketSlot].Joker = 0
    mod.Saved.Player[PIndex].Inventory[TrinketSlot].Progress = 0


    Player:AddCacheFlags(EditionCaches[EditionRemoved], true)


    for _,Pickup in ipairs(Isaac.FindByType(5, 350, Trinket)) do
    
        local Edition = (Pickup.SubType & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT

        if Edition == mod.Edition.BASE then
        
            Pickup = Pickup:ToPickup()

            Pickup:Morph(5, 350, Pickup.SubType | (EditionRemoved << mod.EDITION_FLAG_SHIFT))

            break
        end
    end
    
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.RegisterEditionRemoved)


local TrinketSprite = Sprite("gfx/005.350_trinket_custom.anm2")
TrinketSprite:SetFrame("Idle", 0)


---@param Player EntityPlayer
local function RenderHeldEdition(_, Slot, Position, Scale, Player, CropOffset)

    local PIndex = Player:GetData().TruePlayerIndex

    local Edition = mod.Saved.Player[PIndex].Inventory[TrinketSlotToInventory(Slot)].Edition

    if Edition == mod.Edition.BASE then
        return
    end

    local Config = ItemsConfig:GetTrinket(Player:GetTrinket(Slot))

    if not Config then return end

    local Gfx = Config.GfxFileName

    TrinketSprite:ReplaceSpritesheet(0, Gfx, true)
    TrinketSprite:ReplaceSpritesheet(2, Gfx, true)
    TrinketSprite.Scale = Vector.One * Scale

    TrinketSprite:GetLayer(0):SetCropOffset(CropOffset)
    TrinketSprite:GetLayer(0):SetCustomShader(mod.EditionShaders[Edition])

    TrinketSprite:Render(Position + Vector(16,16))

    return true
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, RenderHeldEdition)


---@param Player Entity
local function SetLastTrinketTouched(_, Pickup, Player)

    Player = Player:ToPlayer()

    if not Player or Player:IsHoldingItem() or Player:GetHeldEntity() then
        return
    end

    mod.Saved.Player[Player:GetData().TruePlayerIndex].LastTouchedTrinket = Pickup.SubType
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.LATE + 1, SetLastTrinketTouched, PickupVariant.PICKUP_TRINKET)


---@param Player EntityPlayer
local function OnSmelterUse(_, Item, _, Player)

    if Item ~= CollectibleType.COLLECTIBLE_SMELTER then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    for i = 0, Player:GetMaxTrinkets()-1 do
        
        local Trinket = Player:GetTrinket(i)

        --local Edition = mod.Saved.Player[PIndex].Inventory[i].Edition

        if Trinket ~= TrinketType.TRINKET_NULL then

            local I = #mod.Saved.Player[PIndex].Inventory+1

            mod.Saved.Player[PIndex].Inventory[I] = mod.Saved.Player[PIndex].Inventory[TrinketSlotToInventory(i)]
            
            --mod.Saved.Player[PIndex].TrinketEditions.SMELTED[Edition] = mod.Saved.Player[PIndex].TrinketEditions.SMELTED[Edition] + 1
        
            Player:AddCacheFlags(EditionCaches[mod.Saved.Player[PIndex].Inventory[I].Edition])

            mod.Saved.Player[PIndex].Inventory[TrinketSlotToInventory(i)] = {Joker = 0,
                                                                             Edition = mod.Edition.BASE,
                                                                             Progress = 0}
        end
    end


    Player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, OnSmelterUse)


local FOIL_BOOST = 1
local HOLO_BOOST = 1.5
local POLY_MULT = 1.15

local function FoilStatBoost(_, Player)

    if not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumFoil = 0

    for i = 1, #mod.Saved.Player[PIndex].Inventory do
        
        if mod.Saved.Player[PIndex].Inventory[i].Edition == mod.Edition.FOIL then
            NumFoil = NumFoil + 1
        end
    end

    local Tears = FOIL_BOOST*NumFoil

    Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, Tears)

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, FoilStatBoost, CacheFlag.CACHE_FIREDELAY)


local function HoloStatBoost(_, Player)

    if not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumHolo = 0

    for i = 1, #mod.Saved.Player[PIndex].Inventory do
        
        if mod.Saved.Player[PIndex].Inventory[i].Edition == mod.Edition.HOLOGRAPHIC then
            NumHolo = NumHolo + 1
        end
    end

    local Damage = HOLO_BOOST*NumHolo

    Player.Damage = Player.Damage + Damage

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, HoloStatBoost, CacheFlag.CACHE_DAMAGE)


local function PolyStatBoost(_, Player)

    if not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumPoly = 0

    for i = 1, #mod.Saved.Player[PIndex].Inventory do
        
        if mod.Saved.Player[PIndex].Inventory[i].Edition == mod.Edition.POLYCROME then
            NumPoly = NumPoly + 1
        end
    end

    local DamageMult = POLY_MULT^NumPoly

    Player.Damage = Player.Damage * DamageMult

end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, PolyStatBoost, CacheFlag.CACHE_DAMAGE)




---@param Player EntityPlayer
function mod:RemoveJoker(Player, Index, StopEval, KeepSmelted)

    local Success = false

    local Inventory = mod.Saved.Player[Player:GetData().TruePlayerIndex].Inventory

    if Player:GetPlayerType() == mod.Characters.JimboType
       or Player:GetPlayerType() == mod.Characters.TaintedJimbo then

        if Inventory[Index].Joker ~= 0 then

            Inventory[Index] = {Joker = 0,
                                Edition = mod.Edition.BASE,
                                Progress = 0,
                                RenderIndex = 0}
            Success = true
        end
    else
        if Index <= 2 then

            Success = Player:TryRemoveTrinket(Inventory[Index].Joker)-- | mod.EditionFlag[Inventory[Index].Edition])
        
        elseif not KeepSmelted then

            Success = Inventory[Index]

            if Success then
                DisableChecks = true

                Player:TryRemoveSmeltedTrinket(Inventory[Index].Joker)-- | mod.EditionFlag[Inventory[Index].Edition])

                DisableChecks = false

                Isaac.CreateTimer(function ()
                    table.remove(Inventory, Index) --cannot be used if called inside a loop in the inventory so wait an update to do so
                end,0,1,true)

                Inventory[Index] = {Joker = 0,
                                    Edition = mod.Edition.BASE,
                                    Progress = 0,
                                    RenderIndex = 0}
            end
        end
    end

    if not StopEval and Success then
        Isaac.RunCallback(mod.Callbalcks.INVENTORY_CHANGE, Player)
    end

    return Success
end

