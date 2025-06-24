local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()

local EFFECT_CARD_OFFSET = Vector(0, -15)

local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..
local YORIK_VALUE_FLAG = 63 --111111 00..



-- CHIPS and MULT amount is equal to balatro's

-- however for balance reasons the enemies are at least 5x as tanky, I could've trimeed down both values but
-- in the end what makes Balatro fun is making BIG ASS NUMBERS so yeah



local NumEffectPlayed = 0 --used to dealy the effects accordingly (resets to 0 after everything is done)

local function IntervalTime(NumEffects)
    return 19 + 18*NumEffects
end

local function GeneralBalatroEffect(PIndex, Colour, Sound, Text, EffectType, Index)

        Isaac.CreateTimer(function ()
        
        if EffectType then
            local Position

            if EffectType == mod.EffectType.HAND then
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
            elseif EffectType == mod.EffectType.JOKER then
                Position = mod.JokerFullPosition[Index]
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, Colour, Sound, Text, EffectType)
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
                Position = mod.JokerFullPosition[Index]
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Amount), EffectType)
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
                Position = mod.JokerFullPosition[Index]
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Amount), EffectType)
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
                Position = mod.JokerFullPosition[Index]
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Amount), EffectType)
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
                Position = mod.JokerFullPosition[Index]
            elseif EffectType == mod.EffectType.ENTITY then
                Position = Index
            elseif EffectType ~= mod.EffectType.NULL then --HAND_FROM_JOKER
                
                Position = mod.LastCardFullPoss[Index] + EFFECT_CARD_OFFSET
                mod.Counters.Activated[EffectType] = 0
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.YELLOW, mod.Sounds.TIMESMULT, "+"..tostring(Amount).."$", EffectType)
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

    local PIndex = Player:GetData().TruePlayerIndex
    

    local HandType = mod.SelectionParams[PIndex].HandType
    local CompatibleHands = mod.SelectionParams[PIndex].PossibleHandTypes

--------------------------------------------------
--------------------PRE PLAY----------------------
--------------------------------------------------






--------------------------------------------------
--------------------SCORING-----------------------
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
        

        elseif Joker == mod.Jokers.BULL 
            or Joker == mod.Jokers.STONE_JOKER
            or Joker == mod.Jokers.ICECREAM
            or Joker == mod.Jokers.RUNNER
            or Joker == mod.Jokers.BLUE_JOKER
            or Joker == mod.Jokers.SQUARE_JOKER
            or Joker == mod.Jokers.CASTLE
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
            or Joker == mod.Jokers.SWASHBUCKLER
            or Joker == mod.Jokers.BOOTSTRAP then


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
        NumEffectPlayed = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.AIMING)
    
        mod.AnimationIsPlaying = false
    end, IntervalTime(NumEffectPlayed), 1, true)
end
mod:AddCallback(mod.Callbalcks.HAND_PLAY, mod.ScoreHand)



local function CopyAdjustments(Player)

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

            local Progress = mod.Saved.Player[PIndex].Progress.Inventory[Index]

            
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



        elseif Joker == mod.Jokers.CARTOMANCER then
            local RandomTarot = Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF):RandomInt(1,22)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, Player, RandomTarot, RandomSeed)

            
            mod:CreateBalatroEffect(mod.JokerFullPosition[Index],mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Tarot!",mod.Jokers.CARTOMANCER)

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

            mod:CreateBalatroEffect(mod.JokerFullPosition[Index], mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.Jokers.GIFT_CARD)


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

        end


        ::SKIP_SLOT::
    end --END JOKER FOR

    --BLUE SEAL EFFECT

    for CardIndex, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local card = mod.Saved.Player[PIndex].FullDeck[Pointer]
        if card.Seal == mod.Seals.BLUE then

            local Planet = mod.Planets.PLUTO + card.Value - 1

            for i=0, MimeNum do

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2.5, Player, Planet, RandomSeed)
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

end
mod:AddCallback(mod.Callbalcks.BLIND_CLEAR, OnBlindClear)





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
                    GeneralBalatroEffect(PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Activate!",mod.EffectType.JOKER, Index)
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

