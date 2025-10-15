---@diagnostic disable: inject-field
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()
local sfx = SFXManager()

local STANDARD_INTERVAL = 12

local TarotMaxSelection = {[Card.CARD_MAGICIAN] = 2,
                           [Card.CARD_EMPRESS] = 2,
                           [Card.CARD_HIEROPHANT] = 2,
                           [Card.CARD_LOVERS] = 1,
                           [Card.CARD_CHARIOT] = 1,
                           [Card.CARD_JUSTICE] = 1,
                           [Card.CARD_STRENGTH] = 2,
                           [Card.CARD_HANGED_MAN] = 2,
                           [Card.CARD_DEATH] = 2,
                           [Card.CARD_DEVIL] = 1,
                           [Card.CARD_TOWER] = 1,
                           [Card.CARD_STARS] = 3,
                           [Card.CARD_MOON] = 3,
                           [Card.CARD_SUN] = 3,
                           [Card.CARD_WORLD] = 3}


local SpectralMaxSelection = {[mod.Spectrals.AURA] = 1,
                              [mod.Spectrals.TALISMAN] = 1,
                              [mod.Spectrals.DEJA_VU] = 1,
                              [mod.Spectrals.TRANCE] = 1,
                              [mod.Spectrals.MEDIUM] = 1,
                              [mod.Spectrals.CRYPTID] = 1}

local function CardModifyPitch(Total, Num)

    local Step = (1.3 - 0.7)/Total

    return 0.7 +Step*Num
end

--the name is kind of misleading (it changes the selected cards' enhancement and such)
local function ChangeSelectionParams(Player, NewParams, SpecialOccasion)

    local PIndex = Player:GetData().TruePlayerIndex

    local Interval = 0
    local NumChanged = 0


    local NumSelected = mod.SelectionParams[PIndex].SelectionNum - 1

    mod.AnimationIsPlaying = true


    for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
        if Selected then

            NumChanged = NumChanged + 1

            local CardNumber = NumChanged + 0 --defining this here makes it keep ita value during the timers

            Interval = 4 * NumChanged

            local Pointer = mod.Saved.Player[PIndex].CurrentHand[i]
            local card = mod.Saved.Player[PIndex].FullDeck[Pointer]



            --flips once
            Isaac.CreateTimer(function ()

                card.Modifiers = card.Modifiers & mod.Modifier.COVERED == 0 and (card.Modifiers | mod.Modifier.COVERED) or (card.Modifiers & ~mod.Modifier.COVERED)
                
                mod.CardFullPoss[Pointer].Y = mod.CardFullPoss[Pointer].Y - 8
                --mod.Counters.SinceCardFlipped[Pointer] = 0
                sfx:Play(mod.Sounds.SELECT, 1, 2, false, CardModifyPitch(NumSelected, 8 - CardNumber))

            end, Interval, 1, true)


            --while flipped (usually covered) changes the params

            if not SpecialOccasion then
                Isaac.CreateTimer(function ()

                    card.Value = NewParams.Value or card.Value
                    card.Suit = NewParams.Suit or card.Suit
                    card.Enhancement = NewParams.Enhancement or card.Enhancement
                    card.Seal = NewParams.Seal or card.Seal
                    card.Edition = NewParams.Edition or card.Edition
                    card.Modifiers = NewParams.Modifiers or card.Modifiers

                end, Interval + 4 * (NumSelected - NumChanged + 1) + 1, 1, true)

            elseif SpecialOccasion == Card.CARD_STRENGTH then
                
                Isaac.CreateTimer(function ()

                    local NewValue
                    if card.Value == mod.Values.KING then
                        NewValue = 1
                    else
                        NewValue = card.Value + 1
                    end

                    card.Value = NewParams.Value or card.Value

                end, Interval + 4 * (NumSelected - NumChanged + 1) + 1, 1, true)
            end

            Interval = Interval + 24 + 4 * NumSelected

            Isaac.CreateTimer(function ()

                card.Modifiers = card.Modifiers & mod.Modifier.COVERED == 0 
                                 and (card.Modifiers | mod.Modifier.COVERED) 
                                 or (card.Modifiers & ~mod.Modifier.COVERED)

                sfx:Play(mod.Sounds.TAROT_UNFLIP, 1, 2, false, CardModifyPitch(NumSelected, CardNumber))

            end, Interval, 1, true)

        end
    end

    return Interval
end


function mod:PlayerIsAbleToUseCard(Player, Consumable)

    local PIndex = Player:GetData().TruePlayerIndex

    local IsTarot = Consumable >= Card.CARD_FOOL and Consumable <= Card.CARD_WORLD
    local IsPlanet = Consumable >= mod.Planets.PLUTO and Consumable <= mod.Planets.ERIS
    local IsSpectral = Consumable >= mod.Spectrals.FAMILIAR and Consumable <= mod.Spectrals.SOUL

    if IsPlanet then
        return true

    elseif IsTarot then

        if Consumable == Card.CARD_FOOL then

            return mod.Saved.Player[PIndex].LastCardUsed and mod.Saved.Player[PIndex].LastCardUsed ~= Card.CARD_FOOL

        
        elseif Consumable == Card.CARD_JUDGEMENT then

            return #mod:GetJimboJokerIndex(Player, 0) > 0 --if at least 1 slot is empty


        elseif Consumable == Card.CARD_WHEEL_OF_FORTUNE
               or Consumable == Card.CARD_TEMPERANCE then

            for i,v in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if v.Joker ~= 0 then
                    return true
                end
            end

            return false

        elseif TarotMaxSelection[Consumable]
               and (not mod.Saved.EnableHand --is selection is impossible
                    or (mod.SelectionParams[PIndex].SelectionNum > TarotMaxSelection[Consumable] or mod.SelectionParams[PIndex].SelectionNum <= 0
                         or (Consumable == Card.CARD_DEATH and mod.SelectionParams[PIndex].SelectionNum ~= 2))) then --if the wrong number of cards is selected
                   
            return false
        end

        return true

    elseif IsSpectral then

        if Consumable == mod.Spectrals.WRAITH then

            return #mod:GetJimboJokerIndex(Player, 0) > 0 --if at least 1 slot is empty

        elseif Consumable == mod.Spectrals.HEX
               or Consumable == mod.Spectrals.ANKH then

            for i,v in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if v.Joker ~= 0 then
                    return true
                end
            end

            return false


        elseif SpectralMaxSelection[Consumable]
               and (not mod.Saved.EnableHand --if selection is impossible
                    or (mod.SelectionParams[PIndex].SelectionNum > SpectralMaxSelection[Consumable] 
                         or mod.SelectionParams[PIndex].SelectionNum <= 0)) then
                   
            return false
        end

        return true

    else --somehow got a different card 
        return false
    end
end


--every tarot has a new effect when used by T. jimbo
---@param Player EntityPlayer
---@param card Card
local function TJimboUseTarot(card, Player, IsPack, UseFlags)

    local PIndex = Player:GetData().TruePlayerIndex
    
    ---local IsTarot = card >= Card.CARD_FOOL and card <= Card.CARD_WORLD

    local SelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]

    local AnimationInterval

    --[[
    if TarotMaxSelection[card]
       and (not mod.Saved.EnableHand --is selection is impossible
       or (mod.SelectionParams[PIndex].SelectionNum > TarotMaxSelection[card] or mod.SelectionParams[PIndex].SelectionNum <= 0
            or (card == Card.CARD_DEATH and mod.SelectionParams[PIndex].SelectionNum ~= 2))) then --if the wrong number of cards is selected

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return
    end]]

    local FreeSpaces = 0

    if card == Card.CARD_HIGH_PRIESTESS or card == Card.CARD_EMPEROR or card == Card.CARD_FOOL then
        
        for _, slot in ipairs(mod.Saved.Player[PIndex].Consumables) do 
            if slot.Card == -1 then
                FreeSpaces = FreeSpaces + 1
            end
        end
    end

    if card == Card.CARD_FOOL then


        if mod.Saved.Player[PIndex].LastCardUsed and mod.Saved.Player[PIndex].LastCardUsed ~= Card.CARD_FOOL then

            local Success = mod:TJimboAddConsumable(Player, mod.Saved.Player[PIndex].LastCardUsed)

            if not Success then
                return
            end

            AnimationInterval = STANDARD_INTERVAL

            goto FINISH
        else
            return
        end
    end
    
    

    if card == Card.CARD_MAGICIAN then
        
        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.LUCKY})
        
    elseif card == Card.CARD_HIGH_PRIESTESS then


        if FreeSpaces == 0 then
            return
        end

        AnimationInterval = 4

        local CardRNG = Player:GetCardRNG(card)
        
        local Rplanets = mod:RandomPlanet(CardRNG, false, false, math.min(2, FreeSpaces))

        for i,Planet in ipairs(Rplanets) do

            AnimationInterval = AnimationInterval + 16
            mod:TJimboAddConsumable(Player, Planet, 0, true)

            Isaac.CreateTimer(function ()
                Player:AnimateCard(Planet)
            end, AnimationInterval,1,true)
        end
        
    
    elseif card == Card.CARD_EMPRESS then

        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.MULT})
    
    elseif card == Card.CARD_EMPEROR then

        if FreeSpaces == 0 then
            return
        end

        AnimationInterval = 4

        local CardRNG = Player:GetCardRNG(card)
        for i=1, math.min(2, FreeSpaces) do

            AnimationInterval = AnimationInterval + 16

            local Tarot
            repeat 
                Tarot = mod:RandomTarot(CardRNG, false, false)
            until Tarot ~= Card.CARD_EMPEROR

            mod:TJimboAddConsumable(Player, Tarot, 0, true)
            
            Isaac.CreateTimer(function ()
                Player:AnimateCard(Tarot)
            end, AnimationInterval,1,true)

        end

        AnimationInterval = AnimationInterval + 8
        

    elseif card == Card.CARD_HIEROPHANT then

        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.BONUS})

    elseif card == Card.CARD_LOVERS then

        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.WILD})
    
    elseif card == Card.CARD_CHARIOT then

        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.STEEL})

    elseif card == Card.CARD_JUSTICE then

        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.GLASS})

    elseif card == Card.CARD_HERMIT then

        local CoinsToAdd =  (mod.Saved.DebtAmount ~= 0) and 0 or math.min(Player:GetNumCoins(), 20)
         --no more then 20 coins

        Player:AddCoins(CoinsToAdd)

        mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToAdd).."$", mod.EffectType.ENTITY, Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == Card.CARD_WHEEL_OF_FORTUNE then

        local CardRNG = Player:GetCardRNG(card)

        local BaseJokers = {}
        for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Edition == mod.Edition.BASE and mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                table.insert(BaseJokers, i)
            end
        end

        if not next(BaseJokers) then
            return
        end

        Isaac.CreateTimer(function ()

            if CardRNG:RandomFloat() < 0.25 and next(BaseJokers) then 
            
                local RandIndex = mod:GetRandom(BaseJokers,CardRNG)

                local EdRoll = Player:GetCardRNG(Card.CARD_WHEEL_OF_FORTUNE):RandomFloat()
                if EdRoll <= 0.5 then
                    sfx:Play(mod.Sounds.FOIL)
                    mod.Saved.Player[PIndex].Inventory[RandIndex].Edition = mod.Edition.FOIL
                    --PLACEHOLDER place editions sounds
                elseif EdRoll <= 0.85 then
                    sfx:Play(mod.Sounds.HOLO)
                    mod.Saved.Player[PIndex].Inventory[RandIndex].Edition = mod.Edition.HOLOGRAPHIC
                else
                    sfx:Play(mod.Sounds.POLY)
                    mod.Saved.Player[PIndex].Inventory[RandIndex].Edition = mod.Edition.POLYCROME
                end

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.PURPLE, mod.Sounds.NOPE, "Nope!", mod.EffectType.ENTITY, Player)--PLACEHOLDER
            end
        end, 24, 1, true)

        AnimationInterval = 28


    elseif card == Card.CARD_STRENGTH then


        AnimationInterval = ChangeSelectionParams(Player, {}, Card.CARD_STRENGTH)

        for i,v in ipairs(SelectedCards) do
            if v then
                if mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value == mod.Values.KING then
                    mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value = 1 --kings become aces
                else
                    mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value = 
                    mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Value + 1
                end
            end
        end
        Isaac.RunCallback("DECK_MODIFY", Player)
        

    elseif card == Card.CARD_HANGED_MAN then
        local selection = {}
        for i,v in ipairs(SelectedCards) do
            if v then
                table.insert(selection, mod.Saved.Player[PIndex].CurrentHand[i]) --gets the card that will be modified
            end
        end

        mod:DestroyCards(Player, selection, true, true)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == Card.CARD_DEATH then

        local FirstIndex
        local SecondCard

        for i,v in ipairs(SelectedCards) do
            if v then
                if FirstIndex then
                    SecondCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]]
                else
                    FirstIndex = i
                end
            end
        end

        AnimationInterval = ChangeSelectionParams(Player, SecondCard)

    elseif card == Card.CARD_TEMPERANCE then

        local CoinsToGain = 0

        for i ,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 then
                CoinsToGain = CoinsToGain + mod:GetJokerCost(Slot.Joker, Slot.Edition, i, Player)
            end
        end
        Player:AddCoins(CoinsToGain)

        mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToGain).."$", mod.EffectType.ENTITY, Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == Card.CARD_DEVIL then

        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.GOLDEN})

    elseif card == Card.CARD_TOWER then


        AnimationInterval = ChangeSelectionParams(Player, {Enhancement = mod.Enhancement.STONE})
        

    elseif card == Card.CARD_STARS then

        AnimationInterval = ChangeSelectionParams(Player, {Suit = mod.Suits.Diamond})

    elseif card == Card.CARD_MOON then
        
        AnimationInterval = ChangeSelectionParams(Player, {Suit = mod.Suits.Club})
        
    elseif card == Card.CARD_SUN then
        
        AnimationInterval = ChangeSelectionParams(Player, {Suit = mod.Suits.Heart})
        
    elseif card == Card.CARD_JUDGEMENT then

        local RandomJoker = mod:RandomJoker(Player:GetCardRNG(Card.CARD_JUDGEMENT), true)

        local Success = mod:AddJoker(Player, RandomJoker.Joker, RandomJoker.Edition)

        if not Success then
            return
            --Player:AnimateSad()
        end

        AnimationInterval = STANDARD_INTERVAL

    elseif card == Card.CARD_WORLD then
        
        AnimationInterval = ChangeSelectionParams(Player, {Suit = mod.Suits.Spade})
    end

    
    ::FINISH::

    mod.Saved.Player[PIndex].LastCardUsed = card

    Player:AnimateCard(card, "UseItem")

    for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = false
    end
    mod.SelectionParams[PIndex].SelectionNum = 0
    

    return AnimationInterval
end
--mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.TJimboUseTarot)

local PLANET_FULL_INTERVAL = 44
local PLANET_STEP = 12

local function TJimboUsePlanet(card, Player, UseFlags)

    local PlanetHandType = card - mod.Planets.PLUTO + 2 --gets the equivalent handtype

    mod.Saved.PlanetTypesUsed = mod.Saved.PlanetTypesUsed | (1 << PlanetHandType)

    
    mod.Saved.Player[Player:GetData().TruePlayerIndex].LastCardUsed = card

    return mod:PlanetUpgradeAnimation(PlanetHandType, 1)
end
--mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.PlanetCards)


---@param Player EntityPlayer
local function TJimboUseSpectral(card, Player, UseFlags)
    
    local PIndex = Player:GetData().TruePlayerIndex

    --[[
    if SpectralMaxSelection[card]
       and not mod.Saved.EnableHand --if selection is impossible
       and (mod.SelectionParams[PIndex].SelectionNum > SpectralMaxSelection[card] or mod.SelectionParams[PIndex].SelectionNum <= 0
            or (card == Card.CARD_DEATH and mod.SelectionParams[PIndex].SelectionNum ~= 2)) then --if the wrong number of cards is selected

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return
    end]]

    local AnimationInterval

    local CardRNG = Player:GetCardRNG(card)

    if card == mod.Spectrals.FAMILIAR then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return --if hand size can't be decreased, don't to anything
        end

        local Valid = 0
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                Valid = Valid + 1
            end
        end
        if Valid == 0 then --if no cards are valid then cancel
            return
        end
        --removes a random card from the deck
        local RandomCard
        repeat
            RandomCard = mod:GetRandom(mod.Saved.Player[PIndex].CurrentHand, CardRNG)
        until mod.Saved.Player[PIndex].FullDeck[RandomCard]

        mod:DestroyCards(Player, {RandomCard}, true, false)

        for i = 1, 3 do --adds 3 face cards
            local RandomFace = {}
            RandomFace.Value = CardRNG:RandomInt(11,13)
            RandomFace.Suit = CardRNG:RandomInt(1,4)
            repeat 
                RandomFace.Enhancement = CardRNG:RandomInt(2,9)
            until RandomFace.Enhancement ~= mod.Enhancement.STONE
            RandomFace.Seal = mod.Seals.NONE
            RandomFace.Edition = mod.Edition.BASE

            mod:AddCardToDeck(Player, RandomFace, 1, true)
        end
        Isaac.RunCallback("DECK_SHIFT", Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.GRIM then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return --if hand size can't be decreased, don't to anything
        end

        local Valid = 0
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                Valid = Valid + 1
            end
        end
        if Valid == 0 then --if no cards are valid then cancel
            return
        end

        --removes a random card from the deck
        local RandomCard
        repeat
            RandomCard = mod:GetRandom(mod.Saved.Player[PIndex].CurrentHand, CardRNG)
        until mod.Saved.Player[PIndex].FullDeck[RandomCard]    

        mod:DestroyCards(Player, {RandomCard}, true, false) 

        for i = 1, 2 do --adds 3 face cards
            local RandomAce = {}
            RandomAce.Value = 1
            RandomAce.Suit = CardRNG:RandomInt(1,4)
            repeat 
                RandomAce.Enhancement = CardRNG:RandomInt(2,9)
            until RandomAce.Enhancement ~= mod.Enhancement.STONE
            RandomAce.Seal = mod.Seals.NONE
            RandomAce.Edition = mod.Edition.BASE    

            mod:AddCardToDeck(Player, RandomAce, 1, true)
        end 
        Isaac.RunCallback("DECK_SHIFT", Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.INCANTATION then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return --if hand size can't be decreased, don't to anything
        end

        local Valid = 0
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                Valid = Valid + 1
            end
        end
        if Valid == 0 then --if no cards are valid then cancel
            return
        end

        ---removes a random card from the deck
        local RandomCard
        repeat
            RandomCard = mod:GetRandom(mod.Saved.Player[PIndex].CurrentHand, CardRNG)
        until mod.Saved.Player[PIndex].FullDeck[RandomCard]    

        mod:DestroyCards(Player, {RandomCard}, true, false)

        for i = 1, 4 do --adds 4 numbered cards
            local RandomPip = {}
            RandomPip.Value = CardRNG:RandomInt(2,10)
            RandomPip.Suit = CardRNG:RandomInt(1,4)
            repeat 
                RandomPip.Enhancement = CardRNG:RandomInt(2,9)
            until RandomPip.Enhancement ~= mod.Enhancement.STONE
            RandomPip.Seal = mod.Seals.NONE
            RandomPip.Edition = mod.Edition.BASE    

            mod:AddCardToDeck(Player, RandomPip, 1, true)
        end
        Isaac.RunCallback("DECK_SHIFT", Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.TALISMAN then
        
        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.GOLDEN
            end
        end   

        sfx:Play(mod.Sounds.SEAL)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.AURA then  

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                local EdRoll = CardRNG:RandomFloat()
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
        
    elseif card == mod.Spectrals.WRAITH then

        mod:SetMoney(0) --makes him poor 
        
        local RandomJoker = mod:RandomJoker(CardRNG, {}, true, "rare")
        local Success = mod:AddJoker(Player, RandomJoker.Joker,RandomJoker.Edition)

        if not Success then
            return
        end

        AnimationInterval = STANDARD_INTERVAL
    
    elseif card == mod.Spectrals.SIGIL then

        if not mod.Saved.EnableHand then
            return --if hand size can't be decreased, don't to anything
        end

        for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
            mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = true
        end
        mod.SelectionParams[PIndex].SelectionNum = #mod.Saved.Player[PIndex].CurrentHand

        local RandomSuit = CardRNG:RandomInt(1,4)

        AnimationInterval = ChangeSelectionParams(Player, {Suit = RandomSuit})

        Isaac.RunCallback("DECK_MODIFY", Player, 0)

    elseif card == mod.Spectrals.OUIJA then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 or not mod.Saved.EnableHand then
            return --if hand size can't be decreased, don't to anything
        end

        --every card is set to a random suit
        local RandomValue = CardRNG:RandomInt(1,13)

        for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
            mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = true
        end
        mod.SelectionParams[PIndex].SelectionNum = #mod.Saved.Player[PIndex].CurrentHand


        AnimationInterval = ChangeSelectionParams(Player, {Value = RandomValue})

        mod.Saved.Player[PIndex].OuijaUses = mod.Saved.Player[PIndex].OuijaUses + 1
        
        Isaac.RunCallback("DECK_MODIFY", Player, 0)
        --Player:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)

    elseif card == mod.Spectrals.ECTOPLASM then 
        if mod.Saved.Player[PIndex].HandSize == 1 then
            return --if hand size can't be decreased, don't to anything
        end

        local BaseJokers = {}--jokers with an edition cannot be chosen 
        for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 and Slot.Edition == mod.Edition.BASE then
                table.insert(BaseJokers, i)
            end
        end
        if not next(BaseJokers) then
            Player:AnimateSad()
            return --if no joker can be chosen then don't do anything
        end
        
        local RandomSlot = mod:GetRandom(BaseJokers, CardRNG)
        mod.Saved.Player[PIndex].Inventory[RandomSlot].Edition = mod.Edition.NEGATIVE

        --mod:AddJimboInventorySlots(Player, 1)

        mod.Saved.Player[PIndex].EctoUses = mod.Saved.Player[PIndex].EctoUses + 1 
        sfx:Play(mod.Sounds.NEGATIVE)

        AnimationInterval = STANDARD_INTERVAL
        
        Isaac.RunCallback("INVENTORY_CHANGE", Player)

    elseif card == mod.Spectrals.IMMOLATE then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return --if hand size can't be decreased, don't to anything
        end

        local RandomCards = {}
        table.move(mod.Saved.Player[PIndex].CurrentHand, 1, #mod.Saved.Player[PIndex].CurrentHand, 1, RandomCards)
        
        for i = #RandomCards - 1, 5, -1 do

            local Rcard = CardRNG:RandomInt(1,i+1)

            table.remove(RandomCards, Rcard)
        end
        
        mod:DestroyCards(Player, RandomCards, true)
        mod.Counters.SinceSelect = 0

        Player:AddCoins(20)

        mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+20$", mod.EffectType.ENTITY, Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.ANKH then
        
        local FilledSlots = {} --gets the slots filled with a joker
        for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 then
                table.insert(FilledSlots, i)
            end
        end
        if not next(FilledSlots) then

            return
        end

        local Rslot = mod:GetRandom(FilledSlots, CardRNG)
        local CopyJoker = mod.Saved.Player[PIndex].Inventory[Rslot].Joker + 0
        local CopyEdition = mod.Saved.Player[PIndex].Inventory[Rslot].Edition + 0
        local CopyProgress = mod.Saved.Player[PIndex].Inventory[Rslot].Progress

        
        for i, _ in ipairs(mod.Saved.Player[PIndex].Inventory) do

            if i ~= Rslot then

                local Joker = mod.Saved.Player[PIndex].Inventory[i].Joker + 0

                mod.Saved.Player[PIndex].Inventory[i].Joker = 0
                mod.Saved.Player[PIndex].Inventory[i].Edition = 0

                Isaac.RunCallback(mod.Callbalcks.JOKER_REMOVED, Player, Joker)
            end
        end


        local Success, JokerIndex = mod:AddJoker(Player, CopyJoker, CopyEdition, false)
        mod.Saved.Player[PIndex].Inventory[JokerIndex].Progress = CopyProgress

        AnimationInterval = STANDARD_INTERVAL
                  
        --Isaac.RunCallback("JOKER_ADDED", Player, CopyJoker, CopyEdition)
        Isaac.RunCallback("INVENTORY_CHANGE", Player)
            
    elseif card == mod.Spectrals.DEJA_VU then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.RED
            end
        end

        sfx:Play(mod.Sounds.SEAL)

        AnimationInterval = STANDARD_INTERVAL
    
    elseif card == mod.Spectrals.HEX then

        local FilledSlots = {} --gets the slot filled with a joker
        for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 then
                table.insert(FilledSlots, i)
            end
        end
        if not next(FilledSlots) then
            Player:AnimateSad()
            return
        end

        local Rslot = mod:GetRandom(FilledSlots, CardRNG)
        for i, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if i ~= Rslot then

                local Joker = mod.Saved.Player[PIndex].Inventory[i].Joker + 0

                mod.Saved.Player[PIndex].Inventory[i].Joker = 0
                mod.Saved.Player[PIndex].Inventory[i].Edition = 0

                Isaac.RunCallback(mod.Callbalcks.JOKER_REMOVED, Player, Joker)
            else
                mod.Saved.Player[PIndex].Inventory[i].Edition = mod.Edition.POLYCROME
            end
        end

        sfx:Play(mod.Sounds.POLY)

        Isaac.RunCallback("INVENTORY_CHANGE", Player)

        AnimationInterval = STANDARD_INTERVAL
        
    elseif card == mod.Spectrals.TRANCE then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.BLUE
            end
        end

        sfx:Play(mod.Sounds.SEAL)

        AnimationInterval = STANDARD_INTERVAL

 
    elseif card == mod.Spectrals.MEDIUM then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.PURPLE
            end
        end

        sfx:Play(mod.Sounds.SEAL)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.CRYPTID then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then

                local CopiedCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]]

                mod:AddCardToDeck(Player, CopiedCard, 2, true)

                break
            end
        end
        AnimationInterval = STANDARD_INTERVAL
        
    elseif card == mod.Spectrals.SOUL then

        local Legendary = mod:RandomJoker(CardRNG, {}, true, "legendary")
        
        local Success = mod:AddJoker(Player, Legendary.Joker, Legendary.Edition)
        if not Success then
            return
        end
        AnimationInterval = STANDARD_INTERVAL

    elseif card == mod.Spectrals.BLACK_HOLE then

        for _, Hand in ipairs(mod.HandTypes) do
            mod.Saved.HandsStat[Hand].Chips = mod.Saved.HandsStat[Hand].Chips + mod.HandUpgrades[Hand].Chips
            mod.Saved.HandsStat[Hand].Mult = mod.Saved.HandsStat[Hand].Mult + mod.HandUpgrades[Hand].Mult

            mod.Saved.HandLevels[Hand] = mod.Saved.HandLevels[Hand] + 1
        end

        mod.Saved.ChipsValue = "-"
        mod.Saved.MultValue = "-"

        AnimationInterval = PLANET_FULL_INTERVAL

        Isaac.CreateTimer(function ()

            mod.Saved.ChipsValue = "+"
        end, PLANET_STEP, 1, true)

        Isaac.CreateTimer(function ()

            mod.Saved.MultValue = "+"
        end, PLANET_STEP*2, 1, true)


        Isaac.CreateTimer(function ()


        end, PLANET_STEP*3, 1, true)

    end

    ::FINISH::

    --mod.Saved.Player[PIndex].LastCardUsed = card

    Player:AnimateCard(card, "UseItem")
    Game:MakeShockwave(Player.Position, 0.025, 0.025, 10)

    for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = false
    end
    mod.SelectionParams[PIndex].SelectionNum = 0


    return AnimationInterval
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.SpectralCards)



function mod:TJimboUseCard(card, Player, IsFromPack, UseFlags)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    
    local PIndex = Player:GetData().TruePlayerIndex

    UseFlags = UseFlags or 0


    local CurrentInterval

    if mod:PlayerIsAbleToUseCard(Player, card) then

        mod.AnimationIsPlaying = true

        local IsTarot = card >= Card.CARD_FOOL and card <= Card.CARD_WORLD
        local IsPlanet = card >= mod.Planets.PLUTO and card <= mod.Planets.ERIS
        local IsSpectral = card >= mod.Spectrals.FAMILIAR and card <= mod.Spectrals.SOUL


        if IsTarot then

            CurrentInterval = TJimboUseTarot(card, Player, IsFromPack, UseFlags)

        elseif IsPlanet then

            CurrentInterval = TJimboUsePlanet(card, Player, UseFlags)

        elseif IsSpectral then

            CurrentInterval = TJimboUseSpectral(card, Player, UseFlags)
        end

    else
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
    end

    if CurrentInterval then --equal to if the card got used (othetwise its false)

        sfx:Play(mod.Sounds.TAROT_USE, 1, 2, false, 0.95 + math.random()*0.1)
        
        if mod.Saved.EnableHand then

            local Purpose

            if mod.SelectionParams[PIndex].PackPurpose ~= mod.SelectionParams.Purposes.NONE then
                
                Purpose = mod.SelectionParams[PIndex].PackPurpose
            else
                Purpose = mod.SelectionParams.Purposes.HAND
            end
        
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, Purpose)

        elseif mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.NONE then

            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
        end


        Isaac.CreateTimer(function ()

            CurrentInterval = Isaac.RunCallback(mod.Callbalcks.CONSUMABLE_USE, Player, card)


            Isaac.CreateTimer(function ()
                mod.AnimationIsPlaying = false
            end, CurrentInterval, 1, true)

        end, CurrentInterval, 1, true)


    end

    return CurrentInterval -- used as true/false
end
--mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.TJimboUseCard)



---@param Player EntityPlayer
---@param card Card
local function TJimboCardPacks(_,card, Player,_)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if card >= mod.Packs.STANDARD and card <= mod.Packs.MEGA_STANDARD then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.STANDARD)
        local RandomPack = {}

        local Size = card == mod.Packs.STANDARD and 3 or 5

        mod.SelectionParams[PIndex].PackOptions = {}

        for i=1, Size do
            mod.SelectionParams[PIndex].PackOptions[i] = mod:RandomPlayingCard(PackRng, true)
        end
        

        mod.SelectionParams[PIndex].Frames = 0


        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.StandardPack)


        if card == mod.Packs.MEGA_STANDARD then
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose + mod.SelectionParams.Purposes.MegaFlag
        end

    elseif card >= mod.Packs.ARCANA and card <= mod.Packs.MEGA_ARCANA then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.ARCANA)

        local CanFindSpectral = PlayerManager.AnyoneHasCollectible(mod.Vouchers.Omen)

        local Size = card == mod.Packs.ARCANA and 3 or 5

        for _,Tarot in ipairs(mod:RandomTarot(PackRng, true, false, Size, CanFindSpectral)) do
            
            mod.SelectionParams[PIndex].PackOptions[#mod.SelectionParams[PIndex].PackOptions+1] = mod:SpecialCardToFrame(Tarot)
        end

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                        mod.SelectionParams.Purposes.TarotPack)

        if card == mod.Packs.MEGA_ARCANA then
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose + mod.SelectionParams.Purposes.MegaFlag
        end

    elseif card >= mod.Packs.CELESTIAL and card <= mod.Packs.MEGA_CELESTIAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.CELESTIAL)
        
        local Size = card == mod.Packs.CELESTIAL and 3 or 5

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Telescope) then

            Size = Size - 1 --one planet gets chosen before hand

            local MaxUses = 0
            local MostUsedHand
            
            for Hand = mod.HandTypes.HIGH_CARD, mod.HandTypes.FIVE_FLUSH do
                
                if mod.Saved.HandsTypeUsed[Hand] >= MaxUses then
                    
                    MostUsedHand = Hand
                    MaxUses = mod.Saved.HandsTypeUsed[Hand]
                end
            end

            mod.SelectionParams[PIndex].PackOptions[1] = mod.Planets.PLUTO + MostUsedHand + 1
        end



        for _,Planet in ipairs(mod:RandomPlanet(PackRng, true, false, Size)) do
            
            mod.SelectionParams[PIndex].PackOptions[#mod.SelectionParams[PIndex].PackOptions+1] = mod:SpecialCardToFrame(Planet)
        end
                
        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.CelestialPack)

        if card == mod.Packs.MEGA_CELESTIAL then
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose + mod.SelectionParams.Purposes.MegaFlag
        end
        
    elseif card >= mod.Packs.SPECTRAL and card <= mod.Packs.MEGA_SPECTRAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)
        
        local PackRng = Player:GetCardRNG(mod.Packs.SPECTRAL)
        mod.SelectionParams[PIndex].PackOptions = {}

        local Size = card == mod.Packs.SPECTRAL and 2 or 4

        for _,Specter in ipairs(mod:RandomSpectral(PackRng, true, true, false, Size)) do
            
            mod.SelectionParams[PIndex].PackOptions[#mod.SelectionParams[PIndex].PackOptions+1] = mod:SpecialCardToFrame(Specter)
        end

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.SpectralPack)
                        
        if card == mod.Packs.MEGA_SPECTRAL then
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose + mod.SelectionParams.Purposes.MegaFlag
        end

    elseif card >= mod.Packs.BUFFON and card <= mod.Packs.MEGA_BUFFON then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local Jokers = {}
        for i,v in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
            table.insert ( Jokers, v.SubType)
        end

        local PackRng = Player:GetCardRNG(mod.Packs.BUFFON)

        local Size = card == mod.Packs.BUFFON and 2 or 4

        mod.SelectionParams[PIndex].PackOptions = mod:RandomJoker(PackRng, true, false, false, Size)

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.BuffonPack)


        if card == mod.Packs.MEGA_BUFFON then
            mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams[PIndex].PackPurpose + mod.SelectionParams.Purposes.MegaFlag
        end

    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, TJimboCardPacks)
