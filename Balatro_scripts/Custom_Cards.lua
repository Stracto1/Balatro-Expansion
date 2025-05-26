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

local MegaChance = 0.15 --0.10 originally
local JumboChance = 0.55 --0.4 originally

local SoulChance = 0.003
local HoleChance = 0.003

--every tarot has a new effect when used by jimbo
---@param Player EntityPlayer
---@param card Card
function mod:NewTarotEffects(card, Player, UseFlags)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local PIndex = Player:GetData().TruePlayerIndex
        local RandomSeed = Random()

        if RandomSeed==0 then RandomSeed=1 end

        local IsTarot = false

        if card == Card.CARD_FOOL then
            if mod.Saved.Jimbo[PIndex].LastCardUsed then

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, mod.Saved.Jimbo[PIndex].LastCardUsed, RandomSeed)
            else
                Player:AnimateSad()
            end

            IsTarot = true
        else
        
        mod.Saved.Jimbo[PIndex].LastCardUsed = card

        if card == Card.CARD_MAGICIAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.MAGICIAN)
            
            IsTarot = true
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
                               RandomVector()*2, Player, Rplanet, RandomSeed)
            end
            
            IsTarot = true
        
        elseif card == Card.CARD_EMPRESS then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.EMPRESS)
            
            IsTarot = true
        
        elseif card == Card.CARD_EMPEROR then
            local RandomTarots = {}
            local CardRNG = Player:GetCardRNG(card)
            for i=1, 2 do
                repeat 
                    RandomTarots[i] = CardRNG:RandomInt(1,22)
                until RandomTarots[i] ~= Card.CARD_EMPEROR --or mod:JimboHasTrinket(Player, mod.Jokers.SHOWMAN)
            end
            for _,Tarot in ipairs(RandomTarots) do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, Player, Tarot, RandomSeed)
            end
            IsTarot = true
        elseif card == Card.CARD_HIEROPHANT then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.HIEROPHANT)
            
            IsTarot = true
        elseif card == Card.CARD_LOVERS then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.LOVERS)
            
            IsTarot = true
        
        elseif card == Card.CARD_CHARIOT then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.CHARIOT)
            
            IsTarot = true
        elseif card == Card.CARD_JUSTICE then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.JUSTICE)
            
            IsTarot = true
        elseif card == Card.CARD_HERMIT then
            local CoinsToAdd = Player:GetNumCoins()
            if CoinsToAdd > 20 then CoinsToAdd = 20 end --no more then 20 coins

            Player:AddCoins(CoinsToAdd)

            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToAdd).."$")

            IsTarot = true
        elseif card == Card.CARD_WHEEL_OF_FORTUNE then
            local CardRNG = Player:GetCardRNG(card)

            local BaseJokers = {}
            for i,Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                if Slot.Edition == mod.Edition.BASE and mod.Saved.Jimbo[PIndex].Inventory[i].Joker ~= 0 then
                    table.insert(BaseJokers, i)
                end
            end

            if not next(BaseJokers) then
                
                Player:AnimateSad()
                return false
            end

            if CardRNG:RandomFloat() < 0.25 and BaseJokers ~= {} then 
                
                local RandIndex = mod:GetRandom(BaseJokers,CardRNG)

                local EdRoll = Player:GetCardRNG(Card.CARD_WHEEL_OF_FORTUNE):RandomFloat()
                if EdRoll <= 0.5 then
                    sfx:Play(mod.Sounds.FOIL)
                    mod.Saved.Jimbo[PIndex].Inventory[RandIndex].Edition = mod.Edition.FOIL
                    --PLACEHOLDER place editions sounds
                elseif EdRoll <= 0.85 then
                    sfx:Play(mod.Sounds.HOLO)
                    mod.Saved.Jimbo[PIndex].Inventory[RandIndex].Edition = mod.Edition.HOLOGRAPHIC
                else
                    sfx:Play(mod.Sounds.POLY)
                    mod.Saved.Jimbo[PIndex].Inventory[RandIndex].Edition = mod.Edition.POLYCROME
                end

                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.PURPLE, mod.Sounds.ACTIVATE, "Nope!")--PLACEHOLDER
            end

            IsTarot = true

        elseif card == Card.CARD_STRENGTH then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.STRENGTH)
            
            IsTarot = true
        elseif card == Card.CARD_HANGED_MAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.HANGED)
            
            IsTarot = true
        elseif card == Card.CARD_DEATH then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.DEATH1)
            
            IsTarot = true
        elseif card == Card.CARD_TEMPERANCE then

            local CoinsToGain = 0

            for i ,Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                if Slot.Joker ~= 0 then
                    CoinsToGain = CoinsToGain + mod:GetJokerCost(Slot.Joker, i, Player)
                end
            end
            Player:AddCoins(CoinsToGain)

            mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(CoinsToGain).."$")


            IsTarot = true
        elseif card == Card.CARD_DEVIL then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.DEVIL)
            
            IsTarot = true
        elseif card == Card.CARD_TOWER then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.TOWER)
            
            IsTarot = true
        elseif card == Card.CARD_STARS then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.STARS)
            
            IsTarot = true
        elseif card == Card.CARD_MOON then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.MOON)
            
            IsTarot = true
        elseif card == Card.CARD_SUN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.SUN)
            
            IsTarot = true
        elseif card == Card.CARD_JUDGEMENT then

            --[[
            local EmptySlot
            for i, Joker in ipairs(mod.Saved.Jimbo[PIndex].Inventory.Jokers) do
                if Joker == 0 then --needs an empty slot
                    EmptySlot = i
                    break
                end
            end

            if EmptySlot then
                
                local RandomJoker = mod:RandomJoker(Player:GetCardRNG(Card.CARD_JUDGEMENT), {}, true)
                mod.Saved.Jimbo[PIndex].Inventory.Jokers[EmptySlot] = RandomJoker.Joker
                mod.Saved.Jimbo[PIndex].Inventory.Editions[EmptySlot] = RandomJoker.Edition

                mod.Saved.Jimbo[PIndex].Progress.Inventory[EmptySlot] = tonumber(ItemsConfig:GetTrinket(RandomJoker.Joker):GetCustomTags()[2]) --sets the base progress
                
                Isaac.RunCallback("INVENTORY_CHANGE", Player)
            else
                Player:AnimateSad()
            end]]

            local RandomJoker = mod:RandomJoker(Player:GetCardRNG(Card.CARD_JUDGEMENT), {}, true)

            local Success = mod:AddJoker(Player, RandomJoker.Joker, RandomJoker.Edition)

            if not Success then
                Player:AnimateSad()
            end

            IsTarot = true

        elseif card == Card.CARD_WORLD then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.WORLD)
            
            IsTarot = true
        end
        end
        
        if IsTarot then

            Player:AnimateCard(card, "UseItem")

            return false
        end

    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.NewTarotEffects)


function mod:PlanetCards(card, Player,_)
    if card <= mod.Planets.PLUTO or card >= mod.Planets.SUN then --if it's a planet Card
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex
    local Hand = card - mod.Planets.PLUTO + 1 --gets the equivalent handtype

    mod.Saved.PlanetTypesUsed = mod.Saved.PlanetTypesUsed | (1 << Hand)

    if Player:GetPlayerType() == mod.Characters.JimboType then

        mod.Saved.CardLevels[Hand] = mod.Saved.CardLevels[Hand] + 1

        --PLACEHOLDER
        mod:CreateBalatroEffect(Player, mod.EffectColors.BLUE, mod.Sounds.ACTIVATE, mod:CardValueToName(Hand, false, true).." Up!")

    elseif false then --TAINTED JIMBO

        mod.Saved.Jimbo[PIndex].HandLevels[Hand] = mod.Saved.Jimbo[PIndex].HandLevels[Hand] + 1
        mod.Saved.Jimbo[PIndex].HandsStat[Hand] = mod.Saved.Jimbo[PIndex].HandsStat[Hand] + mod.HandUpgrades[Hand]
        if Hand == mod.HandTypes.STRAIGHT_FLUSH then
            Hand = mod.HandTypes.ROYAL_FLUSH --upgrades both royal flush and straight flush
            mod.Saved.Jimbo[PIndex].HandLevels[Hand] = mod.Saved.Jimbo[PIndex].HandLevels[Hand] + 1
            mod.Saved.Jimbo[PIndex].HandsStat[Hand] = mod.Saved.Jimbo[PIndex].HandsStat[Hand] + mod.HandUpgrades[Hand]
        end

    end
    
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.PlanetCards)

---@param Player EntityPlayer
---@param card Card
function mod:CardPacks(card, Player,_)

    local PIndex = Player:GetData().TruePlayerIndex

    if card == mod.Packs.STANDARD then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.STANDARD)
        local RandomPack = {}

        local Size = (Player:HasCollectible(mod.Vouchers.Crystal) and 4) or 3

        local EditionRoll = Player:HasCollectible(mod.Vouchers.Illusion) and PackRng:RandomFloat() or 2
        if EditionRoll <= JumboChance then
            Size = Size + 2
        end

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

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.StandardPack)

        if EditionRoll <= JumboChance then

            if EditionRoll <= MegaChance then
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose + mod.SelectionParams.Purposes.MegaFlag
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Mega!")
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jumbo!")
            end
        end

    elseif card == mod.Packs.ARCANA then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.ARCANA)

        local RandomPack = {}
        local Options = {}
        for i=1,22 do
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

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
        mod.SelectionParams.Purposes.TarotPack)

        if EditionRoll <= JumboChance then
        
            if EditionRoll <= MegaChance then
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose + mod.SelectionParams.Purposes.MegaFlag
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Mega!")
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jumbo!")
            end 
        end


    elseif card == mod.Packs.CELESTIAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(mod.Packs.CELESTIAL)
        local RandomPack = {}
        if Player:GetPlayerType() == mod.Characters.JimboType then
            
            local Size = (Player:HasCollectible(mod.Vouchers.Crystal) and 4) or 3

            local EditionRoll = Player:HasCollectible(mod.Vouchers.Illusion) and PackRng:RandomFloat() or 2
            if EditionRoll <= JumboChance then
                Size = Size + 2
            end

            for i=1, Size do
                local Rplanet
                repeat
                    if PackRng:RandomFloat() < HoleChance then
                        Rplanet = mod.Spectrals.BLACK_HOLE
                    else
                        Rplanet = PackRng:RandomInt(mod.Planets.PLUTO,mod.Planets.SUN) --chooses a random planet
                    end
                    Rplanet = mod:SpecialCardToFrame(Rplanet)

                until not mod:Contained(RandomPack, Rplanet)
                table.insert(RandomPack, Rplanet)
            end
            mod.SelectionParams[PIndex].PackOptions = RandomPack

            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
            mod.SelectionParams.Purposes.CelestialPack)

            if EditionRoll <= JumboChance then
        
                if EditionRoll <= MegaChance then
                    mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose + mod.SelectionParams.Purposes.MegaFlag
                    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Mega!")
                else
                    mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jumbo!")
                end 
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
                            if not mod.Saved.Jimbo[PIndex].FiveUnlocked then
                                IsPlanetUnlocked = false
                            end
                        elseif Rplanet == mod.Planets.CERES then
                            if not mod.Saved.Jimbo[PIndex].FlushHouseUnlocked then
                                IsPlanetUnlocked = false
                            end
                        elseif Rplanet == mod.Planets.ERIS then
                            if not mod.Saved.Jimbo[PIndex].FiveFlushUnlocked then
                                IsPlanetUnlocked = false
                            end
                        end
                    end
                    Rplanet = mod:SpecialCardToFrame(Rplanet)

                until IsPlanetUnlocked and not mod:Contained(RandomPack, Rplanet)

                RandomPack[i] = Rplanet
            end            
        end
        mod.SelectionParams[PIndex].PackOptions = RandomPack
        
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

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.SpectralPack)

        if EditionRoll <= JumboChance then
        
            if EditionRoll <= MegaChance then
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose + mod.SelectionParams.Purposes.MegaFlag
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Mega!")
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jumbo!")
            end
        end

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

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.BuffonPack)

        if EditionRoll <= JumboChance then
    
            if EditionRoll <= MegaChance then
                mod.SelectionParams[PIndex].Purpose = mod.SelectionParams[PIndex].Purpose + mod.SelectionParams.Purposes.MegaFlag
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Mega!")
            else
                mod:CreateBalatroEffect(Player, mod.EffectColors.YELLOW, mod.Sounds.ACTIVATE, "Jumbo!")
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.CardPacks)

---@param Player EntityPlayer
function mod:SpectralCards(card, Player)
    if not (card >= mod.Spectrals.FAMILIAR and card <= mod.Spectrals.SOUL) then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if Player:GetPlayerType() == mod.Characters.JimboType then  
        local CardRNG = Player:GetCardRNG(card)
        if card == mod.Spectrals.FAMILIAR then
            
            local Valid = 0
            for i,v in ipairs(mod.Saved.Jimbo[PIndex].CurrentHand) do
                if mod.Saved.Jimbo[PIndex].FullDeck[v] then
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
                RandomCard = mod:GetRandom(mod.Saved.Jimbo[PIndex].CurrentHand, CardRNG)
            until mod.Saved.Jimbo[PIndex].FullDeck[RandomCard]
            table.remove(mod.Saved.Jimbo[PIndex].FullDeck, RandomCard)    
            for i = 1, 3 do --adds 3 face cards
                local RandomFace = {}
                RandomFace.Value = CardRNG:RandomInt(11,13)
                RandomFace.Suit = CardRNG:RandomInt(1,4)
                repeat 
                    RandomFace.Enhancement = CardRNG:RandomInt(2,9)
                until RandomFace.Enhancement ~= mod.Enhancement.STONE
                RandomFace.Seal = mod.Seals.NONE
                RandomFace.Edition = mod.Edition.BASE
                table.insert(mod.Saved.Jimbo[PIndex].FullDeck, RandomFace)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.GRIM then

            local Valid = 0
            for i,v in ipairs(mod.Saved.Jimbo[PIndex].CurrentHand) do
                if mod.Saved.Jimbo[PIndex].FullDeck[v] then
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
                RandomCard = mod:GetRandom(mod.Saved.Jimbo[PIndex].CurrentHand, CardRNG)
            until mod.Saved.Jimbo[PIndex].FullDeck[RandomCard]    
            table.remove(mod.Saved.Jimbo[PIndex].FullDeck, RandomCard)    
            for i = 1, 2 do --adds 3 face cards
                local RandomAce = {}
                RandomAce.Value = 1
                RandomAce.Suit = CardRNG:RandomInt(1,4)
                repeat 
                    RandomAce.Enhancement = CardRNG:RandomInt(2,9)
                until RandomAce.Enhancement ~= mod.Enhancement.STONE
                RandomAce.Seal = mod.Seals.NONE
                RandomAce.Edition = mod.Edition.BASE    
                table.insert(mod.Saved.Jimbo[PIndex].FullDeck, RandomAce)
            end 
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.INCANTATION then

            local Valid = 0
            for i,v in ipairs(mod.Saved.Jimbo[PIndex].CurrentHand) do
                if mod.Saved.Jimbo[PIndex].FullDeck[v] then
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
                RandomCard = mod:GetRandom(mod.Saved.Jimbo[PIndex].CurrentHand, CardRNG)
            until mod.Saved.Jimbo[PIndex].FullDeck[RandomCard]    
            table.remove(mod.Saved.Jimbo[PIndex].FullDeck, RandomCard)
            for i = 1, 4 do --adds 4 numbered cards
                local RandomAce = {}
                RandomAce.Value = CardRNG:RandomInt(2,10)
                RandomAce.Suit = CardRNG:RandomInt(1,4)
                repeat 
                    RandomCard.Enhancement = CardRNG:RandomInt(2,9)
                until RandomCard.Enhancement ~= mod.Enhancement.STONE
                RandomAce.Seal = mod.Seals.NONE
                RandomAce.Edition = mod.Edition.BASE    
                table.insert(mod.Saved.Jimbo[PIndex].FullDeck, Random)
            end
            Isaac.RunCallback("DECK_SHIFT", Player)
        elseif card == mod.Spectrals.TALISMAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.TALISMAN)
            
        elseif card == mod.Spectrals.AURA then  
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.AURA)
            
        elseif card == mod.Spectrals.WRAITH then

            mod.Saved.Other.HasDebt = false
            Player:AddCoins(-Player:GetNumCoins()) --makes him poor 
            
            --[[
            local RandomJoker = mod:RandomJoker(CardRNG, {}, true, "rare")

            for i, Joker in ipairs(mod.Saved.Jimbo[PIndex].Inventory.Jokers) do
                if Joker == 0 then --the first empty slot
                    mod.Saved.Jimbo[PIndex].Inventory.Jokers[i] = RandomJoker
                    mod.Saved.Jimbo[PIndex].Inventory.Editions[i] = mod.Edition.BASE
                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                    return
                end
            end
            Player:AnimateSad() --no joker for you if no slot is empty :(   ]]

            local RandomJoker = mod:RandomJoker(CardRNG, {}, true, "rare")
            local Success = mod:AddJoker(Player, RandomJoker.Joker,RandomJoker.Edition)

            if not Success then
                Player:AnimateSad()
            end
        
        elseif card == mod.Spectrals.SIGIL then
            local RandomSuit = CardRNG:RandomInt(1,4)
            for i,v in ipairs(mod.Saved.Jimbo[PIndex].CurrentHand) do
                if mod.Saved.Jimbo[PIndex].FullDeck[v] then
                    mod.Saved.Jimbo[PIndex].FullDeck[v].Suit = RandomSuit
                end
            end
            Isaac.RunCallback("DECK_MODIFY", Player, 0)
        elseif card == mod.Spectrals.OUIJA then
            --[[
            if mod.Saved.Jimbo[PIndex].HandSize == 1 then
                Player:AnimateSad()
                return
            end
            mod:ChangeJimboHandSize(Player, -1)]]--

            --every card is set to a random value
            local RandomValue = CardRNG:RandomInt(1,13)
            for i,v in ipairs(mod.Saved.Jimbo[PIndex].CurrentHand) do
                if mod.Saved.Jimbo[PIndex].FullDeck[v] then
                    mod.Saved.Jimbo[PIndex].FullDeck[v].Value = RandomValue
                end
            end
            
            Isaac.RunCallback("DECK_MODIFY", Player, 0)

        elseif card == mod.Spectrals.ECTOPLASM then 
            if mod.Saved.Jimbo[PIndex].HandSize == 1 then
                Player:AnimateSad()
                return --if hand size can't be decreased, don't to anything
            end

            mod.Saved.Jimbo[PIndex].EctoUses = mod.Saved.Jimbo[PIndex].EctoUses + 1 


            local BaseJokers = {}--jokers with an edition cannot be chosen 
            for i,Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                if Slot.Joker ~= 0 and Slot.Edition == mod.Edition.BASE then
                    table.insert(BaseJokers, i)
                end
            end
            if not next(BaseJokers) then
                Player:AnimateSad()
                return --if no joker can be chosen then don't do anything
            end 
            
            local RandomSlot = mod:GetRandom(BaseJokers, CardRNG)
            mod.Saved.Jimbo[PIndex].Inventory[RandomSlot].Edition = mod.Edition.NEGATIVE
            --adds a slot since he got a negative joker
            --mod:AddJimboInventorySlots(Player, 1)

            --mod:ChangeJimboHandSize(Player, -mod.Saved.Jimbo[PIndex].EctoUses)
            --mod:ChangeJimboHandSize(Player, -1)

            sfx:Play(mod.Sounds.NEGATIVE)
            
            Isaac.RunCallback("INVENTORY_CHANGE", Player)

        elseif card == mod.Spectrals.IMMOLATE then  

            local RandomCards = {}
            table.move(mod.Saved.Jimbo[PIndex].CurrentHand, 1, #mod.Saved.Jimbo[PIndex].CurrentHand, 1, RandomCards)
            
            for i = #RandomCards - 1, 4, -1 do

                local Rcard = CardRNG:RandomInt(1,i)

                table.remove(RandomCards, Rcard)

            end
            
            mod:DestroyCards(Player, RandomCards, true)

            local NumDestroyed = #RandomCards

            Player:AddCoins(5*NumDestroyed)

            mod:CreateBalatroEffect(Player,mod.EffectColors.YELLOW, 
                                        mod.Sounds.MONEY, "+"..5*NumDestroyed.."$",mod.Spectrals.IMMOLATE)

        elseif card == mod.Spectrals.ANKH then
            
            local FilledSlots = {} --gets the slots filled with a joker
            for i,Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                if Slot.Joker ~= 0 then
                    table.insert(FilledSlots, i)
                end
            end
            if not next(FilledSlots) then
                Player:AnimateSad()
                return
            end

            local Rslot = mod:GetRandom(FilledSlots, CardRNG)
            local CopyJoker = mod.Saved.Jimbo[PIndex].Inventory[Rslot].Joker + 0
            local CopyEdition = mod.Saved.Jimbo[PIndex].Inventory[Rslot].Edition + 0
            local CopyProgress = mod.Saved.Jimbo[PIndex].Progress.Inventory[Rslot]

            
            for i, _ in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                mod.Saved.Jimbo[PIndex].Inventory[i].Joker = 0
                mod.Saved.Jimbo[PIndex].Inventory[i].Edition = 0
            end

            for i=1,2 do

                mod:AddJoker(Player, CopyJoker, CopyEdition, false)
                mod.Saved.Jimbo[PIndex].Progress.Inventory[i] = CopyProgress
            end
                      
            --Isaac.RunCallback("JOKER_ADDED", Player, CopyJoker, CopyEdition)
            --Isaac.RunCallback("INVENTORY_CHANGE", Player)
                
        elseif card == mod.Spectrals.DEJA_VU then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, 
                                                  mod.SelectionParams.Purposes.DEJA_VU)
        
        elseif card == mod.Spectrals.HEX then

            local FilledSlots = {} --gets the slot filled with a joker
            for i,Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                if Slot.Joker ~= 0 then
                    table.insert(FilledSlots, i)
                end
            end
            if not next(FilledSlots) then
                Player:AnimateSad()
                return
            end

            local Rslot = mod:GetRandom(FilledSlots, CardRNG)
            for i, Slot in ipairs(mod.Saved.Jimbo[PIndex].Inventory) do
                if i ~= Rslot then
                    mod.Saved.Jimbo[PIndex].Inventory[i].Joker = 0
                    mod.Saved.Jimbo[PIndex].Inventory[i].Edition = 0
                else
                    mod.Saved.Jimbo[PIndex].Inventory[i].Edition = mod.Edition.POLYCROME
                end
            end

            sfx:Play(mod.Sounds.POLY)

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
            
            local Success = mod:AddJoker(Player, Legendary.Joker, Legendary.Edition)
            if not Success then
                Player:AnimateSad()
            end

        elseif card == mod.Spectrals.BLACK_HOLE then
            for i = 1, 13 do
                mod.Saved.CardLevels[i] = mod.Saved.CardLevels[i] + 1
            end

            
        end
    elseif false then  --PLACEHODER FOR TJIMBO

    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.SpectralCards)