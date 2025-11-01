---@diagnostic disable: need-check-nil, cast-local-type, param-type-mismatch
local mod = Balatro_Expansion
local Game = Game()
local sfx = SFXManager()
--code here apllies all the needed synergies to the characters

---@param Tear EntityTear
---@param Collider Entity
local function OnCardHit(_,Tear,Collider)

    local Player = Tear.Parent:ToPlayer()

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local TearData = Tear:GetData()
    TearData.CollidedWith = TearData.CollidedWith or {}

    local Projectile = Collider:ToProjectile()

    if Projectile then 

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT)
           and not Tear:HasTearFlags(TearFlags.TEAR_SHIELDED) then --made so cards can't disappear (suit tears can tho)
            
           Projectile:Kill()
        end
    end

    --print(Collider.Type, Collider.Variant, Collider.SubType)

    if not Collider:IsActiveEnemy() then return end


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then

        local KnifeDamage = Tear.CollisionDamage * 0.3

        Collider:TakeDamage(KnifeDamage, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(Tear), 2)
    end
    if Player:HasCollectible(CollectibleType.COLLECTIBLE_TRISAGION) then

        local TriDamage = Tear.CollisionDamage * 0.2

        Collider:TakeDamage(TriDamage, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(Tear), 3)
    end

    --if mod:Contained(TearData.CollidedWith, GetPtrHash(Collider)) then return end

    local TearRNG = Tear:GetDropRNG()


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then

        local Amount = mod:IsSuit(Player, TearData.Params, mod.Suits.Spade, false) and 2 or 1

        for i = 1, Amount do

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

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH)
       and TearData.Params.Enhancement == mod.Enhancement.GOLDEN then
        Collider:AddMidasFreeze(EntityRef(Player), 120)
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_GREED)
       and mod:IsSuit(Player, TearData.Params, mod.Suits.Diamond) then
        Collider:AddMidasFreeze(EntityRef(Player), 120)
    end


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then
        
        if mod:IsSuit(Player, TearData.Params, mod.Suits.Diamond, false) then
            
            local Coins = Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)

            for i=1, Coins do
                
                local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Tear.Position, Vector.Zero, Player, CoinSubType.COIN_PENNY, mod:RandomSeed(TearRNG)):ToPickup()

                Coin.Timeout = 50
            end 
        end
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)
       and TearData.Params.Enhancement == mod.Enhancement.GLASS then
        
        Collider:AddBleeding(Player, 90)
    end
end
mod:AddCallback("CARD_HIT", OnCardHit)


---@param Player EntityPlayer
function mod:ActiveItemsNewEffect(Type, ItemRNG, Player, Flags)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Type == CollectibleType.COLLECTIBLE_SMELTER then
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY,
                                                      mod.SelectionParams.Purposes.SMELTER)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ActiveItemsNewEffect)


function ActiveMaxCharge(_, Type, Player, CurrentMax)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    if Type == CollectibleType.COLLECTIBLE_MOMS_BOX then
        return 12
    end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, ActiveMaxCharge)


function mod:OnShopRestock(Partial)

    if Partial then
        return
    end
    local DidSomething = false --needs to reroll an item to work

    for i,Pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP,-1,-1, true)) do
        if Pickup:ToPickup():IsShopItem() or Pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            DidSomething = true
            break
        end
    end

    if not DidSomething then
        return
    end


    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        for Slot=0, ActiveSlot.SLOT_SECONDARY do
            
            if Player:GetActiveItem(Slot) == CollectibleType.COLLECTIBLE_MOMS_BOX then
                
                Player:AddActiveCharge(2, Slot, true, false, true)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnShopRestock)



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

    elseif Type == CollectibleType.COLLECTIBLE_BINGE_EATER then
        for Index,_ in ipairs(mod.Saved.Player[PIndex].FullDeck) do
            mod.Saved.Player[PIndex].FullDeck[Index].Suit = mod.Suits.Heart
        end

    elseif Type == CollectibleType.COLLECTIBLE_HEART
           or Type == CollectibleType.COLLECTIBLE_C_SECTION
           or Type == CollectibleType.COLLECTIBLE_BLOOD_BOMBS then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Heart
        end

    elseif Type == CollectibleType.COLLECTIBLE_QUARTER
           or Type == CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER
           or Type == CollectibleType.COLLECTIBLE_EYE_OF_GREED then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Diamond
        end

    elseif Type == CollectibleType.COLLECTIBLE_PYROMANIAC or Type == CollectibleType.COLLECTIBLE_BOOM 
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
           or Type == CollectibleType.COLLECTIBLE_BRIMSTONE then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            mod.Saved.Player[PIndex].FullDeck[Pointer].Suit = mod.Suits.Spade
        end

    elseif Type == CollectibleType.COLLECTIBLE_TMTRAINER then
        for Index,Card in ipairs(mod.Saved.Player[PIndex].FullDeck) do

            local Seed = mod:PlayingCardParamsToSubType(Card)

            mod.Saved.Player[PIndex].FullDeck[Index] = mod:RandomPlayingCard(Seed, false)

            Player:PlayExtraAnimation("Glitch")
        end


    elseif Type == CollectibleType.COLLECTIBLE_FRUIT_CAKE
           or Type == CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE then

        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

            if mod.Saved.Player[PIndex].FullDeck[Pointer].Enhancement == mod.Enhancement.NONE then
                mod.Saved.Player[PIndex].FullDeck[Pointer].Enhancement = mod.Enhancement.WILD
            end
        end

    elseif Type == CollectibleType.COLLECTIBLE_GODHEAD then

        local Spades = {}

        for i = #mod.Saved.Player[PIndex].FullDeck, 1, -1 do

            local Card = mod.Saved.Player[PIndex].FullDeck[i]

            if Card.Suit == mod.Suits.Spade
               and Card.Enhancement ~= mod.Enhancement.WILD
               and Card.Enhancement ~= mod.Enhancement.STONE then

                Spades[#Spades+1] = i

            elseif Card.Enhancement == mod.Enhancement.NONE then

                mod.Saved.Player[PIndex].FullDeck[i].Enhancement = mod.Enhancement.WILD
            end
        end

        mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Clensed!", mod.EffectType.ENTITY, Player)

        mod:DestroyCards(Player, Spades, true, false)

    elseif Type == mod.Collectibles.POCKET_ACES then

        local AceRNG = Player:GetCollectibleRNG(mod.Collectibles.POCKET_ACES)

        for i=1, 2 do
            
            local Ace = mod:RandomPlayingCard(AceRNG, true, 1, nil, -1, -1, -1)

            mod:AddCardToDeck(Player, Ace, 1, true)
        end

    else
        Any = false
    end

    if Any then
        Isaac.RunCallback("DECK_MODIFY", Player, 0)
    end


    if Type == CollectibleType.COLLECTIBLE_CRYSTAL_BALL then

        if mod:JimboHasTrinket(Player, mod.Jokers.ROCKET) then
        
            Player:AddInnateCollectible(mod.Vouchers.Crystal)
            table.insert(mod.Saved.Player[PIndex].InnateItems.General, mod.Vouchers.Crystal)

        --checks if the player has an innate collectible to remove
        elseif mod:Contained(mod.Saved.Player[PIndex].InnateItems.General, mod.Vouchers.Crystal) then

            Player:AddInnateCollectible(mod.Vouchers.Crystal, -1)
            table.remove(mod.Saved.Player[PIndex].InnateItems.General, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.General,mod.Vouchers.Crystal,true))
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)


---@param Tear EntityTear
function mod:SpadeOpenDoor(Tear, Index, Grid)

    local Data = Tear:GetData()
    local Player = Tear.Parent and Tear.Parent:ToPlayer() or nil

    if not Player or not Grid then
        return
    end

    if Player:GetPlayerType() ~= mod.Characters.JimboType
       or not Player:HasCollectible(CollectibleType.COLLECTIBLE_SHARP_KEY)
       or not mod:IsSuit(Player, Data.Params, mod.Suits.Spade) then
        
        return
    end

    Grid = Grid:ToDoor()

    if Grid and (Grid:IsLocked() or Grid:CanBlowOpen()) then

        ---@diagnostic disable-next-line: param-type-mismatch
        Grid:TryUnlock(Player, true)
    end
end
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, mod.SpadeOpenDoor, mod.CARD_TEAR_VARIANT)
mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, mod.SpadeOpenDoor, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])

---@param Tear EntityTear
function mod:OnCardDeath(Tear)

    local Data = Tear:GetData()


    local Player = Tear.Parent and Tear.Parent:ToPlayer() or nil

    if not Player then
        Player = Tear.SpawnerEntity and Tear.SpawnerEntity:ToPlayer() or nil
    end

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then

        mod.TearCardEnable = false
        mod.Counters.SinceShoot = 0

        local FetusNum = (mod:IsSuit(Player, Data.Params, mod.Suits.Heart) and 2 or 1) * Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_C_SECTION)
        
        for i=1, FetusNum do
            local Fetus = Player:FireTear(Tear.Position, RandomVector() * 4, false, true, false, Tear)
            Fetus:ChangeVariant(TearVariant.FETUS)
            Fetus:AddTearFlags(TearFlags.TEAR_FETUS) --aparently i need to give the fetus propreties
            
            Fetus.CollisionDamage = Tear.CollisionDamage / 2
        end
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_KEEPERS_KIN) then

        local SpiderNum = math.random(1,3) * Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_KEEPERS_KIN)
    
        for i=1, SpiderNum do
            Player:AddBlueSpider(Tear.Position)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.OnCardDeath, mod.CARD_TEAR_VARIANT)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.OnCardDeath, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.OnCardDeath, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.OnCardDeath, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.OnCardDeath, mod.Tears.SUIT_TEAR_VARIANTS[mod.Suits.Diamond])


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

    local CardParams = TearData.Params

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


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then

        Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING)

    elseif Player:HasCollectible(CollectibleType.COLLECTIBLE_TRISAGION) then

        Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_IRON_BAR)
       and CardParams.Enhancement == mod.Enhancement.STEEL then
        Tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
       or Player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
       and TearData.Params.Enhancement == mod.Enhancement.WILD then
        
        local EffectCount = math.random(0,1) + Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
                                             + Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)

        local Effects = {}

        for i=1, math.min(10, EffectCount) do
            
            local Effect

            repeat
                Effect = mod:TEARFLAG(math.random(TearFlags.TEAR_EFFECT_COUNT-1))
            until not mod:Contained(Effects, Effect)

            Tear:AddTearFlags(Effect)
            Effects[#Effects+1] = Effect
        end
    end

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_3_DOLLAR_BILL)
       and mod:IsValue(Player, CardParams, 3) then
        
        local EffectCount = 3 + Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_3_DOLLAR_BILL)

        local Effects = {}

        for i=1, math.min(10, EffectCount) do
            
            local Effect

            repeat
                Effect = mod:TEARFLAG(math.random(TearFlags.TEAR_EFFECT_COUNT-1))
            until not mod:Contained(Effects, Effect)

            Tear:AddTearFlags(Effect)
            Effects[#Effects+1] = Effect
        end
    end


    if Player:HasCollectible(CollectibleType.COLLECTIBLE_SHARD_OF_GLASS)
       and CardParams.Enhancement == mod.Enhancement.GLASS then
        Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
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
