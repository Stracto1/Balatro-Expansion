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


Descriptions.Other.Active = "{{REG_Yellow}}Attivo!"
Descriptions.Other.NotActive = "{{REG_CMult}}Non attivo!"
Descriptions.Other.Compatible = "{{REG_Mint}}Compatibile"
Descriptions.Other.Incompatible = "{{REG_CMult}}Incompatibile"
Descriptions.Other.Ready = "{{REG_Yellow}}Pronto!"
Descriptions.Other.NotReady = "{{ColorRed}}Non pronto!"

Descriptions.Other.Enhanced = "carte potenziate"

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
                         [mod.HandTypes.FIVE_FLUSH] = "Colore Perfetto",
                         [mod.ALL_HAND_TYPES["-"]] = "Tutte le mani (-)",
                         [mod.ALL_HAND_TYPES["+"]] = "TUtte le mani (+)"}



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
Descriptions.Rarity["common"] = "{{REG_CChips}}comune"
Descriptions.Rarity["uncommon"] = "{{REG_Mint}}non comune"
Descriptions.Rarity["rare"] = "{{REG_CMult}}raro"
Descriptions.Rarity["legendary"] = "{{ColorRainbow}}leggendario"




Descriptions.Jimbo = {}
Descriptions.T_Jimbo = {}


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

Descriptions.Warning = {Title = "La mano non assegner\224 punti!",
                        [mod.BLINDS.BOSS_MOUTH] = "Puoi giocare solo [[VALUE1]] questo round",
                        [mod.BLINDS.BOSS_EYE] = "[[VALUE1]] \232 stata gi\224 giocata",
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
                            [mod.BLINDS.BOSS_LEAF] = "Carte penalizzate finch\232 un Jolly non viene venduto",
                            [mod.BLINDS.BOSS_MANACLE] = "-1 Carte in mano",
                            [mod.BLINDS.BOSS_MARK] = "Le figure sono coperte",
                            [mod.BLINDS.BOSS_MOUTH] = "Puoi giocare solo un tipo di mano",
                            [mod.BLINDS.BOSS_NEEDLE] = "Gioca solo 1 mano",
                            [mod.BLINDS.BOSS_OX] = "Giocare [[VALUE1]] fissa i soldi a 0$",
                            [mod.BLINDS.BOSS_PILLAR] = "Carte gi\224 giocate nell'ante sono penalizzate",
                            [mod.BLINDS.BOSS_PLANT] = "Le figure sono penalizzate",
                            [mod.BLINDS.BOSS_PSYCHIC] = "Devi giocare 5 carte",
                            [mod.BLINDS.BOSS_SERPENT] = "Peschi sempre 3 carte dopo mani o scarti",
                            [mod.BLINDS.BOSS_TOOTH] = "-1$ per ogni carta giocata",
                            [mod.BLINDS.BOSS_VESSEL] = "Buio molto alto",
                            [mod.BLINDS.BOSS_WALL] = "Buio molto alto",
                            [mod.BLINDS.BOSS_WATER] = "Inizia con 0 scarti",
                            [mod.BLINDS.BOSS_WHEEL] = "1 carta su 7 \232 coperta",
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

if EID then

----------------------------------------
-------------####JOKERS####-------------
----------------------------------------

--EID:addTrinket(mod.Jokers.JOKER, "\1 {{REG_CMult}}+1.2{{CR}} Danno", "Joker", FileLanguage)


Descriptions.Jimbo.Enhancement = {[mod.Enhancement.NONE]  = "",
                                  [mod.Enhancement.BONUS] = "#{{REG_Bonus}} {{REG_Yellow}}Carta Bonus{{CR}}: #{{IND}}{{Tears}} {{REG_CChips}}+0.5{{CR}} Lacrime qundo attivata",
                                  [mod.Enhancement.MULT]  = "#{{REG_Mult}} {{REG_Yellow}}Carta Molt{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}+0.05{{CR}} Danno quando attivata",
                                  [mod.Enhancement.GOLDEN] = "#{{REG_Gold}} {{REG_Yellow}}Carta Dorata{{CR}}: #{{IND}}{{Coin}} {{REG_Yellow}}+2${{CR}} se tenuta in mano quando un {{REG_Yellow}}Buio{{CR}} viene sconfitto",
                                  [mod.Enhancement.GLASS] = "#{{REG_Glass}} {{REG_Yellow}}Carta di Vetro{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}x1.2{{CR}} Molt. di Danno quando attivata ##{{IND}}!!! {{REG_Mint}}[[CHANCE]] probabilità su 10{{CR}} di venir distrutta quando attivata",
                                  --[mod.Enhancement.LUCKY] = "#{{REG_Lucky}} {{REG_Mint}}Lucky Card{{CR}}: {{REG_Mint}}[[CHANCE]]/5 Chance{{CR}} to give {{REG_CMult}}+0.2{{CR}} damage and {{REG_Mint}}[[CHANCE]]/20 Chance{{CR}} to give {{REG_Yellow}}10 {{Coin}} Pennies",
                                  [mod.Enhancement.LUCKY] = "#{{REG_Lucky}} {{REG_Yellow}}Carta Fortunata{{CR}}: #{{IND}}{{Damage}} {{REG_Mint}}[[CHANCE]] probabilità su 5{{CR}} di dare {{REG_CMult}}+0.2{{CR}} Danno #{{IND}}{{Coin}} {{REG_Mint}}[[CHANCE]] probabilità su 20{{CR}} di dare {{REG_Yellow}}10 Pennies",
                                  [mod.Enhancement.STEEL] = "#{{REG_Steel}} {{REG_Yellow}}Carta d'Acciaio{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}X1.2{{CR}} Damage Molt. when {{REG_Yellow}}held{{CR}} in hand as an hostile room is entered",
                                  [mod.Enhancement.WILD]  = "#{{REG_Wild}} {{REG_Yellow}}Carta Multiuso{{CR}}: #{{IND}} Considerata come di ogni seme",
                                  [mod.Enhancement.STONE] = "{{IND}}{{Tears}} {{REG_CChips}}+1.25{{CR}} Lacrime quando attivata #{{IND}}!!! Non ha valore o seme"
                                  }

Descriptions.Jimbo.Seal = {[mod.Seals.NONE] = "",
                           [mod.Seals.RED] = "#{{REG_Red}} {{REG_Yellow}}Sigillo Rosso{{CR}}: #{{IND}}{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} le abilità della carta",
                           [mod.Seals.BLUE] = "#{{REG_Blue}} {{REG_Yellow}}Sigillo Blu{{CR}}:  #{{IND}}{{REG_Planet}} Crea il corrispettivo {{ColorCyan}}Pianeta{{CR}} se tenuta in mano quando un {{REG_Yellow}}Buio{{CR}} viene sconfitto",
                           [mod.Seals.GOLDEN] = "#{{REG_Golden}} {{REG_Yellow}}Sigillo Dorato{{CR}}: #{{IND}}{{Coin}} Crea una {{REG_Yellow}}Moneta Temporanea{{CR}} quando attivata",
                           [mod.Seals.PURPLE] = "#{{REG_Purple}} {{REG_Yellow}}Sigillo Viola{{CR}}: #{{IND}}{{Card}} Crea un {{ColorPink}}Tarocco{{CR}} casuale quando {{ColorRed}}Scartata{{CR}} #{{IND}}!!! {{REG_Mint}}Minore probabilita{{CR}} se più sono scartate {{REG_Yellow}}insieme",
                           }

Descriptions.Jimbo.CardEdition = {[mod.Edition.BASE] = "",
                                  [mod.Edition.FOIL] = "#{{REG_Foil}} {{REG_Yellow}}Foil{{CR}}: {{REG_CChips}}+1.25{{CR}} Lacrime quando attivata",
                                  [mod.Edition.HOLOGRAPHIC] = "#{{REG_Holo}} {{REG_Yellow}}Olografica{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}+0.25{{CR}} Danno wuando attvata",
                                  [mod.Edition.POLYCROME] = "#{{REG_Poly}} {{REG_Yellow}}Policroma{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}x1.2{{CR}} Molt. di Danno quando attivata",
                                  [mod.Edition.NEGATIVE] = "#{{REG_Nega}} {{REG_Yellow}}Negativa{{CR}}: #{{IND}} scemo chi legge (fra come cazzo la hai trovata)"
                                }

Descriptions.Jimbo.JokerEdition = {[mod.Edition.NOT_CHOSEN] = "",
                                   [mod.Edition.BASE] = "",
                                   [mod.Edition.FOIL] = "#{{REG_Foil}} {{REG_Yellow}}Foil{{CR}}: #{{IND}}{{Tears}} {{REG_CChips}}+3.5{{CR}} Lacrime",
                                   [mod.Edition.HOLOGRAPHIC] = "#{{REG_Holo}} {{REG_Yellow}}Olografico{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}+0.5{{CR}} Danno",
                                   [mod.Edition.POLYCROME] = "#{{REG_Poly}} {{REG_Yellow}}Polycroma{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}X1.25{{CR}} Molt. di Danno",
                                   [mod.Edition.NEGATIVE] = "#{{REG_Nega}} {{REG_Yellow}}Negativo{{CR}}: #{{IND}} {{REG_Yellow}}+1{{CR}} Joker Slot"
                                   }


Descriptions.Jimbo.Jokers = {}
do
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER] = "{{Damage}} {{REG_CMult}}+0.2{{CR}} Danno"
Descriptions.Jimbo.Jokers[mod.Jokers.BULL] = "{{Tears}} {{REG_CChips}}+0.1{{CR}} Lacrime per {{Coin}} {{REG_Yellow}}monete{{CR}} avuta #{{Blank}} {{ColorGray}} (Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Vendere questo Jolly dopo {{REG_Yellow}}3{{CR}} Bui sconfitti duplica un Jolly tenuto [[VALUE2]] #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]]) #{{Confusion}} I nemici rimangono confusi per 2.5 secondi entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{Damage}} {{REG_CMult}}+0.15{{CR}} Danno per Jolly tanuto #{{Damage}} {{REG_CMult}}+0.03{{CR}} Danno per Oggetto avuto #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.MISPRINT] = "{{Damage}} {{REG_CMult}}+0-1{{CR}} Danno casuale ogni stanza #{{Collectible721}} {{REG_Mint}}[[CHANCE]] probabilità su 10{{CR}} di rendere un oggetto {{REG_Yellow}}glitchato"
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{Damage}} {{REG_CMult}}X0.75{{CR}} Molt. di Danno per ogni slot Jolly {{REG_Yellow}}vuoto{{CR}} #!!! {{REG_Yellow}}Forma di Jolly{{CR}} inclusa #{{Damage}} {{REG_CMult}}X0.25{{CR}} Molt. di Danno se nonsi ha un {{REG_Yellow}}{{Collectible}} oggetto attivo{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.STONE_JOKER] = "{{Tears}} {{REG_CChips}}+1.25{{CR}} Lacrime per {{REG_Yellow}}Carta di Pietra{{CR}} nel mazzo completo #{{Tears}} {{REG_CChips}}+0.05{{CR}} Lacrime per roccia nella stanza#{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.ICECREAM] = "{{Tears}} {{REG_CChips}}+[[VALUE1]]{{CR}} Lacrime#!!! Perde {{REG_CChips}}-0.25{{CR}} Lacrime ogni stanza completata #Crea una scia di pozze rallentanti #{{IND}}{{Freezing}} I nemici uccisi sopra essa vengono congelati"
Descriptions.Jimbo.Jokers[mod.Jokers.POPCORN] = "{{Damage}} {{REG_CMult}}+[[VALUE1]]{{CR}} Danno #!!! Parde {{REG_CMult}}-0.2{{CR}} Danno ogni buio sconfitto #Casualmente lancia popcorn esplosivo"
Descriptions.Jimbo.Jokers[mod.Jokers.RAMEN] = "{{Damage}} {{REG_CMult}}X[[VALUE1]]{{CR}}Molt. di Danno#!!! Perde {{REG_CMult}}-0.01X{{CR}} Molt. di Danno ogni carta scartata #{{Collectible682}} Ottieni una versione indebilita di Worm Friend"
Descriptions.Jimbo.Jokers[mod.Jokers.ROCKET] = "{{Coin}} {{REG_Yellow}}+[[VALUE1]] {{Coin}} Monete{{CR}} quando un Buio viene sconfitto#{{IND}}{{Coin}} La ricompensa aumenta di {{REG_Yellow}}2{{CR}} quando un {{REG_Yellow}}Buio Boss{{CR}} viene sconfitto #{{Collectible583}} Dà l'effetto di Rocket in Jar"
Descriptions.Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{Tears}} Le carte {{REG_Yellow}}Dispari{{CR}} danno {{REG_CChips}}+0.31{{CR}} Lacrime quando attivate#{{Tears}} {{REG_CChips}}+0.15{{CR}} Lacrime per oggetto avuto se il numero totale è dispari"
Descriptions.Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{Damage}} Le carte {{REG_Yellow}}Pari{{CR}} danno {{REG_CMult}}+0.04{{CR}} Danno quando attivata #{{Damage}} {{REG_CMult}}+0.02{{CR}} Danno per oggetto tenuto se il numero totale è pari"
Descriptions.Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{Card}} {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} to creare un {{ColorPink}}Tarocco{{CR}} casuale aprendo un {{REG_Yellow}}Busta di Espansione{{CR}} #{{Collectible431}} Dà l'effetto di Multidimensional Baby"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "{{Damage}}{{REG_CMult}}+0.03{{CR}} Danno per stanza completata #{{Damage}}{{REG_CMult}}-0.15{{CR}}Danno ogni mano scartata #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{Damage}}{{REG_CMult}}+0.15{{CR}} Danno per {{REG_Yellow}}Busta di Espansione{{CR}} saltato #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.VAGABOND] = "Crea un {{Card}}{{ColorPink}}Tarocco{{CR}} casuale completando una stanza con {{REG_Yellow}}massimo 2 {{Coin}} Monete{{CR}} #{{Beggar}} {{REG_Mint}}[[CHANCE]] probabilità su 10{{CR}} di creare un {{REG_Yellow}}Beggar{{CR}} casuale completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "{{REG_Joker}} crea un Jolly {{REG_CChips}}comune{{CR}} casuale quando un Buio viene sconfitto"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "{{Coin}} {{REG_Yellow}}+4 {{Coin}} Monete{{CR}} quando un Buio viene sconfitto #{{Collectible202}} I nemici toccati diventano {{REG_Yellow}}dorati{{CR}} per un po'"
Descriptions.Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{Damage}} {{REG_CMult}}+0.04{{CR}} Danno per {{Card}}{{ColorPink}}Tarocco{{CR}} usato questa partita #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno) #{{Collectible451}} Dà l'effetto di Tarot Cloth"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "{{REG_Retrigger}} Copia il Jolly alla sua destra"
Descriptions.Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "{{REG_Retrigger}} Copia il Jolly più a sinistra"
Descriptions.Jimbo.Jokers[mod.Jokers.MADNESS] = "Distrugge un altro Jolly casuale e ottiene {{REG_CMult}}X0.1{{CR}} Molt. di Danno ogni {{REG_Yellow}}Piccolo e Grande Buio{{CR}} sconfitti#{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.MR_BONES] = "Resuscuta a cuori pieni se solo {{REG_Yellow}}1{{CR}} Buio non è stato sconfitto #!!! I Bui non disponibili contano come sconfitti #{{REG_Mint}}[[CHANCE]] probabilità su 5{{CR}} di attivare {{Collectible545}} Book of the Dead completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{Damage}} Le carte di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} danno {{REG_CMult}}+0.07{{CR}} Danno quando attivate #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno) #{{Bomb}} Le esplosioni di {{ColorClub}}Fiori{{CR}} sono più frequenti, più grandi infliggono più danno"
Descriptions.Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{Tears}} Le carte di {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} danno {{REG_CChips}}+0.5{{CR}} Lacrime quando attivate #{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime) #{{Confusion}} Le carte di {{REG_CSpade}}Picche{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} di rallentare e confondere"
Descriptions.Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{Damage}} Le carte di {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} di dare {{REG_CMult}}X1.05{{CR}} Molt. di Danno quando attivate #{{REG_Heart}} Le carte di {{REG_CMult}}Cuori{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilità su 5{{CR}} di {{Charm}} ammaliare"
Descriptions.Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{Coin}} Le carte di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} hannoa {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} di creare una {{Coin}} {{REG_Yellow}}Moneta Temporanea{{CR}} quando attivate #{{Collectible506}} Le carte di  {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} hanno anche l'effetto di {{REG_Yellow}}Backstabber"

Descriptions.Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{Damage}} {{REG_CMult}}+0.75{{CR}} Danno #{{Warning}} {{REG_Mint}}[[CHANCE]] probabilità su 6{{CR}} di distruggersi quando un Buio viene sconfitto"
Descriptions.Jimbo.Jokers[mod.Jokers.CAVENDISH] = "{{Damage}} {{REG_CMult}}X2{{CR}} Molt. di Danno #{{Warning}} {{REG_Mint}}[[CHANCE]] probabilità su 1000{{CR}} di distruggersi quando un Buio viene sconfitto"
Descriptions.Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "{{Damage}} {{REG_CMult}}+0.04{{CR}} Danno per {{RestockMachine}} Restock machine attivata #{{Collectible105}} {{Damage}} {{REG_CMult}}+0.02{{CR}} Danno per {{REG_Yellow}}Dado{{CR}} usato #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Distrugge il Jolly alla sua destra e ottiene {{REG_CMult}}+0.08 x il suo valore di vendita{{CR}} in Danno qunado un Buio viene sconfitto #{{Blank}} {{colorGray}}(Attualmente {{ColorMukt}}+[[VALUE1]]{{ColorGray}} Danno) #{{Collectible705}} Attiva Dark Arts per 2.5 secondi entrando in una stanza ostile"
Descriptions.Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "{{Coin}} {{REG_Yellow}}+1${{CR}} per {{REG_Yellow}}9{{CR}} nel tuo mazzo completo #{{Blank}} {{ColorGray}}(Attualmente  {{REG_Yellow}}[[VALUE1]]{{ColorGray}} Coins){{CR}} #{{Seraphim}} Dà volo"
Descriptions.Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "{{Damage}} {{REG_CMult}}+0.07 X il valore di vendita totale dei Jolly avuto{{CR}} in Danno"
Descriptions.Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "{{Card}} Crea un {{ColorPink}}Tarocco{{CR}} casuale quando un Buio viene sconfitto #{{Card}} {{REG_Mint}}[[CHANCE]] probabilità su 20{{CR}} per ogni pickup di essere un {{ColorPink}}Tarocco"
Descriptions.Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{Damage}} {{REG_CMult}}X2{{CR}} Molt. di Danno ogni 6 stanze completate #{{Blank}} {{ColorGray}} [[VALUE1]]"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "{{Damage}} Le carte attivate danno {{REG_CMult}}+0.01{{CR}} Danno per volta che carte con lo stesso {{REG_Yellow}}Valore{{CR}} sono state attivate nella stanza corrente"
Descriptions.Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "{{Coin}} {{REG_Yellow}}+1 Moneta{{CR}} per {{Heart}} cuore quando si completa una stanza a {{REG_Yellow}}vita piena{{CR}} #{{Timer}} Le porte per {{BossRoom}} Bossrush e {{Hush}} Hush vangono aperte a prescindere dal timer di gioco"
Descriptions.Jimbo.Jokers[mod.Jokers.EGG] = "{{Coin}} Il suo valore di vendita aumenta di {{REG_Yellow}}3 monete{{CR}} ogni Buio sconfitto #Ottieni un famiglio difensivo"
Descriptions.Jimbo.Jokers[mod.Jokers.DNA] = "Se la {{REG_Yellow}}Prima{{CR}} carta giocata di un {{REG_Yellow}}Buio{{CR}} colpisce un nemico, ne viene aggiunta una copia al mazzo #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}}) #{{Collectible658}} Crea un Mini-Isaac completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = " {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} e {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} contano come lo stesso seme # {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} e {{REG_Club}} {{ColorBlue}}Fiori{{CR}} contano come lo stesso seme"

Descriptions.Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{Tears}} {{REG_CChips}}+5{{CR}} Lacrime se una {{REG_Yellow}}Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{Tears}} {{REG_CChips}}+10{{CR}} Lacrime se un {{REG_Yellow}}Tris{{CR}} è tenuto in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{Tears}} {{REG_CChips}}+7{{CR}} Lacrime se una {{REG_Yellow}}Doppia Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{Tears}} {{REG_CChips}}+15{{CR}} Lacrime se una {{REG_Yellow}}Scala{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{Tears}} {{REG_CChips}}+12{{CR}} Lacrime se un {{REG_Yellow}}Colore{{CR}} è tenuto in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{Damage}} {{REG_CMult}}+0.75{{CR}} Danno se una {{REG_Yellow}}Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{Damage}} {{REG_CMult}}+2{{CR}} Danno se un {{REG_Yellow}}Tris{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{Damage}} {{REG_CMult}}+1.75{{CR}} Danno se una {{REG_Yellow}}Doppia Coppia{{CR}} è tenuta in mano entrando in una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{Damage}} {{REG_CMult}}+3{{CR}} Danno se una {{REG_Yellow}}Scala{{CR}} è tenuta in mano entrando in una stanza"

Descriptions.Jimbo.Jokers[mod.Jokers.MIME] = "{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} le abilità {{REG_Yellow}}tenute in mano{{CR}} #{{REG_Mint}}[[CHANCE]] probabilità su 3{{CR}} di copiare l'effetto di un Oggetto Attivo usato"
Descriptions.Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{REG_Yellow}}Colori{{CR}} e {{REG_Yellow}}Scale{{CR}} richiedono solo 4 carte #Ogni quinto nemico {{REG_Yellow}}(non boss){{CR}} creato viene ucciso immediatamente"
Descriptions.Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{Damage}} Le carte di {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} danno {{REG_CMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{Damage}} Le carte di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} danno {{REG_CMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{Damage}} Le carte di {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} danno {{REG_CMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{Damage}} Le carte di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} danno {{REG_CMult}}+0.03{{CR}} Danno quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{Heart}} {{REG_Yellow}}+2{{CR}} Hp #{{REG_HSize}}  {{REG_CMult}}-2{{CR}} Carte in mano #{{Heart}} Cura di mezzo cuore aggiuntivo completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{Damage}} {{REG_CMult}}+1.5{{CR}} Danno se {{REG_Yellow}}fino a 5{{CR}} sono state giocate nella stanza #{{REG_CMult}}+1{{CR}} Danno havendo {{REG_Yellow}}fino a 3{{CR}} carte in mano #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Permette di andare in {{REG_Yellow}}debito{{CR}} #{{Shop}} Oggetti in vendita possono essere comprati con massimo {{REG_CMult}}-20${{CR}} in debito #!!! Gli {{REG_Yellow}}Interessi{{CR}} e effetti {{REG_Yellow}}basati sulle monete{{CR}} non sono attivi se in debito"

Descriptions.Jimbo.Jokers[mod.Jokers.BANNER] = "{{Tears}} {{REG_CChips}}+1.5{{CR}} Lacrime per {{Heart}} {{REG_Yellow}}Cuore pieno #{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime) #Uno stendardo appare entrando in una stanza #{{IND}}{{Tears}} Stare vicino allo stendardo dà {{REG_CChips}}+3{{CR}} Lacrime"
Descriptions.Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{Damage}} {{REG_CMult}}+1.5{{CR}} Danno avendo solo {{REG_Yellow}}1{{CR}} {{Heart}} cuore pieno #{{Heart}} Crea cuori invece di curarti a fine stanza #{{Collectible335}} Attiva un'{{REG_Yellow}}aura repellente{{CR}} mentre attivo"
Descriptions.Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "{{REG_Stone}} Aggiunge una {{REG_Yellow}}Carta di Pietra{{CR}} al mazzo ogni {{REG_Yellow}}Buio{{CR}} sconfitto #{{REG_Mint}}[[CHANCE]] probabilità su 100{{CR}} aggiuntiva di generare delle {{REG_Yellow}}Tinted Rock"
Descriptions.Jimbo.Jokers[mod.Jokers._8_BALL] = "{{Card}} Gli {{REG_Yellow}}8{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilità su 8{{CR}} di creare un {{Card}} {{ColorPink}}Tarot{{CR}} tarocco casuale quando attivati #{{Shotspeed}} +0.16 Shot Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.DUSK] = "{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} le {{REG_Yellow}}ultime 10{{CR}} carte giocabili #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "{{Damage}} {{REG_CMult}}+0.05{{CR}} Danno {{REG_Yellow}}X il Valore{{CR}} più basso delle carte {{REG_Yellow}}tenute in mano{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{Collectible376}} Tutti gli {{Shop}} Shop e {{Treasure}} Treasure hanno una Restock Machine aggiuntiva"
Descriptions.Jimbo.Jokers[mod.Jokers.FIBONACCI] = "{{Damage}} Gli {{REG_Yellow}}Assi{{CR}}, {{REG_Yellow}}2{{CR}}, {{REG_Yellow}}3{{CR}}, {{REG_Yellow}}5{{CR}} e {{REG_Yellow}}8{{CR}} danno {{REG_CMult}}+0.08{{CR}} Danno quando attivati #{{Damage}} {{REG_CMult}}+0.05{{CR}} Danno per {{Collectible}} oggetto avuto se il numero totale è nella sequanza di {{REG_Yellow}}Fibonacci #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "{{Damage}} Ottiene {{REG_CMult}}X0.15{{CR}} Molt. di Danno per {{ColorSilver}}Carta d'Acciaio{{CR}} nel mazzo completo #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{Tears}} Le {{REG_Face}} {{REG_Yellow}}Figure{{CR}} danno {{REG_CChips}}+0.3{{CR}} Lacrime quando attivate #{{Tears}} Uccidere un {{REG_Yellow}}Champion{{CR}} dà {{REG_CChips}}+1{{CR}} Lacrime"
Descriptions.Jimbo.Jokers[mod.Jokers.HACK] = "{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} i {{REG_Yellow}}2{{CR}}, {{REG_Yellow}}3{{CR}}, {{REG_Yellow}}4{{CR}} e {{REG_Yellow}}5{{CR}} giocati #\1 Ottieni una copia degli oggetti {{Quality0}} e {{Quality1}} avuti"
Descriptions.Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "{{REG_Face}} Ogni carta conta come {{REG_Yellow}}Figure{{CR}} #{{REG_Mint}}[[CHANCE]] probabilità su 5{{CR}} aggiuntiva per ongi nemico non boss di essere un {{REG_Yellow}}Champion"

Descriptions.Jimbo.Jokers[mod.Jokers.SCHOLAR] = "\1 Gli {{REG_Yellow}}Assi{{CR}} danno {{REG_CChips}}+0.2{{CR}} Lacrime e {{REG_CMult}}+0.04{{CR}} Danno quando attivati #{{Luck}} {{REG_Mint}}+5{{CR}} Fortuna"
Descriptions.Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{Coin}} Le {{REG_Yellow}}Figure{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} di creare {{REG_Yellow}}2 Monete Temporanee{{CR}} quando attivate #{{Collectible602}} Ottieni l'effetto di Member Card"
Descriptions.Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{Damage}} {{REG_CMult}}+0.01{{CR}} Danno per carte {{REG_Yellow}}non Figura{{CR}} giocate consecutivamente #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{REG_Planet}} {{REG_Mint}}[[CHANCE]] probabilità su 20{{CR}} di potenziare il livello del {{REG_Yellow}}Valore{{CR}} attivato # {{REG_Mint}}[[CHANCE]] probabilità su 20{{CR}} per oggetto {{REG_Yellow}}Stellare{{CR}} avuto"
Descriptions.Jimbo.Jokers[mod.Jokers.BURGLAR] = "!!! Fissa gli Hp a {{ColorRed}}2{{CR}} Cuori #\1 Le carte sono giocabili fino al {{REG_Yellow}}rimischio{{CR}} del mazzo"
Descriptions.Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{Damage}} {{REG_CMult}}X2{{CR}} Molt. di Danno se tutte le carte in mano sono di {{REG_CSpade}}Picche{{CR}} o {{REG_CChips}}Fiori"
Descriptions.Jimbo.Jokers[mod.Jokers.RUNNER] = "{{Tears}} Ottiene {{REG_CChips}}+1.5{{CR}} Lacrime entrando in una stanza ostile {{REG_Yellow}}inesplorata{{CR}} tenendo una {{REG_Yellow}}Scala{{CR}} #{{Tears}} Dà {{REG_CChips}}+Lacrime{{CR}} uguali alla statistica di {{Speed}} velocità #{{Blank}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Fiches) #{{Speed}} +0.1 Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.SPLASH] = "{{REG_Retrigger}} Attiva le carte tenute in mano entrando in una stanza {{REG_Yellow}}ostile"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{Tears}} {{REG_CChips}}+0.15{{CR}} Lacrime per carta rimenente nel mazzo #{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "{{REG_Spectral}} Se la {{REG_Yellow}}prima{{CR}} carta attivata di un {{REG_Yellow}}Buio{{CR}} è un {{REG_Yellow}}6{{CR}} e colpisce un nemico, si distrugge e crea una {{ColorBlue}}Busta Spettrale{{CR}} #{{Collectible3}} 1 lacrima ogni 4 ottiene homing"
Descriptions.Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "{{Damage}} Ottiene {{REG_CMult}}+0.05X{{CR}} Molt. di Danno ogni {{ColorCyan}}Carta Pianeta{{CR}} uasta #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno) #{{Collectible}} Gli oggetti {{REG_Yellow}}Stellari{{CR}} avuti danno {{REG_CMult}}X1.1{{CR}} Molt. di Danno"
Descriptions.Jimbo.Jokers[mod.Jokers.HIKER] = "{{Coin}} Le carte ottengono {{REG_CMult}}+0.02{{CR}} Lacrime {{REG_Yellow}}permanenti{{CR}} quando attivate"
Descriptions.Jimbo.Jokers[mod.Jokers.FACELESS] = "{{Coin}} {{REG_Yellow}}+3 Monete{{CR}} scartando almeno {{REG_Yellow}}2{{CR}} {{REG_Face}} Figure insieme #Se solo nemici {{REG_Yellow}}champion{{CR}} sono presenti, vengono tutti {{REG_Yellow}}uccisi istantaneamente{{CR}} #{{IND}}{{Coin}} I nemici uccisi creano una {{REG_Yellow}}moneta temporanea"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "{{Card}} Entrando in una stanza ostile {{REG_Yellow}}inesplorata{{CR}} tenendo una {{REG_Yellow}}Scala{{CR}} ed un {{REG_Yellow}}Asso{{CR}} crea un {{ColorPink}}Pacco Arcano{{CR}} #{{Collectible128}} +2 mosche Forever Alone"
--Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{REG_Yellow}}[[VALUE1]]s{{CR}} spawn a {{REG_Yellow}}temporary {{Coin}} penny{{R}} quando attivata #!!! {{ColorGray}}(Rank changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{Coin}} Uccidere i nemici nell'{{REG_Yellow}}ordine{{CR}} indicato dalla {{Coin}} sopra di essi ricompensa con una moneta"


Descriptions.Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{Damage}} {{REG_CMult}}X1.1{{CR}} Molt. di Danno giocando 2 carte con lo stesso valore {{REG_Yellow}}di fila{{CR}} #{{IND}}!!! Le {{REG_Yellow}}Carte di Pietra{{CR}} non hanno alcun effetto #{{Collectible665}} Permette di vedere i contenu di {{REG_Yellow}}casse{{CR}} e {{REG_Yellow}}sacchette"
Descriptions.Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "{{Tears}} {{REG_CChips}}+4{{CR}} Lacrime ogni quarta carta giocata #{{Pill}} Ottiene {{REG_CChips}}+0.4{{CR}} Lacrime ogni uso della pillola {{REG_Yellow}}Retro Vision{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.SEANCE] = "{{REG_Spectral}} Crea una {{REG_Yellow}}Busta Spettrale{{CR}} entrando in una stanza ostile {{REG_Yellow}}inesplorata{{CR}} avendo una {{REG_Yellow}}Scala Colore{{CR}} in mano #{{Collectible727}} {{REG_Mint}}[[CHANCE]] possibilità su 6{{CR}} di creare una {{REG_Yellow}}Hungry Soul{{CR}} uccidendo un nemico"
Descriptions.Jimbo.Jokers[mod.Jokers.VAMPIRE] = "{{Damage}} Quando una carta {{REG_Yellow}}Potenziata{{CR}} è giocata, ottiene {{REG_CMult}}X0.02{{CR}} Molt. di Danno e rimuove il {{REG_Yellow}}Potenziamento {{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Le {{REG_Yellow}}Scale{{CR}} possono contenere salti si {{REG_Yellow}}1 Valore{{CR}} #{{Collectible84}} Crea un {{REG_Yellow}}Crawl space{{CR}} in una stanza casuale di ogni piano #{{Collectible84}} Apre tutte le {{REG_Yellow}}Stanze Segrete"
Descriptions.Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "{{Damage}} Ottiene {{REG_CMult}}X0.1{{CR}} Molt. di Danno quando una carta viene {{REG_Yellow}}aggiunta{{CR}} al mazzo #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"

Descriptions.Jimbo.Jokers[mod.Jokers.BARON] = "{{Damage}} I {{REG_Yellow}}Re{{CR}} tenuti in mano danno {{REG_CMult}}X1.2{{CR}} Molt. di Danno entrando in una stanza ostile #{{Quality4}} {{REG_CMult}}X1.25{{CR}} Molt. di Danno per oggetto Q4 avuto #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.OBELISK] = "{{Damage}} Ottiene {{REG_CMult}}X0.1{{CR}} Molt. di Danno per carta giocata con un {{REG_Yellow}}Seme{{CR}} diverso dalla precedente {{REG_Yellow}}di fila{{CR}} #{{IND}}!!! Azzerato ogni stanza completata #{{IND}}!!! {{REG_Yellow}}Stone cards{{CR}} have no effect #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.MIDAS] = "{{REG_Gold}} Le {{REG_Face}} {{REG_Yellow}}Figure attivate{{CR}} diventano {{REG_Yellow}}Dorate{{CR}} #I nemici {{REG_Yellow}}Champion{{CR}} rimangono dorati per un po' quando creati"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{Shop}} {{REG_Yellow}}Vandere{{CR}} questo Jolly crea un'esplosione {{Collectible483}} Mama Mega! e {{Weakness}} indebolisce tutti i {{REG_Yellow}}Boss{{CR}} nella stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "{{Damage}} La prima {{REG_Face}} {{REG_Yellow}}Figura attivata{{CR}} della stanza dà {{REG_CMult}}X1.25{{CR}} Molt. di Danno quando attivata #{{Damage}} {{REG_CMult}}X1.5{{CR}} Molt. di Danno se il primo neico ucciso della stanza è un {{REG_Yellow}}Champion #{{Collectible327}} Puù aprire la {{REG_Yellow}}Srange Door"
Descriptions.Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "{{Coin}} Ogni Jolly avuto ottieno {{REG_Yellow}}+1{{CR}} valore di vednita quando un Buio viene sconfitto #{{Shop}} I prezzi sono ridotti di {{REG_Yellow}}1 Moneta"
Descriptions.Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{REG_HSize}} {{REG_Yellow}}+[[VALUE1]]{{CR}} Carte in mano #{{IND}}!!! Ottiene {{ColorRed}}-1{{CR}} Carte in mano quando un Buio viene sconfitto #{{Collectible594}} Ottieni l'effetto do Jupiter"
Descriptions.Jimbo.Jokers[mod.Jokers.EROSION] = "{{Damage}} Ottiene {{REG_CMult}}+0.15{{CR}} Danno ad ongi carta {{REG_Yellow}}Distrutta{{CR}} #{{Damage}} Ottiene {{REG_CMult}}+0.05{{CR}} Danno per {{REG_Yellow}}Tinted Rock{{CR}} {{REG_Yellow}}Distrutta{{CR}} #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "{{Coin}} Le {{REG_Face}} {{REG_Yellow}}Figure{{CR}} tanute in manoo hanno {{REG_Mint}}[[CHANCE]] probabilità su 4{{CR}} di creare una moneta completando una stanza #{{Coin}} Uccidendo un nemico, gli altri {{REG_Yellow}}Champion{{CR}} creano una {{REG_Yellow}}Moneta Temporanea"

Descriptions.Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "{{Coin}} {{REG_Yellow}}+2 Monete{{CR}} per {{REG_Yellow}}[[VALUE1]]{{CR}} scartato #{{Blank}} {{ColorGray}}(Valore cambia ogni stanza)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "{{Coin}} Gli {{REG_Yellow}}Interessi{{CR}} sono {{REG_Yellow}}Raddoppiati"
Descriptions.Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{REG_HSize}} {{REG_Yellow}}+1{{CR}} Carte in mano #\1 {{REG_Yellow}}+1{{CR}} slot consumabili"
Descriptions.Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{Heart}} {{REG_Yellow}}+1{{CR}} Health up #{{Heart}} Cura di mezzo cuore aggiuntivo completando una stanza"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "{{Damage}} Ottiene {{REG_CMult}}X0.02{{CR}} Molt. di Danno quando una {{REG_Yellow}}Carta Fortunata{{CR}} si attiva con {{REG_Mint}}Successo{{CR}} o quando una {{Slotmachine}} Slot dà un premio #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{Damage}} {{REG_CMult}}X1.25{{CR}} Molt. di Danno per Jolly {{REG_Mint}}non comune{{CR}} avuto #{{Damage}} {{REG_CMult}}X1.1{{CR}} Molt. di Danno per oggetto {{Quality2}} avuto #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{Shop}} {{REG_Yellow}}Vendere{{CR}} questo Jolly attiva l'effetto di {{Collectible347}} Diplopia"

Descriptions.Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "{{Shop}} {{REG_Yellow}}Vendendo{{CR}} questo Jolly, tutte le carte in mano vengono {{REG_Yellow}}Distrutte{{CR}} e danno danno {{REG_Yellow}}+2 {{Coin}} Monete"
Descriptions.Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "{{Damage}} Ottiene {{REG_CMult}}+0.25{{CR}} Danno se una {{REG_Yellow}}Doppia Coppia{{CR}} è tenuta entrando in una stanza ostile #{{Damage}} {{REG_CMult}}+0.1{{CR}} Danno per {{REG_Yellow}}costume{{CR}} visibile #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "#{{Damage}} Le Carte di [[VALUE1]]{{CR}} danno {{REG_CMult}}X1.05{{CR}} Molt. di Danno quando attivate #{{ColorGray}}(Seme cambia ogni stanza)"
Descriptions.Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "\1 I {{REG_Yellow}}10{{CR}} e {{REG_Yellow}}4{{CR}} danno {{REG_CChips}}+0.1{{CR}} Lacrime e {{REG_CMult}}+0.04{{CR}} Danno quando attivati"
Descriptions.Jimbo.Jokers[mod.Jokers.SELTZER] = "{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} le prossime {{REG_Yellow}}[[VALUE1]]{{CR}} carte giocate"
Descriptions.Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{Damage}} Le {{REG_Face}} {{REG_Yellow}}Figure{{CR}} danno {{REG_CMult}}+0.05{{CR}} Danno quando attivate #{{Damage}} Uccidere un {{REG_Yellow}}Champion{{CR}} dà {{REG_CMult}}+0.15{{CR}} Danno #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "{{Damage}} Ottiene {{REG_CMult}}X0.2{{CR}} Molt. di Danno per Jolly venduto nel {{REG_Yellow}}Piano corrente #!!! I Jolly possono essere presi anche ad inventario pieno, ma sono venduti automaticamente senza monete in cambio #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CASTLE] = "{{Tears}} Ottiene {{REG_CChips}}+0.04{{CR}} Lacrime per {{REG_Yellow}}[[VALUE1]]{{CR}} scartato #{{ColorGray}}(Valore cambia ongi stanza) #{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE2]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{REG_Gold}} Le {{REG_Yellow}}Carte Dorate{{CR}} danno {{REG_Yellow}}+1 {{Coin}} Moneta{{CR}} quando attivate #{{Collectible202}} Ogni pickup ha {{REG_Mint}}[[CHANCE]] probabilità su 25{{CR}} di diventare la sua variante {{REG_Yellow}}dorata"
Descriptions.Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{Damage}} Le {{REG_Yellow}}Ultime 5{{CR}} carte giocabili {{REG_CMult}}X1.1{{CR}} Molt. di Danno quando attivate #{{Damage}} {{REG_CMult}}X1.5{{CR}} Molt. di Danno durante le {{BossRoom}} bossfight #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]] {{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = '{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} le {{REG_Face}} {{REG_Yellow}}Figure{{CR}} giocate #{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} gli effetti Jolly ad "Uccisione di Champion"'
Descriptions.Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{REG_HSize}} {{REG_Yellow}}+2{{CR}} Carte in mano #{{REG_Hand}} {{ColorBlue}}-5{{CR}} carte giocabili"
Descriptions.Jimbo.Jokers[mod.Jokers.THROWBACK] = "{{Damage}} {{REG_CMult}}X0.1{{CR}} Molt. di Danno per {{REG_Yellow}}Buio{{CR}} slatato questa partita #{{Damage}} {{REG_CMult}}X0.02{{CR}} Molt. di Danno per {{REG_Yellow}}Stanza Speciale{{CR}} saltata questa partita #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "{{REG_Red}} Aggiunge una carta con un {{REG_Yellow}}Sigillo Casuale{{CR}} al mazzo qunado un Buio viene sconfitto #{{Collectible75}} Ottieni l'effetto do PHD"
Descriptions.Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{REG_Retrigger}} {{REG_Yellow}}Riattiva{{CR}} 3 volte la prima {{REG_Yellow}}carta{{CR}} giocata in una stanza #{{Card}} La {{REG_Yellow}}prima{{CR}} carta usata di un piano crea una copia di sè stessa qunado usata"
Descriptions.Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "{{Damage}} Ottiene {{REG_CMult}}X0.2{{CR}} Molt. di Danno per {{REG_Yellow}}Carta di Vetro{{CR}} distrutta  #{{IND}}!!! {{REG_Mint}}Raddioppia{{CR}} la possibilità di rottura #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{REG_Yellow}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{REG_Yellow}}Oggetti{{CR}}, {{REG_Yellow}}Jolly{{CR}} e {{REG_Yellow}}Carte{{CR}} possono apparire molteplici volte"
Descriptions.Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{Damage}} {{REG_CMult}}X2{{CR}} Molt. di Danno se ogni {{REG_Yellow}}Seme{{CR}} è tenuto in mano entrando in una stanza ostile #{{Charm}} Crea 3 fiori ammalianti nelle stanze ostili"
Descriptions.Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "{{Tears}} Ottiene {{REG_CChips}}+0.04{{CR}} Lacrime quando un {{REG_Yellow}}2{{CR}} viene attivato #\1 Size down #{{Blank}} {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Lacrime)"
Descriptions.Jimbo.Jokers[mod.Jokers.OOPS_6] = "{{Luck}} Ogni {{REG_Mint}}Probabilità{{CR}} è raddoppiata #{{Collectible46}} Ottieni l'effetto di Lucky Foot"
Descriptions.Jimbo.Jokers[mod.Jokers.IDOL] = "{{Damage}} [[VALUE1]]{{CR}} dà {{REG_CMult}}X1.1{{CR}} Molt. di Danno quando attivato #{{ColorGray}} (Carta cambia ongi stanza) #{{Damage}} {{REG_CMult}}X2{{CR}} Molt. di Danno per {{REG_Yellow}} {{Collectible[[VALUE2]]}} [[VALUE3]]{{CR}} avuto"
Descriptions.Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{Damage}} {{REG_CMult}}X1.2{{CR}} Molt. di Danno se sia una carta di {{ColorClub}}Fiori{{CR}} che una {{REG_Yellow}}non di Fiori{{CR}} sono tenute entrando in una stanza ostile#{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}[[VALUE1]]{{CR}})"
Descriptions.Jimbo.Jokers[mod.Jokers.MATADOR] = "{{Coin}} {{REG_Yellow}}+4 monete{{CR}} subendo danno da un {{REG_Yellow}}Boss"
Descriptions.Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "{{Damage}} Ottiene {{REG_CMult}}X0.2{{CR}} Molt. di Danno per {{REG_Yellow}}Jack{{CR}} scartato #{{IND}}!!! {{REG_Yellow}}(Azzerato ogni stanza) #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.DUO] = "{{Damage}} {{REG_CMult}}X1.25{{CR}} Molt. di Danno se una {{REG_Yellow}}Coppia{{CR}} è tenuta entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIO] = "{{Damage}} {{REG_CMult}}X1.5{{CR}} Molt. di Danno se un {{REG_Yellow}}Tris{{CR}} è tenuto entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.FAMILY] = "{{Damage}} {{REG_CMult}}X2{{CR}} Molt. di Danno se un {{REG_Yellow}}Poker{{CR}} è tenuto entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.ORDER] = "{{Damage}} {{REG_CMult}}X2.5{{CR}} Molt. di Danno se una {{REG_Yellow}}Scala{{CR}} è tenuta entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBE] = "{{Damage}} {{REG_CMult}}X1.55{{CR}} Molt. di Danno se un {{REG_Yellow}}Colore{{CR}} è tenuto entrando in una stanza #{{Blank}} {{ColorGray}}(Attualmente: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{Tears}} {{REG_CMult}}+12.5{{CR}} Lacrime #{{REG_HSize}} {{REG_CMult}}-2{{CR}} Carte in mano"
Descriptions.Jimbo.Jokers[mod.Jokers.SATELLITE] = "{{Coin}} {{REG_Yellow}}+1 Moneta{{CR}} per {{ColorCyan}}Carta Pianeta{{CR}} diversa usata questa partita quando un Buio viene sconfitto #(Attualmente {{REG_Yellow}}[[VALUE1]]{{ColorGray}} Monete) #Un raggio di luce colpisce le stanze ostili entrate per ogni {{ColorCyan}}Carta Pianeta{{CR}} usata"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{Damage}} Le {{REG_Yellow}}Regine{{CR}} tenute in mano danno {{REG_CMult}}+0.7{{CR}} Danno entrando in una stanza ostile"
Descriptions.Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{Damage}} {{REG_CMult}}X1.5{{CR}} Molt. di Danno se si hanno almeno {{REG_Yellow}}18{{CR}} carte {{REG_Yellow}}potenziate{{CR}} nel mazzo intero #Essere trasformato in {{Adult}} Adult, {{Mom}} Mom o {{Bob}} Bob raddoppia l'effetto #{{Blank}} {{ColorGray}}(Attualmente [[VALUE1]])"
Descriptions.Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "{{Shop}} Le {{ColorCyan}}Carte Planet{{CR}}, {{ColorCyan}}Buste Celestiali{{CR}} e gli oggetti {{REG_Yellow}}Stellari{{CR}} sono gratuiti #{{Planetarium}} {{REG_Yellow}}+20%{{CR}} possibilità del planetario {{ColorGray}}(Dimezzata per ogni planetario visitato) #{{Planetarium}} I Planetari possono apparire in ogni piano normale"
Descriptions.Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "\1 Potenzia il {{ColorCyan}}livello{{CR}} delle carte {{REG_Yellow}}scartate{{CR}} che colpiscono un nemico"
Descriptions.Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{Damage}} {{REG_CMult}}+0.05{{CR}} Danno per ogni {{REG_Yellow}}5 {{Coin}} Monete{{CR}} avute #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Danno) #Ottieni {{REG_Yellow}}Danno da contatto{{CR}} uguale al numero di monete avute"

Descriptions.Jimbo.Jokers[mod.Jokers.CANIO] = "{{Damage}} Ottiene {{REG_CMult}}X0.25{{CR}} Molt. di Danno quandu una {{REG_Face}} {{REG_Yellow}}Figura{{CR}} viene {{REG_Yellow}}Distrutta #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{COlorGray}} Molt. di Danno) #{{DeathMark}} I nemici {{REG_Yellow}}Champion{{CR}} vengono uccisi immediatamente"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{Damage}} I {{REG_Yellow}}Re{{CR}} e le {{REG_Yellow}}Regine{{CR}} danno {{REG_CMult}}X1.2{{CR}} Molt. di Danno quando attivati"
Descriptions.Jimbo.Jokers[mod.Jokers.YORICK] = "{{Damage}} Ottiene {{REG_CMult}}X0.25{{CR}} Molt. di Danno ogni {{REG_Yellow}}23{{CR}} carte scartate #{{Blank}} {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt. di Danno)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHICOT] = "{{Weakness}} Ogni {{REG_Yellow}}Boss{{CR}} permanentemente indebolito #Rimuove ogni maledizione"
Descriptions.Jimbo.Jokers[mod.Jokers.PERKEO] = "{{Card}} Crea una copia di ogni {{REG_Yellow}}Consumabile{{CR}} quando un {{REG_Yellow}}Buio{{CR}} viene sconfitto"

Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "Dopo essere giocate, le cards vengono cambiate {{REG_Yellow}}casualmente{{CR}} #{{IND}}!!! {{ColorGray}}(La nuova carta generata dipende da quella di partenza)"

end

Descriptions.JokerSynergies = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE] = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_PHD] = "Le carte aggiunte hanno anche un'{{REG_Yellow}}Edizione{{CR}} garantita"
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_FALSE_PHD] = "Le carte aggiunte hanno anche un {{REG_Yellow}}Potenziamento{{CR}} garantito"

Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_SMALL_ROCK] = "Le carte aggiunte hanno anche un {{REG_Yellow}}Sigillo{{CR}} garantito"
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = "Le carte aggiunte hanno anche un'{{REG_Yellow}}Edizione{{CR}} garantita"

Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY] = {}
Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY][CollectibleType.COLLECTIBLE_CHAOS] = "Le carte generate avranno un {{REG_Yellow}}Potenziamento{{CR}}, {{REG_Yellow}}Sigillo{{CR}} o {{REG_Yellow}}Edizione{{CR}} se la carta di partenza ne aveva"

Descriptions.JokerSynergies[mod.Jokers._8_BALL] = {}
Descriptions.JokerSynergies[mod.Jokers._8_BALL][CollectibleType.COLLECTIBLE_MAGIC_8_BALL] = "{{REG_Mint}}Probabilità{{CR}} raddoppiata!"

Descriptions.JokerSynergies[mod.Jokers.MISPRINT] = {}
Descriptions.JokerSynergies[mod.Jokers.MISPRINT][CollectibleType.COLLECTIBLE_TMTRAINER] = "Il danno dato è compreso tra {{REG_CMult}}-0.5{{CR}} e {{REG_CMult}}+2.5"

Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD] = {}
Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD][CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "{{REG_Spade}} L'effetto di ammaliamento dei {{REG_CSpade}}Picche{{CR}} diventa garantito"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER] = "{{Coin}} Dà anche 2 {{REG_Yellow}}Monete dorate{{CR}} quando vednuto in questo modo"

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
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE] = "#{{REG_Jimbo}} Le carte sparano 1 brimstone in una direzione casule quando colpiscono un nemico #{{IND}} I brimstone infliggono il 50% del danno della carta #{{IND}}{{REG_Spade}} I {{REG_CSpade}}Picche{{CR}} sparando un brim. aggiuntivo #\2 +50% Tempo di ricarica carte #{{REG_Spade}} Le carte in mano diventano di {{REG_CSpade}}Picche{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "#{{REG_Jimbo}} Le carte sparano 1 laser in una direzione casuale qunado colpiscono una nemico #{{IND}} I laser infliggono il 50% del danno della carta #{{IND}}{{REG_Heart}} I {{REG_CMult}}Cuori{{CR}} sparano un laser aggiuntivo"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DR_FETUS] = "#{{REG_Jimbo}} Le carte rilasciano una bomba quando colpiscono un nemico #{{IND}} le bombe infliggono il 100% del Danno della carta e mantangono i modificatori del giocatore #{{IND}}{{REG_Club}} Le bombe di {{REG_CChips}}Fiori{{CR}} hanno raggio e danno maggiori #{{REG_Club}} Le carte in mano diventano di {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SMELTER] = "#{{REG_Jimbo}} Permette di vendere un Jolly per il doppio de valore normale #{{Blank}}(usato automaticamente vendendo se carico)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_BOX] = "#{{REG_Jimbo}} Richiede {{Battery}} 12 cariche #{{REG_Jimbo}} Ottiene 2 cariche attivando una {{RestockMachine}} Restock machine"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DOLLAR] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Diamond}} {{REG_Yellow}}Quadri"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYRO] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Club}} {{REG_CChips}}Fiori"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SKELETON_KEY] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Spade}} {{REG_CSpade}}Picche"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BINGE_EATER] = "#{{REG_Jimbo}} Cambia tutto il mazzo in {{REG_Heart}} {{REG_CMult}}Cuori"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEART] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_QUARTER] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOOM] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}}{{REG_CChips}}Fiori{{CR}}quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GLITTER_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}}{{REG_CChips}}Fiori{{CR}}quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOMBER_BOY] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HOT_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BUTT_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_NANCY_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCATTER_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} quando preso #I {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} sono considerati anche come {{REG_Club}} {{REG_CChips}}Fiori{{CR}} "
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FAST_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOBBY_BOMB] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SAD_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GHOST_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STICKY_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARP_KEY] = "#{{REG_Jimbo}} Le carte di {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} possono aprire le porte #{{REG_Spade}} Le carte in mano diventano di {{REG_CSpade}}Picche{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_C_SECTION] = "#{{REG_Jimbo}} Le carte sparano un feto quando atterrano #{{IND}}{{REG_Heart}} Le carte di {{REG_CMult}}Cuori{{CR}} sparano un feto in più #{{REG_Heart}} Le carte in mano diventano di {{REG_CMult}}Cuori{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECH_X] = "#{{REG_Jimbo}} Le carte sono circondate da un cerchio di laser che infligge il 50% del suo danno"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "#{{REG_Jimbo}} Le carte diventano spettrali e perforanti, infliggendo il 30% del loro danno ogni tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TRISAGION] = "#{{REG_Jimbo}} Le carte diventano perforanti, infliggendo il 20% del loro danno ogni tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "#{{REG_Jimbo}} La spada è applicata assieme allo sparare carte"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALLOWED_GROUND] = "#{{REG_Jimbo}} le carte giocate vengono {{REG_Retrigger}} {{REG_Yellow}}Riattivate{{CR}} mentre si è all'interno dell'aura"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM] = "#{{REG_Jimbo}} le carte giocate vengono {{REG_Retrigger}} {{REG_Yellow}}Riattivate{{CR}} mentre si è all'interno dell'aura"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_POUND_OF_FLESH] = "#{{REG_Jimbo}} {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} e {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} sono considerati come lo stesso seme"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TMTRAINER] = "#{{REG_Jimbo}} Tutte le carte del mazzo vengono cambiate casualmente"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "#{{REG_Jimbo}} Le carte di {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} di {{Charm}} ammaliare i nemici"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALO] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} Ottengono una aura come {{Collectible331}} God Head #{{REG_Diamond}} Le carte in mano diventano {{REG_Yellow}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} danno {{REG_CMult}}+0.01{{CR}} Danno per ogni {{ColoraYellorange}}5{{CR}} monete avute quando attivate"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE] = "#{{REG_Jimbo}} Le Lacrime date dai {{REG_Bonus}} {{REG_Yellow}}Potenziamenti Bonus{{CR}} sono raddoppiate"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SOUL] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCAPULAR] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_KEEPERS_KIN] = "#{{REG_Jimbo}} Quando atterrano, le {{REG_Stone}} {{REG_Yellow}}Carte di Pietra{{CR}} creano 1-3 {{REG_Yellow}}Ragni blu"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = "#{{REG_Jimbo}} Dà l'effetto del {{Collectible"..mod.Vouchers.Crystal.."}} Voucher Palla di Cristallo mentre tenuto"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "#{{REG_Jimbo}} Le carte non scompaiono bloccando i proiettili #{{ColorGray}} (Lacrime seme non incluse)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYROMANIAC] = "#{{REG_Jimbo}} Le carte in mano diventano di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} qunado preso # {{REG_Club}} {{REG_CChips}}Fiori{{CR}} e {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} sono considerati come lo stesso seme"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOGO_BOMBS] = "#{{REG_Jimbo}} Le carte di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} aggiunte al mazzo sono raddoppiate"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_IRON_BAR] = "#{{REG_Jimbo}} Le {{REG_Steel}} {{REG_Yellow}}Carte d'Acciaio{{CR}} causano {{Confusion}} Confusione"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "#{{REG_Jimbo}} Le {{REG_Gold}} {{REG_Yellow}}Carte Dorate{{CR}} trasformano i nemici colpiti in statue d'oro"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = "#{{REG_Jimbo}} Le carte in mano diventano {{REG_Wild}} {{REG_Yellow}}Carte Multiuso{{CR}} quando preso #{{Blank}} {{ColorGray}}(non sovrascrive potenziamenti esistenti) #{{REG_Wild}} Le {{REG_Yellow}}Carte Multiuso{{CR}} ottengono effetti casuali aggiuntivi"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = "#{{REG_Jimbo}} I {{REG_Yellorange}}3{{CR}} lanciati ottengono 3 effetti casuali aggiuntivi"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GODHEAD] = "#{{REG_Jimbo}} Tutti le carte puramente di {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} nel mazzo vengono distrutte quando preso #{{REG_Wild}} Le altre carte diventano {{REG_Yellow}}Carte Multiuso #{{Blank}} {{ColorGray}}(non sovrascrive potenziamenti esistenti)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO] = "#{{REG_Jimbo}} La carte di {{REG_Club}} {{REG_CChips}}Fiori{{CR}} esplodono sempre"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FIRE_MIND] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} creano una moneta temporanes quando colpiscono un nemico #{{REG_Jimbo}} Le carte in mano diventano di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARD_OF_GLASS] = "#{{REG_Jimbo}} Le {{REG_Glass}} {{REG_Yellow}}Carte di Vetro{{CR}} hanno l'effetto di {{Collectible506}} Backstabber e causano {{BleedingOut}} sanguinamento #{{REG_Jimbo}} Le carte in mano diventano {{REG_Glass}} {{REG_Yellow}}Carte di Vetro{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EYE_OF_GREED] = "#{{REG_Jimbo}} Le carte di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} rendono i nemici delle statue dorate #{{REG_Jimbo}} Le carte in mano diventano di {{REG_Diamond}} {{REG_Yellow}}Quadri{{CR}} quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MAGIC_SKIN] = "#{{REG_Jimbo}} {{REG_Yellow}}USO SINGOLO #{{REG_Jimbo}} Crea anche 2 {{REG_Joker}} Jolly"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DEEP_POCKETS] = "#{{REG_Jimbo}} Limite massimo aumentato a 9999"
Descriptions.JimboSynergies[mod.Collectibles.POCKET_ACES] = "#{{REG_Jimbo}} Aggiunge 2 Assi con {{REG_Yellow}}Potenziamento{{CR}}, {{REG_Yellow}}Sigillo{{CR}} ed {{REG_Yellow}}Edizione{{CR}} garantiti al mazzo quando preso"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HYPERCOAGULATION] = "#{{REG_Jimbo}} Le carte di {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} cards ottengono l'effetto di {{Collectible224}} Cricket's body"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CANDY_HEART] = "#{{REG_Jimbo}} Le carte di {{REG_Heart}} {{REG_CMult}}Cuori{{CR}} aggiunte ottengono un {{REG_Yellow}}Potenziamento{{CR}} casuale se non avevano uno"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON] = "#{{REG_Jimbo}} Il danno dato dai {{REG_Mult}} {{REG_Yellow}}Potensiamenti Molt{{CR}} è raddoppiato"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_ABADDON] = "#{{REG_Jimbo}} Le carte di {{REG_Spade}} {{REG_CSpade}}Picche{{CR}} infliggono 10% di danno aggiuntivo"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STEAM_SALE] = "#{{REG_Jimbo}} Gli oggetti in vendita costano {{REG_Yellow}}1 {{Coin}} moneta in meno #!!! {{ColorGray}}Effetto base disabilitato"

for _,v in ipairs(mod.EVIL_ITEMS) do
    Descriptions.JimboSynergies[v] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_ABADDON]
end



Descriptions.T_Jimbo.Enhancement = {}
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.BONUS] = "# {{REG_CChips}}+30{{CR}} Fiches"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.MULT]  = "# {{REG_CMult}}+4{{CR}} Molt"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# {{REG_Yellow}}+3${{CR}} se tenuta in mano alla fine del round"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GLASS] = "# {{REG_CMult}}X2{{CR}} Molt # {{REG_Mint}}[[CHANCE]] probabilit\224 su 4{{CR}} di rompersi quando giocata"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{REG_Mint}}[[CHANCE]] possibilit\224 su 5{{CR}} di {{REG_CMult}}+20{{CR}} Molt #{{REG_Mint}}[[CHANCE]] probabilit\224 su 20{{CR}} di {{REG_Yellow}}+20$"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STEEL] = "# {{REG_CMult}}X1.5{{CR}} Molt quando tenuta in mano"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.WILD]  = "# Considerata come di ogni {{REG_Yellow}}Seme"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STONE] = "#{{REG_CChips}}+50{{CR}} Fiches #Non ha un {{REG_Yellow}}Valore{{CR}} o {{REG_Yellow}}Seme"



Descriptions.T_Jimbo.Seal = {}
Descriptions.T_Jimbo.Seal[mod.Seals.NONE] = ""
Descriptions.T_Jimbo.Seal[mod.Seals.RED] = "# {{REG_Yellow}}Riattivata{{CR}} una volta"
Descriptions.T_Jimbo.Seal[mod.Seals.BLUE] = "# Crea il {{ColorCyan}}Planet{{CR}} della mano {{REG_Yellow}}vincente{{CR}} se tenuta in mano"
Descriptions.T_Jimbo.Seal[mod.Seals.GOLDEN] = "# Guadagni {{REG_Yellow}}1$"
Descriptions.T_Jimbo.Seal[mod.Seals.PURPLE] = "# Crea un {{ColorPink}}Tarocco{{CR}} quando {{ColorRed}}Scartata"


Descriptions.T_Jimbo.Edition = {}
Descriptions.T_Jimbo.Edition[mod.Edition.BASE] = ""
Descriptions.T_Jimbo.Edition[mod.Edition.FOIL] = "#{{REG_CChips}}+50{{CR}} Fiches"
Descriptions.T_Jimbo.Edition[mod.Edition.HOLOGRAPHIC] = "#{{REG_CMult}}+10{{CR}} Molt"
Descriptions.T_Jimbo.Edition[mod.Edition.POLYCROME] = "#{{REG_CMult}}X1.5{{CR}} Molt"
Descriptions.T_Jimbo.Edition[mod.Edition.NEGATIVE] = "#{{REG_Yellow}}+1{{CR}} Slot Jolly"
Descriptions.T_Jimbo.ConsumableNEGATIVE = "#{{REG_Yellow}}+1{{CR}} Slot Consumabili"
Descriptions.T_Jimbo.CardNEGATIVE = "#{{REG_Yellow}}+1{{CR}} Carte in mano"


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
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BOSS] = "Cambia il {{REG_Yellow}}Buio Boss{{CR}} dell'ante"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BUFFON] = "Apri una {{REG_Yellow}}Busta Buffone Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.CHARM] = "Apri una {{REG_Yellow}}Busta Arcana Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.COUPON] = "Le carte e buste iniziali del prssimo negozio sono {{REG_Yellow}}Gratuite"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.D6] = "Il costo dei cambi inizia a {{REG_Yellow}}0$"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.DOUBLE] = "Duplica il prossimo patto ottenuto #{{ColorGray}}(Patto Doppio escluso)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ECONOMY] = "raddoppia i soldi avuti #{{ColorGray}}(Max 40$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ETHEREAL] = "Apri una {{REG_Yellow}}Busta Spettrale"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.FOIL] = "Il prossimo negozio ha un Jolly {{REG_CChips}}Foil{{CR}} gratutito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.GARBAGE] = "Guadagna {{REG_Yellow}}1${{CR}} per {{REG_CMult}}scarto{{CR}} sprecato #{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HANDY] = "Guadagna {{REG_Yellow}}1${{CR}} per {{REG_CChips}}mano{{ColorGray}} giocata #([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HOLO] = "Il prossimo negozio ha un Jolly {{REG_CMult}}Olografico{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.INVESTMENT] = "Guadagna {{REG_Yellow}}25${{CR}} dopo aver sconfitto il prossimo {{REG_Yellow}}Buio Boss"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.JUGGLE] = "{{REG_Yellow}}+3{{CR}} carte in mano per il prossimo Buio"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.METEOR] = "Apri una {{REG_Yellow}}Busta Celestiale Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.NEGATIVE] = "Il prossimo negozio ha un Jolly {{ColorBlack}}Negativo{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ORBITAL] = "Potenzia {{REG_Yellow}}[[VALUE1]]{{CR}} di 3 livelli"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.POLYCHROME] = "Il prossimo negozio ha un Jolly {{ColorRainbow}}Policroma{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.RARE] = "Il prossimo negozio ha un Jolly {{REG_CMult}}Raro{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.SPEED] = "Guadagna {{REG_Yellow}}5${{CR}} per Buio saltato #{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.STANDARD] = "Apri una {{REG_Yellow}}Busta Standard Mega"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.TOP_UP] = "Crea fino a {{REG_Yellow}}2{{CR}} Jolly {{REG_CChips}}Comuni"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.UNCOMMON] = "Il prossimo negozio ha un Jolly {{ColorLime}}Non comunq{{CR}} gratuito"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.VOUCHER] = "Il prossimo negozio ha un {{REG_Yellow}}Buono{{CR}} aggiuntivo"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_1] = "Ottieni {{REG_Yellow}}10${{CR}} e il {{REG_Yellow}}Key Piece 1"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_2] = "Ottieni {{REG_Yellow}}10${{CR}} e il {{REG_Yellow}}Key Piece 2"


Descriptions.T_Jimbo.Jokers = {}
do
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER] = "{{REG_CMult}}+4{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BULL] = "{{REG_CChips}}+2{{CR}} Fiches per {{REG_Yellow}}1${{CR}} avuto # {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Dopo {{REG_Yellow}}2{{CR}} round, vendere questo Jolly {{REG_Yellow}}Duplica{{CR}} duplica un'altro Jolly avuto {{ColorGray}}[[VALUE2]]#(Attualmente [[VALUE1]])"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{REG_CMult}}+3{{CR}} Molt per Jolly # {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MISPRINT] = " {{REG_CMult}}+0-23{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{REG_CMult}}X1{{CR}} Molt per slot Jolly vuoto #{{ColorGray}}(Forma di Jolly inclusa) #{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STONE_JOKER] = " {{REG_CChips}}+25{{CR}} Fiches per {{REG_Yellow}}Carta di Pietra{{CR}} nel tuo {{REG_Yellow}}mazzo intero #{{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ICECREAM] = " {{REG_CChips}}+[[VALUE1]]{{CR}} Fiches#Perde {{REG_CChips}}-5{{CR}} Fiches ogni mano giocata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.POPCORN] = " {{REG_CMult}}+[[VALUE1]]{{CR}} Molt #Perde {{REG_CMult}}-4{{CR}} Molt ogni round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAMEN] = " {{REG_CMult}}X[[VALUE1]]{{CR}} Molt#Perde {{REG_CMult}}-0.01X{{CR}} ogni carta scartata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROCKET] = "Guadagna {{REG_Yellow}}[[VALUE1]]${{CR}} at the end of round#Payout increases by {{REG_Yellow}}2${{CR}} when a boss blind is defeated"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ODDTODD] = "Le carte con valore {{REG_Yellow}}dispari{{CR}} danno {{REG_CChips}}+31{{CR}} Fiches quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "Le carte con valore {{REG_Yellow}}pari{{CR}} danno {{REG_CChips}}+4{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{REG_Mint}}[[CHANCE]] probabilit\224 su 2{{CR}} to create a{{ColorPink}}Tarot{{CR}} card when opening a {{REG_Yellow}}Busta di Espansione"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "Ottiene {{REG_CMult}}+1{{CR}} Molt ongi mano giocata#{{REG_CMult}}-1{{CR}} Molt ogni scarto usato #{{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RED_CARD] = "Ottiene {{REG_CMult}}+3{{CR}} Molt ogni {{REG_Yellow}}Busta di Espansione{{CR}} saltata #{{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAGABOND] = "Crea un {{ColorPink}}Tarocco{{CR}} giocando una mano avendo {{REG_Yellow}}4${{CR}} o meno"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "Quando un {{REG_Yellow}}Buio{{CR}} viene selezionato, crea fino a 2 Jolly {{REG_CChips}}comuni"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Guadagna {{REG_Yellow}}4${{CR}} alla fine del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{REG_CMult}}+1{{CR}} Molt per {{ColorPink}}Tarocco{{CR}} usato questa partita #{{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "Copia l'effetto del {{REG_Yellow}}Jolly{{CR}} alla sua destra #{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "Copia l'effetto del {{REG_Yellow}}Jolly{{CR}} pi\242 a sinistra #{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MADNESS] = "Quando un {{REG_Yellow}}Piccolo{{CR}} o {{REG_Yellow}}Grande Buio{{CR}} viene selezionato, distrugge un altro Jolly e ottiene {{REG_CMult}}X0.5{{CR}} Molt# {{REG_CMult}}(Attualmente X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MR_BONES] = "{{REG_CMult}}Previene la morte{{CR}} e si {{REG_Yellow}}autodistrugge{{CR}} se il nemico con pi\242 HP non supera il {{REG_Yellow}}75% del punteggio base del buio"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "Le carte di {{REG_CChips}}Fiori{{CR}} danno {{REG_CMult}}+7{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "Le carte di {{REG_CSpade}}Picche{{CR}} danno {{REG_CChips}}+50{{CR}} Fiches quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "Le carte di {{REG_CMult}}Cuori{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilit\224 su 2{{CR}} di {{REG_CMult}}X1.5{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "Le carte di {{REG_Yellow}}Quadri{{CR}} danno {{REG_Yellow}}+1${{CR}} quando attivate"

Descriptions.T_Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{REG_CMult}}+15{{CR}}Molt #{{REG_Mint}}[[CHANCE]] probabilit\224 su 6{{CR}} of getting destoroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAVENDISH] = " {{REG_CMult}}X3{{CR}}Molt # {{REG_Mint}}[[CHANCE]] probabilit\224 su 1000{{CR}} of getting destroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "Ottiene {{REG_CMult}}+2{{CR}} Molt ogni {{REG_Mint}}Cambio{{CR}} del {{REG_Yellow}}Negozio #{{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Quando un {{REG_Yellow}}buio{{CR}} viene selezionato, distrugge il Jolly alla sua destra e guadagna {{REG_CMult}}+2 volte il suo valore di vendita{{CR}} Molt #{{ColorGrey}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "Guadagna {{REG_Yellow}}1${{CR}} per ogni {{REG_Yellow}}9{{CR}} nel tuo {{REG_Yellow}}mazzo intero{{CR}} alla fine del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "Aggiunge il valore di {{REG_Yellow}}vendita{{CR}} degli altri Jolly a {{ColotMult}}Molt# {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "Quando un {{REG_Yellow}}buio{{CR}} viene selezionato, crea un {{ColorPink}}Tarocco"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{REG_CMult}}X4{{CR}} Molt ogni {{REG_Yellow}}6{{CR}} mani giocate # {{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "Aggiunge il numero di volte che la {{REG_Yellow}}Mano di Poker{{CR}} \232 stata giocata a {{REG_CMult}}Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "Guadagna {{REG_Yellow}}2${{CR}} per ogni {{REG_CMult}}Scarto{{CR}} rimasto se non ne sono stati usati alla fine del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EGG] = "Il valore di vendita di questo Jolly aumenta di {{REG_Yellow}}3${{CR}} ogni {{REG_Yellow}}buio{{CR}} sconfitto"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DNA] = "Se la {{REG_Yellow}}prima mano{{CR}} del round contiene solo {{REG_Yellow}}1{{CR}} carta, aggiungine una copia al {{REG_Yellow}}Mazzo{{CR}} e pescala in mano#{{ColorGray}}[[VALUE1]]"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{REG_CMult}}Cuori{{CR}} e {{REG_Yellow}}Quadri{{CR}} sono considerati lo stesso seme#{{REG_CSpade}}Picche{{CR}} e {{ColorBlue}}Fiori{{CR}} sono considerati lo stesso seme"

---CONTROLLA 


Descriptions.T_Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{REG_CChips}}+50{{CR}} Fiches se la mano giocata contiene una {{REG_Yellow}}Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{REG_CChips}}+100{{CR}} Fiches se la mano giocata contiene un {{REG_Yellow}}Tris"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{REG_CChips}}+80{{CR}} Fiches se la mano giocata contiene una {{REG_Yellow}}Doppia Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{REG_CChips}}+100{{CR}} Fiches se la mano giocata contiene una {{REG_Yellow}}Scala"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{REG_CChips}}+80{{CR}} Fiches se la mano giocata contiene un {{REG_Yellow}}Colore"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{REG_CMult}}+8{{CR}} Molt se la mano giocata contiene una {{REG_Yellow}}Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{REG_CMult}}+12{{CR}} Molt se la mano giocata contiene un {{REG_Yellow}}Tris"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{REG_CMult}}+10{{CR}}Molt se la mano giocata contiene una {{REG_Yellow}}Doppia Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{REG_CMult}}+12{{CR}} Molt se la mano giocata contiene una {{REG_Yellow}}Scala"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{REG_CMult}}+10{{CR}} Molt se la mano giocata contiene un {{REG_Yellow}}Colore"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MIME] = "{{REG_Yellow}}Riattiva{{CR}} le abilit\224 {{REG_Yellow}}tenute in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "I {{REG_Yellow}}Colori{{CR}} e {{REG_Yellow}}Scale{{CR}} richiedono solo 4 carte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "Le carte di {{REG_CMult}}Cuori{{CR}} danno {{REG_CMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "Le carte di {{REG_Yellow}}Quadri{{CR}} danno {{REG_CMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "Le carte di {{REG_CSpade}}Picche{{CR}} danno {{REG_CMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "Le carte di {{REG_CChips}}Fiori{{CR}} danno {{REG_CMult}}+3{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{REG_Yellow}}+3{{CR}} scarti #{{REG_CMult}}-1{{CR}} Carte in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{REG_CMult}}+20{{CR}} Molt se la mano giocata ha fino a {{REG_Yellow}}3{{CR}} carte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Puoi comprare oggetti fino a {{REG_CMult}}-20${{CR}} in debito #{{ColorGray}}(effetto cumulabile)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BANNER] = "{{REG_CChips}}+30{{CR}} Fiches per {{REG_Yellow}}Scarto{{CR}} rimenente"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{REG_CMult}}+15{{CR}} molt when with {{REG_Yellow}}0{{CR}} discards remaining"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "Quando un {{REG_Yellow}}buio{{CR}} viene selezionato, aggiunge una {{REG_Yellow}}Carta di Pietra{{CR}} al mazzo"
Descriptions.T_Jimbo.Jokers[mod.Jokers._8_BALL] = "Gli {{REG_Yellow}}8{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilit\224 su 4{{CR}} di creare un {{ColorPink}}Tarocco{{CR}} qunado attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUSK] = "{{REG_Yellow}}Riattiva{{CR}} l'ultima mano del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "Aggiunge il {{REG_Yellow}}doppio{{CR}} del valore {{REG_Yellow}}minore{{CR}} tenuto in mano a {{REG_CMult}}Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{REG_Yellow}}1 {{REG_Mint}}Cambio{{CR}} gratutio per negozio"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FIBONACCI] = "Ogni {{REG_Yellow}}Asso{{CR}}, {{REG_Yellow}}2{{CR}}, {{REG_Yellow}}3{{CR}}, {{REG_Yellow}}5{{CR}} e {{REG_Yellow}}8{{CR}} d\224 {{REG_CMult}}+8{{CR}} Molt quando attivato"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "Ottiene {{REG_CMult}}X0.2{{CR}} Molt per ogni {{REG_Yellow}}Carta d'Acciaio{{CR}} nel tuo mazzo intero"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "Le {{REG_Yellow}}Figure{{CR}} danno {{REG_CChips}}+30{{CR}} Fiches quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HACK] = "Riattiva i {{REG_Yellow}}2, 3, 4 e 5{{CR}} giocati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Ogni carta \232 considerata come una {{REG_Yellow}}Fiugra"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SCHOLAR] = "Gli {{REG_Yellow}}Assi{{CR}} danno {{REG_CMult}}+4{{CR}} Molt e {{REG_CChips}}+20{{CR}} Fiches quando attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "Le {{REG_Yellow}}Figure{{CR}} hanno {{REG_Mint}}[[CHANCE]] probabilit\224 su 2{{CR}} di dare {{REG_Yellow}}+2${{CR}} quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{REG_CMult}}+1{{CR}} Molt per mano giocata senza una {{REG_Yellow}}Figura attivata#{{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{CR}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{REG_Mint}}[[CHANCE]] probabilit\224 su 4{{CR}} di potenziare la {{REG_Yellow}}Mano di POker{{CR}} giocata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURGLAR] = "All'inizio del round, perdi tutti gli {{REG_CMult}}Scarti{{CR}} e ottieni {{REG_CChips}}+3{{CR}} mani"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{REG_CMult}}X3{{CR}} Molt se tutte le carte in mano sono di {{REG_CSpade}}Picche{{CR}} o {{REG_CChips}}Fiori"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RUNNER] = "Ottiene {{REG_CChips}}+15{{CR}} Fiches se la mano giocata contiene una {{REG_Yellow}}Scala#{{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPLASH] = "Tutte le {{REG_Yellow}}carte giocate{{CR}} assegnano punti"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{REG_CChips}}+2{{CR}} Fiches per carta rimanente nel mazzo # {{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}}Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "Se la {{REG_Yellow}}prima{{CR}}mano giocata \232 un singolo {{REG_Yellow}}6{{CR}}, distruggilo e crea una carta {{ColorBlue}}Spettrale"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "Ottiene {{REG_CMult}}X0.1{{CR}} Molt ogni volta che un {{ColorCyan}}Pianeta{{CR}} viene usato#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIKER] = "Le carte ottengono {{REG_CChips}}+5{{CR}} Fiches permanenti quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FACELESS] = "Guadagna {{REG_Yellow}}5${{CR}} se uno scarto contiene almeno {{REG_Yellow}}3 Figure"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "Crea un {{ColorPink}}Tarocco{{CR}} se la mano giocata contiene una {{REG_Yellow}}Scala{{CR}} e un {{REG_Yellow}}Asso"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "Guadagna {{REG_Yellow}}4${{CR}} se la mano giocata \232 {{REG_Yellow}}[[VALUE1]]{{CR}}#(mano cambia ogni round)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{REG_CChips}}X3{{CR}} Molt se la {{REG_Yellow}}Mano di Poker{{CR}} era gi\224 stata giocata questo round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "Ottiene {{REG_CChips}}+4{{CR}} Fiches se la mano giocata contiene esattamente {{REG_Yellow}}4{{CR}} carte#{{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEANCE] = "crea una carta {{REG_Yellow}}Spettrale{{CR}} quando una {{REG_Yellow}}Scala Reale{{CR}} viene giocata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAMPIRE] = "Quando una carta {{REG_Yellow}}Potenziata{{CR}} viene attivata, ottiene {{REG_CChips}}X0.1{{CR}} Molt e rimuove il {{REG_Yellow}}Potenziamento{{CR}}#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Le {{REG_Yellow}}Scale{{CR}} possono avere salti di {{REG_Yellow}}1 rank"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "Ottiene {{REG_CMult}}X0.25{{CR}} Molt quando una carta viene {{REG_Yellow}}aggiunta{{CR}} al mazzo#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Molt)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BARON] = "I {{REG_Yellow}}King{{CR}} tenuti in mano danno {{REG_CMult}}X1.5{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OBELISK] = "Ottiene {{REG_CMult}}X0.2{{CR}} Molt per mano {{REG_Yellow}}consecutiva{{CR}} giocata senza giocare la tua {{REG_Yellow}}mano di poker{{CR}} pi\242 giocata#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MIDAS] = "Le {{REG_Yellow}}Figure{{CR}} che assegnano punti diventano {{REG_Yellow}}Carte Dorate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{REG_Yellow}}Vendere{{CR}} questo Jolly disabilita il {{REG_Yellow}}Boss{{CR}} attuale"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "La prima {{REG_Yellow}}Figura{{CR}} ad assegnare punti d\224 {{REG_CMult}}X2{{CR}} Molt quando attivata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "Ogni Jolly e consumabile avuto ottiene {{REG_Yellow}}+1${{CR}} valore di vendta a fine round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{ColorCyan}}+[[VALUE1]]{{CR}} Carte in mano #Perde {{REG_CMult}}-1{{CR}} carte in mano ogni round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EROSION] = "{{REG_CChips}}+4{{CR}} Molt per carta sotto {{REG_Yellow}}52{{CR}} nel tuo {{REG_Yellow}}mazzo intero# {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "Le {{REG_Yellow}}Figure{{CR}} tenute in mano hanno {{REG_Mint}}[[CHANCE]] probabilit\224 su 4{{CR}} di dare {{REG_Yellow}}1$"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "Guadagna {{REG_Yellow}}5${{CR}} per ogni {{REG_Yellow}}[[VALUE1]]{{CR}} scartato #(Valore cambia ogni round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "Guadagna {{REG_Yellow}}1${{CR}} aggiuntivo per ogni {{REG_Yellow}}5${{CR}} avuti come interesse"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{REG_Yellow}}+1{{CR}} Carte in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{REG_CMult}}+1{{CR}} scato"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "Ottiene {{REG_CMult}}X0.25{{CR}} Molt per attivazione con {{REG_Mint}}successo{{CR}} di una {{REG_Yellow}}Carta Fourtunata#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BASEBALL] = "I Jolly {{REG_Mint}}Non comuni{{CR}} danno {{REG_CMult}}X1.5{{CR}} Molt"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{REG_Yellow}}Vednere{{CR}} quadto Jolly crea un {{REG_Yellow}}Patto Poppio"

Descriptions.T_Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "Se lo primo scrto del round contiene una {{REG_Yellow}}singola{{CR}} carta, distruggila e guadagna {{ColotYellor}}3$"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "Ottiene {{REG_CMult}}+2{{CR}} Molt se la mano giocata contiene una {{REG_Yellow}}Doppia Coppia#{{ColorGray}}(Attualmente{{REG_CMult}}+[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "Le carte di [[VALUE1]]{{CR}} danno {{REG_CMult}}X1.5{{CR}}Molt quando attivate#{{ColorGray}}(Seme cambia ogni round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "I {{REG_Yellow}}10{{CR}} e {{REG_Yellow}}4{{CR}} danno {{REG_CChips}}+10{{CR}}Fiches e {{REG_CMult}}+4{{CR}} Molt quando attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SELTZER] = "{{REG_Yellow}}Riattiva{{CR}} tutte le carte giocate# {{ColorGray}}({{REG_Yellow}}[[VALUE1]]{{ColorGray}} mani rimanenti)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "Le {{REG_Yellow}}Figure{{CR}} danno {{REG_CMult}}+5{{CR}} Molt quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "Ottiene {{REG_CMult}}X0.25{{CR}} Molt per carta {{REG_Yellow}}venduta{{CR}} quasta Ante #{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CASTLE] = "Ottiene {{REG_CChips}}+3{{CR}} Fiches ogni carta di [[VALUE1]]{{CR}} scartata #{{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE2]]{{ColorGray}} Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "Le {{REG_Yellow}}Carte Dorate{{CR}} danno {{REG_Yellow}}4${{CR}} quando attivate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{REG_CMult}}X3{{CR}} Molt all'{{REG_Yellow}}ultima{{CR}} mano del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{REG_Yellow}}Riattiva{{CR}} le {{REG_Yellow}}Figure{{CR}} giocate"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{REG_Yellow}}+2{{CR}} Carte in mano #{{REG_CMult}}-1{{CR}} mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.THROWBACK] = "Ottiene {{REG_CMult}}X0.25{{CR}} Molt per buio {{REG_Yellow}}saltato{{CR}} questa partita# {{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "When a blind is {{REG_Yellow}}selected{{CR}}, adds a card with a random{{REG_Yellow}}Seal{{CR} to the deck and drawn to hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "La {{REG_Yellow}}prima{{CR}} carta che assegna punti viene {{REG_Yellow}}riattivata{{CR}} 2 volte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "Ottiene {{REG_CMult}}X0.75{{CR}} ogni {{REG_Yellow}}Carta di vetro{{CR}} distrutta#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOWMAN] = "Le carte {{REG_Yellow}}Jolly{{CR}},{{ColorPink}}Tarocche{{CR}},{{ColorCyan}}Pianeta{{CR}} e {{ColorBlue}}Spettrali{{CR}} possono apparire pi\242 volte"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{REG_CChips}}X3{{CR}} Molt se la {{REG_Yellow}}Mano fi Poker{{CR}} contiene tutti i {{REG_Yellow}}Semi"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "Ottieni {{REG_CChips}}+8{{CR}} Fiches per ogni {{REG_Yellow}}2{{CR}} attivato#{{ColorGray}}(Attualmente {{REG_CChips}}+[[VALUE1]]{{ColorGray}}Fiches)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OOPS_6] = "Ogni {{REG_Mint}}probabilit\224{{CR}} \232 rsddoppiata"
Descriptions.T_Jimbo.Jokers[mod.Jokers.IDOL] = "[[VALUE1]]{{CR}} d\224 {{REG_CMult}}X2{{CR}} Molt quando attivata #(Carta cambia ogni round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{REG_CMult}}X2{{CR}} Molt se la {{REG_Yellow}}Mano di Poker{{CR}} contiene una carta di {{REG_CChips}}Flub{{CR}} e una {{REG_Yellow}}non di {{REG_CChips}}Fiori"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MATADOR] = "Guadagna {{REG_Yellow}}8${{CR}} quando la mano giocata attiva l'abilit\224 del {{REG_Yellow}}Buio Boss"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "Ottiene {{REG_CMult}}X0.5{{CR}} Molt ogni {{REG_Yellow}}Jack{{CR}} scartato questo round#{{ColorGray}}(Attualmente {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUO] = "{{REG_CMult}}X2{{CR}} Molt se la mano giocata contiene una {{REG_Yellow}}Coppia"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIO] = "{{REG_CMult}}X3{{CR}} Molt se la mano giocata contiene un {{REG_Yellow}}Tris"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FAMILY] = "{{REG_CMult}}X4{{CR}} Molt se la mano giocata contiene un {{REG_Yellow}}Poker"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ORDER] = "{{REG_CMult}}X3{{CR}} Molt se la mano giocata contiene una {{REG_Yellow}}Scala"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBE] = "{{REG_CMult}}X2{{CR}} Molt se la mano giocata contiene un {{REG_Yellow}}Colore"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{REG_CMult}}+250{{CR}} Fiches #{{REG_CMult}}-2{{CR}} Carte in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SATELLITE] = "Guadagna {{REG_Yellow}}1${{CR}} per {{ColorCyan}}Pianeta{{CR}} diverso usato questa partita# {{ColorGray}}(Attualmente {{REG_Yellow}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{REG_CMult}}+13{{CR}} Molt per {{REG_Yellow}}Regina{{CR}} tenuta in mano"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{REG_CMult}}X3{{CR}} Molt se hai {{REG_Yellow}}16 carte potenziate{{CR}} nel mazzo intero# {{ColorGray}}(Attualmente {{REG_Yellow}}[[VALUE1]]{{ColorGray}} Enhanced cards)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "Ogni {{ColorCyan}}Carta Pianeta{{CR}} e {{ColorCyan}}Busta Celestiale{{CR}} \232 gratuita"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{REG_Yellow}}Potenzia{{CR}} la prima {{REG_Yellow}}Mano di Poker{{CR}} scartata del round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{REG_CMult}}+2{{CR}} Molt per ogni {{REG_Yellow}}5${{CR}} avuti# {{ColorGray}}(Attualmente {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Molt)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CANIO] = "Ottiene {{REG_CMult}}X1{{CR}} Molt ogni {{REG_Yellow}}Figura{{CR}} distrutta#{{ColorGray}}(Attualmente {{ColroMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{REG_Yellow}}Re{{CR}} e {{REG_Yellow}}Regine{{CR}} danno {{REG_CMult}}X2{{CR}} Molt quando attivati"
Descriptions.T_Jimbo.Jokers[mod.Jokers.YORICK] = "Ottiene {{REG_CMult}}X1{{CR}} Molt once every {{REG_Yellow}}23{{CR}} cards discarded#{{ColorGray}}([[VALUE2]] Remaining) #{{ColorGray}}(Attualmente {{ColroMult}}X[[VALUE1]]{{ColorGray}} Molt)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHICOT] = "Disabilita le abilit\224 dei {{REG_Yellow}}Bui Boss"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PERKEO] = "Uscendo dal {{REG_Yellow}}Negozio{{CR}}, crea una copia {{REG_CSpade}}Negativa{{CR}} di un cond\236sumabile avuto casuale"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "Dopo essere attivate, le carte vengono combiate {{REG_Yellow}}casualmente #{{ColorGray}}(La nuova carta dipende da quella di partenza) "


end


Descriptions.T_Jimbo.Debuffed = "Tutte le abilit\224 sono disattivate"


---------------------------------------
-------------####TAROTS####------------
---------------------------------------

Descriptions.Jimbo.Consumables = {}
Descriptions.Jimbo.Consumables[Card.CARD_FOOL] = "Crea una copia dell'ultima carta usata #{{IND}}!!! Eccetto sè stessa #[[VALUE1]] Attualmente: [[VALUE2]]"
Descriptions.Jimbo.Consumables[Card.CARD_MAGICIAN] = "{{REG_Lucky}} Cambia fino a {{REG_Yellow}}2{{CR}} carte nella tua mano in {{REG_Yellow}}Carte Fortunate"
Descriptions.Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "{{REG_Planet}} Crea {{REG_Yellow}}2 carte {{ColorCyan}}Pianeta{{CR}} casuali"
Descriptions.Jimbo.Consumables[Card.CARD_EMPRESS] = "{{REG_Mult}} Cambia fino a {{REG_Yellow}}2{{CR}} carte nella tua mano in {{REG_Yellow}}Carte Molt"
Descriptions.Jimbo.Consumables[Card.CARD_EMPEROR] = "{{Card}} Crea {{REG_Yellow}}2{{CR}} {{ColorPink}}Tarocchi{{CR}} casuali #{{IND}}!!! Eccetto sè stesso"
Descriptions.Jimbo.Consumables[Card.CARD_HIEROPHANT] = "{{REG_Bonus}} Cambia fino a {{REG_Yellow}}2{{CR}} carte nella tua mano in {{REG_Yellow}}Carte Bonus"
Descriptions.Jimbo.Consumables[Card.CARD_LOVERS] = "{{REG_Wild}} Cambia {{REG_Yellow}}1{{CR}} carta nella tua mano in {{REG_Yellow}}Carta Multiuso"
Descriptions.Jimbo.Consumables[Card.CARD_CHARIOT] = "{{REG_Steel}} Cambia {{REG_Yellow}}1{{CR}} carta nella tua mano in {{REG_Yellow}}Carta d'Acciaio"
Descriptions.Jimbo.Consumables[Card.CARD_JUSTICE] = "{{REG_Glass}} Cambia {{REG_Yellow}}1{{CR}} carta nella tua mano in {{REG_Yellow}}Carta di Vetro"
Descriptions.Jimbo.Consumables[Card.CARD_HERMIT] = "Raddoppia i tuoi soldi #{{IND}}!!! Massimo {{REG_Yellow}}20$"
Descriptions.Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{REG_Mint}}[[CHANCE]] probabilità su 4{{CR}} di dare un'{{REG_Yellow}}Edizione{{CR}} ad un Jolly avuto #{{IND}}!!! Non può rimpiazzare edizioni già esistenti"
Descriptions.Jimbo.Consumables[Card.CARD_STRENGTH] = "Aumenta il valore di fino a {{REG_Yellow}}2{{CR}} carte di 1 #{{IND}}!!! I re diventano assi"
Descriptions.Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Distrugge fino a {{REG_Yellow}}2{{CR}} carte tenute in mano"
Descriptions.Jimbo.Consumables[Card.CARD_DEATH] = "Scegli {{REG_Yellow}}2{{CR}} carte, la {{REG_Yellow}}seconda{{CR}} diventa una copia della {{REG_Yellow}}prima"
Descriptions.Jimbo.Consumables[Card.CARD_TEMPERANCE] = "{{Coin}} Dà il {{REG_Yellow}}valore di vendita{{CR}} totale dei Jolly avuti in {{Coin}} Monete"
Descriptions.Jimbo.Consumables[Card.CARD_DEVIL] = "{{REG_Gold}} Cambia {{REG_Yellow}}1{{CR}} carta nella tua mano in {{REG_Yellow}}Carte Dorate"
Descriptions.Jimbo.Consumables[Card.CARD_TOWER] = "{{REG_Stone}} Cambia {{REG_Yellow}}1{{CR}} carta nella tua mano in {{REG_Yellow}}Carte di Pietra"
Descriptions.Jimbo.Consumables[Card.CARD_STARS] = "{{REG_Diamond}} Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte nella tua mano in {{REG_Yellow}}Quadri"
Descriptions.Jimbo.Consumables[Card.CARD_MOON] = "{{REG_Club}} Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte nella tua mano in {{REG_CChips}}Fiori"
Descriptions.Jimbo.Consumables[Card.CARD_SUN] = "{{REG_Heart}} Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte nella tua mano in {{REG_CMult}}Cuori"
Descriptions.Jimbo.Consumables[Card.CARD_JUDGEMENT] = "{{REG_Joker}} Dà un {{REG_Yellow}}Jolly{{CR}} casuale #{{IND}}!!! Serve spazio nell'invetario"
Descriptions.Jimbo.Consumables[Card.CARD_WORLD] = "{{REG_Spade}} Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte nella tua mano in {{REG_CSpade}}Picche"


Descriptions.T_Jimbo.Consumables = {}
Descriptions.T_Jimbo.Consumables[Card.CARD_FOOL] = "Crea un copia dell'ultimo {{ColorPink}}Tarocco{{CR}} o {{ColorCyan}}Pianeta{{CR}} usato #{{ColorGray}}(Eccetto The Fool)#[[VALUE1]]"
Descriptions.T_Jimbo.Consumables[Card.CARD_MAGICIAN] = "Cambia fino a {{REG_Yellow}}2{{CR}} carte in {{REG_Yellow}}Carte Fourtunate"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "Crea {{REG_Yellow}}2{{CR}} carte {{ColorCyan}}Pianeta{{CR}} casuali #{{ColorGray}}(Serve spazio)"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPRESS] = "Cambia fino a {{REG_Yellow}}2{{CR}} carte in {{REG_Yellow}}Carte Molt"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPEROR] = "Creates {{REG_Yellow}}2{{CR}} {{ColorPink}}Tarot{{CR}} cards #{{ColorGray}}(Serve spazio)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIEROPHANT] = "Cambia fino a {{REG_Yellow}}2{{CR}} carte in {{REG_Yellow}}Carte Bonus"
Descriptions.T_Jimbo.Consumables[Card.CARD_LOVERS] = "Cambia {{REG_Yellow}}1{{CR}} carta in {{REG_Yellow}}Carta Multiuso"
Descriptions.T_Jimbo.Consumables[Card.CARD_CHARIOT] = "Cambia {{REG_Yellow}}1{{CR}} carta in {{REG_Yellow}}Carta d'Acciaio"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUSTICE] = "Cambia {{REG_Yellow}}1{{CR}} carta in {{REG_Yellow}}Carta di Vero"
Descriptions.T_Jimbo.Consumables[Card.CARD_HERMIT] = "Raddoppia i tuoi soldi  #{{ColorGray}}(Max 20$)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{REG_Mint}}[[CHANCE]] probabilit\224 su 4{{CR}} di dara un'{{REG_Yellow}}Edizione{{CR}} ad un Jolly avuto #{{ColorGray}}(Non cambia edizioni esistenti)"
Descriptions.T_Jimbo.Consumables[Card.CARD_STRENGTH] = "Aumenta il valore di fino a {{REG_Yellow}}2{{CR}} carte di 1 #{{ColorGray}}(I re divenano assi)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Distruggi fino a {{REG_Yellow}}2{{CR}} carte"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{REG_Yellow}}2{{CR}} cards, the {{REG_Yellow}}Left{{CR}} card becomes a copy of the {{REG_Yellow}}Right{{CR}} card"
Descriptions.T_Jimbo.Consumables[Card.CARD_TEMPERANCE] = "Guadagna il {{REG_Yellow}}valore di vendita{{CR}} totale dei tuoi Jolly #{{ColorGray}}(Attualmente {{REG_Yellow}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEVIL] = "Cambia {{REG_Yellow}}1{{CR}} carta in {{REG_Yellow}}Carta Dorata"
Descriptions.T_Jimbo.Consumables[Card.CARD_TOWER] = "Cambia {{REG_Yellow}}1{{CR}} carta in {{REG_Yellow}}Carta di Pietra"
Descriptions.T_Jimbo.Consumables[Card.CARD_STARS] = "Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte in {{REG_Yellow}}Quadri"
Descriptions.T_Jimbo.Consumables[Card.CARD_MOON] = "Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte in {{REG_CChips}}Fiori"
Descriptions.T_Jimbo.Consumables[Card.CARD_SUN] = "Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte in {{REG_CMult}}Cuori"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUDGEMENT] = "Crea un {{REG_Yellow}}Jolly{{CR}} casuale #{{ColorGray}}(Serve spazio)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WORLD] = "Cambia il seme di fino a {{REG_Yellow}}3{{CR}} carte in {{REG_CSpade}}Picche"


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

Descriptions.Jimbo.Consumables[mod.Planets.PLUTO] = "Gli {{REG_Yellow}}Assi{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.MERCURY] = "I {{REG_Yellow}}2{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.URANUS] = "I {{REG_Yellow}}3{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.VENUS] = "I {{REG_Yellow}}4{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.SATURN] = "I {{REG_Yellow}}5{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.JUPITER] = "I {{REG_Yellow}}6{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.EARTH] = "I {{REG_Yellow}}7{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.MARS] = "Gli {{REG_Yellow}}8{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.NEPTUNE] = "I {{REG_Yellow}}9{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.PLANET_X] = "I {{REG_Yellow}}10{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.CERES] = "I {{REG_Yellow}}Jack{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"
Descriptions.Jimbo.Consumables[mod.Planets.ERIS] = "Le {{REG_Yellow}}Regine{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivate"
Descriptions.Jimbo.Consumables[mod.Planets.SUN] = "I {{REG_Yellow}}Re{{CR}} attivati danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno quando attivati"


Descriptions.T_Jimbo.Consumables[mod.Planets.PLUTO] = "Potenzia {{REG_Yellow}}Carta Alta#{{REG_CMult}}+1{{CR}} Molt#{{REG_CChips}}+10{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.MERCURY] = "Potenzia {{REG_Yellow}}Coppia#{{REG_CMult}}+1{{CR}} Molt#{{REG_CChips}}+15{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.URANUS] = "Potenzia {{REG_Yellow}}Doppia Coppia#{{REG_CMult}}+1{{CR}} Molt#{{REG_CChips}}+20{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.VENUS] = "Potenzia {{REG_Yellow}}Tris#{{REG_CMult}}+2{{CR}} Molt#{{REG_CChips}}+20{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.SATURN] = "Potenzia {{REG_Yellow}}Scala#{{REG_CMult}}+3{{CR}} Molt#{{REG_CChips}}+35{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.JUPITER] = "Potenzia {{REG_Yellow}}Colore#{{REG_CMult}}+2{{CR}} Molt#{{REG_CChips}}+15{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.EARTH] = "Potenzia {{REG_Yellow}}Fulle#{{REG_CMult}}+2{{CR}} Molt#{{REG_CChips}}+25{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.MARS] = "Potenzia {{REG_Yellow}}Poker#{{REG_CMult}}+3{{CR}} Molt#{{REG_CChips}}+30{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.NEPTUNE] = "Potenzia {{REG_Yellow}}Scala Flush#{{REG_CMult}}+4{{CR}} Molt#{{REG_CChips}}+40{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.PLANET_X] = "Potenzia {{REG_Yellow}}Pokerissimo#{{REG_CMult}}+3{{CR}} Molt#{{REG_CChips}}+35{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.CERES] = "Potenzia {{REG_Yellow}}Full Colore#{{REG_CMult}}+4{{CR}} Molt#{{REG_CChips}}+40{{CR}} Fiches"
Descriptions.T_Jimbo.Consumables[mod.Planets.ERIS] = "Potenzia {{REG_Yellow}}Colore Perfetto#{{REG_CMult}}+3{{CR}} Molt#{{REG_CChips}}+50{{CR}} Fiches"


----------------------------------------
-------------####SPECTRALS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{REG_Jimbo}} {{REG_Yellow}}Distrugge{{CR}} una carta in mano casuale e aggiunge {{REG_Yellow}}3 {{REG_Face}} Figure Potenziate{{CR}} casuali al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.GRIM] = "{{REG_Jimbo}} {{REG_Yellow}}Distrugge{{CR}} una carta in mano casuale e aggiunge {{REG_Yellow}}2 Assi Potenziati{{CR}} casuali al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{REG_Jimbo}} {{REG_Yellow}}Distrugge{{CR}} una carta in mano casuale e aggiunge {{REG_Yellow}}4 carte numerate potenziate{{CR}} casuali al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.TALISMAN] = "{{REG_Jimbo}} Metti un {{REG_Golden}} {{REG_Yellow}}Sigillo Dorato{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.AURA] = "{{REG_Jimbo}} Dai un'{{REG_Yellow}}Edition{{CR}} casuale ad una carta scelta"
Descriptions.Jimbo.Consumables[mod.Spectrals.WRAITH] = "{{REG_Jimbo}} Fissa le monete avute a {{REG_Yellow}}0 #{{REG_Joker}} Ottieni un {{REG_CMult}}Jolly Raro{{CR}}#{{IND}}!!! Serve spazio nell'inventario"
Descriptions.Jimbo.Consumables[mod.Spectrals.SIGIL] = "{{REG_Jimbo}} Cambia tutte le carte in mano in uno stesso {{REG_Yellow}}Seme{{CR}} casuale"
Descriptions.Jimbo.Consumables[mod.Spectrals.OUIJA] = "{{REG_Jimbo}} Cambia tutte le carte in mano in uno stesso {{REG_Yellow}}Valore{{CR}} casuale"
Descriptions.Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "{{REG_Jimbo}} Rende un Jolly casuale {{ColorGray}}{{ColorFade}}Negativo #{{IND}}!!! Non rimpiazza edizioni già presenti #{{REG_HSize}} {{ColorRed}}-1{{CR}} Carte in mano #{{IND}}!!! Nessun effetto se le carte in mano nono possono essere diminuite"
Descriptions.Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "{{REG_Jimbo}} {{REG_Yellow}}Distrugge{{CR}} fino a {{REG_Yellow}}3{{CR}} carte nella mano #{{Coin}} Guadagna {{REG_Yellow}}4${{CR}} per ogni carta distrutta"
Descriptions.Jimbo.Consumables[mod.Spectrals.ANKH] = "{{REG_Jimbo}} Crea un copia di un Jolly avuto e distrugge gli altri #!!! Rimuove {{ColorGray}}{{ColorFade}}Negativo{{CR}} dalla copia"
Descriptions.Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "{{REG_Jimbo}} Metti un {{ColorRed}}Sigillo Rosso{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.HEX] = "{{REG_Jimbo}} Rende un Jolly casuale {{ColorRainbow}}Policroma{{CR}} e distrugge gli altri"
Descriptions.Jimbo.Consumables[mod.Spectrals.TRANCE] = "{{REG_Jimbo}} Metti un {{ColorCyan}}Sigillo Blu{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.MEDIUM] = "{{REG_Jimbo}} Metti un {{ColorPink}}Sigillo Viola{{CR}} su una carta selezionata"
Descriptions.Jimbo.Consumables[mod.Spectrals.CRYPTID] = "{{REG_Jimbo}} Aggiunge {{REG_Yellow}}2{{CR}} copie di una carta selezionata al mazzo"
Descriptions.Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "{{REG_Jimbo}} {{REG_Yellow}}Tutte le carte{{CR}} attivate danno {{REG_CChips}}+0.02{{CR}} Lacrime e {{REG_CMult}}+0.02{{CR}} Danno"
Descriptions.Jimbo.Consumables[mod.Spectrals.SOUL] = "{{REG_Jimbo}} Ottieni un Jolly {{ColorRainbow}}Loggendario{{CR}} casuale #{{IND}}!!! Serve spazio nell'inventario"



Descriptions.T_Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{REG_Yellow}}Distrugge{{CR}} una carta in mano casuale, aggiunge {{REG_Yellow}}3 Figure Potenziate{{CR}} cauali al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.GRIM] = "{{REG_Yellow}}Distrugge{{CR}} una carta casuale in mano, aggiunge {{REG_Yellow}}2 Assi Potenziati{{CR}} casuali al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{REG_Yellow}}Distrugge{{CR}} una carta casuale in mano, aggiunge {{REG_Yellow}}4 Carte Numerate Potenziate{{CR}} casuali al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TALISMAN] = "Metti un {{REG_Yellow}}Sigillo Dorato{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.AURA] = "D\224 un'{{REG_Yellow}}Edizione{{CR}} casuale ad una carta scelta"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.WRAITH] = "Fissa i soldi avuti a {{REG_Yellow}}0${{CR}}, creates a random {{REG_CMult}}Rare{{CR}} Joker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SIGIL] = "Cambia tutte le carte in mano in uno stesso {{REG_Yellow}}Seme{{CR}} casuale"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.OUIJA] = "Cambia tutte le carte in mano in uno stesso {{REG_Yellow}}Valore{{CR}} casuale #{{REG_CMult}}-1{{CR}} Carte in mano"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "Rende un Jolly casuale {{REG_CSpade}}Negativo #{{ColorRed}}-[[VALUE1]]{{CR}} Carte in mano"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "Distrugge {{REG_Yellow}}5{{CR}} carte casuali dalla tua mano, guadagna {{REG_Yellow}}20$"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ANKH] = "Duplica un {{REG_Yellow}}Jolly{{CR}} casuale avuto, distrugge gli altri [[VALUE1]]"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "Metti un {{REG_Yellow}}Sigillo Rosso{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.HEX] = "Rendi un Jolly casuale {{ColoorRainbow}}Polychroma{{CR}}, distrugge gli altri"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TRANCE] = "Metti un {{REG_Yellow}}Sigillo Blu{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.MEDIUM] = "Metti un {{REG_Yellow}}Sigillo Viola{{CR}} su una carta selezionata"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.CRYPTID] = "Aggiunge {{REG_Yellow}}2{{CR}} copie di una carta selezionata al mazzo"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "Potenzia tutte le {{REG_Yellow}}Mani di Poker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SOUL] = "Crea un Jolly {{ColorRainbow}}Leggendario{{CR}} casuale #{{ColorGray}}(Serve spazio)"


---------------------------------------
--------------BOOSTERS-----------------
---------------------------------------

Descriptions.Jimbo.Boosters = {}
Descriptions.Jimbo.Boosters[mod.Packs.ARCANA] = "Scegli 1 {{ColorPink}}Tarocco{{CR}} fra {{REG_Yellow}}3{{CR}} da ricevere subito"
Descriptions.Jimbo.Boosters[mod.Packs.CELESTIAL] = "Scegli 1 carta {{ColorCyan}}Pianeta{{CR}} fra {{REG_Yellow}}3{{CR}} da ricevere subito"
Descriptions.Jimbo.Boosters[mod.Packs.STANDARD] = "Scegli 1 {{REG_Yellow}}carta da gioco{{CR}} fra {{REG_Yellow}}3{{CR}} da aggiungere al mazzo"
Descriptions.Jimbo.Boosters[mod.Packs.BUFFON] = "Scegli 1 {{REG_Yellow}}Jolly{{CR}} fra {{REG_Yellow}}2{{CR}} da ricevere subito"
Descriptions.Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Scegli 1 carta {{ColorBlue}}Spettrale{{CR}} fra {{REG_Yellow}}2{{CR}} da ricevere subito"



Descriptions.T_Jimbo.Boosters = {}
Descriptions.T_Jimbo.Boosters[mod.Packs.ARCANA] = "Scegli 1 {{ColorPink}}Tarocco{{CR}} fra {{REG_Yellow}}3{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_ARCANA] = "Scegli 1 {{ColorPink}}Tarocco{{CR}} fra {{REG_Yellow}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_ARCANA] = "Scegli fino a 2 {{ColorPink}}Tarocccchi{{CR}} fra {{REG_Yellow}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.CELESTIAL] = "Scegli 1 carta {{ColorCyan}}Pianeta{{CR}} fra {{REG_Yellow}}3{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_CELESTIAL] = "Scegli 1 carta {{ColorCyan}}Pianeta{{CR}} fra {{REG_Yellow}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_CELESTIAL] = "Scegli fino a 2 carte {{ColorCyan}}Pianeta{{CR}} fra {{REG_Yellow}}5{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.STANDARD] = "Scegli 1 carta {{REG_Yellow}}da gioco{{CR}} fra {{REG_Yellow}}3{{CR}} da aggiungere al mazzo"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_STANDARD] = "Scegli 1 carta {{REG_Yellow}}da gioco{{CR}} fra {{REG_Yellow}}5{{CR}} da aggiungere al mazzo"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_STANDARD] = "Scegli fino a 2 carte {{REG_Yellow}}da gioco{{CR}} fra {{REG_Yellow}}5{{CR}} da aggiungere al mazzo"
Descriptions.T_Jimbo.Boosters[mod.Packs.BUFFON] = "Scegli 1 {{REG_Yellow}}Jolly{{CR}} fra {{REG_Yellow}}2{{CR}} da ricevere subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_BUFFON] = "Scegli 1 {{REG_Yellow}}Jolly{{CR}} fra {{REG_Yellow}}4{{CR}} da ricevere subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_BUFFON] = "Scegli fino a 2 {{REG_Yellow}}Jolly{{CR}} fra {{REG_Yellow}}4{{CR}} da ricevere subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Scegli 1 carta {{ColorBlue}}Spettrale{{CR}} fra {{REG_Yellow}}2{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_SPECTRAL] = "Scegli 1 carta {{ColorBlue}}Spettrale{{CR}} fra {{REG_Yellow}}4{{CR}} da usare subito"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_SPECTRAL] = "Scegli fino a 2 carte {{ColorBlue}}Spettrali{{CR}} fra {{REG_Yellow}}4{{CR}} da usare subito"


----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------


Descriptions.T_Jimbo.Vouchers = {}

Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber] = "{{REG_CChips}}+1{{CR}} mano ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.NachoTong] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful] = "{{REG_CMult}}+1{{CR}} scarto ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Recyclomancy] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush] = "{{REG_CChips}}+1{{CR}} carte in mano"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Palette] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Clearance] = "Gli oggetti sono scontati del {{REG_Yellow}}25% #{{ColorGray}}(Arr. per difetto)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Liquidation] = "Gli oggetti sono scontati del {{REG_Yellow}}50% #{{ColorGray}}(Arr. per difetto)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock] = "{{REG_Yellow}}+1{{CR}} Carta disponibile el negozio"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.OverstockPlus] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hone] = "Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{REG_Yellow}}2X{{CR}} pi\242 spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.GlowUp] = "Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{REG_Yellow}}4X{{CR}} pi\242 spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollSurplus] = "I {{REG_Mint}}Cambi{{CR}} costano {{REG_Yellow}}2${{CR}} in meno"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollGlut] = "I {{REG_Mint}}Rerolls{{CR}} costano altri {{REG_Yellow}}2${{CR}} in meno"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Crystal] = "{{REG_Yellow}}+1{{CR}} slot consumabile"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Omen] = "Le carte {{ColorBlue}}Spettrali{{CR}} possono apparire nelle {{REG_Yellow}}Buste Arcane"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Telescope] = "Le {{REG_Yellow}}Buste Celestiali{{CR}} hanno sempre il {{colorCyan}}Pianeta{{CR}} per la tua mano pi\242 giocata"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Observatory] = "Le carte {{ColorCyan}}Pianeta{{CR}} tenute danno {{REG_CMult}}X1.5{{CR}} Molt per la loro mano corrispettiva"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotMerch] = "I {{ColorPink}}Tarocchi{{CR}} appaiono {{REG_Yellow}}2X{{CR}} pi\242 spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotTycoon] = "I {{ColorPink}}Tarocchi{{CR}} appaiono {{REG_Yellow}}4X{{CR}} pi\242 spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetMerch] = "I {{ColorCyan}}Pianeti{{CR}} appaiono {{REG_Yellow}}2X{{CR}} pi\242 spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetTycoon] = "I {{ColorCyan}}Pianeti{{CR}} appaiono {{REG_Yellow}}4X{{CR}} pi\242 spesso"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneySeed] = "Gli interessi massimi aumentano a {{REG_Yellow}}10$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneyTree] = "Gli interessi massimi aumentano a {{REG_Yellow}}20$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Blank] = "{{ColorGray}}Niente?"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Antimatter] = "{{REG_CSpade}}+1{{CR}} slot Jolly"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MagicTrick] = "Le {{REG_Yellow}}Carte da Gioco{{CR}} possono apparire nello shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Illusion] = "Le {{REG_Yellow}}Carte da Gioco{{CR}} nel negozio possono avere {{REG_Yellow}}Potenziamenti{{CR}},{{REG_Yellow}}Edizioni{{CR}} o {{REG_Yellow}}Sigilli"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hieroglyph] = "{{REG_Yellow}}-1{{CR}} Ante#{{REG_CChips}}-1{{CR}} Mano ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Petroglyph] = "{{REG_Yellow}}-1{{CR}} Ante#{{REG_CMult}}-1{{CR}} Scarto ogni round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Director] = "{{ColorPink}}Cambia{{CR}} il buio boss {{REG_Yellow}}una{{CR}} volta per Ante#({{REG_Yellow}}10${{CR}} per ogni cambio)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Retcon] = "{{ColorPink}}Cambia{{CR}} il buio boss {{REG_Yellow}}infinite{{CR}} volte per Ante#({{REG_Yellow}}10${{CR}} per ogni cambio)"

    EID:addCollectible(mod.Vouchers.Grabber, "{{REG_Jimbo}} {{REG_CChips}}+5{{CR}} {{REG_Hand}} playable cards every room", "Manesco", FileLanguage)
    EID:addCollectible(mod.Vouchers.NachoTong, "{{REG_Jimbo}} {{REG_CChips}}+5{{CR}} {{REG_Hand}} playable cards every room", "Mano sui nachos", FileLanguage)

    EID:addCollectible(mod.Vouchers.Wasteful, "{{REG_Jimbo}} {{REG_CMult}}+1{{CR}} {{Heart}} Cuore #{{Heart}} Cura totale", "Wasteful", FileLanguage)
    EID:addCollectible(mod.Vouchers.Recyclomancy, "{{REG_Jimbo}} {{REG_CMult}}+1{{CR}} {{Heart}} Cuore #{{Heart}} Cura totale", "Recyclomancy", FileLanguage)

    EID:addCollectible(mod.Vouchers.Overstock, "{{REG_Jimbo}} Ogni negozio futuro avrà 1 {{REG_Joker}} Jolly aggiuntivo in vendita", "Più merce", FileLanguage)
    EID:addCollectible(mod.Vouchers.OverstockPlus, "{{REG_Jimbo}} Ogni negozio futuro avrà 1 {{REG_Joker}} Jolly aggiuntivo in vendita", "Troppa merce", FileLanguage)

    EID:addCollectible(mod.Vouchers.Clearance, "{{REG_Jimbo}} Tutto viene scontato del {{REG_Yellow}}25% #{{IND}}!!! I prezzi sono arrotondati per difetto", "Svendita", FileLanguage)
    EID:addCollectible(mod.Vouchers.Liquidation, "{{REG_Jimbo}} Tutto viene scontato del {{REG_Yellow}}50% #{{IND}}!!! I prezzi sono arrotondati per difetto", "Liquidazione", FileLanguage)

    EID:addCollectible(mod.Vouchers.Hone, "{{REG_Jimbo}} Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{REG_Yellow}}2x{{CR}} più frequentemente", "Lucidatura", FileLanguage)
    EID:addCollectible(mod.Vouchers.GlowUp, "{{REG_Jimbo}} Le {{ColorRainbow}}Edizioni{{CR}} speciali appaiono {{REG_Yellow}}4x{{CR}} più frequentemente", "Perfezionamento", FileLanguage)

    EID:addCollectible(mod.Vouchers.RerollSurplus, "{{REG_Jimbo}} Attivare una {{RestockMachine}} Restock Machine ridà indietro {{REG_Yellow}}1{{CR}} {{Coin}} Moneta", "Cambi in Surplus", FileLanguage)
    EID:addCollectible(mod.Vouchers.RerollGlut, "{{REG_Jimbo}} Attivare una {{RestockMachine}} Restock Machine ridà indietro {{REG_Yellow}}2{{CR}} {{Coin}} Monete", "Eccesso di Cambi", FileLanguage)

    EID:addCollectible(mod.Vouchers.Crystal, "{{REG_Jimbo}} Ogni {{REG_Yellow}}Busta di Espansione{{CR}} ha {{REG_Yellow}}1{{CR}} opzione aggiuntiva", "Palla di Cristallo", FileLanguage)
    EID:addCollectible(mod.Vouchers.Omen, "{{REG_Jimbo}} Le {{ColorPink}}Busta Arcane{{CR}} possono contenere carte {{ColorBlue}}Spettrali", "Sfera Presagente", FileLanguage)

    EID:addCollectible(mod.Vouchers.Telescope, "{{REG_Jimbo}} Saltare una {{ColorCyan}}Busta Celestiale{{CR}} crea {{REG_Yellow}}2{{CR}} {{REG_Planet}} {{ColorCyan}}Carte Pianeta{{CR}} casuali aggiuntive", "Telescopio", FileLanguage)
    EID:addCollectible(mod.Vouchers.Observatory, "{{REG_Jimbo}} Le carte danno {{Damage}} {{REG_CMult}}X1.15{{CR}} Molt. di Danno quando attivate se la loro corrispettiva carta {{ColorCyan}}Pianeta{{CR}} è tenuta #{{IND}}{{Planetarium}} Anche avere il corrispettivo oggetto del planetario attiva l'effetto", "Osservatorio", FileLanguage)

    EID:addCollectible(mod.Vouchers.Blank, "{{REG_Jimbo}} {{ColorFade}}Niente?", "Vuoto", FileLanguage)
    EID:addCollectible(mod.Vouchers.Antimatter, "{{REG_Jimbo}} {{REG_Yellow}}+1{{CR}} slot {{REG_Joker}} Jolly", "Antimateria", FileLanguage)

    EID:addCollectible(mod.Vouchers.Brush, "{{REG_Jimbo}} {{REG_CChips}}+1{{CR}} {{REG_HSize}} Carte in mano", "Pennello", FileLanguage)
    EID:addCollectible(mod.Vouchers.Palette, "{{REG_Jimbo}} {{REG_CChips}}+1{{CR}} {{REG_HSize}} Carte in mano", "Tavolozza", FileLanguage)

    EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Cambia tutti i piedistalli nella stanza al costo di 5 monete", "Versione del Regista", FileLanguage)
    EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Attiva il {{Collectible283}} D100 al costo di 5 monete", "Retcon", FileLanguage)

    EID:addCollectible(mod.Vouchers.Hieroglyph, "{{REG_Retrigger}} Ricomincia il piano attuale quando preso", "Geroglifo", FileLanguage)
    EID:addCollectible(mod.Vouchers.Petroglyph, "{{REG_Retrigger}} Ricomincia il piano attuale quando preso", "Petroglifo", FileLanguage)

    EID:addCollectible(mod.Vouchers.MagicTrick, "Le buste di espansione hanno {{REG_Mint}}[[CHANCE]] probabilità su 4{{CR}} di permettere una scelta aggiuntiva dopo la precedente #{{IND}} Può attivarsi più volte", "Trucco di Magia", FileLanguage)
    EID:addCollectible(mod.Vouchers.Illusion, "Le buste di espansione hanno {{REG_Mint}}[[CHANCE]] probabilità su 2{{CR}} di contenere {{REG_Yellow}}2{{CR}} opzioni in pi\242 #Le buste di espansione hanno {{REG_Mint}}[[CHANCE]] probabilità su 5{{CR}} di permettere {{REG_Yellow}}1{{CR}} scelta aggiuntiva", "Illusione", FileLanguage)

    EID:addCollectible(mod.Vouchers.MoneySeed, "{{REG_Jimbo}} Interessi massimi aumentati a {{REG_Yellow}}10{{CR}} {{Coin}} Monete", "Seme del Successo", FileLanguage)
    EID:addCollectible(mod.Vouchers.MoneyTree, "{{REG_Jimbo}} Interessi massimi aumentati a {{REG_Yellow}}20{{CR}} {{Coin}} Monete", "Albero di Soldi", FileLanguage)

    EID:addCollectible(mod.Vouchers.PlanetMerch, "{{REG_Planet}} Ogni pickup ha {{REG_Mint}}[[CHANCE]] probabilità su 15{{CR}} di essere rimpiazzato con una {{ColorCyan}}Carta Pianeta{{CR}} casuale", "Mercante di Pieneti", FileLanguage)
    EID:addCollectible(mod.Vouchers.PlanetTycoon, "{{REG_Planet}} Ogni pickup ha {{REG_Mint}}[[CHANCE]] probabilità su 10{{CR}} aggiuntiva di essere rimpiazzato con una {{ColorCyan}}Carta Pianeta{{CR}} casuale", "Magnate di Pianeti", FileLanguage)

    EID:addCollectible(mod.Vouchers.TarotMerch, "{{Card}} Ogni pickup ha {{REG_Mint}}[[CHANCE]] probabilità su 15{{CR}} di essere rimpiazzato con un {{ColorPink}}Tarocco{{CR}} casuale", "Mercante di Tarocchi", FileLanguage)
    EID:addCollectible(mod.Vouchers.TarotTycoon, "{{Card}} Ogni pickup ha {{REG_Mint}}[[CHANCE]] probabilità su 10{{CR}} aggiuntiva di essere rimpiazzato con un {{ColorPink}}Tarot Card{{CR}} casuale", "Magnate di Tarocchi", FileLanguage)


    Descriptions.PackSynergies = {}
    Descriptions.PackSynergies[mod.Vouchers.Crystal] = "#{{Collectible"..mod.Vouchers.Crystal.."}} {{REG_Yellow}}+1{{CR}} opzione disponibile"
    Descriptions.PackSynergies[mod.Vouchers.Omen] = "#{{Collectible"..mod.Vouchers.Omen.."}} Può contenere {{ColorBlue}}carte Spettrali{{CR}}"
    Descriptions.PackSynergies[mod.Vouchers.Telescope] = "#{{Collectible"..mod.Vouchers.Telescope.."}} Se le opzioni vengono saltate, crea 2 {{ColorCyan}}Carte Pianeta{{CR}} aggiuntive"
    Descriptions.PackSynergies[mod.Vouchers.MagicTrick] = "#{{Collectible"..mod.Vouchers.MagicTrick.."}} Dopo aver preso una scelta, {{REG_Mint}}[[CHANCE]] probabilità su 4{{CR}} di permetterne una aggiuntiva"
    Descriptions.PackSynergies[mod.Vouchers.Illusion] = "#{{Collectible"..mod.Vouchers.Illusion.."}} {{REG_Mint}}[[CHANCE]] probabilit\225 su 2{{CR}} di avere {{REG_Yellow}}+1{{CR}} opzione disponibile #{{Collectible"..mod.Vouchers.Illusion.."}} {{REG_Mint}}[[CHANCE]] probabilità su 5{{CR}} di permettere un scelta aggiuntiva"


-------------------------------------
---------------MAIN GAME-------------
-------------------------------------

EID:addCard(mod.Packs.ARCANA, "{{Card}} Permette di scegliere 1 {{ColorPink}}Tarocco{{CR}} su 3 da ottenere immediatamente", "Busta Arcana", FileLanguage)
EID:addCard(mod.Packs.CELESTIAL, "{{REG_Planet}} Permette di scegliere 1 {{ColorCyan}}carta Pianeta{{CR}} su 3 da ottenere immediatamente", "Busta Celestiale", FileLanguage)
EID:addCard(mod.Packs.SPECTRAL, "{{REG_Spectral}} Permette di scegliere 1 {{ColorBlue}}carta Spettrale{{CR}} su 2 da ottenere immediatamente", "Busta Spettrale", FileLanguage)
EID:addCard(mod.Packs.BUFFON, "{{REG_Joker}} Permette di scegliere 1 {{REG_Yellow}}Jolly{{CR}} su 3 da ottenere immediatamente #!!! {{ColorGray}}(Non richiede spazio)", "Busta Buffone", FileLanguage)
EID:addCard(mod.Packs.STANDARD, "{{REG_HSize}} Permette di scegliere 1 {{REG_Yellow}}carta da gioco{{CR}} su 3 da aggiungere al mazzo", "Busta Standard", FileLanguage)


EID:addCollectible(mod.Collectibles.BALOON_PUPPY, "Famiglio che riflette i proiettili nemici e infligge 7.5 danni da contatto al secondo #Dopo aver subito abbastanza danno, esplode infliggendo {{ColorTellorange}}3 x Danno di Isaac{{CR}} ai nemici vicini #Inizia a inseguire i nemici se Isaac prende danno", "Cucciolo Pallone",FileLanguage)		
EID:addCollectible(mod.Collectibles.BANANA, "Mira e spara una banana devastante che crea un'esplosione {{Collectible483}} Mama Mega! all'atterraggio #!!! Diventa {{Collectible"..mod.Collectibles.EMPTY_BANANA.."}} Buccia di Banana dopo l'uso", "Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.EMPTY_BANANA, "Lascia una buccia di banana a terra #I nemici possono scivolare sule bucce, prendendo danno e diventando {{Confusion}} confusi #{{IND}} Il danno inflitto scala con la velocità a cui si muoveva il nemico", "Buccia di Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.CLOWN, "La metà dei nemici diventa {{Charm}} Ammaliata o {{Fear}} Impaurita stando vicino ad Isaac", "Costume da Clown",FileLanguage)		
EID:addCollectible(mod.Collectibles.CRAYONS, "Muovendoti, lasci una scia di pastello colorata che infligge vari status ai nemici #{{IND}} L'effetto varia in base al colore dela scia #Il colore della scia cambia ongi stanza", "Scatola di Pastelli",FileLanguage)		
EID:addCollectible(mod.Collectibles.FUNNY_TEETH, "Famiglio che insegue i nemici infliggendo 15 danni al secondo #{{IND}}Il danno inflitto aumenta leggermente in base al piano attuale #{{Chargeable}} Dopo essere rimasto attivo per un po' deve venire ricaricato standogli vicino", "Denti Sbellicosi",FileLanguage)		
EID:addCollectible(mod.Collectibles.HORSEY, "Famiglio che salta in un pattern ad L, creando delle onde d'urto all'atterraggio #{{IND}}!!! Le onde non danneggiano Isaac", "Cavallino",FileLanguage)		
EID:addCollectible(mod.Collectibles.LAUGH_SIGN, "Il pubblico reagisce in diretta alle azioni di Isaac #{{BossRoom}} Completare una stanza del boss rimcompensa con qualche pickup casuale #Subire danno lancia dei pomodori che infliggono {{Bait}} Adescamento all'atterraggio", "Ridere!",FileLanguage)		
EID:addCollectible(mod.Collectibles.LOLLYPOP, "{{Timer}} Un lecca lecca appare ogni 18 secondi spesi in una stanza ostile #{{Collectible93}} Prendere un lecca lecca attiva l'effetto di Gamekid! per 4 secondi #!!! Fino a 3 lecca lecca possono essere a terra", "Lecca Lecca",FileLanguage)		
EID:addCollectible(mod.Collectibles.POCKET_ACES, "{{Luck}} 8% di probabilità di sparare un asso #Gli assi infliggono danno uguale al prodotto del {{Damage}} Danno e delle {{Tears}} Lacrime di Isaac", "Assi di Tasca",FileLanguage)		
EID:addCollectible(mod.Collectibles.TRAGICOMEDY, "40% di probabilità una maschera {{REG_Comedy}} comica o {{REG_Tragedy}} tragica completando una stanza #{{IND}}!!! Possono essere indossate entrambe #{{REG_Comedy}} La maschera comica dà: #{{IND}}{{Tears}} +1 Firedelay #{{IND}}{{Speed}} +0.2 Velocità  #{{IND}}{{Luck}} +2 Luck #{{REG_Tragedy}} La maschera tragica dà: #{{IND}}{{Tears}} +0.5 Firedelay,  #{{IND}}{{Damage}} +1 Danno Fisso  #{{IND}}{{Range}} +2.5 Range", "Tragicommedia",FileLanguage)		
EID:addCollectible(mod.Collectibles.UMBRELLA, "All'uso Isaac apre un ombrello, facendo cadere degli incudini su di lui ofgni 5 ~ 7 secondi #{{IND}} Gli incudini creano un'onda d'urto all'atterraggio #{{IND}} Gli incudini possono essere riflessi con l'ombrello, lanciandoli contro un nemico vicino #{{IND}}!!! Le onde d'urto danneggiano Isaac solo se l'incudine non viene bloccato #!!! Usare nuovamente l'oggetto chiude l'ombrello e ferma gli incudini", "Ombrello",FileLanguage)		

for i = 1, Balatro_Expansion.TastyCandyNum do --puts every candy stage

    EID:addTrinket(Balatro_Expansion.Trinkets.TASTY_CANDY[i], "{{Beggar}} Garantisce un premio interagendo con un beggar qualunque #!!! Usi rimasti: {{REG_Yellow}}"..i, "Caramela Gustosa", FileLanguage)		
    EID:addGoldenTrinketMetadataAdditive(mod.Trinkets.TASTY_CANDY[i], "{{ColorGold}}20% di probabilità di ripristinare un uso completando una stanza", nil, nil, FileLanguage)
end

EID:addCharacterInfo(mod.Characters.JimboType, "#Le carte sparate dalla tua {{REG_HSize}} mano possono assegnare punti un nmero limitato di volte per stanza o finchè il mazzo non viene rimischiato #Le statistiche ottenute così sono azzerate ogni stanza #Scarta la tua mano subendo danno #Gli Hp up normali sono trasformati in {{REG_Yellow}}buste di espansione #{{Shop}} Sconfiggi un buio entrando in un {{REG_Yellow}}negozio{{CR}} o battendo il {{REG_Yellow}}boss{{CR}} del piano #Saltare un buio andando al prossimo piano premia con {{REG_Yellow}}buste di espansione", "Jimbo", FileLanguage)
EID:addBirthright(mod.Characters.JimboType, "{{REG_Joker}} +1 {{REG_Yellow}}slot Jolly", "Jimbo", FileLanguage)


EID:addCollectible(mod.Collectibles.HEIRLOOM, "{{Coin}} Le monete possono avere il loro valore aumentato #{{Coin}} Tutti i pickup hanno una possibilità maggiore di essere dorati", "Cimelio",FileLanguage)		
EID:addTrinket(mod.Trinkets.PENNY_SEEDS, "{{Coin}} Crea una moneta per ogni 5 monete avute entrando in un nuovo piano #{{IND}} Bassa probabilità che le monete create siano un trinket moneta o {{Collectible74}} The quarter", "Semmy Spiccioli",FileLanguage)		
EID:addCollectible(mod.Collectibles.THE_HAND, "{{Card}} Up to 5 cards or runes can be stored in the active item #!!! Cards in excess will be destroyed #{{Chargeable}} Holding the item uses the cards stored in the order shown # Press [DROP] key to cycle the held cards # Also collects pickups and deals Danno to enemies hit", "The Hand",FileLanguage)		
EID:addCard(mod.JIMBO_SOUL, "{{Timer}} Per una stanza, bilancia il danno e le lacrime di Isaac #La durata aumenta se usata più volte", "Soul of Jimbo", FileLanguage)
EID:addTrinket(mod.Jokers.CHAOS_THEORY, "{{Collectible402}} Tutti i pickup creati sono casuali", "Chaos Theory", FileLanguage)		
EID:addCollectible(mod.Collectibles.ERIS, "{{Freezing}} Isaac ottiene un'aura congelante che rallenta progressivamente i nemici #Se rallentati abbastanza, I nemici perdono il 4% dei loro HP attuali {{ColorGray}}(Min. 0.1){{CR}} ogni tick #{{IND}}{{Freezing}} I nemici uccisi in questo stato vengono congelati", "Erice",FileLanguage)		
EID:addCollectible(mod.Collectibles.PLANET_X, "{{Planetarium}} Ottieni l'effetto di un oggetto del planetario casuale ogni stanza completata", "Pianeta X",FileLanguage)		
EID:addCollectible(mod.Collectibles.CERES, "Famiglio orbitale che blocca i prioettili nemici e infligge 1 danno da contatto ogni secondo #Quando colpito, crea dei frammenti di asteroide che bloccano fino a 2 proiettili nemici e infligge 2 x il danno di Isaac", "Cerere",FileLanguage)		

EID:addGoldenTrinketMetadataAdditive(mod.Trinkets.PENNY_SEEDS, "{{ColorGold}}Le monete create posso essere di ogni tipo #{{ColorGold}}5% di probabilità per i trinket creati di essere dorati #{{IND}}!!! {{ColorGray}}(solo se sbloccati)", nil, nil, FileLanguage)
EID:addGoldenTrinketMetadataAdditive(mod.Jokers.CHAOS_THEORY, "{{ColorGold}}Ottieni anche l'effetto di {{Collectible402}} Chaos", nil, nil, FileLanguage)


Descriptions.ItemItemSynergies = {}
Descriptions.ItemItemSynergies[mod.Collectibles.FUNNY_TEETH] = {[CollectibleType.COLLECTIBLE_APPLE] = "# Lascia una scia di sangue",
                                                                [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = "# Si ricarica parzialmente uccidendo un nemico",
                                                                [CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = "# Può applicare effetti di stao casuali",
                                                                [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = "# Può applicare {{Bait}} Adescamento ai nemici",
                                                                [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Può rendere i nemici {{Coin}} dorati",
                                                                [CollectibleType.COLLECTIBLE_DEAD_TOOTH] = "# Può {{Poison}} avvelenare i nemici",
                                                                [CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = "# Può curare il possessore di {{HalfHeart}} mezzo cuore rosso uccidendo i nemici",
                                                                [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Può {{Poison}} avvelenare i nemici # Può creare un {{BlackHeart}} cuore nero ad ogni nemico ucciso",
                                                                [CollectibleType.COLLECTIBLE_DOG_TOOTH] = "# Danno e velocitò aumentati",
                                                                [CollectibleType.COLLECTIBLE_TOUGH_LOVE] = "# Infligge il 35% di danno in piò",
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

Descriptions.TrinketItemSynergies = {}
Descriptions.TrinketItemSynergies[TrinketType.TRINKET_ICE_CUBE] = {[mod.Collectibles.CERES] = "Maggiore raggio d'azione e velocità di rallentamento"}

--inverts the table to make collectible synergy descriptions lookup faster
Descriptions.ItemTrinketSynergies = {}
for Trinket,TrinketSyn in pairs(Descriptions.TrinketItemSynergies) do
    
    for Item, SynString in pairs(TrinketSyn) do
        
        Descriptions.ItemTrinketSynergies[Item] = Descriptions.TrinketItemSynergies[Item] or {}
        Descriptions.ItemTrinketSynergies[Item][Trinket] = SynString

        Descriptions.ItemTrinketSynergies[Item][Trinket] = "#{{Trinket"..Trinket.."}}"..Descriptions.ItemTrinketSynergies[Item][Trinket]
        Descriptions.TrinketItemSynergies[Trinket][Item] = "#{{Collectible"..Item.."}}"..Descriptions.TrinketItemSynergies[Trinket][Item]
    end
end


Descriptions.TrinketEdition = {[mod.Edition.BASE] = "",
                               [mod.Edition.FOIL] = "#{{Tears}} {{REG_CChips}}+1{{CR}} Lacrime",
                               [mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{REG_CMult}}+1.5{{CR}} Danno fisso",
                               [mod.Edition.POLYCROME] = "#{{Damage}} {{REG_CMult}}x1.2{{CR}} Molt. di Danno",
                               [mod.Edition.NEGATIVE] = "#{{Collectible479}} Ingoiato appena preso"
                             }



end --END EID EXCLUSIVES

return Descriptions