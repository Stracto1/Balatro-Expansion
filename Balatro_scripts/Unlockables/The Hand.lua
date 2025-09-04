---@diagnostic disable: cast-local-type, need-check-nil, param-type-mismatch
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local VanillaCardsSprite = Sprite("gfx/ui/The_hand_vanilla_cards.anm2", true)

local MAX_HOLD_TIME = 45

local BLACKLIST = {PickupVariant.PICKUP_BED,
                   PickupVariant.PICKUP_BROKEN_SHOVEL,
                   PickupVariant.PICKUP_BIGCHEST,
                   PickupVariant.PICKUP_TROPHY
                   }


local PUSH_VARIANTS = {PickupVariant.PICKUP_BOMBCHEST,
                       PickupVariant.PICKUP_COLLECTIBLE,
                       PickupVariant.PICKUP_MEGACHEST,
                       PickupVariant.PICKUP_TRINKET --makes things easier 
                       }


local CHEST_VARIANTS = {PickupVariant.PICKUP_CHEST,
                        PickupVariant.PICKUP_OLDCHEST,
                        PickupVariant.PICKUP_REDCHEST,
                        PickupVariant.PICKUP_LOCKEDCHEST,
                        PickupVariant.PICKUP_WOODENCHEST,
                        PickupVariant.PICKUP_MOMSCHEST,
                        PickupVariant.PICKUP_MIMICCHEST,
                        PickupVariant.PICKUP_SPIKEDCHEST,
                        PickupVariant.PICKUP_ETERNALCHEST,
                        }



---@param Player EntityPlayer
---@param Rng RNG
local function ActiveUse(_, Item, Rng, Player, Flags, Slot, Data)

    local ReturnTable = {Discharge = false,
                         Remove = false,
                         ShowAnim = false}
                         
    if Item == mod.Collectibles.THE_HAND then

        if Player:GetItemState() == mod.Collectibles.THE_HAND then

            Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)
            Player:AnimateCollectible(mod.Collectibles.THE_HAND, "HideItem")
        else

            Player:SetItemState(mod.Collectibles.THE_HAND)
            Player:AnimateCollectible(mod.Collectibles.THE_HAND, "LiftItem")
        end

        return ReturnTable
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, ActiveUse)


local function UseSingleHandyCard(Player)

    local SomeoneIsSelecting = false

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        local PIndex = Player:GetData().TruePlayerIndex

        print(mod.SelectionParams[PIndex].Mode)
    
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then
            SomeoneIsSelecting = true
        
            break
        end
    end
    
    if SomeoneIsSelecting then

        print("delayed")

        Isaac.CreateTimer(function ()
            UseSingleHandyCard(Player)
        end, 1, 1, true)

    else
        local PIndex = Player:GetData().TruePlayerIndex

        local HandyCards = mod.Saved.Player[PIndex].HandyCards


        Player:UseCard(HandyCards[1])

        table.remove(HandyCards, 1)
        HandyCards[#HandyCards+1] = Card.CARD_NULL
    end
end

---@param Player EntityPlayer
local function UseHandyCards(Player)

    local PIndex = Player:GetData().TruePlayerIndex

    local HandyCards = mod.Saved.Player[PIndex].HandyCards
    local NumCards = #HandyCards

    for i = 1, NumCards do
        Isaac.CreateTimer(function ()

            UseSingleHandyCard(Player)

        end, i*10, 1, true)
    end
end


---@param Player EntityPlayer
local function SetupHandCardsTable(_, Item, _, _,_, VarData, Player)

    if Item ~= mod.Collectibles.THE_HAND then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NumHands = math.min(5*Player:GetCollectibleNum(mod.Collectibles.THE_HAND), 10)


    local HandyCards = mod.Saved.Player[PIndex].HandyCards

    for i = 1, NumHands do
        
        HandyCards[i] = HandyCards[i] or 0
    end    
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, SetupHandCardsTable)



---@param Player EntityPlayer
local function ResizeHandCardsTable(_, Player, Item)

    local PIndex = Player:GetData().TruePlayerIndex

    local NumHands = math.min(5*Player:GetCollectibleNum(mod.Collectibles.THE_HAND), 10)


    local HandyCards = mod.Saved.Player[PIndex].HandyCards

    for i = 10, NumHands do

        if HandyCards[i] and HandyCards[i] ~= Card.CARD_NULL then
            
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, Player, HandyCards[i], mod:RandomSeed(NumHands))
        end
        
        HandyCards[i] = nil --removes any excess card
    end    
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, ResizeHandCardsTable, mod.Collectibles.THE_HAND)


---@param Player EntityPlayer
local function HandInputs(_, Player)

    if not Player:HasCollectible(mod.Collectibles.THE_HAND) then
        return
    end

    local PData = Player:GetData()

    local IsHoldingHand = Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)
                          and Player:GetItemState() == mod.Collectibles.THE_HAND

    if IsHoldingHand then

        PData.THE_HAND_HoldTime = PData.THE_HAND_HoldTime or 0
        PData.THE_HAND_HoldTime = PData.THE_HAND_HoldTime + 1

        if PData.THE_HAND_HoldTime == MAX_HOLD_TIME then
            print("use")
            UseHandyCards(Player)
            Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)
        end
    else
        PData.THE_HAND_HoldTime = 0
    end

    if IsHoldingHand then
        return
    end

        
    if Input.IsActionTriggered(ButtonAction.ACTION_DROP, Player.ControllerIndex) then
        
        local PIndex = Player:GetData().TruePlayerIndex
        local HandyCards = mod.Saved.Player[PIndex].HandyCards

        local FirstEmptySlot = mod:GetValueIndex(HandyCards, Card.CARD_NULL, true) or (#HandyCards + 1)

        table.insert(HandyCards, FirstEmptySlot, HandyCards[1])
        table.remove(HandyCards, 1)
    end


    local ShootDirection = Player:GetShootingInput()

    if Player:GetItemState() == mod.Collectibles.THE_HAND
       and ShootDirection:Length() > 0 then

        for i,Effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, mod.Effects.HAND_SWING)) do
            
            if GetPtrHash(Effect.SpawnerEntity) == GetPtrHash(Player) then
                return
            end
        end

        Player:AnimateCollectible(mod.Collectibles.THE_HAND, "HideItem")
        Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)

        local SwingRotation = ((ShootDirection:GetAngleDegrees() + 45) // 90)*90 - 90
        local SwingDirection = Vector.FromAngle(SwingRotation + 90)


        local Swing = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.HAND_SWING, Player.Position + SwingDirection*5,
                                 Vector.Zero, Player, 0, 1):ToEffect()

        sfx:Play(SoundEffect.SOUND_SHELLGAME)
        --local Swing = Player:FireKnife(Player, SwingRotation, true, KnifeSubType.PROJECTILE, KnifeVariant.BAG_OF_CRAFTING)

        Swing:FollowParent(Player)

        Swing.SpriteRotation = SwingRotation
        Swing.SpriteScale = Player.SpriteScale
        Swing:GetSprite():Play("Swing")
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HandInputs, PlayerVariant.PLAYER)


---@param Effect EntityEffect
local function HandPickupCollision(_, Effect)

    if Effect:GetSprite():IsFinished() then
        Effect:Remove()
        return
    end

    local Player = Effect.SpawnerEntity:ToPlayer()

    local CollisionCapsule = Effect:GetNullCapsule("Hit")

    if not CollisionCapsule then
        return
    end

    local EffectData = Effect:GetData()
    EffectData.HandHitList = EffectData.HandHitList or {}

    for i,Pickup in ipairs(Isaac.FindInCapsule(CollisionCapsule, EntityPartition.PICKUP)) do

        local PickupHash = GetPtrHash(Pickup)
        Pickup = Pickup:ToPickup()

        if not Pickup
           or Pickup.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE
           or Pickup.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ENEMIES
           or mod:Contained(BLACKLIST, Pickup.Variant)
           or mod:Contained(EffectData.HandHitList, PickupHash) then

            goto SKIP_PICKUP
        end

        EffectData.HandHitList[#EffectData.HandHitList+1] = PickupHash

        if Pickup.Variant == PickupVariant.PICKUP_TAROTCARD then

            local PIndex = Effect.Parent:GetData().TruePlayerIndex

            local HandyCards = mod.Saved.Player[PIndex].HandyCards

            local EmptySpace = mod:GetValueIndex(HandyCards, Card.CARD_NULL, true)

            if EmptySpace then --has an empty slot
                
                table.remove(HandyCards, EmptySpace)
                table.insert(HandyCards, 1, Pickup.SubType)
            
            else

                HandyCards[1] = Pickup.SubType
            end

            local CardSprite = Pickup:GetSprite()

            CardSprite:Play("Collect")
            Pickup:PlayPickupSound()
            
            local AnimLength = CardSprite:GetAnimationData("Collect"):GetLength()

            local CardConfig = ItemsConfig:GetCard(Pickup.SubType)

            Game:GetHUD():ShowItemText(CardConfig.Name, CardConfig.Description)

            Isaac.CreateTimer(function ()

                Pickup:Remove()
                
            end, AnimLength, 1, false)

            

        else

            local Collided  = Player:ForceCollide(Pickup, true)

            if Collided then --yay! (works for basic pickups like coins and such)
                return
            end

            Collided  = Pickup:ForceCollide(Player, true)

            if Collided then --yay! (doesn't seem like it ever does anything but might as well try)
                return
            end

            --force the collision in some other way
                                        
            if mod:Contained(CHEST_VARIANTS, Pickup.Variant) then

                if (Pickup.Variant ~= PickupVariant.PICKUP_LOCKEDCHEST
                   and Pickup.Variant ~= PickupVariant.PICKUP_OLDCHEST
                   and Pickup.Variant ~= PickupVariant.PICKUP_ETERNALCHEST) or Player:GetNumKeys() >= 1 then
                
                    Pickup:TryOpenChest()
                end

                Pickup:AddVelocity((Pickup.Position - Player.Position):Resized(7.5))

            elseif mod:Contained(PUSH_VARIANTS, Pickup.Variant) then

                Pickup:AddVelocity((Pickup.Position - Player.Position):Resized(7.5))

            else --teleport the pickup to the player and set its offset to look like it didn't move

                local Movement = Pickup.Position + Pickup.PositionOffset - Player.Position

                Pickup.PositionOffset = Movement

                Pickup.Position = Player.Position

                Isaac.CreateTimer(function ()
                    if Pickup:Exists() then
                        Pickup.PositionOffset = Vector.Zero
                    end
                end, 1, 1, false)
            end
                           
        end

        ::SKIP_PICKUP::
    end



    local HandDamage = Player.SpriteScale:Length() + 5

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH) then
        
        HandDamage = HandDamage + 3.5 + 0.2*Player:GetNumCoins()
    end
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_HEELS) then
        
        HandDamage = HandDamage + 12
    end
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) then

        HandDamage = HandDamage * 2
    end


    for i,Enemy in ipairs(Isaac.FindInCapsule(CollisionCapsule, EntityPartition.ENEMY)) do

        local EnemyHash = GetPtrHash(Enemy)

        if Enemy:IsActiveEnemy() and not mod:Contained(EffectData.HandHitList, EnemyHash) then

            EffectData.HandHitList[#EffectData.HandHitList+1] = EnemyHash

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) then
                    
                Enemy:AddKnockback(EntityRef(Player), (Enemy.Position - Player.Position):Resized(10), 100, true)
                sfx:Play(SoundEffect.SOUND_PUNCH)
            else
                Enemy:AddVelocity((Enemy.Position - Player.Position):Resized(8))
            end

            if Enemy:IsVulnerableEnemy() then
                
                if Player:HasCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH) then
                    if math.random() <= 0.25 then
                        Enemy:AddMidasFreeze(EntityRef(Player), 100)
                    end
                end

                if Player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS)
                   or Player:HasCollectible(CollectibleType.COLLECTIBLE_VIRUS) then
                    if math.random() <= 0.25 then
                        Enemy:AddPoison(EntityRef(Player), 110, Player.Damage / 2)
                    end
                end

                Enemy:TakeDamage(HandDamage,0, EntityRef(Player), 2)
            end
            
        elseif Enemy.Type == EntityType.ENTITY_FIREPLACE then

            Enemy:Kill()
        end
    end


    if not Player:HasCollectible(CollectibleType.COLLECTIBLE_TELEKINESIS) then
        return
    end

    for i,Bullet in ipairs(Isaac.FindInCapsule(CollisionCapsule, EntityPartition.BULLET)) do

        Bullet = Bullet:ToProjectile()
        local BulletHash = GetPtrHash(Bullet)

        if Bullet
           and not Bullet:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) 
           and not mod:Contained(EffectData.HandHitList, BulletHash) then

            EffectData.HandHitList[#EffectData.HandHitList+1] = BulletHash


            Bullet:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.ANTI_GRAVITY)
            Bullet:Deflect(-Bullet.Velocity)
            Bullet:SetColor(Color.ProjectileHushBlue, -1, 100, false, false)
            
        end
    end



end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, HandPickupCollision, mod.Effects.HAND_SWING)


---@param HeartSprite Sprite
---@param Player EntityPlayer
local function MoveHeartsSprite(_, Offset, HeartSprite, Position,_, Player)

    if not Player:HasCollectible(mod.Collectibles.THE_HAND) then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local HandyCards = mod.Saved.Player[PIndex].HandyCards
    local InitialPosition = Position + Vector.Zero

    --ItemsConfig:GetCard(mod.Spectrals.CRYPTID).ModdedCardFront:Render(Vector(150, 100))

    local RENDER_MULT = 1

    if PIndex % 2 == 0 then
        RENDER_MULT = -RENDER_MULT
    end



    local RenderPos = InitialPosition + Vector(0, 4)*RENDER_MULT


    local FirstCard = HandyCards[1]

    if FirstCard < Card.NUM_CARDS then --vanilla cards have a separate sprite since cardfronts are handled like doo doo
    
        VanillaCardsSprite:SetFrame("Big", FirstCard)
        VanillaCardsSprite:Render(RenderPos)
    else

        local Config = ItemsConfig:GetCard(FirstCard)

---@diagnostic disable-next-line: undefined-field
        local CardFront = Config.ModdedCardFront

        CardFront:SetFrame(Config.HudAnim, 0)
        CardFront:Render(RenderPos)
    end

    RenderPos = RenderPos + Vector(16, 0)*RENDER_MULT

    for i = 2, #HandyCards do

        local HandyCard = HandyCards[i]

        if HandyCard < Card.NUM_CARDS then

            VanillaCardsSprite:SetFrame("Small", HandyCard)
            VanillaCardsSprite:Render(RenderPos)

        else --crazy how i need to use 2 XMLnodes to get a card's back

            local Config = ItemsConfig:GetCard(HandyCard)

            local PickupID = XMLData.GetEntryByName(XMLNode.CARD, Config.Name)["pickup"]
            local Anm2Path = XMLData.GetEntityByTypeVarSub(5, 300, PickupID, true)["anm2path"]

            local CardBack = Sprite("gfx/"..Anm2Path)

            CardBack:SetFrame("HUDSmall", 0)

            CardBack:Render(RenderPos)
        end

        if i % 5 == 0 then
            RenderPos = RenderPos + Vector(-64*RENDER_MULT, 14)
        else
            RenderPos = RenderPos + Vector(16*RENDER_MULT, 0)
        end
    end


    HeartSprite.Offset = Vector(82, 0)*RENDER_MULT

end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, CallbackPriority.LATE, MoveHeartsSprite)




