---@diagnostic disable: inject-field
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()
local sfx = SFXManager()


local CardEditionChance = {}
CardEditionChance.Foil = 0.04
CardEditionChance.Holo = 0.068 --is actually 0.028
CardEditionChance.Poly = 0.080 --is actually 0.012
CardEditionChance.Negative = 0.003 --is actually 0.012

local MegaChance = 0.1 --0.10 originally
local JumboChance = 0.4 --0.4 originally

local SoulChance = 0.003
local HoleChance = 0.003

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

--the name is kind of misleading
local function ChangeSelectionParams(PIndex, NewParams)

    local Interval = 0
    local NumChanged = 0

    local NumSelected = mod.SelectionParams[PIndex].SelectionNum - 1


    for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
        if Selected then

            NumChanged = NumChanged + 1

            Interval = 16 * NumChanged
            local Pointer = mod.Saved.Player[PIndex].CurrentHand[i]
            local card = mod.Saved.Player[PIndex].FullDeck[Pointer]



            --flips once
            Isaac.CreateTimer(function ()

                card.Modifiers = card.Modifiers & mod.Modifier.COVERED == 0 and (card.Modifiers | mod.Modifier.COVERED) or (card.Modifiers & ~mod.Modifier.COVERED)
                
                mod.LastCardFullPoss[Pointer].Y = mod.LastCardFullPoss[Pointer] - 8
                --mod.Counters.SinceCardFlipped[Pointer] = 0

            end, Interval, 1, true)


            --while flipped (usually covered) changes the params
            Isaac.CreateTimer(function ()

                card.Value = NewParams.Value or card.Value
                card.Suit = NewParams.Suit or card.Suit
                card.Enhancement = NewParams.Enhancement or card.Enhancement
                card.Seal = NewParams.Seal or card.Seal
                card.Edition = NewParams.Edition or card.Edition
                card.Modifiers = NewParams.Modifiers or card.Modifiers
                
            end, Interval + 16 * (NumSelected - NumChanged + 1) + 1, 1, true)


            Interval = Interval + 20 + 16 * NumSelected

            Isaac.CreateTimer(function ()

                card.Modifiers = card.Modifiers & mod.Modifier.COVERED == 0 and (card.Modifiers | mod.Modifier.COVERED) or (card.Modifiers & ~mod.Modifier.COVERED)

            end, Interval, 1, true)

        end
    end

    return Interval
end




--every tarot has a new effect when used by jimbo
---@param Player EntityPlayer
---@param card Card
local function TJimboUseTarot(card, Player, IsPack, UseFlags)

    local PIndex = Player:GetData().TruePlayerIndex
    
    ---local IsTarot = card >= Card.CARD_FOOL and card <= Card.CARD_WORLD

    local SelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]

    local AnimationInterval

    if TarotMaxSelection[card]
       and (not mod.Saved.EnableHand --is selection is impossible
       or (mod.SelectionParams[PIndex].SelectionNum > TarotMaxSelection[card] or mod.SelectionParams[PIndex].SelectionNum <= 0
            or (card == Card.CARD_DEATH and mod.SelectionParams[PIndex].SelectionNum ~= 2))) then --if the wrong number of cards is selected

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return
    end

    local FreeSpaces = 0

    if card == Card.CARD_HIGH_PRIESTESS or card == Card.CARD_EMPEROR or card == Card.CARD_FOOL then
        
        for _, slot in ipairs(mod.Saved.Player[PIndex].Consumables) do 
            if slot.Card == -1 then
                FreeSpaces = FreeSpaces + 1
            end
        end
    end

    if card == Card.CARD_FOOL then


        if mod.Saved.Player[PIndex].LastCardUsed then

            local Success mod:TJimboAddConsumable(Player, mod.Saved.Player[PIndex].LastCardUsed)

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
        
        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.LUCKY})
        
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

        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.MULT})
    
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

        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.BONUS})

    elseif card == Card.CARD_LOVERS then

        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.WILD})
    
    elseif card == Card.CARD_CHARIOT then

        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.STEEL})

    elseif card == Card.CARD_JUSTICE then

        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.GLASS})

    elseif card == Card.CARD_HERMIT then
        local CoinsToAdd =  mod.Saved.HasDebt and 0 or math.min(Player:GetNumCoins(), 20)
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
            if CardRNG:RandomFloat() < 0.25 and BaseJokers ~= {} then 
            
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
                mod:CreateBalatroEffect(Player, mod.EffectColors.PURPLE, mod.Sounds.ACTIVATE, "Nope!", mod.EffectType.ENTITY, Player)--PLACEHOLDER
            end
        end, 24, 1, true)

        AnimationInterval = 28


    elseif card == Card.CARD_STRENGTH then

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

        AnimationInterval = ChangeSelectionParams(PIndex, SecondCard)

    elseif card == Card.CARD_TEMPERANCE then

        local CoinsToGain = 0

        for i ,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 then
                CoinsToGain = CoinsToGain + mod:GetJokerCost(Slot.Joker, i, Player)
            end
        end
        Player:AddCoins(CoinsToGain)

        mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToGain).."$", mod.EffectType.ENTITY, Player)

        AnimationInterval = STANDARD_INTERVAL

    elseif card == Card.CARD_DEVIL then

        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.GOLDEN})

    elseif card == Card.CARD_TOWER then


        AnimationInterval = ChangeSelectionParams(PIndex, {Enhancement = mod.Enhancement.STONE})
        

    elseif card == Card.CARD_STARS then

        AnimationInterval = ChangeSelectionParams(PIndex, {Suit = mod.Suits.Diamond})

    elseif card == Card.CARD_MOON then
        
        AnimationInterval = ChangeSelectionParams(PIndex, {Suit = mod.Suits.Club})
        
    elseif card == Card.CARD_SUN then
        
        AnimationInterval = ChangeSelectionParams(PIndex, {Suit = mod.Suits.Heart})
        
    elseif card == Card.CARD_JUDGEMENT then

        local RandomJoker = mod:RandomJoker(Player:GetCardRNG(Card.CARD_JUDGEMENT), {}, true)

        local Success = mod:AddJoker(Player, RandomJoker.Joker, RandomJoker.Edition)

        if not Success then
            return
            --Player:AnimateSad()
        end

        AnimationInterval = STANDARD_INTERVAL

    elseif card == Card.CARD_WORLD then
        
        AnimationInterval = ChangeSelectionParams(PIndex, {Suit = mod.Suits.Spade})
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

    local PIndex = Player:GetData().TruePlayerIndex
    local PlanetHandType = card - mod.Planets.PLUTO + 2 --gets the equivalent handtype

    local AnimationInterval = PLANET_FULL_INTERVAL

    mod.Saved.PlanetTypesUsed = mod.Saved.PlanetTypesUsed | (1 << PlanetHandType)


    Isaac.CreateTimer(function ()
        mod.Saved.Player[PIndex].HandsStat[PlanetHandType].Chips = mod.Saved.Player[PIndex].HandsStat[PlanetHandType].Chips + mod.HandUpgrades[PlanetHandType].Chips
    end, PLANET_STEP, 1, true)

    Isaac.CreateTimer(function ()
        mod.Saved.Player[PIndex].HandsStat[PlanetHandType].Mult = mod.Saved.Player[PIndex].HandsStat[PlanetHandType].Mult + mod.HandUpgrades[PlanetHandType].Mult
    end, PLANET_STEP*2, 1, true)

    Isaac.CreateTimer(function ()
        mod.Saved.Player[PIndex].HandLevels[PlanetHandType] = mod.Saved.Player[PIndex].HandLevels[PlanetHandType] + 1
    end, PLANET_STEP*3, 1, true)


    if PlanetHandType == mod.HandTypes.STRAIGHT_FLUSH then

        --upgrades both royal flush and straight flush

        mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.ROYAL_FLUSH] = mod.Saved.Player[PIndex].HandLevels[mod.HandTypes.ROYAL_FLUSH] + 1
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.ROYAL_FLUSH].Mult = mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.ROYAL_FLUSH].Mult + mod.HandUpgrades[mod.HandTypes.ROYAL_FLUSH].Mult
        mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.ROYAL_FLUSH].Chips = mod.Saved.Player[PIndex].HandsStat[mod.HandTypes.ROYAL_FLUSH].Chips + mod.HandUpgrades[mod.HandTypes.ROYAL_FLUSH].Chips
    end

    return AnimationInterval
end
--mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.PlanetCards)


---@param Player EntityPlayer
local function TJimboUseSpectral(card, Player, UseFlags)
    
    local PIndex = Player:GetData().TruePlayerIndex

    if SpectralMaxSelection[card]
       and not mod.Saved.EnableHand --if selection is impossible
       and (mod.SelectionParams[PIndex].SelectionNum > SpectralMaxSelection[card] or mod.SelectionParams[PIndex].SelectionNum <= 0
            or (card == Card.CARD_DEATH and mod.SelectionParams[PIndex].SelectionNum ~= 2)) then --if the wrong number of cards is selected

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return
    end

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

        AnimationInterval = STANDARD_INTERVAL
        
    elseif card == mod.Spectrals.WRAITH then

        mod.Saved.Other.HasDebt = false
        Player:AddCoins(-Player:GetNumCoins()) --makes him poor 
        
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

        AnimationInterval = ChangeSelectionParams(PIndex, {Suit = RandomSuit})

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


        AnimationInterval = ChangeSelectionParams(PIndex, {Value = RandomValue})

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

        mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW, 
                                    mod.Sounds.MONEY, "+20$",mod.Spectrals.IMMOLATE, mod.EffectType.ENTITY, Player)

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
        local CopyProgress = mod.Saved.Player[PIndex].Progress.Inventory[Rslot]

        
        for i, _ in ipairs(mod.Saved.Player[PIndex].Inventory) do
            mod.Saved.Player[PIndex].Inventory[i].Joker = 0
            mod.Saved.Player[PIndex].Inventory[i].Edition = 0
        end

        for i=1,2 do

            mod:AddJoker(Player, CopyJoker, CopyEdition, false)
            mod.Saved.Player[PIndex].Progress.Inventory[i] = CopyProgress
        end

        AnimationInterval = STANDARD_INTERVAL
                  
        --Isaac.RunCallback("JOKER_ADDED", Player, CopyJoker, CopyEdition)
        --Isaac.RunCallback("INVENTORY_CHANGE", Player)
            
    elseif card == mod.Spectrals.DEJA_VU then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.RED
            end
        end

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
                mod.Saved.Player[PIndex].Inventory[i].Joker = 0
                mod.Saved.Player[PIndex].Inventory[i].Edition = 0
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
        AnimationInterval = STANDARD_INTERVAL

 
    elseif card == mod.Spectrals.MEDIUM then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.PURPLE
            end
        end
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
            mod.Saved.Player[PIndex].HandsStat[Hand].Chips = mod.Saved.Player[PIndex].HandsStat[Hand].Chips + mod.HandUpgrades[Hand].Chips
            mod.Saved.Player[PIndex].HandsStat[Hand].Mult = mod.Saved.Player[PIndex].HandsStat[Hand].Mult + mod.HandUpgrades[Hand].Mult

            mod.Saved.Player[PIndex].HandLevels[Hand] = mod.Saved.Player[PIndex].HandLevels[Hand] + 1
        end

        mod.Saved.Player[PIndex].ChipsValue = "-"
        mod.Saved.Player[PIndex].MultValue = "-"

        AnimationInterval = PLANET_FULL_INTERVAL

        Isaac.CreateTimer(function ()

            mod.Saved.Player[PIndex].ChipsValue = "+"
        end, PLANET_STEP, 1, true)

        Isaac.CreateTimer(function ()

            mod.Saved.Player[PIndex].MultValue = "+"
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



function mod:TJimboUseCard(card, Player, IsPack, UseFlags)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    mod.AnimationIsPlaying = true
    local PIndex = Player:GetData().TruePlayerIndex

    UseFlags = UseFlags or 0

    local IsTarot = card >= Card.CARD_FOOL and card <= Card.CARD_WORLD
    local IsPlanet = card >= mod.Planets.PLUTO and card <= mod.Planets.ERIS
    local IsSpectral = card >= mod.Spectrals.FAMILIAR and card <= mod.Spectrals.SOUL

    local RemoveBeforeUse = card == Card.CARD_EMPEROR or card == Card.CARD_HIGH_PRIESTESS

    if not IsPack and RemoveBeforeUse then
        local NumConsumables = #mod.Saved.Player[PIndex].Consumables
        
        --removes the card that just got used
        mod.Saved.Player[PIndex].Consumables[NumConsumables].Card = -1
        mod.Saved.Player[PIndex].Consumables[NumConsumables].Edition = mod.Edition.BASE

        table.remove(mod.Saved.Player[PIndex].Consumables, NumConsumables)
        table.insert(mod.Saved.Player[PIndex].Consumables, 1, {Card = -1, Edition = mod.Edition.BASE})

    end

    local CurrentInterval
    if IsTarot then
        
        CurrentInterval = TJimboUseTarot(card, Player, IsPack, UseFlags)

    elseif IsPlanet then
        
        CurrentInterval = TJimboUsePlanet(card, Player, UseFlags)

    elseif IsSpectral then
        
        CurrentInterval = TJimboUseSpectral(card, Player, UseFlags)
    end

    if CurrentInterval then


        if not IsPack and not RemoveBeforeUse then
            local NumConsumables = #mod.Saved.Player[PIndex].Consumables
            
            --removes the card that just got used
            mod.Saved.Player[PIndex].Consumables[NumConsumables].Card = -1
            mod.Saved.Player[PIndex].Consumables[NumConsumables].Edition = mod.Edition.BASE

            table.remove(mod.Saved.Player[PIndex].Consumables, NumConsumables)
            table.insert(mod.Saved.Player[PIndex].Consumables, 1, {Card = -1, Edition = mod.Edition.BASE})

        end


        Isaac.CreateTimer(function ()

            CurrentInterval = Isaac.RunCallback(mod.Callbalcks.CONSUMABLE_USE, Player, card)

            Isaac.CreateTimer(function ()
                mod.AnimationIsPlaying = false
            end, CurrentInterval, 1, true)

        end, CurrentInterval, 1, true)

    else
        mod.AnimationIsPlaying = false
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

    if card == mod.Packs.STANDARD then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.STANDARD)
        local RandomPack = {}

        local Size = (Player:HasCollectible(mod.Vouchers.Crystal) and 4) or 3

        for i=1, Size do
            local RandomCard = {}
            RandomCard.Suit = PackRng:RandomInt(1, 4)
            RandomCard.Value = PackRng:RandomInt(1,13)
            RandomCard.Upgrades = 0
            RandomCard.Modifiers = 0

            if PackRng:RandomFloat() < 0.4 then
                RandomCard.Enhancement = PackRng:RandomInt(2,9) 
            else
                RandomCard.Enhancement = mod.Enhancement.NONE --no :(
            end

            if PackRng:RandomFloat() < 0.2 then
                RandomCard.Seal = PackRng:RandomInt(1,4)
                sfx:Play(mod.Sounds.SEAL)
            else
                RandomCard.Seal = mod.Seals.NONE --no :(
            end

            local EdRoll = PackRng:RandomFloat()
            if EdRoll <= CardEditionChance.Foil then
                RandomCard.Edition = mod.Edition.FOIL
                sfx:Play(mod.Sounds.FOIL)
            elseif EdRoll <= CardEditionChance.Holo then
                RandomCard.Edition = mod.Edition.HOLOGRAPHIC
                sfx:Play(mod.Sounds.HOLO)
            elseif EdRoll <= CardEditionChance.Poly then
                RandomCard.Edition = mod.Edition.POLYCROME
                sfx:Play(mod.Sounds.POLY)
            else
                RandomCard.Edition = mod.Edition.BASE --no :(
            end

            RandomPack[i] = RandomCard
        end
        mod.SelectionParams[PIndex].PackOptions = RandomPack

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.StandardPack)

    elseif card == mod.Packs.ARCANA then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.ARCANA)

        mod.SelectionParams[PIndex].PackOptions = mod:SpecialCardToFrame(mod:RandomTarot(PackRng, true, false, 3))

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
        mod.SelectionParams.Purposes.TarotPack)

    elseif card == mod.Packs.CELESTIAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.CELESTIAL)
        --mod.SelectionParams[PIndex].PackOptions = {}
        
        mod.SelectionParams[PIndex].PackOptions = mod:SpecialCardToFrame(mod:RandomPlanet(PackRng, true, false, 3))
        
        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.CelestialPack)
        
    elseif card == mod.Packs.SPECTRAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)
        
        local PackRng = Player:GetCardRNG(mod.Packs.SPECTRAL)
        mod.SelectionParams[PIndex].PackOptions = {}

        local Size =  2

        mod.SelectionParams[PIndex].PackOptions = mod:SpecialCardToFrame(mod:RandomSpectral(PackRng, true, true, false, Size))


        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.SpectralPack)

    elseif card == mod.Packs.BUFFON then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local Jokers = {}
        for i,v in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
            table.insert ( Jokers, v.SubType)
        end

        local PackRng = Player:GetCardRNG(mod.Packs.BUFFON)

        local Size = 2

        mod.SelectionParams[PIndex].PackOptions = mod:RandomJoker(PackRng, true, false, false, Size)

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.BuffonPack)

    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, TJimboCardPacks)
