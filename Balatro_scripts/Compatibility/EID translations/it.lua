---@diagnostic disable: param-type-mismatch
local mod = Balatro_Expansion


local FileLanguage = "it" --REMEMBER TO MODIFY ME!!
local Descriptions = {}

Descriptions.Other = {} 
Descriptions.Other.Name = "Guida Inventario"
Descriptions.Other.LV = "LV." --abbreviation of LEVEL

Descriptions.Other.ConfirmName = "{{ColorSilver}}Conferma"
Descriptions.Other.ConfirmDesc = "Conferma la selezione"

Descriptions.Other.SkipName = "{{ColorSilver}}Salta"
Descriptions.Other.SkipDesc = "Salta le opzioni rimanenti"

Descriptions.Other.SellJoker = "Vendi il Jolly selezionato"
Descriptions.Other.SellsFor = "Valore: " --sells for x amount of money
Descriptions.Other.FREE = "GRATIS"


Descriptions.Other.Exit = "Chiudi panoramica"

Descriptions.Other.NONE = "NESSUNO"
Descriptions.Other.Nothing = "Niente"
Descriptions.Other.EmptySlot = "Lo spazio è vuoto!"

Descriptions.Other.Remaining = "rimanente"
Descriptions.Other.Attualmente = "Attualmente:"
Descriptions.Other.CompatibleTriggered = "Carte compatibili attivate: "
Descriptions.Other.CompatibleDiscarded = "Carte compatibili scartate: "
Descriptions.Other.SuitChosen = "Seme scelto: "
Descriptions.Other.CardChosen = "Carta scelta: "
Descriptions.Other.ValueChosen = "Valore scelto: "
Descriptions.Other.HandTypeChosen = "Mano scelta: "
Descriptions.Other.RoomsRemaining = "Stanze rimanenti: "
Descriptions.Other.BlindsCleared = "Bui sconfitti: "
Descriptions.Other.DiscardsRemaining = "Scarti rimanenti: "
Descriptions.Other.RemovesNeg = "Rimuove negativo dalla copia"
Descriptions.Other.ChipsScored = "Fiche"

Descriptions.Other.Cleared = "Sconfitti"
Descriptions.Other.NotCleared = "Imminente"


Descriptions.Other.Active = "{{ColorYellorange}}Attivo!"
Descriptions.Other.NotActive = "{{ColorRed}}Non attivo!"
Descriptions.Other.Compatible = "{{ColorMint}}Compatibile"
Descriptions.Other.Incompatible = "{{ColorMult}}Incompatibile"
Descriptions.Other.Ready = "{{ColorYellorange}}Pronto!"
Descriptions.Other.NotReady = "{{ColorRed}}Non pronto!"

Descriptions.Other.Rounds = "Round"
Descriptions.Other.HandSize = "Carte in mano" --as in the Balatro stat


Descriptions.HandTypeName = {[mod.HandTypes.NONE] = "",
                         [mod.HandTypes.HIGH_CARD] = "Carta Alta",
                         [mod.HandTypes.PAIR] = "Coppia",
                         [mod.HandTypes.TWO_PAIR] = "Doppia Coppia",
                         [mod.HandTypes.THREE] = "Tris",
                         [mod.HandTypes.STRAIGHT] = "Scala",
                         [mod.HandTypes.FLUSH] = "Colore",
                         [mod.HandTypes.FULL_HOUSE] = "Full",
                         [mod.HandTypes.FOUR] = "Poker",
                         [mod.HandTypes.STRAIGHT_FLUSH] = "Scala Colore",
                         [mod.HandTypes.ROYAL_FLUSH] = "Scala Reale",
                         [mod.HandTypes.FIVE] = "Pokerissimo",
                         [mod.HandTypes.FLUSH_HOUSE] = "Full Colore",
                         [mod.HandTypes.FIVE_FLUSH] = "Colore Perfetto",}



Descriptions.EnhancementName = {}
--Descriptions.Other.Enhancement[mod.Enhancement.BONUS] = ""
--Descriptions.Other.Enhancement[mod.Enhancement.MULT]  
--Descriptions.Other.Enhancement[mod.Enhancement.GOLDEN]
--Descriptions.Other.Enhancement[mod.Enhancement.GLASS] 
--Descriptions.Other.Enhancement[mod.Enhancement.LUCKY] 
--Descriptions.Other.Enhancement[mod.Enhancement.STEEL] 
--Descriptions.Other.Enhancement[mod.Enhancement.WILD]  
Descriptions.EnhancementName[mod.Enhancement.STONE] = "{{ColorGray}}Carta di Pietra"



Descriptions.BasicEnhancementName = {}
--Descriptions.Other.Enhancement[mod.Enhancement.BONUS] = ""
--Descriptions.Other.Enhancement[mod.Enhancement.MULT]  
--Descriptions.Other.Enhancement[mod.Enhancement.GOLDEN]
--Descriptions.Other.Enhancement[mod.Enhancement.GLASS] 
--Descriptions.Other.Enhancement[mod.Enhancement.LUCKY] 
--Descriptions.Other.Enhancement[mod.Enhancement.STEEL] 
--Descriptions.Other.Enhancement[mod.Enhancement.WILD]  
Descriptions.BasicEnhancementName[mod.Enhancement.STONE] = "Carta di Pietra"


Descriptions.Rarity = {}
Descriptions.Rarity["common"] = "{{ColorChips}}comune"
Descriptions.Rarity["uncommon"] = "{{ColorMint}}non comune"
Descriptions.Rarity["rare"] = "{{ColorMult}}raro"
Descriptions.Rarity["legendary"] = "{{ColorRainbow}}leggendario"




Descriptions.Jimbo = {}
Descriptions.T_Jimbo = {}

----------------------------------------
-------------####JOKERS####-------------
----------------------------------------

--EID:addTrinket(mod.Jokers.JOKER, "\1 {{ColorMult}}+1.2{{CR}} Danno", "Joker", FileLanguage)


Descriptions.Jimbo.Enhancement = {[mod.Enhancement.NONE]  = "",
                                  [mod.Enhancement.BONUS] = "#{{REG_Bonus}} {{ColorYellorange}}Carta Bonus{{CR}}: #{{IND}}{{Tears}} {{ColorChips}}+0.75{{CR}} Lacrime qundo attivata",
                                  [mod.Enhancement.MULT]  = "#{{REG_Mult}} {{ColorYellorange}}Carta Molt{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}+0.05{{CR}} Danno quando attivata",
                                  [mod.Enhancement.GOLDEN] = "#{{REG_Gold}} {{ColorYellorange}}Carta Dorata{{CR}}: #{{IND}}{{Coin}} {{ColorYellorange}}+2${{CR}} se tenuta in mano quando un {{ColorYellorange}}Buio{{CR}} viene sconfitto",
                                  [mod.Enhancement.GLASS] = "#{{REG_Glass}} {{ColorYellorange}}Carta di Vetro{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}x1.2{{CR}} Molt. di Danno quando attivata ##{{IND}}!!! {{ColorMint}}[[CHANCE]] probabilità su 10{{CR}} di venir distrutta quando attivata",
                                  --[mod.Enhancement.LUCKY] = "#{{REG_Lucky}} {{ColorMint}}Lucky Card{{CR}}: {{ColorMint}}[[CHANCE]]/5 Chance{{CR}} to give {{ColorMult}}+0.2{{CR}} damage and {{ColorMint}}[[CHANCE]]/20 Chance{{CR}} to give {{ColorYellorange}}10 {{Coin}} Pennies",
                                  [mod.Enhancement.LUCKY] = "#{{REG_Lucky}} {{ColorYellorange}}Carta Fortunata{{CR}}: #{{IND}}{{Damage}} {{ColorMint}}[[CHANCE]] probabilità su 5{{CR}} di dare {{ColorMult}}+0.2{{CR}} Danno #{{IND}}{{Coin}} {{ColorMint}}[[CHANCE]] probabilità su 20{{CR}} di dare {{ColorYellorange}}10 Pennies",
                                  [mod.Enhancement.STEEL] = "#{{REG_Steel}} {{ColorYellorange}}Carta d'Acciaio{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}X1.2{{CR}} Damage Molt. when {{ColorYellorange}}held{{CR}} in hand as an hostile room is entered",
                                  [mod.Enhancement.WILD]  = "#{{REG_Wild}} {{ColorYellorange}}Carta Multiuso{{CR}}: #{{IND}} Considerata come di ogni seme",
                                  [mod.Enhancement.STONE] = "#{{REG_Stone}} {{ColorYellorange}}Carta di Pietra{{CR}}: #{{IND}}{{Tears}} {{ColorChips}}+1.25{{CR}} Lacrime quando attivata ##{{IND}}!!! Non ha valore o seme"
                                  }

Descriptions.Jimbo.Seal = {[mod.Seals.NONE] = "",
                           [mod.Seals.RED] = "#{{REG_Red}} {{ColorYellorange}}Sigillo Rosso{{CR}}: #{{IND}}{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} le abilità della carta",
                           [mod.Seals.BLUE] = "#{{REG_Blue}} {{ColorYellorange}}Sigillo Blu{{CR}}:  #{{IND}}{{REG_Planet}} Crea il corrispettivo {{ColorCyan}}Pianeta{{CR}} se tenuta in mano quando un {{ColorYellorange}}Buio{{CR}} è sconfitto",
                           [mod.Seals.GOLDEN] = "#{{REG_Golden}} {{ColorYellorange}}Sigillo Dorato{{CR}}: #{{IND}}{{Coin}} Crea una {{ColorYellorange}}Moneta Temporanea{{CR}} quando attivata",
                           [mod.Seals.PURPLE] = "#{{REG_Purple}} {{ColorYellorange}}Sigillo Viola{{CR}}: #{{IND}}{{Card}} Crea un {{ColorPink}}Tarocco{{CR}} casuale quando {{ColorRed}}Scartata{{CR}} #{{IND}}!!! {{ColorMint}}Minore probabilità{{CR}} se più sono scartate {{ColorYellorange}}insieme",
                           }

Descriptions.Jimbo.CardEdition = {[mod.Edition.BASE] = "",
                                  [mod.Edition.FOIL] = "#{{REG_Foil}} {{ColorYellorange}}Foil{{CR}}: {{ColorChips}}+1.25{{CR}} Lacrime quando attivata",
                                  [mod.Edition.HOLOGRAPHIC] = "#{{REG_Holo}} {{ColorYellorange}}Olografica{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}+0.25{{CR}} Danno wuando attvata",
                                  [mod.Edition.POLYCROME] = "#{{REG_Poly}} {{ColorYellorange}}Policroma{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}x1.2{{CR}} Molt. di Danno quando attivata",
                                  [mod.Edition.NEGATIVE] = "#{{REG_Nega}} {{ColorYellorange}}Negativa{{CR}}: #{{IND}} scemo chi legge (fra come cazzo la hai trovata)"
                                }

Descriptions.Jimbo.JokerEdition = {[mod.Edition.NOT_CHOSEN] = "",
                                   [mod.Edition.BASE] = "",
                                   [mod.Edition.FOIL] = "#{{REG_Foil}} {{ColorYellorange}}Foil{{CR}}: #{{IND}}{{Tears}} {{ColorChips}}+3.5{{CR}} Lacrime",
                                   [mod.Edition.HOLOGRAPHIC] = "#{{REG_Holo}} {{ColorYellorange}}Olografico{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}+0.5{{CR}} Danno",
                                   [mod.Edition.POLYCROME] = "#{{REG_Poly}} {{ColorYellorange}}Polycroma{{CR}}: #{{IND}}{{Damage}} {{ColorMult}}X1.25{{CR}} Molt. di Danno",
                                   [mod.Edition.NEGATIVE] = "#{{REG_Nega}} {{ColorYellorange}}Negativo{{CR}}: #{{IND}} {{ColorYellorange}}+1{{CR}} Joker Slot"
                                   }


Descriptions.Jimbo.Jokers = {}
do
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER] = "{{Damage}} {{ColorMult}}+0.2{{CR}} Danno"
Descriptions.Jimbo.Jokers[mod.Jokers.BULL] = "{{Tears}} {{ColorChips}}+0.1{{CR}} Lacrime per {{Coin}} {{ColorYellorange}}monete{{CR}} avuta #{{Blank}} {{ColorGray}} (Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Vendere questo Jolly dopo {{ColorYellorange}}3{{CR}} Bui sconfitti duplica un Jolly tenuto [[VALUE2]] #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]]) #{{Confusion}} I nemici rimangono confusi per 2.5 secondi entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{Damage}} {{ColorMult}}+0.15{{CR}} Danno per Jolly tanuto #{{Damage}} {{ColorMult}}+0.03{{CR}} Danno per Oggetto avuto #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{CR}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.MISPRINT] = "{{Damage}} {{ColorMult}}+0-1{{CR}} Danno casuale ogni stanza #{{Collectible721}} {{ColorMint}}[[CHANCE]] probabilità su 10{{CR}} di rendere un oggetto {{ColorYellorange}}glitchato"
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{Damage}} {{ColorMult}}X0.75{{CR}} Molt. di Danno per ogni slot Jolly {{ColorYellorange}}vuoto{{CR}} #!!! {{ColorYellorange}}Forma di Jolly{{CR}} inclusa #{{Damage}} {{ColorMult}}X0.25{{CR}} Molt. di Danno se nonsi ha un {{ColorYellorange}}{{Collectible}} oggetto attivo{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.STONE_JOKER] = "{{Tears}} {{ColorChips}}+1.25{{CR}} Lacrime per {{ColorYellorange}}Carta di Pietra{{CR}} nel mazzo completo #{{Tears}} {{ColorChips}}+0.05{{CR}} Lacrime per roccia nella stanza#{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.ICECREAM] = "{{Tears}} {{ColorChips}}+[[VALUE1]]{{CR}} Lacrime#!!! Perde {{ColorChips}}-0.25{{CR}} Lacrime ogni stanza completata #Crea una scia di pozze rallentanti #{{IND}}{{Freezing}} I nemici uccisi sopra essa vengono congelati"
Descriptions.Jimbo.Jokers[mod.Jokers.POPCORN] = "{{Damage}} {{ColorMult}}+[[VALUE1]]{{CR}} Danno #!!! Parde {{ColorMult}}-0.2{{CR}} Danno ogni buio sconfitto #Casualmente lancia popcorn esplosivo"
Descriptions.Jimbo.Jokers[mod.Jokers.RAMEN] = "{{Damage}} {{ColorMult}}X[[VALUE1]]{{CR}}Molt. di Danno#!!! Perde {{ColorMult}}-0.01X{{CR}} Molt. di Danno ogni carta scartata #{{Collectible682}} Ottieni una versione indebilita di Worm Friend"
Descriptions.Jimbo.Jokers[mod.Jokers.ROCKET] = "{{Coin}} {{ColorYellorange}}+[[VALUE1]] {{Coin}} Monete{{CR}} quando un Buio viene sconfitto#{{IND}}{{Coin}} La ricompensa aumenta di {{ColorYellorange}}1{{CR}} quando un {{ColorYellorange}}Buio Boss{{CR}} viene sconfitto #{{Collectible583}} Dà l'effetto di Rocket in Jar"
Descriptions.Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{Tears}} Le carte {{ColorYellorange}}Dispari{{CR}} danno {{ColorChips}}+0.31{{CR}} Lacrime quando attivate#{{Tears}} {{ColorChips}}+0.15{{CR}} Lacrime per oggetto avuto se il numero totale è dispari"
Descriptions.Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{Damage}} Le carte {{ColorYellorange}}Pari{{CR}} danno {{ColorMult}}+0.04{{CR}} Danno quando attivata #{{Damage}} {{ColorMult}}+0.02{{CR}} Danno per oggetto tenuto se il numero totale è pari"
Descriptions.Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{Card}} {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} to creare un {{ColorPink}}Tarocco{{CR}} casuale aprendo un {{ColorYellorange}}Busta di Espansione{{CR}} #{{Collectible431}} Dà l'effetto di Multidimensional Baby"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "{{Damage}}{{ColorMult}}+0.04{{CR}} Danno per stanza completata #{{Damage}}{{ColorMult}}-0.16{{CR}}Danno ogni mano scartata #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{Damage}}{{ColorMult}}+0.15{{CR}} Danno per {{ColorYellorange}}Busta di Espansione{{CR}} saltato #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.VAGABOND] = "Crea un {{Card}}{{ColorPink}}Tarocco{{CR}} casuale completando una stanza con {{ColorYellorange}}massimo 2 {{Coin}} Monete{{CR}} #{{Beggar}} {{ColorMint}}[[CHANCE]] probabilità su 10{{CR}} di creare un {{ColorYellorange}}Beggar{{CR}} casuale completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "{{REG_Joker}} crea un Jolly {{ColorChips}}comune{{CR}} casuale quando un Buio viene sconfitto"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "{{Coin}} {{ColorYellorange}}+4 {{Coin}} Monete{{CR}} quando un Buio viene sconfitto #{{Collectible202}} I nemici toccati diventano {{ColorYellorange}}dorati{{CR}} per un po'"
Descriptions.Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{Damage}} {{ColorMult}}+0.04{{CR}} Danno per {{Card}}{{ColorPink}}Tarocco{{CR}} usato questa partita #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno) #{{Collectible451}} Dà l'effetto di Tarot Cloth"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "{{REG_Retrigger}} Copia il Jolly alla sua destra"
Descriptions.Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "{{REG_Retrigger}} Copia il Jolly più a sinistra"
Descriptions.Jimbo.Jokers[mod.Jokers.MADNESS] = "Distrugge un altro Jolly casuale e ottiene {{ColorMult}}X0.1{{CR}} Molt. di Danno ogni {{ColorYellorange}}Piccolo e Grande Buio{{CR}} sconfitti#{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.MR_BONES] = "Resuscuta a cuori pieni se solo {{ColorYellorange}}1{{CR}} Buio non è sconfitto #!!! I Bui non disponibili contano come sconfitti #{{ColorMint}}[[CHANCE]] probabilità su 5{{CR}} di attivare {{Collectible545}} Book of the Dead completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{Damage}} Le carte di {{REG_Club}} {{ColorChips}}Fiori{{CR}} danno {{ColorMult}}+0.07{{CR}} Danno quando attivate #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno) #{{Bomb}} Le esplosioni di {{ColorClub}}Fiori{{CR}} sono più frequenti, più grandi infliggono più danno"
Descriptions.Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{Tears}} Le carte di {{REG_Spade}} {{ColorSpade}}Picche{{CR}} danno {{ColorChips}}+0.5{{CR}} Lacrime quando attivate #{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime) #{{Confusion}} Le carte di {{ColorSpade}}Picche{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di rallentare e confondere"
Descriptions.Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{Damage}} Le carte di {{REG_Heart}} {{ColorMult}}Cuori{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di dare {{ColorMult}}X1.05{{CR}} Molt. di Danno quando attivate #{{REG_Heart}} Le carte di {{ColorMult}}Cuori{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 5{{CR}} di {{Charm}} ammaliare"
Descriptions.Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{Coin}} Le carte di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} hannoa {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di creare una {{Coin}} {{ColorYellorange}}Moneta Temporanea{{CR}} quando attivate #{{Collectible506}} Le carte di  {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} hanno anche l'effetto di {{ColorYellorange}}Backstabber"

Descriptions.Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{Damage}} {{ColorMult}}+0.75{{CR}} Danno #{{Warning}} {{ColorMint}}[[CHANCE]] probabilità su 6{{CR}} di distruggersi quando un Buio viene sconfitto"
Descriptions.Jimbo.Jokers[mod.Jokers.CAVENDISH] = "{{Damage}} {{ColorMult}}X1.5{{CR}} Molt. di Danno #{{Warning}} {{ColorMint}}[[CHANCE]] probabilità su 1000{{CR}} di distruggersi quando un Buio viene sconfitto"
Descriptions.Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "{{Damage}} {{ColorMult}}+0.02{{CR}} Danno per {{RestockMachine}} Restock machine attivata #{{Collectible105}} {{Damage}} {{ColorMult}}+0.02{{CR}} Danno per {{ColorYellorange}}Dado{{CR}} usato #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Distrugge il Jolly alla sua destra e ottiene {{ColorMult}}+0.08 x il suo valore di vendita{{CR}} in Danno qunado un Buio viene sconfitto #{{Blank}} {{colorGray}}(Attualmente {{ColorMukt}}+[[VALUE1]]{{ColorGray}} Danno) #{{Collectible705}} Attiva Dark Arts per 2.5 secondi entrando in una stanza ostile"
Descriptions.Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "{{Coin}} {{ColorYellorange}}+1${{CR}} per {{ColorYellorange}}9{{CR}} nel tuo mazzo completo #{{Blank}} {{ColorGray}}(Attualmente  {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Coins){{CR}} #{{Seraphim}} Dà volo"
Descriptions.Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "{{Damage}} {{ColorMult}}+0.07 X il valore di vendita totale dei Jolly avuto{{CR}} in Danno"
Descriptions.Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "{{Card}} Crea un {{ColorPink}}Tarocco{{CR}} casuale quando un Buio viene sconfitto #{{Card}} {{ColorMint}}[[CHANCE]] probabilità su 20{{CR}} per ogni pickup di essere un {{ColorPink}}Tarocco"
Descriptions.Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{Damage}} {{ColorMult}}X2{{CR}} Molt. di Danno ogni 6 stanze completate #{{Blank}} {{ColorGray}} [[VALUE1]]"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "{{Damage}} Le carte attivate danno {{ColorMult}}+0.01{{CR}} Danno per volta che carte con lo stesso {{ColorYellorange}}Valore{{CR}} sono state attivate nella stanza corrente"
Descriptions.Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "{{Coin}} {{ColorYellorange}}+1 Moneta{{CR}} per {{Heart}} cuore quando si completa una stanza a {{ColorYellorange}}vita piena{{CR}} #{{Timer}} Le porte per {{BossRoom}} Bossrush e {{Hush}} Hush vangono aperte a prescindere dal timer di gioco"
Descriptions.Jimbo.Jokers[mod.Jokers.EGG] = "{{Coin}} Il suo valore di vendita aumenta di {{ColorYellorange}}3 monete{{CR}} ogni Buio sconfitto #Ottieni un famiglio difensivo"
Descriptions.Jimbo.Jokers[mod.Jokers.DNA] = "Se la {{ColorYellorange}}Prima{{CR}} carta giocata di un {{ColorYellorange}}Buio{{CR}} colpisce un nemico, ne viene aggiunta una copia al mazzo #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}}) #{{Collectible658}} Crea un Mini-Isaac completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = " {{REG_Heart}} {{ColorMult}}Cuori{{CR}} e {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} contano come lo stesso seme # {{REG_Spade}} {{ColorSpade}}Picche{{CR}} e {{REG_Club}} {{ColorBlue}}Fiori{{CR}} contano come lo stesso seme"

Descriptions.Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{Tears}} {{ColorChips}}+5{{CR}} Lacrime se una {{ColorYellorange}}Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{Tears}} {{ColorChips}}+10{{CR}} Lacrime se un {{ColorYellorange}}Tris{{CR}} è tenuto in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{Tears}} {{ColorChips}}+7{{CR}} Lacrime se una {{ColorYellorange}}Doppia Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{Tears}} {{ColorChips}}+15{{CR}} Lacrime se una {{ColorYellorange}}Scala{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{Tears}} {{ColorChips}}+12{{CR}} Lacrime se un {{ColorYellorange}}Colore{{CR}} è tenuto in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{Damage}} {{ColorMult}}+1{{CR}} Danno se una {{ColorYellorange}}Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{Damage}} {{ColorMult}}+2{{CR}} Danno se un {{ColorYellorange}}Tris{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{Damage}} {{ColorMult}}+1.75{{CR}} Danno se una {{ColorYellorange}}Doppia Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{Damage}} {{ColorMult}}+3{{CR}} Danno se una {{ColorYellorange}}Scala{{CR}} è tenuta in mano entrando in una stanza"

Descriptions.Jimbo.Jokers[mod.Jokers.MIME] = "{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} le abilità {{ColorYellorange}}tenute in mano{{CR}} #{{ColorMint}}[[CHANCE]] probabilità su 5{{CR}} di copiare l'effetto di un Oggetto Attivo usato"
Descriptions.Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{ColorYellorange}}Colori{{CR}} e {{ColorYellorange}}Scale{{CR}} richiedono solo 4 carte #Ogni quinto nemico {{ColorYellorange}}(non boss){{CR}} creato viene ucciso immediatamente"
Descriptions.Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{Damage}} Le carte di {{REG_Heart}} {{ColorMult}}Cuori{{CR}} danno {{ColorMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{Damage}} Le carte di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} danno {{ColorMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{Damage}} Le carte di {{REG_Spade}} {{ColorSpade}}Picche{{CR}} danno {{ColorMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{Damage}} Le carte di {{REG_Club}} {{ColorChips}}Fiori{{CR}} danno {{ColorMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{Heart}} {{ColorYellorange}}+2{{CR}} Hp #{{REG_HSize}}  {{ColorMult}}-2{{CR}} Carte in mano #{{Heart}} Cura un cuore aggiuntivo completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{Damage}} {{ColorMult}}+1.5{{CR}} Danno se {{ColorYellorange}}fino a 5{{CR}} sono state giocate nella stanza #{{ColorMult}}+1{{CR}} Danno havendo {{ColorYellorange}}fino a 3{{CR}} carte in mano #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Permette di andare in {{ColorYellorange}}debito{{CR}} #{{Shop}} Oggetti in vendita possono essere comprati con massimo {{ColorMult}}-20${{CR}} in debito #!!! Gli {{ColorYellorange}}Interessi{{CR}} e effetti {{ColorYellorange}}basati sulle monete{{CR}} non sono attivi se in debito"

Descriptions.Jimbo.Jokers[mod.Jokers.BANNER] = "{{Tears}} {{ColorChips}}+1.5{{CR}} Lacrime per {{Heart}} {{ColorYellorange}}Cuore pieno #{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime) #Uno stendardo appare entrando in una stanza #{{IND}}{{Tears}} Stare vicino allo stendardo dà {{ColorChips}}+3{{CR}} Lacrime"
Descriptions.Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{Damage}} {{ColorMult}}+1.5{{CR}} Danno avendo solo {{ColorYellorange}}1{{CR}} {{Heart}} cuore pieno #{{Heart}} Crea cuori invece di curarti a fine stanza #{{Collectible335}} Attiva un'{{ColorYellorange}}aura repellente{{CR}} mentre attivo"
Descriptions.Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "{{REG_Stone}} Aggiunge una {{ColorYellorange}}Carta di Pietra{{CR}} al mazzo ogni {{ColorYellorange}}Buio{{CR}} sconfitto #{{ColorMint}}[[CHANCE]] probabilità su 100{{CR}} aggiuntiva di generare delle {{ColorYellorange}}Tinted Rock"
Descriptions.Jimbo.Jokers[mod.Jokers._8_BALL] = "{{Card}} Gli {{ColorYellorange}}8{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 8{{CR}} di creare un {{Card}} {{ColorPink}}Tarot{{CR}} tarocco casuale quando attivati #{{Shotspeed}} +0.16 Shot Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.DUSK] = "{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} le {{ColorYellorange}}ultime 10{{CR}} carte giocabili #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "{{Damage}} {{ColorMult}}+0.05{{CR}} Danno {{ColorYellorange}}X il Valore{{CR}} più basso delle carte {{ColorYellorange}}tenute in mano{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{Collectible376}} Tutti gli {{Shop}} Shop e {{Treasure}} Treasure hanno una Restock Machine aggiuntiva"
Descriptions.Jimbo.Jokers[mod.Jokers.FIBONACCI] = "{{Damage}} Gli {{ColorYellorange}}Assi{{CR}}, {{ColorYellorange}}2{{CR}}, {{ColorYellorange}}3{{CR}}, {{ColorYellorange}}5{{CR}} e {{ColorYellorange}}8{{CR}} danno {{ColorMult}}+0.08{{CR}} Danno quando attivati #{{Damage}} {{ColorMult}}+0.05{{CR}} Danno per {{Collectible}} oggetto avuto se ilò numero totale è nella sequanza di {{ColorYellorange}}Fibonacci #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "{{Damage}} Ottiene {{ColorMult}}X0.15{{CR}} Molt. di Danno per {{ColorSilver}}Carta d'Acciaio{{CR}} nel mazzo completo #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{Tears}} Le {{REG_Face}} {{ColorYellorange}}Figure{{CR}} danno {{ColorChips}}+0.3{{CR}} Lacrime quando attivate #{{Tears}} Uccidere un {{ColorYellorange}}Champion{{CR}} dà {{ColorChips}}+1{{CR}} Lacrime"
Descriptions.Jimbo.Jokers[mod.Jokers.HACK] = "{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} i {{ColorYellorange}}2{{CR}}, {{ColorYellorange}}3{{CR}}, {{ColorYellorange}}4{{CR}} e {{ColorYellorange}}5{{CR}} giocati #\1 Ottieni una copia degli oggetti {{Quality0}} e {{Quality1}} avuti"
Descriptions.Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "{{REG_Face}} Ogni carta conta come {{ColorYellorange}}Figure{{CR}} #{{ColorMint}}[[CHANCE]] probabilità su 5{{CR}} aggiuntiva per ongi nemico non boss di essere un {{ColorYellorange}}Champion"

Descriptions.Jimbo.Jokers[mod.Jokers.SCHOLAR] = "\1 Gli {{ColorYellorange}}Assi{{CR}} danno {{ColorChips}}+0.2{{CR}} Lacrime e {{ColorMult}}+0.04{{CR}} Danno quando attivati #{{Luck}} {{ColorMint}}+5{{CR}} Fortuna"
Descriptions.Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{Coin}} Le {{ColorYellorange}}Figure{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di creare {{ColorYellorange}}2 Monete Temporanee{{CR}} quando attivate #{{Collectible602}} Ottieni l'effetto di Member Card"
Descriptions.Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{Damage}} {{ColorMult}}+0.01{{CR}} Danno per carte {{ColorYellorange}}non Figura{{CR}} giocate consecutivamente #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{REG_Planet}} {{ColorMint}}[[CHANCE]] probabilità su 20{{CR}} di potenziare il livello del {{ColorYellorange}}Valore{{CR}} attivato # {{ColorMint}}[[CHANCE]] probabilità su 20{{CR}} per oggetto {{ColorYellorange}}Stellare{{CR}} avuto"
Descriptions.Jimbo.Jokers[mod.Jokers.BURGLAR] = "!!! Fissa gli Hp a {{ColorRed}}2{{CR}} Cuori #\1 Le carte sono giocabili fino al {{ColorYellorange}}rimischio{{CR}} del mazzo"
Descriptions.Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{Damage}} {{ColorMult}}X2{{CR}} Molt. di Danno se tutte le carte in mano sono di {{ColorSpade}}Picche{{CR}} o {{ColorChips}}Fiori"
Descriptions.Jimbo.Jokers[mod.Jokers.RUNNER] = "{{Tears}} Ottiene {{ColorChips}}+1.5{{CR}} Lacrime entrando in una stanza ostile {{ColorYellorange}}inesplorata{{CR}} tenendo una {{ColorYellorange}}Scala{{CR}} #{{Tears}} Gives {{ColorChips}}+Lacrime{{CR}} equal to double your {{Speed}} Speed stat#{{Blank}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Fiches) #{{Speed}} +0.1 Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.SPLASH] = "{{REG_Retrigger}} Attiva le carte tenute in mano entrando in una stanza {{ColorYellorange}}ostile"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{Tears}} {{ColorChips}}+0.2{{CR}} Lacrime per carta rimenente nel mazzo #{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "{{Card}} Se la {{ColorYellorange}}prima{{CR}} carta attivata di un {{ColorYellorange}}Buio{{CR}} è un {{ColorYellorange}}6{{CR}} e colpisce un nemico, si distrugge e crea una {{ColorBlue}}Busta Spettrale{{CR}} #{{Collectible3}} 1 lacrima ogni 4 ottiene homing"
Descriptions.Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "{{Damage}} Ottiene {{ColorMult}}+0.05X{{CR}} Molt. di Danno ogni {{ColorCyan}}Carta Pianeta{{CR}} uasta #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno) #{{Collectible}} Gli oggetti {{ColorYellorange}}Stellari{{CR}} avuti danno {{ColorMult}}X1.1{{CR}} Molt. di Danno"
Descriptions.Jimbo.Jokers[mod.Jokers.HIKER] = "{{Coin}} Le carte ottengono {{ColorMult}}+0.02{{CR}} Lacrime {{ColorYellorange}}permanenti{{CR}} quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.FACELESS] = "{{Coin}} {{ColorYellorange}}+3 Monete{{CR}} scartando almeno {{ColorYellorange}}2{{CR}} {{REG_Face}} Figure insieme #Se solo nemici {{ColorYellorange}}champion{{CR}} sono presenti, vengono tutti {{ColorYellorange}}uccisi istantaneamente{{CR}} #{{IND}}{{Coin}} I nemici uccisi creano una {{ColorYellorange}}moneta temporanea"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "{{Card}} Entrando in una stanza ostile {{ColorYellorange}}inesplorata{{CR}} tenendo una {{ColorYellorange}}Scala{{CR}} ed un {{ColorYellorange}}Asso{{CR}} crea un {{ColorPink}}Pacco Arcano{{CR}} #{{Collectible128}} +2 mosche Forever Alone"
--Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{ColorYellorange}}[[VALUE1]]s{{CR}} spawn a {{ColorYellorange}}temporary {{Coin}} penny{{R}} quando attivata #!!! {{ColorGray}}(Rank changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{Coin}} Uccidere i nemici nell'{{ColorYellorange}}ordine{{CR}} indicato dalla {{Coin}} sopra di essi ricompensa con una moneta"


Descriptions.Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{Damage}} {{ColorMult}}X1.1{{CR}} Molt. di Danno giocando 2 carte con lo stesso valore {{ColorYellorange}}di fila{{CR}} #{{IND}}!!! Le {{ColorYellorange}}Carte di Pietra{{CR}} non hanno alcun effetto #{{Collectible665}} Permette di vedere i contenu di {{ColorYellorange}}casse{{CR}} e {{ColorYellorange}}sacchette"
Descriptions.Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "{{Tears}} {{ColorChips}}+4{{CR}} Lacrime ogni quarta carta giocata #{{Pill}} Ottiene {{ColorChips}}+0.4{{CR}} Lacrime ogni uso della pillola {{ColorYellorange}}Retro Vision{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.SEANCE] = "{{REG_Spectral}} Crea una {{ColorYellorange}}Busta Spettrale{{CR}} entrando in una stanza ostile {{ColorYellorange}}inesplorata{{CR}} avendo una {{ColorYellorange}}Scala Colore{{CR}} in mano #{{Collectible727}} {{ColorMint}}[[CHANCE]] possibilità su 6{{CR}} di creare una {{ColorYellorange}}Hungry Soul{{CR}} uccidendo un nemico"
Descriptions.Jimbo.Jokers[mod.Jokers.VAMPIRE] = "{{Damage}} Quando una carta {{ColorYellorange}}Potenziata{{CR}} è giocata, ottiene {{ColorMult}}X0.02{{CR}} Molt. di Danno e rimuove il {{ColorYellorange}}Potenziamento {{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Le {{ColorYellorange}}Scale{{CR}} possono contenere salti si {{ColorYellorange}}1 Valore{{CR}} #{{Collectible84}} Crea un {{ColorYellorange}}Crawl space{{CR}} in una stanza casuale di ogni piano #{{Collectible84}} Apre tutte le {{ColorYellorange}}Stanze Segrete"
Descriptions.Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "{{Damage}} Ottiene {{ColorMult}}X0.1{{CR}} Molt. di Danno quando una carta viene {{ColorYellorange}}aggiunta{{CR}} al mazzo #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"

Descriptions.Jimbo.Jokers[mod.Jokers.BARON] = "{{Damage}} I {{ColorYellorange}}Re{{CR}} tenuti in mano danno {{ColorMult}}X1.2{{CR}} Molt. di Danno entrando in una stanza ostile #{{Quality4}} {{ColorMult}}X1.25{{CR}} Molt. di Danno per oggetto Q4 avuto #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.OBELISK] = "{{Damage}} Ottiene {{ColorMult}}X0.1{{CR}} Molt. di Danno per carta giocata con un {{ColorYellorange}}Seme{{CR}} diverso dalla precedente {{ColorYellorange}}di fila{{CR}} #{{IND}}!!! Azzerato ogni stanza completata #{{IND}}!!! {{ColorYellorange}}Stone cards{{CR}} have no effect #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.MIDAS] = "{{REG_Gold}} Le {{REG_Face}} {{ColorYellorange}}Figure attivate{{CR}} diventano {{ColorYellorange}}Dorate{{CR}} #I nemici {{ColorYellorange}}Champion{{CR}} rimangono dorati per un po' quando creati"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{Shop}} {{ColorYellorange}}Vandere{{CR}} questo Jolly crea un'esplosione {{Collectible483}} Mama Mega! e {{Weakness}} indebolisce tutti i {{ColorYellorange}}Boss{{CR}} nella stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "{{Damage}} La prima {{REG_Face}} {{ColorYellorange}}Figura attivata{{CR}} della stanza dà {{ColorMult}}X1.25{{CR}} Molt. di Danno quando attivata #{{Damage}} {{ColorMult}}X1.5{{CR}} Molt. di Danno se il primo neico ucciso della stanza è un {{ColorYellorange}}Champion #{{Collectible327}} Può aprire la {{ColorYellorange}}Srange Door"
Descriptions.Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "{{Coin}} Ogni Jolly avuto ottieno {{ColorYellorange}}+1{{CR}} valore di vednita quando un Buio viene sconfitto #{{Shop}} I prezzi sono ridotti di {{ColorYellorange}}1 Moneta"
Descriptions.Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{REG_HSize}} {{ColorYellorange}}+[[VALUE1]]{{CR}} Carte in mano #{{IND}}!!! Ottiene {{ColorRed}}-1{{CR}} Carte in mano quando un Buio viene sconfitto #{{Collectible594}} Ottieni l'effetto do Jupiter"
Descriptions.Jimbo.Jokers[mod.Jokers.EROSION] = "{{Damage}} Ottiene {{ColorMult}}+0.15{{CR}} Danno ad ongi carta {{ColorYellorange}}Distrutta{{CR}} #{{Damage}} Ottiene {{ColorMult}}+0.05{{CR}} Danno per {{ColorYellorange}}Tinted Rock{{CR}} {{ColorYellorange}}Distrutta{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "{{Coin}} Le {{REG_Face}} {{ColorYellorange}}Figure{{CR}} tanute in manoo hanno {{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di creare una moneta completando una stanza #{{Coin}} Uccidendo un nemico, gli altri {{ColorYellorange}}Champion{{CR}} creano una {{ColorYellorange}}Moneta Temporanea"

Descriptions.Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "{{Coin}} {{ColorYellorange}}+2 Monete{{CR}} per {{ColorYellorange}}[[VALUE1]]{{CR}} scartato #{{Blank}} {{ColorGray}}(Valore cambia ogni stanza)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "{{Coin}} Gli {{colorYellow}}Interessi{{CR}} sono {{ColorYellorange}}Raddoppiati"
Descriptions.Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{REG_HSize}} {{ColorYellorange}}+1{{CR}} Carte in mano #\1 {{ColorYellorange}}+1{{CR}} slot consumabili"
Descriptions.Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{Heart}} {{ColorYellorange}}+1{{CR}} Health up #{{Heart}} Cura di un cuore aggiuntivo completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "{{Damage}} Ottiene {{ColorMult}}X0.02{{CR}} Molt. di Danno quando una {{ColorYellorange}}Carta Fortunata{{CR}} si attiva con {{ColorMint}}Successo{{CR}} o quando una {{Slotmachine}} Slot dà un premio #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{Damage}} {{ColorMult}}X1.25{{CR}} Molt. di Danno per Jolly {{ColorMint}}non comune{{CR}} avuto #{{Damage}} {{ColorMult}}X1.1{{CR}} Molt. di Danno per oggetto {{Quality2}} avuto #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{Shop}} {{ColorYellorange}}Vendere{{CR}} questo Jolly attiva l'effetto di {{Collectible347}} Diplopia"

Descriptions.Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "{{Shop}} {{ColorYellorange}}Vendendo{{CR}} questo Jolly, tutte le carte in mano vengono {{ColorYellorange}}Distrutte{{CR}} e danno danno {{ColorYellorange}}+2 {{Coin}} Monete"
Descriptions.Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "{{Damage}} Ottiene {{ColorMult}}+0.25{{CR}} Danno se una {{ColorYellorange}}Doppia Coppia{{CR}} è tenuta entrando in una stanza ostile #{{Damage}} {{ColorMult}}+0.1{{CR}} Danno per {{ColorYellorange}}costume{{CR}} visibile #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "#{{Damage}} Le Carte di [[VALUE1]]{{CR}} danno {{ColorMult}}X1.05{{CR}} Molt. di Danno quando attivate #{{ColorGray}}(Seme cambia ogni stanza)"
Descriptions.Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "\1 I {{ColorYellorange}}10{{CR}} e {{ColorYellorange}}4{{CR}} danno {{ColorChips}}+0.1{{CR}} Lacrime e {{ColorMult}}+0.04{{CR}} Danno quando attivati"
Descriptions.Jimbo.Jokers[mod.Jokers.SELTZER] = "{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} le prossime {{ColorYellorange}}[[VALUE1]]{{CR}} carte giocate"
Descriptions.Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{Damage}} Le {{REG_Face}} {{ColorYellorange}}Figure{{CR}} danno {{ColorMult}}+0.05{{CR}} Danno quando attivate #{{Damage}} Uccidere un {{ColorYellorange}}Champion{{CR}} dà {{ColorMult}}+0.15{{CR}} Danno #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "{{Damage}} Ottiene {{ColorMult}}X0.2{{CR}} Molt. di Danno per Jolly venduto nel {{ColorYellorange}}Piano corrente #!!! I Jolly possono essere presi anche ad inventario pieno, ma sono venduti automaticamente senza monete in cambio #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CASTLE] = "{{Tears}} Ottiene {{ColorChips}}+0.04{{CR}} Lacrime per {{ColorYellorange}}[[VALUE1]]{{CR}} scartato #{{ColorGray}}(Valore cambia ongi stanza) #{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE2]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{REG_Gold}} Le {{ColorYellorange}}Carte Dorate{{CR}} danno {{ColorYellorange}}+1 {{Coin}} Moneta{{CR}} quando attivate #{{Collectible202}} Ogni pickup ha {{ColorMint}}[[CHANCE]] probabilità su 25{{CR}} di diventare la sua variante {{ColorYellorange}}dorata"
Descriptions.Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{Damage}} Le {{ColorYellorange}}Ultime 5{{CR}} carte giocabili {{ColorMult}}X1.1{{CR}} Molt. di Danno quando attivate #{{Damage}} {{ColorMult}}X1.5{{CR}} Molt. di Danno durante le {{Boss}} bossfight #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]] {{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = '{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} le {{REG_Face}} {{ColorYellorange}}Figure{{CR}} giocate #{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} gli effetti Jolly ad "Uccisione di Champion"'
Descriptions.Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{REG_HSize}} {{ColorYellorange}}+2{{CR}} Carte in mano #{{REG_Hand}} {{ColorBlue}}-5{{CR}} carte giocabili"
Descriptions.Jimbo.Jokers[mod.Jokers.THROWBACK] = "{{Damage}} {{ColorMult}}X0.1{{CR}} Molt. di Danno per {{ColorYellorange}}Buio{{CR}} slatato questa partita #{{Damage}} {{ColorMult}}X0.02{{CR}} Molt. di Danno per {{ColorYellorange}}Stanza Speciale{{CR}} saltata questa partita #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "{{REG_Red}} Aggiunge una carta con un {{ColorYellorange}}Sigillo Casuale{{CR}} al mazzo qunado un Buio viene sconfitto #{{Collectible75}} Ottieni l'effetto do PHD"
Descriptions.Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{REG_Retrigger}} {{ColorYellorange}}Riattiva{{CR}} 3 volte la prima {{ColorYellorange}}carta{{CR}} giocata in una stanza #{{Card}} La {{ColorYellorange}}prima{{CR}} carta usata di un piano crea una copia di sè stessa qunado usata"
Descriptions.Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "{{Damage}} Ottiene {{ColorMult}}X0.2{{CR}} Molt. di Danno per {{ColorYellorange}}Carta di Vetro{{CR}} distrutta  #{{IND}}!!! {{ColorMint}}Raddioppia{{CR}} la possibilità di rottura #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorYellorange}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{ColorYellorange}}Oggetti{{CR}}, {{ColorYellorange}}Jolly{{CR}} e {{ColorYellorange}}Carte{{CR}} possono apparire molteplici volte"
Descriptions.Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{Damage}} {{ColorMult}}X2{{CR}} Molt. di Danno se ogni {{ColorYellorange}}Seme{{CR}} è tenuto in mano entrando in una stanza ostile #{{Charm}} Crea 3 fiori ammalianti nelle stanze ostili"
Descriptions.Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "{{Tears}} Ottiene {{ColorChips}}+0.04{{CR}} Lacrime quando un {{ColorYellorange}}2{{CR}} viene attivato #\1 Size down #{{Blank}} {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.OOPS_6] = "{{Luck}} Ogni {{ColorMint}}Probabilità{{CR}} è raddoppiata #{{Collectible46}} Ottieni l'effetto di Lucky Foot"
Descriptions.Jimbo.Jokers[mod.Jokers.IDOL] = "{{Damage}} [[VALUE1]]{{CR}} dà {{ColorMult}}X1.1{{CR}} Molt. di Danno quando attivato #{{ColorGray}} (Carta cambia ongi stanza) #{{Damage}} {{ColorMult}}X2{{CR}} Molt. di Danno per {{ColorYellorange}} {{Collectible[[VALUE2]]}} [[VALUE3]]{{CR}} avuto"
Descriptions.Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{Damage}} {{ColorMult}}X1.2{{CR}} Molt. di Danno se sia una carta di {{ColorClub}}Fiori{{CR}} che una {{ColorYellorange}}non di Fiori{{CR}} sono tenute entrando in una stanza ostile#{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}[[VALUE1]]{{CR}})"
Descriptions.Jimbo.Jokers[mod.Jokers.MATADOR] = "{{Coin}} {{ColorYellorange}}+4 monete{{CR}} subendo danno da un {{ColorYellorange}}Boss"
Descriptions.Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "{{Damage}} Ottiene {{ColorMult}}X0.2{{CR}} Molt. di Danno per {{ColorYellorange}}Jack{{CR}} scartato #{{IND}}!!! {{ColorYellorange}}(Azzerato ogni stanza) #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.DUO] = "{{Damage}} {{ColorMult}}X1.25{{CR}} Molt. di Danno se una {{ColorYellorange}}Coppia{{CR}} è tenuta entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIO] = "{{Damage}} {{ColorMult}}X1.5{{CR}} Molt. di Danno se un {{ColorYellorange}}Tris{{CR}} è tenuto entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.FAMILY] = "{{Damage}} {{ColorMult}}X2{{CR}} Molt. di Danno se un {{ColorYellorange}}Poker{{CR}} è tenuto entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.ORDER] = "{{Damage}} {{ColorMult}}X2.5{{CR}} Molt. di Danno se una {{ColorYellorange}}Scala{{CR}} è tenuta entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBE] = "{{Damage}} {{ColorMult}}X1.55{{CR}} Molt. di Danno se un {{ColorYellorange}}Colore{{CR}} è tenuto entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{Tears}} {{ColorMult}}+12.5{{CR}} Lacrime #{{REG_HSize}} {{ColorMult}}-2{{CR}} Carte in mano"
Descriptions.Jimbo.Jokers[mod.Jokers.SATELLITE] = "{{Coin}} {{ColorYellorange}}+1 Moneta{{CR}} per {{ColorCyan}}Carta Pianeta{{CR}} diversa usata questa partita quando un Buio viene sconfitto #(Attualmente {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Monete) #Un raggio di luce colpisce le stanze ostili entrate per ogni {{ColorCyan}}Carta Pianeta{{CR}} usata"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{Damage}} Le {{ColorYellorange}}Regine{{CR}} tenute in mano danno {{ColorMult}}+0.7{{CR}} Danno entrando in una stanza ostile"
Descriptions.Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{Damage}} {{ColorMult}}X1.5{{CR}} Molt. di Danno se si hanno almeno {{ColorYellorange}}18{{CR}} carte {{ColorYellorange}}potenziate{{CR}} nel mazzo intero #Essere trasformato in {{Adult}} Adult, {{Mom}} Mom o {{Bob}} Bob raddoppia l'effetto #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]])"
Descriptions.Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "{{Shop}} Le {{ColorCyan}}Carte Planet{{CR}}, {{ColorCyan}}Buste Celestiali{{CR}} e gli oggetti {{ColorYellorange}}Stellari{{CR}} sono gratuiti #{{Planetarium}} {{ColorYellorange}}+20%{{CR}} possibilità del planetario {{ColorGray}}(Dimezzata per ogni planetario visitato) #{{Planetarium}} I Planetari possono apparire in ogni piano normale"
Descriptions.Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "\1 Potenzia il {{ColorCyan}}livello{{CR}} delle carte {{ColorYellorange}}scartate{{CR}} che colpiscono un nemico"
Descriptions.Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{Damage}} {{ColorMult}}+0.05{{CR}} Danno per ogni {{ColorYellorange}}5 {{Coin}} Monete{{CR}} avute #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Danno) #Ottieni {{ColorYellorange}}Danno da contatto{{CR}} uguale al numero di monete avute"

Descriptions.Jimbo.Jokers[mod.Jokers.CANIO] = "{{Damage}} Ottiene {{ColorMult}}X0.25{{CR}} Molt. di Danno quandu una {{REG_Face}} {{ColorYellorange}}Figura{{CR}} viene {{ColorYellorange}}Distrutta #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{CR}} Molt. di Danno) #{{DeathMark}} I nemici {{ColorYellorange}}Champion{{CR}} vengono uccisi immediatamente"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{Damage}} I {{ColorYellorange}}Re{{CR}} e le {{ColorYellorange}}Regine{{CR}} danno {{ColorMult}}X1.2{{CR}} Molt. di Danno quando attivati"
Descriptions.Jimbo.Jokers[mod.Jokers.YORICK] = "{{Damage}} Ottiene {{ColorMult}}X0.25{{CR}} Molt. di Danno ogni {{ColorYellorange}}23{{CR}} carte scartate #{{Blank}} {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHICOT] = "{{Weakness}} Ogni {{ColorYellorange}}Boss{{CR}} permanentemente indebolito #Rimuove ogni maledizione"
Descriptions.Jimbo.Jokers[mod.Jokers.PERKEO] = "{{Card}} Crea una copia di ogni {{ColorYellorange}}Consumabile{{CR}} quando un {{ColorYellorange}}Buio{{CR}} viene sconfitto"

Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "Dopo essere giocate, le cards vengono cambiate {{ColorYellorange}}casualmente{{CR}} #{{IND}}!!! {{ColorGray}}(La nuova carta generata dipende da quella di partenza)"

end

Descriptions.JokerSynergies = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE] = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_PHD] = "Le carte aggiunte hanno anche un'{{ColorYellorange}}Edizione{{CR}} garantita"
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_FALSE_PHD] = "Le carte aggiunte hanno anche un {{ColorYellorange}}Potenziamento{{CR}} garantito"

Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_SMALL_ROCK] = "Le carte aggiunte hanno anche un {{ColorYellorange}}Sigillo{{CR}} garantito"
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = "Le carte aggiunte hanno anche un'{{ColorYellorange}}Edizione{{CR}} garantita"

Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY] = {}
Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY][CollectibleType.COLLECTIBLE_CHAOS] = "Le carte generate avranno un {{ColorYellorange}}Potenziamento{{CR}}, {{ColorYellorange}}Sigillo{{CR}} o {{ColorYellorange}}Edizione{{CR}} se la carta di partenza ne aveva"

Descriptions.JokerSynergies[mod.Jokers._8_BALL] = {}
Descriptions.JokerSynergies[mod.Jokers._8_BALL][CollectibleType.COLLECTIBLE_MAGIC_8_BALL] = "{{ColorMint}}Probabilità{{CR}} raddoppiata!"

Descriptions.JokerSynergies[mod.Jokers.MISPRINT] = {}
Descriptions.JokerSynergies[mod.Jokers.MISPRINT][CollectibleType.COLLECTIBLE_TMTRAINER] = "Il danno dato è compreso tra {{ColorMult}}-0.5{{CR}} e {{ColorMult}}+2.5"

Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD] = {}
Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD][CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "{{REG_Spade}} L'effetto di ammaliamento dei {{ColorSpade}}Picche{{CR}} diventa garantito"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER] = "{{Coin}} Dà anche 2 {{ColorYellorange}}Monete dorate{{CR}} quando vednuto in questo modo"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_TICKET] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_TICKET][CollectibleType.COLLECTIBLE_SMELTER] = Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER]

Descriptions.JokerSynergies[mod.Jokers.CREDIT_CARD] = {}
Descriptions.JokerSynergies[mod.Jokers.CREDIT_CARD][CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "{{Coin}} Essere in debito conta come avere la metà delle monete massime #{{Colorgray}} (Non è un bug, ma una peculiarità ;) )" --ye ok it's actually a bug

Descriptions.JokerSynergies[mod.Jokers.SOCK_BUSKIN] = {}
Descriptions.JokerSynergies[mod.Jokers.SOCK_BUSKIN][mod.Collectibles.TRAGICOMEDY] = "Entrambe le maschere sono sempre attive"


--inverts the table to make collectible synergy descriptions lookup faster
Descriptions.ItemJokerSynergies = {}
for Joker,JokerSynergies in pairs(Descriptions.JokerSynergies) do
    
    for Item, SynString in pairs(JokerSynergies) do
        
        Descriptions.ItemJokerSynergies[Item] = Descriptions.ItemJokerSynergies[Item] or {}
        Descriptions.ItemJokerSynergies[Item][Joker] = SynString
    end
end


Descriptions.JimboSynergies = {}
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE] = "#{{REG_Jimbo}} Le carte sparano 1 brimstone in una direzione casule quando colpiscono un nemico #{{IND}} I brimstone infliggono il 50% del danno della carta #{{IND}}{{REG_Spade}} I {{ColorSpade}}Picche{{CR}} sparando un brim. aggiuntivo #\2 +50% Tempo di ricarica carte #{{REG_Spade}} Le carte in mano diventano di {{ColorSpade}}Picche{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "#{{REG_Jimbo}} Le carte sparano 1 laser in una direzione casuale qunado colpiscono una nemico #{{IND}} I laser infliggono il 50% del danno della carta #{{IND}}{{REG_Heart}} I {{ColorMult}}Cuori{{CR}} sparano un laser aggiuntivo"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DR_FETUS] = "#{{REG_Jimbo}} Le carte rilasciano una bomba quando colpiscono un nemico #{{IND}} le bombe infliggono il 100% del Danno della carta e mantangono i modificatori del giocatore #{{IND}}{{REG_Club}} Le bombe di {{ColorChips}}Fiori{{CR}} hanno raggio e danno maggiori #{{REG_Club}} Le carte in mano diventano di {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SMELTER] = "#{{REG_Jimbo}} Permette di vendere un Jolly per il doppio de valore normale #{{Blank}}(usato automaticamente vendendo se carico)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_BOX] = "#{{REG_Jimbo}} Richiede {{Battery}} 12 cariche #{{REG_Jimbo}} Ottiene 2 cariche attivando una {{RestockMachine}} Restock machine"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DOLLAR] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Diamond}} {{ColorYellorange}}Quadri"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYRO] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Club}} {{ColorChips}}Fiori"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SKELETON_KEY] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Spade}} {{ColorSpade}}Picche"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BINGE_EATER] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Heart}} {{ColorMult}}Cuori"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEART] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Heart}} {{ColorMult}}Cuori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_QUARTER] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOOM] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}}{{ColorChips}}Fiori{{CR}}quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GLITTER_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}}{{ColorChips}}Fiori{{CR}}quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOMBER_BOY] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HOT_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BUTT_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_NANCY_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCATTER_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Heart}} {{ColorMult}}Cuori{{CR}} quando preso #I {{REG_Heart}} {{ColorMult}}Cuori{{CR}} sono considerati anche come {{REG_Club}} {{ColorChips}}Fiori{{CR}} "
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FAST_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOBBY_BOMB] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SAD_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GHOST_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STICKY_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARP_KEY] = "#{{REG_Jimbo}} Le carte di {{REG_Spade}} {{ColorSpade}}Picche{{CR}} possono aprire le porte #{{REG_Spade}} Le carte in mano diventano di {{ColorSpade}}Picche{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_C_SECTION] = "#{{REG_Jimbo}} Le carte sparano un feto quando atterrano #{{IND}}{{REG_Heart}} Le carte di {{ColorMult}}Cuori{{CR}} sparano un fato in più #{{REG_Heart}} Le carte in mano diventano di {{ColorMult}}Cuori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECH_X] = "#{{REG_Jimbo}} Le carte sono circondate da un cerchio di laser che infligge il 50% del suo danno"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "#{{REG_Jimbo}} Le carte diventano spettrali e perforanti, infliggendo il 30% del loro danno ogni tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TRISAGION] = "#{{REG_Jimbo}} Le carte diventano perforanti, infliggendo il 20% del loro danno ogni tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "#{{REG_Jimbo}} La spada è applicata assieme allo sparare carte"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALLOWED_GROUND] = "#{{REG_Jimbo}} le carte giocate vengono {{REG_Retrigger}} {{ColorYellorange}}Riattivate{{CR}} mentre si è all'interno dell'aura"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM] = "#{{REG_Jimbo}} le carte giocate vengono {{REG_Retrigger}} {{ColorYellorange}}Riattivate{{CR}} mentre si è all'interno dell'aura"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_POUND_OF_FLESH] = "#{{REG_Jimbo}} {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} e {{REG_Heart}} {{ColorMult}}Cuori{{CR}} sono considerati come lo stesso seme"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TMTRAINER] = "#{{REG_Jimbo}} Tutte le carte del mazzo vengono cambiate casualmente"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "#{{REG_Jimbo}} Le carte di {{REG_Spade}} {{ColorSpade}}Picche{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di {{Charm}} ammaliare i nemici"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALO] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} Ottengono una aura come {{Collectible331}} God Head #{{REG_Diamond}} Le carte in mano diventano {{ColorYellorange}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} danno {{ColorMult}}+0.01{{CR}} Danno per ogni {{ColoraYellorange}}5{{CR}} monete avute quando attivate"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE] = "#{{REG_Jimbo}} Le Lacrime date dai {{REG_Bonus}} {{ColorYellorange}}Potenziamenti Bonus{{CR}} sono raddoppiate"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SOUL] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCAPULAR] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_KEEPERS_KIN] = "#{{REG_Jimbo}} Quando atterrano, le {{REG_Stone}} {{ColorYellorange}}Carte di Pietra{{CR}} creano 1-3 {{ColorYellorange}}Ragni blu"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = "#{{REG_Jimbo}} Dà l'effetto del {{Collectible"..mod.Vouchers.Crystal.."}} Voucher Palla di Cristallo mentre tenuto"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "#{{REG_Jimbo}} Le carte non scompaiono bloccando i proiettili #{{ColorGray}} (Lacrime seme non incluse)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYROMANIAC] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{ColorChips}}Fiori{{CR}} qunado preso # {{REG_Club}} {{ColorChips}}Fiori{{CR}} e {{REG_Heart}} {{ColorMult}}Cuori{{CR}} sono considerati come lo stesso seme"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOGO_BOMBS] = "#{{REG_Jimbo}} Le carte di {{REG_Club}} {{ColorChips}}Fiori{{CR}} aggiunte al mazzo sono raddoppiate"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_IRON_BAR] = "#{{REG_Jimbo}} Le {{REG_Steel}} {{ColorYellorange}}Carte d'Acciaio{{CR}} causano {{Confusion}} Confusione"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "#{{REG_Jimbo}} Le {{REG_Gold}} {{ColorYellorange}}Carte Dorate{{CR}} trasformano i nemici colpiti in statue d'oro"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = "#{{REG_Jimbo}} Le carte in mano diventano {{REG_Wild}} {{ColorYellorange}}Carte Multiuso{{CR}} quando preso #{{Blank}} {{ColorGray}}(non sovrascrive potenziamenti esistenti) #{{REG_Wild}} Le {{ColorYellorange}}Carte Multiuso{{CR}} ottengono effetti casuali aggiuntivi"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = "#{{REG_Jimbo}} I {{REG_Yellorange}}3{{CR}} lanciati ottengono 3 effetti casuali aggiuntivi"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GODHEAD] = "#{{REG_Jimbo}} Tutti le carte puramente di {{REG_Spade}} {{ColorSpade}}Picche{{CR}} nel mazzo vengono distrutte quando preso #{{REG_Wild}} Le altre carte diventano {{ColorYellorange}}Carte Multiuso #{{Blank}} {{ColorGray}}(non sovrascrive potenziamenti esistenti)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO] = "#{{REG_Jimbo}} La carte di {{REG_Club}} {{ColorChips}}Fiori{{CR}} esplodono sempre"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FIRE_MIND] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} creano una moneta temporanes quando colpiscono un nemico #{{REG_Jimbo}} Le carte in mano diventano di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARD_OF_GLASS] = "#{{REG_Jimbo}} Le {{REG_Glass}} {{ColorYellorange}}Carte di Vetro{{CR}} hanno l'effetto di {{Collectible506}} Backstabber e causano {{BleedingOut}} sanguinamento #{{REG_Jimbo}} Le carte in mano diventano {{REG_Glass}} {{ColorYellorange}}Carte di Vetro{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EYE_OF_GREED] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} rendono i nemici delle statue dorate #{{REG_Jimbo}} Le carte in mano diventano di {{REG_Diamond}} {{ColorYellorange}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MAGIC_SKIN] = "#{{REG_Jimbo}} {{ColorYellorange}}USO SINGOLO #{{REG_Jimbo}} Crea anche 2 {{REG_Joker}} Jolly"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DEEP_POCKETS] = "#{{REG_Jimbo}} Limite massimo aumentato a 9999"
Descriptions.JimboSynergies[mod.Collectibles.POCKET_ACES] = "#{{REG_Jimbo}} Aggiunge 2 Assi con {{ColorYellorange}}Potenziamento{{CR}}, {{ColorYellorange}}Sigillo{{CR}} ed {{ColorYellorange}}Edizione{{CR}} garantiti al mazzo quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HYPERCOAGULATION] = "#{{REG_Jimbo}} Le carte di {{REG_Heart}} {{ColorMult}}Cuori{{CR}} cards ottengono l'effetto di {{Collectible224}} Cricket's body"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CANDY_HEART] = "#{{REG_Jimbo}} Le carte di {{REG_Heart}} {{ColorMult}}Cuori{{CR}} aggiunte ottengono un {{ColorYellorange}}Potenziamento{{CR}} casuale se non avevano uno"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON] = "#{{REG_Jimbo}} Il danno dato dai {{REG_Mult}} {{ColorYellorange}}Potensiamenti Molt{{CR}} è raddoppiato"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_ABADDON] = "#{{REG_Jimbo}} Le carte di {{REG_Spade}} {{ColorSpade}}Picche{{CR}} infliggono 10% di danno aggiuntivo"


mod.EVIL_ITEMS = {CollectibleType.COLLECTIBLE_ABADDON,
                  CollectibleType.COLLECTIBLE_BLACK_CANDLE,
                  CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES,
                  CollectibleType.COLLECTIBLE_GOAT_HEAD,
                  CollectibleType.COLLECTIBLE_BLACK_CANDLE,
                  CollectibleType.COLLECTIBLE_MATCH_BOOK,
                  CollectibleType.COLLECTIBLE_MISSING_NO,
                  CollectibleType.COLLECTIBLE_FALSE_PHD,
                  CollectibleType.COLLECTIBLE_SAFETY_PIN}
for _,v in ipairs(mod.EVIL_ITEMS) do
    Descriptions.JimboSynergies[v] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_ABADDON]
end



Descriptions.T_Jimbo.Enhancement = {}
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.BONUS] = "# {{ColorChips}}+30{{CR}} Fiches"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.MULT]  = "# {{ColorMult}}+4{{CR}} Molt"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# {{ColorYellorange}}+3${{CR}} se tenuta in mano alla fine del round"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GLASS] = "# {{ColorMult}}X2{{CR}} Molt # {{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di rompersi quando giocata"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{ColorMint}}[[CHANCE]] possibilità su 5{{CR}} di {{ColorMult}}+20{{CR}} Molt #{{ColorMint}}[[CHANCE]] probabilità su 20{{CR}} di {{ColorYellorange}}+20$"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STEEL] = "# {{ColorMult}}X1.5{{CR}} Molt quando tenuta in mano"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.WILD]  = "# Considerata come di ogni {{ColorYellorange}}Seme"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STONE] = "#{{ColorChips}}+50{{CR}} Fiches #Non ha un {{ColorYellorange}}Valore{{CR}} o {{ColorYellorange}}Seme"



Descriptions.T_Jimbo.Seal = {}
Descriptions.T_Jimbo.Seal[mod.Seals.NONE] = ""
Descriptions.T_Jimbo.Seal[mod.Seals.RED] = "# {{ColorYellorange}}Riattivata{{CR}} una volta"
Descriptions.T_Jimbo.Seal[mod.Seals.BLUE] = "# Crea il {{ColorCyan}}Planet{{CR}} della mano {{ColorYellorange}}vincente{{CR}} se tenuta in mano"
Descriptions.T_Jimbo.Seal[mod.Seals.GOLDEN] = "# Guadagni {{ColorYellorange}}1$"
Descriptions.T_Jimbo.Seal[mod.Seals.PURPLE] = "# Crea un {{ColorPink}}Tarocco{{CR}} quando {{ColorRed}}Scartata"


Descriptions.T_Jimbo.Edition = {}
Descriptions.T_Jimbo.Edition[mod.Edition.BASE] = ""
Descriptions.T_Jimbo.Edition[mod.Edition.FOIL] = "#{{ColorChips}}+50{{CR}} Fiches"
Descriptions.T_Jimbo.Edition[mod.Edition.HOLOGRAPHIC] = "#{{ColorMult}}+10{{CR}} Molt"
Descriptions.T_Jimbo.Edition[mod.Edition.POLYCROME] = "#{{ColorMult}}X1.5{{CR}} Molt"
Descriptions.T_Jimbo.Edition[mod.Edition.NEGATIVE] = "#{{ColorYellorange}}+1{{CR}} Slot Jolly"
Descriptions.T_Jimbo.ConsumableNEGATIVE = "#{{ColorYellorange}}+1{{CR}} Slot Consumabili"
Descriptions.T_Jimbo.CardNEGATIVE = "#{{ColorYellorange}}+1{{CR}} Carte in mano"


Descriptions.T_Jimbo.SkipName = {}
Descriptions.T_Jimbo.SkipName[mod.SkipTags.BOSS] = "Patto Boss"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.BUFFON] = "Patto Buffone"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.CHARM] = "Patto Magico"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.COUPON] = "Patto Coupon"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.D6] = "Patto D6"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.DOUBLE] = "Patto Doppio"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.ECONOMY] = "Patto Economia"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.ETHEREAL] = "Patto Etereo"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.FOIL] = "Patto Foil"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.GARBAGE] = "Patto Spazzatura"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.HANDY] = "Patto Manesco"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.HOLO] = "Patto Olografico"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.INVESTMENT] = "Patto Investimento"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.JUGGLE] = "Patto Giocoliere"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.METEOR] = "Patto Meteora"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.NEGATIVE] = "Patto Negativo"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.ORBITAL] = "Patto Orbitale"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.POLYCHROME] = "Patto Policroma"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.RARE] = "Patto Raro"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.SPEED] = "Patto Veloce"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.STANDARD] = "Patto Standard"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.TOP_UP] = "Patto Ricarica"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.UNCOMMON] = "Patto Non comune"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.VOUCHER] = "Patto Buoni"
Descriptions.T_Jimbo.SkipName[mod.SpecialSkipTags.KEY_PIECE_1] = "Patto Uriel"
Descriptions.T_Jimbo.SkipName[mod.SpecialSkipTags.KEY_PIECE_2] = "Patto Gabriel"



Descriptions.T_Jimbo.SkipTag = {}
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BOSS] = "Cambia il {{ColorYellorange}}Buio Boss{{CR}} dell'ante"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BUFFON] = "Apri una {{ColorYellorange}}Busta Buffone Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.CHARM] = "Apri una {{ColorYellorange}}Busta Arcana Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.COUPON] = "Le carte e buste iniziali del prssimo negozio sono {{ColorYellorange}}Gratuite"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.D6] = "Il costo dei cambi inizia a {{ColorYellorange}}0$"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.DOUBLE] = "Duplica il prossimo patto ottenuto #{{ColorGray}}(Patto Doppio escluso)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ECONOMY] = "raddoppia i soldi avuti #{{ColorGray}}(Max 40$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ETHEREAL] = "Apri una {{ColorYellorange}}Busta Spettrale"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.FOIL] = "Il prossimo negozio ha un Jolly {{ColorChips}}Foil{{CR}} gratutito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.GARBAGE] = "Guadagna {{ColorYellorange}}1${{CR}} per {{ColorMult}}scarto{{CR}} sprecato #{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HANDY] = "Guadagna {{ColorYellorange}}1${{CR}} per {{ColorChips}}mano{{ColorGray}} giocata #([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HOLO] = "Il prossimo negozio ha un Jolly {{ColorMult}}Olografico{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.INVESTMENT] = "Guadagna {{ColorYellorange}}25${{CR}} dopo aver sconfitto il prossimo {{ColorYellorange}}Buio Boss"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.JUGGLE] = "{{ColorYellorange}}+3{{CR}} carte in mano per il prossimo Buio"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.METEOR] = "Apri una {{ColorYellorange}}Busta Celestiale Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.NEGATIVE] = "Il prossimo negozio ha un Jolly {{ColorBlack}}Negativo{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ORBITAL] = "Potenzia {{ColorYellorange}}[[VALUE1]]{{CR}} di 3 livelli"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.POLYCHROME] = "Il prossimo negozio ha un Jolly {{ColorRainbow}}Policroma{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.RARE] = "Il prossimo negozio ha un Jolly {{ColorMult}}Raro{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.SPEED] = "Guadagna {{ColorYellorange}}5${{CR}} per Buio saltato #{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.STANDARD] = "Apri una {{ColorYellorange}}Busta Standard Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.TOP_UP] = "Crea fino a {{ColorYellorange}}2{{CR}} Jolly {{ColorChips}}Comuni"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.UNCOMMON] = "Il prossimo negozio ha un Jolly {{ColorLime}}Non comunq{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.VOUCHER] = "Il prossimo negozio ha un {{ColorYellorange}}Buono{{CR}} aggiuntivo"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_1] = "Ottieni {{ColorYellorange}}10${{CR}} e il {{ColorYellorange}}Key Piece 1"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_2] = "Ottieni {{ColorYellorange}}10${{CR}} e il {{ColorYellorange}}Key Piece 2"


Descriptions.T_Jimbo.Jokers = {}
do
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER] = "{{ColorMult}}+4{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BULL] = "{{ColorChips}}+2{{CR}} Fiches per {{ColorYellorange}}1${{CR}} avuto # {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Dopo {{ColorYellorange}}2{{CR}} round, vendere questo Jolly {{ColorYellorange}}Duplica{{CR}} duplica un'altro Jolly avuto {{ColorGray}}[[VALUE2]]#(Attualmente [[VALUE1]])"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{ColorMult}}+3{{CR}} Molt per Jolly # {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MISPRINT] = " {{ColorMult}}+0-23{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{ColorMult}}X1{{CR}} Molt per slot Jolly vuoto #{{ColorGray}}(Forma di Jolly inclusa) #{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STONE_JOKER] = " {{ColorChips}}+25{{CR}} Fiches per {{ColorYellorange}}Carta di Pietra{{CR}} nel tuo {{ColorYellorange}}mazzo intero #{{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ICECREAM] = " {{ColorChips}}+[[VALUE1]]{{CR}} Fiches#Perde {{ColorChips}}-5{{CR}} Fiches ogni mano giocata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.POPCORN] = " {{ColorMult}}+[[VALUE1]]{{CR}} Molt #Perde {{ColorMult}}-4{{CR}} Molt ogni round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAMEN] = " {{ColorMult}}X[[VALUE1]]{{CR}} Molt#Perde {{ColorMult}}-0.01X{{CR}} ogni carta scartata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROCKET] = "Guadagna {{ColorYellorange}}[[VALUE1]]${{CR}} at the end of round#Payout increases by {{ColorYellorange}}2${{CR}} when a boss blind is defeated"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ODDTODD] = "Le carte con valore {{ColorYellorange}}dispari{{CR}} danno {{ColorChips}}+31{{CR}} Fiches quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "Le carte con valore {{ColorYellorange}}pari{{CR}} danno {{ColorChips}}+4{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} to create a{{ColorPink}}Tarot{{CR}} card when opening a {{ColorYellorange}}Busta di Espansione"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "Ottiene {{ColorMult}}+1{{CR}} Molt ongi mano giocata#{{ColorMult}}-1{{CR}} Molt ogni scarto usato #{{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RED_CARD] = "Ottiene {{ColorMult}}+3{{CR}} Molt ogni {{ColorYellorange}}Busta di Espansione{{CR}} saltata #{{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAGABOND] = "Crea un {{ColorPink}}Tarocco{{CR}} giocando una mano avendo {{ColorYellorange}}4${{CR}} o meno"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "Quando un {{ColorYellorange}}Buio{{CR}} viene selezionato, crea fino a 2 Jolly {{ColorChips}}comuni"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Guadagna {{ColorYellorange}}4${{CR}} alla fine del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{ColorMult}}+1{{CR}} Molt per {{ColorPink}}Tarocco{{CR}} usato questa partita #{{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "Copia l'effetto del {{ColorYellorange}}Jolly{{CR}} alla sua destra #{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "Copia l'effetto del {{ColorYellorange}}Jolly{{CR}} più a sinistra #{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MADNESS] = "Quando un {{ColorYellorange}}Piccolo{{CR}} o {{ColorYellorange}}Grande Buio{{CR}} viene selezionato, distrugge un altro Jolly e ottiene {{ColorMult}}X0.5{{CR}} Molt# {{ColorMult}}(Attualmente X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MR_BONES] = "{{ColorMult}}Previene la morte{{CR}} e si {{ColorYellorange}}autodistrugge{{CR}} se il nemico con più HP non supera il {{ColorYellorange}}75% del punteggio base del buio"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "Le carte di {{ColorChips}}Fiori{{CR}} danno {{ColorMult}}+7{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "Le carte di {{ColorSpade}}Picche{{CR}} danno {{ColorChips}}+50{{CR}} Fiches quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "Le carte di {{ColorMult}}Cuori{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di {{ColorMult}}X1.5{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "Le carte di {{ColorYellorange}}Quadri{{CR}} danno {{ColorYellorange}}+1${{CR}} quando attivate"

Descriptions.T_Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{ColorMult}}+15{{CR}}Molt #{{ColorMint}}[[CHANCE]] probabilità su 6{{CR}} of getting destoroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAVENDISH] = " {{ColorMult}}X3{{CR}}Molt # {{ColorMint}}[[CHANCE]] probabilità su 1000{{CR}} of getting destroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "Ottiene {{ColorMult}}+2{{CR}} Molt ogni {{ColorMint}}Cambio{{CR}} del {{ColorYellorange}}Negozio #{{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Quando un {{ColorYellorange}}buio{{CR}} viene selezionato, distrugge il Jolly alla sua destra e guadagna {{ColorMult}}+2 volte il suo valore di vendita{{CR}} Molt #{{ColorGrey}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "Guadagna {{ColorYellorange}}1${{CR}} per ogni {{ColorYellorange}}9{{CR}} nel tuo {{ColorYellorange}}mazzo intero{{CR}} alla fine del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "Aggiunge il valore di {{ColorYellorange}}vendita{{CR}} degli altri Jolly a {{ColotMult}}Molt# {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "Quando un {{ColorYellorange}}buio{{CR}} viene selezionato, crea un {{ColorPink}}Tarocco"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{ColorMult}}X4{{CR}} Molt ogni {{ColorYellorange}}6{{CR}} mani giocate # {{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "Aggiunge il numero di volte che la {{ColorYellorange}}Mano di Poker{{CR}} è stata giocata a {{ColorMult}}Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "Guadagna {{ColorYellorange}}2${{CR}} per ogni {{ColorMult}}Scarto{{CR}} rimasto se non ne sono stati usati alla fine del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EGG] = "Il valore di vendita di questo Jolly aumenta di {{ColorYellorange}}3${{CR}} ogni {{ColorYellorange}}buio{{CR}} sconfitto"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DNA] = "Se la {{ColorYellorange}}prima mano{{CR}} del round contiene solo {{ColorYellorange}}1{{CR}} carta, aggiungine una copia al {{ColorYellorange}}Mazzo{{CR}} e pescala in mano#{{ColorGray}}[[VALUE1]]"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{ColorMult}}Cuori{{CR}} e {{ColorYellorange}}Quadri{{CR}} sono considerati lo stesso seme#{{ColorSpade}}Picche{{CR}} e {{ColorBlue}}Fiori{{CR}} sono considerati lo stesso seme"

---CONTROLLA 


Descriptions.T_Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{ColorChips}}+50{{CR}} Fiches se la mano giocata contiene una {{ColorYellorange}}Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{ColorChips}}+100{{CR}} Fiches se la mano giocata contiene un {{ColorYellorange}}Tris"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{ColorChips}}+80{{CR}} Fiches se la mano giocata contiene una {{ColorYellorange}}Doppia Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{ColorChips}}+100{{CR}} Fiches se la mano giocata contiene una {{ColorYellorange}}Scala"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{ColorChips}}+80{{CR}} Fiches se la mano giocata contiene un {{ColorYellorange}}Colore"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{ColorMult}}+8{{CR}} Molt se la mano giocata contiene una {{ColorYellorange}}Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{ColorMult}}+12{{CR}} Molt se la mano giocata contiene un {{ColorYellorange}}Tris"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{ColorMult}}+10{{CR}}Molt se la mano giocata contiene una {{ColorYellorange}}Doppia Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{ColorMult}}+12{{CR}} Molt se la mano giocata contiene una {{ColorYellorange}}Scala"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{ColorMult}}+10{{CR}} Molt se la mano giocata contiene un {{ColorYellorange}}Colore"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MIME] = "{{ColorYellorange}}Riattiva{{CR}} le abilità {{ColorYellorange}}tenute in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "I {{ColorYellorange}}Colori{{CR}} e {{ColorYellorange}}Scale{{CR}} richiedono solo 4 carte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "Le carte di {{ColorMult}}Cuori{{CR}} danno {{ColorMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "Le carte di {{ColorYellorange}}Quadri{{CR}} danno {{ColorMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "Le carte di {{ColorSpade}}Picche{{CR}} danno {{ColorMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "Le carte di {{ColorChips}}Fiori{{CR}} danno {{ColorMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{ColorYellorange}}+3{{CR}} scarti #{{ColorMult}}-1{{CR}} Carte in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{ColorMult}}+20{{CR}} Molt se la mano giocata ha fino a {{ColorYellorange}}3{{CR}} carte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Puoi comprare oggetti fino a {{ColorMult}}-20${{CR}} in debito #{{ColorGray}}(effetto cumulabile)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BANNER] = "{{ColorChips}}+30{{CR}} Fiches per {{ColorYellorange}}Scarto{{CR}} rimenente"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{ColorMult}}+15{{CR}} molt when with {{ColorYellorange}}0{{CR}} discards remaining"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "Quando un {{ColorYellorange}}buio{{CR}} viene selezionato, aggiunge una {{ColorYellorange}}Carta di Pietra{{CR}} al mazzo"
Descriptions.T_Jimbo.Jokers[mod.Jokers._8_BALL] = "Gli {{ColorYellorange}}8{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di creare un {{ColorPink}}Tarocco{{CR}} qunado attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUSK] = "{{ColorYellorange}}Riattiva{{CR}} l'ultima mano del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "Aggiunge il {{ColorYellorange}}doppio{{CR}} del valore {{ColorYellorange}}minore{{CR}} tenuto in mano a {{ColorMult}}Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{ColorYellorange}}1 {{ColorMint}}Cambio{{CR}} gratutio per negozio"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FIBONACCI] = "Ogni {{ColorYellorange}}Asso{{CR}}, {{ColorYellorange}}2{{CR}}, {{ColorYellorange}}3{{CR}}, {{ColorYellorange}}5{{CR}} e {{ColorYellorange}}8{{CR}} dà {{ColorMult}}+8{{CR}} Molt quando attivato"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "Ottiene {{ColorMult}}X0.2{{CR}} Molt per ogni {{ColorYellorange}}Carta d'Acciaio{{CR}} nel tuo mazzo intero"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "Le {{ColorYellorange}}Figure{{CR}} danno {{ColorChips}}+30{{CR}} Fiches quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HACK] = "Riattiva i {{ColorYellorange}}2, 3, 4 e 5{{CR}} giocati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Ogni carta è considerata come una {{ColorYellorange}}Fiugra"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SCHOLAR] = "Gli {{ColorYellorange}}Assi{{CR}} danno {{ColorMult}}+4{{CR}} Molt e {{ColorChips}}+20{{CR}} Fiches quando attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "Le {{ColorYellorange}}Figure{{CR}} hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di dare {{ColorYellorange}}+2${{CR}} quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{ColorMult}}+1{{CR}} Molt per mano giocata senza una {{ColorYellorange}}Figura attivata#{{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{CR}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di potenziare la {{ColorYellorange}}Mano di POker{{CR}} giocata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURGLAR] = "All'inizio del round, perdi tutti gli {{ColorMult}}Scarti{{CR}} e ottieni {{ColorChips}}+3{{CR}} mani"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{ColorMult}}X3{{CR}} Molt se tutte le carte in mano sono di {{ColorSpade}}Picche{{CR}} o {{ColorChips}}Fiori"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RUNNER] = "Ottiene {{ColorChips}}+15{{CR}} Fiches se la mano giocata contiene una {{ColorYellorange}}Scala#{{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPLASH] = "Tutte le {{ColorYellorange}}carte giocate{{CR}} assegnano punti"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{ColorChips}}+2{{CR}} Fiches per carta rimanente nel mazzo # {{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}}Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "Se la {{ColorYellorange}}prima{{CR}}mano giocata è un singolo {{ColorYellorange}}6{{CR}}, distruggilo e crea una carta {{ColorBlue}}Spettrale"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "Ottiene {{ColorMult}}X0.1{{CR}} Molt ogni volta che un {{ColorCyan}}Pianeta{{CR}} viene usato#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIKER] = "Le carte ottengono {{ColorChips}}+5{{CR}} Fiches permanenti quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FACELESS] = "Guadagna {{ColorYellorange}}5${{CR}} se uno scarto contiene almeno {{ColorYellorange}}3 Figure"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "Crea un {{ColorPink}}Tarocco{{CR}} se la mano giocata contiene una {{ColorYellorange}}Scala{{CR}} e un {{ColorYellorange}}Asso"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "Guadagna {{ColorYellorange}}4${{CR}} se la mano giocata è {{ColorYellorange}}[[VALUE1]]{{CR}}#(mano cambia ogni round)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{ColorChips}}X3{{CR}} Molt se la {{ColorYellorange}}Mano di Poker{{CR}} era già stata giocata questo round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "Ottiene {{ColorChips}}+4{{CR}} Fiches se la mano giocata contiene esattamente {{ColorYellorange}}4{{CR}} carte#{{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEANCE] = "crea una carta {{ColorYellorange}}Spettrale{{CR}} quando una {{ColorYellorange}}Scala Reale{{CR}} viene giocata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAMPIRE] = "Quando una carta {{ColorYellorange}}Potenziata{{CR}} viene attivata, ottiene {{ColorChips}}X0.1{{CR}} Molt e rimuove il {{ColorYellorange}}Potenziamento{{CR}}#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Le {{ColorYellorange}}Scale{{CR}} possono avere salti di {{ColorYellorange}}1 rank"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "Ottiene {{ColorMult}}X0.25{{CR}} Molt quando una carta viene {{ColorYellorange}}aggiunta{{CR}} al mazzo#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}}Molt)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BARON] = "I {{ColorYellorange}}King{{CR}} tenuti in mano danno {{ColorMult}}X1.5{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OBELISK] = "Ottiene {{ColorMult}}X0.2{{CR}} Molt per mano {{ColorYellorange}}consecutiva{{CR}} giocata senza giocare la tua {{ColorYellorange}}mano di poker{{CR}} più giocata#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MIDAS] = "Le {{ColorYellorange}}Figure{{CR}} che assegnano punti diventano {{ColorYellorange}}Carte Dorate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{ColorYellorange}}Vendere{{CR}} questo Jolly disabilita il {{ColorYellorange}}Boss{{CR}} attuale"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "La prima {{ColorYellorange}}Figura{{CR}} ad assegnare punti dà {{ColorMult}}X2{{CR}} Molt quando attivata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "Ogni Jolly e consumabile avuto ottiene {{ColorYellorange}}+1${{CR}} valore di vendta a fine round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{ColorCyan}}+[[VALUE1]]{{CR}} Carte in mano #Perde {{ColorMult}}-1{{CR}} carte in mano ogni round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EROSION] = "{{ColorChips}}+4{{CR}} Molt per carta sotto {{ColorYellorange}}52{{CR}} nel tuo {{ColorYellorange}}mazzo intero# {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "Le {{ColorYellorange}}Figure{{CR}} tenute in mano hanno {{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di dare {{ColorYellorange}}1$"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "Guadagna {{ColorYellorange}}5${{CR}} per ogni {{ColorYellorange}}[[VALUE1]]{{CR}} scartato #(Valore cambia ogni round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "Guadagna {{ColorYellorange}}1${{CR}} aggiuntivo per ogni {{ColorYellorange}}5${{CR}} avuti come interesse"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{ColorYellorange}}+1{{CR}} Carte in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{ColorMult}}+1{{CR}} scato"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "Ottiene {{ColorMult}}X0.25{{CR}} Molt per attivazione con {{ColorMint}}successo{{CR}} di una {{ColorYellorange}}Carta Fourtunata#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BASEBALL] = "I Jolly {{ColorMint}}Non comuni{{CR}} danno {{ColorMult}}X1.5{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{ColorYellorange}}Vednere{{CR}} quadto Jolly crea un {{ColorYellorange}}Patto Poppio"

Descriptions.T_Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "Se lo primo scrto del round contiene una {{ColorYellorange}}singola{{CR}} carta, distruggila e guadagna {{ColotYellor}}3$"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "Ottiene {{ColorMult}}+2{{CR}} Molt se la mano giocata contiene una {{ColorYellorange}}Doppia Coppia#{{ColorGray}}(Attualmente{{ColorMult}}+[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "Le carte di [[VALUE1]]{{CR}} danno {{ColorMult}}X1.5{{CR}}Molt quando attivate#{{ColorGray}}(Seme cambia ogni round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "I {{ColorYellorange}}10{{CR}} e {{ColorYellorange}}4{{CR}} danno {{ColorChips}}+10{{CR}}Fiches e {{ColorMult}}+4{{CR}} Molt quando attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SELTZER] = "{{ColorYellorange}}Riattiva{{CR}} tutte le carte giocate# {{ColorGray}}({{ColorYellorange}}[[VALUE1]]{{ColorGray}} mani rimanenti)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "Le {{ColorYellorange}}Figure{{CR}} danno {{ColorMult}}+5{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "Ottiene {{ColorMult}}X0.25{{CR}} Molt per carta {{ColorYellorange}}venduta{{CR}} quasta Ante #{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CASTLE] = "Ottiene {{ColorChips}}+3{{CR}} Fiches ogni carta di [[VALUE1]]{{CR}} scartata #{{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE2]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "Le {{ColorYellorange}}Carte Dorate{{CR}} danno {{ColorYellorange}}4${{CR}} quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{ColorMult}}X3{{CR}} Molt all'{{ColorYellorange}}ultima{{CR}} mano del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{ColorYellorange}}Riattiva{{CR}} le {{ColorYellorange}}Figure{{CR}} giocate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{ColorYellorange}}+2{{CR}} Carte in mano #{{ColorMult}}-1{{CR}} mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.THROWBACK] = "Ottiene {{ColorMult}}X0.25{{CR}} Molt per buio {{ColorYellorange}}saltato{{CR}} questa partita# {{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "When a blind is {{ColorYellorange}}selected{{CR}}, adds a card with a random{{ColorYellorange}}Seal{{B_Black} to the deck and drawn to hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "La {{ColorYellorange}}prima{{CR}} carta che assegna punti viene {{ColorYellorange}}riattivata{{CR}} 2 volte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "Ottiene {{ColorMult}}X0.75{{CR}} ogni {{ColorYellorange}}Carta di vetro{{CR}} distrutta#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOWMAN] = "Le carte {{ColorYellorange}}Jolly{{CR}},{{ColorPink}}Tarocche{{CR}},{{ColorCyan}}Pianeta{{CR}} e {{ColorBlue}}Spettrali{{CR}} possono apparire più volte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{ColorChips}}X3{{CR}} Molt se la {{ColorYellorange}}Mano fi Poker{{CR}} contiene tutti i {{ColorYellorange}}Semi"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "Ottieni {{ColorChips}}+8{{CR}} Fiches per ogni {{ColorYellorange}}2{{CR}} attivato#{{ColorGray}}(Attualmente {{ColorChips}}+[[VALUE1]]{{ColorGray}}Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OOPS_6] = "Ogni {{ColorMint}}probabilità{{CR}} è rsddoppiata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.IDOL] = "[[VALUE1]]{{CR}} dà {{ColorMult}}X2{{CR}} Molt quando attivata #(Carta cambia ogni round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{ColorMult}}X2{{CR}} Molt se la {{ColorYellorange}}Mano di Poker{{CR}} contiene una carta di {{ColorChips}}Flub{{CR}} e una {{ColorYellorange}}non di {{ColorChips}}Fiori"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MATADOR] = "Guadagna {{ColorYellorange}}8${{CR}} quando la mano giocata attiva l'abilità del {{ColorYellorange}}Buio Boss"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "Ottiene {{ColorMult}}X0.5{{CR}} Molt ogni {{ColorYellorange}}Jack{{CR}} scartato questo round#{{ColorGray}}(Attualmente {{ColorMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUO] = "{{ColorMult}}X2{{CR}} Molt se la mano giocata contiene una {{ColorYellorange}}Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIO] = "{{ColorMult}}X3{{CR}} Molt se la mano giocata contiene un {{ColorYellorange}}Tris"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FAMILY] = "{{ColorMult}}X4{{CR}} Molt se la mano giocata contiene un {{ColorYellorange}}Poker"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ORDER] = "{{ColorMult}}X3{{CR}} Molt se la mano giocata contiene una {{ColorYellorange}}Scala"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBE] = "{{ColorMult}}X2{{CR}} Molt se la mano giocata contiene un {{ColorYellorange}}Colore"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{ColorMult}}+250{{CR}} Fiches #{{ColorMult}}-2{{CR}} Carte in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SATELLITE] = "Guadagna {{ColorYellorange}}1${{CR}} per {{ColorCyan}}Pianeta{{CR}} diverso usato questa partita# {{ColorGray}}(Attualmente {{ColorYellorange}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{ColorMult}}+13{{CR}} Molt per {{ColorYellorange}}Regina{{CR}} tenuta in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{ColorMult}}X3{{CR}} Molt se hai {{ColorYellorange}}16 carte potenziate{{CR}} nel mazzo intero# {{ColorGray}}(Attualmente {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Enhanced cards)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "Ogni {{ColorCyan}}Carta Pianeta{{CR}} e {{ColorCyan}}Busta Celestiale{{CR}} è gratuita"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{ColorYellorange}}Potenzia{{CR}} la prima {{ColorYellorange}}Mano di Poker{{CR}} scartata del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{ColorMult}}+2{{CR}} Molt per ogni {{ColorYellorange}}5${{CR}} avuti# {{ColorGray}}(Attualmente {{ColorMult}}+[[VALUE1]]{{ColorGray}} Molt)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CANIO] = "Ottiene {{ColorMult}}X1{{CR}} Molt ogni {{ColorYellorange}}Figura{{CR}} distrutta#{{ColorGray}}(Attualmente {{ColroMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{ColorYellorange}}Re{{CR}} e {{ColorYellorange}}Regine{{CR}} danno {{ColorMult}}X2{{CR}} Molt quando attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.YORICK] = "Ottiene {{ColorMult}}X1{{CR}} Molt once every {{ColorYellorange}}23{{CR}} cards discarded#{{ColorGray}}([[VALUE2]] Remaining) #{{ColorGray}}(Attualmente {{ColroMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHICOT] = "Disabilita le abilità dei {{ColorYellorange}}Bui Boss"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PERKEO] = "Uscendo dal {{ColorYellorange}}Negozio{{CR}}, crea una copia {{ColorSpade}}Negativa{{CR}} di un condìsumabile avuto casuale"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "Dopo essere attivate, le carte vengono combiate {{ColorYellorange}}casualmente #{{ColorGray}}(La nuova carta dipende da quella di partenza) "


end


Descriptions.T_Jimbo.Debuffed = "Tutte le abilità sono disattivate"


---------------------------------------
-------------####TAROTS####------------
---------------------------------------

Descriptions.Jimbo.Consumables = {}
Descriptions.Jimbo.Consumables[Card.CARD_FOOL] = "Crea una copia dell'ultima carta usata #{{IND}}!!! Eccetto sè stessa #[[VALUE1]] Attualmente: [[VALUE2]]"
Descriptions.Jimbo.Consumables[Card.CARD_MAGICIAN] = "{{REG_Lucky}} Cambia fino a {{ColorYellorange}}2{{CR}} carte nella tua mano in {{ColorYellorange}}Carte Fortunate"
Descriptions.Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "{{REG_Planet}} Crea {{ColorYellorange}}2 carte {{ColorCyan}}Pianeta{{CR}} casuali"
Descriptions.Jimbo.Consumables[Card.CARD_EMPRESS] = "{{REG_Mult}} Cambia fino a {{ColorYellorange}}2{{CR}} carte nella tua mano in {{ColorYellorange}}Carte Mult"
Descriptions.Jimbo.Consumables[Card.CARD_EMPEROR] = "{{Card}} Crea {{ColorYellorange}}2{{CR}} {{ColorPink}}Tarocchi{{CR}} casuali #{{IND}}!!! Eccetto sè stesso"
Descriptions.Jimbo.Consumables[Card.CARD_HIEROPHANT] = "{{REG_Bonus}} Cambia fino a {{ColorYellorange}}2{{CR}} carte nella tua mano in {{ColorYellorange}}Carte Bonus"
Descriptions.Jimbo.Consumables[Card.CARD_LOVERS] = "{{REG_Wild}} Cambia {{ColorYellorange}}1{{CR}} carta nella tua mano in {{ColorYellorange}}Carta Multiuso"
Descriptions.Jimbo.Consumables[Card.CARD_CHARIOT] = "{{REG_Steel}} Cambia {{ColorYellorange}}1{{CR}} carta nella tua mano in {{ColorYellorange}}Carta d'Acciaio"
Descriptions.Jimbo.Consumables[Card.CARD_JUSTICE] = "{{REG_Glass}} Cambia {{ColorYellorange}}1{{CR}} carta nella tua mano in {{ColorYellorange}}Carta di Vetro"
Descriptions.Jimbo.Consumables[Card.CARD_HERMIT] = "Raddoppia i tuoi soldi #{{IND}}!!! Massimo {{ColorYellorange}}20$"
Descriptions.Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di dare un'{{ColorYellorange}}Edizione{{CR}} ad un Jolly avuto #{{IND}}!!! Non può rimpiazzare edizioni già esistenti"
Descriptions.Jimbo.Consumables[Card.CARD_STRENGTH] = "Aumenta il valore di fino a {{ColorYellorange}}2{{CR}} carte di 1 #{{IND}}!!! I re diventano assi"
Descriptions.Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Distrugge fino a {{ColorYellorange}}2{{CR}} carte tenute in mano"
Descriptions.Jimbo.Consumables[Card.CARD_DEATH] = "Scegli {{ColorYellorange}}2{{CR}} carte, la {{ColorYellorange}}seconda{{CR}} diventa una copia della {{ColorYellorange}}prima"
Descriptions.Jimbo.Consumables[Card.CARD_TEMPERANCE] = "{{Coin}} Dà il {{ColorYellorange}}valore di vendita{{CR}} totale dei Jolly avuti in {{Coin}} Monete"
Descriptions.Jimbo.Consumables[Card.CARD_DEVIL] = "{{REG_Gold}} Cambia {{ColorYellorange}}1{{CR}} carta nella tua mano in {{ColorYellorange}}Carte Dorate"
Descriptions.Jimbo.Consumables[Card.CARD_TOWER] = "{{REG_Stone}} Cambia {{ColorYellorange}}1{{CR}} carta nella tua mano in {{ColorYellorange}}Carte di Pietra"
Descriptions.Jimbo.Consumables[Card.CARD_STARS] = "{{REG_Diamond}} Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte nella tua mano in {{ColorYellorange}}Quadri"
Descriptions.Jimbo.Consumables[Card.CARD_MOON] = "{{REG_Club}} Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte nella tua mano in {{ColorChips}}Fiori"
Descriptions.Jimbo.Consumables[Card.CARD_SUN] = "{{REG_Heart}} Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte nella tua mano in {{ColorMult}}Cuori"
Descriptions.Jimbo.Consumables[Card.CARD_JUDGEMENT] = "{{REG_Joker}} Dà un {{ColorYellorange}}Jolly{{CR}} casuale #{{IND}}!!! Serve spazio nell'invetario"
Descriptions.Jimbo.Consumables[Card.CARD_WORLD] = "{{REG_Spade}} Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte nella tua mano in {{ColorSpade}}Picche"


Descriptions.T_Jimbo.Consumables = {}
Descriptions.T_Jimbo.Consumables[Card.CARD_FOOL] = "Crea un copia dell'ultimo {{ColorPink}}Tarocco{{CR}} o {{ColorCyan}}Pianeta{{CR}} usato #{{ColorGray}}(Eccetto The Fool)#[[VALUE1]]"
Descriptions.T_Jimbo.Consumables[Card.CARD_MAGICIAN] = "Cambia fino a {{ColorYellorange}}2{{CR}} carte in {{ColorYellorange}}Carte Fourtunate"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "Crea {{ColorYellorange}}2{{CR}} carte {{ColorCyan}}Pianeta{{CR}} casuali #{{ColorGray}}(Serve spazio)"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPRESS] = "Cambia fino a {{ColorYellorange}}2{{CR}} carte in {{ColorYellorange}}Carte Molt"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPEROR] = "Creates {{ColorYellorange}}2{{CR}} {{ColorPink}}Tarot{{CR}} cards #{{ColorGray}}(Serve spazio)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIEROPHANT] = "Cambia fino a {{ColorYellorange}}2{{CR}} carte in {{ColorYellorange}}Carte Bonus"
Descriptions.T_Jimbo.Consumables[Card.CARD_LOVERS] = "Cambia {{ColorYellorange}}1{{CR}} carta in {{ColorYellorange}}Carta Multiuso"
Descriptions.T_Jimbo.Consumables[Card.CARD_CHARIOT] = "Cambia {{ColorYellorange}}1{{CR}} carta in {{ColorYellorange}}Carta d'Acciaio"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUSTICE] = "Cambia {{ColorYellorange}}1{{CR}} carta in {{ColorYellorange}}Carta di Vero"
Descriptions.T_Jimbo.Consumables[Card.CARD_HERMIT] = "Raddoppia i tuoi soldi  #{{ColorGray}}(Max 20$)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di dara un'{{ColorYellorange}}Edizione{{CR}} ad un Jolly avuto #{{ColorGray}}(Non cambia edizioni esistenti)"
Descriptions.T_Jimbo.Consumables[Card.CARD_STRENGTH] = "Aumenta il valore di fino a {{ColorYellorange}}2{{CR}} carte di 1 #{{ColorGray}}(I re divenano assi)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Distruggi fino a {{ColorYellorange}}2{{CR}} carte"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Left{{CR}} card becomes a copy of the {{ColorYellorange}}Right{{CR}} card"
Descriptions.T_Jimbo.Consumables[Card.CARD_TEMPERANCE] = "Guadagna il {{ColorYellorange}}valore di vendita{{CR}} totale dei tuoi Jolly #{{ColorGray}}(Attualmente {{ColorYellorange}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEVIL] = "Cambia {{ColorYellorange}}1{{CR}} carta in {{ColorYellorange}}Carta Dorata"
Descriptions.T_Jimbo.Consumables[Card.CARD_TOWER] = "Cambia {{ColorYellorange}}1{{CR}} carta in {{ColorYellorange}}Carta di Pietra"
Descriptions.T_Jimbo.Consumables[Card.CARD_STARS] = "Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte in {{ColorYellorange}}Quadri"
Descriptions.T_Jimbo.Consumables[Card.CARD_MOON] = "Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte in {{ColorChips}}Fiori"
Descriptions.T_Jimbo.Consumables[Card.CARD_SUN] = "Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte in {{ColorMult}}Cuori"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUDGEMENT] = "Crea un {{ColorYellorange}}Jolly{{CR}} casuale #{{ColorGray}}(Serve spazio)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WORLD] = "Cambia il seme di fino a {{ColorYellorange}}3{{CR}} carte in {{ColorSpade}}Picche"


Descriptions.ConsumablesName = {}
Descriptions.ConsumablesName[Card.CARD_FOOL] = "Il Matto"
Descriptions.ConsumablesName[Card.CARD_MAGICIAN] = "Il Mago"
Descriptions.ConsumablesName[Card.CARD_HIGH_PRIESTESS] = "La Papesse"
Descriptions.ConsumablesName[Card.CARD_EMPRESS] = "L'Imperatrice"
Descriptions.ConsumablesName[Card.CARD_EMPEROR] = "L'Imperatore"
Descriptions.ConsumablesName[Card.CARD_HIEROPHANT] = "Il Papa"
Descriptions.ConsumablesName[Card.CARD_LOVERS] = "Gli Amanti"
Descriptions.ConsumablesName[Card.CARD_CHARIOT] = "Il Carro"
Descriptions.ConsumablesName[Card.CARD_JUSTICE] = "Giustizia"
Descriptions.ConsumablesName[Card.CARD_HERMIT] =  "L'Eremita"
Descriptions.ConsumablesName[Card.CARD_WHEEL_OF_FORTUNE] = "Ruota della fortuna"
Descriptions.ConsumablesName[Card.CARD_STRENGTH] = "Forza"
Descriptions.ConsumablesName[Card.CARD_HANGED_MAN] = "L'Appeso"
Descriptions.ConsumablesName[Card.CARD_DEATH] = "Morte"
Descriptions.ConsumablesName[Card.CARD_TEMPERANCE] = "Temperanza"
Descriptions.ConsumablesName[Card.CARD_DEVIL] = "Il Diavolo"
Descriptions.ConsumablesName[Card.CARD_TOWER] = "La Torre"
Descriptions.ConsumablesName[Card.CARD_STARS] = "Le Stelle"
Descriptions.ConsumablesName[Card.CARD_MOON] = "La Luna"
Descriptions.ConsumablesName[Card.CARD_SUN] = "Il Sole"
Descriptions.ConsumablesName[Card.CARD_JUDGEMENT] = "Giudizio"
Descriptions.ConsumablesName[Card.CARD_WORLD] ="Il Mondo"



----------------------------------------
-------------####PLANETS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Planets.PLUTO] = "Gli {{ColorYellorange}}Assi{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime e {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.MERCURY] = "I {{ColorYellorange}}2{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.URANUS] = "I {{ColorYellorange}}3{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.VENUS] = "I {{ColorYellorange}}4{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.SATURN] = "I {{ColorYellorange}}5{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.JUPITER] = "I {{ColorYellorange}}6{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.EARTH] = "I {{ColorYellorange}}7{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.MARS] = "Gli {{ColorYellorange}}8{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.NEPTUNE] = "I {{ColorYellorange}}9{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.PLANET_X] = "I {{ColorYellorange}}10{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.CERES] = "I {{ColorYellorange}}Jack{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.ERIS] = "Le {{ColorYellorange}}Regine{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivate"
Descriptions.Jimbo.Consumables[mod.Planets.SUN] = "I {{ColorYellorange}}Re{{CR}} attivati danno {{ColorChips}}+0.02{{CR}} Lacrime and {{ColorMult}}+0.02{{CR}} Danno quando attivati"


Descriptions.T_Jimbo.Consumables[mod.Planets.PLUTO] = "Potenzia {{ColorYellorange}}Carta Alta#{{ColorMult}}+1{{CR}} Molt#{{ColorChips}}+10{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.MERCURY] = "Potenzia {{ColorYellorange}}Coppia#{{ColorMult}}+1{{CR}} Molt#{{ColorChips}}+15{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.URANUS] = "Potenzia {{ColorYellorange}}Doppia Coppia#{{ColorMult}}+1{{CR}} Molt#{{ColorChips}}+20{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.VENUS] = "Potenzia {{ColorYellorange}}Tris#{{ColorMult}}+2{{CR}} Molt#{{ColorChips}}+20{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.SATURN] = "Potenzia {{ColorYellorange}}Scala#{{ColorMult}}+3{{CR}} Molt#{{ColorChips}}+35{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.JUPITER] = "Potenzia {{ColorYellorange}}Colore#{{ColorMult}}+2{{CR}} Molt#{{ColorChips}}+15{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.EARTH] = "Potenzia {{ColorYellorange}}Fulle#{{ColorMult}}+2{{CR}} Molt#{{ColorChips}}+25{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.MARS] = "Potenzia {{ColorYellorange}}Poker#{{ColorMult}}+3{{CR}} Molt#{{ColorChips}}+30{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.NEPTUNE] = "Potenzia {{ColorYellorange}}Scala Flush#{{ColorMult}}+4{{CR}} Molt#{{ColorChips}}+40{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.PLANET_X] = "Potenzia {{ColorYellorange}}Pokerissimo#{{ColorMult}}+3{{CR}} Molt#{{ColorChips}}+35{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.CERES] = "Potenzia {{ColorYellorange}}Full Colore#{{ColorMult}}+4{{CR}} Molt#{{ColorChips}}+40{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.ERIS] = "Potenzia {{ColorYellorange}}Colore Perfetto#{{ColorMult}}+3{{CR}} Molt#{{ColorChips}}+50{{CR}} Fiches"


----------------------------------------
-------------####SPECTRALS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{REG_Jimbo}} {{ColorYellorange}}Distrugge{{CR}} una carta in mano casuale e aggiunge {{ColorYellorange}}3 {{REG_Face}} Figure Potenziate{{CR}} casuali al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.GRIM] = "{{REG_Jimbo}} {{ColorYellorange}}Distrugge{{CR}} una carta in mano casuale e aggiunge {{ColorYellorange}}2 Assi Potenziati{{CR}} casuali al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{REG_Jimbo}} {{ColorYellorange}}Distrugge{{CR}} una carta in mano casuale e aggiunge {{ColorYellorange}}4 carte numerate potenziate{{CR}} casuali al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.TALISMAN] = "{{REG_Jimbo}} Metti un {{REG_Golden}} {{ColorYellorange}}Sigillo Dorato{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.AURA] = "{{REG_Jimbo}} Dai un'{{ColorYellorange}}Edition{{CR}} casuale ad una carta scelta"
Descriptions.Jimbo.Consumables[mod.Spectrals.WRAITH] = "{{REG_Jimbo}} Fissa le monete avute a {{ColorYellorange}}0 #{{REG_Joker}} Ottieni un {{ColorMult}}Jolly Raro{{CR}}#{{IND}}!!! Serve spazio nell'inventario"
Descriptions.Jimbo.Consumables[mod.Spectrals.SIGIL] = "{{REG_Jimbo}} Cambia tutte le carte in mano in uno stesso {{ColorYellorange}}Seme{{CR}} casuale"
Descriptions.Jimbo.Consumables[mod.Spectrals.OUIJA] = "{{REG_Jimbo}} Cambia tutte le carte in mano in uno stesso {{ColorYellorange}}Valore{{CR}} casuale"
Descriptions.Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "{{REG_Jimbo}} Rende un Jolly casuale {{ColorGray}}{{ColorFade}}Negativo #{{IND}}!!! Non rimpiazza edizioni già presenti #{{REG_HSize}} {{ColorRed}}-1{{CR}} Carte in mano #{{IND}}!!! Nessun effetto se le carte in mano nono possono essere diminuite"
Descriptions.Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "{{REG_Jimbo}} {{ColorYellorange}}Distrugge{{CR}} fino a {{ColorYellorange}}3{{CR}} carte nella mano #{{Coin}} Guadagna {{ColorYellorange}}4${{CR}} per ogni carta distrutta"
Descriptions.Jimbo.Consumables[mod.Spectrals.ANKH] = "{{REG_Jimbo}} Crea un copia di un Jolly avuto e distrugge gli altri #!!! Rimuove {{ColorGray}}{{ColorFade}}Negativo{{CR}} dalla copia"
Descriptions.Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "{{REG_Jimbo}} Metti un {{ColorRed}}Sigillo Rosso{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.HEX] = "{{REG_Jimbo}} Rende un Jolly casuale {{ColorRainbow}}Policroma{{CR}} e distrugge gli altri"
Descriptions.Jimbo.Consumables[mod.Spectrals.TRANCE] = "{{REG_Jimbo}} Metti un {{ColorCyan}}Sigillo Blu{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.MEDIUM] = "{{REG_Jimbo}} Metti un {{ColorPink}}Sigillo Viola{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.CRYPTID] = "{{REG_Jimbo}} Aggiunge {{ColorYellorange}}2{{CR}} copie di una carta selezionata al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "{{REG_Jimbo}} {{ColorYellorange}}Tutte le carte{{CR}} attivate danno {{ColorChips}}+0.02{{CR}} Lacrime e {{ColorMult}}+0.02{{CR}} Danno"
Descriptions.Jimbo.Consumables[mod.Spectrals.SOUL] = "{{REG_Jimbo}} Ottieni un Jolly {{ColorRainbow}}Loggendario{{CR}} casuale #{{IND}}!!! Serve spazio nell'inventario"



Descriptions.T_Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{ColorYellorange}}Distrugge{{CR}} una carta in mano casuale, aggiunge {{ColorYellorange}}3 Figure Potenziate{{CR}} cauali al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.GRIM] = "{{ColorYellorange}}Distrugge{{CR}} una carta casuale in mano, aggiunge {{ColorYellorange}}2 Assi Potenziati{{CR}} casuali al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{ColorYellorange}}Distrugge{{CR}} una carta casuale in mano, aggiunge {{ColorYellorange}}4 Carte Numerate Potenziate{{CR}} casuali al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TALISMAN] = "Metti un {{ColorYellorange}}Sigillo Dorato{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.AURA] = "Dà un'{{ColorYellorange}}Edizione{{CR}} casuale ad una carta scelta"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.WRAITH] = "Fissa i soldi avuti a {{ColorYellorange}}0${{CR}}, creates a random {{ColorMult}}Rare{{CR}} Joker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SIGIL] = "Cambia tutte le carte in mano in uno stesso {{ColorYellorange}}Seme{{CR}} casuale"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.OUIJA] = "Cambia tutte le carte in mano in uno stesso {{ColorYellorange}}Valore{{CR}} casuale #{{ColorMult}}-1{{CR}} Carte in mano"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "Rende un Jolly casuale {{ColorSpade}}Negativo #{{ColorRed}}-[[VALUE1]]{{CR}} Carte in mano"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "Distrugge {{ColorYellorange}}5{{CR}} carte casuali dalla tua mano, guadagna {{ColorYellorange}}20$"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ANKH] = "Duplica un {{ColorYellorange}}Jolly{{CR}} casuale avuto, distrugge gli altri [[VALUE1]]"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "Metti un {{ColorYellorange}}Sigillo Rosso{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.HEX] = "Rendi un Jolly casuale {{ColoorRainbow}}Polychroma{{CR}}, distrugge gli altri"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TRANCE] = "Metti un {{ColorYellorange}}Sigillo Blu{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.MEDIUM] = "Metti un {{ColorYellorange}}Sigillo Viola{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.CRYPTID] = "Aggiunge {{ColorYellorange}}2{{CR}} copie di una carta selezionata al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "Potenzia tutte le {{ColorYellorange}}Mani di Poker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SOUL] = "Crea un Jolly {{ColorRainbow}}Leggendario{{CR}} casuale #{{ColorGray}}(Serve spazio)"


---------------------------------------
--------------BOOSTERS-----------------
---------------------------------------

Descriptions.Jimbo.Boosters = {}
Descriptions.Jimbo.Boosters[mod.Packs.ARCANA] = "Scegli 1 {{ColorPink}}Tarocco{{CR}} fra {{ColorYellorange}}3{{CR}} da ricevere subito"
Descriptions.Jimbo.Boosters[mod.Packs.CELESTIAL] = "Scegli 1 carta {{ColorCyan}}Pianeta{{CR}} fra {{ColorYellorange}}3{{CR}} da ricevere subito"
Descriptions.Jimbo.Boosters[mod.Packs.STANDARD] = "Scegli 1 {{ColorYellorange}}carta da gioco{{CR}} fra {{ColorYellorange}}3{{CR}} da aggiungere al mazzo"
Descriptions.Jimbo.Boosters[mod.Packs.BUFFON] = "Scegli 1 {{ColorYellorange}}Jolly{{CR}} fra {{ColorYellorange}}2{{CR}} da ricevere subito"
Descriptions.Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Scegli 1 carta {{ColorBlue}}Spettrale{{CR}} fra {{ColorYellorange}}2{{CR}} da ricevere subito"



Descriptions.T_Jimbo.Boosters = {}
Descriptions.T_Jimbo.Boosters[mod.Packs.ARCANA] = "Scegli 1 {{ColorPink}}Tarocco{{CR}} fra {{ColorYellorange}}3{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_ARCANA] = "Scegli 1 {{ColorPink}}Tarocco{{CR}} fra {{ColorYellorange}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_ARCANA] = "Scegli fino a 2 {{ColorPink}}Tarocccchi{{CR}} fra {{ColorYellorange}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.CELESTIAL] = "Scegli 1 carta {{ColorCyan}}Pianeta{{CR}} fra {{ColorYellorange}}3{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_CELESTIAL] = "Scegli 1 carta {{ColorCyan}}Pianeta{{CR}} fra {{ColorYellorange}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_CELESTIAL] = "Scegli fino a 2 carte {{ColorCyan}}Pianeta{{CR}} fra {{ColorYellorange}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.STANDARD] = "Scegli 1 carta {{ColorYellorange}}da gioco{{CR}} fra {{ColorYellorange}}3{{CR}} da aggiungere al mazzo"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_STANDARD] = "Scegli 1 carta {{ColorYellorange}}da gioco{{CR}} fra {{ColorYellorange}}5{{CR}} da aggiungere al mazzo"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_STANDARD] = "Scegli fino a 2 carte {{ColorYellorange}}da gioco{{CR}} fra {{ColorYellorange}}5{{CR}} da aggiungere al mazzo"
Descriptions.T_Jimbo.Boosters[mod.Packs.BUFFON] = "Scegli 1 {{ColorYellorange}}Jolly{{CR}} fra {{ColorYellorange}}2{{CR}} da ricevere subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_BUFFON] = "Scegli 1 {{ColorYellorange}}Jolly{{CR}} fra {{ColorYellorange}}4{{CR}} da ricevere subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_BUFFON] = "Scegli fino a 2 {{ColorYellorange}}Jolly{{CR}} fra {{ColorYellorange}}4{{CR}} da ricevere subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Scegli 1 carta {{ColorBlue}}Spettrale{{CR}} fra {{ColorYellorange}}2{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_SPECTRAL] = "Scegli 1 carta {{ColorBlue}}Spettrale{{CR}} fra {{ColorYellorange}}4{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_SPECTRAL] = "Scegli fino a 2 carte {{ColorBlue}}Spettrali{{CR}} fra {{ColorYellorange}}4{{CR}} da usare subito"



-------------------------------------
--------------BLINDS-----------------
-------------------------------------

    
Descriptions.BlindNames = {[mod.BLINDS.SMALL] = "Piccolo buio",
                           [mod.BLINDS.BIG] = "Grande buio",
                           [mod.BLINDS.BOSS] = "Buio boss",
                           [mod.BLINDS.BOSS_ACORN] = "Ghinda d'ambra",
                           [mod.BLINDS.BOSS_ARM] = "Il braccio",
                           [mod.BLINDS.BOSS_BELL] = "Campana cerulea",
                           [mod.BLINDS.BOSS_CLUB] = "Il fiore",
                           [mod.BLINDS.BOSS_EYE] = "L'occhio",
                           [mod.BLINDS.BOSS_FISH] = "Il pesce",
                           [mod.BLINDS.BOSS_FLINT] = "La selce",
                           [mod.BLINDS.BOSS_GOAD] = "Il gomito",
                           [mod.BLINDS.BOSS_HEAD] = "La testa",
                           [mod.BLINDS.BOSS_HEART] = "Cuore cremisi",
                           [mod.BLINDS.BOSS_HOOK] = "Il gancio",
                           [mod.BLINDS.BOSS_HOUSE] = "La casa",
                           [mod.BLINDS.BOSS_LEAF] = "Foglia verde",
                           [mod.BLINDS.BOSS_MANACLE] = "Il manubrio",
                           [mod.BLINDS.BOSS_MARK] = "Il merchio",
                           [mod.BLINDS.BOSS_MOUTH] = "la bocca",
                           [mod.BLINDS.BOSS_NEEDLE] = "L'ago",
                           [mod.BLINDS.BOSS_OX] = "Il bue",
                           [mod.BLINDS.BOSS_PILLAR] = "Il pilastro",
                           [mod.BLINDS.BOSS_PLANT] = "La pianta",
                           [mod.BLINDS.BOSS_PSYCHIC] = "Lo psichico",
                           [mod.BLINDS.BOSS_SERPENT] = "Il serpente",
                           [mod.BLINDS.BOSS_TOOTH] = "Il dente",
                           [mod.BLINDS.BOSS_VESSEL] = "Calice violetto",
                           [mod.BLINDS.BOSS_WALL] = "Il muro",
                           [mod.BLINDS.BOSS_WATER] = "L'acqua",
                           [mod.BLINDS.BOSS_WHEEL] = "La ruota",
                           [mod.BLINDS.BOSS_WINDOW] = "La finestra",
                           [mod.BLINDS.BOSS_LAMB] = "L'agnello",
                           [mod.BLINDS.BOSS_MOTHER] = "La madre",
                           [mod.BLINDS.BOSS_DELIRIUM] = "Il delirio",
                           [mod.BLINDS.BOSS_BEAST] = "La bestia",
                           HUSH = "Hush",
                           BOSSRUSH = "Bossrush",
                            }

Descriptions.Warning = {Title = "La mano non assegnerà punti!",
                        [mod.BLINDS.BOSS_MOUTH] = "Puoi giocare solo [[VALUE1]] questo round",
                        [mod.BLINDS.BOSS_EYE] = "[[VALUE1]] è stata già giocata",
                        [mod.BLINDS.BOSS_PSYCHIC] = "La mano deve contenere 5 carte",}


Descriptions.BossEffects = {[mod.BLINDS.SMALL] = "Nessun effetto",
                            [mod.BLINDS.BIG] = "Nessun effetto",
                            [mod.BLINDS.BOSS] = "Nessun effetto",
                            [mod.BLINDS.BOSS_ACORN] = "Copre e mischia tutti i Jolly",
                            [mod.BLINDS.BOSS_ARM] = "Depotenzia la Mano di Poker giocata",
                            [mod.BLINDS.BOSS_BELL] = "Forza una carta ad essere selzionata",
                            [mod.BLINDS.BOSS_CLUB] = "I Fiori sono penalizzati",
                            [mod.BLINDS.BOSS_EYE] = "Non puoi giocare mani ripetute",
                            [mod.BLINDS.BOSS_FISH] = "Le carte pescate dopo un mano sono coperte",
                            [mod.BLINDS.BOSS_FLINT] = "Dimezza fiches e molt base",
                            [mod.BLINDS.BOSS_GOAD] = "I Picche sono penalizzati",
                            [mod.BLINDS.BOSS_HEAD] = "I Cuori sono penalizzati",
                            [mod.BLINDS.BOSS_HEART] = "Penalizza un Jolly casuale ogni mano",
                            [mod.BLINDS.BOSS_HOOK] = "Scarta 2 carte giocando una mano",
                            [mod.BLINDS.BOSS_HOUSE] = "Le carte iniziali pescate sono coperte",
                            [mod.BLINDS.BOSS_LEAF] = "Carte penalizzate finchè un Jolly non viene venduto",
                            [mod.BLINDS.BOSS_MANACLE] = "-1 Carte in mano",
                            [mod.BLINDS.BOSS_MARK] = "Le figure sono coperte",
                            [mod.BLINDS.BOSS_MOUTH] = "Puoi giocare solo un tipo di mano",
                            [mod.BLINDS.BOSS_NEEDLE] = "Gioca solo 1 mano",
                            [mod.BLINDS.BOSS_OX] = "Giocare [[VALUE1]] fissa i soldi a 0$",
                            [mod.BLINDS.BOSS_PILLAR] = "Carte già giocate nell'ante sono penalizzate",
                            [mod.BLINDS.BOSS_PLANT] = "Le figure sono penalizzate",
                            [mod.BLINDS.BOSS_PSYCHIC] = "Devi giocare 5 carte",
                            [mod.BLINDS.BOSS_SERPENT] = "Peschi sempre 3 carte dopo mani o scarti",
                            [mod.BLINDS.BOSS_TOOTH] = "-1$ per ogni carta giocata",
                            [mod.BLINDS.BOSS_VESSEL] = "Buio molto alto",
                            [mod.BLINDS.BOSS_WALL] = "Buio molto alto",
                            [mod.BLINDS.BOSS_WATER] = "Inizia con 0 scarti",
                            [mod.BLINDS.BOSS_WHEEL] = "1 carta su 7 è coperta",
                            [mod.BLINDS.BOSS_WINDOW] = "I Quadri sono penalizzati",
                            [mod.BLINDS.BOSS_LAMB] = "Venire colpito penalizza una carta in mano",
                            [mod.BLINDS.BOSS_MOTHER] = "Venire colpito copre una carta in mano",
                            [mod.BLINDS.BOSS_DELIRIUM] = "Venire colpito cambia valore e seme di una carta in mano",
                            [mod.BLINDS.BOSS_BEAST] = "Venire colpito scarta una carta in mano",
                        }
    

------------------------------------------
--------------T_JIMBO HUDs----------------
------------------------------------------

Descriptions.T_Jimbo.LeftHUD = {ShopSlogan = "Migliora la sessione!",
                                ChooseNextBlind = "Scegli il prossimo buio",
                                RerollBoss = "Cambi boss $10",
                                Reward = "Premio:", --try to keep this one short pls
                                Hands = "Mani",
                                Discards = "Scarti",
                                Ante = "Ante",
                                Round = "Round",
                                RunInfo = "Info partita",
                                Options = "Opzioni",
                                EnemyMaxHP = "HP max nemici",
                                HandScore = "Punti",
                                SPACE_KeyBind = "[Item]",
                                Q_KeyBind = "[Consum.]",
                                E_KeyBind = "[Bomba]",
                            } 


Descriptions.T_Jimbo.RunInfo = {Hands = "Mani", --as in poker hands
                                Deck = "Mazzo",
                                Blinds = "Bui",
                                LVL = "lvl.", --again, abbreviation of level
                                Current = "Current",
                                Defeated = "Sconfitto",
                                Skip = "Salta", --the verb to skip
                                Skipped = "SALTATO",
                                Or = "oppure", --as in defeat OR skip
                                DamageRequirement = "Punti richiesti:",
                                AtLeast = "Ottieni almeno"
                            }

----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------


Descriptions.T_Jimbo.Vouchers = {}

Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber] = "{{ColorChips}}+1{{CR}} mano ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.NachoTong] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful] = "{{ColorMult}}+1{{CR}} scarto ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Recyclomancy] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush] = "{{ColorChips}}+1{{CR}} carte in mano"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Palette] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Clearance] = "Gli oggetti sono scontati del {{ColorYellorange}}25% #{{ColorGray}}(Arr. per difetto)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Liquidation] = "Gli oggetti sono scontati del {{ColorYellorange}}50% #{{ColorGray}}(Arr. per difetto)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock] = "{{ColorYellorange}}+1{{CR}} Carta disponibile el negozio"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.OverstockPlus] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hone] = "Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{ColorYellorange}}2X{{CR}} più spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.GlowUp] = "Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{ColorYellorange}}4X{{CR}} più spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollSurplus] = "I {{ColorMint}}Cambi{{CR}} costano {{ColorYellorange}}2${{CR}} in meno"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollGlut] = "I {{ColorMint}}Rerolls{{CR}} costano altri {{ColorYellorange}}2${{CR}} in meno"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Crystal] = "{{ColorYellorange}}+1{{CR}} slot consumabile"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Omen] = "Le carte {{ColorBlue}}Spettrali{{CR}} possono apparire nelle {{ColorYellorange}}Buste Arcane"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Telescope] = "Le {{ColorYellorange}}Buste Celestiali{{CR}} hanno sempre il {{colorCyan}}Pianeta{{CR}} per la tua mano più giocata"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Observatory] = "Le carte {{ColorCyan}}Pianeta{{CR}} tenute danno {{ColorMult}}X1.5{{CR}} Molt per la loro mano corrispettiva"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotMerch] = "I {{ColorPink}}Tarocchi{{CR}} appaiono {{ColorYellorange}}2X{{CR}} più spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotTycoon] = "I {{ColorPink}}Tarocchi{{CR}} appaiono {{ColorYellorange}}4X{{CR}} più spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetMerch] = "I {{ColorCyan}}Pianeti{{CR}} appaiono {{ColorYellorange}}2X{{CR}} più spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetTycoon] = "I {{ColorCyan}}Pianeti{{CR}} appaiono {{ColorYellorange}}4X{{CR}} più spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneySeed] = "Gli interessi massimi aumentano a {{ColorYellorange}}10$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneyTree] = "Gli interessi massimi aumentano a {{ColorYellorange}}20$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Blank] = "{{ColorGray}}Niente?"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Antimatter] = "{{ColorSpade}}+1{{CR}} slot Jolly"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MagicTrick] = "Le {{ColorYellorange}}Carte da Gioco{{CR}} possono apparire nello shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Illusion] = "Le {{ColorYellorange}}Carte da Gioco{{CR}} nel negozio possono avere {{ColorYellorange}}Potenziamenti{{CR}},{{ColorYellorange}}Edizioni{{CR}} o {{ColorYellorange}}Sigilli"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hieroglyph] = "{{ColorYellorange}}-1{{CR}} Ante#{{ColorChips}}-1{{CR}} Mano ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Petroglyph] = "{{ColorYellorange}}-1{{CR}} Ante#{{ColorMult}}-1{{CR}} Scarto ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Director] = "{{ColorPink}}Cambia{{CR}} il buio boss {{ColorYellorange}}una{{CR}} volta per Ante#({{ColorYellorange}}10${{CR}} per ogni cambio)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Retcon] = "{{ColorPink}}Cambia{{CR}} il buio boss {{ColorYellorange}}infinite{{CR}} volte per Ante#({{ColorYellorange}}10${{CR}} per ogni cambio)"

if EID then
    EID:addCollectible(mod.Vouchers.Grabber, "{{REG_Jimbo}} {{ColorChips}}+5{{CR}} {{REG_Hand}} playable cards every room", "Manesco", FileLanguage)
    EID:addCollectible(mod.Vouchers.NachoTong, "{{REG_Jimbo}} {{ColorChips}}+5{{CR}} {{REG_Hand}} playable cards every room", "Mano sui nachos", FileLanguage)

    EID:addCollectible(mod.Vouchers.Wasteful, "{{REG_Jimbo}} {{ColorMult}}+1{{CR}} {{Heart}} Cuore", "Wasteful", FileLanguage)
    EID:addCollectible(mod.Vouchers.Recyclomancy, "{{REG_Jimbo}} {{ColorMult}}+1{{CR}} {{Heart}} Cuore", "Recyclomancy", FileLanguage)

    EID:addCollectible(mod.Vouchers.Overstock, "{{REG_Jimbo}} Ogni negozio futuro avrà 1 {{REG_Joker}} Jolly aggiuntivo in vendita", "Più merce", FileLanguage)
    EID:addCollectible(mod.Vouchers.OverstockPlus, "{{REG_Jimbo}} Ogni negozio futuro avrà 1 {{REG_Joker}} Jolly aggiuntivo in vendita", "Troppa merce", FileLanguage)

    EID:addCollectible(mod.Vouchers.Clearance, "{{REG_Jimbo}} Tutto viene scontato del {{ColorYellorange}}25% #{{IND}}!!! I prezzi sono arrotondati per difetto", "Svendita", FileLanguage)
    EID:addCollectible(mod.Vouchers.Liquidation, "{{REG_Jimbo}} Tutto viene scontato del {{ColorYellorange}}50% #{{IND}}!!! I prezzi sono arrotondati per difetto", "Liquidazione", FileLanguage)

    EID:addCollectible(mod.Vouchers.Hone, "{{REG_Jimbo}} Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{ColorYellorange}}2x{{CR}} più frequentemente", "Lucidatura", FileLanguage)
    EID:addCollectible(mod.Vouchers.GlowUp, "{{REG_Jimbo}} Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{ColorYellorange}}4x{{CR}} più frequentemente", "Perfezionamento", FileLanguage)

    EID:addCollectible(mod.Vouchers.RerollSurplus, "{{REG_Jimbo}} Attivare una {{RestockMachine}} Restock Machine ridà indietro {{ColorYellorange}}1{{CR}} {{Coin}} Moneta", "Cambi in Surplus", FileLanguage)
    EID:addCollectible(mod.Vouchers.RerollGlut, "{{REG_Jimbo}} Attivare una {{RestockMachine}} Restock Machine ridà indietro {{ColorYellorange}}2{{CR}} {{Coin}} Monete", "Eccesso di Cambi", FileLanguage)

    EID:addCollectible(mod.Vouchers.Crystal, "{{REG_Jimbo}} Ogni {{ColorYellorange}}Busta di Espansione{{CR}} ha {{ColorYellorange}}1{{CR}} opzione aggiuntiva", "Palla di Cristallo", FileLanguage)
    EID:addCollectible(mod.Vouchers.Omen, "{{REG_Jimbo}} Le {{ColorPink}}Busta Arcane{{CR}} possono contenere carte {{ColorBlue}}Spettrali", "Sfera Presagente", FileLanguage)

    EID:addCollectible(mod.Vouchers.Telescope, "{{REG_Jimbo}} Saltare una {{ColorCyan}}Busta Celestiale{{CR}} crea {{ColorYellorange}}2{{CR}} carte {{ColorCyan}}Pianeta{{CR}} casuali aggiuntive", "Telescopio", FileLanguage)
    EID:addCollectible(mod.Vouchers.Observatory, "{{REG_Jimbo}} Le carte attivante mentre si tiene la loro carta {{ColorCyan}}Pianeta{{CR}} corrispettiva danno {{Damage}} {{ColorMult}}X1.15{{CR}} Molt. di Danno #{{IND}}{{Planetarium}} Anche avere il corrispettivo oggetto del planetario conta", "Osservatorio", FileLanguage)

    EID:addCollectible(mod.Vouchers.Blank, "{{REG_Jimbo}} {{ColorFade}}Niente?", "Vuoto", FileLanguage)
    EID:addCollectible(mod.Vouchers.Antimatter, "{{REG_Jimbo}} {{ColorYellorange}}+1{{CR}} slot {{REG_Joker}} Jolly", "Antimateria", FileLanguage)

    EID:addCollectible(mod.Vouchers.Brush, "{{REG_Jimbo}} {{ColorChips}}+1{{CR}} {{REG_HSize}} Carte in mano", "Pennello", FileLanguage)
    EID:addCollectible(mod.Vouchers.Palette, "{{REG_Jimbo}} {{ColorChips}}+1{{CR}} {{REG_HSize}} Carte in mano", "Tavolozza", FileLanguage)

    EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Cambia tutti i piedistalli nella stanza al costo di 5 monete", "Versione del Regista", FileLanguage)
    EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Attiva il {{Collectible283}} D100 al costo di 5 monete", "Retcon", FileLanguage)

    EID:addCollectible(mod.Vouchers.Hieroglyph, "{{REG_Retrigger}} Ricomincia il piano attuale quando preso", "Geroglifo", FileLanguage)
    EID:addCollectible(mod.Vouchers.Petroglyph, "{{REG_Retrigger}} Ricomincia il piano attuale quando preso", "Petroglifo", FileLanguage)

    EID:addCollectible(mod.Vouchers.MagicTrick, "Le buste di espansione hanno {{ColorMint}}[[CHANCE]] probabilità su 4{{CR}} di permettere una scelta aggiuntiva dopo la precedente #{{IND}} Può attivarsi più volte", "Trucco di Magia", FileLanguage)
    EID:addCollectible(mod.Vouchers.Illusion, "Le buste di espansione hanno {{ColorMint}}[[CHANCE]] probabilità su 2{{CR}} di contenere {{ColorYellorange}}2{{CR}} opzioni in più #Le buste di espansione hanno {{ColorMint}}[[CHANCE]] probabilità su 5{{CR}} di permettere {{ColorYellorange}}1{{CR}} scelta aggiuntiva", "Illusione", FileLanguage)

    EID:addCollectible(mod.Vouchers.MoneySeed, "{{REG_Jimbo}} Interessi massimi aumentati a {{ColorYellorange}}10{{CR}} {{Coin}} Monete", "Seme del Successo", FileLanguage)
    EID:addCollectible(mod.Vouchers.MoneyTree, "{{REG_Jimbo}} Interessi massimi aumentati a {{ColorYellorange}}20{{CR}} {{Coin}} Monete", "Albero di Soldi", FileLanguage)

    EID:addCollectible(mod.Vouchers.PlanetMerch, "{{REG_Planet}} Ogni pickup ha {{ColorMint}}[[CHANCE]] probabilità su 15{{CR}} di essere rimpiazzato con una {{REG_Planet}} {{ColorCyan}}Carta Pianeta{{CR}} casuale", "Mercante di Pieneti", FileLanguage)
    EID:addCollectible(mod.Vouchers.PlanetTycoon, "{{REG_Planet}} Ogni pickup ha {{ColorMint}}[[CHANCE]] probabilità su 10{{CR}} aggiuntiva di essere rimpiazzato con una {{REG_Planet}} {{ColorCyan}}Carta Pianeta{{CR}} casuale", "Magnate di Pianeti", FileLanguage)

    EID:addCollectible(mod.Vouchers.TarotMerch, "{{Card}} Ogni pickup ha {{ColorMint}}[[CHANCE]] probabilità su 15{{CR}} di essere rimpiazzato con un {{Card}} {{ColorPink}}Tarocco{{CR}} casuale", "Mercante di Tarocchi", FileLanguage)
    EID:addCollectible(mod.Vouchers.TarotTycoon, "{{Card}} Ogni pickup ha {{ColorMint}}[[CHANCE]] probabilità su 10{{CR}} aggiuntiva di essere rimpiazzato con un {{Card}} {{ColorPink}}Tarot Card{{CR}} casuale", "Magnate di Tarocchi", FileLanguage)
end



-------------------------------------
---------------MAIN GAME-------------
-------------------------------------

if EID then

EID:addCollectible(mod.Collectibles.BALOON_PUPPY, "Famiglio che riflette i proiettili nemici e infligge 5 danni da contatto al secondo #Dopo aver subito abbastanza danno, esplode infliggendo {{ColorTellorange}}3 x Danno di Isaac{{CR}} ai nemici vicini #Inizia a inseguire i nemici se Isaac prende danno", "Cucciolo Pallone",FileLanguage)		
EID:addCollectible(mod.Collectibles.BANANA, "Mira e spara una banana devastante che crea un'esplosione {{Collectible483}} Mama Mega! all'atterraggio #!!! Diventa {{Collectible"..mod.Collectibles.EMPTY_BANANA.."}} Buccia di Banana dopo l'uso", "Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.EMPTY_BANANA, "Lascia una buccia di banana a terra #I nemici possono scivolare sule bucce, prendendo danno e diventando {{Confusion}} confusi #{{IND}} Il danno inflitto scala con la velocità a cui si muoveva il nemico", "Buccia di Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.CLOWN, "La metà dei nemici diventa {{Charm}} Ammaliata o {{Fear}} Impaurita stando vicino ad Isaac", "Costume da Clown",FileLanguage)		
EID:addCollectible(mod.Collectibles.CRAYONS, "Muovendoti, lasci una scia di pastello colorata che infligge vari status ai nemici #{{IND}} L'effetto varia in base al colore dela scia #Il colore della scia cambia ongi stanza", "Scatola di Pastelli",FileLanguage)		
EID:addCollectible(mod.Collectibles.FUNNY_TEETH, "Famiglio che insegue i nemici infliggendo 15 danni al secondo #{{IND}}Il danno inflitto aumenta leggermente in base al piano attuale #{{Chargeable}} Dopo essere rimasto attivo per un po' deve venire ricaricato standogli vicino", "Denti Sbellicosi",FileLanguage)		
EID:addCollectible(mod.Collectibles.HORSEY, "Famiglio che salta in un pattern ad L, creando delle onde d'urto all'atterraggio #{{IND}}!!! Le onde non danneggiano Isaac", "Cavallino",FileLanguage)		
EID:addCollectible(mod.Collectibles.LAUGH_SIGN, "Il pubblico reagisce in diretta alle azioni di Isaac #{{BossRoom}} Completare una stanza del boss rimcompensa con qualche pickup casuale #Subire danno lancia dei pomodori che infliggono {{Bait}} Adescamento all'atterraggio", "Ridere!",FileLanguage)		
EID:addCollectible(mod.Collectibles.LOLLYPOP, "{{Timer}} Un lecca lecca appare ogni 25 secondi spesi in una stanza ostile #{{Collectible93}} Prendere un lecca lecca attiva l'effetto di Gamekid! per 5.5 secondi #!!! Fino a 3 lecca lecca possono essere a terra", "Lecca Lecca",FileLanguage)		
EID:addCollectible(mod.Collectibles.POCKET_ACES, "{{Luck}} 8% di probabilità di sparare un asso #Gli assi infliggono danno uguale al prodotto del {{Damage}} Danno e delle {{Tears}} Lacrime di Isaac", "Assi di Tasca",FileLanguage)		
EID:addCollectible(mod.Collectibles.TRAGICOMEDY, "40% di probabilità una maschera {{REG_Comedy}} comica o {{REG_Tragedy}} tragica completando una stanza #{{IND}}!!! Possono essere indossate entrambe #{{REG_Comedy}} La maschera comica dà: #{{IND}}{{Tears}} +1 Firedelay #{{IND}}{{Speed}} +0.2 Velocità  #{{IND}}{{Luck}} +2 Luck #{{REG_Tragedy}} La maschera tragica dà: #{{IND}}{{Tears}} +0.5 Firedelay,  #{{IND}}{{Damage}} +1 Danno Fisso  #{{IND}}{{Range}} +2.5 Range", "Tragicommedia",FileLanguage)		
EID:addCollectible(mod.Collectibles.UMBRELLA, "All'uso Isaac apre un ombrello, facendo cadere degli incudini su di lui ofgni 5 ~ 7 secondi #{{IND}} Gli incudini creano un'onda d'urto all'atterraggio #{{IND}} Gli incudini possono essere riflessi con l'ombrello, lanciandoli contro un nemico vicino #{{IND}}!!! Le onde d'urto danneggiano Isaac solo se l'incudine non viene bloccato #!!! Usare nuovamente l'oggetto chiude l'ombrello e ferma gli incudini", "Ombrello",FileLanguage)		

for i = 1, Balatro_Expansion.TastyCandyNum do --puts every candy stage

    EID:addTrinket(Balatro_Expansion.Trinkets.TASTY_CANDY[i], "{{Beggar}} Garantisce un premio interagendo con un beggar qualunque #!!! Usi rimasti: {{ColorYellorange}}"..i, "Caramela Gustosa", FileLanguage)		
end


EID:addCollectible(mod.Collectibles.HEIRLOOM, "{{Coin}} Le monete possono avere il loro valore aumentato #{{Coin}} Tutti i pickup hanno una possibilità maggiore di essere dorati", "Cimelio",FileLanguage)		
EID:addTrinket(mod.Trinkets.PENNY_SEEDS, "{{Coin}} Crea una moneta per ogni 5 monete avute entrando in un nuovo piano #{{IND}} Bassa probabilità che le monete create siano un trinket moneta o {{Collectible74}} The quarter", "Semmy Spiccioli",FileLanguage)		
EID:addCollectible(mod.Collectibles.THE_HAND, "{{Card}} Up to 5 cards or runes can be stored in the active item #!!! Cards in excess will be destroyed #{{Chargeable}} Holding the item uses the cards stored in the order shown # Press [DROP] key to cycle the held cards # Also collects pickups and deals Danno to enemies hit", "The Hand",FileLanguage)		
EID:addCard(mod.JIMBO_SOUL, "{{Timer}} Per una stanza, bilancia il danno e le lacrime di Isaac #La durata aumenta se usata più volte", "Soul of Jimbo", FileLanguage)
EID:addTrinket(mod.Jokers.CHAOS_THEORY, "{{Collectible402}} Tutti i pickup creati sono casuali", "Chaos Theory", FileLanguage)		
EID:addCollectible(mod.Collectibles.ERIS, "{{Freezing}} Isaac ottiene un'aura congelante che rallenta progressivamente i nemici #Se rallentati abbastanza, I nemici subiscono danno ogni tick uguale al 3% dei loro HP massimi {{ColorGray}}(Min. 0.1)", "Eris",FileLanguage)		
EID:addCollectible(mod.Collectibles.PLANET_X, "{{Planetarium}} Ottieni l'effetto di un oggetto del planetario casuale ogni stanza completata", "Pianeta X",FileLanguage)		
EID:addCollectible(mod.Collectibles.CERES, "Famiglio orbitale che blocca i prioettili nemici e infligge 1 danno da contatto ogni secondo #Quando colpito, crea dei frammenti di asteroide che bloccano fino a 2 proiettili nemici e infligge 2 x il danno di Isaac", "Cerere",FileLanguage)		


Descriptions.ItemItemSynergies = {}
Descriptions.ItemItemSynergies[mod.Collectibles.FUNNY_TEETH] = {[CollectibleType.COLLECTIBLE_APPLE] = "# Lascia una scia di sangue",
                                                                [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = "# Si ricarica parzialmente uccidendo un nemico",
                                                                [CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = "# Può applicare effetti di stao casuali",
                                                                [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = "# Può applicare {{Bait}} Adescamento ai nemici",
                                                                [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Può rendere i nemici {{Coin}} dorati",
                                                                [CollectibleType.COLLECTIBLE_DEAD_TOOTH] = "# Può {{Poison}} avvelenare i nemici",
                                                                [CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = "# Può curare il possessore di {{HalfHeart}} mezzo cuore rosso uccidendo i nemici",
                                                                [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Può {{Poison}} avvelenare i nemici # Può creare un {{BlackHeart}} cuore nero ad ogni nemico ucciso",
                                                                [CollectibleType.COLLECTIBLE_DOG_TOOTH] = "# Danno e velocità aumentati",
                                                                [CollectibleType.COLLECTIBLE_TOUGH_LOVE] = "# Infligge il 35% di danno in più",
                                                                [CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = "# Quando ricaricato, rilascia un'anello di {{Collectible399}} Maw of the void minore"}
Descriptions.ItemItemSynergies[mod.Collectibles.CLOWN] = {[CollectibleType.COLLECTIBLE_BOZO] = "# Tutti nemici subiscono gli effetti",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.HORSEY] = {[CollectibleType.COLLECTIBLE_BFFS] = "# Raggio delle onde d'urto aumentato",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.HEIRLOOM] = {[CollectibleType.COLLECTIBLE_TELEKINESIS] = "# Ottieni lacrime {{Collectible2}} a ricerca",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.TRAGICOMEDY] = {[CollectibleType.COLLECTIBLE_POLAROID] = "# La {{REG_Comedy}} maschera comica è sempre attiva",
                                                                [CollectibleType.COLLECTIBLE_SOCKS] = "# La {{REG_Comedy}} maschera comica è sempre attiva",
                                                                [CollectibleType.COLLECTIBLE_NEGATIVE] = "# La {{REG_Tragedy}} maschera tragica è sempre attiva",
                                                                [CollectibleType.COLLECTIBLE_DUALITY] = "# Entrambe le maschere sono sempre attive",
                                                                }
Descriptions.ItemItemSynergies[mod.Collectibles.THE_HAND] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Lancia una fiammella per carta tenuta quando usato",
                                                             [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Infligge +0.25 danno per ogni {{Coin}} moneta tenuta # Possiblità di trasformere i nemici colpiti in statue dorate",
                                                             [CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = "# Raddoppia in danno inflitto ed aumenta la respinta causata",
                                                             [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Può {{Poison}} avvelenare i nemici colpiti",
                                                             [CollectibleType.COLLECTIBLE_VIRUS] = "# Può {{Poison}} avvelenare i nemici colpiti",
                                                             [CollectibleType.COLLECTIBLE_TELEKINESIS] = "# Riflette i proiettili colpiti",
                                                             [mod.Collectibles.THE_HAND] = "# Può tenere 5 carte aggiuntive",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.BANANA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# 8 fiammelle con frequenti lacrime esplosive"}
Descriptions.ItemItemSynergies[mod.Collectibles.EMPTY_BANANA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# 2 fiammelle orbitano attorno alle bucce lanciate"}
Descriptions.ItemItemSynergies[mod.Collectibles.UMBRELLA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Fiammella distante con alta probabilità di {{Confsion}} confondere per ogni incudine caduto",
                                                             [mod.Collectibles.UMBRELLA] = "# Tutti gli ombrelli si aprono insieme, aumentando la fraquenza degli incudini e la grandezza della copertura"}
Descriptions.ItemItemSynergies[mod.Vouchers.Director] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Fiammelle distanti che devolvono i nemici toccati"}
Descriptions.ItemItemSynergies[mod.Vouchers.Retcon] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Fiammelle distanti che devolvono i nemici toccati"}




--for faster lookup
for Item, ItemSynergies in pairs(Descriptions.ItemItemSynergies) do
    
    for Item2, SynString in pairs(ItemSynergies) do
        
        Descriptions.ItemItemSynergies[Item2] = Descriptions.ItemItemSynergies[Item2] or {}
        Descriptions.ItemItemSynergies[Item2][Item] = SynString
    end
end

--for cooler icons
for Item, ItemSynergies in pairs(Descriptions.ItemItemSynergies) do
    
    for Item2, SynString in pairs(ItemSynergies) do

        local Prefix

        if Item == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES
           or Item2 == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
            
            Prefix = "#{{VirtuesCollectible"..Item2.."}}"
        else
            Prefix = "#{{Collectible"..Item2.."}}"
        end
        
        
        Descriptions.ItemItemSynergies[Item][Item2] = string.gsub(SynString, "#", Prefix)
    end
end


Descriptions.TrinketEdition = {[mod.Edition.BASE] = "",
                               [mod.Edition.FOIL] = "#{{Tears}} {{ColorChips}}+1{{CR}} Lacrime",
                               [mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{ColorMult}}+1.5{{CR}} Danno fisso",
                               [mod.Edition.POLYCROME] = "#{{Damage}} {{ColorMult}}x1.2{{CR}} Molt. di Danno",
                               [mod.Edition.NEGATIVE] = "#{{Collectible479}} Ingoiato appena preso"
                             }



end --END EID EXCLUSIVES

return Descriptions