if not EID then
    return
end
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local TrinketSprite = Sprite("gfx/005.350_custom.anm2")

local ValueDescription
------------LIST OF ALL THE GOLDEN TRINKET EXTRA TEXT----------
--(don't know how to put extra languages)

----------------------------------------------------------------
do
    local CoopMenu = Sprite("gfx/sprites/EID Icons.anm2")

    EID:addIcon("PlayerJimbo","Jimbo",0,16,16,-7,-6, CoopMenu)
end

EID:addColor("ColorMint", KColor(0.36, 0.87, 0.51, 1)) --taken from the Balatro Jokers mod
EID:addColor("ColorYellorange", KColor(238/255, 186/255, 49/255, 1))
EID:addColor("ColorChips", KColor(49/255, 140/255, 238/255, 1))
EID:addColor("ColorMult", KColor(238/255, 49/255, 66/255, 1))


--[[
local function BalatroValueCondition(descObj) -- descObj contains all informations about the currently described entity
    if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then 
        local Trinket = descObj.ObjSubType
        local Config = ItemsConfig:GetTrinket(Trinket)
        --chacks if it's mad trinket and if it needs a value description
        if Config:HasCustomTag("value") and Config:HasCustomTag("balatro") then
            if Config:HasCustomTag("mult") then
                --SUPERNOVA EXCEPTION--
                if Trinket == TrinketType.TRINKET_SUPERNOVA then
                    for _, player in ipairs(PlayerManager:GetPlayers()) do
                        if player:HasTrinket(TrinketType.TRINKET_SUPERNOVA) then
                            
                            local FirstActive = player:GetActiveItem(0)
                            local SecondActive = player:GetActiveItem(1)
                            if mod.Saved.TrinketValues.Supernova[FirstActive] and mod.Saved.TrinketValues.Supernova[SecondActive] then
                                if FirstActive == 0 and SecondActive == 0 then
                                    ValueDescription = "#Currently: No {{Collectible}} Active item held"
                                    return true
                                
                                elseif mod.Saved.TrinketValues.Supernova[FirstActive] >= mod.Saved.TrinketValues.Supernova[SecondActive] and FirstActive ~= 0 then
                                    ValueDescription = "#Currently: {{Collectible"..tostring(FirstActive).."}} gives {{Damage}} {{ColorMult}}+"..tostring(mod.Saved.TrinketValues.Supernova[FirstActive]).."{{CR}} Damage "
                                    return true
                                else
                                    ValueDescription = "#Currently: {{Collectible"..tostring(SecondActive).."}} gives {{Damage}} {{ColorMult}}+"..tostring(mod.Saved.TrinketValues.Supernova[SecondActive]).."{{CR}} Damage "
                                    return true
                                end
                            end
                            break
                        end
                    end
                    return false
                else --anything other than supernova
                    ValueDescription = "#Currently: {{Damage}} {{ColorMult}}+"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage"
                    return true
                end
            elseif Config:HasCustomTag("multm") then
                ValueDescription = "#Currently: {{Damage}} {{ColorMult}}X"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage Multiplier"
                return true
            elseif Config:HasCustomTag("chips") then
                ValueDescription = "#Currently: {{Tears}} {{ColorChips}}+"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Tears "
                return true
            else
                --PUT ALL THE ACTIVATE JOKERS HERE
                if Trinket == TrinketType.TRINKET_ROCKET then
                    ValueDescription = "#Currently: "..tostring(mod.Saved.TrinketValues.Rocket).." {{Coin}} Coins "
                    return true
                elseif Trinket == TrinketType.TRINKET_CLOUD_NINE then
                    ValueDescription = "#Currently: "..tostring(mod.Saved.TrinketValues.Cloud_9).." pickups remaining"
                    return true
                elseif Trinket == TrinketType.TRINKET_LOYALTY_CARD then
                    ValueDescription = "#Currently: "..tostring(mod.Saved.TrinketValues.Loyalty_card).." rooms remaining"
                    return true
                elseif Trinket == TrinketType.TRINKET_BLUEPRINT then
                    if mod.Saved.TrinketValues.Blueprint == 0 then
                        ValueDescription = "#{{Warning}} No {{Collectible}} Items picked up"
                    else
                        ValueDescription = "#Currently giving: {{Collectible"..tostring(mod.Saved.TrinketValues.Blueprint).."}}"
                    end
                    return true
                elseif Trinket == TrinketType.TRINKET_BRAINSTORM then
                    if mod.Saved.TrinketValues.Brainstorm == 0 then
                        ValueDescription = "#{{Warning}} No {{Collectible}} Items picked up"
                    else
                        ValueDescription = "#Currently giving: {{Collectible"..tostring(mod.Saved.TrinketValues.Brainstorm).."}}"
                    end
                    return true
                end
            end
        end
    end
end
local function BalatroValueCallback(descObj)
    -- alter the description object as you like
    EID:appendToDescription(descObj, ValueDescription)
    return descObj -- return the modified description object
end
--EID:addDescriptionModifier("Balatro Current Values", BalatroValueCondition, BalatroValueCallback)]]

--------------LIST OF ALL THE BASIC DESCRIPTIONS--------------------
---
local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")
EID:addEntity(1000, DescriptionHelperVariant, DescriptionHelperSubType,"Description Overview", "")


--uses a hacky entity to simulate the jokers being descripted, no idea if this is an optimal way or not
local function BalatroInventoryCondition(descObj)
    if descObj.ObjType == EntityType.ENTITY_EFFECT and descObj.ObjVariant == DescriptionHelperVariant and descObj.ObjSubType == DescriptionHelperSubType then
        if Balatro_Expansion.SelectionParams.Mode ~= Balatro_Expansion.SelectionParams.Modes.NONE then
            return true
        end
    end
end
local function BalatroInventoryCallback(descObj)
    -- alter the description object as you like

    descObj.Name = "Selection Helper"

    local SelectedCard

    local Icon = ""
    local Name = ""
    local Description = ""


    if Balatro_Expansion.SelectionParams.Mode == Balatro_Expansion.SelectionParams.Modes.INVENTORY then

        SelectedCard = Balatro_Expansion.Saved.Jimbo.Inventory.Jokers[mod.SelectionParams.Index]

        if not SelectedCard then --the extra confirm button

            if Balatro_Expansion.SelectionParams.Purpose == Balatro_Expansion.SelectionParams.Purposes.SELLING then

                local SelectSlot
                for i,selected in ipairs(mod.SelectionParams.SelectedCards) do
                    if selected then
                        SelectedCard = mod.Saved.Jimbo.Inventory.Jokers[i]
                        SelectSlot = i
                        break
                    end
                end

                local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard))
                
                EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

                Icon = "{{Shop}}"
                Name = "Sell the selected joker"
                Description = "#{{CurrentCard}} Currently gives {{ColorYellorange}}"..Balatro_Expansion:GetJokerCost(SelectedCard, SelectSlot).."${{CR}}"

            else --not selling anything and confirm button

                Icon = ""
                Name = "Exit overview"
                Description = ""
            end
        elseif SelectedCard == 0 then --emtoy slot

            Icon = ""
            Name = "{{Blank}} Nothing"
            Description = "Empty!"

        else --slot with something

            descObj.ObjType = 5
            descObj.ObjVariant = 350
            descObj.ObjSubType = SelectedCard


            local Tstring = "5.350."..tostring(SelectedCard)
            
            local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard))

            EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

            local Rarity = mod:GetJokerRarity(SelectedCard)
            local RarityColor
            if Rarity == "common" then
                RarityColor = "{{ColorCyan}}"
            elseif Rarity == "uncommon" then
                RarityColor = "{{ColorLime}}"
            elseif Rarity == "rare" then
                RarityColor = "{{ColorRed}}"
            else
                RarityColor = "{{ColorRainbow}}"
            end

            Icon = "{{CurrentCard}}"
            Name = RarityColor..EID:getObjectName(5, 350, SelectedCard).."{{CR}}#{{Blank}}"
            Description =""..EID:getDescriptionEntry("custom", Tstring)[3]



            local JokerConfig = ItemsConfig:GetTrinket(SelectedCard)
            if JokerConfig:HasCustomTag("Value") then

                local Value = Balatro_Expansion.Saved.Jimbo.Progress.Inventory[mod.SelectionParams.Index]
                if JokerConfig:HasCustomTag("chips") then
                    Description = Description.." #!!! Currently:{{ColorChips}} +"..tostring(Value).."{{CR}}"

                elseif JokerConfig:HasCustomTag("mult") then
                    Description = Description.." #!!! Currently:{{ColorMult}} +"..tostring(Value).."{{CR}}"

                elseif JokerConfig:HasCustomTag("multm") then
                    if SelectedCard == TrinketType.TRINKET_LOYALTY_CARD then
                        if Value == 0 then
                            Description = Description.." #!!! {{ColorYellorange}}Active!{{CR}}"
                        else
                            Description = Description.." #!!! Rooms left:{{ColorYellorange}} "..tostring(Value).."{{CR}}"
                        end
                    else
                        Description = Description.." #!!! Currently:{{ColorMult}} X"..tostring(Value).."{{CR}}"
                    end


                elseif JokerConfig:HasCustomTag("money") then
                    if SelectedCard == TrinketType.TRINKET_CLOUD_NINE then
                        Description = Description.." #!!! Last payout:{{ColorYellorange}} "..tostring(Value).."${{CR}}"

                    else
                        Description = Description.." #!!! Currently:{{ColorYellorange}} "..tostring(Value).."${{CR}}"
                    end
                elseif JokerConfig:HasCustomTag("activate") then

                    if SelectedCard == TrinketType.TRINKET_BLUEPRINT or SelectedCard == TrinketType.TRINKET_BRAINSTORM then

                        local CopiedJoker = Balatro_Expansion.Saved.Jimbo.Inventory.Jokers[Value] or 0
                        if CopiedJoker ~= 0 and ItemsConfig:GetTrinket(CopiedJoker):HasCustomTag("copy")  then
                            Description = Description.." #!!! Currently:{{ColorLime}} Compatible{{CR}}"
                        else
                            Description = Description.." #!!! Currently:{{ColorMult}} Incompatible{{CR}}"
                        end

                    elseif SelectedCard == TrinketType.TRINKET_INVISIBLE_JOKER then

                        if Value == 3 then
                            Description = Description.." #!!! Currently cleared Blinds:{{ColorYellorange}} Ready!{{CR}}"
                        else
                            Description = Description.." #!!! Currently cleared Blinds: {{ColorYellorange}}"..tostring(Value).."/3{{CR}}"
                        end
                    elseif SelectedCard == TrinketType.TRINKET_DNA then
                        if Balatro_Expansion.Saved.Jimbo.Progress.Blind.Shots == 0 then
                            Description = Description.." #!!! Currently: {{ColorYellorange}}Ready!{{CR}}"

                        else
                            Description = Description.." #!!! Currently: {{ColorRed}}Not Active!{{CR}}"

                        end
                    end
                end
                
            end

            if SelectedCard == TrinketType.TRINKET_EGG then
                Description = Description.." #{{Shop}} Sells for {{ColorYellorange}}"..tostring(mod.Saved.Jimbo.Progress.Inventory[mod.SelectionParams.Index]).."${{CR}}"

            else
                Description = Description.." #{{Shop}} Sells for {{ColorYellorange}}"..tostring(mod:GetJokerCost(SelectedCard, mod.SelectionParams.Index)).."/3{{CR}}"

            end



        end
    end


    EID:appendToDescription(descObj, "#"..Icon.." "..Name.."# "..Description)
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Balatro Inventory Overview", BalatroInventoryCondition, BalatroInventoryCallback)

----------------------------------------
-------------####JOKERS####-------------
-----------------------------------------
EID:addTrinket(TrinketType.TRINKET_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.2 {{CR}}Damage", "Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.2 {{CR}}Danno", "Jolly", "it")
EID:addTrinket(TrinketType.TRINKET_BULL, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.15 {{CR}}Tears for every {{Coin}} coin held", "Bull", "en_us")
EID:addTrinket(TrinketType.TRINKET_BULL, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.15 {{CR}}Lacrime per ogni {{Coin}} moneta avuta", "Toro", "it")
EID:addTrinket(TrinketType.TRINKET_INVISIBLE_JOKER, "{{PlayerJimbo}} Selling this joker after clearing 3 Blinds while holding it gives a copy of another held Joker", "Invisible Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_INVISIBLE_JOKER, "{{PlayerJimbo}} Ogni nuovo piano crea la prima {{Card}} carta o {{Pill}}pillola tenuta", "Jolly invisibile", "it")
EID:addTrinket(TrinketType.TRINKET_ABSTRACT_JOKER, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.15 {{CR}} Damage for Joker held", "Abstract Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_ABSTRACT_JOKER, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.15 {{CR}} Danno per ogni collezionabile avuto", "Jolly astratto", "it")
EID:addTrinket(TrinketType.TRINKET_MISPRINT, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0-1 {{CR}} random Damage Up every new room", "Misprint", "en_us")
EID:addTrinket(TrinketType.TRINKET_MISPRINT, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0-1 {{CR}}Danno casuale#Danno ricevuto cambia ogni nuova stanza", "Errore di stampa", "it")
EID:addTrinket(TrinketType.TRINKET_JOKER_STENCIL, "{{PlayerJimbo}} {{ColorMult}} +0.15X {{CR}}Damage Multiplier for every empty slot in the Joker inventory #Not having an {{Collectible}}Active item gives an additional {{ColorMult}}+0.1X", "Joker Stencil", "en_us")
EID:addTrinket(TrinketType.TRINKET_JOKER_STENCIL, "{{PlayerJimbo}} Questo conferisce {{Damage}}moltiplicatore di danno per ogni pickup non avuto#Non avere {{Coin}}monete, {{Bomb}}bombe, {{Key}}chiavi o {{Card}}carte / {{Pill}}pillole dà {{ColorMult}}X0.05 #Non avere un {{Collectible}}Oggetto attivo dà {{ColorMult}}X0.1 ", "Forma di Jolly", "it")
EID:addTrinket(TrinketType.TRINKET_STONE_JOKER, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+1.25 {{CR}}Tears for every for every stone card in the player's full deck", "Stone Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_STONE_JOKER, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+1.25 {{CR}}Lacrime per ogni roccia distrutta nel piano corrente", "Jolly di pietra", "it")
EID:addTrinket(TrinketType.TRINKET_ICECREAM, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+4 {{CR}}Tears#Loses {{ColorChips}}-0.16{{CR}} Tears every room completed while held", "Icecream", "en_us")
EID:addTrinket(TrinketType.TRINKET_ICECREAM, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+4 {{CR}}Lacrime #\2 Perde {{ColorChips}}-0.05{{CR}} ogni stanza completata mentre lo si tiene", "Gelato", "it")
EID:addTrinket(TrinketType.TRINKET_POPCORN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+1 {{CR}}Damage #Loses {{ColorMult}}-0.2{{CR}} Damage when clearing any blind", "Popcorn", "en_us")
EID:addTrinket(TrinketType.TRINKET_POPCORN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+1 {{CR}}Danno #Perde {{ColorMult}}-0.2{{CR}} Danno qunado entrando in un nuovo piano mentre lo si tiene", "Popcorn", "it")
EID:addTrinket(TrinketType.TRINKET_RAMEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage Multiplier#loses {{ColorMult}}-0.02X {{CR}} on every hand discard", "Ramen", "en_us")
EID:addTrinket(TrinketType.TRINKET_RAMEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Moltiplicatore danno#\2 Perde X0.01 ogni volta che Isaac prende danno mentre lo tiene", "Ramen", "it")
EID:addTrinket(TrinketType.TRINKET_ROCKET, "{{PlayerJimbo}} Gives 2 {{Coin}}Coins on Blind clear#{{Coin}}Coin payout increases by {{ColorYellorange}}1${{CR}} when a boss blind is defeated", "Rocket", "en_us")
EID:addTrinket(TrinketType.TRINKET_ROCKET, "{{PlayerJimbo}} Crea 3 {{Coin}} monete entrando in un nuovo piano#\1 {{Coin}}Le monete create aumentano di 2 dopo ogni attivazione", "Razzo", "it")
EID:addTrinket(TrinketType.TRINKET_ODDTODD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.35 {{CR}} Tears for every Odd numbered card triggered this room", "Odd Todd", "en_us")
EID:addTrinket(TrinketType.TRINKET_ODDTODD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.35 {{CR}} Lacrime per ogni {{Collectible}} collezionabile avuto se è un quantitativo dispari#{{Warning}} Active items are considered", "Numeri dispari", "it")
EID:addTrinket(TrinketType.TRINKET_EVENSTEVEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.04 {{CR}} Damage for every Even numbered card triggered this room", "Even Steven", "en_us")
EID:addTrinket(TrinketType.TRINKET_EVENSTEVEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.04 {{CR}} Danno per ogni {{Collectible}} collezionabile avuto se è un quantitativo pari#{{Warning}} Active items are considered", "Numeri pari", "it")
EID:addTrinket(TrinketType.TRINKET_HALLUCINATION, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}} to spawn a random {{Card}} Tarot Card when opening a Booster Pack", "Hallucination", "en_us")
EID:addTrinket(TrinketType.TRINKET_HALLUCINATION, "{{PlayerJimbo}} {{Shop}} Possibilità di spawnare una {{Card}} carta ogni acquisto in un negozio#La probabilità aumenta in base al costo dell'oggeto comprato #{{DevilRoom}} I patti del diavolo creano sempre 2 {{Card}}carte", "Allucinazione", "it")
EID:addTrinket(TrinketType.TRINKET_GREEN_JOKER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage for every for every room completed while held#{{Damage}}{{ColorMult}}-0.16 {{CR}}Damage on every hand discard" , "Green Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_GREEN_JOKER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Danno per ogni stanza completata mentre lo si tiene#\2 {{Damage}}{{ColorMult}}-0.5 {{CR}}Danno ogni danno preso mentre lo si tiene", "Jolly verde", "it")
EID:addTrinket(TrinketType.TRINKET_RED_CARD, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.15 {{CR}} Damage when skipping a Booster Pack" , "Red Card", "en_us")
EID:addTrinket(TrinketType.TRINKET_RED_CARD, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.15 {{CR}} Danno se il {{Shop}} Negozio o tutte le {{TreasureRoom}}Stanze del tesoro vengono saltate", "Cartellino rosso", "it")
EID:addTrinket(TrinketType.TRINKET_VAGABOND, "{{PlayerJimbo}} Spawns a random {{Card}} Tarot card when compleating a room with 2 {{Coin}} Coins or less#", "Vagabond", "en_us")
EID:addTrinket(TrinketType.TRINKET_VAGABOND, "{{PlayerJimbo}} Crea una {{Card}}Carta dei tarocchi completando una stanza avendo 0 {{Coin}} monete", "Vagabondo", "it")
EID:addTrinket(TrinketType.TRINKET_RIFF_RAFF, "{{PlayerJimbo}} Spawns a random {{ColorChips}} common {{CR}} Joker on every Blind Clear", "Riff-Raff", "en_us")
EID:addTrinket(TrinketType.TRINKET_RIFF_RAFF, "{{PlayerJimbo}} Crea un {{Collectible}} oggetto {{Quality0}} Q0 o {{Quality1}} Q1 all'inizio di un nuovo piano", "Marmaglia", "it")
EID:addTrinket(TrinketType.TRINKET_GOLDEN_JOKER, "{{PlayerJimbo}} Gives 4 {{Coin}} Coins on every Blind clear", "Golden Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_GOLDEN_JOKER, "{{PlayerJimbo}} Crea 5 {{Coin}} monete entrando in un nuovo piano", "Jolly dorato", "it")
EID:addTrinket(TrinketType.TRINKET_FORTUNETELLER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage for every {{Card}} Tarot card used throughout the run" , "Fortuneteller", "en_us")
EID:addTrinket(TrinketType.TRINKET_FORTUNETELLER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Danno per ogni {{Card}} Carta dei tarocchi usata nella partita#\2 {{Damage}}{{ColorMult}}-0.05 {{CR}} Danno per ogni {{Card}} Carta dei tarocchi invertita usata nella partita", "Chiromante", "it")
EID:addTrinket(TrinketType.TRINKET_BLUEPRINT, "{{PlayerJimbo}} Copies the effect of the Joker to its right", "Blueprint", "en_us")
EID:addTrinket(TrinketType.TRINKET_BLUEPRINT, "{{PlayerJimbo}}Conferisce una copia dell'ultimo {{Collectible}} Oggetto passivo preso", "Cianografia", "it")
EID:addTrinket(TrinketType.TRINKET_BRAINSTORM, "{{PlayerJimbo}} Copies the effect of the leftmost held Joker", "Brainstorm", "en_us")
EID:addTrinket(TrinketType.TRINKET_BRAINSTORM, "{{PlayerJimbo}}Conferisce una copia del primo {{Collectible}} Oggetto passivo preso nella partita", "Raccolta di idee", "it")
EID:addTrinket(TrinketType.TRINKET_MADNESS, "{{PlayerJimbo}} Destroys another random Joker and gains {{ColorMult}}+0.01X{{CR}} Damage Multiplier every Small and Big Blind cleared", "Madness", "en_us")
EID:addTrinket(TrinketType.TRINKET_MADNESS, "{{PlayerJimbo}} Questo conferisce {{Damage}}moltiplicatore di danno per ogni cosa distrutta da esso#{{Warning}} Ogni nuovo piano -1 {{Heart}} Punti vita e distrugge un {{Collectible}} Oggetto posseduto casuale", "Follia", "it")
EID:addTrinket(TrinketType.TRINKET_MR_BONES, "{{PlayerJimbo}}Revives jimbo at Full Hp if he died after clearing at least half of the current Blind or during any {{BossRoom}} Bossfight", "Mr. Bones", "en_us")
EID:addTrinket(TrinketType.TRINKET_MR_BONES, "{{PlayerJimbo}}Resuscita Isaac con -1 {{Heart}} Punti vita e vita piena se è morto durante qualunque {{BossRoom}} Bossfight", "Signor Scheletro", "it")
EID:addTrinket(TrinketType.TRINKET_ONIX_AGATE, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.07 {{CR}} Damage for every Club card triggered in the room", "Onyx Agate", "en_us")
EID:addTrinket(TrinketType.TRINKET_ONIX_AGATE, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.07 {{CR}} Danno per ogni {{Bomba}} bomba avuta#{{Warning}} Diminuisce in base alle {{Bomb}} bombe Avute", "Agata onice", "it")
EID:addTrinket(TrinketType.TRINKET_ARROWHEAD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears for every Spade card triggered in the room", "Arrowhead", "en_us")
EID:addTrinket(TrinketType.TRINKET_ARROWHEAD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per ogni {{key}} chiave avuta#{{Warning}} Diminuisce in base alle {{Key}} chiavi avute", "Punta di freccia", "it")
EID:addTrinket(TrinketType.TRINKET_BLOODSTONE, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Heart card triggered to give", "Bloodstone", "en_us")
EID:addTrinket(TrinketType.TRINKET_BLOODSTONE, "{{PlayerJimbo}} Ogni nuova stanza, 50% per ogni {{Heart}} cuore rosso di dare {{Damage}}{{ColorMult}}X0.05 {{CR}} Moltiplicatore di danno", "Diaspro sanguigno", "it")
EID:addTrinket(TrinketType.TRINKET_ROUGH_GEM, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Diamond card triggered to spawn a {{Coin}}Coin that disappears shortly after", "Rough gem", "en_us")
EID:addTrinket(TrinketType.TRINKET_ROUGH_GEM, "{{PlayerJimbo}} Ogni stanza completata, ha una possibilità di creare X {{Coin}} monete#La possiblità aumenta in base alle {{Coin}} monete avute", "Pietra grezza", "it")

EID:addTrinket(TrinketType.TRINKET_GROS_MICHAEL, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.75 {{CR}}Damage #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destoroyed on every Blind cleared", "Gros Michel", "en_us")
EID:addTrinket(TrinketType.TRINKET_GROS_MICHAEL, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+1 {{CR}}Danno #{{Warning}} 33% di possibilità di distruggersi all'inizio di un nuovo piano #Suo fratello attende la sua fine", "Gros Michel", "it")
EID:addTrinket(TrinketType.TRINKET_CAVENDISH, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage multiplier #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destroyed on every Blind cleared", "Cavendish", "en_us")
EID:addTrinket(TrinketType.TRINKET_CAVENDISH, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.3 {{CR}}Moltiplicatore di danno #{{Warning}} 0.05% di possibilità di distruggersi all'inizio di un nuovo piano", "Cavendish", "it")
EID:addTrinket(TrinketType.TRINKET_FLASH_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{RestockMachine}} Restock machine activated while holding this", "Flash Card", "en_us")
EID:addTrinket(TrinketType.TRINKET_FLASH_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Danno per ogni atiivazione di {{RestockMachine}}", "Carta alfabeto", "it")
EID:addTrinket(TrinketType.TRINKET_SACRIFICIAL_DAGGER, "{{PlayerJimbo}} Destroys the Joker to it's right and gains {{Damage}}{{ColorMult}} +0.08 x the destroyed Joker's sell value{{CR}} Damage on every Blind cleared", "Sacrificial Dagger", "en_us")
EID:addTrinket(TrinketType.TRINKET_SACRIFICIAL_DAGGER, "{{PlayerJimbo}} Questo conferisce {{Damage}}{{ColorMult}} +0.25 {{CR}} danno per ogni cosa distrutta da esso#{{Warning}} Ogni nuovo piano -1 {{Heart}} Punti vita e distrugge il primo {{Collectible}} Oggetto attivo posseduto", "Pugnale sacrificare", "it")
EID:addTrinket(TrinketType.TRINKET_CLOUD_NINE, "{{PlayerJimbo}} Gain 1 {{Coin}} Coin for every 9 in your FullDeck on every Blind clear", "Cloud 9", "en_us")
EID:addTrinket(TrinketType.TRINKET_CLOUD_NINE, "{{PlayerJimbo}} Ottieni volo per una stanza ogni 9 {{Heart}} cuori, {{Bomb}} bombe, {{Key}} chiavi o {{Coin}} monete raccolte", "Nove nuvoloso", "it")
EID:addTrinket(TrinketType.TRINKET_SWASHBUCKLER, "{{PlayerJimbo}} {{Shop}} Gives {{Damage}}{{ColorMult}} +0.05 x the total sell value of other held Jokers{{CR}} Damage", "Swashbucler", "en_us")
EID:addTrinket(TrinketType.TRINKET_SWASHBUCKLER, "{{PlayerJimbo}} {{Shop}} Questo conferisce {{Damage}} Danno ogni Oggetto comprato# il {{Damage}} Danno conferisto aumenta con colsto dell'oggetto comprato #{{DavilRoom}} Devil deals conferiscono {{Damage}} Danno specifico in base al costo", "Moschettiere", "it")
EID:addTrinket(TrinketType.TRINKET_CARTOMANCER, "{{PlayerJimbo}} Spawns 1 random {{Card}} Tarot card on every Blind clear", "Cartomancer", "en_us")
EID:addTrinket(TrinketType.TRINKET_CARTOMANCER, "{{PlayerJimbo}} Crea 2 {{Card}} carte entrando in un nuovo piano", "cartomante", "it")
EID:addTrinket(TrinketType.TRINKET_LOYALTY_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X2 {{CR}} Damage multiplier once every 6 rooms cleares", "Loyalty Card", "en_us")
EID:addTrinket(TrinketType.TRINKET_LOYALTY_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X2 {{CR}} Moltiplicatore di danno ogni 6 stanze completate", "Carta fedeltà", "it")
EID:addTrinket(TrinketType.TRINKET_SUPERNOVA, "{{PlayerJimbo}} When a card is played, gives {{Damage}}{{ColorMult}} +0.01 {{CR}} Damage for every time a card with the same value got played in the current room", "Supernova", "en_us")
EID:addTrinket(TrinketType.TRINKET_SUPERNOVA, "{{PlayerJimbo}} Guadagna {{Damage}} {{ColorMult}}+0.04 {{CR}} Danno ogni stanza completata con un {{Collectible}} oggetto attivo #Ogni {{Collectible}} Oggetto attivo salva il proprio {{Damage}} Danno", "Supernova", "it")
EID:addTrinket(TrinketType.TRINKET_DELAYED_GRATIFICATION, "{{PlayerJimbo}} Gives 1 coin per {{Heart}} Heart when clearing a room at full health", "Delayed Gratification", "en_us")
EID:addTrinket(TrinketType.TRINKET_DELAYED_GRATIFICATION, "{{PlayerJimbo}} Crea 1 {{Coin}} Moneta se una stanza viene completata senza subire danni", "Gratificazione ritardata", "it")
EID:addTrinket(TrinketType.TRINKET_EGG, "{{PlayerJimbo}} The sell value of this Joker increases by{{ColorYellorange}} +2$ {{CR}} every {{ColorYellorange}}Blind cleared{{CR}}", "Delayed Gratification", "en_us")
EID:addTrinket(TrinketType.TRINKET_EGG, "{{PlayerJimbo}} Crea 1 {{Coin}} Moneta se una stanza viene completata senza subire danni", "Gratificazione ritardata", "it")
EID:addTrinket(TrinketType.TRINKET_DNA, "{{PlayerJimbo}} If the {{ColorYellorange}} First {{CR}}card triggered in a {{ColorYellorange}}Blind{{CR}} hits an enemy, a copy of that card is added to the deck", "Delayed Gratification", "en_us")
EID:addTrinket(TrinketType.TRINKET_DNA, "{{PlayerJimbo}} Crea 1 {{Coin}} Moneta se una stanza viene completata senza subire danni", "Gratificazione ritardata", "it")






----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------

EID:addCollectible(mod.Vouchers.Grabber, "{{PlayerJimbo}} {{ColorBlue}} +5 playable cards{{CR}} every room", "Grabber", "en_us")
EID:addCollectible(mod.Vouchers.NachoTong, "{{PlayerJimbo}} {{ColorBlue}} +5 additional playable cards{{CR}} every room", "Nacko Tong", "en_us")

EID:addCollectible(mod.Vouchers.Wasteful, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}}", "Wasteful", "en_us")
EID:addCollectible(mod.Vouchers.Recyclomancy, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}}", "Recyclomancy", "en_us")

EID:addCollectible(mod.Vouchers.Overstock, "{{PlayerJimbo}} Every future shop will have 1 additional Joker for sale", "Overstock", "en_us")
EID:addCollectible(mod.Vouchers.OverstockPlus, "{{PlayerJimbo}} Every future shop will have 1 additional Joker for sale", "Overstock Plus", "en_us")

EID:addCollectible(mod.Vouchers.Clearance, "{{PlayerJimbo}} Everything is discounted by {{ColorYellorange}} 25%{{CR}} #!!! Prices are rounded down", "Clearance Sale", "en_us")
EID:addCollectible(mod.Vouchers.Liquidation, "{{PlayerJimbo}} Everything is discounted by {{ColorYellorange}} 50%{{CR}} #!!! Prices are rounded down", "Liquidation", "en_us")

EID:addCollectible(mod.Vouchers.Hone, "{{PlayerJimbo}} Special {{ColorRainbow}}Editions{{CR}} become {{ColorYellorange}}2x{{CR}} more likely to appear", "Hone", "en_us")
EID:addCollectible(mod.Vouchers.GlowUp, "{{PlayerJimbo}} Special {{ColorRainbow}}Editions{{CR}} become {{ColorYellorange}}4x{{CR}} more likely to appear", "Glow Up", "en_us")

EID:addCollectible(mod.Vouchers.RerollSurplus, "{{PlayerJimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{ColorYellorange}}1 {{Coin}} Coins{{CR}}", "Reroll Surplus", "en_us")
EID:addCollectible(mod.Vouchers.RerollGlut, "{{PlayerJimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{ColorYellorange}}2 {{Coin}} Coins{{CR}}", "Reroll Glut", "en_us")

EID:addCollectible(mod.Vouchers.Crystal, "{{PlayerJimbo}} Every {{ColorYellorange}}Booster Pack{{CR}} has 1 more option to choose from", "Crystal Ball", "en_us")
EID:addCollectible(mod.Vouchers.Omen, "{{PlayerJimbo}} {{ColorPink}}Arcana Packs{{CR}} may contain spectral cards", "Omen Globe", "en_us")

EID:addCollectible(mod.Vouchers.Telescope, "{{PlayerJimbo}} Skipping a {{ColorCyan}}Celestial Pack{{CR}} creates {{ColorYellorange}}2{{CR}} additional random {{ColorCyan}}Planet Cards{{CR}}", "Telescope", "en_us")
EID:addCollectible(mod.Vouchers.Observatory, "{{PlayerJimbo}} Triggering a card while holding it's respective {{ColorCyan}}Planet Card{{CR}} gives {{Damage}}{{ColorMult}} X1.15{{CR}} Damage Multiplier#{{Planetarium}} Having the respective Planetarium item also counts", "Observatory", "en_us")

EID:addCollectible(mod.Vouchers.Blank, "{{PlayerJimbo}} {{ColorFade}}Nothing?{{CR}}", "Blank", "en_us")
EID:addCollectible(mod.Vouchers.Antimatter, "{{PlayerJimbo}} Adds a permanent {{ColorYellorange}}Joker Slot{{CR}} to the inventorycon pickup", "Antimatter", "en_us")

EID:addCollectible(mod.Vouchers.Brush, "{{PlayerJimbo}} Gives {{ColorChips}}+1 Hand Size{{CR}}", "Brush", "en_us")
EID:addCollectible(mod.Vouchers.Palette, "{{PlayerJimbo}} Gives {{ColorChips}}+1 additional Hand Size{{CR}}", "Palette", "en_us")

EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible105}} D6 effect", "Director's Cut", "en_us")
EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible283}} D100 effect", "Retcon", "en_us")

--EID:addCollectible(mod.Vouchers.Hieroglyph, "#{{PlayerJimbo}} Triggers the {{Collectible105}} D6 effect", "Director's Cut", "en_us")
--EID:addCollectible(mod.Vouchers.Petroglyph, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible283}} D100 effect", "Retcon", "en_us")


--EID:addCollectible(mod.Vouchers.MagicTrick, "{{PlayerJimbo}} Skipping a {{ColorChips}}Celestial Pack{{CR}} creates 2 additional random {{ColorChips}}Planet Cards{{CR}}", "Telescope", "en_us")
--EID:addCollectible(mod.Vouchers.Illusion, "{{PlayerJimbo}} Triggering a card while holding it's respective {{ColorChips}}Planet Card{{CR}} gives {{Damage}}{{ColorMult}} X1.5{{CR}} Damage Multiplier", "Observatory", "en_us")





