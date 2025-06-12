local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()

local EFFECT_CARD_OFFSET = Vector(0, -15)


local NumEffectPlayed = 0 --used to dealy the effects accordingly (resets to 0 after everything is done)

local function IntervalTime(NumEffects)
    return 19 + 20*NumEffects
end

local function BalatroEffect(Position, Colour, Sound, Text, NumEffects)

    Isaac.CreateTimer(function ()

        mod:CreateBalatroEffect(Position, Colour, Sound, Text)
    end, IntervalTime(NumEffects),1,true)

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
            end

            mod:CreateBalatroEffect(Position, mod.EffectColors.BLUE, mod.Sounds.CHIPS, "+"..tostring(Amount))
        end
        
    end, IntervalTime(NumEffectPlayed),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end


local function IncreaseMult(PIndex, Amount, NumEffects, EffectPosition)

    Isaac.CreateTimer(function ()

        mod.Saved.Player[PIndex].MultValue = mod.Saved.Player[PIndex].MultValue + Amount
        
        if EffectPosition then
            mod:CreateBalatroEffect(EffectPosition, mod.EffectColors.RED, mod.Sounds.ADDMULT, "+"..tostring(Amount))
        end
    end, IntervalTime(NumEffects),1,true)

    NumEffectPlayed = NumEffectPlayed + 1
end


local function TriggerCard(Player, CardIndex)

    --local NumEffects = 0 --counts how many effects got played
    local PIndex = Player:GetData().TruePlayerIndex
    local Card = mod.Saved.Player[PIndex].FullDeck[CardIndex]

    if mod.Saved.Player[PIndex].FullDeck[CardIndex].Modifiers & mod.Modifier.DEBUFFED ~= 0 then
        
        Isaac.CreateTimer(function ()
            mod:CreateBalatroEffect(mod.LastCardFullPoss[CardIndex] + EFFECT_CARD_OFFSET, mod.EffectColors.PURPLE, SoundEffect.SOUND_BLOOD_LASER, "Debuffed!", mod.EffectType.HAND)
    
        end, IntervalTime(NumEffectPlayed),1,true)

        NumEffectPlayed = NumEffectPlayed + 1

        return
    end

    IncreaseChips(PIndex, mod:GetActualCardValue(Card.Value), mod.EffectType.HAND, CardIndex)

    

    --return NumEffects
end


---@param Player EntityPlayer
function mod:ScoreCards(Player)

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


    for i,Index in ipairs(mod.SelectionParams[PIndex].PlayedCards) do

        --print("played", i)
        
        if mod.SelectionParams[PIndex].ScoringCards & 2^(i-1) ~= 0 then

            --print("scored", i)
        
            --print("triggered", i)
            TriggerCard(Player, Index)
        end
    end

    mod.SelectionParams[PIndex].ScoringCards = mod:GetScoringCards(Player, mod.SelectionParams[PIndex].HandType)

--------------------------------------------------
-----------------IN HAND EFFECTS------------------
--------------------------------------------------





--------------------------------------------------
------------------JOKER SCORING-------------------
--------------------------------------------------







--------------RESET VALUES------------------
--------------------------------------------

    Isaac.CreateTimer(function ()
        NumEffectPlayed = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.AIMING)
    end, IntervalTime(NumEffectPlayed), 1, true)
end
mod:AddCallback(mod.Callbalcks.HAND_PLAY, mod.ScoreCards)


