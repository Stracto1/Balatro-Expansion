local mod = Balatro_Expansion
local TrinketValues = mod.SavedValues.TrinketValues
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

local ADDMULTSOUND = Isaac.GetSoundIdByName("ADDMULTSFX")
local TIMESMULTSOUND = Isaac.GetSoundIdByName("TIMESMULTSFX")
local ACTIVATESOUND = Isaac.GetSoundIdByName("ACTIVATESFX")
local CHIPSSOUND = Isaac.GetSoundIdByName("CHIPSSFX")
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")

local EFFECT_COLORS = {}
EFFECT_COLORS.Red = 1
EFFECT_COLORS.Blue = 2
EFFECT_COLORS.Yellow = 3


function mod:EditionsStats(Player, Flags)
    if Player:GetPlayerType() == mod.Characters.JimboType and mod.StatEnable then
        for i,Edition in ipairs(mod.SavedValues.Jimbo.Inventory.Editions) do
            if Flags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
                if Edition == mod.Edition.HOLOGRAPHIC then
                    mod.IncreaseJimboStats(Player,0.5, 0, 1, false, false)
                elseif Edition == mod.Edition.POLYCROME then
                    mod.IncreaseJimboStats(Player,0, 0, 1.25, false, false)
                end
            end
            if Flags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_FIREDELAY then
                if Edition == mod.Edition.FOIL then
                    mod.IncreaseJimboStats(Player,0, 1, 1, false, false)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EditionsStats)

-------------------Joker------------------------
function mod:Joker(player,_)
    if player:GetPlayerType() == mod.Characters.JimboType then
 
        if mod:JimboHasTrinket(player, TrinketType.TRINKET_JOKER) and mod.StatEnable then
            mod:IncreaseJimboStats(player, 0.4, 0, 1, false, false)
        end

    elseif player:HasTrinket(Joker) then
         --controls if it has the trinket
    
        local JokerDMG = 0.5 --base dmg
        local DMGToAdd = JokerDMG * player:GetTrinketMultiplier(Joker) --scalable DMG up
        if mod.WantedEffect == Joker then
            --print("effect")
            mod:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd --flat DMG up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Joker, CacheFlag.CACHE_DAMAGE)

------------------bull---------------------------


function mod:Bull(player, flag)
    if player.HasTrinket(player, Bull) then --controls if it has the trinket
        if player:GetPlayerType() == mod.Characters.JimboType then
            mod:IncreaseJimboStats(flag,player:GetNumCoins() * 0.03)
        else
        local CurrentCoins = player:GetNumCoins()  --gets the player's coins
        local BullTears = 0

        if CurrentCoins <= 25 then
            BullTears = 0.04 * CurrentCoins 
        elseif  CurrentCoins <= 50 then
            BullTears = 1 + 0.02 * (CurrentCoins - 25)
        else
            BullTears = 1.50 + 0.01 * (CurrentCoins - 50)
        end
        BullTears = BullTears * player.GetTrinketMultiplier(player ,Bull)
        TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, BullTears)  --scalable tears up
        if mod.WantedEffect == Bull then
            mod:EffectConverter(1, BullTears, player, 3)
        end
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd --flat tears up
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Bull, CacheFlag.CACHE_FIREDELAY)

----------------------------invisible joker------------------------
function mod:InvisibleJoker(player)
    local Seed = Game:GetSeeds():GetStartSeed() --gets the run's seed
    
    for i = 0, 3, 1 do --checks every consumable slot
        local HeldCard = player.GetCard(player, i)
        local HeldPill = player.GetPill(player, i)

        if HeldCard ~= 0 then  --if player has a card/rune

            for i = 1, player.GetTrinketMultiplier(player, Invisible_Joker), 1 do
                    
                Game:Spawn(EntityType.ENTITY_PICKUP, 300, player.Position , RandomVector() * 3, player, HeldCard, Seed)
            end
            if mod.WantedEffect == Invisible_Joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            break --ends the initial FOR early

        elseif  HeldPill ~= 0 then --pills are a different enity to cards so this is also needed
            for i = 1, player.GetTrinketMultiplier(player, Invisible_Joker), 1 do
                    
                Game:Spawn(EntityType.ENTITY_PICKUP, 70, player.Position , RandomVector() * 3, player, HeldPill, Seed)
            end
            if mod.WantedEffect == Invisible_Joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            break --ends the initial FOR early

        end
    end
    
end

--------------------------abstract joker--------------------

function mod:AbstractJoker(player,_)
    if player.HasTrinket(player, Abstract_joker) then
        local AbstractDMG = 0.08
        local NumItems = player.GetCollectibleCount(player)
        local DMGToAdd = (AbstractDMG * NumItems) * player.GetTrinketMultiplier(player, Abstract_joker)
        if mod.WantedEffect == Abstract_joker then
            mod:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd 
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.AbstractJoker, CacheFlag.CACHE_DAMAGE)

--------------------------------------misprint----------------------------------------------

function mod:Misprint(player,_)
    if player.HasTrinket(player, Misprint) then
        if mod.WantedEffect == Misprint then --basically changes the dmg up only when changing rooms
            local RNG = player:GetTrinketRNG(Misprint)
            local MisprintDMG = 1.5
            local MisprintDMGToAdd = ((MisprintDMG * RNG:RandomFloat()) * player.GetTrinketMultiplier(player, Misprint)) --random float is from 0 to 1
            MisprintDMGToAdd = mod:round(MisprintDMGToAdd, 2)
            mod:EffectConverter(1, MisprintDMGToAdd, player, 1)
            player.Damage = player.Damage + MisprintDMGToAdd
            TrinketValues.LastMisprintDMG = MisprintDMGToAdd
            return
        end
        player.Damage = player.Damage + TrinketValues.LastMisprintDMG
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Misprint, CacheFlag.CACHE_DAMAGE)

-------------------joker stencil-------------------

---@param player EntityPlayer
function mod:JokerStencil(player,_)
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
        if mod.WantedEffect == Joker_stencil then
            mod:EffectConverter(2, JokerStencilMultiplier, player, 2)
        end
        player.Damage = player.Damage * JokerStencilMultiplier
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.JokerStencil, CacheFlag.CACHE_DAMAGE)

------------------STONE JOKER---------------------

---@param player EntityPlayer
function mod:StoneJoker(player, _)
    if player.HasTrinket(player, Stone_joker) then --controls if it has the trinket
        local StoneTears = TrinketValues.Stone_joker
        if mod.WantedEffect == Stone_joker then
            mod:EffectConverter(1, StoneTears, player, 3)
        end
        local TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, StoneTears)
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd --flat tears up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.StoneJoker, CacheFlag.CACHE_FIREDELAY)

-----------------ICE CREAM-------------------------
---@param player EntityPlayer
function mod:IceCream(player, _)
    if player:HasTrinket(Icecream) then
        if TrinketValues.Ice_cream == 0 then
            mod:EffectConverter(4, 0, player, 6)
            return
        end
        local IceTears = TrinketValues.Ice_cream * player:GetTrinketMultiplier(Icecream)
        if mod.WantedEffect == Icecream then
            mod:EffectConverter(1, IceTears, player, 3)
        end
        local TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, IceTears)
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.IceCream, CacheFlag.CACHE_FIREDELAY)

-----------------POPCORN-------------------------
---@param player EntityPlayer
function mod:Popcorn(player, _)
    if player:HasTrinket(Popcorn) then
        if TrinketValues.Popcorn == 0 then
            mod:EffectConverter(4, 0, player, 5)
            return
        end
        local PopDamage = TrinketValues.Popcorn * player:GetTrinketMultiplier(Popcorn)
        if mod.WantedEffect == Popcorn then
            mod:EffectConverter(1, PopDamage, player, 1)
        end
        player.Damage = player.Damage + PopDamage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Popcorn, CacheFlag.CACHE_DAMAGE)

---------------------RAMEN-------------------------
---@param player EntityPlayer
function mod:Ramen(player, _)
    if player:HasTrinket(Ramen) then
        if TrinketValues.Ramen == 0 then
            mod:EffectConverter(4, 0, player, 5)
            return
        end
        local RamenMult = TrinketValues.Ramen + ((TrinketValues.Ramen -1 ) * (player:GetTrinketMultiplier(Ramen) - 1))
        if mod.WantedEffect == Ramen then
            mod:EffectConverter(2, RamenMult, player, 2)
        end
        player.Damage = player.Damage * RamenMult
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.Ramen, CacheFlag.CACHE_DAMAGE)

----------------------------ROCKET-----------------------------
---@param player EntityPlayer
function mod:rocket(player)
    local Seed = Game:GetSeeds():GetStartSeed() --gets the run's seed
    for i = 1, TrinketValues.Rocket , 1 do --checks every consumable slot        
        Game:Spawn(EntityType.ENTITY_PICKUP, 20, player.Position, RandomVector() * 3, player, 1, Seed)
    end
    TrinketValues.Rocket = TrinketValues.Rocket + (2 * player:GetTrinketMultiplier(Rocket))
    mod:EffectConverter(3, 0, player, 4)
end

--------------------------  EVEN STEVEN---------------------------
---@param player EntityPlayer
function mod:EvenSteven(player, _)
    if player:HasTrinket(Evensteven) then --controls if it has the trinket
        if player:GetCollectibleCount() % 2 == 0 then
            local StevenDMG = 0.1
            local DMGToAdd = (StevenDMG * player:GetCollectibleCount()) * player:GetTrinketMultiplier(Evensteven) --scalable DMG up
            if mod.WantedEffect == Evensteven then
                mod:EffectConverter(1, DMGToAdd, player, 1)
            end
            player.Damage = player.Damage + DMGToAdd --flat DMG up
        else
            if mod.WantedEffect == Evensteven then    
                mod:EffectConverter(1, 0, player, 1)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvenSteven, CacheFlag.CACHE_DAMAGE)

------------------------ODD TODD----------------------------
---@param player EntityPlayer
function mod:OddTodd(player, _)

    if player:HasTrinket(Oddtodd) then --controls if it has the trinket
        if player:GetCollectibleCount() % 2 == 1 then
            local OddTears = 0.07
            local TearsToAdd = (OddTears * player:GetCollectibleCount()) * player:GetTrinketMultiplier(Oddtodd) --scalable DMG up
            if mod.WantedEffect == Oddtodd then
                mod:EffectConverter(1, TearsToAdd, player, 3)
            end
            TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, TearsToAdd)
            player.MaxFireDelay = player.MaxFireDelay - TearsToAdd--flat DMG up
        else   
            if mod.WantedEffect == Oddtodd then
                mod:EffectConverter(1, 0, player, 3)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OddTodd, CacheFlag.CACHE_FIREDELAY)
-----------------------HALLUCINATION------------------------
---@param player EntityPlayer
function mod:HAllucination(player, cost)
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
            mod:EffectConverter(3, 0, player, 4)
    end
end
-----------------------VAGABOND---------------------------
---@param player EntityPlayer
function mod:VAgabond(player)
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
    mod:EffectConverter(3, 0, player, 4)   
end
-----------------------GREEN JOKER------------------
function mod:GreenJoker(player,_)
    if player:HasTrinket(Green_joker) then
        local Damage = TrinketValues.Green_joker 
        if mod.WantedEffect == Green_joker then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GreenJoker, CacheFlag.CACHE_DAMAGE)
--------------------RED CARD---------------------
---@param player EntityPlayer
function mod:RedCard(player,_)
    if player:HasTrinket(Red_card) then
        local Damage = TrinketValues.Red_card * player:GetTrinketMultiplier(Red_card)
        if mod.WantedEffect == Red_card then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.RedCard, CacheFlag.CACHE_DAMAGE)
--------------------RIFF RAFF----------------------
---@param player EntityPlayer
function mod:RiffRaff(player)
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
        
    mod:EffectConverter(3, 0, player, 4)
    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetFreeNearPosition(player.Position, 50), Vector.Zero, player, Item, seed)
end
-------------------GOLDEN JOKER--------------------
---@param player EntityPlayer
function mod:Goldenjoker(player)
    local seed = player:GetTrinketRNG(Golden_joker):GetSeed()
    for i = 1, 2 + 2 * player:GetTrinketMultiplier(Golden_joker) do
        Game:Spawn(EntityType.ENTITY_PICKUP, 20, player.Position, RandomVector() * 3, player, 1, seed)
    end
    mod:EffectConverter(3, 0, player, 4)
end
----------------FORTUNETELLER----------------------
---@param player EntityPlayer
function mod:FOrtuneteller(player)
    if player:HasTrinket(Fortuneteller) then
        --print("fortune teller")
        local Damage = TrinketValues.Fortune_Teller * player:GetTrinketMultiplier(Fortuneteller)
        if mod.WantedEffect == Fortuneteller then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.FOrtuneteller, CacheFlag.CACHE_DAMAGE)
-------------------BLUEPRINT--------------------
---@param player EntityPlayer
function mod:BluePrint(player, Add)
    if TrinketValues.Blueprint == 0 then
        return
    end
    if Add then
        if mod.WantedEffect == Blueprint then
            mod:EffectConverter(3, 0, player, 4)
        end
        player:AddCollectible(TrinketValues.Blueprint, 0, false)
    end
    player:RemoveCollectible(TrinketValues.LastBPitem)
    TrinketValues.LastBPitem = TrinketValues.Blueprint
end
------------------BRAINSTORM-----------------------
---@param player EntityPlayer
function mod:BrainStorm(player, Add)
    if Add and TrinketValues.Brainstorm ~= 0 then
        TrinketValues.FirstBrain = false
        if mod.WantedEffect == Brainstorm then
            mod:EffectConverter(3, 0, player, 4)
        end
        player:AddCollectible(TrinketValues.Brainstorm, 0, false)
    else
        player:RemoveCollectible(TrinketValues.Brainstorm)
    end
end
-------------------SMEARED JOKER------------------
---@param player EntityPlayer
---@param pickup EntityPickup
function mod:SmearedJoker(player, pickup)
    local RNG = player:GetTrinketRNG(Smeared_joker)

    if pickup.Variant == PickupVariant.PICKUP_HEART then
        if pickup.SubType == HeartSubType.HEART_HALF or HeartSubType.HEART_FULL or HeartSubType.HEART_DOUBLEPACK then
            if player:CanPickRedHearts() then
                local Chance = 0.5
                if RNG:RandomFloat() <= Chance then
                    mod:EffectConverter(3, 0, player, 4)
                    player:AddCoins(1 * player:GetTrinketMultiplier(Smeared_joker))
                end
            end
        end
    elseif pickup.Variant == PickupVariant.PICKUP_COIN then
        if pickup.SubType ~= CoinSubType.COIN_STICKYNICKEL then
            if player:CanPickRedHearts() then
                local Chance = 0.4
                if RNG:RandomFloat() <= Chance then
                    mod:EffectConverter(3, 0, player, 4)
                    player:AddHearts(1 * player:GetTrinketMultiplier(Smeared_joker))
                end
            end
        end
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
        local Chance = 0.2
        if RNG:RandomFloat() <= Chance then
            if mod.WantedEffect == Smeared_joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            player:AddKeys(1 * player:GetTrinketMultiplier(Smeared_joker))
        end
    elseif pickup.Variant == PickupVariant.PICKUP_KEY then
        local Chance = 0.2
        if RNG:RandomFloat() <= Chance then
            if mod.WantedEffect == Smeared_joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            player:AddBombs(1 * player:GetTrinketMultiplier(Smeared_joker))
        end
    end
end

------------------MADNESS-----------------------
---@param player EntityPlayer
function mod:MAdness(player,_)
    if player:HasTrinket(Madness) then
        --print("madness")

        local MadnessMult = TrinketValues.Madness + (((TrinketValues.Madness - 1)/2) * (player:GetTrinketMultiplier(Madness) - 1))
        if mod.WantedEffect == Madness then
            mod:EffectConverter(2, MadnessMult, player, 2)
        end
        player.Damage = player.Damage * MadnessMult
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.MAdness, CacheFlag.CACHE_DAMAGE)
------------------SACRIFICIAL DAGGER-----------------
---@param player EntityPlayer
function mod:SacrificialDagger(player)
    if player:HasTrinket(Sacrificial_dagger) then
        --print("madness")
        --print(TrinketValues.Sacrificial_dagger)
        local Damage = (TrinketValues.Sacrificial_dagger +((TrinketValues.Sacrificial_dagger/2) * (player:GetTrinketMultiplier(Sacrificial_dagger)-1) ))
        if mod.WantedEffect == Sacrificial_dagger then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SacrificialDagger, CacheFlag.CACHE_DAMAGE)
--------------------MR.BONES--------------------
---@param player EntityPlayer
function mod:MrBones(player, Jimbo)
    if Jimbo then --jimbo has a different effect but on the same callback
        print("Jimbo died")
        local Revive = false
        if mod.SavedValues.Jimbo.BossCleard then --on boss cleared revive anyways
            Revive = true
            
        elseif mod.SavedValues.Jimbo.BigCleared then --if big is cleared then you need to be fighting boss to revive
            if Game:GetRoom():GetBossID() ~= 0 then
                Revive = true
            end
        elseif mod.SavedValues.Jimbo.SmallCleared then
            local BlindProgress  = mod.SavedValues.Jimbo.ClearedRooms
            if BlindProgress >= mod.SavedValues.Jimbo.BigBlind / 2 then
                Revive = true
            end
        else --before clearing small blind
            local BlindProgress  = mod.SavedValues.Jimbo.ClearedRooms
            
            if BlindProgress >= mod.SavedValues.Jimbo.SmallBlind / 2 then
                Revive = true
            end
        end
        if not Revive then
            return
        end

        player:Revive()
        player:SetFullHearts() --full health
        player:SetMinDamageCooldown(120) --some iframes

        local MRindex = mod:GetValueIndex(mod.SavedValues.Jimbo.Inventory, TrinketType.TRINKET_MR_BONES, true)
        mod.SavedValues.Jimbo.Inventory[MRindex] = 0 --removes the trinket
        mod:CreateBalatroEffect(MRindex, EFFECT_COLORS.Yellow, ACTIVATESOUND, "ACTIVATE!")

    else
        local Room = Game:GetRoom()
        if Room:GetBossID() ~= 0 then --only if there's a boss in the room
            player:Revive()
            player:SetMinDamageCooldown(120) --some iframes
            mod:EffectConverter(3, 0, player, 4)
            if player:GetMaxHearts() > 2 then
                player:AddMaxHearts(-2, true)--hp down
            end
            player:SetFullHearts() --full health
            if not player:TryRemoveTrinket(Mr_bones) then
                player:TryRemoveSmeltedTrinket(Mr_bones)
            end
        end
    end
end
------------------ONYX AGATE----------------------
---@param player EntityPlayer
function mod:OnyxAgate(player,_)
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
        if mod.WantedEffect == Onix_agate then
            mod:EffectConverter(1, Damage, player, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnyxAgate, CacheFlag.CACHE_DAMAGE)
-----------------ARROWHEAD---------------------------
---@param player EntityPlayer
function mod:ArrowHead(player,_)
    if player:GetPlayerType() == mod.Characters.JimboType and mod.StatEnable then
        if mod:JimboHasTrinket(player,Arrowhead) then

            mod:IncreaseJimboStats(player, 0, 0.1*mod.SavedValues.Jimbo.Progress.SuitUsed[mod.Suits.Spade],1,false,false)
        end
    
    elseif player:HasTrinket(Arrowhead) then
        --print("arrow")
        local Keys = player:GetNumKeys()
        if Keys <= 10 then
            Tears = (Keys * 0.10) * player:GetTrinketMultiplier(Arrowhead)
        elseif Keys <= 25 then
            Keys = (1 + Keys * 0.5) * player:GetTrinketMultiplier(Arrowhead)
        else
            Keys = (1.75 + Keys * 0.3) * player:GetTrinketMultiplier(Arrowhead)
        end
        if mod.WantedEffect == Arrowhead then
            mod:EffectConverter(1, Tears, player, 3)
        end
        Tears = mod:CalculateTearsUp(player.MaxFireDelay, Tears)
        player.MaxFireDelay = player.MaxFireDelay - Tears
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ArrowHead, CacheFlag.CACHE_FIREDELAY)
----------------BLOODSTONE----------------------------
---@param player EntityPlayer
function mod:BloodStone(player,_)
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
        if mod.WantedEffect == Bloodstone then
            mod:EffectConverter(2, DamageMult, player, 2)
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.BloodStone, CacheFlag.CACHE_DAMAGE)
------------------ROUGH GEM---------------------------
---@param player EntityPlayer
function mod:RoughGem(player)
    local coins = player:GetNumCoins() * player:GetTrinketMultiplier(Rough_gem)
    local RNG = player:GetTrinketRNG(Rough_gem)
    local seed = RNG:GetSeed()
    repeat
        local Random = RNG:RandomInt(1,25)
        if Random <= coins then
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, seed)
            mod:EffectConverter(3,0,player,4)
        end
        coins = coins - (Random * 2)
    until coins <= 0

end
----------------------GROS MICHAEL--------------------
---@param player EntityPlayer
function mod:GrosMichael(player, _)
    if player:HasTrinket(Gros_michael) then --controls if it has the trinket
        --print(mod.WantedEffect)
        if TrinketValues.MichaelDestroyed then
            if mod.WantedEffect == "MCdestroyed" then
                mod:EffectConverter(4, 0, player, 4)
                return
            elseif mod.WantedEffect == "MCsafe" then
                mod:EffectConverter(7, 0, player, 4)
                return
            end
        end
        local Damage = 1 * player:GetTrinketMultiplier(Gros_michael) 
        if mod.WantedEffect == Gros_michael then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage --flat DMG up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GrosMichael, CacheFlag.CACHE_DAMAGE)
----------------------CAVENDISH--------------------
---@param player EntityPlayer
function mod:Cavendish(player, _)
    if player:HasTrinket(Cavendish) then --controls if it has the trinket
        if not TrinketValues.MichaelDestroyed then
            if mod.WantedEffect == "MCdestroyed" then
                mod:EffectConverter(4, 0, player, 4)
                return
            elseif mod.WantedEffect == "MCsafe" then
                mod:EffectConverter(7, 0, player, 4)
                return
            end
        end
        local DamageMult = 1.2 + (0.1 * player:GetTrinketMultiplier(Cavendish)) 
        if mod.WantedEffect == Cavendish then
            mod:EffectConverter(2, DamageMult, player, 2)
        end
        player.Damage = player.Damage * DamageMult
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.Cavendish, CacheFlag.CACHE_DAMAGE)
-------------------FLASH CARD---------------------
---@param player EntityPlayer
function mod:FlashCard(player, _)
    if player:HasTrinket(Flash_card) then --controls if it has the trinket
        local Damage = TrinketValues.Flash_card * player:GetTrinketMultiplier(Flash_card)
        if mod.WantedEffect == Flash_card then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.FlashCard, CacheFlag.CACHE_DAMAGE)

-------------------CLOUD 9---------------------
---@param player EntityPlayer
function mod:Cloudnine(player, _)
    local Tanscendance = ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
    if player:HasTrinket(Cloud_nine) then --controls if it has the trinket
    
        if TrinketValues.Cloud_9 == 0 then
            player.CanFly = true  
            player:AddCostume(Tanscendance)
            if mod.WantedEffect == Cloud_nine then
                mod:EffectConverter(3, 0, player, 4)
            end
        else
            if mod.WantedEffect == Cloud_nine then
                mod:EffectConverter(8, TrinketValues.Cloud_9, player, 4)
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

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Cloudnine, CacheFlag.CACHE_FLYING)
-------------------CARTOMANCER---------------------
---@param player EntityPlayer
function mod:CArtomancer(player)
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
    mod:EffectConverter(3, 0, player, 4)
end
--------------------SWASHBUCKLER-------------------------
---@param player EntityPlayer
function mod:SwashBuckler(player, _)
    if player:HasTrinket(Swashbuckler) then --controls if it has the trinket
        local Damage = TrinketValues.Swashbuckler * player:GetTrinketMultiplier(Swashbuckler)
        if mod.WantedEffect == Swashbuckler then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SwashBuckler, CacheFlag.CACHE_DAMAGE)


--------------------LOYALTY CARD-------------------------
---@param player EntityPlayer
function mod:LoyaltyCard(player)
    if player:HasTrinket(Loyalty_card) then --controls if it has the trinket
    
        if TrinketValues.Loyalty_card == 0 then
            player.Damage = player.Damage * 1.3  
            if mod.WantedEffect == Loyalty_card then
                mod:EffectConverter(2, 1.3, player, 2)
            end  
        else
            if mod.WantedEffect == Loyalty_card then
                mod:EffectConverter(8, TrinketValues.Loyalty_card, player, 4)
            end
        end        
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.LoyaltyCard, CacheFlag.CACHE_DAMAGE)

---------------------SUPERNOVA----------------------------
---@param player EntityPlayer
function mod:SuperNova(player)
    local Damage = 0
    if player:HasTrinket(Supernova) then
        for i = 0, 1, 1 do --takes the higer value between the two held actives
            local Active = player:GetActiveItem(i)
            if TrinketValues.Supernova[Active] > Damage then
                Damage = TrinketValues.Supernova[Active]
            end
        end
        player.Damage = player.Damage + Damage  
        if mod.WantedEffect == Supernova then
            mod:EffectConverter(1, Damage, player, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SuperNova, CacheFlag.CACHE_DAMAGE)

---------------DELAYED GRATIFICATION------------------
---@param player EntityPlayer
function mod:DelayedGratification(player)
    if TrinketValues.DamageTakenRoom == 0 then --gives coins if no damage is taken when compleating rooms
        local seed = player:GetTrinketRNG(Delayed_gratification):GetSeed()
        for i = 1, player:GetTrinketMultiplier(Delayed_gratification), 1 do 
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, seed)
        end
        mod:EffectConverter(3, 0, player, 4)
    end
    TrinketValues.Delayed_gratification = true
end

---------------------EGG------------------

---@param player EntityPlayer
function mod:EGG(player, Destroy)
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
        
        mod:EffectConverter(3, 0, player, 4)
    else
        --print("false")
        TrinketValues.Egg = TrinketValues.Egg + (4 * player:GetTrinketMultiplier(Egg))
        mod:EffectConverter(5, 0, player, 4)
    end
end

-------------------DNA----------------------

---@param player EntityPlayer
function mod:DNA(player, Variant, SubType)
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
            mod:EffectConverter(3, 0, player, 4)
        end
    end
end
