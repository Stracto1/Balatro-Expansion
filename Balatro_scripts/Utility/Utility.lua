---@diagnostic disable: need-check-nil, param-type-mismatch
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()
local sfx = SFXManager()
local Level = Game:GetLevel()

local MAX_SEED_VALUE = 2^32 - 1

local DoorSides = {}
DoorSides.LEFT = 0
DoorSides.UP = 1
DoorSides.RIGHT = 2
DoorSides.DOWN = 3

local SCREEN_TO_WORLD_RATIO = 4

local EditionValue = {[mod.Edition.BASE] = 0,
                      [mod.Edition.FOIL] = 2,
                      [mod.Edition.HOLOGRAPHIC] = 3,
                      [mod.Edition.POLYCROME] = 5,
                      [mod.Edition.NEGATIVE] = 5}


local PackVariantPicker = WeightedOutcomePicker()
PackVariantPicker:AddOutcomeWeight(mod.Packs.ARCANA, 40)
PackVariantPicker:AddOutcomeWeight(mod.Packs.CELESTIAL, 40)
PackVariantPicker:AddOutcomeWeight(mod.Packs.STANDARD, 40)
PackVariantPicker:AddOutcomeWeight(mod.Packs.BUFFON, 12)
PackVariantPicker:AddOutcomeWeight(mod.Packs.SPECTRAL, 6)

local PackQualityPicker = WeightedOutcomePicker()
PackQualityPicker:AddOutcomeWeight(mod.PackQuality.BASE, 8)
PackQualityPicker:AddOutcomeWeight(mod.PackQuality.JUMBO, 4)
PackQualityPicker:AddOutcomeWeight(mod.PackQuality.MEGA, 1)


local ShopItemTypes = {JOKER = 0, PLANET = 1, TAROT = 2}
local ShopItemPicker = WeightedOutcomePicker()
WeightedOutcomePicker():AddOutcomeWeight(ShopItemTypes.JOKER, 20)
WeightedOutcomePicker():AddOutcomeWeight(ShopItemTypes.PLANET, 4)
WeightedOutcomePicker():AddOutcomeWeight(ShopItemTypes.TAROT, 4)


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



function mod:GetBitMaskMin(Mask)

    local MinValue = mod:GetBitMaskMax(Mask)

    for i = math.log(MinValue, 2), 0, -1 do

        local Val = 2^i
        
        if Val & Mask ~= 0 then
            MinValue = Val
        end
    end

    return MinValue
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
    mod.Saved.Labyrinth = 1
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

function mod:SmootherLerp(a,b,t)

    return a + (b - a) * (t^3 * (t*(6*t - 15) + 10))
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


function mod:IsFibonacciNumber(Number)

    local Test1 = (5*Number^2 - 4)^0.5
    local Test2 = (5*Number^2 + 4)^0.5

    return math.floor(Test1) == Test1 or math.floor(Test2) == Test2
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


---@param RNG RNG
function mod:RandomSeed(RNG)

    return RNG:RandomInt(MAX_SEED_VALUE) + 1
end

--for some reason i had difficulty using EntotyNPC:MakeBloodPoof()'s extra arguments so made this
function mod:TrueBloodPoof(Position, Scale, Color)


    local Poof = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, Position,
                            Vector.Zero, nil, 3, 1)

    Poof.SpriteScale = Vector.One * Scale
    Poof:SetColor(Color, -1, 100, false, false)

    local Poof = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, Position,
                            Vector.Zero, nil, 4, 1)

    Poof.SpriteScale = Vector.One * Scale
    Poof:SetColor(Color, -1, 100, false, false)

end


function mod:GetEIDLanguage()

    local Lang = EID and EID:getLanguage() or "en_us"
    if not mod:Contained(mod.EIDSupportedLanguages, Lang) then --defaults to english if the language is not supported
        Lang = "en_us"
    end

    return Lang
end

-------------JIMBO FUNCTIONS------------
---------------------------------------

function mod:RoundBalatroStyle(Value, MaxFigures)


    local Log = Value <= 0 and 2 or math.floor(math.log(Value, 10))

    local ValueString

    if Log >= MaxFigures then

        ValueString = mod:RoundBalatroStyle(mod:round(Value /10^Log, 3), 3).."e"..tostring(Log)

    else
        ValueString = tostring(mod:round(Value, math.max(2 - Log, 0)))
    end

    --if the number ends with .0 then erease it
    local i , e = string.find(ValueString, ".0", 1, true)

    if e == string.len(ValueString) then

        --print(ValueString,"erase")
        
        ValueString = string.gsub(Value, "%.0", "")
    end

    
    return ValueString
    
end


--determines the corresponding poker hand basing on the hand given
function mod:DeterminePokerHand(Player)

    local ElegibleHandTypes = mod.HandFlags.NONE

    local PIndex = Player:GetData().TruePlayerIndex

    local RealHand = {}

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then

        for i,Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            --print(i)
            if Selected then
                --print(i, "is selected")
                table.insert(RealHand, mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]])
            end
        end
    else
        for _,index in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            table.insert(RealHand, mod.Saved.Player[PIndex].FullDeck[index])

        end
    end

    if #RealHand > 0 then --shoud never happen but you never know...
        ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.HIGH_CARD
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
        ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.FLUSH
    end
    --straight check
    if IsStraight then
        ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.STRAIGHT
        if IsRoyal then
            ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.STRAIGHT_FLUSH
            ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.ROYAL_FLUSH
        elseif IsFlush then
            ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.ROYAL_FLUSH
        end
    end

    ------repetition based hands checks-------
    if EqualCards < 2 then --not even a pair (lame)
       return ElegibleHandTypes
    end
    --at least a pair
    ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.PAIR

    if EqualCards < 3 then --not a three of a kind
        if EqualCards == 2.5 then --in that case makes sure if it's a two pair
            ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.TWO_PAIR
        end
        return ElegibleHandTypes
    end
    --at least a three of a kind
    ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.THREE

    if EqualCards < 4 then
        if EqualCards == 3.5 then
            if IsFlush then
                ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.FLUSH_HOUSE
            end
            ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.FULL_HOUSE
        end
        return ElegibleHandTypes
    end
     --at least a four of a kind
     ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.FOUR

    if EqualCards < 5 then 
        return ElegibleHandTypes
    end
    --a five of a kind
    if IsFlush then
        ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.FIVE_FLUSH
    end
    ElegibleHandTypes = ElegibleHandTypes + mod.HandFlags.FIVE

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


function mod:GetHandTypeFromFlag(HandFlag)

    return math.log(mod:GetBitMaskMax(HandFlag), 2)
end


function mod:GetScoringCards(Player, HandType)

    local PIndex = Player:GetData().TruePlayerIndex

    local PlayerHand = {}

    for _,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

        table.insert(PlayerHand, mod.Saved.Player[PIndex].FullDeck[Pointer])
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

        local ValueToKeepStreak = ValueTable[1]
        local StraightStreak = 0

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

            elseif CardValue ~= ValueToKeepStreak - 1 then --logically this can only happen once since at least 4/5 cards need to be compatible
            
                if StraightStreak < 4 then --reset and continue
                    StraightStreak = 1 
                    ValueToKeepStreak = CardValue + 1
                    StreakStart = i

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

        local ValueToKeepStreak = ValueTable[1]
        local StraightStreak = 0

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

            elseif CardValue ~= ValueToKeepStreak - 1 then --logically this can only happen once since at least 4/5 cards need to be compatible
            
                if StraightStreak < 4 then --reset and continue
                    StraightStreak = 1 
                    ValueToKeepStreak = CardValue + 1
                    StreakStart = i

                else --stop
                    break
                end  
            end
        end


        for i = StreakStart, StraightStreak do
            
            ReturnMask = ReturnMask | 2^(i-1)
        end

    else --any hand that requires 5 cards

        ReturnMask = math.maxinteger ---every card scores
    end

    for i,Card in ipairs(PlayerHand) do
        if Card.Enhancement == mod.Enhancement.STONE then --every stone card is scoring
            
            ReturnMask = ReturnMask | 2^(i-1)
        end
    end

    --print(ReturnMask)

    return ReturnMask
end

function mod:PlayedCardIsScored(PIndex, Index) 
    return mod.SelectionParams[PIndex].ScoringCards & 2^(Index-1) ~= 0
end


function mod:GetValueScoring(Value)
    if Value >=10 then
        return 10
    elseif Value == 1 then
        return 11
    end
    return Value
end

function mod:JimboHasTrinket(Player,Trinket)
    if Player:GetPlayerType() ~= mod.Characters.JimboType
       and Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
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


function mod:PlayerCanAfford(Price)

    if Price <= 0 then
        return true
    end

    local MaxDebt = 0
    local Coins = Game:GetPlayer(0):GetNumCoins()

    for i,Player in ipairs(PlayerManager:GetPlayers()) do
        
        MaxDebt = MaxDebt + 20 * #mod:GetJimboJokerIndex(Player, mod.Jokers.CREDIT_CARD, true)
    end

    if not mod.Saved.HasDebt then
        return Coins >= Price or math.abs(Coins - Price) <= MaxDebt
    end

    return Coins + Price <= MaxDebt

end


function mod:GetJimboJokerIndex(Player, Joker, SkipCopy)
    local Indexes = {}

    if Player:GetPlayerType() ~= mod.Characters.JimboType
       and Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then

        return Indexes
    end


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


function mod:IsValue(Player, Card, WantedValue)

    if WantedValue == mod.Values.FACE then
        
        return (Card.Value >= mod.Values.JACK and Card.Enhancement ~= mod.Enhancement.STONE)
               or mod:JimboHasTrinket(Player, mod.Jokers.PAREIDOLIA)
    else
        return Card.Value == WantedValue and Card.Enhancement ~= mod.Enhancement.STONE
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
    local JokerConfig = ItemsConfig:GetTrinket(Joker)

    if not JokerConfig:HasCustomTag("balatro") then
        return JokerConfig.ShopPrice
    end

    local numstring = string.gsub(JokerConfig:GetCustomTags()[1],"%!","")

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

    local Prog
    if Tainted then

        local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)
        local PIndex = T_Jimbo:GetData().TruePlayerIndex

        local JokerRNG = T_Jimbo:GetTrinketRNG(Joker)

        if Joker == mod.Jokers.IDOL then

            local ValidCards = {}
            local RandomCard = {}
            local Suit = 0
            local Value = 0

            for Pointer, card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                if card.Enhancement ~= mod.Enhancement.STONE then
                    ValidCards[#ValidCards+1] = Pointer
                end
            end
            
            if next(ValidCards) then
                RandomCard = mod.Saved.Player[PIndex].FullDeck[mod:GetRandom(ValidCards, JokerRNG, true)]
                Suit = RandomCard.Suit
                Value = RandomCard.Value
            else
                Suit = mod.Suits.Spade
                Value = 1
            end
            
            Prog = Suit + 8*Value

        elseif Joker == mod.Jokers.MAIL_REBATE then
            
            Prog = JokerRNG:PhantomInt(mod.Values.KING) + 1
        elseif Joker == mod.Jokers.CASTLE then

            Prog = mod.Saved.Player[PIndex].FullDeck[JokerRNG:PhantomInt(#mod.Saved.Player[PIndex].FullDeck)+1].Suit
        
        elseif Joker == mod.Jokers.ANCIENT_JOKER then
            Prog = JokerRNG:PhantomInt(mod.Suits.Diamond) + 1

        elseif Joker == mod.Jokers.TO_DO_LIST then

            Prog = mod:RandomHandType(JokerRNG, true)
        
        else

            Prog = tonumber(string.gsub(Config:GetCustomTags()[3],"%:",""), 10)
        end

    else

        local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)
        local PIndex = Jimbo:GetData().TruePlayerIndex

        local JokerRNG = Jimbo:GetTrinketRNG(Joker)

        if Joker == mod.Jokers.IDOL then

            local ValidCards = {}
            local RandomCard = {}
            local Suit = 0
            local Value = 0

            for Pointer, card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                if card.Enhancement ~= mod.Enhancement.STONE then
                    ValidCards[#ValidCards+1] = Pointer
                end
            end
            
            if next(ValidCards) then
                RandomCard = mod.Saved.Player[PIndex].FullDeck[mod:GetRandom(ValidCards, JokerRNG, true)]
                Suit = RandomCard.Suit
                Value = RandomCard.Value
            else
                Suit = mod.Suits.Spade
                Value = 1
            end
            
            Prog = Suit + 8*Value

        elseif Joker == mod.Jokers.MAIL_REBATE then
            
            Prog = JokerRNG:PhantomInt(mod.Values.KING) + 1
        elseif Joker == mod.Jokers.CASTLE then

            Prog = mod.Saved.Player[PIndex].FullDeck[JokerRNG:PhantomInt(#mod.Saved.Player[PIndex].FullDeck)+1].Suit
        
        elseif Joker == mod.Jokers.ANCIENT_JOKER then
            Prog = JokerRNG:PhantomInt(mod.Suits.Diamond) + 1

        elseif Joker == mod.Jokers.TO_DO_LIST then

            Prog = mod:RandomHandType(JokerRNG, true)
        else

            Prog = tonumber(Config:GetCustomTags()[2], 10)
        end
    end

    return Prog
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

    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..SellValue.."$", mod.EffectType.ENTITY, Player)


    --Isaac.RunCallback("INVENTORY_CHANGE", Player)
    Isaac.RunCallback("JOKER_SOLD", Player, Trinket, Slot)

    return true
end


function mod:GetConsumableCost(Consumable, Edition, SellSlot, Player)

    local PIndex = Player:GetData().TruePlayerIndex

    local IsSpectral = Consumable >= mod.Spectrals.FAMILIAR and Consumable <= mod.Spectrals.SOUL

    local SellValue = ((IsSpectral and 4 or 3) + EditionValue[Edition])

    local Discount = 1
    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Liquidation) then
        Discount = 0.5
    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Clearance) then
        Discount = 0.75
    end


    local Cost = math.floor(SellValue * Discount)

    if SellSlot then
        Cost = math.floor(Cost/2)

        local GiftExtra = mod.Saved.Player[PIndex].GiftCardConsumableExtra[SellSlot]

        GiftExtra = GiftExtra or 0

        Cost = Cost + GiftExtra
    end


    return math.max(Cost, 1)
end

---@param Player EntityPlayer
function mod:SellConsumable(Player, SlotToSell)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return false
    end

    local PIndex = Player:GetData().TruePlayerIndex
    --local NumConsumables = #mod.Saved.Player[PIndex].Consumables
    local CardToSell = mod.Saved.Player[PIndex].Consumables[SlotToSell]

    if CardToSell.Card == -1 then
        return false
    end

    local SellValue = mod:GetConsumableCost(mod:FrameToSpecialCard(CardToSell.Card), CardToSell.Edition, true)

    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..SellValue.."$", mod.EffectType.ENTITY, Player)
    Player:AddCoins(SellValue)

    mod.Saved.Player[PIndex].Consumables[SlotToSell].Card = -1
    mod.Saved.Player[PIndex].Consumables[SlotToSell].Edition = mod.Editios.NONE

    Isaac.RunCallback(mod.Callbalcks.CONSUMABLE_SOLD, Player, CardToSell)

    return true
end


local JeditionChance = {0.02, 0.034, 0.037, 0.003}
function mod:RandomJoker(Rng, PlaySound, ForcedRarity, AllowDuplicates, Amount)
    
    
    Amount = Amount or 1

    local Possibilities = {}
    local Exeptions = {} --jokers to remove from the pool

    local HasShowman = false
    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) then
            HasShowman = true
        end
    end

    AllowDuplicates = AllowDuplicates or HasShowman

    if not AllowDuplicates then --add to exeptions jokers held and in the room
    
        for i, Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.JimboType 
            or Player:GetPlayerType() == mod.Characters.TaintedJimbo then

                local PIndex = Player:GetData().TruePlayerIndex

                for _, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
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

    for _,v in ipairs(Exeptions) do

        Possibilities[mod:GetValueIndex(Possibilities, v, true)] = nil
    end

    local EdMult = 1

    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Hone) then
        EdMult = EdMult * 2
    end
    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.GlowUp) then
        EdMult = EdMult * 2
    end



    local ReturnTable = {}

    for i = 1, Amount do

        ReturnTable[i] = {}

        local Trinket = {}

        repeat

            if not next(Possibilities) then
                Trinket.Joker = mod.Jokers.JOKER --default trinket
                break
            end

            Trinket.Joker = mod:GetRandom(Possibilities, Rng)

            ---@diagnostic disable-next-line: param-type-mismatch
            table.remove(Possibilities, mod:GetValueIndex(Possibilities, Trinket.Joker, true))

        until (Trinket.Joker ~= mod.Jokers.GROS_MICHAEL or not mod.Saved.MichelDestroyed) --if it's michel, check if it was destroyed
              and (Trinket.Joker ~= mod.Jokers.CAVENDISH or mod.Saved.MichelDestroyed) --if it's cavendish do the same but opposite
    
    
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

        Trinket.Modifiers = 0

        Trinket.Progress = mod:GetJokerInitialProgress(Trinket.Joker, PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo))

        ReturnTable[i] = Trinket
    end

    if Amount == 1 then
        return ReturnTable[1]
    else
        return ReturnTable
    end
end


function mod:RandomTarot(Rng, CanBeSoul, AllowDuplicates, Amount)

    Amount = Amount or 1
    local IsTaintedJimbo = PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo)
    local PIndex

    local HasShowman = false

    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) then
            HasShowman = true
        end
    end

    AllowDuplicates = AllowDuplicates or HasShowman

    local PossibleTarots = {}
    local IsSoulAvailable = CanBeSoul

    for i = Card.CARD_FOOL, Card.CARD_WORLD do
        PossibleTarots[i] = i
    end 

    if IsTaintedJimbo then
        PIndex = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo):GetData().TruePlayerIndex
    end


    if not AllowDuplicates then
        
        -----removes from the pool planets held
        if IsTaintedJimbo then
            
            for i,Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do
                
                local Consumable = mod:FrameToSpecialCard(Slot.Card)
                
                if Consumable == mod.Spectrals.SOUL then
                    IsSoulAvailable = false
                else
                    PossibleTarots[Consumable] = nil
                end
            end

        else
            for _,Player in ipairs(PlayerManager.GetPlayers()) do

                PIndex = Player:GetData().TruePlayerIndex

                for i = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY do

                    local Consumable = Player:GetCard(i)

                    if Consumable then

                        if Consumable == mod.Spectrals.SOUL then
                            IsSoulAvailable = false
                        else
                            PossibleTarots[Consumable] = nil
                        end
                    end
                end
            end
        end

        -----removes from the pool planets in any opened pack
        for _,Player in ipairs(PlayerManager.GetPlayers()) do

            PIndex = Player:GetData().TruePlayerIndex

            for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
                local Consumable = mod:FrameToSpecialCard(Option)

                if Consumable == mod.Spectrals.SOUL then
                    IsSoulAvailable = false
                else
                    PossibleTarots[Consumable] = nil
                end
            end
        end

        if not IsTaintedJimbo then
            
            for i, PlanetCard in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, -1, true)) do

                if PlanetCard.SubType == mod.Spectrals.SOUL then
                    IsSoulAvailable = false
                else
                    PossibleTarots[PlanetCard.SubType] = nil
                end
            end

        end
    end

    local ReturnTable = {}

    for i=1, Amount do

        if IsSoulAvailable and Rng:RandomFloat() < 0.003 then
            ReturnTable[i] = mod.Spectrals.SOUL

            IsSoulAvailable = AllowDuplicates
        end

        if not next(PossibleTarots) then
            ReturnTable[i] = Card.CARD_FOOL
        end

        ReturnTable[i] = mod:GetRandom(PossibleTarots, Rng)

        PossibleTarots[ReturnTable[i]] = nil
    end

    if Amount == 1 then
        return ReturnTable[1]
    else
        return ReturnTable
    end

end


function mod:RandomPlanet(Rng, CanBeHole, AllowDuplicates, Amount)

    Amount = Amount or 1
    local IsTaintedJimbo = PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo)
    local PIndex

    local HasShowman = false

    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) then
            HasShowman = true
        end
    end

    AllowDuplicates = AllowDuplicates or HasShowman

    local PossiblePlanets = {}
    local IsHoleAvailable = CanBeHole

    for _,Planet in pairs(mod.Planets) do

        local Hand = Planet - mod.Planets.PLUTO + 2

        local IsUnlocked = true

        if ((Hand == mod.HandTypes.FIVE
           or Hand == mod.HandTypes.FIVE_FLUSH
           or Hand == mod.HandTypes.FLUSH_HOUSE)
           and mod.Saved.HandsTypeUsed[Hand] == 0) --secret hands need to be unlocked
           or Hand == mod.HandTypes.ROYAL_FLUSH --this hand type sucks ass
           or Hand == mod.HandTypes.NONE --no such planet
           or (Hand == mod.HandTypes.SUN --would cause a rapture in the quantum space time
               and IsTaintedJimbo) then --also scemo chi legge
            
            IsUnlocked = false
        end

        if IsUnlocked then
            PossiblePlanets[#PossiblePlanets+1] = Planet
        end

    end 

    if IsTaintedJimbo then


        PossiblePlanets.SUN = nil
        PIndex = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo):GetData().TruePlayerIndex
    end


    if not AllowDuplicates then
        
        -----removes from the pool planets held
        if IsTaintedJimbo then
            
            for i,Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do
                
                local Consumable = mod:FrameToSpecialCard(Slot.Card)
                local Index = mod:GetValueIndex(PossiblePlanets, Consumable, true)

                if Index then
                    PossiblePlanets[Index] = nil
                elseif Consumable == mod.Spectrals.BLACK_HOLE then
                    IsHoleAvailable = false
                end
            end

        else
            for _,Player in ipairs(PlayerManager.GetPlayers()) do

                PIndex = Player:GetData().TruePlayerIndex

                for i = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY do

                    local Consumable = Player:GetCard(i)

                    if Consumable then

                        local Index = mod:GetValueIndex(PossiblePlanets, Consumable, true)

                        if Index then
                            PossiblePlanets[Index] = nil
                        elseif Consumable == mod.Spectrals.BLACK_HOLE then
                            IsHoleAvailable = false
                        end
                    end
                end
            end
        end

        -----removes from the pool planets in any opened pack
        for _,Player in ipairs(PlayerManager.GetPlayers()) do

            PIndex = Player:GetData().TruePlayerIndex

            for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
                local Consumable = mod:FrameToSpecialCard(Option)
                local Index = mod:GetValueIndex(PossiblePlanets, Consumable, true)
                
                if Index then
                    PossiblePlanets[Index] = nil

                elseif Consumable == mod.Spectrals.BLACK_HOLE then
                    IsHoleAvailable = false
                end
            end
        end

        if not IsTaintedJimbo then
            
            for i, PlanetCard in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, -1, true)) do

                local Index = mod:GetValueIndex(PossiblePlanets, PlanetCard.SubType, true)

                if Index then
                    PossiblePlanets[Index] = nil

                elseif PlanetCard.SubType == mod.Spectrals.BLACK_HOLE then
                    IsHoleAvailable = false
                end
            end

        end
    end

    local ReturnTable = {}

    for i = 1, Amount do

        if IsHoleAvailable and Rng:RandomFloat() < 0.003 then
            ReturnTable[i] = mod.Spectrals.BLACK_HOLE
            IsHoleAvailable = AllowDuplicates
        end

        if not next(PossiblePlanets) then
            ReturnTable[i] = mod.Planets.PLUTO
        end

        ReturnTable[i] = mod:GetRandom(PossiblePlanets, Rng)

        PossiblePlanets[mod:GetValueIndex(PossiblePlanets, ReturnTable[i], true)] = nil
    end

    if Amount == 1 then
        return ReturnTable[1]
    else
        return ReturnTable
    end

end



function mod:RandomSpectral(Rng, CanBeHole, CanBeSoul, AllowDuplicates, Amount)

    Amount = Amount or 1
    local IsTaintedJimbo = PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo)
    local PIndex

    local HasShowman = false

    for i, Player in ipairs(PlayerManager.GetPlayers()) do
        if mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN) then
            HasShowman = true
        end
    end

    AllowDuplicates = AllowDuplicates or HasShowman

    local PossibleSpectrals = {}
    local IsHoleAvailable = CanBeHole
    local IsSoulAvailable = CanBeSoul

    for k,v in pairs(mod.Spectrals) do
        PossibleSpectrals[k] = v
    end 

    PossibleSpectrals.SOUL = nil
    PossibleSpectrals.BLACK_HOLE = nil

    if IsTaintedJimbo then
        PIndex = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo):GetData().TruePlayerIndex
    end


    if not AllowDuplicates then
        
        -----removes from the pool planets held
        if IsTaintedJimbo then
            
            for i,Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do
                
                local Consumable = mod:FrameToSpecialCard(Slot.Card)
                local Index = mod:GetValueIndex(PossibleSpectrals, Consumable, true)

                if Index then
                    PossibleSpectrals[Index] = nil
                elseif Consumable == mod.Spectrals.SOUL then
                    IsSoulAvailable = false
                elseif Consumable == mod.Spectrals.BLACK_HOLE then
                    IsHoleAvailable = false
                end
            end

        else
            for _,Player in ipairs(PlayerManager.GetPlayers()) do

                PIndex = Player:GetData().TruePlayerIndex

                for i = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY do

                    local Consumable = Player:GetCard(i)

                    if Consumable then

                        local Index = mod:GetValueIndex(PossibleSpectrals, Consumable, true)

                        if Index then
                            PossibleSpectrals[Index] = nil
                        elseif Consumable == mod.Spectrals.SOUL then
                            IsSoulAvailable = false
                        elseif Consumable == mod.Spectrals.BLACK_HOLE then
                            IsHoleAvailable = false
                        end
                    end
                end
            end
        end

        -----removes from the pool planets in any opened pack
        for _,Player in ipairs(PlayerManager.GetPlayers()) do

            PIndex = Player:GetData().TruePlayerIndex

            for i,Option in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            
                local Consumable = mod:FrameToSpecialCard(Option)
                local Index = mod:GetValueIndex(PossibleSpectrals, Consumable, true)
                
                if Index then
                    PossibleSpectrals[Index] = nil

                elseif Consumable == mod.Spectrals.SOUL then
                    IsSoulAvailable = false
                elseif Consumable == mod.Spectrals.BLACK_HOLE then
                    IsHoleAvailable = false
                end
            end
        end

        if not IsTaintedJimbo then
            
            for i, PlanetCard in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, -1, true)) do

                local Index = mod:GetValueIndex(PossibleSpectrals, PlanetCard.SubType, true)

                if Index then
                    PossibleSpectrals[Index] = nil

                elseif PlanetCard.SubType == mod.Spectrals.SOUL then
                    IsSoulAvailable = false
                elseif PlanetCard.SubType == mod.Spectrals.BLACK_HOLE then
                    IsHoleAvailable = false
                end
            end

        end
    end

    local ReturnTable = {}

    for i=1, Amount do
        
        local SpecialRoll = Rng:RandomFloat()

        if IsHoleAvailable and SpecialRoll <= 0.003 then
            ReturnTable[i] = mod.Spectrals.BLACK_HOLE
        elseif IsSoulAvailable and SpecialRoll >= 0.997 then
            ReturnTable[i] = mod.Spectrals.SOUL
        end

        if not next(PossibleSpectrals) then
            ReturnTable[i] = mod.Spectrals.FAMILIAR
        end

        ReturnTable[i] = mod:GetRandom(PossibleSpectrals, Rng)

        table.remove(PossibleSpectrals, mod:GetValueIndex(PossibleSpectrals, ReturnTable[i], true))
    end

    if Amount == 1 then
        return ReturnTable[1]
    else
        return ReturnTable
    end
end


function mod:RandomPack(Rng, RollQuality)

    local Pack = PackVariantPicker:PickOutcome(Rng)

    if RollQuality then
        Pack = Pack + PackQualityPicker:PickOutcome(Rng)
    end

    return Pack
end


function mod:RandomShopItem(Rng)

    local Variant
    local SubType

    local TagActivated
    local ItemType
    local JokerRarity --nil if randomly chosen


    for i, Tag in ipairs(mod.Saved.SkipTags) do

        if Tag == mod.SkipTags.UNCOMMON then

            mod:UseSkipTag(i)
            TagActivated = true
            ItemType = ShopItemTypes.JOKER
            JokerRarity = "uncommon"

            goto RNG_PART

        elseif Tag == mod.SkipTags.RARE then

            mod:UseSkipTag(i)
            TagActivated = true
            ItemType = ShopItemTypes.JOKER
            JokerRarity = "rare"

            goto RNG_PART
        end
    end


    ItemType = ShopItemPicker:PickOutcome(Rng)

    ::RNG_PART::

    if ItemType == ShopItemTypes.JOKER then
        Variant = PickupVariant.PICKUP_TRINKET

        local Joker = mod:RandomJoker(Rng, true, JokerRarity)

        if Joker.Edition == mod.Edition.BASE then

            for i, Tag in ipairs(mod.Saved.SkipTags) do

                if Tag == mod.SkipTags.FOIL then
                    mod:UseSkipTag(i)
                    TagActivated = true
                    Joker.Edition = mod.Edition.FOIL
                    break

                elseif Tag == mod.SkipTags.HOLO then
                    mod:UseSkipTag(i)
                    TagActivated = true
                    Joker.Edition = mod.Edition.HOLOGRAPHIC
                    break

                elseif Tag == mod.SkipTags.POLYCHROME then
                    mod:UseSkipTag(i)
                    TagActivated = true
                    Joker.Edition = mod.Edition.POLYCROME
                    break

                elseif Tag == mod.SkipTags.NEGATIVE then
                    mod:UseSkipTag(i)
                    TagActivated = true
                    Joker.Edition = mod.Edition.NEGATIVE
                    break
                end
            end
        end

        SubType = Joker.Joker

        mod.Saved.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Joker.Joker).Name] = Joker.Edition

    elseif ItemType == ShopItemTypes.TAROT then
        Variant = PickupVariant.PICKUP_TAROTCARD

        SubType = mod:RandomTarot(Rng)

    else --if Type == SHopItemTypes.PLANET
        Variant = PickupVariant.PICKUP_TAROTCARD

        SubType = mod:RandomPlanet(Rng)
    end

    ::RETURN::

    return Variant, SubType, TagActivated

end


function mod:RandomSkipTag(Rng)

    local Tag = mod:GetRandom(mod.Saved.Pools.SkipTags, Rng)

    if Tag == mod.SkipTags.ORBITAL then
        
        Tag = Tag | mod:RandomHandType(mod.RNGs.SKIP_TAGS)
    end

    return Tag
end


function mod:RandomHandType(Rng, Phantom)

    local PossibleHands = {}

    for _, Hand in pairs(mod.HandTypes) do
        
        local IsUnlocked = true

        if ((Hand == mod.HandTypes.FIVE
           or Hand == mod.HandTypes.FIVE_FLUSH
           or Hand == mod.HandTypes.FLUSH_HOUSE)
           and mod.Saved.HandsTypeUsed[Hand] == 0) --secret hands need to be unlocked
           or Hand == mod.HandTypes.ROYAL_FLUSH --this hand type sucks ass
           or Hand == mod.HandTypes.NONE then --scemo chi legge
            
            IsUnlocked = false
        end

        if IsUnlocked then
            PossibleHands[#PossibleHands+1] = Hand
        end
    end

    return mod:GetRandom(PossibleHands, Rng, Phantom)
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
            return "{{ColorSpade}}Spades{{CR}}"
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
        return "Diamonds"
    end

end

function mod:GetCardName(Card, IsEID)

    local Name = ""
    
    if Card.Enhancement == mod.Enhancement.STONE then

        local Lang = mod:GetEIDLanguage()

        if IsEID then
            
            Name = mod.Descriptions.EnhancementName[mod.Enhancement.STONE][Lang] or mod.Descriptions.EnhancementName[mod.Enhancement.STONE]["en_us"]
        else
            Name = mod.Descriptions.BasicEnhancementName[mod.Enhancement.STONE][Lang] or mod.Descriptions.BasicEnhancementName[mod.Enhancement.STONE]["en_us"]
        end
    else
        Name = mod:CardValueToName(Card.Value, IsEID)
        
        if IsEID then
            Name = Name.."{{B_Black}} of "..mod:CardSuitToName(Card.Suit, IsEID)
        else
            Name = Name.." of "..mod:CardSuitToName(Card.Suit, IsEID)
        end
        

    end

    return Name
end


function mod:AddSkipTag(TagAdded)

    table.insert(mod.Saved.SkipTags, 1, TagAdded)

    local Interval = 8

    if TagAdded ~= mod.SkipTags.DOUBLE then
        for i,Tag in ipairs(mod.Saved.SkipTags) do

            if Tag == mod.SkipTags.DOUBLE then

                --remove the first double tag found and duplicate the originally added one
                Isaac.CreateTimer(function ()
                    mod:UseSkipTag(i)
                    mod:AddSkipTag(TagAdded)
                end, Interval, 1, true)

                Interval = Interval + 20

            end
        end
    end

    Isaac.CreateTimer(function ()
        
        Isaac.RunCallback(mod.Callbalcks.POST_SKIP_TAG_ADDED, TagAdded)

    end, Interval, 1, true)

    return Interval
end


function mod:UseSkipTag(Pos)

    table.remove(mod.Saved.SkipTags, Pos)

    sfx:Play(mod.Sounds.SLICE) --PLACEHOLDER
end


---@param Player EntityPlayer
---@param StopEvaluation boolean this is only set when called in mod:AddJoker
local function JimboAddTrinket(_, Player, Trinket, _, StopEvaluation)

    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

    if not IsTaintedJimbo
       and Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
        
    Player:TryRemoveTrinket(Trinket) -- a custom table is used instead since he needs to hold many of them

    local JokerEdition = mod.Saved.FloorEditions[Level:GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Trinket).Name] or mod.Edition.BASE 

    
    local EmptySlot

    if JokerEdition == mod.Edition.NEGATIVE then
    
        EmptySlot = #mod.Saved.Player[PIndex].Inventory + 1
        mod.Saved.Player[PIndex].Inventory[EmptySlot] = {}
    else

        local Empties = mod:GetJimboJokerIndex(Player, 0,true)

        EmptySlot = Empties[#Empties]
    end

    if not EmptySlot then

        Isaac.CreateTimer(function ()
            Player:AnimateSad()
        end,0,1,false)
        
        return false
    end

    mod.Counters.SinceSelect = 0

    mod.Saved.LastJokerRenderIndex = mod.Saved.LastJokerRenderIndex + 1

    mod.Saved.Player[PIndex].Inventory[EmptySlot].Joker = Trinket
    mod.Saved.Player[PIndex].Inventory[EmptySlot].Edition = JokerEdition
    mod.Saved.Player[PIndex].Inventory[EmptySlot].Modifiers = 0
    mod.Saved.Player[PIndex].Inventory[EmptySlot].RenderIndex = mod.Saved.LastJokerRenderIndex


    mod.Saved.Player[PIndex].Progress.Inventory[EmptySlot] = mod:GetJokerInitialProgress(Trinket, IsTaintedJimbo)

    if not StopEvaluation then
        Isaac.RunCallback("JOKER_ADDED", Player, Trinket, JokerEdition, EmptySlot)
        Isaac.RunCallback("INVENTORY_CHANGE", Player)
    end

    return true
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED,CallbackPriority.IMPORTANT, JimboAddTrinket)


function mod:AddJoker(Player, Joker, Edition, StopEval)
    --local PIndex = Player:GetData().TruePlayerIndex

    Edition = Edition or mod.Edition.BASE

    mod.Saved.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Joker).Name] = Edition

    return JimboAddTrinket(nil, Player, Joker, false, StopEval)
end


function mod:AddCardToDeck(Player, CardTable,Amount, PutInHand)

    if Amount <= 0 then
        return
    end

    CardTable.Enhancement = CardTable.Enhancement or mod.Enhancement.NONE
    CardTable.Edition = CardTable.Edition or mod.Edition.BASE
    CardTable.Seal = CardTable.Seal or mod.Seals.NONE
    CardTable.Modifiers = CardTable.Modifiers or 0

    CardTable.Modifiers = CardTable.Modifiers | mod:GetCardModifiers(Player, CardTable)

    local PIndex = Player:GetData().TruePlayerIndex

    for i=1, Amount do
        table.insert(mod.Saved.Player[PIndex].FullDeck,1, CardTable) --adds it to pos 1 so it can't be seen again
    end

    for i,_ in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        mod.Saved.Player[PIndex].CurrentHand[i] = mod.Saved.Player[PIndex].CurrentHand[i] + Amount --fixes the jump made by table.insert
    end

    for i,_ in ipairs(mod.SelectionParams[PIndex].PlayedCards or {}) do
        mod.SelectionParams[PIndex].PlayedCards[i] = mod.SelectionParams[PIndex].PlayedCards[i] + Amount --fixes the jump made by table.insert
    end

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_PILLAR then
        for i,_ in ipairs(mod.Saved.BossBlindVarData) do
            mod.Saved.BossBlindVarData[i] = mod.Saved.BossBlindVarData[i] + Amount --fixes the jump made by table.insert
        end
    end

    mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + Amount --fixes the jump made by table.insert


    if PutInHand then
        for i=1, Amount do
            table.insert(mod.Saved.Player[PIndex].CurrentHand, i) --adds it to the hand if necessary
        end
    end

    if Player:GetPlayerType() == mod.Characters.JimboType then
        mod.CardFullPoss = {} --hud does wierd stuff otherwise
    end

    Isaac.RunCallback("DECK_MODIFY", Player, Amount)
end


local CardGotDestroyed = false
function mod:DestroyCards(Player, DeckIndexes, DoEffects, BlockSubstitution)

    local PIndex = Player:GetData().TruePlayerIndex
    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

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

    for _, DestroyedPointer in ipairs(DeckIndexes) do

        local CardParams = mod.Saved.Player[PIndex].FullDeck[DestroyedPointer]

        DestroyedParams[#DestroyedParams+1] = CardParams

        if mod:Contained(mod.Saved.Player[PIndex].CurrentHand, DestroyedPointer)
           and (#mod.Saved.Player[PIndex].CurrentHand > Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)
           or BlockSubstitution) then
        
            --removes the pointer from the hand so it doesn't become the next card in the deck
            ---@diagnostic disable-next-line: param-type-mismatch
            table.remove(mod.Saved.Player[PIndex].CurrentHand, mod:GetValueIndex(mod.Saved.Player[PIndex].CurrentHand, DestroyedPointer, true))
        
        end


        for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if Pointer >= DestroyedPointer then
                mod.Saved.Player[PIndex].CurrentHand[i] = mod.Saved.Player[PIndex].CurrentHand[i] - 1 --fixes the gap made by table.remove
            end
        end


        if IsTaintedJimbo
           and mod:Contained(mod.SelectionParams[PIndex].PlayedCards, DestroyedPointer) then

            table.remove(mod.SelectionParams[PIndex].PlayedCards, mod:GetValueIndex(mod.SelectionParams[PIndex].PlayedCards, DestroyedPointer, true))
        
            for i,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards or {}) do

                if Pointer >= DestroyedPointer then
                    mod.SelectionParams[PIndex].PlayedCards[i] = mod.SelectionParams[PIndex].PlayedCards[i] - 1 --fixes the gap made by table.remove
                end
            end

            if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_PILLAR then
                
                for i,Pointer in ipairs(mod.Saved.BossBlindVarData) do
                    if Pointer >= DestroyedPointer then
                        mod.SelectionParams[PIndex].PlayedCards[i] = mod.SelectionParams[PIndex].PlayedCards[i] - 1 --fixes the gap made by table.remove
                    end
                end

            end
        end

        table.remove(mod.Saved.Player[PIndex].FullDeck, DestroyedPointer)
        
        if DoEffects then
            mod:CardRipEffect(CardParams, IsTaintedJimbo and Isaac.ScreenToWorld(mod.CardFullPoss[DestroyedPointer]) * SCREEN_TO_WORLD_RATIO or Player.Position)
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



--gets the hypothetical modifiers basing on card and current boss blind
function mod:GetCardModifiers(Player, Card, Pointer)

    local BlindType = mod.Saved.BlindBeingPlayed

    local CardModifiers = 0

    if BlindType == mod.BLINDS.BOSS_CLUB then

        if mod:IsSuit(Player, Card, mod.Suits.Club) then
            CardModifiers = mod.Modifier.DEBUFFED
        end

    elseif BlindType == mod.BLINDS.BOSS_GOAD then

        if mod:IsSuit(Player, Card, mod.Suits.Spade) then
            CardModifiers = mod.Modifier.DEBUFFED
        end

    elseif BlindType == mod.BLINDS.BOSS_HEAD then

        if mod:IsSuit(Player, Card, mod.Suits.Heart) then
            CardModifiers = mod.Modifier.DEBUFFED
        end

    elseif BlindType == mod.BLINDS.BOSS_WINDOW then

        if mod:IsSuit(Player, Card, mod.Suits.Diamond) then
            CardModifiers = mod.Modifier.DEBUFFED
        end

    elseif BlindType == mod.BLINDS.BOSS_PLANT then

        if mod:IsValue(Player, Card, mod.Values.FACE) then
            CardModifiers = mod.Modifier.DEBUFFED
        end

    elseif BlindType == mod.BLINDS.BOSS_MARK then

        if mod:IsValue(Player, Card, mod.Values.FACE) then
            CardModifiers = mod.Modifier.COVERED
        end

    elseif BlindType == mod.BLINDS.BOSS_PILLAR then

        if mod:Contained(mod.Saved.BossBlindVarData, Pointer) then
            CardModifiers = mod.Modifier.DEBUFFED
        end

    elseif BlindType == mod.BLINDS.BOSS_LEAF then

        CardModifiers = mod.Modifier.DEBUFFED --every card is debuffed

    elseif BlindType == mod.BLINDS.BOSS_WHEEL then

        if mod:TryGamble(Player, nil, 1/7) then
            
            CardModifiers = mod.Modifier.COVERED
        end
    end


    return CardModifiers
end



--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if not (Player:GetPlayerType() == mod.Characters.JimboType
       or Player:GetPlayerType() == mod.Characters.TaintedJimbo) then

        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local PlayerRNG = Player:GetDropRNG()

    
    mod.Saved.Player[PIndex].CurrentHand = {}


    mod.Saved.Player[PIndex].FullDeck = mod:Shuffle(mod.Saved.Player[PIndex].FullDeck, PlayerRNG)

    mod.Saved.Player[PIndex].DeckPointer = 1 + Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)


    for i=1, Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) do

        if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_HOUSE then

            local card = mod.Saved.Player[PIndex].DeckPointer[i]

            card.Modifiers = card.Modifiers | mod.Modifier.COVERED
        end

        --mod.Saved.Player[PIndex].CurrentHand[i] = i
    end

    local Interval, DeckFinished = mod:RefillHand(Player, false)


    Isaac.RunCallback("DECK_SHIFT", Player)
    
    --print("end shuffle")
    return Interval
end


function mod:RefillHand(Player, CausedByHandPlay)


    mod.AnimationIsPlaying = true
    --print("refill")

    local PIndex = Player:GetData().TruePlayerIndex
    local DeckSize = #mod.Saved.Player[PIndex].FullDeck

    local DeckFinished = false
    local Delay = 0


    local CardsToGive = Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) - #mod.Saved.Player[PIndex].CurrentHand

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_SERPENT then

        CardsToGive = 3
    end

    --print("should refill with: ", CardsToGive)

    for i = 1, CardsToGive do

        if mod.Saved.Player[PIndex].DeckPointer >= DeckSize then
            
            DeckFinished = true
            break
        end
        
        Isaac.CreateTimer(function ()

            local NewPos = #mod.Saved.Player[PIndex].CurrentHand + 1

            if CausedByHandPlay and mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_FISH then
                
                local card = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].DeckPointer]

                card.Modifiers = card.Modifiers | mod.Modifier.COVERED
            end

            table.insert(mod.Saved.Player[PIndex].CurrentHand, NewPos, mod.Saved.Player[PIndex].DeckPointer)
            sfx:Play(mod.Sounds.SELECT)

            mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 1

            mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][NewPos] = false

            mod:ReorderHand(Player)


            mod.SelectionParams[PIndex].Index = 1

        end, Delay, 1, true)
        
        Delay = Delay + 4
    end

    Dealy = Delay + 1

    Isaac.CreateTimer(function ()
        mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Player[PIndex].CurrentHand

        mod.AnimationIsPlaying = false
    end, Delay, 1, true)

    --print("end refill")

    return Delay, DeckFinished
end


---@param Player EntityPlayer
function mod:ReorderHand(Player)


    local PIndex = Player:GetData().TruePlayerIndex

    local Hand = mod.Saved.Player[PIndex].CurrentHand

    local HandOrder = {} --uses a dummy table to get the new order the cards will be in
    for i=1, #Hand do
        HandOrder[i] = i
    end

    mod.Counters.SinceSelect = 0

    --sorts the dummy table in the specified way
    if mod.Saved.HandOrderingMode == mod.HandOrderingModes.Rank then

        table.sort(HandOrder, function (Index_A, Index_B)

            local Pointer_A = Hand[Index_A]
            local Pointer_B = Hand[Index_B]
            
            local Card_A = mod.Saved.Player[PIndex].FullDeck[Pointer_A]
            local Card_B = mod.Saved.Player[PIndex].FullDeck[Pointer_B]

            if Card_A.Value ~= Card_B.Value then 
                --values need to be compared (has priority over suit)
               
                return Card_A.Value == 1 --if A is an Ace then it always goes to the left (return true)
                       or (Card_B.Value ~= 1 --same goes with B (returns false)
                          and Card_A.Value > Card_B.Value) --otherwise compare the values normally

            else
                --suits need to be compared (minor priority)

                return Card_A.Suit < Card_B.Suit
            end

        end)


    else --(this is suit based)


        table.sort(HandOrder, function (Index_A, Index_B)

            local Pointer_A = Hand[Index_A]
            local Pointer_B = Hand[Index_B]
            
            local Card_A = mod.Saved.Player[PIndex].FullDeck[Pointer_A]
            local Card_B = mod.Saved.Player[PIndex].FullDeck[Pointer_B]

            if Card_A.Suit ~= Card_B.Suit then
                --suit need to be compared (has priority over value)
               
                return Card_A.Suit < Card_B.Suit

            else
                --Values need to be compared (minor priority)

                return Card_A.Value == 1 --if A is an Ace then it always goes to the left (return true)
                       or (Card_B.Value ~= 1 --same goes with B (returns false)
                          and Card_A.Value > Card_B.Value) --otherwise compare the values normally
            end

        end)
    
    end
    

    local OriginalHand = {} 
    table.move(Hand, 1, #Hand, 1, OriginalHand)

    local Selected = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]

    local OriginalSelected = {}
    table.move(Selected, 1, #Selected, 1, OriginalSelected)

    --switches the values
    for EndPos, StartPos in ipairs(HandOrder) do

        Hand[EndPos] = OriginalHand[StartPos]
        Selected[EndPos] = OriginalSelected[StartPos] --keeps the cards selected according to the new order
    end

    local Index = mod.SelectionParams[PIndex].Index

    mod.SelectionParams[PIndex].Index = mod:GetValueIndex(HandOrder, Index, true) --keeps the index on the same card 
end


function mod:RandomBossBlind(Rng, SpecialBoss)
    
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

    --same here
    if not next(mod.Saved.Pools.SpecialBossBlinds) then

        mod.Saved.Pools.SpecialBossBlinds = { mod.BLINDS.BOSS_HEART,
                                              mod.BLINDS.BOSS_BELL,
                                              mod.BLINDS.BOSS_VESSEL,
                                              mod.BLINDS.BOSS_ACORN,
                                              mod.BLINDS.BOSS_LEAF,
                                              }
    end

    local ChosenBoss

    if SpecialBoss then

        ChosenBoss = mod:GetRandom(mod.Saved.Pools.SpecialBossBlinds, Rng)

        table.remove(mod.Saved.Pools.SpecialBossBlinds, mod:GetValueIndex(mod.Saved.Pools.SpecialBossBlinds, ChosenBoss, true))

    else

        ChosenBoss = mod:GetRandom(mod.Saved.Pools.BossBlinds, Rng)

        table.remove(mod.Saved.Pools.BossBlinds, mod:GetValueIndex(mod.Saved.Pools.BossBlinds, ChosenBoss, true))
    
    end


    return ChosenBoss
end


function mod:GetBlindLevel(PlateVarData)

    return PlateVarData & mod.BLINDS.BOSS ~= 0 and mod.BLINDS.BOSS or PlateVarData & ~mod.BLINDS.SKIP
end


local AnteScaling = {300, 1000, 3200, 9000, 25000, 60000, 110000, 200000, 320000, 450000, 630000, 880000, 1100000} --equal to purple stake's requirements but extended due to some routes being too long
                  --{300, 900, 2600, 8000, 20000, 36000, 60000, 100000} --green stake
local BlindScaling = {[mod.BLINDS.SMALL] = 1,
                      [mod.BLINDS.BIG] = 1.5,
                      [mod.BLINDS.BOSS] = 2,
                      [mod.BLINDS.BOSS_NEEDLE] = 0.75, --usually it's 1 but since more enemies need to be hit so make it a bit lower
                      [mod.BLINDS.BOSS_WALL] = 4,
                      [mod.BLINDS.BOSS_VESSEL] = 6} 


function mod:GetBlindScoreRequirement(Blind)
    Blind = Blind or mod.BLINDS.SMALL

    local Score

    if mod.Saved.AnteLevel <= 0 then

        Score = 1/(1 - mod.Saved.AnteLevel) * 100 --(0 --> 100 || -1 --> 50 and so on)

    elseif AnteScaling[mod.Saved.AnteLevel] then
        Score = AnteScaling[mod.Saved.AnteLevel]

    else --stole this bit directly from the game's source code (how tf do you even come up with this?)

        local NumFixedAntes = #AnteScaling
    
        local a, b, c, d, k = AnteScaling[8],1.6,mod.Saved.AnteLevel-NumFixedAntes, 1 + 0.2*(mod.Saved.AnteLevel-NumFixedAntes), 0.75
        
        Score = math.floor(a*(b+(k*c)^d)^c)
        
        Score = Score - Score%(10^math.floor(math.log(Score, 10)-1))
    end

    Score = Score * (BlindScaling[mod.Saved.BlindBeingPlayed] or BlindScaling[mod.BLINDS.BOSS])

    return Score
end

function mod:GetBlindReward(Blind)
    Blind = Blind or mod.BLINDS.SMALL

    local Reward = 0

    if Blind == mod.BLINDS.SMALL then
        Reward = 3
    elseif Blind == mod.BLINDS.BIG then
        Reward = 4
    elseif Blind & mod.BLINDS.BOSS ~= 0 then

        if Blind < mod.BLINDS.BOSS_ACORN then
            Reward = 5

        else --finisher blinds
            Reward = 8
        end
    end
    
    return Reward
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

    repeat

        local BigRoom

        repeat

            BigRoom = RoomConfigHolder.GetRandomRoom( mod:RandomSeed(RoomRNG),
                                                        true, 
                                                        Isaac.GetCurrentStageConfigId(),
                                                        RoomType.ROOM_DEFAULT,
                                                        RoomShape.ROOMSHAPE_2x2,
                                                        -1, -1,
                                                        4,
                                                        10,
                                                        0,
                                                        -1,-1)


            local Entries = BigRoom.Spawns
            local IsHostile = false

            for i = 0, Entries.Size-1 do
                
                local Entity = Entries:Get(i):PickEntry(0)

                local Config = EntityConfig.GetEntity(Entity.Type, Entity.Variant)

                if Config and Config:CanShutDoors() 
                   and Entity.Type ~= EntityType.ENTITY_EFFECT
                   and Entity.Type ~= 4500 --i think it's the trigger pressure plate
                   and Entity.Type ~= EntityType.ENTITY_PICKUP then --why tf is this even needed
                    
                    IsHostile = true
                    break
                end
            end
        until IsHostile

        local PlaceSeed = mod:RandomSeed(PlaceRNG)

        for i = 3, 168 do

            BigDesc = Level:TryPlaceRoom(BigRoom, i, -1, PlaceSeed, true, true, true)

            if BigDesc then
                mod.Saved.BigBlindIndex = i
                break

            else
                Isaac.DebugString("FAILED TO PLACE AT "..tostring(mod.Saved.BigBlindIndex))
            end
        end     
            
    until BigDesc

    repeat

        local SmallRoom 

        repeat
            SmallRoom = RoomConfigHolder.GetRandomRoom( mod:RandomSeed(RoomRNG),
                                                        true, 
                                                        Isaac.GetCurrentStageConfigId(),
                                                        RoomType.ROOM_DEFAULT,
                                                        RoomShape.ROOMSHAPE_1x1,
                                                        -1, -1,
                                                        4,
                                                        10,
                                                        0,
                                                        -1,-1)

            local Entries = SmallRoom.Spawns
            local IsHostile

            for i = 0, Entries.Size-1 do
                
                local Entity = Entries:Get(i):PickEntry(0)

                local Config = EntityConfig.GetEntity(Entity.Type, Entity.Variant)

                if Config and Config:CanShutDoors() 
                   and Entity.Type ~= EntityType.ENTITY_EFFECT
                   and Entity.Type ~= 4500  -- i think it's the trigger pressure plate
                   and Entity.Type ~= EntityType.ENTITY_PICKUP then --why tf is this even needed
                    
                    print(Entity.Type, Entity.Variant, "is hostile")
                    IsHostile = true
                    break
                end
            end

        until IsHostile --makes sure the room has at least 1 enemy



        local PlaceSeed = mod:RandomSeed(PlaceRNG)

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

    local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_2

    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
        ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3
    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
        ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_4
    end

    repeat

        local ShopRoom = RoomConfigHolder.GetRandomRoom(mod:RandomSeed(RoomRNG),
                                                        false,
                                                        StbType.SPECIAL_ROOMS,
                                                        RoomType.ROOM_SHOP,
                                                        RoomShape.NUM_ROOMSHAPES,
                                                        -1, -1,
                                                        0,
                                                        10,
                                                        0, ShopQuality, -1)

        local PlaceSeed = mod:RandomSeed(PlaceRNG)

        for i = 6, 168 do

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

    else
        local Effect = Game:Spawn(EntityType.ENTITY_EFFECT, DescriptionHelperVariant, Player.Position,
                                  Vector.Zero, nil, DescriptionHelperSubType, 1):ToEffect()
        Effect:FollowParent(Player)

        print("spawnwd entity")
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
            mod.CardFullPoss = {}

            mod:FullDeckShuffle(Player)
        end
        
        
        mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Player[PIndex].CurrentHand

        mod.SelectionParams[PIndex].MaxSelectionNum = 5


        if NewPurpose == mod.SelectionParams.Purposes.HAND then
            
            mod.Saved.HandType = mod.HandTypes.NONE

            if IsTaintedJimbo
               and mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_BELL then

                mod.SelectionParams[PIndex].SelectedCards[mod.Saved.BossBlindVarData] = true
            end

        elseif not IsTaintedJimbo then

            if NewPurpose >= mod.SelectionParams.Purposes.DEJA_VU then
            mod.SelectionParams[PIndex].MaxSelectionNum = 1

            elseif NewPurpose == mod.SelectionParams.Purposes.DEATH1 then

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

                for i = 1, #mod.SelectionParams[PIndex].PackOptions do
                    mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] = false
                end

                if mod.Saved.EnableHand then --if the player's hand is required then first shuffle the deck
                    mod:FullDeckShuffle(Player)
                end
            end

        else
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams.Purposes.NONE --just to be safe
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

            --mod.SelectionParams[PIndex].Index = FirstJoker
        end

        if NewPurpose == mod.SelectionParams.Purposes.SMELTER then
            mod.SelectionParams[PIndex].MaxSelectionNum = 1
        else
            --NewPurpose = mod.SelectionParams.Purposes.NONE
            mod.SelectionParams[PIndex].MaxSelectionNum = 2
        end

        mod.SelectionParams[PIndex].OptionsNum = #mod.Saved.Player[PIndex].Inventory

    elseif NewMode == mod.SelectionParams.Modes.CONSUMABLES then

        local NumConsumables = #mod.Saved.Player[PIndex].Consumables

        mod.SelectionParams[PIndex].MaxSelectionNum = 1

        mod.SelectionParams[PIndex].OptionsNum = NumConsumables

        mod.SelectionParams[PIndex].Index = 1 --
    end

    ::FINISH::


    if IsTaintedJimbo then

    
        if mod.GameStarted
           and NewMode ~= mod.SelectionParams.Modes.NONE then

            local Params = mod.SelectionParams[PIndex]

            --Params.MaxSelectionNum = 5

            local AvailableIndexes = {}

            if NewMode == mod.SelectionParams.Modes.INVENTORY then

                for i = 1, #mod.Saved.Player[PIndex].Inventory do

                    Slot = mod.Saved.Player[PIndex].Inventory[i]

                    if Slot.Joker ~= 0 then

                        AvailableIndexes[#AvailableIndexes+1] = i

                    end
                end

            elseif NewMode == mod.SelectionParams.Modes.CONSUMABLES then

                for i = 1, #mod.Saved.Player[PIndex].Consumables do

                    Slot = mod.Saved.Player[PIndex].Consumables[i]

                    if Slot.Card ~= -1 then

                        AvailableIndexes[#AvailableIndexes+1] = i

                    end
                end

            else

                if NewMode == mod.SelectionParams.Modes.HAND then
                    for i=1, Params.OptionsNum do

                        Params.SelectedCards[mod.SelectionParams.Modes.HAND][i] = Params.SelectedCards[mod.SelectionParams.Modes.HAND][i] or false
                    end
                end



                for i = 1, Params.OptionsNum do
                    AvailableIndexes[i] = i
                end

            end

            local NewIndex 
            
            if Params.Mode == mod.SelectionParams.Modes.NONE then

                NewIndex = AvailableIndexes[1]
            else
                NewIndex = math.ceil((Params.Index * #AvailableIndexes) / #Params.SelectedCards[Params.Mode])
            
                NewIndex = AvailableIndexes[NewIndex]

                NewIndex = mod:Clamp(NewIndex, #Params.SelectedCards[NewMode], 1)
            end


            Params.Index = NewIndex or 1
            
            --mod.SelectionParams[PIndex].SelectionNum = mod:GetValueRepetitions(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams[PIndex].Mode],)
        else
            mod.SelectionParams[PIndex].Index = 1
        end


        --print("new index is: ",mod.SelectionParams[PIndex].Index)
    end

    mod.SelectionParams[PIndex].Mode = NewMode
    mod.SelectionParams[PIndex].Purpose = NewPurpose
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
                

                if IsTaintedJimbo
                   and mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_BELL
                   and mod.Saved.BossBlindVarData == mod.SelectionParams[PIndex].Index then
                    
                    SelectedCards[mod.SelectionParams[PIndex].Index] = true
                end


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

            --else
            --    print("too many! (",mod.SelectionParams[PIndex].SelectionNum,"/",mod.SelectionParams[PIndex].MaxSelectionNum,")")
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

            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Added!", mod.EffectType.ENTITY, Player)

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
            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "1 more!",mod.EffectType.ENTITY, Player)
            return
        end
        if mod.SelectionParams[PIndex].Purpose & mod.SelectionParams.Purposes.MegaFlag == mod.SelectionParams.Purposes.MegaFlag 
           and mod.SelectionParams[PIndex].OptionsNum then
            
            mod.SelectionParams[PIndex].OptionsNum = mod.SelectionParams[PIndex].OptionsNum - 1
            mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose & ~mod.SelectionParams.Purposes.MegaFlag
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
                        SelectedCards[i] = false
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

    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.CONSUMABLES then
    
        local Choice = SelectedCards[mod.SelectionParams[PIndex].Index]

        if Choice then
            sfx:Play(mod.Sounds.DESELECT)

            SelectedCards[mod.SelectionParams[PIndex].Index] = false

        else
            sfx:Play(mod.Sounds.SELECT)

            for i,v in ipairs(SelectedCards) do
                if v then
                   SelectedCards[i] = false
                   break
                end
            end

            SelectedCards[mod.SelectionParams[PIndex].Index] = true
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

    elseif mod.SelectionParams[PIndex].PackPurpose ~= mod.SelectionParams.Purposes.NONE then
        --THIS CAN ONLY HAPPEN FOR T.JIMBO
        --packs for base Jimbo activate directly on selection

        local PackIndex = mod:GetValueIndex(PackSelectedCards, true, true)

        if not PackIndex then
            return
        end

        local PackPurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag

        local Interval = 4

        if PackPurpose == mod.SelectionParams.Purposes.TarotPack
           or PackPurpose == mod.SelectionParams.Purposes.SpectralPack
           or PackPurpose == mod.SelectionParams.Purposes.CelestialPack then

            --print(mod:FrameToSpecialCard(mod.SelectionParams[PIndex].PackOptions[PackIndex]))
            
            Interval = mod:TJimboUseCard(mod:FrameToSpecialCard(mod.SelectionParams[PIndex].PackOptions[PackIndex]), Player)

            --local Success = mod:TJimboUseCard(Card.CARD_MAGICIAN, Player, 0)

            if not Interval then --tarot card didn't get used
                return
            end

            table.remove(mod.SelectionParams[PIndex].PackOptions, PackIndex)

            mod.SelectionParams[PIndex].OptionsNum = mod.SelectionParams[PIndex].OptionsNum - 1
            
            if mod.SelectionParams[PIndex].PackPurpose & mod.SelectionParams.Purposes.MegaFlag ~= 0 then
                
                mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag
                
                goto FINISH --allow another card to be chosen
            end

        elseif PackPurpose == mod.SelectionParams.Purposes.StandardPack then

            local SelectedCard = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index]

            mod:AddCardToDeck(Player, SelectedCard, 1)


            table.remove(mod.SelectionParams[PIndex].PackOptions, PackIndex)


            if mod.SelectionParams[PIndex].PackPurpose & mod.SelectionParams.Purposes.MegaFlag ~= 0 then
                     
                mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag
                goto FINISH
            end

        elseif PackPurpose == mod.SelectionParams.Purposes.BuffonPack then

            local Joker = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index].Joker
            local Edition = mod.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index].Edition

            local Success = mod:AddJoker(Player, Joker, Edition)

            if not Success then
                goto FINISH
            end

            table.remove(mod.SelectionParams[PIndex].PackOptions, PackIndex)


            if mod.SelectionParams[PIndex].PackPurpose & mod.SelectionParams.Purposes.MegaFlag ~= 0 then
                                
                mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag

                goto FINISH
            end
        end

        Isaac.CreateTimer(function ()
            if Game:GetRoom():IsClear() then

                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
                mod.Saved.EnableHand = false
            else
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
                mod.Saved.EnableHand = true
            end

            mod.AnimationIsPlaying = false
            mod.SelectionParams[PIndex].PackOptions = {}
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams.Purposes.NONE
        end, Interval + 20, 1, true)
        


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

                if mod.Saved.HandType ~= mod.HandTypes.NONE then

                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.HAND)
                
                    Isaac.RunCallback(mod.Callbalcks.PRE_HAND_PLAY, Player)
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

    elseif mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.CONSUMABLES then

        local SelectedSlot = mod:GetValueIndex(SelectedCards, true, true)

        if SelectedSlot then

            local CardToUse = mod:FrameToSpecialCard(mod.Saved.Player[PIndex].Consumables[SelectedSlot].Card)
            
            local Success = mod:TJimboUseCard(CardToUse, Player, false)
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


---@param Player EntityPlayer
function mod:DiscardSelection(Player)

    local IsTaintedJimbo = Player:GetPlayerType() == mod.Characters.TaintedJimbo

    if not IsTaintedJimbo then
        return false
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local Success = false


    local CurrentMode = mod.SelectionParams[PIndex].Mode
    local CurrentPurpose = mod.SelectionParams[PIndex].Purpose

    local SelectedCards = mod.SelectionParams[PIndex].SelectedCards[CurrentMode] or {}
    local PackSelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK]
    local HandSelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]

    local NumDiscarded = 0

    local CurrentDelay = 0

    if CurrentMode == mod.SelectionParams.Modes.HAND 
       and CurrentPurpose == mod.SelectionParams.Purposes.HAND then

        Success = mod.SelectionParams[PIndex].SelectionNum > 0
                  and mod.Saved.DiscardsRemaining > 0

        if Success then

            mod.AnimationIsPlaying = true

            --jokder stuff
            CurrentDelay = Isaac.RunCallback(mod.Callbalcks.DISCARD, Player, mod.SelectionParams[PIndex].SelectionNum)
            
            local HandIndex = 1
            local SelectionIndex = 1

            --cycles through the selected cards to discard
            while SelectionIndex <= #mod.Saved.Player[PIndex].CurrentHand do
            
            if HandSelectedCards[SelectionIndex] then

                NumDiscarded = NumDiscarded + 1

                local GotDestroyed
                
                --more jokers stuff
                CurrentDelay, GotDestroyed = Isaac.RunCallback(mod.Callbalcks.CARD_DISCARD, Player, mod.Saved.Player[PIndex].CurrentHand[SelectionIndex], 
                                                 SelectionIndex, NumDiscarded == mod.SelectionParams[PIndex].SelectionNum)

                local TrueHandIndex = HandIndex --otherwise the value gets modified in the timer itself

                if not GotDestroyed then
                    Isaac.CreateTimer(function ()

                        table.remove(HandSelectedCards, TrueHandIndex)
                        table.remove(mod.Saved.Player[PIndex].CurrentHand, TrueHandIndex)

                        sfx:Play(mod.Sounds.DESELECT)
                    end, CurrentDelay, 1, true)
                end
            
            else
                HandIndex = HandIndex + 1
            end

            SelectionIndex = SelectionIndex + 1
            end

            Isaac.CreateTimer(function ()

                mod.Saved.DiscardsRemaining = mod.Saved.DiscardsRemaining - 1

                mod:RefillHand(Player)
            end, CurrentDelay+2, 1, true)
        end

    elseif CurrentMode == mod.SelectionParams.Modes.INVENTORY then

        Success = false
            
        local SelectedSlot = mod:GetValueIndex(SelectedCards, true, true) 

        if SelectedSlot then

            Success = mod:SellJoker(Player, SelectedSlot)

            if Success then --moves the selection to the joker before the sold one

                SelectedCards[SelectedSlot] = false
                
                local JokerSlot

                for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                    if Slot.Joker ~= 0 then
                        JokerSlot = i
                        break
                    end
                end

                if JokerSlot then
                    mod.SelectionParams[PIndex].Index = JokerSlot

                elseif mod.Saved.EnableHand then
                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams[PIndex].Purpose)
                else
                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
                end
            end
        
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        end


    elseif CurrentMode == mod.SelectionParams.Modes.CONSUMABLES then
            
        local SelectedSlot = mod:GetValueIndex(SelectedCards, true, true) 

        Success = mod:SellConsumable(Player, SelectedSlot)


        if Success then --moves the selection to the joker before the sold one

            SelectedCards[SelectedSlot] = false
            
            local ConsumableSlot

            for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if Slot.Joker ~= 0 then
                    ConsumableSlot = i
                    break
                end
            end

            if ConsumableSlot then
                mod.SelectionParams[PIndex].Index = ConsumableSlot

            elseif mod.Saved.EnableHand then
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams[PIndex].Purpose)
            else
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
            end
            
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        end

    elseif CurrentMode == mod.SelectionParams.Modes.PACK then

        Success = true

        if Game:GetRoom():IsClear() then

            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
            mod.Saved.EnableHand = false
        else
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
            mod.Saved.EnableHand = true
        end

        mod.SelectionParams[PIndex].PackOptions = {}
        mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams.Purposes.NONE
    end

    if Success then

        Isaac.CreateTimer(function ()
            for i,_ in ipairs(SelectedCards) do
                SelectedCards[i] = false
            end

            for i,_ in ipairs(HandSelectedCards) do
                HandSelectedCards[i] = false
            end
            mod.SelectionParams[PIndex].SelectionNum = 0
            mod.Counters.SinceSelect = 0

            mod.AnimationIsPlaying = false
        end, CurrentDelay+3, 1, true)
    end



    return Success



end


function mod:CountersUpdate()

    for i,v in pairs(mod.Counters) do
        if type(v) == "table" then
            for j,_ in pairs(v) do
                mod.Counters[i][j] = mod.Counters[i][j] + 1
            end
        else
            mod.Counters[i] = mod.Counters[i] + 1
        end
    end

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        local PIndex = Player:GetData().TruePlayerIndex

        --print(PIndex, Player:GetPlayerType())
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then
            mod.SelectionParams[PIndex].Frames = mod.SelectionParams[PIndex].Frames + 1
        else
            mod.SelectionParams[PIndex].Frames = mod.SelectionParams[PIndex].Frames - 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.CountersUpdate)


local CardLayerID = {BODY = 1, VALUE_SUIT = 0, ENHANCEMENT = 2, SEAL = 3, DEBUFF = 4}

local JimboCards = Sprite("gfx/ui/Card Body.anm2")

local JimboCardsLayers = {}
for _,v in pairs(CardLayerID) do
    JimboCardsLayers[v] = JimboCards:GetLayer(v)
end

function mod:RenderCard(Params, Position, Offset, Scale,Rotation, ForceCovered, Thin)

    Offset = Offset or Vector.Zero
    Scale = Scale or Vector.One
    Rotation = Rotation or 0

    if Thin then
        JimboCards:SetAnimation("Thin")
    else
        JimboCards:SetAnimation("Base")
    end

    JimboCards.Scale = Scale
    JimboCards.Rotation = Rotation

    JimboCards:ClearCustomShader()

    if Params.Modifiers & mod.Modifier.COVERED ~= 0 or ForceCovered then
        JimboCards:SetLayerFrame(CardLayerID.BODY, 0)
        JimboCards:RenderLayer(CardLayerID.BODY, Position)

        return
    end

    
    JimboCardsLayers[CardLayerID.BODY]:SetCustomShader(mod.EditionShaders[Params.Edition])
    JimboCardsLayers[CardLayerID.ENHANCEMENT]:SetCustomShader(mod.EditionShaders[Params.Edition])


    JimboCards:SetLayerFrame(CardLayerID.BODY, Params.Enhancement)

    JimboCards:SetLayerFrame(CardLayerID.VALUE_SUIT, 4* Params.Value + Params.Suit - 5)
    JimboCardsLayers[CardLayerID.VALUE_SUIT]:SetPos(Offset*Scale)

    JimboCards:SetLayerFrame(CardLayerID.ENHANCEMENT, Params.Enhancement)

    JimboCards:SetLayerFrame(CardLayerID.SEAL, Params.Seal)

    JimboCards:Render(Position)
    JimboCardsLayers[CardLayerID.BODY]:ClearCustomShader()


    if Params.Modifiers & mod.Modifier.DEBUFFED ~= 0 then
        --renders another copy of the card on top of the original (just like the original game!!)
        JimboCards:SetCustomShader(mod.EditionShaders.DEBUFF)

        JimboCards:Render(Position)
    end

end


local PLANET_STEP = 8

function mod:PlanetUpgradeAnimation(HandType, LevelsGiven, BaseInterval)

    local CurrentLevel = mod.Saved.HandLevels[HandType]

    local HypotheticalLevel = CurrentLevel + LevelsGiven

    --puts a cap to LevelsGained if it would make the level lower than 1
    LevelsGiven = LevelsGiven + (math.max(1,HypotheticalLevel) - HypotheticalLevel)

    if LevelsGiven == 0 then
        return 0 --no animation frames were used
    end


    BaseInterval = BaseInterval or 0
    local OldAnimationIsPlaying = mod.AnimationIsPlaying and true or false --to make sure that there's no upvalue

    mod.AnimationIsPlaying = true

    --shows the current stats
    mod.Saved.MultValue = mod.Saved.HandsStat[HandType].Mult
    mod.Saved.ChipsValue = mod.Saved.HandsStat[HandType].Chips

    local Interval = BaseInterval + 12 --initial wait

    local ExtraChips = mod.HandUpgrades[HandType].Chips * LevelsGiven
    local ExtraMult = mod.HandUpgrades[HandType].Mult * LevelsGiven

    local Sign = mod:GetSignString(ExtraChips) -- either "" or "+" basing on value

    --increase chips
    Isaac.CreateTimer(function ()

        mod.Saved.HandsStat[HandType].Chips = mod.Saved.HandsStat[HandType].Chips + ExtraChips
        
        mod.Saved.ChipsValue = Sign..tostring(ExtraChips)
        sfx:Play(SoundEffect.SOUND_PLOP)

    end, Interval, 1, true)

    Interval = Interval + 12 --for this many frames keeps the "+num" rendered

    --set the value to the increased one
    Isaac.CreateTimer(function ()

        mod.Saved.ChipsValue = mod.Saved.HandsStat[HandType].Chips

    end, Interval, 1, true)

    Interval = Interval + 4



    --increase mult
    Isaac.CreateTimer(function ()
        mod.Saved.HandsStat[HandType].Mult = mod.Saved.HandsStat[HandType].Mult + ExtraMult
        
        mod.Saved.MultValue = Sign..tostring(ExtraMult)
        sfx:Play(SoundEffect.SOUND_PLOP)

    end, Interval, 1, true)

    Interval = Interval + 12 --for this many frames keeps the "+num" rendered

    --set the value to the increased one
    Isaac.CreateTimer(function ()
    
        mod.Saved.MultValue = mod.Saved.HandsStat[HandType].Mult

    end, Interval, 1, true)

    Interval = Interval + 4


    --increase the hand level itself
    Isaac.CreateTimer(function ()

        --can't go below 1
        mod.Saved.HandLevels[HandType] = mod.Saved.HandLevels[HandType] + LevelsGiven
    end, Interval, 1, true)


    Interval = Interval + 16 --ending wait

    Isaac.CreateTimer(function ()

        mod.AnimationIsPlaying = OldAnimationIsPlaying --puts back the animation to where it was

        Isaac.RunCallback(mod.Callbalcks.HAND_UPDATE, PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo))

    end, Interval, 1, true)


    if HandType == mod.HandTypes.STRAIGHT_FLUSH then

        --upgrades both royal flush and straight flush (no need to put this into the timers since it is not shown)

        mod.Saved.HandLevels[mod.HandTypes.ROYAL_FLUSH] = mod.Saved.HandLevels[mod.HandTypes.ROYAL_FLUSH] + LevelsGiven
        mod.Saved.HandsStat[mod.HandTypes.ROYAL_FLUSH].Mult = mod.Saved.HandsStat[mod.HandTypes.ROYAL_FLUSH].Mult + ExtraMult
        mod.Saved.HandsStat[mod.HandTypes.ROYAL_FLUSH].Chips = mod.Saved.HandsStat[mod.HandTypes.ROYAL_FLUSH].Chips + ExtraChips
    end

    return Interval - BaseInterval --how long the animation lasted
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