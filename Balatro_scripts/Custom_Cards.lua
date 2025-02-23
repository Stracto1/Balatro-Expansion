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

local JokerEdChance = {}
JokerEdChance.Negative = 0.003 
JokerEdChance.Foil = 0.02  --is actually 0.012
JokerEdChance.Holo = 0.034 --is actually 0.028
JokerEdChance.Poly = 0.037 --is actually 0.012

local SoulChance = 0.003
local HoleChance = 0.003

--every tarot has a new effect when used by jimbo
---@param Player EntityPlayer
---@param card Card
function mod:NewTarotEffects(card, Player, UseFlags)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local PIndex = Player:GetPlayerIndex()
        local RandomSeed = Random()
        if RandomSeed==0 then RandomSeed=1 end

        if card == Card.CARD_FOOL then
            if mod.Saved.Jimbo.LastUsed[PIndex] then

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, mod.Saved.Jimbo.LastUsed[PIndex], RandomSeed)
            else
                Player:AnimateSad()
            end
            return false
        elseif card == Card.CARD_MAGICIAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.MAGICIAN)
            
            return false
        elseif card == Card.CARD_HIGH_PRIESTESS then

            local CardRNG = Player:GetCardRNG(card)
            for i=1, 2 do
                local Rplanet
                if Player:GetPlayerType() == mod.Characters.JimboType then
                    Rplanet = CardRNG:RandomInt(mod.Planets.PLUTO, mod.Planets.SUN)
                elseif false then
                    Rplanet = CardRNG:RandomInt(mod.Planets.PLUTO, mod.Planets.ERIS)
                end

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                               RandomVector()*2, nil, Rplanet, RandomSeed)
            end
            
            return false
        
        elseif card == Card.CARD_EMPRESS then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.EMPRESS)
            
            return false
        
        elseif card == Card.CARD_EMPEROR then
            local RandomTarots = {}
            local CardRNG = Player:GetCardRNG(card)
            for i=1, 2 do
                repeat 
                    RandomTarots[i] = CardRNG:RandomInt(1,22)
                until RandomTarots[i] ~= Card.CARD_EMPEROR --or mod:JimboHasTrinket(Player, TrinketType.TRINKET_SHOWMAN)
            end
            for _,Tarot in ipairs(RandomTarots) do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, Tarot, RandomSeed)
            end
            return false
        elseif card == Card.CARD_HIEROPHANT then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.HIEROPHANT)
            
            return false
        elseif card == Card.CARD_LOVERS then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.LOVERS)
            
            return false
        
        elseif card == Card.CARD_CHARIOT then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.CHARIOT)
            
            return false
        elseif card == Card.CARD_JUSTICE then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.JUSTICE)
            
            return false
        elseif card == Card.CARD_HERMIT then
            local CoinsToAdd = Player:GetNumCoins()
            if CoinsToAdd > 20 then CoinsToAdd = 20 end --no more then 20 coins

            Player:AddCoins(CoinsToAdd)

            return false
        elseif card == Card.CARD_WHEEL_OF_FORTUNE then
            local CardRNG = Player:GetCardRNG(card)

            local BaseJokers = {}
            for i,Edition in ipairs(mod.Saved.Jimbo.Inventory.Editions) do
                if Edition == mod.Edition.BASE then
                    table.insert(BaseJokers, i)
                end
            end

            if CardRNG:RandomFloat() < 0.25 and BaseJokers ~= {} then 
                
                local RandIndex = mod:GetRandom(BaseJokers,CardRNG)

                local EdRoll = Player:GetCardRNG(mod.Spectrals.AURA):RandomFloat()
                if EdRoll <= 0.5 then
                    mod.Saved.Jimbo.Inventory.Editions[RandIndex] = mod.Edition.FOIL
                    --PLACEHOLDER place editions sounds
                elseif EdRoll <= 0.85 then
                    mod.Saved.Jimbo.Inventory.Editions[RandIndex] = mod.Edition.HOLOGRAPHIC
                else
                    mod.Saved.Jimbo.Inventory.Editions[RandIndex] = mod.Edition.POLYCROME
                end

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, "No!")--PLACEHOLDER
            end

            return false

        elseif card == Card.CARD_STRENGTH then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.STRENGTH)
            
            return false
        elseif card == Card.CARD_HANGED_MAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.HANGED)
            
            return false
        elseif card == Card.CARD_DEATH then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.DEATH1)
            
            return false
        elseif card == Card.CARD_TEMPERANCE then
            local CoinsToGain
            for _ ,Joker in ipairs(mod.Saved.Jimbo.Inventory) do
                if Joker == 0 then
                    goto skip
                end
                local SellValue = math.floor(mod:GetJokerCost(Joker)/2) --placeholder
                CoinsToGain = CoinsToGain + SellValue
                ::skip::
            end
            Player:AddCoins(CoinsToGain)
            return false
        elseif card == Card.CARD_DEVIL then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.DEVIL)
            
            return false
        elseif card == Card.CARD_TOWER then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.TOWER)
            
            return false
        elseif card == Card.CARD_STARS then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.STARS)
            
            return false
        elseif card == Card.CARD_MOON then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.MOON)
            
            return false
        elseif card == Card.CARD_SUN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.SUN)
            
            return false
        elseif card == Card.CARD_JUDGEMENT then
            for i, Joker in ipairs(mod.Saved.Jimbo.Inventory) do
                if Joker == 0 then --needs an empty slot
                    local CardRNG = Player:GetCardRNG(Card.CARD_JUDGEMENT)
                    local RandomJoker = mod.GetRandom(mod.Trinkets, CardRNG, true)
                    mod.Saved.Jimbo.Inventory[i] = RandomJoker
                    mod.Saved.Jimbo.Progress = ItemsConfig:GetTrinket(RandomJoker):GetCustomTags()[2] --sets the base progress
                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                    return false
                end
            end
            Player:AnimateSad()
            return false
        elseif card == Card.CARD_WORLD then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.WORLD)
            
            return false
        end
        mod.Saved.Jimbo.LastUsed[PIndex] = Card
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.NewTarotEffects)


function mod:PlanetCards(card, Player,_)
    if card >= mod.Planets.PLUTO and card <= mod.Planets.SUN then --if it's a planet Card
        if Player:GetPlayerType() == mod.Characters.JimboType then
            local Value = card - mod.Planets.PLUTO + 1 --gets the equivalent card value

            mod.Saved.Jimbo.CardLevels[Value] = mod.Saved.Jimbo.CardLevels[Value] + 1

            local ValueString = tostring(Value)
            if Value == 11 then
                ValueString = "J"
            elseif Value == 12 then
                ValueString = "Q"
            elseif Value == 13 then
                ValueString = "K"
            elseif Value == 1 then
                ValueString = "Ace"
            end

            --PLACEHOLDER
            mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, ValueString.." Up!")

        elseif false then --TAINTED JIMBO
            local Hand = card - mod.Planets.PLUTO + 1 --gets the equivalent handtype

            mod.Saved.Jimbo.HandLevels[Hand] = mod.Saved.Jimbo.HandLevels[Hand] + 1
            mod.Saved.Jimbo.HandsStat[Hand] = mod.Saved.Jimbo.HandsStat[Hand] + mod.HandUpgrades[Hand]
            if Hand == mod.HandTypes.STRAIGHT_FLUSH then
                Hand = mod.HandTypes.ROYAL_FLUSH --upgrades both royal flush and straight flush
                mod.Saved.Jimbo.HandLevels[Hand] = mod.Saved.Jimbo.HandLevels[Hand] + 1
                mod.Saved.Jimbo.HandsStat[Hand] = mod.Saved.Jimbo.HandsStat[Hand] + mod.HandUpgrades[Hand]
            end

        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.PlanetCards)

---@param Player EntityPlayer
---@param card Card
function mod:CardPacks(card, Player,_)
    if card == Card.CARD_PACK_STANDARD then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(Card.CARD_PACK_STANDARD)
        local RandomPack = {}
        for i=1, 3, 1 do
            local RandomCard = {}
            RandomCard.Suit = PackRng:RandomInt(1, 4)
            RandomCard.Value = PackRng:RandomInt(1,13)

            if PackRng:RandomFloat() < 0.4 then
                RandomCard.Enhancement = PackRng:RandomInt(2,9) 
            else
                RandomCard.Enhancement = mod.Enhancement.NONE --no :(
            end

            if PackRng:RandomFloat() < 0.2 then
                RandomCard.Seal = PackRng:RandomInt(1,4)
            else
                RandomCard.Seal = mod.Seals.NONE --no :(
            end

            local EdRoll = PackRng:RandomFloat()
            if EdRoll < CardEditionChance.Foil then
                RandomCard.Edition = mod.Edition.FOIL
            elseif EdRoll < CardEditionChance.Holo then
                RandomCard.Edition = mod.Edition.HOLOGRAPHIC
            elseif EdRoll < CardEditionChance.Poly then
                RandomCard.Edition = mod.Edition.POLYCROME
            else
                RandomCard.Edition = mod.Edition.BASE --no :(
            end

            RandomPack[i] = RandomCard
        end
        mod.SelectionParams.PackOptions = RandomPack

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.StandardPack)
    elseif card == Card.CARD_PACK_TAROT then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(Card.CARD_PACK_TAROT)
        local RandomCard
        mod.SelectionParams.PackOptions ={}
        for i=1, 3, 1 do
            repeat
                if PackRng:RandomFloat() < SoulChance then
                    RandomCard = mod.Spectrals.SOUL
                else
                    RandomCard = PackRng:RandomInt(1,22) --chooses a random not reversed tarot
                end
                
            until not mod:Contained(mod.SelectionParams.PackOptions, RandomCard)
            mod.SelectionParams.PackOptions[i] = mod:SpecialCardToFrame(RandomCard)
        end

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.TarotPack)

    elseif card == Card.CARD_PACK_CELESTIAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(Card.CARD_PACK_CELESTIAL)
        local RandomPack = {}
        if Player:GetPlayerType() == mod.Characters.JimboType then
            
            for i=1, 3 do
                local Rplanet
                repeat  
                    if PackRng:RandomFloat() < HoleChance then
                        Rplanet = mod.Spectrals.BLACK_HOLE
                    else
                        Rplanet = PackRng:RandomInt(mod.Planets.PLUTO,mod.Planets.SUN) --chooses a random planet
                    end

                until not mod:Contained(RandomPack, Rplanet)
                RandomPack[i] = mod:SpecialCardToFrame(Rplanet)
            end

        elseif false then --TAINTED JIMBO
            for i=1, 3, 1 do
                local Rplanet
                repeat  --certain hand types should remain hidden until used one time
                    local IsPlanetUnlocked = true
                    if PackRng:RandomFloat() < HoleChance then
                        Rplanet = mod.Spectrals.BLACK_HOLE
                    else
                        Rplanet = PackRng:RandomInt(mod.Planets.PLUTO,mod.Planets.ERIS) --chooses a random planet

                        if Rplanet == mod.Planets.PLANET_X then
                            if not mod.Saved.Jimbo.FiveUnlocked then
                                IsPlanetUnlocked = false
                            end
                        elseif Rplanet == mod.Planets.CERES then
                            if not mod.Saved.Jimbo.FlushHouseUnlocked then
                                IsPlanetUnlocked = false
                            end
                        elseif Rplanet == mod.Planets.ERIS then
                            if not mod.Saved.Jimbo.FiveFlushUnlocked then
                                IsPlanetUnlocked = false
                            end
                        end
                    end
                until IsPlanetUnlocked and not mod:Contained(RandomPack, Rplanet)
                RandomPack[i] = Rplanet
            end
            --after the generation caonverts them to be useful
            for i,_ in ipairs(RandomPack) do
                RandomPack[i] = mod.SpecialCardToFrame(RandomPack[i])
            end
            
        end
        mod.SelectionParams.PackOptions = RandomPack

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.CelestialPack)
    elseif card == Card.CARD_PACK_SPECTRAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)
        
        local PackRng = Player:GetCardRNG(Card.CARD_PACK_SPECTRAL)
        local RandomSpectral
        for i=1, 3, 1 do
            repeat
                local SuperRoll = PackRng:RandomFloat()
                if SuperRoll <= SoulChance then
                    RandomSpectral = mod.Spectrals.SOUL
                elseif SuperRoll <= SoulChance + HoleChance then
                    RandomSpectral = mod.Spectrals.BLACK_HOLE
                else
                    RandomSpectral = PackRng:RandomInt(mod.Spectrals.FAMILIAR,mod.Spectrals.CRYPTID) --chooses a random spectral card
                end
                mod.SelectionParams.PackOptions[i] = mod:SpecialCardToFrame(RandomSpectral)
            until not mod:Contained(mod.SelectionParams.PackOptions, RandomSpectral)
        end

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.TarotPack)

    elseif card == mod.Packs.BUFFON then

        local RandomPack = {}
        local Jokers = {}
        local PackRng = Player:GetCardRNG(mod.Packs.BUFFON)
        for i=1, 2, 1 do
            RandomPack[i] = mod:RandomJoker(PackRng, Jokers)
            table.insert(Jokers, RandomPack[i].Joker)
        end

        mod.SelectionParams.PackOptions = RandomPack

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.BuffonPack)

    end

end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.CardPacks)

---@param Player EntityPlayer
function mod:SpectralCards(card, Player)
    if not (card >= mod.Spectrals.FAMILIAR and card <= mod.Spectrals.SOUL) then
        return
    end

    if Player:GetPlayerType() == mod.Characters.JimboType then  
        local CardRNG = Player:GetCardRNG(card)
        if card == mod.Spectrals.FAMILIAR then
            
            local Valid = 0
            for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do
                if mod.Saved.Jimbo.FullDeck[v] then
                    Valid = Valid + 1
                end
            end
            if Valid == 0 then --if no cards are valid then cancel
                Player:AnimateSad()
                return
            end
            --removes a random card from the deck
            local RandomCard
            repeat
                RandomCard = mod:GetRandom(mod.Saved.Jimbo.CurrentHand, CardRNG)
            until mod.Saved.Jimbo.FullDeck[RandomCard]
            table.remove(mod.Saved.Jimbo.FullDeck, RandomCard)    
            for i = 1, 3 do --adds 3 face cards
                local RandomFace = {}
                RandomFace.Value = CardRNG:RandomInt(11,13)
                RandomFace.Suit = CardRNG:RandomInt(1,4)
                repeat 
                    RandomFace.Enhancement = CardRNG:RandomInt(2,9)
                until RandomFace.Enhancement ~= mod.Enhancement.STONE
                RandomFace.Seal = mod.Seals.NONE
                RandomFace.Edition = mod.Edition.BASE
                table.insert(mod.Saved.Jimbo.FullDeck, RandomFace)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.GRIM then

            local Valid = 0
            for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do
                if mod.Saved.Jimbo.FullDeck[v] then
                    Valid = Valid + 1
                end
            end
            if Valid == 0 then --if no cards are valid then cancel
                Player:AnimateSad()
                return
            end

            --removes a random card from the deck
            local RandomCard
            repeat
                RandomCard = mod:GetRandom(mod.Saved.Jimbo.CurrentHand, CardRNG)
            until mod.Saved.Jimbo.FullDeck[RandomCard]    
            table.remove(mod.Saved.Jimbo.FullDeck, RandomCard)    
            for i = 1, 2 do --adds 3 face cards
                local RandomAce = {}
                RandomAce.Value = 1
                RandomAce.Suit = CardRNG:RandomInt(1,4)
                repeat 
                    RandomAce.Enhancement = CardRNG:RandomInt(2,9)
                until RandomAce.Enhancement ~= mod.Enhancement.STONE
                RandomAce.Seal = mod.Seals.NONE
                RandomAce.Edition = mod.Edition.BASE    
                table.insert(mod.Saved.Jimbo.FullDeck, RandomAce)
            end 
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.INCANTATION then

            local Valid = 0
            for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do
                if mod.Saved.Jimbo.FullDeck[v] then
                    Valid = Valid + 1
                end
            end
            if Valid == 0 then --if no cards are valid then cancel
                Player:AnimateSad()
                return
            end

            ---removes a random card from the deck
            local RandomCard
            repeat
                RandomCard = mod:GetRandom(mod.Saved.Jimbo.CurrentHand, CardRNG)
            until mod.Saved.Jimbo.FullDeck[RandomCard]    
            table.remove(mod.Saved.Jimbo.FullDeck, RandomCard)    
            for i = 1, 4 do --adds 4 numbered cards
                local RandomAce = {}
                RandomAce.Value = CardRNG:RandomInt(2,10)
                RandomAce.Suit = CardRNG:RandomInt(1,4)
                repeat 
                    RandomCard.Enhancement = CardRNG:RandomInt(2,9)
                until RandomCard.Enhancement ~= mod.Enhancement.STONE
                RandomAce.Seal = mod.Seals.NONE
                RandomAce.Edition = mod.Edition.BASE    
                table.insert(mod.Saved.Jimbo.FullDeck, RandomCard)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.TALISMAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.TALISMAN)
            
        elseif card == mod.Spectrals.AURA then  
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.AURA)
            
        elseif card == mod.Spectrals.WRAITH then    
            Player:AddCoins(-Player:GetNumCoins()) --mekes him poor 
            local RandomJoker = mod:GetRandom(mod.Trinkets.rare, CardRNG)
            for i, Joker in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if Joker == 0 then --the first empty slot
                    mod.Saved.Jimbo.Inventory.Jokers[i] = RandomJoker
                    mod.Saved.Jimbo.Inventory.Editions[i] = mod.Edition.BASE
                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                    return
                end
            end
            Player:AnimateSad() --no joker for you if no slot is empty :(   
        elseif card == mod.Spectrals.SIGIL then
            local RandomSuit = CardRNG:RandomInt(1,4)
            for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do
                if mod.Saved.Jimbo.FullDeck[v] then
                    mod.Saved.Jimbo.FullDeck[v].Suit = RandomSuit
                end
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.OUIJA then 
            if mod.Saved.Jimbo.HandSize == 1 then
                Player:AnimateSad()
                return
            end 
            --every card is set to a random value
            local RandomValue = CardRNG:RandomInt(1,13)
            for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do
                if mod.Saved.Jimbo.FullDeck[v] then
                    mod.Saved.Jimbo.FullDeck[v].Value = RandomValue
                end
            end
            mod:ChangeJimboHandSize(Player, -1)
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.ECTOPLASM then 
            if mod.Saved.Jimbo.HandSize == 1 then
                Player:AnimateSad()
                return --if hand size can't be decreased, don't to anything
            end 
            local BaseJokers = {}--jokers with an edition cannot be chosen 
            for i,v in ipairs(mod.Saved.Jimbo.Inventory.Editions) do
                if v == mod.Edition.BASE then
                    table.insert(BaseJokers, i)
                end
            end
            if BaseJokers == {} then
                Player:AnimateSad()
                return --if no joker can be chosen then don't do anything
            end 
            mod.Saved.Jimbo.EctoUses = mod.Saved.Jimbo.EctoUses + 1 
            local RandomSlot = mod:GetRandom(BaseJokers, CardRNG)
            mod.Saved.Jimbo.Inventory.Editions[RandomSlot] = mod.Edition.NEGATIVE
            --adds a slot since he got a negative joker
            mod:AddJimboInventorySlots(Player, 1)
            mod:ChangeJimboHandSize(Player, -mod.Saved.Jimbo.EctoUses)    
        elseif card == mod.Spectrals.IMMOLATE then  
            local ValidCards = {} --counts how many cards in the hand exist in the deck
            for i,v in ipairs(mod.Saved.Jimbo.CurrentHand) do 
                if mod.Saved.Jimbo.FullDeck[v] then
                    table.insert(ValidCards, mod.Saved.Jimbo.CurrentHand[i])
                end
            end 
            local RandomCards = {}
            if #ValidCards <= 5 then
                RandomCards = ValidCards
            else
                for i = 1, #ValidCards do
                    if i > 5 then --maximum of 5 times
                        break
                    end
                    local Rcard = mod:GetRandom(mod.Saved.Jimbo.CurrentHand, CardRNG)
                    table.insert(RandomCards,Rcard)
                    table.remove(ValidCards, mod:GetValueIndex(ValidCards, Rcard, true))
                end
            end
            table.sort(RandomCards, function (a, b) --sorts it so table.remove doesn't move needed values
                if a > b then
                    return true
                end
                return false
            end)
            for _,v in ipairs(RandomCards) do
                table.remove(mod.Saved.Jimbo.FullDeck, v)
                Player:AddCoins(4)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.ANKH then  
            local FilledSlots = {} --gets the slot filled with a joker
            for i,v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if v ~= 0 then
                    table.insert(FilledSlots, i)
                end
            end 
            if FilledSlots == {} then
                Player:AnimateSad()
                return
            end
            local Rslot = mod:GetRandom(FilledSlots, CardRNG)
            local Added = false
            for i, v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if i ~= Rslot then
                    if Added then
                        mod.Saved.Jimbo.Inventory.Jokers[i] = 0
                        mod.Saved.Jimbo.Inventory.Editions[i] = 0
                    else
                        --new joker not added yet
                        mod.Saved.Jimbo.Inventory.Jokers[i] = mod.Saved.Jimbo.Inventory.Jokers[Rslot]

                        if mod.Saved.Jimbo.Inventory.Editions[Rslot] == mod.Edition.NEGATIVE then
                            --cannot copy negative 
                            mod.Saved.Jimbo.Inventory.Editions[i] = mod.Edition.BASE
                        else
                            mod.Saved.Jimbo.Inventory.Editions[i] = mod.Saved.Jimbo.Inventory.Editions[Rslot]
                        end
                        Added = true
                    end
                end
            end
            Isaac.RunCallback("INVENTORY_CHANGE", Player)
        elseif card == mod.Spectrals.DEJA_VU then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.DEJA_VU)
        
        elseif card == mod.Spectrals.HEX then

            local FilledSlots = {} --gets the slot filled with a joker
            for i,v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if v ~= 0 then
                    table.insert(FilledSlots, i)
                end
            end 
            if FilledSlots == {} then
                Player:AnimateSad()
                return
            end
            local Rslot = mod:GetRandom(FilledSlots, CardRNG)
            for i, v in ipairs(mod.Saved.Jimbo.Inventory.Jokers) do
                if i ~= Rslot then
                    mod.Saved.Jimbo.Inventory.Jokers[i] = 0
                    mod.Saved.Jimbo.Inventory.Editions[i] = 0
                else
                    mod.Saved.Jimbo.Inventory.Editions[i] = mod.Edition.POLYCROME
                end
            end 
            Isaac.RunCallback("INVENTORY_CHANGE", Player)
        elseif card == mod.Spectrals.TRANCE then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.TRANCE)
 
        elseif card == mod.Spectrals.MEDIUM then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.MADIUM)


        elseif card == mod.Spectrals.CRYPTID then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.CRYPTID)
            
        elseif card == mod.Spectrals.SOUL then

            local Legendary = mod:RandomJoker(CardRNG, {}, true, "legendary")
            local RandomSeed = Random()

            if RandomSeed == 0 then RandomSeed = 1 end
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                           RandomVector()*2, nil, Legendary.Joker, RandomSeed)

            mod.Saved.Jimbo.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][Legendary.Joker] = Legendary.Edition

        elseif card == mod.Spectrals.BLACK_HOLE then
            for i = 1, 13 do
                mod.Saved.Jimbo.CardLevels[i] = mod.Saved.Jimbo.CardLevels[i] + 1
            end

            
        end
    elseif false then  --PLACEHODER FOR TJIMBO

    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.SpectralCards)