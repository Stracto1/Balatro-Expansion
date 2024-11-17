local mod = Balatro_Expansion
local JimboCards = {BaseCards = Sprite()
}
JimboCards.BaseCards:Load("gfx/ui/HUD/BaseCards.anm2", true)

local ENHANCEMENTS_ANIMATIONS = {"Base"}
local DISCARD_MAX_COOLDOWN = 75

local WasTheHandHeld = false
local IsHoldingCard = false --used to determine the effect of The Hand item
local HandHoldingFrames = 0

local sfx = SFXManager()
local DiscardChargeSprite = Sprite("gfx/chargebar.anm2")
local HandChargeSprite = Sprite("gfx/chargebar.anm2")

do
    --SETS THE COLOR FOR THE DISCARD CHARGE BAR
    local DiscardProgressBar = DiscardChargeSprite:GetLayer(1)
    
    ---@diagnostic disable-next-line: need-check-nil
    local BarColor = DiscardProgressBar:GetColor()
    BarColor.BO = -1
    BarColor.GO = -0.8
    BarColor.RO = 1

    ---@diagnostic disable-next-line: need-check-nil
    DiscardProgressBar:SetColor(BarColor)
    DiscardChargeSprite.Offset = Vector(-20,-20)

    --SETS THE COLOR FOR THE HAND CHARGE BAR
    local HandProgressBar = HandChargeSprite:GetLayer(1)

    ---@diagnostic disable-next-line: need-check-nil
    BarColor = HandProgressBar:GetColor()
    BarColor.BO = 0.9
    BarColor.GO = -0.3
    BarColor.RO = -1

    ---@diagnostic disable-next-line: need-check-nil
    HandProgressBar:SetColor(BarColor)
    HandChargeSprite.Offset = Vector(20,-20)
end


--local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
--local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root
local Game = Game()
local ItemPool = Game:GetItemPool()

--renders the deck overlay and replaces the hearts
---@param Player EntityPlayer
function mod:PlayerHeartsRender(_,HeartSprite,Position,HasCoTU,Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        --local Pindex = Player:GetPlayerIndex()

        ----DECK RENERING----
        JimboCards.BaseCards.Scale = Vector.One
        for i=0, 2, 1 do
            local Card = TrinketValues.FullDeck[TrinketValues.DeckPointer + i]
            if Card then
                JimboCards.BaseCards.Offset = Vector(85 + 17 * i, 0)
                --SEE THE anm2 FILE TO UNDERSTAND BETTER THIS PART--
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
                -------------------------------------------------------------
                JimboCards.BaseCards.Color.A = JimboCards.BaseCards.Color.A / (i+1) --reduces the transparency based on its order position
                
                --JimboCards.BaseCards:Render(Isaac.WorldToRenderPosition(Player.Position))
                JimboCards.BaseCards:Render(Position)
                JimboCards.BaseCards.Color:Reset()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.PlayerHeartsRender)


--renders the CurrentHand table as cards on top of the active
function mod:OnJimboPocketRender(Player,ItemSlot,Position,_,Scale)
    if ItemSlot == ActiveSlot.SLOT_PRIMARY then
        ----HAND RENDERING----
        JimboCards.BaseCards.Scale = Vector(0.8,0.8) * Scale

        if Scale < 1 then --scale is lower if it's in a seconary slot
            JimboCards.BaseCards.Color.A = 0.5
        end
        for i=1, 5, 1 do --cycles between cards the plyer's hand
            local Card = TrinketValues.FullDeck[TrinketValues.CurrentHand[i]]
            if Card then
                JimboCards.BaseCards.Offset = Vector(-30 + 13 * i, -15) * Scale
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the suit of the rendered card
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit-1) --sets the value of the randered card

                JimboCards.BaseCards:Render(Position)
            end
        end
        JimboCards.BaseCards.Color:Reset()
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.OnJimboPocketRender)


---@param player EntityPlayer
function mod:GiveCostumesOnInit(player)
    if player:GetPlayerType() == mod.Characters.JimboType then
        local Data = player:GetData()
        Data.DiscardCooldown = 0
        ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.GiveCostumesOnInit)


--code for using The Hand
---@param player EntityPlayer
function mod:TheHandUse(_,_, player, _,_,_)
    if player:GetPlayerType() == mod.Characters.JimboType then
        Isaac.CreateTimer(function()
            if HandHoldingFrames < 5 then --the button got released (add card to hand)
                if IsHoldingCard and TrinketValues.DeckPointer <= #TrinketValues.FullDeck then
                    --jimbo is already holding up a card
                    mod:AddCardToHand(TrinketValues.CurrentHand, TrinketValues.DeckPointer-1)
                    player:AnimatePickup(player:GetHeldSprite(), true, "HideItem")
                end

            else--player has held down the button (use the cards in hand)
                --print("should use hand")
                WasTheHandHeld = true
                player:AnimateCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
            end
        end, 6, 1, true)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHandUse, CollectibleType.COLLECTIBLE_THE_HAND)


--handles the charge bar and the isHoldingCard variable basin on the player's animation
---@param Player EntityPlayer
function mod:OnJimboRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    --print(PlayerAnimation)
    --[[if not (PlayerAnimation == "PickupWalkDown" or PlayerAnimation == "PickupWalkUp" or PlayerAnimation == "PickupWalkLeft" or PlayerAnimation == "PickupWalkRight") then
        print("not holding")
        --IsHoldingCard = false
    end]]--

    local activeItemID = Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    if activeItemID == CollectibleType.COLLECTIBLE_THE_HAND then --if that pocketactive is the hand

        if Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
            HandHoldingFrames = HandHoldingFrames + 1
            if WasTheHandHeld then
                if HandHoldingFrames == 50 then --activates
                    mod:DeterminePokerHand(TrinketValues.CurrentHand)
                    TrinketValues.CurrentHand = {0,0,0,0,0}
                    Player:AnimateHappy()
                    sfx:Play(SoundEffect.SOUND_1UP)
                    WasTheHandHeld = false
                else
                    HandChargeSprite:SetAnimation("Charging")
                    HandChargeSprite:SetFrame(HandHoldingFrames * 2)
                    
                    HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
                    
                end
            end
        else
            HandHoldingFrames = 0
            WasTheHandHeld = false
        end
    end

    --0 ~ 75 --progress bar is charging
    --75 ~ 86 -- initial animation for fully charged bar
    --86 ~ XX -- fully charged loop
    local Data = Player:GetData()
    if Data.DiscardCooldown < DISCARD_MAX_COOLDOWN then --charging frames needed

        DiscardChargeSprite:SetAnimation("Charging")
        DiscardChargeSprite:SetFrame(math.floor(Data.DiscardCooldown * 1.33))
    elseif Data.DiscardCooldown < DISCARD_MAX_COOLDOWN + 11 then --Charging frames + StartCharged frames
        DiscardChargeSprite:SetAnimation("StartCharged")
        DiscardChargeSprite:SetFrame(Data.DiscardCooldown - DISCARD_MAX_COOLDOWN)
    else
        DiscardChargeSprite:SetAnimation("Charged")
        DiscardChargeSprite:SetFrame(Data.DiscardCooldown - (DISCARD_MAX_COOLDOWN + 16))
    end

    DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.OnJimboRender)


--allows jimbo to shoot
---@param Player EntityPlayer
function mod:OnJimboUpdate(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local Data = Player:GetData()

        if Data.DiscardCooldown <= 91 then
            Data.DiscardCooldown = Data.DiscardCooldown + 1
        else
            Data.DiscardCooldown = 86
        end
        
        local AimDirection = Player:GetAimDirection()
        
        --if the player is aiming in any direction and the cooldown is reached
        if Data.DiscardCooldown >= 75 and (AimDirection.X ~= 0 or AimDirection.Y ~= 0) then
            Data.DiscardCooldown = 0
            
            local ShotParams = Player:GetMultiShotParams()

            local MaxSpread = ShotParams:GetSpreadAngle(WeaponType.WEAPON_TEARS) --half the total angle the tears spread 
            local EyeAngle = ShotParams:GetMultiEyeAngle() --angle used to determine if player has Wiz or not
            local NumTears = ShotParams:GetNumTears() --tears the player fires simultaneusly

            print(MaxSpread)
            print(EyeAngle)
            print(NumTears)
            local Spread = (MaxSpread / (ShotParams:GetNumLanesPerEye() - 1)) * 2

            if EyeAngle == 45 then --if player has the wiz
                for i=1,-1,-2 do 
                    local BaseAngle = EyeAngle * i --sets +45° and -45° as the base angle

                    for j=0, NumTears/2 -1 do --for each eye
                        --modifies additionally the angle if you also have stuff like QuadShot
                        local FireAngle = (BaseAngle+(MaxSpread - Spread*j)) + AimDirection:GetAngleDegrees()
                        local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10
                        Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
                    end
                end
            else
                for i=0, NumTears-1 do
                    local FireAngle = (MaxSpread - Spread*i) + AimDirection:GetAngleDegrees()
                    local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10
                    Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
                end
            end
            TrinketValues.DeckPointer = TrinketValues.DeckPointer + 1
            --Player:AnimatePickup(Player:GetHeldSprite(), true, "HideItem")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnJimboUpdate)


--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local HandRNG = Player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
        TrinketValues.FullDeck = mod:Shuffle(TrinketValues.FullDeck, HandRNG)
        TrinketValues.DeckPointer = 1
        TrinketValues.CurrentHand = {0,0,0,0,0}
    end 
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.FullDeckShuffle)


---@param RoomConfig RoomConfigRoom
function mod:FloorModifier(_,RoomConfig,Seed)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) and RoomConfig.Type == RoomType.ROOM_TREASURE or RoomConfig.Type == RoomType.ROOM_SHOP then
        --varies a bit the "quality" of the shop used
        local RoomRNG = RNG(Seed)
        local ChosenSubType = RoomRNG:RandomInt(RoomSubType.SHOP_KEEPER_LEVEL_3-1, RoomSubType.SHOP_KEEPER_LEVEL_5)
        
        local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ChosenSubType)

        return NewRoom --replaces the room with the new one
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, mod.FloorModifier)


--repleaces all the tears shot by jimbo with cards/stuff
---@param Tear EntityTear
function mod:OnJimboShoot(Tear)
    local Player = Tear.Parent:ToPlayer()
    local Incubus = Tear.Parent:ToFamiliar()
    print(Player:GetMultiShotParams():GetSpreadAngle(WeaponType.WEAPON_TEARS))
    if Tear.SpawnerType == EntityType.ENTITY_PLAYER then
        --print("from player")
    end
    if Incubus then
        --print("Incubus")
    end
    if Player then
       -- print("player")
    end


    if Player and Player:GetPlayerType() == mod.Characters.JimboType then
        --damage dealt = Damage * TearRate of the player
        Tear.CollisionDamage = Player.Damage * mod:CalculateTearsValue(Player)

        local TearSuit = TrinketValues.FullDeck[TrinketValues.DeckPointer].Suit
        Tear:ChangeVariant(mod.CARD_TEAR_VARIANTS[TearSuit])

        if TearSuit == mod.Suits.Spade then --SPADES
            Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        elseif TearSuit == mod.Suits.Diamond then
            Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
            Tear:AddTearFlags(TearFlags.TEAR_BOUNCE)
        end
        local TearSprite = Tear:GetSprite()
        TearSprite:Play("Base", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.OnJimboShoot)

---@param Tear EntityTear
function mod:test(Tear)
    if Tear.SpawnerType == EntityType.ENTITY_TEAR and mod:Contained(mod.CARD_TEAR_VARIANTS, Tear.SpawnerVariant) then
        --print("spawned from a tear")
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.test)

--applies the additional effects for the card tears
---@param Tear EntityTear
---@param Collider Entity
function mod:OnCardCollision(Tear,Collider,_)
    if not mod:Contained(mod.CARD_TEAR_VARIANTS, Tear.Variant) then
        return
    end

    if Collider:IsActiveEnemy() then
        local TearRNG = Tear:GetDropRNG()
        if Tear.Variant == mod.CARD_TEAR_VARIANTS[mod.Suits.Heart] then --Hearts
            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Tear.Position, Vector.Zero, Tear, 0, TearRNG:GetSeed()):ToEffect()
            Creep.SpriteScale = Vector(1.2,1.2)
            ---@diagnostic disable-next-line: need-check-nil
            Creep:Update()
            if TearRNG:RandomFloat() < 0.2 then
                Collider:AddCharmed(EntityRef(Tear.Parent), 120)
            end
        end
        if Tear.Variant == mod.CARD_TEAR_VARIANTS[mod.Suits.Club] then --Clubs
            if TearRNG:RandomFloat() < 0.2 then
                Game:BombExplosionEffects(Tear.Position, Tear.CollisionDamage / 2, TearFlags.TEAR_NORMAL, Color.Default, Tear.Parent, 0.5)
                --Isaac.Explode(Tear.Position, Tear, Tear.CollisionDamage / 2)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.OnCardCollision)


--adjusts the card rotation basing on its direction of movement every few frames
---@param Tear EntityTear
function mod:OnCardTearRender(Tear)
    local Data = Tear:GetData()
    local TearSprite = Tear:GetSprite()

    if not Data.Counter then
        Data.Counter = 2
    end
    if Data.Counter == 2 then
        TearSprite.Rotation = Tear.Velocity:GetAngleDegrees()
        --TearSprite.Rotation = math.deg(math.atan(Tear.Velocity.Y,Tear.Velocity.X))
        Data.LastRotation = TearSprite.Rotation
        Data.Counter = 0
    else
        TearSprite.Rotation = Data.LastRotation
        Data.Counter = Data.Counter + 1
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.OnCardTearRender, mod.CARD_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.OnCardTearRender, mod.CARD_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.OnCardTearRender, mod.CARD_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.OnCardTearRender, mod.CARD_TEAR_VARIANTS[mod.Suits.Diamond])

---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboBaseStats(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        --Player.Damage = Player.Damage / 2
        Player.Damage = Player.Damage - 2.5
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        --Player.MaxFireDelay = Player.MaxFireDelay - 1
        Player.MaxFireDelay = Player.MaxFireDelay - 0.5
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboBaseStats)


---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboMinimumStats(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    local Tears = mod:CalculateTearsValue(Player)
    --print(mod:CalculateMaxFireDelay(Tears))
    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        if Player.Damage < 0.5 then
            Player.Damage = 0.5
        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.Damage = 4.5 / Tears
        end]]--
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        if Tears < 2.5 then
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(2.5)

        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.MaxFireDelay =  mod:CalculateMaxFireDelay(4.5 / Player.Damage)
        end]]--
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.JimboMinimumStats)
