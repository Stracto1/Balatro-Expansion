local Joker = TrinketType.TRINKET_JOKER
print(Joker)

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
-----------------------------------
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")

local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local Game = Game()
---------------------------------------
local PastCoins
local PastBombs
local PastKeys


function Balatro_Expansion:OnGetTrinket(Selected, SEED)
    if TrinketValues.MichaelDestroyed then--michael was destroyed previously

        if TrinketValues.GoldenMichelGone then --3% to replace with cavendish if a golden michael was destroyed
            local RNG = RNG(SEED)

            if RNG:RandomFloat() <= 0.03 then
                return Cavendish
            end
        end
        if Selected == Gros_michael  then
            local Trinket
            repeat
                Trinket = ItemPool:GetTrinket()
            until Trinket ~= Gros_michael
            return Trinket
        end

    else--michael was not destroyed

        if Selected == Cavendish then  --prevents cavemdish from being chosen
            local Trinket
            repeat
                Trinket = ItemPool:GetTrinket()
            until Trinket ~= Cavendish
            return Trinket
        end
    end
    
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_TRINKET, Balatro_Expansion.OnGetTrinket)

---@param player EntityPlayer
function Balatro_Expansion:SpecificTrinket(player,trinket,_)
    if trinket == Blueprint then 
        Balatro_Expansion:BluePrint(player, true)
    end
    if trinket == Brainstorm then
        Balatro_Expansion:BrainStorm(player, true)
    end
    if trinket == Supernova then
        for i = 0, 1, 1 do
            local Active = player:GetActiveItem(i)
            if not TrinketValues.Supernova[Active] then
                TrinketValues.Supernova[Active] = 0
            end
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, Balatro_Expansion.SpecificTrinket)


function Balatro_Expansion:OnItemRemoval(player,item)
    if player:HasTrinket(Abstract_joker) then
        Balatro_Expansion.WantedEffect = Abstract_joker
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Evensteven) then
        Balatro_Expansion.WantedEffect = Evensteven
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Joker_stencil) then
        Balatro_Expansion.WantedEffect = Joker_stencil
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Oddtodd) then
        Balatro_Expansion.WantedEffect = Oddtodd
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(Supernova) then
        local itemsconfig = ItemsConfig:GetCollectible(item)
        if itemsconfig.Type == ItemType.ITEM_ACTIVE then
            Balatro_Expansion.WantedEffect = Supernova
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, Balatro_Expansion.OnItemRemoval)

function Balatro_Expansion:AlwaysOnItemPickup(item,_,_,_,_,_)
    local itemconfig = ItemsConfig:GetCollectible(item)
    --if Player:HasCollectible(The_Hand, false, true)
    if itemconfig.Type ~= ItemType.ITEM_ACTIVE and itemconfig.Type ~= ItemType.ITEM_TRINKET then
        --print("passive")
        --print("picked up")
        if TrinketValues.Brainstorm == 0 then
            TrinketValues.Brainstorm = item
        end
        TrinketValues.Blueprint = item
    end
    --print(TrinketValues.Brainstormitem)
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Balatro_Expansion.AlwaysOnItemPickup)

function Balatro_Expansion:OnTrinketRemoval(player,trinket)
    --print("removed")
    if trinket == Blueprint then
        Balatro_Expansion:BluePrint(player, false)
        TrinketValues.LastBPitem = 0
    end
    if trinket == Brainstorm then
        Balatro_Expansion:BrainStorm(player,false)
    end
    if trinket == Egg then
        Balatro_Expansion:EGG(player, true)
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, Balatro_Expansion.OnTrinketRemoval)

function Balatro_Expansion:OnItemPickup(item,_,first,_,_,player)
    if player:HasTrinket(Blueprint) and first then
        Balatro_Expansion.WantedEffect = Blueprint
        Balatro_Expansion:BluePrint(player, true)
    end
    if TrinketValues.FirstBrain and player:HasTrinket(Brainstorm) then
        Balatro_Expansion.WantedEffect = Brainstorm
        Balatro_Expansion:BrainStorm(player, true)
    end
    if player:HasTrinket(Abstract_joker) then
        Balatro_Expansion.WantedEffect = Abstract_joker
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Evensteven) then
        Balatro_Expansion.WantedEffect = Evensteven
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Joker_stencil) then
        Balatro_Expansion.WantedEffect = Joker_stencil
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Oddtodd) then
        Balatro_Expansion.WantedEffect = Oddtodd
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(Supernova) then
        local itemconfig = ItemsConfig:GetCollectible(item)
        if itemconfig.Type == ItemType.ITEM_ACTIVE then
            if not TrinketValues.Supernova[item] then
                TrinketValues.Supernova[item] = 0
            end
            Balatro_Expansion.WantedEffect = Supernova
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end 
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Balatro_Expansion.OnItemPickup)

function Balatro_Expansion:AlwaysOnNewRoom()
    Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_SHOP then
        TrinketValues.ShopEntered = true
    elseif Room == RoomType.ROOM_TREASURE then
        TrinketValues.TreasureEntered = true
    end
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if TrinketValues.Cloud_9 == 0 then
            if player:GetTrinketMultiplier(Cloud_nine) > 1 then
                TrinketValues.Cloud_9 = 5
            else
                TrinketValues.Cloud_9 = 9
            end
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM,CallbackPriority.LATE, Balatro_Expansion.AlwaysOnNewRoom)

function Balatro_Expansion:OnNewRoom()
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if player:HasTrinket(Misprint) then --plus mult jokers
            Balatro_Expansion.WantedEffect = Misprint
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(Bloodstone) then
            Balatro_Expansion.WantedEffect = Bloodstone
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if TrinketValues.Cloud_9 == 0 then
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnNewRoom)


function Balatro_Expansion:OnSpecificRoomEnter()
   
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.OnSpecificRoomEnter)

--determines if shop/treasures can be skipped this floor
function Balatro_Expansion:AlwaysOnNewFloor()
    TrinketValues.DamageTakenFloor = 0
    TrinketValues.Dna = true
    TrinketValues.Rocks = 0
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if  player:HasTrinket(Stone_joker) then
            Balatro_Expansion.WantedEffect = Stone_joker
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end

    --DETERMINATION FOR THE PRESENCE OF TRESURES ROOMS/SHOPS--
    --TRUE = NO shops/treasures
    --FALSE = AVAILABLE Shops/treasures

    local Level = Game:GetLevel()
    if Level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
        TrinketValues.Labyrinth = 2
    else
        TrinketValues.Labyrinth = 1
    end
    if Level:IsAscent() then
        TrinketValues.ShopEntered = true
        TrinketValues.TreasureEntered = true
    end
    local Greed = Game:IsGreedMode()
    local Stage = Level:GetAbsoluteStage()
    TrinketValues.ShopEntered = false
    TrinketValues.TreasureEntered = false
    local LevelName = Level:GetName()
    if Stage == LevelStage.STAGE4_1 and not Greed  then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
            TrinketValues.TreasureEntered = true
        end
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_SILVER_DOLLAR) then
            TrinketValues.ShopEntered = true
        end
    elseif LevelName == "Sheol" and not Greed then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_WICKED_CROWN) then
            TrinketValues.TreasureEntered = true
            TrinketValues.ShopEntered = true
        end

    elseif LevelName == "Cathedral" then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_HOLY_CROWN) then
            TrinketValues.TreasureEntered = true
            TrinketValues.ShopEntered = true
        end
    elseif LevelName == "Shop" then --greed mode floor
        TrinketValues.TreasureEntered = true
    elseif Stage >= LevelStage.STAGE6 then --anything after sheol/cathedral
        TrinketValues.TreasureEntered = true
            TrinketValues.ShopEntered = true
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, Balatro_Expansion.AlwaysOnNewFloor)

function Balatro_Expansion:OnNewFloor()
    --print("new floor")
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        
        if player:HasTrinket(Invisible_Joker) then --activate jokers
            Balatro_Expansion.WantedEffect = Invisible_Joker
            Balatro_Expansion:InvisibleJoker(player) --activates the invisible joker trinket
        end
        if player:HasTrinket(Popcorn) then
            TrinketValues.Popcorn = TrinketValues.Popcorn - 0.4
            Balatro_Expansion.WantedEffect = Popcorn
            if TrinketValues.Popcorn <= 0.3 then
                repeat
                    player:TryRemoveTrinket(Popcorn)
                    player:TryRemoveSmeltedTrinket(Popcorn)
                until not player:HasTrinket(Popcorn)
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                TrinketValues.Popcorn = 2 --resets in case the player gets another one
                return --does nothing, just stops the function
            end
                
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if  player:HasTrinket(Rocket) then
            Balatro_Expansion.WantedEffect = Rocket
            Balatro_Expansion:rocket(player)
        end
        if player:HasTrinket(Red_card) then
            if TrinketValues.ShopEntered == false then
                TrinketValues.Red_card = TrinketValues.Red_card + 0.20
            end
            if TrinketValues.TreasureEntered == false then
                TrinketValues.Red_card = TrinketValues.Red_card + (0.20 * TrinketValues.Labyrinth)
            end
            Balatro_Expansion.WantedEffect = Red_card
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(Riff_raff) then
            Balatro_Expansion.WantedEffect = Riff_raff
            Balatro_Expansion:RiffRaff(player)
        end
        if player:HasTrinket(Golden_joker) then
            Balatro_Expansion.WantedEffect = Golden_joker
            Balatro_Expansion:Goldenjoker(player)
        end
        if player:HasTrinket(Madness) then
            RNG = player:GetTrinketRNG(Madness)
            if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B and  player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
                    if player:GetNumCoins() > 0 then
                        for i = 1, player:GetTrinketMultiplier(Madness), 1 do
                            TrinketValues.Madness = TrinketValues.Madness + (math.floor(player:GetNumCoins()/5) / 100)
                            player:AddCoins(- player:GetNumCoins())
                        end
                    end
                else --NON KEEPER ONLY
                    
                    for i = 1, player:GetTrinketMultiplier(Madness), 1 do
                        if player:GetMaxHearts() > 2 then
                    
                            player:AddMaxHearts(-2, true)
                            TrinketValues.Madness = TrinketValues.Madness + 0.05
                        elseif player:GetMaxHearts() == 0 then
                    
                            if player:GetSoulHearts() > 2 then
                                player:AddSoulHearts(-2)
                            TrinketValues.Madness = TrinketValues.Madness + 0.05
                            end
                        end
                    end
                end
            end
            for i = 0, player:GetTrinketMultiplier(Madness) , 1 do
                local ItemCount = player:GetCollectibleCount()
                if ItemCount == 0 then
                    break
                end
                local Item
                repeat
                    Item = RNG:RandomInt(1, CollectibleType.NUM_COLLECTIBLES)
                until player:HasCollectible(Item, true, false)
                player:RemoveCollectible(Item)
                TrinketValues.Madness = TrinketValues.Madness + 0.05
            end
            Balatro_Expansion.WantedEffect = Madness
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end

        if player:HasTrinket(Sacrificial_dagger) then
            local Active = player:GetActiveItem(i)
            if Active ~= 0 then
                --print("Active")
                player:RemoveCollectible(Active, true, i)
                TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                sfx:Play(SLICESOUND)
            end
            if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B and  player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
                    if player:GetNumCoins() > 0 then
                        for i = 1, player:GetTrinketMultiplier(Sacrificial_dagger), 1 do
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + player:GetNumCoins()/100
                            player:AddCoins(- player:GetNumCoins())
                            sfx:Play(SLICESOUND)
                        end
                    end
                else --KEEPER ONLY
                    for i = 1, player:GetTrinketMultiplier(Sacrificial_dagger), 1 do
                        if player:GetMaxHearts() > 2 or (player:GetMaxHearts() == 2 and player:GetSoulHearts() > 0)then
                    
                            player:AddMaxHearts(-2, true)
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                            sfx:Play(SLICESOUND)
                        elseif player:GetSoulHearts() > 2 then

                            player:AddSoulHearts(-2)
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                            sfx:Play(SLICESOUND)
                        end
                    end
                end
            end
            Balatro_Expansion.WantedEffect = Sacrificial_dagger
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(Gros_michael) then
            local RNG = player:GetTrinketRNG(Gros_michael) 
            local Chance = 0.34
            if RNG:RandomFloat() <= Chance then
                TrinketValues.MichaelDestroyed = true
                Balatro_Expansion.WantedEffect = "MCdestroyed"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                for i=0, player:GetMaxTrinkets() - 1, 1 do
                    local Trinket = player:GetTrinket(i)
                    if Trinket == (Gros_michael + TrinketType.TRINKET_GOLDEN_FLAG) then
                        TrinketValues.GoldenMichelGone = true 
                    end
                end 
                repeat
                    player:TryRemoveTrinket(Gros_michael)
                    player:TryRemoveSmeltedTrinket(Gros_michael)
                until not player:HasTrinket(Gros_michael)
            else
                Balatro_Expansion.WantedEffect = "MCsafe"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Cavendish) then
            local RNG = player:GetTrinketRNG(Cavendish) 
            local Chance = 0.002
            if RNG:RandomFloat() <= Chance and player:GetTrinketMultiplier(Cavendish) == 1 then --unlucky man
                Balatro_Expansion.WantedEffect = "MCdestroyed"
                TrinketValues.MichaelDestroyed = false
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                repeat
                    player:TryRemoveTrinket(Cavendish)
                    player:TryRemoveSmeltedTrinket(Cavendish)
                until not player:HasTrinket(Cavendish)
            else
                Balatro_Expansion.WantedEffect = "MCsafe"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Cartomancer) then
            Balatro_Expansion.WantedEffect = Cartomancer
            Balatro_Expansion:CArtomancer(player)
        end
        if player:HasTrinket(Egg) then
            --print("egg")
            Balatro_Expansion.WantedEffect = Egg
            Balatro_Expansion:EGG(player, false)
        end
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Balatro_Expansion:.OnNewFloor)


--AGGIUNGI ROBA QUANDO SERVIRà
---@param pickup EntityPickup
function Balatro_Expansion:PrePickupCollision(pickup, collider)
    
end
--Balatro_Expansion::AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Balatro_Expansion.PrePickupCollision)



function Balatro_Expansion:OnPickupCollision(pickup, collider,_)
    --checks who collided
    if collider.GetType(collider) == EntityType.ENTITY_PLAYER then --checks if a player collided with the pickup
        
        local player = collider:ToPlayer()
        if player:HasTrinket(Cloud_nine) then
            if TrinketValues.Cloud_9 == 0 then
                if player:GetTrinketMultiplier(Cloud_nine) == 1 then
                    TrinketValues.Cloud_9 = 5
                else
                    TrinketValues.Cloud_9 = 9
                end
            else
                TrinketValues.Cloud_9 = TrinketValues.Cloud_9 - 1
            end
            if player:GetTrinketMultiplier(Cloud_nine) > 1 and TrinketValues.Cloud_9 > 5 then
                TrinketValues.Cloud_9 = 5
            end
            Balatro_Expansion.WantedEffect = Cloud_nine
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
        if player:HasTrinket(Smeared_joker) then
            Balatro_Expansion.WantedEffect = Smeared_joker
            Balatro_Expansion:SmearedJoker(player, pickup)
        end

        if pickup.Variant == PickupVariant.PICKUP_COIN then 
        
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB then

        elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
                
            if player:HasTrinket(Joker_stencil) then  --times mult jokers
                Balatro_Expansion.WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        
        elseif pickup.Variant == PickupVariant.PICKUP_PILL then
            if player.HasTrinket(Joker_stencil) then  --times mult jokers
                Balatro_Expansion.WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        
        end

    else
        return nil
    end       
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Balatro_Expansion.OnPickupCollision)

function Balatro_Expansion:AlwaysOnCardUse(card,player,_)
    --print("card used")
    --print(TrinketValues.Fortune_Teller)
    local CardConfig = ItemsConfig:GetCard(card) 
    if CardConfig.CardType == ItemConfig.CARDTYPE_TAROT then --normal tarot
        
        TrinketValues.Fortune_Teller = TrinketValues.Fortune_Teller + (0.05 * player:GetTrinketMultiplier(Fortuneteller))
    elseif CardConfig.CardType == ItemConfig.CARDTYPE_TAROT_REVERSE then --reverse tarot
        TrinketValues.Fortune_Teller = TrinketValues.Fortune_Teller - 0.05
        if TrinketValues.Fortune_Teller < 0 then
            TrinketValues.Fortune_Teller = 0
        end
    end
    if player:HasTrinket(Fortuneteller) then
        --print("fortuneteller")
        Balatro_Expansion.WantedEffect = Fortuneteller
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_CARD, Balatro_Expansion.AlwaysOnCardUse)


function Balatro_Expansion:OnCardUse(card,player,_)
    if player:HasTrinket(Dna) then
        Balatro_Expansion:DNA(player, PickupVariant.PICKUP_TAROTCARD, card)
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_CARD, Balatro_Expansion.OnCardUse)

function Balatro_Expansion:OnPillUse(pill,player,_)
    if player:HasTrinket(Dna) then
        Balatro_Expansion:DNA(player, PickupVariant.PICKUP_PILL, pill)
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_PILL, Balatro_Expansion.OnPillUse)

function Balatro_Expansion:OnActiveUse(Active,_,player,_,_,_)
    if player:HasTrinket(Dna) then
        --needs a frame to maket the single use active items disappear
        Isaac.CreateTimer(function ()
            Balatro_Expansion:DNA(player, PickupVariant.PICKUP_COLLECTIBLE, Active)
        end, 1, 1, true)
        
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_ITEM, Balatro_Expansion.OnActiveUse)


function Balatro_Expansion:OnConsumableRemove(player,_,_) --whenever a card/pill is lost from the player
        if player:HasTrinket(Joker_stencil) then  --times mult jokers
            Balatro_Expansion.WantedEffect = Joker_stencil
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, Balatro_Expansion.OnConsumableUse)
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, Balatro_Expansion.OnConsumableUse)

---@param RockType GridEntityType
function Balatro_Expansion:OnRockDestroy(_,RockType,_)
    
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
            if player:HasTrinket(Stone_joker) then
                local Multiplier = 1

                if RockType == GridEntityType.GRID_ROCKT then --tinted rocks give 3X progress
                    Multiplier = 3
                elseif RockType == GridEntityType.GRID_ROCK_SS then --super tinted rock give 5X progress
                    Multiplier = 5
                end

                if TrinketValues.Stone_joker <= 25 then
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.06 * Multiplier)
                elseif  TrinketValues.Stone_joker <= 75 then
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.03 * Multiplier)
                else
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.01 * Multiplier)
                end

                Balatro_Expansion.WantedEffect = Stone_joker
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                break
            end
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, Balatro_Expansion.OnRockDestroy, GridEntityType.GRID_ROCK)

---@param player EntityPlayer
function Balatro_Expansion:OnUpdate(player)
    local NowCoins = player:GetNumCoins()
    local NowBombs = player:GetNumBombs()
    local NowKeys = player:GetNumKeys()
    --local NowHearts = player:GetHearts()
    if NowCoins ~= PastCoins then
        if player:HasTrinket(Joker_stencil) then
            if NowCoins == 0 or PastCoins == 0 then
                Balatro_Expansion.WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Bull) then
            Balatro_Expansion.WantedEffect = Bull
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
        PastCoins = NowCoins
    end

    if NowBombs ~= PastBombs then
        if player:HasTrinket(Joker_stencil) then
            if NowBombs == 0 or PastBombs == 0 then
                Balatro_Expansion.WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Onix_agate) then
            Balatro_Expansion.WantedEffect = Onix_agate
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        PastBombs = NowBombs
    end

    if NowKeys ~= PastKeys then
        if player:HasTrinket(Joker_stencil) then
            if NowKeys == 0 or PastKeys == 0 then
                Balatro_Expansion.WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Arrowhead) then
            Balatro_Expansion.WantedEffect = Arrowhead
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
        PastKeys = NowKeys
    end

    --if NowHearts ~= PastHearts then
        
        --PastHearts = NowHearts
    --end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Balatro_Expansion.OnUpdate)

---@param player EntityPlayer
function Balatro_Expansion:OnRoomClear(player)
    --print("cleared")

    --MANY TRINKETS ONLY ACTIVATE IN GREED MODE WHEN THE MAJOR WAVE CHUNKS ARE COMPLETED
    local Wave = Game:GetLevel().GreedModeWave --current wave in greed mode
    local WantedWaves = {}
    local IsGreed = Game:IsGreedMode()
    if IsGreed then
        if Game:IsHardMode() then
            WantedWaves = {9,11,12} --greedier last waves
        else
            WantedWaves = {8,10,11} --greed last waves
        end
    end
    --if greed then only on specific waves, else happens anyways
    if not IsGreed or Balatro_Expansion:Contained(WantedWaves, Wave) or Game:GetLevel():GetName() == "shop" then
        --print("consider clear")
    if player:HasTrinket(Vagabond) then
        --print("vagabond")
        Balatro_Expansion.WantedEffect = Vagabond
        Balatro_Expansion:VAgabond(player)
    end
    if player:HasTrinket(Rough_gem) then
        Balatro_Expansion.WantedEffect = Rough_gem
        Balatro_Expansion:RoughGem(player)
    end
    if player:HasTrinket(Loyalty_card) then
        if TrinketValues.Loyalty_card == 0 then
            if player:GetTrinketMultiplier(Loyalty_card) == 1 then
                TrinketValues.Loyalty_card = 5
            else
                TrinketValues.Loyalty_card = 3
            end
        else
            TrinketValues.Loyalty_card = TrinketValues.Loyalty_card - 1
        end
        if player:GetTrinketMultiplier(Loyalty_card) > 1 and TrinketValues.Loyalty_card > 4 then
            TrinketValues.Loyalty_card = 4
        end
        Balatro_Expansion.WantedEffect = Loyalty_card
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Delayed_gratification) then
        Balatro_Expansion:DelayedGratification(player)
    end
    end
    --EXCEPTIONS TO THE GREED MODE WAVE CHECK
    if player:HasTrinket(Icecream) then
        Balatro_Expansion.WantedEffect = Icecream
        TrinketValues.Ice_cream = TrinketValues.Ice_cream - 0.05
        if TrinketValues.Ice_cream <= 0 then
            repeat
                player:TryRemoveTrinket(Icecream)
                player:TryRemoveSmeltedTrinket(Icecream)
            until not player:HasTrinket(Icecream)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
            TrinketValues.Ice_cream = 1 --resets in case the player find another one
            return --does nothing, just stops the function
        end
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(Green_joker) then
        Balatro_Expansion.WantedEffect = Green_joker
        TrinketValues.Green_joker = TrinketValues.Green_joker + (0.04 * player:GetTrinketMultiplier(Green_joker))
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Supernova) then
        for i = 0, 1, 1 do
            local Active = player:GetActiveItem(i)
            if Active ~= 0 then
                TrinketValues.Supernova[Active] = TrinketValues.Supernova[Active] + (0.04 * player:GetTrinketMultiplier(Supernova))
            end
        end
        Balatro_Expansion.WantedEffect = Supernova
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.OnRoomClear)

function Balatro_Expansion:AlwaysOnTakenDamage(_)
    TrinketValues.DamageTakenRoom = TrinketValues.DamageTakenRoom + 1
    TrinketValues.DamageTakenFloor = TrinketValues.DamageTakenFloor + 1
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Balatro_Expansion.AlwaysOnTakenDamage, EntityType.ENTITY_PLAYER)

function Balatro_Expansion:OnTakenDamage(player,_,_,_,_)
    player = player:ToPlayer() --initially it's a generic entity
    if player:HasTrinket(Ramen) then
        Balatro_Expansion.WantedEffect = Ramen
        TrinketValues.Ramen = TrinketValues.Ramen - 0.02
        if TrinketValues.Ramen <= 1 then
            repeat
                player:TryRemoveTrinket(Ramen)
                player:TryRemoveSmeltedTrinket(Ramen)
            until not player:HasTrinket(Ramen)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            TrinketValues.Ramen = 1.3 --resets in case the player find another one
            return
        end
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Green_joker) then
        TrinketValues.Green_joker = TrinketValues.Green_joker - 0.5
        if TrinketValues.Green_joker < 0 then
            TrinketValues.Green_joker = 0
        end
        Balatro_Expansion.WantedEffect = Green_joker
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Balatro_Expansion.OnTakenDamage, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function Balatro_Expansion:OnShopPurchase(_,player,cost)
    if player:HasTrinket(Hallucination) then
        Balatro_Expansion.WantedEffect = Hallucination
        Balatro_Expansion:HAllucination(player, cost)
    end
    if player:HasTrinket(Swashbuckler) then
        --print(cost)
        local increase = 0
        if cost > 0 then
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B) then
                increase = (cost * 0.01)
            else
                increase = (cost * 0.02)
            end
            
        elseif cost > PickupPrice.PRICE_FREE then
            if cost == PickupPrice.PRICE_ONE_HEART or cost == PickupPrice.PRICE_ONE_SOUL_HEART or cost == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART or cost == PickupPrice.PRICE_SOUL then
                
                increase = 0.20
            elseif cost == PickupPrice.PRICE_TWO_HEARTS or cost == PickupPrice.PRICE_TWO_SOUL_HEARTS or cost == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS then
                
                increase = 0.40
            elseif cost == PickupPrice.PRICE_THREE_SOULHEARTS then

                increase = 0.25
            elseif cost == PickupPrice.PRICE_SPIKES then

                increase = 0.10
            end
        end
        TrinketValues.Swashbuckler = TrinketValues.Swashbuckler + increase
        if increase > 0 then
            Balatro_Expansion.WantedEffect = Swashbuckler
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, Balatro_Expansion.OnShopPurchase)

function Balatro_Expansion:OnDeath(player)
    if player:HasTrinket(Mr_bones) then
        Balatro_Expansion.WantedEffect = Mr_bones
        Balatro_Expansion:MrBones(player)
    end
end
--Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, Balatro_Expansion:OnDeath)

function Balatro_Expansion:OnRestock(partial)
    --print("restock")
    for i = 0, Game:GetNumPlayers() - 1, 1 do
        local player = Game:GetPlayer(i)
        if player:HasTrinket(Flash_card) then
            Balatro_Expansion.WantedEffect = Flash_card
            if partial then
                TrinketValues.Flash_card = TrinketValues.Flash_card + 0.05
            else
                TrinketValues.Flash_card = TrinketValues.Flash_card + 0.15
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end

    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, Balatro_Expansion.OnRestock)