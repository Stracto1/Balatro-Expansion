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




--every tarot has a new effect when used by jimbo
---@param Player EntityPlayer
---@param card Card
local function TJimboUseTarot(card, Player, IsPack, UseFlags)

    local PIndex = Player:GetData().TruePlayerIndex
    
    ---local IsTarot = card >= Card.CARD_FOOL and card <= Card.CARD_WORLD

    local RandomSeed = math.max(Random(),1)
    local SelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]

    if TarotMaxSelection[card]
       and (not mod.Saved.EnableHand --is selection is impossible
       or (mod.SelectionParams[PIndex].SelectionNum > TarotMaxSelection[card] or mod.SelectionParams[PIndex].SelectionNum <= 0
            or (card == Card.CARD_DEATH and mod.SelectionParams[PIndex].SelectionNum ~= 2))) then --if the wrong number of cards is selected

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return false
    end

    local FreeSpaces = 0

    if not IsPack then
        local NumConsumables = #mod.Saved.Player[PIndex].Consumables
        
        --removes the card that just got used
        mod.Saved.Player[PIndex].Consumables[NumConsumables].Card = -1
        mod.Saved.Player[PIndex].Consumables[NumConsumables].Edition = mod.Edition.BASE

        table.insert(mod.Saved.Player[PIndex].Consumables, 1, mod.Saved.Player[PIndex].Consumables[NumConsumables])
        table.remove(mod.Saved.Player[PIndex].Consumables, NumConsumables + 1)
        
    end
    if card == Card.CARD_HIGH_PRIESTESS or card == Card.CARD_EMPEROR or card == Card.CARD_FOOL then
        
        for _, slot in ipairs(mod.Saved.Player[PIndex].Consumables) do 
            if slot.Card == -1 then
                FreeSpaces = FreeSpaces + 1
            end
        end
    end

    if card == Card.CARD_FOOL then


        if mod.Saved.Player[PIndex].LastCardUsed then

            if FreeSpaces == 0 then
                return false
            end

            mod:TJimboAddConsumable(Player, mod.Saved.Player[PIndex].LastCardUsed)
            goto FINISH
        else
            return false
        end
    end
    
    

    if card == Card.CARD_MAGICIAN then
        
        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.LUCKY
            end
        end
        
    elseif card == Card.CARD_HIGH_PRIESTESS then


        if FreeSpaces == 0 then
            return false
        end

        local CardRNG = Player:GetCardRNG(card)
        for i=0, FreeSpaces-1 do
            local Rplanet = CardRNG:RandomInt(mod.Planets.PLUTO, mod.Planets.ERIS)

            mod:TJimboAddConsumable(Player, Rplanet, 0, true)
            Isaac.CreateTimer(function ()
                Player:AnimateCard(Rplanet)
            end, 0 + i*15,1,true)
        end
        
    
    elseif card == Card.CARD_EMPRESS then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.MULT
            end
        end
    
    elseif card == Card.CARD_EMPEROR then

        if FreeSpaces == 0 then
            return false
        end

        local RandomTarots = {}
        local CardRNG = Player:GetCardRNG(card)
        for i=1, FreeSpaces do
            local Tarot
            repeat 
                Tarot = CardRNG:RandomInt(1,22)
            until Tarot ~= Card.CARD_EMPEROR and
                  (not mod:Contained(RandomTarots, Tarot) or mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN))

            RandomTarots[i] = Tarot

            mod:TJimboAddConsumable(Player, Tarot, 0, true)
            Isaac.CreateTimer(function ()
                Player:AnimateCard(Tarot)
            end, 0 + (i-1)*15,1,true)

        end
        

    elseif card == Card.CARD_HIEROPHANT then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.BONUS
            end
        end

    elseif card == Card.CARD_LOVERS then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.WILD
            end
        end
    
    elseif card == Card.CARD_CHARIOT then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.STEEL
            end
        end

    elseif card == Card.CARD_JUSTICE then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.GLASS
            end
        end

    elseif card == Card.CARD_HERMIT then
        local CoinsToAdd =  mod.Saved.HasDebt and 0 or math.min(Player:GetNumCoins(), 20)
         --no more then 20 coins

        Player:AddCoins(CoinsToAdd)

        mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToAdd).."$")

    elseif card == Card.CARD_WHEEL_OF_FORTUNE then

        local CardRNG = Player:GetCardRNG(card)

        local BaseJokers = {}
        for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Edition == mod.Edition.BASE and mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                table.insert(BaseJokers, i)
            end
        end

        if not next(BaseJokers) then
            
            return false
        end

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
            mod:CreateBalatroEffect(Player, mod.EffectColors.PURPLE, mod.Sounds.ACTIVATE, "Nope!")--PLACEHOLDER
        end


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

        for k,v in pairs(SecondCard) do
            
            mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[FirstIndex]][k] = v
        end        

    elseif card == Card.CARD_TEMPERANCE then

        local CoinsToGain = 0

        for i ,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 then
                CoinsToGain = CoinsToGain + mod:GetJokerCost(Slot.Joker, i, Player)
            end
        end
        Player:AddCoins(CoinsToGain)

        mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToGain).."$")


    elseif card == Card.CARD_DEVIL then

        

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.GOLDEN
            end
        end

    elseif card == Card.CARD_TOWER then

        

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Enhancement = mod.Enhancement.STONE
            end
        end
        

    elseif card == Card.CARD_STARS then

        

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Suit = mod.Suits.Diamond
            end
        end

    elseif card == Card.CARD_MOON then
        

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Suit = mod.Suits.Club
            end
        end
        
    elseif card == Card.CARD_SUN then
        

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Suit = mod.Suits.Heart
            end
        end
        
    elseif card == Card.CARD_JUDGEMENT then

        --[[
        local EmptySlot
        for i, Joker in ipairs(mod.Saved.Player[PIndex].Inventory.Jokers) do
            if Joker == 0 then --needs an empty slot
                EmptySlot = i
                break
            end
        end

        if EmptySlot then
            
            local RandomJoker = mod:RandomJoker(Player:GetCardRNG(Card.CARD_JUDGEMENT), {}, true)
            mod.Saved.Player[PIndex].Inventory.Jokers[EmptySlot] = RandomJoker.Joker
            mod.Saved.Player[PIndex].Inventory.Editions[EmptySlot] = RandomJoker.Edition

            mod.Saved.Player[PIndex].Progress.Inventory[EmptySlot] = tonumber(ItemsConfig:GetTrinket(RandomJoker.Joker):GetCustomTags()[2]) --sets the base progress
            
            Isaac.RunCallback("INVENTORY_CHANGE", Player)
        else
            Player:AnimateSad()
        end]]

        local RandomJoker = mod:RandomJoker(Player:GetCardRNG(Card.CARD_JUDGEMENT), {}, true)

        local Success = mod:AddJoker(Player, RandomJoker.Joker, RandomJoker.Edition)

        if not Success then
            Player:AnimateSad()
        end


    elseif card == Card.CARD_WORLD then
        

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Suit = mod.Suits.Spade
            end
        end
        

    end

    
    ::FINISH::

    mod.Saved.Player[PIndex].LastCardUsed = card

    Player:AnimateCard(card, "UseItem")

    for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = false
    end
    mod.SelectionParams[PIndex].SelectionNum = 0
    

    return true
end
--mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.TJimboUseTarot)


local function TJimboUsePlanet(card, Player, UseFlags)

    local PIndex = Player:GetData().TruePlayerIndex
    local PlanetHandType = 1 << (card - mod.Planets.PLUTO + 1) --gets the equivalent handtype

    mod.Saved.PlanetTypesUsed = mod.Saved.PlanetTypesUsed | PlanetHandType

    mod.Saved.Player[PIndex].HandLevels[PlanetHandType] = mod.Saved.Player[PIndex].HandLevels[PlanetHandType] + 1
    mod.Saved.Player[PIndex].HandsStat[PlanetHandType] = mod.Saved.Player[PIndex].HandsStat[PlanetHandType] + mod.HandUpgrades[PlanetHandType]
    
    if PlanetHandType == mod.HandTypes.STRAIGHT_FLUSH then
        PlanetHandType = mod.HandTypes.ROYAL_FLUSH --upgrades both royal flush and straight flush
        mod.Saved.Player[PIndex].HandLevels[PlanetHandType] = mod.Saved.Player[PIndex].HandLevels[PlanetHandType] + 1
        mod.Saved.Player[PIndex].HandsStat[PlanetHandType] = mod.Saved.Player[PIndex].HandsStat[PlanetHandType] + mod.HandUpgrades[PlanetHandType]
    end

    return true
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
        return false
    end


    local CardRNG = Player:GetCardRNG(card)

    if card == mod.Spectrals.FAMILIAR then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        local Valid = 0
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                Valid = Valid + 1
            end
        end
        if Valid == 0 then --if no cards are valid then cancel
            return false
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


    elseif card == mod.Spectrals.GRIM then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        local Valid = 0
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                Valid = Valid + 1
            end
        end
        if Valid == 0 then --if no cards are valid then cancel
            return false
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

    elseif card == mod.Spectrals.INCANTATION then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        local Valid = 0
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                Valid = Valid + 1
            end
        end
        if Valid == 0 then --if no cards are valid then cancel
            return false
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

    elseif card == mod.Spectrals.TALISMAN then
        
        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.GOLDEN
            end
        end
        
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

        mod.Saved.Other.HasDebt = false
        Player:AddCoins(-Player:GetNumCoins()) --makes him poor 
        
        --[[
        local RandomJoker = mod:RandomJoker(CardRNG, {}, true, "rare")

        for i, Joker in ipairs(mod.Saved.Player[PIndex].Inventory.Jokers) do
            if Joker == 0 then --the first empty slot
                mod.Saved.Player[PIndex].Inventory.Jokers[i] = RandomJoker
                mod.Saved.Player[PIndex].Inventory.Editions[i] = mod.Edition.BASE
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
                return
            end
        end
        Player:AnimateSad() --no joker for you if no slot is empty :(   ]]

        local RandomJoker = mod:RandomJoker(CardRNG, {}, true, "rare")
        local Success = mod:AddJoker(Player, RandomJoker.Joker,RandomJoker.Edition)

        if not Success then
            return false
        end
    
    elseif card == mod.Spectrals.SIGIL then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        local RandomSuit = CardRNG:RandomInt(1,4)
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                mod.Saved.Player[PIndex].FullDeck[v].Suit = RandomSuit
            end
        end
        Isaac.RunCallback("DECK_MODIFY", Player, 0)

    elseif card == mod.Spectrals.OUIJA then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        --every card is set to a random suit
        local RandomValue = CardRNG:RandomInt(1,13)
        for i,v in ipairs(mod.Saved.Player[PIndex].CurrentHand) do
            if mod.Saved.Player[PIndex].FullDeck[v] then
                mod.Saved.Player[PIndex].FullDeck[v].Value = RandomValue
            end
        end

        mod.Saved.Player[PIndex].OuijaUses = mod.Saved.Player[PIndex].OuijaUses + 1
        
        Isaac.RunCallback("DECK_MODIFY", Player, 0)
        Player:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)

    elseif card == mod.Spectrals.ECTOPLASM then 
        if mod.Saved.Player[PIndex].HandSize == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        mod.Saved.Player[PIndex].EctoUses = mod.Saved.Player[PIndex].EctoUses + 1 


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
        --adds a slot since he got a negative joker
        --mod:AddJimboInventorySlots(Player, 1)

        --mod:ChangeJimboHandSize(Player, -mod.Saved.Player[PIndex].EctoUses)
        --mod:ChangeJimboHandSize(Player, -1)

        sfx:Play(mod.Sounds.NEGATIVE)
        
        Isaac.RunCallback("INVENTORY_CHANGE", Player)

    elseif card == mod.Spectrals.IMMOLATE then

        if Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE) == 1 then
            return false --if hand size can't be decreased, don't to anything
        end

        local RandomCards = {}
        table.move(mod.Saved.Player[PIndex].CurrentHand, 1, #mod.Saved.Player[PIndex].CurrentHand, 1, RandomCards)
        
        for i = #RandomCards - 1, 5, -1 do

            local Rcard = CardRNG:RandomInt(1,i+1)

            table.remove(RandomCards, Rcard)

        end
        
        mod:DestroyCards(Player, RandomCards, true)

        Player:AddCoins(20)

        mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW, 
                                    mod.Sounds.MONEY, "+20$",mod.Spectrals.IMMOLATE)

    elseif card == mod.Spectrals.ANKH then
        
        local FilledSlots = {} --gets the slots filled with a joker
        for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
            if Slot.Joker ~= 0 then
                table.insert(FilledSlots, i)
            end
        end
        if not next(FilledSlots) then

            return false
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
                  
        --Isaac.RunCallback("JOKER_ADDED", Player, CopyJoker, CopyEdition)
        --Isaac.RunCallback("INVENTORY_CHANGE", Player)
            
    elseif card == mod.Spectrals.DEJA_VU then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.RED
            end
        end
    
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
        
    elseif card == mod.Spectrals.TRANCE then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.BLUE
            end
        end
 
    elseif card == mod.Spectrals.MEDIUM then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then
                mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]].Seal = mod.Seals.PURPLE
            end
        end


    elseif card == mod.Spectrals.CRYPTID then

        for i, Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            
            if Selected then

                local CopiedCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[i]]

                mod:AddCardToDeck(Player, CopiedCard, 2, true)

                break
            end
        end
        
    elseif card == mod.Spectrals.SOUL then

        local Legendary = mod:RandomJoker(CardRNG, {}, true, "legendary")
        
        local Success = mod:AddJoker(Player, Legendary.Joker, Legendary.Edition)
        if not Success then
            return false
        end

    elseif card == mod.Spectrals.BLACK_HOLE then
        for i = 1, 13 do
            mod.Saved.CardLevels[i] = mod.Saved.CardLevels[i] + 1
        end

    end

    ::FINISH::

    --mod.Saved.Player[PIndex].LastCardUsed = card

    Player:AnimateCard(card, "UseItem")
    Game:MakeShockwave(Player.Position, 0.025, 0.025, 10)

    for i,_ in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = false
    end
    mod.SelectionParams[PIndex].SelectionNum = 0


    return true
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.SpectralCards)



function mod:TJimboUseCard(card, Player, IsPack, UseFlags)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return false
    end

    local PIndex = Player:GetData().TruePlayerIndex

    UseFlags = UseFlags or 0

    local IsTarot = card >= Card.CARD_FOOL and card <= Card.CARD_WORLD
    local IsPlanet = card >= mod.Planets.PLUTO and card <= mod.Planets.ERIS
    local IsSpectral = card >= mod.Spectrals.FAMILIAR and card <= mod.Spectrals.SOUL

    local Success
    if IsTarot then
        
        Success = TJimboUseTarot(card, Player, IsPack, UseFlags)

    elseif IsPlanet then
        
        Success = TJimboUsePlanet(card, Player, UseFlags)

    elseif IsSpectral then
        
        Success = TJimboUseSpectral(card, Player, UseFlags)
    end

    return Success

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

        local RandomPack = {}
        local Options = {}
        for i=1,22 do --adds every tarot card to the pool
            Options[#Options + 1] = i
        end
        if Player:HasCollectible(mod.Vouchers.Omen) then --adds the spectral cards to the possible outcomes
            for i= mod.Spectrals.FAMILIAR, mod.Spectrals.CRYPTID do
                Options[#Options + 1] = i
            end
        end

        local Size = Player:HasCollectible(mod.Vouchers.Crystal) and 4 or 3 --very cool lua thingy

        local EditionRoll = Player:HasCollectible(mod.Vouchers.Illusion) and PackRng:RandomFloat() or 2
        if EditionRoll <= JumboChance then
            Size = Size + 2
        end

        for i=1, Size, 1 do
            local RandomCard
            repeat
                if PackRng:RandomFloat() < SoulChance then
                    RandomCard = mod.Spectrals.SOUL
                else
                    RandomCard = mod:GetRandom(Options, PackRng) --chooses a random not reversed tarot (i'll prob regret using this)
                end
                RandomCard = mod:SpecialCardToFrame(RandomCard)
                
            until not mod:Contained(RandomPack, RandomCard)
            
            table.insert(RandomPack, RandomCard)
        end
        
        mod.SelectionParams[PIndex].PackOptions = RandomPack

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
        mod.SelectionParams.Purposes.TarotPack)

    elseif card == mod.Packs.CELESTIAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.CELESTIAL)
        local RandomPack = {}
        
        for i=1, 3, 1 do
            local Rplanet
            repeat  --certain hand types should remain hidden until used one time
                local IsPlanetUnlocked = true
                if PackRng:RandomFloat() < HoleChance then
                    Rplanet = mod.Spectrals.BLACK_HOLE
                else
                    Rplanet = PackRng:RandomInt(mod.Planets.PLUTO,mod.Planets.ERIS) --chooses a random planet

                    if Rplanet == mod.Planets.PLANET_X then
                        if not mod.Saved.Player[PIndex].FiveUnlocked then
                            IsPlanetUnlocked = false
                        end
                    elseif Rplanet == mod.Planets.CERES then
                        if not mod.Saved.Player[PIndex].FlushHouseUnlocked then
                            IsPlanetUnlocked = false
                        end
                    elseif Rplanet == mod.Planets.ERIS then
                        if not mod.Saved.Player[PIndex].FiveFlushUnlocked then
                            IsPlanetUnlocked = false
                        end
                    end
                end
                Rplanet = mod:SpecialCardToFrame(Rplanet)

            until IsPlanetUnlocked and not mod:Contained(RandomPack, Rplanet)

            RandomPack[i] = Rplanet
        end            
        
        mod.SelectionParams[PIndex].PackOptions = RandomPack
        mod.SelectionParams[PIndex].Frames = 0

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.CelestialPack)
        
    elseif card == mod.Packs.SPECTRAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)
        
        local PackRng = Player:GetCardRNG(mod.Packs.SPECTRAL)
        local RandomPack = {}

        local Size = (Player:HasCollectible(mod.Vouchers.Crystal) and 3) or 2

        local EditionRoll = Player:HasCollectible(mod.Vouchers.Illusion) and PackRng:RandomFloat() or 2
        if EditionRoll <= JumboChance then
            Size = Size + 2
        end

        for i=1, Size do
            local RSpectral
            repeat
                local SuperRoll = PackRng:RandomFloat()
                if SuperRoll <= SoulChance then
                    RSpectral = mod.Spectrals.SOUL
                elseif SuperRoll <= SoulChance + HoleChance then
                    RSpectral = mod.Spectrals.BLACK_HOLE
                else
                    RSpectral = PackRng:RandomInt(mod.Spectrals.FAMILIAR,mod.Spectrals.CRYPTID) --chooses a random spectral card
                end
                RSpectral = mod:SpecialCardToFrame(RSpectral)

            until not mod:Contained(RandomPack, RSpectral)

            table.insert(RandomPack, RSpectral)
        end
        mod.SelectionParams[PIndex].PackOptions = RandomPack

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.SpectralPack)

    elseif card == mod.Packs.BUFFON then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local RandomPack = {}
        local Jokers = {}
        for i,v in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
            table.insert ( Jokers, v.SubType)
        end

        local PackRng = Player:GetCardRNG(mod.Packs.BUFFON)

        local Size = (Player:HasCollectible(mod.Vouchers.Crystal) and 3) or 2

        local EditionRoll = Player:HasCollectible(mod.Vouchers.Illusion) and PackRng:RandomFloat() or 2
        if EditionRoll <= JumboChance then
            Size = Size + 2
        end

        for i=1, Size, 1 do
            RandomPack[i] = mod:RandomJoker(PackRng, Jokers, true)
            table.insert(Jokers, RandomPack[i].Joker)
        end

        mod.SelectionParams[PIndex].PackOptions = RandomPack

        mod.SelectionParams[PIndex].Frames = 0
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.BuffonPack)

    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, TJimboCardPacks)
