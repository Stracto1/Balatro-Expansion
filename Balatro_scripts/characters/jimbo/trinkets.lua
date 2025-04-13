local mod = Balatro_Expansion
-- |_(T_T)_/
--[[
small dissclaimer: there isn't really a pattern in which i decide where to put the effect
"""evaluation""", i just put it where i thought made more sense as i was adding the joker,
so some are in the stat evaluations and others in their respective callbacks
(will prob regret this)
]]

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

--local INVENTORY_RENDERING_POSITION = Vector(20,220) 


--effects when a card is shot
---@param Player EntityPlayer
function mod:OnCardShot(Player,ShotCard,Evaluate)

local RandomSeed = Random()
if RandomSeed == 0 then RandomSeed = 1 end --crash fix
---
--RETRIGGER CALCULATION + SEALS----
-----------------------------------

local Triggers = 1 --how many times the card needs to be activated again

for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

    local Joker = Slot.Joker

    local ProgressIndex = Index
    local Copied = false
    if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

        Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

        ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

        Copied = true
    end

    if Joker == mod.Jokers.HACK then
        if ShotCard.Value <= 5 and ShotCard.Value ~= 1 then
            Triggers = Triggers + 1

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.Jokers.HACK)

            mod.Counters.Activated[Index] = 0
        end

    elseif Joker == mod.Jokers.DUSK then

        local CardsRemaining = Player:GetCustomCacheValue("hands") - mod.Saved.Jimbo.Progress.Room.Shots

        if CardsRemaining <= 10 and CardsRemaining >= 0 then
            Triggers = Triggers + 1

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.Jokers.DUSK)

            mod.Counters.Activated[Index] = 0
        end
    end

end


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

if ShotCard.Value >= mod.Values.JACK or mod:JimboHasTrinket(Player, mod.Jokers.PAREIDOLIA) then
    mod.Saved.Jimbo.Progress.Room.ValueUsed[mod.Values.FACE] = mod.Saved.Jimbo.Progress.Room.ValueUsed[mod.Values.FACE] + Triggers
end

mod.Saved.Jimbo.Progress.Blind.Shots = mod.Saved.Jimbo.Progress.Blind.Shots + 1
--------------------------------------------------
-----------JOKERS EVALUATION---------------------
------------------------------------------------
for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

    local Joker = Slot.Joker

    local ProgressIndex = Index
    local Copied = false
    if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

        Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

        ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

        Copied = true
    end

    if Joker == 0 then
    elseif Joker == mod.Jokers.ROUGH_GEM then
        if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Diamond, false) then
            for i = 1, Triggers do
            
                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.ROUGH_GEM), 0.5) then
                    local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                            RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                    Coin:ToPickup().Timeout = 50

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.Jokers.ROUGH_GEM)
                end
            end
        end

    elseif Joker == mod.Jokers.BLOODSTONE then
        if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Heart, false) then
            for i = 1, Triggers do
                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BLOODSTONE), 0.5) then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 1
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.05",mod.Jokers.BLOODSTONE)
                end
            end
        end
    elseif Joker == mod.Jokers.SUPERNOVA then

        --adds how many times the card value got used in the same room
        mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] =  
        mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value]

        mod.Counters.Activated[Index] = 0
        mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ADDMULT,
                                "+"..tostring(0.01 * mod.Saved.Jimbo.Progress.Room.ValueUsed[ShotCard.Value]),mod.Jokers.SUPERNOVA)
    
    elseif Joker == mod.Jokers._8_BALL then
        if ShotCard.Value == 8 then

            local BallRNG = Player:GetTrinketRNG(mod.Jokers._8_BALL)
            for i = 1, Triggers do
            
                if mod:TryGamble(Player, BallRNG, 0.25) then

                    local Rtarot = BallRNG:RandomInt(1,22)

                    local Tarot = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                                            RandomVector()*3, Player, Rtarot, RandomSeed)

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.Jokers._8_BALL)
                end
            end
        end
    elseif Joker == mod.Jokers.BUSINESS_CARD then
        if ShotCard.Value >= mod.Values.JACK then --only face cards
            
            for i = 1, Triggers do

                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BUSINESS_CARD), 0.25) then
            
                    for i=1, 2 do --spawns 2 coins 25% of the time
                        local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                                RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                        Coin:ToPickup().Timeout = 50
                    end

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.Jokers.BUSINESS_CARD)
                end
            end
        end
    elseif Joker == mod.Jokers.RIDE_BUS then

        if ShotCard.Value >= mod.Values.JACK then --only face cards
   
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!",mod.Jokers.RIDE_BUS)

        else
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 1

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.01",mod.Jokers.RIDE_BUS)
        end

    elseif Joker == mod.Jokers.SPACE_JOKER then

        if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.SPACE_JOKER), 0.05 + 0.05 * mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]) then

            mod.Saved.Jimbo.CardLevels[ShotCard.Value] = mod.Saved.Jimbo.CardLevels[ShotCard.Value] + 1

            mod.Counters.Activated[Index] = 0

            local ValueString = tostring(ShotCard.Value)
            if ShotCard.Value == 11 then
                ValueString = "J"
            elseif ShotCard.Value == 12 then
                ValueString = "Q"
            elseif ShotCard.Value == 13 then
                ValueString = "K"
            elseif ShotCard.Value == 1 then
                ValueString = "Ace"
            end

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, ValueString.."Up!",mod.Jokers.SPACE_JOKER)
        end
    
    elseif Joker == mod.Jokers.HIKER then

        mod.Saved.Jimbo.FullDeck[ShotCard.Index].Upgrades = mod.Saved.Jimbo.FullDeck[ShotCard.Index].Upgrades + 1
    
        mod.Counters.Activated[Index] = 0
        mod:CreateBalatroEffect(Index,mod.EffectColors.BLUE, mod.Sounds.CHIPS, "Upgrade!",mod.Jokers.HIKER, nil, 0.75)
    
    elseif Joker == mod.Jokers.TO_DO_LIST then
        local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                            RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
        Coin:ToPickup().Timeout = 50

        mod.Counters.Activated[Index] = 0
        mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Done!",mod.Jokers.TO_DO_LIST)

    end
end
---------------BASE CARD STATS--------------
-------------------------------------------
    --------EDITIONS EFFECTS----------
    ----------------------------------
    if ShotCard.Edition == mod.Edition.FOIL then
        mod:IncreaseJimboStats(Player,1.25*Triggers, 0, 1,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.EDITIONEFFECT, "+1.25",mod.Edition.FOIL, nil, 0.45)

    elseif ShotCard.Edition == mod.Edition.HOLOGRAPHIC then
        mod:IncreaseJimboStats(Player,0, 0.25 * Triggers, 1,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.EDITIONEFFECT, "+0.25",mod.Edition.HOLOGRAPHIC, nil, 0.45)

    elseif ShotCard.Edition == mod.Edition.POLYCROME then
        mod:IncreaseJimboStats(Player,0, 0, 1.2 ^ Triggers,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.EDITIONEFFECT, "X1.2",mod.Edition.POLYCROME,nil, 0.45)
    end

    --increases the chips basing on the card value
    local TearsToGet = (mod:GetActualCardValue(ShotCard.Value)/50 
                        + mod.Saved.Jimbo.CardLevels[ShotCard.Value]*0.02
                        + ShotCard.Upgrades*0.02) * Triggers
    
    
    mod:IncreaseJimboStats(Player,0, 0.02 * mod.Saved.Jimbo.CardLevels[ShotCard.Value] * Triggers, 1,false,true) --extra damage given by planet upgrades
    
    local PlayerRNG = Player:GetDropRNG()

    ---------ENHANCEMENT EFFECTS----------
    --------------------------------------
    if ShotCard.Enhancement == mod.Enhancement.STONE then
        TearsToGet = 1.25 * Triggers 
    elseif ShotCard.Enhancement == mod.Enhancement.MULT then
        mod:IncreaseJimboStats(Player, 0, 0.05 * Triggers,1, false,true) 

    elseif ShotCard.Enhancement == mod.Enhancement.BONUS then
        TearsToGet = TearsToGet + 0.75*Triggers

    elseif ShotCard.Enhancement == mod.Enhancement.GLASS then
        mod:IncreaseJimboStats(Player,0, 0, 1.3 ^ Triggers, false,true)

        if mod:TryGamble(Player, PlayerRNG, 0.1) then
            table.remove(mod.Saved.Jimbo.FullDeck, ShotCard.Index) --PLACEHOLDER SOUND
            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "BROKEN!", mod.Enhancement.GLASS)
        end
    elseif ShotCard.Enhancement == mod.Enhancement.LUCKY then
        for i = 1, Triggers do
            if mod:TryGamble(Player, PlayerRNG, 0.2) then
                mod:IncreaseJimboStats(Player, 0, 1, 1, false,true)
                mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.2", mod.Enhancement.LUCKY)
            end 
            if mod:TryGamble(Player, PlayerRNG, 0.05) then
                Player:AddCoins(10)
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+10 $", mod.Enhancement.LUCKY)
            end
        end
    end

    mod:IncreaseJimboStats(Player, TearsToGet, 0, 1, Evaluate, true)

end
mod:AddCallback("CARD_SHOT", mod.OnCardShot)


function mod:OnCardHit(Tear, Collider)

    local TearData = Tear:GetData()
    local Player = Tear.Parent:ToPlayer() or Tear.Parent

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == mod.Jokers.DNA then

            if TearData.Num == 1 then --if it's the first fired card in a blind
                TearData.Num = 2 --prevents double activation
                
                mod:AddCardToDeck(Player, mod.Saved.Jimbo.FullDeck[TearData.Params.Index], 1, true)
    
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Copied!",mod.Jokers.DNA)
            
            end --ADDED TO DECK

        elseif Joker == mod.Jokers.SIXTH_SENSE then

            if TearData.Num == 1 then --if it's the first fired card in a blind
                TearData.Num = 2 --prevents double activation
                
                mod:DestroyCards(Player, {TearData.Params.Index}, false)
                mod:CardRipEffect(TearData, Tear.Position)

                Tear:Remove()

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Destroyed!",mod.Jokers.SIXTH_SENSE)
            
                local Seed = Random()
                Seed = Seed == 0 and 1 or Seed

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, mod.Packs.SPECTRAL, Seed)
            end
        end

    end
end
mod:AddCallback("CARD_HIT", mod.OnCardHit)



function mod:OnHandDiscard(Player)

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise
    --cycles between all the held jokers
    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == mod.Jokers.RAMEN and not Copied then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.02
        
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Extinct!",mod.Jokers.RAMEN)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.02X",mod.Jokers.RAMEN)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        
        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            local InitialProg = mod.Saved.Jimbo.Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.12
                if mod.Saved.Jimbo.Progress.Inventory[Index] < 0 then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = 0
                end
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.12",mod.Jokers.GREEN_JOKER)
        
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        end
    end

    Player:EvaluateItems()

end
mod:AddCallback("HAND_DISCARD", mod.OnHandDiscard)


--effects when a joker gets sold
---@param Player EntityPlayer
function mod:OnJokerSold(Player,Joker,SlotSold)
    --print("sold")
    if Joker == mod.Jokers.INVISIBLE_JOKER then
        if mod.Saved.Jimbo.Progress.Inventory[SlotSold] ~= 3 then
            return
        end
        local HasSomethingElse = false
        for _, trinket in ipairs(mod.Saved.Jimbo.Inventory) do
            --can only copy something other than itself and nothing
            if trinket.Joker ~= 0 and trinket.Joker ~= mod.Jokers.INVISIBLE_JOKER then
                HasSomethingElse = true
                break
            end
        end

        if HasSomethingElse then --no need if player is poor
            local RandomJoker
            local Rng = Player:GetTrinketRNG(mod.Jokers.INVISIBLE_JOKER)
            repeat
                RandomJoker = mod.Saved.Jimbo.Inventory[Rng:RandomInt(1, #mod.Saved.Jimbo.Inventory)]
            until RandomJoker ~= 0 and RandomJoker ~= mod.Jokers.INVISIBLE_JOKER
            --print(RandomJoker)
            mod.Saved.Jimbo.Inventory[SlotSold] = RandomJoker
        end
    elseif false then

    end


    Player:AddCacheFlags(ItemsConfig:GetTrinket(Joker).CacheFlags, true)

    local CustomFlags = ItemsConfig:GetTrinket(Joker):GetCustomCacheTags()

    Player:AddCustomCacheTag(CustomFlags, true)



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

    local MimeNum = 0

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    --cycles between all the held jokers
    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then --could save some time
        elseif Joker == mod.Jokers.INVISIBLE_JOKER then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            local Value = mod.Saved.Jimbo.Progress.Inventory[Index]

            mod.Counters.Activated[Index] = 0
            if Value < 3 then --still charging
            
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, tostring(Value).."/3",mod.Jokers.INVISIBLE_JOKER)
            else --usable
            
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Active!",mod.Jokers.INVISIBLE_JOKER)
            end

        elseif Joker == mod.Jokers.ROCKET then
            --spawns this many coins
            local MoneyAmount = mod.Saved.Jimbo.Progress.Inventory[Index]
            for i=1, MoneyAmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmount).."$",mod.Jokers.ROCKET)
            --on boss beaten it upgrades
            if BlindType == mod.BLINDS.BOSS then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "Upgrade!",mod.Jokers.ROCKET)
            end

        elseif Joker == mod.Jokers.GOLDEN_JOKER then

            --spawns this many coins
            local MoneyAmmount = 3
            for i=1, MoneyAmmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmmount).." $",mod.Jokers.GOLDEN_JOKER)

        elseif Joker == mod.Jokers.RIFF_RAFF then
            local RandomJoker = mod:RandomJoker(Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF), {}, true,"common")
            
            mod:AddJoker(Player, RandomJoker.Joker, RandomJoker.Edition)

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.Jokers.RIFF_RAFF)

        elseif Joker == mod.Jokers.CARTOMANCER then
            local RandomTarot = Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF):RandomInt(1,22)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, Player, RandomTarot, RandomSeed)

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.Jokers.CARTOMANCER)

        elseif Joker == mod.Jokers.EGG then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 2

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.Jokers.EGG)

        elseif Joker == mod.Jokers.DELAYED_GRATIFICATION then

            if Player:HasFullHealth() then
                local NumCoins = Player:GetHearts()/2 --gives coins basing on how many extra heatrs are left

                for i = 1, NumCoins do
                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                               RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                end

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(NumCoins).."$",mod.Jokers.DELAYED_GRATIFICATION)
            end

        elseif Joker == mod.Jokers.CLOUD_NINE then
            
            for i=1, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
            end

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]).."$",mod.Jokers.CLOUD_NINE)
        
        elseif Joker == mod.Jokers.POPCORN and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.2
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 0.1 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Eaten")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.2",mod.Jokers.POPCORN)
            end

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Joker == mod.Jokers.MADNESS and not Copied then

            if BlindType ~= mod.BLINDS.BOSS then

                mod.Counters.Activated[Index] = 0
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.1

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.1X",mod.Jokers.MADNESS)
            
                local Removable = {}
                for i, v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                    if i ~= Index and v.Joker ~= 0 then --any joker other than this one
                        table.insert(Removable, i)
                    end
                end
                if next(Removable) then --if at leat one is present
                    local Rindex = mod:GetRandom(Removable, Player:GetTrinketRNG(mod.Jokers.MADNESS))
                    mod.Saved.Jimbo.Inventory[Rindex].Joker = 0
                    mod.Saved.Jimbo.Inventory[Rindex].Edition = 0

                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                end
            end

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Joker == mod.Jokers.GROS_MICHAEL and not Copied then
            if mod:TryGamble(Player,Player:GetTrinketRNG(mod.Jokers.GROS_MICHAEL), 0.16) then
                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0

                mod.Saved.Jimbo.MichelDestroyed = true

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!",mod.Jokers.GROS_MICHAEL)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.CAVENDISH and not Copied then
            if mod:TryGamble(Player,Player:GetTrinketRNG(mod.Jokers.CAVENDISH), 0.00025) then --1/4000 chance
                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!",mod.Jokers.CAVENDISH)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.SACRIFICIAL_DAGGER and not Copied then
            local RightIndex = Index
            local RightJoker
            repeat
                RightIndex = RightIndex + 1
                RightJoker = mod.Saved.Jimbo.Inventory[RightIndex].Joker
            until not RightJoker or RightJoker ~= 0

            if RightJoker ~= 0 then
                local RightSell = mod:GetJokerCost(RightJoker, RightIndex)

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.SLICE, 
                "+"..tostring(0.08 * RightSell),mod.Jokers.SACRIFICIAL_DAGGER)

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + RightSell * 0.08

                mod.Saved.Jimbo.Inventory[RightIndex].Joker = 0
                mod.Saved.Jimbo.Inventory[RightIndex].Edition = 0

                mod.Counters.Activated[Index] = 0

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.MIME then
            MimeNum = MimeNum + 1

        elseif Joker == mod.Jokers.MARBLE_JOKER then

            local MarbleRNG = Player:GetTrinketRNG(mod.Jokers.MARBLE_JOKER)

            local StoneCard = {}

            StoneCard.Suit = MarbleRNG:RandomInt(1, 4)
            StoneCard.Value = MarbleRNG:RandomInt(1,13)

            StoneCard.Enhancement = mod.Enhancement.STONE
            StoneCard.Seal = mod.Seals.NONE
            StoneCard.Edition = mod.Edition.BASE

            table.insert(mod.Saved.Jimbo.FullDeck, StoneCard)

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Stone!",mod.Jokers.MARBLE_JOKER)
        
            Isaac.RunCallback("DECK_SHIFT", Player)
        end

    end --END JOKER FOR

    --BLUE SEAL EFFECT

    for i, Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local card = mod.Saved.Jimbo.FullDeck[Pointer]
        if card.Seal == mod.Seals.BLUE then

            local Planet = mod.Planets.PLUTO + card.Value - 1

            for i=0, MimeNum do

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, Planet, RandomSeed)
            end

            mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Planet!",mod.Seals.BLUE)
        end
    end

    Player:EvaluateItems()


    for _,index in ipairs(mod.Saved.Jimbo.CurrentHand) do
        if mod.Saved.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.GOLDEN --PLACEHOLDER
           and mod.Saved.Jimbo.FirstDeck and mod.Saved.Jimbo.Progress.Room.Shots < Game:GetPlayer(0):GetCustomCacheValue("hands") then
            for i=0, MimeNum * 3 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                RandomVector() * 4, PlayerManager.FirstPlayerByType(mod.Characters.JimboType),
                CoinSubType.COIN_PENNY, RandomSeed)
            end
            --Jimbo:AddCoins(3)
        end
    end




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

        if mod:JimboHasTrinket(Player, mod.Jokers.RIFF_RAFF) then
            local JokerIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.RIFF_RAFF)
            for _, Index in ipairs(JokerIndexes) do

                local RandomJoker = mod:GetRandom(mod.Trinkets, Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF), true)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                           RandomVector()*3, Player, RandomJoker, RandomSeed)

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "ACTIVATE!",mod.Jokers.RIFF_RAFF)
                
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

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

            if Joker == mod.Jokers.HALLUCINATION then
                local TrinketRNG = Player:GetTrinketRNG(mod.Jokers.HALLUCINATION)
            if TrinketRNG:RandomFloat() < 0.5 then

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, RandomTarot, RandomSeed)

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.Jokers.HALLUCINATION)
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

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker
        
        if Joker == 0 then
        elseif Joker == mod.Jokers.RED_CARD then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.15

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.15",mod.Jokers.RED_CARD)

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
        end
    end

    Player:EvaluateItems()

end
mod:AddCallback("PACK_SKIPPED", mod.OnPackSkipped)


function mod:OnCardUsed(CardUsed,Player,Flag)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or
        Flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then
        return
    end



    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker
        
        if Joker == mod.Jokers.FORTUNETELLER then

            if CardUsed <= Card.CARD_WORLD then --is a tarot
                local Step = 0.04

                print(Flag)
                if Flag & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
                    Step = 0.06
                end
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + Step
            
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+"..tostring(Step),mod.Jokers.FORTUNETELLER)
            end

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        end
    end
        
    Player:EvaluateItems()

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

                mod.Saved.Jimbo.Progress.Room[i] = 0 --resets the room progress
            end
        end
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then --could save some time
        elseif Joker == mod.Jokers.VAGABOND then
            if Player:GetNumCoins() <= 2 or mod.Saved.Other.HasDebt then
                local TrinketRNG = Player:GetTrinketRNG(mod.Jokers.VAGABOND)

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, RandomTarot, RandomSeed)

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.Jokers.VAGABOND)
            end

            local RoomRNG = RNG(Game:GetRoom():GetSpawnSeed())

            if mod:TryGamble(Player, RoomRNG, 0.1) then
                local SpawnPos = Isaac.GetFreeNearPosition(Game:GetRoom():GetCenterPos(),20)
                local BeggarRoll = RoomRNG:RandomFloat()

                if BeggarRoll <= 0.4 then
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.BEGGAR, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())
            
                elseif BeggarRoll <= 0.52 then
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.DEVIL_BEGGAR, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())

                elseif BeggarRoll <= 0.64 then
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.KEY_MASTER, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())

                elseif BeggarRoll <= 0.76 then
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.BOMB_BUM, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())

                elseif BeggarRoll <= 0.88 then
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.BATTERY_BUM, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())

                elseif Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_BEGGAR) then
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.BATTERY_BUM, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())

                else
                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.BEGGAR, SpawnPos, Vector.Zero, Player, 0, Game:GetRoom():GetSpawnSeed())

                end

            end

        elseif Joker == mod.Jokers.ICECREAM and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.16

            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 0.01 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Melted!",mod.Jokers.ICECREAM)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "-0.16",mod.Jokers.ICECREAM)
            end

            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.03

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.05",mod.Jokers.GREEN_JOKER)

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Joker == mod.Jokers.LOYALTY_CARD and not Copied then

            if mod.Saved.Jimbo.Progress.Inventory[Index] ~= 0 then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1

                mod.Counters.Activated[Index] = 0
                if mod.Saved.Jimbo.Progress.Inventory[Index] ~= 0 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, 
                    tostring(mod.Saved.Jimbo.Progress.Inventory[Index].." More"),mod.Jokers.LOYALTY_CARD)
                else
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,"X2.5",mod.Jokers.LOYALTY_CARD)
                end

            elseif Hostile then --need to clear a hostile room to reset
                mod.Saved.Jimbo.Progress.Inventory[Index] = 5
            end

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            
        elseif Joker == mod.Jokers.SUPERNOVA then
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset",mod.Jokers.SUPERNOVA)

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Joker == mod.Jokers.MR_BONES then
            if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.MR_BONES), 0.2) then
                
                Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)

            end
        elseif Joker == mod.Jokers.DNA then
            if Hostile then
                Player:AddMinisaac(Player.Position, true)
            end
        end

    end

    Player:EvaluateItems()

    ::skip_player::

    end
end
mod:AddCallback("TRUE_ROOM_CLEAR", mod.OnRoomClear)


function mod:OnNewRoomJokers()

    if Game:GetRoom():IsClear() then
        return
    end

    --ANY ROOM--

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise


        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker    

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            local HandType = mod:DeterminePokerHand(Player)

            if Joker == mod.Jokers.MISPRINT then
                local MisDMG = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]

                if not Copied then
                    local RoomRNG = RNG(Game:GetRoom():GetSpawnSeed())

                    MisDMG = mod:round(RoomRNG:RandomFloat(), 2)
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = MisDMG

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(MisDMG),mod.Jokers.MISPRINT)
                end

                mod.Counters.Activated[Index] = 0

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            elseif Joker == mod.Jokers.HALLUCINATION then

                local RoomRNG = RNG(Game:GetRoom():GetSpawnSeed())

                if mod:TryGamble(Player, RoomRNG, 0.5) then
                    Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY)
                    table.insert(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY)
                else
                    Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY, -1)
                    table.remove(mod.Saved.Jimbo.InnateItems.General, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.General,CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,true))
                end
                
                --Player:CheckFamiliar(FamiliarVariant.MULTIDIMENSIONAL_BABY, FamiliarNum, RoomRNG)

            elseif Joker == mod.Jokers.JOLLY_JOKER then
                if HandType & mod.HandTypes.PAIR == mod.HandTypes.PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 1

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+1",mod.Jokers.JOLLY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            elseif Joker == mod.Jokers.ZANY_JOKER then
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 2

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+2",mod.Jokers.ZANY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            elseif Joker == mod.Jokers.MAD_JOKER then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 1.75

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+1.75",mod.Jokers.MAD_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            
            elseif Joker == mod.Jokers.CRAZY_JOKER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 3

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+3",mod.Jokers.CRAZY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            elseif Joker == mod.Jokers.DROLL_JOKER then
                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 2.25

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+2.25",mod.Jokers.DROLL_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            
            elseif Joker == mod.Jokers.SLY_JOKER then
                if HandType & mod.HandTypes.PAIR == mod.HandTypes.PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 4

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+4",mod.Jokers.SLY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.WILY_JOKER then
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 8

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+8",mod.Jokers.WILY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.CLEVER_JOKER then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 7

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+7",mod.Jokers.CLEVER_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)
            
            elseif Joker == mod.Jokers.DEVIOUS_JOKER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 12

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+12",mod.Jokers.DEVIOUS_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.CRAFTY_JOKER then

                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 9

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+9",mod.Jokers.CRAFTY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.SPLASH then

                for i, Index in ipairs(mod.Saved.Jimbo.CurrentHand) do 
                    local ShotCard = mod.Saved.Jimbo.FullDeck[Index]
                    ShotCard.Index = Index

                    mod:OnCardShot(Player, ShotCard, false) --triggers every card in hand
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)

            elseif Joker == mod.Jokers.RUNNER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then
 
                    if not Copied then
                        mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 2
                    end

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+2",mod.Jokers.RUNNER)

                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.SUPERPOSISION then

                local HasAce = false
                for _,Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
                    if mod.Saved.Jimbo.FullDeck[Pointer].Value == 1 then
                        HasAce = true
                        break
                    end
                end

                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT and HasAce then
                
                    local Seed = Random()
                    if Seed == 0 then Seed = 1 end

                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                               RandomVector()*3, Player, mod.Packs.ARCANA,  Seed)

                    mod:CreateBalatroEffect(Index, mod.EffectColors.Yellow, mod.Sounds.ACTIVATE, "Tarot!",mod.Jokers.SUPERPOSISION)

                    mod.Counters.Activated[Index] = 0
                end

            elseif Joker == mod.Jokers.TO_DO_LIST then

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = RNG(Game:GetRoom():GetSpawnSeed()):RandomInt(1,mod.Values.KING)

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.Yellow, mod.Sounds.ACTIVATE, "Play "..tostring(mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]).."s",mod.Jokers.TO_DO_LIST)
                end
            end


            if Game:GetLevel():GetCurrentRoomDesc().VisitedCount > 1 then
                goto skip_player
            end
    
            if Joker == mod.Jokers.CHAOS_CLOWN then
    
                Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                       Game:GetRoom():GetGridPosition(27),Vector.Zero, nil, 0, Game:GetRoom():GetSpawnSeed())
            end
        end

        Player:EvaluateItems()

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomJokers)


function mod:OnNewLevelJokers()

    for i,_ in pairs(mod.Saved.Jimbo.Progress.Floor) do
        mod.Saved.Jimbo.Progress.Floor[i] = 0 --resets the blind progress
    end
    mod.Saved.Jimbo.FloorVouchers = {}



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

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker    

            if Joker == 0 then
            elseif Joker == mod.Jokers.FLASH_CARD then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.02

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.02",mod.Jokers.FLASH_CARD)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            end

        end

        Player:EvaluateItems()

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnShopRestock)


function mod:OnDeath(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.MR_BONES then
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

            mod.Saved.Jimbo.Inventory[Index].Joker = 0 --removes the trinket
            mod.Saved.Jimbo.Inventory[Index].Edition = 0

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Saved!",
                                    nil,nil,mod.Jokers.MR_BONES)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)



--adjusts the "copy" values for brainstorm and blueprint whenever the inventory is changed
--also adjusts progress value for some jokers, but only for effect reasons
---@param Player EntityPlayer
function mod:CopyAdjustments(Player)

    Player:AddCustomCacheTag("handsize", false)
    Player:AddCustomCacheTag("discards", false)
    Player:AddCustomCacheTag("inventory", true)


    --FIRST it deternimes the bb / bs copied joker
    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker
        
        local StartI = Index

        while Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM do

            Joker = mod.Saved.Jimbo.Inventory[Index].Joker

            if Joker == mod.Jokers.BLUEPRINT then --copies the joker to its right
                Index = Index + 1

            elseif Joker == mod.Jokers.BRAINSTORM then --copies the leftmost joker
                Index = 1

            end

            mod.Saved.Jimbo.Progress.Inventory[StartI] = Index

            if Index == StartI then --some combinations can lead to infinite loops
                break
            end
        end
    end

    --amounts needed for innete items counting
    local HackNum = 0
    local SuperPosNum = 0

    --SECOND it does other suff
    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == mod.Jokers.JOKER_STENCIL then
        
            local EmptySlots = 0
            for i,v in ipairs(mod.Saved.Jimbo.Inventory) do
                if v.Joker == 0 or v.Joker == mod.Jokers.JOKER_STENCIL then
                    EmptySlots = EmptySlots + 1
                end
            end

            local Mult = 1 + 0.75*EmptySlots

            if Player:GetActiveItem() == CollectibleType.COLLECTIBLE_NULL then
                Mult = Mult + 0.25
            end

            local Difference = Mult - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]

            if Difference ~= 0 then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

            

        elseif Joker == mod.Jokers.SWASHBUCKLER and not Copied then
        
            local TotalSell = 0
            for Slot,Jok in ipairs(mod.Saved.Jimbo.Inventory) do
                if Jok.Joker ~= 0 then
                    TotalSell = TotalSell + mod:GetJokerCost(Jok.Joker, Slot)
                end
            end

            local Difference = TotalSell*0.05 - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
            if Difference ~= 0 then
                local Sign = ""
                if Difference >= 0 then Sign = "+" end

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                Sign..tostring(Difference),mod.Jokers.SWASHBUCKLER)
            end

            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = TotalSell * 0.05

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Joker == mod.Jokers.HACK then

            HackNum = HackNum + 1

        elseif Joker == mod.Jokers.SUPERPOSISION then

            SuperPosNum = SuperPosNum + 1
        end
    end

    local JokerDifference = 0


    JokerDifference = HackNum - mod:GetValueRepetitions(mod.Saved.Jimbo.InnateItems.Hack, mod.Saved.Jimbo.InnateItems.Hack[1])

    if JokerDifference ~= 0 then --prevents unnecessary calculations
    
        ---@diagnostic disable-next-line: undefined-field
        for Item = 1, ItemsConfig:GetCollectibles().Size - 1 do --stole this bit from Baltro Jokers's Baron evaluation with some tweaks
            local item = ItemsConfig:GetCollectible(Item)
            if item
            and item.Type ~= ItemType.ITEM_ACTIVE
            and (item.Quality == 0 or item.Quality == 1)
            and not item:HasTags(ItemConfig.TAG_QUEST)
            and item.Hidden == false
            and Player:HasCollectible(Item, true, true) then

                Player:AddInnateCollectible(Item, JokerDifference)

                if JokerDifference >= 0 then
                    local Size = #mod.Saved.Jimbo.InnateItems.Hack
                    for i=1, JokerDifference do
                        mod.Saved.Jimbo.InnateItems.Hack[Size + i] = Item
                    end
                else
                    for i=1, -JokerDifference do

                        table.remove(mod.Saved.Jimbo.InnateItems.Hack, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.Hack, Item, true))
                    end
                end
            end
        end
    end

    JokerDifference = SuperPosNum - mod:GetValueRepetitions(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_FOREVER_ALONE)

    if JokerDifference >= 0 then
        for i=1, JokerDifference do
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FOREVER_ALONE, 2)
            table.insert(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_FOREVER_ALONE)
        end
    else
        for i=1, -JokerDifference do
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FOREVER_ALONE, -2)

            table.remove(mod.Saved.Jimbo.InnateItems.General, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_FOREVER_ALONE, true))
        end
    end


    if mod:JimboHasTrinket(Player, mod.Jokers.ROCKET) and not Player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, false, false) then
        
        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
        table.insert(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)

    --checks if the player has an innate collectible to remove
    elseif mod:Contained(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) then
        

        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, -1)
        table.remove(mod.Saved.Jimbo.InnateItems.General, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems,CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,true))

    end


    if mod:JimboHasTrinket(Player, mod.Jokers.BUSINESS_CARD) and not Player:HasCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD, false, false) then
        
        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD)
        table.insert(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_MEMBER_CARD)

    --checks if the player has an innate collectible to remove
    elseif Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MEMBER_CARD, false, false) - Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MEMBER_CARD, true, true) > 0 then
        

        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD, -1)
        table.remove(mod.Saved.Jimbo.InnateItems.General, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems,CollectibleType.COLLECTIBLE_MEMBER_CARD,true))

    end

    Player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
    Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    Player:AddCacheFlags(CacheFlag.CACHE_LUCK)

    Player:AddCacheFlags(CacheFlag.CACHE_ALL)

    Player:EvaluateItems()

end
mod:AddCallback("INVENTORY_CHANGE", mod.CopyAdjustments)

---@param Player EntityPlayer
function mod:JokerAdded(Player, Joker,Edition)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Joker == mod.Jokers.SPACE_JOKER then

        local StarItems = 0

        for Item, AmountHeld in ipairs(Player:GetCollectiblesList()) do

            local Config = ItemsConfig:GetCollectible(Item)
            if Config and Config:HasTags(ItemConfig.TAG_STARS) then

                StarItems = StarItems + AmountHeld
            end
        end

        for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SPACE_JOKER, true)) do
            mod.Saved.Jimbo.Progress.Inventory[Index] = StarItems
        end
    end

end
mod:AddCallback("JOKER_ADDED", mod.JokerAdded)


-----SPECIFIC EVALUATIONS-------
--------------------------------

local PastCoins = 0
local PastBombs = 0
local PastKeys = 0
local PastHearts = 0
--keeps track of the player's pickup to see when to evaluate
---@param Player EntityPlayer
function mod:PickupBasedEval(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or Game:GetFrameCount()%2 == 0 then
        return
    end

    local NowCoins = Player:GetNumCoins()
    local NowBombs = Player:GetNumBombs()
    local NowKeys = Player:GetNumKeys()
    local NowHearts = Player:GetHearts()

    if NowCoins ~= PastCoins then

        local Difference = NowCoins - PastCoins

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker
            
            if Joker == mod.Jokers.BULL then

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.GREEDY_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            end
        end

        PastCoins = NowCoins
    end

    if NowBombs ~= PastBombs then

        local Difference = NowBombs - PastBombs

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker
            
            if Joker == mod.Jokers.GLUTTONOUS_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            end

        end

        PastBombs = NowBombs
    end

    if NowKeys ~= PastKeys then

        local Difference = NowKeys - PastKeys

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            if Joker == mod.Jokers.WRATHFUL_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.ARROWHEAD then

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            end

        end

        PastKeys = NowKeys
    end

    if NowHearts ~= PastHearts then

        local Difference = NowHearts - PastHearts

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            if Joker == mod.Jokers.LUSTY_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)


            elseif Joker == mod.Jokers.BANNER then


                mod.Saved.Jimbo.Progress.Inventory[Index] = 0.75*NowHearts

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.MYSTIC_SUMMIT then

                if NowHearts == 2 then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = 0.75
                else
                    mod.Saved.Jimbo.Progress.Inventory[Index] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            end

        end

        PastHearts = NowHearts
    end


    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.PickupBasedEval)


---@param Player EntityPlayer
function mod:ItemAddedEval(Type,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.JOKER_STENCIL then

            if ItemsConfig:GetCollectible(Type).Type == ItemType.ITEM_ACTIVE then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.ABSTRACT_JOKER then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.EVENSTEVEN then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.ODDTODD then

            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

        elseif Joker == mod.Jokers.FIBONACCI then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.SPACE_JOKER  then

            if ItemsConfig:GetCollectible(Type):HasTags(ItemConfig.TAG_STARS) then

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            end

        end
    end

    Player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.ItemAddedEval)


function mod:ItemRemovedEval(Player,Type)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end


    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.JOKER_STENCIL then

            if ItemsConfig:GetCollectible(Type).Type == ItemType.ITEM_ACTIVE then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.ABSTRACT_JOKER then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.EVENSTEVEN then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.ODDTODD then

            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

        elseif Joker == mod.Jokers.FIBONACCI then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.SPACE_JOKER  then

            if ItemsConfig:GetCollectible(Type):HasTags(ItemConfig.TAG_STARS) then

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1
            end

        end
    end

    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.ItemRemovedEval)


---@param Player EntityPlayer
function mod:ShiftEval(Player)

    for Joker,Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        if Slot.Joker == mod.Jokers.RAISED_FIST then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Slot.Joker == mod.Jokers.STEEL_JOKER then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Slot.Joker == mod.Jokers.BLACKBOARD then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Slot.Joker == mod.Jokers.STONE_JOKER then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback("DECK_SHIFT", mod.ShiftEval)

---@param Player EntityPlayer
function mod:DeckModifyEval(Player)

    for Index,Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        if Slot.Joker == mod.Jokers.STEEL_JOKER then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Slot.Joker == mod.Jokers.STONE_JOKER then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

        elseif Slot.Joker == mod.Jokers.CLOUD_NINE then
            local Nines = 0
            for _,card in ipairs(mod.Saved.Jimbo.FullDeck) do
                if card.Value == 9 then
                    Nines = Nines + 1
                end
            end

            mod.Saved.Jimbo.Progress.Inventory[Index] = Nines
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback("DECK_MODIFY", mod.DeckModifyEval)

---STAT EVALUATION

function mod:TearsJokers(Player, _)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == 0 then --could save some time
            elseif Joker == mod.Jokers.BULL then --this works with mod:OnUpdate() in TrinketCallbacks.lua
                
                local Coins = Player:GetNumCoins()

                if mod.Saved.Other.HasDebt then
                    Coins = 0
                end

                local Tears = Player:GetNumCoins()

                if Tears ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    local Difference = Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    mod:GetSignString(Difference)..tostring(Difference),mod.Jokers.BULL)
                end
 
                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect


                --print(Tears)

                mod:IncreaseJimboStats(Player, Tears, 0, 1, false, false)
            
            elseif Joker == mod.Jokers.STONE_JOKER then
                local StoneCards = 0
                for i,card in ipairs(mod.Saved.Jimbo.FullDeck) do
                    if card.Enhancement == mod.Enhancement.STONE then
                        StoneCards = StoneCards + 1
                    end
                end

                local Tears = StoneCards * 1.25

                if Tears ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    mod:GetSignString(Difference)..tostring(Difference),mod.Jokers.STONE_JOKER)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --this is only to tell when to spawn the effect
                end

                mod:IncreaseJimboStats(Player, Tears, 0, 1, false, false)
            
            elseif Joker == mod.Jokers.ICECREAM then
                --icecream stores how many rooms are "left" in its progress
                mod:IncreaseJimboStats(Player, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], 0, 1, false, false)

            elseif Joker == mod.Jokers.ODDTODD then
                local NumOdd = 0
                for Num = 1,10,2 do
                    NumOdd = NumOdd + mod.Saved.Jimbo.Progress.Room.ValueUsed[Num]
                end

                local ItemNum = Player:GetCollectibleCount()

                local Tears = NumOdd*0.31 + ((ItemNum%2==1) and ItemNum*0.03 or 0)

                if Tears > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumOdd ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.ODDTODD)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)
            
            elseif Joker == mod.Jokers.ARROWHEAD then

                local NumSpades = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Spade]

                local Tears = NumSpades*0.5 + Player:GetNumKeys()*0.5

                if Tears ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumSpades ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                    "+"..tostring(Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.ARROWHEAD)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

            elseif Joker >= mod.Jokers.SLY_JOKER and Joker <= mod.Jokers.CRAFTY_JOKER then
                mod:IncreaseJimboStats(Player, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],0,1, false, false)

            elseif Joker == mod.Jokers.BANNER then

                local Tears = 0.75 * Player:GetHearts()

                if Tears ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                    "+"..tostring((Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.BANNER)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

            elseif Joker == mod.Jokers.SCARY_FACE then

                local Tears = mod.Saved.Jimbo.Progress.Room.ValueUsed[mod.Values.FACE]*0.3 + mod.Saved.Jimbo.Progress.Room.ChampKills

                if Tears > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and mod.Saved.Jimbo.Progress.Room.ValueUsed[mod.Values.FACE] ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                    "+"..tostring(Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.SCARY_FACE)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)
            

            elseif Joker == mod.Jokers.SCHOLAR then
                local NumAces = 0
 
                NumAces = mod.Saved.Jimbo.Progress.Room.ValueUsed[1]

                local Tears = NumAces*0.2

                if NumAces > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumAces ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(0.2*(NumAces - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.SCHOLAR)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumAces --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

            elseif Joker == mod.Jokers.SCHOLAR then
                local NumAces = 0
 
                NumAces = mod.Saved.Jimbo.Progress.Room.ValueUsed[1]

                local Tears = NumAces*0.2

                if NumAces > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumAces ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(0.2*(NumAces - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.SCHOLAR)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumAces --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)


            elseif Joker == mod.Jokers.BLUE_JOKER then

                local NumCards = #mod.Saved.Jimbo.FullDeck - mod.Saved.Jimbo.DeckPointer
 
                local Tears = NumCards * 0.1

                if Tears ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.BLUE_JOKER)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

            elseif Joker == mod.Jokers.RUNNER then

                mod:IncreaseJimboStats(Player, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],0,1, false, false)
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

        local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index + 0
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == 0 then --could save some time
            elseif Joker == mod.Jokers.JOKER then
                mod:IncreaseJimboStats(Player, 0, 0.2, 1, false, false)

            elseif Joker == mod.Jokers.ABSTRACT_JOKER then
                local NumJokers = 0
                for j,InnerSlot in ipairs(mod.Saved.Jimbo.Inventory) do
                    if InnerSlot.Joker ~= 0 then
                        NumJokers = NumJokers + 1
                    end
                end

                local ItemNum = Player:GetCollectibleCount()

                local Damage = ItemNum*0.03 + NumJokers + 0.15

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.ABSTRACT_JOKER)
                end
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end

                mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

            elseif Joker == mod.Jokers.MISPRINT then
                mod:IncreaseJimboStats(Player, 0, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], 1, false, false)

            elseif Joker == mod.Jokers.POPCORN then
                mod:IncreaseJimboStats(Player, 0, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], 1, false, false)

            elseif Joker == mod.Jokers.EVENSTEVEN then
                local NumEven = 0
                for Num=2, 10, 2 do
                    NumEven = NumEven + mod.Saved.Jimbo.Progress.Room.ValueUsed[Num]
                end

                local ItemNum = Player:GetCollectibleCount()

                local Damage = NumEven*0.04 + ((ItemNum%2==0) and ItemNum*0.02 or 0)

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumEven ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.EVENSTEVEN)
                end
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end
                mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)

            elseif Joker == mod.Jokers.GREEN_JOKER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == mod.Jokers.RED_CARD then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == mod.Jokers.FORTUNETELLER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == mod.Jokers.ONIX_AGATE then
                local NumClubs = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Club]

                local Damage = NumClubs*0.07

                if Damage > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumClubs ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.ONIX_AGATE)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)
            
            elseif Joker == mod.Jokers.GROS_MICHAEL then
                mod:IncreaseJimboStats(Player, 0,0.75,1, false, false)

            elseif Joker == mod.Jokers.FLASH_CARD then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)

            elseif Joker == mod.Jokers.SWASHBUCKLER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)

            elseif Joker == mod.Jokers.SACRIFICIAL_DAGGER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)

            elseif Joker == mod.Jokers.SUPERNOVA then
                
                mod:IncreaseJimboStats(Player, 0,0.01 * mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker >= mod.Jokers.JOLLY_JOKER and Joker <= mod.Jokers.DROLL_JOKER then
                mod:IncreaseJimboStats(Player, 0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1, false, false)
            
            elseif Joker == mod.Jokers.HALF_JOKER then

                if mod.Saved.Jimbo.Progress.Room.Shots <= 4 then
                    mod:IncreaseJimboStats(Player, 0, 1.5, 1, false, false)
                end

                if #mod.Saved.Jimbo.CurrentHand <= 3 then
                    mod:IncreaseJimboStats(Player, 0, 1, 1, false, false)
                end

            elseif Joker == mod.Jokers.LUSTY_JOKER then
                local NumHearts = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Diamond]

                local Damage = NumHearts*0.03 + 0.05 * Player:GetHearts()

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumHearts ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.LUSTY_JOKER)
                end
                
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, 0, Damage,1, false, false)

            elseif Joker == mod.Jokers.GREEDY_JOKER then
                local NumDiamonds = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Diamond]

                local Coins = Player:GetNumCoins()
                if mod.Saved.other.HasDebt then Coins = 0 end

                local Damage = NumDiamonds * 0.03 + 0.01*Coins

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumDiamonds ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.GREEDY_JOKER)
                end
                    
                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, 0, Damage ,1, false, false)

            elseif Joker == mod.Jokers.GLUTTONOUS_JOKER then
                local NumClubs = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Club]

                local Damage = NumClubs * 0.03 + 0.05*Player:GetNumBombs()
                if NumClubs ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumClubs ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.GLUTTONOUS_JOKER)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)


            elseif Joker == mod.Jokers.WRATHFUL_JOKER then
                local NumSpades = mod.Saved.Jimbo.Progress.Room.SuitUsed[mod.Suits.Spade]

                local Damage = NumSpades * 0.03 + 0.05*Player:GetNumKeys()

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumSpades ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(0.03*(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.WRATHFUL_JOKER)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)

            elseif Joker == mod.Jokers.MYSTIC_SUMMIT then

                local Damage = (Player:GetHearts() == 2) and 0.75 or 0

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.MYSTIC_SUMMIT)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

            elseif Joker == mod.Jokers.RAISED_FIST then

                local MinValue = 11

                for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do

                    MinValue = math.min(MinValue,  mod:GetActualCardValue(mod.Saved.Jimbo.FullDeck[v].Value)) 

                end

                local Damage = 0.05 * MinValue * (MimeNum+1)

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    local Difference = MinValue - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    mod:GetSignString(Difference)..tostring(Difference),mod.Jokers.RAISED_FIST)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end

                mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

            elseif Joker == mod.Jokers.FIBONACCI then

                local NumFibo = 0

                local LastNum = 1
                for i=1,8, 0 do
                    LastNum = i

                    NumFibo = NumFibo + mod.Saved.Jimbo.Progress.Room.ValueUsed[i]

                    i = i + LastNum
                end

                local ItemNum = Player:GetCollectibleCount()
                local HasFibonacci = math.type(((5*ItemNum^2 + 4)^0.5)) == "integer"
                                   or math.type(((5*ItemNum^2 - 4)^0.5)) == "integer"

                local Damage = NumFibo * 0.08 + (HasFibonacci and ItemNum*0.02 or 0)

                if Damage > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] or NumFibo == 1 then

                    mod.Counters.Activated[Index] = 0

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.FIBONACCI)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
                end --only used to tell when to spawn an effect
                
                mod:IncreaseJimboStats(Player, 0,Damage ,1 , false, false)


            elseif Joker == mod.Jokers.SCHOLAR then
                local NumAces = 0
 
                NumAces = mod.Saved.Jimbo.Progress.Room.ValueUsed[1]

                local Damage = NumAces*0.04

                if NumAces > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumAces ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(0.04*(NumAces - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.SCHOLAR)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumAces --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)

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

        local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Jokers or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == 0 then --could save some time
            elseif Joker == mod.Jokers.JOKER_STENCIL then

                local EmptySlots = 0
                for i,Slot2 in ipairs(mod.Saved.Jimbo.Inventory) do
                    if Slot2.Joker == 0 or (Slot2.Joker == mod.Jokers.JOKER_STENCIL and i ~= Index) then
                        EmptySlots = EmptySlots + 1
                    end
                end

                local Mult = 1 + EmptySlots*0.75

                if Player:GetActiveItem() == CollectibleType.COLLECTIBLE_NULL then
                    Mult = Mult + 0.25
                end

                if Mult ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Mult - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    mod:GetSignString(Difference)..tostring(Difference).."X",mod.Jokers.JOKER_STENCIL)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Mult --this is only to tell when to spawn the effect
                end

                mod:IncreaseJimboStats(Player, 0,0, Mult, false, false)
            
            elseif Joker == mod.Jokers.RAMEN then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
            elseif Joker == mod.Jokers.MADNESS then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
            elseif Joker == mod.Jokers.BLOODSTONE then

                mod:IncreaseJimboStats(Player,0,0,1 + 0.05*mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
            elseif Joker == mod.Jokers.CAVENDISH then

                mod:IncreaseJimboStats(Player,0,0,1.5,false,false)
            elseif Joker == mod.Jokers.LOYALTY_CARD then

                if mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] == 0 then
                    mod:IncreaseJimboStats(Player,0,0,2.5,false,false)
                end

            elseif Joker == mod.Jokers.STEEL_JOKER then
                local SteelCards = 0
                for i,card in ipairs(mod.Saved.Jimbo.FullDeck) do
                    if card.Enhancement == mod.Enhancement.STEEL then
                        SteelCards = SteelCards + 1
                    end
                end

                local Mult = 1 + SteelCards * 0.15

                if Mult ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Mult - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    mod:GetSignString(Difference)..tostring(Difference).."X",mod.Jokers.STEEL_JOKER)
                end

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Mult --this is only to tell when to spawn the effect
                end

                mod:IncreaseJimboStats(Player, 0, 0, Mult, false, false)
            
            elseif Joker == mod.Jokers.BLACKBOARD then

                local Mult = 2

                for _,Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
                    local card = mod.Saved.Jimbo.FullDeck[Pointer]

                    if not(mod:IsSuit(Player, card.Suit, card.Enhancement, mod.Suits.Spade)
                           or mod:IsSuit(Player, card.Suit, card.Enhancement, mod.Suits.Club)) then
                        
                        Mult = 1
                        break
                    end
                end


                if Mult == 2 then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Mult

                    mod:IncreaseJimboStats(Player,0,0,Mult,false,false)
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 1
                end

                if Mult ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Mult - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    mod:GetSignString(Difference)..tostring(Difference).."X",mod.Jokers.BLACKBOARD)
                end

            elseif Joker == mod.Jokers.RIDE_BUS then

                local Damage = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] * 0.01

                --the effects are handled in CARD_SHOT

                mod:IncreaseJimboStats(Player,0,Damage,1,false,false)

            elseif Joker == mod.Jokers.CONSTELLATION then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)

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
    for i,Slot in ipairs(mod.Saved.Jimbo.Inventory) do
        if Flags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            if Slot.Edition == mod.Edition.HOLOGRAPHIC then
                mod:IncreaseJimboStats(Player,0, 0.5, 1, false, false)
            elseif Slot.Edition == mod.Edition.POLYCROME then
                mod:IncreaseJimboStats(Player,0, 0, 1.25, false, false)
            end
        end
        if Flags & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            if Slot.Edition == mod.Edition.FOIL then
                mod:IncreaseJimboStats(Player,2.5, 0, 1, false, false)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EditionsStats)



function mod:SteelStatBoosts(Player, _)
    for _,index in ipairs(mod.Saved.Jimbo.CurrentHand) do
        local Triggers = 0
        if mod.Saved.Jimbo.FullDeck[index]
           and mod.Saved.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.STEEL then

            Triggers = Triggers + 1

            if mod.Saved.Jimbo.FullDeck[index].Seal == mod.Seals.RED then
                Triggers = Triggers + 1
            end

            Triggers = Triggers + #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

            --steel cards use the joker stats cause they are variable and need to be reset each time
            mod:IncreaseJimboStats(Player,0, 0, 1.25^Triggers, false,false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SteelStatBoosts, CacheFlag.CACHE_DAMAGE)

-----JOKERS SECONDARY EFFECTS---------
-------------------------------------

---@param Player EntityPlayer
function mod:FlightEval(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    if mod:JimboHasTrinket(Player, mod.Jokers.CLOUD_NINE) then
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
    

    if mod:JimboHasTrinket(Player, mod.Jokers.GOLDEN_JOKER) 
       and Collider:IsEnemy() and Collider:IsActiveEnemy() then
        
        Collider = Collider:ToNPC() or Collider

        Collider:AddMidasFreeze(EntityRef(Player), 100)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, mod.GoldenTouch, PlayerVariant.PLAYER)


---@param Entity Entity
function mod:DelayedGrat(Entity)

    local AllGood = false
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType or AllGood then
            goto skip_player
        end

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do
            if Slot.Joker == mod.Jokers.DELAYED_GRATIFICATION then
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


local EnemyCounter = 1
---@param Entity EntityNPC
function mod:FifthEnemyRemove(Entity)

    local AllGood = false
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType or AllGood then
            goto skip_player
        end

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do
            if Slot.Joker == mod.Jokers.FOUR_FINGER then
                AllGood = true
                break
            end
        end

        ::skip_player::
    end

    if not AllGood or Entity:IsBoss() then
        return
    end

    if Entity:IsActiveEnemy() then

        if EnemyCounter == 5 then
  
            Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)

            Entity:Kill()

            EnemyCounter = 0
        end


        EnemyCounter = EnemyCounter + 1
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.FifthEnemyRemove)


---@param Player EntityPlayer
function mod:MimeActive(Type, RNG, Player, Flags,_,_)

    if Player:GetPlayerType() ~= mod.Characters.JimboType 
       or Flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY
       or Flags & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC
       or Flags & UseFlag.USE_REMOVEACTIVE == UseFlag.USE_REMOVEACTIVE then
        return
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do
        
        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.MIME then

            if mod:TryGamble(Player, RNG, 0.2) then
                Player:UseActiveItem(Type, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
        
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW,mod.Sounds.ACTIVATE, "Again!",mod.Jokers.MIME)
        
                mod.Counters.Activated[Index] = 0
            end
        end
    end
    


end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.MimeActive)


---@param Player EntityPlayer
function mod:MimeCards(card, Player,Flags)

    if Player:GetPlayerType() ~= mod.Characters.JimboType 
       or Flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY
       or Flags & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then
        return
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.MIME then

            if mod:TryGamble(Player, Player:GetCardRNG(card), 0.2) then

                local RandomSeed = Random()
        
                RandomSeed = RandomSeed==0 and 1 or RandomSeed
        
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, card, RandomSeed)
                --Player:UseCard(card, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW,mod.Sounds.ACTIVATE, "Again!",mod.Jokers.MIME)

                mod.Counters.Activated[Index] = 0
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.MimeCards)


function mod:RoughGemBackstab(Tear, Split)

    local Player = Tear.Parent:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local TearData = Tear:GetData()
    
    if mod:IsSuit(Player, TearData.Params.Suit, TearData.Params.Enhancement, mod.Suits.Diamond, false)
       and mod:JimboHasTrinket(Player, mod.Jokers.ROUGH_GEM) then
        Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.RoughGemBackstab)


---@param NPC EntityNPC
function mod:PareidoliaCahmpionChance(NPC)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) 
       or NPC:IsChampion() then
        return
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.PAREIDOLIA then

                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.PAREIDOLIA), 0.2) then

                    NPC:MakeChampion(Player:GetTrinketRNG(mod.Jokers.PAREIDOLIA):GetSeed())
                end
            end
        end

        ::skip_player::
    end


end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.PareidoliaCahmpionChance)


---@param NPC EntityNPC
function mod:EnemyKill(NPC)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    if NPC:IsChampion() then
        mod.Saved.Jimbo.Progress.Room.ChampKills = mod.Saved.Jimbo.Progress.Room.ChampKills + 1
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.SCARY_FACE then
                if NPC:IsChampion() then
                    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                end

            elseif Joker == mod.Jokers.FACELESS then

                if not NPC:IsChampion() then
                    local Champions = {}
                    for _, Entity in ipairs(Isaac.GetRoomEntities()) do
                        if Entity:IsEnemy() and Entity:IsActiveEnemy() then
                            if Entity:ToNPC():IsChampion() then
                                table.insert(Champions, Entity)
                            else
                                goto skip_player --basically acts as a return
                            end
                        end
                    end

                    for _,Enemy in ipairs(Champions) do
                        Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)

                        Entity:Kill()
                    end 

                end
            end
        end

        Player:EvaluateItems()

        ::skip_player::
    end


end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.EnemyKill)



function mod:HackReevaluationAdd(Item,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local AmountToAdd = #mod:GetJimboJokerIndex(Player, mod.Jokers.HACK)

    if AmountToAdd == 0 then
        return
    end

    

    local item = ItemsConfig:GetCollectible(Item)
    if item
    and item.Type ~= ItemType.ITEM_ACTIVE
    and (item.Quality == 0 or item.Quality == 1)
    and not item:HasTags(ItemConfig.TAG_QUEST)
    and item.Hidden == false
    and Player:HasCollectible(Item, true, true) then

        

        Player:AddInnateCollectible(Item, AmountToAdd)

        if AmountToAdd >= 0 then
            for i=1, AmountToAdd do
                mod.Saved.Jimbo.InnateItems.Hack[#mod.Saved.Jimbo.InnateItems.Hack + 1] = Item
            end
        else
            for i=1, -AmountToAdd do

                table.remove(mod.Saved.Jimbo.InnateItems.Hack, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.Hack, Item, true))
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.HackReevaluationAdd)


function mod:HackReevaluationRemove(Player,Item)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local AmountToRemove = #mod:GetJimboJokerIndex(Player, mod.Jokers.HACK)

    print(AmountToRemove)

    if AmountToRemove == 0 then
        return
    end

    local item = ItemsConfig:GetCollectible(Item)
    if item
    and item.Type ~= ItemType.ITEM_ACTIVE
    and (item.Quality == 0 or item.Quality == 1)
    and not item:HasTags(ItemConfig.TAG_QUEST)
    and item.Hidden == false then

        Player:AddInnateCollectible(Item, -AmountToRemove)

        for i=1, AmountToRemove do

            table.remove(mod.Saved.Jimbo.InnateItems.Hack, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.Hack, Item, true))
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.HackReevaluationRemove)


---@param Player EntityPlayer
function mod:JimboLuckStat(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    Player.Luck = Player.Luck + 5 * #mod:GetJimboJokerIndex(Player, mod.Jokers.SCHOLAR)

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboLuckStat, CacheFlag.CACHE_LUCK)

local SuitInitails = {"S","H","C","D"}
function mod:GlitchItems(_,Decrease,Seed)

    if not Decrease then
        return
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.MISPRINT then

                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.MISPRINT), 0.1) then
                    
                    mod.Counters.Activated[Index] = 0

                    --just like the base game, technically shows the next card to be drawn
                    local CardString = tostring(mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.DeckPointer])..SuitInitails[mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.DeckPointer].Suit]

                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW,mod.Sounds.ACTIVATE, "#@"..CardString,mod.Jokers.MIME)

                    GlichItem = ProceduralItemManager.CreateProceduralItem(Player:GetTrinketRNG(mod.Jokers.MISPRINT):GetSeed(),
                                                                            ProceduralItemManager.GetProceduralItemCount()+1) -- i guess this is what i'm supposed to do(?)

                    return GlichItem
                end
            end
        end
    
        ::skip_player::
    end


end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.GlitchItems)



function mod:PlanetCardUse(card, Player,_)
    if card <= mod.Planets.PLUTO or card >= mod.Planets.SUN 
       or Player:GetPlayerType() ~= mod.Characters.JimboType then --if it's a planet Card
        return
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.CONSTELLATION then
            
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 0.04

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT, "+0.04X",mod.Jokers.CONSTELLATION)

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        end



    end

    Player:Evaluateitems()
end

------------EXAMPLE JOKER FUNCTION----------
--[[
for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType or AllGood then
        goto skip_player
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do
        if Slot.Joker == mod.Jokers.DELAYED_GRATIFICATION then
            AllGood = true
            break
        end
    end

    ::skip_player::
end
--]]