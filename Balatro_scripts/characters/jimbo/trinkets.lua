local mod = Balatro_Expansion
-- |_(T_T)_/ <-- me rn fr
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
--RETRIGGER CALCULATION + SEALS + VAMPIRE EFFECT----
-----------------------------------

local Triggers = 1 --how many times the card needs to be activated again

for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

    local Joker = Slot.Joker

    local ProgressIndex = Index
    local Copied = false
    if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

        Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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

    elseif Joker == mod.Jokers.SELTZER then

        Triggers = Triggers + 1
    
    elseif Joker == mod.Jokers.VAMPIRE then

        if not Copied and ShotCard.Enhancement ~= mod.Enhancement.NONE then

            mod.Saved.Jimbo.FullDeck[ShotCard.Index].Enhancement = mod.Enhancement.NONE
            ShotCard.Enhancement = mod.Enhancement.NONE

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.02

            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.02X",mod.Jokers.VAMPIRE)

            mod.Counters.Activated[Index] = 0

            Isaac.RunCallback("DECK_MODIFY", Player)
        end

    elseif Joker == mod.Jokers.MIDAS then

        if not Copied and ShotCard.Value >= mod.Values.JACK then
            mod.Saved.Jimbo.FullDeck[ShotCard.Index].Enhancement = mod.Enhancement.GOLDEN
            ShotCard.Enhancement = mod.Enhancement.GOLDEN
    
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Golden!",mod.Jokers.MIDAS)
    
            mod.Counters.Activated[Index] = 0
    
            Isaac.RunCallback("DECK_MODIFY", Player)
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
for GoodSuit,IsValid in ipairs(mod:IsSuit(Player, ShotCard, 0, true)) do

    if IsValid then
        mod.Saved.Jimbo.Progress.Room.SuitUsed[GoodSuit] = mod.Saved.Jimbo.Progress.Room.SuitUsed[GoodSuit] + Triggers
    end
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

        Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

        ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

        Copied = true
    end

    if Joker == 0 then
    elseif Joker == mod.Jokers.ROUGH_GEM then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Diamond, false) then
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
        if mod:IsSuit(Player, ShotCard, mod.Suits.Heart, false) then
            for i = 1, Triggers do
                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BLOODSTONE), 0.5) then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] * 1.05
                    
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
                                                RandomVector()*4 * Player.MoveSpeed, Player, CoinSubType.COIN_PENNY, RandomSeed)
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

        if ShotCard.Value == mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
            local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,                                  RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                                    Coin:ToPickup().Timeout = 50

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Done!",mod.Jokers.TO_DO_LIST)
        end

    elseif Joker == mod.Jokers.CARD_SHARP then

        if not Copied
           and mod.Saved.Jimbo.LastShotIndex ~= 0
           and ShotCard.Value == mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.LastShotIndex].Value --same value as last card
           and ShotCard.Enhancement ~= mod.Enhancement.STONE --no stone cards allowed
           and mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.LastShotIndex].Enhancement ~= mod.Enhancement.STONE then
            
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.1",mod.Jokers.CARD_SHARP)
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] * 1.10
        end
    
    elseif Joker == mod.Jokers.SQUARE_JOKER then

        if mod.Saved.Jimbo.Progress.Room.Shots % 4 == 3 then
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
            "+4"
            ,mod.Jokers.SQUARE_JOKER)

        elseif mod.Saved.Jimbo.Progress.Room.Shots % 4 == 0 then
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
            "-4"
            ,mod.Jokers.SQUARE_JOKER)
        end
    elseif Joker == mod.Jokers.OBELISK then

        if not Copied and mod.Saved.Jimbo.LastShotIndex ~= 0 then

            if (ShotCard.Suit ~= mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.LastShotIndex].Suit --different suit from last card
                or ShotCard.Enhancement == mod.Enhancement.WILD --wild always trigger
                or mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.LastShotIndex].Enhancement == mod.Enhancement.WILD) then
            
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.05X",mod.Jokers.OBELISK)
                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 0.05
            
            elseif mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] ~= 1 then
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset",mod.Jokers.OBELISK)
                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 1
            end
        end

    elseif Joker == mod.Jokers.PHOTOGRAPH then

        if not Copied
           and mod.Saved.Jimbo.Progress.Room.ValueUsed[mod.Values.FACE] == Triggers then --if it's the first one played
            
            local Mult = 1.1^Triggers
           
            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.Jokers.PHOTOGRAPH)
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] * Mult
        end

    elseif Joker == mod.Jokers.ANCIENT_JOKER then
        if mod:IsSuit(Player, ShotCard, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex], false) then

            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(1.05^Triggers),mod.Jokers.ANCIENT_JOKER)
        end

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

                for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.02

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.02X", mod.Jokers.LUCKY_CAT)
                end

            end
            if mod:TryGamble(Player, PlayerRNG, 0.05) then
                Player:AddCoins(10)
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+10 $", mod.Enhancement.LUCKY)

                for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.02

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.02X", mod.Jokers.LUCKY_CAT)
                end

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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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



function mod:OnHandDiscard(Player, AmountDiscarded)

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise
    --cycles between all the held jokers
    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == mod.Jokers.RAMEN and not Copied then

            local LostMult = 0.01 * AmountDiscarded
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - LostMult
        
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Eaten!",mod.Jokers.RAMEN)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, tostring(-LostMult).."X",mod.Jokers.RAMEN)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        
        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            local InitialProg = mod.Saved.Jimbo.Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 0.16
                if mod.Saved.Jimbo.Progress.Inventory[Index] < 0 then
                    mod.Saved.Jimbo.Progress.Inventory[Index] = 0
                end
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.16",mod.Jokers.GREEN_JOKER)
        
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            for i,Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
                if mod.Saved.Jimbo.FullDeck[Pointer].Value == mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    for i=1,2 do
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                   RandomVector()*2.5, Player, CoinSubType.COIN_PENNY, 1)
                    end
                end
            end

        elseif Joker == mod.Jokers.DRUNKARD then

            Game:SetDizzyAmount(math.max(Game:GetDizzyAmount()-0.04, 0))
        end
    end

    Player:EvaluateItems()

end
mod:AddCallback("HAND_DISCARD", mod.OnHandDiscard)


--effects when a joker gets sold
---@param Player EntityPlayer
function mod:OnJokerSold(Player,Joker,SlotSold)
    --print("sold")


    --NOT COPIABLE JOKERS

    if Joker == mod.Jokers.INVISIBLE_JOKER then
        if mod.Saved.Jimbo.Progress.Inventory[SlotSold] ~= 3 then
            return
        end
        local ValidJokers = {}
        for i, trinket in ipairs(mod.Saved.Jimbo.Inventory) do
            --can only copy something other than itself and nothing
            if trinket.Joker ~= 0 and i ~= SlotSold then
                ValidJokers[#ValidJokers + 1] = i
            end
        end

        if not next(ValidJokers) then --no need if player is poor
            return
        end

        local RandomIndex = mod:GetRandom(ValidJokers, Player:GetTrinketRNG(mod.Jokers.INVISIBLE_JOKER))

        local JokerCopied = mod.Saved.Jimbo.Inventory[RandomIndex].Joker
        local EditionCopied = mod.Saved.Jimbo.Inventory[RandomIndex].Edition

        if EditionCopied == mod.Edition.NEGATIVE then --removes negative from copied joker
            EditionCopied = mod.Edition.BASE
        end

        mod:AddJoker(Player, JokerCopied, EditionCopied)

        mod.Saved.Jimbo.Progress.Inventory[SlotSold] = mod.Saved.Jimbo.Progress.Inventory[RandomIndex]

    elseif Joker == mod.Jokers.CAMPFIRE then

        mod.Saved.Jimbo.Progress.Inventory[SlotSold] = mod.Saved.Jimbo.Progress.Inventory[SlotSold] + 0.2

        mod:CreateBalatroEffect(SlotSold,mod.EffectColors.RED, 
                                        mod.Sounds.TIMESMULT, "+0.2X",mod.Jokers.CAMPFIRE)

    elseif Joker == mod.Jokers.TRADING_CARD then
    
        local NumDestroyed = #mod.Saved.Jimbo.CurrentHand

        mod:CreateBalatroEffect(SlotSold,mod.EffectColors.YELLOW, 
                                        mod.Sounds.MOMEY, "+"..3*NumDestroyed.."$",mod.Jokers.TRADING_CARD)


        mod:DestroyCards(Player, mod.Saved.Jimbo.CurrentHand, true)

    end
    
    --BP/BS CHACK
    if Joker == mod.Jokers.BLUEPRINT then
        Joker = mod.Saved.Jimbo.Inventory[SlotSold + 1].Joker or 0

    elseif Joker == mod.Jokers.BRAINSTORM then
        Joker = mod.Saved.Jimbo.Inventory[1].Joker
    end
    
    
    if Joker == mod.Jokers.LUCHADOR then

        for _,Entity in ipairs(Isaac.GetRoomEntities()) do
            if Entity:IsBoss() then
                Entity:ToNPC():AddWeakness(EntityRef(Player), 900)
            end
        end

        Game:GetRoom():MamaMegaExplosion(Player.Position)

        mod:CreateBalatroEffect(SlotSold,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "You're Done!",mod.Jokers.LUCHADOR)

    elseif Joker == mod.Jokers.DIET_COLA then

        --PLACEHOLDER maybe play the tag sfx

        Player:UseActiveItem(CollectibleType.COLLECTIBLE_DIPLOPIA, UseFlag.USE_NOANIM & UseFlag.USE_MIMIC)
    end

--[[ INVENTORY_CHANGE evaluates every stat anyways
    Player:AddCacheFlags(ItemsConfig:GetTrinket(Joker).CacheFlags, true)

    local CustomFlags = ItemsConfig:GetTrinket(Joker):GetCustomCacheTags()

    Player:AddCustomCacheTag(CustomFlags, true)]]



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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
            StoneCard.Upgrades = 0

            mod:AddCardToDeck(Player, StoneCard,1, false)

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Stone!",mod.Jokers.MARBLE_JOKER)
        
        elseif Joker == mod.Jokers.GIFT_CARD then
            
            for i,JokerSlot in ipairs(mod.Saved.Jimbo.Inventory) do

                if JokerSlot.Joker ~= 0 then
                    mod.Saved.Jimbo.Progress.GiftCardExtra[i] = mod.Saved.Jimbo.Progress.GiftCardExtra[i] or 0
                    
                    mod.Saved.Jimbo.Progress.GiftCardExtra[i] = mod.Saved.Jimbo.Progress.GiftCardExtra[i] + 1
                end
            end

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.Jokers.GIFT_CARD)


            if mod:JimboHasTrinket(Player, mod.Jokers.SWASHBUCKLER) then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.TURTLE_BEAN then
            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 0 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Eaten!")

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-1",mod.Jokers.TURTLE_BEAN)
            
                Player:AddCustomCacheTag("handsize")
            end

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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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

            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

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

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
        elseif Joker == mod.Jokers.SUPERNOVA then
            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0

            mod.Counters.Activated[Index] = 0
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset",mod.Jokers.SUPERNOVA)

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.MR_BONES then
            if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.MR_BONES), 0.2) then
                
                Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
            end

        elseif Joker == mod.Jokers.DNA then
            if Hostile then
                Player:AddMinisaac(Player.Position, true)
            end


        elseif Joker == mod.Jokers.RESERVED_PARK then

            local ParkRNG = Player:GetTrinketRNG(mod.Jokers.RESERVED_PARK)

            for _,Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
                local card = mod.Saved.Jimbo.FullDeck[Pointer]

                if card.Value >= mod.Values.JACK and card.Enhancement ~= mod.Enhancement.STONE
                   and mod:TryGamble(Player, ParkRNG, 0.25) then

                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position, RandomVector()*2.5, Player, 0, Game:GetRoom():GetSpawnSeed())
                end
            end

        elseif Joker == mod.Jokers.PHOTOGRAPH then

            mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 1

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.SELTZER and not Copied then

            mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] - 1
    
            if mod.Saved.Jimbo.Progress.Inventory[Index] <= 0 then --at 0 it self destructs
                
                mod.Saved.Jimbo.Inventory[Index].Joker = 0
                mod.Saved.Jimbo.Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Empty!",mod.Jokers.SELTZER)
    
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "-1",mod.Jokers.SELTZER)
            end
        end

    end

    Player:EvaluateItems()

    ::skip_player::

    end
end
mod:AddCallback("TRUE_ROOM_CLEAR", mod.OnRoomClear)


function mod:OnNewRoomJokers()

    if not mod.GameStarted then
        return
    end
    --ANY ROOM--

    local Room = Game:GetRoom()
    local RoomRNG = RNG(Room:GetSpawnSeed())

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker    

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            local HandType = mod:DeterminePokerHand(Player)

            local RandomSeed = Random()
            if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

            if Joker == mod.Jokers.SHORTCUT then
                
                if Game:GetLevel():GetCurrentRoomDesc().SafeGridIndex == mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local GridPos = Isaac.GetFreeNearPosition(Room:GetCenterPos(),20)

                    Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, GridPos, true)

                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = -1
                end

            elseif Joker == mod.Jokers.STONE_JOKER then
                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            end


            if not Room:IsFirstVisit() or Room:IsClear() then
                goto skip_player
            end

            if Joker == mod.Jokers.MISPRINT then
                local MisDMG = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]

                if not Copied then
                    local RoomRNG = RNG(Room:GetSpawnSeed())

                    MisDMG = mod:round(RoomRNG:RandomFloat(), 2)
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = MisDMG

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(MisDMG),mod.Jokers.MISPRINT)
                end


                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.HALLUCINATION then

                local RoomRNG = RNG(Room:GetSpawnSeed())

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

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.ZANY_JOKER then
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 2

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+2",mod.Jokers.ZANY_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.MAD_JOKER then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 1.5

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+1.5",mod.Jokers.MAD_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
            elseif Joker == mod.Jokers.CRAZY_JOKER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 3

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+3",mod.Jokers.CRAZY_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.DROLL_JOKER then
                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 2.25

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+2.25",mod.Jokers.DROLL_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
            elseif Joker == mod.Jokers.SLY_JOKER then
                if HandType & mod.HandTypes.PAIR == mod.HandTypes.PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 4

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+4",mod.Jokers.SLY_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.WILY_JOKER then
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 8

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+8",mod.Jokers.WILY_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.CLEVER_JOKER then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 6

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+6",mod.Jokers.CLEVER_JOKER)
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            
            elseif Joker == mod.Jokers.DEVIOUS_JOKER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 12

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+12",mod.Jokers.DEVIOUS_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.CRAFTY_JOKER then

                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 9

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+9",mod.Jokers.CRAFTY_JOKER)

                    mod.Counters.Activated[Index] = 0
                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.SPLASH then

                for i, Index in ipairs(mod.Saved.Jimbo.CurrentHand) do 
                    local ShotCard = mod.Saved.Jimbo.FullDeck[Index]
                    ShotCard.Index = Index

                    mod:OnCardShot(Player, ShotCard, false) --triggers every card in hand
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

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
                

                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                               RandomVector()*3, Player, mod.Packs.ARCANA,  RandomSeed)

                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.Jokers.SUPERPOSISION)

                    mod.Counters.Activated[Index] = 0
                end

            elseif Joker == mod.Jokers.TO_DO_LIST then

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = RoomRNG:RandomInt(1,mod.Values.KING)

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Play "..tostring(mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]).."s",mod.Jokers.TO_DO_LIST)
                end

            elseif Joker == mod.Jokers.MAIL_REBATE then

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = RoomRNG:RandomInt(1,mod.Values.KING)
                    
                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Discard "..tostring(mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]).."s",mod.Jokers.MAIL_REBATE)
                end

            elseif Joker == mod.Jokers.SEANCE then

                if HandType & mod.HandTypes.STRAIGHT_FLUSH == mod.HandTypes.STRAIGHT_FLUSH then

                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                               RandomVector()*2.5, Player, mod.Packs.SPECTRAL, RandomSeed)
                end

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Spectral!",mod.Jokers.SEANCE)
    
            elseif Joker == mod.Jokers.CHAOS_CLOWN then

                if Room:GetType() == RoomType.ROOM_SHOP then

                    Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                           Game:GetRoom():GetGridPosition(27),Vector.Zero, nil, 0, Game:GetRoom():GetSpawnSeed())
                end

            elseif Joker == mod.Jokers.ANCIENT_JOKER then

                local StableRoomRNG = RNG(Room:GetSpawnSeed()) --this is initialised caus in Balator ancient jokers copies always have the same suit

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = StableRoomRNG:RandomInt(mod.Suits.Spade,mod.Suits.Diamond)

                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Play "..mod:CardSuitToName(mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]).."!",mod.Jokers.ANCIENT_JOKER)
                end

            elseif Joker == mod.Jokers.SPARE_TROUSERS then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then
                   
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 0.25 --0.4

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.25",mod.Jokers.MAD_JOKER)

                else
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
            end
        end

        Player:EvaluateItems()

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomJokers)


function mod:OnNewLevelJokers()

    if not mod.GameStarted then
        return
    end

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

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            if Slot.Joker == mod.Jokers.SHORTCUT then

                local Level = Game:GetLevel()

                for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SHORTCUT, true)) do
                    repeat
                        local Seed = Random()
                        if Seed == 0 then Seed = 1 end

                        mod.Saved.Jimbo.Progress.Inventory[Index] = Level:GetRandomRoomIndex(false, Seed)  --ShortRNG:RandomInt(0, NumRooms-1)
                    until Level:GetStartingRoomIndex() ~= mod.Saved.Jimbo.Progress.Inventory[Index]

                    --print("chose: "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))
                end

            elseif Slot.Joker == mod.Jokers.CAMPFIRE then
 
                mod.Saved.Jimbo.Progress.Inventory[Index] = 1

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Reset",mod.Jokers.CAMPFIRE)
            end
        end

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

    --Player:AddCustomCacheTag("handsize", false)
    --Player:AddCustomCacheTag("discards", false)
    --Player:AddCustomCacheTag("inventory", true)


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

            if Index == StartI
               or not mod.Saved.Jimbo.Inventory[Index]
               or mod.Saved.Jimbo.Inventory[Index].Joker == 0
               or not ItemsConfig:GetTrinket(mod.Saved.Jimbo.Inventory[Index].Joker):HasCustomCacheTag("copy") then --some combinations can lead to infinite loops
                
                mod.Saved.Jimbo.Progress.Inventory[StartI] = 0
                break
            end
        end
    end

    --amounts needed for innate items counting
    local HackNum = 0
    local SuperPosNum = 0

    --SECOND it does other suff
    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == -1 then
        elseif Joker == 0 then --if the slot is empty

            if not Copied then
                mod.Saved.Jimbo.Progress.GiftCardExtra[Index] = 0
            end

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

            if TotalSell*0.05 - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] ~= 0 then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        elseif Joker == mod.Jokers.SQUARE_JOKER then
            Options.Filter = false --they get what they deserve
            
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


    if mod:JimboHasTrinket(Player, mod.Jokers.ROCKET) then
        
        if not Player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, false, false) then
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
            table.insert(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
        end

    --checks if the player has an innate collectible to remove
    elseif mod:Contained(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) then
        
        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, -1)
        table.remove(mod.Saved.Jimbo.InnateItems.General, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.General,CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,true))

    end

    if mod:JimboHasTrinket(Player, mod.Jokers.JUGGLER) then
        
        if not Player:HasCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, false, false) then
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY)
            table.insert(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_POLYDACTYLY)
        end

    --checks if the player has an innate collectible to remove
    elseif mod:Contained(mod.Saved.Jimbo.InnateItems.General, CollectibleType.COLLECTIBLE_POLYDACTYLY) then
        
        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, -1)
        table.remove(mod.Saved.Jimbo.InnateItems.General, mod:GetValueIndex(mod.Saved.Jimbo.InnateItems.General,CollectibleType.COLLECTIBLE_POLYDACTYLY,true))

    end

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

    elseif Joker == mod.Jokers.SHORTCUT then

        local Level = Game:GetLevel()

        for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SHORTCUT, true)) do
            repeat
                local Seed = Random()
                if Seed == 0 then Seed = 1 end

                local RandomIndex = Level:GetRandomRoomIndex(false, Seed)  --ShortRNG:RandomInt(0, NumRooms-1)
            
                local ChosenRoom = Level:GetRoomByIdx(RandomIndex)

                mod.Saved.Jimbo.Progress.Inventory[Index] = ChosenRoom.SafeGridIndex

            until Level:GetStartingRoomIndex() ~= mod.Saved.Jimbo.Progress.Inventory[Index]
                  and ChosenRoom.Data.Type ~= RoomType.ROOM_BOSS
                  and ChosenRoom.Data.Type ~= RoomType.ROOM_ULTRASECRET
        
            --print("chose: "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            if Level:GetCurrentRoomDesc().SafeGridIndex == mod.Saved.Jimbo.Progress.Inventory[Index] then
                local Room = Game:GetRoom()
                local GridPos = Isaac.GetFreeNearPosition(Room:GetCenterPos(),20)

                Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, GridPos, true)

                mod.Saved.Jimbo.Progress.Inventory[Index] = -1
            end
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
function mod:MischeviousThingsBasedEval(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or Game:GetFrameCount() % 3 == 0 then
        return
    end

    local NowCoins = Player:GetNumCoins()
    local NowBombs = Player:GetNumBombs()
    local NowKeys = Player:GetNumKeys()
    local NowHearts = Player:GetHearts()
    local NowShader = Player:GetSprite():HasCustomShader()

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

    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.ICECREAM, true)) do
        if Game:GetFrameCount() % 8 == Index or Game:GetFrameCount() % 9 == Index then

            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, Player.Position,
                                     Vector.Zero, Player, 0, 1):ToEffect()


        ---@diagnostic disable-next-line: need-check-nil
            local Data = Creep:GetData()
            Data.IsIcecreamB = true

        ---@diagnostic disable-next-line: need-check-nil
            Creep:GetSprite().Color:SetOffset(-1,-0.5,-0.2)

            Creep.Scale = 0.65 + mod.Saved.Jimbo.Progress.Inventory[Index] * 0.1

        end
    end




    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.MischeviousThingsBasedEval)


---@param Player EntityPlayer
function mod:ItemAddedEval(Type,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local Config = ItemsConfig:GetCollectible(Type)

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.JOKER_STENCIL then

            if Config.Type == ItemType.ITEM_ACTIVE then
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

            if Config:HasTags(ItemConfig.TAG_STARS) then

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
            end

        elseif Joker == mod.Jokers.BARON then

            if Config.Quality == 4 then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.BASEBALL then

            if Config.Quality == 2 then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Slot.Joker == mod.Jokers.BLACKBOARD then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Slot.Joker == mod.Jokers.BARON then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback("DECK_SHIFT", mod.ShiftEval)


---@param Player EntityPlayer
function mod:DeckModifyEval(Player, CardsAdded)

    CardsAdded = CardsAdded or 0

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

        elseif Slot.Joker == mod.Jokers.HOLOGRAM then

            if CardsAdded > 0 then

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.1*CardsAdded

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                "+0.1X",mod.Jokers.HOLOGRAM)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Slot.Joker == mod.Jokers.EROSION then
            if CardsAdded < 0 then

                mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.15 * -CardsAdded

                mod.Counters.Activated[Index] = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                "+"..tostring(0.15 * -CardsAdded),mod.Jokers.EROSION)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                
            end
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

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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
                local Room = Game:GetRoom()

                for i = 0, Room:GetGridSize() do
                    local Rock = Room:GetGridEntity(i)
                    if Rock and Rock:GetType() == GridEntityType.GRID_ROCK and Rock:GetSaveState().State ~= 2 then
                        Tears = Tears + 0.05
                    end
                end

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

                local Tears = NumOdd*0.31 + ((ItemNum%2==1) and ItemNum*0.07 or 0)

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

                    local Difference = Tears - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                    mod:GetSignString(Difference)..tostring((Difference))
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

            elseif Joker == mod.Jokers.WALKIE_TALKIE then
                local NumUsed = mod.Saved.Jimbo.Progress.Room.ValueUsed[4] + mod.Saved.Jimbo.Progress.Room.ValueUsed[10]
 
                local Tears = NumUsed*0.1

                if NumUsed > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumUsed ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(0.1*(NumUsed - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.WALKIE_TALKIE)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumUsed --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

            elseif Joker == mod.Jokers.BLUE_JOKER then

                local NumCards = #mod.Saved.Jimbo.FullDeck - mod.Saved.Jimbo.DeckPointer + 1
 
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

                mod:IncreaseJimboStats(Player, mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + Player.MoveSpeed,0,1, false, false)
            
            elseif Joker == mod.Jokers.SQUARE_JOKER then

                local Tears = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 0 --retro vision stats

                if mod.Saved.Jimbo.Progress.Room.Shots % 4 == 3 then
                    Tears = Tears + 4
                end

                mod:IncreaseJimboStats(Player, Tears,0,1, false, false)
            
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

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

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

                local TotalSell = 0
                for i,Jok in ipairs(mod.Saved.Jimbo.Inventory) do
                    if Jok.Joker ~= 0 then
                        TotalSell = TotalSell + mod:GetJokerCost(Jok.Joker, i)
                    end
                end

                local Difference = TotalSell*0.05 - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                if Difference ~= 0 then

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    mod:GetSignString(Difference)..tostring(Difference),mod.Jokers.SWASHBUCKLER)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = TotalSell * 0.05


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


                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect

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
                local i = 1
                while i <= 8 do

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

            elseif Joker == mod.Jokers.WALKIE_TALKIE then
                local NumUsed = mod.Saved.Jimbo.Progress.Room.ValueUsed[4] + mod.Saved.Jimbo.Progress.Room.ValueUsed[10]
 
                local Damage = NumUsed*0.04

                if NumUsed > mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] and NumUsed ~= 0 then

                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+"..tostring(0.04*(NumUsed - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]))
                    ,mod.Jokers.WALKIE_TALKIE)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = NumUsed --only used to tell when to spawn an effect

                mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)

            elseif Joker == mod.Jokers.EROSION then

                mod:IncreaseJimboStats(Player,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1,false,false)    

            elseif Joker == mod.Jokers.SMILEY_FACE then

                local Damage = 0.05 * mod.Saved.Jimbo.Progress.Room.ValueUsed[mod.Values.FACE]

                if Damage ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                    "+"..tostring(Damage - mod.Saved.Jimbo.Progress.Inventory[ProgressIndex])
                    ,mod.Jokers.SMILEY_FACE)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect

                mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

            elseif Joker == mod.Jokers.SPARE_TROUSERS then

                mod:IncreaseJimboStats(Player,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],1,false,false)    
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

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

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

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)
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

                    if not(mod:IsSuit(Player, card, mod.Suits.Spade)
                           or mod:IsSuit(Player, card, mod.Suits.Club)) then
                        
                        Mult = 1
                        break
                    end
                end

                if Mult ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Mult / mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod.Counters.Activated[Index] = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    "X"..tostring(Difference),mod.Jokers.BLACKBOARD)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Mult

                mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

            elseif Joker == mod.Jokers.RIDE_BUS then

                local Damage = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] * 0.01

                --the effects are handled in CARD_SHOT

                mod:IncreaseJimboStats(Player,0,Damage,1,false,false)

            elseif Joker == mod.Jokers.CONSTELLATION then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)

            elseif Joker == mod.Jokers.CARD_SHARP then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)

            elseif Joker == mod.Jokers.VAMPIRE then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)

            elseif Joker == mod.Jokers.HOLOGRAM then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)

            elseif Joker == mod.Jokers.BARON then
            

                local Mult = 1

                for _,Pointer in ipairs(mod.Saved.Jimbo.CurrentHand) do
                    local card = mod.Saved.Jimbo.FullDeck[Pointer]

                    if card.Value == mod.Values.KING then
                        
                        Mult = Mult * 1.2
                    end
                end

            ---@diagnostic disable-next-line: undefined-field
                for Item = 1, ItemsConfig:GetCollectibles().Size - 1 do --stole this bit from Baltro Jokers's Baron evaluation with some tweaks
                    local item = ItemsConfig:GetCollectible(Item)
                    if item
                    and item.Type ~= ItemType.ITEM_ACTIVE
                    and item.Quality == 4
                    and not item:HasTags(ItemConfig.TAG_QUEST)
                    and item.Hidden == false
                    and Player:HasCollectible(Item, true, true) then
                    
                        Mult = Mult * 1.2
                    end
                end

                if Mult ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Mult / mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    "X"..tostring(Difference),mod.Jokers.BARON)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Mult

                mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

            elseif Joker == mod.Jokers.OBELISK then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)    
            
            elseif Joker == mod.Jokers.PHOTOGRAPH then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)

            elseif Joker == mod.Jokers.LUCKY_CAT then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)    

            elseif Joker == mod.Jokers.BASEBALL then

                local Mult = 1

                for _,Slot2 in ipairs(mod.Saved.Jimbo.Inventory) do
                    if Slot2.Joker ~= 0 and mod:GetJokerRarity(Slot2.Joker) == "uncommon" then
                        Mult = Mult * 1.25
                    end
                end

            ---@diagnostic disable-next-line: undefined-field
                for Item = 1, ItemsConfig:GetCollectibles().Size - 1 do --stole this bit from Baltro Jokers's Baron evaluation with some tweaks
                    local item = ItemsConfig:GetCollectible(Item)
                    if item
                    and item.Type ~= ItemType.ITEM_ACTIVE
                    and item.Quality == 2
                    and not item:HasTags(ItemConfig.TAG_QUEST)
                    and item.Hidden == false
                    and Player:HasCollectible(Item, true, true) then
                    
                        Mult = Mult * 1.1
                    end
                end

                if Mult ~= mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] then
                    local Difference = Mult / mod.Saved.Jimbo.Progress.Inventory[ProgressIndex]
                    
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    "X"..tostring(Difference),mod.Jokers.BASEBALL)
                end

                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = Mult

                mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

            elseif Joker == mod.Jokers.CAMPFIRE then

                mod:IncreaseJimboStats(Player,0,0,mod.Saved.Jimbo.Progress.Inventory[ProgressIndex],false,false)    

            elseif Joker == mod.Jokers.ANCIENT_JOKER then

                mod:IncreaseJimboStats(Player,0,0,1.05^mod.Saved.Jimbo.Progress.Room.SuitUsed,false,false)
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
            mod:IncreaseJimboStats(Player,0, 0, 1.2^Triggers, false,false)
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


---@param Entity EntityNPC
function mod:NPCInit(Entity)

    if not Entity:IsActiveEnemy() then
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

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.PAREIDOLIA then

                if not Entity:IsBoss() and EntityConfig.GetEntity(Entity.Type, Entity.Variant, Entity.SubType):CanBeChampion()
                   and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.PAREIDOLIA), 0.2) then

                    Entity:MakeChampion(Entity.InitSeed)
                end

            elseif Joker == mod.Jokers.FOUR_FINGER then

                if not Entity:IsBoss() then

                    if mod.Saved.Jimbo.Progress.Inventory[Index] == 5 then
              
                        Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
            
                        Entity:Kill()
            
                        mod.Saved.Jimbo.Progress.Inventory[Index] = 0
                    end

                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1
                end

            elseif Joker == mod.Jokers.MIDAS then

                if Entity:IsChampion() then
                    
                    Entity:AddMidasFreeze(EntityRef(Player), 210)

                end
            end
        end

        ::skip_player::
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.NPCInit)


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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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


---@param Player EntityPlayer
function mod:PillUse(Effect,Color, Player,Flags)

    if Player:GetPlayerType() ~= mod.Characters.JimboType 
       or Flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY
       or Flags & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then
        return
    end

    for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.SQUARE_JOKER then

            if Effect == PillEffect.PILLEFFECT_RETRO_VISION then

                if Color & PillColor.PILL_COLOR_MASK == PillColor.PILL_COLOR_MASK then --hprse pill
                    
                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 1.6
                
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+1.6"
                    ,mod.Jokers.SQUARE_JOKER)

                else --base pill

                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.4
                
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+0.4"
                    ,mod.Jokers.SQUARE_JOKER)

                end

                mod.Counters.Activated[Index] = 0
                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            end
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_PILL, mod.PillUse)


function mod:RoughGemBackstab(Tear, Split)

    local Player = Tear.Parent:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local TearData = Tear:GetData()
    
    if TearData.Params and mod:IsSuit(Player, TearData.Params, mod.Suits.Diamond, false)
       and mod:JimboHasTrinket(Player, mod.Jokers.ROUGH_GEM) then
        
        Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.RoughGemBackstab)



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

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.SCARY_FACE then
                if NPC:IsChampion() then
                    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                end

            elseif Joker == mod.Jokers.BUSINESS_CARD then
                if NPC:IsChampion() then
                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, NPC.Position,
                    RandomVector()*2, Player, CoinSubType.COIN_PENNY, 1)

                end

            elseif Joker == mod.Jokers.FACELESS then

                if not NPC:IsChampion() then

                    local Champions = {}
                    local EnableKill = true

                    for _, Entity in ipairs(Isaac.GetRoomEntities()) do
                        if Entity:IsEnemy() and Entity:IsActiveEnemy() and Entity:IsVulnerableEnemy() then
                            if Entity:ToNPC():IsChampion() then
                                table.insert(Champions, GetPtrHash(Entity))
                            else
                                EnableKill = false
                                break
                            end
                        end
                    end

                    if EnableKill then
                        for _, Enemy in ipairs(Isaac.GetRoomEntities()) do

                            if mod:Contained(Champions,GetPtrHash(Enemy)) then
                                Enemy:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                                Enemy:Kill()

                                local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Enemy.Position,
                                                        RandomVector()*4, Player, CoinSubType.COIN_PENNY, 1):ToPickup()

                                Coin.Timeout = 120
                            end
                        end
                    end

                end

            elseif Joker == mod.Jokers.SEANCE then
                
                if not EntityConfig.GetEntity(NPC.Type,NPC.Variant, NPC.SubType):HasEntityTags(EntityTag.GHOST) 
                   and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.SEANCE), 0.16) then
                    Seed = Random()
                    if Seed == 0 then Seed = 1 end

                    local Ghost = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, NPC.Position,
                                             NPC.Velocity / 2, Player, 1, Seed):ToEffect()

                ---@diagnostic disable-next-line: need-check-nil
                    Ghost:SetTimeout(150)
                end

            elseif Joker == mod.Jokers.PHOTOGRAPH then
                
                if NPC:IsChampion() and mod.Saved.Jimbo.Progress.Room.ChampKills == 1 then
                    
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    "X1.1",mod.Jokers.PHOTOGRAPH)

                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] * 1.1
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end

            elseif Joker == mod.Jokers.RESERVED_PARK then

                local ParkRNG = Player:GetTrinketRNG(mod.Jokers.RESERVED_PARK)
                local KilledHash = GetPtrHash(NPC)

                for _, Entity in ipairs(Isaac.GetRoomEntities()) do
                    if Entity:IsEnemy() and Entity:ToNPC():IsChampion() then
                        
                        if KilledHash ~= GetPtrHash(Entity) and mod:TryGamble(Player, ParkRNG, 0.5) then
                            local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Entity.Position,
                                                    RandomVector()*4, Player, CoinSubType.COIN_PENNY, 1):ToPickup()

                            Coin.Timeout = 120

                        end
                            
                        
                    end
                end
            end
        end

        Player:EvaluateItems()

        ::skip_player::
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.EnemyKill)



---@param Door GridEntityDoor
function mod:DoorInit(Door)
    if not Door:IsRoomType(RoomType.ROOM_SECRET) and not Door:IsRoomType(RoomType.ROOM_SUPERSECRET)
       or Door:IsOpen() then
        return
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            if Slot.Joker == mod.Jokers.SHORTCUT then
                if Door:IsRoomType(RoomType.ROOM_SECRET) or Door:IsRoomType(RoomType.ROOM_SUPERSECRET) then
                    Door:TryBlowOpen(false, Player)
                end
                break
            end
        end

        ::skip_player::
    end
    
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, mod.DoorInit)



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

---@param Player EntityPlayer
function mod:JimboSpeedStat(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local NumRunner = #mod:GetJimboJokerIndex(Player, mod.Jokers.RUNNER)

    Player.MoveSpeed = Player.MoveSpeed + 0.1 * NumRunner

    if NumRunner > 0 then
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end

end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, mod.JimboSpeedStat, CacheFlag.CACHE_SPEED)


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

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

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


function mod:PickupGhostUpdate(Pickup)

    --only affects any type of chest + grab bags
    if not ((Pickup.Variant == PickupVariant.PICKUP_CHEST or Pickup.Variant == PickupVariant.PICKUP_WOODENCHEST
       or Pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST or Pickup.Variant == PickupVariant.PICKUP_BOMBCHEST
       or Pickup.Variant == PickupVariant.PICKUP_OLDCHEST or Pickup.Variant == PickupVariant.PICKUP_HAUNTEDCHEST
       or Pickup.Variant == PickupVariant.PICKUP_MEGACHEST or Pickup.Variant == PickupVariant.PICKUP_ETERNALCHEST
       or Pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST or Pickup.Variant == PickupVariant.PICKUP_MIMICCHEST
       or Pickup.Variant == PickupVariant.PICKUP_REDCHEST) and Pickup.SubType == ChestSubType.CHEST_CLOSED)
       and Pickup.Variant ~= PickupVariant.PICKUP_GRAB_BAG then

        return
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() == mod.Characters.JimboType 
           and mod:JimboHasTrinket(Player, mod.Jokers.CARD_SHARP) then
            return true
        end
    
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE_GHOST_PICKUPS, mod.PickupGhostUpdate)


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

            Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.CONSTELLATION then
            
            if not Copied then
                mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] + 0.04

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT, "+0.04X",mod.Jokers.CONSTELLATION)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.PlanetCardUse)

function mod:RemoveReflection(Player)

    return not (Game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
                and mod:JimboHasTrinket(Player, mod.Jokers.VAMPIRE))

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, mod.RemoveReflection)


local StoneEval = true
function mod:RockDestroy(Rock, RockType, Immediate)

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.EROSION then

                if RockType == GridEntityType.GRID_ROCKT then
                    
                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.1

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    "+0.1",mod.Jokers.EROSION)
    
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

                elseif RockType == GridEntityType.GRID_ROCK_SS then

                    mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.25

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    "+0.25",mod.Jokers.EROSION)
    
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

                end

            elseif Joker == mod.Jokers.STONE_JOKER then

                if StoneEval and RockType == GridEntityType.GRID_ROCK then
                    StoneEval = false
                    Isaac.CreateTimer(function ()
                        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                        StoneEval = true
                    end,1,1,true)
                end
                
            end
        end

        Player:EvaluateItems()

        ::skip_player::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.RockDestroy)


---@param Slot EntitySlot
function mod:SlotPayoutCheck(Slot)

    local Sprite = Slot:GetSprite()

    --[[
    if Sprite:IsEventTriggered("Prize") then
        print(Sprite:IsEventTriggered("Prize"))
        sfx:Play(SoundEffect.SOUND_MEGA_BLAST_START)
    end]]

    if Sprite:IsPlaying("WiggleEnd") and Sprite:GetFrame() == 6 then

        Isaac.CreateTimer(function ()
            local Prize = Slot:GetPrizeType()
            if Prize > 0 and Prize < 13 then
                mod:SlotPayoutEffect(Slot)
            end

        end,2,1,true)
        return
    end

end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.SlotPayoutCheck, SlotVariant.SLOT_MACHINE)


function mod:SlotPayoutEffect(SlotMachine)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
    
        for Index, Slot in ipairs(mod.Saved.Jimbo.Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Jimbo.Inventory[mod.Saved.Jimbo.Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Jimbo.Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Jimbo.Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.LUCKY_CAT then

                if not Copied then
                    mod.Saved.Jimbo.Progress.Inventory[ProgressIndex] = mod.Saved.Jimbo.Progress.Inventory[Index] + 0.02

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.02X", mod.Jokers.LUCKY_CAT)
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end
            end
        end

        Player:EvaluateItems()

        ::skip_player::
    end
end


---@param Effect EntityEffect
function mod:IceCreamCreepFreeze(Effect)

    local Data = Effect:GetData()

    if not Data.IsIcecreamB then
        return
    end

    
    local EffectCapsule = Effect:GetCollisionCapsule()

    for i,Entity in ipairs(Isaac.FindInCapsule(EffectCapsule)) do

        if Entity:ToNPC() then

            Entity:AddIce(EntityRef(Game:GetPlayer(0)),10)
        end

    end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.IceCreamCreepFreeze, EffectVariant.PLAYER_CREEP_WHITE)

local PastActiveCostumes = 0
---@param Player EntityPlayer
function mod:OnCostumeModify(_, Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local NumActiveCostumes = 0
    local CheckedItems = {}
    for _,CostumeDesc in ipairs(Player:GetCostumeSpriteDescs()) do
    
        local ItemCongig = CostumeDesc:GetItemConfig()
    
        if not mod:Contained(CheckedItems, ItemCongig.ID) then --sometimes items are put multiple times in the for loop
        
            CheckedItems[#CheckedItems+1] = ItemCongig.ID
        
            for i,LayerState in ipairs(CostumeDesc:GetSprite():GetAllLayers()) do --gets every layer in the costume's sprite
            
                --print("Checking "..LayerState:GetName().." of "..ItemCongig.Name)
            
                if string.match(LayerState:GetName(), "body") then --if the item has a body costume
                
                    if Player:IsItemCostumeVisible(ItemCongig, LayerState:GetName()) then
                        NumActiveCostumes = NumActiveCostumes + 1
                        break
                    end
                end
            end
        end
    end

    if NumActiveCostumes == PastActiveCostumes then
        return
    end

    for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SPARE_TROUSERS, true)) do
    
        local Difference = (NumActiveCostumes - PastActiveCostumes)*0.2

        mod.Saved.Jimbo.Progress.Inventory[Index] = mod.Saved.Jimbo.Progress.Inventory[Index]
    
        mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    tostring(Difference),mod.Jokers.SPARE_TROUSERS)

        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end

    PastActiveCostumes = NumActiveCostumes

    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_COSTUME, mod.OnCostumeModify)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_COSTUME, mod.OnCostumeModify)














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