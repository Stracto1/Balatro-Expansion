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
Descriptions.Other.RoomsRemaining = "Rooms remaining: "
Descriptions.Other.BlindsCleared = "Blinds cleared: "
Descriptions.Other.DiscardsRemaining = "Discards remaining: "



Descriptions.Other.Active = "{{ColorYellorange}}Active!{{CR}}"
Descriptions.Other.Compatible = "{{ColorLime}}Compatible{{CR}}"
Descriptions.Other.Incompatible = "{{ColorMult}}Incompatible{{CR}}"
Descriptions.Other.Ready = "{{ColorYellorange}}Ready!{{CR}}"
Descriptions.Other.NotReady = "{{ColorRed}}Not ready!{{CR}}"

Descriptions.Other.HandSize = "Hand Size" --as in the Balatro stat



Descriptions.EhancementName = {}
--Descriptions.Other.EhancementName[mod.Enhancement.BONUS] = ""
--Descriptions.Other.EhancementName[mod.Enhancement.MULT]  
--Descriptions.Other.EhancementName[mod.Enhancement.GOLDEN]
--Descriptions.Other.EhancementName[mod.Enhancement.GLASS] 
--Descriptions.Other.EhancementName[mod.Enhancement.LUCKY] 
--Descriptions.Other.EhancementName[mod.Enhancement.STEEL] 
--Descriptions.Other.EhancementName[mod.Enhancement.WILD]  
Descriptions.EhancementName[mod.Enhancement.STONE] = "{{ColorGray}}Stone Card{{CR}}"


Descriptions.Rarity = {}
Descriptions.Rarity["common"] = "{{ColorCyan}}common{{CR}}"
Descriptions.Rarity["uncommon"] = "{{ColorLime}}uncommon{{CR}}"
Descriptions.Rarity["rare"] = "{{ColorRed}}rare{{CR}}"
Descriptions.Rarity["legendary"] = "{{ColorRainbow}}legendary{{CR}}"

Descriptions.Enhancement = {}
Descriptions.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.Enhancement[mod.Enhancement.BONUS] = "# {{ColorChips}}Bonus Card{{CR}}: When triggered gives {{ColorChips}}+0.75 Tears{{CR}}"
Descriptions.Enhancement[mod.Enhancement.MULT]  = "# {{ColorMult}}Mult Card{{CR}}: When triggered gives {{ColorMult}}+0.05 Damage{{CR}}"
Descriptions.Enhancement[mod.Enhancement.GOLDEN] = "# {{ColorYellorange}}Gold Card{{CR}}: Holding it when a {{ColorYellorange}}blind{{CR}} is cleared gives {{ColorYellow}}2${{CR}} #!!! Cards played need to be {{ColorCyan}}Triggerable{{CR}} for the effect to occur"
Descriptions.Enhancement[mod.Enhancement.GLASS] = "# {{ColorGlass}}Glass Card{{CR}}: When triggered gives {{ColorMult}}x1.2 Damage Multiplier{{CR}} #!!! When scored {{ColorMint}}10% chance{{CR}} to get destroyed"
Descriptions.Enhancement[mod.Enhancement.LUCKY] = "# {{ColorMint}}Lucky Card{{CR}}: When triggered {{ColorMint}}20% chance{{CR}} to give {{ColorMult}}+0.2 Mult{{CR}} and {{ColorMint}}5% chance{{CR}} to spawn {{ColorYellow}}10 {{Coin}}Coins{{CR}}"
Descriptions.Enhancement[mod.Enhancement.STEEL] = "# {{ColorSilver}}Steel Card{{CR}}: When held in hand gives {{ColorMult}}x1.2 Damage Multiplier{{CR}}"
Descriptions.Enhancement[mod.Enhancement.WILD]  = "# {{ColorRainbow}}Wild Card{{CR}}: This card counts as every Suit"
Descriptions.Enhancement[mod.Enhancement.STONE] = "# {{ColorGray}}Stone Card{{CR}}: When triggered gives {{ColorChips}}+1.25 Tears{{CR}} #!!! Has no Value or Suit"


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


----------------------------------------
-------------####JOKERS####-------------
-----------------------------------------
EID:addTrinket(mod.Jokers.JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.2 {{CR}}Damage", "Joker", FileLanguage)
EID:addTrinket(mod.Jokers.BULL, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.15 {{CR}}Tears for every {{Coin}} coin held", "Bull", FileLanguage)
EID:addTrinket(mod.Jokers.INVISIBLE_JOKER, "{{PlayerJimbo}} Selling this joker after clearing 3 Blinds while holding it gives a copy of another held Joker", "Invisible Joker", FileLanguage)
EID:addTrinket(mod.Jokers.ABSTRACT_JOKER, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.15 {{CR}} Damage per Joker held #{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.03 {{CR}} Damage per Collectible held", "Abstract Joker", FileLanguage)
EID:addTrinket(mod.Jokers.MISPRINT, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0-1 {{CR}} random Damage Up every new room #{{PlayerJimbo}} {{ColorMint}}10% Chance{{CR}} for any item to become a gliched one upon spawning", "Misprint", FileLanguage)
EID:addTrinket(mod.Jokers.JOKER_STENCIL, "{{PlayerJimbo}} {{ColorMult}}+0.75X{{CR}} Damage Multiplier for every Joker slot being {{ColorYellorange}}empty{{CR}} or containing another {{ColorYellorange}}Joker Stencil{{CR}}#Not having any {{Collectible}}Active item gives and additional {{ColorMult}}+0.25X{{CR}} Damage Multiplier", "Joker Stencil", FileLanguage)
EID:addTrinket(mod.Jokers.STONE_JOKER, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+1.25 {{CR}}Tears for every for every stone card in the player's full deck #Gives {{ColorChips}}+0.05 {{CR}}Tears per rock in the current room", "Stone Joker", FileLanguage)
EID:addTrinket(mod.Jokers.ICECREAM, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+4 {{CR}}Tears#Loses {{ColorChips}}-0.16{{CR}} Tears every room completed while held #A trail of slowing follows Jimbo #Killing an enemy on top of the creep turns it in a Frozen Statue", "Icecream", FileLanguage)
EID:addTrinket(mod.Jokers.POPCORN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+1 {{CR}}Damage #Loses {{ColorMult}}-0.2{{CR}} Damage when clearing any blind", "Popcorn", FileLanguage)
EID:addTrinket(mod.Jokers.RAMEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage Multiplier#loses {{ColorMult}}-0.01X{{CR}} per card discarded while holding this", "Ramen", FileLanguage)
EID:addTrinket(mod.Jokers.ROCKET, "{{PlayerJimbo}} Gives 2 {{Coin}}Coins on Blind clear#{{Coin}}Coin payout increases by {{ColorYellorange}}1${{CR}} when a boss blind is defeated #{{PlayerJimbo}} Grants the {{Collectible583}}Rocket in Jar effect", "Rocket", FileLanguage)
EID:addTrinket(mod.Jokers.ODDTODD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.31 {{CR}} Tears for every Odd numbered card triggered this room #{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.07{{CR}} Tears per Collectible held if the total amount is odd", "Odd Todd", FileLanguage)
EID:addTrinket(mod.Jokers.EVENSTEVEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.04 {{CR}} Damage per Even numbered card triggered this room #{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage per Collectible held if the total amount is even", "Even Steven", FileLanguage)
EID:addTrinket(mod.Jokers.HALLUCINATION, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}} to spawn a random {{Card}}{{ColorPink}} Tarot Card {{CR}}when opening a Booster Pack #{{PlayerJimbo}} {{ColorMint}}50% chance{{CR}} to give a {{Collectible431}} Multidimansional Baby every room entered", "Hallucination", FileLanguage)
EID:addTrinket(mod.Jokers.GREEN_JOKER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage per room completed while held#{{Damage}}{{ColorMult}}-0.16 {{CR}}Damage on every hand discard" , "Green Joker", FileLanguage)
EID:addTrinket(mod.Jokers.RED_CARD, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.15 {{CR}} Damage when skipping a Booster Pack" , "Red Card", FileLanguage)
EID:addTrinket(mod.Jokers.VAGABOND, "{{PlayerJimbo}} Spawns a random {{Card}}{{ColorPink}} Tarot Card {{CR}}when compleating a room with 2 {{Coin}} Coins or less #{{ColorMint}}1/10 chance{{CR}} to spawn a random {{ColorYellorange}}Beggar{{CR}} when clearing a room", "Vagabond", FileLanguage)
EID:addTrinket(mod.Jokers.RIFF_RAFF, "{{PlayerJimbo}} Spawns a random {{ColorChips}} common {{CR}} Joker on every Blind Clear", "Riff-Raff", FileLanguage)
EID:addTrinket(mod.Jokers.GOLDEN_JOKER, "{{PlayerJimbo}} Gives 4 {{Coin}} Coins on every Blind clear #{{Coin}} Every enemy touched becomes golden for a short time", "Golden Joker", FileLanguage)
EID:addTrinket(mod.Jokers.FORTUNETELLER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage for every {{Card}}{{ColorPink}} Tarot Card {{CR}}used throughout the run" , "Fortuneteller", FileLanguage)
EID:addTrinket(mod.Jokers.BLUEPRINT, "{{PlayerJimbo}} Copies the effect of the Joker to its right", "Blueprint", FileLanguage)
EID:addTrinket(mod.Jokers.BRAINSTORM, "{{PlayerJimbo}} Copies the effect of the leftmost held Joker", "Brainstorm", FileLanguage)
EID:addTrinket(mod.Jokers.MADNESS, "{{PlayerJimbo}} Destroys another random Joker and gains {{ColorMult}}+0.1X{{CR}} Damage Multiplier every {{ColorYellorange}}Small and Big Blind{{CR}} cleared", "Madness", FileLanguage)
EID:addTrinket(mod.Jokers.MR_BONES, "{{PlayerJimbo}}Revives jimbo at Full Hp if he died after clearing at least half of the current Blind or during any {{BossRoom}} Bossfight #{{ColorMint}}20% chance{{CR}} to use the {{Collectible545}} Book of the Dead on every Room Clear", "Mr. Bones", FileLanguage)
EID:addTrinket(mod.Jokers.ONIX_AGATE, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.07 {{CR}} Damage for every Club card triggered in the room", "Onyx Agate", FileLanguage)
EID:addTrinket(mod.Jokers.ARROWHEAD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per {{ColorGray}}Spade{{CR}} card triggered in the room # {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per {{Key}} Key held", "Arrowhead", FileLanguage)
EID:addTrinket(mod.Jokers.BLOODSTONE, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Heart card triggered to give {{Damage}} {{ColorMult}}X1.05 {{CR}} Damage Multiplier", "Bloodstone", FileLanguage)
EID:addTrinket(mod.Jokers.ROUGH_GEM, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Diamond card triggered to spawn a {{Coin}}Coin that disappears shortly after #Every {{ColorYellorange}}Dimaond{{CR}} card shot also has the {{Collectible506}} Backstabber effect", "Rough gem", FileLanguage)

EID:addTrinket(mod.Jokers.GROS_MICHAEL, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.75 {{CR}}Damage #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destoroyed on every Blind cleared", "Gros Michel", FileLanguage)
EID:addTrinket(mod.Jokers.CAVENDISH, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage multiplier #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destroyed on every Blind cleared", "Cavendish", FileLanguage)
EID:addTrinket(mod.Jokers.FLASH_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{RestockMachine}} Restock machine activated while holding this #{{Collectible105}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{ColorYellorange}}Dice Item{{CR}} ussed while holding this", "Flash Card", FileLanguage)
EID:addTrinket(mod.Jokers.SACRIFICIAL_DAGGER, "{{PlayerJimbo}} Destroys the Joker to it's right and gains {{Damage}}{{ColorMult}} +0.08 x the destroyed Joker's sell value{{CR}} Damage on every Blind cleared", "Sacrificial Dagger", FileLanguage)
EID:addTrinket(mod.Jokers.CLOUD_NINE, "{{PlayerJimbo}} Gain 1 {{Coin}} Coin for every {{ColorYellorange}}9{{CR}} in your FullvDeck on every Blind clear #{{Seraphim}} Gives Flight", "Cloud 9", FileLanguage)
EID:addTrinket(mod.Jokers.SWASHBUCKLER, "{{PlayerJimbo}} {{Shop}} Gives {{Damage}}{{ColorMult}} +0.05 x the total sell value of other held Jokers{{CR}} Damage", "Swashbucler", FileLanguage)
EID:addTrinket(mod.Jokers.CARTOMANCER, "{{PlayerJimbo}} Spawns 1 random {{Card}} {{ColorPink}}Tarot Card{{CR}}on every Blind clear #{{ColorMint}}5% Chance{{CR}} for any pickup to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Cartomancer", FileLanguage)
EID:addTrinket(mod.Jokers.LOYALTY_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X2 {{CR}} Damage multiplier once every 6 rooms cleares", "Loyalty Card", FileLanguage)
EID:addTrinket(mod.Jokers.SUPERNOVA, "{{PlayerJimbo}} When a card is played, gives {{Damage}}{{ColorMult}} +0.01 {{CR}} Damage for every time a card with the same value got played in the current room", "Supernova", FileLanguage)
EID:addTrinket(mod.Jokers.DELAYED_GRATIFICATION, "{{PlayerJimbo}} Gives 1 coin per {{Heart}} Heart when clearing a room at full health #{{Timer}} Both the {{Boss}}Bossrush and {{Hush}} Hush door open regardless of the ingame timer", "Delayed Gratification", FileLanguage)
EID:addTrinket(mod.Jokers.EGG, "{{PlayerJimbo}} The sell value of this Joker increases by{{ColorYellorange}} +2$ {{CR}} every {{ColorYellorange}}Blind cleared{{CR}}", "Egg", FileLanguage)
EID:addTrinket(mod.Jokers.DNA, "{{PlayerJimbo}} If the {{ColorYellorange}} First {{CR}}card triggered in a {{ColorYellorange}}Blind{{CR}} hits an enemy, a copy of that card is added to the deck #{{Collectible658}} Spawns a Mini-Isaac every Hostile room cleared", "DNA", FileLanguage)
EID:addTrinket(mod.Jokers.SMEARED_JOKER, "{{PlayerJimbo}} {{ColorMult}}Hearts{{CR}} and {{ColorYellorange}}Diamonds{{CR}} count as the same suit #{{ColorGray}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit", "Smeared Joker", FileLanguage)

EID:addTrinket(mod.Jokers.SLY_JOKER, "{{PlayerJimbo}} {{ColorChips}}+4 {{CR}}Tears if a {{ColorYellorange}}Pair{{CR}} is held when entering a room", "Sly Joker", FileLanguage)
EID:addTrinket(mod.Jokers.WILY_JOKER, "{{PlayerJimbo}} {{ColorChips}}+8 {{CR}}Tears if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room", "Wily Joker", FileLanguage)
EID:addTrinket(mod.Jokers.CLEVER_JOKER, "{{PlayerJimbo}} {{ColorChips}}+7 {{CR}}Tears if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room", "Clever Joker", FileLanguage)
EID:addTrinket(mod.Jokers.DEVIOUS_JOKER, "{{PlayerJimbo}} {{ColorChips}}+12 {{CR}}Tears if a {{ColorYellorange}}Straight{{CR}} is held when entering a room", "Devious Joker", FileLanguage)
EID:addTrinket(mod.Jokers.CRAFTY_JOKER, "{{PlayerJimbo}} {{ColorChips}}+9 {{CR}}Tears if a {{ColorYellorange}}Flush{{CR}} is held when entering a room", "Crafty Joker", FileLanguage)
EID:addTrinket(mod.Jokers.JOLLY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+1 {{CR}}Damage if a {{ColorYellorange}}Pair{{CR}} is held when entering a room", "Jolly Joker", FileLanguage)
EID:addTrinket(mod.Jokers.ZANY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+2 {{CR}}Damage if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room", "Zany Joker", FileLanguage)
EID:addTrinket(mod.Jokers.MAD_JOKER, "{{PlayerJimbo}} {{ColorMult}}+1.75 {{CR}}Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room", "Mad Joker", FileLanguage)
EID:addTrinket(mod.Jokers.CRAZY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+3 {{CR}}Damage if a {{ColorYellorange}}Straight{{CR}} is held when entering a room", "Crazy Joker", FileLanguage)
EID:addTrinket(mod.Jokers.DROLL_JOKER, "{{PlayerJimbo}} {{ColorMult}}+2.25 {{CR}}Damage if a {{ColorYellorange}}Flush{{CR}} is held when entering a room", "Droll Joker", FileLanguage)

EID:addTrinket(mod.Jokers.MIME, "{{PlayerJimbo}} {{ColorYellorange}}Retriggers{{CR}} {{ColorYellorange}}all held in hand{{CR}} effects #{{ColorMint}}20% Chance{{CR}} to copy the effect of an Active Item or consumable used", "Mime", FileLanguage)
EID:addTrinket(mod.Jokers.FOUR_FINGER, "{{PlayerJimbo}} {{ColorYellorange}}Flushes{{CR}} and {{ColorYellorange}}Straights{{CR}} only need 4 compatible cards #Every fifth non-boss enemy spawned gets killed immediantly", "Fpur Fingers", FileLanguage)
EID:addTrinket(mod.Jokers.LUSTY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorMult}}Heart{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Luty Joker", FileLanguage)
EID:addTrinket(mod.Jokers.GREEDY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorYellorange}}Diamond{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Greedy Joker", FileLanguage)
EID:addTrinket(mod.Jokers.WRATHFUL_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorGray}}Spade{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Wrathful Joker", FileLanguage)
EID:addTrinket(mod.Jokers.GLUTTONOUS_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorChips}}Club{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Gluttonous Joker", FileLanguage)
EID:addTrinket(mod.Jokers.MERRY_ANDY, "{{PlayerJimbo}} {{ColorRed}}+2 Hp{{CR}} and {{ColorCyan}}-2 Hand size{{CR}} while held", "Merry Andy", FileLanguage)
EID:addTrinket(mod.Jokers.HALF_JOKER, "{{PlayerJimbo}} {{ColorMult}}+1.5 {{CR}}Damage when {{CR}}5 or less{{CR}} card have been played in the current room #{{PlayerJimbo}} {{ColorMult}}+1 {{CR}}Damage when holding {{ColorYellorange}}3 or less{{CR}} cards", "Half Joker", FileLanguage)
EID:addTrinket(mod.Jokers.CREDIT_CARD, "{{PlayerJimbo}} Allows to go in {{ColorYellorange}}debt{{CR}} by spending more coins than you have#{{Shop}} Items on sale can be bought with a maximum of {{ColorMult}}-20${{CR}} debt #!!! Interest and coin-based effect cannot trigger while in debt", "Credit Card", FileLanguage)

EID:addTrinket(mod.Jokers.BANNER, "{{PlayerJimbo}} {{ColorChips}}+1.5 {{CR}}Tears per Red heart Jimbo has", "Banner", FileLanguage)
EID:addTrinket(mod.Jokers.MYSTIC_SUMMIT, "{{PlayerJimbo}} {{ColorMult}}+0.75 {{CR}}Damage while having only 1 full Red Heart", "Mystic Summit", FileLanguage)
EID:addTrinket(mod.Jokers.MARBLE_JOKER, "{{PlayerJimbo}} Adds a {{ColorGray}}Stone card{{CR}} to the deck every blind cleared", "Marble Joker", FileLanguage)
EID:addTrinket(mod.Jokers._8_BALL, "{{PlayerJimbo}} {{ColorMint}}1/8 Chance{{CR}} to spawn a random {{Card}} {{ColorPink}}Tarot card{{CR}} when an {{ColorYellorange}}8{{CR}} is triggered", "8 Ball", FileLanguage)
EID:addTrinket(mod.Jokers.DUSK, "{{PlayerJimbo}} The {{ColorYellorange}}last 10{{CR}} triggerable cards shot get retriggered an additional time", "Dusk", FileLanguage)
EID:addTrinket(mod.Jokers.RAISED_FIST, "{{PlayerJimbo}} The held card with the {{ColorYellorange}}lowest value{{CR}} gives {{ColorMult}}0.05{{CR}} {{ColorYellorange}} X its value{{CR}} Damage", "Raised Fist", FileLanguage)
EID:addTrinket(mod.Jokers.CHAOS_CLOWN, "{{PlayerJimbo}} Every {{Shop}} Shop visited has an additional Restock Machine", "Chaos the Clown", FileLanguage)
EID:addTrinket(mod.Jokers.FIBONACCI, "{{PlayerJimbo}} {{ColorMult}}+0.08 {{CR}}Damage per {{ColorYellorange}}Ace, 2, 3, 5 and 8{{CR}} triggered this room", "Fibonacci", FileLanguage)
EID:addTrinket(mod.Jokers.STEEL_JOKER, "{{PlayerJimbo}} This gains {{ColorMult}}+0.15X {{CR}}Damage Multiplier per {{ColorSilver}}Steel card{{CR}} in your deck", "Steel Joker", FileLanguage)
EID:addTrinket(mod.Jokers.SCARY_FACE, "{{PlayerJimbo}} {{ColorChips}}+0.3 {{CR}}Tears per {{ColorYellorange}}Face card{{CR}} triggered #{{ColorChips}}+1 {{CR}}Tears per {{ColorYellorange}}Champion enemy{{CR}} killed this room", "Scary Face", FileLanguage)
EID:addTrinket(mod.Jokers.HACK, "{{PlayerJimbo}} Played {{ColorYellorange}}2, 3, 4 and 5{{CR}} get retrigged #Jimbo gains a copy of every {{Quality0}} and {{Quality1}} Item held", "Hack", FileLanguage)
EID:addTrinket(mod.Jokers.PAREIDOLIA, "{{PlayerJimbo}} Every played card counts as a {{ColorYellorange}}Face card{{CR}} #{{ColorMint}}1/5 Chance{{CR}} for any non-boss enemy to become a {{ColorYellorange}}Champion{{CR}}", "Pareidolia", FileLanguage)

EID:addTrinket(mod.Jokers.SCHOLAR, "{{PlayerJimbo}} {{ColorMult}}+0.04{{CR}} Damage and {{ColorChips}}+0.1{{CR}} Tears per {{ColorYellorange}}Ace{{CR}} triggered", "Scholar", FileLanguage)
EID:addTrinket(mod.Jokers.BUSINESS_CARD, "{{PlayerJimbo}} {{ColorMint}}1/2 Chance{{CR}} to spawn 2 vanishing Pennies when a {{ColorYellorange}}Face card{{CR}} is triggered #Gain the {{Collectible602}} Member Card effect", "Business Card", FileLanguage)
EID:addTrinket(mod.Jokers.RIDE_BUS, "{{PlayerJimbo}} {{ColorMult}}+0.01 {{CR}}Damage per consecutive {{ColorYellorange}}non-Face card{{CR}} triggered", "Ride the Bus", FileLanguage)
EID:addTrinket(mod.Jokers.SPACE_JOKER, "{{PlayerJimbo}} {{ColorMint}}1/20 Chance{{CR}} to upgrade the played card value's level #Gains an additional {{ColorMint}}1/20 Chance{{CR}} per {{ColorYellorange}}Star-related{{CR}} Item held", "Space Joker", FileLanguage)
EID:addTrinket(mod.Jokers.BURGLAR, "{{PlayerJimbo}} Sets your Hp to {{ColorRed}}1{{CR}}#Cards can be triggered until the deck gets {{ColorYellorange}}reshuffled{{CR}} every room", "Burglar", FileLanguage)
EID:addTrinket(mod.Jokers.BLACKBOARD, "{{PlayerJimbo}} {{ColorMult}}x2 {{CR}}Damage Multiplier if all cards held in hand are {{ColorGray}}Spades{{CR}} or {{ColorChips}}Clubs{{CR}}", "Blackboard", FileLanguage)
EID:addTrinket(mod.Jokers.RUNNER, "{{PlayerJimbo}} This joker gains {{ColorChips}}+2{{CR}} Tears when entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} in hand #Gives {{ColorChips}}+Tears{{CR}} equal to your speed stat#{{Speed}} +0.1 Speed", "Runner", FileLanguage)
EID:addTrinket(mod.Jokers.SPLASH, "{{PlayerJimbo}} Triggers all cards in hand upon entering a hostile room", "Splash", FileLanguage)
EID:addTrinket(mod.Jokers.BLUE_JOKER, "{{PlayerJimbo}} {{ColorChips}}+0.1 {{CR}}Tears per remaining card in your deck", "Blue Joker", FileLanguage)
EID:addTrinket(mod.Jokers.SIXTH_SENSE, "{{PlayerJimbo}} If the {{ColorYellorange}}First{{CR}} card played in a {{ColorYellorange}}Blind{{CR}} is a {{ColorYellorange}}6{{CR}} and hits an enemy, it gets destroyed and spawns a {{ColorBlue}}Spectral Pack{{CR}}", "Sixth Sense", FileLanguage)
EID:addTrinket(mod.Jokers.CONSTELLATION, "{{PlayerJimbo}} This Jokers gains {{ColorMult}}+0.04X{{CR}} Damage Multiplier every time a {{ColorCyan}}Planet Card{{CR}} is used while holding it", "Constellation", FileLanguage)
EID:addTrinket(mod.Jokers.HIKER, "{{PlayerJimbo}} {{ColorYellorange}}Triggering{{CR}} a card gives it a {{ColorYellorange}}permanent{{CR}} {{ColorMult}}+0.02{{CR}} Tears upgrade", "Hiker", FileLanguage)
EID:addTrinket(mod.Jokers.FACELESS, "{{PlayerJimbo}} Gain {{ColorMult}}+3${{CR}} when discarding {{ColorYellorange}}at least 2 Face cards{{CR}} at the same time #If only {{ColorYellorange}}Non-boss champion{{CR}} enemies are left in the room, they are {{ColorYellorange}}killed instantly{{CR}} spawning a vanishing penny", "Faceless Joker", FileLanguage)
EID:addTrinket(mod.Jokers.SUPERPOSISION, "{{PlayerJimbo}} Entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} and an {{ColorYellorange}}Ace{{CR}} spawns an {{ColorPink}}Arcana Pack{{CR}} #Grants 2 {{Collectible128}} Forever Alone Flies", "Superposition", FileLanguage)
EID:addTrinket(mod.Jokers.TO_DO_LIST, "{{PlayerJimbo}} A random {{ColorYellorange}}Card value{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Playing{{CR}} a card with that value spawns a vanishing penny", "To Do List", FileLanguage)

EID:addTrinket(mod.Jokers.CARD_SHARP, "{{PlayerJimbo}} Gives {{ColorChips}}X1.1{{CR}} Damage Multiplier when {{ColorYellorange}}Scoring{{CR}} 2 cards with the same value consecutevely #{{Collectible665}} Allows Isaac to see the content of chests and sacks", "Card Sharp", FileLanguage)
EID:addTrinket(mod.Jokers.SQUARE_JOKER, "{{PlayerJimbo}} Gives {{ColorChips}}+4{{CR}} Tears every fourth card shot #{{Pill}} Gains {{ColorChips}}+0.4{{CR}} Tears every time a {{ColorYellorange}}Retro Vision{{CR}} pill is used", "Square Joker", FileLanguage)
EID:addTrinket(mod.Jokers.SEANCE, "{{PlayerJimbo}} Spawns a {{ColorYellorange}}Spectral Pack{{CR}} if a {{ColorYellorange}}Straight Flush{{CR}} is held when entering a room #{{Collectible727}} {{ColorMint}}1/6 chance{{CR}} to spawn a {{ColorYellorange}}Hungry Soul{{CR}} when killing an enemy", "Sèance", FileLanguage)
EID:addTrinket(mod.Jokers.VAMPIRE, "{{PlayerJimbo}} When a card with an {{ColorYellorange}}Enhancement{{CR}} is {{ColorYellorange}}Scored{{CR}}, this gains {{ColorChips}}+0.02X{{CR}} Damage Multiplier and removes the card's {{ColorYellorange}}Enhancement{{CR}}", "Vanpire", FileLanguage)
EID:addTrinket(mod.Jokers.SHORTCUT, "{{PlayerJimbo}} {{ColorYellorange}}Straights{{CR}} and {{ColorYellorange}}Straights{{CR}} only require {{ColorYellorange}}4{{CR}} compatible cards #{{Collectible84}} Creates a {{ColorYellorange}}Trapdoor{{CR}} in a random room every floor", "Shortcut", FileLanguage)
EID:addTrinket(mod.Jokers.HOLOGRAM, "{{PlayerJimbo}} This gains {{ColorChips}}+0.1X {{CR}}Damage Multiplier when a card gets {{ColorYellorange}}Added{{CR}}", "Hologram", FileLanguage)

EID:addTrinket(mod.Jokers.BARON, "{{PlayerJimbo}} Every {{ColorYellorange}}King{{CR}} held in hand gives {{ColorMult}}X1.25{{CR}} Damage Multiplier #{{Quality4}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per Q4 item held", "Baron", FileLanguage)
EID:addTrinket(mod.Jokers.OBELISK, "{{PlayerJimbo}} This gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier when {{ColorYellorange}}scoring{{CR}} a card with a different {{ColorYellorange}}Suit{{CR}} from the last", "Obelisk", FileLanguage)
EID:addTrinket(mod.Jokers.MIDAS, "{{PlayerJimbo}} Every {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} becomes {{ColorYellorange}}Golden{{CR}}#{{ColorYellorange}}Champion{{CR}} enemies are breifly turned into golden statues when spawning", "midas Mask", FileLanguage)
EID:addTrinket(mod.Jokers.LUCHADOR, "{{PlayerJimbo}} {{ColorYellorange}}Selling{{CR}} this joker causes a {{Collectible483}}Mama Mega! explosion and weakens all {{ColorYellorange}}Bosses{{CR}} in the room", "Luchador", FileLanguage)
EID:addTrinket(mod.Jokers.PHOTOGRAPH, "{{PlayerJimbo}} The first {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} every room gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when {{ColorYellorange}}Scored{{CR}} #Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when killing the first {{ColorYellorange}}Champion{{CR}} enemy in the room ", "Photograph", FileLanguage)
EID:addTrinket(mod.Jokers.GIFT_CARD, "{{PlayerJimbo}} Every joker held gains {{ColorChips}}+1${{CR}} selling value when clearing a blind", "Gift Card", FileLanguage)
EID:addTrinket(mod.Jokers.TURTLE_BEAN, "{{PlayerJimbo}} Gains {{ColorCyan}}+3{{CR}} Hand Size #Bonus is decreased by {{ColorRed}}-1{{CR}} every blind beaten, ", "Turtle Bean", FileLanguage)
EID:addTrinket(mod.Jokers.EROSION, "{{PlayerJimbo}} This gains {{ColorChips}}+0.15{{CR}} Damage when a card gets {{ColorYellorange}}Destroyed{{CR}} #This gains {{ColorChips}}+0.1{{CR}} Damage when a {{ColorYellorange}}Tinted Rock{{CR}} gets {{ColorYellorange}}Destroyed{{CR}}", "Erosion", FileLanguage)
EID:addTrinket(mod.Jokers.RESERVED_PARK, "{{PlayerJimbo}} When clearing a room every {{ColorYellorange}}Face{{CR}} card held has a {{ColorMint}}1/4 chance{{CR}} to spawn a penny #When killing an enemy every other {{ColorYellorange}}Champion{{CR}} enemy has a {{ColorMint}}1/2 chance{{CR}} to spawn a penny around it", "Reserved Parking", FileLanguage)

EID:addTrinket(mod.Jokers.MAIL_REBATE, "{{PlayerJimbo}} A random {{ColorYellorange}}Card value{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Discarding{{CR}} a card with that value spawns 2 {{Coin}} pennies", "Mail-in rebate", FileLanguage)
EID:addTrinket(mod.Jokers.TO_THE_MOON, "{{PlayerJimbo}} Gain {{ColorYellow}}+1${{CR}} per {{ColorYellorange}}Interest{{CR}} at the end of a blind", "To the Moon", FileLanguage)
EID:addTrinket(mod.Jokers.JUGGLER, "{{PlayerJimbo}} {{ColorChips}}+1 Hand Size{{CR}} #+1 {{ColorYellorange}}consumable slot{{CR}}", "Juggler", FileLanguage)
EID:addTrinket(mod.Jokers.DRUNKARD, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}} #Healing when at full heath makes Isaac vision more distorted #Taking damage reverts the distorsion", "Drunkard", FileLanguage)
EID:addTrinket(mod.Jokers.LUCKY_CAT, "{{PlayerJimbo}} This gains {{ColorMult}}+0.02X{{CR}} Damage Multiplier when a {{ColorMint}}Lucky Card{{CR}} procs or when a {{Slotmachine}} Slot pays out", "Lucky Cat", FileLanguage)
EID:addTrinket(mod.Jokers.BASEBALL, "{{PlayerJimbo}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per {{ColorLime}}Uncommon{{CR}} Joker held #Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier per {{Quality2}} Item held", "Baseball Card", FileLanguage)
EID:addTrinket(mod.Jokers.DIET_COLA, "{{PlayerJimbo}} Copies the {{Collectible347}} Diplopia effect when {{ColorYellorange}}Sold{{CR}}", "Diet Cola", FileLanguage)

EID:addTrinket(mod.Jokers.TRADING_CARD, "{{PlayerJimbo}}{{ColorYellorange}}Destroys{{CR}} every card in hand when {{ColorYellorange}}Sold{{CR}}", "Trading Card", FileLanguage)
EID:addTrinket(mod.Jokers.SPARE_TROUSERS, "{{PlayerJimbo}}This gains {{ColorMult}}+0.25{{CR}} Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room #Gives {{ColorMult}}+0.1{{CR}} Damage for every active costume the player has", "Spare Trousers", FileLanguage)
EID:addTrinket(mod.Jokers.ANCIENT_JOKER, "{{PlayerJimbo}} A random {{ColorYellorange}}Card suit{{CR}} is chosen upon entering an hostile room #Gives {{ColorMult}}X1.05{{CR}} Damage Multiplier every time a card with that {{ColorYellorange}}Suit{{CR}} is {{ColorYellorange}}Triggered{{CR}}", "Ancient Joker", FileLanguage)
EID:addTrinket(mod.Jokers.WALKIE_TALKIE, "{{PlayerJimbo}} {{ColorChips}}+0.1{{CR}} Tears and {{ColorChips}}+0.04{{CR}} Damage per {{ColorYellorange}}10{{CR}} and {{ColorYellorange}}4{{CR}} triggered this room", "Walkie Talkie", FileLanguage)
EID:addTrinket(mod.Jokers.SELTZER, "{{PlayerJimbo}} Every card played in the next 15 rooms gets {{ColorYellorange}}Retriggered{{CR}}", "Seltzer", FileLanguage)
EID:addTrinket(mod.Jokers.SMILEY_FACE, "{{PlayerJimbo}} Gives {{ColorMult}}+0.05{{CR}} Damage per {{ColorYellorange}}Face card{{CR}} triggered this room #Gives {{ColorMult}}+0.15{{CR}} Damage per {{ColorYellorange}}Champion{{CR}} enemy killed this room", "Smiley Face", FileLanguage)
EID:addTrinket(mod.Jokers.CAMPFIRE, "{{PlayerJimbo}} This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier per sold Joker this {{ColorYellorange}}Ante{{CR}}", "Campfire", FileLanguage)
EID:addTrinket(mod.Jokers.CASTLE, "{{PlayerJimbo}} A random {{ColorYellorange}}Card suit{{CR}} is chosen upon entering an hostile room #This gains {{ColorChips}}+0.04{{CR}} Tears when {{ColorYellorange}}Discarding{{CR}} a card with that {{ColorYellorange}}Suit{{CR}}", "Castle", FileLanguage)
EID:addTrinket(mod.Jokers.GOLDEN_TICKET, "{{PlayerJimbo}} Gain {{ColorYellow}}+2${{CR}} every time a {{ColorYellorange}}Golden card{{CR}} is triggered #Every pickup has a {{ColorMint}}1/25 chance{{CR}} to become its {{ColorYellorange}}Golden{{CR}} variant", "Joker", FileLanguage)
EID:addTrinket(mod.Jokers.ACROBAT, "{{PlayerJimbo}} Gives {{ColorMult}}X2{{CR}} Damage Multipier if Jimbo has {{ColorYellorange}}5 or less{{CR}} playable cards left", "Acrobat", FileLanguage)
EID:addTrinket(mod.Jokers.SOCK_BUSKIN, "{{PlayerJimbo}} {{ColorYellorange}}Face card{{CR}} played get {{ColorYellorange}}Retriggered{{CR}} #On {{ColorYellorange}}Champion kill{{CR}} Joker effects get retriggered", "Sock and Buskin", FileLanguage)
EID:addTrinket(mod.Jokers.TROUBADOR, "{{PlayerJimbo}} {{ColorChips}}+2 Hand Size{{CR}} #{{ColorBlue}}-5 playable cards{{CR}} every room", "Troubador", FileLanguage)
EID:addTrinket(mod.Jokers.THROWBACK, "{{PlayerJimbo}} This gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier per skipped {{ColorYellorange}}Special room{{CR}} skipped this run", "Throwback", FileLanguage)
EID:addTrinket(mod.Jokers.CERTIFICATE, "{{PlayerJimbo}} A card with a {{ColorYellorange}}Random Seal{{CR}} is added to the deck every time a {{ColorYellorange}}Blind{{CR}} is cleared", "Certificate", FileLanguage)
EID:addTrinket(mod.Jokers.HANG_CHAD, "{{PlayerJimbo}} The {{ColorYellorange}}first{{CR}} card played is {{ColorYellorange}}triggered{{CR}} 3 additional times #The {{ColorYellorange}}first{{CR}} card used every floor spawns a copy of itself", "Hanging Chad", FileLanguage)
EID:addTrinket(mod.Jokers.GLASS_JOKER, "{{PlayerJimbo}} This gains {{ColorMult}}+0.1X{{CR}} Damage Multiplier every time a {{ColorGlass}}Glass Card{{CR}} is destroyed", "Glass Joker", FileLanguage)
EID:addTrinket(mod.Jokers.SHOWMAN, "{{PlayerJimbo}} Alredy seen {{ColorYellorange}}Jokers{{CR}} and {{ColorYellorange}}Items{{CR}} can reappear throughuot the run", "Showman", FileLanguage)
EID:addTrinket(mod.Jokers.FLOWER_POT, "{{PlayerJimbo}} {{ColorChips}}X1.5{{CR}} Damage Multiplier if every {{ColorYellorange}}Suit{{CR}} is held in hand when entering an hostile room", "Flower Pot", FileLanguage)
EID:addTrinket(mod.Jokers.WEE_JOKER, "{{PlayerJimbo}} This gains {{ColorMult}}+0.04{{CR}} Tears when a {{ColorYellorange}}2{{CR}} is {{ColorYellorange}}triggered{{CR}}#The samller Jimbo is, the higer is the stat gain", "Wee Joker", FileLanguage)
EID:addTrinket(mod.Jokers.OOPS_6, "{{PlayerJimbo}} Every {{ColorMint}}Listed Chance{{CR}} is Doubled", "Opps, All 6s!", FileLanguage)
EID:addTrinket(mod.Jokers.IDOL, "{{PlayerJimbo}} A random {{ColorYellorange}}Card{{CR}} from Jimbo's deck is chosen upon entering an hostile room #Playing a card with the same {{ColorYellorange}}Value ans Suit{{CR}} gives {{ColorMult}}X1.1{{CR}} Damage Multiplier", "The Idol", FileLanguage)
EID:addTrinket(mod.Jokers.SEE_DOUBLE, "{{PlayerJimbo}} {{ColorMult}}X1.2{{CR}} Damage Multiplier when entering an hostile room while holding both a {{ColorClub}}Club{{CR}} and a {{ColorYellorange}}Not-club{{CR}} card in hand", "Seeing Double", FileLanguage)
EID:addTrinket(mod.Jokers.MATADOR, "{{PlayerJimbo}} Gain {{ColorYellow}}+6${{CR}} when Jimbo takes damage from a {{ColorYellorange}}Boss{{CR}}", "Matador", FileLanguage)
EID:addTrinket(mod.Jokers.HIT_ROAD, "{{PlayerJimbo}} This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier every time a {{ColorYellorange}}Jack{{CR}} is discarded #!!! Resets every beaten {{ColorYellorange}}Blind{{CR}}", "Hit the Road", FileLanguage)
EID:addTrinket(mod.Jokers.DUO, "{{PlayerJimbo}} {{ColorMult}}X1.25{{CR}} Damage Mutiplier if a {{ColorYellorange}}Pair{{CR}} is held when entering an hostile room", "The", FileLanguage)
EID:addTrinket(mod.Jokers.TRIO, "{{PlayerJimbo}} {{ColorMult}}X1.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Three of a Kind{{CR}} is held when entering an hostile room", "The", FileLanguage)
EID:addTrinket(mod.Jokers.FAMILY, "{{PlayerJimbo}} {{ColorMult}}X2{{CR}} Damage Mutiplier if a {{ColorYellorange}}Four of a Kind{{CR}} is held when entering an hostile room", "The", FileLanguage)
EID:addTrinket(mod.Jokers.ORDER, "{{PlayerJimbo}} {{ColorMult}}X2.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Straight{{CR}} is held when entering an hostile room", "The", FileLanguage)
EID:addTrinket(mod.Jokers.TRIBE, "{{PlayerJimbo}} {{ColorMult}}X1.35{{CR}} Damage Mutiplier if a {{ColorYellorange}}Flush{{CR}} is held when entering an hostile room", "The", FileLanguage)
EID:addTrinket(mod.Jokers.STUNTMAN, "{{PlayerJimbo}} {{ColorMult}}+12.5{{CR}} Tears #{{ColorChips}}-3 Hand Size{{CR}}", "Stuntman", FileLanguage)
EID:addTrinket(mod.Jokers.SATELLITE, "{{PlayerJimbo}} Upon Clearing a {{ColorYellorange}}Blind{{CR}} gain {{ColorYellow}}+1${{CR}} per unique {{ColorCyan}}Planet Card{{CR}} used this run", "Satellite", FileLanguage)
EID:addTrinket(mod.Jokers.SHOOT_MOON, "{{PlayerJimbo}} {{ColorMult}}+0.7{{CR}} Damage per {{ColorYellorange}}Queen{{CR}} held in hand when entering an hostile room", "Shoot the Moon", FileLanguage)
EID:addTrinket(mod.Jokers.DRIVER_LICENSE, "{{PlayerJimbo}} {{ColorMult}}X1.5{{CR}} Damage Multiplier if Jimbo has at least {{ColorYellorange}}18 Enhanced cards{{CR}} in his deck or if he's an {{Adult}} adult", "Driver's License", FileLanguage)
EID:addTrinket(mod.Jokers.ASTRONOMER, "{{PlayerJimbo}} Every {{ColorCyan}}Planet card{{CR}},{{ColorCyan}}Celestial Pack{{CR}} and {{ColorYellorange}}Star-themed{{CR}} item is free", "Astronomer", FileLanguage)
EID:addTrinket(mod.Jokers.BURNT_JOKER, "{{PlayerJimbo}} {{ColorCyan}}Upgrades{{CR}} the level of {{ColorYellorange}}discarded{{CR}} cards that hit an enemy", "Burnt Joker", FileLanguage)
EID:addTrinket(mod.Jokers.BOOTSTRAP, "{{PlayerJimbo}} {{ColorMult}}+0.1{{CR}} Damage per 5 coins held", "Bootstraps", FileLanguage)

EID:addTrinket(mod.Jokers.CANIO, "{{PlayerJimbo}} This gains {{ColorMult}}+0.25X{{CR}} Damage Multiplier when a {{ColorYellorange}}Face card{{CR}} is {{ColorYellorange}}Destroyed{{CR}}", "Canio", FileLanguage)
EID:addTrinket(mod.Jokers.TRIBOULET, "{{PlayerJimbo}} {{ColorMult}}X1.1{{CR}} Damage Multiplier per {{ColorYellorange}}King or Queen{{CR}} triggered this room", "Triboulet", FileLanguage)
EID:addTrinket(mod.Jokers.YORICK, "{{PlayerJimbo}} This gains {{ColorMult}}+0.2X{{CR}} Damage Multiplier every {{ColorYellorange}}23{{CR}} cards discarded", "Yorick", FileLanguage)
EID:addTrinket(mod.Jokers.CHICOT, "{{PlayerJimbo}} Every {{ColorYellorange}}Boss>{{CR}} is permanently {{Weakness}} weakened #Disables every curse", "Chicot", FileLanguage)
EID:addTrinket(mod.Jokers.PERKEO, "{{PlayerJimbo}} Spwns a duplicate of every {{ColorYellorange}}Consumable{{CR}} Jimbo has upon entering a {{Shop}} shop or a new floor", "Parkeo", FileLanguage)







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


----------------------------------------
-------------####TAROTS####------------
-----------------------------------------

Descriptions.Tarot = {}
Descriptions.Tarot[Card.CARD_FOOL] = "#{{PlayerJimbo}} Spawns copy of your last used card #!!! Cannot spawn itself #Currently: "
Descriptions.Tarot[Card.CARD_MAGICIAN] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMint}}Lucky Cards{{CR}}"
Descriptions.Tarot[Card.CARD_HIGH_PRIESTESS] = "#{{PlayerJimbo}} Spawns {{ColorYellorange}}2{{CR}} random {{ColorCyan}}Planet Cards{{CR}}"
Descriptions.Tarot[Card.CARD_EMPRESS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMult}}Mult Cards{{CR}}"
Descriptions.Tarot[Card.CARD_EMPEROR] = "#{{PlayerJimbo}} Spawns {{ColorYellorange}}2{{CR}} random {{ColorPink}}Tarot Cards{{CR}} #!!! Cannot spawn itself"
Descriptions.Tarot[Card.CARD_HIEROPHANT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorChips}}Bonus Cards{{CR}}"
Descriptions.Tarot[Card.CARD_LOVERS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorRainbow}}Wild Card{{CR}}"
Descriptions.Tarot[Card.CARD_CHARIOT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorSilver}}Steel Card{{CR}}"
Descriptions.Tarot[Card.CARD_JUSTICE] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorGlass}}Glass Card{{CR}}"
Descriptions.Tarot[Card.CARD_HERMIT] = "#{{PlayerJimbo}} Doubles you current money #!!! Can give up to {{ColorYellow}}20${{CR}}"
Descriptions.Tarot[Card.CARD_WHEEL_OF_FORTUNE] = "#{{PlayerJimbo}} {{ColorMint}}25% chance{{CR}} to give a random {{ColorRainbow}}Edition{{CR}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
Descriptions.Tarot[Card.CARD_STRENGTH] = "#{{PlayerJimbo}} Raise the value of {{ColorYellorange}}up to 2{{CR}} cards by 1 #!!! Kings chosen become Aces"
Descriptions.Tarot[Card.CARD_HANGED_MAN] = "#{{PlayerJimbo}} Removes from the deck {{ColorYellorange}}up to 2{{CR}} cards"
Descriptions.Tarot[Card.CARD_DEATH] = "#{{PlayerJimbo}} Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Second{{CR}} card chosen becomes the {{ColorYellorange}}First{{CR}}"
Descriptions.Tarot[Card.CARD_TEMPERANCE] = "#{{PlayerJimbo}} Gives the total {{ColorYellow}}Sell value{{CR}} of you Jokers in {{Coin}}Pennies"
Descriptions.Tarot[Card.CARD_DEVIL] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorYellorange}}Gold Card{{CR}}"
Descriptions.Tarot[Card.CARD_TOWER] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorGray}}Stone Card{{CR}}"
Descriptions.Tarot[Card.CARD_STARS] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorYellorange}}Diamonds{{CR}}"
Descriptions.Tarot[Card.CARD_MOON] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorChips}}Clubs{{CR}}"
Descriptions.Tarot[Card.CARD_SUN] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorMult}}Hearts{{CR}}"
Descriptions.Tarot[Card.CARD_JUDGEMENT] = "#{{PlayerJimbo}} Gives random {{ColorYellorange}}Joker{{CR}} #!!! Requires an empty Inventory slot"
Descriptions.Tarot[Card.CARD_WORLD] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorGray}}Spades{{CR}}"

--Descriptions.Tarot[FileLanguage][Card.CARD_FOOL] = "#{{PlayerJimbo}}"

----------------------------------------
-------------####PLANETS####------------
-----------------------------------------

EID:addCard(mod.Planets.PLUTO, "{{PlayerJimbo}} {{ColorYellorange}}Aces{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Pluto", FileLanguage)
EID:addCard(mod.Planets.MERCURY, "{{PlayerJimbo}} {{ColorYellorange}}2s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Mercury", FileLanguage)
EID:addCard(mod.Planets.URANUS, "{{PlayerJimbo}} {{ColorYellorange}}3s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Uranus", FileLanguage)
EID:addCard(mod.Planets.VENUS, "{{PlayerJimbo}} {{ColorYellorange}}4s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Venus", FileLanguage)
EID:addCard(mod.Planets.SATURN, "{{PlayerJimbo}} {{ColorYellorange}}5s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Saturn", FileLanguage)
EID:addCard(mod.Planets.JUPITER, "{{PlayerJimbo}} {{ColorYellorange}}6s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Jupiter", FileLanguage)
EID:addCard(mod.Planets.EARTH, "{{PlayerJimbo}} {{ColorYellorange}}7s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Earth", FileLanguage)
EID:addCard(mod.Planets.MARS, "{{PlayerJimbo}} {{ColorYellorange}}8s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Mars", FileLanguage)
EID:addCard(mod.Planets.NEPTUNE, "{{PlayerJimbo}} {{ColorYellorange}}9s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Neptune", FileLanguage)
EID:addCard(mod.Planets.PLANET_X, "{{PlayerJimbo}} {{ColorYellorange}}10s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Planet X", FileLanguage)
EID:addCard(mod.Planets.CERES, "{{PlayerJimbo}} {{ColorYellorange}}Jacks{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Ceres", FileLanguage)
EID:addCard(mod.Planets.ERIS, "{{PlayerJimbo}} {{ColorYellorange}}Queens{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Eris", FileLanguage)
EID:addCard(mod.Planets.SUN, "{{PlayerJimbo}} {{ColorYellorange}}Kings{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Sun", FileLanguage)


----------------------------------------
-------------####SPECTRALS####------------
-----------------------------------------

EID:addCard(mod.Spectrals.FAMILIAR, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}3{{CR}} random {{ColorYellorange}}Enhanced Face cards{{CR}} to your deck", "Familiar", FileLanguage)
EID:addCard(mod.Spectrals.GRIM, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}2{{CR}} random {{ColorYellorange}}Enhanced Aces cards{{CR}} to your deck", "Grim", FileLanguage)
EID:addCard(mod.Spectrals.INCANTATION, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}4{{CR}} random {{ColorYellorange}}Enhanced Numbered cards{{CR}} to your deck", "Incantation", FileLanguage)
EID:addCard(mod.Spectrals.TALISMAN, "{{PlayerJimbo}} Put a {{ColorYellorange}}Golden Seal{{CR}} on one selected card", "Talisman", FileLanguage)
EID:addCard(mod.Spectrals.AURA, "{{PlayerJimbo}} Give a random {{ColorRainbow}}Edition{{CR}} to a selected card", "Aura", FileLanguage)
EID:addCard(mod.Spectrals.WRAITH, "{{PlayerJimbo}} Sets your money to {{ColorYellorange}}0{{CR}} and gives a random {{ColorMult}}Rare Joker{{CR}}#!!! Requires an empty Inventory slot", "Wraith", FileLanguage)
EID:addCard(mod.Spectrals.SIGIL, "{{PlayerJimbo}} Turns all the cards in your hand to the same random {{ColorYellorange}}Suit{{CR}}", "Sigil", FileLanguage)
EID:addCard(mod.Spectrals.OUIJA, "{{PlayerJimbo}} Turns all the cards in your hand to the same random {{ColorYellorange}}Rank{{CR}}", "Ouija", FileLanguage)
EID:addCard(mod.Spectrals.ECTOPLASM, "{{PlayerJimbo}} Turns a random Joker {{ColorGray}}{{ColorFade}}Negative{{CR}} and gives {{ColorRed}}-1{{CR}} Hand size #!!! Cannot replace any {{ColorYellorange}}Edition{{CR}} a Joker alredy has #!!! The effect won't occur if hand size cannot be lowered", "Ectoplasm", FileLanguage)
EID:addCard(mod.Spectrals.IMMOLATE, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} up to {{ColorYellorange}}3{{CR}} cards from your hand and gives {{ColorYellow}}4${{CR}} for every card destroyed", "Immolate", FileLanguage)
EID:addCard(mod.Spectrals.ANKH, "{{PlayerJimbo}} Gives a copy a of random Joker held and destroys all the others #!!! Removes the {{ColorGray}}{{ColorFade}}Negative{{CR}} Edition from the copied Joker", "Ankh", FileLanguage)
EID:addCard(mod.Spectrals.DEJA_VU, "{{PlayerJimbo}} Put a {{ColorRed}}Red Seal{{CR}} on one selected card", "Deja Vu", FileLanguage)
EID:addCard(mod.Spectrals.HEX, "{{PlayerJimbo}} Gives the {{ColorRainbow}}Polychrome{{CR}} Edition to random Joker held and destroys all the others", "Hex", FileLanguage)
EID:addCard(mod.Spectrals.TRANCE, "{{PlayerJimbo}} Put a {{ColorCyan}}Blue Seal{{CR}} on one selected card", "Trance", FileLanguage)
EID:addCard(mod.Spectrals.MEDIUM, "{{PlayerJimbo}} Put a {{ColorPink}}Purple Seal{{CR}} on one selected card", "Medium", FileLanguage)
EID:addCard(mod.Spectrals.CRYPTID, "{{PlayerJimbo}} Add {{ColorYellorange}}2{{CR}} copies of a selected card to your deck", "Cryptid", FileLanguage)
EID:addCard(mod.Spectrals.BLACK_HOLE, "{{PlayerJimbo}} {{ColorYellorange}}All Cards{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Black Hole", FileLanguage)
EID:addCard(mod.Spectrals.SOUL, "{{PlayerJimbo}} Gives a random {{ColorRainbow}}Legendary{{CR}} Joker#!!! Requires an empty Inventory slot", "The Soul", FileLanguage)


return Descriptions