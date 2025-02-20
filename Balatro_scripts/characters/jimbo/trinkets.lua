local mod = Balatro_Expansion
-- \_(T_T)_/

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()

--local INVENTORY_RENDERING_POSITION = Vector(20,220) 



--a some trinkets still have their effects/ callbacks in Trinket_Effects.lua and Trinket_Callbacks.lua
--MR.Bones 

function mod:EditionsStats(Player, Flags)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    for i,Edition in ipairs(mod.Saved.Jimbo.Inventory.Editions) do
        if Flags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            if Edition == mod.Edition.HOLOGRAPHIC then
                mod:IncreaseJimboStats(Player,0, 0.5, 1, false, false)
            elseif Edition == mod.Edition.POLYCROME then
                mod:IncreaseJimboStats(Player,0, 0, 1.2, false, false)
            end
        end
        if Flags & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            if Edition == mod.Edition.FOIL then
                mod:IncreaseJimboStats(Player,2.5, 0, 1, false, false)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EditionsStats)


--effects when a card is shot
function mod:OnCardShot(Player,ShotCard,Evaluate)

if not Evaluate then --basically if the room is hostile
    return
end
local Triggers = 1 --how many times the card needs to be activated again
local RandomSeed = Random()
if RandomSeed == 0 then RandomSeed = 1 end --crash fix
---
--retrigger calculation
---
----- PROGRESS CALCULATION------------------
for _,RanOutOfNames in ipairs(mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, 0, true)) do
    for i = 1, Triggers do
        mod.Saved.Jimbo.Progress.Room.SuitUsed[RanOutOfNames] = mod.Saved.Jimbo.Progress.Room.SuitUsed[RanOutOfNames] + 1
    end
end
mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value] = mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value] + 1
mod.Saved.Jimbo.Progress.Blind.Shots = mod.Saved.Jimbo.Progress.Blind.Shots + 1
--------------------------------------------------

for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
    if Joker == 0 then
    elseif Joker == TrinketType.TRINKET_ROUGH_GEM then
        if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Diamond, false) then
            for i = 1, Triggers do
            
                if mod:TryGamble(Player, nil, 0.5) then
                    local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                            RandomVector()*3, nil, CoinSubType.COIN_PENNY, RandomSeed)
                    Coin:ToPickup().Timeout = 50
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
                end
            end
        end
    elseif Joker == TrinketType.TRINKET_DNA then
        if mod.Saved.Jimbo.Progress.Blind.Shots == 1 then --if it's the first fired card in a blind
            table.insert(mod.Saved.Jimbo.FullDeck, mod.Saved.Jimbo.FullDeck[ShotCard.Index])
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
        end --ADDED TO DECK
    elseif Joker == TrinketType.TRINKET_BLOODSTONE then
        if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Heart, false) then
            for i = 1, Triggers do
            
                if mod:TryGamble(Player, nil, 0.5) then
                    
                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index]
                    mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.2")
                end
            end
        end
    end
end


--after the first deck got finished, no longer activate card effects
--(joker effects always activate no matter what)
Isaac.RunCallback("CARD_SHOT_FINAL",Player,ShotCard,Triggers, mod.Saved.Jimbo.FirstDeck)

Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)


end
mod:AddCallback("CARD_SHOT", mod.OnCardShot)


function mod:OnHandDiscard(Player)

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise
    --cycles between all the held jokers
    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if Joker == 0 then
        elseif Joker == TrinketType.TRINKET_RAMEN then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - mod.Saved.Jimbo.HandSize
            if mod.Saved.Jimbo.Progress.Inventory[Index] == 0 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                local Loss = mod.Saved.Jimbo.HandSize / 100
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-"..tostring(Loss).."X")
            end
        
        elseif Joker == TrinketType.TRINKET_GREEN_JOKER then
            local InitialProg = mod.Saved.Jimbo.Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 4
                if mod.Saved.Jimbo.Progress.Inventory[Index] < 0 then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = 0
                end
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-"..tostring((InitialProg - mod.Saved.Jimbo.Progress.Inventory[Index])*0.05))
        
            end
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

end
mod:AddCallback("HAND_DISCARD", mod.OnHandDiscard)


--effects when a joker gets sold
---@param Player EntityPlayer
function mod:OnJokerSold(Player,Joker,SlotSold)
    --print("sold")
    if Joker == TrinketType.TRINKET_INVISIBLE_JOKER then
        if mod.Saved.Jimbo.Progress.Inventory[SlotSold] ~= 3 then
            return
        end
        local HasSomethingElse = false
        for _, trinket in ipairs(mod.Saved.Jimbo.Inventory) do
            --can only copy something other than itself and nothing
            if trinket ~= 0 and trinket ~= TrinketType.TRINKET_INVISIBLE_JOKER then
                HasSomethingElse = true
                break
            end
        end

        if HasSomethingElse then --no need if player is poor
            local RandomJoker
            local Rng = Player:GetTrinketRNG(TrinketType.TRINKET_INVISIBLE_JOKER)
            repeat
                RandomJoker = mod.Saved.Jimbo.Inventory[Rng:RandomInt(1, #mod.Saved.Jimbo.Inventory)]
            until RandomJoker ~= 0 and RandomJoker ~= TrinketType.TRINKET_INVISIBLE_JOKER
            --print(RandomJoker)
            mod.Saved.Jimbo.Inventory[SlotSold] = RandomJoker
        end
    elseif false then

    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback("JOKER_SOLD", mod.OnJokerSold)

--effects when a blind gets completed
function mod:OnBlindClear(BlindType)

    for i,v in pairs(mod.Saved.Jimbo.Progress.Blind) do

        if type(v) == "table" then

            for j,_ in ipairs(mod.Saved.Jimbo.Progress.Blind[i]) do
                mod.Saved.Jimbo.Progress.Blind[i][j] = 0
            end
        else
            mod.Saved.Jimbo.Progress.Blind[i] = 0 --resets the blind progress
        end
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    --cycles between all the held jokers
    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        if Joker == 0 then --could save some time
        elseif Joker == TrinketType.TRINKET_INVISIBLE_JOKER then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            local Value = mod.Saved.Jimbo.Progress.Inventory[Index]

            if Value < 3 then --still charging
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, tostring(Value).."/3")
            else --usable
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "ACTIVE!")
            end

        elseif Joker == TrinketType.TRINKET_ROCKET then
            --spawns this many coins
            local MoneyAmount = mod.Saved.Jimbo.Progress.Inventory[Index]
            for i=1, MoneyAmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmount).." $")
            --on boss beaten it upgrades
            if BlindType == mod.BLINDS.BOSS then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "Upgrade!")
            end
        elseif Joker == TrinketType.TRINKET_GOLDEN_JOKER then

            --spawns this many coins
            local MoneyAmmount = 3
            for i=1, MoneyAmmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmmount).." $")

        elseif Joker == TrinketType.TRINKET_RIFF_RAFF then
            local RandomJoker = mod:GetRandom(mod.Trinkets, Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF), true)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                       RandomVector()*3, nil, RandomJoker, RandomSeed)

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")

        elseif Joker == TrinketType.TRINKET_CARTOMANCER then
            local RandomTarot = Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF):RandomInt(1,22)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, nil, RandomTarot, RandomSeed)

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")

        elseif Joker == TrinketType.TRINKET_EGG then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 2

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Upgrade!")

        elseif Joker == TrinketType.TRINKET_DELAYED_GRATIFICATION then

            local NumCoins = Player:GetHearts()/2 - 1 --gives coins basing on how many extra heatrs are left

            for i = 1, NumCoins do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, nil, CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(NumCoins).."$")
        

        elseif Joker == TrinketType.TRINKET_CLOUD_NINE then
            local Nines = 0
            for _,card in ipairs(mod.Saved.Jimbo.FullDeck) do
                if card.Value == 9 then
                    Nines = Nines + 1
                end
            end
            for i=1, Nines do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, nil, CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(Nines).."$")
        
        elseif Joker == TrinketType.TRINKET_POPCORN then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1
            if mod.Saved.Jimbo.Progress.Inventory[Index] == 0 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.2")
            end

        elseif Joker == TrinketType.TRINKET_MADNESS then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.15X")
            
            local Removable = {}
            for i, v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if i ~= Index and v ~= 0 then --any joker other than this one
                    table.insert(Removable, i)
                end
            end
            if Removable ~= {} then --if at leat one is present
                local Rindex = mod:GetRandom(Removable, Player:GetTrinketRNG(TrinketType.TRINKET_MADNESS))
                mod.Saved.Jimbo.Inventory.Jokers[Rindex] = 0
                mod.Saved.Jimbo.Inventory.Editions[Rindex] = 0

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY,true)

    ::skip_player::

    end
end
mod:AddCallback("BLIND_CLEARED", mod.OnBlindClear)

function mod:OnBlindStart(BlindType)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        if mod:JimboHasTrinket(Player, TrinketType.TRINKET_RIFF_RAFF) then
            local JokerIndexes = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_RIFF_RAFF)
            for _, Index in ipairs(JokerIndexes) do

                local RandomJoker = mod:GetRandom(mod.Trinkets, Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF), true)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                           RandomVector()*3, nil, RandomJoker, RandomSeed)

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "ACTIVATE!")
                
            end

        end


        ::skip_player::
    end
end
--mod:AddCallback("BLIND_STARTED", mod.OnBlindStart) remained unused due to similarity with BLIND_CLEARED


---@param Player EntityPlayer
function mod:OnPackOpened(Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if Joker == TrinketType.TRINKET_HALLUCINATION then
            local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_HALLUCINATION)
        if TrinketRNG:RandomFloat() < 0.5 then

            local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, nil, RandomTarot, RandomSeed)
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
        end
        end
    end

end
mod:AddCallback("PACK_OPENED", mod.OnPackOpened)

function mod:OnPackSkipped(Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if Joker == 0 then
        elseif Joker == TrinketType.TRINKET_RED_CARD then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.15")
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

end
mod:AddCallback("PACK_SKIPPED", mod.OnPackSkipped)


function mod:OnCardUsed(CardUsed,Player,Flag)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or
        Flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then
        return
    end

    for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if Joker == TrinketType.TRINKET_CARTOMANCER then
            if CardUsed <= Card.CARD_WORLD then --is a tarot
                local Step = 1
                if Flag & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
                    Step = 2
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + Step
            
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.05")
            end
        end
    end
        
    --Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)

end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUsed)


--usually used as a kind of hand played (ex. Vagabond)
function mod:OnRoomClear(IsBoss)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if Joker == 0 then --could save some time
        elseif Joker == TrinketType.TRINKET_VAGABOND then
            if Player:GetNumCoins() < 4 then
                local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_VAGABOND)

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, RandomTarot, RandomSeed)
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
            end

        elseif Joker == TrinketType.TRINKET_ICECREAM then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1
            if mod.Saved.Jimbo.Progress.Inventory[Index] == 0 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.Blue, mod.Sounds.ACTIVATE, "-0.1")
            end
        elseif Joker == TrinketType.TRINKET_GREEN_JOKER then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.05")
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    ::skip_player::
    end
end
mod:AddCallback("TRUE_ROOM_CLEAR", mod.OnRoomClear)


function mod:OnNewRoomJokers()

    for i,v in pairs(mod.Saved.Jimbo.Progress.Room) do
        if type(v) == "table" then

            for j,_ in ipairs(mod.Saved.Jimbo.Progress.Room[i]) do
                mod.Saved.Jimbo.Progress.Room[i][j] = 0
            end
        else

            mod.Saved.Jimbo.Progress.Room[i] = 0 --resets the blind progress
        end
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == TrinketType.TRINKET_MISPRINT then
                local MisDMG = Player:GetTrinketRNG(TrinketType.TRINKET_MISPRINT):RandomFloat()
                mod.Saved.Jimbo.Progress.Inventory[Index] = MisDMG
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(MisDMG))
            end
        end

        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        --Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomJokers)

function mod:OnNewLevelJokers()

    for i,_ in pairs(mod.Saved.Jimbo.Progress.Floor) do
        mod.Saved.Jimbo.Progress.Floor[i] = 0 --resets the blind progress
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise


        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevelJokers)


--adjusts the "copy" values for brainstorm and blueprint whenever the inventory is changed
function mod:CopyAdjustments(Player)

    for i,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        local StartI = i
        repeat --continues to 

            if Joker == TrinketType.TRINKET_BLUEPRINT then --copies the joker to its right
                i = i + 1
                Joker = mod.Saved.Jimbo.Inventory.Jokers[i] or 0 --if nothing is there then just put 0
            
                if i == StartI then --some combinations can lead to an infinite loop
                    Joker = 0
                end

            elseif Joker == TrinketType.TRINKET_BRAINSTORM then --copies the leftmost joker
                i = 1
                Joker = mod.Saved.Jimbo.Inventory.Jokers[i] or 0 --if nothing is there then just put 0
            
                if i == StartI then --some combinations can lead to an infinite loop
                    Joker = 0
                end
            else
                Joker = 0 --needed to check if bp or bs copied something
            end
        until (Joker ~= TrinketType.TRINKET_BLUEPRINT and Joker ~= TrinketType.TRINKET_BRAINSTORM)

        --at this point if Joker~=0 then StartI is the index of a bb or bs

        if Joker ~= 0 then --ItemsConfig:GetTrinket(Joker) is nil otherwise

            if ItemsConfig:GetTrinket(Joker):HasCustomTag("copy") then --not every joker can be copied
                mod.Saved.Jimbo.Progress.Inventory[StartI] = Joker --saves in its progress the joker it is copying
            else
                mod.Saved.Jimbo.Progress.Inventory[StartI] = 0 --if not compatible
            end
        end

    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback("INVENTORY_CHANGE", mod.CopyAdjustments)



function mod:TearsJokers(Player, _)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == 0 then --could save some time
            elseif Joker == TrinketType.TRINKET_BULL then --this works with mod:OnUpdate() in TrinketCallbacks.lua
                local Tears = Player:GetNumCoins() * 0.1
                mod:IncreaseJimboStats(Player, Tears, 0, 1, false, false)
            
            elseif Joker == TrinketType.TRINKET_STONE_JOKER then
                local StoneCards = 0
                for i,card in ipairs(mod.Saved.Jimbo.FullDeck) do
                    if card.Enhancement == mod.Enhancement.STONE then
                        StoneCards = StoneCards + 1
                    end
                end
                mod:IncreaseJimboStats(Player, 1.25 * StoneCards, 0, 1, false, false)
            
            elseif Joker == TrinketType.TRINKET_ICECREAM then
                --icecream stores how many rooms are "left" in its progress
                mod:IncreaseJimboStats(Player, 0.16 * mod.Saved.Jimbo.Progress.Inventory[Index], 0, 1, false, false)

            elseif Joker == TrinketType.TRINKET_ODDTODD then
                local NumOdd = 0
                for Num = 1,10,2 do
                    NumOdd = NumOdd + mod.Saved.Jimbo.Progress.Room.ValueUsed[Num]
                end
                if NumOdd > mod.Saved.Jimbo.Progress.Inventory[Index] then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.Blue,mod.Sounds.CHIPS,
                    "+"..tostring(0.75*(NumOdd - mod.Saved.Jimbo.Progress.Inventory[Index])))
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = NumOdd --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, 0.75 * NumOdd,0,1, false, false)
            
            elseif Joker == TrinketType.TRINKET_ARROWHEAD then
                local NumSpades = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Spade]
                if NumSpades > mod.Saved.Jimbo.Progress.Inventory[Index] then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.Blue, mod.Sounds.CHIPS,
                    "+"..tostring(1.25*(NumSpades - mod.Saved.Jimbo.Progress.Inventory[Index])))
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = NumSpades --only used to tell when to spawn an effect
            
                mod:IncreaseJimboStats(Player, 1.25 * NumSpades,0,1, false, false)
            end
        end

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.TearsJokers, CacheFlag.CACHE_FIREDELAY)

function mod:DamageJokers(Player,_)

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == 0 then --could save some time
            elseif Joker == TrinketType.TRINKET_JOKER then
                mod:IncreaseJimboStats(Player, 0, 0.2, 1, false, false)

            elseif Joker == TrinketType.TRINKET_ABSTRACT_JOKER then
                local NumJokers = 0
                for j,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                    if Joker ~= 0 then
                        NumJokers = NumJokers + 1
                    end
                end
                mod:IncreaseJimboStats(Player, 0, 0.15 * NumJokers, 1, false, false)

            elseif Joker == TrinketType.TRINKET_MISPRINT then
                mod:IncreaseJimboStats(Player, 0, mod.Saved.Jimbo.Progress.Inventory[Index], 1, false, false)

            elseif Joker == TrinketType.TRINKET_POPCORN then
                mod:IncreaseJimboStats(Player, 0, mod.Saved.Jimbo.Progress.Inventory[Index] * 0.2, 1, false, false)

            elseif Joker == TrinketType.TRINKET_EVENSTEVEN then
                local NumEven = 0
                for Num=2, 10, 2 do
                    NumEven = NumEven + mod.Saved.Jimbo.Progress.Room.ValueUsed[Num]
                end
                if NumEven > mod.Saved.Jimbo.Progress.Inventory[Index] then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULTSOUND,
                    "+"..tostring(0.1*(NumEven - mod.Saved.Jimbo.Progress.Inventory[Index])))
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = NumEven --this is only to tell when to spawn the effect

                mod:IncreaseJimboStats(Player, 0,0.1*NumEven,1, false, false)

            elseif Joker == TrinketType.TRINKET_GREEN_JOKER then
                mod:IncreaseJimboStats(Player, 0,0.05*mod.Saved.Jimbo.Progress.Inventory[Index],1, false, false)
            
            elseif Joker == TrinketType.TRINKET_RED_CARD then
                mod:IncreaseJimboStats(Player, 0,0.15*mod.Saved.Jimbo.Progress.Inventory[Index],1, false, false)
            elseif Joker == TrinketType.TRINKET_CARTOMANCER then
                mod:IncreaseJimboStats(Player, 0,0.05*mod.Saved.Jimbo.Progress.Inventory[Index],1, false, false)
            
            elseif Joker == TrinketType.TRINKET_ONIX_AGATE then
                local NumClubs = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Club]
                if NumClubs > mod.Saved.Jimbo.Progress.Inventory[Index] then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(0.1*(NumClubs - mod.Saved.Jimbo.Progress.Inventory[Index])))
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = NumClubs --only used to tell when to spawn an effect
            
                mod:IncreaseJimboStats(Player, 0,0.1 * NumClubs,1, false, false)
            
            end
        end

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.DamageJokers, CacheFlag.CACHE_DAMAGE)

function mod:DamageMultJokers(Player,_)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == 0 then --could save some time
            elseif Joker == TrinketType.TRINKET_JOKER_STENCIL then
                local EmptySlots = 0
                for i,v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                    if v == 0 then
                        EmptySlots = EmptySlots + 1
                    end
                end
                mod:IncreaseJimboStats(Player, 0,0, 1 + 0.15*EmptySlots, false, false)
            elseif Joker == TrinketType.TRINKET_RAMEN then
                mod:IncreaseJimboStats(Player,0,0,1 + 0.01*mod.Saved.Jimbo.Progress.Inventory[Index],false,false)
            elseif Joker == TrinketType.TRINKET_MADNESS then
                mod:IncreaseJimboStats(Player,0,0,1 + 0.15*mod.Saved.Jimbo.Progress.Inventory[Index],false,false)
            elseif Joker == TrinketType.TRINKET_BLOODSTONE then
                mod:IncreaseJimboStats(Player,0,0,1 + 0.15*mod.Saved.Jimbo.Progress.Inventory[Index],false,false)
            end
        end

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.DamageMultJokers, CacheFlag.CACHE_DAMAGE)