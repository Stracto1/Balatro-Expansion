local mod = Balatro_Expansion
-- |_(T_T)_/

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

--local INVENTORY_RENDERING_POSITION = Vector(20,220) 


--effects when a card is shot
---@param Player EntityPlayer
function mod:OnCardShot(Player,ShotCard,Evaluate)

if not Evaluate then --basically if the room is hostile
    return
end

local RandomSeed = Random()
if RandomSeed == 0 then RandomSeed = 1 end --crash fix
---
--RETRIGGER CALCULATION + SEALS----
-----------------------------------

local Triggers = 1 --how many times the card needs to be activated again
if ShotCard.Seal == mod.Seals.RED then
    Triggers = Triggers + 1

elseif ShotCard.Seal == mod.Seals.GOLDEN then
    for i=1, Triggers do
        local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                RandomVector()*4 *Player.MoveSpeed^0.5, Player, CoinSubType.COIN_PENNY, RandomSeed)  
        Coin:ToPickup().Timeout = 45 --disappers short after spawning (would be too OP otherwise)
    end
end

----- PROGRESS CALCULATION------------------
--------------------------------------------
for _,RanOutOfNames in ipairs(mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, 0, true)) do

    mod.Saved.Jimbo.Progress.Room.SuitUsed[RanOutOfNames] = mod.Saved.Jimbo.Progress.Room.SuitUsed[RanOutOfNames] + Triggers
end
mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value] = mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value] + Triggers
mod.Saved.Jimbo.Progress.Blind.Shots = mod.Saved.Jimbo.Progress.Blind.Shots + 1
--------------------------------------------------
-----------JOKERS EVALUATION---------------------
------------------------------------------------
for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

    local ProgressIndex = Index
    local Copied = false
    if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

        Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

        --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
        --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

        ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

        Copied = true
    end

    if Joker == 0 then
    elseif Joker == TrinketType.TRINKET_ROUGH_GEM then
        if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Diamond, false) then
            for i = 1, Triggers do
            
                if mod:TryGamble(Player, Player:GetTrinketRNG(TrinketType.TRINKET_ROUGH_GEM), 0.5) then
                    local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                            RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                    Coin:ToPickup().Timeout = 50

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
                end
            end
        end

    elseif Joker == TrinketType.TRINKET_BLOODSTONE then
        if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Heart, false) then
            for i = 1, Triggers do
                if mod:TryGamble(Player, Player:GetTrinketRNG(TrinketType.TRINKET_BLOODSTONE), 0.5) then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 1
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.05")
                end
            end
        end
    elseif Joker == TrinketType.TRINKET_SUPERNOVA then

        --adds how many times the card value got used in the same room
        mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] =  
        mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value]

        mod.Counters.Activated[Index] = 0
        mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(0.01 * mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value]))
    end
end
---------------BASE CARD STATS--------------
-------------------------------------------
    --------EDITIONS EFFECTS----------
    ----------------------------------
    if ShotCard.Edition == mod.Edition.FOIL then
        mod:IncreaseJimboStats(Player,1.25*Triggers, 0, 1,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.EDITIONEFFECT, "+1.25", Vector(0, 20), 0.45)

    elseif ShotCard.Edition == mod.Edition.HOLOGRAPHIC then
        mod:IncreaseJimboStats(Player,0, 0.25 * Triggers, 1,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.EDITIONEFFECT, "+0.25", Vector(0, 20), 0.45)

    elseif ShotCard.Edition == mod.Edition.POLYCROME then
        mod:IncreaseJimboStats(Player,0, 0, 1.2 ^ Triggers,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.EDITIONEFFECT, "X1.2", Vector(0, 20), 0.45)
    end 

    --increases the chips basing on the card value
    local TearsToGet = (mod:GetActualCardValue(ShotCard.Value)/50 + mod.Saved.Jimbo.CardLevels[ShotCard.Value]*0.02) * Triggers
    mod:IncreaseJimboStats(Player,0, 0.02 * mod.Saved.Jimbo.CardLevels[ShotCard.Value] * Triggers, 1,false,true)
    
    local PlayerRNG = Player:GetDropRNG()

    ---------ENHANCEMENT EFFECTS----------
    --------------------------------------
    if ShotCard.Enhancement == mod.Enhancement.STONE then
        TearsToGet = 1.25 * Triggers 
    elseif ShotCard.Enhancement == mod.Enhancement.MULT then
        mod:IncreaseJimboStats(Player, 0, 0.05 * Triggers,1, false,true) 

    elseif ShotCard.Enhancement == mod.Enhancement.BONUS then
        mod:IncreaseJimboStats(Player,0.75 * Triggers, 0 , 1,false,true)    

    elseif ShotCard.Enhancement == mod.Enhancement.GLASS then
        mod:IncreaseJimboStats(Player,0, 0, 1.3 ^ Triggers, false,true)

        if mod:TryGamble(Player, PlayerRNG, 0.1) then
            table.remove(mod.Saved.Jimbo.FullDeck, ShotCard.Index) --PLACEHOLDER SOUND
            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "BROKEN!", Vector(0, 20))
        end 
    elseif ShotCard.Enhancement == mod.Enhancement.LUCKY then
        for i = 1, Triggers do
            if mod:TryGamble(Player, PlayerRNG, 0.2) then
                mod:IncreaseJimboStats(Player, 0, 1, 1, false,true)
                mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.2", Vector(0, 20))
            end 
            if mod:TryGamble(Player, PlayerRNG, 0.05) then
                Player:AddCoins(10)
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+10 $", Vector(0, 20))
            end
        end
    end

    mod:IncreaseJimboStats(Player, TearsToGet, 0, 1,true, true)

end
mod:AddCallback("CARD_SHOT", mod.OnCardShot)


function mod:OnCardHit(Tear, Collider)

    local TearData = Tear:GetData()

    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        local ProgressIndex = Index
        local Copied = false
        if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == TrinketType.TRINKET_DNA then

            if TearData.Num == 1 then --if it's the first fired card in a blind
                TearData.Num = 2 --prevents double activation
                
                table.insert(mod.Saved.Jimbo.FullDeck, mod.Saved.Jimbo.FullDeck[TearData.Params.Index])
    
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
            end --ADDED TO DECK

        end




    end
end
mod:AddCallback("CARD_HIT", mod.OnCardHit)


function mod:SteelStatBoosts(Player, _)
    for _,index in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local Triggers = 0
        if mod.Saved.Jimbo.FullDeck[index]
           and mod.Saved.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.STEEL then

            Triggers = Triggers + 1

            if mod.Saved.Jimbo.FullDeck[index].Seal == mod.Seals.RED then
                Triggers = Triggers + 1
            end
            --if mod:JimboHasTrinket(Player, TrinkrtType.MIME) then Triggers = Triggers + 1

            --steel cards use the joker stats cause they are variable and need to be reset each time
            mod:IncreaseJimboStats(Player,0, 0, 1.2^Triggers, false,false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SteelStatBoosts, CacheFlag.CACHE_DAMAGE)


function mod:OnHandDiscard(Player)

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise
    --cycles between all the held jokers
    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        local ProgressIndex = Index
        local Copied = false
        if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == TrinketType.TRINKET_RAMEN and not Copied then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.02
        
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod.Saved.Jimbo.Inventory.Editions[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.02X")
            end
        
        elseif Joker == TrinketType.TRINKET_GREEN_JOKER and not Copied then
            local InitialProg = mod.Saved.Jimbo.Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.12
                if mod.Saved.Jimbo.Progress.Inventory[Index] < 0 then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = 0
                end
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.04")
        
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

    local Flags = ItemsConfig:GetTrinket(Joker).CacheFlags & ~CacheFlag.CACHE_DAMAGE & ~CacheFlag.CACHE_FIREDELAY

    Player:AddCacheFlags(Flags, true)

    Isaac.RunCallback("INVENTORY_CHANGE", Player)
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

        local ProgressIndex = Index
        local Copied = false
        if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then --could save some time
        elseif Joker == TrinketType.TRINKET_INVISIBLE_JOKER and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            local Value = mod.Saved.Jimbo.Progress.Inventory[Index]

            mod.Counters.Activated[Index] = 0
            if Value < 3 then --still charging
            
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, tostring(Value).."/3")
            else --usable
            
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Active!")
            end

        elseif Joker == TrinketType.TRINKET_ROCKET and not Copied then
            --spawns this many coins
            local MoneyAmount = mod.Saved.Jimbo.Progress.Inventory[Index]
            for i=1, MoneyAmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmount).."$")
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
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmmount).." $")

        elseif Joker == TrinketType.TRINKET_RIFF_RAFF then
            local RandomJoker = mod:RandomJoker(Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF), {}, true,"common")
            
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                       RandomVector()*3, Player, RandomJoker.Joker, RandomSeed)

            mod.Saved.Jimbo.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][RandomJoker.Joker] = RandomJoker.Edition

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")

        elseif Joker == TrinketType.TRINKET_CARTOMANCER then
            local RandomTarot = Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF):RandomInt(1,22)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, Player, RandomTarot, RandomSeed)

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")

        elseif Joker == TrinketType.TRINKET_EGG then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 2

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Upgrade!")

        elseif Joker == TrinketType.TRINKET_DELAYED_GRATIFICATION then

            if Player:HasFullHealth() then
                local NumCoins = Player:GetHearts()/2 --gives coins basing on how many extra heatrs are left

                for i = 1, NumCoins do
                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                               RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                end

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(NumCoins).."$")
            end

        elseif Joker == TrinketType.TRINKET_CLOUD_NINE then
            local Nines = 0
            for _,card in ipairs(mod.Saved.Jimbo.FullDeck) do
                if card.Value == 9 then
                    Nines = Nines + 1
                end
            end
            for i=1, Nines do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
            end

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(Nines).."$")
        
        elseif Joker == TrinketType.TRINKET_POPCORN and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.2
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 0.1 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod.Saved.Jimbo.Inventory.Editions[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.2")
            end

        elseif Joker == TrinketType.TRINKET_MADNESS and not Copied then

            if BlindType ~= mod.BLINDS.BOSS then

                mod.Counters.Activated[Index] = 0
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.1

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.1X")
            
                local Removable = {}
                for i, v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                    if i ~= Index and v ~= 0 then --any joker other than this one
                        table.insert(Removable, i)
                    end
                end
                if next(Removable) then --if at leat one is present
                    local Rindex = mod:GetRandom(Removable, Player:GetTrinketRNG(TrinketType.TRINKET_MADNESS))
                    mod.Saved.Jimbo.Inventory.Jokers[Rindex] = 0
                    mod.Saved.Jimbo.Inventory.Editions[Rindex] = 0

                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                end
            end

        elseif Joker == TrinketType.TRINKET_GROS_MICHAEL and not Copied then
            if mod:TryGamble(Player,Player:GetTrinketRNG(TrinketType.TRINKET_GROS_MICHAEL), 0.16) then
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod.Saved.Jimbo.Inventory.Editions[Index] = 0

                mod.Saved.Jimbo.MichelDestroyed = true

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end
        elseif Joker == TrinketType.TRINKET_CAVENDISH and not Copied then
            if mod:TryGamble(Player,Player:GetTrinketRNG(TrinketType.TRINKET_CAVENDISH), 0.00025) then --1/4000 chance
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod.Saved.Jimbo.Inventory.Editions[Index] = 0

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end
        elseif Joker == TrinketType.TRINKET_SACRIFICIAL_DAGGER and not Copied then
            local RightIndex = Index
            local RightJoker
            repeat
                RightIndex = RightIndex + 1
                RightJoker = mod.Saved.Jimbo.Inventory.Jokers[RightIndex]
            until not RightJoker or RightJoker ~= 0

            if RightJoker ~= 0 then
                local RightSell = mod:GetJokerCost(RightJoker, RightIndex)

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.SLICE, 
                "+"..tostring(0.08 * RightSell))

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + RightSell * 0.08

                mod.Saved.Jimbo.Inventory.Jokers[RightIndex] = 0
                mod.Saved.Jimbo.Inventory.Editions[RightIndex] = 0

                mod.Counters.Activated[Index] = 0

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end
        end

    end --END JOKER FOR

    for i, Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local card = mod.Saved.Jimbo.FullDeck[Pointer]
        if card.Seal == mod.Seals.BLUE then

            local Planet = mod.Planets.PLUTO + card.Value - 1

            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*2.5, Player, Planet, RandomSeed)

            mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Planet!")
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY,true)

    ::skip_player::

    end --END PLAYER FOR
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
                           RandomVector()*3, Player, RandomJoker, RandomSeed)

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

        local ProgressIndex = Index
        local Copied = false
        if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

            if Joker == TrinketType.TRINKET_HALLUCINATION then
                local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_HALLUCINATION)
            if TrinketRNG:RandomFloat() < 0.5 then

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, RandomTarot, RandomSeed)

                mod.Counters.Activated[Index] = 0
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
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.15

            mod.Counters.Activated[Index] = 0
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
        if Joker == TrinketType.TRINKET_FORTUNETELLER then

            if CardUsed <= Card.CARD_WORLD then --is a tarot
                local Step = 0.04

                print(Flag)
                if Flag & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
                    Step = 0.06
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + Step
            
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+"..tostring(Step))
            end
        end
    end
        
    --Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)

end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_CARD,CallbackPriority.EARLY, mod.OnCardUsed)


--usually used as a kind of hand played (ex. Vagabond)
function mod:OnRoomClear(IsBoss, Hostile)

    if not Game:IsGreedMode() or Hostile then
        for i,v in pairs(mod.Saved.Jimbo.Progress.Room) do
            if type(v) == "table" then

                for j,_ in ipairs(mod.Saved.Jimbo.Progress.Room[i]) do
                    mod.Saved.Jimbo.Progress.Room[i][j] = 0
                end
            else

                mod.Saved.Jimbo.Progress.Room[i] = 0 --resets the blind progress
            end
        end
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        local ProgressIndex = Index
        local Copied = false
        if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then --could save some time
        elseif Joker == TrinketType.TRINKET_VAGABOND then
            if Player:GetNumCoins() <= 2 then
                local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_VAGABOND)

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, RandomTarot, RandomSeed)

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!")
            end

        elseif Joker == TrinketType.TRINKET_ICECREAM and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.16

            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 0.01 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory.Jokers[Index] = 0
                mod.Saved.Jimbo.Inventory.Editions[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Extinct!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "-0.16")
            end
        elseif Joker == TrinketType.TRINKET_GREEN_JOKER and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.03

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.05")

        elseif Joker == TrinketType.TRINKET_LOYALTY_CARD and not Copied then

            if mod.Saved.Jimbo.Progress.Inventory[Index] ~= 0 then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1

                mod.Counters.Activated[Index] = 0
                if mod.Saved.Jimbo.Progress.Inventory[Index] ~= 0 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, 
                    tostring(mod.Saved.Jimbo.Progress.Inventory[Index].." More"))
                else
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,"X2")
                end

            elseif Hostile then --need to clear a hostile room to reset
                mod.Saved.Jimbo.Progress.Inventory[Index] = 5
            end
        
        elseif Joker == TrinketType.TRINKET_SUPERNOVA then
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset")

        elseif Joker == TrinketType.TRINKET_MR_BONES then
            if mod:TryGamble(Player, Player:GetTrinketRNG(TrinketType.TRINKET_MR_BONES), 0.15) then
                
                Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD, UseFlag.USE_NOANIM)

            end
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    ::skip_player::
    end
end
mod:AddCallback("TRUE_ROOM_CLEAR", mod.OnRoomClear)


function mod:OnNewRoomJokers()
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

            local ProgressIndex = Index
            local Copied = false
            if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == TrinketType.TRINKET_MISPRINT then
                local MisDMG = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]

                if not Copied then
                    local RoomRNG = RNG(Game:GetRoom():GetSpawnSeed())

                    MisDMG = mod:round(RoomRNG:RandomFloat(), 2)
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = MisDMG

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(MisDMG))
                end

                mod.Counters.Activated[Index] = 0

            elseif Joker == TrinketType.TRINKET_HALLUCINATION then

                local RoomRNG = RNG(Game:GetRoom():GetSpawnSeed())

                --def not 100% fault proof but works for now
                local FamiliarNum = Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY)
                
                if mod:TryGamble(Player, RoomRNG, 0.25) then
                    FamiliarNum = FamiliarNum + 1
                    Player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY, true, -1, false)
                else
                    Player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY, 1)
                end
                
                --Player:CheckFamiliar(FamiliarVariant.MULTIDIMENSIONAL_BABY, FamiliarNum, RoomRNG)
            end
        end

        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

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


function mod:OnShopRestock(Partial)

    if Partial then
        return
    end
    local DidSomething = false --needs to reroll a shop item to work

    for i,Pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP,-1,-1, true)) do
        if Pickup:ToPickup():IsShopItem() then
            DidSomething = true
            break
        end
    end

    if not DidSomething then
        return
    end


    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

            if Joker == 0 then
            elseif Joker == TrinketType.TRINKET_FLASH_CARD then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.02

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.02")
            end

        end

        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnShopRestock)


function mod:OnDeath(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        if Joker == TrinketType.TRINKET_MR_BONES then
            local Revive = false
            if mod.Saved.Jimbo.BossCleared == 2 then --on boss cleared revive anyways
                Revive = true

            elseif mod.Saved.Jimbo.BigCleared then --if big is cleared then you need to be fighting boss to revive
                if Game:GetRoom():GetBossID() ~= 0 then
                    Revive = true
                end
            elseif mod.Saved.Jimbo.SmallCleared then
                local BlindProgress  = mod.Saved.Jimbo.ClearedRooms
                if BlindProgress >= mod.Saved.Jimbo.BigBlind / 2 then
                    Revive = true
                end
            else --before clearing small blind
                local BlindProgress  = mod.Saved.Jimbo.ClearedRooms

                if BlindProgress >= mod.Saved.Jimbo.SmallBlind / 2 then
                    Revive = true
                end
            end
            if not Revive then
                return
            end

            Player:Revive()
            Player:SetFullHearts() --full health
            Player:SetMinDamageCooldown(120) --some iframes

            local MRindex = mod:GetValueIndex(mod.Saved.Jimbo.Inventory, TrinketType.TRINKET_MR_BONES, true)
            mod.Saved.Jimbo.Inventory.Jokers[Index] = 0 --removes the trinket
            mod.Saved.Jimbo.Inventory.Editions[Index] = 0
            mod:CreateBalatroEffect(MRindex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Saved!")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)

--adjusts the "copy" values for brainstorm and blueprint whenever the inventory is changed
--also adjusts progress value for some jokers, but only for effect reasons
function mod:CopyAdjustments(Player)

    --FIRST it deternimes the bb / bs copied joker
    for i,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do 
        local StartI = i

        while Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM do

            Joker = mod.Saved.Jimbo.Inventory.Jokers[i]

            if Joker == TrinketType.TRINKET_BLUEPRINT then --copies the joker to its right
                i = i + 1

            elseif Joker == TrinketType.TRINKET_BRAINSTORM then --copies the leftmost joker
                i = 1

            end

            mod.Saved.Jimbo.Progress.Inventory[StartI] = i

            if i == StartI then --some combinations can lead to infinite loops
                break
            end
        end
    end

    --SECOND it does other suff
    for Index,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

        local ProgressIndex = Index + 0
        local Copied = false
        if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == TrinketType.TRINKET_JOKER_STENCIL then
        
            local EmptySlots = 0
            for i,v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if v == 0 then
                    EmptySlots = EmptySlots + 1
                end
            end
            local Difference = EmptySlots - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
            if Difference ~= 0 then
                local Sign = ""
                if Difference >= 0 then Sign = "+" end

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                Sign..tostring(0.15*Difference).." X")
            end
            if not Copied then
                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = EmptySlots
            end

        elseif Joker == TrinketType.TRINKET_SWASHBUCKLER and not Copied then
        
            local TotalSell = 0
            for Slot,Jok in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if Jok ~= 0 then
                    TotalSell = TotalSell + mod:GetJokerCost(Jok, Slot)
                end
            end

            local Difference = TotalSell*0.05 - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
            if Difference ~= 0 then
                local Sign = ""
                if Difference >= 0 then Sign = "+" end

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                Sign..tostring(Difference))
            end

            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = TotalSell * 0.05
            
        end
    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback("INVENTORY_CHANGE", mod.CopyAdjustments)


function mod:JokerAdded(Player, Joker, ExtraEval)

    local Flags = ItemsConfig:GetTrinket(Joker).CacheFlags & ~CacheFlag.CACHE_DAMAGE & ~CacheFlag.CACHE_FIREDELAY

    Player:AddCacheFlags(Flags, true)

    if ExtraEval then
        Isaac.RunCallback("INVENTORY_CHANGED", Player)
    end
end


local PastCoins
local PastBombs
local PastKeys

--keeps track of the player's pickup to see when to evaluate
function mod:PickupBasedEval(Player)
    local NowCoins = Player:GetNumCoins()
    local NowBombs = Player:GetNumBombs()
    local NowKeys = Player:GetNumKeys()
    --local NowHearts = player:GetHearts()

    if NowCoins ~= PastCoins then 

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == TrinketType.TRINKET_BULL then

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    
                local Difference = NowCoins - PastCoins
                local Sign = "+"
                if Difference < 0 then
                    Sign = ""
                end

                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                    Sign..tostring(0.1*Difference),nil,nil, true)
            end

        end
        
        
        PastCoins = NowCoins
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.PickupBasedEval)




function mod:TearsJokers(Player, _)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do

            local ProgressIndex = Index
            local Copied = false
            if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == 0 then --could save some time
            elseif Joker == TrinketType.TRINKET_BULL then --this works with mod:OnUpdate() in TrinketCallbacks.lua
                local Tears = Player:GetNumCoins() * 0.15

                print(Tears)

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
                mod:IncreaseJimboStats(Player, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], 0, 1, false, false)

            elseif Joker == TrinketType.TRINKET_ODDTODD then
                local NumOdd = 0
                for Num = 1,10,2 do
                    NumOdd = NumOdd + mod.Saved.Jimbo.Progress.Room.ValueUsed[Num]
                end
                if NumOdd > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] or NumOdd == 1 and mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] ~= NumOdd then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(0.35*(NumOdd - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])))
                end
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = NumOdd --only used to tell when to spawn an effect
                end
                mod:IncreaseJimboStats(Player, 0.35 * NumOdd,0,1, false, false)
            
            elseif Joker == TrinketType.TRINKET_ARROWHEAD then
                local NumSpades = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Spade]
                if NumSpades > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] or NumSpades == 1 and mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] ~= NumSpades then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                    "+"..tostring(0.50*(NumSpades - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])))
                end
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = NumSpades --only used to tell when to spawn an effect
                end

                mod:IncreaseJimboStats(Player, 0.50 * NumSpades,0,1, false, false)
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

            local ProgressIndex = Index + 0
            local Copied = false
            if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

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
                mod:IncreaseJimboStats(Player, 0, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], 1, false, false)

            elseif Joker == TrinketType.TRINKET_POPCORN then
                mod:IncreaseJimboStats(Player, 0, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], 1, false, false)

            elseif Joker == TrinketType.TRINKET_EVENSTEVEN then
                local NumEven = 0
                for Num=2, 10, 2 do
                    NumEven = NumEven + mod.Saved.Jimbo.Progress.Room.ValueUsed[Num]
                end

                if NumEven > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] or NumEven == 1 and mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] ~= NumEven then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(0.04*(NumEven - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])))
                end
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumEven --this is only to tell when to spawn the effect
                end
                mod:IncreaseJimboStats(Player, 0,0.04*NumEven,1, false, false)

            elseif Joker == TrinketType.TRINKET_GREEN_JOKER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == TrinketType.TRINKET_RED_CARD then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == TrinketType.TRINKET_FORTUNETELLER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == TrinketType.TRINKET_ONIX_AGATE then
                local NumClubs = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Club]
                if NumClubs > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] or NumClubs == 1 and mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] ~= NumClubs then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(0.07*(NumClubs - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])))
                end
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumClubs --only used to tell when to spawn an effect
                end
                mod:IncreaseJimboStats(Player, 0,0.07 * NumClubs,1, false, false)
            
            elseif Joker == TrinketType.TRINKET_GROS_MICHAEL then
                mod:IncreaseJimboStats(Player, 0,0.75,1, false, false)

            elseif Joker == TrinketType.TRINKET_FLASH_CARD then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)

            elseif Joker == TrinketType.TRINKET_SWASHBUCKLER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)

            elseif Joker == TrinketType.TRINKET_SACRIFICIAL_DAGGER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)

            elseif Joker == TrinketType.TRINKET_SUPERNOVA then
                
                mod:IncreaseJimboStats(Player, 0,0.01 * mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
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

            local ProgressIndex = Index
            local Copied = false
            if Joker == TrinketType.TRINKET_BLUEPRINT or Joker == TrinketType.TRINKET_BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]] or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[Index]]))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == 0 then --could save some time
            elseif Joker == TrinketType.TRINKET_JOKER_STENCIL then

                mod:IncreaseJimboStats(Player, 0,0, 1 + 0.15*mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], false, false)
            elseif Joker == TrinketType.TRINKET_RAMEN then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
            elseif Joker == TrinketType.TRINKET_MADNESS then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
            elseif Joker == TrinketType.TRINKET_BLOODSTONE then

                mod:IncreaseJimboStats(Player,0,0,1 + 0.05*mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
            elseif Joker == TrinketType.TRINKET_CAVENDISH then

                mod:IncreaseJimboStats(Player,0,0,1.5,false,false)
            elseif Joker == TrinketType.TRINKET_LOYALTY_CARD then

                if mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] == 0 then
                    mod:IncreaseJimboStats(Player,0,0,2,false,false)
                end
            end
        end

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.DamageMultJokers, CacheFlag.CACHE_DAMAGE)


function mod:EditionsStats(Player, Flags)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    for i,Edition in ipairs(mod.Saved.Jimbo.Inventory.Editions) do
        if Flags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            if Edition == mod.Edition.HOLOGRAPHIC then
                mod:IncreaseJimboStats(Player,0, 0.5, 1, false, false)
            elseif Edition == mod.Edition.POLYCROME then
                mod:IncreaseJimboStats(Player,0, 0, 1.25, false, false)
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



-----JOKERS SECONDARY EFFECTS---------
-------------------------------------

---@param Player EntityPlayer
function mod:FlightEval(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_CLOUD_NINE) then
        Player:AddCostume(ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_FATE))
        Player.CanFly = true

    elseif not Player:HasCollectible(CollectibleType.COLLECTIBLE_FATE) then
        Player:RemoveCostume(ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_FATE))

    end

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.FlightEval, CacheFlag.CACHE_FLYING)


---@param Player EntityPlayer
---@param Collider Entity
function mod:GoldenTouch(Player, Collider)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    

    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_GOLDEN_JOKER) 
       and Collider:IsEnemy() and Collider:IsActiveEnemy() then
        
        Collider = Collider:ToNPC() or Collider

        Collider:AddMidasFreeze(EntityRef(Player), 100)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, mod.GoldenTouch, PlayerVariant.PLAYER)


---@param Entity Entity
function mod.DelayedGrat(Entity)

    local AllGood = false
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType or AllGood then
            goto skip_player
        end

        for Index, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == TrinketType.TRINKET_DELAYED_GRATIFICATION then
                AllGood = true
                break
            end
        end

        ::skip_player::
    end

    if not AllGood then
        return
    end

    if Entity.Type == EntityType.ENTITY_MOM and Entity.Variant ~= 10 then
        Game:GetRoom():TrySpawnBossRushDoor(true)

    elseif Entity.Type == EntityType.ENTITY_MOMS_HEART then
        Game:GetRoom():TrySpawnBlueWombDoor(true,true)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.DelayedGrat, EntityType.ENTITY_MOM)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.DelayedGrat, EntityType.ENTITY_MOMS_HEART)
