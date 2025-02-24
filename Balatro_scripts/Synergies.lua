local mod = Balatro_Expansion
local Game = Game()
--code here apllies all the needed synergies to the characters

---@param Tear EntityTear
---@param Collider Entity
function mod:CardCollisionSynergy(Tear,Collider,_)
    if not mod:Contained(mod.CARD_TEAR_VARIANTS, Tear.Variant) then
        return
    end

    if Collider:IsActiveEnemy() and  mod:Contained(Collider:GetData().CollidedWith, Tear.TearIndex) then
        local TearRNG = Tear:GetDropRNG()
        local Player = Tear.Parent:ToPlayer()

        ---@diagnostic disable-next-line: need-check-nil
        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
            for i = 1, 2, 1 do
                ---@diagnostic disable-next-line: need-check-nil
                local Laser = Player:FireBrimstone(RandomVector(), Player)
                Laser.CollisionDamage = Tear.CollisionDamage
                Laser.DisableFollowParent = true
                Laser.Position = Tear.Position
            end
        end
        if Player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
            local Bomb = Player:FireBomb(Tear.Position, Vector.Zero, Tear)
            Bomb:AddTearFlags(Player:GetBombFlags())
            Bomb.SpawnerEntity = Tear
            Bomb.ExplosionDamage = Tear.CollisionDamage * 3
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.CardCollisionSynergy)
