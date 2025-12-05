---@diagnostic disable: param-type-mismatch
local mod = Balatro_Expansion


----TUTORIAL FOR YOU BEAUTIFUL TRANSLATORS!!!------
---------------------------------------------------

--be sure to modify the file language variable right after this tutorial with the appropriate EID language code (it's a one time thing!)

--only translate things inside the quotes ("..."), NOT the variables' name

--things written inside brackets ({{...}} / [[...]]) need to be kept intact, thay are names needed for symbols and procedurally generated text
    --you can however move them freely in the string to make it have sense
    --most of the [[...]] are variable numbers, but sometimes they are shorter words or entire phrases
        --you can check EID.lua to see what each of them is, but feel free to ask directly if that's too confusing!

--in general try to mantain the style of the balatro descriptions, so:
    --Balatro-related terms shoud be kept as similar as possible to the original game
    --Keep things short without any overcomplications
    --Important terms should be highlighted with {{REG_Yellow}}...{{CR}}
    --Specific things shuch as the suits should always be colored correctly and preceded with they respective symbo (too lazy to make a list)
        --DO NOT put symbols inside the T_Jimbo descriptions, they will not be diplayed correctly if you do

--stuff added/modified after the original release is marked with UPDATE_X, so they're easier to spot

--don't rush this out, 1100+ lines are A LOT and will def take some time so try to not force yourself into doing this if you don't want!


--------SPECIAL CHARACTERS LIST--------
--many special characters are f-ed up in rendering so u need to write them as raw symbols
    --I suggest writing stuff normally and then replace everithing with whatever command your editor has 

--go here to see the ones you need: https://wofsauge.github.io/IsaacDocs/rep/images/tutorial_special_chars/b3.png
--(some might not be compatible with the font used)

---------------------------------------

--All of that said, good luck!
-------------------------------------------------
-------------------------------------------------

local FileLanguage = "en_us" --REMEMBER TO MODIFY ME!!
local Descriptions = {}

Descriptions.Other = {} 
Descriptions.Other.Name = "Inventory Helper"
Descriptions.Other.LV = "LV." --abbreviation of LEVEL

Descriptions.Other.ConfirmName = "{{ColorSilver}}Confirm"
Descriptions.Other.ConfirmDesc = "Confirm the current card selection"

Descriptions.Other.SkipName = "{{ColorSilver}}Skip"
Descriptions.Other.SkipDesc = "Skip the remaining pack options"

Descriptions.Other.SellJoker = "Sell the selected joker"
Descriptions.Other.SellsFor = "Sells for" --sells for x amount of money
Descriptions.Other.FREE = "FREE"


Descriptions.Other.Exit = "Exit overview"

Descriptions.Other.NONE = "NONE"
Descriptions.Other.Nothing = "Nothing"
Descriptions.Other.EmptySlot = "This slot's empty!"

Descriptions.Other.Remaining = "remaining"
Descriptions.Other.Currently = "Currently:"
Descriptions.Other.CompatibleTriggered = "Compatible cards triggered: "
Descriptions.Other.CompatibleDiscarded = "Compatible cards discarded: "
Descriptions.Other.SuitChosen = "Suit chosen: "
Descriptions.Other.CardChosen = "Card chosen: "
Descriptions.Other.ValueChosen = "Rank chosen: "
Descriptions.Other.HandTypeChosen = "Hand Type chosen: "
Descriptions.Other.RoomsRemaining = "Rooms remaining: "
Descriptions.Other.BlindsCleared = "Blinds cleared: "
Descriptions.Other.DiscardsRemaining = "Discards remaining: "
Descriptions.Other.RemovesNeg = "Removes negative from the copy"
Descriptions.Other.ChipsScored = "Chips when scored"

Descriptions.Other.Cleared = "Cleared"
Descriptions.Other.NotCleared = "Upcoming"


Descriptions.Other.Active = "{{REG_Yellow}}Active!"
Descriptions.Other.NotActive = "{{REG_CMult}}Not active!"
Descriptions.Other.Compatible = "{{REG_Mint}}Compatible"
Descriptions.Other.Incompatible = "{{REG_CMult}}Incompatible"
Descriptions.Other.Ready = "{{REG_Yellow}}Ready!"
Descriptions.Other.NotReady = "{{ColorRed}}Not ready!"

Descriptions.Other.Enhanced = "Enhanced cards"

Descriptions.Other.Rounds = "Rounds"
Descriptions.Other.HandSize = "Hand Size" --as in the Balatro stat


Descriptions.HandTypeName = {[mod.HandTypes.NONE] = "",
                         [mod.HandTypes.HIGH_CARD] = "High Card",
                         [mod.HandTypes.PAIR] = "Pair",
                         [mod.HandTypes.TWO_PAIR] = "Two Pair",
                         [mod.HandTypes.THREE] = "Three of a Kind",
                         [mod.HandTypes.STRAIGHT] = "Striaght",
                         [mod.HandTypes.FLUSH] = "Flush",
                         [mod.HandTypes.FULL_HOUSE] = "Full House",
                         [mod.HandTypes.FOUR] = "Four of a Kind",
                         [mod.HandTypes.STRAIGHT_FLUSH] = "Straight Flush",
                         [mod.HandTypes.ROYAL_FLUSH] = "Royal Flush",
                         [mod.HandTypes.FIVE] = "Five of a Kind",
                         [mod.HandTypes.FLUSH_HOUSE] = "Flush House",
                         [mod.HandTypes.FIVE_FLUSH] = "Flush Five",}



Descriptions.EnhancementName = {}
--Descriptions.Other.Enhancement[mod.Enhancement.BONUS] = ""
--Descriptions.Other.Enhancement[mod.Enhancement.MULT]  
--Descriptions.Other.Enhancement[mod.Enhancement.GOLDEN]
--Descriptions.Other.Enhancement[mod.Enhancement.GLASS] 
--Descriptions.Other.Enhancement[mod.Enhancement.LUCKY] 
--Descriptions.Other.Enhancement[mod.Enhancement.STEEL] 
--Descriptions.Other.Enhancement[mod.Enhancement.WILD]  
Descriptions.EnhancementName[mod.Enhancement.STONE] = "{{ColorGray}}Stone Card"



Descriptions.BasicEnhancementName = {}
--Descriptions.Other.Enhancement[mod.Enhancement.BONUS] = ""
--Descriptions.Other.Enhancement[mod.Enhancement.MULT]  
--Descriptions.Other.Enhancement[mod.Enhancement.GOLDEN]
--Descriptions.Other.Enhancement[mod.Enhancement.GLASS] 
--Descriptions.Other.Enhancement[mod.Enhancement.LUCKY] 
--Descriptions.Other.Enhancement[mod.Enhancement.STEEL] 
--Descriptions.Other.Enhancement[mod.Enhancement.WILD]  
Descriptions.BasicEnhancementName[mod.Enhancement.STONE] = "Stone Card"


Descriptions.Rarity = {}
Descriptions.Rarity["common"] = "{{REG_CChips}}common"
Descriptions.Rarity["uncommon"] = "{{REG_Mint}}uncommon"
Descriptions.Rarity["rare"] = "{{REG_CMult}}rare"
Descriptions.Rarity["legendary"] = "{{ColorRainbow}}legendary"




Descriptions.Jimbo = {}
Descriptions.T_Jimbo = {}

-------------------------------------
--------------BLINDS-----------------
-------------------------------------

    
Descriptions.BlindNames = {[mod.BLINDS.SMALL] = "Small blind",
                           [mod.BLINDS.BIG] = "Big blind",
                           [mod.BLINDS.BOSS] = "Boss Blind",
                           [mod.BLINDS.BOSS_ACORN] = "Amber acorn",
                           [mod.BLINDS.BOSS_ARM] = "The Arm",
                           [mod.BLINDS.BOSS_BELL] = "Cerulean Bell",
                           [mod.BLINDS.BOSS_CLUB] = "The club",
                           [mod.BLINDS.BOSS_EYE] = "The eye",
                           [mod.BLINDS.BOSS_FISH] = "The fish",
                           [mod.BLINDS.BOSS_FLINT] = "The flint",
                           [mod.BLINDS.BOSS_GOAD] = "The goad",
                           [mod.BLINDS.BOSS_HEAD] = "The head",
                           [mod.BLINDS.BOSS_HEART] = "Crimson Heart",
                           [mod.BLINDS.BOSS_HOOK] = "The hook",
                           [mod.BLINDS.BOSS_HOUSE] = "The house",
                           [mod.BLINDS.BOSS_LEAF] = "Verdant leaf",
                           [mod.BLINDS.BOSS_MANACLE] = "The manacle",
                           [mod.BLINDS.BOSS_MARK] = "The mark",
                           [mod.BLINDS.BOSS_MOUTH] = "The mouth",
                           [mod.BLINDS.BOSS_NEEDLE] = "The needle",
                           [mod.BLINDS.BOSS_OX] = "The ox",
                           [mod.BLINDS.BOSS_PILLAR] = "The pillar",
                           [mod.BLINDS.BOSS_PLANT] = "The plant",
                           [mod.BLINDS.BOSS_PSYCHIC] = "The psychic",
                           [mod.BLINDS.BOSS_SERPENT] = "The serpent",
                           [mod.BLINDS.BOSS_TOOTH] = "The tooth",
                           [mod.BLINDS.BOSS_VESSEL] = "Violet Vessel",
                           [mod.BLINDS.BOSS_WALL] = "The wall",
                           [mod.BLINDS.BOSS_WATER] = "The water",
                           [mod.BLINDS.BOSS_WHEEL] = "The wheel",
                           [mod.BLINDS.BOSS_WINDOW] = "The window",
                           [mod.BLINDS.BOSS_LAMB] = "The lamb",
                           [mod.BLINDS.BOSS_MOTHER] = "The mother",
                           [mod.BLINDS.BOSS_DELIRIUM] = "The delirium",
                           [mod.BLINDS.BOSS_BEAST] = "The beast",
                           HUSH = "Hush",
                           BOSSRUSH = "Bossrush",
                            }

Descriptions.Warning = {Title = "Hand will not score!",
                        [mod.BLINDS.BOSS_MOUTH] = "Can only play [[VALUE1]] this round",
                        [mod.BLINDS.BOSS_EYE] = "[[VALUE1]] was already played",
                        [mod.BLINDS.BOSS_PSYCHIC] = "Hand needs to contain 5 cards",}


Descriptions.BossEffects = {[mod.BLINDS.SMALL] = "No additional effect",
                            [mod.BLINDS.BIG] = "No additional effect",
                            [mod.BLINDS.BOSS] = "No additional effect",
                            [mod.BLINDS.BOSS_ACORN] = "Covers and shuffles all Jokers",
                            [mod.BLINDS.BOSS_ARM] = "Decreases level of hand played",
                            [mod.BLINDS.BOSS_BELL] = "Forces one card to be selected",
                            [mod.BLINDS.BOSS_CLUB] = "All Club cards are debuffed",
                            [mod.BLINDS.BOSS_EYE] = "Cannot repeat hand types",
                            [mod.BLINDS.BOSS_FISH] = "Cards drawn after hand play are covered",
                            [mod.BLINDS.BOSS_FLINT] = "Halfes base chips and mult",
                            [mod.BLINDS.BOSS_GOAD] = "All Spade cards are debuffed",
                            [mod.BLINDS.BOSS_HEAD] = "All Heart cards are debuffed",
                            [mod.BLINDS.BOSS_HEART] = "One random Joker is disabled every hand",
                            [mod.BLINDS.BOSS_HOOK] = "Discard 2 cards on hand play",
                            [mod.BLINDS.BOSS_HOUSE] = "Starting hand is drawn face down",
                            [mod.BLINDS.BOSS_LEAF] = "All cards are debuffed until a Joker is sold",
                            [mod.BLINDS.BOSS_MANACLE] = "-1 hand size",
                            [mod.BLINDS.BOSS_MARK] = "All face cards are drawn face down",
                            [mod.BLINDS.BOSS_MOUTH] = "Can only play one hand type",
                            [mod.BLINDS.BOSS_NEEDLE] = "Only play 1 hand",
                            [mod.BLINDS.BOSS_OX] = "Playing a [[VALUE1]] sets money to 0$",
                            [mod.BLINDS.BOSS_PILLAR] = "Cards played this ante are debuffed",
                            [mod.BLINDS.BOSS_PLANT] = "All face cards are debuffed",
                            [mod.BLINDS.BOSS_PSYCHIC] = "Must play 5 cards",
                            [mod.BLINDS.BOSS_SERPENT] = "After play and discard always draw 3 cards",
                            [mod.BLINDS.BOSS_TOOTH] = "-1$ per card played",
                            [mod.BLINDS.BOSS_VESSEL] = "Very large blind",
                            [mod.BLINDS.BOSS_WALL] = "Very large blind",
                            [mod.BLINDS.BOSS_WATER] = "Start with 0 discards",
                            [mod.BLINDS.BOSS_WHEEL] = "1 in 7 cards are drawn face down",
                            [mod.BLINDS.BOSS_WINDOW] = "All Diamond cards are debuffed",
                            [mod.BLINDS.BOSS_LAMB] = "Getting hit debuffs a random card held",
                            [mod.BLINDS.BOSS_MOTHER] = "Getting hit covers a random card held",
                            [mod.BLINDS.BOSS_DELIRIUM] = "Getting hit changes suit and rank of a random card held",
                            [mod.BLINDS.BOSS_BEAST] = "Getting hit discards 1 random selected card",
                        }
    

------------------------------------------
--------------T_JIMBO HUDs----------------
------------------------------------------

Descriptions.T_Jimbo.LeftHUD = {ShopSlogan = "Improve your run!",
                                ChooseNextBlind = "Choose your next blind",
                                RerollBoss = "Reroll Boss $10",
                                Reward = "Reward:", --try to keep this one short pls
                                Hands = "Hands",
                                Discards = "Discards",
                                Ante = "Ante",
                                Round = "Round",
                                RunInfo = "Run info",
                                Options = "Options",
                                EnemyMaxHP = "Enemies' max HP",
                                HandScore = "Score",
                                SPACE_KeyBind = "[Item]",
                                Q_KeyBind = "[Pill/Card]",
                                E_KeyBind = "[Bomb]",
                            } 


Descriptions.T_Jimbo.RunInfo = {Hands = "Hands", --as in poker hands
                                Deck = "Deck",
                                Blinds = "Blinds",
                                LVL = "lvl.", --again, abbreviation of level
                                Current = "Current",
                                Defeated = "Defeated",
                                Skip = "Skip", --the verb to skip
                                Skipped = "SKIPPED",
                                Or = "or", --as in defeat OR skip
                                DamageRequirement = "Score Requirement:",
                                AtLeast = "Score at least"
                            }

--------------------------------------------
--------------EID EXCLUSIVES----------------
--------------------------------------------

if EID then

----------------------------------------
-------------####JOKERS####-------------
----------------------------------------

--EID:addTrinket(mod.Jokers.JOKER, "\1 {{REG_CMult}}+1.2{{CR}} Damage", "Joker", FileLanguage)

Descriptions.Jimbo.Enhancement = {[mod.Enhancement.NONE]  = "",
                                  [mod.Enhancement.BONUS] = "#{{REG_Bonus}} {{REG_Yellow}}Bonus Card{{CR}}: #{{IND}}{{Tears}} {{REG_CChips}}+0.5{{CR}} Tears when scored",
                                  [mod.Enhancement.MULT]  = "#{{REG_Mult}} {{REG_Yellow}}Mult Card{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}+0.05{{CR}} Damage when scored",
                                  [mod.Enhancement.GOLDEN] = "#{{REG_Gold}} {{REG_Yellow}}Gold Card{{CR}}: #{{IND}}{{Coin}} {{REG_Yellow}}+2${{CR}} when held as a {{REG_Yellow}}blind{{CR}} is cleared",
                                  [mod.Enhancement.GLASS] = "#{{REG_Glass}} {{REG_Yellow}}Glass Card{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}x1.2{{CR}} Damage Mult. when scored ##{{IND}}!!! {{REG_Mint}}[[CHANCE]] in 10 Chance{{CR}} to get destroyed when scored ",
                                  --[mod.Enhancement.LUCKY] = "#{{REG_Lucky}} {{REG_Mint}}Lucky Card{{CR}}: {{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to give {{REG_CMult}}+0.2{{CR}} damage and {{REG_Mint}}[[CHANCE]] in 20 Chance{{CR}} to give {{REG_Yellow}}10 {{Coin}} Pennies",
                                  [mod.Enhancement.LUCKY] = "#{{REG_Lucky}} {{REG_Yellow}}Lucky Card{{CR}}: #{{IND}}{{Damage}} {{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to give {{REG_CMult}}+0.2{{CR}} damage #{{IND}}{{Coin}} {{REG_Mint}}[[CHANCE]] in 20 Chance{{CR}} to give {{REG_Yellow}}10 Pennies",
                                  [mod.Enhancement.STEEL] = "#{{REG_Steel}} {{REG_Yellow}}Steel Card{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}X1.2{{CR}} Damage Mult. when {{REG_Yellow}}held{{CR}} in hand as an hostile room is entered",
                                  [mod.Enhancement.WILD]  = "#{{REG_Wild}} {{REG_Yellow}}Wild Card{{CR}}: #{{IND}} Is considered as every suit",
                                  [mod.Enhancement.STONE] = "#{{REG_Stone}} {{REG_Yellow}}Stone Card{{CR}}: #{{IND}}{{Tears}} {{REG_CChips}}+1.25{{CR}} Tears when scored ##{{IND}}!!! Has no Rank or Suit"
                                  }

Descriptions.Jimbo.Seal = {[mod.Seals.NONE] = "",
                           [mod.Seals.RED] = "#{{REG_Red}} {{REG_Yellow}}Red Seal{{CR}}: #{{IND}}{{REG_Retrigger}} This card's abilities are {{REG_Yellow}}Retriggered{{CR}} once",
                           [mod.Seals.BLUE] = "#{{REG_Blue}} {{REG_Yellow}}Blue Seal{{CR}}:  #{{IND}}{{REG_Planet}} Spawns the card's respective {{ColorCyan}}Planet{{CR}} card when held as a {{REG_Yellow}}Blind{{CR}} is cleared",
                           [mod.Seals.GOLDEN] = "#{{REG_Golden}} {{REG_Yellow}}Golden Seal{{CR}}: #{{IND}}{{Coin}} Spawns a {{REG_Yellow}}Temporary Penny{{CR}} when scored",
                           [mod.Seals.PURPLE] = "#{{REG_Purple}} {{REG_Yellow}}Purple Seal{{CR}}: #{{IND}}{{Card}} Spawns a random {{ColorPink}}Tarot{{CR}} card when {{ColorRed}}Discarded{{CR}}  #{{IND}}!!! {{REG_Mint}}Lower Chance{{CR}} if multiple are discarded {{REG_Yellow}}at once",
                           }

Descriptions.Jimbo.CardEdition = {[mod.Edition.BASE] = "",
                                  [mod.Edition.FOIL] = "#{{REG_Foil}} {{REG_Yellow}}Foil{{CR}}: {{REG_CChips}}+1.25{{CR}} Tears when scored",
                                  [mod.Edition.HOLOGRAPHIC] = "#{{REG_Holo}} {{REG_Yellow}}Holographic{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}+0.25{{CR}} Damage when scored",
                                  [mod.Edition.POLYCROME] = "#{{REG_Poly}} {{REG_Yellow}}Polychrome{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}x1.2{{CR}} Damage Mult. when scored",
                                  [mod.Edition.NEGATIVE] = "#{{REG_Nega}} {{REG_Yellow}}Negative{{CR}}: #{{IND}} scemo chi legge (how tf did u even get this)"
                                }

Descriptions.Jimbo.JokerEdition = {[mod.Edition.NOT_CHOSEN] = "",
                                   [mod.Edition.BASE] = "",
                                   [mod.Edition.FOIL] = "#{{REG_Foil}} {{REG_Yellow}}Foil{{CR}}: #{{IND}}{{Tears}} {{REG_CChips}}+3.5{{CR}} Tears",
                                   [mod.Edition.HOLOGRAPHIC] = "#{{REG_Holo}} {{REG_Yellow}}Holographic{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}+0.5{{CR}} Damage",
                                   [mod.Edition.POLYCROME] = "#{{REG_Poly}} {{REG_Yellow}}Polychrome{{CR}}: #{{IND}}{{Damage}} {{REG_CMult}}X1.25{{CR}} Damage Mult.",
                                   [mod.Edition.NEGATIVE] = "#{{REG_Nega}} {{REG_Yellow}}Negative{{CR}}: #{{IND}} {{REG_Yellow}}+1{{CR}} Joker Slot"
                                   }


Descriptions.Jimbo.Jokers = {}
do
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER] = "{{Damage}} {{REG_CMult}}+0.2{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.BULL] = "{{Tears}} {{REG_CChips}}+0.1{{CR}} Tears per {{Coin}} {{REG_Yellow}}coin{{CR}} held {{ColorGray}}#{{Blank}} {{ColorGray}} (Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Selling this Joker after clearing {{REG_Yellow}}3{{CR}} Blinds duplicates another held Joker [[VALUE2]] #{{Blank}} {{ColorGray}}(Currently [[VALUE1]]) #{{Confusion}} Enemies are confused for 2.5 seconds when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{Damage}} {{REG_CMult}}+0.15{{CR}} Damage per Joker held #{{Damage}} {{REG_CMult}}+0.03{{CR}} Damage per Collectible held #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.MISPRINT] = "{{Damage}} {{REG_CMult}}+0-1{{CR}} random Damage every new room #{{Collectible721}} {{REG_Mint}}[[CHANCE]] in 10 Chance{{CR}} for any item spawned to be {{REG_Yellow}}gliched"
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{Damage}} {{REG_CMult}}X0.75{{CR}} Damage Mult. per {{REG_Yellow}}empty{{CR}} Joker slot #!!! {{REG_Yellow}}Joker Stencil{{CR}} included #{{Damage}} {{REG_CMult}}X0.25{{CR}} Damage Mult. if no {{REG_Yellow}}{{Collectible}}Active item{{CR}} is held#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.STONE_JOKER] = "{{Tears}} {{REG_CChips}}+1.25{{CR}} Tears per {{REG_Yellow}}Stone card{{CR}} in your full deck #{{Tears}} {{REG_CChips}}+0.05{{CR}} Tears per rock in the current room{{ColorGray}}#{{Blank}} (Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.ICECREAM] = "{{Tears}} {{REG_CChips}}+[[VALUE1]]{{CR}} Tears#!!! Loses {{REG_CChips}}-0.25{{CR}} Tears every room completed #Create a trail of slowing creep #{{IND}}{{Freezing}} Enemies killed on top of it turn in Frozen Statues"
Descriptions.Jimbo.Jokers[mod.Jokers.POPCORN] = "{{Damage}} {{REG_CMult}}+[[VALUE1]]{{CR}} Damage #!!! Loses {{REG_CMult}}-0.2{{CR}} Damage every blind beaten #Randomly launch exploding popcorn"
Descriptions.Jimbo.Jokers[mod.Jokers.RAMEN] = "{{Damage}} {{REG_CMult}}X[[VALUE1]]{{CR}}Damage Mult.#!!! Loses {{REG_CMult}}-0.01X{{CR}} Damage Mult. per card discarded"
Descriptions.Jimbo.Jokers[mod.Jokers.ROCKET] = "{{Coin}} {{REG_Yellow}}+[[VALUE1]] {{Coin}} Coins{{CR}} on Blind clear #{{IND}}{{Coin}} Coin payout increases by {{REG_Yellow}}2{{CR}} when a boss blind is defeated #{{Collectible583}} Grants the Rocket in Jar effect"
Descriptions.Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{Tears}} {{REG_Yellow}}Odd{{CR}} numbered cards give {{REG_CChips}}+0.31{{CR}} Tears when scored#{{Tears}} {{REG_CChips}}+0.15{{CR}} Tears per Collectible held if the total amount is odd"
Descriptions.Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{Damage}} {{REG_Yellow}}Even{{CR}} numbered cards give {{REG_CMult}}+0.04{{CR}} Damage when scored #{{Damage}} {{REG_CMult}}+0.02{{CR}} Damage per Collectible held if the total amount is even"
Descriptions.Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{Card}} {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to spawn a random {{ColorPink}}Tarot{{CR}} card when opening a {{REG_Yellow}}Booster Pack{{CR}}#{{Collectible431}} Gives the Multidimensional Baby effect"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "{{Damage}}{{REG_CMult}}+0.04{{CR}} Damage per room completed#{{Damage}}{{REG_CMult}}-0.16{{CR}}Damage on every hand discard #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{Damage}}{{REG_CMult}}+0.15{{CR}} Damage per {{REG_Yellow}}Booster Pack{{CR}} skipped #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.VAGABOND] = "Spawns a random {{Card}}{{ColorPink}}Tarot{{CR}} card when clearing a room with {{REG_Yellow}}2 {{Coin}} Coins or less{{CR}} #{{Beggar}} {{REG_Mint}}[[CHANCE]] in 10 Chance{{CR}} to spawn a random {{REG_Yellow}}Beggar{{CR}} when clearing a room"
Descriptions.Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "{{REG_Joker}} Spawns a random {{REG_CChips}}common{{CR}} Joker on Blind Clear"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "{{Coin}} {{REG_Yellow}}+5 {{Coin}} Coins{{CR}} on Blind clear #{{Collectible202}} Enemies touched become {{REG_Yellow}}golden{{CR}} for a short time"
Descriptions.Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{Damage}} {{REG_CMult}}+0.04{{CR}} Damage per {{Card}}{{ColorPink}}Tarot{{CR}} card used throughout the run #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage) #{{Collectible451}} Grants the Tarot Cloth effect"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "{{REG_Retrigger}} Copies the effect of the Joker to its right"
Descriptions.Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "{{REG_Retrigger}} Copies the effect of the leftmost held Joker"
Descriptions.Jimbo.Jokers[mod.Jokers.MADNESS] = "Destroys another random Joker and gains {{REG_CMult}}X0.1{{CR}} Damage Mult. every {{REG_Yellow}}Small and Big Blind{{CR}} cleared#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.MR_BONES] = "Revive at Full Hp if only {{REG_Yellow}}1{{CR}} of the floor's blinds is uncleared #!!! Unavailable blinds count as cleared #{{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to activate {{Collectible545}} Book of the Dead on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{Damage}} {{REG_Club}} {{REG_CChips}}Club{{CR}} cards give {{REG_CMult}}+0.07{{CR}} Damage when scored #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage) #{{Bomb}} {{ColorClub}}Club{{CR}} cards explosions are more frequent, bigger and deal more damage"
Descriptions.Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{Tears}} {{REG_Spade}} {{REG_CSpade}}Spade{{CR}} cards give {{REG_CChips}}+0.5{{CR}} Tears when scored #{{Blank}} {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears) #{{Confusion}} {{REG_CSpade}}Spade{{CR}} cards have a {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to slow and confuse"
Descriptions.Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{Damage}} {{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards have a {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to give {{REG_CMult}}X1.05{{CR}} Damage Mult. when scored #{{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards leave a bigger and stronger creep pool #{{Charm}} {{REG_CMult}}Heart{{CR}} cards have a {{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to charm"
Descriptions.Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{Coin}} {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}} cards have a {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to spawn a {{Coin} {{REG_Yellow}}Temporary Penny{{CR}} when scored #{{Collectible506}} {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}} cards also have the {{REG_Yellow}}Backstabber{{CR}} effect"

Descriptions.Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{Damage}} {{REG_CMult}}+0.75{{CR}} Damage #{{Warning}} {{REG_Mint}}[[CHANCE]] in 6 Chance{{CR}} of getting destroyed on Blind clear"
Descriptions.Jimbo.Jokers[mod.Jokers.CAVENDISH] = "{{Damage}} {{REG_CMult}}X1.5{{CR}} Damage Mult. #{{Warning}} {{REG_Mint}}[[CHANCE]] in 1000 Chance{{CR}} of getting destroyed on Blind clear"
Descriptions.Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "{{Damage}} {{REG_CMult}}+0.02{{CR}} Damage per {{RestockMachine}} Restock machine activated #{{Collectible105}} {{Damage}} {{REG_CMult}}+0.02{{CR}} Damage per {{REG_Yellow}}Dice Item{{CR}} used #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Destroys the Joker to its right and gains {{REG_CMult}}+0.08 x its sell value{{CR}} Damage on Blind clear #{{Blank}} {{colorGray}}(Currently {{ColorMukt}}+[[VALUE1]]{{ColorGray}} Damage) #{{Collectible705}} Activates Dark Arts for 2.5 seconds when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "{{Coin}} {{REG_Yellow}}+1 Coin{{CR}} per {{REG_Yellow}}9{{CR}} in your Full Deck on Blind clear#{{Blank}} {{ColorGray}}(Currently  {{REG_Yellow}}[[VALUE1]]{{ColorGray}} Coins){{CR}} #{{Seraphim}} Gain Flight"
Descriptions.Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "{{Damage}} {{REG_CMult}}+0.07 x the total sell value of held Jokers{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "{{Card}} Spawns a random {{ColorPink}}Tarot{{CR}} card on Blind clear #{{Card}} {{REG_Mint}}[[CHANCE]] in 20 Chance{{CR}} for any pickup to be replaced with a random {{ColorPink}}Tarot{{CR}} card"
Descriptions.Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{Damage}} {{REG_CMult}}X2{{CR}} Damage Mult. once every 6 rooms cleared #{{Blank}} {{ColorGray}} [[VALUE1]]"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "{{Damage}} Cards scored give {{REG_CMult}}+0.01{{CR}} Damage per time a card with the same {{REG_Yellow}}Rank{{CR}} got played in the current room"
Descriptions.Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "{{Coin}} {{REG_Yellow}}+1 Coin{{CR}} per {{Heart}}{{REG_CMult}}Heart{{CR}}when clearing a room at {{REG_Yellow}}full health{{CR}} #{{Timer}} Both the {{BossRoom}} Bossrush and {{Hush}} Hush door open regardless of the ingame timer"
Descriptions.Jimbo.Jokers[mod.Jokers.EGG] = "{{Coin}} The sell value of this Joker increases by {{REG_Yellow}}3 Coins{{CR}} on blind clear #Gain a tears-blocking familiar"
Descriptions.Jimbo.Jokers[mod.Jokers.DNA] = "If the {{REG_Yellow}}First{{CR}} card played of a {{REG_Yellow}}Blind{{CR}} hits an enemy, add a copy of that card to the deck #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}}) #{{Collectible658}} Spawns a Mini-Isaac on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = " {{REG_Heart}} {{REG_CMult}}Hearts{{CR}} and {{REG_Diamond}} {{REG_Yellow}}Diamonds{{CR}} count as the same suit # {{REG_Spade}} {{REG_CSpade}}Spades{{CR}} and {{REG_Club}} {{ColorBlue}}Clubs{{CR}} count as the same suit"

Descriptions.Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{Tears}} {{REG_CChips}}+5{{CR}} Tears if a {{REG_Yellow}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{Tears}} {{REG_CChips}}+10{{CR}} Tears if a {{REG_Yellow}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{Tears}} {{REG_CChips}}+7{{CR}} Tears if a {{REG_Yellow}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{Tears}} {{REG_CChips}}+15{{CR}} Tears if a {{REG_Yellow}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{Tears}} {{REG_CChips}}+12{{CR}} Tears if a {{REG_Yellow}}Flush{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{Damage}} {{REG_CMult}}+1{{CR}} Damage if a {{REG_Yellow}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{Damage}} {{REG_CMult}}+2{{CR}} Damage if a {{REG_Yellow}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{Damage}} {{REG_CMult}}+1.75{{CR}} Damage if a {{REG_Yellow}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{Damage}} {{REG_CMult}}+3{{CR}} Damage if a {{REG_Yellow}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{Damage}} {{REG_CMult}}+2.25{{CR}} Damage if a {{REG_Yellow}}Flush{{CR}} is held when entering a room"

Descriptions.Jimbo.Jokers[mod.Jokers.MIME] = "{{REG_Retrigger}} {{REG_Yellow}}Retriggers{{CR}} all {{REG_Yellow}}held in hand{{CR}} effects #{{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to copy the effect of an Active Item used"
Descriptions.Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{REG_Yellow}}Flushes{{CR}} and {{REG_Yellow}}Straights{{CR}} only require 4 cards #Every fifth {{REG_Yellow}}non-boss{{CR}} enemy spawned gets killed immediantly"
Descriptions.Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{Damage}} {{REG_CMult}}Heart{{CR}} cards give {{REG_CMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{Damage}} {{REG_Yellow}}Diamond{{CR}} cards give {{REG_CMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{Damage}} {{REG_CSpade}}Spade{{CR}} cards give {{REG_CMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{Damage}} {{REG_CChips}}Club{{CR}} cards give {{REG_CMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{Heart}} {{REG_Yellow}}+2{{CR}} Hp #{{REG_HSize}} {{REG_CMult}}-2{{CR}} Hand size #{{Heart}} Heal one extra heart on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{Damage}} {{REG_CMult}}+1.5{{CR}} Damage when {{REG_Yellow}}5 or less{{CR}} card have been played in the current room #{{REG_CMult}}+1{{CR}} Damage when having {{REG_Yellow}}3 or less{{CR}} cards in hand #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Allows to go in {{REG_Yellow}}debt{{CR}} #{{Shop}} Items on sale can only be bought with a maximum of {{REG_CMult}}-20${{CR}} debt #!!! {{REG_Yellow}}Interest{{CR}} and {{REG_Yellow}}coin held-based{{CR}} effects cannot trigger while in debt"

Descriptions.Jimbo.Jokers[mod.Jokers.BANNER] = "{{Tears}} {{REG_CChips}}+1.5{{CR}} Tears per {{Heart}} {{REG_Yellow}}full heart{{CR}}#{{Blank}} {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears) #A banner spawns as an hostile room is entered #{{IND}}{{Tears}} Standing close to the banner gives {{REG_CChips}}+3{{CR}} Tears"
Descriptions.Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{Damage}} {{REG_CMult}}+1.5{{CR}} Damage while having only {{REG_Yellow}}1{{CR}} {{Heart}} full Heart#{{Heart}} Spawns hearts instead of healing when clearing a room #{{Collectible335}} Grants a {{REG_Yellow}}repelling aura{{CR}} while active"
Descriptions.Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "{{REG_Stone}} Adds a {{REG_Yellow}}Stone card{{CR}} to the deck on blind clear # {{REG_Mint}}[[CHANCE]] in 100 Chance{{CR}} for rocks to be replaced with {{REG_Yellow}}Tinted Rocks"
Descriptions.Jimbo.Jokers[mod.Jokers._8_BALL] = "{{Card}} {{REG_Yellow}}8s{{CR}} have a {{REG_Mint}}[[CHANCE]] in 8 Chance{{CR}} to spawn a random {{Card}} {{ColorPink}}Tarot{{CR}} card when scored #{{Shotspeed}} +0.16 Shot Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.DUSK] = "{{REG_Retrigger}} {{REG_Yellow}}Retriggers the {{REG_Yellow}}last 10{{CR}} scoring cards #{{Blank}} {{ColorGray}}(Currently [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "{{Damage}} {{REG_CMult}}+0.05{{CR}} Damage {{REG_Yellow}}X the Rank{{CR}} of the lowest card {{REG_Yellow}}held{{CR}} #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{Collectible376}} All {{Shop}} Shops and {{Treasure}} Treasure rooms have an additional Restock Machine"
Descriptions.Jimbo.Jokers[mod.Jokers.FIBONACCI] = "{{Damage}} {{REG_Yellow}}Aces{{CR}}, {{REG_Yellow}}2s{{CR}}, {{REG_Yellow}}3s{{CR}}, {{REG_Yellow}}5s{{CR}} and {{REG_Yellow}}8s{{CR}} give {{REG_CMult}}+0.08{{CR}} Damage when scored #{{Damage}} {{REG_CMult}}+0.05{{CR}} Damage per {{Collectible}} collectible held if the total amount is a {{REG_Yellow}}Fibonacci number#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "{{Damage}} This gains {{REG_CMult}}X0.15{{CR}} Damage Mult. per {{ColorSilver}}Steel card{{CR}} in your deck#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{Tears}} {{REG_Face}} {{REG_Yellow}}Face{{CR}} cards give {{REG_CChips}}+0.3{{CR}} Tears when scored #{{Tears}} Killing a {{REG_Yellow}}Champion{{CR}} gives {{REG_CChips}}+1{{CR}} Tears"
Descriptions.Jimbo.Jokers[mod.Jokers.HACK] = "{{REG_Yellow}}Retriggers{{CR}} played {{REG_Yellow}}2s{{CR}}, {{REG_Yellow}}3s{{CR}}, {{REG_Yellow}}4s{{CR}} and {{REG_Yellow}}5s{{CR}} #\1 Gain an additional copy of every {{Quality0}} and {{Quality1}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Every card counts as a {{REG_Yellow}}Face{{CR}} card #{{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} for any non-boss enemy to become a {{REG_Yellow}}Champion"

Descriptions.Jimbo.Jokers[mod.Jokers.SCHOLAR] = "\1 {{REG_Yellow}}Aces{{CR}} give {{REG_CMult}}+0.04{{CR}} Damage and {{REG_CChips}}+0.2{{CR}} Tears when scored #{{Luck}} {{REG_Mint}}+5{{CR}} Luck"
Descriptions.Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{Coin}} {{REG_Yellow}}Face{{CR}} cards have a {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to spawn {{REG_Yellow}}2 temporary {{Coin}} Pennies{{CR}} when scored #Gain the {{Collectible602}} Member Card effect"
Descriptions.Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{Damage}} {{REG_CMult}}+0.01{{CR}} Damage per consecutive {{REG_Yellow}}non-Face{{CR}} card played #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "\1 {{REG_Mint}}[[CHANCE]] in 20 Chance{{CR}} to upgrade the {{REG_Yellow}}scored card Rank{{CR}}'s level #Gains an additional {{REG_Mint}}[[CHANCE]] in 20 Chance{{CR}} per {{REG_Yellow}}Star-related{{CR}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.BURGLAR] = "!!! Sets your Hp to {{ColorRed}}2{{CR}} Hearts #\1 Cards can be scored until the deck gets {{REG_Yellow}}reshuffled"
Descriptions.Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{Damage}} {{REG_CMult}}X2{{CR}} Damage Mult. if all cards held are {{REG_CSpade}}Spades{{CR}} or {{REG_CChips}}Clubs"
Descriptions.Jimbo.Jokers[mod.Jokers.RUNNER] = "{{Tears}} Gains {{REG_CChips}}+1.5{{CR}} Tears when entering an {{REG_Yellow}}unexplored{{CR}} room while holding a {{REG_Yellow}}Straight{{CR}} #{{Tears}} Gives {{REG_CChips}}+Tears{{CR}} equal to double your {{Speed}} Speed stat#{{Blank}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Chips) #{{Speed}} +0.1 Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.SPLASH] = "{{REG_Retrigger}} Scores all cards in hand upon entering an {{REG_Yellow}}hostile{{CR}} room"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{Tears}} {{REG_CChips}}+0.15{{CR}} Tears per remaining card in your deck#{{Blank}} {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "{{REG_Spectral}} If the {{REG_Yellow}}First{{CR}} card played in a {{REG_Yellow}}Blind{{CR}} is a {{REG_Yellow}}6{{CR}} and hits an enemy, destroy it and spawn a {{ColorBlue}}Spectral Pack{{CR}} #{{Collectible3}} 1 every 4 tears shot gains homing"
Descriptions.Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "{{Damage}} Gains {{REG_CMult}}+0.05X{{CR}} Damage Mult. every time a {{ColorCyan}}Planet Card{{CR}} is used while holding it #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.) #{{Collectible}} {{REG_Yellow}}Star-related{{CR}} items held give {{REG_CMult}}X1.1{{CR}} Damage Mult."
Descriptions.Jimbo.Jokers[mod.Jokers.HIKER] = "{{Coin}} Cards gain a {{REG_Yellow}}permanent{{CR}} {{REG_CMult}}+0.02{{CR}} Tears upgrade when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.FACELESS] = "{{Coin}} {{REG_Yellow}}+3 Coins{{CR}} when discarding at least {{REG_Yellow}}2{{CR}} {{REG_Face}} Face cards at once #If only {{REG_Yellow}}champion{{CR}} enemies are left in the room, they are {{REG_Yellow}}killed instantly{{CR}} #{{IND}}{{REG_Face}} Enemies killed spawn a {{REG_Yellow}}vanishing penny"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "{{Card}} Entering an hostile {{REG_Yellow}}unexplored{{CR}} room while holding a {{REG_Yellow}}Straight{{CR}} and an {{REG_Yellow}}Ace{{CR}} spawns an {{ColorPink}}Arcana Pack{{CR}} #{{Collectible128}} +2 Forever Alone flies"
--Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{REG_Yellow}}[[VALUE1]]s{{CR}} spawn a {{REG_Yellow}}temporary {{Coin}} penny{{R}} when scored #!!! {{ColorGray}}(Rank changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{Coin}} Killing enemies in the {{REG_Yellow}}order{{CR}} dictated by the {{Coin}} above them awards with a penny"


Descriptions.Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{Damage}} {{REG_CMult}}X1.1{{CR}} Damage Mult. when playing 2 cards with the same rank {{REG_Yellow}}consecutevely{{CR}} #{{IND}}!!! {{REG_Yellow}}Stone cards{{CR}} have no effect #{{Collectible665}} Allows to see the content of {{REG_Yellow}}chests{{CR}} and {{REG_Yellow}}sacks"
Descriptions.Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "{{Tears}} {{REG_CChips}}+4{{CR}} Tears to every fourth card shot #{{Pill}} Gains {{REG_CChips}}+0.4{{CR}} Tears every time a {{REG_Yellow}}Retro Vision{{CR}} pill is used #{{Blank}} {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.SEANCE] = "Spawns a {{REG_Yellow}}Spectral Pack{{CR}} if a {{REG_Yellow}}Straight Flush{{CR}} is held when entering an hostile {{REG_Yellow}}unexplored{{CR}} room #{{Collectible727}} {{REG_Mint}}[[CHANCE]] in 6 Chance{{CR}} to spawn a {{REG_Yellow}}Hungry Soul{{CR}} when killing an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.VAMPIRE] = "{{Damage}} When an {{REG_Yellow}}Enhanced{{CR}} card is Played, this gains {{REG_CMult}}X0.02{{CR}} Damage Mult. and removes the {{REG_Yellow}}Enhancement{{CR}} #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Allows {{REG_Yellow}}Straights{{CR}} to be made with gaps of {{REG_Yellow}}1 Rank{{CR}} #{{Collectible84}} Creates a {{REG_Yellow}}Crawl space{{CR}} in a random room every floor #{{Collectible84}} Opens all {{REG_Yellow}}Secret Rooms"
Descriptions.Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "{{Damage}} Gains {{REG_CMult}}X0.1{{CR}} Damage Mult. when a card gets {{REG_Yellow}}Added{{CR}} to the deck #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"

Descriptions.Jimbo.Jokers[mod.Jokers.BARON] = "{{Damage}} {{REG_Yellow}}Kings{{CR}} held in hand give {{REG_CMult}}X1.2{{CR}} Damage Mult. when entering an hostile room #{{Quality4}} Gives {{REG_CMult}}X1.25{{CR}} Damage Mult. per Q4 item held#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.OBELISK] = "{{Damage}} Gains {{REG_CMult}}X0.1{{CR}} Damage Mult. per {{REG_Yellow}}consecutive{{CR}} card played with a different {{REG_Yellow}}Suit{{CR}} from the last #{{IND}}!!! Reset every room clear #{{IND}}!!! {{REG_Yellow}}Stone cards{{CR}} have no effect #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.MIDAS] = "{{Coin}}  {{REG_Face}} {{REG_Yellow}}Face{{CR}} cards {{REG_Yellow}}Played{{CR}} become {{REG_Yellow}}Golden{{CR}}#{{REG_Yellow}}Champion{{CR}} enemies are breifly turned into golden statues when spawning"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{Shop}} {{REG_Yellow}}Selling{{CR}} this Joker causes a {{Collectible483}} Mama Mega! explosion and {{Weakness}} weakens all {{REG_Yellow}}Bosses{{CR}} in the room"
Descriptions.Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "{{Damage}} The first {{REG_Face}} {{REG_Yellow}}Face{{CR}} card {{REG_Yellow}}Played{{CR}} every room gives {{REG_CMult}}X1.25{{CR}} Damage Mult. when scored #{{Damage}} {{REG_CMult}}X1.2{{CR}} Damage Mult. if the first enemy killed in a room is a {{REG_Yellow}}Champion{{CR}} #{{COllectible327}} Can open {{REG_Yellow}}A Strange Door"
Descriptions.Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "{{Coin}} Every Joker held gains {{REG_Yellow}}+1{{CR}} selling value on blind clear #{{Shop}} Prices are reduced by {{REG_Yellow}}1 Coin"
Descriptions.Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{REG_HSize}} {{REG_Yellow}}+[[VALUE1]]{{CR}} Hand Size #{{IND}}!!! Loses {{ColorRed}}-1{{CR}} Hand Size on blind clear #{{Collectible594}} Grants the Jupiter effect"
Descriptions.Jimbo.Jokers[mod.Jokers.EROSION] = "{{Damage}} Gains {{REG_CMult}}+0.15{{CR}} Damage when a card gets {{REG_Yellow}}Destroyed{{CR}} #{{Damage}} Gains {{REG_CMult}}+0.05{{CR}} Damage per {{REG_Yellow}}Tinted{{CR}} Rock {{REG_Yellow}}Destroyed{{CR}} #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "{{Coin}}  {{REG_Face}} {{REG_Yellow}}Face{{CR}} cards held in hand have a {{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to spawn a penny on room clear #{{Coin}} When killing an enemy, other {{REG_Yellow}}Champions{{CR}} create a {{REG_Yellow}}Vanishong penny"

Descriptions.Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "{{Coin}} {{REG_Yellow}}+2 Coins{{CR}} per {{REG_Yellow}}[[VALUE1]]{{CR}} discarded #{{Blank}} {{ColorGray}}(Rank changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "{{Coin}} {{colorYellow}}Interests{{CR}} earned are {{REG_Yellow}}Doubled"
Descriptions.Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{REG_HSize}} {{REG_Yellow}}+1{{CR}} Hand Size #\1 {{REG_Yellow}}+1{{CR}} consumable slot"
Descriptions.Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{Heart}} {{REG_Yellow}}+1{{CR}} Health up #{{Heart}} Heal one extra heart on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "{{Damage}} Gains {{REG_CMult}}X0.02{{CR}} Damage Mult. when a {{REG_Yellow}}Lucky Card{{CR}} triggers {{REG_Mint}}Succesfully{{CR}} or when a {{Slotmachine}} Slot pays out #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{Damage}} {{REG_CMult}}X1.25{{CR}} Damage Mult. per {{REG_Mint}}Uncommon{{CR}} Joker held #{{Damage}} Gives {{REG_CMult}}X1.1{{CR}} Damage Mult. per {{Quality2}} Item held #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{Shop}} {{REG_Yellow}}Selling{{CR}} this Joker activates the {{Collectible347}} Diplopia effect"

Descriptions.Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "{{Shop}} {{REG_Yellow}}Selling{{CR}} this Joker, all cards in hand are {{REG_Yellow}}Destroyed{{CR}} and give {{REG_Yellow}}+2 {{Coin}} Coins"
Descriptions.Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "{{Damage}} Gains {{REG_CMult}}+0.25{{CR}} Damage if a {{REG_Yellow}}Two-pair{{CR}} is held when entering an hostile room #{{Damage}} {{REG_CMult}}+0.1{{CR}} Damage per active {{REG_Yellow}}costume{{CR}} #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "#{{Damage}} [[VALUE1]]{{CR}} cards give {{REG_CMult}}X1.05{{CR}} Damage Mult. when scored #{{ColorGray}}(Suit changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "\1 {{REG_Yellow}}10s{{CR}} and {{REG_Yellow}}4s{{CR}} give {{REG_CChips}}+0.1{{CR}} Tears and {{REG_CMult}}+0.04{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.SELTZER] = "{{REG_Rretrigger}} {{REG_Yellow}}Retriggers{{CR}} the next {{REG_Yellow}}[[VALUE1]]{{CR}} played cards"
Descriptions.Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{Damage}} {{REG_Face}} {{REG_Yellow}}Face{{CR}} cards give {{REG_CMult}}+0.05{{CR}} Damage when scored #{{Damage}} Killing a {{REG_Yellow}}Champion{{CR}} gives {{REG_CMult}}+0.15{{CR}} Damage #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "{{Damage}} Gains {{REG_CMult}}X0.2{{CR}} Damage Mult. per sold Joker this {{REG_Yellow}}Floor{{CR}} #!!! Jokers can be picked up at full inventory and are sold automatically without giving any coins #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.CASTLE] = "{{Tears}} Gains {{REG_CChips}}+0.04{{CR}} Tears per {{REG_Yellow}}[[VALUE1]]{{CR}} discarded #{{ColorGray}}(Value changes every room) #{{Blank}} {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE2]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{REG_Gold}} {{REG_Yellow}}Golden cards{{CR}} give {{REG_Yellow}}+1 {{Coin}} Coin{{CR}} when scored #{{Collectible202}} Every pickup has a {{REG_Mint}}[[CHANCE]] in 25 Chance{{CR}} to become its {{REG_Yellow}}Golden{{CR}} variant"
Descriptions.Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{Damage}} The {{REG_Yellow}}Last 5{{CR}} scoring cards give {{REG_CMult}}X1.1{{CR}} Damage Mult. when scored #{{Damage}} {{REG_CMult}}X1.5{{CR}} Damage Mult. during any {{Boss}} bossfight #{{Blank}} {{ColorGray}}(Currently [[VALUE1]] {{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = '{{REG_Retrigger}} {{REG_Yellow}}Retriggers{{CR}} played {{REG_Face}} {{REG_Yellow}}Face{{CR}} cards #\1  {{REG_Yellow}}Retriggers{{CR}} "on champion kill" Joker effects'
Descriptions.Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{REG_HSize}} {{REG_Yellow}}+2{{CR}} Hand Size #{{REG_Hand}} {{ColorBlue}}-5{{CR}} scoring cards"
Descriptions.Jimbo.Jokers[mod.Jokers.THROWBACK] = "{{Damage}} {{REG_CMult}}X0.1{{CR}} Damage Mult. per {{REG_Yellow}}Blind{{CR}} skipped this run #{{Damage}} {{REG_CMult}}X0.02{{CR}} Damage Mult. per {{REG_Yellow}}Special room{{CR}} skipped this run #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "{{REG_Red}} Adds a card with a {{REG_Yellow}}Random Seal{{CR}} to the deck on blind clear #{{Collectible75}} Grants the PHD effect"
Descriptions.Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{REG_Retrigger}} {{REG_Yellow}}Retriggers{{CR}} 3 times the {{REG_Yellow}}first{{CR}} played card in a room #{{Card}} The {{REG_Yellow}}first{{CR}} card used every floor spawns a copy of itself"
Descriptions.Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "{{Damage}} Gains {{REG_CMult}}X0.2{{CR}} Damage Mult. per destroyed {{REG_Yellow}}Glass Card{{CR}} #{{IND}}!!! {{REG_Mint}}Doubles{{CR}} the Glass card's breaking Chance #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{REG_Yellow}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{REG_Yellow}}Items{{CR}}, {{REG_Yellow}}Joker{{CR}}, {{ColorPink}}Tarot{{CR}}, {{ColorCyan}}Planet{{CR}} and {{ColorBlue}}Spectral{{CR}} cards may appear multiple times"
Descriptions.Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{Damage}} {{REG_CMult}}X2{{CR}} Damage Mult. if every {{REG_Yellow}}Suit{{CR}} is held in hand when entering an hostile room #{{Charm}} Spawns 3 charming flowers in hostile rooms"
Descriptions.Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "{{Tears}} Gains {{REG_CChips}}+0.04{{CR}} Tears when a {{REG_Yellow}}2{{CR}} is scored #\1 Reduces Isaac's size and hitbox #{{Blank}} {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.OOPS_6] = "{{Luck}} Every {{REG_Mint}}Listed Chance{{CR}} is Doubled #{{Collectible46}} Grants the Lucky foot effect"
Descriptions.Jimbo.Jokers[mod.Jokers.IDOL] = "{{Damage}} [[VALUE1]]{{CR}} give {{REG_CMult}}X1.1{{CR}} Damage Mult. when scored #{{ColorGray}} (Card changes every room) #{{Damage}} {{REG_CMult}}X2{{CR}} Damage Mult. per {{REG_Yellow}} {{Collectible[[VALUE2]]}} [[VALUE3]]{{CR}} held"
Descriptions.Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{Damage}} {{REG_CMult}}X1.2{{CR}} Damage Mult. if both a {{ColorClub}}Club{{CR}} and a {{REG_Yellow}}Not-club{{CR}} card are held in hand when entering an hostile room#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}[[VALUE1]]{{CR}})"
Descriptions.Jimbo.Jokers[mod.Jokers.MATADOR] = "{{Coin}} {{REG_Yellow}}+4 Coins{{CR}} when taking damage from a {{REG_Yellow}}Boss"
Descriptions.Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "{{Damage}} Gains {{REG_CMult}}X0.2{{CR}} Damage Mult. per {{REG_Yellow}}Jack{{CR}} discarded #{{IND}}!!! {{REG_Yellow}}(Resets every Room) #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.DUO] = "{{Damage}} {{REG_CMult}}X1.25{{CR}} Damage Mult. if a {{REG_Yellow}}Pair{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIO] = "{{Damage}} {{REG_CMult}}X1.5{{CR}} Damage Mult. if a {{REG_Yellow}}Three of a Kind{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.FAMILY] = "{{Damage}} {{REG_CMult}}X2{{CR}} Damage Mult. if a {{REG_Yellow}}Four of a Kind{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.ORDER] = "{{Damage}} {{REG_CMult}}X2.5{{CR}} Damage Mult. if a {{REG_Yellow}}Straight{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBE] = "{{Damage}} {{REG_CMult}}X1.55{{CR}} Damage Mult. if a {{REG_Yellow}}Flush{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{Tears}} {{REG_CMult}}+12.5{{CR}} Tears #{{REG_HSize}} {{REG_CMult}}-2{{CR}} Hand Size"
Descriptions.Jimbo.Jokers[mod.Jokers.SATELLITE] = "{{Coin}} Gain {{REG_Yellow}}1 Coin{{CR}} per unique {{ColorCyan}}Planet{{CR}} card used this run on blind clear #(Currently {{REG_Yellow}}[[VALUE1]]{{ColorGray}} Coins) #A light beam is shot per unique {{ColorCyan}}Planet{{CR}} card used when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{Damage}} {{REG_Yellow}}Queens{{CR}} held in hand give {{REG_CMult}}+0.7{{CR}} Damage when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{Damage}} {{REG_CMult}}X1.5{{CR}} Damage Mult. if there are at least {{REG_Yellow}}18 Enhanced cards{{CR}} in your full deck #Having either the {{Adult}} Adult, {{Mom}} Mom or {{Bob}} Bob transformation also activates the effect #{{Blank}} {{ColorGray}}(Currently [[VALUE1]])"
Descriptions.Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "{{Shop}} {{ColorCyan}}Planet{{CR}} cards,{{ColorCyan}}Celestial Packs{{CR}} and {{REG_Yellow}}Star-themed{{CR}} items are free #{{Planetarium}} {{REG_Yellow}}+20%{{CR}} planetarium Chance {{ColorGray}}(halves every time one is visited) #{{Planetarium}} Planetariums can spawns on any normal floor"
Descriptions.Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "\1 Upgrades the {{ColorCyan}}level{{CR}} of {{REG_Yellow}}discarded{{CR}} if they hit an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{Damage}} {{REG_CMult}}+0.05{{CR}} Damage per {{REG_Yellow}}5 {{Coin}} Coins{{CR}} held {{ColorGray}}#{{Blank}} (Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Damage) #Gain {{REG_Yellow}}Collision Damage{{CR}} equal to the amount of coins held"

Descriptions.Jimbo.Jokers[mod.Jokers.CANIO] = "{{Damage}} Gains {{REG_CMult}}X0.25{{CR}} Damage Mult. when a {{REG_Face}} {{REG_Yellow}}Face{{CR}} card is {{REG_Yellow}}Destroyed{{CR}}#{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{CR}} Damage Mult.) #{{DeathMark}} {{REG_Yellow}}Champion{{CR}} enemies are immediantly killed"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{Damage}} {{REG_Yellow}}Kings{{CR}} and {{REG_Yellow}}Queens{{CR}} give {{REG_CMult}}X1.2{{CR}} Damage Mult. when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.YORICK] = "{{Damage}} Gains {{REG_CMult}}X0.25{{CR}} Damage Mult. every {{REG_Yellow}}23{{CR}} cards discarded #{{Blank}} {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHICOT] = "{{Weakness}} Every {{REG_Yellow}}Boss{{CR}} is permanently weakened #Disables every curse"
Descriptions.Jimbo.Jokers[mod.Jokers.PERKEO] = "{{Card}} Spawns a duplicate of every {{REG_Yellow}}Consumable{{CR}} held on {{REG_Yellow}}Blind{{CR}} clear"

Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "After being scored, cards are {{REG_Yellow}}randomly{{CR}} rerolled #!!! {{ColorGray}}(The new card generated depends on the starting one)"

end

Descriptions.JokerSynergies = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE] = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_PHD] = "Cards added also have a guaranteed random {{REG_Yellow}}Edition"
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_FALSE_PHD] = "Cards added also have a guaranteed random {{REG_Yellow}}Enhancement"

Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_SMALL_ROCK] = "Cards added also have a guaranteed random {{REG_Yellow}}Seal"
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = "Cards added also have a guaranteed random {{REG_Yellow}}Edition"

Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY] = {}
Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY][CollectibleType.COLLECTIBLE_CHAOS] = "Cards generated are guaranteed to have an {{REG_Yellow}}Enhancement{{CR}}, {{REG_Yellow}}Seal{{CR}} or {{REG_Yellow}}Edition{{CR}} if the starting card had one"

Descriptions.JokerSynergies[mod.Jokers._8_BALL] = {}
Descriptions.JokerSynergies[mod.Jokers._8_BALL][CollectibleType.COLLECTIBLE_MAGIC_8_BALL] = "{{REG_Mint}}Trigger Chance{{CR}} doubled!"

Descriptions.JokerSynergies[mod.Jokers.MISPRINT] = {}
Descriptions.JokerSynergies[mod.Jokers.MISPRINT][CollectibleType.COLLECTIBLE_TMTRAINER] = "Damage given ranges from {{REG_CMult}}-0.5{{CR}} to {{CR}} {{REG_CMult}}+2.5"

Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD] = {}
Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD][CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "{{REG_Spade}} {{REG_CSpade}}Spade{{CR}}'s charm effect becomes guaranteed"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER] = "{{Coin}} Also gives 2 {{REG_Yellow}}Golden pennies{{CR}} when sold this way"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_TICKET] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_TICKET][CollectibleType.COLLECTIBLE_SMELTER] = Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER]

Descriptions.JokerSynergies[mod.Jokers.CREDIT_CARD] = {}
Descriptions.JokerSynergies[mod.Jokers.CREDIT_CARD][CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "{{Coin}} Being in debt counts as having half of the maximum amount of coins #{{Colorgray}} (it's not a bug, but a feature)" --ye ok it's actually a bug

Descriptions.JokerSynergies[mod.Jokers.SOCK_BUSKIN] = {}
Descriptions.JokerSynergies[mod.Jokers.SOCK_BUSKIN][mod.Collectibles.TRAGICOMEDY] = "Both masks are always active"


--inverts the table to make collectible synergy descriptions lookup faster
Descriptions.ItemJokerSynergies = {}
for Joker,JokerSynergies in pairs(Descriptions.JokerSynergies) do
    
    for Item, SynString in pairs(JokerSynergies) do
        
        Descriptions.ItemJokerSynergies[Item] = Descriptions.ItemJokerSynergies[Item] or {}
        Descriptions.ItemJokerSynergies[Item][Joker] = SynString
    end
end


Descriptions.JimboSynergies = {}
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE] = "#{{REG_Jimbo}} When hitting an enemy, cards shoot 1 blood laser that deals 50% the card's damage in a random direction #{{IND}}{{REG_Spade}} {{REG_CSpade}}Spade{{CR}} cards shoot an extra laser #{{REG_Spade}} Cards held in hand become {{REG_CSpade}}Spade{{CR}} cards on pickup #\2 +50% card fire cooldown"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "#{{REG_Jimbo}} When hitting an enemy, cards shoot 1 laser that deal 50% the card's damage in a random direction #{{IND}}{{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards shoot an extra laser"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DR_FETUS] = "#{{REG_Jimbo}} When hitting an enemy, cards leave a bomb #The bombs deal 100% of the card's damage and inherit his bomb upgrades #{{IND}}{{REG_Club}} {{ColorCips}}Club{{CR}} card's bombs are bigger and deal more damage #{{REG_Club}} Cards held in hand become {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SMELTER] = "#{{REG_Jimbo}} On use allows to sell a Joker for double the normal amount of coins #{{Blank}}(used automatically when selling at full charge)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_BOX] = "#{{REG_Jimbo}} Has {{Battery}} 12 max charges #{{REG_Jimbo}} Also gains 2 charges when using a {{RestockMachine}} Restock machine"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DOLLAR] = "#{{REG_Jimbo}} Change all your deck's cards suit to {{REG_Diamond}} {{REG_Yellow}}Diamond"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYRO] = "#{{REG_Jimbo}} Change all your deck's cards suit to {{REG_Club}} {{REG_CChips}}Club"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SKELETON_KEY] = "#{{REG_Jimbo}} Change all your deck's cards suit to {{REG_Spade}} {{REG_CSpade}}Spade"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BINGE_EATER] = "#{{REG_Jimbo}} Change all your deck's cards suit to {{REG_Heart}} {{REG_CMult}}Heart"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEART] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_QUARTER] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOOM] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GLITTER_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOMBER_BOY] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HOT_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BUTT_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_NANCY_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCATTER_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards on pickup # {{REG_Heart}} {{REG_CMult}}Hearts{{CR}} and {{REG_Club}} {{REG_CChips}}Clubs{{CR}} are considered as the same suit"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FAST_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOBBY_BOMB] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SAD_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GHOST_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STICKY_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARP_KEY] = "#{{REG_Jimbo}} {{REG_Spade}} {{REG_CSpade}}Spade{{CR}} cards can be used to open doors #{{REG_Spade}} Cards held in hand become{{REG_CSpades}}Spade{{CR}}cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_C_SECTION] = "#{{REG_Jimbo}} Cards fire a fetus as they land #{{IND}}{{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards fire an additional fetus #{{REG_Heart}} Cards held in hand become {{REG_CMult}}Heart{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECH_X] = "#{{REG_Jimbo}} Cards are surrounded by a laser ring that deals 50% of its damage per tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "#{{REG_Jimbo}} Cards gain spectral and piercing, dealing 30% of its damage per tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TRISAGION] = "#{{REG_Jimbo}} Cards gain piercing, dealing 20% of its damage per tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "#{{REG_Jimbo}} The sword is applied on top of the usual card shooting"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALLOWED_GROUND] = "#{{REG_Jimbo}} Played cards are {{REG_Retrigger}} {{REG_Yellow}}Retriggered{{CR}} while inside the aura"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM] = "#{{REG_Jimbo}} Player cards are {{REG_Retrigger}} {{REG_Yellow}}Retriggered{{CR}} while inside the aura"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_POUND_OF_FLESH] = "#{{REG_Jimbo}} {{REG_Diamond}} {{REG_Yellow}}Diamonds{{CR}} and {{REG_Heart}} {{REG_CMult}}Hearts{{CR}} are considered as the same suit"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TMTRAINER] = "#{{REG_Jimbo}} All cards in the deck get randomized on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "#{{REG_Jimbo}} {{REG_Spade}}{{REG_CSpades}}Spade{{CR}}cards have a {{REG_Mint}}[[CHANCE]] in 2 Chance{{R}} to {{Charm}} Charm enemies"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALO] = "#{{REG_Jimbo}} {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}}cards gain a {{Collectible331}} God Head-like aura #{{REG_Diamond}} Cards held in hand become{{REG_Yellow}}Diamond{{CR}}cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "#{{REG_Jimbo}} {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}}cards give {{REG_CMult}}+0.01{{CR}} Damage per {{ColoraYellorange}}5{{CR}} coins held when scored"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE] = "#{{REG_Jimbo}} Tears given by {{REG_Bonus}} {{REG_Yellow}}Bouns enhancements{{CR}} are doubled"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SOUL] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCAPULAR] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_KEEPERS_KIN] = "#{{REG_Jimbo}} When landing, {{REG_Stone}} {{REG_Yellow}}Stone cards{{CR}} spawn 1-3 {{REG_Yellow}}Blue Spiders"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = "#{{REG_Jimbo}} Also gives the {{Collectible"..mod.Vouchers.Crystal.."}} Crystal ball Vaoucher effect while held"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "#{{REG_Jimbo}} Cards fired don't disappear when blocking projectiles #{{ColorGray}} (Suit tears behave as usual)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYROMANIAC] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Club}} {{REG_CChips}}Club{{CR}} cards on pickup # {{REG_Club}} {{REG_CChips}}Clubs{{CR}} and {{REG_Heart}} {{REG_CMult}}Hearts{{CR}} are considered as the same suit"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOGO_BOMBS] = "#{{REG_Jimbo}} {{REG_Club}} {{REG_CChips}}Club{{CR}} cards added to your deck are doubled"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_IRON_BAR] = "#{{REG_Jimbo}} {{REG_Steel}} {{ColorYelloragne}}Steel cards{{CR}} cause {{Confusion}} Confusion to enemies hit"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "#{{REG_Jimbo}} {{REG_Gold}} {{REG_Yellow}}Gold cards{{CR}} turn enemies hit into golden statues"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = "#{{REG_Jimbo}} Cards held in hand become {{REG_Wild}} {{REG_Yellow}}Wild cards{{CR}} on pickup #{{Blank}} {{ColorGray}}(can't overwrite existing enhancements) #{{REG_Wild}} Wild cards gain additional random tear effects"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = "#{{REG_Jimbo}} {{REG_Yellorange}}3s{{CR}} fired gain 3 additional tear effects"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GODHEAD] = "#{{REG_Jimbo}} All natrually {{REG_Spade}} {{REG_CSpades}}Spade{{CR}} cards in your deck are destroyed #{{REG_Wild}} All other cards become {{REG_Yellow}}Wild Cards#{{Blank}} {{ColorGray}}(Can't overide existing enhancements)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO] = "#{{REG_Jimbo}} {{REG_Club}} {{REG_CChips}}Club{{CR}} cards are guaranteed to trigger their explosion"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FIRE_MIND] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = "#{{REG_Jimbo}} All {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}} cards spawn vanishing penny when hitting an enemy #{{REG_Jimbo}} Cards held in hand become {{REG_Diamond}} {{REG_Yellow}}Diamond{{CR}} cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARD_OF_GLASS] = "#{{REG_Jimbo}} {{REG_Glass}} {{REG_Yellow}}Glass cards{{CR}} have the {{Collectible506}} Backstabber effect and always cause {{BleedingOut}} bleeding #{{REG_Jimbo}} Cards held in hand become {{REG_Glass}} {{REG_Yellow}}Glass cards{{CR}} on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EYE_OF_GREED] = "#{{REG_Jimbo}} All {{REG_Diamond}}{{REG_Yellow}}Diamond{{CR}}cards turn enemies hit in golden statues #{{REG_Jimbo}} Cards held in hand become {{REG_Diamond}}{{REG_Yellow}}Diamond{{CR}}cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MAGIC_SKIN] = "#{{REG_Jimbo}} Becomes {{REG_Yellow}}SINGLE USE #{{REG_Jimbo}} Also spawns 2 random {{REG_Joker}} Jokers"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DEEP_POCKETS] = "#{{REG_Jimbo}} Max coin count is increased to 9999"
Descriptions.JimboSynergies[mod.Collectibles.POCKET_ACES] = "#{{REG_Jimbo}} Adds 2 aces with a random {{REG_Yellow}}Enhancement{{CR}}, {{REG_Yellow}}Seal{{CR}} and {{REG_Yellow}}Edition{{CR}} to the deck on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HYPERCOAGULATION] = "#{{REG_Jimbo}} {{REG_Heart}} {{REG_CMult}}Heart{{CR}} cards fired gain the {{Collectible224}} Cricket's body split effect"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CANDY_HEART] = "#{{REG_Jimbo}} {{REG_Heart}}{{REG_CMult}}Heart{{CR}}cards added gain a random {{REG_Yellow}}Enhancement{{CR}} if they didn't have one"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON] = "#{{REG_Jimbo}} Damage given by {{REG_Mult}} {{REG_Yellow}}Mult enhancements{{CR}} are doubled"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_ABADDON] = "#{{REG_Jimbo}} {{REG_Spade}}{{REG_CSpades}}Spade{{CR}} cards deal 10% more damage"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STEAM_SALE] = "#{{REG_Jimbo}} Items on sale cost {{REG_Yellow}}1 {{Coin}} coin less #!!! {{ColorGray}}Normal effect does not activte"


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
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.BONUS] = "# {{REG_CChips}}+30{{CR}} Chips"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.MULT]  = "# {{REG_CMult}}+4{{CR}} Mult"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# {{REG_Yellow}}+3${{CR}} when held at the end of round"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GLASS] = "# {{REG_CMult}}X2{{CR}} Molt # {{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to break when played"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to give {{REG_CMult}}+20{{CR}} Mult # {{REG_Mint}}[[CHANCE]] in 20 Chance{{CR}} to give {{REG_Yellow}}+20$"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STEEL] = "# {{REG_CMult}}X1.5{{CR}} Mult When held in hand"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.WILD]  = "# Considered as being of every {{REG_Yellow}}Suit"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STONE] = "#{{REG_CChips}}+50{{CR}} Chips #Doesn't have a {{REG_Yellow}}Rank{{CR}} or {{REG_Yellow}}Suit"



Descriptions.T_Jimbo.Seal = {}
Descriptions.T_Jimbo.Seal[mod.Seals.NONE] = ""
Descriptions.T_Jimbo.Seal[mod.Seals.RED] = "# {{REG_Yellow}}Retriggered{{CR}} once"
Descriptions.T_Jimbo.Seal[mod.Seals.BLUE] = "# Create {{REG_Yellow}}winning{{CR}} hand's {{ColorCyan}}Planet{{CR}} if held"
Descriptions.T_Jimbo.Seal[mod.Seals.GOLDEN] = "# Earn {{REG_Yellow}}1$"
Descriptions.T_Jimbo.Seal[mod.Seals.PURPLE] = "# Creates {{ColorPink}}Tarot{{CR}} when {{ColorRed}}Discarded"


Descriptions.T_Jimbo.Edition = {}
Descriptions.T_Jimbo.Edition[mod.Edition.BASE] = ""
Descriptions.T_Jimbo.Edition[mod.Edition.FOIL] = "#{{REG_CChips}}+50{{CR}} Chips"
Descriptions.T_Jimbo.Edition[mod.Edition.HOLOGRAPHIC] = "#{{REG_CMult}}+10{{CR}} Mult"
Descriptions.T_Jimbo.Edition[mod.Edition.POLYCROME] = "#{{REG_CMult}}X1.5{{CR}} Mult"
Descriptions.T_Jimbo.Edition[mod.Edition.NEGATIVE] = "#{{REG_Yellow}}+1{{CR}} Joker Slot"
Descriptions.T_Jimbo.ConsumableNEGATIVE = "#{{REG_Yellow}}+1{{CR}} Consumable Slot"
Descriptions.T_Jimbo.CardNEGATIVE = "#{{REG_Yellow}}+1{{CR}} Hand Size"


Descriptions.T_Jimbo.SkipName = {}
Descriptions.T_Jimbo.SkipName[mod.SkipTags.BOSS] = "Boss Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.BUFFON] = "Buffon Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.CHARM] = "Charm Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.COUPON] = "Coupon Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.D6] = "D6 Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.DOUBLE] = "Double Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.ECONOMY] = "Economy Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.ETHEREAL] = "Ethereal Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.FOIL] = "Foil Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.GARBAGE] = "Garbage Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.HANDY] = "Handy Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.HOLO] = "Holographic Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.INVESTMENT] = "Investment Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.JUGGLE] = "Juggle Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.METEOR] = "Meteor Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.NEGATIVE] = "Negative Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.ORBITAL] = "Orbital Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.POLYCHROME] = "Polychrome Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.RARE] = "Rare Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.SPEED] = "Speed Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.STANDARD] = "Standard Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.TOP_UP] = "Top-Up Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.UNCOMMON] = "Uncommon Tag"
Descriptions.T_Jimbo.SkipName[mod.SkipTags.VOUCHER] = "Voucher Tag"
Descriptions.T_Jimbo.SkipName[mod.SpecialSkipTags.KEY_PIECE_1] = "Uriel Tag"
Descriptions.T_Jimbo.SkipName[mod.SpecialSkipTags.KEY_PIECE_2] = "Gabriel Tag"



Descriptions.T_Jimbo.SkipTag = {}
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BOSS] = "Reroll this ante's {{REG_Yellow}}boss blind"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BUFFON] = "Open a {{REG_Yellow}}Mega Buffon Pack"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.CHARM] = "Open a {{REG_Yellow}}Mega Arcana Pack"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.COUPON] = "Initail cards and boosters in the next shop are {{REG_Yellow}}Free"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.D6] = "Rerolls in the next shop start at {{REG_Yellow}}0$"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.DOUBLE] = "Duplicates the next skip tag taken #{{ColorGray}}(except Double Tag)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ECONOMY] = "Double your money # {{ColorGray}}(Max 40$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ETHEREAL] = "Open a {{REG_Yellow}}Spectral Pack"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.FOIL] = "The next shop contains a free {{REG_CChips}}Foil{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.GARBAGE] = "Gain {{REG_Yellow}}1${{CR}} per unused {{REG_CMult}}Discard #{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HANDY] = "Gain {{REG_Yellow}}1${{CR}} per played {{REG_CChips}}Hand{{ColorGray}} #([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HOLO] = "The next shop contains a free {{REG_CMult}}Holographic{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.INVESTMENT] = "{{REG_Yellow}}25${{CR}} after defeating the next {{REG_Yellow}}Boss Blind"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.JUGGLE] = "Gain {{REG_Yellow}}+3{{CR}} hand size for the next blind"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.METEOR] = "Open a {{REG_Yellow}}Mega Celestial Pack"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.NEGATIVE] = "The next shop contains a free {{ColorBlack}}Negative{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ORBITAL] = "Upgrade {{REG_Yellow}}[[VALUE1]]{{CR}} by 3 levels"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.POLYCHROME] = "The next shop contains a free {{ColorRainbow}}Polychrome{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.RARE] = "The next shop contains a free {{REG_CMult}}Rare{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.SPEED] = "Gain {{REG_Yellow}}5${{CR}} per blind skipped this run #{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.STANDARD] = "Open a {{REG_Yellow}}Mega Standard Pack"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.TOP_UP] = "Gain up to {{REG_Yellow}}2{{CR}} {{REG_CChips}}Common{{CR}} Jokers"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.UNCOMMON] = "The next shop contains a free {{ColorLime}}Uncommon{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.VOUCHER] = "The next shop has an additional {{REG_Yellow}}Voucher"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_1] = "Gain {{REG_Yellow}}10${{CR}} and the {{REG_Yellow}}Key Piece 1{{CR}} item"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_2] = "Gain {{REG_Yellow}}10${{CR}} and the {{REG_Yellow}}Key Piece 2{{CR}} item"


Descriptions.T_Jimbo.Jokers = {}
do
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER] = "{{REG_CMult}}+4{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BULL] = " {{REG_CChips}}+2{{CR}} Chips per {{REG_Yellow}}1${{CR}} you have# {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "After {{REG_Yellow}}2{{CR}} rounds, sell this Joker to {{REG_Yellow}}Duplicate{{CR}} a random Joker {{ColorGray}}[[VALUE2]]#(Currently [[VALUE1]])"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{REG_CMult}}+3{{CR}} Mult per Joker card# {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MISPRINT] = " {{REG_CMult}}+0-23{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{REG_CMult}}X1{{CR}} Mult per empty Joker slot#Joker Stencil included# {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STONE_JOKER] = " {{REG_CChips}}+25{{CR}} Chips per {{REG_Yellow}}Stone card{{CR}} in your {{REG_Yellow}}Full deck{{CR}} {{ColorGray}}#(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ICECREAM] = " {{REG_CChips}}+[[VALUE1]]{{CR}} Chips#Loses {{REG_CChips}}-5{{CR}} Chips every hand played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.POPCORN] = " {{REG_CMult}}+[[VALUE1]]{{CR}} Mult #Loses {{REG_CMult}}-4{{CR}} Mult every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAMEN] = " {{REG_CMult}}X[[VALUE1]]{{CR}} Mult#loses {{REG_CMult}}-0.01X{{CR}} per card discarded #{{Collectible682}} Gain a weaker copy of Worm Friend"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROCKET] = "Earn {{REG_Yellow}}[[VALUE1]]${{CR}} at the end of round#Payout increases by {{REG_Yellow}}2${{CR}} when a boss blind is defeated"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ODDTODD] = "Played cards with {{REG_Yellow}}odd{{CR}} rank give {{REG_CChips}}+31{{CR}} Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "Played cards with {{REG_Yellow}}even{{CR}} rank give {{REG_CChips}}+4{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to create a{{ColorPink}}Tarot{{CR}} card when opening a {{REG_Yellow}}Booster Pack"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "This gains {{REG_CMult}}+1{{CR}} Mult per hand played#{{REG_CMult}}-1{{CR}} Mult per discard #{{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RED_CARD] = "Ottiene {{REG_CMult}}+3{{CR}} Mult per {{REG_Yellow}}Booster Pack{{CR}} skipped#{{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAGABOND] = "Creates a{{ColorPink}}Tarot{{CR}} card when a hand is played with {{REG_Yellow}}4${{CR}} or less"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "When a{{REG_Yellow}}Blind{{CR}} is selected, creates up to 2 {{REG_CChips}}common{{REG_Yellow}}Jokers"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Earn {{REG_Yellow}}4${{CR}} at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{REG_CMult}}+1{{CR}}Mult per {{ColorPink}}Tarot{{CR}} card used this run # {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "Copies the effect of the {{REG_Yellow}}Joker{{CR}} to its right#{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "Copies the effect of the leftmost held {{REG_Yellow}}Joker{{CR}}#{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MADNESS] = "When a {{REG_Yellow}}Small{{CR}} or {{REG_Yellow}}Big Blind{{CR}} is selected, destroys another random Joker and gains {{REG_CMult}}X0.5{{CR}} Mult# {{REG_CMult}}(Currently X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MR_BONES] = "{{REG_CMult}}Prevents Death{{CR}} and {{REG_Yellow}}self desctructs{{CR}} if the enemy with the most HP has up to{{REG_Yellow}}75% of the blind's base size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{REG_CChips}}Club{{CR}} cards give{{REG_CMult}}+7{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{REG_CSpade}}Spade{{CR}} cards give{{REG_CChips}}+50{{CR}}Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{REG_CMult}}Heart{{CR}} card have a{{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to give {{REG_CMult}}X1.5{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{REG_Yellow}}Diamond{{CR}} cards give {{REG_Yellow}}1${{CR}} when scored"

Descriptions.T_Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = " {{REG_CMult}}+15{{CR}}Mult #{{REG_Mint}}[[CHANCE]] in 6 Chance{{CR}} of getting destoroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAVENDISH] = " {{REG_CMult}}X3{{CR}}Mult # {{REG_Mint}}[[CHANCE]] in 1000 Chance{{CR}} of getting destroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "This gains {{REG_CMult}}+2{{CR}} Mult every {{REG_Yellow}}Shop{{REG_Mint}}Reroll #{{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "When a {{REG_Yellow}}blind{{CR}} is selcted, destroys the Joker to its right and gains {{REG_CMult}}+double its sell value{{CR}} Mult #{{ColorGrey}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "Earn {{REG_Yellow}}1${{CR}} per {{REG_Yellow}}9{{CR}} in your {{REG_Yellow}}Full Deck{{CR}} at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "Adds the sell value of other owned{{REG_Yellow}}Jokers{{CR}} to {{REG_CMult}}Mult# {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "When a {{REG_Yellow}}blind{{CR}} is selected, creates a{{ColorPink}}Tarot{{CR}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{REG_CMult}}X4{{CR}} Mult once every {{REG_Yellow}}6{{CR}}hands played # {{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "Adds the number of times {{REG_Yellow}}Poker hand{{CR}} was played to {{REG_CMult}}Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "Earn {{REG_Yellow}}2${{CR}} per {{REG_CMult}}Discard{{CR}} if none were used at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EGG] = "The sell value of this Joker increases by {{REG_Yellow}}3${{CR}} every {{REG_Yellow}}Blind{{CR}} cleared"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DNA] = "If the {{REG_Yellow}}First hand{{CR}} of round only contains {{REG_Yellow}}1{{CR}} card, add a copy to your {{REG_Yellow}}Deck{{CR}} and draw it in hand #{{ColorGray}}[[VALUE1]]"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{REG_CMult}}Hearts{{CR}} and {{REG_Yellow}}Diamonds{{CR}} count as the same suit #{{REG_CSpade}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{REG_CChips}}+50{{CR}}Chips if hand played contains a {{REG_Yellow}}Pair"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{REG_CChips}}+100 {{CR}}Chips if hand played contains a {{REG_Yellow}}Three of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{REG_CChips}}+80 {{CR}}Chips if hand played contains a {{REG_Yellow}}Two Pair"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{REG_CChips}}+100 {{CR}}Chips if hand played contains a {{REG_Yellow}}Striaght"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{REG_CChips}}+80 {{CR}}Chips if hand played contains a {{REG_Yellow}}Flush"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{REG_CMult}}+8 {{CR}}Mult if hand played contains a {{REG_Yellow}}Pair"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{REG_CMult}}+12 {{CR}}Mult if hand played contains a {{REG_Yellow}}Three of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{REG_CMult}}+10 {{CR}}Mult if hand played contains a {{REG_Yellow}}Two Pair"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{REG_CMult}}+12 {{CR}}Mult if hand played contains a {{REG_Yellow}}Straight"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{REG_CMult}}+10 {{CR}}Mult if hand played contains a {{REG_Yellow}}Flush"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MIME] = "{{REG_Yellow}}Retriggers{{CR}} all {{REG_Yellow}}held in hand{{CR}} abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{REG_Yellow}}Flushes{{CR}} and {{REG_Yellow}}Straights{{CR}} only need 4 cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{REG_CMult}}Heart{{CR}} cards give {{REG_CMult}}+3{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{REG_Yellow}}Diamond{{CR}} cards give {{REG_CMult}}+3{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{REG_CSpade}}Spade{{CR}} cards give {{REG_CMult}}+3{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{REG_CChips}}Club{{CR}} cards give {{REG_CMult}}+3 {{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{REG_Yellow}}+3{{CR}} Discards #{{REG_CMult}}-1{{CR}} Hand size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{REG_CMult}}+20{{CR}}Mult when hand played has {{REG_Yellow}}3 or less{{CR}} cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Shop items can be bought with up to {{REG_CMult}}-20${{CR}} in debt #{{ColorGray}}(Effect is stackable)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BANNER] = "{{REG_CChips}}+30{{CR}}Chips per remaining{{REG_Yellow}}Discard"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{REG_CMult}}+15{{CR}} Molt when with {{REG_Yellow}}0{{CR}} discards remaining"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "When a {{REG_Yellow}}Blind{{CR}} is selected, adds a {{REG_Yellow}}Stone card{{CR}} to the deck"
Descriptions.T_Jimbo.Jokers[mod.Jokers._8_BALL] = "{{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to create a{{ColorPink}}Tarot{{CR}}card when an {{REG_Yellow}}8{{CR}} is scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUSK] = "{{REG_Yellow}}Retriggers{{CR}} last hand of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "Adds {{REG_Yellow}}double{{CR}} the rank of the {{REG_Yellow}}lowest{{CR}} ranked card held in hand to {{REG_CMult}}Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{REG_Yellow}}1{{CR}} free {{REG_Mint}}Reroll{{CR}} per shop"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FIBONACCI] = "Every {{REG_Yellow}}Ace{{CR}}, {{REG_Yellow}}2{{CR}}, {{REG_Yellow}}3{{CR}}, {{REG_Yellow}}5{{CR}} and {{REG_Yellow}}8{{CR}} gives {{REG_CMult}}+8{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "This gains {{REG_CMult}}X0.2{{CR}}Mult per {{REG_Yellow}}Steel card{{CR}} in your full deck"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{REG_Yellow}}Face cards{{CR}} give {{REG_CChips}}+30{{CR}}Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HACK] = "Retriggers {{REG_Yellow}}2, 3, 4 and 5{{CR}} played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Every card counts as a {{REG_Yellow}}Face card"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SCHOLAR] = "{{REG_Yellow}}Aces{{CR}} give {{REG_CMult}}+4{{CR}} Mult and {{REG_CChips}}+20{{CR}} Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{REG_Yellow}}Face cards{{CR}} have a {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to give{{REG_Yellow}}2${{CR}} when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{REG_CMult}}+1{{CR}}Mult per consecutive hand played without a {{REG_Yellow}}scoring Face card#{{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to upgrade level of played {{REG_Yellow}}Poker hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURGLAR] = "After a round starts, lose all {{REG_CMult}}Discards{{CR}} and gain {{REG_CChips}}+3{{CR}} hands"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{REG_CMult}}X3{{CR}}Mult if all cards held in hand are {{REG_CSpade}}Spades{{CR}} or {{REG_CChips}}Clubs"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RUNNER] = "This gains {{REG_CChips}}+15{{CR}} Chips when played hand contains a {{REG_Yellow}}Straight#{{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPLASH] = "All {{REG_Yellow}}played cards{{CR}} are considered in scoring"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{REG_CChips}}+2{{CR}}Chips per remaining card in your deck # {{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "If the {{REG_Yellow}}First{{CR}} hand played is a single {{REG_Yellow}}6{{CR}}, destroy it and create a {{ColorBlue}}Spectral{{CR}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "This Jokers gains {{REG_CMult}}X0.1{{CR}} Mult every time a {{ColorCyan}}Planet{{CR}} card is used#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIKER] = "Cards gain {{REG_CChips}}+5{{CR}} permanent Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FACELESS] = "Gain {{REG_Yellow}}5${{CR}} when discarding {{REG_Yellow}}3 or more Face cards{{CR}} at once"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "Create a {{ColorPink}}Tarot{{CR}} card when played hand contains a {{REG_Yellow}}Straight{{CR}} and an {{REG_Yellow}}Ace"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "Gain {{REG_Yellow}}4${{CR}} when played hand is a {{REG_Yellow}}[[VALUE1]]{{CR}}#(Hand changes every round)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{REG_CChips}}X3{{CR}} Mult if {{REG_Yellow}}Poker hand{{CR}} was alredy played this round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "This gains {{REG_CChips}}+4{{CR}} Chips if hand played contains exactly {{REG_Yellow}}4{{CR}} cards#{{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEANCE] = "Creates a {{REG_Yellow}}Spectral{{CR}} card if a {{REG_Yellow}}Straight Flush{{CR}} is played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAMPIRE] = "When {{REG_Yellow}}Enhanced{{CR}} card is scored, this gains {{REG_CChips}}X0.1{{CR}} Mult and removes the card's {{REG_Yellow}}Enhancement{{CR}}#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Allows {{REG_Yellow}}Straights{{CR}} to be made with gaps of {{REG_Yellow}}1 rank"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "This gains {{REG_CMult}}X0.25{{CR}}Mult when a card gets {{REG_Yellow}}added{{CR}} to the deck#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Mult)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BARON] = "Every {{REG_Yellow}}King{{CR}} held in hand gives {{REG_CMult}}X1.5{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OBELISK] = "This gains {{REG_CMult}}X0.2{{CR}} Mult per {{REG_Yellow}}consecutive{{CR}} hand played without playing your most played {{REG_Yellow}}Poker hand{{CR}}#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MIDAS] = "Every scoring {{REG_Yellow}}Face card{{CR}} becomes {{REG_Yellow}}Golden"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{REG_Yellow}}Selling{{CR}} this Joker disables all {{REG_Yellow}}Boss abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "First Scoring {{REG_Yellow}}Face card{{CR}} gives {{REG_CMult}}X2{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "Every Joker and consumable held gains {{REG_Yellow}}+1${{CR}} selling value at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{ColorCyan}}+[[VALUE1]]{{CR}} Hand Size #Loses {{REG_CMult}}-1{{CR}} Hand size every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EROSION] = "{{REG_CChips}}+4{{CR}} Mult per card below {{REG_Yellow}}52{{CR}} in your {{REG_Yellow}}Full deck# {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "Each {{REG_Yellow}}Face card{{CR}} held in hand has a {{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to give {{REG_Yellow}}1$"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "Earn {{REG_Yellow}}5${{CR}} per {{REG_Yellow}}[[VALUE1]]{{CR}} discarded #(Rank changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "Earn {{REG_Yellow}}1${{CR}} extra per {{REG_Yellow}}5${{CR}} you have as interest"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{REG_Yellow}}+1{{CR}} Hand Size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{REG_CMult}}+1{{CR}} discard"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "This gains {{REG_CMult}}X0.25{{CR}} Mult per {{REG_Mint}}Successful{{REG_Yellow}}Lucky Card{{CR}} trigger#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{REG_Mint}}Uncommon{{CR}} Jokers give {{REG_CMult}}X1.5{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{REG_Yellow}}Selling{{CR}} this creates a {{REG_Yellow}}Double Tag"

Descriptions.T_Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "If first discard of round contains a {{REG_Yellow}}single{{CR}} card, destroy it and gain {{ColotYellor}}3$"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "This gains {{REG_CMult}}+2{{CR}} Mult if hand played contains a {{REG_Yellow}}Two-pair#{{ColorGray}}(Currently{{REG_CMult}}+[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "[[VALUE1]]{{CR}} cards give {{REG_CMult}}X1.5{{CR}}Mult when scored#{{ColorGray}}(suit changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "{{REG_Yellow}}10s{{CR}} and {{REG_Yellow}}4s{{CR}} give {{REG_CChips}}+10{{CR}}Chips and {{REG_CMult}}+4{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SELTZER] = "{{REG_Yellow}}Retriggers{{CR}} all played cards# {{ColorGray}}({{REG_Yellow}}[[VALUE1]]{{ColorGray}} hands remaining)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{REG_Yellow}}Face cards{{CR}} give {{REG_CMult}}+5{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "This gains {{REG_CMult}}X0.25{{CR}} Mult per card {{REG_Yellow}}sold{{CR}} this Ante #{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CASTLE] = "This gains {{REG_CChips}}+3{{CR}} Chips per [[VALUE1]]{{CR}} card discarded #{{ColorGray}}(Currently {{REG_CChips}}+[[VALUE2]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{REG_Yellow}}Golden{{CR}} cards give {{REG_Yellow}}4${{CR}} when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{REG_CMult}}X3{{CR}} Mult on {{REG_Yellow}}last{{CR}} hand of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{REG_Yellow}}Retriggers{{CR}} played {{REG_Yellow}}Face{{CR}} cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{REG_Yellow}}+2{{CR}} Hand Size #{{REG_CMult}}-1{{CR}} Hands"
Descriptions.T_Jimbo.Jokers[mod.Jokers.THROWBACK] = "This gains {{REG_CMult}}X0.25{{CR}} Mult per blind {{REG_Yellow}}skipped{{CR}} in this run# {{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "When a blind is {{REG_Yellow}}selected{{CR}}, adds a card with a random{{REG_Yellow}}Seal{{CR} to the deck and drawn to hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{REG_Yellow}}First{{CR}} scoring card played is {{REG_Yellow}}retriggered{{CR}} twice"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "This gains {{REG_CMult}}X0.75{{CR}} per {{REG_Yellow}}Glass Card{{CR}} destroyed#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{REG_Yellow}}Joker{{CR}},{{ColorPink}}Tarot{{CR}},{{ColorCyan}}Planet{{CR}} and {{ColorBlue}}Spectral{{CR}} cards may appear multiple times"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{REG_CChips}}X3{{CR}} Mult if {{REG_Yellow}}Poker Hand{{CR}} contains all{{REG_Yellow}}Suits"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "This gains {{REG_CChips}}+8{{CR}} Chips per {{REG_Yellow}}2{{CR}} scored#{{ColorGray}}(Currently {{REG_CChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OOPS_6] = "Every {{REG_Mint}}Listed Chance{{CR}} is doubled"
Descriptions.T_Jimbo.Jokers[mod.Jokers.IDOL] = "[[VALUE1]]{{CR}} give {{REG_CMult}}X2{{CR}} Mult when scored #(Card changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{REG_CMult}}X2{{CR}} Mult if {{REG_Yellow}}Poker Hand{{CR}} contains both a {{REG_CChips}}Club{{CR}} and {{REG_Yellow}}not-{{REG_CChips}}Club{{CR}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MATADOR] = "Guadagna {{REG_Yellow}}8${{CR}} when hand played triggers the {{REG_Yellow}}Boss blind{{CR}} effect"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "This gains {{REG_CMult}}X0.5{{CR}} Mult per {{REG_Yellow}}Jack{{CR}} discarded this round#{{ColorGray}}(Currently {{REG_CMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUO] = "{{REG_CMult}}X2{{CR}} Mult if hand played contains a {{REG_Yellow}}Pair "
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIO] = "{{REG_CMult}}X3{{CR}} Mult if hand played contains a {{REG_Yellow}}Three of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FAMILY] = "{{REG_CMult}}X4{{CR}} Mult if hand played contains a {{REG_Yellow}}Four of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ORDER] = "{{REG_CMult}}X3{{CR}} Mult if hand played contains a {{REG_Yellow}}Straight"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBE] = "{{REG_CMult}}X2{{CR}} Mult if hand played contains a {{REG_Yellow}}Flush"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{REG_CMult}}+250{{CR}} Chips #{{REG_CMult}}-2{{CR}} Hand Size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SATELLITE] = "Earn {{REG_Yellow}}1${{CR}} per unique {{ColorCyan}}Planet{{CR}} card used this run# {{ColorGray}}(Currently {{REG_Yellow}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{REG_CMult}}+13{{CR}} Mult per {{REG_Yellow}}Queen{{CR}} held in hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{REG_CMult}}X3{{CR}} Mult if you have at least {{REG_Yellow}}16 Enhanced cards{{CR}} in your full deck # {{ColorGray}}(Currently {{REG_Yellow}}[[VALUE1]]{{ColorGray}} Enhanced cards)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "Every {{ColorCyan}}Planet{{CR}} card and {{ColorCyan}}Celestial{{CR}} pack is free"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{REG_Yellow}}Upgrades{{CR}} the level of first discarded {{REG_Yellow}}Poker hand{{CR}} every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{REG_CMult}}+2{{CR}} Mult per {{REG_Yellow}}5${{CR}} you have# {{ColorGray}}(Currently {{REG_CMult}}+[[VALUE1]]{{ColorGray}} Mult)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CANIO] = "This gains {{REG_CMult}}X1{{CR}} Mult per {{REG_Yellow}}Face{{CR}} card is destroyed#{{ColorGray}}(Currently {{ColroMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{REG_Yellow}}Kings{{CR}} and {{REG_Yellow}}Queens{{CR}} give {{REG_CMult}}X2{{CR}} Mult when triggered"
Descriptions.T_Jimbo.Jokers[mod.Jokers.YORICK] = "This gains {{REG_CMult}}X1{{CR}} Mult once every {{REG_Yellow}}23{{CR}} cards discarded#{{ColorGray}}([[VALUE2]] Remaining) #{{ColorGray}}(Currently {{ColroMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHICOT] = "Disables all {{REG_Yellow}}Boss blind{{CR}} abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PERKEO] = "When exiting a {{REG_Yellow}}Shop{{CR}}, creates a {{REG_CSpade}}Negative{{CR}} copy of a random consumable you have"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "After being scored, cards are {{REG_Yellow}}randomly{{CR}} rerolled #{{ColorGray}}(The new card generated depends on the starting one)"


end


Descriptions.T_Jimbo.Debuffed = "All abilitied are disabled"


---------------------------------------
-------------####TAROTS####------------
---------------------------------------

Descriptions.Jimbo.Consumables = {}
Descriptions.Jimbo.Consumables[Card.CARD_FOOL] = "Spawns copy of your last used card #!!! Cannot spawn itself #[[VALUE1]] Currently: [[VALUE2]]"
Descriptions.Jimbo.Consumables[Card.CARD_MAGICIAN] = "{{REG_Lucky}} Turn up to {{REG_Yellow}}2{{CR}} cards from your hand into {{REG_Yellow}}Lucky Cards"
Descriptions.Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "{{REG_Planet}} Spawns {{REG_Yellow}}2{{CR}} random {{ColorCyan}}Planet Cards"
Descriptions.Jimbo.Consumables[Card.CARD_EMPRESS] = "{{REG_Mult}} Turn up to {{REG_Yellow}}2{{CR}} cards from your hand into {{REG_Yellow}}Mult Cards"
Descriptions.Jimbo.Consumables[Card.CARD_EMPEROR] = "{{Card}} Spawns {{REG_Yellow}}2{{CR}} random {{ColorPink}}Tarot Cards{{CR}} #{{IND}}!!! Cannot spawn itself"
Descriptions.Jimbo.Consumables[Card.CARD_HIEROPHANT] = "{{REG_Bonus}} Turn up to {{REG_Yellow}}2{{CR}} cards from your hand into {{REG_Yellow}}Bonus Cards"
Descriptions.Jimbo.Consumables[Card.CARD_LOVERS] = "{{REG_Wild}} Turn {{REG_Yellow}}1{{CR}} card from your hand into a {{REG_Yellow}}Wild Card"
Descriptions.Jimbo.Consumables[Card.CARD_CHARIOT] = "{{REG_Steel}} Turn {{REG_Yellow}}1{{CR}} card from your hand into a {{REG_Yellow}}Steel Card"
Descriptions.Jimbo.Consumables[Card.CARD_JUSTICE] = "{{REG_Glass}} Turn {{REG_Yellow}}1{{CR}} card from your hand into a {{REG_Yellow}}Glass Card"
Descriptions.Jimbo.Consumables[Card.CARD_HERMIT] = "Doubles you current money #{{IND}}!!! Can give up to {{REG_Yellow}}20$"
Descriptions.Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to give a random {{REG_Yellow}}Edition{{CR}} to a Joker in your inventory #{{IND}}!!! Cannot replace existing editions"
Descriptions.Jimbo.Consumables[Card.CARD_STRENGTH] = "Raise the Rank of up to {{REG_Yellow}}2{{CR}} cards by 1 #{{IND}}!!! Kings chosen become Aces"
Descriptions.Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Destroys up to {{REG_Yellow}}2{{CR}} cards from your hand"
Descriptions.Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{REG_Yellow}}2{{CR}} cards, the {{REG_Yellow}}second{{CR}} card chosen becomes the {{REG_Yellow}}first"
Descriptions.Jimbo.Consumables[Card.CARD_TEMPERANCE] = "{{Coin}} Gives the total {{REG_Yellow}}Sell value{{CR}} of you Jokers in {{Coin}}Pennies"
Descriptions.Jimbo.Consumables[Card.CARD_DEVIL] = "{{REG_Gold}} Turn {{REG_Yellow}}1{{CR}} card from your hand into a {{REG_Yellow}}Gold Card"
Descriptions.Jimbo.Consumables[Card.CARD_TOWER] = "{{REG_Stone}} Turn {{REG_Yellow}}1{{CR}} card from your hand into a {{REG_Yellow}}Stone Card"
Descriptions.Jimbo.Consumables[Card.CARD_STARS] = "{{REG_Diamond}} Set the Suit of up to {{REG_Yellow}}3{{CR}} cards from your hand into {{REG_Yellow}}Diamonds"
Descriptions.Jimbo.Consumables[Card.CARD_MOON] = "{{REG_Club}} Sets the Suit of up to {{REG_Yellow}}3{{CR}} cards from your hand into {{REG_CChips}}Clubs"
Descriptions.Jimbo.Consumables[Card.CARD_SUN] = "{{REG_Heart}} Sets the Suit of up to {{REG_Yellow}}3{{CR}} cards from your hand into {{REG_CMult}}Hearts"
Descriptions.Jimbo.Consumables[Card.CARD_JUDGEMENT] = "{{REG_Joker}} Gives a random {{REG_Yellow}}Joker{{CR}} #{{IND}}!!! Requires an empty Inventory slot"
Descriptions.Jimbo.Consumables[Card.CARD_WORLD] = "{{REG_Spade}} Set the Suit of up to {{REG_Yellow}}3{{CR}} cards from your hand into {{REG_CSpade}}Spades"


Descriptions.T_Jimbo.Consumables = {}
Descriptions.T_Jimbo.Consumables[Card.CARD_FOOL] = "Creates copy of your last used {{ColorPink}}Tarot{{CR}} or {{ColorCyan}}Planet{{CR}} used#{{ColorGray}}(exept The Fool)#[[VALUE1]]"
Descriptions.T_Jimbo.Consumables[Card.CARD_MAGICIAN] = "Turn up to {{REG_Yellow}}2{{CR}} cards into {{REG_Yellow}}Lucky Cards"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "Create {{REG_Yellow}}2{{CR}} {{ColorCyan}}Planet{{CR}} cards#{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPRESS] = "Turn up to {{REG_Yellow}}2{{CR}} cards into {{REG_Yellow}}Mult Cards"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPEROR] = "Creates {{REG_Yellow}}2{{CR}} {{ColorPink}}Tarot{{CR}} cards #{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIEROPHANT] = "Turn up to {{REG_Yellow}}2{{CR}} cards into {{REG_CChips}}Bonus Cards"
Descriptions.T_Jimbo.Consumables[Card.CARD_LOVERS] = "Turn {{REG_Yellow}}1{{CR}} card into a {{REG_Yellow}}Wild Card"
Descriptions.T_Jimbo.Consumables[Card.CARD_CHARIOT] = "Turn {{REG_Yellow}}1{{CR}} card into a {{REG_Yellow}}Steel Card"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUSTICE] = "Turn {{REG_Yellow}}1{{CR}} card into a {{REG_Yellow}}Glass Card"
Descriptions.T_Jimbo.Consumables[Card.CARD_HERMIT] = "Doubles your money #{{ColorGray}}(Max 20$)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to give a random {{REG_Yellow}}Edition{{CR}} to a Joker in your inventory #{{ColorGray}}(Cannot replace existing editions)"
Descriptions.T_Jimbo.Consumables[Card.CARD_STRENGTH] = "Raise the Rank of up to {{REG_Yellow}}2{{CR}} cards by 1 #{{ColorGray}}(Kings chosen become Aces)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Destroy up to {{REG_Yellow}}2{{CR}} cards"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{REG_Yellow}}2{{CR}} cards, the {{REG_Yellow}}Left{{CR}} card becomes a copy of the {{REG_Yellow}}Right{{CR}} card"
Descriptions.T_Jimbo.Consumables[Card.CARD_TEMPERANCE] = "Gives the total {{REG_Yellow}}Sell value{{CR}} of your Jokers#{{ColorGray}}(Currently {{ColorYellor}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEVIL] = "Turn {{REG_Yellow}}1{{CR}} card into a {{REG_Yellow}}Gold Card"
Descriptions.T_Jimbo.Consumables[Card.CARD_TOWER] = "Turn {{REG_Yellow}}1{{CR}} card into a {{REG_Yellow}}Stone Card"
Descriptions.T_Jimbo.Consumables[Card.CARD_STARS] = "Set the Suit of up to {{REG_Yellow}}3{{CR}} cards into {{REG_Yellow}}Diamonds"
Descriptions.T_Jimbo.Consumables[Card.CARD_MOON] = "Set the Suit of up to {{REG_Yellow}}3{{CR}} cards into {{REG_CChips}}Clubs"
Descriptions.T_Jimbo.Consumables[Card.CARD_SUN] = "Set the Suit of up to {{REG_Yellow}}3{{CR}} cards into {{REG_CMult}}Hearts"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUDGEMENT] = "Creates a random {{REG_Yellow}}Joker{{CR}} #{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WORLD] = "Set the Suit of up to {{REG_Yellow}}3{{CR}} cards into {{REG_CSpade}}Spades"


Descriptions.ConsumablesName = {}
Descriptions.ConsumablesName[Card.CARD_FOOL] = "The Fool"
Descriptions.ConsumablesName[Card.CARD_MAGICIAN] = "The Magician"
Descriptions.ConsumablesName[Card.CARD_HIGH_PRIESTESS] = "The High Priestess"
Descriptions.ConsumablesName[Card.CARD_EMPRESS] = "The Empress"
Descriptions.ConsumablesName[Card.CARD_EMPEROR] = "The Emperor"
Descriptions.ConsumablesName[Card.CARD_HIEROPHANT] = "The Hierophant"
Descriptions.ConsumablesName[Card.CARD_LOVERS] = "The Lovers"
Descriptions.ConsumablesName[Card.CARD_CHARIOT] = "The Chariot"
Descriptions.ConsumablesName[Card.CARD_JUSTICE] = "Justice"
Descriptions.ConsumablesName[Card.CARD_HERMIT] =  "The Hermith"
Descriptions.ConsumablesName[Card.CARD_WHEEL_OF_FORTUNE] = "Weel of Fortune"
Descriptions.ConsumablesName[Card.CARD_STRENGTH] = "Strength"
Descriptions.ConsumablesName[Card.CARD_HANGED_MAN] = "The Hanged Man"
Descriptions.ConsumablesName[Card.CARD_DEATH] = "Death"
Descriptions.ConsumablesName[Card.CARD_TEMPERANCE] = "Temperance"
Descriptions.ConsumablesName[Card.CARD_DEVIL] = "The Devil"
Descriptions.ConsumablesName[Card.CARD_TOWER] = "The Tower"
Descriptions.ConsumablesName[Card.CARD_STARS] = "The Stars"
Descriptions.ConsumablesName[Card.CARD_MOON] = "The Moon"
Descriptions.ConsumablesName[Card.CARD_SUN] = "The Sun"
Descriptions.ConsumablesName[Card.CARD_JUDGEMENT] = "Judgement"
Descriptions.ConsumablesName[Card.CARD_WORLD] ="The World"

----------------------------------------
-------------####PLANETS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Planets.PLUTO] = "{{REG_Yellow}}Aces{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.MERCURY] = "{{REG_Yellow}}2s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.URANUS] = "{{REG_Yellow}}3s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.VENUS] = "{{REG_Yellow}}4s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.SATURN] = "{{REG_Yellow}}5s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.JUPITER] = "{{REG_Yellow}}6s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.EARTH] = "{{REG_Yellow}}7s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.MARS] = "{{REG_Yellow}}8s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.NEPTUNE] = "{{REG_Yellow}}9s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.PLANET_X] = "{{REG_Yellow}}10s{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.CERES] = "{{REG_Yellow}}Jacks{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.ERIS] = "{{REG_Yellow}}Queens{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"
Descriptions.Jimbo.Consumables[mod.Planets.SUN] = "{{REG_Yellow}}Kings{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}} Tears and {{REG_CMult}}+0.02{{CR}} Damage when scored"


Descriptions.T_Jimbo.Consumables[mod.Planets.PLUTO] = "Level up {{REG_Yellow}}High card#{{REG_CMult}}+1{{CR}} Mult#{{REG_CChips}}+10{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.MERCURY] = "Level up {{REG_Yellow}}Pair#{{REG_CMult}}+1{{CR}} Mult#{{REG_CChips}}+15{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.URANUS] = "Level up {{REG_Yellow}}Two Pair#{{REG_CMult}}+1{{CR}} Mult#{{REG_CChips}}+20{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.VENUS] = "Level up {{REG_Yellow}}Three of a Kind#{{REG_CMult}}+2{{CR}} Mult#{{REG_CChips}}+20{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.SATURN] = "Level up {{REG_Yellow}}Straight#{{REG_CMult}}+3{{CR}} Mult#{{REG_CChips}}+35{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.JUPITER] = "Level up {{REG_Yellow}}Flush#{{REG_CMult}}+2{{CR}} Mult#{{REG_CChips}}+15{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.EARTH] = "Level up {{REG_Yellow}}Full House#{{REG_CMult}}+2{{CR}} Mult#{{REG_CChips}}+25{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.MARS] = "Level up {{REG_Yellow}}Four of a Kind#{{REG_CMult}}+3{{CR}} Mult#{{REG_CChips}}+30{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.NEPTUNE] = "Level up {{REG_Yellow}}Straight Flush#{{REG_CMult}}+4{{CR}} Mult#{{REG_CChips}}+40{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.PLANET_X] = "Level up {{REG_Yellow}}Five of a Kind#{{REG_CMult}}+3{{CR}} Mult#{{REG_CChips}}+35{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.CERES] = "Level up {{REG_Yellow}}Flush House#{{REG_CMult}}+4{{CR}} Mult#{{REG_CChips}}+40{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.ERIS] = "Level up {{REG_Yellow}}Flush Five#{{REG_CMult}}+3{{CR}} Mult#{{REG_CChips}}+50{{CR}} Chips"


----------------------------------------
-------------####SPECTRALS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{REG_Jimbo}} {{REG_Yellow}}Destroys{{CR}} one random card from your hand and adds {{REG_Yellow}}3{{CR}} random {{REG_Face}} {{REG_Yellow}}Enhanced Face cards{{CR}} to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.GRIM] = "{{REG_Jimbo}} {{REG_Yellow}}Destroys{{CR}} one random card from your hand and adds {{REG_Yellow}}2{{CR}} random {{REG_Yellow}}Enhanced Aces cards{{CR}} to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{REG_Jimbo}} {{REG_Yellow}}Destroys{{CR}} one random card from your hand and adds {{REG_Yellow}}4{{CR}} random {{REG_Yellow}}Enhanced Numbered cards{{CR}} to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.TALISMAN] = "{{REG_Jimbo}} Put a {{REG_Yellow}}Golden Seal{{CR}} on a selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.AURA] = "{{REG_Jimbo}} Give a random {{REG_Yellow}}Edition{{CR}} to a selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.WRAITH] = "{{REG_Jimbo}} Sets coins held to {{REG_Yellow}}0 #{{REG_Joker}} Gain a random {{REG_CMult}}Rare Joker{{CR}}#{{IND}}!!! Requires inventroy space"
Descriptions.Jimbo.Consumables[mod.Spectrals.SIGIL] = "{{REG_Jimbo}} Turns all the cards in your hand to the same random {{REG_Yellow}}Suit"
Descriptions.Jimbo.Consumables[mod.Spectrals.OUIJA] = "{{REG_Jimbo}} Turns all the cards in your hand to the same random {{REG_Yellow}}Rank"
Descriptions.Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "{{REG_Jimbo}} Turns a random Joker {{ColorGray}}{{ColorFade}}Negative #{{IND}}!!! Can't replace existing editions #{{REG_HSize}} {{ColorRed}}-1{{CR}} Hand Size #{{IND}}!!! No effect if Hand Size can't be lowered"
Descriptions.Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "{{REG_Jimbo}} {{REG_Yellow}}Destroys{{CR}} up to {{REG_Yellow}}3{{CR}} cards in your hand #{{Coin}} Earn {{REG_Yellow}}4${{CR}} per card destroyed"
Descriptions.Jimbo.Consumables[mod.Spectrals.ANKH] = "{{REG_Jimbo}} Gives a copy a of random Joker held and destroys all the others #!!! Removes the {{ColorGray}}{{ColorFade}}Negative{{CR}} Edition from the copied Joker"
Descriptions.Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "{{REG_Jimbo}} Put a {{ColorRed}}Red Seal{{CR}} on a selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.HEX] = "{{REG_Jimbo}} Gives the {{ColorRainbow}}Polychrome{{CR}} Edition to random Joker held and destroys all the others"
Descriptions.Jimbo.Consumables[mod.Spectrals.TRANCE] = "{{REG_Jimbo}} Put a {{ColorCyan}}Blue Seal{{CR}} on a selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.MEDIUM] = "{{REG_Jimbo}} Put a {{ColorPink}}Purple Seal{{CR}} on a selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.CRYPTID] = "{{REG_Jimbo}} Add {{REG_Yellow}}2{{CR}} copies of a selected card to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "{{REG_Jimbo}} {{REG_Yellow}}All Cards{{CR}} triggered give an additional {{REG_CChips}}+0.02{{CR}}Tears and {{REG_CMult}}+0.02su una carta selezionata Damage"
Descriptions.Jimbo.Consumables[mod.Spectrals.SOUL] = "{{REG_Jimbo}} Gives a random {{ColorRainbow}}Legendary{{CR}} Joker#{{IND}}!!! Requires an empty Inventory slot"



Descriptions.T_Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{REG_Yellow}}Destroy{{CR}} a random card, adds {{REG_Yellow}}3{{CR}} random {{REG_Yellow}}Enhanced Face{{CR}} cards to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.GRIM] = "{{REG_Yellow}}Destroy{{CR}} a random card, adds {{REG_Yellow}}2{{CR}} random {{REG_Yellow}}Enhanced Aces{{CR}} to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{REG_Yellow}}Destroy{{CR}} a random card, adds {{REG_Yellow}}4{{CR}} random {{REG_Yellow}}Enhanced Numbered cards{{CR}} to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TALISMAN] = "Put a {{REG_Yellow}}Golden Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.AURA] = "Give a random {{REG_Yellow}}Edition{{CR}} to a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.WRAITH] = "Set your money to {{REG_Yellow}}0$, creates a random {{REG_CMult}}Rare{{CR}} Joker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SIGIL] = "Turns all cards in your hand to the same random {{REG_Yellow}}Suit"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.OUIJA] = "Turns all cards in your hand to the same random {{REG_Yellow}}Rank#{{REG_CMult}}-1{{CR}} Hand size"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "Turns a random Joker {{REG_CSpade}}Negative#{{ColorRed}}-[[VALUE1]]{{CR}} Hand size"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "Destroys {{REG_Yellow}}5{{CR}} cards from your hand and earn {{REG_Yellow}}20$"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ANKH] = "Duplicates a random {{REG_Yellow}}Joker{{CR}}, destroys all others [[VALUE1]]"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "Put a {{ColorRed}}Red Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.HEX] = "Turns a random Joker {{ColoorRainbow}}Polychrome{{CR}} and destroys all the others"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TRANCE] = "Put a {{ColorCyan}}Blue Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.MEDIUM] = "Put a {{ColorPink}}Purple Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.CRYPTID] = "Adds {{REG_Yellow}}2{{CR}} copies of a selected card to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "Level up all {{REG_Yellow}}Poker hands"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SOUL] = "Creates a random {{ColorRainbow}}Legendary{{CR}} Joker"


---------------------------------------
--------------BOOSTERS-----------------
---------------------------------------

Descriptions.Jimbo.Boosters = {}
Descriptions.Jimbo.Boosters[mod.Packs.ARCANA] = "Choose 1 {{ColorPink}}Tarot{{CR}} card out of {{REG_Yellow}}3{{CR}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{CR}} card out of {{REG_Yellow}}3{{CR}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.STANDARD] = "Choose 1 {{REG_Yellow}}Playing{{CR}} card out of {{REG_Yellow}}3{{CR}} to add to your deck"
Descriptions.Jimbo.Boosters[mod.Packs.BUFFON] = "Choose 1 {{REG_Yellow}}Joker{{CR}} out of {{REG_Yellow}}2{{CR}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Choose 1 {{ColorBlue}}Spectral{{CR}} card out of {{REG_Yellow}}2{{CR}} to get immediantly"



Descriptions.T_Jimbo.Boosters = {}
Descriptions.T_Jimbo.Boosters[mod.Packs.ARCANA] = "Choose 1 {{ColorPink}}Tarot{{CR}} card out of {{REG_Yellow}}3{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_ARCANA] = "Choose 1 {{ColorPink}}Tarot{{CR}} card out of {{REG_Yellow}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_ARCANA] = "Choose up to 2 {{ColorPink}}Tarot{{CR}} card out of {{REG_Yellow}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{CR}} card out of {{REG_Yellow}}3{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{CR}} card out of {{REG_Yellow}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_CELESTIAL] = "Choose up to 2 {{ColorCyan}}Planet{{CR}} card out of {{REG_Yellow}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.STANDARD] = "Choose 1 {{REG_Yellow}}Playing{{CR}} card out of {{REG_Yellow}}3{{CR}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_STANDARD] = "Choose 1 {{REG_Yellow}}Playing{{CR}} card out of {{REG_Yellow}}5{{CR}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_STANDARD] = "Choose up to 2 {{REG_Yellow}}Playing{{CR}} card out of {{REG_Yellow}}5{{CR}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.BUFFON] = "Choose 1 {{REG_Yellow}}Joker{{CR}} out of {{REG_Yellow}}2{{CR}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_BUFFON] = "Choose 1 {{REG_Yellow}}Joker{{CR}} out of {{REG_Yellow}}4{{CR}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_BUFFON] = "Choose up to 2 {{REG_Yellow}}Joker{{CR}} out of {{REG_Yellow}}4{{CR}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Choose 1 {{ColorBlue}}Spectral{{CR}} card out of {{REG_Yellow}}2{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_SPECTRAL] = "Choose 1 {{ColorBlue}}Spectral{{CR}} card out of {{REG_Yellow}}4{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_SPECTRAL] = "Choose up to 2 {{ColorBlue}}Spectral{{CR}} card out of {{REG_Yellow}}4{{CR}} to use immediantly"



----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------

Descriptions.T_Jimbo.Vouchers = {}

Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber] = "{{REG_CChips}}+1{{CR}} Hand every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.NachoTong] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful] = "{{REG_CMult}}+1{{CR}} discard every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Recyclomancy] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush] = "{{REG_CChips}}+1{{CR}} Hand size"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Palette] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Clearance] = "Everything in the shop is {{REG_Yellow}}25% off#{{ColorGray}}(rounded down)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Liquidation] = "Everything in the shop is {{REG_Yellow}}50% off#{{ColorGray}}(rounded down)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock] = "{{REG_Yellow}}+1{{CR}} Item available in the shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.OverstockPlus] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hone] = "Special {{ColorRainbow}}Editions{{CR}} are {{REG_Yellow}}2X{{CR}} more likely to appear"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.GlowUp] = "Special {{ColorRainbow}}Editions{{CR}} are {{REG_Yellow}}4X{{CR}} more likely to appear"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollSurplus] = "{{REG_Mint}}Rerolls{{CR}} cost {{REG_Yellow}}2${{CR}} less"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollGlut] = "{{REG_Mint}}Rerolls{{CR}} cost and additional {{REG_Yellow}}2${{CR}} less"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Crystal] = "{{REG_Yellow}}+1{{CR}} consumable slot"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Omen] = "{{ColorBlue}}Spectral{{CR}} cards may appear in {{REG_Yellow}}Arcana Packs"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Telescope] = "{{REG_Yellow}}Celestial Packs{{CR}} always contain the {{colorCyan}}Planet{{CR}} for your most played poker hand"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Observatory] = "{{ColorCyan}}Planets{{CR}} you hold give {{REG_CMult}}X1.5{{CR}} Molt for their respective Poker hand"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotMerch] = "{{ColorPink}}Tarot{{CR}} cards appear{{REG_Yellow}}2X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotTycoon] = "{{ColorPink}}Tarot{{CR}} cards appear{{REG_Yellow}}4X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetMerch] = "{{ColorCyan}}Planet{{CR}} cards appear{{REG_Yellow}}2X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetTycoon] = "{{ColorCyan}}Planet{{CR}} cards appear{{REG_Yellow}}4X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneySeed] = "Raise the Interest cap to {{REG_Yellow}}10$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneyTree] = "Raise the Interest cap to {{REG_Yellow}}20$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Blank] = "{{ColorGray}}Does nothing?"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Antimatter] = "{{REG_CSpade}}+1{{CR}} Joker slot"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MagicTrick] = "{{REG_Yellow}}Playing cards{{CR}} can appear in shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Illusion] = "{{REG_Yellow}}Playing cards{{CR}} in shop can have {{REG_Yellow}}Enhancements{{CR}},{{REG_Yellow}}Editions{{CR}} and/or {{REG_Yellow}}Seals"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hieroglyph] = "{{REG_Yellow}}-1{{CR}} Ante#{{REG_CChips}}-1{{CR}} Hand every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Petroglyph] = "{{REG_Yellow}}-1{{CR}} Ante#{{REG_CMult}}-1{{CR}} Discard every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Director] = "{{ColorPink}}Reroll{{CR}} boss blind {{REG_Yellow}}Once{{CR}} per Ante#({{REG_Yellow}}10${{CR}} per reroll)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Retcon] = "{{ColorPink}}Reroll{{CR}} boss blind {{REG_Yellow}}Unlimited{{CR}} times per Ante#({{REG_Yellow}}10${{CR}} per reroll)"


    EID:addCollectible(mod.Vouchers.Grabber, "{{REG_Jimbo}} {{REG_CChips}}+5{{CR}} {{REG_Hand}} playable cards every room", "Grabber", FileLanguage)
    EID:addCollectible(mod.Vouchers.NachoTong, "{{REG_Jimbo}} {{REG_CChips}}+5{{CR}} {{REG_Hand}} playable cards every room", "Nacho Tong", FileLanguage)

    EID:addCollectible(mod.Vouchers.Wasteful, "{{REG_Jimbo}} {{REG_CMult}}+1{{CR}} {{Heart}} Health up #{{Heart}} Full health", "Wasteful", FileLanguage)
    EID:addCollectible(mod.Vouchers.Recyclomancy, "{{REG_Jimbo}} {{REG_CMult}}+1{{CR}} {{Heart}} Health up #{{Heart}} Full health", "Recyclomancy", FileLanguage)

    EID:addCollectible(mod.Vouchers.Overstock, "{{REG_Jimbo}} Every future shop will have 1 additional {{REG_Joker}} Joker for sale", "Overstock", FileLanguage)
    EID:addCollectible(mod.Vouchers.OverstockPlus, "{{REG_Jimbo}} Every future shop will have 1 additional {{REG_Joker}} Joker for sale", "Overstock Plus", FileLanguage)

    EID:addCollectible(mod.Vouchers.Clearance, "{{REG_Jimbo}} Everything is discounted by {{REG_Yellow}}25% #{{IND}}!!! Prices are rounded down", "Clearance Sale", FileLanguage)
    EID:addCollectible(mod.Vouchers.Liquidation, "{{REG_Jimbo}} Everything is discounted by {{REG_Yellow}}50% #{{IND}}!!! Prices are rounded down", "Liquidation", FileLanguage)

    EID:addCollectible(mod.Vouchers.Hone, "{{REG_Jimbo}} Special {{ColorRainbow}}Editions{{CR}} are {{REG_Yellow}}2x{{CR}} more likely to appear", "Hone", FileLanguage)
    EID:addCollectible(mod.Vouchers.GlowUp, "{{REG_Jimbo}} Special {{ColorRainbow}}Editions{{CR}} are {{REG_Yellow}}4x{{CR}} more likely to appear", "Glow Up", FileLanguage)

    EID:addCollectible(mod.Vouchers.RerollSurplus, "{{REG_Jimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{REG_Yellow}}1{{CR}} {{Coin}} Coin", "Reroll Surplus", FileLanguage)
    EID:addCollectible(mod.Vouchers.RerollGlut, "{{REG_Jimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{REG_Yellow}}2{{CR}} {{Coin}} Coins", "Reroll Glut", FileLanguage)

    EID:addCollectible(mod.Vouchers.Crystal, "{{REG_Jimbo}} Every {{REG_Yellow}}Booster Pack{{CR}} has {{REG_Yellow}}1{{CR}} more option to choose from", "Crystal Ball", FileLanguage)
    EID:addCollectible(mod.Vouchers.Omen, "{{REG_Jimbo}} {{ColorPink}}Arcana Packs{{CR}} may contain {{ColorBlue}}Spectral{{CR}} cards", "Omen Globe", FileLanguage)

    EID:addCollectible(mod.Vouchers.Telescope, "{{REG_Jimbo}} Skipping a {{ColorCyan}}Celestial Pack{{CR}} creates {{REG_Yellow}}2{{CR}} additional random {{REG_Planet}} {{ColorCyan}}Planet Cards", "Telescope", FileLanguage)
    EID:addCollectible(mod.Vouchers.Observatory, "{{REG_Jimbo}} Cards give {{Damage}}{{REG_CMult}} X1.15{{CR}} Damage Mult. when triggered if their respective {{ColorCyan}}Planet Card{{CR}} id held #{{IND}}{{Planetarium}} Having the respective Planetarium item also counts", "Observatory", FileLanguage)

    EID:addCollectible(mod.Vouchers.Blank, "{{REG_Jimbo}} {{ColorFade}}Nothing?", "Blank", FileLanguage)
    EID:addCollectible(mod.Vouchers.Antimatter, "{{REG_Jimbo}} {{REG_Yellow}}+1{{CR}} {{REG_Joker}} Joker Slot", "Antimatter", FileLanguage)

    EID:addCollectible(mod.Vouchers.Brush, "{{REG_Jimbo}} {{REG_CChips}}+1{{CR}} {{REG_HSize}} Hand Size", "Brush", FileLanguage)
    EID:addCollectible(mod.Vouchers.Palette, "{{REG_Jimbo}} {{REG_CChips}}+1{{CR}} {{REG_HSize}} Hand Size", "Palette", FileLanguage)

    EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Rerolls all pedestal items in the room for 5 coins", "Director's Cut", FileLanguage)
    EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Triggers the {{Collectible283}} D100 effect for 5 coins", "Retcon", FileLanguage)

    EID:addCollectible(mod.Vouchers.Hieroglyph, "{{REG_Retrigger}} Restarts the current floor on pickup", "Hieroglyph", FileLanguage)
    EID:addCollectible(mod.Vouchers.Petroglyph, "{{REG_Retrigger}} Restarts the current floor on pickup", "Petroglyph", FileLanguage)

    EID:addCollectible(mod.Vouchers.MagicTrick, "{{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} for packs to let the player choose an extra option after the previous one #{{IND}} Can trigger Multiple times", "Magic Trick", FileLanguage)
    EID:addCollectible(mod.Vouchers.Illusion, "{{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} for a pack to contain {{REG_Yellow}}2{{CR}} extra options #{{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} for packs to let the player choose {{REG_Yellow}}1{{CR}} more option", "Illusion", FileLanguage)

    EID:addCollectible(mod.Vouchers.MoneySeed, "{{REG_Jimbo}} Maximum interest increased to {{REG_Yellow}}10{{CR}} {{Coin}} Coins", "Money Seed", FileLanguage)
    EID:addCollectible(mod.Vouchers.MoneyTree, "{{REG_Jimbo}} Maximum interest increased to {{REG_Yellow}}20{{CR}} {{Coin}} Coins", "Money Tree", FileLanguage)

    EID:addCollectible(mod.Vouchers.PlanetMerch, "{{REG_Planet}} Every pickup has a {{REG_Mint}}[[CHANCE]] in 15 Chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card", "Planet Merchant", FileLanguage)
    EID:addCollectible(mod.Vouchers.PlanetTycoon, "{{REG_Planet}} Every pickup has an additional {{REG_Mint}}[[CHANCE]] in 10 Chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card", "Planet Tycoon", FileLanguage)

    EID:addCollectible(mod.Vouchers.TarotMerch, "{{Card}} Every pickup has a {{REG_Mint}}[[CHANCE]] in 15 Chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card", "Tarot Merchant", FileLanguage)
    EID:addCollectible(mod.Vouchers.TarotTycoon, "{{Card}} Every pickup has an additional {{REG_Mint}}[[CHANCE]] in 10 Chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card", "Tarot Tycoon", FileLanguage)


    Descriptions.PackSynergies = {}
    Descriptions.PackSynergies[mod.Vouchers.Crystal] = "#{{Collectible"..mod.Vouchers.Crystal.."}} {{REG_Yellow}}+1{{CR}} available option"
    Descriptions.PackSynergies[mod.Vouchers.Omen] = "#{{Collectible"..mod.Vouchers.Omen.."}} May contain {{ColorBlue}}Spectral cards{{CR}}"
    Descriptions.PackSynergies[mod.Vouchers.Telescope] = "#{{Collectible"..mod.Vouchers.Telescope.."}} If options are skipped, spawns 2 additional {{ColorCyan}}Planet cards"
    Descriptions.PackSynergies[mod.Vouchers.MagicTrick] = "#{{Collectible"..mod.Vouchers.MagicTrick.."}} When a choice is taken, {{REG_Mint}}[[CHANCE]] in 4 Chance{{CR}} to allow an additional one"
    Descriptions.PackSynergies[mod.Vouchers.Illusion] = "#{{Collectible"..mod.Vouchers.Illusion.."}} {{REG_Mint}}[[CHANCE]] in 2 Chance{{CR}} to have {{REG_Yellow}}+1{{CR}} available option #{{Collectible"..mod.Vouchers.Illusion.."}} {{REG_Mint}}[[CHANCE]] in 5 Chance{{CR}} to allow an extra choice"






-------------------------------------
---------------MAIN GAME-------------
-------------------------------------

EID:addCard(mod.Packs.ARCANA, "{{Card}} Allows to choose 1 out of 3 {{ColorPink}}Tarot cards{{CR}} to get immediantly", "Arcana Pack", FileLanguage)
EID:addCard(mod.Packs.CELESTIAL, "{{REG_Planet}} Allows to choose 1 out of 3 {{ColorCyan}}Planet cards{{CR}} to get immediantly", "Celestial Pack", FileLanguage)
EID:addCard(mod.Packs.SPECTRAL, "{{REG_Spectral}} Allows to choose 1 out of 3 {{ColorBlue}}Spectral cards{{CR}} to get immediantly", "Spectral Pack", FileLanguage)
EID:addCard(mod.Packs.BUFFON, "{{REG_Joker}} Allows to choose 1 out of 3 {{REG_Yellow}}Jokers{{CR}} to get immediantly #!!! {{ColorGray}}(Does not require space)", "Buffon Pack", FileLanguage)
EID:addCard(mod.Packs.STANDARD, "{{REG_HSize}} Allows to choose 1 out of 3 {{REG_Yellow}}Playing cards{{CR}} to get immediantly", "Standard Pack", FileLanguage)


EID:addCollectible(mod.Collectibles.BALOON_PUPPY, "Familiar that reflects enemy shots and deals 7.5 contact damage per second #After taking enough hits, explodes dealing {{REG_Yellow}}3 x Isaac's Damage{{CR}} to nerby enemies #If Isaac takes damage, starts chasing down enemies", "Baloon Puppy",FileLanguage)		
EID:addCollectible(mod.Collectibles.BANANA, "Aim and shoot a devastating banana that creates a {{Collectible483}} Mama Mega! explosion upon landing #!!! Upon use becomes {{Collectible"..mod.Collectibles.EMPTY_BANANA.."}} Empty Banana", "Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.EMPTY_BANANA, "Leaves a banana peel on the ground #Enemies can slip on the peels, taking damage and becoming {{Confusion}} confused #{{IND}} Damage dealt scales with how fast the enemies were moving", "Empty Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.CLOWN, "50% of enemies get either the {{Charm}} Charm or {{Fear}} Fear effect applied when standing close to Isaac", "Clown Costume",FileLanguage)		
EID:addCollectible(mod.Collectibles.CRAYONS, "While moving, create a trail of crayon dust that applies various status effects #{{IND}} Effect applied changes basing the dust's color #Dust color changes every new room", "Box of Crayons",FileLanguage)		
EID:addCollectible(mod.Collectibles.FUNNY_TEETH, "Familiar that chases enemies dealing 22.5 damage per second #{{IND}}Damage dealt raises slightly basing on current floor #{{Chargeable}} After being active for some time needs to be recharged by standing near it ", "Funny Teeth",FileLanguage)		
EID:addCollectible(mod.Collectibles.HORSEY, "Familiar that jumps in an L pattern, creating damaging shockwaves upon landing #{{IND}}!!! The shockwaves cannot hurt Isaac", "Horsey",FileLanguage)		
EID:addCollectible(mod.Collectibles.LAUGH_SIGN, "An audience reacts live to Isaac's actions #{{BossRoom}} Clearing a boss room rewards with random pickups #Taking damage launches tomatoes that leave a damaging creep and apply {{Bait}} Bait upon landing", "Laugh Sign",FileLanguage)		
EID:addCollectible(mod.Collectibles.LOLLYPOP, "{{Timer}} A lollypop spawns on the ground every 18 seconds spent in an uncleared room #{{Collectible93}} Picking up the lollypops grants the Gamekid! effect for 4 seconds #!!! A maximum of 3 lollypops can be on the ground at once", "Lollypop",FileLanguage)		
EID:addCollectible(mod.Collectibles.POCKET_ACES, "{{Luck}} Tears have an 8% Chance to become Ace cards #Ace cards deal the product of Isaac's {{Damage}} Damage and {{Tears}} Tears stat worth of damage", "Pocket Aces",FileLanguage)		
EID:addCollectible(mod.Collectibles.TRAGICOMEDY, "40% Chance to wear a {{REG_Comedy}} comedy or {{REG_Tragedy}} tragedy mask on room clear #{{IND}}!!! Both can be worn at once #{{REG_Comedy}} The comedy mask grants: #{{IND}}{{Tears}} +1 Firedelay #{{IND}}{{Speed}} +0.2 Speed  #{{IND}}{{Luck}} +3 Luck #{{REG_Tragedy}} The tragedy mask grants: #{{IND}}{{Tears}} +0.5 Firedelay,  #{{IND}}{{Damage}} +1.5 Flat Damage #{{IND}}{{Range}} +2.5 Range", "Tragicomedy",FileLanguage)		
EID:addCollectible(mod.Collectibles.UMBRELLA, "On use Isaac opens an umbrella, causing avils to fall on top of him every 5 ~ 7 seconds #{{IND}} Anvils create shockwaves upon landing #{{IND}} Anvils can be reflected by the umbrella, sending them thorwards a near enemy #{{IND}}!!! Shockwaves only hurt Isaac if the anvil wasn't reflected #!!! Using the item again closes the umbrella and stops the anvils from falling", "Umbrella",FileLanguage)		

for i = 1, Balatro_Expansion.TastyCandyNum do --puts every candy stage

    EID:addTrinket(Balatro_Expansion.Trinkets.TASTY_CANDY[i], "{{Beggar}} Guarantees a payout when interacting with any beggar #!!! Uses left: {{REG_Yellow}}"..i, "Tasty Candy", FileLanguage)		
    EID:addGoldenTrinketMetadataAdditive(mod.Trinkets.TASTY_CANDY[i], "{{ColorGold}}33% to not lose durability when used", nil, nil, FileLanguage)
end

EID:addCharacterInfo(mod.Characters.JimboType, "#Cards shot from your {{REG_HSize}} hand can be scored a limited amount of times per room or until the deck is reshuffled #Stats gained this way are reset every room cleared #Discard your hand by taking damage #Normal Hp ups taken are transformed into {{ColorYellornage}}booster packs #{{Shop}} Clear a blind by entering a {{REG_Yellow}}shop{{CR}} or defeating the floor's {{REG_Yellow}}boss{{CR}}, earning coins and interets #Skipping blinds by going to the next floor awards with free {{REG_Yellow}}booster packs{{CR}}", "Jimbo", FileLanguage)
EID:addBirthright(mod.Characters.JimboType, "{{REG_Joker}} +1 {{REG_Yellow}}Joker slot", "Jimbo", FileLanguage)

EID:addCollectible(mod.Collectibles.HEIRLOOM, "{{Coin}} All coins have a Chance to get their value upgraded #{{Coin}} All pickups have a 7.5% chance to turn into their golden variant", "Heirloom",FileLanguage)		
EID:addTrinket(mod.Trinkets.PENNY_SEEDS, "{{Coin}} Gain 1 coin per 5 coin isaac has every floor #Very low Chance for the coins spawned to be a penny trinket or {{Collectible74}} The quarter", "Penny Seeds",FileLanguage)		
EID:addCollectible(mod.Collectibles.THE_HAND, "{{Card}} Up to 5 cards or runes can be stored in the active item #!!! Cards in excess will be destroyed #{{Chargeable}} Holding the item uses the cards stored in the order shown # Press [DROP] key to cycle the held cards # Also collects pickups and deals damage to enemies hit", "The Hand",FileLanguage)		
EID:addCard(mod.JIMBO_SOUL, "{{Timer}} For the current Room, balances Isaac's Damage and Tears stats #{{Blank}} {{ColorGray}}(Effect lasts longer if used multiple times)", "Soul of Jimbo", FileLanguage)
EID:addTrinket(mod.Jokers.CHAOS_THEORY, "{{Collectible402}} All pickups spawned are randomised", "Chaos Theory", FileLanguage)		
EID:addCollectible(mod.Collectibles.ERIS, "{{Freezing}} Isaac gains a freezing aura that progressively slows enemies #After being slowed enough, non-boss enemies lose 4% of their current hp every tick {{ColorGray}}(Min. 0.1) #{{IND}}{{Freezing}} Enemies killed while in this state are become frozen statues", "Eris",FileLanguage)		
EID:addCollectible(mod.Collectibles.PLANET_X, "{{Planetarium}} Gain the effect of a random Planetarium item every room clear", "Planet X",FileLanguage)		
EID:addCollectible(mod.Collectibles.CERES, "Orbiting familiar that blocks projectiles and deals 1 contact damage per second #When hit, creates asteroid bits that can block up to 2 shots and deal twice Isaac's damage", "Ceres",FileLanguage)		

EID:addGoldenTrinketMetadataAdditive(mod.Trinkets.PENNY_SEEDS, "{{ColorGold}}Coins spawned can be of any kind #{{ColorGold}}5% chance for trinkets spawned to be golden #{{IND}}!!! {{ColorGray}}(Golden variants need to be unlocked to appear)", nil, nil, FileLanguage)
EID:addGoldenTrinketMetadataAdditive(mod.Jokers.CHAOS_THEORY, "{{ColorGold}}Also gives the {{Collectible402}} Chaos effect", nil, nil, FileLanguage)



Descriptions.ItemItemSynergies = {}
Descriptions.ItemItemSynergies[mod.Collectibles.FUNNY_TEETH] = {[CollectibleType.COLLECTIBLE_APPLE] = "# Also leaves a trail of damaging creep",
                                                                [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = "# Partially regains charge when killing an enemy",
                                                                [CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = "# Chance to apply random status effects",
                                                                [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = "# Chance to apply {{Bait}} Bait to enemies",
                                                                [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Chance to {{Coin}} Goldify enemies",
                                                                [CollectibleType.COLLECTIBLE_DEAD_TOOTH] = "# Chance to {{Poison}} Poison enemies",
                                                                [CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = "# Chance to heal its owner for {{HalfHeart}} half red heart when killing an enemy",
                                                                [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Chance to {{Poison}} Poison enemies #Chance to drop a {{BlackHeart}} black heart on every kill",
                                                                [CollectibleType.COLLECTIBLE_DOG_TOOTH] = "# Gains more speed and damage",
                                                                [CollectibleType.COLLECTIBLE_TOUGH_LOVE] = "# Deals 35% more damage",
                                                                [CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = "# When recharged, fires a smaller {{Collectible399}} Maw of the void ring"}
Descriptions.ItemItemSynergies[mod.Collectibles.CLOWN] = {[CollectibleType.COLLECTIBLE_BOZO] = "# All enemies are affected",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.HORSEY] = {[CollectibleType.COLLECTIBLE_BFFS] = "# Increased shockwave range",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.TRAGICOMEDY] = {[CollectibleType.COLLECTIBLE_POLAROID] = "# The {{REG_Comedy}} comedy mask is always active",
                                                                [CollectibleType.COLLECTIBLE_SOCKS] = "# The {{REG_Comedy}} comedy mask is always active",
                                                                [CollectibleType.COLLECTIBLE_NEGATIVE] = "# The {{REG_Tragedy}} tragedy mask is always active",
                                                                [CollectibleType.COLLECTIBLE_DUALITY] = "# Both masks are always active",
                                                                }
Descriptions.ItemItemSynergies[mod.Collectibles.HEIRLOOM] = {[CollectibleType.COLLECTIBLE_TELEKINESIS] = "# Gain {{Collectible2}} Homing shots",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.THE_HAND] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Shoots a wisp per card held when swung",
                                                             [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Deals +0.25 damage per {{Coin}} coin held # Chance to turn enemies hit in golden statues",
                                                             [CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = "# Doubles damage dealt to enemies and increases the knockback strength",
                                                             [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Chance to {{Poison}} poinson enemies hit",
                                                             [CollectibleType.COLLECTIBLE_VIRUS] = "# Chance to {{Poison}} poinson enemies hit",
                                                             [CollectibleType.COLLECTIBLE_TELEKINESIS] = "# Deflects projectiles hit",
                                                             [mod.Collectibles.THE_HAND] = "# 5 more cards can be held at once",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.BANANA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Create 8 wisps with high Chance to shoot explosive tears"}
Descriptions.ItemItemSynergies[mod.Collectibles.EMPTY_BANANA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# 2 wisps orbit the peels thrown"}
Descriptions.ItemItemSynergies[mod.Collectibles.UMBRELLA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Gain an outer ring wisp with Chance of {{Confsion}} concussing tears per anvil fallen",
                                                             [mod.Collectibles.UMBRELLA] = "# All umbrellas are opened at the same time, increasing the anvils falling and the cover's size"}
Descriptions.ItemItemSynergies[mod.Vouchers.Director] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Creates outer ring wisps that devolve enemies on contact"}
Descriptions.ItemItemSynergies[mod.Vouchers.Retcon] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Creates outer ring wisps that devolve enemies on contact"}




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
Descriptions.TrinketItemSynergies[TrinketType.TRINKET_ICE_CUBE] = {[mod.Collectibles.CERES] = "Bigger effect radius and faster slowing speed"}

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
                               [mod.Edition.FOIL] = "#{{Tears}} {{REG_CChips}}+1{{CR}} Fire rate",
                               [mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{REG_CMult}}+1.5{{CR}} Flat Damage",
                               [mod.Edition.POLYCROME] = "#{{Damage}} {{REG_CMult}}x1.2{{CR}} Damage Mult.",
                               [mod.Edition.NEGATIVE] = "#{{Collectible479}} Immediantly smelted when picked up"
                             }



end --END EID EXCLUSIVES

return Descriptions