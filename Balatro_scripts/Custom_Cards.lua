---@diagnostic disable: inject-field
local mod = Balatro_Expansion
local ItemsConfig = Isaac.GetItemConfig()
local Game = Game()

--every tarot has a new effect when used by jimbo
---@param Player EntityPlayer
---@param card Card
function mod:NewTarotEffects(card, Player, UseFlags)
    print("used")
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local PIndex = Player:GetPlayerIndex()
        local RandomSeed = Random()
        if RandomSeed==0 then RandomSeed=1 end

        if card == Card.CARD_FOOL then
            if mod.SavedValues.Jimbo.LastUsed[PIndex] then

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, mod.SavedValues.Jimbo.LastUsed[PIndex], RandomSeed)
                return false
            end
        elseif card == Card.CARD_MAGICIAN then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND,
                                                  mod.SelectionParams.Purposes.MAGICIAN)
            return false
        elseif card == Card.CARD_HIGH_PRIESTESS then
            
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, mod.SavedValues.Jimbo.LastUsed[PIndex], RandomSeed)
            --placeholder effect, should spawn 2 planet cards
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
                                                  mod.SelectionParams.Purposes.DEATH)
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
    if card >= mod.Planets.PLUTO and card <= mod.Planets.ERIS then --if it's a planet Card

        local Hand = card - mod.Planets.PLUTO + 1
        mod.SavedValues.Jimbo.HandLevels[Hand] = mod.SavedValues.Jimbo.HandLevels[Hand] + 1
        mod.SavedValues.Jimbo.HandsStat[Hand] = mod.SavedValues.Jimbo.HandsStat[Hand] + mod.HandUpgrades[Hand]
        if Hand == 9 then
            Hand = 9.5 --upgrades both royal flush and straight flush
            mod.SavedValues.Jimbo.HandLevels[Hand] = mod.SavedValues.Jimbo.HandLevels[Hand] + 1
            mod.SavedValues.Jimbo.HandsStat[Hand] = mod.SavedValues.Jimbo.HandsStat[Hand] + mod.HandUpgrades[Hand]
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
            RandomCard.Enhancement = PackRng:RandomInt(1,2)
            RandomCard.Edition = 1

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
            RandomPack[i] = PackRng:RandomInt(1,22) --chooses a random not reversed tarot
        end
        mod.SelectionParams.PackOptions = RandomPack

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.TarotPack)

    elseif card == Card.CARD_PACK_CELESTIAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)

        local PackRng = Player:GetCardRNG(Card.CARD_PACK_CELESTIAL)
        local RandomPack = {}
        for i=1, 3, 1 do
            repeat  --certain hand types should remain hidden until used one time
                local IsPlanetUnlocked = true
                RandomPack[i] = PackRng:RandomInt(1,12) --chooses a random not reversed tarot
                if RandomPack[i] == 10 then
                    if not mod.SavedValues.Jimbo.FiveUnlocked then
                        IsPlanetUnlocked =false
                    end
                elseif RandomPack[i] == 11 then
                    if not mod.SavedValues.Jimbo.FlushHouseUnlocked then
                        IsPlanetUnlocked =false
                    end
                elseif RandomPack[i] == 12 then
                    if not mod.SavedValues.Jimbo.FiveFlushUnlockedUnlocked then
                        IsPlanetUnlocked =false
                    end
                end

            until IsPlanetUnlocked
        end
        mod.SelectionParams.PackOptions = RandomPack

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK,
                                              mod.SelectionParams.Purposes.CelestialPack)
    elseif card == Card.CARD_PACK_SPECTRAL then
        Isaac.RunCallback("PACK_OPENED",Player,card)
        
    end

end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.CardPacks)