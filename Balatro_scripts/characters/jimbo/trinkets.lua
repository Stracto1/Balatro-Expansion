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
local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..
local BaronKings = 0

--local INVENTORY_RENDERING_POSITION = Vector(20,220) 


--effects when a card is shot
---@param Player EntityPlayer
function mod:OnCardShot(Player,ShotCard,Evaluate)

local PIndex = Player:GetData().TruePlayerIndex

local RandomSeed = Random()
if RandomSeed == 0 then RandomSeed = 1 end --crash fix
---
--RETRIGGER CALCULATION + SEALS + VAMPIRE EFFECT----
-----------------------------------

local Triggers = 1 --how many times the card needs to be activated again

for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

    local Joker = Slot.Joker

    local ProgressIndex = Index
    local Copied = false
    if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

        Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

        ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

        Copied = true
    end

    if Joker == mod.Jokers.HACK then
        if ShotCard.Value <= 5 and ShotCard.Value ~= 1 then
            Triggers = Triggers + 1

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)

            
        end

    elseif Joker == mod.Jokers.DUSK then

        local CardsRemaining = Player:GetCustomCacheValue("hands") - mod.Saved.Player[PIndex].Progress.Room.Shots

        if CardsRemaining <= 10 and CardsRemaining >= 0 then
            Triggers = Triggers + 1

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.SELTZER then

        Triggers = Triggers + 1

    elseif Joker == mod.Jokers.SOCK_BUSKIN then

        if mod:IsValue(Player, ShotCard, mod.Values.FACE) then
            Triggers = Triggers + 1

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)

        end

    elseif Joker == mod.Jokers.HANG_CHAD then

        if mod.Saved.Player[PIndex].Progress.Room.Shots == 0 then
            Triggers = Triggers + 3

            for i=1, 3 do
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)
            end
        end
    
    elseif Joker == mod.Jokers.VAMPIRE then

        if not Copied and ShotCard.Enhancement ~= mod.Enhancement.NONE then

            mod.Saved.Player[PIndex].FullDeck[ShotCard.Index].Enhancement = mod.Enhancement.NONE
            ShotCard.Enhancement = mod.Enhancement.NONE

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.02

            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.02X",mod.EffectType.JOKER, Player)

            

            Isaac.RunCallback("DECK_MODIFY", Player)
        end

    elseif Joker == mod.Jokers.MIDAS then

        if not Copied and mod:IsValue(Player, ShotCard, mod.Values.FACE) then
            mod.Saved.Player[PIndex].FullDeck[ShotCard.Index].Enhancement = mod.Enhancement.GOLDEN
            ShotCard.Enhancement = mod.Enhancement.GOLDEN
    
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Golden!",mod.EffectType.JOKER, Player)

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
        mod.Saved.Player[PIndex].Progress.Room.SuitUsed[GoodSuit] = mod.Saved.Player[PIndex].Progress.Room.SuitUsed[GoodSuit] + Triggers
    end
 end
mod.Saved.Player[PIndex].Progress.Room.ValueUsed[ShotCard.Value] = mod.Saved.Player[PIndex].Progress.Room.ValueUsed[ShotCard.Value] + Triggers

if mod:IsValue(Player, ShotCard, mod.Values.FACE) then
    mod.Saved.Player[PIndex].Progress.Room.ValueUsed[mod.Values.FACE] = mod.Saved.Player[PIndex].Progress.Room.ValueUsed[mod.Values.FACE] + Triggers
end

mod.Saved.Player[PIndex].Progress.Blind.Shots = mod.Saved.Player[PIndex].Progress.Blind.Shots + 1

--------------------------------------------------
-----------JOKERS EVALUATION---------------------
------------------------------------------------
for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

    local Joker = Slot.Joker

    local ProgressIndex = Index
    local Copied = false
    if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

        Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

        ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

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

                    
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.EffectType.JOKER, Player)
                end
            end
        end

    elseif Joker == mod.Jokers.BLOODSTONE then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Heart, false) then

            local Mult = 1

            for i = 1, Triggers do
                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BLOODSTONE), 0.5) then

                    Mult = Mult * 1.05
                end
            end

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult), mod.EffectType.JOKER, Player)
        end
    elseif Joker == mod.Jokers.ARROWHEAD then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Spade, false) then

            local Chips = 0.5 * Triggers

            mod:IncreaseJimboStats(Player, Chips, 0, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips), mod.EffectType.JOKER, Player)
        end
    elseif Joker == mod.Jokers.ONIX_AGATE then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Club, false) then

            local Mult = 0.07 * Triggers

            mod:IncreaseJimboStats(Player, 0, Mult, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult), mod.EffectType.JOKER, Player)
        
        end

    elseif Joker == mod.Jokers.LUSTY_JOKER then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Heart, false) then

            local Mult = 0.03 * Triggers

            mod:IncreaseJimboStats(Player, 0, Mult, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult), mod.EffectType.JOKER, Player)
        
        end
    elseif Joker == mod.Jokers.GREEDY_JOKER then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Diamond, false) then

            local Mult = 0.03 * Triggers

            mod:IncreaseJimboStats(Player, 0, Mult, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult), mod.EffectType.JOKER, Player)
        
        end

    elseif Joker == mod.Jokers.WRATHFUL_JOKER then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Spade, false) then

            local Mult = 0.03 * Triggers

            mod:IncreaseJimboStats(Player, 0, Mult, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult), mod.EffectType.JOKER, Player)
        
        end

    elseif Joker == mod.Jokers.GLUTTONOUS_JOKER then
        if mod:IsSuit(Player, ShotCard, mod.Suits.Club, false) then

            local Mult = 0.03 * Triggers

            mod:IncreaseJimboStats(Player, 0, Mult, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult), mod.EffectType.JOKER, Player)
        
        end

    elseif Joker == mod.Jokers.SUPERNOVA then

        local TimesScoredBefore = mod.Saved.Player[PIndex].Progress.Room.ValueUsed[ShotCard.Value] - Triggers
        local TimesScoredAfter = mod.Saved.Player[PIndex].Progress.Room.ValueUsed[ShotCard.Value]

        --adds how many times the card value got used in the same room
        local TotalAdd = 0
        for i = TimesScoredBefore, TimesScoredAfter - 1 do
            TotalAdd = TotalAdd + i
        end

        TotalAdd = TotalAdd * 0.01
        
        mod:IncreaseJimboStats(Player, 0, TotalAdd, 1, false, true)        
        
        mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ADDMULT,
                                "+"..tostring(TotalAdd),mod.EffectType.JOKER, Player)
    
    elseif Joker == mod.Jokers._8_BALL then
        if mod:IsValue(Player, ShotCard, 8) then

            local BallRNG = Player:GetTrinketRNG(mod.Jokers._8_BALL)
            for i = 1, Triggers do
            
                if mod:TryGamble(Player, BallRNG, 0.25) then

                    local Rtarot = mod:RandomTarot(BallRNG, false, false)

                    local Tarot = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                                            RandomVector()*3, Player, Rtarot, RandomSeed)

                    
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!",mod.EffectType.JOKER, Player)
                end
            end
        end
    elseif Joker == mod.Jokers.BUSINESS_CARD then
        if mod:IsValue(Player, ShotCard, mod.Values.FACE) then --only face cards
            
            for i = 1, Triggers do

                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BUSINESS_CARD), 0.25) then
            
                    for i=1, 2 do --spawns 2 coins 25% of the time
                        local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                                RandomVector()*4 * Player.MoveSpeed, Player, CoinSubType.COIN_PENNY, RandomSeed)
                        Coin:ToPickup().Timeout = 50
                    end

                    
                    mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.EffectType.JOKER, Player)
                end
            end
        end
    elseif Joker == mod.Jokers.RIDE_BUS then

        if mod:IsValue(Player, ShotCard, mod.Values.FACE) then --only face cards

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!",mod.EffectType.JOKER, Player)

        else
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 0.01*Triggers

            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(0.01*Triggers),mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.SPACE_JOKER then

        if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.SPACE_JOKER), 0.05 + 0.05 * mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]) then

            mod.Saved.CardLevels[ShotCard.Value] = mod.Saved.CardLevels[ShotCard.Value] + 1

            local ValueString = mod:CardValueToName(ShotCard.Value, false, true)

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, ValueString.."Up!",mod.EffectType.JOKER, Player)
        end
    
    elseif Joker == mod.Jokers.HIKER then

        mod.Saved.Player[PIndex].FullDeck[ShotCard.Index].Upgrades = mod.Saved.Player[PIndex].FullDeck[ShotCard.Index].Upgrades + Triggers

        mod:CreateBalatroEffect(Index,mod.EffectColors.BLUE, mod.Sounds.CHIPS, "Upgrade!",mod.EffectType.JOKER, Player)

    elseif Joker == mod.Jokers.TO_DO_LIST then

        if mod:IsValue(Player, ShotCard, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]) then

            local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,                                  
            RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                                    Coin:ToPickup().Timeout = 50

            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Done!",mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.CARD_SHARP then

        local CardToCopy = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].LastShotIndex]

        if not Copied
           and mod.Saved.Player[PIndex].LastShotIndex ~= 0
           and (mod:IsValue(Player, ShotCard, CardToCopy.Value)
                and mod:IsValue(Player, CardToCopy, ShotCard.Value) --same value as last card
                    or (ShotCard.Enhancement == mod.Enhancement.STONE --or both stone cards
                       and CardToCopy.Enhancement == mod.Enhancement.STONE)) then

            local Mult = 1.1
            
            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)
            
            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.1", mod.EffectType.JOKER, Player) 
            
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] * 1.1
        end
    
    elseif Joker == mod.Jokers.SQUARE_JOKER then

        if mod.Saved.Player[PIndex].Progress.Room.Shots % 4 == 3 then --+4 every 4th card that needs to be shot
            
            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
            "+4",mod.EffectType.JOKER, Player)

        elseif mod.Saved.Player[PIndex].Progress.Room.Shots % 4 == 0 then
            
            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
            "-4",mod.EffectType.JOKER, Player)
        end
    elseif Joker == mod.Jokers.OBELISK then

        if not Copied and mod.Saved.Player[PIndex].LastShotIndex ~= 0
           and ShotCard.Enhancement ~= mod.Enhancement.STONE then

            local LastCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].LastShotIndex]

            if not mod:IsSuit(Player, ShotCard, LastCard.Suit) --different suit from last card
               or ShotCard.Enhancement == mod.Enhancement.WILD --wild always triggers
               or LastCard.Enhancement == mod.Enhancement.WILD then
            
                
                mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+"..tostring(0.05*Triggers).."X",mod.EffectType.JOKER, Player)
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 0.05*Triggers
            
            elseif mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] ~= 1 then
                
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset",mod.EffectType.JOKER, Player)
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1
            end
        end

    elseif Joker == mod.Jokers.PHOTOGRAPH then

        if mod.Saved.Player[PIndex].Progress.Room.ValueUsed[mod.Values.FACE] == Triggers then --if it's the first one played
            
            local Mult = 1.2^Triggers

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)        
           
            mod:CreateBalatroEffect(Index,mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.ANCIENT_JOKER then
        if mod:IsSuit(Player, ShotCard, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]&SUIT_FLAG, false) then

            Mult = 1.05^Triggers

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
        
        end

    elseif Joker == mod.Jokers.GOLDEN_TICKET then
        if ShotCard.Enhancement == mod.Enhancement.GOLDEN then
            for i = 1, Triggers do
                local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                        RandomVector()*3*Player.MoveSpeed, Player, CoinSubType.COIN_PENNY, RandomSeed)
                
                Coin:ToPickup().Timeout = 50

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.EffectType.JOKER, Player)
            end
        end

    elseif Joker == mod.Jokers.WEE_JOKER then

        if mod:IsValue(Player, ShotCard, 2) then

            local ScaleMult = math.min(2/Player.SpriteScale:LengthSquared(),1)
            local TearGain = 0.04 * Triggers * ScaleMult

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + TearGain

            mod:CreateBalatroEffect(Index,mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(TearGain),mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.IDOL then -- 3 values need to be stored, so the first 3 bits are for the suit then 4 for the value and the other say how many were played

        if mod:IsSuit(Player, ShotCard, SUIT_FLAG & mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex])
           and mod:IsValue(Player, ShotCard, VALUE_FLAG & mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]) then
            
            local Mult = 1.1^Triggers

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
        
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        end

    elseif Joker == mod.Jokers.SCARY_FACE then 
        if mod:IsValue(Player, ShotCard, mod.Values.FACE) then
            
            local Chips = 0.3*Triggers

            mod:IncreaseJimboStats(Player, Chips, 0, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips),mod.EffectType.JOKER, Player)
        
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        end

    elseif Joker == mod.Jokers.SMILEY_FACE then 
        if mod:IsValue(Player, ShotCard, mod.Values.FACE) then
            
            local Damage = 0.05*Triggers

            mod:IncreaseJimboStats(Player, Damage, 0, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Damage),mod.EffectType.JOKER, Player)
        
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        end

    elseif Joker == mod.Jokers.ODDTODD then

        if ShotCard.Enhancement ~= mod.Enhancement.STONE
           and ShotCard.Value % 2 == 1
           and ShotCard.Value < mod.Values.JACK then

            local Tears = 0.31 * Triggers

            mod:IncreaseJimboStats(Player, Tears, 0, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Tears), mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.EVENSTEVEN then

        if ShotCard.Enhancement ~= mod.Enhancement.STONE
           and ShotCard.Value % 2 == 0
           and ShotCard.Value < mod.Values.JACK then

            local Damage = 0.04 * Triggers

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Damage), mod.EffectType.JOKER, Player)
        end

    elseif Joker == mod.Jokers.SCHOLAR then

        if mod:IsValue(Player, ShotCard, 1) then

            local Tears = 0.2 * Triggers
            local Damage = 0.04 * Triggers

            mod:IncreaseJimboStats(Player, Tears, Damage, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Tears), mod.EffectType.JOKER, Player)
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Damage), mod.EffectType.JOKER, Player)

        end

    elseif Joker == mod.Jokers.WALKIE_TALKIE then

        if mod:IsValue(Player, ShotCard, 4) or mod:IsValue(Player, ShotCard, 10) then

            local Tears = 0.1 * Triggers
            local Damage = 0.04 * Triggers

            mod:IncreaseJimboStats(Player, Tears, Damage, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Tears), mod.EffectType.JOKER, Player)
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Damage), mod.EffectType.JOKER, Player)

        end

    elseif Joker == mod.Jokers.FIBONACCI then

        if ShotCard.Enhancement ~= mod.Enhancement.STONE
           and (ShotCard.Value == 1 
                or ShotCard.Value == 2 
                or ShotCard.Value == 3 
                or ShotCard.Value == 5 
                or ShotCard.Value == 8) then
            

            local Damage = 0.08 * Triggers

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Damage), mod.EffectType.JOKER, Player)
        end
    elseif Joker == mod.Jokers.TRIBOULET then
        if mod:IsValue(Player, ShotCard, mod.Values.QUEEN) or mod:IsValue(Player, ShotCard, mod.Values.KING) then

            local Mult = 1.1 ^ Triggers

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult), mod.EffectType.JOKER, Player)
        end
    end
end
---------------BASE CARD STATS--------------
-------------------------------------------
    --------EDITIONS EFFECTS----------
    ----------------------------------
    if ShotCard.Edition == mod.Edition.FOIL then
        mod:IncreaseJimboStats(Player,1.25*Triggers, 0, 1,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.EDITIONEFFECT, "+1.25",mod.EffectType.ENTITY, Player)

    elseif ShotCard.Edition == mod.Edition.HOLOGRAPHIC then
        mod:IncreaseJimboStats(Player,0, 0.25 * Triggers, 1,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.EDITIONEFFECT, "+0.25",mod.EffectType.ENTITY, Player)

    elseif ShotCard.Edition == mod.Edition.POLYCROME then
        mod:IncreaseJimboStats(Player,0, 0, 1.2 ^ Triggers,false,true)
        mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.EDITIONEFFECT, "X1.2",mod.EffectType.ENTITY, Player)
    end

    --increases the chips basing on the card value
    local TearsToGet = (mod:GetValueScoring(ShotCard.Value)/50 
                        + mod.Saved.CardLevels[ShotCard.Value]*0.02
                        + ShotCard.Upgrades*0.02) * Triggers
    
    
    mod:IncreaseJimboStats(Player,0, 0.02 * mod.Saved.CardLevels[ShotCard.Value] * Triggers, 1,false,true) --extra damage given by planet upgrades
    
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
        mod:IncreaseJimboStats(Player,0, 0, 1.2 ^ Triggers, false,true)

        if mod:TryGamble(Player, PlayerRNG, 0.1) then

            mod:DestroyCards(Player, ShotCard.Index, true)

            --PLACEHOLDER sound
            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "BROKEN!", mod.EffectType.ENTITY, Player)
        
            for _,CardTear in ipairs(Isaac.FindInRadius(Player.Position, 1, EntityPartition.TEAR)) do
                
                local Params = CardTear:GetData().Params

                if Params.Enhancement == mod.Enhancement.GLASS
                   and Params.Index == ShotCard.Index then
                    
                    CardTear:Remove()
                    break
                end
            end
        end

    elseif ShotCard.Enhancement == mod.Enhancement.LUCKY then
        for i = 1, Triggers do
            if mod:TryGamble(Player, PlayerRNG, 0.2) then
                mod:IncreaseJimboStats(Player, 0, 1, 1, false,true)
                mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.2", mod.EffectType.ENTITY, Player)

                for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.02

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.02X", mod.EffectType.JOKER, Player)
                end

            end
            if mod:TryGamble(Player, PlayerRNG, 0.05) then
                Player:AddCoins(10)
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+10 $", mod.EffectType.ENTITY, Player)

                for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.02

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.02X", mod.EffectType.JOKER, Player)
                end

            end
        end
    end

    mod:IncreaseJimboStats(Player, TearsToGet, 0, 1, Evaluate, true)

end
mod:AddCallback("CARD_SHOT", mod.OnCardShot)


function mod:OnCardHit(Tear, Collider)

    local TearData = Tear:GetData()
    local card = TearData.Params
    local Player = Tear.Parent:ToPlayer() or Tear.Parent
    local PIndex = Player:GetData().TruePlayerIndex


    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == mod.Jokers.DNA then

            if TearData.Num == 1 then --if it's the first fired card in a blind
                TearData.Num = 2 --prevents double activation
                
                mod:AddCardToDeck(Player, mod.Saved.Player[PIndex].FullDeck[TearData.Params.Index], 1, true)
                
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Copied!",mod.EffectType.JOKER, Player)
            
            end --ADDED TO DECK

        elseif Joker == mod.Jokers.SIXTH_SENSE then

            if TearData.Num == 1 and mod:IsValue(Player, card, 6) then --if it's the first fired card in a blind
                TearData.Num = 2 --prevents double activation
                
                mod:DestroyCards(Player, {TearData.Params.Index}, false)
                mod:CardRipEffect(TearData, Tear.Position)

                Tear:Remove()

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Destroyed!",mod.EffectType.JOKER, Player)
            
                local Seed = Random()
                Seed = Seed == 0 and 1 or Seed

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, mod.Packs.SPECTRAL, Seed)
            end

        elseif Joker == mod.Jokers.BURNT_JOKER then

            if TearData.WasDiscarded
               and not next(TearData.CollidedWith) then

                mod.Saved.CardLevels[TearData.Params.Value] = mod.Saved.CardLevels[TearData.Params.Value] + 1
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, mod:CardValueToName(TearData.Params.Value).." Up!",mod.EffectType.JOKER, Player)
            end
        end

    end
end
mod:AddCallback("CARD_HIT", mod.OnCardHit)



function mod:OnHandDiscard(Player, AmountDiscarded)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    local DiscardedPointers = {}

    for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do
            
        if mod.SelectionParams[PIndex].SelectedCards[i] then
            DiscardedPointers[#DiscardedPointers+1] = mod.Saved.Player[PIndex].CurrentHand[i]
        end
    end

    

    --cycles between all the held jokers
    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then
        elseif Joker == mod.Jokers.RAMEN and not Copied then

            local LostMult = 0.01 * AmountDiscarded
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - LostMult
        
            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Eaten!",mod.EffectType.JOKER, Player)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, tostring(-LostMult).."X",mod.EffectType.JOKER, Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        
        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            local InitialProg = mod.Saved.Player[PIndex].Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 0.16
                if mod.Saved.Player[PIndex].Progress.Inventory[Index] < 0 then
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0
                end
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.16",mod.EffectType.JOKER, Player)
        
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            local NumCompatible = 0

            for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                local DiscardedCard = mod.Saved.Player[PIndex].FullDeck[Pointer]

                if mod:IsValue(Player, DiscardedCard, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]) then
                    NumCompatible = NumCompatible + 1
                end
            end

            if NumCompatible > 0 then

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.MOMEY, "+"..tostring(2*NumCompatible).."$",mod.EffectType.JOKER, Player)


                for i=1,2*NumCompatible do
                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                               RandomVector()*2.5, Player, CoinSubType.COIN_PENNY, 1)
                end
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod:IsSuit(Player,mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & SUIT_FLAG) then
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 8

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+0.04",mod.EffectType.JOKER, Player)
                
                    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                end
            end

        elseif Joker == mod.Jokers.DRUNKARD then

            Game:SetDizzyAmount(math.max(Game:GetDizzyAmount()-0.05, 0))


        elseif Joker == mod.Jokers.HIT_ROAD then

            local NumJacks = 0

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Values.JACK) then
                    
                    NumJacks = NumJacks + 1
                end
            end

            if NumJacks ~= 0 then

                local Increase = 0.25 * NumJacks

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + Increase

                local Mult = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)


                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end



        elseif Joker == mod.Jokers.FACELESS then

            local NumFaces = 0

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Values.FACE) then
                    
                    NumFaces = NumFaces + 1
                end
            end

            if NumFaces >= 2 then
                Player:AddCoins(3)

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.MOMEY, "+3$",mod.EffectType.JOKER, Player)
            end


        elseif Joker == mod.Jokers.YORICK then

            local BeforeMult = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] // 23

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + AmountDiscarded

            local AfterMult = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] // 23

            if BeforeMult ~= AfterMult then
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(AfterMult),mod.EffectType.JOKER, Player)
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
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    --NOT COPIABLE JOKERS

    if Joker == mod.Jokers.INVISIBLE_JOKER then
        if mod.Saved.Player[PIndex].Progress.Inventory[SlotSold] ~= 3 then
            return
        end
        local ValidJokers = {}
        for i, trinket in ipairs(mod.Saved.Player[PIndex].Inventory) do
            --can only copy something other than itself and nothing
            if trinket.Joker ~= 0 and i ~= SlotSold then
                ValidJokers[#ValidJokers + 1] = i
            end
        end

        if not next(ValidJokers) then --no need if player is poor
            return
        end

        local RandomIndex = mod:GetRandom(ValidJokers, Player:GetTrinketRNG(mod.Jokers.INVISIBLE_JOKER))

        local JokerCopied = mod.Saved.Player[PIndex].Inventory[RandomIndex].Joker
        local EditionCopied = mod.Saved.Player[PIndex].Inventory[RandomIndex].Edition

        if EditionCopied == mod.Edition.NEGATIVE then --removes negative from copied joker
            EditionCopied = mod.Edition.BASE
        end

        mod:AddJoker(Player, JokerCopied, EditionCopied)

        mod.Saved.Player[PIndex].Progress.Inventory[SlotSold] = mod.Saved.Player[PIndex].Progress.Inventory[RandomIndex]

    elseif Joker == mod.Jokers.TRADING_CARD then
    
        local NumDestroyed = #mod.Saved.Player[PIndex].CurrentHand


        for i = 1, NumDestroyed*2 do

            local Seed = mod:RandomSeed(Player:GetTrinketRNG(Joker))

            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                       RandomVector()*2.5, Player, CoinSubType.COIN_PENNY, Seed)
        end

        mod:CreateBalatroEffect(SlotSold,mod.EffectColors.YELLOW, 
                                        mod.Sounds.MOMEY, "+"..tostring(2*NumDestroyed).."$",mod.EffectType.JOKER, Player)


        mod:DestroyCards(Player, mod.Saved.Player[PIndex].CurrentHand, true)

    end

    for _,Index in mod:GetJimboJokerIndex(Player, mod.Jokers.CAMPFIRE, true) do

        mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.2

        mod:CreateBalatroEffect(Index,mod.EffectColors.RED, 
                                        mod.Sounds.TIMESMULT, "+0.2X",mod.EffectType.JOKER, Player)
    end
    
    --BP/BS CHACK
    if Joker == mod.Jokers.BLUEPRINT then
        Joker = mod.Saved.Player[PIndex].Inventory[SlotSold + 1] and mod.Saved.Player[PIndex].Inventory[SlotSold + 1].Joker or 0

    elseif Joker == mod.Jokers.BRAINSTORM then
        Joker = mod.Saved.Player[PIndex].Inventory[1].Joker
    end
    
    
    if Joker == mod.Jokers.LUCHADOR then

        for _,Entity in ipairs(Isaac.GetRoomEntities()) do
            if Entity:IsBoss() then
                Entity:ToNPC():AddWeakness(EntityRef(Player), 900)
            end
        end

        Game:GetRoom():MamaMegaExplosion(Player.Position)

        mod:CreateBalatroEffect(SlotSold,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "You're Done!",mod.EffectType.JOKER, Player)

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

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() == mod.Characters.JimboType then
            local PIndex = Player:GetData().TruePlayerIndex

            for i,v in pairs(mod.Saved.Player[PIndex].Progress.Blind) do

                if type(v) == "table" then

                    for j,_ in ipairs(mod.Saved.Player[PIndex].Progress.Blind[i]) do
                        mod.Saved.Player[PIndex].Progress.Blind[i][j] = 0
                    end
                else
                    mod.Saved.Player[PIndex].Progress.Blind[i] = 0 --resets the blind progress
                end
            end
        end
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local MimeNum = 0

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    --cycles between all the held jokers
    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then --could save some time
        elseif Joker == mod.Jokers.INVISIBLE_JOKER then

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 1
            local Value = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            
            if Value < 3 then --still charging
            
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, tostring(Value).."/3",mod.EffectType.JOKER, Player)
            else --usable
            
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Active!",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.ROCKET then
            --spawns this many coins
            local MoneyAmount = mod.Saved.Player[PIndex].Progress.Inventory[Index]
            for i=1, MoneyAmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmount).."$",mod.EffectType.JOKER, Player)
            --on boss beaten it upgrades
            if BlindType == mod.BLINDS.BOSS then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 1
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "Upgrade!",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.GOLDEN_JOKER then

            --spawns this many coins
            local MoneyAmmount = 3
            for i=1, MoneyAmmount do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                           Player.Position, RandomVector()*3, Player,
                           CoinSubType.COIN_PENNY, RandomSeed)
            end
            
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, 
                                    mod.Sounds.ACTIVATE, "+"..tostring(MoneyAmmount).." $",mod.EffectType.JOKER, Player)

        elseif Joker == mod.Jokers.RIFF_RAFF then
            local RandomJoker = mod:RandomJoker(Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF), true, "common", false)
            
            mod:AddJoker(Player, RandomJoker.Joker, RandomJoker.Edition)

            
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.EffectType.JOKER, Player)

        elseif Joker == mod.Jokers.CARTOMANCER then
            local RandomTarot = Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF):RandomInt(1,22)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, Player, RandomTarot, RandomSeed)

            
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.EffectType.JOKER, Player)

        elseif Joker == mod.Jokers.EGG then

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 2

            
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.EffectType.JOKER, Player)

        elseif Joker == mod.Jokers.DELAYED_GRATIFICATION then

            if Player:HasFullHealth() then
                local NumCoins = Player:GetHearts()/2 --gives coins basing on how many extra heatrs are left

                for i = 1, NumCoins do
                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                               RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
                end

                
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(NumCoins).."$",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.CLOUD_NINE then
            
            for i=1, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, Player, CoinSubType.COIN_PENNY, RandomSeed)
            end

            
            mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]).."$",mod.EffectType.JOKER, Player)
        
        elseif Joker == mod.Jokers.POPCORN then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 0.2
                if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 0.1 then --at 0 it self destructs

                    mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                    mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Eaten", mod.EffectType.JOKER, Player)

                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                else

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.2",mod.EffectType.JOKER, Player)
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.MADNESS then

            if not Copied and BlindType ~= mod.BLINDS.BOSS then

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.1

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.1X",mod.EffectType.JOKER, Player)
            
                local Removable = {}
                for i, v in ipairs(mod.Saved.Player[PIndex].Inventory) do
                    if i ~= Index and v.Joker ~= 0 then --any joker other than this one
                        table.insert(Removable, i)
                    end
                end
                if next(Removable) then --if at leat one is present
                    local Rindex = mod:GetRandom(Removable, Player:GetTrinketRNG(mod.Jokers.MADNESS))
                    mod.Saved.Player[PIndex].Inventory[Rindex].Joker = 0
                    mod.Saved.Player[PIndex].Inventory[Rindex].Edition = 0

                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.GROS_MICHAEL then
            if not Copied and mod:TryGamble(Player,Player:GetTrinketRNG(mod.Jokers.GROS_MICHAEL), 0.16) then
                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0

                mod.Saved.MichelDestroyed = true

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!",mod.EffectType.JOKER, Player)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.CAVENDISH then
            if not Copied and mod:TryGamble(Player,Player:GetTrinketRNG(mod.Jokers.CAVENDISH), 0.00025) then --1/4000 chance
                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!",mod.EffectType.JOKER, Player)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        elseif Joker == mod.Jokers.SACRIFICIAL_DAGGER then
            
            if not Copied then
                local RightIndex = Index
                local RightJoker
                repeat
                    RightIndex = RightIndex + 1
                    RightJoker = mod.Saved.Player[PIndex].Inventory[RightIndex].Joker
                until not RightJoker or RightJoker ~= 0

                if RightJoker ~= 0 then
                    local RightSell = mod:GetJokerCost(RightJoker, mod.Saved.Player[PIndex].Inventory[RightIndex].Edition, RightIndex)

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.SLICE, 
                    "+"..tostring(0.08 * RightSell),mod.EffectType.JOKER, Player)

                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + RightSell * 0.08

                    mod.Saved.Player[PIndex].Inventory[RightIndex].Joker = 0
                    mod.Saved.Player[PIndex].Inventory[RightIndex].Edition = 0



                    Isaac.RunCallback("INVENTORY_CHANGE", Player)

                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end
            end

        elseif Joker == mod.Jokers.MIME then
            MimeNum = MimeNum + 1

        elseif Joker == mod.Jokers.MARBLE_JOKER then

            local MarbleRNG = Player:GetTrinketRNG(mod.Jokers.MARBLE_JOKER)

            local Seal
            local Edition
            local Enhancement = mod.Enhancement.STONE

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM) then
                Edition = -1
            end

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_SMALL_ROCK) then
                Seal = -1
            end

            local StoneCard = mod:RandomPlayingCard(MarbleRNG, true, nil, nil, Enhancement, Seal, Edition)

            mod:AddCardToDeck(Player, StoneCard,1, false)

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Stone!",mod.EffectType.JOKER, Player)
        
        elseif Joker == mod.Jokers.GIFT_CARD then
            
            for i,JokerSlot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if JokerSlot.Joker ~= 0 then
                    mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] or 0
                    
                    mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] + 1
                end
            end

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.EffectType.JOKER, Player)


            if mod:JimboHasTrinket(Player, mod.Jokers.SWASHBUCKLER) then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.TURTLE_BEAN then
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 1
            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 0 then --at 0 it self destructs
                
                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Eaten!",mod.EffectType.JOKER, Player)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-1",mod.EffectType.JOKER, Player)
            
                Player:AddCustomCacheTag("handsize")
            end

        elseif Joker == mod.Jokers.CERTIFICATE then

            local MarbleRNG = Player:GetTrinketRNG(mod.Jokers.CERTIFICATE)

            local Seal = -1
            local Edition
            local Enhancement

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) then

                Edition = -1
            end

            if Player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then

                Enhancement = -1
            end

            local SealCard = mod:RandomPlayingCard(MarbleRNG, true, nil, nil, Enhancement, Seal, Edition)

            mod:AddCardToDeck(Player, SealCard,1, false)

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Added!",mod.EffectType.JOKER, Player)
        
        

        elseif Joker == mod.Jokers.SATELLITE then
            
            local PlanetsUsed = mod.GetJokerInitialProgress(Joker, false)

            for i=1, PlanetsUsed do
                
                local Seed = mod:RandomSeed(Player:GetTrinketRNG(mod.Jokers.SATELLITE))

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, Player, CoinSubType.COIN_PENNY, Seed)
            end

            if PlanetsUsed ~= 0 then
                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(PlanetsUsed).."$",mod.EffectType.JOKER, Player)
            end

        end
    end --END JOKER FOR

    --BLUE SEAL EFFECT

    for i, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if card.Seal == mod.Seals.BLUE then

            local Planet = mod.Planets.PLUTO + card.Value - 1

            for i=0, MimeNum do

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, Planet, RandomSeed)
            end

            mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Planet!",mod.EffectType.ENTITY, Player)
        end
    end

    Player:EvaluateItems()

    --GOLD CARD EFFECT
    for _,index in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        if mod.Saved.Player[PIndex].FullDeck[index].Enhancement == mod.Enhancement.GOLDEN --PLACEHOLDER
           and mod.Saved.Player[PIndex].FirstDeck and mod.Saved.Player[PIndex].Progress.Room.Shots < Game:GetPlayer(0):GetCustomCacheValue("hands") then
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


--function mod:OnBlindStart(BlindType)
--end
--mod:AddCallback("BLIND_STARTED", mod.OnBlindStart) remained unused due to similarity with BLIND_CLEARED


---@param Player EntityPlayer
function mod:OnPackOpened(Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

            if Joker == mod.Jokers.HALLUCINATION then
                local TrinketRNG = Player:GetTrinketRNG(mod.Jokers.HALLUCINATION)
            if TrinketRNG:RandomFloat() < 0.5 then

                local RandomTarot = mod:RandomTarot(TrinketRNG, false, false)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, RandomTarot, RandomSeed)

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.EffectType.JOKER, Player)
            end
        end
    end

end
mod:AddCallback("PACK_OPENED", mod.OnPackOpened)

function mod:OnPackSkipped(Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        if Joker == 0 then
        elseif Joker == mod.Jokers.RED_CARD then
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.15

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.15",mod.EffectType.JOKER, Player)

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

    local PIndex = Player:GetData().TruePlayerIndex

    if CardUsed <= Card.CARD_WORLD then
        if Flag & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
            mod.Saved.TarotsUsed = mod.Saved.TarotsUsed + 2
        else
            mod.Saved.TarotsUsed = mod.Saved.TarotsUsed + 1
        end
    end

    mod.Saved.Player[PIndex].Progress.Floor.CardsUsed = mod.Saved.Player[PIndex].Progress.Floor.CardsUsed + 1

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        if Joker == mod.Jokers.FORTUNETELLER then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.HANG_CHAD then
            if mod.Saved.Player[PIndex].Progress.Floor.CardsUsed == 1 then
                local Seed = Random()
                Seed = Seed == 0 and 1 or Seed

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, CardUsed, Seed)

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)

            end
        end
    end
        
    Player:EvaluateItems()

end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_CARD,CallbackPriority.EARLY, mod.OnCardUsed)


function mod:OnRoomClear(IsBoss, Hostile)

    if not Game:IsGreedMode() or Hostile then
        for _, Player in ipairs(PlayerManager.GetPlayers()) do

            if Player:GetPlayerType() == mod.Characters.JimboType then
                local PIndex = Player:GetData().TruePlayerIndex

                for i,v in pairs(mod.Saved.Player[PIndex].Progress.Room) do
                    if type(v) == "table" then

                        for j,_ in ipairs(mod.Saved.Player[PIndex].Progress.Room[i]) do
                            mod.Saved.Player[PIndex].Progress.Room[i][j] = 0
                        end
                    else

                        mod.Saved.Player[PIndex].Progress.Room[i] = 0 --resets the room progress
                    end
                end
            end
        end
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise


    --ADVANCE RNG
    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        if Slot.Joker == mod.Jokers.IDOL
           or Slot.Joker == mod.Jokers.MAIL_REBATE
           or Slot.Joker == mod.Jokers.CASTLE
           or Slot.Joker == mod.Jokers.TO_DO_LIST
           or Slot.Joker == mod.Jokers.ANCIENT_JOKER then
            
            Player:GetTrinketRNG(Slot.Joker):Next()
        end
    end

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 then --could save some time
        elseif Joker == mod.Jokers.VAGABOND then
            if Player:GetNumCoins() <= 2 or mod.Saved.HasDebt then
                local TrinketRNG = Player:GetTrinketRNG(mod.Jokers.VAGABOND)

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, RandomTarot, RandomSeed)

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.EffectType.JOKER, Player)
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
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 0.125

            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 0.01 then --at 0 it self destructs
                
                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Melted!",mod.EffectType.JOKER, Player)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "-0.16",mod.EffectType.JOKER, Player)
            end

            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.03

            
            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.05",mod.EffectType.JOKER, Player)

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Joker == mod.Jokers.LOYALTY_CARD and not Copied then

            if mod.Saved.Player[PIndex].Progress.Inventory[Index] ~= 0 then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 1

                
                if mod.Saved.Player[PIndex].Progress.Inventory[Index] ~= 0 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, 
                    tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index].." More"),mod.EffectType.JOKER, Player)
                else
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,"X2.5",mod.EffectType.JOKER, Player)
                end

            elseif Hostile then --need to clear a hostile room to reset
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = 5
            end

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
        elseif Joker == mod.Jokers.SUPERNOVA then

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
            
            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset",mod.EffectType.JOKER, Player)

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

            for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

                if mod:IsValue(Player, card, mod.Values.FACE)
                   and mod:TryGamble(Player, ParkRNG, 0.25) then

                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position, RandomVector()*2.5, Player, 0, Game:GetRoom():GetSpawnSeed())
                end
            end

        elseif Joker == mod.Jokers.PHOTOGRAPH then

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.SELTZER and not Copied then

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 1
    
            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 0 then --at 0 it self destructs
                
                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Empty!",mod.EffectType.JOKER, Player)
    
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "-1",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.TO_DO_LIST then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod:GetJokerInitialProgress(Joker)

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Play "..mod:CardValueToName(mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], false, true).."s",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod:GetJokerInitialProgress(Joker)
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Discard "..mod:CardValueToName(mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], false, true).."s",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            if not Copied then
                local Suit = mod:GetJokerInitialProgress(Joker)
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Suit + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~SUIT_FLAG)

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Discard "..mod:CardSuitToName(Suit, false, true),mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.IDOL then -- 3 values need to be stored, so the first 3 bits are for the suit, the 4 for the value and the other say how many were discarded

            if not Copied then
                
                local Prog = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                Prog = mod:GetJokerInitialProgress(Joker)

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, mod:CardValueToName(Prog & ~SUIT_FLAG, false, true).." "..mod:CardSuitToName(Prog & ~VALUE_FLAG, false, true),mod.EffectType.JOKER, Player)
            
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.ANCIENT_JOKER then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod:GetJokerInitialProgress(Joker)

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Play "..mod:CardSuitToName(mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]).."!",mod.EffectType.JOKER, Player)
            end

        elseif Joker == mod.Jokers.HIT_ROAD then 

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] ~= 1 then

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1

                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!",mod.EffectType.JOKER, Player)
                
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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

    if Room:IsFirstVisit() then
        local Type = Room:GetType()
        if  Type ~= RoomType.ROOM_DEFAULT
		    and Type ~= RoomType.ROOM_DUNGEON
		    and Type ~= RoomType.ROOM_GREED_EXIT
		    and Type ~= RoomType.ROOM_SECRET_EXIT
		    and Type ~= RoomType.ROOM_BOSS
		    and Type ~= RoomType.ROOM_ULTRASECRET
		    and Type ~= RoomType.ROOM_SECRET
		    and Type ~= RoomType.ROOM_SUPERSECRET then --Thanks Balatro Jokers

            mod.Saved.FloorSkippedSpecials = mod.Saved.FloorSkippedSpecials - 1
        end

    end



    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
        local PIndex = Player:GetData().TruePlayerIndex

        local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)


        -----------STEEL CARD BUFFS------------
        ---------------------------------------

        for _,index in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            local Triggers = 0
            if mod.Saved.Player[PIndex].FullDeck[index]
               and mod.Saved.Player[PIndex].FullDeck[index].Enhancement == mod.Enhancement.STEEL then

                Triggers = Triggers + 1 + MimeNum

                if mod.Saved.Player[PIndex].FullDeck[index].Seal == mod.Seals.RED then
                    Triggers = Triggers + 1
                end

                mod:IncreaseJimboStats(Player,0, 0, 1.2^Triggers, false, true)
            end
        end


        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local RoomRNG = RNG(Room:GetSpawnSeed())

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

                Copied = true
            end

            local HandType = mod:DeterminePokerHand(Player)

            local RandomSeed = Random()
            if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

            if Joker == mod.Jokers.SHORTCUT then
                
                if Game:GetLevel():GetCurrentRoomDesc().SafeGridIndex == mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                    
                    local GridPos = Isaac.GetFreeNearPosition(Room:GetCenterPos(),20)

                    Isaac.GridSpawn(GridEntityType.GRID_STAIRS, 0, GridPos, true)

                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = -1
                end

            elseif Joker == mod.Jokers.STONE_JOKER then
                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            end

            if Room:IsFirstVisit() then

                if Joker == mod.Jokers.CHAOS_CLOWN then

                    if Room:GetType() == RoomType.ROOM_SHOP then

                        Game:Spawn(EntityType.ENTITY_SLOT, SlotVariant.SHOP_RESTOCK_MACHINE,
                               Game:GetRoom():GetGridPosition(27),Vector.Zero, nil, 0, Game:GetRoom():GetSpawnSeed())
                    end
                elseif Joker == mod.Jokers.PERKEO then

                    if Room:GetType() == RoomType.ROOM_SHOP then
                    
                        for i = 0, 1 do
                            local Seed = Random()
                            Seed = Seed==0 and 1 or Seed

                            local card = Player:GetCard(i)
                            local pill = Player:GetPill(i)
                            if card ~= 0 then
                                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD,
                                           Player.Position,RandomVector()*3, nil, card, Seed)
                            
                                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                                        mod.Sounds.ACTIVATE, "Copy!",mod.EffectType.JOKER, Player)
                            elseif pill ~= 0 then
                                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL,
                                           Player.Position,RandomVector()*3, nil, pill, Seed)
                            
                                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                                        mod.Sounds.ACTIVATE, "Copy!",mod.EffectType.JOKER, Player)
                            end

                        end
                    end
                end
            end

            if Room:IsClear() then
                goto skip_player
            end

            if Joker == mod.Jokers.MISPRINT then
                local MisDMG = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                if not Copied then

                    MisDMG = mod:round(RoomRNG:RandomFloat(), 2)
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = MisDMG

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(MisDMG),mod.EffectType.JOKER, Player)
                end


                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.HALLUCINATION then

                if mod:TryGamble(Player, RoomRNG, 0.5) then
                    Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY)
                    table.insert(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY)
                else
                    Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY, -1)
                    table.remove(mod.Saved.Player[PIndex].InnateItems.General, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.General,CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,true))
                end
                
                --Player:CheckFamiliar(FamiliarVariant.MULTIDIMENSIONAL_BABY, FamiliarNum, RoomRNG)

            elseif Joker == mod.Jokers.JOLLY_JOKER then
                if HandType & mod.HandTypes.PAIR == mod.HandTypes.PAIR then

                    local Mult = 1 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.ZANY_JOKER then
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then

                    local Mult = 2 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.MAD_JOKER then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then

                    local Mult = 1.5 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
            elseif Joker == mod.Jokers.CRAZY_JOKER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then

                    local Mult = 3 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.DROLL_JOKER then
                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then

                    local Mult = 2.25 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Mult),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
            elseif Joker == mod.Jokers.SLY_JOKER then
                if HandType & mod.HandTypes.PAIR == mod.HandTypes.PAIR then

                    local Chips = 4 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Chips

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.WILY_JOKER then
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then

                    local Chips = 8 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Chips

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips),mod.EffectType.JOKER, Player)

                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.CLEVER_JOKER then
                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then

                    local Chips = 6 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Chips

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips),mod.EffectType.JOKER, Player)
                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            
            elseif Joker == mod.Jokers.DEVIOUS_JOKER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then

                    local Chips = 12 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Chips

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips),mod.EffectType.JOKER, Player)

                    
                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.CRAFTY_JOKER then

                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then

                    local Chips = 9 * (MimeNum+1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Chips

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Chips),mod.EffectType.JOKER, Player)
                else
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.SPLASH then

                for i, Index in ipairs(mod.Saved.Player[PIndex].CurrentHand) do 
                    local ShotCard = mod.Saved.Player[PIndex].FullDeck[Index]
                    ShotCard.Index = Index

                    for i=0, MimeNum do
                        mod:OnCardShot(Player, ShotCard, false) --triggers every card in hand
                    end
                end

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.RUNNER then
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then

                    local Increase = 2 * (MimeNum + 1)
 
                    if not Copied then
                        mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + Increase
                    end

                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Increase),mod.EffectType.JOKER, Player)
                end

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            elseif Joker == mod.Jokers.SUPERPOSISION then

                local HasAce = false
                for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                    if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer] ,1) then
                        HasAce = true
                        break
                    end
                end

                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT and HasAce then
                
                    for i=0, MimeNum do
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                                   RandomVector()*3, Player, mod.Packs.ARCANA,  RandomSeed)
                    end

                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.EffectType.JOKER, Player)

                    
                end

            

            elseif Joker == mod.Jokers.SEANCE then

                if HandType & mod.HandTypes.STRAIGHT_FLUSH == mod.HandTypes.STRAIGHT_FLUSH then

                    for i = 0, MimeNum do
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                                   RandomVector()*2.5, Player, mod.Packs.SPECTRAL, RandomSeed)
                    end
                end

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Spectral!",mod.EffectType.JOKER, Player)

            

            elseif Joker == mod.Jokers.SPARE_TROUSERS then

                if HandType & mod.HandTypes.TWO_PAIR == mod.HandTypes.TWO_PAIR then

                    local Increase = 0.25 * (MimeNum + 1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + Increase --0.4

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Increase),mod.EffectType.JOKER, Player)

                end


            elseif Joker == mod.Jokers.BARON then

                BaronKings = 0

                for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                    if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Values.KING) then
                        BaronKings = BaronKings + 1
                    end
                end

                --mod.Saved.Player[PIndex].Progress.Room.KingsAtStart = BaronKings * (MimeNum+1)

                local Mult = 1.2 ^ (BaronKings * (MimeNum + 1))

                mod:IncreaseJimboStats(Player, 0, 0, Mult, false, true)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.FLOWER_POT then

                if not Copied then
                    local HasSuit = 0

                    for i=mod.Suits.Spade, mod.Suits.Diamond do

                        for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                            if mod:IsSuit(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], i) then
                                HasSuit = i
                                break
                            end
                        end

                        if HasSuit ~= i then
                            break
                        end
                    end

                    if HasSuit == mod.Suits.Diamond then

                        local Mult = 1.5 ^ (MimeNum + 1)
                    
                        mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                        mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)


                    else
                        mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1
                    end

                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end

            

            elseif Joker == mod.Jokers.SEE_DOUBLE then
                local HasClub = false
                local HasNoClub = false
                for _, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                    
                    local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

                    if card.Enhancement == mod.Enhancement.WILD then
                        HasClub = true
                        HasNoClub = true

                    elseif mod:IsSuit(Player, card, mod.Suits.Club) then
                        HasClub = true

                    else
                        HasNoClub = true
                    end

                    if HasClub and HasNoClub then
                        break
                    end
                end

                local Mult = 1
                if HasClub and HasNoClub then
                    Mult = 1.2 ^ (MimeNum + 1)

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
                end

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.DUO then

                local Mult = 1
                if HandType & mod.HandTypes.PAIR == mod.HandTypes.PAIR then

                    Mult = 1.25 ^ (MimeNum + 1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1.25
                end

                if Mult ~= 1 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
                end
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.TRIO then

                local Mult = 1
                if HandType & mod.HandTypes.THREE == mod.HandTypes.THREE then
                   
                    Mult = 1.5 ^ (MimeNum + 1)

                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                end

                if Mult ~= 1 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
                end
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            
            elseif Joker == mod.Jokers.FAMILY then

                local Mult = 1
                if HandType & mod.HandTypes.FOUR == mod.HandTypes.FOUR then

                    Mult = 2 ^ (MimeNum + 1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                end

                if Mult ~= 1 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
                end
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.ORDER then

                local Mult = 1
                if HandType & mod.HandTypes.STRAIGHT == mod.HandTypes.STRAIGHT then

                    Mult = 2.5 ^ (MimeNum + 1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                end

                if Mult == 2.5 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
                end
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.TRIBE then

                local Mult = 1
                if HandType & mod.HandTypes.FLUSH == mod.HandTypes.FLUSH then

                    Mult = 1.55 ^ (MimeNum + 1)
                   
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                end

                if Mult ~= 1 then
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "X"..tostring(Mult),mod.EffectType.JOKER, Player)
                end
                
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.SHOOT_MOON then

                local MoonsShot = 0

                for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                    if mod:IsValue(Player,  mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Values.QUEEN) then
                        MoonsShot = MoonsShot + 1
                    end
                end

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = MoonsShot * 0.7 * (MimeNum + 1)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.ACROBAT then

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

    for _, Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then
            local PIndex = Player:GetData().TruePlayerIndex

            for i,_ in pairs(mod.Saved.Player[PIndex].Progress.Floor) do
                mod.Saved.Player[PIndex].Progress.Floor[i] = 0 --resets the blind progress
            end
            mod.Saved.FloorVouchers = {}

            mod.Saved.RunSkippedSpecials = mod.Saved.RunSkippedSpecials + mod.Saved.FloorSkippedSpecials
            mod.Saved.FloorSkippedSpecials = 0
        end
    end

    do
    local rooms = Game:GetLevel():GetRooms()
	local num = 0
    for i = 0, rooms.Size - 1 do
        local room = rooms:Get(i)
        if  (room.Data.Type ~= RoomType.ROOM_DEFAULT
		and room.Data.Type ~= RoomType.ROOM_DUNGEON
		and room.Data.Type ~= RoomType.ROOM_GREED_EXIT
		and room.Data.Type ~= RoomType.ROOM_SECRET_EXIT
		and room.Data.Type ~= RoomType.ROOM_BOSS
		and room.Data.Type ~= RoomType.ROOM_ULTRASECRET
		and room.Data.Type ~= RoomType.ROOM_SECRET
		and room.Data.Type ~= RoomType.ROOM_SUPERSECRET
		and room.VisitedCount <= 0) then --Thanks Balatro Jokers
            mod.Saved.FloorSkippedSpecials = mod.Saved.FloorSkippedSpecials + 1
        end
    end
    end


    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        local PIndex = Player:GetData().TruePlayerIndex

        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            if Slot.Joker == mod.Jokers.SHORTCUT then

                local Level = Game:GetLevel()

                for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SHORTCUT, true)) do

                    local RadnomIndex

                    repeat
                        mod:RandomSeed(Player:GetTrinketRNG(mod.Jokers.SHORTCUT))

                        RadnomIndex = Level:GetRandomRoomIndex(false, Seed)  --ShortRNG:RandomInt(0, NumRooms-1)
                    
                        local ChosenRoom = Level:GetRoomByIdx(RadnomIndex)

                    until Level:GetStartingRoomIndex() ~= RadnomIndex
                          and ChosenRoom.Data.Type ~= RoomType.ROOM_BOSS
                          and ChosenRoom.Data.Type ~= RoomType.ROOM_ULTRASECRET

                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = RadnomIndex

                    --print("chose: "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))
                end

            elseif Slot.Joker == mod.Jokers.CAMPFIRE then
 
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = 1

                mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Reset",mod.EffectType.JOKER, Player)

            elseif Slot.Joker == mod.Jokers.PERKEO then

                for i = 0, 1 do
                    local Seed = Random()
                    Seed = Seed==0 and 1 or Seed
            
                    local card = Player:GetCard(i)
                    local pill = Player:GetPill(i)
                    if card ~= 0 then
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD,
                               Player.Position,RandomVector()*3, nil, card, Seed)
                    
                        mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Copy!",mod.EffectType.JOKER, Player)
                    elseif pill ~= 0 then
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL,
                               Player.Position,RandomVector()*3, nil, pill, Seed)
                        
                        mod:CreateBalatroEffect(Index,mod.EffectColors.YELLOW, 
                                        mod.Sounds.ACTIVATE, "Copy!",mod.EffectType.JOKER, Player)
                    end
                        
                end
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

        local PIndex = Player:GetData().TruePlayerIndex

        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker    

            if Joker == 0 then
            elseif Joker == mod.Jokers.FLASH_CARD then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.02

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.02",mod.EffectType.JOKER, Player)

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
    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.MR_BONES then
            local Revive = false
            if mod.Saved.BossCleared == 2 then --on boss cleared revive anyways
                Revive = true

            elseif mod.Saved.BigCleared then --if big is cleared then you need to be fighting boss to revive
                if Game:GetRoom():GetBossID() ~= 0 then
                    Revive = true
                end
            elseif mod.Saved.SmallCleared then
                local BlindProgress  = mod.Saved.ClearedRooms
                if BlindProgress >= mod.Saved.BigBlind / 2 then
                    Revive = true
                end
            else --before clearing small blind
                local BlindProgress  = mod.Saved.ClearedRooms

                if BlindProgress >= mod.Saved.SmallBlind / 2 then
                    Revive = true
                end
            end
            if not Revive then
                return
            end

            Player:Revive()
            Player:SetFullHearts() --full health
            Player:SetMinDamageCooldown(120) --some iframes

            mod.Saved.Player[PIndex].Inventory[Index].Joker = 0 --removes the trinket
            mod.Saved.Player[PIndex].Inventory[Index].Edition = 0

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Saved!",
                                    mod.EffectType.JOKER, Player)

            break
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
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    local PIndex = Player:GetData().TruePlayerIndex

    --FIRST it deternimes the bb / bs copied joker
    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        local StartI = Index

        while Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM do

            Joker = mod.Saved.Player[PIndex].Inventory[Index].Joker

            if Joker == mod.Jokers.BLUEPRINT then --copies the joker to its right
                Index = Index + 1

            elseif Joker == mod.Jokers.BRAINSTORM then --copies the leftmost joker
                Index = 1

            end

            mod.Saved.Player[PIndex].Progress.Inventory[StartI] = Index

            if Index == StartI
               or not mod.Saved.Player[PIndex].Inventory[Index]
               or mod.Saved.Player[PIndex].Inventory[Index].Joker == 0
               or not ItemsConfig:GetTrinket(mod.Saved.Player[PIndex].Inventory[Index].Joker):HasCustomCacheTag("copy") then --some combinations can lead to infinite loops
                
                mod.Saved.Player[PIndex].Progress.Inventory[StartI] = 0
                break
            end
        end
    end

    --amounts needed for innate items counting
    local HackNum = 0
    local SuperPosNum = 0

    --SECOND it does other suff
    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == -1 then
        elseif Joker == 0 then --if the slot is empty

            if not Copied then
                mod.Saved.Player[PIndex].Progress.GiftCardExtra[Index] = 0
            end

        elseif Joker == mod.Jokers.JOKER_STENCIL then
        
            local EmptySlots = 0
            for i,v in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if v.Joker == 0 or v.Joker == mod.Jokers.JOKER_STENCIL then
                    EmptySlots = EmptySlots + 1
                end
            end

            local Mult = 0.25 + 0.75*EmptySlots

            if Player:GetActiveItem() == CollectibleType.COLLECTIBLE_NULL then
                Mult = Mult + 0.25
            end

            local Difference = Mult - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

            if Difference ~= 0 then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

            

        elseif Joker == mod.Jokers.SWASHBUCKLER and not Copied then
        
            local TotalSell = 0
            for Slot,Jok in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if Jok.Joker ~= 0 then
                    TotalSell = TotalSell + mod:GetJokerCost(Jok.Joker, Jok.Edition, Slot, Player)
                end
            end

            if TotalSell*0.05 - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] ~= 0 then
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


    JokerDifference = HackNum - mod:GetValueRepetitions(mod.Saved.Player[PIndex].InnateItems.Hack, mod.Saved.Player[PIndex].InnateItems.Hack[1])

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
                    local Size = #mod.Saved.Player[PIndex].InnateItems.Hack
                    for i=1, JokerDifference do
                        mod.Saved.Player[PIndex].InnateItems.Hack[Size + i] = Item
                    end
                else
                    for i=1, -JokerDifference do

                        table.remove(mod.Saved.Player[PIndex].InnateItems.Hack, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.Hack, Item, true))
                    end
                end
            end
        end
    end

    JokerDifference = SuperPosNum - mod:GetValueRepetitions(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_FOREVER_ALONE)

    if JokerDifference >= 0 then
        for i=1, JokerDifference do
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FOREVER_ALONE, 2)
            table.insert(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_FOREVER_ALONE)
        end
    else
        for i=1, -JokerDifference do
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FOREVER_ALONE, -2)

            table.remove(mod.Saved.Player[PIndex].InnateItems.General, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_FOREVER_ALONE, true))
        end
    end


    if mod:JimboHasTrinket(Player, mod.Jokers.ROCKET) then
        
        if not Player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, false, false) then
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
            table.insert(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
        end

    --checks if the player has an innate collectible to remove
    elseif mod:Contained(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) then
        
        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, -1)
        table.remove(mod.Saved.Player[PIndex].InnateItems.General, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.General,CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,true))

    end

    if mod:JimboHasTrinket(Player, mod.Jokers.JUGGLER) then
        
        if not Player:HasCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, false, false) then
            Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY)
            table.insert(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_POLYDACTYLY)
        end

    --checks if the player has an innate collectible to remove
    elseif mod:Contained(mod.Saved.Player[PIndex].InnateItems.General, CollectibleType.COLLECTIBLE_POLYDACTYLY) then
        
        Player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, -1)
        table.remove(mod.Saved.Player[PIndex].InnateItems.General, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.General,CollectibleType.COLLECTIBLE_POLYDACTYLY,true))

    end

    if not mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) and next(mod.Saved.ShowmanRemovedItems) then
        local ItemPool = Game:GetItemPool()

        for _,Item in ipairs(mod.Saved.ShowmanRemovedItems) do
            
            ItemPool:RemoveCollectible(Item)
        end

        mod.Saved.ShowmanRemovedItems = {}
    end

    Player:AddCacheFlags(CacheFlag.CACHE_ALL)

    Player:EvaluateItems()
end
mod:AddCallback("INVENTORY_CHANGE", mod.CopyAdjustments)


---@param Player EntityPlayer
function mod:JokerAdded(Player, Joker, Edition, Index)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex


    if Joker == mod.Jokers.JOKER then

        mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.2",
                                mod.EffectType.JOKER, Player)

    elseif Joker == mod.Jokers.GROS_MICHAEL then

        mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+0.75",
                                mod.EffectType.JOKER, Player)

    elseif Joker == mod.Jokers.CAVENDISH then

        mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X2",
                                mod.EffectType.JOKER, Player)


    elseif Joker == mod.Jokers.SPACE_JOKER then

        local StarItems = 0

        for Item, AmountHeld in ipairs(Player:GetCollectiblesList()) do

            local Config = ItemsConfig:GetCollectible(Item)
            if Config and Config:HasTags(ItemConfig.TAG_STARS) then

                StarItems = StarItems + AmountHeld
            end
        end

        for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SPACE_JOKER, true)) do
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = StarItems
        end

    elseif Joker == mod.Jokers.SHORTCUT then

        local Level = Game:GetLevel()

        repeat
            local Seed = Random()
            if Seed == 0 then Seed = 1 end

            local RandomIndex = Level:GetRandomRoomIndex(false, Seed)  --ShortRNG:RandomInt(0, NumRooms-1)
        
            local ChosenRoom = Level:GetRoomByIdx(RandomIndex)

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = ChosenRoom.SafeGridIndex

        until Level:GetStartingRoomIndex() ~= mod.Saved.Player[PIndex].Progress.Inventory[Index]
              and ChosenRoom.Data.Type ~= RoomType.ROOM_BOSS
              and ChosenRoom.Data.Type ~= RoomType.ROOM_ULTRASECRET
    
        --print("chose: "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

        if Level:GetCurrentRoomDesc().SafeGridIndex == mod.Saved.Player[PIndex].Progress.Inventory[Index] then
            local Room = Game:GetRoom()
            local GridPos = Isaac.GetFreeNearPosition(Room:GetCenterPos(),20)

            Isaac.GridSpawn(GridEntityType.GRID_STAIRS, 1, GridPos, true)

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = -1
        end

    elseif Joker == mod.Jokers.SHOWMAN then

        local ItemPool = Game:GetItemPool()

        for Item, Removed in ipairs(ItemPool:GetRemovedCollectibles()) do

        ---@diagnostic disable-next-line: undefined-field
            ItemPool:ResetCollectible(Item)

            mod.Saved.ShowmanRemovedItems[#mod.Saved.ShowmanRemovedItems + 1] = Item

        end

    elseif Joker == mod.Jokers.STUNTMAN then

        mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+12.5",
                                    mod.EffectType.JOKER, Player)

    elseif Joker == mod.Jokers.CHICOT then

        Game:GetLevel():RemoveCurses(Game:GetLevel():GetCurses())
    end
end
mod:AddCallback("JOKER_ADDED", mod.JokerAdded)


-----SPECIFIC EVALUATIONS-------
--------------------------------

local PastCoins = 0
local PastBombs = 0
local PastKeys = 0
--keeps track of the player's pickup to see when to evaluate
---@param Player EntityPlayer
function mod:MischeviousThingsBasedEval(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or Game:GetFrameCount() % 3 == 0
       or not mod.GameStarted then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local NowCoins = Player:GetNumCoins()
    local NowBombs = Player:GetNumBombs()
    local NowKeys = Player:GetNumKeys()

    if NowCoins ~= PastCoins then

        local Difference = NowCoins - PastCoins

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker
            
            if Joker == mod.Jokers.BULL then

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

            elseif Joker == mod.Jokers.GREEDY_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            elseif Joker == mod.Jokers.BOOTSTRAP then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            end
        end

        PastCoins = NowCoins
    end

    if NowBombs ~= PastBombs then

        local Difference = NowBombs - PastBombs

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker
            
            if Joker == mod.Jokers.GLUTTONOUS_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

            elseif Joker == mod.Jokers.ONIX_AGATE then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
            end

        end

        PastBombs = NowBombs
    end

    if NowKeys ~= PastKeys then

        local Difference = NowKeys - PastKeys

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            if Joker == mod.Jokers.WRATHFUL_JOKER then

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

            elseif Joker == mod.Jokers.ARROWHEAD then

                Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

            end

        end

        PastKeys = NowKeys
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

            Creep.Scale = 0.65 + mod.Saved.Player[PIndex].Progress.Inventory[Index] * 0.1

        end
    end




    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.MischeviousThingsBasedEval)


---@param Player EntityPlayer
local function OnHeartsChange(_,Player, Amount, HpType, _)

    if Amount == 0 or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local NowHearts = Player:GetHearts() + Player:GetRottenHearts()


    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.LUSTY_JOKER then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)


        elseif Joker == mod.Jokers.BANNER then


            mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0.75*NowHearts

            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

        elseif Joker == mod.Jokers.MYSTIC_SUMMIT then

            if NowHearts == 2 then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0.75
            else
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0
            end

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        end

    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_HEARTS, OnHeartsChange)


---@param Player EntityPlayer
function mod:ItemAddedEval(Type,_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local Config = ItemsConfig:GetCollectible(Type)

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

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

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 1
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
    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

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

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 1
            end

        end
    end

    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.ItemRemovedEval)


---@param Player EntityPlayer
function mod:ShiftEval(Player)

    local PIndex = Player:GetData().TruePlayerIndex

    for Joker,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        if Slot.Joker == mod.Jokers.RAISED_FIST then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Slot.Joker == mod.Jokers.BLACKBOARD then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        elseif Joker == mod.Jokers.ACROBAT then

            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback("DECK_SHIFT", mod.ShiftEval)


---@param Player EntityPlayer
function mod:DeckModifyEval(Player, CardsAdded, CardsDestroyed)

    local PIndex = Player:GetData().TruePlayerIndex

    CardsAdded = CardsAdded or 0
    CardsDestroyed = CardsDestroyed or {}

    for Index,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        if Slot.Joker == mod.Jokers.STEEL_JOKER then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)

        elseif Slot.Joker == mod.Jokers.STONE_JOKER then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, false)

        elseif Slot.Joker == mod.Jokers.CLOUD_NINE then
            local Nines = 0
            for _,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                if mod:IsValue(Player, card, 9) then
                    Nines = Nines + 1
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = Nines

        elseif Slot.Joker == mod.Jokers.HOLOGRAM then

            if CardsAdded > 0 then

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.1*CardsAdded

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                "+0.1X",mod.EffectType.JOKER, Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Slot.Joker == mod.Jokers.EROSION then
            if CardsAdded < 0 then

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.15 * -CardsAdded

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                "+"..tostring(0.15 * -CardsAdded),mod.EffectType.JOKER, Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                
            end

        elseif Slot.Joker == mod.Jokers.DRIVER_LICENSE then

            local Is18 = Player:HasPlayerForm(PlayerForm.PLAYERFORM_ADULTHOOD) or Player:HasPlayerForm(PlayerForm.PLAYERFORM_MOM) or Player:HasPlayerForm(PlayerForm.PLAYERFORM_BOB)

            if not Is18 then
                local Enahncements = 0
                for _,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                    if card.Enhancement ~= mod.Enhancement.NONE then
                        Enahncements = Enahncements + 1
                    end
                end

                Is18 = Enahncements >= 18
            end

            local Mult = Is18 and 1.5 or 1

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[Index] then
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,
                "X"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]),mod.EffectType.JOKER, Player)
            
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = Mult
            end

        elseif Slot.Joker == mod.Jokers.GLASS_JOKER then

            local GlassNum = 0

            for i, card in ipairs(CardsDestroyed) do
                if card.Enhancement == mod.Enhancement.GLASS then
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.2
                    GlassNum = GlassNum + 1
                end
            end

            if GlassNum ~= 0 then
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,
                "+"..tostring(0.1*GlassNum).."X",mod.EffectType.JOKER, Player)
            end

        elseif Slot.Joker == mod.Jokers.CANIO then
  
            local FaceNum = 0

            for i, card in ipairs(CardsDestroyed) do
                
                if mod:IsValue(Player, card, mod.Values.FACE) then
                    
                    FaceNum = FaceNum + 1
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.25
                end
            end

            if FaceNum ~= 0 then
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,
                "X"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]),mod.EffectType.JOKER, Player)
            end
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback("DECK_MODIFY", mod.DeckModifyEval)


---STAT EVALUATION

function mod:TearsJokers(Player, _)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
        Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 or not ItemsConfig:GetTrinket(Joker):HasCustomTag(mod.JokerTypes.CHIPS) then --could save some time
            goto skip_joker
        end
        if Joker == mod.Jokers.BULL then
            
            local Coins = mod.Saved.HasDebt and 0 or Player:GetNumCoins()

            local Tears = Coins * 0.1
 
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect


            --print(Tears)

            mod:IncreaseJimboStats(Player, Tears, 0, 1, false, false)
        
        elseif Joker == mod.Jokers.STONE_JOKER then

            local StoneCards = 0
            for i,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
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

            if Tears ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                local Difference = Tears - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                mod:GetSignString(Difference)..tostring(Difference), mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --this is only to tell when to spawn the effect
            end

            mod:IncreaseJimboStats(Player, Tears, 0, 1, false, false)

        elseif Joker == mod.Jokers.ODDTODD then
 
            local ItemNum = Player:GetCollectibleCount()

            local Tears = (ItemNum%2==1) and ItemNum*0.07 or 0

            if Tears ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Tears - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

            mod:IncreaseJimboStats(Player, Tears,0,1, false, false)
        
        elseif Joker == mod.Jokers.ARROWHEAD then

            local NumSpades = mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Spade]

            local Tears = NumSpades*0.5 + Player:GetNumKeys()*0.5

            if Tears ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] and NumSpades ~= 0 then

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                "+"..tostring(Tears - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex])
                ,mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

            mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

        elseif Joker >= mod.Jokers.SLY_JOKER and Joker <= mod.Jokers.CRAFTY_JOKER then
            mod:IncreaseJimboStats(Player, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex],0,1, false, false)

        elseif Joker == mod.Jokers.BANNER then

            local Tears = 0.75 * Player:GetHearts()

            if Tears ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Tears - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                mod:GetSignString(Difference)..tostring((Difference))
                ,mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect
            
            mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

        elseif Joker == mod.Jokers.SCARY_FACE then

            local Tears = mod.Saved.Player[PIndex].Progress.Room.ChampKills

            if Tears ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Tears - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                mod.GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect

            mod:IncreaseJimboStats(Player, Tears,0,1, false, false)
        

        

            

        elseif Joker == mod.Jokers.BLUE_JOKER then

            local NumCards = #mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer + 1
 
            local Tears = NumCards * 0.1

            if Tears ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] and not Copied then

                mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                "+"..tostring(Tears - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex])
                ,mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Tears --only used to tell when to spawn an effect
            end


            mod:IncreaseJimboStats(Player, Tears,0,1, false, false)

        elseif Joker == mod.Jokers.RUNNER then

            mod:IncreaseJimboStats(Player, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + Player.MoveSpeed,0,1, false, false)
        
        elseif Joker == mod.Jokers.SQUARE_JOKER then

            local Tears = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 0 --retro vision stats

            if mod.Saved.Player[PIndex].Progress.Room.Shots % 4 == 3 then
                Tears = Tears + 4
            end

            mod:IncreaseJimboStats(Player, Tears,0,1, false, false)
        
        elseif Joker == mod.Jokers.CASTLE then

            local NumDiscards = (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~SUIT_FLAG)/8

            mod:IncreaseJimboStats(Player, NumDiscards*0.04,0,1, false, false)


        
        elseif Joker == mod.Jokers.STUNTMAN then

            mod:IncreaseJimboStats(Player, 12.5,0,1, false, false)
        
        else

            mod:IncreaseJimboStats(Player, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], 0, 1, false, false)

        end
        ::skip_joker::
    end
    
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.TearsJokers, CacheFlag.CACHE_FIREDELAY)


function mod:DamageJokers(Player,_)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 or not ItemsConfig:GetTrinket(Joker):HasCustomTag(mod.JokerTypes.MULT) then --could save some time
            goto skip_joker
        end
        if Joker == mod.Jokers.JOKER then
            mod:IncreaseJimboStats(Player, 0, 0.2, 1, false, false)

        elseif Joker == mod.Jokers.ABSTRACT_JOKER then
            local NumJokers = 0
            for j,InnerSlot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if InnerSlot.Joker ~= 0 then
                    NumJokers = NumJokers + 1
                end
            end

            local ItemNum = Player:GetCollectibleCount()

            local Damage = ItemNum*0.03 + NumJokers + 0.15

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                "+"..tostring(Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex])
                ,mod.EffectType.JOKER, Player)
            end
            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

        elseif Joker == mod.Jokers.EVENSTEVEN then
            
            local ItemNum = Player:GetCollectibleCount()

            local Damage = (ItemNum%2==0) and ItemNum*0.02 or 0

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end
            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end
            mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)

        elseif Joker == mod.Jokers.FORTUNETELLER then

            local Damage = 0.03 * mod.Saved.TarotsUsed

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] and not Copied then

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                "+"..tostring(Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex])
                ,mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)
        
        elseif Joker == mod.Jokers.ONIX_AGATE then

            local Bombs = Player:GetNumBombs()

            local Damage = Bombs*0.07

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end
            
            mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)
        
        elseif Joker == mod.Jokers.GROS_MICHAEL then
            mod:IncreaseJimboStats(Player, 0,0.75,1, false, false)

        elseif Joker == mod.Jokers.SWASHBUCKLER then

            local TotalSell = 0
            for i,Jok in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if Jok.Joker ~= 0 then
                    TotalSell = TotalSell + mod:GetJokerCost(Jok.Joker, Jok.Edition, i)
                end
            end

            local Difference = TotalSell*0.05 - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
            if Difference ~= 0 then

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                mod:GetSignString(Difference)..tostring(Difference),mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = TotalSell * 0.05


            mod:IncreaseJimboStats(Player, 0,mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex],1, false, false)

        elseif Joker == mod.Jokers.HALF_JOKER then

            if mod.Saved.Player[PIndex].Progress.Room.Shots <= 4 then
                mod:IncreaseJimboStats(Player, 0, 1.5, 1, false, false)
            end

            if #mod.Saved.Player[PIndex].CurrentHand <= 3 then
                mod:IncreaseJimboStats(Player, 0, 1, 1, false, false)
            end

        elseif Joker == mod.Jokers.LUSTY_JOKER then

            local Damage = 0.05 * Player:GetHearts()

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end
            
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            
            mod:IncreaseJimboStats(Player, 0, Damage,1, false, false)

        elseif Joker == mod.Jokers.GREEDY_JOKER then

            local Coins = Player:GetNumCoins()
            if mod.Saved.other.HasDebt then Coins = 0 end

            local Damage = 0.01*Coins

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end
                
            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end --only used to tell when to spawn an effect

            mod:IncreaseJimboStats(Player, 0, Damage ,1, false, false)

        elseif Joker == mod.Jokers.GLUTTONOUS_JOKER then

            local Damage = 0.05*Player:GetNumBombs()

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end --only used to tell when to spawn an effect
            
            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)


        elseif Joker == mod.Jokers.WRATHFUL_JOKER then

            local Damage = 0.05*Player:GetNumKeys()

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end --only used to tell when to spawn an effect
            
            mod:IncreaseJimboStats(Player, 0,Damage,1, false, false)

        elseif Joker == mod.Jokers.MYSTIC_SUMMIT then

            local Damage = (Player:GetHearts() == 2) and 0.75 or 0

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                "+"..tostring(Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex])
                ,mod.EffectType.JOKER, Player)
            end


            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

        elseif Joker == mod.Jokers.RAISED_FIST then

            local MinValue = 11

            for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                MinValue = math.min(MinValue,  mod:GetValueScoring(mod.Saved.Player[PIndex].FullDeck[v].Value)) 

            end

            local Damage = 0.05 * MinValue * (MimeNum+1)

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = MinValue - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference),mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

        elseif Joker == mod.Jokers.FIBONACCI then

            local ItemNum = Player:GetCollectibleCount()

            local HasFibonacci = math.type(((5*ItemNum^2 + 4)^0.5)) == "integer"
                               or math.type(((5*ItemNum^2 - 4)^0.5)) == "integer"

            local Damage = HasFibonacci and ItemNum*0.05 or 0

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect
            end --only used to tell when to spawn an effect
            
            mod:IncreaseJimboStats(Player, 0,Damage ,1 , false, false)


        

        

        elseif Joker == mod.Jokers.SMILEY_FACE then

            local Damage = 0.15 * mod.Saved.Player[PIndex].Progress.Room.ChampKills

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference)
                ,mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --this is only to tell when to spawn the effect

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

        elseif Joker == mod.Jokers.BOOTSTRAP then --this works with mod:OnUpdate() in TrinketCallbacks.lua
            local Coins = mod.Saved.HasDebt and 0 or Player:GetNumCoins()

            local Damage = (Coins//5) * 0.1

            if Damage ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Damage - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.ADDMULT,
                mod:GetSignString(Difference)..tostring(Difference),mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Damage --only used to tell when to spawn an effect

            mod:IncreaseJimboStats(Player, 0, Damage, 1, false, false)

        else
            mod:IncreaseJimboStats(Player,0,mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex],1,false,false)    
        end
        ::skip_joker::
    end
    
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.DamageJokers, CacheFlag.CACHE_DAMAGE)


function mod:DamageMultJokers(Player,_)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end
    
    local PIndex = Player:GetData().TruePlayerIndex

    local MimeNum = #mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == 0 or not ItemsConfig:GetTrinket(Joker):HasCustomTag(mod.JokerTypes.XMULT) then --could save some time
            goto skip_joker
        end
        if Joker == mod.Jokers.JOKER_STENCIL then

            local EmptySlots = 0
            for i,Slot2 in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if Slot2.Joker == 0 or (Slot2.Joker == mod.Jokers.JOKER_STENCIL and i ~= Index) then
                    EmptySlots = EmptySlots + 1
                end
            end

            local Mult = 1 + EmptySlots*0.75

            if Player:GetActiveItem() == CollectibleType.COLLECTIBLE_NULL then
                Mult = Mult + 0.25
            end

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                local Difference = Mult - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                mod:GetSignString(Difference)..tostring(Difference).."X",mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult --this is only to tell when to spawn the effect
            end

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, false)
        
        elseif Joker == mod.Jokers.CAVENDISH then

            mod:IncreaseJimboStats(Player, 0, 0, 2, false, false)

        elseif Joker == mod.Jokers.LOYALTY_CARD then

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] == 0 then
                mod:IncreaseJimboStats(Player,0,0,2.5,false,false)
            end

        elseif Joker == mod.Jokers.STEEL_JOKER then
            local SteelCards = 0
            for i,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                if card.Enhancement == mod.Enhancement.STEEL then
                    SteelCards = SteelCards + 1
                end
            end

            local Mult = 1 + SteelCards * 0.15

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                local Difference = Mult - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                mod:GetSignString(Difference)..tostring(Difference).."X",mod.EffectType.JOKER, Player)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult --this is only to tell when to spawn the effect
            end

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, false)
        
        elseif Joker == mod.Jokers.BLACKBOARD then

            local Mult = 2

            for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

                if not(mod:IsSuit(Player, card, mod.Suits.Spade)
                       or mod:IsSuit(Player, card, mod.Suits.Club)) then
                    
                    Mult = 1
                    break
                end
            end

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                local Difference = Mult / mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                "X"..tostring(Difference),mod.EffectType.JOKER, Player)
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

            mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

        elseif Joker == mod.Jokers.BARON then
        
            local Mult = 1

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

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then

                local Difference = Mult / mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                "X"..tostring(Difference),mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
            end

            mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

        elseif Joker == mod.Jokers.BASEBALL then

            local Mult = 1

            for _,Slot2 in ipairs(mod.Saved.Player[PIndex].Inventory) do
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

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] and not Copied then
                local Difference = Mult / mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                "X"..tostring(Difference),mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
            end

            mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

        elseif Joker == mod.Jokers.CAMPFIRE then

            mod:IncreaseJimboStats(Player,0,0,mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex],false,false)    

        elseif Joker == mod.Jokers.ACROBAT then

            local CardsRemaining = Player:GetCustomCacheValue("hands") - mod.Saved.Player[PIndex].Progress.Room.Shots
            local Mult = 1
    
            if CardsRemaining <= 5 and CardsRemaining >= 0 then
                Mult = 2
            end

            if Game:GetRoom():GetBossID() ~= 0 then
                Mult = Mult * 1.5
            end

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                local Difference = Mult / mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                "X"..tostring(Difference),mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
            end

            mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

        elseif Joker == mod.Jokers.THROWBACK then

            local Mult = 1 + 0.05*mod.Saved.RunSkippedSpecials
    

            if Mult ~= mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                local Difference = Mult - mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
                
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                mod.GetSignString(Difference)..tostring(Difference).."X",mod.EffectType.JOKER, Player)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult
            end

            mod:IncreaseJimboStats(Player,0,0,Mult,false,false)

        

        
        

        elseif Joker == mod.Jokers.YORICK then

            local Mult = 1 + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] // 23)

            mod:IncreaseJimboStats(Player, 0, 0, 1+ 0.25*Mult, false, false)
        else
            mod:IncreaseJimboStats(Player,0,0,mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex],false,false)
        end

        ::skip_joker::
    end
    
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.DamageMultJokers, CacheFlag.CACHE_DAMAGE)



function mod:EditionsStats(Player, Flags)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
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


-----JOKERS SECONDARY EFFECTS---------
-------------------------------------

---@param Player EntityPlayer
function mod:FlightEval(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
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

        local PIndex = Player:GetData().TruePlayerIndex

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
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
        local PIndex = Player:GetData().TruePlayerIndex

        if not Entity:IsBoss() and EntityConfig.GetEntity(Entity.Type, Entity.Variant, Entity.SubType):CanBeChampion() then

            for i=1, #mod:GetJimboJokerIndex(Player, mod.Jokers.PAREIDOLIA) do
                if  mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.PAREIDOLIA), 0.2) then

                    Entity:MakeChampion(Entity.InitSeed)
                end
            end
        end


        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

                Copied = true
            end

            
            if Joker == mod.Jokers.FOUR_FINGER then

                if not Entity:IsBoss() then

                    if mod.Saved.Player[PIndex].Progress.Inventory[Index] == 5 then
              
                        Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
            
                        Entity:Kill()
                        mod:CreateBalatroEffect(Entity, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                        "5/4",mod.EffectType.ENTITY, Player)
            
                        mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0
                    end

                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 1
                end

            elseif Joker == mod.Jokers.MIDAS then

                if Entity:IsChampion() then
                    
                    Entity:AddMidasFreeze(EntityRef(Player), 210)

                end

            elseif Joker == mod.Jokers.CHICOT then

                if Entity:IsBoss() then
                    
                    Entity:AddWeakness(EntityRef(Player), -1)

                    mod:CreateBalatroEffect(Entity, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                    "Weaken!",mod.EffectType.JOKER, Player)
                end

            elseif Joker == mod.Jokers.CANIO then

                if Entity:IsChampion() then

                    Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                    Entity:Kill()

                    --Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.)

                    mod:CreateBalatroEffect(Entity, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    "No Comedy!",mod.EffectType.JOKER, Player)
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

    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        
        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.MIME then

            if mod:TryGamble(Player, RNG, 0.2) then
                Player:UseActiveItem(Type, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
        
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW,mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)
        
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
    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.MIME then

            if mod:TryGamble(Player, Player:GetCardRNG(card), 0.2) then

                local RandomSeed = mod:RandomSeed(Player:GetTrinketRNG(mod.Jokers.MIME))
        
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, card, RandomSeed)
                --Player:UseCard(card, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
                mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW,mod.Sounds.ACTIVATE, "Again!",mod.EffectType.JOKER, Player)

                
            end
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.MimeCards)


---@param Player EntityPlayer
function mod:PillUse(Effect,Color, Player,Flags)

    if Player:GetPlayerType() ~= mod.Characters.JimboType 
       or Flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY
       or Flags & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.SQUARE_JOKER then

            if Effect == PillEffect.PILLEFFECT_RETRO_VISION then

                if Color & PillColor.PILL_COLOR_MASK == PillColor.PILL_COLOR_MASK then --hprse pill
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 1.6
                
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+1.6",mod.EffectType.JOKER, Player)

                else --base pill

                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.4
                
                    mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE,mod.Sounds.CHIPS,
                    "+0.4",mod.EffectType.JOKER, Player)

                end

                
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

    local Triggers = 1

    if NPC:IsChampion() then
        for i,Player in ipairs(PlayerManager.GetPlayers()) do
            local PIndex = Player:GetData().TruePlayerIndex

            mod.Saved.Player[PIndex].Progress.Room.ChampKills = mod.Saved.Player[PIndex].Progress.Room.ChampKills + 1

            if Player:GetPlayerType() == mod.Characters.JimboType then
                Triggers = Triggers + #mod:GetJimboJokerIndex(Player, mod.Jokers.SOCK_BUSKIN)
            end
        end
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
        local PIndex = Player:GetData().TruePlayerIndex

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.SCARY_FACE then
                if NPC:IsChampion() then
                    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                end

            elseif Joker == mod.Jokers.SMILEY_FACE then
                if NPC:IsChampion() then
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
                
                if NPC:IsChampion() and mod.Saved.Player[PIndex].Progress.Room.ChampKills == 1 then
                    
                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT,
                    "X1.1", mod.EffectType.JOKER, Player)

                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] * 1.1
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
function mod:DoorUpdate(Door)
    if not mod.GameStarted or 
       not Door:IsRoomType(RoomType.ROOM_SECRET) and not Door:IsRoomType(RoomType.ROOM_SUPERSECRET)
       or Door:IsOpen() then
        return
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
        local PIndex = Player:GetData().TruePlayerIndex

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

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
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, mod.DoorUpdate)



function mod:HackReevaluationAdd(Item,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

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
                mod.Saved.Player[PIndex].InnateItems.Hack[#mod.Saved.Player[PIndex].InnateItems.Hack + 1] = Item
            end
        else
            for i=1, -AmountToAdd do

                table.remove(mod.Saved.Player[PIndex].InnateItems.Hack, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.Hack, Item, true))
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.HackReevaluationAdd)


function mod:HackReevaluationRemove(Player,Item)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

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

            table.remove(mod.Saved.Player[PIndex].InnateItems.Hack, mod:GetValueIndex(mod.Saved.Player[PIndex].InnateItems.Hack, Item, true))
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.HackReevaluationRemove)


---@param Player EntityPlayer
function mod:JimboLuckStat(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    Player.Luck = Player.Luck + 5 * #mod:GetJimboJokerIndex(Player, mod.Jokers.SCHOLAR)

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboLuckStat, CacheFlag.CACHE_LUCK)

---@param Player EntityPlayer
function mod:JimboSpeedStat(Player,_)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

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
        local PIndex = Player:GetData().TruePlayerIndex

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.MISPRINT then

                if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.MISPRINT), 0.1) then
                    
                    

                    --just like the base game, technically shows the next card to be drawn
                    local CardString = tostring(mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].DeckPointer])..SuitInitails[mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].DeckPointer].Suit]

                    mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW,mod.Sounds.ACTIVATE, "#@"..CardString, mod.EffectType.JOKER, Player)

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
    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = Index
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            Copied = true
        end

        if Joker == mod.Jokers.CONSTELLATION then
            
            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 0.05

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED,mod.Sounds.TIMESMULT, "+0.05X",mod.EffectType.JOKER, Player)

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
        local PIndex = Player:GetData().TruePlayerIndex

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
            Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.EROSION then

                if RockType == GridEntityType.GRID_ROCKT then
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.1

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    "+0.1",mod.EffectType.JOKER, Player)
    
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

                elseif RockType == GridEntityType.GRID_ROCK_SS then

                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.25

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    "+0.25",mod.EffectType.JOKER, Player)
    
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
        local PIndex = Player:GetData().TruePlayerIndex

        for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = Index
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]]
                Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[Index]

                Copied = true
            end

            if Joker == mod.Jokers.LUCKY_CAT then

                if not Copied then
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.02

                    mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.02X", mod.EffectType.JOKER, Player)
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



---@param Player EntityPlayer
---@param Config ItemConfigItem
function mod:OnCostumeModify(Config, Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local NumActiveCostumes = 0
    for _,LayerMap in ipairs(Player:GetCostumeLayerMap()) do
    
        --local ItemCongig = CostumeDesc:GetItemConfig()
    
        if LayerMap.costumeIndex ~= -1 then --every layer checks if an item is there 
            NumActiveCostumes = NumActiveCostumes + 1
        end

        --[[
        if not mod:Contained(CheckedItems, ItemCongig.ID) then --sometimes items are put multiple times in the for loop
        
            CheckedItems[#CheckedItems+1] = ItemCongig.ID
        
            for i,LayerState in ipairs(CostumeDesc:GetSprite():GetAllLayers()) do --gets every layer in the costume's sprite
            
                --print("Checking "..LayerState:GetName().." of "..ItemCongig.Name)
            
                --if string.match(LayerState:GetName(), "body") then --if the item has a body costume
                
                if Player:IsItemCostumeVisible(ItemCongig, LayerState:GetName()) then
                    NumActiveCostumes = NumActiveCostumes + 1
                    break
                end
                --end
            end
        end]]
    end

    if NumActiveCostumes == mod.Saved.Player[PIndex].NumActiveCostumes then
        return
    end

    for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.SPARE_TROUSERS, true)) do
    
        local Difference = (NumActiveCostumes - mod.Saved.Player[PIndex].NumActiveCostumes)*0.1

        mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + Difference
    
        mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                    mod:GetSignString(Difference)..tostring(Difference), mod.EffectType.JOKER, Player)

        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end

    mod.Saved.Player[PIndex].NumActiveCostumes = NumActiveCostumes

    Player:EvaluateItems()

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_COSTUME, mod.OnCostumeModify)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_COSTUME, mod.OnCostumeModify)



local VariantGoldenSubtype = {
    --[PickupVariant.PICKUP_BOMB] = BombSubType.BOMB_GOLDEN,
    [PickupVariant.PICKUP_COIN] = CoinSubType.COIN_GOLDEN,
    [PickupVariant.PICKUP_HEART] = HeartSubType.HEART_GOLDEN,
    --[PickupVariant.PICKUP_CHEST] = ChestSubType.,
    [PickupVariant.PICKUP_KEY] = KeySubType.KEY_GOLDEN,
    [PickupVariant.PICKUP_PILL] = PillColor.PILL_GOLD,
    [PickupVariant.PICKUP_LIL_BATTERY] = BatterySubType.BATTERY_GOLDEN,
}

--changes the shop items to be in a specific pattern and rolls for the edition
---@param Pickup EntityPickup
---@param rNG RNG
function mod:PickupChanger(Pickup,Variant, SubType, ReqVariant, ReqSubType, rNG)

    local ReturnTable = {Variant, SubType, true} --basic return equal to not returning anything

    local RollRNG = mod.Saved.GeneralRNG --tried using the rng from the callback but it gave the same results each time


    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
       or not (ReqSubType == 0 or ReqVariant == 0) then

        return
    end

    for i,Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then

            local TicketRNG = Player:GetTrinketRNG(mod.Jokers.GOLDEN_TICKET)
            
            for i=1, #mod:GetJimboJokerIndex(Player, mod.Jokers.GOLDEN_TICKET) do
                
                if mod:TryGamble(Player, TicketRNG, 0.04) then
                    
                    if ReturnTable[1] == PickupVariant.PICKUP_CHEST then
                        ReturnTable[1] = PickupVariant.PICKUP_LOCKEDCHEST

                    elseif ReturnTable[1] == PickupVariant.PICKUP_BOMB then

                        if ReturnTable[2] == BombSubType.BOMB_TROLL then
                            ReturnTable[2] = BombSubType.BOMB_GOLDENTROLL
    
                        else
                            ReturnTable[2] = BombSubType.BOMB_GOLDEN

                        end

                    else
                        ReturnTable[2] = VariantGoldenSubtype[ReturnTable[1]]
                    end


                end
            end
        end
    end


    
    return ReturnTable
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, mod.PickupChanger)


function mod:OnGetCollectible(Type)

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) then

            --print(Game:GetItemPool():HasCollectible(Type))
        ---@diagnostic disable-next-line: undefined-field
            Game:GetItemPool():ResetCollectible(Type)

            mod.Saved.ShowmanRemovedItems[#mod.Saved.ShowmanRemovedItems+1] = Type
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, mod.OnGetCollectible)


---@param Player Entity
---@param Source EntityRef
function mod:OnTakeDamage(Player,Amount,Flags,Source,_)
    ---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local Enemy = Source.Entity:ToNPC() or (Source.Entity.SpawnerEntity and Source.Entity.SpawnerEntity:ToNPC())
    
    if Enemy and Enemy:IsBoss() then
        for i = 1, #mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR) do
            for j=1, 6 do
                local Seed = Random()
                Seed = Seed==0 and 1 or Seed

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                           RandomVector()*3, Player, CoinSubType.COIN_PENNY, Seed)
            end
        end
    end

    if Flags & DamageFlag.DAMAGE_FIRE then
        return not mod:JimboHasTrinket(Player, mod.Jokers.BURNT_JOKER)
    end


    
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakeDamage)


function mod:OnGetCurse(_)

    if not mod.GameStarted then
        return
    end

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if mod:JimboHasTrinket(Player, mod.Jokers.CHICOT) then

            return 0
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.OnGetCurse)





------------EXAMPLE JOKER FUNCTION----------
--[[
for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType or AllGood then
        goto skip_player
    end

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        if Slot.Joker == mod.Jokers.DELAYED_GRATIFICATION then
            AllGood = true
            break
        end
    end

    ::skip_player::
end
--]]