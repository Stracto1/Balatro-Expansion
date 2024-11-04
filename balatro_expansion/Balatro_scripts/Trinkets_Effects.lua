---------------------CACHE EVALUATION CALLBACKS---------------------
--------------------------------------------------------------------
--these are all the cache evaluations for every trinekt/item
--the functions for non-statup trinkets are also here

local Joker = Isaac.GetTrinketIdByName("Joker")
local Bull = Isaac.GetTrinketIdByName("Bull")
local Invisible_Joker = Isaac.GetTrinketIdByName("Invisible joker")
local Abstract_joker = Isaac.GetTrinketIdByName("Abstract joker")
local Misprint = Isaac.GetTrinketIdByName("Misprint")
local Joker_stencil = Isaac.GetTrinketIdByName("Joker stencil")
local Stone_joker = Isaac.GetTrinketIdByName("Stone joker")
local Icecream = Isaac.GetTrinketIdByName("Ice cream")
local Popcorn = Isaac.GetTrinketIdByName("Popcorn")
local Ramen = Isaac.GetTrinketIdByName("Ramen")
local Rocket = Isaac.GetTrinketIdByName("Rocket")
local Oddtodd = Isaac.GetTrinketIdByName("Odd todd")
local Evensteven = Isaac.GetTrinketIdByName("Even steven")
local Hallucination = Isaac.GetTrinketIdByName("Hallucination")
local Green_joker = Isaac.GetTrinketIdByName("Green joker")
local Red_card = Isaac.GetTrinketIdByName("Red card")
local Vagabond = Isaac.GetTrinketIdByName("Vagabond")
local Riff_raff = Isaac.GetTrinketIdByName("Riff-raff")
local Golden_joker = Isaac.GetTrinketIdByName("Golden joker")
local Fortuneteller = Isaac.GetTrinketIdByName("Fortune Teller")
local Blueprint = Isaac.GetTrinketIdByName("Blueprint")
local Brainstorm = Isaac.GetTrinketIdByName("Brainstorm")
local Smeared_joker = Isaac.GetTrinketIdByName("Smeared joker")
local Madness = Isaac.GetTrinketIdByName("Madness")
local Mr_bones = Isaac.GetTrinketIdByName("Mr. Bones")
local Onix_agate = Isaac.GetTrinketIdByName("Onyx agate")
local Arrowhead = Isaac.GetTrinketIdByName("Arrowhead")
local Bloodstone = Isaac.GetTrinketIdByName("Bloodstone")
local Rough_gem = Isaac.GetTrinketIdByName("Rough gem")
local Gros_michael = Isaac.GetTrinketIdByName("Gros Michel")
local Cavendish = Isaac.GetTrinketIdByName("Cavendish")
local Flash_card = Isaac.GetTrinketIdByName("Flash card")
local Sacrificial_dagger = Isaac.GetTrinketIdByName("Sacrificial dagger")
local Loyalty_card = Isaac.GetTrinketIdByName("Loyalty card")
local Swashbuckler = Isaac.GetTrinketIdByName("Swashbuckler")
local Cloud_nine = Isaac.GetTrinketIdByName("Cloud 9")
local Cartomancer = Isaac.GetTrinketIdByName("Cartomancer")
local Supernova = Isaac.GetTrinketIdByName("Supernova")
local Delayed_gratification = Isaac.GetTrinketIdByName("Delayed gratification")
local Egg = Isaac.GetTrinketIdByName("Egg")
local Dna = Isaac.GetTrinketIdByName("Dna")

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local ItemPool = Game:GetItemPool()

-------------------Joker------------------------
function Balatro_Expansion:Joker(player, _)

    if player.HasTrinket(player, Joker) then --controls if it has the trinket
        local JokerDMG = 0.5 --base dmg
        local DMGToAdd = JokerDMG * player.GetTrinketMultiplier(player ,Joker) --scalable DMG up
        if Balatro_Expansion.WantedEffect == Joker then
            --print("effect")
            Balatro_Expansion:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd --flat DMG up
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.Joker, CacheFlag.CACHE_DAMAGE)

------------------bull---------------------------


function Balatro_Expansion:Bull(player, _)
    if player.HasTrinket(player, Bull) then --controls if it has the trinket
        
        local CurrentCoins = player.GetNumCoins(player)  --gets the player's coins
        local BullTears = 0

        if CurrentCoins <= 25 then
            BullTears = 0.04 * CurrentCoins 
        elseif  CurrentCoins <= 50 then
            BullTears = 1 + 0.02 * (CurrentCoins - 25)
        else
            BullTears = 1.50 + 0.01 * (CurrentCoins - 50)
        end
        BullTears = BullTears * player.GetTrinketMultiplier(player ,Bull)
        TearsToAdd = Balatro_Expansion:CalculateTearsUp(player.MaxFireDelay, BullTears)  --scalable tears up
        if Balatro_Expansion.WantedEffect == Bull then
            Balatro_Expansion:EffectConverter(1, BullTears, player, 3)
        end
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd --flat tears up
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.Bull, CacheFlag.CACHE_FIREDELAY)

----------------------------invisible joker------------------------
function Balatro_Expansion:InvisibleJoker(player)
    local Seed = Game:GetSeeds():GetStartSeed() --gets the run's seed
    
    for i = 0, 3, 1 do --checks every consumable slot
        local HeldCard = player.GetCard(player, i)
        local HeldPill = player.GetPill(player, i)

        if HeldCard ~= 0 then  --if player has a card/rune

            for i = 1, player.GetTrinketMultiplier(player, Invisible_Joker), 1 do
                    
                Game:Spawn(EntityType.ENTITY_PICKUP, 300, player.Position , RandomVector() * 3, player, HeldCard, Seed)
            end
            if Balatro_Expansion.WantedEffect == Invisible_Joker then
                Balatro_Expansion:EffectConverter(3, 0, player, 4)
            end
            break --ends the initial FOR early

        elseif  HeldPill ~= 0 then --pills are a different enity to cards so this is also needed
            for i = 1, player.GetTrinketMultiplier(player, Invisible_Joker), 1 do
                    
                Game:Spawn(EntityType.ENTITY_PICKUP, 70, player.Position , RandomVector() * 3, player, HeldPill, Seed)
            end
            if Balatro_Expansion.WantedEffect == Invisible_Joker then
                Balatro_Expansion:EffectConverter(3, 0, player, 4)
            end
            break --ends the initial FOR early

        end
    end
    
end

--------------------------abstract joker--------------------

function Balatro_Expansion:AbstractJoker(player,_)
    if player.HasTrinket(player, Abstract_joker) then
        local AbstractDMG = 0.08
        local NumItems = player.GetCollectibleCount(player)
        local DMGToAdd = (AbstractDMG * NumItems) * player.GetTrinketMultiplier(player, Abstract_joker)
        if Balatro_Expansion.WantedEffect == Abstract_joker then
            Balatro_Expansion:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd 
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.AbstractJoker, CacheFlag.CACHE_DAMAGE)

--------------------------------------misprint----------------------------------------------

function Balatro_Expansion:Misprint(player,_)
    if player.HasTrinket(player, Misprint) then
        if Balatro_Expansion.WantedEffect == Misprint then --basically changes the dmg up only when changing rooms
            local RNG = player:GetTrinketRNG(Misprint)
            local MisprintDMG = 1.5
            local MisprintDMGToAdd = ((MisprintDMG * RNG:RandomFloat()) * player.GetTrinketMultiplier(player, Misprint)) --random float is from 0 to 1
            MisprintDMGToAdd = Balatro_Expansion:round(MisprintDMGToAdd, 2)
            Balatro_Expansion:EffectConverter(1, MisprintDMGToAdd, player, 1)
            player.Damage = player.Damage + MisprintDMGToAdd
            TrinketValues.LastMisprintDMG = MisprintDMGToAdd
            return
        end
        player.Damage = player.Damage + TrinketValues.LastMisprintDMG
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.Misprint, CacheFlag.CACHE_DAMAGE)

-------------------joker stencil-------------------

---@param player EntityPlayer
function Balatro_Expansion:JokerStencil(player,_)
    if player:HasTrinket(Joker_stencil) then
        local JokerStencilMultiplier = 1
        if player.GetPlayerType(player) == PlayerType.PLAYER_ISAAC_B then --specific dmg up for Tisaac
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, true) then
                JokerStencilMultiplier = JokerStencilMultiplier + 0.1 * (13 - player.GetCollectibleCount(player))
            else
                JokerStencilMultiplier = JokerStencilMultiplier + 0.15 * (8 - player.GetCollectibleCount(player))
            end
        end
        if player:GetActiveItem() == CollectibleType.COLLECTIBLE_NULL then --chacks active item slot
            JokerStencilMultiplier = JokerStencilMultiplier + 0.1
        end
        if player:GetNumCoins() == 0 then
            JokerStencilMultiplier = JokerStencilMultiplier + 0.05
        end
        if player:GetNumBombs() == 0 then
            JokerStencilMultiplier = JokerStencilMultiplier + 0.05
        end
        if player:GetNumKeys() == 0 then
            JokerStencilMultiplier = JokerStencilMultiplier + 0.05
        end
        for i = 0, player:GetMaxPocketItems() -1, 1 do --checks every available consumable slot
            if player:GetPocketItem(i):GetSlot() == 0 then  --if the slot is empty
                JokerStencilMultiplier = JokerStencilMultiplier + 0.05
                break
            end
        end
        JokerStencilMultiplier = JokerStencilMultiplier + ((JokerStencilMultiplier - 1) * (player:GetTrinketMultiplier(Joker_stencil) - 1))
        if Balatro_Expansion.WantedEffect == Joker_stencil then
            Balatro_Expansion:EffectConverter(2, JokerStencilMultiplier, player, 2)
        end
        player.Damage = player.Damage * JokerStencilMultiplier
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, Balatro_Expansion.JokerStencil, CacheFlag.CACHE_DAMAGE)

------------------STONE JOKER---------------------

---@param player EntityPlayer
function Balatro_Expansion:StoneJoker(player, _)
    if player.HasTrinket(player, Stone_joker) then --controls if it has the trinket
        local StoneTears = TrinketValues.Stone_joker
        if Balatro_Expansion.WantedEffect == Stone_joker then
            Balatro_Expansion:EffectConverter(1, StoneTears, player, 3)
        end
        local TearsToAdd = Balatro_Expansion:CalculateTearsUp(player.MaxFireDelay, StoneTears)
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd --flat tears up
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.StoneJoker, CacheFlag.CACHE_FIREDELAY)

-----------------ICE CREAM-------------------------
---@param player EntityPlayer
function Balatro_Expansion:IceCream(player, _)
    if player:HasTrinket(Icecream) then
        if TrinketValues.Ice_cream == 0 then
            Balatro_Expansion:EffectConverter(4, 0, player, 6)
            return
        end
        local IceTears = TrinketValues.Ice_cream * player:GetTrinketMultiplier(Icecream)
        if Balatro_Expansion.WantedEffect == Icecream then
            Balatro_Expansion:EffectConverter(1, IceTears, player, 3)
        end
        local TearsToAdd = Balatro_Expansion:CalculateTearsUp(player.MaxFireDelay, IceTears)
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.IceCream, CacheFlag.CACHE_FIREDELAY)

-----------------POPCORN-------------------------
---@param player EntityPlayer
function Balatro_Expansion:Popcorn(player, _)
    if player:HasTrinket(Popcorn) then
        if TrinketValues.Popcorn == 0 then
            Balatro_Expansion:EffectConverter(4, 0, player, 5)
            return
        end
        local PopDamage = TrinketValues.Popcorn * player:GetTrinketMultiplier(Popcorn)
        if Balatro_Expansion.WantedEffect == Popcorn then
            Balatro_Expansion:EffectConverter(1, PopDamage, player, 1)
        end
        player.Damage = player.Damage + PopDamage
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.Popcorn, CacheFlag.CACHE_DAMAGE)

---------------------RAMEN-------------------------
---@param player EntityPlayer
function Balatro_Expansion:Ramen(player, _)
    if player:HasTrinket(Ramen) then
        if TrinketValues.Ramen == 0 then
            Balatro_Expansion:EffectConverter(4, 0, player, 5)
            return
        end
        local RamenMult = TrinketValues.Ramen + ((TrinketValues.Ramen -1 ) * (player:GetTrinketMultiplier(Ramen) - 1))
        if Balatro_Expansion.WantedEffect == Ramen then
            Balatro_Expansion:EffectConverter(2, RamenMult, player, 2)
        end
        player.Damage = player.Damage * RamenMult
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, Balatro_Expansion.Ramen, CacheFlag.CACHE_DAMAGE)

----------------------------ROCKET-----------------------------
---@param player EntityPlayer
function Balatro_Expansion:rocket(player)
    local Seed = Game:GetSeeds():GetStartSeed() --gets the run's seed
    for i = 1, TrinketValues.Rocket , 1 do --checks every consumable slot        
        Game:Spawn(EntityType.ENTITY_PICKUP, 20, player.Position, RandomVector() * 3, player, 1, Seed)
    end
    TrinketValues.Rocket = TrinketValues.Rocket + (2 * player:GetTrinketMultiplier(Rocket))
    Balatro_Expansion:EffectConverter(3, 0, player, 4)
end

--------------------------  EVEN STEVEN---------------------------
---@param player EntityPlayer
function Balatro_Expansion:EvenSteven(player, _)
    if player:HasTrinket(Evensteven) then --controls if it has the trinket
        if player:GetCollectibleCount() % 2 == 0 then
            local StevenDMG = 0.1
            local DMGToAdd = (StevenDMG * player:GetCollectibleCount()) * player:GetTrinketMultiplier(Evensteven) --scalable DMG up
            if Balatro_Expansion.WantedEffect == Evensteven then
                Balatro_Expansion:EffectConverter(1, DMGToAdd, player, 1)
            end
            player.Damage = player.Damage + DMGToAdd --flat DMG up
        else
            if Balatro_Expansion.WantedEffect == Evensteven then    
                Balatro_Expansion:EffectConverter(1, 0, player, 1)
            end
        end
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.EvenSteven, CacheFlag.CACHE_DAMAGE)

------------------------ODD TODD----------------------------
---@param player EntityPlayer
function Balatro_Expansion:OddTodd(player, _)

    if player:HasTrinket(Oddtodd) then --controls if it has the trinket
        if player:GetCollectibleCount() % 2 == 1 then
            local OddTears = 0.07
            local TearsToAdd = (OddTears * player:GetCollectibleCount()) * player:GetTrinketMultiplier(Oddtodd) --scalable DMG up
            if Balatro_Expansion.WantedEffect == Oddtodd then
                Balatro_Expansion:EffectConverter(1, TearsToAdd, player, 3)
            end
            TearsToAdd = Balatro_Expansion:CalculateTearsUp(player.MaxFireDelay, TearsToAdd)
            player.MaxFireDelay = player.MaxFireDelay - TearsToAdd--flat DMG up
        else   
            if Balatro_Expansion.WantedEffect == Oddtodd then
                Balatro_Expansion:EffectConverter(1, 0, player, 3)
            end
        end
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.OddTodd, CacheFlag.CACHE_FIREDELAY)
-----------------------HALLUCINATION------------------------
---@param player EntityPlayer
function Balatro_Expansion:HAllucination(player, cost)
    local Deal = 0
    local Chance = 0.2 + (cost * 0.02)
    if cost < 0 then --devil deal cost
        if cost == PickupPrice.PRICE_SPIKES then
            Chance = 0.3
        elseif cost == PickupPrice.PRICE_FREE then
            Chance = 0.5
            Deal = 1
        else
            Chance = 1
            Deal = 1
        end
    end
    local RNG = player:GetTrinketRNG(Hallucination)
    if RNG:RandomFloat() <= Chance then
        if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
            for i = 1,player:GetTrinketMultiplier(Hallucination) + Deal, 1 do
                local RNG = player:GetTrinketRNG(Hallucination)
                local seed = RNG:GetSeed()
                local Pill = ItemPool:GetPill(seed)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position , RandomVector() * 3, player, Pill, seed)
            end
        else       
            for i = 1,player:GetTrinketMultiplier(Hallucination) + Deal, 1 do
                local RNG = player:GetTrinketRNG(Hallucination)
                local seed = RNG:GetSeed()    
                local Card = ItemPool:GetCard(seed, true, true, false)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, seed)    
            end
        end
            Balatro_Expansion:EffectConverter(3, 0, player, 4)
    end
end
-----------------------VAGABOND---------------------------
---@param player EntityPlayer
function Balatro_Expansion:VAgabond(player)
    local RNG = player:GetTrinketRNG(Vagabond)
    local seed = RNG:GetSeed()
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
        local Pill = ItemPool:GetPill(seed)
        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position , RandomVector() * 3, player, Pill, seed)
    else
        if player:GetTrinketMultiplier(Vagabond) > 1 then
            local Card = ItemPool:GetCard(seed, true, true, false)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, seed)
        else
            local Card = ItemPool:GetCardEx(seed, 0,0,0, false)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, seed)
        end
    end
    Balatro_Expansion:EffectConverter(3, 0, player, 4)   
end
-----------------------GREEN JOKER------------------
function Balatro_Expansion:GreenJoker(player,_)
    if player:HasTrinket(Green_joker) then
        local Damage = TrinketValues.Green_joker 
        if Balatro_Expansion.WantedEffect == Green_joker then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.GreenJoker, CacheFlag.CACHE_DAMAGE)
--------------------RED CARD---------------------
---@param player EntityPlayer
function Balatro_Expansion:RedCard(player,_)
    if player:HasTrinket(Red_card) then
        local Damage = TrinketValues.Red_card * player:GetTrinketMultiplier(Red_card)
        if Balatro_Expansion.WantedEffect == Red_card then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.RedCard, CacheFlag.CACHE_DAMAGE)
--------------------RIFF RAFF----------------------
---@param player EntityPlayer
function Balatro_Expansion:RiffRaff(player)
    local RNG = player:GetTrinketRNG(Riff_raff)
    local PersistentGD = Isaac.GetPersistentGameData()
    local seed = RNG:GetSeed()
    local Item
    local Config
    repeat
        Item = RNG:RandomInt(1, CollectibleType.NUM_COLLECTIBLES) --chooses a compleatly random item
        --print(Item)
        Config = ItemsConfig:GetCollectible(Item)
    until  (Config.Quality <= 0 + player:GetTrinketMultiplier(Riff_raff)) and (PersistentGD:Unlocked(Config.AchievementID))
        
    Balatro_Expansion:EffectConverter(3, 0, player, 4)
    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetFreeNearPosition(player.Position, 50), Vector.Zero, player, Item, seed)
end
-------------------GOLDEN JOKER--------------------
---@param player EntityPlayer
function Balatro_Expansion:Goldenjoker(player)
    local seed = player:GetTrinketRNG(Golden_joker):GetSeed()
    for i = 1, 2 + 2 * player:GetTrinketMultiplier(Golden_joker) do
        Game:Spawn(EntityType.ENTITY_PICKUP, 20, player.Position, RandomVector() * 3, player, 1, seed)
    end
    Balatro_Expansion:EffectConverter(3, 0, player, 4)
end
----------------FORTUNETELLER----------------------
---@param player EntityPlayer
function Balatro_Expansion:FOrtuneteller(player)
    if player:HasTrinket(Fortuneteller) then
        --print("fortune teller")
        local Damage = TrinketValues.Fortune_Teller * player:GetTrinketMultiplier(Fortuneteller)
        if Balatro_Expansion.WantedEffect == Fortuneteller then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.FOrtuneteller, CacheFlag.CACHE_DAMAGE)
-------------------BLUEPRINT--------------------
---@param player EntityPlayer
function Balatro_Expansion:BluePrint(player, Add)
    if TrinketValues.Blueprint == 0 then
        return
    end
    if Add then
        if Balatro_Expansion.WantedEffect == Blueprint then
            Balatro_Expansion:EffectConverter(3, 0, player, 4)
        end
        player:AddCollectible(TrinketValues.Blueprint, 0, false)
    end
    player:RemoveCollectible(TrinketValues.LastBPitem)
    TrinketValues.LastBPitem = TrinketValues.Blueprint
end
------------------BRAINSTORM-----------------------
---@param player EntityPlayer
function Balatro_Expansion:BrainStorm(player, Add)
    if Add and TrinketValues.Brainstorm ~= 0 then
        TrinketValues.FirstBrain = false
        if Balatro_Expansion.WantedEffect == Brainstorm then
            Balatro_Expansion:EffectConverter(3, 0, player, 4)
        end
        player:AddCollectible(TrinketValues.Brainstorm, 0, false)
    else
        player:RemoveCollectible(TrinketValues.Brainstorm)
    end
end
-------------------SMEARED JOKER------------------
---@param player EntityPlayer
---@param pickup EntityPickup
function Balatro_Expansion:SmearedJoker(player, pickup)
    local RNG = player:GetTrinketRNG(Smeared_joker)

    if pickup.Variant == PickupVariant.PICKUP_HEART then
        if pickup.SubType == HeartSubType.HEART_HALF or HeartSubType.HEART_FULL or HeartSubType.HEART_DOUBLEPACK then
            if player:CanPickRedHearts() then
                local Chance = 0.5
                if RNG:RandomFloat() <= Chance then
                    Balatro_Expansion:EffectConverter(3, 0, player, 4)
                    player:AddCoins(1 * player:GetTrinketMultiplier(Smeared_joker))
                end
            end
        end
    elseif pickup.Variant == PickupVariant.PICKUP_COIN then
        if pickup.SubType ~= CoinSubType.COIN_STICKYNICKEL then
            if player:CanPickRedHearts() then
                local Chance = 0.4
                if RNG:RandomFloat() <= Chance then
                    Balatro_Expansion:EffectConverter(3, 0, player, 4)
                    player:AddHearts(1 * player:GetTrinketMultiplier(Smeared_joker))
                end
            end
        end
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
        local Chance = 0.2
        if RNG:RandomFloat() <= Chance then
            if Balatro_Expansion.WantedEffect == Smeared_joker then
                Balatro_Expansion:EffectConverter(3, 0, player, 4)
            end
            player:AddKeys(1 * player:GetTrinketMultiplier(Smeared_joker))
        end
    elseif pickup.Variant == PickupVariant.PICKUP_KEY then
        local Chance = 0.2
        if RNG:RandomFloat() <= Chance then
            if Balatro_Expansion.WantedEffect == Smeared_joker then
                Balatro_Expansion:EffectConverter(3, 0, player, 4)
            end
            player:AddBombs(1 * player:GetTrinketMultiplier(Smeared_joker))
        end
    end
end

------------------MADNESS-----------------------
---@param player EntityPlayer
function Balatro_Expansion:MAdness(player,_)
    if player:HasTrinket(Madness) then
        --print("madness")

        local MadnessMult = TrinketValues.Madness + (((TrinketValues.Madness - 1)/2) * (player:GetTrinketMultiplier(Madness) - 1))
        if Balatro_Expansion.WantedEffect == Madness then
            Balatro_Expansion:EffectConverter(2, MadnessMult, player, 2)
        end
        player.Damage = player.Damage * MadnessMult
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, Balatro_Expansion.MAdness, CacheFlag.CACHE_DAMAGE)
------------------SACRIFICIAL DAGGER-----------------
---@param player EntityPlayer
function Balatro_Expansion:SacrificialDagger(player)
    if player:HasTrinket(Sacrificial_dagger) then
        --print("madness")
        --print(TrinketValues.Sacrificial_dagger)
        local Damage = (TrinketValues.Sacrificial_dagger +((TrinketValues.Sacrificial_dagger/2) * (player:GetTrinketMultiplier(Sacrificial_dagger)-1) ))
        if Balatro_Expansion.WantedEffect == Sacrificial_dagger then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.SacrificialDagger, CacheFlag.CACHE_DAMAGE)
--------------------MR.BONES--------------------
---@param player EntityPlayer
function Balatro_Expansion:MrBones(player)
    local Room = Game:GetRoom()
    if Room:GetBossID() ~= 0 then --only if there's a boss in the room
        player:Revive()
        player:SetMinDamageCooldown(120)
        Balatro_Expansion:EffectConverter(3, 0, player, 4)
        if player:GetMaxHearts() > 2 then
            player:AddMaxHearts(-2, true)
        end
        player:SetFullHearts()
        if not player:TryRemoveTrinket(Mr_bones) then
            player:TryRemoveTrinket(Mr_bones)
        end
    end
end
------------------ONYX AGATE----------------------
---@param player EntityPlayer
function Balatro_Expansion:OnyxAgate(player,_)
    if player:HasTrinket(Onix_agate) then
        --print("onyx")
        local Bombs = player:GetNumBombs()
        if Bombs <= 10 then
            Damage = (Bombs * 0.10) * player:GetTrinketMultiplier(Onix_agate)
        elseif Bombs <= 25 then
            Damage = (1 + Bombs * 0.05) * player:GetTrinketMultiplier(Onix_agate)
        else
            Damage = (1.75 + Bombs * 0.03) * player:GetTrinketMultiplier(Onix_agate)
        end 
        player.Damage = player.Damage + Damage
        if Balatro_Expansion.WantedEffect == Onix_agate then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.OnyxAgate, CacheFlag.CACHE_DAMAGE)
-----------------ARROWHEAD---------------------------
---@param player EntityPlayer
function Balatro_Expansion:ArrowHead(player,_)
    if player:HasTrinket(Arrowhead) then
        --print("arrow")
        local Keys = player:GetNumKeys()
        if Keys <= 10 then
            Tears = (Keys * 0.10) * player:GetTrinketMultiplier(Arrowhead)
        elseif Keys <= 25 then
            Keys = (1 + Keys * 0.5) * player:GetTrinketMultiplier(Arrowhead)
        else
            Keys = (1.75 + Keys * 0.3) * player:GetTrinketMultiplier(Arrowhead)
        end
        if Balatro_Expansion.WantedEffect == Arrowhead then
            Balatro_Expansion:EffectConverter(1, Tears, player, 3)
        end
        Tears = Balatro_Expansion:CalculateTearsUp(player.MaxFireDelay, Tears)
        player.MaxFireDelay = player.MaxFireDelay - Tears
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.ArrowHead, CacheFlag.CACHE_FIREDELAY)
----------------BLOODSTONE----------------------------
---@param player EntityPlayer
function Balatro_Expansion:BloodStone(player,_)
    if player:HasTrinket(Bloodstone) then
        local RNG = player:GetTrinketRNG(Bloodstone)
        local Hearts = math.floor(player:GetHearts()/2)
        local Chance = 0.5 + 0.25*(player:GetTrinketMultiplier(Bloodstone)-1)
        local DamageMult = 1
        for i = 1, Hearts, 1 do
            if RNG:RandomFloat() <= Chance then
                DamageMult = DamageMult + 0.05
            end
        end
        player.Damage = player.Damage * DamageMult
        if Balatro_Expansion.WantedEffect == Bloodstone then
            Balatro_Expansion:EffectConverter(2, DamageMult, player, 2)
        end
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, Balatro_Expansion.BloodStone, CacheFlag.CACHE_DAMAGE)
------------------ROUGH GEM---------------------------
---@param player EntityPlayer
function Balatro_Expansion:RoughGem(player)
    local coins = player:GetNumCoins() * player:GetTrinketMultiplier(Rough_gem)
    local RNG = player:GetTrinketRNG(Rough_gem)
    local seed = RNG:GetSeed()
    repeat
        local Random = RNG:RandomInt(1,25)
        if Random <= coins then
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, seed)
            Balatro_Expansion:EffectConverter(3,0,player,4)
        end
        coins = coins - (Random * 2)
    until coins <= 0

end
----------------------GROS MICHAEL--------------------
---@param player EntityPlayer
function Balatro_Expansion:GrosMichael(player, _)
    if player:HasTrinket(Gros_michael) then --controls if it has the trinket
        --print(Balatro_Expansion.WantedEffect)
        if TrinketValues.MichaelDestroyed then
            if Balatro_Expansion.WantedEffect == "MCdestroyed" then
                Balatro_Expansion:EffectConverter(4, 0, player, 4)
                return
            elseif Balatro_Expansion.WantedEffect == "MCsafe" then
                Balatro_Expansion:EffectConverter(7, 0, player, 4)
                return
            end
        end
        local Damage = 1 * player:GetTrinketMultiplier(Gros_michael) 
        if Balatro_Expansion.WantedEffect == Gros_michael then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage --flat DMG up
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.GrosMichael, CacheFlag.CACHE_DAMAGE)
----------------------CAVENDISH--------------------
---@param player EntityPlayer
function Balatro_Expansion:Cavendish(player, _)
    if player:HasTrinket(Cavendish) then --controls if it has the trinket
        if not TrinketValues.MichaelDestroyed then
            if Balatro_Expansion.WantedEffect == "MCdestroyed" then
                Balatro_Expansion:EffectConverter(4, 0, player, 4)
                return
            elseif Balatro_Expansion.WantedEffect == "MCsafe" then
                Balatro_Expansion:EffectConverter(7, 0, player, 4)
                return
            end
        end
        local DamageMult = 1.2 + (0.1 * player:GetTrinketMultiplier(Cavendish)) 
        if Balatro_Expansion.WantedEffect == Cavendish then
            Balatro_Expansion:EffectConverter(2, DamageMult, player, 2)
        end
        player.Damage = player.Damage * DamageMult
    end
end

Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, Balatro_Expansion.Cavendish, CacheFlag.CACHE_DAMAGE)
-------------------FLASH CARD---------------------
---@param player EntityPlayer
function Balatro_Expansion:FlashCard(player, _)
    if player:HasTrinket(Flash_card) then --controls if it has the trinket
        local Damage = TrinketValues.Flash_card * player:GetTrinketMultiplier(Flash_card)
        if Balatro_Expansion.WantedEffect == Flash_card then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.FlashCard, CacheFlag.CACHE_DAMAGE)

-------------------CLOUD 9---------------------
---@param player EntityPlayer
function Balatro_Expansion:Cloudnine(player, _)
    local Tanscendance = ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
    if player:HasTrinket(Cloud_nine) then --controls if it has the trinket
    
        if TrinketValues.Cloud_9 == 0 then
            player.CanFly = true  
            player:AddCostume(Tanscendance)
            if Balatro_Expansion.WantedEffect == Cloud_nine then
                Balatro_Expansion:EffectConverter(3, 0, player, 4)
            end
        else
            if Balatro_Expansion.WantedEffect == Cloud_nine then
                Balatro_Expansion:EffectConverter(8, TrinketValues.Cloud_9, player, 4)
            end
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
                player:RemoveCostume(Tanscendance)
            end
        end
    else
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
            player:RemoveCostume(Tanscendance)
        end
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.Cloudnine, CacheFlag.CACHE_FLYING)
-------------------CARTOMANCER---------------------
---@param player EntityPlayer
function Balatro_Expansion:CArtomancer(player)
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
        for i = 1, 2 * player:GetTrinketMultiplier(Cartomancer), 1 do
            local RNG = player:GetTrinketRNG(Cartomancer)
            local seed = RNG:GetSeed()
            local Pill = ItemPool:GetPill(seed)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position , RandomVector() * 3, player, Pill, seed)
        end
    else
        for i = 1,2 * player:GetTrinketMultiplier(Cartomancer), 1 do
            local RNG = player:GetTrinketRNG(Cartomancer)
            local seed = RNG:GetSeed()
            local Card = ItemPool:GetCard(seed, true, true, false)
            --Print(Card)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, seed)
        end
    end      
    Balatro_Expansion:EffectConverter(3, 0, player, 4)
end
--------------------SWASHBUCKLER-------------------------
---@param player EntityPlayer
function Balatro_Expansion:SwashBuckler(player, _)
    if player:HasTrinket(Swashbuckler) then --controls if it has the trinket
        local Damage = TrinketValues.Swashbuckler * player:GetTrinketMultiplier(Swashbuckler)
        if Balatro_Expansion.WantedEffect == Swashbuckler then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.SwashBuckler, CacheFlag.CACHE_DAMAGE)


--------------------LOYALTY CARD-------------------------
---@param player EntityPlayer
function Balatro_Expansion:LoyaltyCard(player)
    if player:HasTrinket(Loyalty_card) then --controls if it has the trinket
    
        if TrinketValues.Loyalty_card == 0 then
            player.Damage = player.Damage * 1.3  
            if Balatro_Expansion.WantedEffect == Loyalty_card then
                Balatro_Expansion:EffectConverter(2, 1.3, player, 2)
            end  
        else
            if Balatro_Expansion.WantedEffect == Loyalty_card then
                Balatro_Expansion:EffectConverter(8, TrinketValues.Loyalty_card, player, 4)
            end
        end        
    end
end

Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, Balatro_Expansion.LoyaltyCard, CacheFlag.CACHE_DAMAGE)

---------------------SUPERNOVA----------------------------
---@param player EntityPlayer
function Balatro_Expansion:SuperNova(player)
    local Damage = 0
    if player:HasTrinket(Supernova) then
        for i = 0, 1, 1 do --takes the higer value between the two held actives
            local Active = player:GetActiveItem(i)
            if TrinketValues.Supernova[Active] > Damage then
                Damage = TrinketValues.Supernova[Active]
            end
        end
        player.Damage = player.Damage + Damage  
        if Balatro_Expansion.WantedEffect == Supernova then
            Balatro_Expansion:EffectConverter(1, Damage, player, 1)
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.SuperNova, CacheFlag.CACHE_DAMAGE)

---------------DELAYED GRATIFICATION------------------
---@param player EntityPlayer
function Balatro_Expansion:DelayedGratification(player)
    if TrinketValues.DamageTakenRoom == 0 then --gives coins if no damage is taken when compleating rooms
        local seed = player:GetTrinketRNG(Delayed_gratification):GetSeed()
        for i = 1, player:GetTrinketMultiplier(Delayed_gratification), 1 do 
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, seed)
        end
        Balatro_Expansion:EffectConverter(3, 0, player, 4)
    end
    TrinketValues.Delayed_gratification = true
end

---------------------EGG------------------

---@param player EntityPlayer
function Balatro_Expansion:EGG(player, Destroy)
    --print(Destroy)
    if Destroy then
        local seed = player:GetTrinketRNG(Egg):GetSeed()
        for i = 1, TrinketValues.Egg , 1 do 
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, seed)
        end
        local Entities = Isaac.GetRoomEntities()
        print(Entities)
        for k, Entity in ipairs(Isaac.GetRoomEntities()) do
            if Entity.Type == EntityType.ENTITY_PICKUP and Entity.Variant == PickupVariant.PICKUP_TRINKET and Entity.SubType == Egg then
                Entity:Remove()
                break
            end
        end
        
        Balatro_Expansion:EffectConverter(3, 0, player, 4)
    else
        --print("false")
        TrinketValues.Egg = TrinketValues.Egg + (4 * player:GetTrinketMultiplier(Egg))
        Balatro_Expansion:EffectConverter(5, 0, player, 4)
    end
end

-------------------DNA----------------------

---@param player EntityPlayer
function Balatro_Expansion:DNA(player, Variant, SubType)
    if TrinketValues.Dna then    
        local Copied = false --needed to not make the trinket deactivate in case of a wrong active item being used
        local seed = player:GetTrinketRNG(Golden_joker):GetSeed()
        if Variant == PickupVariant.PICKUP_COLLECTIBLE then --checks if it's an active item or card/pill
            local Activeconfig = ItemsConfig:GetCollectible(SubType)
                
            --only spawns active item with a "normal" charge type and not singular use actives
            if Activeconfig.MaxCharges ~= 0 and player:HasCollectible(SubType) then 

                local Item = Game:Spawn(EntityType.ENTITY_PICKUP, Variant, Isaac.GetFreeNearPosition(player.Position, 50) , Vector.Zero, player, SubType, seed):ToPickup()
                Item.Charge = 0  --gives the item no charges
                Copied = true
            end
        else
            Game:Spawn(EntityType.ENTITY_PICKUP, Variant, player.Position , RandomVector() * 3, player,SubType, seed)
            Copied = true
        end
        if Copied then
            if player:GetTrinketMultiplier(Dna) > 1 then
                local RNG = player:GetTrinketRNG(Dna)
                Chance = 0.7
                if RNG:RandomFloat() < Chance then --Chance to not deactivate if a golden version is obtained
                    TrinketValues.Dna = false
                end
            else
                TrinketValues.Dna = false
            end
            Balatro_Expansion:EffectConverter(3, 0, player, 4)
        end
    end
end
