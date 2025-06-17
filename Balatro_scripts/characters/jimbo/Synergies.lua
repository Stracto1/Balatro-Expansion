---@diagnostic disable: need-check-nil, cast-local-type
local mod = Balatro_Expansion
local Game = Game()
local sfx = SFXManager()
--code here apllies all the needed synergies to the characters

---@param Tear EntityTear
---@param Collider Entity
function mod:CardCollisionSynergy(Tear,Collider,_)

    local Player = Tear.Parent:ToPlayer()

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local TearData = Tear:GetData()
    TearData.CollidedWith = TearData.CollidedWith or {}

    --print(Collider.Type, Collider.Variant, Collider.SubType)

    if not Collider:IsActiveEnemy() or mod:Contained(TearData.CollidedWith, GetPtrHash(Collider)) then
        return
    end


    local TearRNG = Tear:GetDropRNG()


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then

        local Amount = mod:IsSuit(Player, TearData.Params, mod.Suits.Heart, false) and 2 or 1

        for i = 1, Amount, 1 do

            local Laser = Player:FireBrimstone(RandomVector(), Player)

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
                Laser:SetDamageMultiplier(1.25)
            else
                Laser:SetScale(0.75)
            end

            Laser:SetDamageMultiplier(Laser:GetDamageMultiplier()*Tear.CollisionDamage/2) --idk why i need to set the multiplier like this 

            --Laser.CollisionDamage = Tear.CollisionDamage   --insted of doing this
            Laser.DisableFollowParent = true
            Laser.Position = Tear.Position

            Laser.TearFlags = Laser.TearFlags & ~TearFlags.TEAR_EXPLOSIVE --would be a suicide otherwise

        end

    elseif Player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then

        local Amount = mod:IsSuit(Player, TearData.Params, mod.Suits.Heart, false) and 2 or 1

        for i = 1, Amount, 1 do

            local Laser = Player:FireTechLaser(Tear.Position, LaserOffset.LASER_TECH1_OFFSET, RandomVector(),
                                               nil, false, Tear)

            Laser:SetKnockbackDirection(Vector.Zero)
            Laser:SetDamageMultiplier(Laser:GetDamageMultiplier()*Tear.CollisionDamage/2) --idk why i need to set the multiplier like this 
            --Laser.CollisionDamage = Tear.CollisionDamage   --insted of doing this

            Laser.DisableFollowParent = true

            Laser.TearFlags = Laser.TearFlags & ~TearFlags.TEAR_EXPLOSIVE --would be a suicide otherwise

        end
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then

        local Bomb = Player:FireBomb(Tear.Position, Vector.Zero, Tear)

        Bomb:AddTearFlags(Player:GetBombFlags() & ~TearFlags.TEAR_SAD_BOMB)

        Bomb.SpawnerEntity = Tear

        if mod:IsSuit(Player, TearData.Params, mod.Suits.Club, false) then
            
            Bomb.ExplosionDamage = Tear.CollisionDamage * 4
            Bomb.RadiusMultiplier = 1.25
        else

            Bomb.ExplosionDamage = Tear.CollisionDamage * 2.5
        end

    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.Tears.CARD_TEAR_VARIANT)
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Club])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Diamond])



---@param Player EntityPlayer
function mod:ActiveItemsNewEffect(Type, ItemRNG, Player, Flags)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Type == CollectibleType.COLLECTIBLE_SMELTER then
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY,
                                                      mod.SelectionParams.Purposes.SMELTER)
    
    elseif Type == CollectibleType.COLLECTIBLE_MOMS_BOX then

        if Flags & UseFlag.USE_MIMIC == 0 then
            Player:UseActiveItem(CollectibleType.COLLECTIBLE_MOMS_BOX, UseFlag.USE_MIMIC | UseFlag.USE_NOANIM) --spawns 2 trinkets
        end

        return {["Remove"] = true}
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ActiveItemsNewEffect)


---@param Player EntityPlayer
function mod:OnItemPickup(Type, _,FirstTime,_,_, Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local Any = true

    if Type == CollectibleType.COLLECTIBLE_DOLLAR then
        for Index,_ in ipairs(mod.Saved.Player[PIndex].FullDeck) do
            mod.Saved.Player[PIndex].FullDeck[Index].Suit = mod.Suits.Diamond
        end

    elseif Type == CollectibleType.COLLECTIBLE_PYRO then
        for Index,_ in ipairs(mod.Saved.Player[PIndex].FullDeck) do
            mod.Saved.Player[PIndex].FullDeck[Index].Suit = mod.Suits.Club
        end

    elseif Type == CollectibleType.COLLECTIBLE_SKELETON_KEY then
        for Index,_ in ipairs(mod.Saved.Player[PIndex].FullDeck) do
            mod.Saved.Player[PIndex].FullDeck[Index].Suit = mod.Suits.Spade
        end

    elseif Type == CollectibleType.COLLECTIBLE_BODY then
        for Index,_ in ipairs(mod.Saved.Player[PIndex].FullDeck) do
            mod.Saved.Player[PIndex].FullDeck[Index].Suit = mod.Suits.Heart
        end

    elseif Type == CollectibleType.COLLECTIBLE_HEART or Type == CollectibleType.COLLECTIBLE_BINGE_EATER
        or Type == CollectibleType.COLLECTIBLE_BRIMSTONE  then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Heart
        end



    elseif Type == CollectibleType.COLLECTIBLE_QUARTER or Type == CollectibleType.COLLECTIBLE_BINGE_EATER then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Diamond
        end

    elseif Type == CollectibleType.COLLECTIBLE_BOOM or Type == CollectibleType.COLLECTIBLE_BLOOD_BOMBS
           or Type == CollectibleType.COLLECTIBLE_GLITTER_BOMBS or Type == CollectibleType.COLLECTIBLE_FAST_BOMBS
           or Type == CollectibleType.COLLECTIBLE_BOMBER_BOY or Type == CollectibleType.COLLECTIBLE_BOBBY_BOMB
           or Type == CollectibleType.COLLECTIBLE_HOT_BOMBS or Type == CollectibleType.COLLECTIBLE_SAD_BOMBS
           or Type == CollectibleType.COLLECTIBLE_BUTT_BOMBS or Type == CollectibleType.COLLECTIBLE_GHOST_BOMBS
           or Type == CollectibleType.COLLECTIBLE_NANCY_BOMBS or Type == CollectibleType.COLLECTIBLE_STICKY_BOMBS
           or Type == CollectibleType.COLLECTIBLE_SCATTER_BOMBS or Type == CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Club
        end

    elseif (Type == CollectibleType.COLLECTIBLE_SHARP_KEY and FirstTime)
            or Type == CollectibleType.COLLECTIBLE_BINGE_EATER then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Spade
        end

    else
        Any = false
    end


    if Any then
        Isaac.RunCallback("DECK_MODIFY", Player, 0)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)


---@param Tear EntityTear
function mod:SpadeOpenDoor(Tear)

    local Data = Tear:GetData()
    local Player = Tear.Parent

    if not Player then
        return
    end

    Player = Player:ToPlayer()

    if Player:GetPlayerType() ~= mod.Characters.JimboType
       or not Player:HasCollectible(CollectibleType.COLLECTIBLE_SHARP_KEY)
       or not mod:IsSuit(Player, Data.Params, mod.Suits.Spade) then
        
        return
    end

    local Grid = Game:GetRoom():GetGridEntityFromPos(Tear.Position)

    if not Grid then
        return
    end

    Grid = Grid:ToDoor()

    if Grid and (Grid:IsLocked() or Grid:CanBlowOpen()) then

---@diagnostic disable-next-line: param-type-mismatch
        Grid:TryUnlock(Player, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.SpadeOpenDoor, mod.CARD_TEAR_VARIANT)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.SpadeOpenDoor, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])



---@param Tear EntityTear
function mod:OnCardDeath(Tear)

    local Data = Tear:GetData()

    --print(Tear.HomingFriction)

    if Tear.Variant ~= mod.CARD_TEAR_VARIANT
       and not mod:Contained(mod.Tears.SUIT_TEAR_VARIANTS, Tear.Variant) then

        return
    end

    local Player = Tear.Parent:ToPlayer()

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then

        mod.TearCardEnable = false
        mod.Counters.SinceShoot = 0

        local FetusNum = mod:IsSuit(Player, Data.Params, mod.Suits.Heart) and 2 or 1
        
        for i=1, FetusNum do
            local Fetus = Player:FireTear(Tear.Position, RandomVector() * 4, false, true, false, Tear)
            Fetus:ChangeVariant(TearVariant.FETUS)
            Fetus:AddTearFlags(Tear.TearFlags | TearFlags.TEAR_FETUS) --aparently i need to give the fetus propreties
            
            Fetus.CollisionDamage = Tear.CollisionDamage / 2
        
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.OnCardDeath)



---@param Tear EntityTear
function mod:OntearFired(Tear, Split)

    local Player = Tear.Parent:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local TearData = Tear:GetData()
    
    if not TearData.Params then
        return
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
        
        local Seed = Random()
        Seed = Seed == 0 and 1 or Seed

        local Laser

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then

            --spawning a LaserVariant.BRIM_TECH or THICK_RED makes it's color transparent balck for no reson
            Laser = Game:Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, Tear.Position, Vector.Zero,
                               Tear, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, 1):ToLaser()

            Laser.Radius = 60
            Laser.Color:Reset()
            Laser:SetDamageMultiplier(2)
        else
            Laser = Game:Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, Tear.Position, Vector.Zero,
                               Tear, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, 1):ToLaser()

            Laser.Radius = 40
        end


        --local Laser = Player:FireTechXLaser(Tear.Position, Tear.Velocity, 60, Tear, 1)
        
        Laser:AddTearFlags(Tear.TearFlags)
        Laser.Parent = Tear
        Laser:SetDisableFollowParent(false)
        Laser.CollisionDamage = Tear.CollisionDamage * Laser:GetDamageMultiplier() / 2

    end

end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.OntearFired)



---@param Player EntityPlayer
function mod:EvaluateJimboStats(Type, _,FirstTime,_,_, Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Type == CollectibleType.COLLECTIBLE_BRIMSTONE then
        Player:AddCustomCacheTag(mod.CustomCache.HAND_COOLDOWN, true)
    end



end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE,CallbackPriority.LATE, mod.EvaluateJimboStats)













---@param Player EntityPlayer
function mod:EvaluatePlayCD(_,_,_,_,_,Player)

    if Player:GetPlayerType() == mod.Characters.JimboType then
        Player:AddCustomCacheTag("playcd", true)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.EvaluatePlayCD)
