if not EID then
    return
end
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local TrinketSprite = Sprite("gfx/005.350_custom.anm2")
local Description
local ValueDescription
------------LIST OF ALL THE GOLDEN TRINKET EXTRA TEXT----------
--(don't know how to put extra languages)
local GoldenDescriptions = {"Stats up DOUBLED!",
                            "Pickups DOUBLED!",
                            "chance INCREASED!",
                            "No effect",
                            "Maximum item quality INCREASED!",
                            "Items given DOUBLED!",
                            "Activates MORE FREQUeNTLY!",
                            "Upgrades TWICE AS FAST!",
                            "HIGHER chance of finding its brother!",
                            "UNBREACKABLE and stat up INCREASED",
                            "ANY card can spawn!",
                            "Activates TWICE and gives HIGER stats!"}
----------------------------------------------------------------
local function BalatroStencilCondition(descObj) -- descObj contains all informations about the currently described entity
    if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET and descObj.ObjSubType == TrinketType.TRINKET_JOKER_STENCIL then 
        if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_ISAAC_B) then
            return true
        end
    end
end
local function BalatroStencilCallback(descObj)
    -- alter the description object as you like
    EID:appendToDescription(descObj, "#{{Player21}} Gives {{Damage}}{{ColorRed}}x0.15 {{CR}} Damage multiplier for each empty {{Collectible}} Item slot")
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Balatro TIsaac stencil", BalatroStencilCondition, BalatroStencilCallback)

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
                                    ValueDescription = "#Currently: {{Collectible"..tostring(FirstActive).."}} gives {{Damage}} {{ColorRed}}+"..tostring(mod.Saved.TrinketValues.Supernova[FirstActive]).."{{CR}} Damage "
                                    return true
                                else
                                    ValueDescription = "#Currently: {{Collectible"..tostring(SecondActive).."}} gives {{Damage}} {{ColorRed}}+"..tostring(mod.Saved.TrinketValues.Supernova[SecondActive]).."{{CR}} Damage "
                                    return true
                                end
                            end
                            break
                        end
                    end
                    return false
                else --anything other than supernova
                    ValueDescription = "#Currently: {{Damage}} {{ColorRed}}+"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage"
                    return true
                end
            elseif Config:HasCustomTag("multm") then
                ValueDescription = "#Currently: {{Damage}} {{ColorRed}}X"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage Multiplier"
                return true
            elseif Config:HasCustomTag("chips") then
                ValueDescription = "#Currently: {{Tears}} {{ColorCyan}}+"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Tears "
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
EID:addDescriptionModifier("Balatro Current Values", BalatroValueCondition, BalatroValueCallback)
--------------LIST OF ALL THE BASIC DESCRIPTIONS--------------------
---
local InventoryHelperVariant = Isaac.GetEntityVariantByName("Inventory Helper")
local InventoryHelperSubType = Isaac.GetEntitySubTypeByName("Inventory Helper")
EID:addEntity(1000, InventoryHelperVariant, InventoryHelperSubType,"Inventory Overview", "")


--uses a hacky entity to simulate the jokers being descripted, no idea if this is an optimal way or not
local function BalatroInventoryCondition(descObj)
    if descObj.ObjType == EntityType.ENTITY_EFFECT and descObj.ObjVariant == InventoryHelperVariant and descObj.ObjSubType == InventoryHelperSubType then
        if Balatro_Expansion.SelectionParams.Mode ~= Balatro_Expansion.SelectionParams.Modes.NONE then
            return true
        end
    end
end
local function BalatroInventoryCallback(descObj)
    -- alter the description object as you like
    local Selectedtrinket = Balatro_Expansion.Saved.Jimbo.Inventory.Jokers[mod.SelectionParams.Index]

    local ExtraDescription = ""
    if not Selectedtrinket or Selectedtrinket == 0 then

        descObj.Name = "Nothing"
        ExtraDescription = "#Empty!"
    else
        local Tstring = "5.350."..tostring(Selectedtrinket)
        ExtraDescription = "#"..EID:getDescriptionEntry("custom", Tstring)[3]
        
        descObj.Name = EID:getObjectName(5, 350, Selectedtrinket)

        TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(Selectedtrinket).GfxFileName, true)

        descObj.Icon = EID:createItemIconObject("Trinket"..tostring(Selectedtrinket))
        --descObj.Icon = {"Idle", 2, 16,16, -1,0 , TrinketSprite}

        descObj.ObjType = 5
        descObj.ObjVariant = 350
        descObj.ObjSubType = Selectedtrinket
    end
    

    EID:appendToDescription(descObj, ExtraDescription)
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Balatro Inventory Overview", BalatroInventoryCondition, BalatroInventoryCallback)

---
---
EID:addTrinket(TrinketType.TRINKET_JOKER, "\1 {{Damage}} {{ColorRed}}+0.5 {{CR}}Damage", "Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_JOKER, "\1 {{Damage}} {{ColorRed}}+0.5 {{CR}}Danno", "Jolly", "it")
EID:addTrinket(TrinketType.TRINKET_BULL, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Tears for every {{Coin}} coin Isaac has#{{Warning}} Scales down basing on {{Coin}}coins held", "Bull", "en_us")
EID:addTrinket(TrinketType.TRINKET_BULL, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Lacrime per ogni {{Coin}} moneta#{{Warning}} Diminuisce in base alle {{Coin}}Monete Avute", "Toro", "it")
EID:addTrinket(TrinketType.TRINKET_INVISIBLE_JOKER, "On every new floor spawns the first held {{Card}}card or {{Pill}}pill", "Invisible Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_INVISIBLE_JOKER, "Ogni nuovo piano crea la prima {{Card}}carta o {{Pill}}pillola tenuta", "Jolly invisibile", "it")
EID:addTrinket(TrinketType.TRINKET_ABSTRACT_JOKER, "\1 {{Damage}} {{ColorRed}}+0.08 {{CR}}Damage for every {{Collectible}} collectible Isaac has", "Abstract Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_ABSTRACT_JOKER, "\1 {{Damage}} {{ColorRed}}+0.08 {{CR}}Danno per ogni collezionabile avuto", "Jolly astratto", "it")
EID:addTrinket(TrinketType.TRINKET_MISPRINT, "\1 {{Damage}} {{ColorRed}}+0~2 {{CR}} random Damage#Damage given changes every new room", "Misprint", "en_us")
EID:addTrinket(TrinketType.TRINKET_MISPRINT, "\1 {{Damage}} {{ColorRed}}+0~2 {{CR}}Danno casuale#Danno ricevuto cambia ogni nuova stanza", "Errore di stampa", "it")
EID:addTrinket(TrinketType.TRINKET_JOKER_STENCIL, "\1 This gives {{Damage}}Damage Multiplier for each pickup Isaac doesn't have#Not having {{Coin}}coins, {{Bomb}}bombs, {{Key}}keys or {{Card}}cards / {{Pill}}pills each give {{ColorRed}}X0.05 #Not having an {{Collectible}}Active item gives {{ColorRed}}X0.1", "Joker Stencil", "en_us")
EID:addTrinket(TrinketType.TRINKET_JOKER_STENCIL, "\1 Questo conferisce {{Damage}}moltiplicatore di danno per ogni pickup non avuto#Non avere {{Coin}}monete, {{Bomb}}bombe, {{Key}}chiavi o {{Card}}carte / {{Pill}}pillole dà {{ColorRed}}X0.05 #Non avere un {{Collectible}}Oggetto attivo dà {{ColorRed}}X0.1 ", "Forma di Jolly", "it")
EID:addTrinket(TrinketType.TRINKET_STONE_JOKER, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Tears for every rock destroyed on the current floor#Tinted rocks give extra stats#{{Warning}} Scales down basing on the ammount of rocks destroyed", "Stone Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_STONE_JOKER, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Lacrime per ogni roccia distrutta nel piano corrente#Le tinted rocks danno statistiche aggiuntive#{{Warning}} Diminuisce in base al quantitativo di roccie distrutte", "Jolly di pietra", "it")
EID:addTrinket(TrinketType.TRINKET_ICECREAM, "\1 {{Tears}} {{ColorCyan}}+1 {{CR}}Tears#\2 Loses {{ColorCyan}}-0.05{{CR}} every room completed while held", "Icecream", "en_us")
EID:addTrinket(TrinketType.TRINKET_ICECREAM, "\1 {{Tears}} {{ColorCyan}}+1 {{CR}}Lacrime #\2 Perde {{ColorCyan}}-0.05{{CR}} ogni stanza completata mentre lo si tiene", "Gelato", "it")
EID:addTrinket(TrinketType.TRINKET_POPCORN, "\1 {{Damage}} {{ColorRed}}+2 {{CR}}Damage #\2 Loses {{ColorRed}}-0.4{{CR}} Damage when entering a new floor while held", "Popcorn", "en_us")
EID:addTrinket(TrinketType.TRINKET_POPCORN, "\1 {{Damage}} {{ColorRed}}+2 {{CR}}Danno #\2 Perde {{ColorRed}}-0.4{{CR}} Danno qunado entrando in un nuovo piano mentre lo si tiene", "Popcorn", "it")
EID:addTrinket(TrinketType.TRINKET_RAMEN, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Damage multiplier#\2 loses {{ColorRed}}X0.01 {{CR}} each time Isaac takes damage while held", "Ramen", "en_us")
EID:addTrinket(TrinketType.TRINKET_RAMEN, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Moltiplicatore danno#\2 Perde X0.01 ogni volta che Isaac prende danno mentre lo tiene", "Ramen", "it")
EID:addTrinket(TrinketType.TRINKET_ROCKET, "Spawns 3 {{Coin}}coins when entring a new floor#\1 {{Coin}}Coins spawned increase by 2 on each activation", "Rocket", "en_us")
EID:addTrinket(TrinketType.TRINKET_ROCKET, "Crea 3 {{Coin}} monete entrando in un nuovo piano#\1 {{Coin}}Le monete create aumentano di 2 dopo ogni attivazione", "Razzo", "it")
EID:addTrinket(TrinketType.TRINKET_ODDTODD, "\1 {{Tears}} {{ColorCyan}}+0.07 {{CR}} Tears for every {{Collectible}} collectible Isaac has if it's an odd ammont#{{Warning}} Active items are considered", "Odd Todd", "en_us")
EID:addTrinket(TrinketType.TRINKET_ODDTODD, "\1 {{Tears}} {{ColorCyan}}+0.07 {{CR}} Lacrime per ogni {{Collectible}} collezionabile avuto se è un quantitativo dispari#{{Warning}} Active items are considered", "Numeri dispari", "it")
EID:addTrinket(TrinketType.TRINKET_EVENSTEVEN, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Damage for every {{Collectible}} collectible Isaac has if it's an even ammont#{{Warning}} Active items are considered", "Even Steven", "en_us")
EID:addTrinket(TrinketType.TRINKET_EVENSTEVEN, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Danno per ogni {{Collectible}} collezionabile avuto se è un quantitativo pari#{{Warning}} Active items are considered", "Numeri pari", "it")
EID:addTrinket(TrinketType.TRINKET_HALLUCINATION, "{{Shop}} Chance to spawn a random {{Card}} card on every shop purchase#Chance increases basing on bought item's cost #{{DevilRoom}} Devil deals taken always spawn 2 {{Card}} cards", "Hallucination", "en_us")
EID:addTrinket(TrinketType.TRINKET_HALLUCINATION, "{{Shop}} Possibilità di spawnare una {{Card}} carta ogni acquisto in un negozio#La probabilità aumenta in base al costo dell'oggeto comprato #{{DevilRoom}} I patti del diavolo creano sempre 2 {{Card}}carte", "Allucinazione", "it")
EID:addTrinket(TrinketType.TRINKET_GREEN_JOKER, "\1 {{Damage}}{{ColorRed}}+0.04 {{CR}} Damage for every for every room completed while held#\2 {{Damage}}{{ColorRed}}-0.5 {{CR}}Damage each time Isaac takes damage while held" , "Green Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_GREEN_JOKER, "\1 {{Damage}}{{ColorRed}}+0.04 {{CR}} Danno per ogni stanza completata mentre lo si tiene#\2 {{Damage}}{{ColorRed}}-0.5 {{CR}}Danno ogni danno preso mentre lo si tiene", "Jolly verde", "it")
EID:addTrinket(TrinketType.TRINKET_RED_CARD, "\1 {{Damage}}{{ColorRed}}+0.20 {{CR}} Damage if {{Shop}}Shops or all {{TreasureRoom}}Treasure rooms in a floor were skipped" , "Red Card", "en_us")
EID:addTrinket(TrinketType.TRINKET_RED_CARD, "\1 {{Damage}}{{ColorRed}}+0.20 {{CR}} Danno se il {{Shop}} Negozio o tutte le {{TreasureRoom}}Stanze del tesoro vengono saltate", "Cartellino rosso", "it")
EID:addTrinket(TrinketType.TRINKET_VAGABOND, "Spawns a random {{Card}} basic Tarot card when compleating a room with 0 {{Coin}} coins#", "Vagabond", "en_us")
EID:addTrinket(TrinketType.TRINKET_VAGABOND, "Crea una {{Card}}Carta dei tarocchi completando una stanza avendo 0 {{Coin}} monete", "Vagabondo", "it")
EID:addTrinket(TrinketType.TRINKET_RIFF_RAFF, "Spawns a random {{Quality0}} Q0 or {{Quality1}} Q1 {{Collectible}}item at the start of a new floor", "Riff-Raff", "en_us")
EID:addTrinket(TrinketType.TRINKET_RIFF_RAFF, "Crea un {{Collectible}} oggetto {{Quality0}} Q0 o {{Quality1}} Q1 all'inizio di un nuovo piano", "Marmaglia", "it")
EID:addTrinket(TrinketType.TRINKET_GOLDEN_JOKER, "Spawns 5 {{Coin}} coins when entring a new floor", "Golden Joker", "en_us")
EID:addTrinket(TrinketType.TRINKET_GOLDEN_JOKER, "Crea 5 {{Coin}} monete entrando in un nuovo piano", "Jolly dorato", "it")
EID:addTrinket(TrinketType.TRINKET_FORTUNETELLER, "\1 {{Damage}}{{ColorRed}}+0.05 {{CR}} Damage for every {{Card}} Tarot card used throughout the run#\2 {{Damage}}{{ColorRed}}-0.05 {{CR}} Damage for every {{Card}} Reverse tarot card used throughout the run" , "Fortune Teller", "en_us")
EID:addTrinket(TrinketType.TRINKET_FORTUNETELLER, "\1 {{Damage}}{{ColorRed}}+0.05 {{CR}} Danno per ogni {{Card}} Carta dei tarocchi usata nella partita#\2 {{Damage}}{{ColorRed}}-0.05 {{CR}} Danno per ogni {{Card}} Carta dei tarocchi invertita usata nella partita", "Chiromante", "it")
EID:addTrinket(TrinketType.TRINKET_BLUEPRINT, "Gives Isaac a copy of the latest picked up {{Collectible}} Passive item ", "Blueprint", "en_us")
EID:addTrinket(TrinketType.TRINKET_BLUEPRINT, "Conferisce una copia dell'ultimo {{Collectible}} Oggetto passivo preso", "Cianografia", "it")
EID:addTrinket(TrinketType.TRINKET_BRAINSTORM, "Gives Isaac a copy of the first picked up {{Collectible}} Passive item in the run", "Brainstorm", "en_us")
EID:addTrinket(TrinketType.TRINKET_BRAINSTORM, "Conferisce una copia del primo {{Collectible}} Oggetto passivo preso nella partita", "Raccolta di idee", "it")
EID:addTrinket(TrinketType.TRINKET_MADNESS, "\1 This gives {{Damage}}Damage Multiplier for each thing it destroyed#{{Warning}} On every new floor -1 {{Heart}} Hp down and destoys a random {{Collectible}} item Isaac has", "Madness", "en_us")
EID:addTrinket(TrinketType.TRINKET_MADNESS, "\1 Questo conferisce {{Damage}}moltiplicatore di danno per ogni cosa distrutta da esso#{{Warning}} Ogni nuovo piano -1 {{Heart}} Punti vita e distrugge un {{Collectible}} Oggetto posseduto casuale", "Follia", "it")
EID:addTrinket(TrinketType.TRINKET_MR_BONES, "Revives Isaac with -1 {{Heart}} Hp and full health if he died during any {{BossRoom}} Bossfight", "Mr. Bones", "en_us")
EID:addTrinket(TrinketType.TRINKET_MR_BONES, "Resuscita Isaac con -1 {{Heart}} Punti vita e vita piena se è morto durante qualunque {{BossRoom}} Bossfight", "Signor Scheletro", "it")
EID:addTrinket(TrinketType.TRINKET_ONIX_AGATE, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Damage for every {{Bomb}} bomb Isaac has#{{Warning}} Scales down basing on {{Bomb}} boms held", "Onyx Agate", "en_us")
EID:addTrinket(TrinketType.TRINKET_ONIX_AGATE, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Danno per ogni {{Bomba}} bomba avuta#{{Warning}} Diminuisce in base alle {{Bomb}} bombe Avute", "Agata onice", "it")
EID:addTrinket(TrinketType.TRINKET_ARROWHEAD, "\1 {{Tears}} {{ColorCyan}}+0.1 {{CR}} Tears for every {{Key}} key Isaac has#{{Warning}} Scales down basing on {{Key}} keys held", "Arrowhead", "en_us")
EID:addTrinket(TrinketType.TRINKET_ARROWHEAD, "\1 {{Tears}} {{ColorCyan}}+0.1 {{CR}} Tears per ogni {{key}} chiave avuta#{{Warning}} Diminuisce in base alle {{Key}} chiavi avute", "Punta di freccia", "it")
EID:addTrinket(TrinketType.TRINKET_BLOODSTONE, "\1 Every new room, each full {{Heart}} Red heart has a 50% chance to give {{Damage}}{{ColorRed}} X0.05{{CR}} Damage multiplier", "Bloodstone", "en_us")
EID:addTrinket(TrinketType.TRINKET_BLOODSTONE, "\1 Ogni nuova stanza, 50% per ogni {{Heart}} cuore rosso di dare {{Damage}}{{ColorRed}}X0.05 {{CR}} Moltiplicatore di danno", "Diaspro sanguigno", "it")
EID:addTrinket(TrinketType.TRINKET_ROUGH_GEM, "\1 Every room completed, has a chance to spawn X {{Coin}} coins#Chance increases basing on {{Coin}} coins held", "Rough gem", "en_us")
EID:addTrinket(TrinketType.TRINKET_ROUGH_GEM, "\1 Ogni stanza completata, ha una possibilità di creare X {{Coin}} monete#La possiblità aumenta in base alle {{Coin}} monete avute", "Pietra grezza", "it")

EID:addTrinket(TrinketType.TRINKET_GROS_MICHAEL, "\1 {{Damage}} {{ColorRed}}+1 {{CR}}Damage #{{Warning}} 33% chance for this to destroy on a new floor #His brother is waiting his demise", "Gros Michel", "en_us")
EID:addTrinket(TrinketType.TRINKET_GROS_MICHAEL, "\1 {{Damage}} {{ColorRed}}+1 {{CR}}Danno #{{Warning}} 33% di possibilità di distruggersi all'inizio di un nuovo piano #Suo fratello attende la sua fine", "Gros Michel", "it")
EID:addTrinket(TrinketType.TRINKET_CAVENDISH, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Damage multiplier #{{Warning}} 0.05% chance for this to destroy on a new floor", "Cavendish", "en_us")
EID:addTrinket(TrinketType.TRINKET_CAVENDISH, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Moltiplicatore di danno #{{Warning}} 0.05% di possibilità di distruggersi all'inizio di un nuovo piano", "Cavendish", "it")
EID:addTrinket(TrinketType.TRINKET_FLASH_CARD, "\1 {{Damage}} {{ColorRed}}+0.15 {{CR}} Damage for every {{RestockMachine}} Restock machine activated while holding this", "Flash Card", "en_us")
EID:addTrinket(TrinketType.TRINKET_FLASH_CARD, "\1 {{Damage}} {{ColorRed}}+0.15 {{CR}} Danno per ogni atiivazione di {{RestockMachine}}", "Carta alfabeto", "it")
EID:addTrinket(TrinketType.TRINKET_SACRIFICIAL_DAGGER, "\1 This gives {{Damage}}{{ColorRed}}+0.25 {{CR}} damage for each thing it destroyed#{{Warning}} On every new floor -1 {{Heart}} Hp down and destoys the first held {{Collectible}} Active item", "Sacrificial Dagger", "en_us")
EID:addTrinket(TrinketType.TRINKET_SACRIFICIAL_DAGGER, "\1 Questo conferisce {{Damage}}{{ColorRed}}+0.25 {{CR}} danno per ogni cosa distrutta da esso#{{Warning}} Ogni nuovo piano -1 {{Heart}} Punti vita e distrugge il primo {{Collectible}} Oggetto attivo posseduto", "Pugnale sacrificare", "it")
EID:addTrinket(TrinketType.TRINKET_CLOUD_NINE, "Gain flight for the current room every 9 {{Heart}} hearts, {{Bomb}} bombs, {{Key}} keys or {{Coin}} coins picked up", "Cloud 9", "en_us")
EID:addTrinket(TrinketType.TRINKET_CLOUD_NINE, "Ottieni volo per una stanza ogni 9 {{Heart}} cuori, {{Bomb}} bombe, {{Key}} chiavi o {{Coin}} monete raccolte", "Nove nuvoloso", "it")
EID:addTrinket(TrinketType.TRINKET_SWASHBUCKLER, "{{Shop}} This gives {{Damage}} Damage on every shop purchase# {{Damage}}Damage given increases basing on bought item's cost #{{DevilRoom}} Devil deals give specific ammount of {{Damage}} Damage Basing on cost", "Swashbucler", "en_us")
EID:addTrinket(TrinketType.TRINKET_SWASHBUCKLER, "{{Shop}} Questo conferisce {{Damage}} Danno ogni Oggetto comprato# il {{Damage}} Danno conferisto aumenta con colsto dell'oggetto comprato #{{DavilRoom}} Devil deals conferiscono {{Damage}} Danno specifico in base al costo", "Moschettiere", "it")
EID:addTrinket(TrinketType.TRINKET_CARTOMANCER, "Spawns 2 {{Card}} Cards when entring a new floor", "Cartomancer", "en_us")
EID:addTrinket(TrinketType.TRINKET_CARTOMANCER, "Crea 2 {{Card}} carte entrando in un nuovo piano", "cartomante", "it")
EID:addTrinket(TrinketType.TRINKET_LOYALTY_CARD, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}} Damage multiplier once every 6 rooms completed", "Loyalty Card", "en_us")
EID:addTrinket(TrinketType.TRINKET_LOYALTY_CARD, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}} Moltiplicatore di danno ogni 6 stanze completate", "Carta fedeltà", "it")
EID:addTrinket(TrinketType.TRINKET_SUPERNOVA, "\1 Gains {{Damage}} {{ColorRed}} +0.04 {{CR}} Damage for every room completed while holding a {{Collectible}} active item #Each {{Collectible}}active item stores its {{Damage}} Damage value", "Supernova", "en_us")
EID:addTrinket(TrinketType.TRINKET_SUPERNOVA, "\1 Guadagna {{Damage}} {{ColorRed}}+0.04 {{CR}} Danno ogni stanza completata con un {{Collectible}} oggetto attivo #Ogni {{Collectible}} Oggetto attivo salva il proprio {{Damage}} Danno", "Supernova", "it")
EID:addTrinket(TrinketType.TRINKET_DELAYED_GRATIFICATION, "Spawns 1 {{Coin}} Coin if a room is completed without taking damage", "Delayed Gratification", "en_us")
EID:addTrinket(TrinketType.TRINKET_DELAYED_GRATIFICATION, "Crea 1 {{Coin}} Moneta se una stanza viene completata senza subire danni", "Gratificazione ritardata", "it")