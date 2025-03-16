---@diagnostic disable: need-check-nil
local mod = Balatro_Expansion
local Game = Game()
--code here apllies all the needed synergies to the characters

---@param Tear EntityTear
---@param Collider Entity
function mod:CardCollisionSynergy(Tear,Collider,_)

    local TearData = Tear:GetData()
    TearData.CollidedWith = TearData.CollidedWith or {}

    if not Collider:IsActiveEnemy() or mod:Contained(TearData.CollidedWith, GetPtrHash(Collider)) then
        return
    end

    local TearRNG = Tear:GetDropRNG()
    local Player = Tear.Parent:ToPlayer()


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        local Amount = mod:IsSuit(Player, TearData.Params.Suit, TearData.Params.Enhancement, mod.Suits.Heart, false) and 2 or 1

        for i = 1, Amount, 1 do

            local Laser = Player:FireBrimstone(RandomVector(), Player)

            Laser:SetKnockbackDirection(Vector.Zero)
            Laser.CollisionDamage = Tear.CollisionDamage
            Laser.DisableFollowParent = true
            Laser.Position = Collider.Position

            Laser.TearFlags = Laser.TearFlags & ~TearFlags.TEAR_EXPLOSIVE --would be suicide otehrwise

        end
    end
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then

        local Bomb = Player:FireBomb(Tear.Position, Vector.Zero, Tear)

        Bomb:AddTearFlags(Player:GetBombFlags() & ~TearFlags.TEAR_SAD_BOMB)

        Bomb.SpawnerEntity = Tear

        if mod:IsSuit(Player, TearData.Params.Suit, TearData.Params.Enhancement, mod.Suits.Club, false) then
            
            Bomb.ExplosionDamage = Tear.CollisionDamage * 4
            Bomb.RadiusMultiplier = 1.25
        else

            Bomb.ExplosionDamage = Tear.CollisionDamage * 2.5
        end

    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.CARD_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.CARD_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.CARD_TEAR_VARIANTS[mod.Suits.Club])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.CARD_TEAR_VARIANTS[mod.Suits.Diamond])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.SUIT_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.SUIT_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.SUIT_TEAR_VARIANTS[mod.Suits.Club])
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION,CallbackPriority.EARLY, mod.CardCollisionSynergy, mod.SUIT_TEAR_VARIANTS[mod.Suits.Diamond])







---@param Player EntityPlayer
function mod:EvaluatePlayCD(_,_,_,_,_,Player)

    if Player:GetPlayerType() == mod.Characters.JimboType then
        Player:AddCustomCacheTag("playcd", true)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.EvaluatePlayCD)
