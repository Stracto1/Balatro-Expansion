local Game  = Game()
local ItemsConfig = Isaac.GetItemConfig()
---------------CURSES/CHALLENGES-----------------
-------------------------------------------------
--all the code regarding the custom challenges and curses
--since i'm a masochist, the curse callbacks are only added when needed just like the trinket's do

-----------CALLBACK SYSTEM/CHALLENGE FUNCTIONALITY--------------------

--restores the callbacks for the curses
function Balatro_Expansion:ChallengeSetup(Continued)
    --challenge functionality reset
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.ChallengeRoomClear)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.ChallengeRoomEntrance)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, Balatro_Expansion.ShopItems)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_GET_CARD, Balatro_Expansion.ChallengeCards)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_GET_TRINKET, Balatro_Expansion.ChallengeTrinkets)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, Balatro_Expansion.DoorBehaviour)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_PICKUP_INIT, Balatro_Expansion.CoinWaveSpawn, PickupVariant.PICKUP_COIN)

    --curse functions reset
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_NPC_INIT, Balatro_Expansion.CurseNPCInit)
    Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_NPC_UPDATE, Balatro_Expansion.CurseNPCUpdate)

    --only adds the required callbacks if it's a challenge
    if Balatro_Expansion:Contained(Balatro_Expansion.Challenges, Game.Challenge) then
        --sets starting money
        if not Continued then
            Game:GetPlayer(0):AddCoins(4)
        end
        Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.ChallengeRoomClear)
        Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, Balatro_Expansion.ShopItems)
        Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_TRINKET, Balatro_Expansion.ChallengeTrinkets)
        Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_CARD, Balatro_Expansion.ChallengeCards)
        Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.ChallengeRoomEntrance)
        Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, Balatro_Expansion.DoorBehaviour)
        Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Balatro_Expansion.CoinWaveSpawn, PickupVariant.PICKUP_COIN)
        
        local CurrentCurse = Game:GetLevel():GetCurses()
        if CurrentCurse == Balatro_Expansion.AllCurses.THE_WALL then
            Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Balatro_Expansion.CurseNPCInit)
            Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, Balatro_Expansion.CurseNPCUpdate)
        end      
    end
end
Balatro_Expansion:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE ,Balatro_Expansion.ChallengeSetup)

--chooses a random custom curse when needed
function Balatro_Expansion:ChooseChallengeCurse(_)
    --print("curse eval")
    if Balatro_Expansion:Contained(Balatro_Expansion.Challenges, Game.Challenge) then
        --curses callbacks reset
        Balatro_Expansion:RemoveCallback(ModCallbacks.MC_POST_NPC_INIT, Balatro_Expansion.CurseNPCInit)
        Balatro_Expansion:RemoveCallback(ModCallbacks.MC_PRE_NPC_UPDATE, Balatro_Expansion.CurseNPCUpdate)

        local RNG = RNG( Game:GetSeeds():GetStartSeed() )
        local ChosenCurse = RNG:RandomInt(1, #Balatro_Expansion.NormalCurses)
        --only adds the required callbacks to make the curse function
        if Balatro_Expansion.NormalCurses[ChosenCurse] == Balatro_Expansion.AllCurses.THE_WALL then
            --print("wall chosen")
            Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Balatro_Expansion.CurseNPCInit)
            Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, Balatro_Expansion.CurseNPCUpdate)
        end
        return Balatro_Expansion.NormalCurses[ChosenCurse]
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, Balatro_Expansion.ChooseChallengeCurse)


--sets the ammont of coins spawned when waves are cleared
function Balatro_Expansion:ChallengeRoomClear()
    --print("clear")
    local Wave = Game:GetLevel().GreedModeWave
    --print(Wave)
    local Seed = Game:GetSeeds():GetStartSeed()
    if Wave == 9 then
        local Player = Game:GetPlayer(0)

        local Interests = math.floor(Player:GetNumCoins()/5)
        if Interests > 5 then
            Interests = 5
        end

        Player:AddCoins(3)
        Balatro_Expansion:EffectConverter(9, 3,Player,4)

        Isaac.CreateTimer(function ()
            for i = 1, Interests, 1 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position , RandomVector() * 3, Player, CoinSubType.COIN_PENNY, Seed)
                Balatro_Expansion:EffectConverter(8,0,Player,4)
            end 
        end, 21, 1, true)
    
    elseif Wave == 11 then
        TrinketValues.ShopEntered = false
        local Player = Game:GetPlayer(0)

        local Interests = math.floor(Player:GetNumCoins()/5)
        if Interests > 5 then
            Interests = 5
        end

        Player:AddCoins(4)
        Balatro_Expansion:EffectConverter(9, 4,Player,4)

        Isaac.CreateTimer(function ()
            for i = 1, Interests, 1 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position , RandomVector() * 3, Player, CoinSubType.COIN_PENNY, Seed)
                Balatro_Expansion:EffectConverter(8,0,Player,4)
            end 
        end, 21, 1, true)
    elseif Wave == 12 then
        TrinketValues.ShopEntered = false
        local Player = Game:GetPlayer(0)

        local Interests = math.floor(Player:GetNumCoins()/5)
        if Interests > 5 then
            Interests = 5
        end

        Player:AddCoins(5)
        Balatro_Expansion:EffectConverter(9, 5,Player,4)

        Isaac.CreateTimer(function ()
            for i = 1, Interests, 1 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position , RandomVector() * 3, Player, CoinSubType.COIN_PENNY, Seed)
                Balatro_Expansion:EffectConverter(8,0,Player,4)
            end 
        end, 21, 1, true)
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.ChallengeRoomClear)

function Balatro_Expansion:ChallengeRoomEntrance()
    local Room =  Game:GetRoom()
    if Room:GetType() == RoomType.ROOM_SHOP and not TrinketValues.ShopEntered then
        Room:ShopRestockFull()
    elseif Room:GetType() == RoomType.ROOM_GREED_EXIT then
        --for some reason it's bugges and the trapdoor for the next floor won't spawn
        Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Room:GetCenterPos())
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Balatro_Expansion.ChallengeRoomEntrance)

--this part is kind of complicated, so hope i explained it well in the code

--the shops and cursed rooms only open when you completed the wave chunks (normal-boss-nightmare) and NOT in the middle of them
--the golden treasure is always closed, while the silver one is always open 
--the nightmare wave is now mandatory to finish the floor
---@param Door GridEntityDoor
function Balatro_Expansion:DoorBehaviour(Door)

    --door cannot be closed if it leads back to the startin room/if it's a silver treasure/if it's a secret room door
    if not(Door.TargetRoomType == RoomType.ROOM_DEFAULT or Door.TargetRoomType == RoomType.ROOM_BOSS) and Door:GetGridIndex() ~= 179 and Door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and Door.CurrentRoomType ~= RoomType.ROOM_SUPERSECRET then

        --always closes golden treasure
        if Door.TargetRoomType == RoomType.ROOM_TREASURE then
            Door:Bar()
        
        else
            local Wave = Game:GetLevel().GreedModeWave
            if Wave ~= 11 then --waves between the three segments
            
                if Wave ~= 12 then 

                    --closes the exit if it's not after the nightmare wave
                    if Door.TargetRoomType == RoomType.ROOM_GREED_EXIT then
                        Door:Bar()

                    --closes all doors when it's not an in-between of the waves
                    elseif Wave ~= 9 then
                        Door:Bar()
                    end
                end
            else --wave 10 (between boss and nightmare)
            
                --closes the exit after the boss waves
                if Door.TargetRoomType == RoomType.ROOM_GREED_EXIT then
                    Door:Bar()
                end
            end
        end
    end    
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, Balatro_Expansion.DoorBehaviour)

---@param Pickup EntityPickup
function Balatro_Expansion:CoinWaveSpawn(Pickup)
    --the coins given between waves in greed Balatro_Expansione have a nil spawner variable
    if not Pickup.SpawnerEntity then
        Pickup:Remove()
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Balatro_Expansion.CoinWaveSpawn, PickupVariant.PICKUP_COIN)


function Balatro_Expansion:ShopItems(Variant, SubType, _, Price)
    local NewPrice = Price
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local Quality = ItemsConfig:GetCollectible(SubType).Quality
        NewPrice = 2 + (math.ceil(1.83 ^ Quality)) -- |Q0 2 |Q1 4|Q2 6|Q3 9|Q4 13|

        if Game:GetRoom():GetType() == RoomType.ROOM_DEVIL then --little discount for devil deals
            NewPrice = NewPrice - math.floor(NewPrice/4) -- |Q0 2|Q1 3|Q2 5|Q3 7|Q4 10|
        end

    elseif Variant == PickupVariant.PICKUP_TAROTCARD then
        local CardType = ItemsConfig:GetCard(SubType).CardType
        if CardType == ItemConfig.CARDTYPE_SPECIAL then
            NewPrice = 4
        elseif CardType == ItemConfig.CARDTYPE_SUIT or CardType == ItemConfig.CARDTYPE_TAROT_REVERSE then
            NewPrice = 5
        elseif CardType == ItemConfig.CARDTYPE_RUNE then
            NewPrice = 3
        else
            NewPrice = 2
        end

    elseif Variant == PickupVariant.PICKUP_TRINKET then
        NewPrice = 5
        local TrinketConfig = ItemsConfig:GetTrinket(SubType)
        if TrinketConfig:HasCustomTag("givescoins") then --increases cost if the trinket can give you money
            local Tags = TrinketConfig:GetCustomTags()
            NewPrice = NewPrice + 6 - #Tags
        end
    elseif Variant == PickupVariant.PICKUP_LIL_BATTERY or Variant == PickupVariant.PICKUP_BOMB or Variant == PickupVariant.PICKUP_HEART or Variant == PickupVariant.PICKUP_PILL then
        NewPrice = 2
    end

    return NewPrice
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, Balatro_Expansion.ShopItems)


function Balatro_Expansion:ChallengeTrinkets(Trinket, _)
    local FirstTag = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[1] --the mod's trinkets all have a specific first customtag
    
    if not (FirstTag == "mult" or FirstTag == "chips" or FirstTag == "activate" or FirstTag == "multm") then
        repeat
            Trinket = ItemPool:GetTrinket()
            FirstTag = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[1]
        --only allows Balatro_Expansion's trinkets to be chosen
        until FirstTag == "mult" or FirstTag == "chips" or FirstTag == "activate" or FirstTag == "multm"
        return Trinket
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_TRINKET, Balatro_Expansion.ChallengeTrinkets)

---@param Rng RNG
function Balatro_Expansion:ChallengeCards(Rng, SelectedCard, CanBeSuit, CanBeRunes, OnlyRunes)
    --does not allow cards that generate too much money/ do useless things
    if SelectedCard == Card.CARD_ACE_OF_DIAMONDS or SelectedCard == Card.CARD_SOUL_KEEPER or SelectedCard == Card.CARD_DIAMONDS_2 or SelectedCard == Card.CARD_GET_OUT_OF_JAIL then 
        repeat
            SelectedCard = ItemPool:GetCard(Rng:GetSeed(), CanBeSuit, CanBeRunes, OnlyRunes)
        until SelectedCard ~= Card.CARD_ACE_OF_DIAMONDS or SelectedCard ~= Card.CARD_SOUL_KEEPER or SelectedCard ~= Card.CARD_DIAMONDS_2 or SelectedCard ~= Card.CARD_GET_OUT_OF_JAIL
        return SelectedCard
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_GET_CARD, Balatro_Expansion.ChallengeCards)