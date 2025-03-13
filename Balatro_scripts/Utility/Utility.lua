local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()
local sfx = SFXManager()

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

function mod:GetValueIndex(Table, Value, Stop)
    local WantedIndexes = {}
    for k, v in pairs(Table) do
        if v == Value then
            if Stop then
                return k
            end
            table.insert(WantedIndexes, k)
        end
    end
    if Stop then --if you got here with stop then didn't find anything
        return 0 --prob won't give problems
    end
    return WantedIndexes
end

function mod:GetValueRepetitions(Table, Value)
    local Repeat = 0
    for _,v in pairs(Table) do
        if v == Value then
            Repeat = Repeat + 1
        end
    end
    return Repeat
end


function mod:GetMax(Table)
    local Result = 0
    for _,v in ipairs(Table) do
        Result = math.max(Result,v)
    end
    return Result
end

---@param Table tablelib
---@param RNG RNG
---@param Phantom boolean?
function mod:GetRandom(Table, RNG, Phantom)
    local Possibilities = {}
    for _,v in pairs(Table) do
        table.insert(Possibilities, v)
    end
    if Phantom then
        return Possibilities[RNG:PhantomInt(#Possibilities) + 1] -- +1 is to set it from 1 to #possibilities (sill no PhantomInt(min, max))
    else
        return Possibilities[RNG:RandomInt(1,#Possibilities)]
    end
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

--adds a value in many ways and returns the position it got put in
---@param Table table
---@param CanBeEmpty boolean?
---@param Shift boolean?
function mod:AddValueToTable(Table, Value, CanBeEmpty, Shift, Pos)

    if CanBeEmpty then
        for i,v in ipairs(Table) do
            if v == 0 then
                Table[i] = Value
                return i
            end
        end
    end

    local minI
    for i,_ in ipairs(Table) do
        minI = i
        break
    end
    
    if Shift then --{1,2,3,4,5} ==> {6,1,2,3,4}
        
        table.remove(Table)
        table.insert(Table, minI, Value)
        return minI
    else
        Pos = Pos or minI
        Table[Pos] = Value
        return Pos
    end
    --[[
    for i=1,#HandTable-1 do    --puts them in order{2,3,4,5,1}
        local Temp = HandTable[i]
        HandTable[i] = HandTable[i+1]
        HandTable[i+1] = Temp
    end
    
    --replaces 1 (oldest) with the new one
    HandTable[#HandTable] = card
    --return HandTable]]--
end

function mod:FloorHasShopOrTreasure()
    --DETERMINATION FOR THE PRESENCE OF TRESURES ROOMS/SHOPS--
    --FALSE = NO shops/treasures
    --TRUE = AVAILABLE Shops/treasures
    local Available = {}
    Available.Treasure = true
    Available.Shop = true

    local Level = Game:GetLevel()
    mod.Saved.Other.Labyrinth = 1
    if Level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
        mod.Saved.Jimbo.Labyrinth = 2
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

function mod:Lerp(a, b, t)
    t = mod:Clamp(math.abs(t), 1,0)
    return a + (b - a) * t
end

function mod:CoolLerp(a, b, t)
    t = mod:Clamp(math.abs(t), 1,0)

    t = t/(t^2 - 0.4*t + 0.4)

    return a + (b - a) * t
end

function mod:VectorLerp(vec1, vec2, percent)
    percent = mod:Clamp(math.abs(percent), 1,0)
    return vec1 * (1 - percent) + vec2 * percent
end

function mod:CoolVectorLerp(vec1, vec2, percent)
    percent = mod:Clamp(math.abs(percent), 1,0)

    --percent = percent + math.sin(math.rad(percent*180)) * 0.6
    percent = percent/(percent^2 - 0.4*percent + 0.4)

    return vec1 * (1 - percent) + vec2 * percent
end

function mod:Clamp(Num,Max,Min)
    return math.max(Min,math.min(Num, Max))
end

function mod:HeadDirectionToString(Vector) --ty for the base sheriff

    --local Angle = ((Vector:GetAngleDegrees() + 22.5) // 45) * 45 --9 directions angle
    local Angle = ((Vector:GetAngleDegrees() + 45) // 90) * 90

    if Angle == 0 then
        return "_right"
    elseif Angle == 90 then
        return "_down"
    elseif Angle == 180 or Angle == -180 then
        return "_left"
    elseif Angle == -90 then
        return "_up"
    end

    return ""
end

-------------JIMBO FUNCTIONS------------
---------------------------------------

function mod:SubstituteCards(ChosenTable)
    for i = #ChosenTable, 1,-1 do
        if ChosenTable[i] then
            --first adds the ammount of new cards needed
            table.insert(mod.Saved.Jimbo.CurrentHand,#mod.Saved.Jimbo.CurrentHand+1, mod.Saved.Jimbo.DeckPointer)
            mod.Saved.Jimbo.DeckPointer = mod.Saved.Jimbo.DeckPointer +1
            --then removes the selected cards 
            table.remove(mod.Saved.Jimbo.CurrentHand,i)
        end
    end
    
end

--determines the corresponding poker hand basing on the hand given
function mod:DeterminePokerHand()
    local ElegibleHandTypes = {mod.HandTypes.NONE}

    
    local RealHand = {}
    for i,_ in ipairs(mod.Saved.Jimbo.CurrentHand) do
        if mod.CardSelectionParams.SelectedCards[i] then
            table.insert(RealHand, mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[i]])
        end
    end

    if #RealHand > 0 then
        table.insert(ElegibleHandTypes, mod.HandTypes.HIGH_CARD)
    else
        return ElegibleHandTypes --why bother if there nothing selected
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
    if IsFlush then
        table.insert(ElegibleHandTypes,mod.HandTypes.FIVE_FLUSH)
    end
    table.insert(ElegibleHandTypes,mod.HandTypes.FIVE)

    --IN THE END THERE WILL BE A TABLE CONTAINING ALL THE POSSIBLE HAND TYPES
    --THAT THE USED ONE CONTAINS, MAKING IT EASIER FOR JOKERS TO ACTIVATE CORRECTLY
    --BUT ONLY THE "HIGHEST" ONE WILL BE CONSIDERED AS SCORED

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
    
        CardValues[mod.Saved.Jimbo.FullDeck[card].Value] = CardValues[mod.Saved.Jimbo.FullDeck[card].Value] + 1
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


function mod:GetActualCardValue(Value)
    if Value >=10 then
        return 10
    elseif Value == 1 then
        return 11
    end
    return Value
end

function mod:JimboHasTrinket(Player,Trinket)
    for _,v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if v == Trinket then
            return true
        end
    end
    return false
end

function mod:GetJimboJokerIndex(Player, Joker)
    local Indexes = {}

    for i,v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
        if v == Joker then
            table.insert(Indexes, i)
        elseif v == TrinketType.TRINKET_BLUEPRINT or v == TrinketType.TRINKET_BRAINSTORM   then

            if mod.Saved.Jimbo.Inventory.Jokers[mod.Saved.Jimbo.Progress.Inventory[i]] == Joker then
                table.insert(Indexes, i)
            end
        end
    end
    return Indexes
end

function mod:IsSuit(Player, Suit, Enhancement, WantedSuit, MakeTable)
    if MakeTable then --in this case makes a table telling the equivalent suits

        if Enhancement == mod.Enhancement.STONE then
            return {} --no suit
        elseif Enhancement == mod.Enhancement.WILD then
            return {1,2,3,4} --every suit is good
        end
        local GoodSuits = {} 

        table.insert(GoodSuits, Suit)
        
        if (mod:JimboHasTrinket(Player, TrinketType.TRINKET_SMEARED_JOKER)) then
            --in this case spades/clubs and Hearts/diamonds are considered the same

            local Jump = 2 --distance SPADE/HEART => CLUB/DIAMOND

            if WantedSuit > 2 then  --the suits are in order: (SPADE,HEART,CLUB,DIAMOND)
                Jump = -2 --distance CLUB/DIAMOND => SPADE/HEART
            end
            table.insert(GoodSuits, WantedSuit + Jump)
            
        end
        return GoodSuits

    else --in this case only says true or false if equal
        if Enhancement == mod.Enhancement.STONE then
            return false
        
        elseif Suit == WantedSuit or Enhancement == mod.Enhancement.WILD then
            return true
        end
        
        if (mod:JimboHasTrinket(Player, TrinketType.TRINKET_SMEARED_JOKER)) then
            --in this case spades/clubs and Hearts/diamonds are considered the same
            local Jump = 2 --distance SPADE/HEART => CLUB/DIAMOND
            if WantedSuit > 2 then  --the suits are in order: (SPADE,HEART,CLUB,DIAMOND)
                Jump = -2 --distance CLUB/DIAMOND => SPADE/HEART
            end
            if Suit == WantedSuit + Jump then
                return true
            end
        end
        return false
    end
end

function mod:TryGamble(Player, RNG, Chance)
    --Chance = Chance * (2 ^ mod:GetValueRepetitions(mod.Saved.Jimbo.Inventory, TrinketType.TRINKET_OOPS_6) 
    if RNG then
        if RNG:RandomFloat() < Chance then
            return true
        end
    else
        if math.random() < Chance then
            return true
        end
    end
    return false
end

---@param SellSlot integer?
function mod:GetJokerCost(Joker, SellSlot)
    --removes ! from the customtag (see items.xml) 
    local numstring = string.gsub(ItemsConfig:GetTrinket(Joker):GetCustomTags()[1],"%!","")

    local Cost = tonumber(numstring)
    if SellSlot then --also tells if you want the buy/sell value as the return
    
        Cost = math.floor((Cost + mod.Saved.Jimbo.Inventory.Editions[SellSlot]) / 2)
        if Joker == TrinketType.TRINKET_EGG then
            Cost = mod.Saved.Jimbo.Progress.Inventory[SellSlot]
        end
    else
        --print(tonumber(string.gsub(ItemsConfig:GetTrinket(Joker):GetCustomTags()[1],"%!",""),2))
        local EdValue = mod.Saved.Jimbo.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Joker).Name] or 0
        
        Cost = Cost + EdValue
    end

    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Liquidation) then --50% off
        Cost = Cost * 0.5
    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Clearance) then --25% off
        Cost = Cost * 0.75
    end
    Cost = math.floor(Cost) --rounds it down 
    Cost = math.max(Cost, 1)

    return Cost
end

function mod:GetJokerRarity(Joker)
    return string.gsub(ItemsConfig:GetTrinket(Joker):GetCustomTags()[3],"%?","")
end

function mod:AddJimboInventorySlots(Player, Amount)
    mod.Saved.Jimbo.InventorySize = mod.Saved.Jimbo.InventorySize + Amount
    if Amount >= 0 then
        for i=1,Amount do --just adds empty spaces to fill
            table.insert(mod.Saved.Jimbo.Inventory.Jokers, 0)
            table.insert(mod.Saved.Jimbo.Inventory.Editions, 0)
        end
    else
        for i,Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
            if Joker == 0 then --searches for an empty slot to remove
                table.remove(mod.Saved.Jimbo.Inventory.Jokers, i)
                table.remove(mod.Saved.Jimbo.Inventory.Editions, i)
                return
            end
        end

        Isaac.RunCallback("JOKER_SOLD", Player, mod.Saved.Jimbo.Inventory.Jokers[1], 1)
        table.remove(mod.Saved.Jimbo.Inventory.Jokers, 1) --if none are present then sell the first joker
        table.remove(mod.Saved.Jimbo.Inventory.Editions, 1)
    end
end

function mod:ChangeJimboHandSize(Player, Amount)
    
    if Amount >= 0 then
        for i=1,Amount do --just adds empty spaces to fill
            table.insert(mod.Saved.Jimbo.CurrentHand,1, mod.Saved.Jimbo.DeckPointer)
            mod.Saved.Jimbo.DeckPointer = mod.Saved.Jimbo.DeckPointer + 1
        end
        mod.Saved.Jimbo.HandSize = mod.Saved.Jimbo.HandSize + Amount
    else
        for i=-1,Amount, -1 do
            if mod.Saved.Jimbo.HandSize == 1 then
                return
            end
            table.remove(mod.Saved.Jimbo.CurrentHand, mod.Saved.Jimbo.HandSize)
            mod.Saved.Jimbo.HandSize = mod.Saved.Jimbo.HandSize - 1
        end
    end
end


function mod:SpecialCardToFrame(CardID)
    if CardID <= Card.CARD_WORLD then --tarot cards
        return CardID
    elseif CardID >= mod.Planets.PLUTO and CardID <= mod.Planets.SUN then --planet cards
        return 23 + CardID - mod.Planets.PLUTO
    end
    return 36 + CardID - mod.Spectrals.FAMILIAR --spectral cards
end

function mod:FrameToSpecialCard(Frame)
    if Frame <= Card.CARD_WORLD then --tarot cards
        return Frame
    elseif Frame > Card.CARD_WORLD and Frame <= 35 then --planet cards
        return Frame + mod.Planets.PLUTO - 23
    end
    return Frame + mod.Spectrals.FAMILIAR - 36 --spectral cards
end

function mod:SellJoker(Player, Trinket, Slot)
    mod.Saved.Jimbo.Inventory.Jokers[Slot] = 0
    local SellValue
    if Trinket == TrinketType.TRINKET_EGG then --egg holds its sell value in its progress
        
        SellValue = mod.Saved.Jimbo.Progress.Inventory[Slot]
    else
        SellValue = mod:GetJokerCost(Trinket, Slot)
    end
    

    if mod.Saved.Jimbo.Inventory.Editions[Slot] == mod.Edition.NEGATIVE then
        --selling a negative joker reduces your inventory size
        mod:AddJimboInventorySlots(Player, -1)
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
        mod.SelectionParams.Index = mod.SelectionParams.Index - 1
    end

    for i=1, SellValue do
        Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,Player.Position,RandomVector()*2,Player,CoinSubType.COIN_PENNY,RNG():GetSeed())
    end

    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..SellValue.."$")

    Isaac.RunCallback("INEVNTORY_CHANGE", Player)
    Isaac.RunCallback("JOKER_SOLD", Player, Trinket, Slot)
end


local JeditionChance = {0.02, 0.034, 0.037, 0.003}
function mod:RandomJoker(Rng, Exeptions, PlaySound, ForcedRarity)
    Exeptions = Exeptions or {}
    local Trinket = {}
    local Possibilities = {}

    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then
            for i, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if Joker ~= 0 then
                    Exeptions[#Exeptions+1] = Joker
                end
            end
        end
    end

    for i, Trinket in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        
        Exeptions[#Exeptions+1] = Trinket
    end


    if ForcedRarity then
        table.move(mod.Trinkets[ForcedRarity], 1, #mod.Trinkets[ForcedRarity], 1, Possibilities)
    else
 
        local RarityRoll = Rng:RandomFloat()
        if RarityRoll < 0.75 then

            table.move(mod.Trinkets.common, 1, #mod.Trinkets.common, 1, Possibilities)
        elseif RarityRoll < 0.95 then

            table.move(mod.Trinkets.uncommon, 1, #mod.Trinkets.uncommon, 1, Possibilities)
        else

            table.move(mod.Trinkets.rare, 1, #mod.Trinkets.rare, 1, Possibilities)
        end
    end

    repeat

        if not next(Possibilities) then
            Trinket.Joker = TrinketType.TRINKET_JOKER --default trinket
            break
        end

        Trinket.Joker = mod:GetRandom(Possibilities, Rng)

        ---@diagnostic disable-next-line: param-type-mismatch
        table.remove(Possibilities, mod:GetValueIndex(Possibilities, Trinket.Joker, true))

    until not mod:Contained(Exeptions, Trinket.Joker) --basic criteria
          and (Trinket.Joker ~= TrinketType.TRINKET_GROS_MICHAEL or not mod.Saved.Jimbo.MichelDestroyed) --if it's michel, check if it was destroyed
          and (Trinket.Joker ~= TrinketType.TRINKET_CAVENDISH or mod.Saved.Jimbo.MichelDestroyed) --if it's cavendish do the same but opposite
    
    local EdMult = 1

    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Hone) then
        EdMult = EdMult * 2
    end
    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.GlowUp) then
        EdMult = EdMult * 2
    end

    local EdRoll = Rng:RandomFloat()
    if EdRoll <= JeditionChance[mod.Edition.FOIL] * EdMult then --foil chance
        Trinket.Edition = mod.Edition.FOIL
        if PlaySound then
            sfx:Play(mod.Sounds.FOIL)
        end

    elseif EdRoll <= JeditionChance[mod.Edition.HOLOGRAPHIC] * EdMult then --holo chance
        Trinket.Edition = mod.Edition.HOLOGRAPHIC
        if PlaySound then
            sfx:Play(mod.Sounds.HOLO)
        end

    elseif EdRoll <= JeditionChance[mod.Edition.POLYCROME] * EdMult then --poly chance
        Trinket.Edition = mod.Edition.POLYCROME
        if PlaySound then
            sfx:Play(mod.Sounds.POLY)
        end

    elseif EdRoll <= JeditionChance[mod.Edition.POLYCROME] * EdMult + JeditionChance[mod.Edition.NEGATIVE] then --negative chance
        Trinket.Edition = mod.Edition.NEGATIVE
        if PlaySound then
            sfx:Play(mod.Sounds.NEGATIVE)
        end

    else
        Trinket.Edition = mod.Edition.BASE
    end

    return Trinket
end


function mod:CardValueToName(Value, IsEID)

    local String

    if Value == 1 then
        String = "Ace"
    elseif Value == 11 then
        String = "Jack"
    elseif Value == 12 then
        String = "Queen"
    elseif Value == 13 then
        String = "King"
    else
        String = tostring(Value)
    end

    if IsEID then
        String = "{{ColorYellorange}}"..String.."{{CR}}"
    end

    return String

end


function mod:CardSuitToName(Suit, IsEID)

    if Suit == mod.Suits.Spade then
        if IsEID then
            return "{{ColorGray}}Spades{{CR}}"
        end
        return "Spades"
    elseif Suit == mod.Suits.Heart then
        if IsEID then
            return "{{ColorRed}}Hearts{{CR}}"
        end
        return "Hearts"
    elseif Suit == mod.Suits.Club then
        if IsEID then
            return "{{ColorChips}}Clubs{{CR}}"
        end
        return "Clubs"
    elseif Suit == mod.Suits.Diamond then
        if IsEID then
            return "{{ColorYellorange}}Diamonds{{CR}}"
        end
        return "Spades"
    end

end