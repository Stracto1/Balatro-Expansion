---@diagnostic disable: param-type-mismatch
local mod = Balatro_Expansion


local FileLanguage = "en_us" --REMEMBER TO MODIFY ME!!
local Descriptions = {}

Descriptions.Other = {} 
Descriptions.Other.Name = "Inventory Helper"
Descriptions.Other.LV = "LV." --abbreviation of LEVEL

Descriptions.Other.ConfirmName = "{{ColorSilver}}Confirm{{CR}}"
Descriptions.Other.ConfirmDesc = "Confirm the current card selection"

Descriptions.Other.SkipName = "{{ColorSilver}}Skip{{CR}}"
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


Descriptions.Other.Active = "{{ColorYellorange}}Active!{{CR}}"
Descriptions.Other.NotActive = "{{ColorRed}}Not active!{{CR}}"
Descriptions.Other.Compatible = "{{ColorMint}}Compatible{{CR}}"
Descriptions.Other.Incompatible = "{{ColorMult}}Incompatible{{CR}}"
Descriptions.Other.Ready = "{{ColorYellorange}}Ready!{{CR}}"
Descriptions.Other.NotReady = "{{ColorRed}}Not ready!{{CR}}"

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




Descriptions.Jimbo = {}
Descriptions.T_Jimbo = {}

----------------------------------------
-------------####JOKERS####-------------
----------------------------------------

--EID:addTrinket(mod.Jokers.JOKER, "\1 {{ColorMult}}+1.2{{CR}} Damage", "Joker", FileLanguage)

Descriptions.Jimbo.Enhancement = {[mod.Enhancement.NONE]  = "",
                                  [mod.Enhancement.BONUS] = "#{{BalatroBonus}} {{ColorChips}}Bonus Card{{CR}}: Gives {{ColorChips}}+0.75{{CR}} Tears when scored",
                                  [mod.Enhancement.MULT]  = "#{{BalatroMult}} {{ColorMult}}Mult Card{{CR}}:Gives {{ColorMult}}+0.05{{CR}} Damage when scored",
                                  [mod.Enhancement.GOLDEN] = "#{{BalatroGold}} {{ColorYellorange}}Gold Card{{CR}}: Holding it when a {{ColorYellorange}}blind{{CR}} is cleared gives {{ColorYellorange}}2${{CR}}",
                                  [mod.Enhancement.GLASS] = "#{{BalatroGlass}} {{ColorGlass}}Glass Card{{CR}}: Gives {{ColorMult}}x1.2{{CR}} Damage Multiplier when scored #!!! When scored {{ColorMint}}[[CHANCE]]/10 Chance{{CR}} to get destroyed",
                                  [mod.Enhancement.LUCKY] = "#{{BalatroLucky}} {{ColorMint}}Lucky Card{{CR}}: {{ColorMint}}[[CHANCE]]/5 Chance{{CR}} to give {{ColorMult}}+0.2{{CR}} damage and {{ColorMint}}[[CHANCE]]/20 Chance{{CR}} to give {{ColorYellorange}}10 {{Coin}} Pennies{{CR}}",
                                  [mod.Enhancement.STEEL] = "#{{BalatroSteel}} {{ColorSilver}}Steel Card{{CR}}: Gives {{ColorMult}}X1.2{{CR}} Damage Multiplier when {{ColorYellorange}}held{{CR}} in hand as an hostile room is entered",
                                  [mod.Enhancement.WILD]  = "#{{BalatroWild}} {{ColorRainbow}}Wild Card{{CR}}: Is considered as every suit",
                                  [mod.Enhancement.STONE] = "#{{BalatroStone}} {{ColorGray}}Stone Card{{CR}}: Gives {{ColorChips}}+1.25{{CR}} Tears when scored #!!! Has no Rank or Suit"
                                  }

Descriptions.Jimbo.Seal = {[mod.Seals.NONE] = "",
                           [mod.Seals.RED] = "# {{ColorMult}}Red Seal{{CR}}: This card's abilities are {{ColorYellorange}}Retriggered{{CR}} once",
                           [mod.Seals.BLUE] = "# {{ColorCyan}}Blue Seal{{CR}}: Spawns the card's respective {{ColorCyan}}Planet{{CR}} card when holding this as a Blind is cleared #!!! {{ColorGray}}(Must have at least 1 scoring card)",
                           [mod.Seals.GOLDEN] = "# {{ColorYellorange}}Golden Seal{{CR}}: spawns a {{Coin}} {{ColorYellorange}}Temporary Penny{{CR}} when scored",
                           [mod.Seals.PURPLE] = "# {{ColorPink}}Purple Seal{{CR}}: Spawns a random {{ColorPink}}Tarot{{CR}} card when {{ColorRed}}Discarded{{CR}}  #!!! {{ColorMint}}Lower chance{{CR}} if multiple are discarded {{ColorYellorange}}at once{{CR}}",
                           }

Descriptions.Jimbo.CardEdition = {[mod.Edition.BASE] = "",
                                  [mod.Edition.FOIL] = "#{{Tears}} {{ColorChips}}Foil{{CR}}: {{ColorChips}}+1.25{{CR}} Tears when scored",
                                  [mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{ColorMult}}Holographic{{CR}}: {{ColorMult}}+0.25{{CR}} Damage when scored",
                                  [mod.Edition.POLYCROME] = "#{{Damage}} {{ColorRainbow}}Polychrome{{CR}}: {{ColorMult}}x1.2{{CR}} Damage Multiplier when scored",
                                  [mod.Edition.NEGATIVE] = "#\1  {{ColorGray}}{{ColorFade}}Negative{{CR}}: scemo chi legge (how tf did u even get this)"
                                }

Descriptions.Jimbo.JokerEdition = {[mod.Edition.NOT_CHOSEN] = "",
                                   [mod.Edition.BASE] = "",
                                   [mod.Edition.FOIL] = "#{{Tears}} {{ColorChips}}Foil{{CR}}: {{ColorChips}}+3.5{{CR}} Tears while held",
                                   [mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{ColorMult}}Holographic{{CR}}: {{ColorMult}}+0.5{{CR}} Damage while held",
                                   [mod.Edition.POLYCROME] = "#{{Damage}} {{ColorRainbow}}Polychrome{{CR}}: {{ColorMult}}X1.25{{CR}} Damage Multiplier while held",
                                   [mod.Edition.NEGATIVE] = "#\1  {{ColorGray}}{{ColorFade}}Negative{{CR}}: {{ColorYellorange}}+1{{CR}} Joker Slot while held"
                                   }


Descriptions.Jimbo.Jokers = {}
do
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER] = "{{Damage}} {{ColorMult}}+0.2{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.BULL] = "{{Tears}} {{ColorChips}}+0.1{{CR}} Tears per {{Coin}} {{ColorYellorange}}coin{{CR}} held {{ColorGray}}#{{Blank}} {{ColorGray}} (Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "Selling this Joker after clearing {{ColorYellorange}}3{{CR}} Blinds duplicates another held Joker [[VALUE2]] #{{Blank}} {{ColorGray}}(Currently [[VALUE1]]) #{{Confusion}} Enemies are confused for 2.5 seconds when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{Damage}} {{ColorMult}}+0.15{{CR}} Damage per Joker held #{{Damage}} {{ColorMult}}+0.03{{CR}} Damage per Collectible held #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{CR}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.MISPRINT] = "{{Damage}} {{ColorMult}}+0-1{{CR}} random Damage every new room #{{Collectible721}} {{ColorMint}}[[CHANCE]]/10 Chance{{CR}} for any item spawned to become a gliched"
Descriptions.Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{Damage}} {{ColorMult}}X0.75{{CR}} Damage Multiplier per {{ColorYellorange}}empty{{CR}} Joker slot #!!! {{ColorYellorange}}Joker Stencil{{CR}} included #Gains {{ColorMult}}X0.25{{CR}} Damage Multiplier if no {{ColorYellorange}}{{Collectible}}Active item{{CR}} is held#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Multiplier)"
Descriptions.Jimbo.Jokers[mod.Jokers.STONE_JOKER] = "{{Tears}} {{ColorChips}}+1.25{{CR}} Tears per per {{ColorYellorange}}Stone card{{CR}} in your full deck #{{Tears}} {{ColorChips}}+0.05{{CR}} Tears per rock in the current room{{ColorGray}}#{{Blank}} (Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.ICECREAM] = "{{Tears}} {{ColorChips}}+[[VALUE1]]{{CR}} Tears#!!! Loses {{ColorChips}}-0.25{{CR}} Tears every room completed #Create a trail of slowing creep #Killing an enemy on top of the creep turns it in a Frozen Statue"
Descriptions.Jimbo.Jokers[mod.Jokers.POPCORN] = "{{Damage}} {{ColorMult}}+[[VALUE1]]{{CR}} Damage #!!! Loses {{ColorMult}}-0.2{{CR}} Damage every blind beaten #Randomly launch exploding popcorn"
Descriptions.Jimbo.Jokers[mod.Jokers.RAMEN] = "{{Damage}} {{ColorMult}}X[[VALUE1]]{{CR}}Damage Multiplier#!!! Loses {{ColorMult}}-0.01X{{CR}} per card discarded"
Descriptions.Jimbo.Jokers[mod.Jokers.ROCKET] = "Gives {{ColorYellorange}}[[VALUE1]] {{Coin}} Coins{{CR}} on Blind clear#{{Coin}} Coin payout increases by {{ColorYellorange}}1{{CR}} when a boss blind is defeated #{{Collectible583}} Grants the Rocket in Jar effect"
Descriptions.Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{Tears}} Odd numbered cards give {{ColorChips}}+0.31{{CR}} Tears when scored#{{Tears}} {{ColorChips}}+0.15{{CR}} Tears per Collectible held if the total amount is odd"
Descriptions.Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{Damage}} Even numbered cards give {{ColorMult}}+0.04{{CR}} Damage when scored #{{Damage}} {{ColorMult}}+0.02{{CR}} Damage per Collectible held if the total amount is even"
Descriptions.Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{Card}} {{ColorMint}}[[CHANCE]]/2 Chance{{CR}} to spawn a random {{ColorPink}}Tarot{{CR}} card when opening a {{ColorYellorange}}Booster Pack{{CR}}#\1  Give a {{Collectible431}} Multidimensional Baby"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "{{Damage}}{{ColorMult}}+0.04{{CR}} Damage per room completed#{{Damage}}{{ColorMult}}-0.16{{CR}}Damage on every hand discard #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{Damage}}{{ColorMult}}+0.15{{CR}} Damage per {{ColorYellorange}}Booster Pack{{CR}} skipped #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.VAGABOND] = "Spawns a random {{Card}}{{ColorPink}}Tarot{{CR}} card when clearing a room with {{ColorYellorange}}2 {{Coin}} Coins or less{{CR}} #{{Beggar}} {{ColorMint}}[[CHANCE]]/10 Chance{{CR}} to spawn a random {{ColorYellorange}}Beggar{{CR}} when clearing a room"
Descriptions.Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "\1 Spawns a random {{ColorChips}}common{{CR}} Joker on Blind Clear"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Gives {{ColorYellorange}}4 {{Coin}} Coins{{CR}} on Blind clear #{{Coin}} Every enemy touched becomes {{ColorYellorange}}golden{{CR}} for a short time"
Descriptions.Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{Damage}} {{ColorMult}}+0.04{{CR}} Damage per {{Card}}{{ColorPink}}Tarot{{CR}} card used throughout the run #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage) #{{Collectible451}} Grants the Tarot Cloth effect"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "\1 Copies the effect of the Joker to its right"
Descriptions.Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "\1 Copies the effect of the leftmost held Joker"
Descriptions.Jimbo.Jokers[mod.Jokers.MADNESS] = "Destroys another random Joker and gains {{ColorMult}}X0.1{{CR}} Damage Multiplier every {{ColorYellorange}}Small and Big Blind{{CR}} cleared#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.MR_BONES] = "Revive at Full Hp if only {{ColorYellorange}}1{{CR}} of the floor's blinds is uncleared #!!! Unavailable blinds count as cleared #{{ColorMint}}[[CHANCE]]/5 Chance{{CR}} to activate {{Collectible545}} Book of the Dead on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{Damage}} {{ColorChips}}Club{{CR}} cards give {{ColorMult}}+0.07{{CR}} Damage when scored #{{Damage}} {{ColorChips}}+0.07{{CR}} Damage per {{Bomb}} Bomb held#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage) #{{Bomb}} {{ColorClub}}Club{{CR}} cards explosions are more frequent, bigger and deal more damage"
Descriptions.Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{Tears}} {{ColorChips}}+0.5{{CR}} Tears per {{ColorSpade}}Spade{{CR}} card triggered in the room # {{Tears}} {{ColorChips}}+0.5{{CR}} Tears per {{Key}} Key held#{{Blank}} {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears) #{{Confusion}} {{ColorSpade}}Spade{{CR}} cards gain a 50% chance to clow and confuse"
Descriptions.Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{Damage}} {{ColorMult}}Heart{{CR}} cards have a {{ColorMint}} [[CHANCE]]/2 Chance{{CR}} to give {{ColorMult}}X1.05{{CR}} Damage Multiplier when scored #{{Charm}} {{ColorMult}}Heart{{CR}} cards gain 10% chance to charm"
Descriptions.Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{Coin}} {{ColorYellorange}}Diamond{{CR}} cards have a {{ColorMint}} [[CHANCE]]/2 Chance{{CR}} to spawn a {{ColorYellorange}}temporary {{Coin}}Penny{{CR}} when scored #{{Collectible506}} {{ColorYellorange}}Diamond{{CR}} cards also have the {{ColorYellorange}}Backstabber{{CR}} effect"

Descriptions.Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = "{{Damage}} {{ColorMult}}+0.75{{CR}} Damage #{{Warning}} {{ColorMint}}[[CHANCE]]/6 Chance{{CR}} of getting destroyed on Blind clear"
Descriptions.Jimbo.Jokers[mod.Jokers.CAVENDISH] = "{{Damage}} {{ColorMult}}X1.5{{CR}} Damage multiplier #{{Warning}} {{ColorMint}}[[CHANCE]]/1000 chance{{CR}} of getting destroyed on Blind clear"
Descriptions.Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "{{Damage}} {{ColorMult}}+0.02{{CR}} Damage per {{RestockMachine}} Restock machine activated #{{Collectible105}} {{Damage}} {{ColorMult}}+0.02{{CR}} Damage per {{ColorYellorange}}Dice Item{{CR}} used #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "Destroys the Joker to its right and gains {{ColorMult}}+0.08 x its sell value{{CR}} Damage on Blind clear #{{Blank}} {{colorGray}}(Currently {{ColorMukt}}+[[VALUE1]]{{ColorGray}} Damage) #{{Collectible705}} Activates Dark Arts for 2.5 seconds when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "{{Coin}} Gain {{ColorYellorange}}1${{CR}} per {{ColorYellorange}}9{{CR}} in your Full Deck on Blind clear#{{Blank}} {{ColorGray}}(Currently  {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Coins){{CR}} #{{Seraphim}} Gain Flight"
Descriptions.Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "{{Damage}} Gives {{Damage}}{{ColorMult}}+0.07 x the total sell value of held Jokers{{CR}} Damage"
Descriptions.Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "Spawns a random {{Card}} {{ColorPink}}Tarot{{CR}} card on Blind clear #{{Card}} {{ColorMint}}[[CHANCE]]/20 Chance{{CR}} for any pickup to be replaced with a random {{ColorPink}}Tarot{{CR}} card"
Descriptions.Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = "{{Damage}} {{ColorMult}}X2{{CR}} Damage multiplier once every 6 rooms cleares #{{Blank}} {{ColorGray}} [[VALUE1]]"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "Cards scored give {{Damage}}{{ColorMult}}+0.01{{CR}} Damage per time a card with the same {{ColorYellorange}}Rank{{CR}} got played in the current room"
Descriptions.Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "{{Coin}} Gives {{ColorYellorange}}1 Coin{{CR}} per {{Heart}} full heart when clearing a room at {{ColorYellorange}}full health{{CR}} #{{Timer}} Both the {{BossRoom}} Bossrush and {{Hush}} Hush door open regardless of the ingame timer"
Descriptions.Jimbo.Jokers[mod.Jokers.EGG] = "The sell value of this Joker increases by {{ColorYellorange}}3${{CR}} on blind clear #Gain a tears-blocking familiar"
Descriptions.Jimbo.Jokers[mod.Jokers.DNA] = "If the {{ColorYellorange}}First{{CR}} card played in a {{ColorYellorange}}Blind{{CR}} hits an enemy, add a copy of that card to the deck #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}}) #{{Collectible658}} Spawns a Mini-Isaac on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{ColorMult}}Hearts{{CR}} and {{ColorYellorange}}Diamonds{{CR}} count as the same suit #{{ColorSpade}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit"

Descriptions.Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{Tears}} {{ColorChips}}+5{{CR}} Tears if a {{ColorYellorange}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{Tears}} {{ColorChips}}+10{{CR}} Tears if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{Tears}} {{ColorChips}}+7{{CR}} Tears if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{Tears}} {{ColorChips}}+15{{CR}} Tears if a {{ColorYellorange}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{Tears}} {{ColorChips}}+12{{CR}} Tears if a {{ColorYellorange}}Flush{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{Damage}} {{ColorMult}}+1{{CR}} Damage if a {{ColorYellorange}}Pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{Damage}} {{ColorMult}}+2{{CR}} Damage if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{Damage}} {{ColorMult}}+1.75{{CR}} Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{Damage}} {{ColorMult}}+3{{CR}} Damage if a {{ColorYellorange}}Straight{{CR}} is held when entering a room"
Descriptions.Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{Damage}} {{ColorMult}}+2.25{{CR}} Damage if a {{ColorYellorange}}Flush{{CR}} is held when entering a room"

Descriptions.Jimbo.Jokers[mod.Jokers.MIME] = "{{ColorYellorange}}Retriggers{{CR}} all {{ColorYellorange}}held in hand{{CR}} effects #{{ColorMint}}[[CHANCE]]/5 Chance{{CR}} to copy the effect of an Active Item used"
Descriptions.Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{ColorYellorange}}Flushes{{CR}} and {{ColorYellorange}}Straights{{CR}} only require 4 cards #Every fifth {{ColorYellorange}}non-boss{{CR}} enemy spawned gets killed immediantly"
Descriptions.Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{Damage}} {{ColorMult}}Heart{{CR}} cards give {{ColorMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{Damage}} {{ColorYellorange}}Diamond{{CR}} cards give {{ColorMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{Damage}} {{ColorSpade}}Spade{{CR}} cards give {{ColorMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{Damage}} {{ColorChips}}Club{{CR}} cards give {{ColorMult}}+0.03{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "\1  {{ColorYellorange}}+2{{CR}} {{Heart}} Hp #\2  {{ColorMult}}-2{{CR}} Hand size"
Descriptions.Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{Damage}} {{ColorMult}}+1.5{{CR}} Damage when {{ColorYellorange}}5 or less{{CR}} card have been played in the current room #{{ColorMult}}+1{{CR}} Damage when having {{ColorYellorange}}3 or less{{CR}} cards in hand #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Allows to go in {{ColorYellorange}}debt{{CR}} #{{Shop}} Items on sale can only be bought with a maximum of {{ColorMult}}-20${{CR}} debt #!!! {{ColorYellorange}}Interest{{CR}} and {{ColorYellorange}}coin held-based{{CR}} effects cannot trigger while in debt"

Descriptions.Jimbo.Jokers[mod.Jokers.BANNER] = "{{Tears}} {{ColorChips}}+1.5{{CR}} Tears per {{Heart}} {{ColorYellorange}}full heart{{CR}}#{{Blank}} {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears) #A banner spawns as an hostile room is entered #{{Tears}} Standing close to the banner gives {{ColorChips}}+3{{CR}} Tears"
Descriptions.Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{Damage}} {{ColorMult}}+1.5{{CR}} Damage while having only {{ColorYellorange}}1{{CR}} full Heart #{{Collectible335}} Grants a {{ColorYellorange}}repelling aura{{CR}} while active"
Descriptions.Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "Adds a {{ColorYellorange}}Stone card{{CR}} to the deck on blind clear # {{ColorMint}}[[CHANCE]]/100 Chance{{CR}} for rocks to be replaced with {{ColorYellorange}}Tinted Rocks"
Descriptions.Jimbo.Jokers[mod.Jokers._8_BALL] = "{{ColorYellorange}}8s{{CR}} have a {{ColorMint}}[[CHANCE]]/8 Chance{{CR}} to spawn a random {{Card}} {{ColorPink}}Tarot{{CR}} card scored #{{Shotspeed}} +0.16 Shot Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.DUSK] = "The {{ColorYellorange}}last 10{{CR}} scoring cards get {{ColorYellorange}}Retriggered #{{Blank}} {{ColorGray}}(Currently [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "Gives {{ColorMult}}0.05{{CR}} Damage {{ColorYellorange}}X the Rank{{CR}} of the lowest card {{ColorYellorange}}held{{CR}} #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{Collectible376}} All Shops and Treasure rooms visited have an additional Restock Machine"
Descriptions.Jimbo.Jokers[mod.Jokers.FIBONACCI] = "{{Damage}} {{ColorYellorange}}Aces{{CR}}, {{ColorYellorange}}2s{{CR}}, {{ColorYellorange}}3s{{CR}}, {{ColorYellorange}}5s{{CR}} and {{ColorYellorange}}8s{{CR}} give {{ColorMult}}+0.08{{CR}} Damage when scored #{{Damage}} {{ColorMult}}+0.05{{CR}} Damage per {{Collectible}} collectible held if the total amount is a {{ColorYellorange}}Fibonacci number#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "{{Damage}} This gains {{ColorMult}}X0.15{{CR}} Damage Multiplier per {{ColorSilver}}Steel card{{CR}} in your deck#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{Tears}} {{ColorYellorange}}Face{{CR}} cards give {{ColorChips}}+0.3{{CR}} Tears when scored #{{Tears}} Killing a {{ColorYellorange}}Champion{{CR}} gives {{ColorChips}}+1{{CR}} Tears"
Descriptions.Jimbo.Jokers[mod.Jokers.HACK] = "{{ColorYellorange}}Retriggers{{CR}} played {{ColorYellorange}}2s{{CR}}, {{ColorYellorange}}3s{{CR}}, {{ColorYellorange}}4s{{CR}} and {{ColorYellorange}}5s{{CR}} #\1 Gain an additional copy of every {{Quality0}} and {{Quality1}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Every card counts as a {{ColorYellorange}}Face{{CR}} card #{{ColorMint}}[[CHANCE]]/5 Chance{{CR}} for any non-boss enemy to become a {{ColorYellorange}}Champion{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.SCHOLAR] = "\1  {{ColorYellorange}}Aces{{CR}} give {{ColorMult}}+0.04{{CR}} Damage and {{ColorChips}}+0.2{{CR}} Tears when scored #{{Luck}} {{ColorMint}}+5{{CR}} Luck"
Descriptions.Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{Coin}} {{ColorYellorange}}Face{{CR}} cards have a {{ColorMint}}[[CHANCE]]/2 Chance{{CR}} to spawn {{ColorYellorange}}2 temporary {{Coin}} Pennies{{CR}} when scored #Gain the {{Collectible602}} Member Card effect"
Descriptions.Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{Damage}} {{ColorMult}}+0.01{{CR}} Damage per consecutive {{ColorYellorange}}non-Face{{CR}} card played #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "\1 {{ColorMint}}[[CHANCE]]/20 Chance{{CR}} to upgrade the {{ColorYellorange}}played card Rank{{CR}}'s level #Gains an additional {{ColorMint}}{{[[CHANCE]]/20 Chance{{CR}} per {{ColorYellorange}}Star-related{{CR}} Item held"
Descriptions.Jimbo.Jokers[mod.Jokers.BURGLAR] = "!!! Sets your Hp to {{ColorRed}}2{{CR}} Hearts #\1 Cards can be scored until the deck gets {{ColorYellorange}}reshuffled{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{Damage}} {{ColorMult}}X2{{CR}} Damage Multiplier if all cards held are {{ColorSpade}}Spades{{CR}} or {{ColorChips}}Clubs{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.RUNNER] = "{{Tears}} Gains {{ColorChips}}+1.5{{CR}} Tears when entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} #{{Tears}} Gives {{ColorChips}}+Tears{{CR}} equal to double your {{Speed}} Speed stat#{{Blank}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Chips) #{{Speed}} +0.1 Speed"
Descriptions.Jimbo.Jokers[mod.Jokers.SPLASH] = "\1 Scores all cards in hand upon entering an {{ColorYellorange}}hostile{{CR}} room"
Descriptions.Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{Tears}} {{ColorChips}}+0.2{{CR}} Tears per remaining card in your deck#{{Blank}} {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "{{Card}} If the {{ColorYellorange}}First{{CR}} card played in a {{ColorYellorange}}Blind{{CR}} is a {{ColorYellorange}}6{{CR}} and hits an enemy, destroy it and spawn a {{ColorBlue}}Spectral Pack{{CR}} #{{Collectible3}} 1 every 4 tears shot gains homing"
Descriptions.Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "{{Damage}} This Jokers gains {{ColorMult}}+0.05X{{CR}} Damage Multiplier every time a {{ColorCyan}}Planet Card{{CR}} is used while holding it #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.) #{{Collectible}} {{ColorYellorange}}Star-related{{CR}} items held give {{ColorMult}}X1.1{{CR}} Damage Mult."
Descriptions.Jimbo.Jokers[mod.Jokers.HIKER] = "{{Coin}} Cards gain a {{ColorYellorange}}permanent{{CR}} {{ColorMult}}+0.02{{CR}} Tears upgrade when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.FACELESS] = "{{Coin}} Gain {{ColorYellorange}}3 Pennies{{CR}} when discarding at least {{ColorYellorange}}2{{CR}} Face cards at once #If only {{ColorYellorange}}champion{{CR}} enemies are left in the room, they are {{ColorYellorange}}killed instantly{{CR}} spawning a {{ColorYellorvanishing penny{{CR}}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "{{Card}} Entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} and an {{ColorYellorange}}Ace{{CR}} spawns an {{ColorPink}}Arcana Pack{{CR}} #Grants 2 {{Collectible128}} Forever Alone Flies"
--Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{ColorYellorange}}[[VALUE1]]s{{CR}} spawn a {{ColorYellorange}}temporary {{Coin}} penny{{R}} when scored #!!! {{ColorGray}}(Rank changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "{{Coin}} Killing enemies in the {{ColorYellorange}}order{{CR}} dictated by the {{Coin}} above them awards with a penny"


Descriptions.Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{Damage}} Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier when playing 2 cards with the same rank {{ColorYellorange}}consecutevely{{CR}} #!!! {{ColorYellorange}}Stone cards{{CR}} are considered as a separete renk #{{Collectible665}} Allows to see the content of {{ColorYellorange}}chests{{CR}} and {{ColorYellorange}}sacks{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "{{Tears}} Gives {{ColorChips}}+4{{CR}} Tears to every fourth card shot #{{Pill}} Gains {{ColorChips}}+0.4{{CR}} Tears every time a {{ColorYellorange}}Retro Vision{{CR}} pill is used #{{Blank}} {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.SEANCE] = "Spawns a {{ColorYellorange}}Spectral Pack{{CR}} if a {{ColorYellorange}}Straight Flush{{CR}} is held when entering a room #{{Collectible727}} {{ColorMint}}1/6 chance{{CR}} to spawn a {{ColorYellorange}}Hungry Soul{{CR}} when killing an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.VAMPIRE] = "{{Damage}} When an {{ColorYellorange}}Enhanced{{CR}} card is Played, this gains {{ColorMult}}X0.02{{CR}} Damage Multiplier and removes the {{ColorYellorange}}Enhancement{{CR}} #{{Blank}} {{ColorGray}}(Currenlty {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Allows {{ColorYellorange}}Straights{{CR}} to be made with gaps of {{ColorYellorange}}1 rank{{CR}} #{{Collectible84}} Creates a {{ColorYellorange}}Crawl space{{CR}} in a random room every floor #{{Collectible84}} immediantly opens all {{ColorYellorange}}Secret Room{{CR}} doors"
Descriptions.Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "{{Damage}} Gains {{ColorMult}}X0.1{{CR}} Damage Multiplier when a card gets {{ColorYellorange}}Added{{CR}} to the deck #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"

Descriptions.Jimbo.Jokers[mod.Jokers.BARON] = "{{Damage}} {{ColorYellorange}}Kings{{CR}} held in hand give {{ColorMult}}X1.2{{CR}} Damage Multiplier when entering an hostile room #{{Quality4}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per Q4 item held#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.OBELISK] = "{{Damage}} Gains {{ColorMult}}X0.05{{CR}} Damage Multiplier per {{ColorYellorange}}consecutive{{CR}} card played with a different {{ColorYellorange}}Suit{{CR}} from the last #!!! {{ColorYellorange}}Stone cards{{CR}} have no effect #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.MIDAS] = "{{Coin}} {{ColorYellorange}}Face{{CR}} cards {{ColorYellorange}}Played{{CR}} become {{ColorYellorange}}Golden{{CR}}#{{ColorYellorange}}Champion{{CR}} enemies are breifly turned into golden statues when spawning"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{Shop}} {{ColorYellorange}}Selling{{CR}} this Joker causes a {{Collectible483}}Mama Mega! explosion and {{Weakness}} weakens all {{ColorYellorange}}Bosses{{CR}} in the room"
Descriptions.Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "{{Damage}} The first {{ColorYellorange}}Face{{CR}} card {{ColorYellorange}}Played{{CR}} every room gives {{ColorMult}}X1.2{{CR}} Damage Multiplier when scored #{{Damage}} If the first room enemy killed is a {{ColorYellorange}}Champion{{CR}}, gives {{ColorMult}}X1.2{{CR}} Damage Multiplier #Can open {{ColorYellorange}}A Strange Door{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "{{Coin}} Every Joker held gains {{ColorYellorange}}+1${{CR}} selling value on blind clear #{{Shop}} All items cost {{ColorYellorange}}1$ less"
Descriptions.Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "\1 {{ColorYellorange}}+[[VALUE1]]{{CR}} Hand Size #!!! Bonus is decreased by {{ColorRed}}-1{{CR}} on blind clear #{{Collectible594}} Grants the Jupiter effect"
Descriptions.Jimbo.Jokers[mod.Jokers.EROSION] = "{{Damage}} Gains {{ColorMult}}+0.15{{CR}} Damage when a card gets {{ColorYellorange}}Destroyed{{CR}} #This gains {{ColorMult}}+0.05{{CR}} Damage per {{ColorYellorange}}Tinted{{CR}} Rock {{ColorYellorange}}Destroyed{{CR}} #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "{{Coin}} {{ColorYellorange}}Face{{CR}} cards held in hand have a {{ColorMint}}[[CHANCE]]/4 Chance{{CR}} to spawn a penny on blind clear #When killing an enemy, other {{ColorYellorange}}Champions{{CR}} create a {{ColorYellorange}}Vanishong penny{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "{{Coin}} Gain {{ColorYellorange}}2 pennies{{CR}} per {{ColorYellorange}}[[VALUE1]]{{CR}} discarded #{{Blank}} {{ColorGray}}(Rank changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "{{Coin}} {{colorYellow}}Interests{{CR}} earned are {{ColorYellorange}}Doubled{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.JUGGLER] = "\1  {{ColorYellorange}}+1{{CR}} Hand Size #\1  {{ColorYellorange}}+1{{CR}} consumable slot"
Descriptions.Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{Heart}} {{ColorMult}}+1{{CR}} Health up #{{Heart}} Heal one extra heart on room clear"
Descriptions.Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "{{Damage}} Gains {{ColorMult}}X0.02{{CR}} Damage Multiplier when a {{ColorYellorange}}Lucky Card{{CR}} triggers {{ColorMint}}Succesfully{{CR}} or when a {{Slotmachine}} Slot pays out #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{Damage}} Gives {{ColorMult}}X1.25{{CR}} Damage Multiplier per {{ColorMint}}Uncommon{{CR}} Joker held #{{Damage}} Gives {{ColorMult}}X1.1{{CR}} Damage Multiplier per {{Quality2}} Item held #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{Shop}} Copies the {{Collectible347}} Diplopia effect when {{ColorYellorange}}Sold{{CR}}"

Descriptions.Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "{{Shop}} {{ColorYellorange}}Selling{{CR}} this Joker {{ColorYellorange}}Destroys{{CR}} every card held in hand #{{Coins}} Gives {{ColorYellorange}}2 pennies{{CR}} per card destroyed {{ColorYellorange}}this way"
Descriptions.Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "{{Damage}} Gains {{ColorMult}}+0.25{{CR}} Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room #Gives {{ColorMult}}+0.1{{CR}} Damage per active {{ColorYellorange}}costume{{CR}} #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "#{{Damage}} [[VALUE1]]{{CR}} cards give {{ColorMult}}X1.05{{CR}} Damage Multiplier when scored #{{ColorGray}}(Suit changes every room)"
Descriptions.Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "\1 {{ColorYellorange}}10s{{CR}} and {{ColorYellorange}}4s{{CR}} give {{ColorChips}}+0.1{{CR}} Tears and {{ColorMult}}+0.04{{CR}} Damage when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.SELTZER] = "\1  {{ColorYellorange}}Retriggers{{CR}} the next {{ColorYellorange}}[[VALUE1]]{{CR}} played cards"
Descriptions.Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{Damage}} {{ColorYellorange}}Face{{CR}} cards give {{ColorMult}}+0.05{{CR}} Damage when scored #Killing a {{ColorYellorange}}Champion{{CR}} gives {{ColorMult}}+0.15{{CR}} Damage #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage)"
Descriptions.Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "{{Damage}} Gains {{ColorMult}}X0.2{{CR}} Damage Multiplier per sold Joker this {{ColorYellorange}}Floor{{CR}} #!!! Jokers gotten with full inventory are sold automatically without giving any coin #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.CASTLE] = "{{Tears}} Gains {{ColorChips}}+0.04{{CR}} Tears per {{ColorYellorange}}[[VALUE1]]{{CR}} discarded #{{Blank}} {{ColorGray}}(Currently {{ColorChips}}+[[VALUE2]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{Coin}} {{ColorYellorange}}Golden cards{{CR}} give {{ColorYellorange}}1 penny{{CR}} when scored #{{Collectible202}} Every pickup has a {{ColorMint}}[[CHANCE]]/25 chance{{CR}} to become its {{ColorYellorange}}Golden{{CR}} variant"
Descriptions.Jimbo.Jokers[mod.Jokers.ACROBAT] = "{{Damage}} The {{ColorYellorange}}Last 5{{CR}} scoring cards give {{ColorMult}}X1.1{{CR}} Damage Mult when scored #{{Damage}} Gives {{ColorMult}}X1.5{{CR}} Damage multiplier during any {{Boss}} bossfight #{{Blank}} {{ColorGray}}(Currently [[VALUE1]] {{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = '\1  {{ColorYellorange}}Retriggers{{CR}} played {{ColorYellorange}}Face{{CR}} cards #\1  {{ColorYellorange}}Retriggers{{CR}} "on champion kill" Joker effects'
Descriptions.Jimbo.Jokers[mod.Jokers.TROUBADOR] = "\1  {{ColorYellorange}}+2{{CR}} Hand Size #\2  {{ColorBlue}}-5{{CR}} scoring cards"
Descriptions.Jimbo.Jokers[mod.Jokers.THROWBACK] = "{{Damage}} Gains {{ColorMult}}X0.1{{CR}} Damage Multiplier per {{ColorYellorange}}Blind{{CR}} skipped this run #{{Damage}} Gains {{ColorMult}}X0.02{{CR}} Damage Multiplier per {{ColorYellorange}}Special room{{CR}} skipped this run #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "\1 Adds a card with {{ColorYellorange}}Random Seal{{CR}} to the deck on blind clear #{{Collectible75}} Grants the PHD effect"
Descriptions.Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "\1  {{ColorYellorange}}Retriggers 3{{CR}} times the {{ColorYellorange}}first{{CR}} played card in a room #{{Card}} The {{ColorYellorange}}first{{CR}} card used every floor spawns a copy of itself"
Descriptions.Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "{{Damage}} Gains {{ColorMult}}X0.2{{CR}} Damage Multiplier per destroyed {{ColorYellorange}}Glass Card{{CR}} #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorYellorange}} Damage Mult.) #!!! {{ColorMint}}Doubles{{CR}} the Glass card's breaking chance"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{ColorYellorange}}Items{{CR}}, {{ColorYellorange}}Joker{{CR}}, {{ColorPink}}Tarot{{CR}}, {{ColorCyan}}Planet{{CR}} and {{ColorBlue}}Spectral{{CR}} cards may appear multiple times"
Descriptions.Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{Damage}} {{ColorMult}}X2{{CR}} Damage Multiplier if every {{ColorYellorange}}Suit{{CR}} is held in hand when entering an hostile room #Spawns 3 charming flowers in hostile rooms"
Descriptions.Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "{{Tears}} Gains {{ColorChips}}+0.04{{CR}} Tears when a {{ColorYellorange}}2{{CR}} is scored #\1 Reduces Isaac's size and hitbox #{{Blank}} {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Tears)"
Descriptions.Jimbo.Jokers[mod.Jokers.OOPS_6] = "{{Luck}} Every {{ColorMint}}Listed Chance{{CR}} is Doubled #{{Collectible46}} Grants the Lucky foot effect"
Descriptions.Jimbo.Jokers[mod.Jokers.IDOL] = "{{Damage}} [[VALUE1]]{{CR}} give {{ColorMult}}X1.1{{CR}} Damage Multiplier when scored #{{ColorGray}} (Card changes every room) #{{Damage}} {{ColorMult}}X2{{CR}} Damage Mult. per {{ColorYellorange}} {{Collectible[[VALUE2]]}} [[VALUE3]]{{CR}} held"
Descriptions.Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{Damage}} {{ColorMult}}X1.2{{CR}} Damage Multiplier if both a {{ColorClub}}Club{{CR}} and a {{ColorYellorange}}Not-club{{CR}} card are held in hand when entering an hostile room#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}[[VALUE1]]{{CR}})"
Descriptions.Jimbo.Jokers[mod.Jokers.MATADOR] = "{{Coin}} Gain {{ColorYellorange}}3 pennies{{CR}} when taking damage from a {{ColorYellorange}}Boss{{CR}}"
Descriptions.Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "{{Damage}} Gains {{ColorMult}}X0.2{{CR}} Damage Multiplier per {{ColorYellorange}}Jack{{CR}} discarded #!!! Resets every {{ColorYellorange}}Room{{CR}} #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.DUO] = "{{Damage}} {{ColorMult}}X1.25{{CR}} Damage Mutiplier if a {{ColorYellorange}}Pair{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIO] = "{{Damage}} {{ColorMult}}X1.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Three of a Kind{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.FAMILY] = "{{Damage}} {{ColorMult}}X2{{CR}} Damage Mutiplier if a {{ColorYellorange}}Four of a Kind{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.ORDER] = "{{Damage}} {{ColorMult}}X2.5{{CR}} Damage Mutiplier if a {{ColorYellorange}}Straight{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBE] = "{{Damage}} {{ColorMult}}X1.55{{CR}} Damage Mutiplier if a {{ColorYellorange}}Flush{{CR}} is held when entering an hostile room #{{Blank}} {{ColorGray}}(Currently: [[VALUE1]]{{ColorGray}})"
Descriptions.Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{Tears}} {{ColorMult}}+12.5{{CR}} Tears #\2  {{ColorMult}}-2{{CR}} Hand Size"
Descriptions.Jimbo.Jokers[mod.Jokers.SATELLITE] = "{{Coin}} Gain {{ColorYellorange}}1 Coin{{CR}} per unique {{ColorCyan}}Planet{{CR}} card used this run on blind clear #(Currently {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Coins) #A light beam is shot per unique {{ColorCyan}}Planet{{CR}} card used when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{Damage}} {{ColorYellorange}}Queens{{CR}} held in hand give {{ColorMult}}+0.7{{CR}} Damage when entering an hostile room"
Descriptions.Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{Damage}} {{ColorMult}}X1.5{{CR}} Damage Multiplier if there are at least {{ColorYellorange}}18{{CR}} Enhanced cards in your full deck #Having either the {{Adult}} Adult, {{Mom}} Mom or {{Bob}} Bob transformation also activates the effect #{{Blank}} {{ColorGray}}(Currently [[VALUE1]])"
Descriptions.Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "{{Shop}} {{ColorCyan}}Planet{{CR}} cards,{{ColorCyan}}Celestial Packs{{CR}} and {{ColorYellorange}}Star-themed{{CR}} items are free #{{Planetarium}} {{ColorYellorange}}+20%{{CR}} planetarium chance {{ColorGray}}(halves every time one is visited) #{{Planetarium}} Planetariums can spawns on any normal floor"
Descriptions.Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "\1 Upgrades the {{ColorCyan}}level{{CR}} of {{ColorYellorange}}discarded{{CR}} if they hit an enemy"
Descriptions.Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{Damage}} {{ColorMult}}+0.05{{CR}} Damage per {{ColorYellorange}}5 {{Coin}} Coins{{CR}} held {{ColorGray}}#{{Blank}} (Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Damage) #Gain {{ColorYellorange}}Collision Damage{{CR}} equal to the amount of coins held"

Descriptions.Jimbo.Jokers[mod.Jokers.CANIO] = "Gains {{ColorMult}}X0.25{{CR}} Damage Multiplier when a {{ColorYellorange}}Face{{CR}} card is {{ColorYellorange}}Destroyed{{CR}}#{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{CR}} Damage Mult.) #{{DeathMark}} {{ColorYellorange}}Champion{{CR}} enemies are immediantly killed"
Descriptions.Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{ColorYellorange}}Kings{{CR}} and {{ColorYellorange}}Queens{{CR}} give {{ColorMult}}X1.2{{CR}} Damage Multiplier when scored"
Descriptions.Jimbo.Jokers[mod.Jokers.YORICK] = "Gains {{ColorMult}}+0.25X{{CR}} Damage Multiplier every {{ColorYellorange}}23{{CR}} cards discarded #{{Blank}} {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Damage Mult.)"
Descriptions.Jimbo.Jokers[mod.Jokers.CHICOT] = "{{Weakness}} Every {{ColorYellorange}}Boss{{CR}} is permanently weakened #Disables every curse"
Descriptions.Jimbo.Jokers[mod.Jokers.PERKEO] = "{{Card}} Spawns a duplicate of every {{ColorYellorange}}Consumable{{CR}} held upon entering a {{Shop}} shop or a new floor"

Descriptions.Jimbo.Jokers[mod.Jokers.CHAOS_THEORY] = "After being scored, cards become another {{ColorYellorange}}randomly{{CR}} chosen card #!!! {{ColorGray}} The new card generated depends on the starting one "

end

Descriptions.JokerSynergies = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE] = {}
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_PHD] = "Cards added also have a random {{ColorYellorange}}Edition{{CR}}"
Descriptions.JokerSynergies[mod.Jokers.CERTIFICATE][CollectibleType.COLLECTIBLE_FALSE_PHD] = "Cards added also have a random {{ColorYellorange}}Enhancement{{CR}}"

Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_SMALL_ROCK] = "Cards added also have a random {{ColorYellorange}}Seal{{CR}}"
Descriptions.JokerSynergies[mod.Jokers.MARBLE_JOKER][CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = "Cards added also have a random {{ColorYellorange}}Edition{{CR}}"

Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY] = {}
Descriptions.JokerSynergies[mod.Jokers.CHAOS_THEORY][CollectibleType.COLLECTIBLE_CHAOS] = "Cards generated are guaranteed to have an {{ColorYellorange}}Enhancement{{CR}},{{ColorYellorange}}Seal{{CR}} or {{ColorYellorange}}Edition{{CR}} if the starting card had one"

Descriptions.JokerSynergies[mod.Jokers._8_BALL] = {}
Descriptions.JokerSynergies[mod.Jokers._8_BALL][CollectibleType.COLLECTIBLE_MAGIC_8_BALL] = "{{ColorMint}}Trigger Chance{{CR}} doubled!"

Descriptions.JokerSynergies[mod.Jokers.MISPRINT] = {}
Descriptions.JokerSynergies[mod.Jokers.MISPRINT][CollectibleType.COLLECTIBLE_TMTRAINER] = "Stats given range from {{ColorMult}}-1{{CR}} to {{CR}} {{ColorMult}}4{{CR}} Damage #{{Blank}} {{ColorGray}}(Stats can't go lower than their base value)"

Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD] = {}
Descriptions.JokerSynergies[mod.Jokers.ARROWHEAD][CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "{{BalatroSpade}} Spade charm becomes guaranteed"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER] = "{{Coin}} Also gives 2 {{ColorYellorange}}Golden pennies{{CR}} when sold this way"

Descriptions.JokerSynergies[mod.Jokers.GOLDEN_TICKET] = {}
Descriptions.JokerSynergies[mod.Jokers.GOLDEN_TICKET][CollectibleType.COLLECTIBLE_SMELTER] = Descriptions.JokerSynergies[mod.Jokers.GOLDEN_JOKER][CollectibleType.COLLECTIBLE_SMELTER]

Descriptions.JokerSynergies[mod.Jokers.CREDIT_CARD] = {}
Descriptions.JokerSynergies[mod.Jokers.CREDIT_CARD][CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "{{Coin}} being in debt counts as having half of the maximum amount of coins #{{Colorgray}} (it's not a bug, but a feature)" --ye ok it's actually a bug


--inverts the table to make collectible synergy descriptions lookup faster
Descriptions.ItemJokerSynergies = {}
for Joker,JokerSynergies in pairs(Descriptions.JokerSynergies) do
    
    for Item, SynString in pairs(JokerSynergies) do
        
        Descriptions.ItemJokerSynergies[Item] = Descriptions.ItemJokerSynergies[Item] or {}
        Descriptions.ItemJokerSynergies[Item][Joker] = SynString
    end
end


Descriptions.JimboSynergies = {}
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE] = "#{{PlayerJimbo}} When hitting an enemy, cards shoot 1 blood laser that deal 50% the card's damage in a random direction #{{BalatroSpade}} Spade cards shoot an extra laser #{{BalatroSpade}} All cads held in hand become Spade cards on pickup #\2 +50% card fire cooldown"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "#{{PlayerJimbo}} When hitting an enemy, cards shoot 1 laser that deal 50% the card's damage in a random direction #{{BalatroHeart}} Heart cards shoot an extra laser"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DR_FETUS] = "#{{PlayerJimbo}} When hitting an enemy, cards leave a bomb #The bombs deal 250% of the card's damage and inherit his bomb upgrades #{{BalatroClub}} Club card's bombs are bigger and deal more damage"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SMELTER] = "#{{PlayerJimbo}} On use allows to sell a Joker for double the normal amount of coins #{{Blank}}(used automatically when selling at full charge)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_BOX] = "#{{PlayerJimbo}} Has {{Battery}} 12 max charges #{{PlayerJimbo}} Also gains 2 charges when using a {{RestockMachine}} Restock machine"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DOLLAR] = "#{{PlayerJimbo}} Change all your deck's cards suit to {{BalatroDiamond}} Diamond"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYRO] = "#{{PlayerJimbo}} Change all your deck's cards suit to {{BalatroClub}} Club"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SKELETON_KEY] = "#{{PlayerJimbo}} Change all your deck's cards suit to {{BalatroSpade}} Spade"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BINGE_EATER] = "#{{PlayerJimbo}} Change all your deck's cards suit to {{BalatroHeart}} Heart"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEART] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroSpade}} Heart cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_QUARTER] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroDiamond}} Diamond cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOOM] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GLITTER_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOMBER_BOY] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HOT_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BUTT_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_NANCY_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCATTER_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroHeart}} Heart cards on pickup #{{BalatroHeart}} Heart cards are also considered as {{BalatroClub}} Club cards"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FAST_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOBBY_BOMB] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SAD_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GHOST_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STICKY_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARP_KEY] = "#{{PlayerJimbo}} {{BalatroSpade}} Spade cards can be used to open doors #{{BalatroSpade}} All cards held in hand become Spade cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_C_SECTION] = "#{{PlayerJimbo}} Cards fire a fetus as they land #{{BalatroHeart}} Heart cards fire an additional fetus #{{BalatroHeart}} All cards held in hand become heart cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TECH_X] = "#{{PlayerJimbo}} Cards are surrounded by a laser ring that deals 50% of its damage per tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "#{{PlayerJimbo}} Cards gain spectral and piercing, dealing 30% of its damage per tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TRISAGION] = "#{{PlayerJimbo}} Cards gain piercing, dealing 20% of its damage per tick"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "#{{PlayerJimbo}} The sword is applied on top of the usual card shooting"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALLOWED_GROUND] = "#{{PlayerJimbo}} The sword is applied on top of the usual card shooting"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM] = "#{{PlayerJimbo}} The sword is applied on top of the usual card shooting"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_POUND_OF_FLESH] = "#{{PlayerJimbo}} {{BalatroDiamond}} Diamond and {{BalatroHeart}} Heart are considered as the same suit"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_TMTRAINER] = "#{{PlayerJimbo}} All cards in the deck get randomised on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = "#{{PlayerJimbo}} {{BalatroSpade}} Spade cards have a 50% chance to {{Charm}} Charm enemies"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_ABADDON] = "#{{PlayerJimbo}} {{BalatroSpade}} Spade cards deal 10% more damage"

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

Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HALO] = "#{{PlayerJimbo}} {{BalatroDiamond}} Diamond cards gain a {{Collectible331}} God Head-like aura #{{BalatroDiamond}} All cads held in hand become Diamond cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = "#{{PlayerJimbo}} {{BalatroDiamond}} Diamond cards give {{ColorMult}}+0.01{{CR}} Damage per {{ColoraYellorange}}5{{CR}} coins held when scored"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE] = "#{{PlayerJimbo}} Tears given by {{BalatroBonus}} {{ColorYellorange}}Bouns enhancements{{CR}} are doubled"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SOUL] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SCAPULAR] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MITRE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_KEEPERS_KIN] = "#{{PlayerJimbo}} when landing, {{BalatroStone}} {{ColorYellorange}}Stone cards{{CR}} spawn 1-3 {{ColorYellorange}}Blue Spiders"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = "#{{PlayerJimbo}} Also gives the {{Collectible"..mod.Vouchers.Crystal.."}} Crystal ball effect while held"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "#{{PlayerJimbo}} Cards fired still block projectiles but can't disappear #{{ColorGray}} (Suit tears behave as usual)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PYROMANIAC] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroClub}} Club cards on pickup #{{BalatroClub}} Club cards are also considered as Heart cards"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_BOGO_BOMBS] = "#{{PlayerJimbo}} {{BalatroClub}} Club cards added to your deck are doubled"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_IRON_BAR] = "#{{PlayerJimbo}} {{BalatroSteel}} Steel cards cause {{Confusion}} Confusion to enemies hit"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "#{{PlayerJimbo}} {{BalatroGold}} Gold cards turn enemies hit into golden statues"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = "#{{PlayerJimbo}} All cards held in hand become {{BalatroWild}} Wild cards on pickup #{{Blank}} {{ColorGray}}(can't overwrite existing enhancements) #{{BalatroWild}} Wild cards gain additional random tear effects"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FRUIT_CAKE]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = "#{{PlayerJimbo}} {{BalatroYellorange}}3s{{CR}} fired gain 3 additional tear effects"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_GODHEAD] = "#{{PlayerJimbo}} All {{BalatroSpade}} Spade cards in your deck are destroyed #{{BalatroWild}} All other cards become {{ColroYellorange}}Wild Cards#{{Blank}} {{ColorGray}}(Can't overide existing enhancements)"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO] = "#{{PlayerJimbo}} {{BalatroClub}} Club cards are guaranteed to trigger their explosion"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_FIRE_MIND] = Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_EXPLOSIVO]
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = "#{{PlayerJimbo}} All {{BalatroDiamond}} Diamond cards spawn vanishing penny when hitting an enemy #{{PlayerJimbo}} All cards held in hand become {{BalatroDiamond}} Diamond cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_SHARD_OF_GLASS] = "#{{PlayerJimbo}} {{BalatroGlass}} Glass cards have the {{Collectible506}} Backstabber effect and always cause {{BleedingOut}} bleeding #{{PlayerJimbo}} All cards held in hand become {{BalatroGlass}} Glass cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = "#{{PlayerJimbo}} All {{BalatroDiamond}} Diamond cards turn enemies hit in golden statues #{{PlayerJimbo}} All cards held in hand become {{BalatroDiamond}} Diamond cards on pickup"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_MAGIC_SKIN] = "#{{PlayerJimbo}} Becomes {{ColorYellorange}}SINGLE USE #{{PlayerJimbo}} Also spawns 2 random {{BalatroJoker}} Jokers"
Descriptions.JimboSynergies[CollectibleType.COLLECTIBLE_DEEP_POCKETS] = "#{{PlayerJimbo}} Max coin amount is increased to 9999"
Descriptions.JimboSynergies[mod.Collectibles.POCKET_ACES] = "#{{PlayerJimbo}} Adds 2 aces with a random {{ColorYellorange}}Enhancement{{CR}}, {{ColorYellorange}}Seal{{CR}} and {{ColorYellorange}}Edition{{CR}} to the deck on pickup"




Descriptions.T_Jimbo.Enhancement = {}
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.NONE]  = ""
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.BONUS] = "# {{ColorChips}}+30{{CR}} Chips"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.MULT]  = "# {{ColorMult}}+4{{CR}} Mult"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GOLDEN] = "# {{ColorYellorange}}+3${{CR}} when held at the end of round"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.GLASS] = "# {{ColorMult}}X2{{CR}} Mult # {{ColorMint}}[[CHANCE]] in 4 Chance{{CR}} to break when played"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.LUCKY] = "# {{ColorMint}}[[CHANCE]]/5 Chance{{CR}} to give +{{ColorMult}}20{{CR}} Mult # {{ColorMint}}[[CHANCE]]/20 Chance{{CR}} to give {{ColorYellorange}}+20${{CR}}"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STEEL] = "# {{ColorMult}}X1.5{{CR}} Mult When held in hand"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.WILD]  = "# Is considered as being every {{ColorYellorange}}Suit{{CR}}"
Descriptions.T_Jimbo.Enhancement[mod.Enhancement.STONE] = "{{ColorChips}}+50{{CR}} Chips #Doesn't have a {{ColorYellorange}}Rank{{CR}} or {{ColorYellorange}}Suit{{CR}}"



Descriptions.T_Jimbo.Seal = {}
Descriptions.T_Jimbo.Seal[mod.Seals.NONE] = ""
Descriptions.T_Jimbo.Seal[mod.Seals.RED] = "# {{ColorYellorange}}Retriggered{{CR}} once"
Descriptions.T_Jimbo.Seal[mod.Seals.BLUE] = "# Create {{ColorYellorange}}winning{{CR}} hand's {{ColorCyan}}Planet{{CR}} if held"
Descriptions.T_Jimbo.Seal[mod.Seals.GOLDEN] = "# Earn {{ColorYellorange}}1${{CR}}"
Descriptions.T_Jimbo.Seal[mod.Seals.PURPLE] = "# Creates {{ColorPink}}Tarot{{CR}} when {{ColorRed}}Discarded{{CR}}"


Descriptions.T_Jimbo.Edition = {}
Descriptions.T_Jimbo.Edition[mod.Edition.BASE] = ""
Descriptions.T_Jimbo.Edition[mod.Edition.FOIL] = "#{{ColorChips}}+50{{CR}} Chips"
Descriptions.T_Jimbo.Edition[mod.Edition.HOLOGRAPHIC] = "#{{ColorMult}}+10{{CR}} Mult"
Descriptions.T_Jimbo.Edition[mod.Edition.POLYCROME] = "#{{ColorMult}}X1.5{{CR}} Mult"
Descriptions.T_Jimbo.Edition[mod.Edition.NEGATIVE] = "#{{ColorYellorange}}+1{{CR}} Joker Slot"
Descriptions.T_Jimbo.ConsumableNEGATIVE = "#{{ColorYellorange}}+1{{CR}} Consumable Slot"
Descriptions.T_Jimbo.CardNEGATIVE = "#{{ColorYellorange}}+1{{CR}} Hand Size"


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
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BOSS] = "{{ColorYellorange}}Reroll{{CR}} this ante's boss blind"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.BUFFON] = "Open a {{ColorYellorange}}Mega Buffon Pack{{CR}}"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.CHARM] = "Open a {{ColorYellorange}}Mega Arcana Pack{{CR}}"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.COUPON] = "Initial jokers and boosters in the next shops are {{ColorYellorange}}Free"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.D6] = "Rerolls in the next shop start at {{ColorYellorange}}0$"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.DOUBLE] = "Duplicates the next skip tag taken {{ColorGray}}(except Double Tag)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ECONOMY] = "Duplicate your money # {{ColorGray}}(Max 40$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ETHEREAL] = "Open a {{ColorYellorange}}Spectral Pack{{CR}}"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.FOIL] = "The next shop contains a free {{ColorChips}}Foil{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.GARBAGE] = "Gain {{ColorYellorange}}1${{CR}} per unused {{ColorMult}}Discard{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HANDY] = "Gain {{ColorYellorange}}1${{CR}} per played {{ColorChips}}Hand{{ColorGray}}([[VALUE1]]$)"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.HOLO] = "The next shop contains a free {{ColorMult}}Holographic{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.INVESTMENT] = "Gain {{ColorYellorange}}25${{CR}} after defeating thid ante's boss"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.JUGGLE] = "Gain {{ColorYellorange}}+3{{CR}} hand size for the next blind"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.METEOR] = "Open a {{ColorYellorange}}Mega Celestial Pack{{CR}}"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.NEGATIVE] = "The next shop contains a free {{ColorBlack}}Negative{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.ORBITAL] = "Upgrade {{ColorYellorange}}[[VALUE1]]{{CR}} by 3 levels"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.POLYCHROME] = "The next shop contains a free {{ColorRainbow}}Polychrome{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.RARE] = "The next shop contains a free {{ColorMult}}Rare{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.SPEED] = "Gain {{ColorYellorange}}5${{CR}} per blind skipped this run"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.STANDARD] = "Open a {{ColorYellorange}}Mega Standard Pack{{CR}}"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.TOP_UP] = "Gain up to {{ColorYellorange}}2{{CR}} {{ColorChips}}Common{{CR}} Jokers"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.UNCOMMON] = "The next shop contains a free {{ColorLime}}Uncommon{{CR}} Joker"
Descriptions.T_Jimbo.SkipTag[mod.SkipTags.VOUCHER] = "The next shop has an additional {{ColorYellorange}}Voucher"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_1] = "Gain {{ColorYellorange}}10${{CR}} and the {{ColorYellorange}}Key Piece 1{{CR}} item"
Descriptions.T_Jimbo.SkipTag[mod.SpecialSkipTags.KEY_PIECE_2] = "Gain {{ColorYellorange}}10${{CR}} and the {{ColorYellorange}}Key Piece 2{{CR}} item"


Descriptions.T_Jimbo.Jokers = {}
do
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER] = "{{ColorMult}}+4{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BULL] = " {{ColorChips}}+2{{CR}} Chips per {{ColorYellorange}}1${{CR}} you have# {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.INVISIBLE_JOKER] = "After {{ColorYellorange}}2{{CR}} rounds, sell this Joker to {{ColorYellorange}}Duplicate{{CR}} a random Joker {{ColorGray}}[[VALUE2]]#(Currently [[VALUE1]])"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ABSTRACT_JOKER] = "{{ColorMult}}+3{{CR}} Mult per Joker card# {{ColorGray}} (Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MISPRINT] = " {{ColorMult}}+0-23{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOKER_STENCIL] = "{{ColorMult}}X1{{CR}} Mult per empty Joker slot#{{CR}}Joker Stencil included# {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STONE_JOKER] = " {{ColorChips}}+25{{CR}} Chips per {{ColorYellorange}}Stone card{{CR}} in your {{ColorYellorange}}Full deck{{CR}} {{ColorGray}}#(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ICECREAM] = " {{ColorChips}}+[[VALUE1]]{{CR}} Chips#Loses {{ColorChips}}-5{{CR}} Chips every hand played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.POPCORN] = " {{ColorMult}}+[[VALUE1]]{{CR}} Mult #Loses {{ColorMult}}-4{{CR}} Mult every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAMEN] = " {{ColorMult}}X[[VALUE1]]{{CR}} Mult#loses {{ColorMult}}-0.01X{{CR}} per card discarded #{{Collectible682}} Gain a weaker copy of Worm Friend"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROCKET] = "{{Coin}} Earn {{ColorYellorange}}[[VALUE1]]${{CR}} at the end of round#Payout increases by {{ColorYellorange}}2${{CR}} when a boss blind is defeated"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ODDTODD] = "{{Damage}} Played cards with {{ColorYellorange}}odd{{CR}} rank give {{ColorChips}}+31{{CR}} Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EVENSTEVEN] = "{{Tears}} Played cards with {{ColorYellorange}}even{{CR}} rank give {{ColorChips}}+4{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALLUCINATION] = "{{ColorMint}}[[CHANCE]]/2 Chance{{CR}} to create a{{ColorPink}}Tarot{{CR}} card when opening a {{ColorYellorange}}Booster Pack"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEN_JOKER] = "This gains {{ColorMult}}+1{{CR}} Mult per hand played#{{ColorMult}}-1{{CR}} Mult per discard #{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RED_CARD] = "{{ColorMult}}+3{{CR}} Mult per {{ColorYellorange}}Booster Pack{{CR}}#{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAGABOND] = "Creates a{{ColorPink}}Tarot{{CR}} card when a hand is played with {{ColorYellorange}}4${{CR}} or less"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIFF_RAFF] = "When a{{ColorYellorange}}Blind{{CR}} is selected, creates up to 2 {{ColorChips}}common{{ColorYellorange}}Jokers{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_JOKER] = "Earn {{ColorYellorange}}4${{CR}} at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FORTUNETELLER] = "{{ColorMult}}+1{{CR}}Mult per {{ColorPink}}Tarot{{CR}} card used this run # {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUEPRINT] = "Copies the effect of the {{ColorYellorange}}Joker{{CR}} to its right#{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BRAINSTORM] = "Copies the effect of the leftmost held {{ColorYellorange}}Joker{{CR}}#{{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MADNESS] = "When a {{ColorYellorange}}Small{{CR}} or {{ColorYellorange}}Big Blind{{CR}} is selected, destroys another random Joker and gains {{ColorMult}}X0.5{{CR}} Mult# {{ColorMult}}(Currently X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MR_BONES] = "{{ColorMult}}Prevents Death{{CR}} and {{ColorYellorange}}self desctructs{{CR}} if the enemy with the most HP has up to{{ColorYellorange}}75% of the blind's base size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ONIX_AGATE] = "{{ColorChips}}Club{{CR}} cards give{{ColorMult}}+7{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ARROWHEAD] = "{{ColorSpade}}Spade{{CR}} cards give{{ColorChips}}+50{{CR}}Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLOODSTONE] = "{{ColorMult}}Heart{{CR}} card have a{{ColorMint}}[[CHANCE]]/2 chance{{CR}} to give {{ColorMult}}X1.5{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ROUGH_GEM] = "{{ColorYellorange}}Diamond{{CR}} cards give {{ColorYellorange}}1${{CR}} when scored"

Descriptions.T_Jimbo.Jokers[mod.Jokers.GROS_MICHAEL] = " {{ColorMult}}+15{{CR}}Mult #{{ColorMint}}[[CHANCE]]/6 chance{{CR}} of getting destoroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAVENDISH] = " {{ColorMult}}X3{{CR}}Mult # {{ColorMint}}[[CHANCE]]/1000 chance{{CR}} of getting destroyed every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLASH_CARD] = "This gains {{ColorMult}}+2{{CR}} Mult every {{ColorYellorange}}Shop{{ColorMint}}Reroll #{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SACRIFICIAL_DAGGER] = "When a blind is selcted, destroys the Joker to its right and gains {{ColorMult}}+double its sell value{{CR}} Mult #{{ColorGrey}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLOUD_NINE] = "Earn {{ColorYellorange}}1${{CR}} per {{ColorYellorange}}9{{CR}} in your {{ColorYellorange}}Full Deck{{CR}} at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SWASHBUCKLER] = "Adds the sell value of other owned{{ColorYellorange}}Jokers{{CR}}# {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CARTOMANCER] = "When a {{ColorYellorange}}blind{{CR}} is selected creates a{{ColorPink}}Tarot{{CR}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LOYALTY_CARD] = " {{ColorMult}}X4{{CR}} Mult once every {{ColorYellorange}}6{{CR}}hands played # {{ColorGray}}([[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERNOVA] = "Adds ne number of times {{ColorYellorange}}Poker hand{{CR}} was played to {{ColorMult}}Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DELAYED_GRATIFICATION] = "Earn {{ColorYellorange}}2${{CR}} per {{ColorMult}}Discard{{CR}} if none were used at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EGG] = "The sell value of this Joker increases by {{ColorYellorange}}2${{CR}} every {{ColorYellorange}}Blind{{CR}} cleared"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DNA] = "If the {{ColorYellorange}}First hand{{CR}} of round only contains {{ColorYellorange}}1{{CR}} card, add a copy to your {{ColorYellorange}}Deck{{CR}} and draw it in hand #{{ColorGray}}[[VALUE1]]"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMEARED_JOKER] = "{{ColorMult}}Hearts{{CR}} and {{ColorYellorange}}Diamonds{{CR}} count as the same suit #{{ColorSpade}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SLY_JOKER] = "{{ColorChips}}+50{{CR}}Chips if hand played contains a {{ColorYellorange}}Pair{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WILY_JOKER] = "{{ColorChips}}+100 {{CR}}Chips if hand played contains a {{ColorYellorange}}Three of a Kind{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CLEVER_JOKER] = "{{ColorChips}}+80 {{CR}}Chips if hand played contains a {{ColorYellorange}}Two Pair{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DEVIOUS_JOKER] = "{{ColorChips}}+100 {{CR}}Chips if hand played contains a {{ColorYellorange}}Striaght{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAFTY_JOKER] = "{{ColorChips}}+80 {{CR}}Chips if hand played contains a {{ColorYellorange}}Flush{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JOLLY_JOKER] = "{{ColorMult}}+8 {{CR}}Mult if hand played contains a {{ColorYellorange}}Pair{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ZANY_JOKER] = "{{ColorMult}}+12 {{CR}}Mult if hand played contains a {{ColorYellorange}}Three of a Kind{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MAD_JOKER] = "{{ColorMult}}+10 {{CR}}Mult if hand played contains a {{ColorYellorange}}Two Pair{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CRAZY_JOKER] = "{{ColorMult}}+12 {{CR}}Mult if hand played contains a {{ColorYellorange}}Straight{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DROLL_JOKER] = "{{ColorMult}}+10 {{CR}}Mult if hand played contains a {{ColorYellorange}}Flush{{CR}}"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MIME] = "{{ColorYellorange}}Retriggers{{CR}} all {{ColorYellorange}}held in hand{{CR}} abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FOUR_FINGER] = "{{ColorYellorange}}Flushes{{CR}} and {{ColorYellorange}}Straights{{CR}} only need 4 cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUSTY_JOKER] = "{{ColorMult}}Heart{{CR}} cards give {{ColorMult}}+3{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GREEDY_JOKER] = "{{ColorYellorange}}Diamond{{CR}} cards give {{ColorMult}}+3{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WRATHFUL_JOKER] = "{{ColorSpade}}Spade{{CR}} cards give {{ColorMult}}+3{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLUTTONOUS_JOKER] = "{{ColorChips}}Club{{CR}} cards give {{ColorMult}}+3 {{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MERRY_ANDY] = "{{ColorYellorange}}+3{{CR}} #{{ColorMult}}-1{{CR}} Hand size ##{{Heart}} Heal one extra heart on room clear"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HALF_JOKER] = "{{ColorMult}}+20{{CR}}Mult when hand played has {{ColorYellorange}}3 or less{{CR}} cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CREDIT_CARD] = "Shop items can be bought with up to {{ColorMult}}-20${{CR}} in debt #{{ColorGray}}(Effect is stackable)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BANNER] = "{{ColorChips}}+30{{CR}}Chips per remaining{{ColorYellorange}}Discard{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MYSTIC_SUMMIT] = "{{ColorMult}}+15{{CR}} when with {{ColorYellorange}}0{{CR}} discards remaining"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MARBLE_JOKER] = "When a {{ColorYellorange}}Blind{{CR}} is selected, adds a {{ColorYellorange}}Stone card{{CR}} to the deck"
Descriptions.T_Jimbo.Jokers[mod.Jokers._8_BALL] = "{{ColorMint}}[[CHANCE]]/4 Chance{{CR}} to create a{{ColorPink}}Tarot{{CR}}card when an {{ColorYellorange}}8{{CR}} is scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUSK] = "{{ColorYellorange}}Retriggers{{CR}} last hand of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RAISED_FIST] = "Adds {{ColorYellorange}}double{{CR}} the rank of the {{ColorYellorange}}lowest{{CR}} ranked card held in hand to {{ColorMult}}Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHAOS_CLOWN] = "{{ColorYellorange}}1{{CR}} free {{ColorMint}}Reroll{{CR}} per shop"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FIBONACCI] = "Every {{ColorYellorange}}Ace{{CR}}, {{ColorYellorange}}2{{CR}}, {{ColorYellorange}}3{{CR}}, {{ColorYellorange}}5{{CR}} and {{ColorYellorange}}8{{CR}} gives {{ColorMult}}+8{{CR}}Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STEEL_JOKER] = "This gains {{ColorMult}}X0.2{{CR}}Mult per {{ColorYellorange}}Steel card{{CR}} in your full deck"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SCARY_FACE] = "{{ColorYellorange}}Face cards{{CR}} give {{ColorChips}}+30{{CR}}Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HACK] = "Retriggers {{ColorYellorange}}2, 3, 4 and 5{{CR}} played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PAREIDOLIA] = "Every card counts as a {{ColorYellorange}}Face card{{CR}}"

Descriptions.T_Jimbo.Jokers[mod.Jokers.SCHOLAR] = "{{ColorYellorange}}Aces{{CR}} give {{ColorMult}}+4{{CR}} Mult and {{ColorChips}}+20{{CR}} Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BUSINESS_CARD] = "{{ColorYellorange}}Face cards{{CR}} have a {{ColorMint}}[[CHANCE]]/2 Chance{{CR}} to give{{ColorYellorange}}2${{CR}} when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RIDE_BUS] = "{{ColorMult}}+1{{CR}}Mult per consecutive hand played without a {{ColorYellorange}}scoring Face card#{{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{CR}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPACE_JOKER] = "{{ColorMint}}[[CHANCE]]/4 Chance{{CR}} to upgrade level of played {{ColorYellorange}}Poker hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURGLAR] = "After a round starts, removes all {{ColorMult}}Discards{{CR}} and gain {{ColorChips}}+3{{CR}} hands"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLACKBOARD] = "{{ColorMult}}X3{{CR}}Mult if all cards held in hand are {{ColorSpade}}Spades{{CR}} or {{ColorChips}}Clubs{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RUNNER] = "This gains {{ColorChips}}+15{{CR}} Chips when played hand contains a {{ColorYellorange}}Straight#{{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPLASH] = "All {{ColorYellorange}}played cards{{CR}} are considered in scoring"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BLUE_JOKER] = "{{ColorChips}}+2{{CR}}Chips per remaining card in your deck # {{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SIXTH_SENSE] = "If the {{ColorYellorange}}First{{CR}} hand played is a single {{ColorYellorange}}6{{CR}}, destroy it and create a {{ColorBlue}}Spectral{{CR}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CONSTELLATION] = "This Jokers gains {{ColorMult}}X0.1{{CR}} Mult every time a {{ColorCyan}}Planet{{CR}} card is used#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIKER] = "Cards gain {{ColorChips}}+5{{CR}} permanent Chips when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FACELESS] = "Gain {{ColorYellorange}}5${{CR}} when discarding {{ColorYellorange}}3 or more Face cards{{CR}} at once"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SUPERPOSISION] = "Create a {{ColorPink}}Tarot{{CR}} card when played hand contains a {{ColorYellorange}}Straight{{CR}} and an {{ColorYellorange}}Ace{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_DO_LIST] = "Gain {{ColorYellorange}}4${{CR}} when played hand is a {{ColorYellorange}}[[VALUE1]]{{CR}}#(Hand changes every round)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CARD_SHARP] = "{{ColorChips}}X3{{CR}} Mult if {{ColorYellorange}}Poker hand{{CR}} was alredy played this round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SQUARE_JOKER] = "This gains {{ColorChips}}+4{{CR}} Chips if hand played contains exactly {{ColorYellorange}}4{{CR}} cards#{{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEANCE] = "Creates a {{ColorYellorange}}Spectral{{CR}} card If a {{ColorYellorange}}Straight Flush{{CR}} is played"
Descriptions.T_Jimbo.Jokers[mod.Jokers.VAMPIRE] = "When a card with an {{ColorYellorange}}Enhancement{{CR}} is scored, this gains {{ColorChips}}X0.1{{CR}} Mult and removes the card's {{ColorYellorange}}Enhancement{{CR}}#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHORTCUT] = "Allows {{ColorYellorange}}Straights{{CR}} to be made with gaps of {{ColorYellorange}}1 rank{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HOLOGRAM] = "This gains {{ColorMult}}X0.25{{CR}}Mult when a card gets {{ColorYellorange}}added{{CR}} to the deck#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"

Descriptions.T_Jimbo.Jokers[mod.Jokers.BARON] = "Every {{ColorYellorange}}King{{CR}} held in hand gives {{ColorMult}}X1.5{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OBELISK] = "This gains {{ColorMult}}+0.2X{{CR}} Mult per {{ColorYellorange}}consecutive{{CR}} hand played without playing you most played {{ColorYellorange}}Poker hand{{CR}}#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MIDAS] = "Every scoring {{ColorYellorange}}Face card{{CR}} becomes {{ColorYellorange}}Golden{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCHADOR] = "{{ColorYellorange}}Selling{{CR}} this Joker disables all {{ColorYellorange}}Boss abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PHOTOGRAPH] = "First Scoring {{ColorYellorange}}Face card{{CR}} gives {{ColorMult}}X2{{CR}} Mult when {{ColorYellorange}}Scored{{CR}}"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GIFT_CARD] = "Every Joker and consumable held gains {{ColorYellorange}}1${{CR}} selling value at the end of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TURTLE_BEAN] = "Gain {{ColorCyan}}+[[VALUE1]]{{CR}} Hand Size #Loses {{ColorMult}}-1{{CR}} Hand size every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.EROSION] = "{{ColorChips}}+4{{CR}} Mult per card below {{ColorYellorange}}52{{CR}} in your {{ColorYellorange}}Full deck# {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.RESERVED_PARK] = "Each {{ColorYellorange}}Face card{{CR}} held in hand has a {{ColorMint}}[[CHANCE]]/4 Chance{{CR}} to give {{ColorYellorange}}1$"

Descriptions.T_Jimbo.Jokers[mod.Jokers.MAIL_REBATE] = "Earn {{ColorYellorange}}5${{CR}} per {{ColorYellorange}}[[VALUE1]]{{CR}} discarded #(Rank changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TO_THE_MOON] = "Interests earned are {{ColorYellorange}}Doubled"
Descriptions.T_Jimbo.Jokers[mod.Jokers.JUGGLER] = "{{ColorYellorange}}+1{{CR}} Hand Size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRUNKARD] = "{{ColorMult}}+1{{CR}} discard"
Descriptions.T_Jimbo.Jokers[mod.Jokers.LUCKY_CAT] = "This gains {{ColorMult}}X0.25{{CR}} Mult per {{ColorMint}}Successful{{ColorYellorange}}Lucky Card{{CR}} trigger#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BASEBALL] = "{{ColorMint}}Uncommon{{CR}} Jokers give {{ColorMult}}X1.5{{CR}} Mult"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DIET_COLA] = "{{ColorYellorange}}Selling{{CR}} this creates a {{ColorYellorange}}Double tag"

Descriptions.T_Jimbo.Jokers[mod.Jokers.TRADING_CARD] = "If first discard of round contains a {{ColorYellorange}}single{{CR}} card, destroy it and gain {{ColotYellor}}3$"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SPARE_TROUSERS] = "This gains {{ColorMult}}+2{{CR}} Mult if hand played caontains a {{ColorYellorange}}Two-pair{{CR}}#{{ColorGray}}(Currently{{ColorMult}}+[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ANCIENT_JOKER] = "[[VALUE1]]{{CR}} cards give {{ColorMult}}X1.5{{CR}}Mult when scored#(suit changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WALKIE_TALKIE] = "{{ColorYellorange}}10s{{CR}} and {{ColorYellorange}}4s{{CR}} give {{ColorChips}}+10{{CR}}Chips and {{ColorMult}}+4{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SELTZER] = "{{ColorYellorange}}Retriggers{{CR}} all played cards# {{ColorGray}}({{ColorYellorange}}[[VALUE1]]{{ColorGray}} hands remaining)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SMILEY_FACE] = "{{ColorYellorange}}Face cards{{CR}} give {{ColorMult}}+5{{CR}} Mult when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CAMPFIRE] = "This gains {{ColorMult}}X0.25{{CR}} Mult per card {{ColorYellorange}}sold{{CR}} this Ante #{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CASTLE] = "This gains {{ColorChips}}+3{{CR}} Chips per [[VALUE1]]{{CR}} card discarded #{{ColorGray}}(Currently {{ColorChips}}+[[VALUE2]]{{ColorGray}} Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GOLDEN_TICKET] = "{{ColorYellorange}}Golden{{CR}} cards give {{ColorYellorange}}4${{CR}} when scored"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ACROBAT] = "Gives {{ColorMult}}X3{{CR}} Mult on {{ColorYellorange}}last{{CR}} hand of round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SOCK_BUSKIN] = "{{ColorYellorange}}Retriggers{{CR}} played {{ColorYellorange}}Face{{CR}} cards"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TROUBADOR] = "{{ColorYellorange}}+2{{CR}} Hand Size #{{ColorMult}}-1{{CR}} Hands"
Descriptions.T_Jimbo.Jokers[mod.Jokers.THROWBACK] = "This gains {{ColorMult}}X0.25{{CR}} Mult per blind {{ColorYellorange}}skipped{{CR}} in this run# {{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CERTIFICATE] = "When a blind is {{ColorYellorange}}selected{{CR}}, adds a card with a random{{ColorYellorange}}Seal{{B_Black} to the deck and drawn to hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HANG_CHAD] = "{{ColorYellorange}}First{{CR}} scoring card played is {{ColorYellorange}}retriggered{{CR}} twice"
Descriptions.T_Jimbo.Jokers[mod.Jokers.GLASS_JOKER] = "This gains {{ColorMult}}X0.75{{CR}} per {{ColorYellorange}}Glass Card{{CR}} destroyed#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{Co}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOWMAN] = "{{ColorYellorange}}Joker{{CR}},{{ColorPink}}Tarot{{CR}},{{ColorCyan}}Planet{{CR}} and {{ColorBlue}}Spectral{{CR}} cards may appear multiple times"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FLOWER_POT] = "{{ColorChips}}X3{{CR}} Mult if {{oOlorYellorange}}scoring{{CR}} cards contain all{{COlorYellorange}}Suits"
Descriptions.T_Jimbo.Jokers[mod.Jokers.WEE_JOKER] = "This gains {{ColorChips}}+8{{CR}} Chips per {{ColorYellorange}}2{{CR}} scored#{{ColorGray}}(Currently {{ColorChips}}+[[VALUE1]]{{ColorGray}}Chips)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.OOPS_6] = "Every {{ColorMint}}Listed Chance{{CR}} is Doubled"
Descriptions.T_Jimbo.Jokers[mod.Jokers.IDOL] = "[[VALUE1]]{{CR}} give {{ColorMult}}X2{{CR}} Mult when scored #(Card changes every round)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SEE_DOUBLE] = "{{ColorMult}}X2{{CR}} Mult if hand played contains both a {{ColorYellorange}}scoring{{ColorChips}}club{{CR}} and {{ColorYellorange}}not-club{{CR}} card"
Descriptions.T_Jimbo.Jokers[mod.Jokers.MATADOR] = "Earn {{ColorYellorange}}+8${{CR}} when hand played triggers the {{ColorYellorange}}Boss blind{{CR}} effect"
Descriptions.T_Jimbo.Jokers[mod.Jokers.HIT_ROAD] = "This gains {{ColorMult}}X0.5{{CR}} Mult per {{ColorYellorange}}Jack{{CR}} discarded this round#{{ColorGray}}(Currently {{ColorMult}}X[[VALUE1]]{{ColorGray}}Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DUO] = "{{ColorMult}}X2{{CR}} Mult if hand played contains a {{ColorYellorange}}Pair "
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIO] = "{{ColorMult}}X3{{CR}} Mult if hand played contains a {{ColorYellorange}}Three of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.FAMILY] = "{{ColorMult}}X4{{CR}} Mult if hand played contains a {{ColorYellorange}}Four of a Kind"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ORDER] = "{{ColorMult}}X3{{CR}} Mult if hand played contains a {{ColorYellorange}}Straight"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBE] = "{{ColorMult}}X2{{CR}} Mult if hand played contains a {{ColorYellorange}}Flush"
Descriptions.T_Jimbo.Jokers[mod.Jokers.STUNTMAN] = "{{ColorMult}}+250{{CR}} Chips #{{ColorMult}}-s{B_Black}} Hand Size"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SATELLITE] = "Earn {{ColorYellorange}}1${{CR}} per unique {{ColorCyan}}Planet{{CR}} card used this run# {{ColorGray}}(Currently {{ColorYellorange}}[[VALUE1]]${{ColorGray}})"
Descriptions.T_Jimbo.Jokers[mod.Jokers.SHOOT_MOON] = "{{ColorMult}}+13{{CR}} Mult per {{ColorYellorange}}Queen{{CR}} held in hand"
Descriptions.T_Jimbo.Jokers[mod.Jokers.DRIVER_LICENSE] = "{{ColorMult}}X3{{CR}} Mult if you have at least {{ColorYellorange}}16 Enhanced cards{{CR}} in your full deck # {{ColorGray}}(Currently {{ColorYellorange}}[[VALUE1]]{{ColorGray}} Enhanced cards)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.ASTRONOMER] = "Every {{ColorCyan}}Planet{{CR}} card and {{ColorCyan}}Celestial{{CR}} pack is free"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BURNT_JOKER] = "{{ColorYellorange}}Upgrades{{CR}} the level first discarded {{ColorYellorange}}Poker hand{{CR}} every round"
Descriptions.T_Jimbo.Jokers[mod.Jokers.BOOTSTRAP] = "{{ColorMult}}+2{{CR}} Mult per {{ColorYellorange}}5${{CR}} you have# {{ColorGray}}(Currently {{ColorMult}}+[[VALUE1]]{{ColorGray}})"

Descriptions.T_Jimbo.Jokers[mod.Jokers.CANIO] = "This gains {{ColorMult}}X1{{CR}} Mult per a {{ColorYellorange}}Face{{CR}} card is {{ColorYellorange}}Destroyed{{CR}}#{{ColorGray}}(Currently {{ColroMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.TRIBOULET] = "{{ColorYellorange}}Kings{{CR}} and {{ColorYellorange}}Queens{{CR}} give {{ColorMult}}X2{{CR}} Mult when triggered"
Descriptions.T_Jimbo.Jokers[mod.Jokers.YORICK] = "This gains {{ColorMult}}X1{{CR}} Mult once every {{ColorYellorange}}23{{CR}} cards discarded#{{ColorGray}}([[VALUE2]] Remaining) #{{ColorGray}}(Currently {{ColroMult}}X[[VALUE1]]{{ColorGray}} Mult)"
Descriptions.T_Jimbo.Jokers[mod.Jokers.CHICOT] = "Disables all {{ColorYellorange}}Boss blind{{CR}} abilities"
Descriptions.T_Jimbo.Jokers[mod.Jokers.PERKEO] = "When exiting a {{ColorYellorange}}Shop{{CR}}, creates a {{ColorSpade}}Negative{{CR}} copy of a random consumable you have"


end


Descriptions.T_Jimbo.Debuffed = "All abilitied are disabled"


---------------------------------------
-------------####TAROTS####------------
---------------------------------------

Descriptions.Jimbo.Consumables = {}
Descriptions.Jimbo.Consumables[Card.CARD_FOOL] = "Spawns copy of your last used card #!!! Cannot spawn itself #[[VALUE1]] Currently: [[VALUE2]]"
Descriptions.Jimbo.Consumables[Card.CARD_MAGICIAN] = "Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMint}}Lucky Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "Spawns {{ColorYellorange}}2{{CR}} random {{ColorCyan}}Planet Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_EMPRESS] = "Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMult}}Mult Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_EMPEROR] = "Spawns {{ColorYellorange}}2{{CR}} random {{ColorPink}}Tarot Cards{{CR}} #!!! Cannot spawn itself"
Descriptions.Jimbo.Consumables[Card.CARD_HIEROPHANT] = "Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorChips}}Bonus Cards{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_LOVERS] = "Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorRainbow}}Wild Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_CHARIOT] = "Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorSilver}}Steel Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_JUSTICE] = "Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorGlass}}Glass Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_HERMIT] = "Doubles you current money #!!! Can give up to {{ColorYellorange}}20${{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{ColorMint}}25% chance{{CR}} to give a random {{ColorRainbow}}Edition{{CR}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
Descriptions.Jimbo.Consumables[Card.CARD_STRENGTH] = "Raise the Rank of {{ColorYellorange}}up to 2{{CR}} cards by 1 #!!! Kings chosen become Aces"
Descriptions.Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Removes from the deck {{ColorYellorange}}up to 2{{CR}} cards"
Descriptions.Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Second{{CR}} card chosen becomes the {{ColorYellorange}}First{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_TEMPERANCE] = "Gives the total {{ColorYellorange}}Sell value{{CR}} of you Jokers in {{Coin}}Pennies"
Descriptions.Jimbo.Consumables[Card.CARD_DEVIL] = "Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorYellorange}}Gold Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_TOWER] = "Turn {{ColorYellorange}}1{{CR}} card from your hand into a {{ColorGray}}Stone Card{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_STARS] = "Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorYellorange}}Diamonds{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_MOON] = "Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorChips}}Clubs{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_SUN] = "Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorMult}}Hearts{{CR}}"
Descriptions.Jimbo.Consumables[Card.CARD_JUDGEMENT] = "Gives a random {{ColorYellorange}}Joker{{CR}} #!!! Requires an empty Inventory slot"
Descriptions.Jimbo.Consumables[Card.CARD_WORLD] = "Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorSpade}}Spades{{CR}}"


Descriptions.T_Jimbo.Consumables = {}
Descriptions.T_Jimbo.Consumables[Card.CARD_FOOL] = "Creates copy of your last used {{ColorPink}}Tarot{{CR}} or {{ColorCyan}}Planet{{CR}} used#{{ColorGray}}(exept The Fool)#[[VALUE1]]"
Descriptions.T_Jimbo.Consumables[Card.CARD_MAGICIAN] = "Turn up to {{ColorYellorange}}2{{CR}} cards into {{ColorMint}}Lucky Cards{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIGH_PRIESTESS] = "Create {{ColorYellorange}}2{{CR}} {{ColorCyan}}Planet{{CR}} cards#{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPRESS] = "Turn up to {{ColorYellorange}}2{{CR}} cards into {{ColorMult}}Mult Cards{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_EMPEROR] = "Creates {{ColorYellorange}}2{{CR}} {{ColorPink}}Tarot{{CR}} cards #{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HIEROPHANT] = "Turn up to {{ColorYellorange}}2{{CR}} cards into {{ColorChips}}Bonus Cards{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_LOVERS] = "Turn {{ColorYellorange}}1{{CR}} card into a {{ColorRainbow}}Wild Card{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_CHARIOT] = "Turn {{ColorYellorange}}1{{CR}} card into a {{ColorSilver}}Steel Card{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUSTICE] = "Turn {{ColorYellorange}}1{{CR}} card into a {{ColorSilver}}Glass Card{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_HERMIT] = "Doubles you current money #{{ColorGray}}(Max 20$){{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_WHEEL_OF_FORTUNE] = "{{ColorMint}}[[CHANCE]]/4 Chance{{CR}} to give a random {{ColorRainbow}}Edition{{CR}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
Descriptions.T_Jimbo.Consumables[Card.CARD_STRENGTH] = "Raise the Rank of up to {{ColorYellorange}}2{{CR}} cards by 1 #{{ColorGray}}(Kings chosen become Aces)"
Descriptions.T_Jimbo.Consumables[Card.CARD_HANGED_MAN] = "Destroy up to {{ColorYellorange}}2{{CR}} cards"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEATH] = "Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Left{{CR}} card becomes a copy of the {{ColorYellorange}}Right{{CR}} card"
Descriptions.T_Jimbo.Consumables[Card.CARD_TEMPERANCE] = "Gives the total {{ColorYellorange}}Sell value{{CR}} of your Jokers#{{ColorGray}}(Currently {{ColorYellor}}[[VALUE1]]${{COlorGray}})"
Descriptions.T_Jimbo.Consumables[Card.CARD_DEVIL] = "Turn {{ColorYellorange}}1{{CR}} card into a {{ColorYellorange}}Gold Card{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_TOWER] = "Turn {{ColorYellorange}}1{{CR}} card into a {{ColorGray}}Stone Card{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_STARS] = "Set the Suit of up to {{ColorYellorange}}3{{CR}} cards into {{ColorYellorange}}Diamonds{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_MOON] = "Set the Suit of up to {{ColorYellorange}}3{{CR}} cards into {{ColorChips}}Clubs{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_SUN] = "Set the Suit of up to {{ColorYellorange}}3{{CR}} cards into {{ColorMult}}Hearts{{CR}}"
Descriptions.T_Jimbo.Consumables[Card.CARD_JUDGEMENT] = "Creates a random {{ColorYellorange}}Joker{{CR}} #{{ColorGray}}(Must have room)"
Descriptions.T_Jimbo.Consumables[Card.CARD_WORLD] = "Set the Suit of up to {{ColorYellorange}}3{{CR}} cards into {{ColorSpade}}Spades{{CR}}"


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
Descriptions.ConsumablesName[Card.CARD_DEVIL] = "The Davil"
Descriptions.ConsumablesName[Card.CARD_TOWER] = "The Tower"
Descriptions.ConsumablesName[Card.CARD_STARS] = "The Stars"
Descriptions.ConsumablesName[Card.CARD_MOON] = "The Moon"
Descriptions.ConsumablesName[Card.CARD_SUN] = "The Sun"
Descriptions.ConsumablesName[Card.CARD_JUDGEMENT] = "Judgement"
Descriptions.ConsumablesName[Card.CARD_WORLD] ="The World"



----------------------------------------
-------------####PLANETS####------------
-----------------------------------------

Descriptions.Jimbo.Consumables[mod.Planets.PLUTO] = "{{ColorYellorange}}Aces{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.MERCURY] = "{{ColorYellorange}}2s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.URANUS] = "{{ColorYellorange}}3s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.VENUS] = "{{ColorYellorange}}4s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.SATURN] = "{{ColorYellorange}}5s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.JUPITER] = "{{ColorYellorange}}6s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.EARTH] = "{{ColorYellorange}}7s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.MARS] = "{{ColorYellorange}}8s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.NEPTUNE] = "{{ColorYellorange}}9s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.PLANET_X] = "{{ColorYellorange}}10s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.CERES] = "{{ColorYellorange}}Jacks{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.ERIS] = "{{ColorYellorange}}Queens{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"
Descriptions.Jimbo.Consumables[mod.Planets.SUN] = "{{ColorYellorange}}Kings{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}} when scored"


Descriptions.T_Jimbo.Consumables[mod.Planets.PLUTO] = "Level up {{ColorYellorange}}High card#{{ColorMult}}+1{{CR}} Mult#{{ColorChips}}+10{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.MERCURY] = "Level up {{ColorYellorange}}Pair#{{ColorMult}}+1{{CR}} Mult#{{ColorChips}}+15{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.URANUS] = "Level up {{ColorYellorange}}Two Pair#{{ColorMult}}+1{{CR}} Mult#{{ColorChips}}+20{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.VENUS] = "Level up {{ColorYellorange}}Three of a Kind#{{ColorMult}}+2{{CR}} Mult#{{ColorChips}}+20{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.SATURN] = "Level up {{ColorYellorange}}Straight#{{ColorMult}}+3{{CR}} Mult#{{ColorChips}}+35{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.JUPITER] = "Level up {{ColorYellorange}}Flush#{{ColorMult}}+2{{CR}} Mult#{{ColorChips}}+15{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.EARTH] = "Level up {{ColorYellorange}}Full House#{{ColorMult}}+2{{CR}} Mult#{{ColorChips}}+25{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.MARS] = "Level up {{ColorYellorange}}Four of a Kind#{{ColorMult}}+3{{CR}} Mult#{{ColorChips}}+30{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.NEPTUNE] = "Level up {{ColorYellorange}}Straight Flush#{{ColorMult}}+4{{CR}} Mult#{{ColorChips}}+40{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.PLANET_X] = "Level up {{ColorYellorange}}Five of a Kind#{{ColorMult}}+3{{CR}} Mult#{{ColorChips}}+35{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.CERES] = "Level up {{ColorYellorange}}Flush House#{{ColorMult}}+4{{CR}} Mult#{{ColorChips}}+40{{CR}} Chips"
Descriptions.T_Jimbo.Consumables[mod.Planets.ERIS] = "Level up {{ColorYellorange}}Flush Five#{{ColorMult}}+3{{CR}} Mult#{{ColorChips}}+50{{CR}} Chips"


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
Descriptions.Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} up to {{ColorYellorange}}3{{CR}} cards from your hand and gives {{ColorYellorange}}4${{CR}} per card destroyed"
Descriptions.Jimbo.Consumables[mod.Spectrals.ANKH] = "{{PlayerJimbo}} Gives a copy a of random Joker held and destroys all the others #!!! Removes the {{ColorGray}}{{ColorFade}}Negative{{CR}} Edition from the copied Joker"
Descriptions.Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "{{PlayerJimbo}} Put a {{ColorRed}}Red Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.HEX] = "{{PlayerJimbo}} Gives the {{ColorRainbow}}Polychrome{{CR}} Edition to random Joker held and destroys all the others"
Descriptions.Jimbo.Consumables[mod.Spectrals.TRANCE] = "{{PlayerJimbo}} Put a {{ColorCyan}}Blue Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.MEDIUM] = "{{PlayerJimbo}} Put a {{ColorPink}}Purple Seal{{CR}} on one selected card"
Descriptions.Jimbo.Consumables[mod.Spectrals.CRYPTID] = "{{PlayerJimbo}} Add {{ColorYellorange}}2{{CR}} copies of a selected card to your deck"
Descriptions.Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "{{PlayerJimbo}} {{ColorYellorange}}All Cards{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}"
Descriptions.Jimbo.Consumables[mod.Spectrals.SOUL] = "{{PlayerJimbo}} Gives a random {{ColorRainbow}}Legendary{{CR}} Joker#!!! Requires an empty Inventory slot"



Descriptions.T_Jimbo.Consumables[mod.Spectrals.FAMILIAR] = "{{ColorYellorange}}Destroy{{CR}} a random card and add {{ColorYellorange}}3{{CR}} random {{ColorYellorange}}Enhanced Face{{CR}} cards to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.GRIM] = "{{ColorYellorange}}Destroy{{CR}} a random card and add {{ColorYellorange}}2{{CR}} random {{ColorYellorange}}Enhanced Aces{{CR}} to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.INCANTATION] = "{{ColorYellorange}}Destroy{{CR}} a random card and add {{ColorYellorange}}4{{CR}} random {{ColorYellorange}}Enhanced Numbered cards{{CR}} to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TALISMAN] = "Put a {{ColorYellorange}}Golden Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.AURA] = "Give a random {{ColorYellorange}}Edition{{CR}} to a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.WRAITH] = "Set your money to {{ColorYellorange}}0${{CR}} and create a random {{ColorMult}}Rare{{CR}} Joker"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SIGIL] = "Turn all cards in your hand to the same random {{ColorYellorange}}Suit{{CR}}"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.OUIJA] = "Turn all cards in your hand to the same random {{ColorYellorange}}Rank#{{ColorMult}}-1{{CR}} Hand size"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ECTOPLASM] = "Turn a random Joker {{ColorSpade}}Negative#{{ColorRed}}-[[VALUE1]]{{CR}} Hand size"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.IMMOLATE] = "Destroy {{ColorYellorange}}5{{CR}} cards from your hand and earn {{ColorYellorange}}20${{CR}}"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.ANKH] = "Duplicate random {{ColorYellorange}}Joker{{CR}} #Destroy all other Jokers held [[VALUE1]]"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.DEJA_VU] = "Put a {{ColorRed}}Red Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.HEX] = "Turn a random Joker {{ColoorRainbow}}Polychrome{{CR}} and destroys all the others"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.TRANCE] = "Put a {{ColorCyan}}Blue Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.MEDIUM] = "Put a {{ColorPink}}Purple Seal{{CR}} on a selected card"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.CRYPTID] = "Add {{ColorYellorange}}2{{CR}} copies of a selected card to your deck"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.BLACK_HOLE] = "Level up all {{ColorYellorange}}Poker hands"
Descriptions.T_Jimbo.Consumables[mod.Spectrals.SOUL] = "Create a random {{ColorRainbow}}Legendary{{CR}} Joker"


---------------------------------------
--------------BOOSTERS-----------------
---------------------------------------

Descriptions.Jimbo.Boosters = {}
Descriptions.Jimbo.Boosters[mod.Packs.ARCANA] = "Choose 1 {{ColorPink}}Tarot{{CR}} card out of {{ColorYellorange}}3{{CR}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{CR}} card out of {{ColorYellorange}}3{{CR}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.STANDARD] = "Choose 1 {{ColorYellorange}}Playing{{CR}} card out of {{ColorYellorange}}3{{CR}} to add to your deck"
Descriptions.Jimbo.Boosters[mod.Packs.BUFFON] = "Choose 1 {{ColorYellorange}}Joker{{CR}} out of {{ColorYellorange}}2{{CR}} to get immediantly"
Descriptions.Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Choose 1 {{ColorBlue}}Spectral{{CR}} card out of {{ColorYellorange}}2{{CR}} to use immediantly"



Descriptions.T_Jimbo.Boosters = {}
Descriptions.T_Jimbo.Boosters[mod.Packs.ARCANA] = "Choose 1 {{ColorPink}}Tarot{{CR}} card out of {{ColorYellorange}}3{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_ARCANA] = "Choose 1 {{ColorPink}}Tarot{{CR}} card out of {{ColorYellorange}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_ARCANA] = "Choose up to 2 {{ColorPink}}Tarot{{CR}} card out of {{ColorYellorange}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{CR}} card out of {{ColorYellorange}}3{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_CELESTIAL] = "Choose 1 {{ColorCyan}}Planet{{CR}} card out of {{ColorYellorange}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_CELESTIAL] = "Choose up to 2 {{ColorCyan}}Planet{{CR}} card out of {{ColorYellorange}}5{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.STANDARD] = "Choose 1 {{ColorYellorange}}Playing{{CR}} card out of {{ColorYellorange}}3{{CR}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_STANDARD] = "Choose 1 {{ColorYellorange}}Playing{{CR}} card out of {{ColorYellorange}}5{{CR}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_STANDARD] = "Choose up to 2 {{ColorYellorange}}Playing{{CR}} card out of {{ColorYellorange}}5{{CR}} to add to your deck"
Descriptions.T_Jimbo.Boosters[mod.Packs.BUFFON] = "Choose 1 {{ColorYellorange}}Joker{{CR}} out of {{ColorYellorange}}2{{CR}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_BUFFON] = "Choose 1 {{ColorYellorange}}Joker{{CR}} out of {{ColorYellorange}}4{{CR}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_BUFFON] = "Choose up to 2 {{ColorYellorange}}Joker{{CR}} out of {{ColorYellorange}}4{{CR}} to get immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.SPECTRAL] =  "Choose 1 {{ColorBlue}}Spectral{{CR}} card out of {{ColorYellorange}}2{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.JUMBO_SPECTRAL] = "Choose 1 {{ColorBlue}}Spectral{{CR}} card out of {{ColorYellorange}}4{{CR}} to use immediantly"
Descriptions.T_Jimbo.Boosters[mod.Packs.MEGA_SPECTRAL] = "Choose up to 2 {{ColorBlue}}Spectral{{CR}} card out of {{ColorYellorange}}4{{CR}} to use immediantly"



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
                           [mod.BLINDS.BOSS_HEART] = "Crimson heart ",
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
                        [mod.BLINDS.BOSS_PSYCHIC] = "Hand needs to contain at least 5 cards",}


Descriptions.BossEffects = {[mod.BLINDS.SMALL] = "No additional effect",
                            [mod.BLINDS.BIG] = "No additional effect",
                            [mod.BLINDS.BOSS] = "No additional effect",
                            [mod.BLINDS.BOSS_ACORN] = "Covers and shuffles all Jokers",
                            [mod.BLINDS.BOSS_ARM] = "Decreases level of hand played",
                            [mod.BLINDS.BOSS_BELL] = "Forces one card to be selected",
                            [mod.BLINDS.BOSS_CLUB] = "All club cards are debuffed",
                            [mod.BLINDS.BOSS_EYE] = "Cannot repeat hand types",
                            [mod.BLINDS.BOSS_FISH] = "Cards drawn after hand play are covered",
                            [mod.BLINDS.BOSS_FLINT] = "Halfes base chips and mult",
                            [mod.BLINDS.BOSS_GOAD] = "All spade cards are debuffed",
                            [mod.BLINDS.BOSS_HEAD] = "All heart cards are debuffed",
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
                            [mod.BLINDS.BOSS_WINDOW] = "All diamond cards are debuffed",
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

----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------


Descriptions.T_Jimbo.Vouchers = {}

Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber] = "{{ColorChips}}+1{{CR}} Hand every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.NachoTong] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Grabber]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful] = "{{ColorMult}}+1{{CR}} discard every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Recyclomancy] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Wasteful]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush] = "{{ColorChips}}+1{{CR}} Hand size"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Palette] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Brush]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Clearance] = "Everything in the shop is {{ColorYellorange}}25% off#{{ColorGray}}(rounded down)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Liquidation] = "Everything in the shop is {{ColorYellorange}}50% off#{{ColorGray}}(rounded down)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock] = "{{ColorYellorange}}+1{{CR}} Item available in the shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.OverstockPlus] = Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Overstock]
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hone] = "Special {{ColorRainbow}}Editions{{CR}} are {{ColorYellorange}}2X{{CR}} more likely to Appear"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.GlowUp] = "Special {{ColorRainbow}}Editions{{CR}} are {{ColorYellorange}}4X{{CR}} more likely to Appear"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollSurplus] = "{{ColorMint}}Rerolls{{CR}} cost {{ColorYellorange}}2${{CR}} less"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.RerollGlut] = "{{ColorMint}}Rerolls{{CR}} cost and additional {{ColorYellorange}}2${{CR}} less"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Crystal] = "{{ColorYellorange}}+1{{CR}} consumable slot"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Omen] = "{{ColorBlue}}Spectral{{CR}} cards may appear in {{ColorYellorange}}Arcana Packs"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Telescope] = "{{ColorYellorange}}Celestial Packs{{CR}} always contain the {{colorCyan}}Planet{{CR}} for your most played {{ColorYellorange}}Poker hand"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Observatory] = "{{ColorCyan}}Planets{{CR}} you hold give {{ColorMult}}X1.5{{CR}} for their respective {{ColorYellorange}}Poker hand"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotMerch] = "{{ColorPink}}Tarot{{CR}} cards appear{{ColorYellorange}}2X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.TarotTycoon] = "{{ColorPink}}Tarot{{CR}} cards appear{{ColorYellorange}}4X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetMerch] = "{{ColorCyan}}Planet{{CR}} cards appear{{ColorYellorange}}2X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.PlanetTycoon] = "{{ColorCyan}}Planet{{CR}} cards appear{{ColorYellorange}}4X{{CR}} more frequently"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneySeed] = "Raise the Interest cap to {{ColorYellorange}}10$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MoneyTree] = "Raise the Interest cap to {{ColorYellorange}}20$"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Blank] = "{{ColorGray}}Does nothing?"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Antimatter] = "{{ColorSpade}}+1{{CR}} Joker slot"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.MagicTrick] = "{{ColorYellorange}}Playing cards{{CR}} can appear in shop"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Illusion] = "{{ColorYellorange}}Playing cards{{CR}} in shop can have and {{ColorYellorange}}Enhancement{{CR}},{{ColorYellorange}}Edition{{CR}} and/or {{ColorYellorange}}Seal{{CR}}"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Hieroglyph] = "{{ColorYellorange}}-1{{CR}} Ante#{{ColorChips}}-1{{CR}} Hand every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Petroglyph] = "{{ColorYellorange}}-1{{CR}} Ante#{{ColorMult}}-1{{CR}} Discard every round"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Director] = "{{ColorPink}}Reroll{{CR}} boss blind {{ColorYellorange}}Once{{CR}} per Ante#({{ColorYellorange}}10${{CR}} per reroll)"
Descriptions.T_Jimbo.Vouchers[mod.Vouchers.Retcon] = "{{ColorPink}}Reroll{{CR}} boss blind {{ColorYellorange}}Unlimited{{CR}} times per Ante#({{ColorYellorange}}10${{CR}} per reroll)"


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

EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Triggers the {{Collectible105}} D6 effect for 5 coins", "Director's Cut", FileLanguage)
EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Triggers the {{Collectible283}} D100 effect for 5 coins", "Retcon", FileLanguage)

EID:addCollectible(mod.Vouchers.Hieroglyph, "{{PlayerJimbo}} Activates the {{Collectible127}} Forget Me Now! effect upon pickup", "Hieroglyph", FileLanguage)
EID:addCollectible(mod.Vouchers.Petroglyph, "{{PlayerJimbo}} Activates the {{Collectible127}} Forget Me Now! effect upon pickup", "Petroglyph", FileLanguage)

EID:addCollectible(mod.Vouchers.MagicTrick, "{{PlayerJimbo}} {{ColorMint}} 25% chance{{CR}} to be able to choose one more option from a pack #Can trigger Multiple times", "Magic Trick", FileLanguage)
EID:addCollectible(mod.Vouchers.Illusion, "{{PlayerJimbo}} Every pack opened has a{{ColorMint}} 55% chance{{CR}} to contain {{ColorYellorange}}2{{CR}} more options and a {{ColorMint}} 15% chance{{CR}} to let the player choose {{ColorYellorange}}1{{CR}} more option", "Observatory", FileLanguage)

EID:addCollectible(mod.Vouchers.MoneySeed, "{{PlayerJimbo}} Maximum interest increased to {{ColorYellorange}}10${{CR}}", "Money Seed", FileLanguage)
EID:addCollectible(mod.Vouchers.MoneyTree, "{{PlayerJimbo}} Maximum interest increased to {{ColorYellorange}}20${{CR}}", "Money Tree", FileLanguage)

EID:addCollectible(mod.Vouchers.PlanetMerch, "{{PlayerJimbo}} Every pickup has a {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card{{CR}}", "Planet Merchant", FileLanguage)
EID:addCollectible(mod.Vouchers.PlanetTycoon, "{{PlayerJimbo}} Every pickup has an additional {{ColorMint}}10% chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card{{CR}}", "Planet Tycoon", FileLanguage)

EID:addCollectible(mod.Vouchers.TarotMerch, "{{PlayerJimbo}} Every pickup has a {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Tarot Merchant", FileLanguage)
EID:addCollectible(mod.Vouchers.TarotTycoon, "{{PlayerJimbo}} Every pickup has an additional {{ColorMint}}10% chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Tarot Tycoon", FileLanguage)











-------------------------------------
---------------MAIN GAME-------------
-------------------------------------

EID:addCollectible(mod.Collectibles.BALOON_PUPPY, "Familiar that reflects enemy shots and deals 5 contact damage per second #Explodes dealing 3 x Isaac's Damage after taking enough damage #If Isaac takes damage, starts chasing down enemies", "Baloon Puppy",FileLanguage)		
EID:addCollectible(mod.Collectibles.BANANA, "Isaac shoots a devastating banana that creates a {{Collectible483}} Mama Mega! explosion on contact #!!! Upon use becomes {{Collectible"..mod.Collectibles.EMPTY_BANANA.."}} Empty Banana", "Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.EMPTY_BANANA, "Leaves a banana peel on the ground #Enemies that slip on the peels take damage basing on how fast they were moving", "Empty Banana",FileLanguage)		
EID:addCollectible(mod.Collectibles.CLOWN, "50% of enemies get either the {{Charm}} Charm or {{Fear}} Fear effect applied when standing close to Isaac", "Clown Costume",FileLanguage)		
EID:addCollectible(mod.Collectibles.CRAYONS, "While moving, create a trail of crayon dust that applies status effects #Effects applied change basing the dust's color #!!! Dust color changes every new room", "Box of Crayons",FileLanguage)		
EID:addCollectible(mod.Collectibles.FUNNY_TEETH, "Spawns a familiar that chases enemies dealing 15 damage per second #{{Chargeable}} Needs to be recharged by standing near it after being active for some time", "Funny Teeth",FileLanguage)		
EID:addCollectible(mod.Collectibles.HORSEY, "Spawns a familiar that jumps in an L pattern, creating damaging shockwaves upon landing #!!! The shockwaves cannot hurt Isaac", "Horsey",FileLanguage)		
EID:addCollectible(mod.Collectibles.LAUGH_SIGN, "An audience reacts live to Isaac's actions #{{BossRoom}} Clearing a boss room rewards the player with random pickups #Taking damage launches tomatoes that leave a damaging creep and apply {{Bait}} Bait upon landing", "Laugh Sign",FileLanguage)		
EID:addCollectible(mod.Collectibles.LOLLYPOP, "{{Timer}} A lollypop spawns on the ground every 25 seconds spent in an uncleared room #{{Collectible93}} Picking up the lollypops grants the Gamekid! effect for 5.5 seconds #!!! A maximum of 3 lollypops can be on the ground at once", "Lollypop",FileLanguage)		
EID:addCollectible(mod.Collectibles.POCKET_ACES, "{{Luck}} Tears have an 8% chance to become Ace cards #Ace cards deal the product of Isaac's {{Damage}} Damage and {{Tears}} Tears stat worth of damage", "Pocket Aces",FileLanguage)		
EID:addCollectible(mod.Collectibles.TRAGICOMEDY, "40% chance to wear a comedy or tragedy mask upon clearing a room #\1 The comedy mask grants: {{Tears}} +1 Firedelay, {{Speed}} +0.2 Speed and {{Luck}} +2 Luck #\1 Wearing a tragedy mask grants: {{Tears}} +0.5 Firedelay, {{Damage}} +1 Flat Damage and {{Range}} +2.5 Range #!!! both mask can be worn at once", "Tragicomedy",FileLanguage)		
EID:addCollectible(mod.Collectibles.UMBRELLA, "Isaac opens an umbrella, causing anvils to fall on top of him every 5 ~ 7 seconds #Anvils create damaging shockwaves when landing #Anvils can be reflected by the umbrella, sending them thorwards a near enemy #!!! Using the item again stops the anvils from falling", "Umbrella",FileLanguage)		

for i = 1, Balatro_Expansion.TastyCandyNum do --puts every candy stage

    EID:addTrinket(Balatro_Expansion.Trinkets.TASTY_CANDY[i], "{{Beggar}} Guarantees a payout when interacting with any beggar #!!! Uses left: {{ColorYellorange}}"..i, "Tasty Candy", FileLanguage)		
end


EID:addCollectible(mod.Collectibles.HEIRLOOM, "{{Coin}} All coins have a chance to get their value upgraded #{{Coin}} All pickups are more likely to turn into their golden variant", "Heirloom",FileLanguage)		
EID:addTrinket(mod.Trinkets.PENNY_SEEDS, "{{Coin}} Gain 1 coin per 5 coin isaac has every floor #Very low chance for the coins spawned to be a penny trinket or {{Collectible74}} The quarter", "Penny Seeds",FileLanguage)		
EID:addCollectible(mod.Collectibles.THE_HAND, "{{Card}} Up to 5 cards or runes can be stored in the active item #!!! Cards in excess will be destroyed #{{Chargeable}} Holding the item uses the cards stored in the order shown # Press [DROP] key to cycle the held cards # Also collects pickups and deals damage to enemies hit", "The Hand",FileLanguage)		
EID:addCard(mod.JIMBO_SOUL, "{{Timer}} For the current Room, balances Isaac's Damage and Tears stats #{{Blank}} {{ColorGray}}(Effect lasts longer if used multiple times)", "Soul of Jimbo", FileLanguage)
EID:addTrinket(mod.Jokers.CHAOS_THEORY, "{{Collectible402}} All pickups spawned are randomised", "Chaos Theory", FileLanguage)		
EID:addCollectible(mod.Collectibles.ERIS, "Enemies around Isaac are increasingly slowed the closer they are to him #After being slowed enough, enemies take 3% of their remaining health worth of damage per tick #{{Blank}} \7 (Min. 0.1)", "Eris",FileLanguage)		
EID:addCollectible(mod.Collectibles.PLANET_X, "{{Planetarium}} Gain the effect of a random Planetarium item every room clear", "Planet X",FileLanguage)		
EID:addCollectible(mod.Collectibles.CERES, "Familiar that blocks projectiles and deals 1 contact damage per second #When hit, creates asteroid bits that can block up to 2 shots and deal twice Isaac's damage", "Ceres",FileLanguage)		



Descriptions.ItemItemSynergies = {}
Descriptions.ItemItemSynergies[mod.Collectibles.FUNNY_TEETH] = {[CollectibleType.COLLECTIBLE_APPLE] = "# Also leaves a trail of damaging creep",
                                                                [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = "# Partially regains charge when killing an enemy",
                                                                [CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = "# Chance to apply random status effects",
                                                                [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = "# Chance to apply {{Bait}} Bait to enemies",
                                                                [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Chance to {{Coin}} Goldify enemies",
                                                                [CollectibleType.COLLECTIBLE_DEAD_TOOTH] = "# Chance to {{Poison}} Poison enemies",
                                                                [CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = "# Chance to heal its owner FOR {{HalfHeart}} half red heart when killing an enemy",
                                                                [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Chance to {{Poison}} Poison enemies and to drop a {{BlackHeart}} on every kill",
                                                                [CollectibleType.COLLECTIBLE_DOG_TOOTH] = "# Gains more speed and damage",
                                                                [CollectibleType.COLLECTIBLE_TOUGH_LOVE] = "# Deals 35% more damage",
                                                                [CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = "# When recharged, fires a smaller {{Collectible399}} Maw of the void ring"}
Descriptions.ItemItemSynergies[mod.Collectibles.CLOWN] = {[CollectibleType.COLLECTIBLE_BOZO] = "# All enemies are affected",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.HORSEY] = {[CollectibleType.COLLECTIBLE_BFFS] = "# Increased shockwave range",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.HEIRLOOM] = {[CollectibleType.COLLECTIBLE_TELEKINESIS] = "# Gain {{Collectible2}} Homing shots",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.THE_HAND] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Shoots a wisp per card held when swung",
                                                             [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = "# Deals +0.25 damage per {{Coin}} coin held to enemie and has a chance to turn them in golden statues",
                                                             [CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = "# Doubles damage dealt to enemies and increases the knockback strength",
                                                             [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = "# Chance to poinson enemies hit",
                                                             [CollectibleType.COLLECTIBLE_VIRUS] = "# Chance to poison enemies hit",
                                                             [CollectibleType.COLLECTIBLE_TELEKINESIS] = "# Deflects projectiles hit",
                                                             [mod.Collectibles.THE_HAND] = "# 5 more cards can be held at once",
                                                            }
Descriptions.ItemItemSynergies[mod.Collectibles.BANANA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Create 8 wisps with high chance to shoot explosive tears"}
Descriptions.ItemItemSynergies[mod.Collectibles.EMPTY_BANANA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# 2 wisps orbit the peels thrown"}
Descriptions.ItemItemSynergies[mod.Collectibles.UMBRELLA] = {[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "# Gain an outer ring wisp with chance of {{Confsion}} concussing tears per anvil fallen",
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


Descriptions.TrinketEdition = {[mod.Edition.BASE] = "",
                               [mod.Edition.FOIL] = "#{{Tears}} {{ColorChips}}+1{{CR}} Fire rate",
                               [mod.Edition.HOLOGRAPHIC] = "#{{Damage}} {{ColorMult}}+1.5{{CR}} Flat Damage",
                               [mod.Edition.POLYCROME] = "#{{Damage}} {{ColorMult}}x1.2{{CR}} Damage Multiplier",
                               [mod.Edition.NEGATIVE] = "#{{Collectible479}} Immediantly smelted when picked up"
                             }



return Descriptions