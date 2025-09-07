local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()


local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..


-- CHIPS and MULT amount is equal to balatro's

-- however for balance reasons the enemies are at least 5x as tanky, I could've trimeed down both values but
-- in the end what makes Balatro fun is making BIG ASS NUMBERS so yeah

local DEFAULT_INCREASE = 16

local NumEffectPlayed = 0 --used to dealy the effects accordingly (resets to 0 after everything is done)
local CurrentInterval = 16

local function ResetEffects(BaseInterval)
    NumEffectPlayed = 0
    CurrentInterval = BaseInterval or 16
end

local function NumEffectsToSpeed(NumEffects)
    return mod:SmootherLerp(1, 3, math.min(NumEffects/75,1))
end


local function IncreaseInterval(Amount)

    CurrentInterval = CurrentInterval + math.ceil(Amount/NumEffectsToSpeed(NumEffectPlayed))
end


local function IntervalTime(NumEffects, SpeedMult)

    local OldInteval = CurrentInterval + 0

    CurrentInterval = CurrentInterval + math.ceil(16/(NumEffectsToSpeed(NumEffects)*SpeedMult))

    return OldInteval
end

local function GeneralBalatroEffect(Player, PIndex, Colour, Sound, Text, EffectType, Index, SpeedMult)

    SpeedMult = SpeedMult or 1

    Isaac.CreateTimer(function ()
        
        if EffectType then

            mod:CreateBalatroEffect(Index, Colour, Sound, Text, EffectType, Player, NumEffectsToSpeed(NumEffectPlayed) * SpeedMult)
        end
        
    end, IntervalTime(NumEffectPlayed, SpeedMult),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end

local function IncreaseChips(Player, PIndex, Amount, EffectType, Index, SpeedMult)

    if Amount <= 0 then
        return
    end

    SpeedMult = SpeedMult or 1

    Isaac.CreateTimer(function ()

        mod.Saved.ChipsValue = mod.Saved.ChipsValue + Amount
        
        if EffectType then

            mod:CreateBalatroEffect(Index, mod.EffectColors.BLUE, mod.Sounds.CHIPS,
                                    "+"..tostring(Amount), EffectType, Player, NumEffectsToSpeed(NumEffectPlayed) * SpeedMult)
        end
        
    end, IntervalTime(NumEffectPlayed, SpeedMult),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end


local function IncreaseMult(Player, PIndex, Amount, EffectType, Index, SpeedMult)

    if Amount <= 0 then
        return
    end

    SpeedMult = SpeedMult or 1

    Isaac.CreateTimer(function ()

        mod.Saved.MultValue = mod.Saved.MultValue + Amount
        
        if EffectType then

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Amount), EffectType, Player, NumEffectsToSpeed(NumEffectPlayed) * SpeedMult)
        end
        
    end, IntervalTime(NumEffectPlayed, SpeedMult),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end

local function MultiplyMult(Player, PIndex, Amount, EffectType, Index, SpeedMult)

    if Amount <= 1 then
        return
    end

    SpeedMult = SpeedMult or 1

    Isaac.CreateTimer(function ()

        mod.Saved.MultValue = mod.Saved.MultValue * Amount
        
        if EffectType then

            mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X"..tostring(Amount), EffectType, Player, NumEffectsToSpeed(NumEffectPlayed) * SpeedMult)
        end
        
    end, IntervalTime(NumEffectPlayed, SpeedMult),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end

---@param Player EntityPlayer
local function AddMoney(Player, Amount, EffectType, Index, SpeedMult)

    if Amount == 0 then
        return
    end

    SpeedMult = SpeedMult or 1

    Isaac.CreateTimer(function ()

        local PIndex = Player:GetData().TruePlayerIndex
        Player:AddCoins(Amount)
        
        if EffectType then

            local Color = Amount < 0 and mod.EffectColors.RED or mod.EffectColors.YELLOW

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.TIMESMULT, "+"..tostring(Amount).."$", EffectType, Player, NumEffectsToSpeed(NumEffectPlayed) * SpeedMult)
        end
        
    end, IntervalTime(NumEffectPlayed, SpeedMult),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end


local function IncreaseJokerProgress(Player, PIndex, JokerIndex, Amount, EffectColor, ShowDifference, SpeedMult)
    
    SpeedMult = SpeedMult or 1

    Isaac.CreateTimer(function ()

        mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] + Amount

        if EffectColor then

            local Text

            if ShowDifference == true then
                Text = mod:GetSignString(Amount)..tostring(Amount)
            elseif ShowDifference == false then
                Text = mod:GetSignString(mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex])..tostring(mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex])
            else
                Text = "Upgrade!"
            end


            mod:CreateBalatroEffect(JokerIndex, EffectColor, mod.Sounds.ACTIVATE, Text, mod.EffectType.JOKER, Player, NumEffectsToSpeed(NumEffectPlayed) * SpeedMult)
        end
        
    end, IntervalTime(NumEffectPlayed, SpeedMult),1,true)
    

    if EffectColor then
        NumEffectPlayed = NumEffectPlayed + 1
    end
end


local function ProgressString(PIndex, JokerIndex)
    return tostring(mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex])
end


local function AddCashoutString(Name, Money, Type)

    if Money <= 0 then
        return
    end

    --print(CurrentInterval)

    Isaac.CreateTimer(function ()
        
        mod.ScreenStrings.CashOut[#mod.ScreenStrings.CashOut+1] = {Name = Name, String = tostring(Money).."$", StartFrame = Isaac.GetFrameCount(), Type = Type}

    end, CurrentInterval, 1, true)


    IncreaseInterval(52)

end




---@param Player EntityPlayer
---@param CardPointer integer
local function TriggerCard(Player, CardPointer, CardIndex)

    --local NumEffects = 0 --counts how many effects got played
    local PIndex = Player:GetData().TruePlayerIndex
    local Card = mod.Saved.Player[PIndex].FullDeck[CardPointer]

    if Card.Modifiers & mod.Modifier.DEBUFFED ~= 0 then
        
        GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.CLOWN_HONK, "Debuffed!", mod.EffectType.HAND, CardPointer)

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
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex)
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex)
            end

        elseif Joker == mod.Jokers.HACK then

            if Card.Value <= 5 and Card.Value ~= 1 then
                TriggersLeft = TriggersLeft + 1
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex)
            end

        elseif Joker == mod.Jokers.SOCK_BUSKIN then

            if mod:IsValue(Player, Card, mod.Values.FACE) then
                TriggersLeft = TriggersLeft + 1
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex)
            end

        elseif Joker == mod.Jokers.SELTZER then

            TriggersLeft = TriggersLeft + 1
            table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex)

        elseif Joker == mod.Jokers.DUSK then

            if mod.Saved.HandsRemaining == 0 then --LAST HAND
                TriggersLeft = TriggersLeft + 1
                table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex)
            end

        end

        ::SKIP_SLOT::
    end


    repeat
        local BaseChips = mod:GetValueScoring(Card.Value)

        if Card.Enhancement == mod.Enhancement.BONUS then

            BaseChips = BaseChips + 30

        elseif Card.Enhancement == mod.Enhancement.STONE then

            BaseChips = 50
        end

        BaseChips = BaseChips + 5 * Card.Upgrades --HIKER EFFECT

        IncreaseChips(Player, PIndex, mod:GetValueScoring(Card.Value), mod.EffectType.HAND, CardPointer)

        for _, Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.HIKER)) do

            Card.Upgrades = Card.Upgrades + 5

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Upgrade!", mod.EffectType.JOKER, Index)
        end

        if Card.Enhancement == mod.Enhancement.MULT then
        
            IncreaseMult(Player, PIndex, 4, mod.EffectType.HAND, CardPointer)

        elseif Card.Enhancement == mod.Enhancement.GLASS then

            MultiplyMult(Player, PIndex, 2, mod.EffectType.HAND, CardPointer)

        elseif Card.Enhancement == mod.Enhancement.LUCKY then

            local LuckyRNG = Player:GetTrinketRNG(mod.Jokers.LUCKY_CAT)

            if mod:TryGamble(Player, LuckyRNG, 0.2) then

                IncreaseMult(Player, PIndex, 20, mod.EffectType.HAND, CardPointer)

                for _, CatIndex in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                    IncreaseJokerProgress(Player, PIndex, CatIndex, 0,25, mod.EffectKColors.RED)
                end
            end

            if mod:TryGamble(Player, LuckyRNG, 0.05) then
                AddMoney(Player, 20, mod.EffectType.HAND, CardPointer)

                for _, CatIndex in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.LUCKY_CAT, true)) do
                    IncreaseJokerProgress(Player, PIndex, CatIndex, 0,25, mod.EffectKColors.RED)
                end
            end
        end


        if Card.Edition == mod.Edition.FOIL then
        
            IncreaseChips(Player, PIndex, 50, mod.EffectType.HAND, CardPointer)

        elseif Card.Edition == mod.Edition.HOLOGRAPHIC then
        
            IncreaseMult(Player, PIndex, 10, mod.EffectType.HAND, CardPointer)

        elseif Card.Edition == mod.Edition.POLYCROME then
        
            MultiplyMult(Player, PIndex, 1.5, mod.EffectType.HAND, CardPointer)
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
                IncreaseMult(Player, PIndex, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ODDTODD then
            
            if Card.Enhancement ~= mod.Enhancement.STONE 
               and Card.Value % 2 == 1 and Card.Value < mod.Values.JACK then
                IncreaseChips(Player, PIndex, 31, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ONIX_AGATE then
            
            if mod:IsSuit(Player, Card, mod.Suits.Club) then
                IncreaseMult(Player, PIndex, 7, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ARROWHEAD then
            
            if mod:IsSuit(Player, Card, mod.Suits.Spade) then
                IncreaseChips(Player, PIndex, 30, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.BLOODSTONE then
            
            if mod:IsSuit(Player, Card, mod.Suits.Heart)
               and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.BLOODSTONE), 0.5) then
                MultiplyMult(Player, PIndex, 1.5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.ROUGH_GEM then
            
            if mod:IsSuit(Player, Card, mod.Suits.Diamond) then
                AddMoney(Player, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.LUSTY_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Heart) then
                IncreaseMult(Player, PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.WRATHFUL_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Spade) then
                IncreaseMult(Player, PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.GREEDY_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Diamond) then
                IncreaseMult(Player, PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.GLUTTONOUS_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Suits.Club) then
                IncreaseMult(Player, PIndex, 3, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers._8_BALL then
            
                local BallRNG = Player:GetTrinketRNG(mod.Jokers._8_BALL)

                if mod:IsValue(Player, Card, 8) and Card.Enhancement ~= mod.Enhancement.STONE
                   and mod:TryGamble(Player, BallRNG, 0.25) then

                    local RandomTarot = mod:RandomTarot(BallRNG, false, false)

                    local Success = mod:TJimboAddConsumable(Player, RandomTarot, 0, true)

                    if Success then
                        GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)
                    end

                end


            elseif Joker == mod.Jokers.FIBONACCI then
            
            if Card.Value < mod.Values.JACK 
               and Card.Enhancement ~= mod.Enhancement.STONE
               and mod:IsFibonacciNumber(Card.Value) then

                IncreaseMult(Player, PIndex, 8, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.SCARY_FACE then
            
            if mod:IsValue(Player, Card, mod.Values.FACE) then

                IncreaseChips(Player, PIndex, 30, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.SCHOLAR then
            
            if mod:IsValue(Player, Card, 1) then

                IncreaseMult(Player, PIndex, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                IncreaseChips(Player, PIndex, 20, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
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
                    MultiplyMult(Player, PIndex, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                end
            end

            elseif Joker == mod.Jokers.ANCIENT_JOKER then
            
            if mod:IsSuit(Player, Card, mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]) then

                MultiplyMult(Player, PIndex, 1.5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.WALKIE_TALKIE then
            
            if mod:IsValue(Player, Card, 4) or mod:IsValue(Player, Card, 10) then

                IncreaseMult(Player, PIndex, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                IncreaseChips(Player, PIndex, 10, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

        
            elseif Joker == mod.Jokers.GOLDEN_TICKET then
            
            if Card.Enhancement == mod.Enhancement.GOLDEN then

                AddMoney(Player, 4, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end
        
            elseif Joker == mod.Jokers.SMILEY_FACE then
            
            if mod:IsValue(Player, Card, mod.Values.FACE) then

                IncreaseMult(Player, PIndex, 5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

            elseif Joker == mod.Jokers.WEE_JOKER then
            
                if mod:IsValue(Player, Card, 2) then

                    if not Copied then
                        IncreaseJokerProgress(Player, PIndex, ProgressIndex, 8, mod.EffectKColors.BLUE)
                    end
                end


            elseif Joker == mod.Jokers.IDOL then

            local IdolPrigress = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]
            
            if mod:IsValue(Player, Card, IdolPrigress & VALUE_FLAG)
               and mod:IsSuit(Player, Card, IdolPrigress & SUIT_FLAG) then

                MultiplyMult(Player, PIndex, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end


            elseif Joker == mod.Jokers.TRIBOULET then

            local IdolPrigress = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]
            
            if mod:IsValue(Player, Card, IdolPrigress & VALUE_FLAG)
               and mod:IsSuit(Player, Card, IdolPrigress & SUIT_FLAG) then

                MultiplyMult(Player, PIndex, 2, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
            end

        


        
            end


            ::SKIP_SLOT::
        end


        if Card.Seal == mod.Seals.GOLDEN then

            AddMoney(Player, 3, mod.EffectType.HAND, CardPointer)
        end

        if TriggerCauses[TriggersLeft] == mod.EffectType.HAND then --red seal
            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.HAND, CardPointer)
        
        elseif TriggerCauses[TriggersLeft] ~= mod.EffectType.NULL then --any joker
            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.JOKER, TriggerCauses[TriggersLeft])
        end


        for _, Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.CHAOS_THEORY)) do

            local NewCardSubType = mod:PlayingCardParamsToSubType(Card)

            local NewCardRNG = RNG(Player:GetTrinketRNG(mod.Jokers.CHAOS_THEORY):PhantomInt(NewCardSubType) + 1)

            mod.Saved.Player[PIndex].FullDeck[CardPointer] = mod:RandomPlayingCard(NewCardRNG, true)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Chaos!", mod.EffectType.HAND_FROM_JOKER | Index, CardPointer)
        end


        TriggersLeft = TriggersLeft - 1

    until TriggersLeft <= 0

    --return NumEffects
end


local function HeldCardEffect(Player, CardPointer, CardIndex, LowestPointer)

    local PIndex = Player:GetData().TruePlayerIndex
    local Card = mod.Saved.Player[PIndex].FullDeck[CardPointer]

    if Card.Modifiers & mod.Modifier.DEBUFFED ~= 0 then
        
        return
    end



    local TriggersLeft = 1
    local TriggerCauses = {mod.EffectType.NULL}

    if Card.Seal == mod.Seals.RED then
        TriggersLeft = TriggersLeft + 1
        table.insert(TriggerCauses, 1, mod.EffectType.HAND)
    end

    for _,MimeIndex in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)) do
        
        TriggersLeft = TriggersLeft + 1
        table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | MimeIndex)
    end

    repeat

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


            if Joker == mod.Jokers.RAISED_FIST then

                if CardPointer == LowestPointer then

                    IncreaseMult(Player, PIndex, 2*mod:GetCardActualValue(Card.Value), mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                end


            elseif Joker == mod.Jokers.SHOOT_MOON then

                if mod:IsValue(Player, Card, mod.Values.QUEEN) then

                    IncreaseMult(Player, PIndex, 13, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                end


            elseif Joker == mod.Jokers.BARON then

                if mod:IsValue(Player, Card, mod.Values.KING) then

                    MultiplyMult(Player, PIndex, 1.5, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                end

            elseif Joker == mod.Jokers.RESERVED_PARK then

                if mod:IsValue(Player, Card, mod.Values.FACE) 
                   and Player:GetTrinketRNG(mod.Jokers.RESERVED_PARK):RandomFloat() <= 0.5 then

                    AddMoney(Player, 1, mod.EffectType.HAND_FROM_JOKER | JokerIndex, CardPointer)
                end
            end



            ::SKIP_SLOT::
        end

        if TriggerCauses[TriggersLeft] == mod.EffectType.HAND then --red seal
            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.HAND, CardPointer)
        
        elseif TriggerCauses[TriggersLeft] ~= mod.EffectType.NULL then --red seal
            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.JOKER, TriggerCauses[TriggersLeft])
        end

        TriggersLeft = TriggersLeft - 1

    until TriggersLeft <= 0
end



---@param Player EntityPlayer
function mod:ScoreHand(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects()

    local PIndex = Player:GetData().TruePlayerIndex
    

    local HandType

    if mod.Saved.HandType == mod.HandTypes.ROYAL_FLUSH then
        
        HandType = mod.HandTypes.STRAIGHT_FLUSH
    else
        HandType = mod.Saved.HandType
    end


    local CompatibleHands = mod.Saved.PossibleHandTypes
    local PlayedCards = mod.SelectionParams[PIndex].PlayedCards


    for _, Pointer in ipairs(PlayedCards) do
        mod.Saved.AnteCardsPlayed[#mod.Saved.AnteCardsPlayed + 1] = Pointer

    end

--------------------------------------------------
------------------BOSS EFFECTS--------------------
--------------------------------------------------


    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_PSYCHIC then
        
        if #PlayedCards < 5 then

            local MatadorIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR)

            for _,Index in ipairs(MatadorIndexes) do
                
                AddMoney(Player, 8, mod.EffectType.JOKER, Index)
            end

            Isaac.CreateTimer(function ()

                mod.SelectionParams[PIndex].SelectionNum = 0
                Isaac.RunCallback(mod.Callbalcks.POST_HAND_PLAY, Player)

            end, CurrentInterval, 1, true)

            return
        end


    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_EYE then
        
        local HandFlag = 1 << HandType

        if mod.Saved.BossBlindVarData & HandFlag ~= 0 then --if hand got already played

            local MatadorIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR)

            for _,Index in ipairs(MatadorIndexes) do
                
                AddMoney(Player, 8, mod.EffectType.JOKER, Index)
            end
        
        
            Isaac.CreateTimer(function ()

                mod.SelectionParams[PIndex].SelectionNum = 0
                Isaac.RunCallback(mod.Callbalcks.POST_HAND_PLAY, Player)

            end, CurrentInterval, 1, true)

            return

        else
            mod.Saved.BossBlindVarData = mod.Saved.BossBlindVarData | HandFlag

        end

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_MOUTH then
        
        local HandFlag = 1 << HandType

        if mod.Saved.BossBlindVarData ~= 0  --if no hand was played yet
           and mod.Saved.BossBlindVarData & HandFlag == 0 then --if hand didn't get played
           
           local MatadorIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR)

            for _,Index in ipairs(MatadorIndexes) do
                
                AddMoney(Player, 8, mod.EffectType.JOKER, Index)
            end
           
           
            Isaac.CreateTimer(function ()

                mod.SelectionParams[PIndex].SelectionNum = 0
                Isaac.RunCallback(mod.Callbalcks.POST_HAND_PLAY, Player)

            end, CurrentInterval, 1, true)

            return

        else
            mod.Saved.BossBlindVarData = mod.Saved.BossBlindVarData | HandFlag

        end

    

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_TOOTH then

        local MatadorIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR)

        for _,Index in ipairs(MatadorIndexes) do
            
            AddMoney(Player, 8, mod.EffectType.JOKER, Index)
        end

        for Pointer,Card in ipairs(PlayedCards) do

            AddMoney(Player, -1, mod.EffectType.HAND, Pointer, 2)
        end

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_ARM then

        if mod.Saved.HandLevels[HandType] ~= 1 then --only if the hand in question can be leveled down

            local MatadorIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR)

            for _,Index in ipairs(MatadorIndexes) do

                AddMoney(Player, 8, mod.EffectType.JOKER, Index)
            end
        end
        
        CurrentInterval = CurrentInterval + mod:PlanetUpgradeAnimation(HandType, -1, CurrentInterval)

    elseif mod.Saved.BlindBeingPlayed & mod.BLINDS.BOSS ~= 0 then

        --in general, if a card is debuffed then matador does stuff

        for _, Pointer in ipairs(PlayedCards) do

            local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

            if card.Modifiers & mod.Modifier.DEBUFFED ~= 0 then
                
                local MatadorIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.MATADOR)

                for _,Index in ipairs(MatadorIndexes) do

                    AddMoney(Player, 8, mod.EffectType.JOKER, Index)
                end

                break
            end
        end
    end




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

        if Joker == 0 or Slot.Modifiers & mod.Modifier.DEBUFFED ~= 0 then
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.RUNNER then
            
            if CompatibleHands & mod.HandFlags.STRAIGHT ~= 0 then
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 15, mod.EffectColors.BLUE)

            end

        elseif Joker == mod.Jokers.SUPERPOSISION then
            
            if CompatibleHands & mod.HandFlags.STRAIGHT ~= 0 then

                for i,Pointer in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

                    --searches for an ace
                    if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], 1) then

                        local TarotRNG = Player:GetTrinketRNG(mod.Jokers.SUPERPOSISION)

                        local RandomTarot = mod:RandomTarot(TarotRNG, false, false)

                        local Success = mod:TJimboAddConsumable(Player, RandomTarot, 0, true)

                        if Success then
                            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)
                        end

                        break
                    end
                end
            end

        elseif Joker == mod.Jokers.SEANCE then
            
            if CompatibleHands & mod.HandFlags.STRAIGHT_FLUSH ~= 0 then

                local SpectralRNG = Player:GetTrinketRNG(mod.Jokers.SEANCE)

                local RandomSpectral = mod:RandomTarot(SpectralRNG, false, false)

                local Success = mod:TJimboAddConsumable(Player, RandomSpectral, 0, true)

                if Success then
                    GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Spectral!", mod.EffectType.JOKER, JokerIndex)
                end

                break
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

                    IncreaseInterval(6)

                    NumSucked = NumSucked + 1

                    break
                end
            end

            if NumSucked > 0 then
                IncreaseJokerProgress(Player, PIndex, JokerIndex, 0.1*NumSucked, true)
            end

            Isaac.RunCallback(mod.Callbalcks.DECK_MODIFY, Player)

        elseif Joker == mod.Jokers.MIDAS then

            if Copied then
                goto SKIP_SLOT
            end
        
            for i,Pointer in ipairs(PlayedCards) do

                if mod:IsValue(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Values.FACE) then

                    Isaac.CreateTimer(function ()
                        mod.Saved.Player[PIndex].FullDeck[Pointer].Enhancement = mod.Enhancement.GOLDEN
                    end, CurrentInterval, 1, true)

                    IncreaseInterval(6)

                    NumSucked = NumSucked + 1

                    break
                end
            end

            if NumSucked > 0 then
                IncreaseJokerProgress(Player, PIndex, JokerIndex, 0.1*NumSucked)
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "Golden!", mod.EffectType.JOKER, JokerIndex)
            end

            Isaac.RunCallback(mod.Callbalcks.DECK_MODIFY, Player)

        elseif Joker == mod.Jokers.SQUARE_JOKER then
            
            if #PlayedCards == 4 then
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 4)

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "+4", mod.EffectType.JOKER, ProgressIndex)
            end

        elseif Joker == mod.Jokers.GREEN_JOKER then

            if Copied then
                goto SKIP_SLOT
            end
            
            IncreaseJokerProgress(Player, PIndex, ProgressIndex, 4, true)


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
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, ProgressIndex)

            else
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 1, mod.EffectColors.RED, true)
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+1", mod.EffectType.JOKER, ProgressIndex)
            end

        elseif Joker == mod.Jokers.OBELISK then

            if Copied then
                goto SKIP_SLOT
            end

            local TimesMostUsed = mod:GetMax(mod.Saved.HandsUsed)

            if mod.Saved.HandsUsed[HandType] >= TimesMostUsed then
                
                mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] = 1
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, ProgressIndex)

            else
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 0.2, mod.EffectColors.RED, false)
            end

        elseif Joker == mod.Jokers.VAGABOND then
            
            if Player:GetNumCoins() <= 4 then

                local TarotRNG = Player:GetTrinketRNG(mod.Jokers.SUPERPOSISION)

                local RandomTarot = mod:RandomTarot(TarotRNG, false, false)

                local Success = mod:TJimboAddConsumable(Player, RandomTarot, 0, true)

                if Success then
                    GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)
                end
            end

        elseif Joker == mod.Jokers.DNA then

            if mod.Saved.HandsRemaining == Player:GetCustomCacheValue(mod.CustomCache.HAND_NUM) - 1
               and #mod.SelectionParams[PIndex].PlayedCards == 1 then
                
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Copied!", mod.EffectType.JOKER, JokerIndex)
            
                local CopyCard = mod.Saved.Player[PIndex].FullDeck[mod.SelectionParams[PIndex].PlayedCards[1]]

                mod:AddCardToDeck(Player, CopyCard, 1, true)
            end
        end


        ::SKIP_SLOT::
    end


    --specifically the flint effect happens here

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_FLINT then
        
        mod.Saved.ChipsValue = mod.Saved.ChipsValue / 2
        mod.Saved.MultValue = mod.Saved.MultValue / 2
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

    local LowestCardPointer = 0

    do -----RAISED FIST-----
    
    local LowestValue = 15

    for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

        if mod:GetValueScoring(mod.Saved.Player[PIndex].FullDeck[Pointer].Value) <= LowestValue then

            LowestValue = mod.Saved.Player[PIndex].FullDeck[Pointer].Value + 0
            LowestCardPointer = Pointer
        end
    end

    end

    for Index,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do

        HeldCardEffect(Player, Pointer, Index, LowestCardPointer)
    end



--------------------------------------------------
------------------JOKER SCORING-------------------
--------------------------------------------------


    local BaseballIndexes = mod:GetJimboJokerIndex(Player, mod.Jokers.BASEBALL)

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
            
            IncreaseMult(Player, PIndex, 4, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.GROS_MICHAEL then
            
            IncreaseMult(Player, PIndex, 15, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.CAVENDISH then
            
            MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.MISPRINT then

            IncreaseMult(Player, PIndex, Player:GetTrinketRNG(mod.Jokers.MISPRINT):RandomInt(0,23), mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.JOLLY_JOKER then

            if CompatibleHands & mod.HandFlags.PAIR ~= 0 then
                IncreaseMult(Player, PIndex, 8, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.ZANY_JOKER then

            if CompatibleHands & mod.HandFlags.THREE ~= 0 then
                IncreaseMult(Player, PIndex, 12, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.MAD_JOKER then

            if CompatibleHands & mod.HandFlags.TWO_PAIR ~= 0 then
                IncreaseMult(Player, PIndex, 10, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.CRAZY_JOKER then

            if CompatibleHands & mod.HandFlags.STRAIGHT ~= 0 then
                IncreaseMult(Player, PIndex, 12, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.DROLL_JOKER then

            if CompatibleHands & mod.HandFlags.FLUSH ~= 0 then
                IncreaseMult(Player, PIndex, 10, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.SLY_JOKER then

            if CompatibleHands & mod.HandFlags.PAIR ~= 0 then
                IncreaseChips(Player, PIndex, 80, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.WILY_JOKER then

            if CompatibleHands & mod.HandFlags.THREE ~= 0 then
                IncreaseChips(Player, PIndex, 120, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.CLEVER_JOKER then

            if CompatibleHands & mod.HandFlags.TWO_PAIR ~= 0 then
                IncreaseChips(Player, PIndex, 100, mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.DEVIOUS_JOKER then

            if CompatibleHands & mod.HandFlags.STRAIGHT ~= 0 then
                IncreaseChips(Player, PIndex, 120, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.CRAFTY_JOKER then

            if CompatibleHands & mod.HandFlags.FLUSH ~= 0 then
                IncreaseChips(Player, PIndex, 100, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.HALF_JOKER then

            if #mod.SelectionParams[PIndex].PlayedCards <= 3 then
                IncreaseMult(Player, PIndex, 20, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.BANNER then

            if mod.Saved.DiscardsRemaining > 0 then
                IncreaseChips(Player, PIndex, 30 * mod.Saved.DiscardsRemaining, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.MYSTIC_SUMMIT then

            if mod.Saved.DiscardsRemaining == 0 then
                IncreaseMult(Player, PIndex, 15, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.SUPERNOVA then

            local PokerUses = mod.Saved.HandsTypeUsed[HandType]

            IncreaseMult(Player, PIndex, PokerUses, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.CARD_SHARP then

            local HandFlag = 1 << HandType

            local PlayedHands = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

            local HandWasPlayed = PlayedHands & HandFlag ~= 0

            if HandWasPlayed then
                MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            else
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = PlayedHands | HandFlag
            end

        elseif Joker == mod.Jokers.ACROBAT then

            --PLACEHOLDER
            if mod.Saved.HandsRemaining == 0 then
                IncreaseMult(Player, PIndex, 15, mod.EffectType.JOKER, JokerIndex)
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
            
                MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)
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

                MultiplyMult(Player, PIndex, 2, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.DUO then

            if CompatibleHands & mod.HandFlags.PAIR ~= 0 then
                MultiplyMult(Player, PIndex, 2, mod.EffectType.JOKER, JokerIndex)
            end
        
        elseif Joker == mod.Jokers.TRIO then

            if CompatibleHands & mod.HandFlags.THREE ~= 0 then
                MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.FAMILY then

            if CompatibleHands & mod.HandFlags.FOUR ~= 0 then
                MultiplyMult(Player, PIndex, 4, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.ORDER then

            if CompatibleHands & mod.HandFlags.STRAIGHT ~= 0 then
                MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.TRIBE then

            if CompatibleHands & mod.HandFlags.FLUSH ~= 0 then
                MultiplyMult(Player, PIndex, 2, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.DRIVER_LICENSE then

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] >= 16 then --counts the enhanced cards
                MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.BLACKBOARD then

            local IsGood = true

            for _,Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
                
                if not (mod:IsSuit(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Suits.Spade)
                        or mod:IsSuit(Player, mod.Saved.Player[PIndex].FullDeck[Pointer], mod.Suits.Club)) then
                            
                    IsGood = false
                    break
                end
            end

            if IsGood then
                MultiplyMult(Player, PIndex, 3, mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.YORICK then

            local Mult = 1 + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] // 23)

            MultiplyMult(Player, PIndex, Mult, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.CASTLE then

            local Chips = (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~SUIT_FLAG)/(SUIT_FLAG + 1)

            IncreaseChips(Player, PIndex, Chips, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.LOYALTY_CARD then
            
            local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

            if Progress == 0 then
                MultiplyMult(Player, PIndex, 4, mod.EffectType.JOKER, JokerIndex)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 6
            end

        elseif Joker == mod.Jokers.BULL then
            

            local Chips = Player:GetNumCoins()*2

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Chips


            IncreaseChips(Player, PIndex, Chips, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.BLUE_JOKER then

            local NumCards = #mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer + 1

            IncreaseChips(Player, PIndex, NumCards*2, mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.BOOTSTRAP then

            local Mult = (Player:GetNumCoins()//5) * 2

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Mult

            IncreaseMult(Player, PIndex, Mult, mod.EffectType.JOKER, JokerIndex)
        
        elseif Joker == mod.Jokers.STONE_JOKER
            or Joker == mod.Jokers.ICECREAM
            or Joker == mod.Jokers.RUNNER
            or Joker == mod.Jokers.SQUARE_JOKER
            or Joker == mod.Jokers.WEE_JOKER then

            IncreaseChips(Player, PIndex, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], mod.EffectType.JOKER, JokerIndex)

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


            IncreaseMult(Player, PIndex, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], mod.EffectType.JOKER, JokerIndex)

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


            MultiplyMult(Player, PIndex, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex], mod.EffectType.JOKER, JokerIndex)

        end

        

        if mod:GetJokerRarity(Joker) == "uncommon" then
            for _, BaseballIndex in ipairs(BaseballIndexes) do

                Isaac.CreateTimer(function ()
                    mod.Counters.Activated[BaseballIndex] = 0
                end,CurrentInterval, 1, true)

                MultiplyMult(Player, PIndex, 1.5, mod.EffectType.JOKER, JokerIndex)
            end
        end

        if Slot.Edition == mod.Edition.FOIL then
            IncreaseChips(Player, PIndex, 50, mod.EffectType.JOKER, JokerIndex)
        elseif Slot.Edition == mod.Edition.HOLOGRAPHIC then
            IncreaseMult(Player, PIndex, 10, mod.EffectType.JOKER, JokerIndex)
        elseif Slot.Edition == mod.Edition.POLYCROME then
            MultiplyMult(Player, PIndex, 1.5, mod.EffectType.JOKER, JokerIndex)
        end

        ::SKIP_SLOT::
    end

-------------------OBSERVATORY--------------------
--------------------------------------------------

    if Player:HasCollectible(mod.Vouchers.Observatory) then

        for i, Consumable in ipairs(mod.Saved.Player[PIndex].Consumables) do

            local Planet = Consumable.Card

            if Planet < mod.Planets.PLUTO
               or Planet > mod.Planets.SUN then
                
                goto SKIP_PLANET
            end

            local PlanetPokerHand = Planet - mod.Planets.PLUTO + 1

            if HandType == PlanetPokerHand then
                
                MultiplyMult(Player, PIndex, 1.5, mod.EffectType.CONSUMABLE, i)
            end

            ::SKIP_PLANET::
        end

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
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, -5, mod.EffectColors.BLUE, true)
            end
        elseif Joker == mod.Jokers.SELTZER then
            
            if Copied then
                goto SKIP_SLOT
            end


            IncreaseJokerProgress(Player, PIndex, ProgressIndex, -1)

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] <= 0 then
                
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                     "Empty!", mod.EffectType.JOKER, JokerIndex)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                     "-1", mod.EffectType.JOKER, JokerIndex)
            end


        elseif Joker == mod.Jokers.LOYALTY_CARD then
            
            if not Copied then
                local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

                if Progress == 1 then
                    GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Active!", mod.EffectType.JOKER, ProgressIndex)
                
                elseif Progress == 6 then
                    GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, ProgressIndex)
                
                else
                    GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, tostring(Progress).." Remaining!", mod.EffectType.JOKER, ProgressIndex)
                end

                IncreaseJokerProgress(Player, PIndex, ProgressIndex, -1)
            end

        elseif Joker == mod.Jokers.MATADOR then

            for _,Pointer in ipairs(PlayedCards) do

                local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

                if card.Modifiers & mod.Modifier.DEBUFFED then

                    AddMoney(Player, 8, mod.EffectType.JOKER, JokerIndex)

                    break
                end
            end
        end


        ::SKIP_SLOT::
    end
    
    local CardsToDestroy = {}

    for i,Index in ipairs(PlayedCards) do

        if mod.Saved.Player[PIndex].FullDeck[Index].Enhancement == mod.Enhancement.GLASS then

            if mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.GLASS_JOKER), 0.25) then
                CardsToDestroy[#CardsToDestroy+1] = Index
            end
        end
    end

    local SixthSense = mod:GetJimboJokerIndex(Player, mod.Jokers.SIXTH_SENSE)[1]
    local DestroyedBySixth = false

    if SixthSense 
      and #PlayedCards == 1 and mod.Saved.Player[PIndex].Fulldeck[PlayedCards[1]].Value == 6
      and not mod:Contained(CardsToDestroy, PlayedCards[1]) then

        DestroyedBySixth = true
        CardsToDestroy[#CardsToDestroy+1] = PlayedCards[1]

        --IncreaseInterval(3)
    end

    Isaac.CreateTimer(function ()
        mod:DestroyCards(Player, CardsToDestroy, true, true)
    end, CurrentInterval, 1, true)

    if DestroyedBySixth then

        if mod:TJimboAddConsumable(Player, -1, 0, true) then

            Isaac.CreateTimer(function ()

                local SpectralRNG = Player:GetTrinketRNG(mod.Jokers.SIXTH_SENSE)

                local RandomSpectral = mod:RandomTarot(SpectralRNG, false, false, false)

                mod:TJimboAddConsumable(Player, RandomSpectral, 0, true)
            end, CurrentInterval, 1, true)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.PURPLE, mod.Sounds.ACTIVATE, "Destroyed!", mod.EffectType.JOKER, SixthSense)
        end

    elseif #CardsToDestroy > 0 then
        IncreaseInterval(8)
    end


----------SHOW TOTAL HAND SCORE ANIMATION----------
---------------------------------------------------


local AnimLength = 12

Isaac.CreateTimer(function ()

    local ScoredChips = mod.Saved.ChipsValue + 0
    local ScoredMult = mod.Saved.MultValue + 0
    local ScoredScore = ScoredChips*ScoredMult --lol funny name

    for i=1, AnimLength do

        Isaac.CreateTimer(function ()

            mod.Saved.ChipsValue = math.floor(mod:Lerp(ScoredChips, 0, i/AnimLength))
            mod.Saved.MultValue = math.floor(mod:Lerp(ScoredMult, 0, i/AnimLength))

            mod.Saved.TotalScore = math.ceil(mod:Lerp(0, ScoredScore, i/AnimLength))
        end, i, 1, true)
    end

end, CurrentInterval, 1, true)


--------------RESET VALUES------------------
--------------------------------------------

    CurrentInterval = CurrentInterval + AnimLength

    Isaac.CreateTimer(function ()
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.AIMING)
    
        --mod.AnimationIsPlaying = false
    end, CurrentInterval, 1, true)
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
            for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                if Slot.Joker ~= 0 and JokerIndex ~= Index then
                    TotalSell = TotalSell + mod:GetJokerCost(Slot.Joker, Slot.Edition, JokerIndex, Player)
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = TotalSell -- +MULT

        elseif Joker == mod.Jokers.SQUARE_JOKER then
            Options.Filter = false --they get what they deserve

        end
    end
end
mod:AddCallback(mod.Callbalcks.INVENTORY_CHANGE, CopyAdjustments)





--effects when a blind gets completed
local function OnBlindSkip(_,BlindType)

    ResetEffects()

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

        if Joker == mod.Jokers.THROWBACK then

            if not Copied then

                local Progress = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

                Progress = 1 + 0.25*mod.Saved.NumBlindsSkipped

                local Text = "X"..tostring(Progress)

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, Text, mod.EffectType.JOKER, JokerIndex)
            end

        end

        ::SKIP_SLOT::
    end --END JOKER FOR

    ::skip_player::

    end --END PLAYER FOR

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.BLIND_SKIP, OnBlindSkip)


local function OnBlindSelect(_,BlindType)

    ResetEffects(8)

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
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!", mod.EffectType.JOKER, JokerIndex)
            end

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

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Stone!", mod.EffectType.JOKER, JokerIndex)

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

                IncreaseJokerProgress(Player, PIndex, JokerIndex, RightSell, mod.EffectColors.RED, false)

                mod.Saved.Player[PIndex].Inventory[RightIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[RightIndex].Edition = 0

                Isaac.RunCallback("INVENTORY_CHANGE", Player)

                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.MADNESS then

            if not Copied or BlindType & mod.BLINDS.BOSS ~= 0 then
                goto SKIP_SLOT
            end
                
            IncreaseJokerProgress(Player, PIndex, JokerIndex, 0.5, mod.EffectColors.RED, false)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.5 X", mod.EffectType.JOKER, JokerIndex)
            
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

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Added!", mod.EffectType.JOKER, JokerIndex)
        
        end

        ::SKIP_SLOT::
    end --END JOKER FOR

    ::skip_player::

    end --END PLAYER FOR

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.BLIND_SELECTED, OnBlindSelect)




--effects when a blind gets completed
local function OnBlindStart(_,BlindType)

    ResetEffects(12)

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

        if Joker == mod.Jokers.RIFF_RAFF then
            local RaffRNG = Player:GetTrinketRNG(mod.Jokers.RIFF_RAFF)
            
            local RandomJokers = mod:RandomJoker(RaffRNG, true, "common", 2)

            for i=1, 2 do
                
                Isaac.CreateTimer(function ()
                    local Success = mod:AddJoker(Player, RandomJokers[i].Joker, RandomJokers[i].Edition)
                    if Success then
                        mod.Counters.Activated[JokerIndex] = 0
                    end
                end, CurrentInterval, 1, true)

                IncreaseInterval(8)
                
            end

            IncreaseInterval(8)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jokers!", mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.BURGLAR then

            mod.Saved.HandsRemaining = mod.Saved.HandsRemaining + 3

            mod.Saved.DiscardsRemaining = 0


            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "+3", mod.EffectType.JOKER, JokerIndex)

        end

        ::SKIP_SLOT::
    end --END JOKER FOR

    ::skip_player::

    end --END PLAYER FOR

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)


---@diagnostic disable-next-line: need-check-nil
    CurrentInterval = CurrentInterval + 4*T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)


    Isaac.CreateTimer(function ()
        mod.AnimationIsPlaying = false
    end, CurrentInterval, 1, true)

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.POST_BLIND_START, OnBlindStart)




--effects when a blind gets completed
local function OnBlindClear(_,BlindType)

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
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

            IncreaseJokerProgress(Player, PIndex, ProgressIndex, 1)

            local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]

            
            if Progress < 2 then --still charging
            
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                     tostring(Progress).."/2", mod.EffectType.JOKER, JokerIndex)

            else --usable
            
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                     "Active!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.ROCKET then

            --on boss beaten it upgrades
            if BlindType & mod.BLINDS.BOSS ~= 0 then
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 2)

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                         "Upgrade!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.EGG then

            IncreaseJokerProgress(Player, PIndex, ProgressIndex, 3)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE,
                                 "Value Up!", mod.EffectType.JOKER, JokerIndex)

        elseif Joker == mod.Jokers.POPCORN then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(Player, PIndex, ProgressIndex, -4)

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] <= 0 then
                
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "Eaten!", mod.EffectType.JOKER, JokerIndex)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "-4", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.GROS_MICHAEL then
            if not Copied and mod:TryGamble(Player,Player:GetTrinketRNG(mod.Jokers.GROS_MICHAEL), 1/6) then
                
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Edition = mod.Edition.BASE

                mod.Saved.MichelDestroyed = true

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!", mod.EffectType.JOKER, JokerIndex)
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Safe!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.CAVENDISH then
            if not Copied and mod:TryGamble(Player, Player:GetTrinketRNG(mod.Jokers.CAVENDISH), 0.001) then --1/4000 chance
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[JokerIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Extinct!", mod.EffectType.JOKER, JokerIndex)
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Safe!", mod.EffectType.JOKER, JokerIndex)
            end



        
        elseif Joker == mod.Jokers.GIFT_CARD then
            
            for i,JokerSlot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if JokerSlot.Joker ~= 0 then
                    mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] or 0
                    
                    mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] = mod.Saved.Player[PIndex].Progress.GiftCardExtra[i] + 1
                end
            end

            GeneralBalatroEffect(Player, PIndex)

            mod:CreateBalatroEffect(JokerIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Value Up!",mod.Jokers.GIFT_CARD)


            if mod:JimboHasTrinket(Player, mod.Jokers.SWASHBUCKLER) then
                Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end

        elseif Joker == mod.Jokers.TURTLE_BEAN then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(Player, PIndex, ProgressIndex, -1)

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] <= 0 then
                
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Joker = 0
                mod.Saved.Player[PIndex].Inventory[ProgressIndex].Edition = mod.Edition.BASE

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "Eaten!", mod.EffectType.JOKER, JokerIndex)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                                     "-1", mod.EffectType.JOKER, JokerIndex)
            end


        elseif Joker == mod.Jokers.HIT_ROAD then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Reset!", mod.EffectType.JOKER, JokerIndex)


        
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
                RandomCard = mod.Saved.Player[PIndex].FullDeck[mod:GetRandom(ValidCards, Player:GetTrinketRNG(mod.Jokers.IDOL), true)]
                Suit = RandomCard.Suit
                Value = RandomCard.Value
            else
                Suit = mod.Suits.Spade
                Value = 1
            end
            
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = (Suit + 8*Value)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, mod:CardValueToName(Value, false, true).." "..mod:CardSuitToName(Suit, false, true), mod.EffectType.JOKER, JokerIndex)
        
        elseif Joker == mod.Jokers.TO_DO_LIST then

            if not Copied then

                local Hand = mod:RandomHandType(Player:GetTrinketRNG(mod.Jokers.TO_DO_LIST), true)

                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Hand

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.MAIL_REBATE then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Player:GetTrinketRNG(mod.Jokers.MAIL_REBATE):PhantomInt(mod.Values.KING) + 1
                
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            if not Copied then
                local Suit = mod.Saved.Player[PIndex].FullDeck[Player:GetTrinketRNG(mod.Jokers.CASTLE):PhantomInt(#mod.Saved.Player[PIndex].FullDeck)].Suit + 1
                
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Suit + (mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & ~SUIT_FLAG)

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end
        elseif Joker == mod.Jokers.ANCIENT_JOKER then

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = Player:GetTrinketRNG(mod.Jokers.ANCIENT_JOKER):PhantomInt(mod.Suits.Diamond) + 1

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Change!", mod.EffectType.JOKER, JokerIndex)
            end
        
        elseif Joker == mod.Jokers.CARD_SHARP then

            --progress contains as a bitflag the hand types played, this resets said hand at the end of round
            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0

        elseif Joker ==  mod.Jokers.GIFT_CARD then

            for JokerIndex, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if Slot.Joker ~= 0 then

                    local Extra = mod.Saved.Player[PIndex].GiftCardExtra[JokerIndex]

                    Extra = Extra or 0

                    Extra = Extra + 1
                else
                    mod.Saved.Player[PIndex].GiftCardExtra[JokerIndex] = 0
                end
            end

            for Index, Consumable in ipairs(mod.Saved.Player[PIndex].Consumables) do

                if Consumable.Card ~= -1 then

                    local Extra = mod.Saved.Player[PIndex].GiftCardConsumableExtra[Index]

                    Extra = Extra or 0

                    Extra = Extra + 1
                else
                    mod.Saved.Player[PIndex].GiftCardConsumableExtra[Index] = 0
                end
            end
        end


        ::SKIP_SLOT::
    end --END JOKER FOR



    local TriggersLeft = 1
    local TriggerCauses = {mod.EffectType.NULL}

    for _,MimeIndex in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.MIME)) do
        
        TriggersLeft = TriggersLeft + 1
        table.insert(TriggerCauses, 1, mod.EffectType.HAND_FROM_JOKER | MimeIndex)
    end


    --BLUE SEAL EFFECT

    for CardIndex, Pointer in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
        local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

        for i = #TriggerCauses, 1, -1 do

            if card.Seal == mod.Seals.BLUE then

                local Planet = mod.Planets.PLUTO + math.log(mod.Saved.HandType, 2) - 1

                Isaac.CreateTimer(function ()
                    local Success = mod:TJimboAddConsumable(Player, Planet, 0, true)

                    if Success then
                        mod:CreateBalatroEffect(Pointer, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "Planet!", mod.EffectType.HAND)
                    end

                end, CurrentInterval, 1, true)

                IncreaseInterval(8)
            
            elseif card.Seal == mod.Seals.RED then
                table.insert(TriggerCauses, #TriggerCauses, mod.EffectType.HAND)
            end

            if card.Enhancement == mod.Enhancement.GOLDEN then

                AddMoney(Player, 3, mod.EffectType.HAND, Pointer)
            end

            if TriggerCauses[i] == mod.EffectType.HAND then --red seal
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.HAND, Pointer)
                table.remove(TriggerCauses, i)

            elseif TriggerCauses[i] ~= mod.EffectType.NULL then --any joker
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Again!", mod.EffectType.JOKER, TriggerCauses[TriggersLeft])
            end
        end
    end


    ::skip_player::

    end --END PLAYER FOR

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.POST_BLIND_CLEAR, OnBlindClear)



local function OnShopReroll()

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

        if Joker == mod.Jokers.FLASH_CARD then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(Player, PIndex, JokerIndex, 2, mod.EffectColors.RED, false)

        end


        ::SKIP_SLOT::
    end

        ::skip_player::
    end

    return CurrentInterval

end
mod:AddCallback(mod.Callbalcks.SHOP_REROLL, OnShopReroll)



local function OnShopExit(_)

    mod.Saved.NumShopRerolls = 0
    mod.Saved.RerollStartingPrice = 0

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

        if Joker == mod.Jokers.PERKEO then

            local PossibleConsumables = {}
            
            for i,Consumable in ipairs(mod.Saved.Player[PIndex].Consumables) do
                
                if Consumable.Card ~= 0 then
                    PossibleConsumables[#PossibleConsumables+1] = Consumable.Card
                end
            end

            if next(PossibleConsumables) then
                
                local RandomCard = mod:GetRandom(PossibleConsumables, Player:GetTrinketRNG(mod.Jokers.PERKEO))

                mod:TJimboAddConsumable(Player, RandomCard, 0, false, mod.Edition.NEGATIVE)

            end

        elseif Joker == mod.Jokers.CHAOS_CLOWN then

            mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 1 --makes its free reroll available
        end


        ::SKIP_SLOT::
    end

        ::skip_player::
    end

    return CurrentInterval

end
mod:AddCallback(mod.Callbalcks.SHOP_EXIT, OnShopExit)



local function CashoutEvaluation(_, BlindBeaten)

    local Player = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not Player then
        return
    end

    mod.ScreenStrings.CashOut = {}

    mod.AnimationIsPlaying = true

    ResetEffects(8)

    local Room = Game:GetRoom()

    local TotalGain = 0

    if Room:GetType() == RoomType.ROOM_BOSSRUSH
       or mod:IsTaintedHeartBossRoom() then

        Isaac.CreateTimer(function ()
            mod.AnimationIsPlaying = false
            
        end, CurrentInterval, 1, true)


        return TotalGain
    end

    

    local BlindMoney = mod:GetBlindReward(BlindBeaten)


    AddCashoutString("Blind beaten", BlindMoney, BlindBeaten)
    TotalGain = TotalGain + BlindMoney

    AddCashoutString(". . . . . . . . . . . . . . . . . . . .", BlindMoney, mod.StringTypes.General)

    local PIndex = Player:GetData().TruePlayerIndex


    AddCashoutString("Hands Remaining", mod.Saved.HandsRemaining, mod.StringTypes.Hand)
    TotalGain = TotalGain + mod.Saved.HandsRemaining

    
    local Interests = Player:GetNumCoins() // 5
    local MaxInterest = 5

    if Player:HasCollectible(mod.Vouchers.MoneyTree) then
        MaxInterest = 20

    elseif Player:HasCollectible(mod.Vouchers.MoneySeed) then

        MaxInterest = 10
    end

    Interests = math.min(Interests, MaxInterest)


    AddCashoutString("Interests (max "..tostring(MaxInterest).."$)", Interests, mod.StringTypes.Interest)
    TotalGain = TotalGain + Interests


    for i, Tag in ipairs(mod.Saved.SkipTags) do
        
        if Tag == mod.SkipTags.INVESTMENT and (BlindBeaten & mod.BLINDS.BOSS ~= 0) then
            
            Isaac.CreateTimer(function ()
                mod:UseSkipTag(i)
            end, CurrentInterval, 1, true)

            AddCashoutString("Invenstment", 25, mod.StringTypes.Interest)

            TotalGain = TotalGain + 25
        end
    end


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

        if Joker == mod.Jokers.CLOUD_NINE then
            
            local Nines = mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

            AddCashoutString("Cloud Nine", Nines, mod.StringTypes.Joker)
            TotalGain = TotalGain + Nines

        elseif Joker == mod.Jokers.DELAYED_GRATIFICATION then
            
            local Discards = mod.Saved.Player[PIndex].RemainingDiscards
            if Discards == Player:GetCustomCacheValue(mod.CustomCache.DISCARD_NUM) then

                AddCashoutString("Delayed Grat.", Discards*2, mod.StringTypes.Joker)
                TotalGain = TotalGain + Discards*2
            end


        elseif Joker == mod.Jokers.ROCKET then

            AddCashoutString("Rocket", mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex], mod.StringTypes.Joker)
            TotalGain = TotalGain + mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex]

        elseif Joker == mod.Jokers.GOLDEN_JOKER then

            AddCashoutString("Golden Joker", 4, mod.StringTypes.Joker)
            TotalGain = TotalGain + 4

        elseif Joker == mod.Jokers.SATELLITE then

            local UniquePlanets = mod:GetJokerInitialProgress(Joker, true)

            mod.Saved.Player[PIndex].Progress.Inventory[JokerIndex] = UniquePlanets

            AddCashoutString("Satellite", UniquePlanets, mod.StringTypes.Joker)
            TotalGain = TotalGain + UniquePlanets

        end

        ::SKIP_SLOT::
    end


    AddCashoutString("Total", TotalGain, mod.StringTypes.General)


    Isaac.CreateTimer(function ()
        mod.AnimationIsPlaying = false
        
    end, CurrentInterval, 1, true)


    return TotalGain
end
mod:AddCallback(mod.Callbalcks.CASHOUT_EVAL, CashoutEvaluation)


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
                    GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+1 Tarot!",mod.EffectType.JOKER, Index)
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
            IncreaseJokerProgress(Player, PIndex, Index, 3, mod.EffectColors.RED, false)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+3", mod.EffectType.JOKER, Index)
        end
    end
end
mod:AddCallback(mod.Callbalcks.PACK_SKIP, OnPackSkipped)



local function OnHandDiscard(_, Player, AmountDiscarded)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects(4)

    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.DISCARD, OnHandDiscard)



local function OnCardDiscard(_, Player, PointerDiscarded, HandIndex, IsLastCard)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    IncreaseInterval(4)


    local PIndex = Player:GetData().TruePlayerIndex

    local CardDiscarded = mod.Saved.Player[PIndex].FullDeck[PointerDiscarded]



    if CardDiscarded.Seal == mod.Seals.PURPLE then

        --tries to add a fake card to see if it's possible
        local Success = mod:TJimboAddConsumable(Player, 0, 0, true)

        if Success then

            Isaac.CreateTimer(function ()

                local Tarot = mod:RandomTarot(mod.RNGs.PURPLE_SEAL)

                mod:TJimboAddConsumable(Player, Tarot, 0, true)

            end, CurrentInterval, 1, true)

            GeneralBalatroEffect(Player, PIndex, mod.EffectColors.PURPLE, mod.Sounds.ACTIVATE, "+1 Tarot", mod.EffectType.HAND, PointerDiscarded, 2)
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
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.RAMEN then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(Player, PIndex, Index, -0.01)

            if mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 1 then --at 1 it self destructs

                mod.Saved.Player[PIndex].Inventory[Index].Joker = 0
                mod.Saved.Player[PIndex].Inventory[Index].Edition = 0
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.EAT, "Eaten!", mod.EffectType.JOKER, Index, 2)

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.EAT, "-0.01X", mod.EffectType.JOKER, Index, 2)
            end
        

        elseif Joker == mod.Jokers.MAIL_REBATE then

            if mod:IsValue(Player, CardDiscarded, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]) then
                
                AddMoney(Player, 5, mod.EffectType.JOKER, Index, 2)
            end

        elseif Joker == mod.Jokers.FACELESS then

            if Copied then
                goto SKIP_SLOT
            end

            if mod:IsValue(Player, CardDiscarded, mod.Values.FACE) then
                
                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 1)
            end

        elseif Joker == mod.Jokers.CASTLE then -- 2 values need to be stored, so the first 3 bits are for the suit and the other say how many were discarded

            if Copied then
                goto SKIP_SLOT
            end
        
            if mod:IsSuit(Player, CardDiscarded, mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] & SUIT_FLAG) then
                
                IncreaseJokerProgress(Player, PIndex, Index, 3 * (SUIT_FLAG+1), mod.EffectColors.BLUE)
            end

        elseif Joker == mod.Jokers.HIT_ROAD then

            if Copied then
                goto SKIP_SLOT
            end

            if mod:IsValue(Player, CardDiscarded, mod.Values.JACK) then
                
                IncreaseJokerProgress(Player, PIndex, Index, 0.5, mod.EffectColors.RED, false)
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "+0.5X", mod.EffectType.JOKER, Index, 2)
            end

        elseif Joker == mod.Jokers.TRADING_CARD then

            if Copied then
                goto SKIP_SLOT
            end

            if mod.SelectionParams[PIndex].SelectionNum == 1
               and mod.Saved.DiscardsRemaining == Player:GetCustomCacheValue(mod.CustomCache.DISCARD_NUM) - 1 then
                
                mod:CardRipEffect(CardDiscarded, mod.CardFullPoss[PointerDiscarded])
                mod:DestroyCards(Player, {HandIndex})

                AddMoney(Player, 3, mod.EffectType.JOKER, Index)
            end

        elseif Joker == mod.Jokers.YORICK then

            if Copied then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(Player, PIndex, Index, 1)

            local Progress = mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex]
            
            if Progress % 23 == 0 then

                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.RED, mod.Sounds.ACTIVATE, "X"..tostring(Progress//23), mod.EffectType.JOKER, Index, 2)
            end
            
        end


        if not IsLastCard then
            goto SKIP_SLOT
        end
            
        if Joker == mod.Jokers.GREEN_JOKER then

            if Copied or mod.Saved.Player[PIndex].Progress.Inventory[Index] <= 0 then
                goto SKIP_SLOT
            end

            IncreaseJokerProgress(Player, PIndex, Index, -1, mod.EffectColors.RED, true)
        
        elseif Joker == mod.Jokers.FACELESS then

            if mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] >= 3 then
                
                AddMoney(Player, 5, mod.EffectType.JOKER, Index)
            end

            if not Copied then
                mod.Saved.Player[PIndex].Progress.Inventory[ProgressIndex] = 0
            end
        end

        ::SKIP_SLOT::
    end

    return CurrentInterval

end
mod:AddCallback(mod.Callbalcks.CARD_DISCARD, OnCardDiscard)


---@param Player EntityPlayer
local function OnJokerAdded(_, Player, Joker, Edition, EmptySlot)
    --print("sold")
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects(8)

    local PIndex = Player:GetData().TruePlayerIndex

    --NOT COPIABLE JOKERS

    if Joker == mod.Jokers.DRUNKARD then
        
        mod.Saved.DiscardsRemaining = mod.Saved.DiscardsRemaining + 1

    elseif Joker == mod.Jokers.MERRY_ANDY then
        
        mod.Saved.DiscardsRemaining = mod.Saved.DiscardsRemaining + 2

    elseif Joker == mod.Jokers.CHAOS_CLOWN then

        mod:UpdateRerollPrice()
    end  

    
    --BP/BS CHACK
    if Joker == mod.Jokers.BLUEPRINT then
        Joker = mod.Saved.Player[PIndex].Inventory[EmptySlot + 1] and mod.Saved.Player[PIndex].Inventory[EmptySlot + 1] or 0

    elseif Joker == mod.Jokers.BRAINSTORM then
        Joker = mod.Saved.Player[PIndex].Inventory[1].Joker
    end

end
mod:AddCallback(mod.Callbalcks.JOKER_ADDED, OnJokerAdded)



--effects when a joker gets sold
---@param Player EntityPlayer
local function OnJokerSold(_, Player,Joker,SlotSold)
    --print("sold")
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects(8)

    mod.AnimationIsPlaying = true

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
    
    elseif Joker == mod.Jokers.CHAOS_CLOWN then

        mod:UpdateRerollPrice()
    end  

    for _,Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.CAMPFIRE, true)) do

        IncreaseJokerProgress(Player, PIndex, Index, 0.25, mod.EffectColors.RED, false)
    end
    
    --BP/BS CHACK
    if Joker == mod.Jokers.BLUEPRINT then
        Joker = mod.Saved.Player[PIndex].Inventory[SlotSold + 1] and mod.Saved.Player[PIndex].Inventory[SlotSold + 1] or 0

    elseif Joker == mod.Jokers.BRAINSTORM then
        Joker = mod.Saved.Player[PIndex].Inventory[1].Joker
    end
    
    
    if Joker == mod.Jokers.LUCHADOR then

        local OldBlind = mod.Saved.BlindBeingPlayed + 0

        if OldBlind & mod.BLINDS.BOSS ~= 0 then

            mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS --removes any special effect

            for Pointer, Card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
        
                mod.Saved.Player[PIndex].FullDeck[Pointer].Modifiers = 0 --no modifiers (not covered or debuffed)
            end

            for i, _ in ipairs(mod.Saved.Player[PIndex].Inventory) do
        
                mod.Saved.Player[PIndex].Inventory[i].Modifiers = 0 --no modifiers (not covered or debuffed)
            end


            if OldBlind == mod.BLINDS.BOSS_WALL then
                
                for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                    if Enemy:IsActiveEnemy() then
                        
                        local DamageDealt = Enemy.MaxHitPoints - Enemy.HitPoints

                        Enemy.MaxHitPoints = Enemy.MaxHitPoints / 2
                        Enemy.HitPoints = Enemy.MaxHitPoints - DamageDealt
                    end
                end

            elseif OldBlind == mod.BLINDS.BOSS_VESSEL then
                
                for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                    if Enemy:IsActiveEnemy() then
                        
                        local DamageDealt = Enemy.MaxHitPoints - Enemy.HitPoints

                        Enemy.MaxHitPoints = Enemy.MaxHitPoints / 3
                        Enemy.HitPoints = Enemy.MaxHitPoints - DamageDealt
                    end
                end


            end

        end

    elseif Joker == mod.Jokers.DIET_COLA then

        --PLACEHOLDER maybe play the tag sfx

        mod:AddSkipTag(mod.SkipTags.DOUBLE)
    end

    Isaac.CreateTimer(function ()
        mod.AnimationIsPlaying = false
    end, CurrentInterval, 1, true)


    Isaac.RunCallback("INVENTORY_CHANGE", Player)
end
mod:AddCallback(mod.Callbalcks.JOKER_SOLD, OnJokerSold)


local function OnJokerRemoved(_, Player, Joker)

    if Joker == mod.Jokers.CHAOS_CLOWN then
        
        mod:UpdateRerollPrice()
    end
end
mod:AddCallback(mod.Callbalcks.JOKER_REMOVED, OnJokerRemoved)



--effects when a consumable gets sold
---@param Player EntityPlayer
local function OnConsumableSold(_, Player, Consumable)
    --print("sold")
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects(6)

    mod.AnimationIsPlaying = true

    local PIndex = Player:GetData().TruePlayerIndex

    --NOT COPIABLE JOKERS

    for _,Index in mod:GetJimboJokerIndex(Player, mod.Jokers.CAMPFIRE, true) do

        IncreaseJokerProgress(Player, PIndex, Index, 0.25, mod.EffectColors.RED, false)
    end

    Isaac.CreateTimer(function ()
        mod.AnimationIsPlaying = false
    end, CurrentInterval, 1, true)
    
end
mod:AddCallback(mod.Callbalcks.CONSUMABLE_SOLD, OnConsumableSold)




local function OnConsumableUse(_, Player, Consumable)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    ResetEffects(12)

    if Consumable <= Card.CARD_WORLD then
        mod.Saved.TarotsUsed = mod.Saved.TarotsUsed + 1
    end


    local PIndex = Player:GetData().TruePlayerIndex

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
            goto SKIP_SLOT
        end

        if Joker == mod.Jokers.FORTUNETELLER then

            if not Copied and Consumable <= Card.CARD_WORLD then

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.TarotsUsed
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "+"..tostring(mod.Saved.TarotsUsed), mod.EffectType.JOKER, Index)
            end

        elseif Joker == mod.Jokers.CONSTELLATION then

            if not Copied
               and Consumable >= mod.Planets.PLUTO and Consumable <= mod.Planets.SUN then

                IncreaseJokerProgress(Player, PIndex, ProgressIndex, 0.1, mod.EffectColors.YELLOW, false)
                GeneralBalatroEffect(Player, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "X"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]), mod.EffectType.JOKER, Index)

            end
        end


        ::SKIP_SLOT::
    end

    return CurrentInterval

end
mod:AddCallback(mod.Callbalcks.CONSUMABLE_USE, OnConsumableUse)



---@param Player EntityPlayer
local function OnDeckModify(_, Player, CardsAdded, CardsDestroyed)

    local PIndex = Player:GetData().TruePlayerIndex

    CardsAdded = CardsAdded or 0
    CardsDestroyed = CardsDestroyed or {}

    for Index,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        if Slot.Joker == mod.Jokers.STEEL_JOKER then

            local NumSteel = 0

            for _,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                
                if card.Enhancement == mod.Enhancement.STEEL then
                    NumSteel = NumSteel + 1
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = 1 + 0.2*NumSteel

        elseif Slot.Joker == mod.Jokers.STONE_JOKER then

            local NumStone = 0

            for _,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                
                if card.Enhancement == mod.Enhancement.STONE then
                    NumStone = NumStone + 1
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = 25*NumStone

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

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.25*CardsAdded

                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.ACTIVATE,
                "+0.25X",mod.EffectType.JOKER, Player)
            end

        elseif Slot.Joker == mod.Jokers.EROSION then
            if CardsAdded ~= 0 then

                mod.Saved.Player[PIndex].Progress.Inventory[Index] = math.max(0, 4 * (52 - #mod.Saved.Player[PIndex].FullDeck))
            end

        elseif Slot.Joker == mod.Jokers.DRIVER_LICENSE then

            local Enahncements = 0
            for _,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                if card.Enhancement ~= mod.Enhancement.NONE then
                    Enahncements = Enahncements + 1
                end
            end

            mod.Saved.Player[PIndex].Progress.Inventory[Index] = Enahncements

        elseif Slot.Joker == mod.Jokers.GLASS_JOKER then

            local GlassNum = 0

            for _, card in ipairs(CardsDestroyed) do
                if card.Enhancement == mod.Enhancement.GLASS then
                    mod.Saved.Player[PIndex].Progress.Inventory[Index] = mod.Saved.Player[PIndex].Progress.Inventory[Index] + 0.75
                    GlassNum = GlassNum + 1
                end
            end

            if GlassNum ~= 0 then
                mod:CreateBalatroEffect(Index, mod.EffectColors.RED, mod.Sounds.TIMESMULT,
                "X"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[Index]),mod.EffectType.JOKER, Player)
            end

        elseif Slot.Joker == mod.Jokers.CANIO then
  
            local FaceNum = 0

            for _, card in ipairs(CardsDestroyed) do
                
                if mod:IsValue(Player, card, mod.Values.FACE) then
                    
                    FaceNum = FaceNum + 1
                end
            end

            if FaceNum ~= 0 then

                IncreaseJokerProgress(Player, PIndex, Index, FaceNum, mod.EffectColors.RED, false)
            end
        end
    end

    Player:EvaluateItems()
end
mod:AddCallback(mod.Callbalcks.DECK_MODIFY, OnDeckModify)



local function OnDeath(_, Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    for Index, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

        local Joker = Slot.Joker

        if Joker == mod.Jokers.MR_BONES then

            local BlindSize = mod:GetBlindScoreRequirement(mod.Saved.BlindBeingPlayed)
            
            local EnemyMaxHP = BlindSize

            for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                if Enemy:IsActiveEnemy() and Enemy:IsVulnerableEnemy() then
                    
                    EnemyMaxHP = math.min(EnemyMaxHP, Enemy.HitPoints)
                end
            end

            local Revive = EnemyMaxHP / BlindSize <= 0.75

            if not Revive then
                return
            end

            Player:Revive()

            Game:GetRoom():MamaMegaExplosion(Player.Position)

            Isaac.CreateTimer(function ()

                for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                    if Enemy:IsActiveEnemy() then

                        Enemy:Kill()
                    end
                end
            end, 8, 1, true)

            mod.Saved.Player[PIndex].Inventory[Index].Joker = 0 --removes the trinket
            mod.Saved.Player[PIndex].Inventory[Index].Edition = 0

            Isaac.RunCallback(mod.Callbalcks.INVENTORY_CHANGE, Player)

            mod:CreateBalatroEffect(Index, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Saved!",
                                    mod.EffectType.JOKER, Player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, OnDeath)





local function EvaluateBlindEffect(_, BlindStarted)

    local BlindType = mod.Saved.BlindBeingPlayed

    local TJimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not TJimbo then -- no TJimbo found
        return
    end

    ResetEffects(4)

    local PIndex = TJimbo:GetData().TruePlayerIndex

    local PlayerDeck = mod.Saved.Player[PIndex].FullDeck


    --clears the deck from all boss effects to then reapply what is needed        
    for Pointer, Card in ipairs(PlayerDeck) do
        
        PlayerDeck[Pointer].Modifiers = 0 --no modifiers (not covered or debuffed)
    end


    local OldBlind = mod.Saved.BlindBeingPlayed + 0

    if mod:JimboHasTrinket(TJimbo, mod.Jokers.CHICOT) then
    
        if mod.Saved.BlindBeingPlayed & mod.BLINDS.BOSS ~= 0 then

            GeneralBalatroEffect(TJimbo, PIndex, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Disabled!",
                                 mod.EffectType.JOKER, mod:GetJimboJokerIndex(TJimbo, mod.Jokers.CHICOT)[1])

            mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS

            --resets the required score for vessel and wall
            if OldBlind == mod.BLINDS.BOSS_WALL then
                
                for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                    if Enemy:IsActiveEnemy() then
                        
                        Enemy.HitPoints = Enemy.HitPoints / 2
                        Enemy.MaxHitPoints = Enemy.MaxHitPoints / 2
                    end
                end

            elseif OldBlind == mod.BLINDS.BOSS_VESSEL then
                
                for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                    if Enemy:IsActiveEnemy() then
                        
                        Enemy.HitPoints = Enemy.HitPoints / 3
                        Enemy.MaxHitPoints = Enemy.MaxHitPoints / 3
                    end
                end


            end
        end
    end
    
    if BlindType & mod.BLINDS.BOSS == 0  --if its not a boss
       or BlindType & ~mod.BLINDS.BOSS == 0 then --if its an effectless boss (usually chicot/luchador)

       -- no effects to apply
        return CurrentInterval
    end

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_WATER then
        
        TJimbo:AddCustomCacheTag(mod.CustomCache.DISCARD_NUM, true)

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_NEEDLE then
        
        TJimbo:AddCustomCacheTag(mod.CustomCache.HAND_NUM, true)

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_MANACLE then
        
        TJimbo:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)

    else
        for Pointer,Card in ipairs(PlayerDeck) do

            PlayerDeck[Pointer].Modifiers = PlayerDeck[Pointer].Modifiers | mod:GetCardModifiers(TJimbo, Card, Pointer)
        end

    end


    return CurrentInterval
end
mod:AddCallback(mod.Callbalcks.BOSS_BLIND_EVAL, EvaluateBlindEffect)


