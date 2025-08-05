---@diagnostic disable: param-type-mismatch
local mod = Balatro_Expansion


local FileLanguage = "en_us" --REMEMBER TO MODIFY ME!!
local Descriptions = {}

Descriptions.Other = {} 
Descriptions.Other.Name = "Inventory Helper"
Descriptions.Other.LV = "LV." --abbreviation of LEVEL

Descriptions.Other.ConfirmName = "{{ColorSilver}}Confirm{{CR}}"
Descriptions.Other.ConfirmDesc = "Confirm the current card selection as is"

Descriptions.Other.SkipName = "{{ColorSilver}}Skip{{CR}}"
Descriptions.Other.SkipDesc = "Skip the remaining pack options"

Descriptions.Other.SellJoker = "Sell the selected joker"
Descriptions.Other.SellsFor = "Sells for" --sells for x amount of money

Descriptions.Other.Exit = "Exit overview"

Descriptions.Other.Nothing = "Nothing"
Descriptions.Other.EmptySlot = "This slot's empty!"

Descriptions.Other.Currently = "Currently:"
Descriptions.Other.CompatibleTriggered = "Compatible cards triggered: "
Descriptions.Other.CompatibleDiscarded = "Compatible cards discarded: "
Descriptions.Other.SuitChosen = "Suit chosen: "
Descriptions.Other.CardChosen = "Card chosen: "
Descriptions.Other.ValueChosen = "Value chosen: "
Descriptions.Other.HandTypeChosen = "Hand Type chosen: "
Descriptions.Other.RoomsRemaining = "Rooms remaining: "
Descriptions.Other.BlindsCleared = "Blinds cleared: "
Descriptions.Other.DiscardsRemaining = "Discards remaining: "



Descriptions.Other.Active = "{{ColorYellorange}}Active!{{CR}}"
Descriptions.Other.Compatible = "{{ColorLime}}Compatible{{CR}}"
Descriptions.Other.Incompatible = "{{ColorMult}}Incompatible{{CR}}"
Descriptions.Other.Ready = "{{ColorYellorange}}Ready!{{CR}}"
Descriptions.Other.NotReady = "{{ColorRed}}Not ready!{{CR}}"

Descriptions.Other.HandSize = "Hand Size" --as in the Balatro stat


Descriptions.HandTypeName = {[mod.HandTypes.NONE] = "None",
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
Descriptions.EnhancementName[mod.Enhancement.STONE] = "{{ColorGray}}Stone Card{{CR}}"



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
Descriptions.Rarity["common"] = "{{ColorCyan}}common{{CR}}"
Descriptions.Rarity["uncommon"] = "{{ColorLime}}uncommon{{CR}}"
Descriptions.Rarity["rare"] = "{{ColorRed}}rare{{CR}}"
Descriptions.Rarity["legendary"] = "{{ColorRainbow}}legendary{{CR}}"


Descriptions.Seal = {}
Descriptions.Seal[mod.Seals.NONE] = ""
Descriptions.Seal[mod.Seals.RED] = "# {{ColorRed}}Red Seal{{CR}}: This card's abilities are {{ColorYellorange}}Triggered one more time{{CR}}"
Descriptions.Seal[mod.Seals.BLUE] = "# {{ColorCyan}}Blue Seal{{CR}}: Holding this when a Blind is{{ColorYellorange}} Cleared{{CR}} spawns the card's respective {{ColorCyan}}Planet Card{{CR}}"
Descriptions.Seal[mod.Seals.GOLDEN] = "# {{ColorYellorange}}Golden Seal{{CR}}: {{ColorYellorange}}Triggering{{CR}} this card spawn a {{Coin}} Penny which disappears soon after if not taken"
Descriptions.Seal[mod.Seals.PURPLE] = "# {{ColorPink}}Purple Seal{{CR}}: {{ColorRed}}Discarding{{CR}} spawns a random {{ColorPink}}Tarot Card{{CR}} #!!! Lower chance for the effect to occur if multiple are discarded {{ColorYellorange}}at the same time{{CR}}"

Descriptions.CardEdition = {}
Descriptions.CardEdition[mod.Edition.BASE] = ""
Descriptions.CardEdition[mod.Edition.FOIL] = "# {{ColorChips}}Foil{{CR}}: Gives {{ColorChips}}+1.25 Tears{{CR}} when triggered"
Descriptions.CardEdition[mod.Edition.HOLOGRAPHIC] = "# {{ColorMult}}Holographic{{CR}}: Gives {{ColorMult}}+0.25 Damage{{CR}} when triggered"
Descriptions.CardEdition[mod.Edition.POLYCROME] = "# {{ColorRainbow}}Polychrome{{CR}}: Gives {{ColorMult}}x1.2 Damage Multiplier{{CR}} when triggered"
Descriptions.CardEdition[mod.Edition.NEGATIVE] = "# {{ColorGray}}{{ColorFade}}Negative{{CR}}: wtf how did you even get this"


Descriptions.JokerEdition = {}
Descriptions.JokerEdition[mod.Edition.NOT_CHOSEN] = ""
Descriptions.JokerEdition[mod.Edition.BASE] = ""
Descriptions.JokerEdition[mod.Edition.FOIL] = "# {{ColorChips}}Foil{{CR}}: Gives {{ColorChips}}+2.5 Tears{{CR}} while held"
Descriptions.JokerEdition[mod.Edition.HOLOGRAPHIC] = "# {{ColorMult}}Holographic{{CR}}: Gives {{ColorMult}}+0.5 Damage{{CR}} while held"
Descriptions.JokerEdition[mod.Edition.POLYCROME] = "# {{ColorRainbow}}Polychrome{{CR}}: Gives {{ColorMult}}x1.25 Damage Multiplier{{CR}} while held"
Descriptions.JokerEdition[mod.Edition.NEGATIVE] = "# {{ColorGray}}{{ColorFade}}Negative{{CR}}: {{ColorYellorange}}+1 Joker Slot{{CR}} while held"


Descriptions.Jimbo = {}
Descriptions.T_Jimbo = {}

----------------------------------------
-------------####JOKERS####-------------
-----------------------------------------

--EID:addTrinket(mod.Jokers.JOKER, "\1 {{ColorMult}}+1.2{{CR}} Damage", "Joker", FileLanguage)

Descriptions.Jimbo.Jokers = {}
do
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER] = "{{PlayerJimbo}} {{ColorMult}}+0.2{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.BULL] = "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.15 {{CR}}Tears for every {{Coin}} coin held"
Descriptions.Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "{{PlayerJimbo}} Selling this joker after clearing 3 Blinds while holding it gives a copy of another held Joker"
Descriptions.Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.15 {{CR}} Damage per Joker held #{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.03 {{CR}} Damage per Collectible held"
Descriptions.Jimbo.Jokers[mod.Jokers.MISPRINT] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0-1 {{CR}} random Damage Up every new room #{{PlayerJimbo}} {{ColorMint}}10% Chance{{CR}} for any item to become a gliched one upon spawning"
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{PlayerJimbo}} {{ColorMult}}+0.75X{{CR}} Damage Multiplier for every Joker slot being {{ColorYellorange}}empty{{CR}} or containing another {{ColorYellorange}}Joker Stencil{{CR}}#Not having any {{Collectible}}Active item gives and additional {{ColorMult}}+0.25X{{CR}} Damage Multiplier"
Descriptions.Jimbo.Jokers[mod.Jokers.STONE_JOKER] = "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+1.25 {{CR}}Tears for every for every stone card in the player's full deck #Gives {{ColorChips}}+0.05 {{CR}}Tears per rock in the current room"
Descriptions.Jimbo.Jokers[mod.Jokers.ICECREAM] = "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+4 {{CR}}Tears#Loses {{ColorChips}}-0.16{{CR}} Tears every room completed while held #A trail of slowing follows Jimbo #Killing an enemy on top of the creep turns it in a Frozen Statue"
Descriptions.Jimbo.Jokers[mod.Jokers.POPCORN] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+1 {{CR}}Damage #Loses {{ColorMult}}-0.2{{CR}} Damage when clearing any blind"
Descriptions.Jimbo.Jokers[mod.Jokers.RAMEN] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage Multiplier#loses {{ColorMult}}-0.01X{{CR}} per card discarded while holding this"
Descriptions.Jimbo.Jokers[mod.Jokers.ROCKET] = "{{PlayerJimbo}} Gives 2 {{Coin}}Coins on Blind clear#{{Coin}}Coin payout increases by {{ColorYellorange}}1${{CR}} when a boss blind is defeated #{{PlayerJimbo}} Grants the {{Collectible583}}Rocket in Jar effect"
Descriptions.Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.31 {{CR}} Tears for every Odd numbered card triggered this room #{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.07{{CR}} Tears per Collectible held if the total amount is odd"
Descriptions.Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.04 {{CR}} Damage per Even numbered card triggered this room #{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage per Collectible held if the total amount is even"
Descriptions.Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}} to spawn a random {{Card}}{{ColorPink}} Tarot Card {{CR}}when opening a Booster Pack #{{PlayerJimbo}} {{ColorMint}}50% chance{{CR}} to give a {{Collectible431}} Multidimansional Baby every room entered"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage per room completed while held#{{Damage}}{{ColorMult}}-0.16 {{CR}}Damage on every hand discard"
Descriptions.Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.15 {{CR}} Damage when skipping a Booster Pack"
Descriptions.Jimbo.Jokers[mod.Jokers.VAGABOND] = "{{PlayerJimbo}} Spawns a random {{Card}}{{ColorPink}} Tarot Card {{CR}}when compleating a room with 2 {{Coin}} Coins or less #{{ColorMint}}1/10 chance{{CR}} to spawn a random {{ColorYellorange}}Beggar{{CR}} when clearing a room"
Descriptions.Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "{{PlayerJimbo}} Spawns a random {{ColorChips}} common {{CR}} Joker on every Blind Clear"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "{{PlayerJimbo}} Gives 4 {{Coin}} Coins on every Blind clear #{{Coin}} Every enemy touched becomes golden for a short time"
Descriptions.Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage for every {{Card}}{{ColorPink}} Tarot Card {{CR}}used throughout the run"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "{{PlayerJimbo}} Copies the effect of the Joker to its right"
Descriptions.Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "{{PlayerJimbo}} Copies the effect of the leftmost held Joker"
Descriptions.Jimbo.Jokers[mod.Jokers.MADNESS] = "{{PlayerJimbo}} Destroys another random Joker and gains {{ColorMult}}+0.1X{{CR}} Damage Multiplier every {{ColorYellorange}}Small and Big Blind{{CR}} cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.MR_BONES] = "{{PlayerJimbo}}Revives jimbo at Full Hp if he died after clearing at least half of the current Blind or during any {{BossRoom}} Bossfight #{{ColorMint}}20% chance{{CR}} to use the {{Collectible545}} Book of the Dead on every Room Clear"
Descriptions.Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.07 {{CR}} Damage for every Club card triggered in the room"
Descriptions.Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per {{ColorGray}}Spade{{CR}} card triggered in the room # {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per {{Key}} Key held"
Descriptions.Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Heart card triggered to give {{Damage}} {{ColorMult}}X1.05 {{CR}} Damage Multiplier"
Descriptions.Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Diamond card triggered to spawn a {{Coin}}Coin that disappears shortly after #Every {{ColorYellorange}}Dimaond{{CR}} card shot also has the {{Collectible506}} Backstabber effect"

Descriptions.Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.75 {{CR}}Damage #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destoroyed on every Blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.CAVENDISH] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage multiplier #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destroyed on every Blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{RestockMachine}} Restock machine activated while holding this #{{Collectible105}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{ColorYellorange}}Dice Item{{CR}} ussed while holding this"
Descriptions.Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "{{PlayerJimbo}} Destroys the Joker to it's right and gains {{Damage}}{{ColorMult}} +0.08 x the destroyed Joker's sell value{{CR}} Damage on every Blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "{{PlayerJimbo}} Gain 1 {{Coin}} Coin for every {{ColorYellorange}}9{{CR}} in your FullvDeck on every Blind clear #{{Seraphim}} Gives Flight"
Descriptions.Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "{{PlayerJimbo}} {{Shop}} Gives {{Damage}}{{ColorMult}} +0.05 x the total sell value of other held Jokers{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "{{PlayerJimbo}} Spawns 1 random {{Card}} {{ColorPink}}Tarot Card{{CR}}on every Blind clear #{{ColorMint}}5% Chance{{CR}} for any pickup to be replaced with a random {{ColorPink}}Tarot Card{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X2 {{CR}} Damage multiplier once every 6 rooms cleares"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "{{PlayerJimbo}} When a card is played, gives {{Damage}}{{ColorMult}} +0.01 {{CR}} Damage for every time a card with the same value got played in the current room"
Descriptions.Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "{{PlayerJimbo}} Gives 1 coin per {{Heart}} Heart when clearing a room at full health #{{Timer}} Both the {{Boss}}Bossrush and {{Hush}} Hush door open regardless of the ingame timer"
Descriptions.Jimbo.Jokers[mod.Jokers.EGG] = "{{PlayerJimbo}} The sell value of this Joker increases by{{ColorYellorange}} +2$ {{CR}} every {{ColorYellorange}}Blind cleared{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.DNA] = "{{PlayerJimbo}} If the {{ColorYellorange}} First {{CR}}card triggered in a {{ColorYellorange}}Blind{{CR}} hits an enemy, a copy of that card is added to the deck #{{Collectible658}} Spawns a Mini-Isaac every Hostile room cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{PlayerJimbo}} {{ColorMult}}Hearts{{CR}} and {{ColorYellorange}}Diamonds{{CR}} count as the same suit #{{ColorGray}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit"

Descriptions.Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{PlayerJimbo}} {{ColorChips}}+4 {{CR}}Tears if a {{ColorYellorange}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{PlayerJimbo}} {{ColorChips}}+8 {{CR}}Tears if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{PlayerJimbo}} {{ColorChips}}+7 {{CR}}Tears if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{PlayerJimbo}} {{ColorChips}}+12 {{CR}}Tears if a {{ColorYellorange}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{PlayerJimbo}} {{ColorChips}}+9 {{CR}}Tears if a {{ColorYellorange}}Flush{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+1 {{CR}}Damage if a {{ColorYellorange}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+2 {{CR}}Damage if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+1.75 {{CR}}Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+3 {{CR}}Damage if a {{ColorYellorange}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+2.25 {{CR}}Damage if a {{ColorYellorange}}Flush{{CR}} is held when entering a room"

Descriptions.Jimbo.Jokers[mod.Jokers.MIME] = "{{PlayerJimbo}} {{ColorYellorange}}Retriggers{{CR}} {{ColorYellorange}}all held in hand{{CR}} effects #{{ColorMint}}20% Chance{{CR}} to copy the effect of an Active Item or consumable used"
Descriptions.Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{PlayerJimbo}} {{ColorYellorange}}Flushes{{CR}} and {{ColorYellorange}}Straights{{CR}} only need 4 compatible cards #Every fifth non-boss enemy spawned gets killed immediantly"
Descriptions.Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorMult}}Heart{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorYellorange}}Diamond{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorGray}}Spade{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorChips}}Club{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{PlayerJimbo}} {{ColorRed}}+2 Hp{{CR}} and {{ColorCyan}}-2 Hand size{{CR}} while held"
Descriptions.Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{PlayerJimbo}} {{ColorMult}}+1.5 {{CR}}Damage when {{CR}}5 or less{{CR}} card have been played in the current room #{{PlayerJimbo}} {{ColorMult}}+1 {{CR}}Damage when holding {{ColorYellorange}}3 or less{{CR}} cards"
Descriptions.Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "{{PlayerJimbo}} Allows to go in {{ColorYellorange}}debt{{CR}} by spending more coins than you have#{{Shop}} Items on sale can be bought with a maximum of {{ColorMult}}-20${{CR}} debt #!!! Interest and coin-based effect cannot trigger while in debt"

Descriptions.Jimbo.Jokers[mod.Jokers.BANNER] = "{{PlayerJimbo}} {{ColorChips}}+1.5 {{CR}}Tears per Red heart Jimbo has"
Descriptions.Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{PlayerJimbo}} {{ColorMult}}+0.75 {{CR}}Damage while having only 1 full Red Heart"
Descriptions.Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "{{PlayerJimbo}} Adds a {{ColorGray}}Stone card{{CR}} to the deck every blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers._8_BALL] = "{{PlayerJimbo}} {{ColorMint}}1/8 Chance{{CR}} to spawn a random {{Card}} {{ColorPink}}Tarot card{{CR}} when an {{ColorYellorange}}8{{CR}} is triggered"
Descriptions.Jimbo.Jokers[mod.Jokers.DUSK] = "{{PlayerJimbo}} The {{ColorYellorange}}last 10{{CR}} triggerable cards shot get retriggered an additional time"
Descriptions.Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "{{PlayerJimbo}} The held card with the {{ColorYellorange}}lowest value{{CR}} gives {{ColorMult}}0.05{{CR}} {{ColorYellorange}} X its value{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{PlayerJimbo}} Every {{Shop}} Shop visited has an additional Restock Machine"
Descriptions.Jimbo.Jokers[mod.Jokers.FIBONACCI] = "{{PlayerJimbo}} {{ColorMult}}+0.08 {{CR}}Damage per {{ColorYellorange}}Ace, 2, 3, 5 and 8{{CR}} triggered this room"
Descriptions.Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.15X {{CR}}Damage Multiplier per {{ColorSilver}}Steel card{{CR}} in your deck"
Descriptions.Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{PlayerJimbo}} {{ColorChips}}+0.3 {{CR}}Tears per {{ColorYellorange}}Face card{{CR}} triggered #{{ColorChips}}+1 {{CR}}Tears per {{ColorYellorange}}Champion enemy{{CR}} killed this room"
Descriptions.Jimbo.Jokers[mod.Jokers.HACK] = "{{PlayerJimbo}} Played {{ColorYellorange}}2, 3, 4 and 5{{CR}} get retrigged #Jimbo gains a copy of every {{Quality0}} and {{Quality1}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "{{PlayerJimbo}} Every played card counts as a {{ColorYellorange}}Face card{{CR}} #{{ColorMint}}1/5 Chance{{CR}} for any non-boss enemy to become a {{ColorYellorange}}Champion{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.SCHOLAR] = "{{PlayerJimbo}} {{ColorMult}}+0.04{{CR}} Damage and {{ColorChips}}+0.1{{CR}} Tears per {{ColorYellorange}}Ace{{CR}} triggered"
Descriptions.Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{PlayerJimbo}} {{ColorMint}}1/2 Chance{{CR}} to spawn 2 vanishing Pennies when a {{ColorYellorange}}Face card{{CR}} is triggered #Gain the {{Collectible602}} Member Card effect"
Descriptions.Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{PlayerJimbo}} {{ColorMult}}+0.01 {{CR}}Damage per consecutive {{ColorYellorange}}non-Face card{{CR}} triggered"
Descriptions.Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{PlayerJimbo}} {{ColorMint}}1/20 Chance{{CR}} to upgrade the played card value's level #Gains an additional {{ColorMint}}1/20 Chance{{CR}} per {{ColorYellorange}}Star-related{{CR}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.BURGLAR] = "{{PlayerJimbo}} Sets your Hp to {{ColorRed}}1{{CR}}#Cards can be triggered until the deck gets {{ColorYellorange}}reshuffled{{CR}} every room"
Descriptions.Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{PlayerJimbo}} {{ColorMult}}x2 {{CR}}Damage Multiplier if all cards held in hand are {{ColorGray}}Spades{{CR}} or {{ColorChips}}Clubs{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.RUNNER] = "{{PlayerJimbo}} This joker gains {{ColorChips}}+2{{CR}} Tears when entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} in hand #Gives {{ColorChips}}+Tears{{CR}} equal to your speed stat#{{Speed}} +0.1 Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.SPLASH] = "{{PlayerJimbo}} Triggers all cards in hand upon entering a hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{PlayerJimbo}} {{ColorChips}}+0.1 {{CR}}Tears per remaining card in your deck"
Descriptions.Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "{{PlayerJimbo}} If the {{ColorYellorange}}First{{CR}} card played in a {{ColorYellorange}}Blind{{CR}} is a {{ColorYellorange}}6{{CR}} and hits an enemy, it gets destroyed and spawns a {{ColorBlue}}Spectral Pack{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "{{PlayerJimbo}} This Jokers gains {{ColorMult}}+0.04X{{CR}} Damage Multiplier every time a {{ColorCyan}}Planet Card{{CR}} is used while holding it"
Descriptions.Jimbo.Jokers[mod.Jokers.HIKER] = "{{PlayerJimbo}} {{ColorYellorange}}Triggering{{CR}} a card gives it a {{ColorYellorange}}permanent{{CR}} {{ColorMult}}+0.02{{CR}} Tears upgrade"
Descriptions.Jimbo.Jokers[mod.Jokers.FACELESS] = "{{PlayerJimbo}} Gain {{ColorMult}}+3${{CR}} when discarding {{ColorYellorange}}at least 2 Face cards{{CR}} at the same time #If only {{ColorYellorange}}Non-boss champion{{CR}} enemies are left in the room, they are {{ColorYellorange}}killed instantly{{CR}} spawning a vanishing penny"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "{{PlayerJimbo}} Entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} and an {{ColorYellorange}}Ace{{CR}} spawns an {{ColorPink}}Arcana Pack{{CR}} #Grants 2 {{Collectible128}} Forever Alone Flies"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{PlayerJimbo}} A random {{ColorYellorange}}Card value{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Playing{{CR}} a card with that value spawns a vanishing penny"

Descriptions.Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{PlayerJimbo}} Gives {{ColorChips}}X1.1{{CR}} Damage Multiplier when {{ColorYellorange}}Scoring{{CR}} 2 cards with the same value consecutevely #{{Collectible665}} Allows Isaac to see the content of chests and sacks"
Descriptions.Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "{{PlayerJimbo}} Gives {{ColorChips}}+4{{CR}} Tears every fourth card shot #{{Pill}} Gains {{ColorChips}}+0.4{{CR}} Tears every time a {{ColorYellorange}}Retro Vision{{CR}} pill is used"
Descriptions.Jimbo.Jokers[mod.Jokers.SEANCE] = "{{PlayerJimbo}} Spawns a {{ColorYellorange}}Spectral Pack{{CR}} if a {{ColorYellorange}}Straight Flush{{CR}} is held when entering a room #{{Collectible727}} {{ColorMint}}1/6 chance{{CR}} to spawn a {{ColorYellorange}}Hungry Soul{{CR}} when killing an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.VAMPIRE] = "{{PlayerJimbo}} When a card with an {{ColorYellorange}}Enhancement{{CR}} is {{ColorYellorange}}Scored{{CR}}, this gains {{ColorChips}}+0.02X{{CR}} Damage Multiplier and removes the card's {{ColorYellorange}}Enhancement{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SHORTCUT] = "{{PlayerJimbo}} Allows {{ColorYellorange}}Straights{{CR}} to be made with gaps of {{ColorYellorange}}1 rank{{CR}} #{{Collectible84}} Creates a {{ColorYellorange}}Crawl space{{CR}} in a random room every floor #{{Collectible84}} immediantly opens all {{ColorYellorange}}Secret Room{{CR}} doors"
Descriptions.Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.1X {{CR}}Damage Multiplier when a card gets {{ColorYellorange}}Added{{CR}} to the deck"

Descriptions.Jimbo.Jokers[mod.Jokers.BARON] = "{{PlayerJimbo}} Every {{ColorYellorange}}King{{CR}} held in hand gives {{ColorMult}}X1.25{{CR}} Damage Multiplier #{{Quality4}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per Q4 item held"
Descriptions.Jimbo.Jokers[mod.Jokers.OBELISK] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier when {{ColorYellorange}}scoring{{CR}} a card with a different {{ColorYellorange}}Suit{{CR}} from the last"
Descriptions.Jimbo.Jokers[mod.Jokers.MIDAS] = "{{PlayerJimbo}} Every {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} becomes {{ColorYellorange}}Golden{{CR}}#{{ColorYellorange}}Champion{{CR}} enemies are breifly turned into golden statues when spawning"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{PlayerJimbo}} {{ColorYellorange}}Selling{{CR}} this joker causes a {{Collectible483}}Mama Mega! explosion and weakens all {{ColorYellorange}}Bosses{{CR}} in the room"
Descriptions.Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "{{PlayerJimbo}} The first {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} every room gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when {{ColorYellorange}}Scored{{CR}} #Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when killing the first {{ColorYellorange}}Champion{{CR}} enemy in the room "
Descriptions.Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "{{PlayerJimbo}} Every joker held gains {{ColorChips}}+1${{CR}} selling value when clearing a blind"
Descriptions.Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "{{PlayerJimbo}} Gains {{ColorCyan}}+3{{CR}} Hand Size #Bonus is decreased by {{ColorRed}}-1{{CR}} every blind beaten"
Descriptions.Jimbo.Jokers[mod.Jokers.EROSION] = "{{PlayerJimbo}} This gains {{ColorChips}}+0.15{{CR}} Damage when a card gets {{ColorYellorange}}Destroyed{{CR}} #This gains {{ColorChips}}+0.1{{CR}} Damage when a {{ColorYellorange}}Tinted Rock{{CR}} gets {{ColorYellorange}}Destroyed{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "{{PlayerJimbo}} When clearing a room every {{ColorYellorange}}Face{{CR}} card held has a {{ColorMint}}1/4 chance{{CR}} to spawn a penny #When killing an enemy every other {{ColorYellorange}}Champion{{CR}} enemy has a {{ColorMint}}1/2 chance{{CR}} to spawn a penny around it"

Descriptions.Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "{{PlayerJimbo}} A random {{ColorYellorange}}Card value{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Discarding{{CR}} a card with that value spawns 2 {{Coin}} pennies"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "{{PlayerJimbo}} Gain {{ColorYellow}}+1${{CR}} per {{ColorYellorange}}Interest{{CR}} at the end of a blind"
Descriptions.Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{PlayerJimbo}} {{ColorChips}}+1 Hand Size{{CR}} #+1 {{ColorYellorange}}consumable slot{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}} #Healing when at full heath makes Isaac vision more distorted #Taking damage reverts the distorsion"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.02X{{CR}} Damage Multiplier when a {{ColorMint}}Lucky Card{{CR}} procs or when a {{Slotmachine}} Slot pays out"
Descriptions.Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{PlayerJimbo}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per {{ColorLime}}Uncommon{{CR}} Joker held #Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier per {{Quality2}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{PlayerJimbo}} Copies the {{Collectible347}} Diplopia effect when {{ColorYellorange}}Sold{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "{{PlayerJimbo}}{{ColorYellorange}}Destroys{{CR}} every card in hand when {{ColorYellorange}}Sold{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "{{PlayerJimbo}}This gains {{ColorMult}}+0.25{{CR}} Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room #Gives {{ColorMult}}+0.1{{CR}} Damage for every active costume the player has"
Descriptions.Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "{{PlayerJimbo}} A random {{ColorYellorange}}Card suit{{CR}} is chosen upon entering an hostile room #Gives {{ColorMult}}X1.05{{CR}} Damage Multiplier every time a card with that {{ColorYellorange}}Suit{{CR}} is {{ColorYellorange}}Triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "{{PlayerJimbo}} {{ColorChips}}+0.1{{CR}} Tears and {{ColorChips}}+0.04{{CR}} Damage per {{ColorYellorange}}10{{CR}} and {{ColorYellorange}}4{{CR}} triggered this room"
Descriptions.Jimbo.Jokers[mod.Jokers.SELTZER] = "{{PlayerJimbo}} Every card played in the next 15 rooms gets {{ColorYellorange}}Retriggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{PlayerJimbo}} Gives {{ColorMult}}+0.05{{CR}} Damage per {{ColorYellorange}}Face card{{CR}} triggered this room #Gives {{ColorMult}}+0.15{{CR}} Damage per {{ColorYellorange}}Champion{{CR}} enemy killed this room"
Descriptions.Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier per sold Joker this {{ColorYellorange}}Ante{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.CASTLE] = "{{PlayerJimbo}} A random {{ColorYellorange}}Card suit{{CR}} is chosen upon entering an hostile room #This gains {{ColorChips}}+0.04{{CR}} Tears when {{ColorYellorange}}Discarding{{CR}} a card with that {{ColorYellorange}}Suit{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{PlayerJimbo}} Gain {{ColorYellow}}+2${{CR}} every time a {{ColorYellorange}}Golden card{{CR}} is triggered #Every pickup has a {{ColorMint}}1/25 chance{{CR}} to become its {{ColorYellorange}}Golden{{CR}} variant"
Descriptions.Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{PlayerJimbo}} Gives {{ColorMult}}X2{{CR}} Damage Multipier if Jimbo has {{ColorYellorange}}5 or less{{CR}} playable cards left"
Descriptions.Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{PlayerJimbo}} {{ColorYellorange}}Face card{{CR}} played get {{ColorYellorange}}Retriggered{{CR}} #On {{ColorYellorange}}Champion kill{{CR}} Joker effects get retriggered"
Descriptions.Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{PlayerJimbo}} {{ColorChips}}+2 Hand Size{{CR}} #{{ColorBlue}}-5 playable cards{{CR}} every room"
Descriptions.Jimbo.Jokers[mod.Jokers.THROWBACK] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier per skipped {{ColorYellorange}}Special room{{CR}} skipped this run"
Descriptions.Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "{{PlayerJimbo}} A card with a {{ColorYellorange}}Random Seal{{CR}} is added to the deck every time a {{ColorYellorange}}Blind{{CR}} is cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{PlayerJimbo}} The {{ColorYellorange}}first{{CR}} card played is {{ColorYellorange}}triggered{{CR}} 3 additional times #The {{ColorYellorange}}first{{CR}} card used every floor spawns a copy of itself"
Descriptions.Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.1X{{CR}} Damage Multiplier every time a {{ColorGlass}}Glass Card{{CR}} is destroyed"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{PlayerJimbo}} Alredy seen {{ColorYellorange}}Jokers{{CR}} and {{ColorYellorange}}Items{{CR}} can reappear throughuot the run"
Descriptions.Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{PlayerJimbo}} {{ColorChips}}X1.5{{CR}} Damage Multiplier if every {{ColorYellorange}}Suit{{CR}} is held in hand when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.04{{CR}} Tears when a {{ColorYellorange}}2{{CR}} is {{ColorYellorange}}triggered{{CR}}#The samller Jimbo is, the higer is the stat gain"
Descriptions.Jimbo.Jokers[mod.Jokers.OOPS_6] = "{{PlayerJimbo}} Every {{ColorMint}}Listed Chance{{CR}} is Doubled"
Descriptions.Jimbo.Jokers[mod.Jokers.IDOL] = "{{PlayerJimbo}} A random {{ColorYellorange}}Card{{CR}} from Jimbo's deck is chosen upon entering an hostile room #Playing a card with the same {{ColorYellorange}}Value ans Suit{{CR}} gives {{ColorMult}}X1.1{{CR}} Damage Multiplier"
Descriptions.Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{PlayerJimbo}} {{ColorMult}}X1.2{{CR}} Damage Multiplier when entering an hostile room while holding both a {{ColorClub}}Club{{CR}} and a {{ColorYellorange}}Not-club{{CR}} card in hand"
Descriptions.Jimbo.Jokers[mod.Jokers.MATADOR] = "{{PlayerJimbo}} Gain {{ColorYellow}}+6${{CR}} when Jimbo takes damage from a {{ColorYellorange}}Boss{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier every time a {{ColorYellorange}}Jack{{CR}} is discarded #!!! Resets every beaten {{ColorYellorange}}Blind{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.DUO] = "{{PlayerJimbo}} {{ColorMult}}X1.25{{CR}} Damage Mutiplier if a {{ColorYellorange}}Pair{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIO] = "{{PlayerJimbo}} {{ColorMult}}X1.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Three of a Kind{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.FAMILY] = "{{PlayerJimbo}} {{ColorMult}}X2{{CR}} Damage Mutiplier if a {{ColorYellorange}}Four of a Kind{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.ORDER] = "{{PlayerJimbo}} {{ColorMult}}X2.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Straight{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBE] = "{{PlayerJimbo}} {{ColorMult}}X1.35{{CR}} Damage Mutiplier if a {{ColorYellorange}}Flush{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{PlayerJimbo}} {{ColorMult}}+12.5{{CR}} Tears #{{ColorChips}}-3 Hand Size{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SATELLITE] = "{{PlayerJimbo}} Upon Clearing a {{ColorYellorange}}Blind{{CR}} gain {{ColorYellow}}+1${{CR}} per unique {{ColorCyan}}Planet Card{{CR}} used this run"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{PlayerJimbo}} {{ColorMult}}+0.7{{CR}} Damage per {{ColorYellorange}}Queen{{CR}} held in hand when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{PlayerJimbo}} {{ColorMult}}X1.5{{CR}} Damage Multiplier if Jimbo has at least {{ColorYellorange}}18 Enhanced cards{{CR}} in his deck #Having either the {{Adult}} Adult, {{Mom}} Mom or {{Bob}} Bob transformation also activates the effect"
Descriptions.Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "{{PlayerJimbo}} Every {{ColorCyan}}Planet card{{CR}},{{ColorCyan}}Celestial Pack{{CR}} and {{ColorYellorange}}Star-themed{{CR}} item is free"
Descriptions.Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{PlayerJimbo}} {{ColorCyan}}Upgrades{{CR}} the level of {{ColorYellorange}}discarded{{CR}} cards that hit an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{PlayerJimbo}} {{ColorMult}}+0.1{{CR}} Damage per 5 coins held"

Descriptions.Jimbo.Jokers[mod.Jokers.CANIO] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.25X{{CR}} Damage Multiplier when a {{ColorYellorange}}Face card{{CR}} is {{ColorYellorange}}Destroyed{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{PlayerJimbo}} {{ColorMult}}X1.1{{CR}} Damage Multiplier per {{ColorYellorange}}King or Queen{{CR}} triggered this room"
Descriptions.Jimbo.Jokers[mod.Jokers.YORICK] = "{{PlayerJimbo}} This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier every {{ColorYellorange}}23{{CR}} cards discarded"
Descriptions.Jimbo.Jokers[mod.Jokers.CHICOT] = "{{PlayerJimbo}} Every {{ColorYellorange}}Boss>{{CR}} is permanently {{Weakness}} weakened #Disables every curse"
Descriptions.Jimbo.Jokers[mod.Jokers.PERKEO] = "{{PlayerJimbo}} Spwns a duplicate of every {{ColorYellorange}}Consumable{{CR}} Jimbo has upon entering a {{Shop}} shop or a new floor"
end



Descriptions.Jimbo.Enhancement = {}
Descriptions.Jimbo.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.Jimbo.Enhancement[mod.Enhancement.BONUS] = "# {{ColorChips}}Bonus Card{{CR}}: When triggered gives {{ColorChips}}+0.75 Tears{{CR}}"
Descriptions.Jimbo.Enhancement[mod.Enhancement.MULT]  = "# {{ColorMult}}Mult Card{{CR}}: When triggered gives {{ColorMult}}+0.05 Damage{{CR}}"
Descriptions.Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# {{ColorYellorange}}Gold Card{{CR}}: Holding it when a {{ColorYellorange}}blind{{CR}} is cleared gives {{ColorYellow}}2${{CR}} #!!! Cards played need to be {{ColorCyan}}Triggerable{{CR}} for the effect to occur"
Descriptions.Jimbo.Enhancement[mod.Enhancement.GLASS] = "# {{ColorGlass}}Glass Card{{CR}}: When triggered gives {{ColorMult}}x1.2 Damage Multiplier{{CR}} #!!! When scored {{ColorMint}}10% chance{{CR}} to get destroyed"
Descriptions.Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{ColorMint}}Lucky Card{{CR}}: When triggered {{ColorMint}}20% chance{{CR}} to give {{ColorMult}}+0.2 Mult{{CR}} and {{ColorMint}}5% chance{{CR}} to spawn {{ColorYellow}}10 {{Coin}}Coins{{CR}}"
Descriptions.Jimbo.Enhancement[mod.Enhancement.STEEL] = "# {{ColorSilver}}Steel Card{{CR}}: When held in hand gives {{ColorMult}}x1.2 Damage Multiplier{{CR}}"
Descriptions.Jimbo.Enhancement[mod.Enhancement.WILD]  = "# {{ColorRainbow}}Wild Card{{CR}}: This card counts as every Suit"
Descriptions.Jimbo.Enhancement[mod.Enhancement.STONE] = "# {{ColorGray}}Stone Card{{CR}}: When triggered gives {{ColorChips}}+1.25 Tears{{CR}} #!!! Has no Value or Suit"


Descriptions.T_Jimbo.Enhancement = {}
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.BONUS] = "# +{{ColorChips}}30{{CR}} Chips"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.MULT]  = "# +{{ColorMult}}4{{CR}} Mult"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# +{{ColorYellorange}}3${{CR}} when held at the end of round"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GLASS] = "# X{{ColorMult}}2{{CR}} Mult # {{ColorMint}}[[CHANCE]] in 4 Chance{{CR}} to break when played"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{ColorMint}}[[CHANCE]] in 5 Chance{{CR}} to give +{{ColorMult}}20{{CR}} Mult # {{ColorMint}}[[CHANCE]] in 20 Chance{{CR}} to give +{{ColorMult}}20${{CR}}"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STEEL] = "# X{{ColorMult}}1.5{{CR}} Mult When held in hand"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.WILD]  = "# Is considered as being every {{ColorYellorange}}Suit{{CR}}"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STONE] = "# +{{ColorChips}}50{{CR}} Chips #Doesn't have a {{ColorYellorange}}Rank{{CR}} or {{ColorYellorange}}Suit{{CR}}"







---------------------------------------
-------------####TAROTS####------------
---------------------------------------

Descriptions.Jimbo.Consumables = {}
Descriptions.Jimbo.Consumables[Card.CARD_FOOL] = "#{{PlayerJimbo}} Spawns copy of your last used card #!!! Cannot spawn itself #Currently: "
Descriptions.Jimbo.Consumables[Card.CARD_MAGICIAN] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMint}}Lucky Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "#{{PlayerJimbo}} Spawns {{ColorYellorange}}2{{CR}} random {{ColorCyan}}Planet Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_EMPRESS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMult}}Mult Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_EMPEROR] = "#{{PlayerJimbo}} Spawns {{ColorYellorange}}2{{CR}} random {{ColorPink}}Tarot Cards{{CR}} #!!! Cannot spawn itself"
Descriptions.Jimbo.Consumables[Card.CARD_HIEROPHANT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorChips}}Bonus Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_LOVERS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorRainbow}}Wild Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_CHARIOT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorSilver}}Steel Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_JUSTICE] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorGlass}}Glass Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_HERMIT] = "#{{PlayerJimbo}} Doubles you current money #!!! Can give up to {{ColorYellow}}20${{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "#{{PlayerJimbo}} {{ColorMint}}25% chance{{CR}} to give a random {{ColorRainbow}}Edition{{CR}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
Descriptions.Jimbo.Consumables[Card.CARD_STRENGTH] = "#{{PlayerJimbo}} Raise the value of {{ColorYellorange}}up to 2{{CR}} cards by 1 #!!! Kings chosen become Aces"
Descriptions.Jimbo.Consumables[Card.CARD_HANGED_MAN] = "#{{PlayerJimbo}} Removes from the deck {{ColorYellorange}}up to 2{{CR}} cards"
Descriptions.Jimbo.Consumables[Card.CARD_DEATH] = "#{{PlayerJimbo}} Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Second{{CR}} card chosen becomes the {{ColorYellorange}}First{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_TEMPERANCE] = "#{{PlayerJimbo}} Gives the total {{ColorYellow}}Sell value{{CR}} of you Jokers in {{Coin}}Pennies"
Descriptions.Jimbo.Consumables[Card.CARD_DEVIL] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorYellorange}}Gold Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_TOWER] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorGray}}Stone Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_STARS] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorYellorange}}Diamonds{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_MOON] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorChips}}Clubs{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_SUN] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorMult}}Hearts{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_JUDGEMENT] = "#{{PlayerJimbo}} Gives random {{ColorYellorange}}Joker{{CR}} #!!! Requires an empty Inventory slot"
Descriptions.Jimbo.Consumables[Card.CARD_WORLD] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorGray}}Spades{{CR}}"


----------------------------------------
-------------####PLANETS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Planets.PLUTO] = "{{PlayerJimbo}} {{ColorYellorange}}Aces{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.MERCURY] = "{{PlayerJimbo}} {{ColorYellorange}}2s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.URANUS] = "{{PlayerJimbo}} {{ColorYellorange}}3s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.VENUS] = "{{PlayerJimbo}} {{ColorYellorange}}4s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.SATURN] = "{{PlayerJimbo}} {{ColorYellorange}}5s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.JUPITER] = "{{PlayerJimbo}} {{ColorYellorange}}6s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.EARTH] = "{{PlayerJimbo}} {{ColorYellorange}}7s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.MARS] = "{{PlayerJimbo}} {{ColorYellorange}}8s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.NEPTUNE] = "{{PlayerJimbo}} {{ColorYellorange}}9s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.PLANET_X] = "{{PlayerJimbo}} {{ColorYellorange}}10s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.CERES] = "{{PlayerJimbo}} {{ColorYellorange}}Jacks{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.ERIS] = "{{PlayerJimbo}} {{ColorYellorange}}Queens{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Planets.SUN] = "{{PlayerJimbo}} {{ColorYellorange}}Kings{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"


----------------------------------------
-------------####SPECTRALS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}3{{CR}} random {{ColorYellorange}}Enhanced Face cards{{CR}} to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.GRIM] = "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}2{{CR}} random {{ColorYellorange}}Enhanced Aces cards{{CR}} to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}4{{CR}} random {{ColorYellorange}}Enhanced Numbered cards{{CR}} to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.TALISMAN] = "{{PlayerJimbo}} Put a {{ColorYellorange}}Golden Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.AURA] = "{{PlayerJimbo}} Give a random {{ColorRainbow}}Edition{{CR}} to a selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.WRAITH] = "{{PlayerJimbo}} Sets your money to {{ColorYellorange}}0{{CR}} and gives a random {{ColorMult}}Rare Joker{{CR}}#!!! Requires an empty Inventory slot"
Descriptions.Jimbo.Consumables[mod.Spectrals.SIGIL] = "{{PlayerJimbo}} Turns all the cards in your hand to the same random {{ColorYellorange}}Suit{{CR}}"
Descriptions.Jimbo.Consumables[mod.Spectrals.OUIJA] = "{{PlayerJimbo}} Turns all the cards in your hand to the same random {{ColorYellorange}}Rank{{CR}}"
Descriptions.Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "{{PlayerJimbo}} Turns a random Joker {{ColorGray}}{{ColorFade}}Negative{{CR}} and gives {{ColorRed}}-1{{CR}} Hand size #!!! Cannot replace any {{ColorYellorange}}Edition{{CR}} a Joker alredy has #!!! The effect won't occur if hand size cannot be lowered"
Descriptions.Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} up to {{ColorYellorange}}3{{CR}} cards from your hand and gives {{ColorYellow}}4${{CR}} for every card destroyed"
Descriptions.Jimbo.Consumables[mod.Spectrals.ANKH] = "{{PlayerJimbo}} Gives a copy a of random Joker held and destroys all the others #!!! Removes the {{ColorGray}}{{ColorFade}}Negative{{CR}} Edition from the copied Joker"
Descriptions.Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "{{PlayerJimbo}} Put a {{ColorRed}}Red Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.HEX] = "{{PlayerJimbo}} Gives the {{ColorRainbow}}Polychrome{{CR}} Edition to random Joker held and destroys all the others"
Descriptions.Jimbo.Consumables[mod.Spectrals.TRANCE] = "{{PlayerJimbo}} Put a {{ColorCyan}}Blue Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.MEDIUM] = "{{PlayerJimbo}} Put a {{ColorPink}}Purple Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.CRYPTID] = "{{PlayerJimbo}} Add {{ColorYellorange}}2{{CR}} copies of a selected card to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "{{PlayerJimbo}} {{ColorYellorange}}All Cards{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Spectrals.SOUL] = "{{PlayerJimbo}} Gives a random {{ColorRainbow}}Legendary{{CR}} Joker#!!! Requires an empty Inventory slot"



-------------------------------------
--------------BLINDS-----------------
-------------------------------------

    
Descriptions.BlindNames = {[Balatro_Expansion.BLINDS.SMALL] = "Small blind",
                           [Balatro_Expansion.BLINDS.BIG] = "Big blind",
                           [Balatro_Expansion.BLINDS.BOSS] = "Boss Blind",
                           [Balatro_Expansion.BLINDS.BOSS_ACORN] = "Amber acorn",
                           [Balatro_Expansion.BLINDS.BOSS_ARM] = "The Arm",
                           [Balatro_Expansion.BLINDS.BOSS_BELL] = "Cerulean Bell",
                           [Balatro_Expansion.BLINDS.BOSS_CLUB] = "The club",
                           [Balatro_Expansion.BLINDS.BOSS_EYE] = "The eye",
                           [Balatro_Expansion.BLINDS.BOSS_FISH] = "The fish",
                           [Balatro_Expansion.BLINDS.BOSS_FLINT] = "The flint",
                           [Balatro_Expansion.BLINDS.BOSS_GOAD] = "The goad",
                           [Balatro_Expansion.BLINDS.BOSS_HEAD] = "The head",
                           [Balatro_Expansion.BLINDS.BOSS_HEART] = "Crimson heart ",
                           [Balatro_Expansion.BLINDS.BOSS_HOOK] = "The hook",
                           [Balatro_Expansion.BLINDS.BOSS_HOUSE] = "The house",
                           [Balatro_Expansion.BLINDS.BOSS_LEAF] = "Verdant leaf",
                           [Balatro_Expansion.BLINDS.BOSS_MANACLE] = "The manacle",
                           [Balatro_Expansion.BLINDS.BOSS_MARK] = "The mark",
                           [Balatro_Expansion.BLINDS.BOSS_MOUTH] = "The mouth",
                           [Balatro_Expansion.BLINDS.BOSS_NEEDLE] = "The needle",
                           [Balatro_Expansion.BLINDS.BOSS_OX] = "The ox",
                           [Balatro_Expansion.BLINDS.BOSS_PILLAR] = "The pillar",
                           [Balatro_Expansion.BLINDS.BOSS_PLANT] = "The plant",
                           [Balatro_Expansion.BLINDS.BOSS_PSYCHIC] = "The psychic",
                           [Balatro_Expansion.BLINDS.BOSS_SERPENT] = "The serpent",
                           [Balatro_Expansion.BLINDS.BOSS_TOOTH] = "The tooth",
                           [Balatro_Expansion.BLINDS.BOSS_VESSEL] = "Violet Vessel",
                           [Balatro_Expansion.BLINDS.BOSS_WALL] = "The wall",
                           [Balatro_Expansion.BLINDS.BOSS_WATER] = "The water",
                           [Balatro_Expansion.BLINDS.BOSS_WHEEL] = "The wheel",
                           [Balatro_Expansion.BLINDS.BOSS_WINDOW] = "The window",
                            }


Descriptions.BossEffects = {[mod.BLINDS.SMALL] = "",
                            [mod.BLINDS.BIG] = "",
                            [mod.BLINDS.BOSS] = "",
                            [mod.BLINDS.BOSS_ACORN] = "Covers and shuffles all Jokers",
                            [mod.BLINDS.BOSS_ARM] = "Decreases level of hand played",
                            [mod.BLINDS.BOSS_BELL] = "Forces one card to be selected",
                            [mod.BLINDS.BOSS_CLUB] = "All club cards are debuffed",
                            [mod.BLINDS.BOSS_EYE] = "Cannot repeat hand types",
                            [mod.BLINDS.BOSS_FISH] = "Cards drawn after hand play are covered",
                            [mod.BLINDS.BOSS_FLINT] = "Halfes base chips and mult",
                            [mod.BLINDS.BOSS_GOAD] = "All spade cards are debuffed",
                            [mod.BLINDS.BOSS_HEAD] = "All heart cards are debuffed",
                            [mod.BLINDS.BOSS_HOOK] = "Discard 2 cards on hand play",
                            [mod.BLINDS.BOSS_HOUSE] = "Starting hand is drawn face down",
                            [mod.BLINDS.BOSS_LEAF] = "All cards are debuffed until a joker is sold",
                            [mod.BLINDS.BOSS_MANACLE] = "-1 hand size",
                            [mod.BLINDS.BOSS_MARK] = "All face cards are drawn face down",
                            [mod.BLINDS.BOSS_MOUTH] = "Can only play one hand type",
                            [mod.BLINDS.BOSS_NEEDLE] = "Only play 1 hand",
                            [mod.BLINDS.BOSS_OX] = "Playing a [[HAND]] sets money to 0$",
                            [mod.BLINDS.BOSS_PILLAR] = "Cards played this ante are debuffed",
                            [mod.BLINDS.BOSS_PLANT] = "All face cards are debuffed",
                            [mod.BLINDS.BOSS_PSYCHIC] = "Must play 5 cards",
                            [mod.BLINDS.BOSS_SERPENT] = "After play and discard always draw 3 cards",
                            [mod.BLINDS.BOSS_TOOTH] = "-1$ per card played",
                            [mod.BLINDS.BOSS_VESSEL] = "Very large blind",
                            [mod.BLINDS.BOSS_WALL] = "Very large blind",
                            [mod.BLINDS.BOSS_WATER] = "Start with 0 discards",
                            [mod.BLINDS.BOSS_WHEEL] = "1 in 7 cards are drawn face down",
                            [mod.BLINDS.BOSS_WINDOW] = "All diamond cards are debuffed",
                        }
    

-------------------------------------
--------------T_JIMBO----------------
-------------------------------------

Descriptions.T_Jimbo.LeftHUD = {ShopSlogan = "Improve your run!",
                                ChooseNextBlind = "Choose your next blind",
                                Hands = "Hands",
                                Discards = "Discards",
                                Ante = "Ante",
                                Round = "Round",
                                RunInfo = "Run info",
                                Options = "Options",
                                EnemyMaxHP = "Enemies' max HP",
                                HandScore = "Score",
                                Q_KeyBind = "[Pill/Card]",
                                E_KeyBind = "[Bomb]",
                            } 



-------------------------------------
---------------MAIN GAME-------------
-------------------------------------

EID:addCollectible(mod.Collectibles.BALOON_PUPPY, "Spawns a floating familiar that reflects shots back at enemies #Explodes dealing 3 x Isaac's Damage after taking enough damage #If Isaac takes damage, it starts chasing down enemies dealing 1 damage every tick", "Baloon Puppy",FileLanguage)		
EID:addCollectible(mod.Collectibles.BANANA, "Isaac shoots a devastating banana that creates a {{Collectible483}} Mama Mega! explosion on contact #Upon use becomes {{Collectible"..tostring(mod.Collectibles.EMPTY_BANANA).."}} Empty Banana", "Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.EMPTY_BANANA, "Leaves a banana peel on the ground, able to make any moving enemy to slip on it #Enemies that slip on these peels take more damage the faster they were moving #Entring a new floor recharges it to {{Collectible"..tostring(mod.Collectibles.BANANA).."}} Banana", "Empty Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.CLOWN, "When Isaac takes damage, every enemy in the room has a 66% chance to get either {{Fear}} Fear or {{Charm}} Charm applied", "Clown Costume",FileLanguage)		
EID:addCollectible(mod.Collectibles.CRAYONS, "While moving, Isaac leaves a trail of crayon dust that applies a variety of status effect to enemies that step on it #The dust's color changes every new room", "Box of Crayons",FileLanguage)		
EID:addCollectible(mod.Collectibles.FUNNY_TEETH, "Spawns a familiar that chases enemies dealiing X contact damage every tick #{{Chargeable}} After being active for a while a player needs to recharge it by standing near it", "Funny Teeth",FileLanguage)		
EID:addCollectible(mod.Collectibles.HORSEY, "Spawns a familiar moves in an L pattern, creating friendly shockwaves upon landing", "Horsey",FileLanguage)		
EID:addCollectible(mod.Collectibles.LAUGH_SIGN, "An audience reacts live to Isaac's actions #{{BossRoom}} Clearing a boss room rewards the player with random pickups #Taking damage makes the audience mad, launching tomatoes that leave a damaging creep and apply {{Bait}} Bait upon landing", "Laugh Sign",FileLanguage)		
EID:addCollectible(mod.Collectibles.LOLLYPOP, "A lollypop spawns on the ground every 25 seconds spent in an uncleared room #{{Collectible93}} Picking up these lollypops grants the Gamekid! effect for 5.5 seconds #!!! Stops spawning if 3 or more lollypops are on the ground", "Lollypop",FileLanguage)		
EID:addCollectible(mod.Collectibles.POCKET_ACES, "Tears have an 8% chance to become Aces #Ace cards deal the product of Isaac's {{Damage}} Damage and {{Tears}} Tears stat worth of damage #{{Luck}} Chance scales with luck", "Pocket Aces",FileLanguage)		
EID:addCollectible(mod.Collectibles.TRAGICOMEDY, "40% chance to wear a comedy or tragedy mask upon entering a room #\1 Wearing a comedy mask grants: {{Tears}} +1 Firedelay, {{Speed}} +0.2 Speed and {{Luck}} +2 Luck #\1 Wearing a tragedy mask grants: {{Tears}} +0.5 Firedelay, {{Damage}} +1 Flat Damage and {{Range}} +2.5 Range #!!! both mask can be worn at once", "Tragicomedy",FileLanguage)		
EID:addCollectible(mod.Collectibles.UMBRELLA, "Isaac opens an umbrella, causing anvils to fall on him every 5 ~ 7 seconds #Anvils can be reflected by the umbrella, sending them thorwards a random near enemy #Untouched anvils create damaging shockwaves and a pit #!!! Using the item again closes the umbrella, stopping the anvils from falling", "Umbrella",FileLanguage)		
EID:addCollectible(mod.Collectibles.OPENED_UMBRELLA, "Isaac opens an umbrella, causing anvils to fall on him every 5 ~ 7 seconds #Anvils can be reflected by the umbrella, sending them thorwards a random near enemy #Untouched anvils create damaging shockwaves and a pit #!!! Using the item again closes the umbrella, stooping the anvils from falling", "Umbrella",FileLanguage)		




----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------

EID:addCollectible(mod.Vouchers.Grabber, "{{PlayerJimbo}} {{ColorBlue}} +5 playable cards{{CR}} every room", "Grabber", FileLanguage)
EID:addCollectible(mod.Vouchers.NachoTong, "{{PlayerJimbo}} {{ColorBlue}} +5 additional playable cards{{CR}} every room", "Nacko Tong", FileLanguage)

EID:addCollectible(mod.Vouchers.Wasteful, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}}", "Wasteful", FileLanguage)
EID:addCollectible(mod.Vouchers.Recyclomancy, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}}", "Recyclomancy", FileLanguage)

EID:addCollectible(mod.Vouchers.Overstock, "{{PlayerJimbo}} Every future shop will have 1 additional Joker for sale", "Overstock", FileLanguage)
EID:addCollectible(mod.Vouchers.OverstockPlus, "{{PlayerJimbo}} Every future shop will have 1 additional Joker for sale", "Overstock Plus", FileLanguage)

EID:addCollectible(mod.Vouchers.Clearance, "{{PlayerJimbo}} Everything is discounted by {{ColorYellorange}} 25%{{CR}} #!!! Prices are rounded down", "Clearance Sale", FileLanguage)
EID:addCollectible(mod.Vouchers.Liquidation, "{{PlayerJimbo}} Everything is discounted by {{ColorYellorange}} 50%{{CR}} #!!! Prices are rounded down", "Liquidation", FileLanguage)

EID:addCollectible(mod.Vouchers.Hone, "{{PlayerJimbo}} Special {{ColorRainbow}}Editions{{CR}} become {{ColorYellorange}}2x{{CR}} more likely to appear", "Hone", FileLanguage)
EID:addCollectible(mod.Vouchers.GlowUp, "{{PlayerJimbo}} Special {{ColorRainbow}}Editions{{CR}} become {{ColorYellorange}}4x{{CR}} more likely to appear", "Glow Up", FileLanguage)

EID:addCollectible(mod.Vouchers.RerollSurplus, "{{PlayerJimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{ColorYellorange}}1 {{Coin}} Coins{{CR}}", "Reroll Surplus", FileLanguage)
EID:addCollectible(mod.Vouchers.RerollGlut, "{{PlayerJimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{ColorYellorange}}2 {{Coin}} Coins{{CR}}", "Reroll Glut", FileLanguage)

EID:addCollectible(mod.Vouchers.Crystal, "{{PlayerJimbo}} Every {{ColorYellorange}}Booster Pack{{CR}} has 1 more option to choose from", "Crystal Ball", FileLanguage)
EID:addCollectible(mod.Vouchers.Omen, "{{PlayerJimbo}} {{ColorPink}}Arcana Packs{{CR}} may contain spectral cards", "Omen Globe", FileLanguage)

EID:addCollectible(mod.Vouchers.Telescope, "{{PlayerJimbo}} Skipping a {{ColorCyan}}Celestial Pack{{CR}} creates {{ColorYellorange}}2{{CR}} additional random {{ColorCyan}}Planet Cards{{CR}}", "Telescope", FileLanguage)
EID:addCollectible(mod.Vouchers.Observatory, "{{PlayerJimbo}} Triggering a card while holding it's respective {{ColorCyan}}Planet Card{{CR}} gives {{Damage}}{{ColorMult}} X1.15{{CR}} Damage Multiplier#{{Planetarium}} Having the respective Planetarium item also counts", "Observatory", FileLanguage)

EID:addCollectible(mod.Vouchers.Blank, "{{PlayerJimbo}} {{ColorFade}}Nothing?{{CR}}", "Blank", FileLanguage)
EID:addCollectible(mod.Vouchers.Antimatter, "{{PlayerJimbo}} Adds a permanent {{ColorYellorange}}Joker Slot{{CR}} to the inventorycon pickup", "Antimatter", FileLanguage)

EID:addCollectible(mod.Vouchers.Brush, "{{PlayerJimbo}} Gives {{ColorChips}}+1 Hand Size{{CR}}", "Brush", FileLanguage)
EID:addCollectible(mod.Vouchers.Palette, "{{PlayerJimbo}} Gives {{ColorChips}}+1 additional Hand Size{{CR}}", "Palette", FileLanguage)

EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible105}} D6 effect", "Director's Cut", FileLanguage)
EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible283}} D100 effect", "Retcon", FileLanguage)

EID:addCollectible(mod.Vouchers.Hieroglyph, "{{PlayerJimbo}} Activates the {{Collectible127}} Forget Me Now! effect upon pickup", "Hieroglyph", FileLanguage)
EID:addCollectible(mod.Vouchers.Petroglyph, "{{PlayerJimbo}} Activates the {{Collectible127}} Forget Me Now! effect upon pickup", "Petroglyph", FileLanguage)

EID:addCollectible(mod.Vouchers.MagicTrick, "{{PlayerJimbo}} {{ColorMint}} 25% chance{{CR}} to be able to choose one more option from a pack #Can trigger Multiple times", "Magic Trick", FileLanguage)
EID:addCollectible(mod.Vouchers.Illusion, "{{PlayerJimbo}} Every pack opened has a{{ColorMint}} 55% chance{{CR}} to contain {{ColorYellorange}}2{{CR}} more options and a {{ColorMint}} 15% chance{{CR}} to let the player choose {{ColorYellorange}}1{{CR}} more option", "Observatory", FileLanguage)

EID:addCollectible(mod.Vouchers.MoneySeed, "{{PlayerJimbo}} Maximum interest increased to {{ColorYellow}}10${{CR}}", "Money Seed", FileLanguage)
EID:addCollectible(mod.Vouchers.MoneyTree, "{{PlayerJimbo}} Maximum interest increased to {{ColorYellow}}20${{CR}}", "Money Tree", FileLanguage)

EID:addCollectible(mod.Vouchers.PlanetMerch, "{{PlayerJimbo}} Every pickup has a {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card{{CR}}", "Planet Merchant", FileLanguage)
EID:addCollectible(mod.Vouchers.PlanetTycoon, "{{PlayerJimbo}} Every pickup has an additional {{ColorMint}}10% chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card{{CR}}", "Planet Tycoon", FileLanguage)

EID:addCollectible(mod.Vouchers.TarotMerch, "{{PlayerJimbo}} Every pickup has a {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Tarot Merchant", FileLanguage)
EID:addCollectible(mod.Vouchers.TarotTycoon, "{{PlayerJimbo}} Every pickup has an additional {{ColorMint}}10% chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Tarot Tycoon", FileLanguage)


























return Descriptions