---@diagnostic disable: undefined-field, need-check-nil, inject-field, cast-local-type
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

local ColorSubType = {} --used to randomize familiar/effect colors
ColorSubType.RED = 1
ColorSubType.CYAN = 2
ColorSubType.ORANGE = 3
ColorSubType.WHITE = 4
ColorSubType.GREEN = 5
ColorSubType.PINK = 6
ColorSubType.PURPLE = 7
ColorSubType.GREY = 8
ColorSubType.YELLOW = 9
ColorSubType.NUM_COLORS = 9


local CrayonColors = {}
CrayonColors[ColorSubType.RED] = Color(1,1,1,1,0,0,0,0.95,0.3,0.3,1)
CrayonColors[ColorSubType.CYAN] = Color(1,1,1,1,0,0,0,0.27,0.59,0.95,1)
CrayonColors[ColorSubType.ORANGE] = Color(1,1,1,1,0,0,0,0.95,0.59,0.2,1)
CrayonColors[ColorSubType.WHITE] = Color(1,1,1,1,0,0,0,1,0.95,0.95,1)
CrayonColors[ColorSubType.GREEN] = Color(1,1,1,1,0,0,0,0.4,0.8,0.27,1)
CrayonColors[ColorSubType.PINK] = Color(1,1,1,1,0,0,0,0.89,0.48,0.8,1)
CrayonColors[ColorSubType.PURPLE] = Color(1,1,1,1,0,0,0,0.67,0.11,0.63,1)
CrayonColors[ColorSubType.GREY] = Color(1,1,1,1,0,0,0,0.6,0.6,0.6,1)
CrayonColors[ColorSubType.YELLOW] = Color(1,1,1,1,0,0,0,0.9,0.83,0.31,1)

local BananaState = {}
BananaState.IDLE = 1 --waiting for someone stupid enough to fall for it
BananaState.FLYING = 2 --in mid-air from initial throw
BananaState.SLIP = 3 --disappearing

local PUPPY_RESPAWN_TIMER = 270
local PuppyState = {}
PuppyState.IDLE = 1 --chilling with isaac while still attached
PuppyState.ATTACK = 2 --disappearing
PuppyState.EXPLODED = 3 --disappearing

local PuppyColorsSuffix = {}
PuppyColorsSuffix[ColorSubType.RED] = "_red"
PuppyColorsSuffix[ColorSubType.CYAN] = "_cyan"
PuppyColorsSuffix[ColorSubType.ORANGE] = "_orange"
PuppyColorsSuffix[ColorSubType.WHITE] = "_white"
PuppyColorsSuffix[ColorSubType.GREEN] = "_green"
PuppyColorsSuffix[ColorSubType.PINK] = "_pink"
PuppyColorsSuffix[ColorSubType.PURPLE] = "_red"
PuppyColorsSuffix[ColorSubType.GREY] = "_grey"
PuppyColorsSuffix[ColorSubType.YELLOW] = "_yellow"

local LaughEffectType = {}
LaughEffectType.GOOD = 0
LaughEffectType.BAD = 1
LaughEffectType.GASP = 2
LaughEffectType.LAUGH = 3
LaughEffectType.RANDOM = 4
LaughEffectType.TRANSITION = 5


local TomatoAnimations = {}
TomatoAnimations.IDLE = {"Idle1","Idle2"}
TomatoAnimations.SPLAT = {"Splat1","Splat2"}
TomatoAnimations.DISAPPEAR = {"Disappear1","Disappear2"}
TomatoAnimations.NUM_VARIANTS = 2

local TomatoState = {}
TomatoState.THROW = 0
TomatoState.SPLAT = 3
TomatoState.DISAPPEAR = 6

BASE_CARD_ANIMATION = "Base"
local SUIT_ANIMATIONS = {"Spade","Heart","Club","Diamond"}


local ComedicState = {}
ComedicState.NONE = 0
ComedicState.COMEDY = 1
ComedicState.TRAGEDY = 2
ComedicState.TRAGICOMEDY = 3

local MaskCostume = {}
MaskCostume[ComedicState.NONE] = 0
MaskCostume[ComedicState.COMEDY] = Isaac.GetCostumeIdByPath("gfx/characters/comedy_mask_costume.anm2")
MaskCostume[ComedicState.TRAGEDY] = Isaac.GetCostumeIdByPath("gfx/characters/tragic_mask_costume.anm2")
MaskCostume[ComedicState.TRAGICOMEDY] = Isaac.GetCostumeIdByPath("gfx/characters/tragicomedy_mask_costume.anm2")

local TragicomedyCaches = CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_SPEED 


local AnvilStates = {}
AnvilStates.FALLING = 0
AnvilStates.REFLECTED = 30

local ANVIL_FOLLOW_TIME = 35
local ANVIL_START_HEIGHT = -1200
local UMBRELLA_HEIGHT = -31

local MAX_LOLLYPOP_COOLDOWN = 600
local LollypopPicker = WeightedOutcomePicker()
LollypopPicker:AddOutcomeFloat(1, 1)
LollypopPicker:AddOutcomeFloat(2, 1)
LollypopPicker:AddOutcomeFloat(3, 0.01)

local CandySheets = {}
CandySheets[SlotVariant.BEGGAR] = "gfx/sprites/slot_004_beggar.png"
CandySheets[SlotVariant.DEVIL_BEGGAR] = "gfx/sprites/slot_005_devil_beggar.png"
CandySheets[SlotVariant.KEY_MASTER] = "gfx/sprites/slot_007_key_master.png"
CandySheets[SlotVariant.BOMB_BUM] = "gfx/sprites/slot_009_bomb_bum.png"
CandySheets[SlotVariant.BATTERY_BUM] = "gfx/sprites/slot_013_battery_bum.png"


local function UnlockItems(_,Type)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        
        local GameData = Isaac.GetPersistentGameData()

        if Type == CompletionType.MOMS_HEART then
            GameData:TryUnlock(mod.Achievements.Trinkets[mod.Jokers.JOKER])

        elseif Type == CompletionType.ISAAC then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.HORSEY])

        elseif Type == CompletionType.BLUE_BABY then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.CRAYONS])

        elseif Type == CompletionType.SATAN then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.BALOON_PUPPY])

        elseif Type == CompletionType.LAMB then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.FUNNY_TEETH])

        elseif Type == CompletionType.BOSS_RUSH then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.LOLLYPOP])

        elseif Type == CompletionType.HUSH then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.LAUGH_SIGN])

        elseif Type == CompletionType.MEGA_SATAN then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.UMBRELLA])

        elseif Type == CompletionType.MOTHER then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.TRAGICOMEDY])

        elseif Type == CompletionType.BEAST then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.BANANA])

        elseif Type == CompletionType.DELIRIUM then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.POCKET_ACES])

        elseif Type == CompletionType.ULTRA_GREED then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.CLOWN])
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, UnlockItems)



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
                       and TargetCollum ~= 1 and math.abs(TargetCollum - RoomWidth) > 2 --can't go on the room's borders
                       and TargetRow ~= 1 and math.abs(TargetRow - Room:GetGridHeight()) > 2 then
                        --cannot go back to where it came from 

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

    FamiliarCount = Player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.BALOON_PUPPY) + Player:GetCollectibleNum(mod.Collectibles.BALOON_PUPPY)
    Player:CheckFamiliar(mod.Familiars.BLOON_PUPPY, FamiliarCount, RNG(math.max(Random(), 1)), ItemsConfig:GetCollectible(mod.Collectibles.BALOON_PUPPY))
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveFamiliars, CacheFlag.CACHE_FAMILIARS)


---@param Familiar EntityFamiliar
function mod:FamiliarInit(Familiar)

    if Familiar.Variant == mod.Familiars.HORSEY then
        local Room = Game:GetRoom()

        Familiar.Position = Room:GetGridPosition(Room:GetGridIndex(Familiar.Position))

        Familiar.State = HorseyState.IDLE
        Familiar.FireCooldown = HORSEY_JUMP_COOLDOWN

    elseif Familiar.Variant == mod.Familiars.BLOON_PUPPY then

        Familiar.DepthOffset = Familiar.DepthOffset + 1000
        Familiar.Position = Familiar.Player.Position

        Familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        Familiar.State = PuppyState.IDLE
        Familiar.FireCooldown = 0
        Familiar.MaxHitPoints = 16 * Familiar:GetMultiplier()

        Familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_Baloon_Puppy"..PuppyColorsSuffix[math.random(ColorSubType.NUM_COLORS)]..".png", true)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.FamiliarInit)


---@param Familiar EntityFamiliar
function mod:FamiliarUpdate(Familiar)

    if Familiar.Variant == mod.Familiars.HORSEY then
        local Room = Game:GetRoom()
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

    elseif Familiar.Variant == mod.Familiars.BLOON_PUPPY then


        Familiar.FlipX = Familiar.Velocity.X < 0

        local Grid = Game:GetRoom():GetGridEntityFromPos(Familiar.Position)

        if Familiar.State ~= PuppyState.EXPLODED
           and Grid and Grid:GetType() == GridEntityType.GRID_ROCK_SPIKED
           and Grid.State ~= 4 and Grid.State ~= 2 then --4 means a flat file-like effect is active | 2 means it's destroyed

            Familiar.State = PuppyState.EXPLODED
            Familiar:GetSprite():Play("Explode")
            Familiar.FireCooldown = PUPPY_RESPAWN_TIMER
            sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2,false,1.2)

        end

        if Familiar.State == PuppyState.IDLE then
            
            local PlayerDistance = Familiar.Position + Familiar.SpriteOffset - Familiar.Player.Position
            local DistanceLength = PlayerDistance:Length()
            local DistanceAngle = PlayerDistance:GetAngleDegrees()

            if DistanceLength > 90 then --reached maximum string length
                
                Familiar.Velocity = Familiar.Velocity*0.98 --gradually slows down

                Familiar:AddVelocity(PlayerDistance/-100 * (1+((DistanceLength-90)/50)))
                
                --Familiar.Position = Familiar.Position - PlayerDistance/(DistanceLength/4)

            elseif DistanceLength > 80 and DistanceAngle > -120 and DistanceAngle < -60 then --almost maximum length but not quite

                Familiar.Velocity = Familiar.Velocity*0.95 --gradually slows down

            else --string is loose
                Familiar.Velocity = Familiar.Velocity*0.95
                Familiar:AddVelocity(Vector(0,-0.15))

            end

        elseif Familiar.State == PuppyState.ATTACK then

            Familiar:PickEnemyTarget(350, 13, 9) --switch target + prioritize low hp

            local TargetDistance = (Familiar.Target and Familiar.Target.Position or Familiar.Player.Position) - Familiar.Position
            local Speed = Familiar.Target and 3.75 or 1.75
            local MinDistance = Familiar.Target and 10 or 25


            if TargetDistance:Length() >= MinDistance then

                Familiar.Velocity = TargetDistance:Resized(Speed)
                --Familiar:GetPathFinder():FindGridPath(Familiar.Player.Position, 0.5, 0, true)
            end

            Familiar.FireCooldown = Familiar.FireCooldown + 1

        elseif Familiar.State == PuppyState.EXPLODED then

            Familiar.FireCooldown = Familiar.FireCooldown - 1
            if Familiar.FireCooldown == 0 then

                Familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_Baloon_Puppy"..PuppyColorsSuffix[math.random(ColorSubType.NUM_COLORS)]..".png", true)

                Familiar.Position = Familiar.Player.Position
                Familiar:GetSprite():Play("Idle")

                Familiar.HitPoints = Familiar.MaxHitPoints
                Familiar.State = PuppyState.IDLE
                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, Familiar.Position, Vector.Zero, Familiar, 0, 1)
            end
        end 
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.FamiliarUpdate)


---@param Familiar EntityFamiliar
function mod:FamiliarRender(Familiar)

    if Familiar.Variant == mod.Familiars.BLOON_PUPPY then

        if Familiar.State == PuppyState.IDLE or Familiar.State == PuppyState.ATTACK then
            
            local PlayerDistance = Familiar.Position + Familiar.SpriteOffset - Familiar.Player.Position
            local DistanceLength = PlayerDistance:Length()

            local NumPoints = (DistanceLength // 50)+2
            local FamiliarScreenPos = Isaac.WorldToScreen(Familiar.Position)
            local PlayerScreenPos = mod:CoolVectorLerp(Isaac.WorldToScreen(Familiar.Player.Position), FamiliarScreenPos, Familiar.FireCooldown/35)

            local LastPoint = PlayerScreenPos
            local CurveExp = mod:CoolLerp(math.min(DistanceLength/100, 1.1), 1, Familiar.FireCooldown/20)

            if PlayerDistance.Y < 0 then
                
                for i=0, 1, 1/NumPoints do

                    local MidPoint = Vector.Zero

                    MidPoint.X = mod:ExponentLerp(PlayerScreenPos.X, FamiliarScreenPos.X, i, CurveExp)
                    MidPoint.Y = mod:ExponentLerp(PlayerScreenPos.Y, FamiliarScreenPos.Y, i, 1/CurveExp)

                    Isaac.DrawLine(LastPoint,MidPoint,KColor.Black, KColor.Black, 1)

                    LastPoint = MidPoint + Vector.Zero
                end
            else
                for i=0, 1, 1/NumPoints do

                    local MidPoint = Vector.Zero

                    MidPoint.Y = mod:ExponentLerp(PlayerScreenPos.Y, FamiliarScreenPos.Y, i, CurveExp)
                    MidPoint.X = mod:ExponentLerp(PlayerScreenPos.X, FamiliarScreenPos.X, i, 1/CurveExp)

                    Isaac.DrawLine(LastPoint,MidPoint,KColor.Black, KColor.Black, 1)

                    LastPoint = MidPoint + Vector.Zero
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, mod.FamiliarRender)



---@param Familiar EntityFamiliar
---@param Collider Entity
function mod:FamiliarCollision(Familiar, Collider,_)

    if Familiar.Variant == mod.Familiars.BLOON_PUPPY then

        if Familiar.State == PuppyState.EXPLODED then
            return
        end

        local Bullet = Collider:ToProjectile()
        local NPC = Collider:ToNPC()

        if Bullet and not Bullet:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
            
            Familiar:TakeDamage(1, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(Bullet), 7)
            
            if Familiar.HitPoints == 2 then --one hit away from death (take damage takes place next frame)
                
                sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2,false,1.2)
                Familiar.State = PuppyState.EXPLODED
                Familiar:GetSprite():Play("Explode")
                Familiar.FireCooldown = PUPPY_RESPAWN_TIMER

                for _, Entity in ipairs(Isaac.FindInRadius(Familiar.Position,30,EntityPartition.ENEMY|EntityPartition.BULLET)) do

                    local NPC = Entity:ToNPC()
                    local Bullet = Entity:ToProjectile()
                    if NPC then
                        NPC:TakeDamage((Familiar.Player.Damage * 3 + 2)*Familiar:GetMultiplier(), DamageFlag.DAMAGE_EXPLOSION, EntityRef(Familiar), 2)
                        NPC:AddKnockback(EntityRef(Familiar), (NPC.Position - Familiar.Position):Resized(8), 30, true)

                    elseif Bullet then

                        Bullet.Velocity = -1.5*Bullet.Velocity
                        Bullet:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES|ProjectileFlags.CANT_HIT_PLAYER)
                        Bullet.Damage = Bullet.Damage*2*Familiar:GetMultiplier()
                    end
                end
            else
                --no idea tf the editor is doing
---@diagnostic disable-next-line: param-type-mismatch
                Familiar:AddVelocity(Collider.Velocity/3) 
            end

            Bullet.Velocity = -Bullet.Velocity
            Bullet:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES|ProjectileFlags.CANT_HIT_PLAYER)
            Bullet.Damage = Bullet.Damage*Familiar:GetMultiplier()
            sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE, 0.9)

        elseif NPC then

            if NPC.Type == EntityType.ENTITY_SPIKEBALL
               or NPC.Type == EntityType.ENTITY_BALL_AND_CHAIN then
                
                Familiar.State = PuppyState.EXPLODED
                Familiar:GetSprite():Play("Explode")
                Familiar.FireCooldown = PUPPY_RESPAWN_TIMER
                sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2,false,1.2)
            
            elseif Familiar.State == PuppyState.ATTACK then
                if NPC and NPC:IsActiveEnemy() and NPC:IsVulnerableEnemy() then

                    NPC:TakeDamage(Familiar:GetMultiplier(), DamageFlag.DAMAGE_COUNTDOWN, EntityRef(Familiar), 5)
                    Familiar:CanBlockProjectiles()
                end
            end
        end
        
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

    elseif Effect.Variant == mod.Effects.ANVIL then
        --Effect.PositionOffset = Vector(0, -1750)

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

                if Effect.SubType == ColorSubType.RED then

                    Entity:AddBaited(PowderRef, 20)
                    Entity:SetBaitedCountdown(20)

                elseif Effect.SubType == ColorSubType.ORANGE then

                    Entity:AddBurn(PowderRef, 23, Damage)
                    Entity:SetBurnCountdown(23)


                elseif Effect.SubType == ColorSubType.CYAN then
                
                    Entity:AddIce(PowderRef, 20)

                    Entity:AddSlowing(PowderRef, 20, 0.85, Color(1.5,1.5,1.5,1)) --PLACEHOLDER COLOR
                    Entity:SetSlowingCountdown(20)

                elseif Effect.SubType == ColorSubType.GREEN then

                    Entity:AddPoison(PowderRef, 23, Damage)
                    Entity:SetPoisonCountdown(23)


                elseif Effect.SubType == ColorSubType.WHITE then

                    Entity:AddSlowing(PowderRef, 30, 0.7, Color(1.5,1.5,1.5,1)) --PLACEHOLDER COLOR
                    Entity:SetSlowingCountdown(30)


                elseif Effect.SubType == ColorSubType.PINK then

                    Entity:AddCharmed(PowderRef, 30)
                    Entity:SetCharmedCountdown(30)

                elseif Effect.SubType == ColorSubType.PURPLE then

                    Entity:AddFear(PowderRef, 20)
                    Entity:SetFearCountdown(20)

                elseif Effect.SubType == ColorSubType.GREY then

                    Entity:AddMagnetized(PowderRef, 15)
                    Entity:SetMagnetizedCountdown(15)

                elseif Effect.SubType == ColorSubType.YELLOW then

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

                Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
                Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
        elseif Effect.State == BananaState.SLIP then

            Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

            if Effect:GetSprite():IsFinished("disappear") then
                Effect:Remove()
            end

        elseif Effect.State == BananaState.IDLE then

            for i,Collider in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule(), EntityPartition.ENEMY)) do
                ---@diagnostic disable-next-line: cast-local-type
                Collider = Collider:ToNPC()

                local ColliderSpeed = Collider.Velocity:Length()
                local Data = Collider:GetData()
            
                if Collider and Collider:IsActiveEnemy() and ColliderSpeed >= 0.25
                    and not Data.HasBananaSlipped then
                    
                    sfx:Play(mod.Sounds.SLIP, 0.55)
                    Effect.State = BananaState.SLIP
                    Effect:AddVelocity(Collider.Velocity * 3)
                    Effect:GetSprite():Play("disappear")

                    Collider:AddConfusion(EntityRef(Effect), 90, false)
                    Data.HasBananaSlipped = EntityRef(Effect)
                    Data.BananaSlipSpeed = -2*ColliderSpeed
                    Data.BananaSlipAcceleration = ColliderSpeed / 9

                    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) then
                        mod:LaughSignEffect(LaughEffectType.LAUGH)
                    end

                    break
                end
            end
        end

    elseif Effect.Variant == mod.Effects.ANVIL then

        local Data = Effect:GetData()

        Effect.SpriteOffset.Y = Effect.SpriteOffset.Y + Data.FallingSpeed
        Data.FallingSpeed = Data.FallingSpeed + Data.FallingAcceleration


        --for whaterver reason shadows can be rendered only if an effect has 2 or more as the timeout??
        --alr also works if it's less than 0 but still wtf
        Effect:SetTimeout(math.max(Effect.Timeout, 2))

        if Effect.State == AnvilStates.FALLING then
            
            if Effect.Timeout <= 2 then
                Effect.IsFollowing = false
                Effect.Velocity = Vector.Zero
            else
                Effect.IsFollowing = true
            end

            for _,Umbrella in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule(), EntityPartition.EFFECT)) do
                
                if Umbrella.Variant == mod.Effects.UMBRELLA
                   and Effect.SpriteOffset.Y > UMBRELLA_HEIGHT * Umbrella.SpriteScale.Y then

                    Umbrella:GetSprite():Play("Bounce", true)
                    sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE)


                    local Enemies = Isaac.FindInRadius(Effect.Position, 240, EntityPartition.ENEMY)

                    Data.FallingSpeed = -6 - math.random()*4
                    Data.FallingAcceleration = 0.75 + math.random()*0.5

                    if next(Enemies) then
                        local Target = mod:GetRandom(Enemies)

                        local FlightTime = ((Data.FallingSpeed^2 + 2*Data.FallingAcceleration*Effect.SpriteOffset.Y)^0.5 - Data.FallingSpeed)*2/Data.FallingAcceleration


                        Effect.Velocity = (Target.Position + Target.Velocity - Effect.Position)/FlightTime

                    else
                        Effect.Velocity = RandomVector() * (math.random()*5 + 2)
                    end

                    Effect.State = AnvilStates.REFLECTED
                    return
                end
            end

            if Effect.SpriteOffset.Y < 0 then
                return
            end
            
            local Room = Game:GetRoom()
            local AnvilGridIndex = Room:GetGridIndex(Effect.Position)

            local Grid = Room:GetGridEntityFromPos(Effect.Position)
            local FellOnWater = Room:GetWaterAmount() >= 0.2
            local FellInPit = Grid and Grid:ToPit()


            Game:MakeShockwave(Effect.Position, 0.025, 0.02, 10)

            if not FellInPit then --fell on ground/rock

                if Grid then

                    Grid:Destroy(true)
                    Room:RemoveGridEntityImmediate(AnvilGridIndex, 1, false)
                end

                if mod:CanTileBeBlocked(AnvilGridIndex) then
                    local Pit = Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, Effect.Position)

                    if Pit then
                        Pit = Pit:ToPit()

                        Pit:UpdateCollision()
                    end
                end
                

                local Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Effect.Position,
                                         Vector.Zero, nil, 0, 1):ToEffect()

                Shock:SetRadii(10,25)


                Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Effect.Position,
                                   Vector.Zero, nil, 0, 1):ToEffect()

                Shock:SetRadii(35,75)
                --Shock.Parent = Effect.SpawnerEntity
            end

            if FellOnWater then

                Effect:SpawnWaterImpactEffects(Effect.Position, Vector.One, 100)

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, Effect.Position,
                           Vector.Zero, nil, 0, 1)
                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1,2,false, 0.9 + math.random()*0.1)

                for i=1, math.random(5,10) do

                    local Tear = Game:Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, Effect.Position,
                                            RandomVector()* (4.5 + math.random()*2.5), nil, 0, math.max(1, Random())):ToTear()

                    Tear.FallingSpeed = - (10 + math.random()*20)
                    Tear.FallingAcceleration = 1.5 + math.random()*1.5

                    Tear.Scale = 0.7 + math.random()*0.25
                end
            else
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 0.8)
                local Dust = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, Effect.Position,
                                RandomVector(), nil,0, math.max(1, Random())):ToEffect()
                Dust.SpriteScale = Vector(1.25, 1.25)
                Dust:SetTimeout(20)
            end

            Effect:Remove()

        elseif Effect.State == AnvilStates.REFLECTED then

            Effect.SpriteRotation = Effect.SpriteRotation + (Effect.Velocity.X > 0 and 10 or -10)
            local Room = Game:GetRoom()
            local Grid = Room:GetGridEntityFromPos(Effect.Position)


            if Effect.SpriteOffset.Y < 0
               and not (Grid and Grid:GetType() == GridEntityType.GRID_WALL) then --break stuff when touching a wall or when landing
                return
            end


            local FellOnWater = Room:GetWaterAmount() >= 0.2

            if FellOnWater then
                Effect:SpawnWaterImpactEffects(Effect.Position, Vector.One, 100)

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, Effect.Position,
                           Vector.Zero, nil, 0, 1)
                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1,2,false, 0.9 + math.random()*0.1)

            else
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 0.8)

                local Dust = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, Effect.Position,
                                RandomVector(), nil,0, math.max(1, Random())):ToEffect()
                Dust.SpriteScale = Vector(1.25, 1.25)
                Dust:SetTimeout(20)
            end

            local Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Effect.Position,
                                         Vector.Zero, nil, 0, 1):ToEffect()

            Shock:SetRadii(10,35)
            Shock.Parent = Game:GetPlayer(0)

            Effect:Remove()
        end

    elseif Effect.Variant == mod.Effects.UMBRELLA then

        local Sprite = Effect:GetSprite()

        if Sprite:IsEventTriggered("open") then
            
            sfx:Play(SoundEffect.SOUND_GOOATTACH0)
        elseif Sprite:IsFinished("Retreat") then
            Effect:Remove()
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.EffectUpdate)

---@param Effect EntityEffect
local function EffectRender(_,Effect)

    if Effect.Variant == mod.Effects.TOMATO then

        local Data = Effect:GetData()
        if not Data.LaughingSpawn then --already landed

            local AnimIdx = Effect.State % (TomatoAnimations.NUM_VARIANTS + 1)

            if Effect.FrameCount == 150 then
                Effect:GetSprite():Play("Disappear"..tostring(AnimIdx))
            elseif Effect:GetSprite():IsFinished("Disappear"..tostring(AnimIdx)) then

                Effect:Remove()
                return
            end
            return
        end

        if Effect.SpriteScale.Y == 1 then --just landed

            Data.RenderFrames = nil
            Data.LaughingSpawn = nil
            Data.StartThrowOffset = nil
            Data.StartThrowRotation = nil
            Data.TargetThrowRotation = nil
            Effect.DepthOffset = 0
            Effect.SpriteRotation = 0

            local Sprite = Effect:GetSprite()
            local AnimIdx = Effect.State % (TomatoAnimations.NUM_VARIANTS+1)
            Effect.State = TomatoState.SPLAT + AnimIdx
            Sprite:Play("Splat"..tostring(AnimIdx))

            sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS)
            Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Effect.Position,
                       RandomVector()*3,Effect,0,1)



            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Effect.Position, 
                                     Vector.Zero, Effect, 0, math.max(Random(),1)):ToEffect()
            Creep.CollisionDamage = Effect.SpawnerEntity:ToPlayer().Damage/4 or 0.5
            Creep.SpriteScale = Vector.One * (2 + math.random()*1.5)
            Creep.Timeout = 600
            Creep:Update()

            for _,Enemy in ipairs(Isaac.FindInRadius(Effect.Position, 35, EntityPartition.ENEMY)) do

                Enemy:AddBaited(EntityRef(Effect), 120)
            end
        else

            Data.RenderFrames = Data.RenderFrames + 1

            Effect.SpriteOffset.Y = mod:ExponentLerp(Data.StartThrowOffset.Y, 0, Data.RenderFrames/300, 0.95)
            Effect.SpriteOffset.X = mod:Lerp(Data.StartThrowOffset.X, 0, Data.RenderFrames/900)

            Effect.SpriteScale = Vector.One * mod:ExponentLerp(2.25, 1, Data.RenderFrames/75, 2.5)
            Effect.SpriteRotation = mod:ExponentLerp(Data.StartThrowRotation, Data.TargetThrowRotation, Data.RenderFrames/75, 0.9)
        end

    elseif Effect.Variant == mod.Effects.ANVIL then
        --Effect:SetShadowSize(mod:Lerp(0.25, 1, Effect.SpriteOffset.Y/ANVIL_START_HEIGHT))
        Effect:SetShadowSize(mod:ExponentLerp(0.25, 0.8, Effect.SpriteOffset.Y/ANVIL_START_HEIGHT, 2))
        Effect:RenderShadowLayer(Vector.Zero)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, EffectRender)

-------------PICKUPS---------------
-----------------------------------


---@param Pickup EntityPickup
---@param Player Entity
local function PickupCollision(_, Pickup, Player)

    Player = Player:ToPlayer()

    if not Player then
        return
    end

    if Pickup.Variant == mod.Pickups.LOLLYPOP then
        
        if Player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
            Player = Player:GetOtherTwin()
        end

        local Effects = Player:GetEffects()
        Effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_GAMEKID, true, 1)
        Effects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_GAMEKID).Cooldown = 165

        Pickup:GetSprite():Play("Collect")
        Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(mod.Sounds.EAT, 1, 10, false, 0.95 + math.random()*0.1)
        Pickup.Velocity = Vector.Zero
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PickupCollision)


---@param Pickup EntityPickup
local function PickupUpdate(_, Pickup)

    if Pickup.Variant == mod.Pickups.LOLLYPOP then

        local Sprite = Pickup:GetSprite()

        if Sprite:IsEventTriggered("DropSound") then

            sfx:Play(SoundEffect.SOUND_SCAMPER)

        elseif Sprite:IsPlaying("Collect") then
            Pickup.Velocity = Vector.Zero
            Pickup:SetShadowSize(0)

        elseif Sprite:IsFinished("Collect") then
                Pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PickupUpdate)

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

    elseif Player:HasCollectible(mod.Collectibles.LOLLYPOP) then

        if Game:GetRoom():IsClear() then
            return
        end

        local Data = Player:GetData()

        if Player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_GAMEKID) > 0 then --timer advances only while vulnerable
            return
        end

        Data.LollypopCooldown = Data.LollypopCooldown and (Data.LollypopCooldown - 1) or MAX_LOLLYPOP_COOLDOWN
    
        if Data.LollypopCooldown <= 0 then

            local LollypopNum = 0
            for _, _ in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.Pickups.LOLLYPOP)) do
                LollypopNum = LollypopNum + 1
            end

            if LollypopNum >= 3 then
                return
            end

            Game:Spawn(EntityType.ENTITY_PICKUP, mod.Pickups.LOLLYPOP, Isaac.GetRandomPosition(), Vector.Zero,
                       nil, LollypopPicker:PickOutcome(Player:GetCollectibleRNG(mod.Collectibles.LOLLYPOP)), math.max(Random(), 1))

            Data.LollypopCooldown = MAX_LOLLYPOP_COOLDOWN
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.SpawnCrayonCreep, PlayerVariant.PLAYER)


local function OnNewRoom()

    if not mod.GameStarted then
        return
    end
    local Room = Game:GetRoom()

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        local PIndex = Player:GetData().TruePlayerIndex

        if Player:HasCollectible(mod.Collectibles.CRAYONS) then
            
            local RandomColor
            local Data = Player:GetData()
            repeat
                RandomColor = math.random(ColorSubType.NUM_COLORS)

            until not Data.CrayonColor or RandomColor ~= Data.CrayonColor

            Player:GetData().CrayonColor = RandomColor
        end
        if Player:HasCollectible(mod.Collectibles.BALOON_PUPPY) then

            for _, Puppy in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.BLOON_PUPPY)) do

                if Puppy.State ~= PuppyState.EXPLODED then
                    Puppy = Puppy:ToFamiliar()
                    Puppy.State = PuppyState.IDLE
                    Puppy.FireCooldown = 0
                end
            end
        end
        if Player:HasCollectible(mod.Collectibles.TRAGICOMEDY) then

            ---@diagnostic disable-next-line: param-type-mismatch
            Player:AddCacheFlags(TragicomedyCaches)
            Player:TryRemoveNullCostume(MaskCostume[mod.Saved.Player[PIndex].ComedicState])
            mod.Saved.Player[PIndex].ComedicState = ComedicState.NONE
            

            if Player:GetPlayerType() == mod.Characters.JimboType and mod:JimboHasTrinket(Player, mod.Jokers.SOCK_BUSKIN)
               or Player:HasTrinket(mod.Jokers.SOCK_BUSKIN) 
               or Player:HasCollectible(CollectibleType.COLLECTIBLE_DUALITY) then --set both tragic and comedy

                mod.Saved.Player[PIndex].ComedicState = ComedicState.TRAGICOMEDY + 0

            else

                local MaskRNG = Player:GetCollectibleRNG(mod.Collectibles.TRAGICOMEDY)
                local ComedicChance = MaskRNG:RandomFloat()

                if ComedicChance <= 0.4 or Player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then
                    mod.Saved.Player[PIndex].ComedicState = mod.Saved.Player[PIndex].ComedicState + ComedicState.COMEDY

                end

                ComedicChance = MaskRNG:RandomFloat()

                if ComedicChance <= 0.4 or Player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
                    mod.Saved.Player[PIndex].ComedicState = mod.Saved.Player[PIndex].ComedicState + ComedicState.TRAGEDY

                end

                Player:AddNullCostume(MaskCostume[mod.Saved.Player[PIndex].ComedicState])
            end

            Player:EvaluateItems()

        else --does not have tragicomedy
        
            Player:TryRemoveNullCostume(MaskCostume[mod.Saved.Player[PIndex].ComedicState])
            mod.Saved.Player[PIndex].ComedicState = ComedicState.NONE

        end
    end

    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) and Room:IsFirstVisit() then
        mod:LaughSignEffect(LaughEffectType.GASP, PlayerManager.FirstCollectibleOwner(mod.Collectibles.LAUGH_SIGN))
    end


end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnNewRoom)


function mod:ChooseRoomCrayonColor2(Type,_,_,_,_, Player)
    if Type == mod.Collectibles.CRAYONS then

        local RandomColor
        local Data = Player:GetData()
        repeat
            RandomColor = math.random(ColorSubType.NUM_COLORS)

        until not Data.CrayonColor or RandomColor ~= Data.CrayonColor

        Player:GetData().CrayonColor = RandomColor
        return
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.ChooseRoomCrayonColor2)


---@param Player EntityPlayer
---@param Rng RNG
function mod:ActiveUse(Item, Rng, Player, Flags, Slot, Data)

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
                   BananaSpeed + Player:GetTearMovementInheritance(BananaSpeed), Player, 0, math.max(Random(), 1)):ToEffect()
        
        sfx:Play(SoundEffect.SOUND_SUMMON_POOF)

        Banan:GetSprite():Play("throw")

        local Data = Banan:GetData()

        Banan.State = BananaState.FLYING

        Data.ZSpeed = -math.random()*10 - 6
        Data.ZAcceleration = 1 or math.random()*1.5 + 1

    elseif Item == mod.Collectibles.UMBRELLA then

        local Anvil = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.ANVIL, Player.Position, 
                               Vector.Zero, Player, 0, 1):ToEffect()

        Anvil:FollowParent(Player)
        Anvil:SetTimeout(ANVIL_FOLLOW_TIME) --will follow the player for thim many frames
    
        Anvil.State = AnvilStates.FALLING
        Anvil.SpriteOffset = Vector(0, ANVIL_START_HEIGHT)

        local Data = Anvil:GetData()
        Data.FallingSpeed = 15
        Data.FallingAcceleration = 0


        if Flags & UseFlag.USE_MIMIC == 0 then
            Player:AddCollectible(mod.Collectibles.OPENED_UMBRELLA, 0,  false, Slot)

            local Umbrella = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.UMBRELLA, Player.Position, 
                       Vector.Zero, Player, 0, 1):ToEffect()

            Umbrella.SpriteScale = Player.SpriteScale
            Umbrella.DepthOffset = 10
            Umbrella.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            Umbrella:FollowParent(Player)
            
            Umbrella:SetSize(Umbrella.Size, Umbrella.SizeMulti*Umbrella.SpriteScale, 12)
            Umbrella:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
        end

        Isaac.CreateTimer(function ()
            if Player:Exists() and not Player:IsDead()
               and Player:HasCollectible(mod.Collectibles.OPENED_UMBRELLA) then
                
                Player:UseActiveItem(mod.Collectibles.UMBRELLA, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
            end
        end, math.random(150, 210), 1, true)

    elseif Item == mod.Collectibles.OPENED_UMBRELLA then

        for _,Umbrella in ipairs(Isaac.FindInRadius(Player.Position, 1, EntityPartition.EFFECT)) do
            
            if Umbrella.Variant == mod.Effects.UMBRELLA then
                
                Umbrella:GetSprite():Play("Retreat")
            end
        end

        if Flags & UseFlag.USE_MIMIC == 0 then
            Player:AddCollectible(mod.Collectibles.UMBRELLA, 0,  false, Slot)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ActiveUse)


---@param Player EntityPlayer
local function OnPlayerUpdate(_,Player)

    local ShootDirection = Player:GetShootingInput()

    if Player:GetItemState() == mod.Collectibles.BANANA
       and ShootDirection:Length() > 0 then

        
        Player:AnimateCollectible(mod.Collectibles.BANANA, "HideItem")
        Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)

        Player:AddCollectible(mod.Collectibles.EMPTY_BANANA, 0, true, Player:GetActiveItemSlot(mod.Collectibles.BANANA))
        Player:DischargeActiveItem()
        
        local Tear = Game:Spawn(EntityType.ENTITY_TEAR, mod.Tears.BANANA_VARIANT, Player.Position, ShootDirection*Player.ShotSpeed*2.75, Player, 0, 1):ToTear()
        Tear.Parent = Player

        Tear.CanTriggerStreakEnd = false

        sfx:Play(SoundEffect.SOUND_PLOP)
        Tear.CollisionDamage = 0
        Tear.FallingAcceleration = 0


    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, OnPlayerUpdate)


local function OnUpdate()

    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) then
        
        if math.random() <= 0.001 then
            mod:LaughSignEffect(LaughEffectType.RANDOM)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, OnUpdate)


local function OnStageTransition()
    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) then
        
        mod:LaughSignEffect(LaughEffectType.TRANSITION)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY_JINGLE, OnStageTransition, Music.MUSIC_JINGLE_NIGHTMARE)



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

                Cloud:SetColor(CrayonColors[ColorSubType.YELLOW], -1, 1, true, true)
            end
        end,5,1, false)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.BananaExplosion)


function mod:ResetBananaCharge()

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        for Slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do    
            local Item = Player:GetActiveItem(Slot)

            if Item == mod.Collectibles.EMPTY_BANANA then
                
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

---@param Entity Entity
local function OnPlayerTakeDamage(_,Entity)
    
    local Player = Entity:ToPlayer()

    if not Player then
        return
    end

    if Player:HasCollectible(mod.Collectibles.BALOON_PUPPY) then
        
        for _, Puppy in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.BLOON_PUPPY)) do

            Puppy = Puppy:ToFamiliar()
            if Puppy.State == PuppyState.IDLE and Player:GetPlayerIndex() == Puppy.Player:GetPlayerIndex() then
                Puppy = Puppy:ToFamiliar()
                Puppy.State = PuppyState.ATTACK
                Puppy.FireCooldown = 0 --used as a timer for how long it has been attacking
            end
        end
    end
    if Player:HasCollectible(mod.Collectibles.LAUGH_SIGN) then

        mod:LaughSignEffect(LaughEffectType.BAD, Player)

    end
    if Player:HasCollectible(mod.Collectibles.CLOWN) then
        sfx:Play(mod.Sounds.CLOWN_HONK,1,2,false, 0.75 + math.random()*0.5)
        Isaac.CreateTimer(function ()
            sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
        end,0,1, true)

        for _, Enemy in ipairs(Isaac.GetRoomEntities()) do
            
            Enemy = Enemy:ToNPC()
            if Enemy and Enemy:IsActiveEnemy() then
                
                local ClownRNG = Player:GetCollectibleRNG(mod.Collectibles.CLOWN)
                local EffectRoll = ClownRNG:RandomFloat()

                if EffectRoll <= 0.33 then
                    Enemy:AddFear(EntityRef(Player), 100)

                elseif EffectRoll >= 0.66 then
                    Enemy:AddCharmed(EntityRef(Player), 100)

                end
            end
        end
    end

end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, OnPlayerTakeDamage, EntityType.ENTITY_PLAYER)


local function OnRoomClear()

    local Type = Game:GetRoom():GetType()
    if Type == RoomType.ROOM_BOSS or Type == RoomType.ROOM_MINIBOSS then

        for _,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:HasCollectible(mod.Collectibles.LAUGH_SIGN) then

                mod:LaughSignEffect(LaughEffectType.GOOD, Player)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, OnRoomClear)


---@param Player EntityPlayer?
function mod:LaughSignEffect(Type, Player)

    if Type == LaughEffectType.BAD then --throw tomatoes randomly in the room
    
        sfx:Play(mod.Sounds.BOO, 1, 120, false, math.random()*0.1 + 0.95)

        local Timer = 10
        for i=1, 5 + Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO)*2 do
            
            Isaac.CreateTimer(function ()

                local Tomato = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.TOMATO, 
                                          Isaac.GetRandomPosition(), Vector.Zero, Player, 0, 1):ToEffect()

                local Data = Tomato:GetData()
                Data.LaughingSpawn = true
                Data.RenderFrames = 0

                local RandomAnimIdx = math.random(1, TomatoAnimations.NUM_VARIANTS)

                Tomato:GetSprite():Play("Idle"..tostring(RandomAnimIdx))
                Tomato.State = TomatoState.THROW + RandomAnimIdx


                --starts from off screen
                Tomato.SpriteOffset = Vector(math.random(-110, 110),Isaac.GetScreenHeight() - Isaac.WorldToScreen(Tomato.Position).Y + 40)
                Tomato.SpriteScale = Vector.One * 2.25
                Data.StartThrowOffset = Tomato.SpriteOffset
                Data.StartThrowRotation = math.random()*-360 - 360
                Data.TargetThrowRotation = RandomAnimIdx == 1 and -45 or 45 --replace this with a table if more animations appear(not gonna happen)

                Tomato.DepthOffset = 1000

            end, Timer, 1, true)

            Timer = Timer + math.random(10,35)
        end

    elseif Type == LaughEffectType.GOOD then --throw pickups at player

        sfx:Play(mod.Sounds.APPLAUSE, 1, 120, false, math.random()*0.1 + 0.95)
        local Timer = 10
        local Room = Game:GetRoom()
        for i=1, 5 do
            
            Isaac.CreateTimer(function ()

                local Pickup = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 
                                          Room:FindFreePickupSpawnPosition(Player.Position, 100), Vector.Zero, Player,
                                          NullPickupSubType.NO_COLLECTIBLE_CHEST, math.max(Random(),1))

                local Data = Pickup:GetData()
                Data.LaughingSpawn = true
                Data.RenderFrames = 0

                --starts from off screen
                Pickup.SpriteOffset = Vector(math.random(-110, 110),Isaac.GetScreenHeight() - Isaac.WorldToScreen(Pickup.Position).Y + 40)
                Pickup.SpriteScale = Vector.One * 2.25
                Data.StartThrowOffset = Pickup.SpriteOffset
                Data.StartThrowRotation = math.random()*-360 - 360
                Pickup.DepthOffset = 1000


                Pickup:GetSprite():Play("Idle")

            end, Timer, 1, true)

            Timer = Timer + math.random(10,30)
        end

    elseif Type == LaughEffectType.GASP then
        sfx:Play(mod.Sounds.GASP, 1, 120)

    elseif Type == LaughEffectType.LAUGH then
        sfx:Play(mod.Sounds.LAUGH, 1, 120)

    elseif Type == LaughEffectType.RANDOM then
        sfx:Play(mod.Sounds.RANDOM_CROWD, 1, 300, false, math.random()*0.1 + 0.95)

    elseif Type == LaughEffectType.TRANSITION then
        sfx:Play(mod.Sounds.CROWD_TRANSITION, 1, 2, false, math.random()*0.1 + 0.95)
    
    end

end


local function WaitForPickupLanding(_, Pickup, Collider)

    local Data = Pickup:GetData()

    if Data.LaughingSpawn then
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, WaitForPickupLanding)


---@param Pickup EntityPickup
local function PickupThrowParabola(_, Pickup)

    local Data = Pickup:GetData()
    if not Data.LaughingSpawn then
        return
    end

    if Pickup.SpriteScale.Y == 1 then --pickup landed
        
        Data.RenderFrames = nil
        Data.LaughingSpawn = nil
        Data.StartThrowOffset = nil
        Data.StartThrowRotation = nil

        if Pickup.Variant == PickupVariant.PICKUP_BOMB
           and Pickup.SubType == BombSubType.BOMB_TROLL or Pickup.SubType == BombSubType.BOMB_SUPERTROLL then
            
            Isaac.Explode(Pickup.Position, Pickup, 100)
        else
            Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL --make the pickupable like normal
            Pickup.DepthOffset = 0
            sfx:Play(SoundEffect.SOUND_SCAMPER)
        end
    else
        
        Data.RenderFrames = Data.RenderFrames + 1

        Pickup.SpriteOffset.Y = mod:ExponentLerp(Data.StartThrowOffset.Y, 0, Data.RenderFrames/300, 0.95)
        Pickup.SpriteOffset.X = mod:Lerp(Data.StartThrowOffset.X, 0, Data.RenderFrames/900)

        Pickup.SpriteScale = Vector.One * mod:ExponentLerp(2.25, 1, Data.RenderFrames/75, 2,5)
        Pickup.SpriteRotation =mod:ExponentLerp(Data.StartThrowRotation, 0, Data.RenderFrames/75, 0.9)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, PickupThrowParabola)


local function OnItemLoss(_, Player, Item)

    if Item == mod.Collectibles.OPENED_UMBRELLA then

        for _,Umbrella in ipairs(Isaac.FindInRadius(Player.Position, 1, EntityPartition.EFFECT)) do
            
            if Umbrella.Variant == mod.Effects.UMBRELLA then
                
                Umbrella:GetSprite():Play("Retreat")
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, OnItemLoss)


local function OnItemAdded(_, Item, Charge, FirstTime, Slot, Var, Player)

    if Item == mod.Collectibles.OPENED_UMBRELLA then

        if not Player:HasCollectible(mod.Collectibles.UMBRELLA) then
            
            return {mod.Collectibles.UMBRELLA, 0, false, Slot, Var, Player}
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, OnItemAdded)


---@param Tear EntityTear
local function PocketAcesTrigger(_, Tear)

    local Player = Tear.Parent:ToPlayer()

    if not Player or Player:GetPlayerType() == mod.Characters.JimboType
       or not Player:HasCollectible(mod.Collectibles.POCKET_ACES) then
        return
    end

    local CardChance = (1 + Player.Luck/3)/13

    if math.random() >= CardChance then
        return
    end

    if Tear:ToTear() then --change the variant as well

        Tear:ChangeVariant(mod.Tears.CARD_TEAR_VARIANT)

        local TearSprite = Tear:GetSprite()
        TearSprite:Play(BASE_CARD_ANIMATION, true)
        TearSprite:PlayOverlay(SUIT_ANIMATIONS[math.random(1,4)], true)

        Tear.CollisionDamage = math.max(Tear.CollisionDamage, Player.Damage * mod:CalculateTears(Player.MaxFireDelay))
    
    else --only change the damage dealt
    
        local Laser = Tear:ToLaser()
        local Multiplier = math.max(1, Player.Damage * mod:CalculateTears(Player.MaxFireDelay)/Laser.CollisionDamage)
        Laser:SetDamageMultiplier(Laser:GetDamageMultiplier() * Multiplier)
        Tear.CollisionDamage = Player.Damage * mod:CalculateTears(Player.MaxFireDelay)
    
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PocketAcesTrigger)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, PocketAcesTrigger)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE_BALL, PocketAcesTrigger)


local function StatEvaluation(_,Player, Cache)

    if not mod.GameStarted then
        return
    end

    if Player:HasCollectible(mod.Collectibles.TRAGICOMEDY) then
        
        local PIndex = Player:GetData().TruePlayerIndex

        if mod.Saved.Player[PIndex].ComedicState & ComedicState.COMEDY == ComedicState.COMEDY then
            
            if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
                Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, 1)
            end
            if Cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
                Player.MoveSpeed = Player.MoveSpeed + 0.2
            end
            if Cache & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
                Player.Luck = Player.Luck + 2
            end
        end
        if mod.Saved.Player[PIndex].ComedicState & ComedicState.TRAGEDY == ComedicState.TRAGEDY then

            if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
                Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, 0.5)
            end
            if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
                Player.Damage = Player.Damage + 1
            end
            if Cache & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
                Player.TearRange = Player.TearRange + 100
            end
        end
    end
    if Player:HasCollectible(mod.Collectibles.LOLLYPOP) then

        if Cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
            
            Player.MoveSpeed = Player.MoveSpeed + 0.15*Player:GetCollectibleNum(mod.Collectibles.LOLLYPOP)
        end
    end

    if Player:HasTrinket(mod.Jokers.JOKER) then
        if  Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            
            Player.Damage = Player.Damage + 1.2 * Player:GetTrinketMultiplier(mod.Jokers.JOKER)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, StatEvaluation)


---@param Slot EntitySlot
---@param Player EntityPlayer
local function GuaranteeBeggarPayout(_, Slot, Player)

    if not (Slot.Variant == SlotVariant.BEGGAR
        or Slot.Variant == SlotVariant.KEY_MASTER
        or Slot.Variant == SlotVariant.BOMB_BUM
        or Slot.Variant == SlotVariant.BATTERY_BUM
        or Slot.Variant == SlotVariant.DEVIL_BEGGAR) then
                
        return
    end

    Player = Player:ToPlayer()

    if not Player then
        return
    end

    if Player:HasTrinket(mod.Trinkets.TASTY_CANDY, true) then

        Slot:GetSprite():ReplaceSpritesheet(2, CandySheets[Slot.Variant], true) --puts the candy in the bum's sprite
        Slot:GetSprite():Play("PayPrize")


        print(Slot:GetPrizeType())
        --Slot:SetPrizeType(3)
        Slot:SetState(2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, GuaranteeBeggarPayout)