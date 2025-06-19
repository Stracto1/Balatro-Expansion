---@diagnostic disable: need-check-nil, param-type-mismatch
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()
local sfx = SFXManager()
local Level = Game:GetLevel()

local RoomHolderMode = {ANY = -1, HOSTILE = 0} --idk but this seems like it after trying ~20 room generations

local MAX_SEED_VALUE = 2^32 - 1

local DoorSides = {}
DoorSides.LEFT = 0
DoorSides.UP = 1
DoorSides.RIGHT = 2
DoorSides.DOWN = 3

local EditionValue = {[mod.Edition.BASE] = 0,
                      [mod.Edition.FOIL] = 2,
                      [mod.Edition.HOLOGRAPHIC] = 3,
                      [mod.Edition.POLYCROME] = 5,
                      [mod.Edition.NEGATIVE] = 5}


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
        return false --prob won't give problems
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
    local Result = math.mininteger
    local ResultPosition = 1
    for i,v in ipairs(Table) do
        if v > Result then
            Result = v
            ResultPosition = i
        end
    end
    return Result, ResultPosition
end


function mod:GetBitMaskMax(Mask)

    local MaxValue = 0

    for i = 1, 64, 1 do
        if Mask < 2^i then
            
            MaxValue = 2^(i-1)
            break
        end
    end

    return MaxValue
end

---@param Table tablelib
---@param RNG RNG
---@param Phantom boolean?
function mod:GetRandom(Table, RNG, Phantom)

    if not next(Table) then
        return --don't bother if table is empty
    end

    local Possibilities = {}
    for _,v in pairs(Table) do
        table.insert(Possibilities, v)
    end
    if RNG then 
        if Phantom then
            return Possibilities[RNG:PhantomInt(#Possibilities) + 1] -- +1 is to set it from 1 to #possibilities (sill no PhantomInt(min, max))
        else
            return Possibilities[RNG:RandomInt(1,#Possibilities)]
        end
    else
        return Possibilities[math.random(1,#Possibilities)]
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
            if v == 0 then --works for what the mod uses, not really optimal otherwise i guess
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
    --[[
    mod.Saved.Other.Labyrinth = 1
    if Level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
        mod.Saved.Player[PIndex].Labyrinth = 2
    end]]
    if Level:IsAscent() then
        Available.Treasure = false
        Available.Shop = false
        return Available
    end
    local Greed = Game:IsGreedMode()
    local Stage = Level:GetAbsoluteStage()
    local LevelName = Level:GetName()

    if Stage == LevelStage.STAGE4_1 and not Greed  then
        if not PlayerManager.AnyoneHasTrinket(mod.Jokers.BLOODY_CROWN) then
            Available.Treasure = false
        end
        if not PlayerManager.AnyoneHasTrinket(mod.Jokers.SILVER_DOLLAR) then
            Available.Shop = false
        end
    elseif LevelName == "Sheol" and not Greed then
        if not PlayerManager.AnyoneHasTrinket(mod.Jokers.WICKED_CROWN) then
            Available.Treasure = false
            Available.Shop = false
        end

    elseif LevelName == "Cathedral" then
        if not PlayerManager.AnyoneHasTrinket(mod.Jokers.HOLY_CROWN) then
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

function mod:ExponentLerp(a, b, t, exp)
    t = mod:Clamp(math.abs(t), 1,0)
    exp = exp or 1

    return a + (b - a) * t^exp
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

function mod:GetSignString(Num)

    if Num >= 0 then
        return "+"
    else
        return ""
    end
end

function mod:CanTileBeBlocked(IndexToDestroy)

    local Room = Game:GetRoom()
    local CanTileBeBlocked = true

    local StartingGridPath = Room:GetGridPath(IndexToDestroy)
    Room:SetGridPath(IndexToDestroy, 1000)

    --the idea is spawning an entity on a door and seeing if it can travel to every other door

    local DoorPositions = {}

    for Slot = DoorSlot.LEFT0 , DoorSlot.NUM_DOOR_SLOTS-1 do

        local Door = Room:GetDoor(Slot)
        if Door then

            local Position = Door.Position
            local DoorSide = Slot % 4

            if DoorSide == DoorSides.LEFT then
                
                Position = Position + Vector(40,0)
            elseif DoorSide == DoorSides.UP then
                Position = Position + Vector(0,40)
            elseif DoorSide == DoorSides.RIGHT then
                Position = Position + Vector(-40,0)
            elseif DoorSide == DoorSides.DOWN then
                Position = Position + Vector(0,-40)
            end

            DoorPositions[#DoorPositions+1] = Position
        end
    end

    local PathfinderSlave = Game:Spawn(mod.Entities.BALATRO_TYPE, mod.Entities.PATH_SLAVE, DoorPositions[1],
                                       Vector.Zero, nil, 0, 1):ToNPC()

    local Pathfinder = PathfinderSlave.Pathfinder

    for i = 2, #DoorPositions do
        
        if not Pathfinder:HasPathToPos(DoorPositions[i], true) --if one door becomes unreachable, can't destroy
           or IndexToDestroy == Room:GetGridIndex(DoorPositions[i]) then 
            
            CanTileBeBlocked = false
            break
        end
    end

    Room:SetGridPath(IndexToDestroy, StartingGridPath)
    PathfinderSlave:Remove()

    return CanTileBeBlocked

end

local function IsSpecialBossFight(_, CurrentBossType)

    local Room = Game:GetRoom()
    local Level = Game:GetLevel()

    local Type = CurrentBossType or Room:GetBossID()

    mod.Saved.IsSpecialBossFight = mod.Saved.IsSpecialBossFight
                                   or (mod:Contained(mod.SPECIAL_BOSSES, CurrentBossType)
                                   or Level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_NO_WALLS ~= 0)


end
mod:AddCallback(ModCallbacks.MC_POST_BOSS_INTRO_SHOW, IsSpecialBossFight)
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, IsSpecialBossFight)


local function ResetSpecialBossFight()

    mod.Saved.IsSpecialBossFight = false
end
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, ResetSpecialBossFight)


-------------JIMBO FUNCTIONS------------
---------------------------------------



--determines the corresponding poker hand basing on the hand given
function mod:DeterminePokerHand(Player)

    local ElegibleHandTypes = mod.HandTypes.NONE

    local PIndex = Player:GetData().TruePlayerIndex

    local RealHand = {}

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then

        for i,Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            if Selected then
                table.insert(RealHand, mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]])
            end
        end
    else
        for _,index in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            table.insert(RealHand, mod.Saved.Player[PIndex].FullDeck[index])

        end
    end

    if #RealHand > 0 then --shoud never happen but you never know...
        ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.HIGH_CARD
    else
        return ElegibleHandTypes --why bother if there's nothing
    end

    local ValidCardsNumber = #RealHand

    --print(ValidCardsNumber)
    local IsFlush = false
    local IsStraight = false
    local IsRoyal = false

    if ValidCardsNumber >= 4 then --no need to check if there aren't enough cards
        IsFlush = mod:IsFlush(Player, RealHand)
        IsStraight,IsRoyal = mod:IsStraight(Player, RealHand)
    
    end

    local EqualCards = mod:GetCardValueRepetitions(Player, RealHand)

    --general flush check
    if IsFlush then
        ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.FLUSH
    end
    --straight check
    if IsStraight then
        ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.STRAIGHT
        if IsRoyal then
            ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.STRAIGHT_FLUSH
            ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.ROYAL_FLUSH
        elseif IsFlush then
            ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.ROYAL_FLUSH
        end
    end

    ------repetition based hands checks-------
    if EqualCards < 2 then --not even a pair (lame)
       return ElegibleHandTypes
    end
    --at least a pair
    ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.PAIR

    if EqualCards < 3 then --not a three of a kind
        if EqualCards == 2.5 then --in that case makes sure if it's a two pair
            ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.TWO_PAIR
        end
        return ElegibleHandTypes
    end
    --at least a three of a kind
    ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.THREE

    if EqualCards < 4 then
        if EqualCards == 3.5 then
            if IsFlush then
                ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.FLUSH_HOUSE
            end
            ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.FULL_HOUSE
        end
        return ElegibleHandTypes
    end
     --at least a four of a kind
     ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.FOUR

    if EqualCards < 5 then 
        return ElegibleHandTypes
    end
    --a five of a kind
    if IsFlush then
        ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.FIVE_FLUSH
    end
    ElegibleHandTypes = ElegibleHandTypes + mod.HandTypes.FIVE

    --IN THE END THERE WILL BE A BITMASK CONTAINING ALL THE POSSIBLE HAND TYPES
    --THAT THE USED ONE CONTAINS, MAKING IT EASIER FOR JOKERS TO ACTIVATE CORRECTLY
    --BUT ONLY THE "HIGHEST" ONE WILL BE CONSIDERED AS SCORED

    return ElegibleHandTypes
end

function mod:IsFlush(Player, HandTable)
    local CardSuits = {0,0,0,0} --counts how many of each suit there are

    local HasFourFingers = mod:JimboHasTrinket(Player, mod.Jokers.FOUR_FINGER)

    for _, Card in ipairs(HandTable) do --cycles between all the cards in the used hand
        if Card.Enhancement == mod.Enhancement.WILD then
            for i = 1, 4 do
                CardSuits[i] = CardSuits[i] + 1
            end
        elseif Card.Enhancement ~= mod.Enhancement.STONE then
            CardSuits[Card.Suit] = CardSuits[Card.Suit] + 1
        end
    end

    for _, SuitNumber in ipairs(CardSuits) do
        if SuitNumber >= 5 or (HasFourFingers and SuitNumber >= 4) then --if 5 cards have the same suit
            return true
        end
    end
    return false
end

function mod:IsStraight(Player, HandTable)

    local ValueTable = {} --the value of every card
    for i, card in ipairs(HandTable) do
        
        if card.Enhancement ~= mod.Enhancement.STONE then

            ValueTable[i] = card.Value
        end
    end

    --table setup
    table.sort(ValueTable) --makes things easier
    for _, CardValue in ipairs(ValueTable) do --adds a copy of all the aces as 14 (after the kings)
        if CardValue == 1 then
            table.insert(ValueTable, 14)
        else
            break
        end
    end

    local HasFourFingers = mod:JimboHasTrinket(Player, mod.Jokers.FOUR_FINGER)
    local HasShortcut = mod:JimboHasTrinket(Player, mod.Jokers.SHORTCUT)

    local LowestValue = ValueTable[1]
    local ValueToKeepStreak = LowestValue + 1
    local StraightStreak = 1
    for _, CardValue in ipairs(ValueTable) do --cycles between all the cards in the used hand

        if CardValue == ValueToKeepStreak then
            StraightStreak = StraightStreak + 1

            if ValueToKeepStreak == 14 then --14 is the ace after a king 
                break
            end

            ValueToKeepStreak = ValueToKeepStreak + 1

        elseif HasShortcut and CardValue == ValueToKeepStreak + 1 then --with shortcut a 1 value gap is good

            StraightStreak = StraightStreak + 1

            if ValueToKeepStreak == 13 then --14 is the ace after a king 
                break
            end

            ValueToKeepStreak = ValueToKeepStreak + 2
        else
            StraightStreak = 1 --reset the streak
            ValueToKeepStreak = CardValue + 1
        end

    end

    return StraightStreak >= 5 or (HasFourFingers and StraightStreak >= 4), LowestValue >= 10
end

function mod:GetCardValueRepetitions(Player, HandTable)

    local CardValues = {} -- counts how many of each rank there are

    for _, card in ipairs(HandTable) do --cycles between all the cards in the given hand
    
        if card.Enhancement ~= mod.Enhancement.STONE then
            CardValues[card.Value] = CardValues[card.Value] and (CardValues[card.Value] + 1) or 1
        end
    end

    local PairPresent = false --tells if there is a pair for a possible full house/two pairs
    local ToaKPresent = false --tells if there is a ToaK for a possible full house

    for _, ValueNum in pairs(CardValues) do

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


function mod:GetScoringCards(Player, HandType)

    local PIndex = Player:GetData().TruePlayerIndex

    local PlayerHand = {}
    for i,Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        if Selected then
            table.insert(PlayerHand, mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]])
        end
    end

    if mod:JimboHasTrinket(Player, mod.Jokers.SPLASH) then
        print("all scoring!")
        return math.maxinteger
    end

    local ReturnMask = 0

    if HandType == mod.HandTypes.HIGH_CARD then
        
        local MaxValueIndex = 1
        local MaxValue = 1

        for i,Card in ipairs(PlayerHand) do

            
            if Card.Enhancement == mod.Enhancement.STONE then
            elseif Card.Value > MaxValue then
                
                MaxValue = Card.Value
                MaxValueIndex = i

            elseif Card.Value == 1 then
                MaxValue = Card.Value
                MaxValueIndex = i
                break
            end
        end

        ReturnMask = 2^(MaxValueIndex-1)

    elseif HandType == mod.HandTypes.PAIR then

        local CardValues = {}
        local PairValue = 0

        for i,Card in ipairs(PlayerHand) do

            if mod:Contained(CardValues, Card.Value) then
                PairValue = Card.Value
                break

            elseif Card.Enhancement ~= mod.Enhancement.STONE then
                CardValues[#CardValues+1] = Card.Value
            end

        end

        for i,Card in ipairs(PlayerHand) do

            if Card.Value == PairValue then

                ReturnMask = ReturnMask | 2^(i-1)
            end
        end

    elseif HandType == mod.HandTypes.TWO_PAIR then
        
        local PairValue = 0

        for i=1, 2 do
            local CardValues = {}

            for i,Card in ipairs(PlayerHand) do

                if mod:Contained(CardValues, Card.Value) and Card.Value ~= PairValue then
                    PairValue = Card.Value
                    break

                elseif Card.Enhancement ~= mod.Enhancement.STONE then
                    CardValues[#CardValues+1] = Card.Value
                end

            end

            for i,Card in ipairs(PlayerHand) do

                if Card.Value == PairValue then

                    ReturnMask = ReturnMask | 2^(i-1)
                end
            end
        end

    elseif HandType == mod.HandTypes.THREE then

        local CardValues = {}
        local RepeatedValue = 0

        for i,Card in ipairs(PlayerHand) do

            if mod:GetValueRepetitions(CardValues, Card.Value) == 2 then
                RepeatedValue = Card.Value
                break

            elseif Card.Enhancement ~= mod.Enhancement.STONE then
                CardValues[#CardValues+1] = Card.Value
            end
            
        end

        for i,Card in ipairs(PlayerHand) do

            if Card.Value == RepeatedValue then

                ReturnMask = ReturnMask | 2^(i-1)
            end
        end

    elseif HandType == mod.HandTypes.FOUR then

        local CardValues = {}
        local RepeatedValue = 0

        for i,Card in ipairs(PlayerHand) do

            if mod:GetValueRepetitions(CardValues, Card.Value) == 3 then
                RepeatedValue = Card.Value
                break

            elseif Card.Enhancement ~= mod.Enhancement.STONE then
                CardValues[#CardValues+1] = Card.Value
            end

            
        end

        for i,Card in ipairs(PlayerHand) do

            if Card.Value == RepeatedValue then

                ReturnMask = ReturnMask | 2^(i-1)
            end
        end

    elseif HandType == mod.HandTypes.FLUSH and mod:JimboHasTrinket(Player, mod.Jokers.FOUR_FINGER) then

        local CardSuits = {0,0,0,0} --counts how many of each suit there are

        for _, Card in ipairs(PlayerHand) do
            if Card.Enhancement == mod.Enhancement.WILD then
                for i = 1, 4 do
                    CardSuits[i] = CardSuits[i] + 1
                end
            elseif Card.Enhancement ~= mod.Enhancement.STONE then
                CardSuits[Card.Suit] = CardSuits[Card.Suit] + 1
            end
        end

        local _,MaxSuit = mod:GetMax(CardSuits)

        for i, Card in ipairs(PlayerHand) do

            if mod:IsSuit(Player, Card, MaxSuit) then

                ReturnMask = ReturnMask | 2^(i-1)
            end
        end


    elseif HandType == mod.HandTypes.STRAIGHT and mod:JimboHasTrinket(Player, mod.Jokers.FOUR_FINGER) then

        local ValueTable = {} --the value of every card
        for i, card in ipairs(PlayerHand) do
            if card.Enhancement ~= mod.Enhancement.STONE then

                ValueTable[i] = card.Value
            end
        end

        --table setup
        table.sort(ValueTable) --makes things easier
        for _, CardValue in ipairs(ValueTable) do --adds a copy of all the aces as 14 (after the kings)
            if CardValue == 1 then
                table.insert(ValueTable, 14)
            else
                break
            end
        end

        local HasShortcut = mod:JimboHasTrinket(Player, mod.Jokers.SHORTCUT)


        local StreakStart = 1

        local ValueToKeepStreak = ValueTable[1] + 1
        local StraightStreak = 1

        for i, CardValue in ipairs(ValueTable) do --cycles between all the cards in the used hand

            if CardValue == ValueToKeepStreak then
                StraightStreak = StraightStreak + 1

                if ValueToKeepStreak == 14 then --14 is the ace after a king 
                    break
                end

                ValueToKeepStreak = ValueToKeepStreak + 1

            elseif HasShortcut and CardValue == ValueToKeepStreak + 1 then --with shortcut a 1 value gap is good

                StraightStreak = StraightStreak + 1

                if ValueToKeepStreak == 13 then --14 is the ace after a king 
                    break
                end

                ValueToKeepStreak = ValueToKeepStreak + 2

            else --logically this can only happen once since at least 4/5 cards need to be compatible
            
                if StraightStreak < 4 then --reset and continue
                    StraightStreak = 1 
                    ValueToKeepStreak = CardValue + 1
                    StreaksStart = i

                else --stop
                    break
                end  
            end
        end

        for i = StreakStart, StraightStreak do
            
            ReturnMask = ReturnMask | 2^(i-1)
        end

        
    elseif (HandType == mod.HandTypes.STRAIGHT_FLUSH or HandType == mod.HandTypes.ROYAL_FLUSH)
           and mod:JimboHasTrinket(Player, mod.Jokers.FOUR_FINGER) then

        --puts together the flush and stright algorithms

        -----FLUSH------

        local CardSuits = {0,0,0,0} --counts how many of each suit there are

        for _, Card in ipairs(PlayerHand) do
            if Card.Enhancement == mod.Enhancement.WILD then
                for i = 1, 4 do
                    CardSuits[i] = CardSuits[i] + 1
                end
            elseif Card.Enhancement ~= mod.Enhancement.STONE then
                CardSuits[Card.Suit] = CardSuits[Card.Suit] + 1
            end
        end

        local _,MaxSuit = mod:GetMax(CardSuits)

        for i, Card in ipairs(PlayerHand) do

            if mod:IsSuit(Player, Card, MaxSuit) then

                ReturnMask = ReturnMask | 2^(i-1)
            end
        end


        -----STRAIGHT------

        local ValueTable = {} --the value of every card
        for i, card in ipairs(PlayerHand) do
            if card.Enhancement ~= mod.Enhancement.STONE then

                ValueTable[i] = card.Value
            end
        end

        --table setup
        table.sort(ValueTable) --makes things easier
        for _, CardValue in ipairs(ValueTable) do --adds a copy of all the aces as 14 (after the kings)
            if CardValue == 1 then
                table.insert(ValueTable, 14)
            else
                break
            end
        end



        local HasShortcut = mod:JimboHasTrinket(Player, mod.Jokers.SHORTCUT)

        local StreakStart = 1

        local ValueToKeepStreak = ValueTable[1] + 1
        local StraightStreak = 1

        for i, CardValue in ipairs(ValueTable) do --cycles between all the cards in the used hand

            if CardValue == ValueToKeepStreak then
                StraightStreak = StraightStreak + 1

                if ValueToKeepStreak == 14 then --14 is the ace after a king 
                    break
                end

                ValueToKeepStreak = ValueToKeepStreak + 1

            elseif HasShortcut and CardValue == ValueToKeepStreak + 1 then --with shortcut a 1 value gap is good

                StraightStreak = StraightStreak + 1

                if ValueToKeepStreak == 13 then --14 is the ace after a king 
                    break
                end

                ValueToKeepStreak = ValueToKeepStreak + 2

            else --logically this can only happen once since at least 4/5 cards need to be compatible
            
                if StraightStreak < 4 then --reset and continue
                    StraightStreak = 1 
                    ValueToKeepStreak = CardValue + 1
                    StreaksStart = i

                else --stop
                    break
                end  
            end
        end


        for i = StreakStart, StraightStreak do
            
            ReturnMask = ReturnMask | 2^(i-1)
        end

    else --any hand that requires 5 cards

        return math.maxinteger ---every card scores
    end

    for i,Card in ipairs(PlayerHand) do
        if Card.Enhancement == mod.Enhancement.STONE then --every stone card is scoring
            
            ReturnMask = ReturnMask | 2^(i-1)
        end
    end

    print(ReturnMask, tonumber(tostring(ReturnMask), 2))
    return ReturnMask
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
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return false
    end
    local PIndex = Player:GetData().TruePlayerIndex

    for _,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        if Slot.Joker == Trinket then
            return true
        end
    end
    return false
end

function mod:GetJimboJokerIndex(Player, Joker, SkipCopy)
    local Indexes = {}
    local PIndex = Player:GetData().TruePlayerIndex

    for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        if Slot.Joker == Joker then
            table.insert(Indexes, i)

        elseif not SkipCopy
               and (Slot.Joker == mod.Jokers.BLUEPRINT or Slot.Joker == mod.Jokers.BRAINSTORM) then

            local CopiedJoker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[i]]
            CopiedJoker = CopiedJoker and CopiedJoker.Joker or 0

            if CopiedJoker == Joker then
                table.insert(Indexes, i)
            end
        end
    end
    return Indexes
end


---@param Player EntityPlayer
function mod:IsSuit(Player, Card, WantedSuit, MakeTable)

    if MakeTable then --in this case makes a table telling the equivalent suits

        if Card.Enhancement == mod.Enhancement.STONE then
            return {} --no suit
        elseif Card.Enhancement == mod.Enhancement.WILD then
            return {true,true,true,true} --every suit is good
        end
        local GoodSuits = {false,false,false,false}
        GoodSuits[Card.Suit] = true


        if mod:JimboHasTrinket(Player, mod.Jokers.SMEARED_JOKER) then
            --in this case spades/clubs and Hearts/diamonds are considered the same

            local Jump = 2 --distance SPADE/HEART => CLUB/DIAMOND

            if WantedSuit > 2 then  --the suits are in order: (SPADE,HEART,CLUB,DIAMOND)
                Jump = -2 --distance CLUB/DIAMOND => SPADE/HEART
            end

            GoodSuits[WantedSuit + Jump] = true
        end

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS) --clubs count as hearts
           and Card.Suit == mod.Suits.Club and WantedSuit == mod.Suits.Heart then

            GoodSuits[mod.Suits.Heart] = true

        end

        return GoodSuits

    else --in this case only says true or false if equal
        if Card.Enhancement == mod.Enhancement.STONE then
            return false
        
        elseif Card.Suit == WantedSuit or Card.Enhancement == mod.Enhancement.WILD then
            return true
        end
        
        if mod:JimboHasTrinket(Player, mod.Jokers.SMEARED_JOKER) then
            --in this case spades/clubs and Hearts/diamonds are considered the same

            if Card.Suit % 2 == WantedSuit % 2 then
                return true
            end
        end


        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS) --clubs count as hearts
           and Card.Suit == mod.Suits.Club and WantedSuit == mod.Suits.Heart then

            return true
        end



        return false
    end
end

function mod:TryGamble(Player, RNG, Chance)
    Chance = Chance * (2 ^ #mod:GetJimboJokerIndex(Player, mod.Jokers.OOPS_6))
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
function mod:GetJokerCost(Joker, Edition, SellSlot, Player)
    --removes ! from the customtag (see items.xml)

    local numstring = string.gsub(ItemsConfig:GetTrinket(Joker):GetCustomTags()[1],"%!","")

    local Cost = tonumber(numstring) + EditionValue[Edition]

    if SellSlot then --also tells if you want the buy/sell value as the return
    
        local PIndex = Player:GetData().TruePlayerIndex
    
        Cost = math.floor(Cost / 2)
        if Joker == mod.Jokers.EGG then
            Cost = mod.Saved.Player[PIndex].Progress.Inventory[SellSlot]
        end

        mod.Saved.Player[PIndex].Progress.GiftCardExtra[SellSlot] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[SellSlot] or 0

        Cost = Cost + mod.Saved.Player[PIndex].Progress.GiftCardExtra[SellSlot]
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
    return string.gsub(ItemsConfig:GetTrinket(Joker):GetCustomTags()[4],"%?","")
end

function mod:GetJokerInitialProgress(Joker, Tainted)

    local Config = ItemsConfig:GetTrinket(Joker)
    if Tainted then

        return string.gsub(Config:GetCustomTags()[3],"%:","")
    else

        return tonumber(Config:GetCustomTags()[2])
    end
end

function mod:AddJimboInventorySlots(Player, Amount)
    local PIndex = Player:GetData().TruePlayerIndex

    if Amount >= 0 then
        for i=1,Amount do --just adds empty spaces to fill
            table.insert(mod.Saved.Player[PIndex].Inventory, {["Joker"] = 0,["Edition"]=mod.Edition.BASE})

            mod.Saved.Player[PIndex].Progress.GiftCardExtra[#mod.Saved.Player[PIndex].Inventory] = 0

        end
    else
        for i=1, -Amount do

            for j,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if Slot.Joker == 0 then --searches for an empty slot to remove
                    table.remove(mod.Saved.Player[PIndex].Inventory, j)

                    table.remove(mod.Saved.Player[PIndex].Progress.GiftCardExtra, j)

                    return
                end
            end

            mod:SellJoker(Player, mod.Saved.Player[PIndex].Inventory.Jokers[1], 1)
        end
    end
end

function mod:ChangeJimboHandSize(Player, Amount)
    local PIndex = Player:GetData().TruePlayerIndex

    if Amount >= 0 then
        for i=1,Amount do --just adds empty spaces to fill
            table.insert(mod.Saved.Player[PIndex].CurrentHand,1, mod.Saved.Player[PIndex].DeckPointer)
            mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 1
        end
    else
        for i=-1,Amount, -1 do
            if mod.Saved.Player[PIndex].HandSize == 1 then
                return
            end
            table.remove(mod.Saved.Player[PIndex].CurrentHand, mod.Saved.Player[PIndex].HandSize)
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

function mod:SellJoker(Player, Slot, Multiplier)
    local PIndex = Player:GetData().TruePlayerIndex

    local Trinket = mod.Saved.Player[PIndex].Inventory[Slot].Joker + 0

    if Trinket == 0 then
        return false
    end

    local Edition = mod.Saved.Player[PIndex].Inventory[Slot].Edition + 0

    mod.Saved.Player[PIndex].Inventory[Slot].Joker = 0
    mod.Saved.Player[PIndex].Inventory[Slot].Edition = mod.Edition.BASE

    local SellValue = mod:GetJokerCost(Trinket, Edition, Slot, Player) * (Multiplier or 1)
    SellValue = math.floor(SellValue)

    mod.Saved.Player[PIndex].Progress.GiftCardExtra[Slot] = 0

    if mod.Saved.Player[PIndex].Inventory[Slot].Edition == mod.Edition.NEGATIVE then
        --selling a negative joker reduces your inventory size
        mod:AddJimboInventorySlots(Player, -1)
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
        mod.SelectionParams[PIndex].Index = mod.SelectionParams[PIndex].Index - 1
    end

    if Player:GetPlayerType() == mod.Characters.JimboType then

        for i=1, SellValue do
            Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,Player.Position,RandomVector()*2,Player,CoinSubType.COIN_PENNY,RNG():GetSeed())
        end
    else
        Player:AddCoins(SellValue)
    end

    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..SellValue.."$")


    --Isaac.RunCallback("INVENTORY_CHANGE", Player)
    Isaac.RunCallback("JOKER_SOLD", Player, Trinket, Slot)

    return true
end


function mod:GetConsumableCost(Consumable, Edition, Selling)

    local IsSpectral = Consumable >= mod.Spectrals.FAMILIAR and Consumable <= mod.Spectrals.SOUL

    local SellValue = ((IsSpectral and 4 or 3) + EditionValue[Edition])

    local Discount = 1
    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Liquidation) then
        Discount = 0.5
    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Clearance) then
        Discount = 0.75
    end

    local Cost = math.floor(SellValue * Discount)

    if Selling then
        Cost = math.floor(Cost/2)
    end

    return math.max(Cost, 1)

end

---@param Player EntityPlayer
function mod:SellConsumable(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local NumConsumables = #mod.Saved.Player[PIndex].Consumables
    local CardToSell = mod.Saved.Player[PIndex].Consumables[NumConsumables].Card + 0

    if CardToSell == -1 then
        return false
    end

    local PlayerConsumables = mod.Saved.Player[PIndex].Consumables

    CardToSell = mod:FrameToSpecialCard(CardToSell)

    local Edition = PlayerConsumables[NumConsumables].Edition + 0

    local SellValue = mod:GetConsumableCost(CardToSell, Edition, true)

    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..SellValue.."$")
    Player:AddCoins(SellValue)

    table.remove(PlayerConsumables, NumConsumables)
    table.insert(PlayerConsumables, 1, {Card = -1, Edition = 0})

    return true
end


local JeditionChance = {0.02, 0.034, 0.037, 0.003}
function mod:RandomJoker(Rng, Exeptions, PlaySound, ForcedRarity)
    Exeptions = Exeptions or {}
    local Trinket = {}
    local Possibilities = {}
    local HasShowman = false

    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) then
            HasShowman = true
        end
    end

    if not HasShowman then --add to exeptions jokers held and in the room
    
        for i, Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType then
                local PIndex = Player:GetData().TruePlayerIndex

                for i, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                    if Slot.Joker ~= 0 then
                        Exeptions[#Exeptions+1] = Slot.Joker
                    end
                end
            end
        end

        for _, Trinket in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do

            Exeptions[#Exeptions+1] = Trinket.SubType
        end
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
            Trinket.Joker = mod.Jokers.JOKER --default trinket
            break
        end

        Trinket.Joker = mod:GetRandom(Possibilities, Rng)

        ---@diagnostic disable-next-line: param-type-mismatch
        table.remove(Possibilities, mod:GetValueIndex(Possibilities, Trinket.Joker, true))

    until not mod:Contained(Exeptions, Trinket.Joker) --basic criteria
          and (Trinket.Joker ~= mod.Jokers.GROS_MICHAEL or not mod.Saved.MichelDestroyed) --if it's michel, check if it was destroyed
          and (Trinket.Joker ~= mod.Jokers.CAVENDISH or mod.Saved.MichelDestroyed) --if it's cavendish do the same but opposite
    
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


function mod:CardValueToName(Value, IsEID, OnlyInitial)

    local String

    if Value == 1 then
        if OnlyInitial then
            String = "A"
        else
            String = "Ace"
        end
    elseif Value == mod.Values.JACK then
        if OnlyInitial then
            String = "J"
        else
            String = "Jack"
        end
    elseif Value == mod.Values.QUEEN then
        if OnlyInitial then
            String = "Q"
        else
            String = "Queen"
        end
    elseif Value == mod.Values.KING then
        if OnlyInitial then
            String = "K"
        else
            String = "King"
        end
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

function mod:AddJoker(Player, Joker, Edition, StopEval)
    --local PIndex = Player:GetData().TruePlayerIndex

    Edition = Edition or mod.Edition.BASE

    mod.Saved.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Joker).Name] = Edition

    return mod:JimboAddTrinket(Player, Joker, false, StopEval)
end


---@param Player EntityPlayer
---@param StopEvaluation boolean this is only set when called in mod:AddJoker
function mod:JimboAddTrinket(Player, Trinket, _, StopEvaluation)

    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

    if not IsTaintedJimbo
       and Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
        
    Player:TryRemoveTrinket(Trinket) -- a custom table is used instead since he needs to hold many of them

    local JokerEdition = mod.Saved.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Trinket).Name] or mod.Edition.BASE 


    local EmptySlot = mod:GetJimboJokerIndex(Player, 0,true)[1]
    
    if not EmptySlot then
        Isaac.CreateTimer(function ()
            Player:AnimateSad()
        end,0,1,false)
        
        return false
    end

    mod.Counters.SinceSelect = 0

    mod.Saved.Player[PIndex].Inventory[EmptySlot].Joker = Trinket
    mod.Saved.Player[PIndex].Inventory[EmptySlot].Edition = JokerEdition

    mod.Saved.Player[PIndex].Progress.Inventory[EmptySlot] = mod:GetJokerInitialProgress(Trinket, IsTaintedJimbo)

    if not StopEvaluation then
        Isaac.RunCallback("JOKER_ADDED", Player, Trinket, JokerEdition, EmptySlot)
        Isaac.RunCallback("INVENTORY_CHANGE", Player)
    end

    return true
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED,CallbackPriority.IMPORTANT, mod.JimboAddTrinket)



function mod:AddCardToDeck(Player, CardTable,Amount, PutInHand)

    if Amount <= 0 then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    for i=1, Amount do
        table.insert(mod.Saved.Player[PIndex].FullDeck,1, CardTable) --adds it to pos 1 so it can't be seen again
    end

    for i,_ in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        mod.Saved.Player[PIndex].CurrentHand[i] = mod.Saved.Player[PIndex].CurrentHand[i] + Amount --fixes the jump made by table.insert
    end
    mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 2 --fixes the jump made by table.insert

    if PutInHand then
        for i=1, Amount do
            table.insert(mod.Saved.Player[PIndex].CurrentHand, i) --adds it to the hand if necessary
        end
    end

    mod.LastCardFullPoss = {} --hud does wierd stuff otherwise

    Isaac.RunCallback("DECK_MODIFY", Player, Amount)
end


local CardGotDestroyed = false
function mod:DestroyCards(Player, DeckIndexes, DoEffects, BlockSubstitution)
    local PIndex = Player:GetData().TruePlayerIndex

    CardGotDestroyed = true

    Isaac.CreateTimer(function ()
        CardGotDestroyed = false
    end,35,1,true)

    table.sort(DeckIndexes, function (a, b) --sorts it so that table.remove doesn't shift indexes around
        if a > b then
            return true
        end
        return false
    end)

    local DestroyedParams = {}

    for _, Index in ipairs(DeckIndexes) do
        local CardParams = mod.Saved.Player[PIndex].FullDeck[Index]

        DestroyedParams[#DestroyedParams+1] = CardParams

        if mod:Contained(mod.Saved.Player[PIndex].CurrentHand, Index) 
           and (#mod.Saved.Player[PIndex].CurrentHand > Player:GetCustomCacheValue("handsize")
           or BlockSubstitution) then
        
            ---@diagnostic disable-next-line: param-type-mismatch
            table.remove(mod.Saved.Player[PIndex].CurrentHand, mod:GetValueIndex(mod.Saved.Player[PIndex].CurrentHand, Index, true))
        end

        table.remove(mod.Saved.Player[PIndex].FullDeck, Index)
        
        if DoEffects then
            mod:CardRipEffect(CardParams, Player.Position)
        end
    end

    Isaac.RunCallback("DECK_MODIFY", Player, -#DeckIndexes, DestroyedParams)
end


function mod:CardRipEffect(CardParams, Position)

    if CardParams.Enhancement == mod.Enhancement.STONE then
        
        for i=1, 5 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(3,3.25,3.5,0.85)

            --Splat:GetSprite().Color = Color(0.6,0.65,0.7,1)
        end
    
        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 2, false, 1.5 + math.random()*0.05)

        return

    elseif CardParams.Enhancement == mod.Enhancement.WILD then

        for i=1, 2 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(8,8,8,1)
        end


        local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()

        Splat:GetSprite().Color:SetColorize(0.9,0.9,0.9,1) --black


        Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
        RandomVector()*3, nil, 0, 1):ToEffect()

        Splat:GetSprite().Color:SetColorize(1.5,3,15,0.8) -- blue


        Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()

        Splat:GetSprite().Color:SetColorize(6,0,0,2) --red

        Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
        RandomVector()*3, nil, 0, 1):ToEffect()

        Splat:GetSprite().Color:SetColorize(6,1.2,0.9,3) --orange


        sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH_SHORT, 1, 2, false, 2 + math.random()*0.05)

        return
    
    elseif CardParams.Enhancement == mod.Enhancement.GLASS then

        for i=1, 5 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOOD_PARTICLE, Position,
                                         RandomVector()*3, nil, 0, 1):ToEffect()
            
            Splat:GetSprite().Color:SetColorize(8,8,8.5,1)
            Splat:GetSprite().Color:SetTint(1,1,1,0.25)
        end

        sfx:Play(SoundEffect.SOUND_POT_BREAK_2, 1, 2, false, 1.5 + math.random()*0.05) --PLACEHOLDER SOUND

    elseif CardParams.Enhancement == mod.Enhancement.LUCKY then

        for i=1, 5 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(5.1,5.1,3.9,1)
        end
    
        sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH_SHORT, 1, 2, false, 2 + math.random()*0.05)
    
    elseif CardParams.Enhancement == mod.Enhancement.STEEL then

        for i=1, 4 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(4,4,4.25,1)
        end
    
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 1.5 + math.random()*0.05)
    
    elseif CardParams.Enhancement == mod.Enhancement.MULT then

        for i=1, 2 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(8,8,8,1) --white
        end

        local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()

        Splat:GetSprite().Color:SetColorize(0.9,0.9,1.1,1) -- slightly blueish black

        Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()

        Splat:GetSprite().Color:SetColorize(6,0,0,2) --red

    
        sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH_SHORT, 1, 2, false, 2 + math.random()*0.05)

    elseif CardParams.Enhancement == mod.Enhancement.BONUS then

        for i=1, 2 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(8,8,8,1) --white
        end

        for i=1, 2 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(1.5,3,15,0.8) --blue
        end

        sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH_SHORT, 1, 2, false, 2 + math.random()*0.05)

    elseif CardParams.Enhancement == mod.Enhancement.GOLDEN then

        for i=1, 14 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.COIN_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            --Splat:GetSprite().Color:SetColorize(8,8,8,1)
        end
    
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 1.5 + math.random()*0.05)

    else
        for i=1, 5 do
            local Splat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                                     RandomVector()*3, nil, 0, 1):ToEffect()
    
            Splat:GetSprite().Color:SetColorize(8,8,8,1)
        end
    
        sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH_SHORT, 1, 2, false, 2 + math.random()*0.05)

    end

    local SuitSplat = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Position,
                             RandomVector()*3, nil, 0, 1):ToEffect()

    if CardParams.Suit == mod.Suits.Spade then

        SuitSplat:GetSprite().Color:SetColorize(0.9,0.9,0.9,1) --black

    elseif CardParams.Suit == mod.Suits.Club then

        SuitSplat:GetSprite().Color:SetColorize(1.5,3,15,0.8) --blue

    elseif CardParams.Suit == mod.Suits.Heart then

        SuitSplat:GetSprite().Color:SetColorize(6,0,0,2) --red

    else --diamonds

        SuitSplat:GetSprite().Color:SetColorize(6,1.2,0.9,3) --orange
    
    end

    if CardParams.Enhancement == mod.Enhancement.GLASS then
        SuitSplat:GetSprite().Color:SetTint(1,1,1,0.5)
    end
end

---@param Effect EntityEffect
function mod:NoBloodSplats(Effect)

    if CardGotDestroyed then --tried for like an hour to get some way of recognising theese specific blood splats but no luck
        Effect:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.NoBloodSplats, EffectVariant.BLOOD_SPLAT)


--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if not (Player:GetPlayerType() == mod.Characters.JimboType
       or Player:GetPlayerType() == mod.Characters.TaintedJimbo) then

        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local PlayerRNG = Player:GetDropRNG()
    mod.Saved.Player[PIndex].FullDeck = mod:Shuffle(mod.Saved.Player[PIndex].FullDeck, PlayerRNG)

    mod.Saved.Player[PIndex].DeckPointer = Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) + 1
    for i=1, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) do
        mod.Saved.Player[PIndex].CurrentHand[i] = i
    end

    Isaac.RunCallback("DECK_SHIFT", Player)
    
end


function mod:RefillHand(Player)

    local PIndex = Player:GetData().TruePlayerIndex
    local DeckSize = #mod.Saved.Player[PIndex].FullDeck - 1

    for i = #mod.Saved.Player[PIndex].CurrentHand, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) - 1 do

        if mod.Saved.Player[PIndex].DeckPointer > DeckSize then
            
            return false
        end
        
        table.insert(mod.Saved.Player[PIndex].CurrentHand, mod.Saved.Player[PIndex].DeckPointer)

        mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 1
    end

    return true
end


function mod:ChooseBossBlind(SpecialBoss)
    
    --resets the pool in case it gets emptied
    if not next(mod.Saved.Pools.BossBlinds) then
        
        mod.Saved.Pools.BossBlinds = { mod.BLINDS.BOSS_HOOK,
                                       mod.BLINDS.BOSS_CLUB,
                                       mod.BLINDS.BOSS_PSYCHIC,
                                       mod.BLINDS.BOSS_GOAD,
                                       mod.BLINDS.BOSS_WINDOW,
                                       mod.BLINDS.BOSS_MANACLE,
                                       mod.BLINDS.BOSS_PILLAR,
                                       mod.BLINDS.BOSS_HEAD,
                                       }

        if mod.Saved.AnteLevel >= 2 then

            local InitialBossNum = #mod.Saved.Pools.BossBlinds
                
            mod.Saved.Pools.BossBlinds[InitialBossNum+1] = mod.BLINDS.BOSS_HOUSE
            mod.Saved.Pools.BossBlinds[InitialBossNum+2] = mod.BLINDS.BOSS_WALL
            mod.Saved.Pools.BossBlinds[InitialBossNum+3] = mod.BLINDS.BOSS_WHEEL
            mod.Saved.Pools.BossBlinds[InitialBossNum+4] = mod.BLINDS.BOSS_ARM
            mod.Saved.Pools.BossBlinds[InitialBossNum+5] = mod.BLINDS.BOSS_FISH
            mod.Saved.Pools.BossBlinds[InitialBossNum+6] = mod.BLINDS.BOSS_WATER
            mod.Saved.Pools.BossBlinds[InitialBossNum+7] = mod.BLINDS.BOSS_MOUTH
            mod.Saved.Pools.BossBlinds[InitialBossNum+8] = mod.BLINDS.BOSS_NEEDLE
        end       
        if mod.Saved.AnteLevel >= 3 then
        
            local InitialBossNum = #mod.Saved.Pools.BossBlinds
        
            mod.Saved.Pools.BossBlinds[InitialBossNum+1] = mod.BLINDS.BOSS_EYE
            mod.Saved.Pools.BossBlinds[InitialBossNum+2] = mod.BLINDS.BOSS_TOOTH
        end
        if mod.Saved.AnteLevel >= 4 then
        
            mod.Saved.Pools.BossBlinds[#mod.Saved.Pools.BossBlinds+1] = mod.BLINDS.BOSS_PLANT
        end
        if mod.Saved.AnteLevel >= 5 then
        
            mod.Saved.Pools.BossBlinds[#mod.Saved.Pools.BossBlinds+1] = mod.BLINDS.BOSS_SERPENT
        end
        if mod.Saved.AnteLevel >= 6 then
        
            mod.Saved.Pools.BossBlinds[#mod.Saved.Pools.BossBlinds+1] = mod.BLINDS.BOSS_OX
        
        end

    end

    if not next(mod.Saved.Pools.SpecialBossBlinds) then

        mod.Saved.Pools.SpecialBossBlinds = { mod.BLINDS.BOSS_HEART,
                                              mod.BLINDS.BOSS_BELL,
                                              mod.BLINDS.BOSS_VESSEL,
                                              mod.BLINDS.BOSS_ACORN,
                                              mod.BLINDS.BOSS_LEAF,
                                              }
    end

    if SpecialBoss then

        mod.Saved.AnteBoss = mod:GetRandom(mod.Saved.Pools.SpecialBossBlinds, RNG(Game:GetLevel():GetDungeonPlacementSeed()))

        table.remove(mod.Saved.Pools.SpecialBossBlinds, mod:GetValueIndex(mod.Saved.Pools.SpecialBossBlinds, mod.Saved.AnteBoss, true))

    else

        mod.Saved.AnteBoss = mod:GetRandom(mod.Saved.Pools.BossBlinds, RNG(Game:GetLevel():GetDungeonPlacementSeed()))

        table.remove(mod.Saved.Pools.BossBlinds, mod:GetValueIndex(mod.Saved.Pools.BossBlinds, mod.Saved.AnteBoss, true))

    end

end


function mod:GetBlindLevel(PlateVarData)

    return math.min(PlateVarData & ~mod.BLINDS.SKIP, mod.BLINDS.BOSS)
end


---@param Trinket EntityPickup
function mod:TrinketEditionsRender(Trinket, Offset)
    local Index = Level:GetCurrentRoomDesc().ListIndex
    local JokerConfig = ItemsConfig:GetTrinket(Trinket.SubType)

    --some precautions
    mod.Saved.FloorEditions[Index] = mod.Saved.FloorEditions[Index] or {}
    mod.Saved.FloorEditions[Index][JokerConfig.Name] = mod.Saved.FloorEditions[Index][JokerConfig.Name] or 0

    local Edition = mod.Saved.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name]
    
    Trinket:GetSprite():SetCustomShader(mod.EditionShaders[Edition])

    --Trinket:GetSprite():SetCustomShader(mod.EditionShaders[mod.Edition.NEGATIVE])
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.TrinketEditionsRender, PickupVariant.PICKUP_TRINKET)


function mod:EnableTrinketEditions()
    mod.Saved.FloorEditions = {}
    Isaac.CreateTimer(function()
        local AllRoomsDesc = Level:GetRooms()
        for i=1, Level:GetRoomCount()-1 do
            local RoomDesc = AllRoomsDesc:Get(i)
            mod.Saved.FloorEditions[RoomDesc.ListIndex] = {}
        end
    end, 1,1,true )
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.EnableTrinketEditions)




function mod:PlaceBlindRoomsForReal()

    local Level = Game:GetLevel()

    local RoomSeed = Game:GetSeeds():GetStageSeed(Isaac.GetCurrentStageConfigId())
    local RoomRNG = RNG(RoomSeed)
    local RoomPlaceSeed = Level:GetDungeonPlacementSeed()
    local PlaceRNG = RNG(RoomPlaceSeed)

    local SmallDesc
    local BigDesc
    local ShopDesc

    local tries = 0

    repeat

        local BigRoom = RoomConfigHolder.GetRandomRoom( RoomRNG:RandomInt(MAX_SEED_VALUE) + 1,
                                                        true, 
                                                        Isaac.GetCurrentStageConfigId(),
                                                        RoomType.ROOM_DEFAULT,
                                                        RoomShape.ROOMSHAPE_2x2,
                                                        -1, -1,
                                                        7,
                                                        10,
                                                        0,
                                                        -1,RoomHolderMode.HOSTILE)

        local PlaceSeed = PlaceRNG:RandomInt(MAX_SEED_VALUE) + 1

        for i = 3, 168 do

            BigDesc = Level:TryPlaceRoom(BigRoom, i, -1, PlaceSeed, true, true, true)

            if BigDesc then
                mod.Saved.BigBlindIndex = i
                break

            else
                Isaac.DebugString("FAILED TO PLACE AT "..tostring(mod.Saved.BigBlindIndex))
            end
        end     
        
        tries = tries + 1
    
    until BigDesc

    tries = 0

    repeat

        local SmallRoom = RoomConfigHolder.GetRandomRoom( RoomRNG:RandomInt(MAX_SEED_VALUE) + 1,
                                                        true, 
                                                        Isaac.GetCurrentStageConfigId(),
                                                        RoomType.ROOM_DEFAULT,
                                                        RoomShape.ROOMSHAPE_1x1,
                                                        -1, -1,
                                                        7,
                                                        10,
                                                        0,
                                                        -1,RoomHolderMode.HOSTILE)

        local PlaceSeed = PlaceRNG:RandomInt(MAX_SEED_VALUE) + 1

        for i = 0, 168 do

            SmallDesc = Level:TryPlaceRoom(SmallRoom, i, -1, PlaceSeed, true, true, true)
            
            if SmallDesc then

                mod.Saved.SmallBlindIndex = i
                break
            else
                Isaac.DebugString("FAILED TO PLACE AT "..tostring(mod.Saved.BigBlindIndex))
            end
        end

    until SmallDesc

    SmallDesc:AddRestrictedGridIndex(67)

    tries = 0

    local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3

    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
        ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3
    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
        ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_4
    end

    repeat

        local ShopRoom = RoomConfigHolder.GetRandomRoom(RoomRNG:RandomInt(MAX_SEED_VALUE) + 1,
                                                        false, 
                                                        StbType.SPECIAL_ROOMS,
                                                        RoomType.ROOM_SHOP,
                                                        RoomShape.NUM_ROOMSHAPES,
                                                        -1, -1,
                                                        0,
                                                        10,
                                                        0, ShopQuality, RoomHolderMode.ANY)

        local PlaceSeed = PlaceRNG:RandomInt(MAX_SEED_VALUE) + 1

        for i = 5, 168 do

            ShopDesc = Level:TryPlaceRoom(ShopRoom, i, -1, PlaceSeed, true, true, true)
            
            if ShopDesc then

                mod.Saved.ShopIndex = i
                break

            else
                Isaac.DebugString("FAILED TO PLACE AT "..tostring(mod.Saved.BigBlindIndex))
            end
        end

    until ShopDesc

 
end


--VV sorry, didn't put many comments on these functions and I'm too lazy to do so now (I'll def regret this)

local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")
local music = MusicManager()

--allows to activate/disable selection states easily
---@param Player EntityPlayer
function mod:SwitchCardSelectionStates(Player,NewMode,NewPurpose)

    local PIndex = Player:GetData().TruePlayerIndex
    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

    local OldMode = mod.SelectionParams[PIndex].Mode
    local OldPurpose = mod.SelectionParams[PIndex].Purpose

    mod.Counters.SinceSelect = 0
    --if the selection changes from an ""active"" to a ""not active"" state
    if (NewMode == mod.SelectionParams.Modes.NONE) ~= (OldMode == mod.SelectionParams.Modes.NONE) then
        mod.SelectionParams[PIndex].Frames = 0
    end

    if NewMode == mod.SelectionParams.Modes.NONE then

        for i,v in ipairs(Isaac.FindByType(1000, DescriptionHelperVariant, DescriptionHelperSubType)) do
            v:Remove()
        end
        

        if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STOP_WATCH) then
            music:PitchSlide(0.9)
        else
            music:PitchSlide(1)
        end
        music:VolumeSlide(1, 0.04)


        mod.SelectionParams[PIndex].Index = 1

        if Player:GetPlayerType() == mod.Characters.TaintedJimbo then

            mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Player[PIndex].CurrentHand
            mod.SelectionParams[PIndex].MaxSelectionNum = 5

            mod.SelectionParams[PIndex].PackOptions = {}

            if NewPurpose == mod.SelectionParams.Purposes.NONE then
                mod.Saved.EnableHand = false

            elseif NewPurpose == mod.SelectionParams.Purposes.AIMING then

                local Target = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, Player.Position, Vector.Zero, Player, 0, math.max(Random(), 1))
                
                Target.Parent = Player
                Target.SortingLayer = SortingLayer.SORTING_BACKGROUND
            end
        else
            mod.SelectionParams[PIndex].OptionsNum = 0
            mod.SelectionParams[PIndex].MaxSelectionNum = 0

            for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                mod.SelectionParams[PIndex].SelectedCards[i] = false 
            end
            mod.SelectionParams[PIndex].SelectionNum = 0

            Player:SetCanShoot(true)

            Game:GetRoom():SetPauseTimer(0)
        end

        goto FINISH
    end

    if not IsTaintedJimbo then
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE
           and mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.DEATH1 then
            --if changing from an "active" state to another

            mod:UseSelection(Player)
        end
        
        Game:GetRoom():SetPauseTimer(225)
        Player:SetCanShoot(false)
    end
    
    if NewMode == mod.SelectionParams.Modes.HAND then

        --print(OldMode ~= mod.SelectionParams.Modes.HAND)
        if not mod.Saved.EnableHand--OldMode == mod.SelectionParams.Modes.NONE
           and IsTaintedJimbo then

            mod.Saved.EnableHand = true
            mod.LastCardFullPoss = {}
            mod:FullDeckShuffle(Player)
        end
        
        
        mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Player[PIndex].CurrentHand
        if NewPurpose == mod.SelectionParams.Purposes.HAND then
            mod.SelectionParams[PIndex].MaxSelectionNum = 5
            mod.SelectionParams[PIndex].HandType = mod.HandTypes.NONE

        elseif NewPurpose >= mod.SelectionParams.Purposes.DEJA_VU then
            mod.SelectionParams[PIndex].MaxSelectionNum = 1

        else --various tarot cards
            if NewPurpose == mod.SelectionParams.Purposes.DEATH1 then

                mod.SelectionParams[PIndex].MaxSelectionNum = 2

            elseif NewPurpose >= mod.SelectionParams.Purposes.WORLD then --any suit based tarot
                --WORLD, SUN, MOON, STAR
                mod.SelectionParams[PIndex].MaxSelectionNum = 3

            else --any other card
                local Size = -(NewPurpose % 2) + 2 --see main.lua to understand why this works
                if Player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
                    Size = Size + 1
                end
                mod.SelectionParams[PIndex].MaxSelectionNum = Size
            end
        end
    
    elseif NewMode == mod.SelectionParams.Modes.PACK then

        music:PitchSlide(1.1)
        music:VolumeSlide(0.45, 0.02)

        mod.SelectionParams[PIndex].MaxSelectionNum = 2
        mod.SelectionParams[PIndex].OptionsNum = #mod.SelectionParams[PIndex].PackOptions

        if IsTaintedJimbo then

            if mod.SelectionParams[PIndex].PackPurpose ~= mod.SelectionParams.Purposes.NONE then
                --switching back while pack is already opened

                NewPurpose = mod.SelectionParams[PIndex].PackPurpose


            else --just opened a pack

                mod.Saved.EnableHand = NewPurpose == mod.SelectionParams.Purposes.TarotPack
                                       or NewPurpose == mod.SelectionParams.Purposes.SpectralPack

                mod.SelectionParams[PIndex].PackPurpose = NewPurpose

                if mod.Saved.EnableHand then --if the player's hand is required then first shuffle the deck
                    mod:FullDeckShuffle(Player)
                end
            end
            
        end

    elseif NewMode == mod.SelectionParams.Modes.INVENTORY then

        if IsTaintedJimbo then
            
            local FirstJoker

            for i, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                
                if Slot.Joker ~= 0 then
                    FirstJoker = i
                    break
                end
            end

            if not FirstJoker then
                return
            end

            mod.SelectionParams[PIndex].Index = FirstJoker
        end

        if NewPurpose == mod.SelectionParams.Purposes.SMELTER then
            mod.SelectionParams[PIndex].MaxSelectionNum = 1
        else
            --NewPurpose = mod.SelectionParams.Purposes.NONE
            mod.SelectionParams[PIndex].MaxSelectionNum = 2
        end

        mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Player[PIndex].Inventory
    end

    ::FINISH::

    Game:Spawn(EntityType.ENTITY_EFFECT, DescriptionHelperVariant, Player.Position
                   ,Vector.Zero, nil, DescriptionHelperSubType, 1)

    mod.SelectionParams[PIndex].Mode = NewMode
    mod.SelectionParams[PIndex].Purpose = NewPurpose

    if IsTaintedJimbo then
        mod.SelectionParams[PIndex].MaxSelectionNum = 5
        mod.SelectionParams[PIndex].Index = mod:Clamp(mod.SelectionParams[PIndex].Index, mod.SelectionParams[PIndex].OptionsNum, 1)
    
        --mod.SelectionParams[PIndex].SelectionNum = mod:GetValueRepetitions(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Mode],)
    
        for i=1, mod.SelectionParams[PIndex].OptionsNum do
        
            mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] or false
        end
    end
end


--handles the single card selection
---@param Player EntityPlayer
function mod:Select(Player)

    mod.Counters.SinceSelect = 0
    local PIndex = Player:GetData().TruePlayerIndex
    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

    local SelectedCards = mod.SelectionParams[PIndex].SelectedCards

    if IsTaintedJimbo then
        SelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Mode]
        --print(mod.SelectionParams[PIndex].Mode)
    end


    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

        local Choice = SelectedCards[mod.SelectionParams[PIndex].Index]
            
        if Choice then

            sfx:Play(mod.Sounds.DESELECT)

            SelectedCards[mod.SelectionParams[PIndex].Index] = false                    
            mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum - 1


        --if it's not currently selected and it doesn't surpass the limit
        elseif mod.SelectionParams[PIndex].SelectionNum < mod.SelectionParams[PIndex].MaxSelectionNum then   
            
            sfx:Play(mod.Sounds.SELECT)
            --confirm the selection
            SelectedCards[mod.SelectionParams[PIndex].Index] = true

            mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum + 1

        end

    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.NONE then
            
            --print("purpose is set to NONE!")
            return
        end

        --print("at selection: ", mod.SelectionParams[PIndex].MaxSelectionNum)

        --if its an actual option
        if mod.SelectionParams[PIndex].Index <= mod.SelectionParams[PIndex].OptionsNum then
            local Choice = SelectedCards[mod.SelectionParams[PIndex].Index]
            
            if Choice then

                sfx:Play(mod.Sounds.DESELECT)

                SelectedCards[mod.SelectionParams[PIndex].Index] = false                    
                mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum - 1

            --if it's not currently selected and it doesn't surpass the limit
            elseif mod.SelectionParams[PIndex].SelectionNum < mod.SelectionParams[PIndex].MaxSelectionNum then   
                
                sfx:Play(mod.Sounds.SELECT)
                --confirm the selection
                SelectedCards[mod.SelectionParams[PIndex].Index] = true

                mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum + 1

                if not IsTaintedJimbo then
                
                    --if max selection is done, automatically use hand
                    if mod.SelectionParams[PIndex].MaxSelectionNum == mod.SelectionParams[PIndex].SelectionNum then --DSS TO BE ADDED
                        --makes things faster by automatically activating if you chose the maximum number of cards
                        mod:UseSelection(Player)
                        mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
                        return

                    elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.DEATH1 then
                        for i,v in ipairs(SelectedCards) do
                            if v then
                                DeathCopyCard = mod.Saved.Player[PIndex].CurrentHand[i]
                                break
                            end
                        end
                    end 
                end
            end
            if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND
               and IsTaintedJimbo then

                Isaac.RunCallback("HAND_TYPE_UPDATE", Player)
            end

        else--if its the additional confirm button
            --print("confirm")
            mod:UseSelection(Player)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
        end

    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.PACK then

        local TruePurpose = mod.SelectionParams[PIndex].Purpose & ~mod.SelectionParams.Purposes.MegaFlag --removes it for pack checks

        if IsTaintedJimbo then
            
            for i,_ in ipairs(SelectedCards) do
                
                SelectedCards[i] = false
            end

            SelectedCards[mod.SelectionParams[PIndex].Index] = true
            sfx:Play(mod.Sounds.SELECT)

            if TruePurpose == mod.SelectionParams.Purposes.CelestialPack then
                Isaac.RunCallback(mod.Callbalcks.HAND_UPDATE, Player)
            end

            return
        end

        if mod.SelectionParams[PIndex].Index > mod.SelectionParams[PIndex].OptionsNum then--skip button
            
            Isaac.RunCallback("PACK_SKIPPED", Player, mod.SelectionParams[PIndex].Purpose)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
            return
        end

        sfx:Play(mod.Sounds.SELECT)

        if TruePurpose == mod.SelectionParams.Purposes.StandardPack then
            local SelectedCard = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index]

            mod:AddCardToDeck(Player, SelectedCard, 1, true)

            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, nil, "Added!",mod.Packs.STANDARD)

        elseif TruePurpose == mod.SelectionParams.Purposes.BuffonPack then

            local Joker = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index].Joker
            local Edition = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index].Edition
            local Index = Level:GetCurrentRoomDesc().ListIndex

            Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET, Player.Position, RandomVector()*3,nil,Joker,Game:GetSeeds():GetStartSeed())
            
            mod.Saved.FloorEditions[Index] = mod.Saved.FloorEditions[Index] or {}
            
            mod.Saved.FloorEditions[Index][ItemsConfig:GetTrinket(Joker).Name] = Edition


        else --tarot/planet/Spectral pack
            local card = mod:FrameToSpecialCard(mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index])
            local RndSeed = Random()
            if RndSeed == 0 then RndSeed = 1 end
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position, RandomVector()* 2, nil, card, RndSeed)
            
        end
        if Player:HasCollectible(mod.Vouchers.MagicTrick) and mod:TryGamble(Player, Player:GetCollectibleRNG(mod.Vouchers.MagicTrick), 0.25)
           and mod.SelectionParams[PIndex].OptionsNum > 1 then

            table.remove(mod.SelectionParams[PIndex].PackOptions, mod.SelectionParams[PIndex].Index)
            mod.SelectionParams[PIndex].OptionsNum = mod.SelectionParams[PIndex].OptionsNum - 1
            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "1 more!",mod.Vouchers.MagicTrick)
            return
        end
        if mod.SelectionParams[PIndex].Purpose & mod.SelectionParams.Purposes.MegaFlag == mod.SelectionParams.Purposes.MegaFlag 
           and mod.SelectionParams[PIndex].OptionsNum then
            
            mod.SelectionParams[PIndex].OptionsNum = mod.SelectionParams[PIndex].OptionsNum - 1
            mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose - mod.SelectionParams.Purposes.MegaFlag
            table.remove(mod.SelectionParams[PIndex].PackOptions, mod.SelectionParams[PIndex].Index)
            return
        end

        mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
        
    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        if mod.SelectionParams[PIndex].Index <= #mod.Saved.Player[PIndex].Inventory then --a joker is selected
            
            local Choice = SelectedCards[mod.SelectionParams[PIndex].Index]

            if Choice then
                sfx:Play(mod.Sounds.DESELECT)

                SelectedCards[mod.SelectionParams[PIndex].Index] = false

                if not IsTaintedJimbo then
                    mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.NONE
                end

            
            else --if it's not currently selected

                if IsTaintedJimbo then

                    sfx:Play(mod.Sounds.SELECT)

                    for i,v in ipairs(SelectedCards) do
                        if v then
                           SelectedCards[i] = false
                           break
                        end
                    end

                    SelectedCards[mod.SelectionParams[PIndex].Index] = true

                elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SMELTER then --DSS TO BE ADDED
                    mod:UseSelection(Player)
                    mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)
    
                elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SELLING then
                    local FirstI
                    local SecondI = mod.SelectionParams[PIndex].Index
                    for i,v in ipairs(SelectedCards) do
                        if v then
                           FirstI = i
                           SelectedCards[i] = false
                           break
                        end
                    end

                    sfx:Play(mod.Sounds.SELECT)
                    Isaac.CreateTimer(function ()
                        sfx:Play(mod.Sounds.SELECT,1,2,false, 1.2)
                    end, 3, 1, false)

                    mod.Saved.Player[PIndex].Inventory[FirstI].Joker,mod.Saved.Player[PIndex].Inventory[SecondI].Joker =
                    mod.Saved.Player[PIndex].Inventory[SecondI].Joker,mod.Saved.Player[PIndex].Inventory[FirstI].Joker

                    mod.Saved.Player[PIndex].Progress.Inventory[FirstI],mod.Saved.Player[PIndex].Progress.Inventory[SecondI] =
                    mod.Saved.Player[PIndex].Progress.Inventory[SecondI],mod.Saved.Player[PIndex].Progress.Inventory[FirstI]

                    for _,GiftSlot in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.GIFT_CARD, true)) do

                        mod.Saved.Player[PIndex].Progress.Inventory[GiftSlot][FirstI],mod.Saved.Player[PIndex].Progress.Inventory[GiftSlot][SecondI] = 
                        mod.Saved.Player[PIndex].Progress.Inventory[GiftSlot][SecondI],mod.Saved.Player[PIndex].Progress.Inventory[GiftSlot][FirstI]    
                    
                    end


                    Isaac.RunCallback("INVENTORY_CHANGE", Player)

                    mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.NONE

                elseif mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index].Joker ~= 0 then
                       
                    sfx:Play(mod.Sounds.SELECT)

                    SelectedCards[mod.SelectionParams[PIndex].Index] = true

                    if mod.SelectionParams[PIndex].Purpose ~= mod.SelectionParams.Purposes.SMELTER then

                        mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.SELLING
                    end

                end


            end

        else--the confirm button is pressed
        
            if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SMELTER then
                mod:UseSelection(Player)
                mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)

            elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SELLING then
                local SoldSlot
                for i,v in ipairs(SelectedCards) do
                    if v then
                        SoldSlot = i
                        SelectedCards[i] = false
                       break
                    end
                end
                --print(FirstI)

                mod:SellJoker(Player, SoldSlot)
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams.Purposes.NONE
            else
                mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)
            end
        end
    end
end


local PurposeEnh = {nil,2,4,9,5,3,6,nil,7,nil,8}
--activates the current selection when finished
---@param Player EntityPlayer
function mod:UseSelection(Player)

    local PIndex = Player:GetData().TruePlayerIndex
    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

    local SelectedCards
    local PackSelectedCards
    local HandSelectedCards

    if IsTaintedJimbo then
        SelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Mode] or {}
        PackSelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK]
        HandSelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]

    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then
        return

    else
        SelectedCards = mod.SelectionParams[PIndex].SelectedCards

        table.move(SelectedCards,1,#SelectedCards,1, PackSelectedCards)
        table.move(SelectedCards,1,#SelectedCards,1, HandSelectedCards)
    end


    if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.NONE then

        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AIMING then
            

            mod:ActivateCurrentHand(Player)
            --Isaac.RunCallback(mod.Callbalcks.POST_HAND_PLAY, Player)
        end


    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then
        --maybe I could've done something nicer then these elseifs but works anyways

        if IsTaintedJimbo then
            
            if mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.TarotPack
               or mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.SpectralPack then

                --T Jimbo could confirm the pack selection while being in the hand "area"

                mod.SelectionParams[PIndex].Mode = mod.SelectionParams.Modes.PACK
                mod:UseSelection(Player)
                return

            elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HAND then

                if mod.SelectionParams[PIndex].HandType ~= mod.HandTypes.NONE then

                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.HAND)
                
                    Isaac.RunCallback(mod.Callbalcks.HAND_PLAY, Player)
                end
                return
            end
        end

        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.DEATH1 then --then the card that will become a copy
            for i,v in ipairs(SelectedCards) do
                if v then
                    local selection = mod.Saved.Player[PIndex].CurrentHand[i] --gets the card that will be modified
                    mod.Saved.Player[PIndex].FullDeck[selection] = mod.Saved.Player[PIndex].FullDeck[DeathCopyCard]
                    Isaac.RunCallback("DECK_MODIFY", Player)
                end
            end
        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.HANGED then
            local selection = {}
            for i,v in ipairs(SelectedCards) do
                if v then
                    table.insert(selection, mod.Saved.Player[PIndex].CurrentHand[i]) --gets the card that will be modified
                end
            end

            mod:DestroyCards(Player, selection, true, true)

        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.STRENGTH then
            for i,v in ipairs(SelectedCards) do
                if v then
                    if mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value == 13 then
                        mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value = 1 --kings become aces
                    else
                        mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value = 
                        mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value + 1
                    end
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)
        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.CRYPTID then
            local Chosen
            for i,v in ipairs(SelectedCards) do
                if v then
                    Chosen = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]]
                    break
                end
            end

            mod:AddCardToDeck(Player, Chosen, 2, true)

        elseif mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.AURA then
            for i,v in ipairs(SelectedCards) do
                if v then
                    local EdRoll = Player:GetCardRNG(mod.Spectrals.AURA):RandomFloat()
                    if EdRoll <= 0.5 then
                        sfx:Play(mod.Sounds.FOIL, 0.6)
                        mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Edition = mod.Edition.FOIL
                    elseif EdRoll <= 0.85 then
                        sfx:Play(mod.Sounds.HOLO, 0.6)
                        mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Edition = mod.Edition.HOLOGRAPHIC
                    else
                        sfx:Play(mod.Sounds.POLY, 0.6)
                        mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Edition = mod.Edition.POLYCROME
                    end
                    break
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player, 0)

        --didn't want to put ~20 more elseifs so did this instead
        elseif mod.SelectionParams[PIndex].Purpose >= mod.SelectionParams.Purposes.DEJA_VU then
            local NewSeal = mod.SelectionParams[PIndex].Purpose - 16 --put the purposes in order to make this work
            for i,v in ipairs(SelectedCards) do
                if v then
                    mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = NewSeal --kings become aces
                    sfx:Play(mod.Sounds.SEAL)
                    break
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)

        elseif mod.SelectionParams[PIndex].Purpose >= mod.SelectionParams.Purposes.WORLD then 
            local NewSuit = mod.SelectionParams[PIndex].Purpose - mod.SelectionParams.Purposes.WORLD + 1--put the purposes in order to make this work
            for i,v in ipairs(SelectedCards) do
                if v then
                    mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Suit = NewSuit
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)
        elseif mod.SelectionParams[PIndex].Purpose >= mod.SelectionParams.Purposes.EMPRESS then
            local NewEnh = PurposeEnh[mod.SelectionParams[PIndex].Purpose] --put the purposes in order to make this work
            for i,v in ipairs(SelectedCards) do
                if v then
                    mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = NewEnh

                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player)
        end

        --print(mod.SelectionParams[PIndex].MaxSelectionNum)


    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then

        if mod.SelectionParams[PIndex].Purpose == mod.SelectionParams.Purposes.SMELTER then

            local SelectedSlot = mod:GetValueIndex(SelectedCards, true, true) --finds the first true

            local Joker = mod.Saved.Player[PIndex].Inventory[SelectedSlot].Joker

            if Joker == mod.Jokers.GOLDEN_JOKER then --or Joker == mod.Jokers.GOLDEN_TICKET then
                for i=1, 2 do --gives money 2 golden pennies
                    local Seed = Random()
                    Seed = Seed==0 and 1 or Seed

                    Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,Player.Position,RandomVector()*2,Player,CoinSubType.COIN_GOLDEN,Seed)
                end

                mod:SellJoker(Player, SelectedSlot)
            else
                mod:SellJoker(Player, SelectedSlot, 2)
            end
        end


    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.PACK then
        --THIS CAN ONLY HAPPEN FOR T.JIMBO
        --packs for base Jimbo activate directly on selection

        local PackIndex = mod:GetValueIndex(PackSelectedCards, true, true)

        if not PackIndex then
            return
        end

        local PackPurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag

        if PackPurpose == mod.SelectionParams.Purposes.TarotPack
           or PackPurpose == mod.SelectionParams.Purposes.SpectralPack
           or PackPurpose == mod.SelectionParams.Purposes.CelestialPack then
            
            local Success = mod:TJimboUseCard(mod:FrameToSpecialCard(mod.SelectionParams[PIndex].PackOptions[PackIndex]), Player)

            --local Success = mod:TJimboUseCard(Card.CARD_MAGICIAN, Player, 0)

            if not Success then
                
                --mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams[PIndex].PackPurpose)
                return
            end
            if mod.SelectionParams[PIndex].Purpose & mod.SelectionParams.Purposes.MegaFlag == mod.SelectionParams.Purposes.MegaFlag then
                
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose & ~mod.SelectionParams.Purposes.MegaFlag
                
                table.remove(mod.SelectionParams[PIndex].PackOptions, PackIndex)
                goto FINISH
            end
            
            mod.SelectionParams[PIndex].PackOptions = {}
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams.Purposes.NONE
        end

        if Game:GetRoom():IsClear() and false then

            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
            mod.Saved.EnableHand = false
        else
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
            mod.Saved.EnableHand = true
        end
        
    end

    ::FINISH::

    for i,_ in ipairs(SelectedCards) do
        SelectedCards[i] = false
    end

    if IsTaintedJimbo then
        for i,_ in ipairs(HandSelectedCards) do
            HandSelectedCards[i] = false
        end
        mod.SelectionParams[PIndex].SelectionNum = 0
    end
end



-------TRASH--------
--------------------
--[[
function mod:SubstituteCards(ChosenTable)
    for i = #ChosenTable, 1,-1 do
        if ChosenTable[i] then
            --first adds the ammount of new cards needed
            table.insert(mod.Saved.Player[PIndex].CurrentHand,#mod.Saved.Player[PIndex].CurrentHand+1, mod.Saved.Player[PIndex].DeckPointer)
            mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer +1
            --then removes the selected cards 
            table.remove(mod.Saved.Player[PIndex].CurrentHand,i)
        end
    end
    
end

---]]