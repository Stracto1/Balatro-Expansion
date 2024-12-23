local mod = Balatro_Expansion
local Game = Game()

--rounds down to numDecimal of spaces
function mod:round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

--if X is inside of list
function mod:Contained(list, x)
	for _, v in pairs(list) do
	    if v == x then
            return true 
        end
	end
	return false
end


function mod:GetMax(Table)
    local Result = 0
    for _,v in ipairs(Table) do
        Result = math.max(Result,v)
    end
    return Result
end

function mod:CalculateTearsUp(currentMaxFireDelay, TearsAdded)
    --big ass math jumpscare (CHAT GPT moment) needed to give a stable tears up (like pisces does)
    local currentTearsPerSecond = 30 / (currentMaxFireDelay + 1)
    local targetTearsPerSecond = currentTearsPerSecond + TearsAdded
    local FireDelayToAdd = currentMaxFireDelay - ((30 / targetTearsPerSecond) - 1)

    return FireDelayToAdd
end

function mod:CalculateTearsValue(Player)
    return 30 / (Player.MaxFireDelay + 1)
end

function mod:CalculateMaxFireDelay(Tears)
    return (30 - Tears)/Tears
end

function mod:CalculateTears(Firedelay)
    return 30 / (Firedelay + 1)
end

--returns a shuffled version of the given table
function mod:Shuffle(table, RNG)
    for i = #table, 2, -1 do
        local j = RNG:RandomInt(i) + 1
        table[i], table[j] = table[j], table[i]
    end
    return table
end

---@param HandTable table
---@param card integer
function mod:AddCardToHand(HandTable, card)
    
    for i=1,#HandTable-1 do    --then puts them in order{2,3,4,5,1}
        local Temp = HandTable[i]
        HandTable[i] = HandTable[i+1]
        HandTable[i+1] = Temp
    end
    
    --replaces the first (oldest) with the new one
    HandTable[#HandTable] = card
    --return HandTable
end

function mod:SubstituteCards(ChosenTable)
    for i = #ChosenTable, 1,-1 do
        if ChosenTable[i] then
            --first adds the ammount of new cards needed
            table.insert(mod.SavedValues.Jimbo.CurrentHand,#mod.SavedValues.Jimbo.CurrentHand+1, mod.SavedValues.Jimbo.DeckPointer)
            mod.SavedValues.Jimbo.DeckPointer = mod.SavedValues.Jimbo.DeckPointer +1
            --then removes the selected cards 
            table.remove(mod.SavedValues.Jimbo.CurrentHand,i)
        end
    end
    
end

--determines the corresponding poker hand basing on the hand given
function mod:DeterminePokerHand()
    local ElegibleHandTypes = {mod.HandTypes.HIGH_CARD} --always at least a high card

    local RealHand = {}
    for i,_ in ipairs(Balatro_Expansion.SavedValues.Jimbo.CurrentHand) do
        if mod.CardSelectionParams.SelectedCards[i] then
            table.insert(RealHand, Balatro_Expansion.SavedValues.Jimbo.FullDeck[Balatro_Expansion.SavedValues.Jimbo.CurrentHand[i]])
        end
    end

    local ValueTable = {} --the value of every card used
    local SuitTable = {} --the suit of every card used
    for i, card in ipairs(RealHand) do
        ValueTable[i] = card.Value
        SuitTable[i] = card.Suit

    end

    local ValidCardsNumber = #RealHand

    --print(ValidCardsNumber)
    local IsFlush = false
    local IsStraight = false
    local IsRoyal = false

    if ValidCardsNumber >= 4 then --no need to check if there aren't enough cards
        IsFlush = mod:IsFlush(SuitTable)
        IsStraight,IsRoyal = mod:IsStraight(ValueTable)
    
    end

    local EqualCards = mod:GetCardValueRepetitions(ValueTable)

    --general flush check
    if IsFlush then
        table.insert(ElegibleHandTypes,mod.HandTypes.FLUSH)
    end
    --straight check
    if IsStraight then
        table.insert(ElegibleHandTypes,mod.HandTypes.STRAIGHT)
        if IsRoyal then
            table.insert(ElegibleHandTypes,mod.HandTypes.STRAIGHT_FLUSH)
            table.insert(ElegibleHandTypes,mod.HandTypes.ROYAL_FLUSH)
        elseif IsFlush then
            table.insert(ElegibleHandTypes,mod.HandTypes.STRAIGHT_FLUSH)
        end
    end

    ------repetition based hands checks-------
    if EqualCards < 2 then --not even a pair (lame)
       return ElegibleHandTypes
    end
    --at least a pair
    table.insert(ElegibleHandTypes,mod.HandTypes.PAIR)

    if EqualCards < 3 then --not a three of a kind
        if EqualCards == 2.5 then --in that case makes sure if it's a two pair
            table.insert(ElegibleHandTypes,mod.HandTypes.TWO_PAIR)
        end
        return ElegibleHandTypes
    end
    --at least a three of a kind
    table.insert(ElegibleHandTypes,mod.HandTypes.THREE)

    if EqualCards < 4 then
        if EqualCards == 3.5 then
            if IsFlush then
                table.insert(ElegibleHandTypes,mod.HandTypes.FLUSH_HOUSE)
            end
            table.insert(ElegibleHandTypes,mod.HandTypes.FULL_HOUSE)
        end
        return ElegibleHandTypes
    end
     --at least a four of a kind
    table.insert(ElegibleHandTypes,mod.HandTypes.FOUR)

    if EqualCards < 5 then 
        return ElegibleHandTypes
    end
    --a five of a kind
    if IsFlush then --not even a pair (lame)
        table.insert(ElegibleHandTypes,mod.HandTypes.FIVE_FLUSH)
    end
    table.insert(ElegibleHandTypes,mod.HandTypes.FIVE)

    --IN THE END THERE WILL BE A TABLE CONTAINING ALL THE POSSIBLE HAND TYPES
    --THAT THE USED ONE CONTAINS, MAKING IT EASIER FOR JOKERS TO ACTIVATE CORRECTLY
    --BUT ONLY THE "HIGEST" ONE WILL BE CONSIDERED AS USED

    return ElegibleHandTypes


end

function mod:IsFlush(SuitTable)
    local CardSuits = {0,0,0,0} --spades, hearts, clubs, diamonds

    for _, Suit in ipairs(SuitTable) do --cycles between all the cards in the used hand
        CardSuits[Suit] = CardSuits[Suit] + 1
    end

    for _, SuitNumber in ipairs(CardSuits) do
        if SuitNumber >= 5 then --if 5 cards have the same suit
            return true
        end
    end
    return false
end

function mod:IsStraight(ValueTable)
    table.sort(ValueTable)

    local LowestValue = ValueTable[1]
    local ValueToKeepStreak = LowestValue + 1
    local StraightStreak = 1
    for _, CardValue in ipairs(ValueTable) do --cycles between all the cards in the used hand

        if CardValue == ValueToKeepStreak  then
            StraightStreak = StraightStreak + 1
            if ValueToKeepStreak == 13 then
                ValueToKeepStreak = 1 --ace
            elseif ValueToKeepStreak ~= 1 then
                ValueToKeepStreak = ValueToKeepStreak + 1
            end
        end
    end
    if StraightStreak == 5 then
        if LowestValue == 10 then --determines if it's a royal flush
            return true,true
        else
            return true,false
        end
    end
    return false,false
end

function mod:GetCardValueRepetitions(ValueTable)

    local CardValues = {0,0,0,0,0,0,0,0,0,0,0,0,0} -- all the card's possible values

    --PAIRS CHECK
    for _, card in ipairs(ValueTable) do --cycles between all the cards in the used hand
    
        CardValues[mod.SavedValues.Jimbo.FullDeck[card].Value] = CardValues[mod.SavedValues.Jimbo.FullDeck[card].Value] + 1
    end

    local PairPresent = false --tells if there is a pair for a full house/two pairs
    local ToaKPresent = false --tells if there is a ToaK for a possible full house

    for _, ValueNum in ipairs(CardValues) do
        if ValueNum == 5 then
            return 5 --5 of a kind
        elseif ValueNum == 4 then
            return 4 --4 of a kind
        elseif ValueNum == 3 then
            if PairPresent then
                return 3.5 --full house
            end
            ToaKPresent = true
        elseif ValueNum == 2 then
            if PairPresent then
                return 2.5 --two pairs
            elseif ToaKPresent then
                return 3.5 --full house
            end
            PairPresent = true
        end
    end
    if PairPresent then
        return 2 --pair
    elseif ToaKPresent then
        return 3 --3 of a kind
    end
    return 1 --high card
end

function mod:FloorHasShopOrTreasure()
    --DETERMINATION FOR THE PRESENCE OF TRESURES ROOMS/SHOPS--
    --FALSE = NO shops/treasures
    --TRUE = AVAILABLE Shops/treasures
    local Available = {}
    Available.Treasure = true
    Available.Shop = true

    local Level = Game:GetLevel()
    mod.SavedValues.Other.Labyrinth = 1
    if Level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
        mod.SavedValues.Jimbo.Labyrinth = 2
    end
    if Level:IsAscent() then
        Available.Treasure = false
        Available.Shop = false
        return Available
    end
    local Greed = Game:IsGreedMode()
    local Stage = Level:GetAbsoluteStage()
    local LevelName = Level:GetName()

    if Stage == LevelStage.STAGE4_1 and not Greed  then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
            Available.Treasure = false
        end
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_SILVER_DOLLAR) then
            Available.Shop = false
        end
    elseif LevelName == "Sheol" and not Greed then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_WICKED_CROWN) then
            Available.Treasure = false
            Available.Shop = false
        end

    elseif LevelName == "Cathedral" then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_HOLY_CROWN) then
            Available.Treasure = false
            Available.Shop = false
        end
    elseif LevelName == "Shop" then --greed mode floor
        Available.Treasure = false
        
    elseif Stage >= LevelStage.STAGE6 then --anything after sheol/cathedral
        Available.Treasure = false
        Available.Shop = false
    end
    return Available
end

function mod:IncreaseJimboStats(Player,flag,increase)
    if flag & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        mod.SavedValues.Jimbo.StatsToAdd.Damage = mod.SavedValues.Jimbo.StatsToAdd.Damage + increase
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    elseif flag & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        mod.SavedValues.Jimbo.StatsToAdd.Tears = mod.SavedValues.Jimbo.StatsToAdd.Tears + increase
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        --print(mod.SavedValues.Jimbo.StatsToAdd.Tears)
    end
end

function mod:GetActualCardValue(Value)
    if Value >=10 then
        return 10
    end
    if Value == 1 then
        return 11
    end
    return Value
end
