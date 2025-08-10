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


Descriptions.Other.Active = "{{ColorYellorange}}Active!{{CR}}"
Descriptions.Other.Compatible = "{{ColorMint}}Compatible{{CR}}"
Descriptions.Other.Incompatible = "{{ColorMult}}Incompatible{{CR}}"
Descriptions.Other.Ready = "{{ColorYellorange}}Ready!{{CR}}"
Descriptions.Other.NotReady = "{{ColorRed}}Not ready!{{CR}}"

Descriptions.Other.Rounds = "Rounds"
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
Descriptions.Rarity["common"] = "{{ColorChips}}common{{CR}}"
Descriptions.Rarity["uncommon"] = "{{ColorMint}}uncommon{{CR}}"
Descriptions.Rarity["rare"] = "{{ColorMult}}rare{{CR}}"
Descriptions.Rarity["legendary"] = "{{ColorRainbow}}legendary{{CR}}"


Descriptions.Seal = {}
Descriptions.Seal[mod.Seals.NONE] = ""
Descriptions.Seal[mod.Seals.RED] = "# {{ColorMult}}Red Seal{{CR}}: This card's abilities are {{ColorYellorange}}Retriggered{{CR}} once"
Descriptions.Seal[mod.Seals.BLUE] = "# {{ColorCyan}}Blue Seal{{CR}}: Spawns the card's respective {{ColorCyan}}Planet{{CR}} card when holding this as a Blind is cleared #!!! {{ColorGray}}(Must have at least 1 scoring card)"
Descriptions.Seal[mod.Seals.GOLDEN] = "# {{ColorYellorange}}Golden Seal{{CR}}: spawns a {{Coin}} {{ColorYellorange}}Penny{{CR}} which disappears soon after when scored"
Descriptions.Seal[mod.Seals.PURPLE] = "# {{ColorPink}}Purple Seal{{CR}}: Spawns a random {{ColorPink}}Tarot{{CR}} card when {{ColorRed}}Discarded{{CR}}  #!!! {{ColorMint}}Lower chance{{CR}} for the effect to occur if multiple are discarded {{ColorYellorange}}at once{{CR}}"

Descriptions.CardEdition = {}
Descriptions.CardEdition[mod.Edition.BASE] = ""
Descriptions.CardEdition[mod.Edition.FOIL] = "#{{Tears}} {{ColorChips}}Foil{{CR}}: {{ColorChips}}+1.25{{CR}} Tears when scored"
Descriptions.CardEdition[mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{ColorMult}}Holographic{{CR}}: {{ColorMult}}+0.25{{CR}}Damage when scored"
Descriptions.CardEdition[mod.Edition.POLYCROME] = "#{{Damage}} {{ColorRainbow}}Polychrome{{CR}}: {{ColorMult}}x1.2{{CR}} Damage Multiplier when scored"
Descriptions.CardEdition[mod.Edition.NEGATIVE] = "#\1 {{ColorGray}}{{ColorFade}}Negative{{CR}}: wtf how did you even get this"


Descriptions.JokerEdition = {}
Descriptions.JokerEdition[mod.Edition.NOT_CHOSEN] = ""
Descriptions.JokerEdition[mod.Edition.BASE] = ""
Descriptions.JokerEdition[mod.Edition.FOIL] = "#{{Tears}} {{ColorChips}}Foil{{CR}}: {{ColorChips}}+2.5{{CR}} Tears while held"
Descriptions.JokerEdition[mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{ColorMult}}Holographic{{CR}}: {{ColorMult}}+0.5{{CR}} Damage while held"
Descriptions.JokerEdition[mod.Edition.POLYCROME] = "#{{Damage}} {{ColorRainbow}}Polychrome{{CR}}: {{ColorMult}}x1.25{{CR}} Damage Multiplier while held"
Descriptions.JokerEdition[mod.Edition.NEGATIVE] = "#\1 {{ColorGray}}{{ColorFade}}Negative{{CR}}: {{ColorYellorange}}+1{{CR}} Joker Slot while held"


Descriptions.Jimbo = {}
Descriptions.T_Jimbo = {}

----------------------------------------
-------------####JOKERS####-------------
-----------------------------------------

--EID:addTrinket(mod.Jokers.JOKER, "\1 {{ColorMult}}+1.2{{CR}} Damage", "Joker", FileLanguage)

Descriptions.Jimbo.Jokers = {}
do
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER] = "{{Damage}} {{ColorMult}}+0.2{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.BULL] = "{{Tears}} {{ColorChips}}+0.1{{CR}} Tears per {{Coin}} {{ColorYellow}}coin{{CR}} held {{ColorGray}}#{{Blank}} (Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Selling this Joker after clearing {{ColorYellorange}}3{{CR}} Blinds duplicates another held Joker [[VALUE2]] #{{Blank}} {{ColorGray}}(Currently [[VALUE1]])"
Descriptions.Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{Damage}} {{ColorMult}}+0.15{{CR}} Damage per Joker held #{{Damage}} {{ColorMult}}+0.03{{CR}} Damage per Collectible held #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{CR}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.MISPRINT] = "{{Damage}} {{ColorMult}}+0-1{{CR}} random Damage every new room #{{Collectible721}} {{ColorMint}}[[CHANCE]]/10 Chance{{CR}} for any item spawned to become a gliched"
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{Damage}} {{ColorMult}}X0.75{{CR}} Damage Multiplier per {{ColorYellorange}}empty{{CR}} Joker slot #!!! {{ColorYellorange}}Joker Stencil{{CR}} included #Gains {{ColorMult}}X0.25{{CR}} Damage Multiplier if no {{ColorYellorange}}{{Collectible}}Active item{{CR}} is held#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{CR}} Damage Multiplier)"
Descriptions.Jimbo.Jokers[mod.Jokers.STONE_JOKER] = "{{Tears}} {{ColorChips}}+1.25{{CR}} Tears per per {{ColorYellorange}}Stone card{{CR}} in your full deck #{{Tears}} {{ColorChips}}+0.05{{CR}} Tears per rock in the current room{{ColorGray}}#{{Blank}} (Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.ICECREAM] = "{{Tears}} {{ColorChips}}+[[VALUE1]]{{CR}} Tears#!!! Loses {{ColorChips}}-0.12{{CR}} Tears every room completed #Create a trail of slowing creep #Killing an enemy on top of the creep turns it in a Frozen Statue"
Descriptions.Jimbo.Jokers[mod.Jokers.POPCORN] = "{{Damage}} {{ColorMult}}+[[VALUE1]]{{CR}} Damage #!!! Loses {{ColorMult}}-0.2{{CR}} Damage every blind beaten"
Descriptions.Jimbo.Jokers[mod.Jokers.RAMEN] = "{{Damage}} {{ColorMult}}X[[VALUE1]]{{CR}}Damage Multiplier#!!! Loses {{ColorMult}}-0.01X{{CR}} per card discarded"
Descriptions.Jimbo.Jokers[mod.Jokers.ROCKET] = "Gives {{ColorYellow}}[[VALUE1]] {{Coin}} Coins{{CR}} on Blind clear#{{Coin}} Coin payout increases by {{ColorYellorange}}1{{CR}} when a boss blind is defeated #{{Collectible}} Grants the {{Collectible583}}Rocket in Jar effect"
Descriptions.Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{Tears}} Odd numbered cards give {{ColorChips}}+0.31{{CR}} Tears when scored#{{Tears}} {{ColorChips}}+0.07{{CR}} Tears per Collectible held if the total amount is odd"
Descriptions.Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{Damage}} {{ColorMult}}+0.04{{CR}} Damage per Even numbered card triggered this room #{{Damage}} {{ColorMult}}+0.02{{CR}} Damage per Collectible held if the total amount is even"
Descriptions.Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{ColorMint}}[[CHANCE]]/2 Chance{{CR}} to spawn a random {{Card}}{{ColorPink}}Tarot{{CR}} card when opening a {{ColorYellorange}}Booster Pack{{CR}}#\1 {{ColorMint}}[[CHANCE]]/2 Chance{{CR}} to give a {{Collectible431}} Multidimansional Baby every room entered"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "{{Damage}}{{ColorMult}}+0.04{{CR}} Damage per room completed#{{Damage}}{{ColorMult}}-0.16{{CR}}Damage on every hand discard #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{Damage}}{{ColorMult}}+0.15{{CR}} Damage per {{ColorYellorange}}Booster Pack{{CR}} skipped #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.VAGABOND] = "Spawns a random {{Card}}{{ColorPink}}Tarot{{CR}} card when clearing a room with {{ColorYellow}}2 {{Coin}} Coins or less{{CR}} #{{Beggar}} {{ColorMint}}[[CHANCE]]/10 Chance{{CR}} to spawn a random {{ColorYellorange}}Beggar{{CR}} when clearing a room"
Descriptions.Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "\1 Spawns a random {{ColorChips}}common{{CR}} Joker on every Blind Clear"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Gives {{ColorYellow}}4 {{Coin}} Coins{{CR}} on every Blind clear #{{Coin}} Every enemy touched becomes {{ColorYellorange}}golden{{CR}} for a short time"
Descriptions.Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{Damage}} {{ColorMult}}+0.04{{CR}} Damage per {{Card}}{{ColorPink}}Tarot{{CR}} card used throughout the run #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "\1 Copies the effect of the Joker to its right"
Descriptions.Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "\1 Copies the effect of the leftmost held Joker"
Descriptions.Jimbo.Jokers[mod.Jokers.MADNESS] = "Destroys another random Joker and gains {{ColorMult}}X0.1{{CR}} Damage Multiplier every {{ColorYellorange}}Small and Big Blind{{CR}} cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.MR_BONES] = "Revive at Full Hp if at least {{ColorYellorange}}half{{CR}} of the current Blind is cleared or during any {{BossRoom}}{{ColorYellorange}} Bossfight{{CR}} #{{ColorMint}}[[CHANCE]]/5 Chance{{CR}} to activate {{Collectible545}} Book of the Dead on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{Damage}} {{ColorChips}}Club{{CR}} cards give {{ColorMult}}+0.07{{CR}} Damage when scored #{{Damage}} {{ColorChips}}+0.07{{CR}} Damage per {{Bomb}} Bomb held"
Descriptions.Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{Tears}} {{ColorChips}}+0.5{{CR}} Tears per {{ColorSpade}}Spade{{CR}} card triggered in the room # {{Tears}} {{ColorChips}}+0.5{{CR}} Tears per {{Key}} Key held"
Descriptions.Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{ColorMint}} 1/2 chance{{CR}}per Heart card triggered to give {{Damage}} {{ColorMult}}X1.05{{CR}} Damage Multiplier"
Descriptions.Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{ColorMint}} 1/2 chance{{CR}}per Diamond card triggered to spawn a {{Coin}}Coin that disappears shortly after #Every {{ColorYellorange}}Dimaond{{CR}} card shot also has the {{Collectible506}} Backstabber effect"

Descriptions.Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{Damage}} {{ColorMult}}+0.75{{CR}}Damage #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destoroyed on every Blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.CAVENDISH] = "{{Damage}} {{ColorMult}}X1.5{{CR}}Damage multiplier #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destroyed on every Blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "{{Damage}} {{ColorMult}}+0.02{{CR}} Damage per {{RestockMachine}} Restock machine activated #{{Collectible105}} {{Damage}} {{ColorMult}}+0.02{{CR}} Damage per {{ColorYellorange}}Dice Item{{CR}} ussed"
Descriptions.Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Destroys the Joker to it's right and gains {{Damage}}{{ColorMult}} +0.08 x the destroyed Joker's sell value{{CR}} Damage on every Blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "Gain 1 {{Coin}} Coin per {{ColorYellorange}}9{{CR}} in your Full Deck on every Blind clear #{{Seraphim}} Gives Flight"
Descriptions.Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "{{Shop}} Gives {{Damage}}{{ColorMult}} +0.05 x the total sell value of other held Jokers{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "Spawns 1 random {{Card}} {{ColorPink}}Tarot Card{{CR}}on every Blind clear #{{ColorMint}}5% Chance{{CR}} for any pickup to be replaced with a random {{ColorPink}}Tarot Card{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{Damage}} {{ColorMult}}X2{{CR}} Damage multiplier once every 6 rooms cleares"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "When a card is played, gives {{Damage}}{{ColorMult}} +0.01{{CR}} Damage per time a card with the same Rank got played in the current room"
Descriptions.Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "Gives 1 coin per {{Heart}} Heart when clearing a room at full health #{{Timer}} Both the {{Boss}}Bossrush and {{Hush}} Hush door open regardless of the ingame timer"
Descriptions.Jimbo.Jokers[mod.Jokers.EGG] = "The sell value of this Joker increases by{{ColorYellorange}} +2${{CR}} every {{ColorYellorange}}Blind cleared{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.DNA] = "If the {{ColorYellorange}} First{{CR}}card triggered in a {{ColorYellorange}}Blind{{CR}} hits an enemy, a copy of that card is added to the deck #{{Collectible658}} Spawns a Mini-Isaac every Hostile room cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{ColorMult}}Hearts{{CR}} and {{ColorYellorange}}Diamonds{{CR}} count as the same suit #{{ColorSpade}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit"

Descriptions.Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{ColorChips}}+4{{CR}}Tears if a {{ColorYellorange}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{ColorChips}}+8{{CR}}Tears if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{ColorChips}}+7{{CR}}Tears if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{ColorChips}}+12{{CR}}Tears if a {{ColorYellorange}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{ColorChips}}+9{{CR}}Tears if a {{ColorYellorange}}Flush{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{ColorMult}}+1{{CR}}Damage if a {{ColorYellorange}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{ColorMult}}+2{{CR}}Damage if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{ColorMult}}+1.75{{CR}}Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{ColorMult}}+3{{CR}}Damage if a {{ColorYellorange}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{ColorMult}}+2.25{{CR}}Damage if a {{ColorYellorange}}Flush{{CR}} is held when entering a room"

Descriptions.Jimbo.Jokers[mod.Jokers.MIME] = "{{ColorYellorange}}Retriggers{{CR}} all {{ColorYellorange}}held in hand{{CR}} effects #{{ColorMint}}20% Chance{{CR}} to copy the effect of an Active Item or consumable used"
Descriptions.Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{ColorYellorange}}Flushes{{CR}} and {{ColorYellorange}}Straights{{CR}} only need 4 compatible cards #Every fifth non-boss enemy spawned gets killed immediantly"
Descriptions.Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{ColorMult}}+0.03{{CR}}Damage per triggered {{ColorMult}}Heart{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{ColorMult}}+0.03{{CR}}Damage per triggered {{ColorYellorange}}Diamond{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{ColorMult}}+0.03{{CR}}Damage per triggered {{ColorSpade}}Spade{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{ColorMult}}+0.03{{CR}}Damage per triggered {{ColorChips}}Club{{CR}} card {{ColorYellorange}}triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{ColorRed}}+2 Hp{{CR}} #{{ColorCyan}}-2 Hand size{{CR}} while held"
Descriptions.Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{ColorMult}}+1.5{{CR}}Damage when{{CR}}5 or less{{CR}} card have been played in the current room #{{ColorMult}}+1{{CR}}Damage when having {{ColorYellorange}}3 or less{{CR}} cards in hand"
Descriptions.Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Allows to go in {{ColorYellorange}}debt{{CR}} by spending more coins than you have#{{Shop}} Items on sale can only be bought with a maximum of {{ColorMult}}-20${{CR}} debt #!!! Interest and money-based effects cannot trigger while in debt"

Descriptions.Jimbo.Jokers[mod.Jokers.BANNER] = "{{ColorChips}}+1.5{{CR}} Tears per full {{Heart}}Red heart"
Descriptions.Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{ColorMult}}+0.75{{CR}}Damage while having only 1 full Red Heart"
Descriptions.Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "Adds a {{ColorGray}}Stone card{{CR}} to the deck every blind cleared"
Descriptions.Jimbo.Jokers[mod.Jokers._8_BALL] = "{{ColorMint}}1/8 Chance{{CR}} to spawn a random {{Card}} {{ColorPink}}Tarot card{{CR}} when an {{ColorYellorange}}8{{CR}} is triggered"
Descriptions.Jimbo.Jokers[mod.Jokers.DUSK] = "The {{ColorYellorange}}last 10{{CR}} triggerable cards shot get retriggered an additional time"
Descriptions.Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "The held card with the {{ColorYellorange}}lowest Rank{{CR}} gives {{ColorMult}}0.05{{CR}} {{ColorYellorange}} X its Rank{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "Every {{Shop}} Shop visited has an additional Restock Machine"
Descriptions.Jimbo.Jokers[mod.Jokers.FIBONACCI] = "{{ColorMult}}+0.08{{CR}}Damage per {{ColorYellorange}}Ace, 2, 3, 5 and 8{{CR}} triggered this room"
Descriptions.Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "This gains {{ColorMult}}+0.15X{{CR}}Damage Multiplier per {{ColorSilver}}Steel card{{CR}} in your deck"
Descriptions.Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{ColorChips}}+0.3{{CR}}Tears per {{ColorYellorange}}Face card{{CR}} triggered #{{ColorChips}}+1{{CR}}Tears per {{ColorYellorange}}Champion enemy{{CR}} killed this room"
Descriptions.Jimbo.Jokers[mod.Jokers.HACK] = "Played {{ColorYellorange}}2, 3, 4 and 5{{CR}} get retrigged #Jimbo gains a copy of every {{Quality0}} and {{Quality1}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Every card counts as a {{ColorYellorange}}Face card{{CR}} #{{ColorMint}}1/5 Chance{{CR}} for any non-boss enemy to become a {{ColorYellorange}}Champion{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.SCHOLAR] = "{{ColorMult}}+0.04{{CR}} Damage and {{ColorChips}}+0.1{{CR}} Tears per {{ColorYellorange}}Ace{{CR}} triggered"
Descriptions.Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{ColorMint}}1/2 Chance{{CR}} to spawn 2 vanishing Pennies when a {{ColorYellorange}}Face card{{CR}} is triggered #Gain the {{Collectible602}} Member Card effect"
Descriptions.Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{ColorMult}}+0.01{{CR}}Damage per consecutive {{ColorYellorange}}non-Face card{{CR}} triggered"
Descriptions.Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{ColorMint}}1/20 Chance{{CR}} to upgrade the played card Rank's level #Gains an additional {{ColorMint}}1/20 Chance{{CR}} per {{ColorYellorange}}Star-related{{CR}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.BURGLAR] = "Sets your Hp to {{ColorRed}}1{{CR}} Heart#Cards can be triggered until the deck gets {{ColorYellorange}}reshuffled{{CR}} every room"
Descriptions.Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{ColorMult}}X2{{CR}}Damage Multiplier if all cards held in hand are {{ColorSpade}}Spades{{CR}} or {{ColorChips}}Clubs{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.RUNNER] = "This joker gains {{ColorChips}}+2{{CR}} Tears when entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} in hand #Gives {{ColorChips}}+Tears{{CR}} equal to your speed stat#{{Speed}} +0.1 Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.SPLASH] = "Triggers all cards in hand upon entering a hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{ColorChips}}+0.1{{CR}}Tears per remaining card in your deck"
Descriptions.Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "If the {{ColorYellorange}}First{{CR}} card played in a {{ColorYellorange}}Blind{{CR}} is a {{ColorYellorange}}6{{CR}} and hits an enemy, it gets destroyed and spawns a {{ColorBlue}}Spectral Pack{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "This Jokers gains {{ColorMult}}+0.04X{{CR}} Damage Multiplier every time a {{ColorCyan}}Planet Card{{CR}} is used while holding it"
Descriptions.Jimbo.Jokers[mod.Jokers.HIKER] = "{{ColorYellorange}}Triggering{{CR}} a card gives it a {{ColorYellorange}}permanent{{CR}} {{ColorMult}}+0.02{{CR}} Tears upgrade"
Descriptions.Jimbo.Jokers[mod.Jokers.FACELESS] = "Gain {{ColorMult}}+3${{CR}} when discarding {{ColorYellorange}}at least 2 Face cards{{CR}} at the same time #If only {{ColorYellorange}}Non-boss champion{{CR}} enemies are left in the room, they are {{ColorYellorange}}killed instantly{{CR}} spawning a vanishing penny"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "Entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} and an {{ColorYellorange}}Ace{{CR}} spawns an {{ColorPink}}Arcana Pack{{CR}} #Grants 2 {{Collectible128}} Forever Alone Flies"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "A random {{ColorYellorange}}Card Rank{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Playing{{CR}} a card with that Rank spawns a vanishing penny"

Descriptions.Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when {{ColorYellorange}}Scoring{{CR}} 2 cards with the same rank consecutevely #{{Collectible665}} Allows Isaac to see the content of chests and sacks"
Descriptions.Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "Gives {{ColorChips}}+4{{CR}} Tears every fourth card shot #{{Pill}} Gains {{ColorChips}}+0.4{{CR}} Tears every time a {{ColorYellorange}}Retro Vision{{CR}} pill is used"
Descriptions.Jimbo.Jokers[mod.Jokers.SEANCE] = "Spawns a {{ColorYellorange}}Spectral Pack{{CR}} if a {{ColorYellorange}}Straight Flush{{CR}} is held when entering a room #{{Collectible727}} {{ColorMint}}1/6 chance{{CR}} to spawn a {{ColorYellorange}}Hungry Soul{{CR}} when killing an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.VAMPIRE] = "When a card with an {{ColorYellorange}}Enhancement{{CR}} is {{ColorYellorange}}Scored{{CR}}, this gains {{ColorChips}}+0.02X{{CR}} Damage Multiplier and removes the card's {{ColorYellorange}}Enhancement{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Allows {{ColorYellorange}}Straights{{CR}} to be made with gaps of {{ColorYellorange}}1 rank{{CR}} #{{Collectible84}} Creates a {{ColorYellorange}}Crawl space{{CR}} in a random room every floor #{{Collectible84}} immediantly opens all {{ColorYellorange}}Secret Room{{CR}} doors"
Descriptions.Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "This gains {{ColorMult}}+0.1X{{CR}}Damage Multiplier when a card gets {{ColorYellorange}}Added{{CR}} to the deck"

Descriptions.Jimbo.Jokers[mod.Jokers.BARON] = "Every {{ColorYellorange}}King{{CR}} held in hand gives {{ColorMult}}X1.25{{CR}} Damage Multiplier #{{Quality4}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per Q4 item held"
Descriptions.Jimbo.Jokers[mod.Jokers.OBELISK] = "This gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier when {{ColorYellorange}}scoring{{CR}} a card with a different {{ColorYellorange}}Suit{{CR}} from the last"
Descriptions.Jimbo.Jokers[mod.Jokers.MIDAS] = "Every {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} becomes {{ColorYellorange}}Golden{{CR}}#{{ColorYellorange}}Champion{{CR}} enemies are breifly turned into golden statues when spawning"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{ColorYellorange}}Selling{{CR}} this joker causes a {{Collectible483}}Mama Mega! explosion and weakens all {{ColorYellorange}}Bosses{{CR}} in the room"
Descriptions.Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "The first {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} every room gives {{ColorMult}}X1.2{{CR}} Damage Multiplier when {{ColorYellorange}}Scored{{CR}} #Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when killing the first {{ColorYellorange}}Champion{{CR}} enemy in the room "
Descriptions.Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "Every joker held gains {{ColorChips}}+1${{CR}} selling value when clearing a blind"
Descriptions.Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "Gains {{ColorCyan}}+3{{CR}} Hand Size #Bonus is decreased by {{ColorRed}}-1{{CR}} every blind beaten"
Descriptions.Jimbo.Jokers[mod.Jokers.EROSION] = "This gains {{ColorChips}}+0.15{{CR}} Damage when a card gets {{ColorYellorange}}Destroyed{{CR}} #This gains {{ColorChips}}+0.1{{CR}} Damage when a {{ColorYellorange}}Tinted Rock{{CR}} gets {{ColorYellorange}}Destroyed{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "When clearing a room every {{ColorYellorange}}Face{{CR}} card held has a {{ColorMint}}1/4 chance{{CR}} to spawn a penny #When killing an enemy every other {{ColorYellorange}}Champion{{CR}} enemy has a {{ColorMint}}1/2 chance{{CR}} to spawn a penny around it"

Descriptions.Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "A random {{ColorYellorange}}Card rank{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Discarding{{CR}} a card with that rank spawns 2 {{Coin}} pennies"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "Gain {{ColorYellow}}+1${{CR}} per {{ColorYellorange}}Interest{{CR}} at the end of a blind"
Descriptions.Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{ColorChips}}+1 Hand Size{{CR}} #+1 {{ColorYellorange}}consumable slot{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{Heart}}{{ColorMult}} +1 Health up{{CR}} #Healing when at full heath makes Isaac vision more distorted #Taking damage reverts the distorsion"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "This gains {{ColorMult}}+0.02X{{CR}} Damage Multiplier when a {{ColorMint}}Lucky Card{{CR}} procs or when a {{Slotmachine}} Slot pays out"
Descriptions.Jimbo.Jokers[mod.Jokers.BASEBALL] = "Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per {{ColorMint}}Uncommon{{CR}} Joker held #Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier per {{Quality2}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.DIET_COLA] = "Copies the {{Collectible347}} Diplopia effect when {{ColorYellorange}}Sold{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "{{PlayerJimbo}}{{ColorYellorange}}Destroys{{CR}} every card in hand when {{ColorYellorange}}Sold{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "{{PlayerJimbo}}This gains {{ColorMult}}+0.25{{CR}} Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room #Gives {{ColorMult}}+0.1{{CR}} Damage per active costume the player has"
Descriptions.Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "A random {{ColorYellorange}}Card suit{{CR}} is chosen upon entering an hostile room #Gives {{ColorMult}}X1.05{{CR}} Damage Multiplier every time a card with that {{ColorYellorange}}Suit{{CR}} is {{ColorYellorange}}Triggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "{{ColorChips}}+0.1{{CR}} Tears and {{ColorChips}}+0.04{{CR}} Damage per {{ColorYellorange}}10{{CR}} and {{ColorYellorange}}4{{CR}} triggered this room"
Descriptions.Jimbo.Jokers[mod.Jokers.SELTZER] = "Every card played in the next 15 rooms gets {{ColorYellorange}}Retriggered{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "Gives {{ColorMult}}+0.05{{CR}} Damage per {{ColorYellorange}}Face card{{CR}} triggered this room #Gives {{ColorMult}}+0.15{{CR}} Damage per {{ColorYellorange}}Champion{{CR}} enemy killed this room"
Descriptions.Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier per sold Joker this {{ColorYellorange}}Ante{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.CASTLE] = "A random {{ColorYellorange}}Card suit{{CR}} is chosen upon entering an hostile room #This gains {{ColorChips}}+0.04{{CR}} Tears when {{ColorYellorange}}Discarding{{CR}} a card with that {{ColorYellorange}}Suit{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "Gain {{ColorYellow}}+2${{CR}} every time a {{ColorYellorange}}Golden card{{CR}} is triggered #Every pickup has a {{ColorMint}}1/25 chance{{CR}} to become its {{ColorYellorange}}Golden{{CR}} variant"
Descriptions.Jimbo.Jokers[mod.Jokers.ACROBAT] = "Gives {{ColorMult}}X2{{CR}} Damage Multipier when {{ColorYellorange}}5 or less{{CR}} scoring cards are left"
Descriptions.Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{ColorYellorange}}Face card{{CR}} played get {{ColorYellorange}}Retriggered{{CR}} #On {{ColorYellorange}}Champion kill{{CR}} Joker effects get retriggered"
Descriptions.Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{ColorYellorange}}+2{{CR}} Hand Size #{{ColorBlue}}-5 playable cards{{CR}} every room"
Descriptions.Jimbo.Jokers[mod.Jokers.THROWBACK] = "This gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier per {{ColorYellorange}}Special room{{CR}} skipped in this run"
Descriptions.Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "A card with a {{ColorYellorange}}Random Seal{{CR}} is added to the deck every time a {{ColorYellorange}}Blind{{CR}} is cleared"
Descriptions.Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "The {{ColorYellorange}}first{{CR}} card played is {{ColorYellorange}}triggered{{CR}} 3 additional times #The {{ColorYellorange}}first{{CR}} card used every floor spawns a copy of itself"
Descriptions.Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier every time a {{ColorGlass}}Glass Card{{CR}} is destroyed"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{ColorYellorange}}Items{{CR}},{{ColorYellorange}}Joker{{CR}},{{ColorPink}}Tarot{{CR}},{{ColorCyan}}Planet{{CR}} and {{ColorBlue}}Spectral{{CR}} cards may appear multiple times"
Descriptions.Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{ColorChips}}X1.5{{CR}} Damage Multiplier if every {{ColorYellorange}}Suit{{CR}} is held in hand when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "This gains {{ColorChips}}+0.04{{CR}} Tears when a {{ColorYellorange}}2{{CR}} is {{ColorYellorange}}triggered{{CR}}#The samller you are, the higher the stats gained"
Descriptions.Jimbo.Jokers[mod.Jokers.OOPS_6] = "Every {{ColorMint}}Listed Chance{{CR}} is Doubled"
Descriptions.Jimbo.Jokers[mod.Jokers.IDOL] = "A random {{ColorYellorange}}Card{{CR}} from your deck is chosen upon entering an hostile room #Playing a card with the same {{ColorYellorange}}Value and Suit{{CR}} gives {{ColorMult}}X1.1{{CR}} Damage Multiplier"
Descriptions.Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{ColorMult}}X1.2{{CR}} Damage Multiplier when entering an hostile room while holding both a {{ColorClub}}Club{{CR}} and a {{ColorYellorange}}Not-club{{CR}} card in hand"
Descriptions.Jimbo.Jokers[mod.Jokers.MATADOR] = "Gain {{ColorYellow}}+6${{CR}} when taking damage from a {{ColorYellorange}}Boss{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier every time a {{ColorYellorange}}Jack{{CR}} is discarded #!!! Resets every beaten {{ColorYellorange}}Blind{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.DUO] = "{{ColorMult}}X1.25{{CR}} Damage Mutiplier if a {{ColorYellorange}}Pair{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIO] = "{{ColorMult}}X1.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Three of a Kind{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.FAMILY] = "{{ColorMult}}X2{{CR}} Damage Mutiplier if a {{ColorYellorange}}Four of a Kind{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.ORDER] = "{{ColorMult}}X2.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Straight{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBE] = "{{ColorMult}}X1.35{{CR}} Damage Mutiplier if a {{ColorYellorange}}Flush{{CR}} is held when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{ColorMult}}+12.5{{CR}} Tears #{{ColorMult}}-3{{CR}} Hand Size"
Descriptions.Jimbo.Jokers[mod.Jokers.SATELLITE] = "Gain {{ColorYellow}}1 {{Coin}} Coin{{CR}} per unique {{ColorCyan}}Planet{{CR}} card used this run when clearing a {{colorYellorange}}Blind{{ColorGray}}#(Currently {{ColorYellow}}[[VALUE1]] Coins{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{ColorMult}}+0.7{{CR}} Damage per {{ColorYellorange}}Queen{{CR}} held in hand when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{ColorMult}}X1.5{{CR}} Damage Multiplier if there are at least {{ColorYellorange}}18 Enhanced cards{{CR}} in your full deck #Having either the {{Adult}} Adult, {{Mom}} Mom or {{Bob}} Bob transformation also activates the effect"
Descriptions.Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "Every {{ColorCyan}}Planet card{{CR}},{{ColorCyan}}Celestial Pack{{CR}} and {{ColorYellorange}}Star-themed{{CR}} item is free"
Descriptions.Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{ColorCyan}}Upgrades{{CR}} the level of {{ColorYellorange}}discarded{{CR}} cards that hit an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{Damage}} {{ColorMult}}+0.1{{CR}} Damage per {{ColorYellorange}}5 {{Coin}} coins{{CR}} held {{ColorGray}}#{{Blank}} (Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"

Descriptions.Jimbo.Jokers[mod.Jokers.CANIO] = "This gains {{ColorMult}}+0.25X{{CR}} Damage Multiplier when a {{ColorYellorange}}Face card{{CR}} is {{ColorYellorange}}Destroyed{{CR}} #All {{COlorYellorange}}Champion{{CR}} enemies are immediantly killed"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{ColorMult}}X1.2{{CR}} Damage Multiplier per {{ColorYellorange}}King or Queen{{CR}} scored this room"
Descriptions.Jimbo.Jokers[mod.Jokers.YORICK] = "This gains {{ColorMult}}+0.25X{{CR}} Damage Multiplier every {{ColorYellorange}}23{{CR}} cards discarded"
Descriptions.Jimbo.Jokers[mod.Jokers.CHICOT] = "{{Weakness}} Every {{ColorYellorange}}Boss{{CR}} is permanently  weakened #Disables every curse"
Descriptions.Jimbo.Jokers[mod.Jokers.PERKEO] = "Spawns a duplicate of every {{ColorYellorange}}Consumable{{CR}} held upon entering a {{Shop}} shop or a new floor"
end


Descriptions.T_Jimbo.Jokers = {}
do
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER] = "{{ColorMult}}+4{{B_Black}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BULL] = " {{ColorChips}}+2{{B_Black}} Chips per {{ColorYellow}}1${{B_Black}} you have# {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "After {{ColorYellorange}}2{{B_Black}} rounds, sell this Joker to {{ColorYellorange}}Duplicate{{B_Black}} a random Joker {{ColorGray}}[[VALUE2]]#(Currently [[VALUE1]])"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{ColorMult}}+3{{B_Black}} Mult per Joker card# {{ColorGray}} (Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MISPRINT] = " {{ColorMult}}+0-23{{B_Black}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{ColorMult}}X1{{B_Black}} Mult per empty Joker slot#{{B_Black}}Joker Stencil included# {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STONE_JOKER] = " {{ColorChips}}+25{{B_Black}} Chips per {{ColorYellorange}}Stone card{{B_Black}} in your {{ColorYellorange}}Full deck{{B_Black}} {{ColorGray}}#(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ICECREAM] = " {{ColorChips}}+[[VALUE1]]{{B_Black}} Chips#Loses {{ColorChips}}-5{{B_Black}} Chips every hand played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.POPCORN] = " {{ColorMult}}+[[VALUE1]]{{B_Black}} Mult #Loses {{ColorMult}}-4{{B_Black}} Mult every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAMEN] = " {{ColorMult}}X[[VALUE1]]{{B_Black}} Mult#loses {{ColorMult}}-0.01X{{B_Black}} per card discarded"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROCKET] = "Earn {{ColorYellow}}[[VALUE1]]${{B_Black}} at the end of round#Payout increases by {{ColorYellorange}}2${{B_Black}} when a boss blind is defeated"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ODDTODD] = "Played cards with {{ColorYellorange}}odd{{B_Black}} rank give {{ColorChips}}+31{{B_Black}} Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "Played cards with {{ColorYellorange}}even{{B_Black}} rank give {{ColorChips}}+4{{B_Black}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{ColorMint}}[[CHANCE]]/2 Chance{{B_Black}} to create a{{ColorPink}}Tarot{{B_Black}} card when opening a {{ColorYellorange}}Booster Pack"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "This gains {{ColorMult}}+1{{B_Black}} Mult per hand played#{{ColorMult}}-1{{B_Black}} Mult per discard #{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{ColorMult}}+3{{B_Black}} Mult per {{ColorYellorange}}Booster Pack{{B_Black}}#{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAGABOND] = "Creates a{{ColorPink}}Tarot{{B_Black}} card when a hand is played with {{ColorYellow}}4${{B_Black}} or less"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "When a{{ColorYellorange}}Blind{{B_Black}} is selected, creates up to 2 {{ColorChips}}common{{ColorYellorange}}Jokers{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Earn {{ColorYellow}}4${{B_Black}} at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{ColorMult}}+1{{B_Black}}Mult per {{ColorPink}}Tarot{{B_Black}} card used this run # {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "Copies the effect of the {{ColorYellorange}}Joker{{B_Black}} to its right#{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "Copies the effect of the leftmost held {{ColorYellorange}}Joker{{B_Black}}#{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MADNESS] = "When a {{ColorYellorange}}Small{{B_Black}} or {{ColorYellorange}}Big Blind{{B_Black}} is selected, destroys another random Joker and gains {{ColorMult}}X0.5{{B_Black}} Mult# {{ColorGray}}(Currently X[[VALUE]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MR_BONES] = "{{ColorMult}}Prevents Death{{B_Black}} and {{ColorYellorange}}self desctructs{{B_Black}} if the enemy with the most HP has up to{{ColorYellorange}}75% of the blind's base size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{ColorChips}}Club{{B_Black}} cards give{{ColorMult}}+7{{B_Black}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{ColorSpade}}Spade{{B_Black}} cards give{{ColorChips}}+50{{B_Black}}Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{ColorMult}}Heart{{B_Black}} card have a{{ColorMint}}[[CHANCE]]/2 chance{{B_Black}} to give {{ColorMult}}X1.5{{B_Black}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{ColorYellorange}}Diamond{{B_Black}} cards give {{ColorYellow}}1${{B_Black}} when scored"

Descriptions.T_Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = " {{ColorMult}}+15{{B_Black}}Mult #{{ColorMint}}[[CHANCE]]/6 chance{{B_Black}} of getting destoroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAVENDISH] = " {{ColorMult}}X3{{B_Black}}Mult # {{ColorMint}}[[CHANCE]]/1000 chance{{B_Black}} of getting destroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "This gains {{ColorMult}}+2{{B_Black}} Mult every {{ColorYellorange}}Shop{{ColorMint}}Reroll #{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "When a blind is selcted, destroys the Joker to its right and gains {{ColorMult}}+double its sell value{{B_Black}} Mult #{{ColorGrey}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "Earn {{ColorYellow}}1${{B_Black}} per {{ColorYellorange}}9{{B_Black}} in your {{ColorYellorange}}Full Deck{{B_Black}} at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "Adds the sell value of other owned{{ColorYellorange}}Jokers{{B_Black}}# {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "When a {{ColorYellorange}}blind{{B_Black}} is selected creates a{{ColorPink}}Tarot{{B_Black}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = " {{ColorMult}}X4{{B_Black}} Mult once every {{ColorYellorange}}6{{B_Black}}hands played # {{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "Adds ne number of times {{ColorYellorange}}Poker hand{{B_Black}} was played to {{ColorMult}}Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "Earn {{ColorYellow}}2${{B_Black}} per {{ColorMult}}Discard{{B_Black}} if none were used at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EGG] = "The sell value of this Joker increases by {{ColorYellorange}}2${{B_Black}} every {{ColorYellorange}}Blind{{B_Black}} cleared"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DNA] = "If the {{ColorYellorange}}First hand{{B_Black}} of round only contains {{ColorYellorange}}1{{B_Black}} card, add a copy to your {{ColorYellorange}}Deck{{B_Black}} and draw it in hand #{{ColorGray}}[[VALUE1]]"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{ColorMult}}Hearts{{B_Black}} and {{ColorYellorange}}Diamonds{{B_Black}} count as the same suit #{{ColorSpade}}Spades{{B_Black}} and {{ColorBlue}}Clubs{{B_Black}} count as the same suit"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{ColorChips}}+50{{B_Black}}Chips if hand played contains a {{ColorYellorange}}Pair{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{ColorChips}}+100 {{B_Black}}Chips if hand played contains a {{ColorYellorange}}Three of a Kind{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{ColorChips}}+80 {{B_Black}}Chips if hand played contains a {{ColorYellorange}}Two Pair{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{ColorChips}}+100 {{B_Black}}Chips if hand played contains a {{ColorYellorange}}Striaght{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{ColorChips}}+80 {{B_Black}}Chips if hand played contains a {{ColorYellorange}}Flush{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{ColorMult}}+8 {{B_Black}}Mult if hand played contains a {{ColorYellorange}}Pair{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{ColorMult}}+12 {{B_Black}}Mult if hand played contains a {{ColorYellorange}}Three of a Kind{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{ColorMult}}+10 {{B_Black}}Mult if hand played contains a {{ColorYellorange}}Two Pair{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{ColorMult}}+12 {{B_Black}}Mult if hand played contains a {{ColorYellorange}}Straight{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{ColorMult}}+10 {{B_Black}}Mult if hand played contains a {{ColorYellorange}}Flush{{B_Black}}"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MIME] = "{{ColorYellorange}}Retriggers{{B_Black}} all {{ColorYellorange}}held in hand{{B_Black}} abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{ColorYellorange}}Flushes{{B_Black}} and {{ColorYellorange}}Straights{{B_Black}} only need 4 cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{ColorMult}}Heart{{B_Black}} cards give {{ColorMult}}+3{{B_Black}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{ColorYellorange}}Diamond{{B_Black}} cards give {{ColorMult}}+3{{B_Black}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{ColorSpade}}Spade{{B_Black}} cards give {{ColorMult}}+3{{B_Black}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{ColorChips}}Club{{B_Black}} cards give {{ColorMult}}+3 {{B_Black}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{ColorYellorange}}+3{{B_Black}} #{{ColorMult}}-1{{B_Black}} Hand size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{ColorMult}}+20{{B_Black}}Mult when hand played has {{ColorYellorange}}3 or less{{B_Black}} cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Shop items can be bought with up to {{ColorMult}}-20${{B_Black}} in debt #{{ColorGray}}(Effect is stackable)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BANNER] = "{{ColorChips}}+30{{B_Black}}Chips per remaining{{ColorYellorange}}Discard{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{ColorMult}}+15{{B_Black}} when with {{ColorYellorange}}0{{B_Black}} discards remaining"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "When a {{ColorYellorange}}Blind{{B_Black}} is selected, adds {{ColorYellorange}}Stone card{{B_Black}} is added to the deck"
Descriptions.T_Jimbo.Jokers[mod.Jokers._8_BALL] = "{{ColorMint}}[[CHANCE]]/4 Chance{{B_Black}} to create a{{ColorPink}}Tarot{{B_Black}}card when an {{ColorYellorange}}8{{B_Black}} is scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUSK] = "{{ColorYellorange}}Retriggers{{B_Black}} last hand of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "Adds {{ColorYellorange}}double{{B_Black}} the rank of the {{ColorYellorange}}lowest{{B_Black}} ranked card held in hand to {{ColorMult}}Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{ColorYellorange}}1{{B_Black}} free {{ColorMint}}Reroll{{B_Black}} per shop"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FIBONACCI] = "Every {{ColorYellorange}}Ace{{B_Black}}, {{ColorYellorange}}2{{B_Black}}, {{ColorYellorange}}3{{B_Black}}, {{ColorYellorange}}5{{B_Black}} and {{ColorYellorange}}8{{B_Black}} gives {{ColorMult}}+8{{B_Black}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "This gains {{ColorMult}}X0.2{{B_Black}}Mult per {{ColorYellorange}}Steel card{{B_Black}} in your full deck"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{ColorYellorange}}Face cards{{B_Black}} give {{ColorChips}}+30{{B_Black}}Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HACK] = "Retriggers {{ColorYellorange}}2, 3, 4 and 5{{B_Black}} played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Every card counts as a {{ColorYellorange}}Face card{{B_Black}}"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SCHOLAR] = "{{ColorYellorange}}Aces{{B_Black}} give {{ColorMult}}+4{{B_Black}} Mult and {{ColorChips}}+20{{B_Black}} Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{ColorYellorange}}Face cards{{B_Black}} have a {{ColorMint}}[[CHANCE]]/2 Chance{{B_Black}} to give{{ColorYellow}}2${{B_Black}} when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{ColorMult}}+1{{B_Black}}Mult per consecutive hand played without a {{ColorYellorange}}scoring Face card#{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{B_Black}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{ColorMint}}[[CHANCE]]/4 Chance{{B_Black}} to upgrade level of played {{ColorYellorange}}Poker hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURGLAR] = "After a round starts, removes all {{ColorMult}}Discards{{B_Black}} and gain {{ColorChips}}+3{{B_Black}} hands"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{ColorMult}}X3{{B_Black}}Mult if all cards held in hand are {{ColorSpade}}Spades{{B_Black}} or {{ColorChips}}Clubs{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RUNNER] = "This gains {{ColorChips}}+15{{B_Black}} Chips when played hand contains a {{ColorYellorange}}Straight#{{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPLASH] = "All {{ColorYellorange}}played cards{{B_Black}} are considered in scoring"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{ColorChips}}+2{{B_Black}}Chips per remaining card in your deck # {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "If the {{ColorYellorange}}First{{B_Black}} hand played is a single {{ColorYellorange}}6{{B_Black}}, destroy it and create a {{ColorBlue}}Spectral{{B_Black}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "This Jokers gains {{ColorMult}}X0.1{{B_Black}} Mult every time a {{ColorCyan}}Planet{{B_Black}} card is used#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIKER] = "Cards gain {{ColorChips}}+5{{B_Black}} permanent Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FACELESS] = "Gain {{ColorYellow}}5${{B_Black}} when discarding {{ColorYellorange}}3 or more Face cards{{B_Black}} at once"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "Create a {{ColorPink}}Tarot{{B_Black}} card when played hand contains a {{ColorYellorange}}Straight{{B_Black}} and an {{ColorYellorange}}Ace{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "Gain {{ColorYellow}}4${{B_Black}} when played hand is a {{ColorYellorange}}[[VALUE1]]{{B_Black}}#(Hand changes every round)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{ColorChips}}X3{{B_Black}} Mult if {{ColorYellorange}}Poker hand{{B_Black}} was alredy played this round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "This gains {{ColorChips}}+4{{B_Black}} Chips if hand played contains exactly {{ColorYellorange}}4{{B_Black}} cards#{{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEANCE] = "Creates a {{ColorYellorange}}Spectral{{B_Black}} card If a {{ColorYellorange}}Straight Flush{{B_Black}} is played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAMPIRE] = "When a card with an {{ColorYellorange}}Enhancement{{B_Black}} is scored, this gains {{ColorChips}}X0.1{{B_Black}} Mult and removes the card's {{ColorYellorange}}Enhancement{{B_Black}}#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Allows {{ColorYellorange}}Straights{{B_Black}} to be made with gaps of {{ColorYellorange}}1 rank{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "This gains {{ColorMult}}X0.25{{B_Black}}Mult when a card gets {{ColorYellorange}}added{{B_Black}} to the deck#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BARON] = "Every {{ColorYellorange}}King{{B_Black}} held in hand gives {{ColorMult}}X1.5{{B_Black}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OBELISK] = "This gains {{ColorMult}}+0.2X{{B_Black}} Mult per {{ColorYellorange}}consecutive{{B_Black}} hand played without playing you most played {{ColorYellorange}}Poker hand{{B_Black}}#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MIDAS] = "Every scoring {{ColorYellorange}}Face card{{B_Black}} becomes {{ColorYellorange}}Golden{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{ColorYellorange}}Selling{{B_Black}} this Joker disables all {{ColorYellorange}}Boss abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "First Scoring {{ColorYellorange}}Face card{{B_Black}} gives {{ColorMult}}X2{{B_Black}} Mult when {{ColorYellorange}}Scored{{B_Black}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "Every Joker and consumable held gains {{ColorChips}}1${{B_Black}} selling value at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "Gain {{ColorCyan}}+[[VALUE1]]{{B_Black}} Hand Size #Loses {{ColorMult}}-1{{B_Black}} Hand size every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EROSION] = "{{ColorChips}}+4{{B_Black}} Mult per card below {{ColorYellorange}}52{{B_Black}} in your {{ColorYellorange}}Full deck# {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "Each {{ColorYellorange}}Face card{{B_Black}} held in hand has a {{ColorMint}}[[CHANCE]]/4 Chance{{B_Black}} to give {{ColorYellow}}1$"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "Earn {{ColorYellow}}5${{B_Black}} per {{ColorYellorange}}[[VALUE1]]{{B_Black}} discarded #(Rank changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "Interests earned are {{ColorYellorange}}Doubled"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{ColorYellorange}}+1{{B_Black}} Hand Size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{ColorMult}}+1{{B_Black}} discard"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "This gains {{ColorMult}}X0.25{{B_Black}} Mult per {{ColorMint}}Successful{{ColorYellorange}}Lucky Card{{B_Black}} trigger#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{ColorMint}}Uncommon{{B_Black}} Jokers give {{ColorMult}}X1.5{{B_Black}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{ColorYellorange}}Selling{{B_Black}} this creates a {{ColorYellorange}}Double tag"

Descriptions.T_Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "If first discard of round contains a {{ColorYellorange}}single{{B_Black}} card, destroy it and gain {{ColotYellor}}3$"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "This gains {{ColorMult}}+2{{B_Black}} Mult if hand played caontains a {{ColorYellorange}}Two-pair{{B_Black}}#{{ColorGray}}(Currently{{ColorMult}}+[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "[[VALUE1]]{{B_Black}} cards give {{ColorMult}}X1.5{{B_Black}}Mult when scored#(suit changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "{{ColorYellorange}}10s{{B_Black}} and {{ColorYellorange}}4s{{B_Black}} give {{ColorChips}}+10{{B_Black}}Chips and {{ColorMult}}+4{{B_Black}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SELTZER] = "{{ColorYellorange}}Retriggers{{B_Black}} all played cards# {{ColorGray}}({{ColorYellorange}}[[VALUE1]]{{ColorGray}} hands remaining)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{ColorYellorange}}Face cards{{B_Black}} give {{ColorMult}}+5{{B_Black}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "This gains {{ColorMult}}X0.25{{B_Black}} Mult per card {{ColorYellorange}}sold{{B_Black}} this Ante #{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CASTLE] = "This gains {{ColorChips}}+3{{B_Black}} Chips per [[VALUE1]]{{B_Black}} card discarded #{{ColorGray}}(Currently {{ColorChips}}+[[VALUE2]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{ColorYellorange}}Golden{{B_Black}} cards give {{ColorYellow}}4${{B_Black}} when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ACROBAT] = "Gives {{ColorMult}}X3{{B_Black}} Mult on {{ColorYellorange}}last{{B_Black}} hand of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{ColorYellorange}}Retriggers{{B_Black}} played {{ColorYellorange}}Face{{B_Black}} cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{ColorYellorange}}+2{{B_Black}} Hand Size #{{ColorMult}}-1{{B_Black}} Hands"
Descriptions.T_Jimbo.Jokers[mod.Jokers.THROWBACK] = "This gains {{ColorMult}}X0.25{{B_Black}} Mult per blind {{ColorYellorange}}skipped{{B_Black}} in this run# {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "When a blind is {{ColorYellorange}}selected{{B_Black}}, adds card with a random{{ColorYellorange}}Seal{{B_Black}} is added to the deck and drawn to hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{ColorYellorange}}First{{B_Black}} scoring card played is {{ColorYellorange}}retriggered{{B_Black}} twice"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "This gains {{ColorMult}}X0.75{{B_Black}} per {{ColorYellorange}}Glass Card{{B_Black}} destroyed#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{Co}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{ColorYellorange}}Joker{{B_Black}},{{ColorPink}}Tarot{{B_Black}},{{ColorCyan}}Planet{{B_Black}} and {{ColorBlue}}Spectral{{B_Black}} cards may appear multiple times"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{ColorChips}}X3{{B_Black}} Mult if {{oOlorYellorange}}scoring{{B_Black}} cards contain all{{COlorYellorange}}Suits"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "This gains {{ColorChips}}+8{{B_Black}} Chips per {{ColorYellorange}}2{{B_Black}} scored#{{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OOPS_6] = "Every {{ColorMint}}Listed Chance{{B_Black}} is Doubled"
Descriptions.T_Jimbo.Jokers[mod.Jokers.IDOL] = "[[VALUE1]]{{B_Black}} give {{ColorMult}}X2{{B_Black}} Mult when scored #(Card changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{ColorMult}}X2{{B_Black}} Mult if hand played contains both a {{ColorYellorange}}scoring{{ColorChips}}club{{B_Black}} and {{ColorYellorange}}not-club{{B_Black}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MATADOR] = "Earn {{ColorYellow}}+8${{B_Black}} when hand played triggers the {{ColorYellorange}}Boss blind{{B_Black}} effect"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "This gains {{ColorMult}}X0.5{{B_Black}} Mult per {{ColorYellorange}}Jack{{B_Black}} discarded this round#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUO] = "{{ColorMult}}X2{{B_Black}} Mult if hand plaed contains a {{ColorYellorange}}Pair "
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIO] = "{{ColorMult}}X3{{B_Black}} Mult if hand plaed contains a {{ColorYellorange}}Three of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FAMILY] = "{{ColorMult}}X4{{B_Black}} Mult if hand plaed contains a {{ColorYellorange}}Four of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ORDER] = "{{ColorMult}}X3{{B_Black}} Mult if hand plaed contains a {{ColorYellorange}}Straight"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBE] = "{{ColorMult}}X2{{B_Black}} Mult if hand played contains a {{ColorYellorange}}Flush"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{ColorMult}}+250{{B_Black}} Chips #{{ColorMult}}-s{B_Black}} Hand Size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SATELLITE] = "Earn {{ColorYellow}}1${{B_Black}} per unique {{ColorCyan}}Planet{{B_Black}} card used this run# {{ColorGray}}(Currently {{ColorYellow}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{ColorMult}}+13{{B_Black}} Mult per {{ColorYellorange}}Queen{{B_Black}} held in hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{ColorMult}}X3{{B_Black}} Mult if you have at least {{ColorYellorange}}16 Enhanced cards{{B_Black}} in your full deck # {{ColorGray}}(Currently {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Enhanced cards)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "Every {{ColorCyan}}Planet{{B_Black}} card and {{ColorCyan}}Celestial{{B_Black}} pack is free"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{ColorYellorange}}Upgrades{{B_Black}} the level first discarded {{ColorYellorange}}Poker hand{{B_Black}} every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{ColorMult}}+2{{B_Black}} Mult per {{ColorYellow}}5${{B_Black}} you have# {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}})"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CANIO] = "This gains {{ColorMult}}X1{{B_Black}} Mult per a {{ColorYellorange}}Face{{B_Black}} card is {{ColorYellorange}}Destroyed{{B_Black}}#{{ColorGray}}(Currently {{ColroMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{ColorYellorange}}Kings{{B_Black}} and {{ColorYellorange}}Queens{{B_Black}} give {{ColorMult}}X2{{B_Black}} Mult when triggered"
Descriptions.T_Jimbo.Jokers[mod.Jokers.YORICK] = "This gains {{ColorMult}}X1{{B_Black}} Mult once every {{ColorYellorange}}23{{B_Black}} cards discarded#{{ColorGray}}([[VALUE2]] Remaining) #{{ColorGray}}(Currently {{ColroMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHICOT] = "Disables all {{ColorYellorange}}Boss blind{{B_Black}} abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PERKEO] = "When exiting a {{ColorYellorange}}Shop{{B_Black}}, creates a {{ColorSpade}}Negative{{B_Black}} copy of a random consumable you have"


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
Descriptions.Jimbo.Enhancement[mod.Enhancement.STONE] = "# {{ColorGray}}Stone Card{{CR}}: When triggered gives {{ColorChips}}+1.25 Tears{{CR}} #!!! Has no Rank or Suit"


Descriptions.T_Jimbo.Enhancement = {}
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.BONUS] = "# +{{ColorChips}}30{{B_Black}} Chips"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.MULT]  = "# +{{ColorMult}}4{{B_Black}} Mult"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# +{{ColorYellorange}}3${{B_Black}} when held at the end of round"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GLASS] = "# X{{ColorMult}}2{{B_Black}} Mult # {{ColorMint}}[[CHANCE]] in 4 Chance{{B_Black}} to break when played"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{ColorMint}}[[CHANCE]] in 5 Chance{{B_Black}} to give +{{ColorMult}}20{{B_Black}} Mult # {{ColorMint}}[[CHANCE]] in 20 Chance{{B_Black}} to give +{{ColorMult}}20${{CR}}"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STEEL] = "# X{{ColorMult}}1.5{{B_Black}} Mult When held in hand"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.WILD]  = "# Is considered as being every {{ColorYellorange}}Suit{{B_Black}}"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STONE] = "+{{ColorChips}}50{{B_Black}} Chips #Doesn't have a {{ColorYellorange}}Rank{{B_Black}} or {{ColorYellorange}}Suit{{B_Black}}"

Descriptions.T_Jimbo.Debuffed = "All abilitied are disabled"


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
Descriptions.Jimbo.Consumables[Card.CARD_LOVERS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorRainbow}}Wild Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_CHARIOT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorSilver}}Steel Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_JUSTICE] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorGlass}}Glass Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_HERMIT] = "#{{PlayerJimbo}} Doubles you current money #!!! Can give up to {{ColorYellow}}20${{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "#{{PlayerJimbo}} {{ColorMint}}25% chance{{CR}} to give a random {{ColorRainbow}}Edition{{CR}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
Descriptions.Jimbo.Consumables[Card.CARD_STRENGTH] = "#{{PlayerJimbo}} Raise the Rank of {{ColorYellorange}}up to 2{{CR}} cards by 1 #!!! Kings chosen become Aces"
Descriptions.Jimbo.Consumables[Card.CARD_HANGED_MAN] = "#{{PlayerJimbo}} Removes from the deck {{ColorYellorange}}up to 2{{CR}} cards"
Descriptions.Jimbo.Consumables[Card.CARD_DEATH] = "#{{PlayerJimbo}} Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Second{{CR}} card chosen becomes the {{ColorYellorange}}First{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_TEMPERANCE] = "#{{PlayerJimbo}} Gives the total {{ColorYellow}}Sell value{{CR}} of you Jokers in {{Coin}}Pennies"
Descriptions.Jimbo.Consumables[Card.CARD_DEVIL] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorYellorange}}Gold Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_TOWER] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorGray}}Stone Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_STARS] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorYellorange}}Diamonds{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_MOON] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorChips}}Clubs{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_SUN] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorMult}}Hearts{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_JUDGEMENT] = "#{{PlayerJimbo}} Gives random {{ColorYellorange}}Joker{{CR}} #!!! Requires an empty Inventory slot"
Descriptions.Jimbo.Consumables[Card.CARD_WORLD] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorSpade}}Spades{{CR}}"


Descriptions.T_Jimbo.Consumables = {}
Descriptions.T_Jimbo.Consumables[Card.CARD_FOOL] = "Creates copy of your last used {{ColorPink}}Tarot{{B_Black}} or {{ColorCyan}}Planet{{B_Black}} used#{{ColorGray}}(exept The Fool)#[[VALUE1]]"
Descriptions.T_Jimbo.Consumables[Card.CARD_MAGICIAN] = "#Turn up to {{ColorYellorange}}2{{B_Black}} cards into {{ColorMint}}Lucky Cards{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "#Create {{ColorYellorange}}2{{B_Black}} {{ColorCyan}}Planet{{B_Black}} cards#{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPRESS] = "Turn up to {{ColorYellorange}}2{{B_Black}} cards into {{ColorMult}}Mult Cards{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPEROR] = "Creates {{ColorYellorange}}2{{B_Black}} {{ColorPink}}Tarot{{B_Black}} cards #{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIEROPHANT] = "Turn up to {{ColorYellorange}}2{{B_Black}} cards into {{ColorChips}}Bonus Cards{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_LOVERS] = "Turn {{ColorYellorange}}1{{B_Black}} card into a {{ColorRainbow}}Wild Card{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_CHARIOT] = "Turn {{ColorYellorange}}1{{B_Black}} card into a {{ColorSilver}}Steel Card{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUSTICE] = "Turn {{ColorYellorange}}1{{B_Black}} card into a {{ColorSilver}}Glass Card{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_HERMIT] = "Doubles you current money #{{ColorGray}}(Max 20$){{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{ColorMint}}[[CHANCE]]/4 Chance{{B_Black}} to give a random {{ColorRainbow}}Edition{{B_Black}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
Descriptions.T_Jimbo.Consumables[Card.CARD_STRENGTH] = "Raise the Rank of up to {{ColorYellorange}}2{{B_Black}} cards by 1 #{{ColorGray}}(Kings chosen become Aces)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Destroy up to {{ColorYellorange}}2{{B_Black}} cards"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{ColorYellorange}}2{{B_Black}} cards, the {{ColorYellorange}}Left{{B_Black}} card becomes a copy of the {{ColorYellorange}}Right{{B_Black}} card"
Descriptions.T_Jimbo.Consumables[Card.CARD_TEMPERANCE] = "Gives the total {{ColorYellow}}Sell value{{B_Black}} of your Jokers#{{ColorGray}}(Currently {{ColorYellor}}[[VALUE1]]${{COlorGray}})"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEVIL] = "Turn {{ColorYellorange}}1{{B_Black}} card into a {{ColorYellorange}}Gold Card{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_TOWER] = "Turn {{ColorYellorange}}1{{B_Black}} card into a {{ColorGray}}Stone Card{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_STARS] = "Set the Suit of up to {{ColorYellorange}}3{{B_Black}} cards into {{ColorYellorange}}Diamonds{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_MOON] = "Set the Suit of up to {{ColorYellorange}}3{{B_Black}} cards into {{ColorChips}}Clubs{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_SUN] = "Set the Suit of up to {{ColorYellorange}}3{{B_Black}} cards into {{ColorMult}}Hearts{{B_Black}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUDGEMENT] = "Creates random {{ColorYellorange}}Joker{{B_Black}} #{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WORLD] = "Set the Suit of up to {{ColorYellorange}}3{{B_Black}} cards into {{ColorSpade}}Spades{{B_Black}}"


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


Descriptions.T_Jimbo.Consumables[mod.Planets.PLUTO] = "Level up#{{ColorYellorange}}High card#{{ColorMult}}+1{{B_Black}} Mult#{{ColorChips}}+10{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.MERCURY] = "Level up#{{ColorYellorange}}Pair#{{ColorMult}}+1{{B_Black}} Mult#{{ColorChips}}+15{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.URANUS] = "Level up#{{ColorYellorange}}Two Pair#{{ColorMult}}+1{{B_Black}} Mult#{{ColorChips}}+20{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.VENUS] = "Level up#{{ColorYellorange}}Three of a Kind#{{ColorMult}}+2{{B_Black}} Mult#{{ColorChips}}+20{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.SATURN] = "Level up#{{ColorYellorange}}Straight#{{ColorMult}}+3{{B_Black}} Mult#{{ColorChips}}+35{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.JUPITER] = "Level up#{{ColorYellorange}}Flush#{{ColorMult}}+2{{B_Black}} Mult#{{ColorChips}}+15{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.EARTH] = "Level up#{{ColorYellorange}}Full House#{{ColorMult}}+2{{B_Black}} Mult#{{ColorChips}}+25{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.MARS] = "Level up#{{ColorYellorange}}Four of a Kind#{{ColorMult}}+3{{B_Black}} Mult#{{ColorChips}}+30{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.NEPTUNE] = "Level up#{{ColorYellorange}}Straight Flush#{{ColorMult}}+4{{B_Black}} Mult#{{ColorChips}}+40{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.PLANET_X] = "Level up#{{ColorYellorange}}Five of a Kind#{{ColorMult}}+3{{B_Black}} Mult#{{ColorChips}}+35{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.CERES] = "Level up#{{ColorYellorange}}Flush House#{{ColorMult}}+4{{B_Black}} Mult#{{ColorChips}}+40{{B_Black}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.ERIS] = "Level up#{{ColorYellorange}}Flush Five#{{ColorMult}}+3{{B_Black}} Mult#{{ColorChips}}+50{{B_Black}} Chips"


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
Descriptions.Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} up to {{ColorYellorange}}3{{CR}} cards from your hand and gives {{ColorYellow}}4${{CR}} per card destroyed"
Descriptions.Jimbo.Consumables[mod.Spectrals.ANKH] = "{{PlayerJimbo}} Gives a copy a of random Joker held and destroys all the others #!!! Removes the {{ColorGray}}{{ColorFade}}Negative{{CR}} Edition from the copied Joker"
Descriptions.Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "{{PlayerJimbo}} Put a {{ColorRed}}Red Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.HEX] = "{{PlayerJimbo}} Gives the {{ColorRainbow}}Polychrome{{CR}} Edition to random Joker held and destroys all the others"
Descriptions.Jimbo.Consumables[mod.Spectrals.TRANCE] = "{{PlayerJimbo}} Put a {{ColorCyan}}Blue Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.MEDIUM] = "{{PlayerJimbo}} Put a {{ColorPink}}Purple Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.CRYPTID] = "{{PlayerJimbo}} Add {{ColorYellorange}}2{{CR}} copies of a selected card to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "{{PlayerJimbo}} {{ColorYellorange}}All Cards{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Spectrals.SOUL] = "{{PlayerJimbo}} Gives a random {{ColorRainbow}}Legendary{{CR}} Joker#!!! Requires an empty Inventory slot"



Descriptions.T_Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{ColorYellorange}}Destroy{{B_Black}} a random card and add {{ColorYellorange}}3{{B_Black}} random {{ColorYellorange}}Enhanced Face{{B_Black}} cards to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.GRIM] = "{{ColorYellorange}}Destroy{{B_Black}} a random card and add {{ColorYellorange}}2{{B_Black}} random {{ColorYellorange}}Enhanced Aces{{B_Black}} to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{ColorYellorange}}Destroy{{B_Black}} a random card and add {{ColorYellorange}}4{{B_Black}} random {{ColorYellorange}}Enhanced Numbered cards{{B_Black}} to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TALISMAN] = "Put a {{ColorYellorange}}Golden Seal{{B_Black}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.AURA] = "Give a random {{ColorYellorange}}Edition{{B_Black}} to a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.WRAITH] = "Set your money to {{ColorYellorange}}0${{B_Black}} and create a random {{ColorMult}}Rare{{B_Black}} Joker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SIGIL] = "Turn all cards in your hand to the same random {{ColorYellorange}}Suit{{B_Black}}"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.OUIJA] = "Turn all cards in your hand to the same random {{ColorYellorange}}Rank#{{ColorMult}}-1{{B_Black}} Hand size"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "Turn a random Joker {{ColorSpade}}Negative#{{ColorRed}}-[[VALUE1]]{{B_Black}} Hand size"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "Destroy {{ColorYellorange}}5{{B_Black}} cards from your hand and earn {{ColorYellow}}20${{B_Black}}"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ANKH] = "Duplicate random {{ColorYellorange}}Joker{{B_Black}} #Destroy all other Jokers held [[VALUE1]]"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "Put a {{ColorRed}}Red Seal{{B_Black}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.HEX] = "Turn a random Joker {{ColoorRainbow}}Polychrome{{B_Black}} and destroys all the others"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TRANCE] = "Put a {{ColorCyan}}Blue Seal{{B_Black}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.MEDIUM] = "Put a {{ColorPink}}Purple Seal{{B_Black}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.CRYPTID] = "Add {{ColorYellorange}}2{{B_Black}} copies of a selected card to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "Level up all {{ColorYellorange}}Poker hands"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SOUL] = "Create a random {{ColorRainbow}}Legendary{{B_Black}} Joker"


---------------------------------------
--------------BOOSTERS-----------------
---------------------------------------

Descriptions.Jimbo.Boosters = {}
Descriptions.Jimbo.Boosters[mod.Packs.ARCANA] = "Choose 1 {{ColorPink}}Tarot{{B_Black}} card out of {{ColorYellorange}}3{{B_Black}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{B_Black}} card out of {{ColorYellorange}}3{{B_Black}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.STANDARD] = "Choose 1 {{ColorYellorange}}Playing{{B_Black}} card out of {{ColorYellorange}}3{{B_Black}} to add to your deck"
Descriptions.Jimbo.Boosters[mod.Packs.BUFFON] = "Choose 1 {{ColorYellorange}}Joker{{B_Black}} out of {{ColorYellorange}}2{{B_Black}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Choose 1 {{ColorBlue}}Spectral{{B_Black}} card out of {{ColorYellorange}}2{{B_Black}} to use immediantly"



Descriptions.T_Jimbo.Boosters = {}
Descriptions.T_Jimbo.Boosters[mod.Packs.ARCANA] = "Choose 1 {{ColorPink}}Tarot{{B_Black}} card out of {{ColorYellorange}}3{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_ARCANA] = "Choose 1 {{ColorPink}}Tarot{{B_Black}} card out of {{ColorYellorange}}5{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_ARCANA] = "Choose up to 2 {{ColorPink}}Tarot{{B_Black}} card out of {{ColorYellorange}}5{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{B_Black}} card out of {{ColorYellorange}}3{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{B_Black}} card out of {{ColorYellorange}}5{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_CELESTIAL] = "Choose up to 2 {{ColorCyan}}Planet{{B_Black}} card out of {{ColorYellorange}}5{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.STANDARD] = "Choose 1 {{ColorYellorange}}Playing{{B_Black}} card out of {{ColorYellorange}}3{{B_Black}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_STANDARD] = "Choose 1 {{ColorYellorange}}Playing{{B_Black}} card out of {{ColorYellorange}}5{{B_Black}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_STANDARD] = "Choose up to 2 {{ColorYellorange}}Playing{{B_Black}} card out of {{ColorYellorange}}5{{B_Black}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.BUFFON] = "Choose 1 {{ColorYellorange}}Joker{{B_Black}} out of {{ColorYellorange}}2{{B_Black}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_BUFFON] = "Choose 1 {{ColorYellorange}}Joker{{B_Black}} out of {{ColorYellorange}}4{{B_Black}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_BUFFON] = "Choose up to 2 {{ColorYellorange}}Joker{{B_Black}} out of {{ColorYellorange}}4{{B_Black}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Choose 1 {{ColorBlue}}Spectral{{B_Black}} card out of {{ColorYellorange}}2{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_SPECTRAL] = "Choose 1 {{ColorBlue}}Spectral{{B_Black}} card out of {{ColorYellorange}}4{{B_Black}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_SPECTRAL] = "Choose up to 2 {{ColorBlue}}Spectral{{B_Black}} card out of {{ColorYellorange}}4{{B_Black}} to use immediantly"



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


Descriptions.T_Jimbo.Vouchers = {}

Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber] = "{{ColorChips}}+1{{B_Black}} Hand every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.NachoTong] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful] = "{{ColorMult}}+1{{B_Black}} discard every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Recyclomancy] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush] = "{{ColorChips}}+1{{B_Black}} Hand size"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Palette] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Clearance] = "Everything in the shop is {{ColorYellorange}}25% off#{{ColorGray}}(rounded down)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Liquidation] = "Everything in the shop is {{ColorYellorange}}50% off#{{ColorGray}}(rounded down)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock] = "{{ColorYellorange}}+1{{B_Black}} Item available in the shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.OverstockPlus] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hone] = "Special {{ColorRainbow}}Editions{{B_Black}} are {{ColorYellorange}}2X{{B_Black}} more likely to Appear"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.GlowUp] = "Special {{ColorRainbow}}Editions{{B_Black}} are {{ColorYellorange}}4X{{B_Black}} more likely to Appear"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollSurplus] = "{{ColorMint}}Rerolls{{B_Black}} cost {{ColorYellorange}}2${{B_Black}} less"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollGlut] = "{{ColorMint}}Rerolls{{B_Black}} cost and additional {{ColorYellorange}}2${{B_Black}} less"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Crystal] = "{{ColorYellorange}}+1{{B_Black}} consumable slot"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Omen] = "{{ColorBlue}}Spectral{{B_Black}} cards may appear in {{ColorYellorange}}Arcana Packs"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Telescope] = "{{ColorYellorange}}Celestial Packs{{B_Black}} always contain the {{colorCyan}}Planet{{B_Black}} for your most played {{ColorYellorange}}Poker hand"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Observatory] = "{{ColorCyan}}Planets{{B_Black}} you hold give {{ColorMult}}X1.5{{B_Black}} for their respective {{ColorYellorange}}Poker hand"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotMerch] = "{{ColorPink}}Tarot{{B_Black}} cards appear{{ColorYellorange}}2X{{B_Black}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotTycoon] = "{{ColorPink}}Tarot{{B_Black}} cards appear{{ColorYellorange}}4X{{B_Black}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetMerch] = "{{ColorCyan}}Planet{{B_Black}} cards appear{{ColorYellorange}}2X{{B_Black}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetTycoon] = "{{ColorCyan}}Planet{{B_Black}} cards appear{{ColorYellorange}}4X{{B_Black}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneySeed] = "Raise the Interest cap to {{ColorYellow}}10$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneyTree] = "Raise the Interest cap to {{ColorYellow}}20$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Blank] = "{{ColorGray}}Does nothing?"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Antimatter] = "{{ColorSpade}}+1{{B_Black}} Joker slot"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MagicTrick] = "{{ColorYellorange}}Playing cards{{B_Black}} can appear in shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Illusion] = "{{ColorYellorange}}Playing cards{{B_Black}} in shop can have and {{ColorYellorange}}Enhancement{{B_Black}},{{ColorYellorange}}Edition{{B_Black}} and/or {{ColorYellorange}}Seal{{B_Black}}"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hieroglyph] = "{{ColorYellorange}}-1{{B_Black}} Ante#{{ColorChips}}-1{{B_Black}} Hand every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Petroglyph] = "{{ColorYellorange}}-1{{B_Black}} Ante#{{ColorMult}}-1{{B_Black}} Discard every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Director] = "{{ColorPink}}Reroll{{B_Black}} boss blind {{ColorYellorange}}Once{{B_Black}} per Ante#({{ColorYellow}}10${{B_Black}} per reroll)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Retcon] = "{{ColorPink}}Reroll{{B_Black}} boss blind {{ColorYellorange}}Unlimited{{B_Black}} times per Ante#({{ColorYellow}}10${{B_Black}} per reroll)"


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