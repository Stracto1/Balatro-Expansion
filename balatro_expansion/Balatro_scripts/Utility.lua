local Game = Game()

--rounds down to numDecimal of spaces
function Balatro_Expansion:round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

--if X is inside of list
function Balatro_Expansion:Contained(list, x)
	for _, v in pairs(list) do
	    if v == x then
            return true 
        end
	end
	return false
end


function Balatro_Expansion:CalculateTearsUp(currentMaxFireDelay, TearsAdded)
    --big ass math jumpscare (CHAT GPT moment) needed to give a stable tears up (like pisces does)
    local currentTearsPerSecond = 30 / (currentMaxFireDelay + 1)
    local targetTearsPerSecond = currentTearsPerSecond + TearsAdded
    local FireDelayToAdd = currentMaxFireDelay - ((30 / targetTearsPerSecond) - 1)

    return FireDelayToAdd
end

function Balatro_Expansion:CalculateTearsValue(Player)
    return 30 / (Player.MaxFireDelay + 1)
end

function Balatro_Expansion:CalculateMaxFireDelay(Tears)
    return (30 - Tears)/Tears
end

--returns a shuffled version of the given table
function Balatro_Expansion:Shuffle(table, RNG)
    for i = #table, 2, -1 do
        local j = RNG:RandomInt(i) + 1
        table[i], table[j] = table[j], table[i]
    end
    return table
end

---@param HandTable table
---@param card integer
function Balatro_Expansion:AddCardToHand(HandTable, card)
    for index, SlotValue in ipairs(HandTable) do
        if SlotValue == 0 then
            HandTable[index] = card --puts the card in the first found empty slot
            return HandTable
        end
    end
    --no empty slots (puts it as first and shifts all the rest)

    --replaces the first (oldest) with the new one
    HandTable[1] = card
    
    for i = 5, 1, -1 do    --then puts them in order{5,1,2,3,4}
        local Temp = HandTable[i]
        HandTable[i] = HandTable[1]
        HandTable[1] = Temp
    end
    --return HandTable
end

--determine the corresponding poker hand basing on the hand given
function Balatro_Expansion:DeterminePokerHand(HandTable)
    local ValidCardsNumber = 0
    for _,Card in pairs(HandTable) do
        if Card ~= 0 then
            ValidCardsNumber = ValidCardsNumber + 1
        end
    end
    --print(ValidCardsNumber)
    local IsFlush = false
    if ValidCardsNumber >= 4 then --no need to check if there aren't enough cards
        IsFlush = Balatro_Expansion:IsFlush(HandTable)
    end
    local EqualCards = Balatro_Expansion:GetCardValueRepetitions(HandTable)

    if EqualCards == 5 then
        if IsFlush then
            print("flush 5")
            return
        else
            print("5 of a kind")
            return
        end
    elseif EqualCards == 3.5 then
        if IsFlush then
            print("flush house")
            return
        else
            print("full house")
            return
        end
    end
    local IsStraight = false
    local IsRoyal = false

    if ValidCardsNumber >= 4 then --no need to check if there aren't enough cards
        local ValueTable = {}
        for i, v in ipairs(HandTable) do
            if v == 0 then
                ValueTable[i] = 0
            else
                ValueTable[i] = TrinketValues.FullDeck[v].Value
            end
            print(ValueTable[i])
        end
        IsStraight,IsRoyal = Balatro_Expansion:IsStraight(ValueTable)
    end

    if IsFlush and not IsStraight then
        print("flush")
    end

    if IsStraight then
        if IsFlush then
            if IsRoyal then
                print("royal flush")
                return
            else
                print("straight flush")
                return
            end
        else
            print("straight")
            return
        end
    elseif EqualCards == 4 then
        print("4 of a kind")
        return
    elseif EqualCards == 3 then
        print("3 of a kind")
        return
    elseif EqualCards == 2.5 then
        print("two pairs")
        return
    elseif EqualCards == 2 then
        print("pair")
        return
    else
        print("high card")
    end
end

function Balatro_Expansion:IsFlush(HandTable)
    local CardSuits = {0,0,0,0} --spades, hearts, clubs, diamonds

    for _, Card in ipairs(HandTable) do --cycles between all the cards in the used hand
        if Card == 0 then --checks if the card exists
            break
        end
        CardSuits[TrinketValues.FullDeck[Card].Suit] = CardSuits[TrinketValues.FullDeck[Card].Suit] + 1
    end

    for _, SuitNumber in ipairs(CardSuits) do
        if SuitNumber >= 5 then --if 5 cards have the same suit
            return true
        end
    end
    return false
end

function Balatro_Expansion:IsStraight(HandTable)

    table.sort(HandTable, function(a,b) --sorts the hand to make it easier to detect straights
        --a = TrinketValues.FullDeck[a].Value
        --b = TrinketValues.FullDeck[b].Value
        if (a < b and a ~= 0) or b == 0 then
            return true
        end
        return false
    end)

    local LowestValue = TrinketValues.FullDeck[HandTable[1]].Value
    local ValueToKeepStreak = LowestValue + 1
    local StraightStreak = 1
    for _, Card in ipairs(HandTable) do --cycles between all the cards in the used hand
        if Card == 0 then --checks if the card exists
            break
        end
        if TrinketValues.FullDeck[Card].Value == ValueToKeepStreak  then
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

function Balatro_Expansion:GetCardValueRepetitions(HandTable)

    local CardValues = {0,0,0,0,0,0,0,0,0,0,0,0,0} -- all the card's possible values

    --PAIRS CHECK
    for _, Card in ipairs(HandTable) do --cycles between all the cards in the used hand
        if Card ~= 0 then --checks if the card exists
            CardValues[TrinketValues.FullDeck[Card].Value] = CardValues[TrinketValues.FullDeck[Card].Value] + 1
        end
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
