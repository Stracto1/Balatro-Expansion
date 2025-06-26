local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()

local EFFECT_CARD_OFFSET = Vector(0, 0)
local EFFECT_JOKER_OFFSET = Vector(0, 45)

local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..
local YORIK_VALUE_FLAG = 63 --111111 00..



-- CHIPS and MULT amount is equal to balatro's

-- however for balance reasons the enemies are at least 5x as tanky, I could've trimeed down both values but
-- in the end what makes Balatro fun is making BIG ASS NUMBERS so yeah



local NumEffectPlayed = 0 --used to dealy the effects accordingly (resets to 0 after everything is done)
local CurrentInterval = 17

local function ResetEffects(BaseInterval)
    NumEffectPlayed = 0
    CurrentInterval = BaseInterval or 17
end

local function NumEffectsToSpeed(NumEffects)
    return mod:SmootherLerp(1, 3, math.min(NumEffects/75,1))
end

local function IntervalTime(NumEffects)
    --return 19 + 18*NumEffects
    CurrentInterval = CurrentInterval + math.ceil(16*NumEffectsToSpeed(NumEffects))

    return CurrentInterval
end

local function GeneralBalatroEffect(PIndex, Colour, Sound, Text, EffectType, Index)

        Isaac.CreateTimer(function ()
        
        if EffectType then
            local Position

            if EffectType == mod.EffectType.HAND then
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
            elseif EffectType == mod.EffectType.JOKER then
                Position = mod.JokerFullPosition[Index] + EFFECT_JOKER_OFFSET
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, Colour, Sound, Text, EffectType, NumEffectsToSpeed(NumEffectPlayed))
        end
        
    end, IntervalTime(NumEffectPlayed),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end

local function IncreaseChips(PIndex, Amount, EffectType, Index)

    Isaac.CreateTimer(function ()

        mod.Saved.Player[PIndex].ChipsValue = mod.Saved.Player[PIndex].ChipsValue + Amount
        
        if EffectType then
            local Position

            if EffectType == mod.EffectType.HAND then
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
            elseif EffectType == mod.EffectType.JOKER then
                Position = mod.JokerFullPosition[Index] + EFFECT_JOKER_OFFSET
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Amount), EffectType, NumEffectsToSpeed(NumEffectPlayed))
        end
        
    end, IntervalTime(NumEffectPlayed),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end


local function IncreaseMult(PIndex, Amount, EffectType, Index)

    Isaac.CreateTimer(function ()

        mod.Saved.Player[PIndex].MultValue = mod.Saved.Player[PIndex].MultValue + Amount
        
        if EffectType then
            local Position

            if EffectType == mod.EffectType.HAND then
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
            elseif EffectType == mod.EffectType.JOKER then
                Position = mod.JokerFullPosition[Index] + EFFECT_JOKER_OFFSET
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Amount), EffectType, NumEffectsToSpeed(NumEffectPlayed))
        end
        
    end, IntervalTime(NumEffectPlayed),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end

local function MultiplyMult(PIndex, Amount, EffectType, Index)

    Isaac.CreateTimer(function ()

        mod.Saved.Player[PIndex].MultValue = mod.Saved.Player[PIndex].MultValue * Amount
        
        if EffectType then
            local Position

            if EffectType == mod.EffectType.HAND then
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
            elseif EffectType == mod.EffectType.JOKER then
                Position = mod.JokerFullPosition[Index] + EFFECT_JOKER_OFFSET
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Amount), EffectType, NumEffectsToSpeed(NumEffectPlayed))
        end
        
    end, IntervalTime(NumEffectPlayed),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end

---@param Player EntityPlayer
local function AddMoney(Player, Amount, EffectType, Index)

    Isaac.CreateTimer(function ()

        local PIndex = Player:GetData().TruePlayerIndex
        Player:AddCoins(Amount)
        
        if EffectType then
            local Position

            if EffectType == mod.EffectType.HAND then
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
            elseif EffectType == mod.EffectType.JOKER then
                Position = mod.JokerFullPosition[Index] + EFFECT_JOKER_OFFSET
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.YELLOW, mod.Sounds.TIMESMULT, "+"..tostring(Amount).."$", EffectType, NumEffectsToSpeed(NumEffectPlayed))
        end
        
    end, IntervalTime(NumEffectPlayed),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end


local function IncreaseJokerProgress(PIndex, JokerIndex, Amount, IncreaseEffectsNum)

    Isaac.CreateTimer(function ()

        mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] + Amount
        
    end, IntervalTime(NumEffectPlayed),1,true)

    if IncreaseEffectsNum then
        NumEffectPlayed = NumEffectPlayed + 1
    end
end


---@param Player EntityPlayer
---@param CardPointer integer
local function TriggerCard(Player, CardPointer, CardIndex)

    --local NumEffects = 0 --counts how many effects got played
    local PIndex = Player:GetData().TruePlayerIndex
    local Card = mod.Saved.Player[PIndex].FullDeck[CardPointer]

    local HasPareidolia = mod:JimboHasTrinket(Player, mod.Jokers.PAREIDOLIA)
    local HasShowman = mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN)

    if mod.Saved.Player[PIndex].FullDeck[CardPointer].Modifiers & mod.Modifier.DEBUFFED ~= 0 then
        
        Isaac.CreateTimer(function ()
            mod:CreateBalatroEffect(mod.LastCardFullPoss[CardPointer] + EFFECT_CARD_OFFSET, mod.EffectColors.PURPLE, SoundEffect.SOUND_BLOOD_LASER, "Debuffed!", mod.EffectType.HAND)
    
        end, IntervalTime(NumEffectPlayed),1,true)

        NumEffectPlayed = NumEffectPlayed + 1

        return
    end

    --------------------------------------
    -------RETRIGGER CALCULATION----------
    --------------------------------------

    local TriggersLeft = 1
    local TriggerCauses = {mod.EffectType.NULL} --used to rapresent the "Again!" effects

    if Card.Seal == mod.Seals.RED then
        TriggersLeft = TriggersLeft + 1
        table.insert(TriggerCauses, 1, mod.EffectType.HAND)
    end

    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = JokerIndex + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            Copied = true
        end

        if Joker == 0 then
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.HANG_CHAD then
            
            if 2^CardIndex == mod:GetBitMaskMin(mod.SelectionParams[PIndex].ScoringCards) then
                TriggersLeft = TriggersLeft + 2
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER & JokerIndex)
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER & JokerIndex)
            end

        elseif Joker == mod.Jokers.HACK then

            if Card.Value <= 5 and Card.Value ~= 1 then
                TriggersLeft = TriggersLeft + 1
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER & JokerIndex)
            end

        elseif Joker == mod.Jokers.SOCK_BUSKIN then

            if mod:IsValue(Player, Card, mod.Values.FACE) then
                TriggersLeft = TriggersLeft + 1
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER & JokerIndex)
            end

        elseif Joker == mod.Jokers.SELTZER then

            TriggersLeft = TriggersLeft + 1
            table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER & JokerIndex)

        elseif Joker == mod.Jokers.DUSK then

            if mod.Saved.Player[PIndex].HandsRemaining == 1 then --LAST HAND
                TriggersLeft = TriggersLeft + 1
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER & JokerIndex)
            end

        end

        ::SKIP_SLOT::
    end


    repeat
        local BaseChips = mod:GetActualCardValue(Card.Value)

        if mod:JimboHasTrinket(Player, mod.Jokers.HIKER) then
            Card.Upgrades = Card.Upgrades + 5
        end

        if Card.Enhancement == mod.Enhancement.BONUS then

            BaseChips = BaseChips + 30

        elseif Card.Enhancement == mod.Enhancement.STONE then

            BaseChips = 50
        end

        BaseChips = BaseChips + 1 * Card.Upgrades --HIKER EFFECT

        IncreaseChips(PIndex, mod:GetActualCardValue(Card.Value), mod.EffectType.HAND, CardPointer)


        if Card.Enhancement == mod.Enhancement.MULT then
        
        IncreaseMult(PIndex, 4, mod.EffectType.HAND, CardPointer)

        elseif Card.Enhancement == mod.Enhancement.GLASS then

        MultiplyMult(PIndex, 2, mod.EffectType.HAND, CardPointer)

        elseif Card.Enhancement == mod.Enhancement.LUCKY then

        local LuckyRNG = Player:GetTrinketRNG(mod.Jokers.LUCKY_CAT)

        if mod:TryGamble(Player, LuckyRNG, 0.2) then

            IncreaseMult(PIndex, 20, mod.EffectType.HAND, CardPointer)

            for _, CatIndex in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                IncreaseJokerProgress(PIndex, CatIndex, 0,25)

                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.25X", mod.EffectType.JOKER, CatIndex)
            end
        end

        if mod:TryGamble(Player, LuckyRNG, 0.05) then
            AddMoney(Player, 20, mod.EffectType.HAND, CardPointer)

            for _, CatIndex in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                IncreaseJokerProgress(PIndex, CatIndex, 0,25)

                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.25X", mod.EffectType.JOKER, CatIndex)
            end
        end
        end


        if Card.Edition == mod.Edition.FOIL then
        
        IncreaseChips(PIndex, 50, mod.EffectType.HAND, CardPointer)

        elseif Card.Edition == mod.Edition.HOLOGRAPHIC then
        
        IncreaseMult(PIndex, 10, mod.EffectType.HAND, CardPointer)

        elseif Card.Edition == mod.Edition.FOIL then
        
        MultiplyMult(PIndex, 1.5, mod.EffectType.HAND, CardPointer)
        end

        -------------ON TRIGGER JOKERS-------------
        -------------------------------------------

        for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

            local Joker = Slot.Joker

            local ProgressIndex = JokerIndex + 0
            local Copied = false
            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
                Joker = Joker and Joker.Joker or 0

                --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
                --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

                ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

                Copied = true
            end

            if Joker == 0 then
                goto SKIP_SLOT
            end


            if Joker == mod.Jokers.EVENSTEVEN then
            
            if Card.Enhancement ~= mod.Enhancement.STONE
               and Card.Value % 2 == 0 and Card.Value < mod.Values.JACK then
                IncreaseMult(PIndex, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ODDTODD then
            
            if Card.Enhancement ~= mod.Enhancement.STONE 
               and Card.Value % 2 == 1 and Card.Value < mod.Values.JACK then
                IncreaseChips(PIndex, 31, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ONIX_AGATE then
            
            if mod:IsSuit(Player, Card, mod.Suits.Club) then
                IncreaseMult(PIndex, 7, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ARROWHEAD then
            
            if mod:IsSuit(Player, Card, mod.Suits.Spade) then
                IncreaseChips(PIndex, 30, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.BLOODSTONE then
            
            if mod:IsSuit(Player, Card, mod.Suits.Heart)
               and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BLOODSTONE), 0.5) then
                MultiplyMult(PIndex, 1.5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ROUGH_GEM then
            
            if mod:IsSuit(Player, Card, mod.Suits.Diamond) then
                AddMoney(Player, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.LUSTY_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Heart) then
                IncreaseMult(PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.WRATHFUL_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Spade) then
                IncreaseMult(PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.GREEDY_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Diamond) then
                IncreaseMult(PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.GLUTTONOUS_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Club) then
                IncreaseMult(PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers._8_BALL then
            
            if Card.Value == 8 and Card.Enhancement ~= mod.Enhancement.STONE
               and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers._8_BALL), 0.25) then
                
                local EmptySlot 
                for i,Slot in ipairs(mod.Saved.Player[PIndex].Consumables) do
                    
                    if Slot.Card == -1 then
                        EmptySlot = i
                        break
                    end
                end

                if EmptySlot then

                    local PossibleTarots = {}
                    
                    for i = 1, 22 do --every tarot

                        local HasCard = false

                        for _,Consumable in ipairs(mod.Saved.Player[PIndex].Consumables) do
                            if Consumable.Card == i then
                                HasCard = true
                                break
                            end
                        end

                        if not HasCard or HasShowman then
                        
                            PossibleTarots[i] = i
                        end
                    end

                    local RandomTarot = mod:GetRandom(PossibleTarots)

                    mod.Saved.Player[PIndex].Consumables[EmptySlot].Card = mod:SpecialCardToFrame(RandomTarot())
                    GeneralBalatroEffect(PIndex, mod.EffectColors, mod.Sounds.HAND_FROM_JOKER | JokerIndex, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)

                end
            end


            elseif Joker == mod.Jokers.FIBONACCI then
            
            if Card.Value < mod.Values.JACK 
               and Card.Enhancement ~= mod.Enhancement.STONE
               and mod:IsFibonacciNumber(Card.Value) then

                IncreaseMult(PIndex, 8, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.SCARY_FACE then
            
            if mod:IsValue(Player, Card, mod.Values.FACE) then

                IncreaseChips(PIndex, 30, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.SCHOLAR then
            
            if mod:IsValue(Player, Card, 1) then

                IncreaseMult(PIndex, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                IncreaseChips(PIndex, 20, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.BUSINESS_CARD then
            
            if mod:IsValue(Player, Card, mod.Values.FACE) and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BUSINESS_CARD), 0.5) then

                AddMoney(Player, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.PHOTOGRAPH then

            
            
            if mod:IsValue(Player, Card, mod.Values.FACE) then

                local IsFirstFace = false

                for _,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

                    if mod:IsValue(Player, mod.Saved.Player[PIndex].FulDeck[Pointer], mod.Values.FACE) then
                        
                        IsFirstFace = CardPointer == Pointer

                        break --stops at the first face card found
                    end
                end

                if IsFirstFace then
                    MultiplyMult(PIndex, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                end
            end

            elseif Joker == mod.Jokers.ANCIENT_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]) then

                MultiplyMult(PIndex, 1.5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.WALKIE_TALKIE then
            
            if mod:IsValue(Player, Card, 4) or mod:IsValue(Player, Card, 10) then

                IncreaseMult(PIndex, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                IncreaseChips(PIndex, 10, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

        
            elseif Joker == mod.Jokers.GOLDEN_TICKET then
            
            if Card.Enhancement == mod.Enhancement.GOLDEN then

                AddMoney(Player, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end
        
            elseif Joker == mod.Jokers.SMILEY_FACE then
            
            if mod:IsValue(Player, Card, mod.Values.FACE) then

                IncreaseMult(PIndex, 5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.WEE_JOKER then
            
            if mod:IsValue(Player, Card, 2) then

                if not Copied then
                    IncreaseJokerProgress(PIndex, ProgressIndex, 8)
                end
                GeneralBalatroEffect(PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Upgrade!", mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.IDOL then

            local IdolPrigress = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]
            
            if mod:IsValue(Player, Card, IdolPrigress & VALUE_FLAG)
               and mod:IsSuit(Player, Card, IdolPrigress & SUIT_FLAG) then

                MultiplyMult(PIndex, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.TRIBOULET then

            local IdolPrigress = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]
            
            if mod:IsValue(Player, Card, IdolPrigress & VALUE_FLAG)
               and mod:IsSuit(Player, Card, IdolPrigress & SUIT_FLAG) then

                MultiplyMult(PIndex, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

        


        
            end


            ::SKIP_SLOT::
        end


        if Card.Seal == mod.Seals.GOLDEN then

            AddMoney(Player, 1, mod.EffectType.HAND, CardPointer)
        end

        if TriggerCauses[TriggersLeft] == mod.EffectType.HAND then --red seal
            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.HAND, CardPointer)
        
        elseif TriggerCauses[TriggersLeft] ~= mod.EffectType.NULL then --red seal
            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.JOKER, TriggerCauses[TriggersLeft])
        end

        TriggersLeft = TriggersLeft - 1


    until TriggersLeft <= 0

    --return NumEffects
end



---@param Player EntityPlayer
function mod:ScoreHand(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects()

    local PIndex = Player:GetData().TruePlayerIndex
    

    local HandType = mod.SelectionParams[PIndex].HandType
    local CompatibleHands = mod.SelectionParams[PIndex].PossibleHandTypes
    local PlayedCards = mod.SelectionParams[PIndex].PlayedCards

--------------------------------------------------
--------------------PRE PLAY----------------------
--------------------------------------------------

    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = JokerIndex + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            Copied = true
        end

        if Joker == 0 then
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.RUNNER then
            
            if CompatibleHands & mod.HandTypes.STRAIGHT ~= 0 then
                IncreaseJokerProgress(PIndex, ProgressIndex, 15)

                GeneralBalatroEffect(PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "+15", mod.EffectType.JOKER, ProgressIndex)

            end

        elseif Joker == mod.Jokers.SUPERPOSISION then
            
            if CompatibleHands & mod.HandTypes.STRAIGHT ~= 0 then

                local HasAce = false

                for i,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

                    if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], 1) then

                        local TarotRNG = Player:GetTrinketRNG(mod.Jokers.SUPERPOSISION)

                        local RandomTarot = mod:RandomTarot(TarotRNG, false, false)

                        local Success = mod:TJimboAddConsumable(Player, RandomTarot, 0, true)

                        if Success then
                            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)
                        end

                        break
                    end
                end
            end

        elseif Joker == mod.Jokers.TO_DO_LIST then
        
            if HandType == mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] then
                
                AddMoney(Player, 4, mod.EffectType.JOKER, ProgressIndex)

            end

        elseif Joker == mod.Jokers.VAMPIRE then

            if Copied then
                goto SKIP_SLOT
            end
        
            local NumSucked = 0

            for i,Pointer in ipairs(PlayedCards) do

                if mod.Saved.Player[PIndex].FullDeck[Pointer].Enhancement ~= mod.Enhancement.NONE then

                    Isaac.CreateTimer(function ()
                        mod.Saved.Player[PIndex].FullDeck[Pointer].Enhancement = mod.Enhancement.NONE
                    end, CurrentInterval, 1, true)

                    CurrentInterval = CurrentInterval + 2

                    NumSucked = NumSucked + 1

                    break
                end
            end

            if NumSucked > 0 then
                IncreaseJokerProgress(PIndex, JokerIndex, 0.1*NumSucked)
                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Upgrade!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.SQUARE_JOKER then
            
            if #PlayedCards == 4 then
                IncreaseJokerProgress(PIndex, ProgressIndex, 4)

                GeneralBalatroEffect(PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "+4", mod.EffectType.JOKER, ProgressIndex)
            end

        elseif Joker == mod.Jokers.GREEN_JOKER then

            if Copied then
                goto SKIP_SLOT
            end
            
            IncreaseJokerProgress(PIndex, ProgressIndex, 4)
            GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+1", mod.EffectType.JOKER, ProgressIndex)


        elseif Joker == mod.Jokers.RIDE_BUS then
            
            if Copied then
                goto SKIP_SLOT
            end

            local HasFace = false

            for i,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

                if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Values.FACE) then

                    HasFace = true

                    break
                end
            end

            if HasFace then
                mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] = 0
                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, ProgressIndex)

            else
                IncreaseJokerProgress(PIndex, ProgressIndex, 1)
                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+1", mod.EffectType.JOKER, ProgressIndex)
            end

        elseif Joker == mod.Jokers.OBELISK then

            if Copied then
                goto SKIP_SLOT
            end

            local TimesMostUsed = mod:GetMax(mod.Saved.Player[PIndex].HandsUsed)

            if mod.Saved.Player[PIndex].HandsUsed[HandType] >= TimesMostUsed then
                
                mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] = 1
                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, ProgressIndex)

            else
                IncreaseJokerProgress(PIndex, ProgressIndex, 0.2)
                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.2Xs", mod.EffectType.JOKER, ProgressIndex)

            end

        end


        ::SKIP_SLOT::
    end




--------------------------------------------------
-----------------CARD SCORING---------------------
--------------------------------------------------


    for Index,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

        --print("played", i)
        
        if mod:PlayedCardIsScored(PIndex, Index) then

            --print("scored", i)
        
            --print("triggered", i)
            TriggerCard(Player, Pointer, Index)
        end
    end

--------------------------------------------------
-----------------IN HAND EFFECTS------------------
--------------------------------------------------





--------------------------------------------------
------------------JOKER SCORING-------------------
--------------------------------------------------

    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = JokerIndex + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            Copied = true
        end

        if Joker == 0 then
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.JOKER then
            
            IncreaseMult(PIndex, 4, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.GROS_MICHAEL then
            
            IncreaseMult(PIndex, 15, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.CAVENDISH then
            
            MultiplyMult(PIndex, 1.5, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.MISPRINT then

            IncreaseMult(PIndex, Player:GetTrinketRNG(mod.Jokers.MISPRINT):RandomInt(0,23), mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.JOLLY_JOKER then

            if CompatibleHands & mod.HandTypes.PAIR ~= 0 then
                IncreaseMult(PIndex, 8, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.ZANY_JOKER then

            if CompatibleHands & mod.HandTypes.THREE ~= 0 then
                IncreaseMult(PIndex, 12, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.MAD_JOKER then

            if CompatibleHands & mod.HandTypes.TWO_PAIR ~= 0 then
                IncreaseMult(PIndex, 10, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.CRAZY_JOKER then

            if CompatibleHands & mod.HandTypes.STRAIGHT ~= 0 then
                IncreaseMult(PIndex, 12, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.DROLL_JOKER then

            if CompatibleHands & mod.HandTypes.FLUSH ~= 0 then
                IncreaseMult(PIndex, 10, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.SLY_JOKER then

            if CompatibleHands & mod.HandTypes.PAIR ~= 0 then
                IncreaseChips(PIndex, 80, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.WILY_JOKER then

            if CompatibleHands & mod.HandTypes.THREE ~= 0 then
                IncreaseChips(PIndex, 120, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.CLEVER_JOKER then

            if CompatibleHands & mod.HandTypes.TWO_PAIR ~= 0 then
                IncreaseChips(PIndex, 100, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.DEVIOUS_JOKER then

            if CompatibleHands & mod.HandTypes.STRAIGHT ~= 0 then
                IncreaseChips(PIndex, 120, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.CRAFTY_JOKER then

            if CompatibleHands & mod.HandTypes.FLUSH ~= 0 then
                IncreaseChips(PIndex, 100, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.HALF_JOKER then

            if #mod.SelectionParams[PIndex].PlayedCards <= 3 then
                IncreaseMult(PIndex, 20, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.BANNER then

            if mod.Saved.Player[PIndex].DiscardsRemaining > 0 then
                IncreaseChips(PIndex, 30 * mod.Saved.Player[PIndex].DiscardsRemaining, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.MYSTIC_SUMMIT then

            if mod.Saved.Player[PIndex].DiscardsRemaining == 0 then
                IncreaseMult(PIndex, 15, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.SUPERNOVA then

            --PLACEHOLDER
            if mod.Saved.Player[PIndex].DiscardsRemaining == 0 then
                IncreaseMult(PIndex, 15, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.CARD_SHARP then

            --PLACEHOLDER
            if mod.Saved.Player[PIndex].DiscardsRemaining == 0 then
                IncreaseMult(PIndex, 15, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.ACROBAT then

            --PLACEHOLDER
            if mod.Saved.Player[PIndex].HandsRemaining == 1 then
                IncreaseMult(PIndex, 15, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.FLOWER_POT then

            local HasSuit = 0

            for i = mod.Suits.Spade, mod.Suits.Diamond do

                for Index,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do
                    if mod:PlayedCardIsScored(PIndex, Index)
                       and mod:IsSuit(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], i) then

                        HasSuit = i
                        break
                    end
                end

                if HasSuit ~= i then
                    break
                end
            end

            if HasSuit == mod.Suits.Diamond then --all the suits are held
            
                MultiplyMult(PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end


        elseif Joker == mod.Jokers.SEE_DOUBLE then

            local HasClub = false
            local HasNoClub = false
            for Index, Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do
                
                if mod:PlayedCardIsScored(PIndex, Index) then
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
            end

            if HasClub and HasNoClub then

                MultiplyMult(PIndex, 2, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.DUO then

            if CompatibleHands & mod.HandTypes.PAIR ~= 0 then
                MultiplyMult(PIndex, 2, mod.EffectType.JOKER, JokerIndex)
            end
        
        elseif Joker == mod.Jokers.TRIO then

            if CompatibleHands & mod.HandTypes.THREE ~= 0 then
                MultiplyMult(PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.FAMILY then

            if CompatibleHands & mod.HandTypes.FOUR ~= 0 then
                MultiplyMult(PIndex, 4, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.ORDER then

            if CompatibleHands & mod.HandTypes.STRAIGHT ~= 0 then
                MultiplyMult(PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.TRIBE then

            if CompatibleHands & mod.HandTypes.FLUSH ~= 0 then
                MultiplyMult(PIndex, 2, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.DRIVER_LICENSE then

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] >= 16 then --counts the enhanced cards
                MultiplyMult(PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.YORICK then

            local Mult = (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~YORIK_VALUE_FLAG)/(YORIK_VALUE_FLAG+1)

            mod:IncreaseJimboStats(Player, 0, 0, Mult, false, false)

        elseif Joker == mod.Jokers.CASTLE then
            IncreaseChips(PIndex, (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~SUIT_FLAG)/SUIT_FLAG + 1, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.LOYALTY_CARD then
            
            local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

            if Progress == 0 then
                MultiplyMult(PIndex, 4, mod.EffectType.JOKER, JokerIndex)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 6
            end

        elseif Joker == mod.Jokers.BULL then
            IncreaseChips(PIndex, Player:GetNumCoins()*2)

        elseif Joker == mod.Jokers.BLUE_JOKER then
            local NumCards = #mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer + 1
            IncreaseChips(PIndex, NumCards*2, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.BOOTSTRAP then

            local Mult = (Player:GetNumCoins()//5) * 2

            IncreaseMult(PIndex, Mult, mod.EffectType.JOKER, JokerIndex)
        
        elseif Joker == mod.Jokers.STONE_JOKER
            or Joker == mod.Jokers.ICECREAM
            or Joker == mod.Jokers.RUNNER
            or Joker == mod.Jokers.SQUARE_JOKER
            or Joker == mod.Jokers.WEE_JOKER then

            IncreaseChips(PIndex, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.FORTUNETELLER 
            or Joker == mod.Jokers.ABSTRACT_JOKER
            or Joker == mod.Jokers.POPCORN
            or Joker == mod.Jokers.GREEN_JOKER
            or Joker == mod.Jokers.RED_CARD
            or Joker == mod.Jokers.SACRIFICIAL_DAGGER
            or Joker == mod.Jokers.RIDE_BUS
            or Joker == mod.Jokers.EROSION
            or Joker == mod.Jokers.FLASH_CARD
            or Joker == mod.Jokers.SPARE_TROUSERS
            or Joker == mod.Jokers.SWASHBUCKLER then


            IncreaseMult(PIndex, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.JOKER_STENCIL 
            or Joker == mod.Jokers.THROWBACK 
            or Joker == mod.Jokers.RAMEN 
            or Joker == mod.Jokers.MADNESS
            or Joker == mod.Jokers.STEEL_JOKER
            or Joker == mod.Jokers.LUCKY_CAT
            or Joker == mod.Jokers.HOLOGRAM
            or Joker == mod.Jokers.CONSTELLATION
            or Joker == mod.Jokers.HIT_ROAD
            or Joker == mod.Jokers.CAMPFIRE
            or Joker == mod.Jokers.VAMPIRE
            or Joker == mod.Jokers.OBELISK
            or Joker == mod.Jokers.GLASS_JOKER
            or Joker == mod.Jokers.CANIO then


            MultiplyMult(PIndex, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], mod.EffectType.JOKER, JokerIndex)

        end



        ::SKIP_SLOT::
    end


----------------------------------------------------
------------------POST HAND STUFF-------------------
----------------------------------------------------


    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        local ProgressIndex = JokerIndex + 0
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            Copied = true
        end

        if Joker == 0 then
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.ICECREAM then
            
            if not Copied then
                IncreaseJokerProgress(PIndex, ProgressIndex, -5)

                GeneralBalatroEffect(PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "-5", mod.EffectType.JOKER, ProgressIndex)

            end
        elseif Joker == mod.Jokers.SELTZER then
            
            if not Copied then
                IncreaseJokerProgress(PIndex, ProgressIndex, -1)

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "-1", mod.EffectType.JOKER, ProgressIndex)

            end

        elseif Joker == mod.Jokers.LOYALTY_CARD then
            
            if not Copied then
                local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                if Progress == 1 then
                    GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Active!", mod.EffectType.JOKER, ProgressIndex)
                
                elseif Progress == 6 then
                    GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, ProgressIndex)
                
                else
                    GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, tostring(Progress).." Remaining!", mod.EffectType.JOKER, ProgressIndex)
                end

                IncreaseJokerProgress(PIndex, ProgressIndex, -1)
            end
        end


        ::SKIP_SLOT::
    end


    
    local CardsToDestroy = {}

    for i,Index in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

        if mod.Saved.Player[PIndex].FullDeck[Index].Enhancement == mod.Enhancement.GLASS then
            
            if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.GLASS_JOKER), 0.25) then
                
                CardsToDestroy[#CardsToDestroy+1] = Index
                
            end

        end
    end


    mod:DestroyCards(Player, CardsToDestroy, true, true)



--------------RESET VALUES------------------
--------------------------------------------

    Isaac.CreateTimer(function ()
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.AIMING)
    
        mod.AnimationIsPlaying = false
    end, IntervalTime(NumEffectPlayed), 1, true)
end
mod:AddCallback(mod.Callbalcks.HAND_PLAY, mod.ScoreHand)



local function CopyAdjustments(_,Player)

    --Player:AddCustomCacheTag("handsize", false)
    --Player:AddCustomCacheTag("discards", false)
    --Player:AddCustomCacheTag("inventory", true)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
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

            if Index == StartI -- an infinite loop started
               or not mod.Saved.Player[PIndex].Inventory[Index] --the copied slot doesn't exsist
               or mod.Saved.Player[PIndex].Inventory[Index].Joker == 0 --the slot is empty
               or not ItemsConfig:GetTrinket(mod.Saved.Player[PIndex].Inventory[Index].Joker):HasCustomCacheTag("copy") then --the joker cannot be copied
                
                mod.Saved.Player[PIndex].Progress.Inventory[StartI] = 0
                break
            end
        end
    end

    --amounts needed for innate items counting

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

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1 + EmptySlots -- XMULT

        elseif Joker == mod.Jokers.ABSTRACT_JOKER then
        
            local FullSlots = 0
            for i,v in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if v.Joker ~= 0 then
                    FullSlots = FullSlots + 1
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = FullSlots*3 -- XMULT

        elseif Joker == mod.Jokers.SWASHBUCKLER and not Copied then
        
            local TotalSell = 0
            for Slot,Jok in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if Jok.Joker ~= 0 then
                    TotalSell = TotalSell + mod:GetJokerCost(Jok.Joker, Jok.Edition, Slot, Player)
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = TotalSell -- +MULT

        elseif Joker == mod.Jokers.SQUARE_JOKER then
            Options.Filter = false --they get what they deserve

        end
    end
end
mod:AddCallback("INVENTORY_CHANGE", CopyAdjustments)



--effects when a blind gets completed
local function OnBlindClear(_,BlindType)

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        goto skip_player
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local MimeNum = 0

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    --cycles between all the held jokers
    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = JokerIndex
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            Copied = true
        end

        if Joker == 0 then --could save some time
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.INVISIBLE_JOKER then

            IncreaseJokerProgress(PIndex, ProgressIndex, 1)

            local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

            
            if Progress < 2 then --still charging
            
                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                     tostring(Progress).."/2", mod.EffectType.JOKER, JokerIndex)

            else --usable
            
                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                     "Active!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.ROCKET then
            --spawns this many coins

            
            --on boss beaten it upgrades
            if BlindType & mod.BLINDS.BOSS ~= 0 then
                IncreaseJokerProgress(PIndex, ProgressIndex, 2)

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                         "Upgrade!", mod.EffectType.JOKER, JokerIndex)
            end




        elseif Joker == mod.Jokers.EGG then

            IncreaseJokerProgress(PIndex, ProgressIndex, 3)

            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                 "Value Up!", mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.POPCORN then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(PIndex, ProgressIndex, -4)

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] <= 0 then
                
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "Eaten!", mod.EffectType.JOKER, JokerIndex)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "-4", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.GROS_MICHAEL then
            if not Copied and mod:TryGamble(Player,Player:GetTrinketRNG(mod.Jokers.GROS_MICHAEL), 0.16) then
                
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Edition = mod.Edition.BASE

                mod.Saved.MichelDestroyed = true

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!", mod.EffectType.JOKER, JokerIndex)
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end

        elseif Joker == mod.Jokers.CAVENDISH then
            if not Copied and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.CAVENDISH), 0.001) then --1/4000 chance
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!", mod.EffectType.JOKER, JokerIndex)
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end



        
        elseif Joker == mod.Jokers.GIFT_CARD then
            
            for i,JokerSlot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if JokerSlot.Joker ~= 0 then
                    mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] or 0
                    
                    mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] + 1
                end
            end

            mod:CreateBalatroEffect(mod.JokerFullPosition[JokerIndex], mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.Jokers.GIFT_CARD)


            if mod:JimboHasTrinket(Player, mod.Jokers.SWASHBUCKLER) then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.TURTLE_BEAN then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(PIndex, ProgressIndex, -1)

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] <= 0 then
                
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "Eaten!", mod.EffectType.JOKER, JokerIndex)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "-1", mod.EffectType.JOKER, JokerIndex)
            end


        elseif Joker == mod.Jokers.HIT_ROAD then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1

            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.MIME then
            MimeNum = MimeNum + 1
        
        elseif Joker == mod.Jokers.IDOL then -- 3 values need to be stored, so the first 3 bits are for the suit, the 4 for the value and the other say how many were discarded

            if Copied then
                goto SKIP_SLOT
            end

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
                RandomCard = mod.Saved.Player[PIndex].FullDeck[mod:GetRandom(ValidCards, Player:GetTrinketRNG(mod.Jokers.IDOL))]
                Suit = RandomCard.Suit
                Value = RandomCard.Value
            else
                Suit = mod.Suits.Spade
                Value = 1
            end
            
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = (Suit + 8*Value)

            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, mod:CardValueToName(Value, false, true).." "..mod:CardSuitToName(Suit, false, true), mod.EffectType.JOKER, JokerIndex)
        
        elseif Joker == mod.Jokers.TO_DO_LIST then

            if not Copied then

                local PossibleHands = {}

                for _, Hand in pairs(mod.HandTypes) do
                    
                    local IsUnlocked = true

                    if ((Hand == mod.HandTypes.FIVE
                       or Hand == mod.HandTypes.FIVE_FLUSH
                       or Hand == mod.HandTypes.FLUSH_HOUSE)
                       and mod.Saved.Player[PIndex].HandsUsed == 0)
                       or Hand == mod.HandTypes.ROYAL_FLUSH then
                        
                        IsUnlocked = false
                    end

                    PossibleHands[#PossibleHands+1] = Hand
                end


                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Player:GetTrinketRNG(mod.Jokers.TO_DO_LIST):RandomInt(1,#PossibleHands)

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Player:GetTrinketRNG(mod.Jokers.MAIL_REBATE):RandomInt(1,mod.Values.KING)
                
                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            if not Copied then
                local Suit = mod.Saved.Player[PIndex].FullDeck[Player:GetTrinketRNG(mod.Jokers.CASTLE):RandomInt(1,#mod.Saved.Player[PIndex].FullDeck)].Suit
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Suit + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~SUIT_FLAG)

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.ANCIENT_JOKER then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Player:GetTrinketRNG(mod.Jokers.ANCIENT_JOKER):RandomInt(mod.Suits.Spade,mod.Suits.Diamond)

                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end
        end


        ::SKIP_SLOT::
    end --END JOKER FOR

    --BLUE SEAL EFFECT

    for CardIndex, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if card.Seal == mod.Seals.BLUE then

            local Planet = mod.Planets.PLUTO + math.log(mod.SelectionParams[PIndex].HandType, 2) - 1

            for i=0, MimeNum do

                mod:TJimboAddConsumable(Player, Planet, 0, true)
            end

            mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Planet!",mod.Seals.BLUE)
        end
    end


    for _,index in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        if mod.Saved.Player[PIndex].FullDeck[index].Enhancement == mod.Enhancement.GOLDEN
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

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.BLIND_CLEAR, OnBlindClear)


--effects when a blind gets completed
local function OnBlindStart(_,BlindType)

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        goto skip_player
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    --cycles between all the held jokers
    for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        local ProgressIndex = JokerIndex
        local Copied = false
        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            Joker = mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]]
            Joker = Joker and Joker.Joker or 0

            --print("should be copiyng: "..tostring(mod.Saved.Player[PIndex].Inventory[mod.Saved.Player[PIndex].Progress.Inventory[Index]].Joker))
            --print("copy "..tostring(Joker).." at "..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]))

            ProgressIndex = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            Copied = true
        end

        if Joker == 0 then --could save some time
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.CARTOMANCER then
            local TarotRNG = Player:GetTrinketRNG(mod.Jokers.CARTOMANCER)

            local RandomTarot = mod:RandomTarot(TarotRNG, false, false)

            local Success = mod:TJimboAddConsumable(Player, RandomTarot, 0, true)

            if Success then
                GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)
            end


        elseif Joker == mod.Jokers.RIFF_RAFF then
            local RaffRNG = Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF)
            
            local RandomJokers = mod:RandomJoker(RaffRNG, true, "common")

            for i=1, 2 do
                
                Isaac.CreateTimer(function ()
                    local Success = mod:TJimboAddConsumable(Player, RandomJokers[i], 0, true)
                    if Success then
                        mod.Counters.Activated[JokerIndex] = 0
                    end
                end, CurrentInterval, 1, true)

                CurrentInterval = CurrentInterval + 8

            end

            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jokers!", mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.STONE_JOKER then

            local MarbleRNG = Player:GetTrinketRNG(mod.Jokers.MARBLE_JOKER)

            local StoneCard = {}

            StoneCard.Suit = MarbleRNG:RandomInt(1, 4)
            StoneCard.Value = MarbleRNG:RandomInt(1,13)

            StoneCard.Enhancement = mod.Enhancement.STONE
            StoneCard.Seal = mod.Seals.NONE
            StoneCard.Edition = mod.Edition.BASE
            StoneCard.Upgrades = 0

            mod:AddCardToDeck(Player, StoneCard,1, false)

            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Stone!", mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.SACRIFICIAL_DAGGER then

            if Copied then
                goto SKIP_SLOT
            end

            local RightIndex = JokerIndex
            local RightJoker
            repeat
                RightIndex = RightIndex + 1
                RightJoker = mod.Saved.Player[PIndex].Inventory[RightIndex].Joker
            until not RightJoker or RightJoker ~= 0

            if RightJoker ~= 0 then
                local RightSell = mod:GetJokerCost(RightJoker, mod.Saved.Player[PIndex].Inventory[RightIndex].Edition, RightIndex)

                IncreaseJokerProgress(PIndex, JokerIndex, RightSell)
                GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.SLICE, "+"..tostring(RightSell), mod.EffectType.JOKER, JokerIndex)

                mod.Saved.Player[PIndex].Inventory[RightIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[RightIndex].Edition = 0

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.MADNESS then

            if not Copied or BlindType & mod.BLINDS.BOSS ~= 0 then
                goto SKIP_SLOT
            end
                
            IncreaseJokerProgress(PIndex, JokerIndex, 0.5)

            GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.5 X", mod.EffectType.JOKER, JokerIndex)
            
            local Removable = {}
            for i, v in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if i ~= JokerIndex and v.Joker ~= 0 then --any joker other than this one
                    table.insert(Removable, i)
                end
            end
            if next(Removable) then --if at leat one is present
                local Rindex = mod:GetRandom(Removable, Player:GetTrinketRNG(mod.Jokers.MADNESS))
                mod.Saved.Player[PIndex].Inventory[Rindex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Rindex].Edition = 0

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            end

        elseif Joker == mod.Jokers.CERTIFICATE then

            local MarbleRNG = Player:GetTrinketRNG(mod.Jokers.CERTIFICATE)

            local SealCard = {}

            SealCard.Suit = MarbleRNG:RandomInt(1, 4)
            SealCard.Value = MarbleRNG:RandomInt(1,13)

            SealCard.Enhancement = mod.Enhancement.STONE
            SealCard.Seal = MarbleRNG:RandomInt(mod.Seals.RED, mod.Seals.PURPLE)

            mod:AddCardToDeck(Player, SealCard,1, false)

            GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Added!", mod.EffectType.JOKER, JokerIndex)
        end

        ::SKIP_SLOT::
    end --END JOKER FOR

    ::skip_player::

    end --END PLAYER FOR

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.BLIND_START, OnBlindStart)





---@param Player EntityPlayer
local function OnPackOpened(_,Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
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

                local Success = mod:TJimboAddConsumable(Player, RandomTarot, 0, true)

                if Success then
                    GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!",mod.EffectType.JOKER, Index)
                end
            end
        end
    end

end
mod:AddCallback(mod.Callbalcks.PACK_OPEN, OnPackOpened)


local function OnPackSkipped(_,Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end
    
    local PIndex = Player:GetData().TruePlayerIndex

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker
        
        if Joker == mod.Jokers.RED_CARD then
            IncreaseJokerProgress(PIndex, Index, 3)

            GeneralBalatroEffect(PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+3", mod.EffectType.JOKER, Index)
        end
    end
end
mod:AddCallback(mod.Callbalcks.PACK_SKIP, OnPackSkipped)



local function OnHandDiscard(_, Player, AmountDiscarded)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects(5)

    local PIndex = Player:GetData().TruePlayerIndex
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

        if Joker == 0 then
        elseif Joker == mod.Jokers.RAMEN and not Copied then

            local LostMult = 0.01 * AmountDiscarded
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - LostMult
        
            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Eaten!",mod.EffectType.JOKER)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.ACTIVATE, tostring(-LostMult).."X",mod.EffectType.JOKER)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        
        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            local InitialProg = mod.Saved.Player[PIndex].Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 0.16
                if mod.Saved.Player[PIndex].Progress.Inventory[Index] < 0 then
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0
                end
                
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.16",mod.EffectType.JOKER)
        
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                if mod.Saved.Player[PIndex].FullDeck[Pointer].Value == mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                    for i=1,2 do
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                   RandomVector()*2.5, Player, CoinSubType.COIN_PENNY, 1)
                    end
                end
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod:IsSuit(Player,mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & SUIT_FLAG) then
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 8

                    mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+0.04",mod.EffectType.JOKER)
                
                    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                end
            end

        elseif Joker == mod.Jokers.DRUNKARD then

            Game:SetDizzyAmount(math.max(Game:GetDizzyAmount()-0.05, 0))


        elseif Joker == mod.Jokers.HIT_ROAD then

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod.Saved.Player[PIndex].FullDeck[Pointer].Value == mod.Values.JACK 
                   and mod.Saved.Player[PIndex].FullDeck[Pointer].Enahncement ~= mod.Enhancement.STONE then
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 0.2

                    mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.2X",mod.EffectType.JOKER)
                
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end
            end
        elseif Joker == mod.Jokers.YORICK then

            local Discards = #mod.Saved.Player[PIndex].CurrentHand
            local MissingDiscards = (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & YORIK_VALUE_FLAG) - Discards
            local MultIncrease = 0

            for i=MissingDiscards, 0, 23 do

                MissingDiscards = i
                MultIncrease = MultIncrease + 1
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = -MissingDiscards + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~YORIK_VALUE_FLAG) + (YORIK_VALUE_FLAG+1)*MultIncrease

            if MultIncrease ~= 0 then
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+"..tostring(0.2*MultIncrease).."X",mod.EffectType.JOKER)
            end
        end
    end

    return CurrentInterval

end
mod:AddCallback(mod.Callbalcks.DISCARD, OnHandDiscard)



local function OnCardDiscard(_, Player, CardDiscarded)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
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

        if Joker == 0 then
        elseif Joker == mod.Jokers.RAMEN then

            local LostMult = 0.01 * AmountDiscarded
            mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - LostMult
        
            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Eaten!",mod.EffectType.JOKER)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.ACTIVATE, tostring(-LostMult).."X",mod.EffectType.JOKER)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
        
        elseif Joker == mod.Jokers.GREEN_JOKER and not Copied then
            local InitialProg = mod.Saved.Player[PIndex].Progress.Inventory[Index]
            if InitialProg > 0 then
                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] - 0.16
                if mod.Saved.Player[PIndex].Progress.Inventory[Index] < 0 then
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = 0
                end
                
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.ACTIVATE, "-0.16",mod.EffectType.JOKER)
        
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                if mod.Saved.Player[PIndex].FullDeck[Pointer].Value == mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] then
                    for i=1,2 do
                        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                   RandomVector()*2.5, Player, CoinSubType.COIN_PENNY, 1)
                    end
                end
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod:IsSuit(Player,mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & SUIT_FLAG) then
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 8

                    mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+0.04",mod.EffectType.JOKER)
                
                    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                end
            end

        elseif Joker == mod.Jokers.DRUNKARD then

            Game:SetDizzyAmount(math.max(Game:GetDizzyAmount()-0.05, 0))


        elseif Joker == mod.Jokers.HIT_ROAD then

            for i,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

                if mod.Saved.Player[PIndex].FullDeck[Pointer].Value == mod.Values.JACK 
                   and mod.Saved.Player[PIndex].FullDeck[Pointer].Enahncement ~= mod.Enhancement.STONE then
                    
                    mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] + 0.2

                    mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+0.2X",mod.EffectType.JOKER)
                
                    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end
            end
        elseif Joker == mod.Jokers.YORICK then

            local Discards = #mod.Saved.Player[PIndex].CurrentHand
            local MissingDiscards = (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & YORIK_VALUE_FLAG) - Discards
            local MultIncrease = 0

            for i=MissingDiscards, 0, 23 do

                MissingDiscards = i
                MultIncrease = MultIncrease + 1
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = -MissingDiscards + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~YORIK_VALUE_FLAG) + (YORIK_VALUE_FLAG+1)*MultIncrease

            if MultIncrease ~= 0 then
                mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.RED, mod.Sounds.TIMESMULT, "+"..tostring(0.2*MultIncrease).."X",mod.EffectType.JOKER)
            end
        end
    end

    return CurrentInterval

end
mod:AddCallback(mod.Callbalcks.CARD_DISCARD, OnCardDiscard)


