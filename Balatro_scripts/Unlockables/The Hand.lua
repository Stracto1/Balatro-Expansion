---@diagnostic disable: cast-local-type, need-check-nil, param-type-mismatch
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local HandChargeBar = Sprite("gfx/ui/chargebar_the_hand.anm2", true)
HandChargeBar.Offset = Vector(-17, -25) --the player offset

local CHARGE_LENGTH = HandChargeBar:GetAnimationData("Charging"):GetLength()
local DISAPPEAR_LENGTH = HandChargeBar:GetAnimationData("Disappear"):GetLength()


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
                       PickupVariant.PICKUP_HEART --makes things easier 
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

local WISP_HEIGHT_OFFSET = 14
local BASE_WISP_VELOCITY = 5.5



---@param Player EntityPlayer
---@param Rng RNG
local function ActiveUse(_, Item, Rng, Player, Flags, Slot, Data)
                         
    if Item == mod.Collectibles.THE_HAND then

        local ReturnTable = {Discharge = false,
                             Remove = false,
                             ShowAnim = false}

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
    
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then
            SomeoneIsSelecting = true
        
            break
        end
    end
    
    if SomeoneIsSelecting then

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

        if HandyCards[i] == 0 then

            if i == 1 then
                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
            end
            return
        end

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

    if not Player:HasCollectible(mod.Collectibles.THE_HAND)
      or not mod.GameStarted then
        return
    end

    local PData = Player:GetData()
    PData.REG_HandHoldTime = PData.REG_HandHoldTime or 0

    local IsHoldingHand = Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)
                          and Player:GetItemState() == mod.Collectibles.THE_HAND


    if IsHoldingHand then

        PData.REG_HandHoldTime = math.max(1, PData.REG_HandHoldTime + 1)

        if PData.REG_HandHoldTime == MAX_HOLD_TIME + mod.HOLD_THRESHOLD then

            UseHandyCards(Player)

            Player:AnimateCollectible(mod.Collectibles.THE_HAND, "HideItem")
            Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)

            PData.REG_HandHoldTime = -1
        end

    elseif PData.REG_HandHoldTime < 0 then --disappearing

        PData.REG_HandHoldTime = PData.REG_HandHoldTime - 1

        if -PData.REG_HandHoldTime > DISAPPEAR_LENGTH+1 then
            PData.REG_HandHoldTime = 0
        end
    else
        PData.REG_HandHoldTime = 0
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

        local Swing = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.HAND_SWING, Player.Position + ShootDirection*Player.Size,
                                 Vector.Zero, Player, 0, 1):ToEffect()

        sfx:Play(SoundEffect.SOUND_SHELLGAME)
        --local Swing = Player:FireKnife(Player, SwingRotation, true, KnifeSubType.PROJECTILE, KnifeVariant.BAG_OF_CRAFTING)

        Swing:FollowParent(Player)

        Swing.SpriteRotation = SwingRotation
        Swing.SpriteScale = Player.SpriteScale
        Swing:GetSprite():Play("Swing")

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            
            local CardsHeld = 0
            for i,card in ipairs(mod.Saved.Player[Player:GetData().TruePlayerIndex].HandyCards) do
                if card ~= Card.CARD_NULL then
                    CardsHeld = CardsHeld + 1
                end
            end

            local BaseVelocity = Player:GetTearMovementInheritance(ShootDirection) 

            for i=1, CardsHeld do
                
                local Wisp = Player:AddWisp(mod.Collectibles.THE_HAND, Swing.Position + BaseVelocity)
                --Wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR) wisps are invisible if the flag is cleared, don't really like how it looks but idfk dude

                local Jiggle = 2*(CardsHeld)
                Wisp.Velocity = ShootDirection:Rotated(math.random(-Jiggle,Jiggle))
                Wisp.Velocity = Wisp.Velocity:Resized(BASE_WISP_VELOCITY + math.random()*4)

                Wisp.SpriteRotation = Wisp.Velocity:GetAngleDegrees()-90

                Wisp.SpriteOffset = Vector(0, -WISP_HEIGHT_OFFSET) 
                                    + WISP_HEIGHT_OFFSET*(Wisp.Velocity:Normalized())

                Wisp.FireCooldown = math.random(15, 30)
            end
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, HandInputs)



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
            Pickup:GetData().REG_HandPicked = true
            
            local AnimLength = CardSprite:GetAnimationData("Collect"):GetLength()

            Game:GetHUD():ShowItemText(mod:GetConsumableName(Pickup.SubType), "You better play it well!")

            Isaac.CreateTimer(function ()
                Pickup:Remove()
            end, AnimLength-7, 1, false)

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
                
                    Pickup:TryOpenChest(Player)
                end

                Pickup:AddVelocity((Pickup.Position - Player.Position):Resized(7.5))

            elseif mod:Contained(PUSH_VARIANTS, Pickup.Variant) then

                Pickup:AddVelocity((Pickup.Position - Player.Position):Resized(7.5))

            elseif Pickup.Variant == PickupVariant.PICKUP_PILL then

                local Sprite = Pickup:GetSprite()
                local AnimLength = Sprite:GetAnimationData("Collect"):GetLength()

            
                Pickup:PlayPickupSound()
                Sprite:Play("Collect", true)

                Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                Player:AddPill(Pickup.SubType)

                Pickup:GetData().REG_HandPicked = true

                Isaac.CreateTimer(function ()
                    Pickup:Remove()
                end, AnimLength-7, 1, false)

            elseif Pickup.Variant == PickupVariant.PICKUP_TRINKET then

                local Sprite = Pickup:GetSprite()
                local AnimLength = Sprite:GetAnimationData("Collect"):GetLength()

                Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                Pickup:PlayPickupSound()
                Sprite:Play("Collect", true)


                local HasRoom = false

                for i=0, Player:GetMaxTrinkets()-1 do
                    if Player:GetTrinket(i) == TrinketType.TRINKET_NULL then
                        HasRoom = true
                        break
                    end
                end

                if not HasRoom then
                    Player:DropTrinket(Player.Position, false)
                end

                mod.Saved.Player[Player:GetData().TruePlayerIndex].LastTouchedTrinket = Pickup.SubType
                Player:AddTrinket(Pickup.SubType & ~mod.EditionFlag.ALL)

                Pickup:GetData().REG_HandPicked = true

                Isaac.CreateTimer(function ()
                    Pickup:Remove()
                end, AnimLength-7, 1, false)

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



    local HandDamage = Player.SpriteScale.X*3.5 + 4

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH) then
        
        HandDamage = HandDamage + 0.25*(mod.Saved.DebtAmount==0 and Player:GetNumCoins() or 0)
    end
    --if Player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_HEELS) then
        
        --HandDamage = HandDamage + 12
    --end
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) then

        HandDamage = HandDamage * 2
    end


    for i,Enemy in ipairs(Isaac.FindInCapsule(CollisionCapsule, EntityPartition.ENEMY)) do

        local EnemyHash = GetPtrHash(Enemy)

        if Enemy:IsActiveEnemy() and not mod:Contained(EffectData.HandHitList, EnemyHash) then

            EffectData.HandHitList[#EffectData.HandHitList+1] = EnemyHash
            sfx:Play(SoundEffect.SOUND_PUNCH)

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) then
                    
                Enemy:AddKnockback(EntityRef(Player), (Enemy.Position - Player.Position):Resized(12), 100, true)
            else
                Enemy.Velocity = Enemy.Velocity * 0.6
                Enemy:AddVelocity((Enemy.Position - Player.Position):Resized(9.5))
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

    
    local RENDER_MULT = Player:GetPlayerIndex()%2 == 1 and -1 or 1 --either goes from left to right or vice versa


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

        else --crazy how I need to use 2 XMLnodes just to get a card's back

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


local function ChargeBar(_, Offset, HeartSprite, Position,_, Player)

    if not Player:HasCollectible(mod.Collectibles.THE_HAND) then
        return
    end

    local HoldTime = Player:GetData().REG_HandHoldTime or 0

    
    if HoldTime > 0 then --charging up to use the cards

        if HoldTime < mod.HOLD_THRESHOLD then
            return
        end

        HoldTime = HoldTime - mod.HOLD_THRESHOLD + 1


        local Frame = math.floor((HoldTime/MAX_HOLD_TIME)*CHARGE_LENGTH)

        HandChargeBar:Play("Charging", true)
        HandChargeBar:SetFrame("Charging", Frame)

        HandChargeBar:Render(Isaac.WorldToScreen(Player.Position))
        
    elseif HoldTime < 0 then

        local Frame = -HoldTime - 1

        HandChargeBar:SetFrame("Disappear", Frame)
        HandChargeBar:Render(Isaac.WorldToScreen(Player.Position))
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, ChargeBar)



--to be sure the used pickups don't remain after exiting the room too soon
local function RemoveUnwantedPickups()

    for i, Pickup in ipairs(Isaac.FindByType(5)) do

        if Pickup:GetData().REG_HandPicked then
            Pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, RemoveUnwantedPickups)


local function RemoveWisps()

    for i, Pickup in ipairs(Isaac.FindByType(3, FamiliarVariant.WISP, mod.Collectibles.THE_HAND)) do
        Pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, RemoveWisps)



---@param Wisp EntityFamiliar
local function WispUpdate(_, Wisp)

    if Wisp.SubType ~= mod.Collectibles.THE_HAND then
        return
    end

    Wisp.CollisionDamage = 3.5 --apparently needs to be forced every update

    Wisp.FireCooldown = Wisp.FireCooldown - 1

    Wisp.Velocity = Wisp.Velocity*0.95

    if Wisp.FireCooldown <= 0 then
        Wisp:Kill()
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, WispUpdate, FamiliarVariant.WISP)

---@param Wisp EntityFamiliar
local function WispDeath(_, Wisp)

    if Wisp.Variant ~= FamiliarVariant.WISP
       or Wisp.SubType ~= mod.Collectibles.THE_HAND then
        return
    end

    sfx:AdjustVolume(SoundEffect.SOUND_STEAM_HALFSEC, 0.33)
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, WispDeath, EntityType.ENTITY_FAMILIAR)




local DOUBLE_HAND_COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/double_hand_costume.anm2")

local HAND_COSTUME_SCHOOL = Isaac.GetCostumeIdByPath("gfx/characters/hand_schoolbag_costume.anm2")
local DOUBLE_HAND_COSTUME_SCHOOL = Isaac.GetCostumeIdByPath("gfx/characters/double_hand_schoolbag_costume.anm2") --made this cause player is most likerly to get 2 copies through schoolbag


---@param Player EntityPlayer
local function CostumeHandle1(_, Item, _, _,_, VarData, Player)

    if Item ~= mod.Collectibles.THE_HAND
       and Item ~= CollectibleType.COLLECTIBLE_SCHOOLBAG then
        return
    end

    local NumHands = Player:GetCollectibleNum(mod.Collectibles.THE_HAND, true)

    if NumHands > 1 then

        if Player:IsItemCostumeVisible(ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG), PlayerSpriteLayer.SPRITE_BODY) then
            
            Player:AddNullCostume(DOUBLE_HAND_COSTUME_SCHOOL)
            Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME)
        else
            Player:AddNullCostume(DOUBLE_HAND_COSTUME)
            Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME_SCHOOL)
        end
        
    else

        if NumHands == 1
           and Player:IsItemCostumeVisible(ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG), PlayerSpriteLayer.SPRITE_BODY) then
            
            Player:AddNullCostume(HAND_COSTUME_SCHOOL)
        end

        Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME)
        Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME_SCHOOL)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, CostumeHandle1)

local function CostumeHandle2(_,Player, Item)

    if Item ~= mod.Collectibles.THE_HAND
       and Item ~= CollectibleType.COLLECTIBLE_SCHOOLBAG then
        return
    end

    local NumHands = Player:GetCollectibleNum(mod.Collectibles.THE_HAND, true)

    if NumHands > 1 then

        if Player:IsItemCostumeVisible(ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG), PlayerSpriteLayer.SPRITE_BODY) then
            
            Player:AddNullCostume(DOUBLE_HAND_COSTUME_SCHOOL)
            Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME)
        else
            Player:AddNullCostume(DOUBLE_HAND_COSTUME)
            Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME_SCHOOL)
        end
    else

        if NumHands == 1
           and Player:IsItemCostumeVisible(ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG), PlayerSpriteLayer.SPRITE_BODY) then
            
            Player:AddNullCostume(HAND_COSTUME_SCHOOL)
        else
            Player:TryRemoveNullCostume(HAND_COSTUME_SCHOOL)
        end

        Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME)
        Player:TryRemoveNullCostume(DOUBLE_HAND_COSTUME_SCHOOL)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, CostumeHandle2)

