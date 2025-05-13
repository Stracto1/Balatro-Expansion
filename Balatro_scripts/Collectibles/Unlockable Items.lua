---@diagnostic disable: undefined-field, need-check-nil, inject-field
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local HORSEY_RADIUS = 20
local HORSEY_MAX_JUMP_DELAY = 90
local HORSEY_JUMP_COOLDOWN = HORSEY_MAX_JUMP_DELAY - 35

local HorseyState = {}
HorseyState.IDLE = 1 --waiting for something to jump on or to cooldown to reache 0
HorseyState.JUMP = 2 --in mid-air
HorseyState.SLEEP = 3

local CrayonColorSubType = {}
CrayonColorSubType.RED = 1
CrayonColorSubType.CYAN = 2
CrayonColorSubType.ORANGE = 3
CrayonColorSubType.WHITE = 4
CrayonColorSubType.GREEN = 5
CrayonColorSubType.PINK = 6
CrayonColorSubType.PURPLE = 7
CrayonColorSubType.GREY = 8
CrayonColorSubType.YELLOW = 9
CrayonColorSubType.NUM_COLORS = 9


local CrayonColors = {}
CrayonColors[CrayonColorSubType.RED] = Color(1,1,1,1,0,0,0,0.95,0.3,0.3,1)
CrayonColors[CrayonColorSubType.CYAN] = Color(1,1,1,1,0,0,0,0.27,0.59,0.95,1)
CrayonColors[CrayonColorSubType.ORANGE] = Color(1,1,1,1,0,0,0,0.95,0.59,0.2,1)
CrayonColors[CrayonColorSubType.WHITE] = Color(1,1,1,1,0,0,0,1,0.95,0.95,1)
CrayonColors[CrayonColorSubType.GREEN] = Color(1,1,1,1,0,0,0,0.4,0.8,0.27,1)
CrayonColors[CrayonColorSubType.PINK] = Color(1,1,1,1,0,0,0,0.89,0.48,0.8,1)
CrayonColors[CrayonColorSubType.PURPLE] = Color(1,1,1,1,0,0,0,0.67,0.11,0.63,1)
CrayonColors[CrayonColorSubType.GREY] = Color(1,1,1,1,0,0,0,0.6,0.6,0.6,1)
CrayonColors[CrayonColorSubType.YELLOW] = Color(1,1,1,1,0,0,0,0.9,0.83,0.31,1)

local BananaState = {}
BananaState.IDLE = 1 --waiting for someone stupid enough to fall for it
BananaState.FLYING = 2 --in mid-air from initial throw
BananaState.SLIP = 3 --disappearing


---@param Familiar EntityFamiliar
---@param Force boolean --TRUE: forces to choose random direction different from the last one
local function GetHorseyGridTarget(Familiar, Force)

    local Room = Game:GetRoom()
    local RoomWidth = Room:GetGridWidth()

    local LastGrid = Familiar:GetData().LastGrid or 0
    --local LastCollum = LastGrid % RoomWidth
    --local LastRow = LastGrid//RoomWidth

    local HorseGrid = Room:GetGridIndex(Familiar.Position)
    local HorseCollum = HorseGrid % RoomWidth
    local HorseRow = HorseGrid//RoomWidth

    --print("horse:", HorseCollum, HorseRow)

    local PossibleGrids = {}

    --searches for horse movements with a stompable enemy in it
    for CollumOffset=-2, 2, 1 do

        if CollumOffset ~= 0 then
            
            local StartRowOffset = math.abs(CollumOffset) - 3 --either -2 or -1

            for RowOffset = StartRowOffset, -StartRowOffset, -2*StartRowOffset do

                local TargetRow = HorseRow+RowOffset
                local TargetCollum = HorseCollum+CollumOffset
                local TargetGrid = TargetCollum + TargetRow*RoomWidth

                local TargetGridEntity = Room:GetGridEntity(TargetGrid)

                --print(TargetGrid, TargetRow, TargetCollum)
                if not TargetGridEntity
                   or TargetGridEntity:IsBreakableRock()
                   or TargetGridEntity:GetType() == GridEntityType.GRID_NULL
                   or TargetGridEntity.CollisionClass == GridCollisionClass.COLLISION_NONE then

                    -- cannot go on unbreakable rocks

                    if Force 
                       and TargetGrid ~= LastGrid
                       --and (math.abs(TargetCollum-LastCollum) > 1 or math.abs(TargetRow-LastRow) > 1)
                       and TargetCollum ~= 1 and math.abs(TargetCollum - RoomWidth) > 2
                       and TargetRow ~= 1 and math.abs(TargetRow - Room:GetGridHeight()) > 2 then
                        --cannot go back to where it came from or on the room's borders

                        PossibleGrids[#PossibleGrids+1] = TargetGrid

                    else
                        for i, Entity in ipairs(Isaac.FindInRadius(Room:GetGridPosition(TargetGrid), HORSEY_RADIUS)) do

                            ---@diagnostic disable-next-line: cast-local-type
                            Entity = Entity:ToNPC()

                            if Entity and Entity:IsActiveEnemy() and Entity:IsVulnerableEnemy() then

                                PossibleGrids[#PossibleGrids+1] = TargetGrid
                                break
                            end
                        end
                    end
                end --GridEntity check
            end -- RowOffset for
        end

    end--CollumOffset for

    return mod:GetRandom(PossibleGrids)
end

------------FAMILIARS--------------
-----------------------------------

---@param Player EntityPlayer
function mod:GiveFamiliars(Player, _)

    local FamiliarCount = Player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.HORSEY) + Player:GetCollectibleNum(mod.Collectibles.HORSEY)

    Player:CheckFamiliar(mod.Familiars.HORSEY, FamiliarCount, RNG(math.max(Random(), 1)), ItemsConfig:GetCollectible(mod.Collectibles.HORSEY))
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveFamiliars, CacheFlag.CACHE_FAMILIARS)


---@param Familiar EntityFamiliar
function mod:FamiliarInit(Familiar)

    if Familiar.Variant == mod.Familiars.HORSEY then
        local Room = Game:GetRoom()

        
        Familiar.Position = Room:GetGridPosition(Room:GetGridIndex(Familiar.Position))

        Familiar.State = HorseyState.IDLE
        Familiar.FireCooldown = HORSEY_JUMP_COOLDOWN

    
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.FamiliarInit)


---@param Familiar EntityFamiliar
function mod:FamiliarUpdate(Familiar)

    local Room = Game:GetRoom()

    if Familiar.Variant == mod.Familiars.HORSEY then
        local HorseSprite = Familiar:GetSprite()

        if Familiar.State == HorseyState.IDLE then

            Familiar.Position = Room:GetGridPosition(Room:GetGridIndex(Familiar.Position))

            if Room:IsClear() then
                Familiar.State = HorseyState.SLEEP

                HorseSprite:Play("StartSleep")
            
            elseif Familiar.FireCooldown < HORSEY_JUMP_COOLDOWN then
                local DestinationGrid = GetHorseyGridTarget(Familiar, Familiar.FireCooldown == 0)

                if DestinationGrid then

                    Familiar:GetData().LastGrid = Room:GetGridIndex(Familiar.Position)
                    Familiar:GetData().TargetGrid = DestinationGrid

                    Familiar.State = HorseyState.JUMP
                    HorseSprite:Play("Jump")
                end
            end

        elseif Familiar.State == HorseyState.JUMP then

            if Familiar.Position.X == Room:GetGridPosition(Familiar:GetData().TargetGrid).X
               and Familiar.Position.Y == Room:GetGridPosition(Familiar:GetData().TargetGrid).Y then

                Familiar.Velocity = Vector.Zero
            end

            if HorseSprite:IsEventTriggered("Landing") then

                local Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Familiar.Position, Vector.Zero,
                                         Familiar, 0, 1):ToEffect()

                ---@diagnostic disable-next-line: need-check-nil
                Shock:SetRadii(15,30)
                --Shock.CollisionDamage = 1 or Familiar.Player.Damage*1.5 + 1 :( no work

                Shock.Parent = Familiar.Player

                SFXManager():Play(SoundEffect.SOUND_CHEST_DROP) --PLACEHOLDER

                Game:MakeShockwave(Familiar.Position, 0.015, 0.01, 5)
                --Entity:AddKnockback(EntityRef(Familiar), (Entity.Position - Familiar.Position):Normalized(), 4, false)

            elseif HorseSprite:IsEventTriggered("StartMove") then

                Familiar.Velocity = (Room:GetGridPosition(Familiar:GetData().TargetGrid) - Familiar.Position) / 5

                HorseSprite.FlipX = Familiar.Velocity.X >= 0

            elseif HorseSprite:IsFinished("Jump") then

                HorseSprite:Play("Idle")

                Familiar.State = HorseyState.IDLE
                Familiar.FireCooldown = HORSEY_MAX_JUMP_DELAY
            end

        elseif Familiar.State == HorseyState.SLEEP then

            if not Room:IsClear() then

                Familiar.State = HorseyState.IDLE
                Familiar.FireCooldown = HORSEY_JUMP_COOLDOWN

                HorseSprite:Play("Idle")

            elseif HorseSprite:IsFinished("StartSleep") then
                HorseSprite:Play("Sleep")
            end
        end

        Familiar.FireCooldown = math.max(Familiar.FireCooldown - 1, 0)

    
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.FamiliarUpdate)


---@param Familiar EntityFamiliar
---@param Collider Entity
function mod:FamiliarCollision(Familiar, Collider,_)

    if Familiar.Variant == mod.Familiars.BANANA_PEEL then

        
        
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, mod.FamiliarCollision)


--------------EFFECTS--------------
----------------------------------

---@param Effect EntityEffect
function mod:EffectInit(Effect)


    if Effect.Variant == mod.Effects.CRAYON_POWDER then
        local Sprite = Effect:GetSprite()

        Sprite:SetFrame(math.random(0, Sprite:GetAnimationData("Idle"):GetLength()))

        Effect:SetColor(CrayonColors[Effect.SubType], -1, 2, false, true)
        
        Effect.SpriteRotation = Effect.SpawnerEntity.Velocity:GetAngleDegrees()

        Effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
        Effect:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
        
    elseif Effect.Variant == mod.Effects.BANANA_PEEL then

        local Data = Effect:GetData()

        Effect.State = BananaState.FLYING

        Data.ZSpeed = -math.random()*10 - 6
        Data.ZAcceleration = 1 or math.random()*1.5 + 1    
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectInit)


---@param Effect EntityEffect
function mod:EffectUpdate(Effect)

    if Effect.Variant == mod.Effects.CRAYON_POWDER then
        if Effect.Timeout <= 0 then
            Effect.SpriteScale = Vector(Effect.SpriteScale.X - 0.05, Effect.SpriteScale.Y - 0.05)
            Effect.Color.A = Effect.Color.A - 0.05

            if Effect.SpriteScale.X < 0.1 then
                Effect:Remove()
            end
            return
        end

        if Effect.FrameCount % 6 ~= 0 then
            return
        end

        local PowderRef = EntityRef(Effect)
        local Player = Effect.SpawnerEntity:ToPlayer()
        local Damage = Player and Player.Damage/2 or 1

        for _,Entity in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule())) do

            ---@diagnostic disable-next-line: cast-local-type
            Entity = Entity:ToNPC()

            if Entity and Entity:IsActiveEnemy() and not Entity:IsFlying() then

                if Effect.SubType == CrayonColorSubType.RED then

                    Entity:AddBaited(PowderRef, 20)
                    Entity:SetBaitedCountdown(20)

                elseif Effect.SubType == CrayonColorSubType.ORANGE then

                    Entity:AddBurn(PowderRef, 23, Damage)
                    Entity:SetBurnCountdown(23)


                elseif Effect.SubType == CrayonColorSubType.CYAN then
                
                    Entity:AddIce(PowderRef, 20)

                    Entity:AddSlowing(PowderRef, 20, 0.85, Color(1.5,1.5,1.5,1)) --PLACEHOLDER COLOR
                    Entity:SetSlowingCountdown(20)

                elseif Effect.SubType == CrayonColorSubType.GREEN then

                    Entity:AddPoison(PowderRef, 23, Damage)
                    Entity:SetPoisonCountdown(23)


                elseif Effect.SubType == CrayonColorSubType.WHITE then

                    Entity:AddSlowing(PowderRef, 30, 0.7, Color(1.5,1.5,1.5,1)) --PLACEHOLDER COLOR
                    Entity:SetSlowingCountdown(30)


                elseif Effect.SubType == CrayonColorSubType.PINK then

                    Entity:AddCharmed(PowderRef, 30)
                    Entity:SetCharmedCountdown(30)

                elseif Effect.SubType == CrayonColorSubType.PURPLE then

                    Entity:AddFear(PowderRef, 20)
                    Entity:SetFearCountdown(20)

                elseif Effect.SubType == CrayonColorSubType.GREY then

                    Entity:AddMagnetized(PowderRef, 15)
                    Entity:SetMagnetizedCountdown(15)

                elseif Effect.SubType == CrayonColorSubType.YELLOW then

                    local Laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC, Entity.Position, math.random(-180, 180), 2, Vector.Zero, Effect)
                    Laser.MaxDistance = math.random()*45 + 40
                    Laser.CollisionDamage = Damage
                end
            end
        end

    elseif Effect.Variant == mod.Effects.BANANA_PEEL then

        if RoomTransition:GetTransitionMode() ~= 0 then
            Effect:Remove()
            return
        end


        if Effect.State == BananaState.FLYING then

            Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

            local Data = Effect:GetData()
            
            Effect.SpriteOffset.Y = math.min(Effect.SpriteOffset.Y + Data.ZSpeed,0)
            Data.ZSpeed = Data.ZSpeed + Data.ZAcceleration

            if Effect.SpriteOffset.Y == 0 then
                Effect.State = BananaState.IDLE
                sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS)

                Effect:AddVelocity(-Effect.Velocity)
                Effect:GetSprite():Play("land")
            end
        elseif Effect.State == BananaState.SLIP then

            Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

            if Effect:GetSprite():IsFinished("disappear") then
                Effect:Remove()
            end

        elseif Effect.State == BananaState.IDLE then

            Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
            Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND


            for i,Collider in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule(), EntityPartition.ENEMY)) do
                ---@diagnostic disable-next-line: cast-local-type
                Collider = Collider:ToNPC()

                local ColliderSpeed = Collider.Velocity:Length()
                local Data = Collider:GetData()
            
                if Collider and Collider:IsActiveEnemy() and ColliderSpeed >= 0.25
                    and not Data.HasBananaSlipped then
                    
                    sfx:Play(mod.Sounds.SLIP)
                    Effect.State = BananaState.SLIP
                    Effect:AddVelocity(Collider.Velocity * 3)
                    Effect:GetSprite():Play("disappear")

                    Collider:AddConfusion(EntityRef(Effect), 90, false)
                    Data.HasBananaSlipped = EntityRef(Effect)
                    Data.BananaSlipSpeed = -2*ColliderSpeed
                    Data.BananaSlipAcceleration = ColliderSpeed / 9

                    break
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.EffectUpdate)


---------GENERAL ENTITIES----------
-----------------------------------


---@param Entity Entity
function mod:EntityInit(Entity)

end
--mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.EntityInit, mod.Entities.BALATRO_TYPE)


---@param Entity Entity
function mod:EntityUpdate(Entity)

    
end
--mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.EntityUpdate, mod.Entities.BALATRO_TYPE)


---@param Entity Entity
function mod:EntityCollision(Entity, Collider,_)


end
--mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.EntityCollision, mod.Entities.BALATRO_TYPE)



----------ITEM EFFECTS---------
-------------------------------

---@param Player EntityPlayer
function mod:SpawnCrayonCreep(Player)

    if Player:HasCollectible(mod.Collectibles.CRAYONS) then
        
        if Player.Velocity:Length() > 0.25 and Player.FrameCount % math.floor(3/Player.MoveSpeed) == 0 then
 
            local Powder = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.CRAYON_POWDER,
                                      Player.Position, Vector.Zero, Player, Player:GetData().CrayonColor or 1, 1):ToEffect()

            Powder:SetTimeout(100)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.SpawnCrayonCreep, PlayerVariant.PLAYER)


function mod:ChooseRoomCrayonColor()

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:HasCollectible(mod.Collectibles.CRAYONS) then
            
            local RandomColor
            local Data = Player:GetData()
            repeat
                RandomColor = math.random(CrayonColorSubType.NUM_COLORS)

            until not Data.CrayonColor or RandomColor ~= Data.CrayonColor

            Player:GetData().CrayonColor = RandomColor
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ChooseRoomCrayonColor)


function mod:ChooseRoomCrayonColor2(Type,_,_,_,_, Player)
    if Type == mod.Collectibles.CRAYONS then

        local RandomColor
        local Data = Player:GetData()
        repeat
            RandomColor = math.random(CrayonColorSubType.NUM_COLORS)

        until not Data.CrayonColor or RandomColor ~= Data.CrayonColor

        Player:GetData().CrayonColor = RandomColor
        return
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.ChooseRoomCrayonColor2)


---@param Player EntityPlayer
---@param Rng RNG
function mod:ActiveUse(Item, Rng, Player, Flag, Slot, Data)

    local ReturnTable = {Discharge = false,
                         Remove = false,
                         ShowAnim = false}
                         
    if Item == mod.Collectibles.BANANA then

        if Player:GetItemState() == mod.Collectibles.BANANA then

            Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)
            Player:AnimateCollectible(mod.Collectibles.BANANA, "HideItem")
        else

            Player:SetItemState(mod.Collectibles.BANANA)
            Player:AnimateCollectible(mod.Collectibles.BANANA, "LiftItem")
        end
        return ReturnTable

    elseif Item == mod.Collectibles.EMPTY_BANANA then

        local BananaSpeed = RandomVector()*(math.random() + 2)

        local Banan = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BANANA_PEEL, Player.Position,
                   BananaSpeed + Player:GetTearMovementInheritance(BananaSpeed), Player, 0, math.max(Random(), 1))
        sfx:Play(SoundEffect.SOUND_SUMMON_POOF)

        Banan:GetSprite():Play("throw")

    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ActiveUse)


---@param Player EntityPlayer
function mod:PlayerUpdate(Player)

    local ShootDirection = Player:GetShootingInput()

    if Player:GetItemState() == mod.Collectibles.BANANA
       and ShootDirection:Length() > 0 then

        
        Player:AnimateCollectible(mod.Collectibles.BANANA, "HideItem")
        Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)

        Player:AddCollectible(mod.Collectibles.EMPTY_BANANA, 0, true, Player:GetActiveItemSlot(mod.Collectibles.BANANA))
        Player:DischargeActiveItem()
        
        local Tear = Player:FireTear(Player.Position, ShootDirection*Player.ShotSpeed*3.3, false, false, false, Player, 1)
        
        sfx:Play(SoundEffect.SOUND_PLOP)
        Tear:ChangeVariant(mod.Tears.BANANA_VARIANT)
        Tear.CollisionDamage = 0
        Tear.FallingAcceleration = 0


    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.PlayerUpdate)


---@param Tear EntityTear
function mod:BananaInfiniteRange(Tear)

    if Tear.Variant == mod.Tears.BANANA_VARIANT then
        Tear.FallingSpeed = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.BananaInfiniteRange)


---@param Tear EntityTear
function mod:BananaExplosion(Tear)

    if Tear.Variant == mod.Tears.BANANA_VARIANT then
        
        Game:GetRoom():MamaMegaExplosion(Tear.Position)

        Isaac.CreateTimer(function ()
            for _, Cloud in ipairs(Isaac.FindByType(1000, EffectVariant.DUST_CLOUD)) do

                Cloud:SetColor(CrayonColors[CrayonColorSubType.YELLOW], -1, 1, true, true)
            end
        end,5,1, false)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.BananaExplosion)


function mod:ResetBananaCharge()

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        for Slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do    
            local Item = Player:GetActiveItem(Slot)

            if Item and Item == mod.Collectibles.EMPTY_BANANA then
                
                Player:AnimateCollectible(mod.Collectibles.BANANA, "UseItem")
                Player:AddCollectible(mod.Collectibles.BANANA, 1, true, Slot)
                sfx:Play(SoundEffect.SOUND_BEEP)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetBananaCharge)


---@param Entity Entity
function mod:EntityBananaSlip(Entity)

    local Data = Entity:GetData()

    if not Data.HasBananaSlipped then
        return
    end

    Entity.SpriteRotation = Entity.SpriteRotation + 30
    Entity.SpriteOffset.Y = Entity.SpriteOffset.Y + Data.BananaSlipSpeed
    Data.BananaSlipSpeed = Data.BananaSlipSpeed + Data.BananaSlipAcceleration

    if Entity.SpriteOffset.Y >= 0 then
        
        Entity.SpriteRotation = 0
        Entity.SpriteOffset.Y = 0

        Entity:TakeDamage(2.5*Data.BananaSlipSpeed, DamageFlag.DAMAGE_CRUSH, Data.HasBananaSlipped, 1)

        if Entity:HasMortalDamage() then
            Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
        end

        Data.BananaSlipSpeed = nil
        Data.HasBananaSlipped = nil
        Data.BananaSlipAcceleration = nil
    end
    
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.EntityBananaSlip)

