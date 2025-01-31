---@diagnostic disable: inject-field
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()
local sfx = SFXManager()
local CardEditionChance = {}
CardEditionChance.Foil = 0.04
CardEditionChance.Holo = 0.068 --is actually 0.028
CardEditionChance.Poly = 0.080 --is actually 0.012

local SoulChance = 0.003
local HoleChance = 0.203

--every tarot has a new effect when used by jimbo
---@param Player EntityPlayer
---@param card Card
function mod:NewTarotEffects(card, Player, UseFlags)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local PIndex = Player:GetPlayerIndex()
        local RandomSeed = Random()
        if RandomSeed==0 then RandomSeed=1 end

        if card == Card.CARD_FOOL then
            if mod.SavedValues.Jimbo.LastUsed[PIndex] then

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, mod.SavedValues.Jimbo.LastUsed[PIndex], RandomSeed)
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
                --placeholder effect, should spawn 2 planet cards
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

            if CardRNG:RandomFloat() < 0.25 then
                
                --sets a random joker to stuff (needs time ok?!?)
            else
                --mod:CreateBalatroEffect() purple
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
            for _ ,Joker in ipairs(mod.SavedValues.Jimbo.Inventory) do
                if Joker == 0 then
                    goto skip
                end
                local SellValue = math.floor(ItemsConfig:GetTrinket(Joker):GetCustomTags()[1] / 2)
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
            for i, Joker in ipairs(mod.SavedValues.Jimbo.Inventory) do
                if Joker == 0 then --needs an empty slot
                    local CardRNG = Player:GetCardRNG(Card.CARD_JUDGEMENT)
                    local RandomJoker = mod.GetRandom(mod.Trinkets, CardRNG, true)
                    mod.SavedValues.Jimbo.Inventory[i] = RandomJoker
                    mod.SavedValues.Jimbo.Progress = ItemsConfig:GetTrinket(RandomJoker):GetCustomTags()[2] --sets the base progress

                    break
                end
            end
            return false
        elseif card == Card.CARD_WORLD then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.WORLD)
            return false
        
        end
        mod.SavedValues.Jimbo.LastUsed[PIndex] = Card
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.NewTarotEffects)


function mod:PlanetCards(card, Player,_)
    if card >= mod.Planets.PLUTO and card <= mod.Planets.SUN then --if it's a planet Card
        if Player:GetPlayerType() == mod.Characters.JimboType then
            local Value = card - mod.Planets.PLUTO + 1 --gets the equivalent card value

            mod.SavedValues.Jimbo.CardLevels[Value] = mod.SavedValues.Jimbo.CardLevels[Value] + 1

        elseif false then --TAINTED JIMBO
            local Hand = card - mod.Planets.PLUTO + 1 --gets the equivalent handtype

            mod.SavedValues.Jimbo.HandLevels[Hand] = mod.SavedValues.Jimbo.HandLevels[Hand] + 1
            mod.SavedValues.Jimbo.HandsStat[Hand] = mod.SavedValues.Jimbo.HandsStat[Hand] + mod.HandUpgrades[Hand]
            if Hand == mod.HandTypes.STRAIGHT_FLUSH then
                Hand = mod.HandTypes.ROYAL_FLUSH --upgrades both royal flush and straight flush
                mod.SavedValues.Jimbo.HandLevels[Hand] = mod.SavedValues.Jimbo.HandLevels[Hand] + 1
                mod.SavedValues.Jimbo.HandsStat[Hand] = mod.SavedValues.Jimbo.HandsStat[Hand] + mod.HandUpgrades[Hand]
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
        local RandomPack = {}
        for i=1, 3, 1 do
            if PackRng:RandomFloat() < SoulChance then
                RandomPack[i] = mod.Spectrals.Soul
            else
                RandomPack[i] = PackRng:RandomInt(1,22) --chooses a random not reversed tarot
            end
        end
        mod.SelectionParams.PackOptions = RandomPack

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
                    print(Rplanet)
                until not mod:Contained(RandomPack, Rplanet)
                RandomPack[i] = Rplanet
            end
            --after the generation caonverts them to be useful
            for i,_ in ipairs(RandomPack) do
                RandomPack[i] = mod:SpecialCardToFrame(RandomPack[i])
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
                            if not mod.SavedValues.Jimbo.FiveUnlocked then
                                IsPlanetUnlocked = false
                            end
                        elseif Rplanet == mod.Planets.CERES then
                            if not mod.SavedValues.Jimbo.FlushHouseUnlocked then
                                IsPlanetUnlocked = false
                            end
                        elseif Rplanet == mod.Planets.ERIS then
                            if not mod.SavedValues.Jimbo.FiveFlushUnlocked then
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
        local RandomPack = {}
        for i=1, 3, 1 do
            local SuperRoll = PackRng:RandomFloat()
            if SuperRoll <= SoulChance then
                RandomPack[i] = mod.Spectrals.SOUL
            elseif SuperRoll <= SoulChance + HoleChance then
                RandomPack[i] = mod.Spectrals.BLACK_HOLE
            else
                RandomPack[i] = PackRng:RandomInt(mod.Spectrals.FAMILIAR,mod.Spectrals.CRYPTID) --chooses a random spectral card
            end
            RandomPack[i] = mod:SpecialCardToFrame(RandomPack[i])
        end

        mod.SelectionParams.PackOptions = RandomPack

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.TarotPack)
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
            for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
                if mod.SavedValues.Jimbo.FullDeck[v] then
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
                RandomCard = mod:GetRandom(mod.SavedValues.Jimbo.CurrentHand, CardRNG)
            until mod.SavedValues.Jimbo.FullDeck[RandomCard]
            table.remove(mod.SavedValues.Jimbo.FullDeck, RandomCard)    
            for i = 1, 3 do --adds 3 face cards
                local RandomFace = {}
                RandomFace.Value = CardRNG:RandomInt(11,13)
                RandomFace.Suit = CardRNG:RandomInt(1,4)
                RandomFace.Enhancement = CardRNG:RandomInt(2,9)
                RandomFace.Seal = mod.Seals.NONE
                RandomFace.Edition = mod.Edition.BASE   
                table.insert(mod.SavedValues.Jimbo.FullDeck, RandomFace)
            end
        elseif card == mod.Spectrals.GRIM then

            local Valid = 0
            for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
                if mod.SavedValues.Jimbo.FullDeck[v] then
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
                RandomCard = mod:GetRandom(mod.SavedValues.Jimbo.CurrentHand, CardRNG)
            until mod.SavedValues.Jimbo.FullDeck[RandomCard]    
            table.remove(mod.SavedValues.Jimbo.FullDeck, RandomCard)    
            for i = 1, 2 do --adds 3 face cards
                local RandomAce = {}
                RandomAce.Value = 1
                RandomAce.Suit = CardRNG:RandomInt(1,4)
                RandomAce.Enhancement = CardRNG:RandomInt(2,9)
                RandomAce.Seal = mod.Seals.NONE
                RandomAce.Edition = mod.Edition.BASE    
                table.insert(mod.SavedValues.Jimbo.FullDeck, RandomAce)
            end 
        elseif card == mod.Spectrals.INCANTATION then

            local Valid = 0
            for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
                if mod.SavedValues.Jimbo.FullDeck[v] then
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
                RandomCard = mod:GetRandom(mod.SavedValues.Jimbo.CurrentHand, CardRNG)
            until mod.SavedValues.Jimbo.FullDeck[RandomCard]    
            table.remove(mod.SavedValues.Jimbo.FullDeck, RandomCard)    
            for i = 1, 4 do --adds 4 numbered cards
                local RandomAce = {}
                RandomAce.Value = CardRNG:RandomInt(2,10)
                RandomAce.Suit = CardRNG:RandomInt(1,4)
                RandomAce.Enhancement = CardRNG:RandomInt(2,9)
                RandomAce.Seal = mod.Seals.NONE
                RandomAce.Edition = mod.Edition.BASE    
                table.insert(mod.SavedValues.Jimbo.FullDeck, RandomAce)
            end 
        elseif card == mod.Spectrals.TALISMAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.TALISMAN)    
        elseif card == mod.Spectrals.AURA then  
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.AURA)    
        elseif card == mod.Spectrals.WRAITH then    
            Player:AddCoins(-Player:GetNumCoins()) --mekes him poor 
            local RandomJoker = mod:GetRandom(mod.Trinkets.rare, CardRNG)
            for i, Joker in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do
                if Joker == 0 then --the first empty slot
                    mod.SavedValues.Jimbo.Inventory.Jokers[i] = RandomJoker
                    mod.SavedValues.Jimbo.Inventory.Editions[i] = mod.Edition.BASE
                    return
                end
            end
            Player:AnimateSad() --no joker for you :(   
        elseif card == mod.Spectrals.SIGIL then
            local RandomSuit = CardRNG:RandomInt(1,4)
            for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
                if mod.SavedValues.Jimbo.FullDeck[v] then
                    mod.SavedValues.Jimbo.FullDeck[v].Suit = RandomSuit
                end
            end
        
        elseif card == mod.Spectrals.OUIJA then 
            if mod.SavedValues.Jimbo.HandSize == 1 then
                Player:AnimateSad()
                return
            end 
            --every card is set to a random value
            local RandomValue = CardRNG:RandomInt(1,13)
            for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
                if mod.SavedValues.Jimbo.FullDeck[v] then
                    mod.SavedValues.Jimbo.FullDeck[v].Value = RandomValue
                end
            end

            mod:ChangeJimboHandSize(Player, -1) 
        elseif card == mod.Spectrals.ECTOPLASM then 
            if mod.SavedValues.Jimbo.HandSize == 1 then
                Player:AnimateSad()
                return --if hand size can't be decreased, don't to anything
            end 
            local BaseJokers = {}--jokers with an edition cannot be chosen 
            for i,v in ipairs(mod.SavedValues.Jimbo.Inventory.Editions) do
                if v == mod.Edition.BASE then
                    table.insert(BaseJokers, i)
                end
            end
            if BaseJokers == {} then
                Player:AnimateSad()
                return --if no joker can be chosen then don't do anything
            end 
            mod.SavedValues.Jimbo.EctoUses = mod.SavedValues.Jimbo.EctoUses + 1 
            local RandomSlot = mod:GetRandom(BaseJokers, CardRNG)
            mod.SavedValues.Jimbo.Inventory.Editions[RandomSlot] = mod.Edition.NEGATIVE
            --adds a slot since he got a negative joker
            mod:AddJimboInventorySlots(Player, 1)
            mod:ChangeJimboHandSize(Player, -mod.SavedValues.Jimbo.EctoUses)    
        elseif card == mod.Spectrals.IMMOLATE then  
            local ValidCards = {} --counts how many cards in the hand exixst in the deck
            for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do 
                if mod.SavedValues.Jimbo.FullDeck[v] then
                    table.insert(ValidCards, mod.SavedValues.Jimbo.CurrentHand[i])
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
                    local Rcard = mod:GetRandom(mod.SavedValues.Jimbo.CurrentHand, CardRNG)
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
                table.remove(mod.SavedValues.Jimbo.FullDeck, v)
                Player:AddCoins(4)
            end 
        elseif card == mod.Spectrals.ANKH then  
            local FilledSlots = {} --gets the slot filled with a joker
            for i,v in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do
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
            for i, v in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do
                if i ~= Rslot then
                    if Added then
                        mod.SavedValues.Jimbo.Inventory.Jokers[i] = 0
                        mod.SavedValues.Jimbo.Inventory.Editions[i] = 0
                    else
                        --new joker not added yet
                        mod.SavedValues.Jimbo.Inventory.Jokers[i] = mod.SavedValues.Jimbo.Inventory.Jokers[Rslot]

                        if mod.SavedValues.Jimbo.Inventory.Editions[Rslot] == mod.Edition.NEGATIVE then
                            --cannot copy negative 
                            mod.SavedValues.Jimbo.Inventory.Editions[i] = mod.Edition.BASE
                        else
                            mod.SavedValues.Jimbo.Inventory.Editions[i] = mod.SavedValues.Jimbo.Inventory.Editions[Rslot]
                        end
                        Added = true
                    end
                end
            end 
        elseif card == mod.Spectrals.DEJA_VU then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.DEJA_VU)
        
        elseif card == mod.Spectrals.HEX then

            local FilledSlots = {} --gets the slot filled with a joker
            for i,v in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do
                if v ~= 0 then
                    table.insert(FilledSlots, i)
                end
            end 
            if FilledSlots == {} then
                Player:AnimateSad()
                return
            end
            local Rslot = mod:GetRandom(FilledSlots, CardRNG)
            for i, v in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do
                if i ~= Rslot then
                    mod.SavedValues.Jimbo.Inventory.Jokers[i] = 0
                    mod.SavedValues.Jimbo.Inventory.Editions[i] = 0
                else
                    mod.SavedValues.Jimbo.Inventory.Editions[i] = mod.Edition.POLYCROME
                end
            end 

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

            local Legendary = mod:GetRandom(mod.Trinkets.legendary, CardRNG)
            local RandomSeed = Random()
            if RandomSeed == 0 then RandomSeed = 1 end
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*2, nil, Legendary, RandomSeed)
        elseif card == mod.Spectrals.BLACK_HOLE then
            
        end
    else
        --unlockable cards
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.SpectralCards)