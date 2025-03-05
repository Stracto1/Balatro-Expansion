
Balatro_Expansion = RegisterMod("Balatro Expansion", 1)

-------------------------------
---@diagnostic disable: inject-field
TrinketType.TRINKET_JOKER = Isaac.GetTrinketIdByName("Joker")
--print(TrinketType.TRINKET_JOKER)
TrinketType.TRINKET_BULL = Isaac.GetTrinketIdByName("Bull")
TrinketType.TRINKET_INVISIBLE_JOKER = Isaac.GetTrinketIdByName("Invisible joker")
TrinketType.TRINKET_ABSTRACT_JOKER = Isaac.GetTrinketIdByName("Abstract joker")
TrinketType.TRINKET_MISPRINT = Isaac.GetTrinketIdByName("Misprint")
TrinketType.TRINKET_JOKER_STENCIL = Isaac.GetTrinketIdByName("Joker stencil")
TrinketType.TRINKET_STONE_JOKER = Isaac.GetTrinketIdByName("Stone joker")
TrinketType.TRINKET_ICECREAM = Isaac.GetTrinketIdByName("Ice cream")
TrinketType.TRINKET_POPCORN = Isaac.GetTrinketIdByName("Popcorn")
TrinketType.TRINKET_RAMEN = Isaac.GetTrinketIdByName("Ramen")
TrinketType.TRINKET_ROCKET = Isaac.GetTrinketIdByName("Rocket")
TrinketType.TRINKET_ODDTODD = Isaac.GetTrinketIdByName("Odd todd")
TrinketType.TRINKET_EVENSTEVEN = Isaac.GetTrinketIdByName("Even steven")
TrinketType.TRINKET_HALLUCINATION = Isaac.GetTrinketIdByName("Hallucination")
TrinketType.TRINKET_GREEN_JOKER = Isaac.GetTrinketIdByName("Green joker")
TrinketType.TRINKET_RED_CARD = Isaac.GetTrinketIdByName("Red card")
TrinketType.TRINKET_VAGABOND = Isaac.GetTrinketIdByName("Vagabond")
TrinketType.TRINKET_RIFF_RAFF = Isaac.GetTrinketIdByName("Riff-raff")
TrinketType.TRINKET_GOLDEN_JOKER = Isaac.GetTrinketIdByName("Golden joker")
TrinketType.TRINKET_FORTUNETELLER = Isaac.GetTrinketIdByName("Fortune Teller")
TrinketType.TRINKET_BLUEPRINT = Isaac.GetTrinketIdByName("Blueprint")
TrinketType.TRINKET_BRAINSTORM = Isaac.GetTrinketIdByName("Brainstorm")
TrinketType.TRINKET_SMEARED_JOKER = Isaac.GetTrinketIdByName("Smeared joker")
TrinketType.TRINKET_MADNESS = Isaac.GetTrinketIdByName("Madness")
TrinketType.TRINKET_MR_BONES = Isaac.GetTrinketIdByName("Mr. Bones")
TrinketType.TRINKET_ONIX_AGATE = Isaac.GetTrinketIdByName("Onyx agate")
TrinketType.TRINKET_ARROWHEAD = Isaac.GetTrinketIdByName("Arrowhead")
TrinketType.TRINKET_BLOODSTONE = Isaac.GetTrinketIdByName("Bloodstone")
TrinketType.TRINKET_ROUGH_GEM = Isaac.GetTrinketIdByName("Rough gem")
TrinketType.TRINKET_GROS_MICHAEL = Isaac.GetTrinketIdByName("Gros Michel")
TrinketType.TRINKET_CAVENDISH = Isaac.GetTrinketIdByName("Cavendish")
TrinketType.TRINKET_FLASH_CARD = Isaac.GetTrinketIdByName("Flash card")
TrinketType.TRINKET_SACRIFICIAL_DAGGER = Isaac.GetTrinketIdByName("Cerimonial dagger")
TrinketType.TRINKET_LOYALTY_CARD = Isaac.GetTrinketIdByName("Loyalty card")
TrinketType.TRINKET_SWASHBUCKLER = Isaac.GetTrinketIdByName("Swashbuckler")
TrinketType.TRINKET_CLOUD_NINE = Isaac.GetTrinketIdByName("Cloud 9")
TrinketType.TRINKET_CARTOMANCER = Isaac.GetTrinketIdByName("Cartomancer")
TrinketType.TRINKET_SUPERNOVA = Isaac.GetTrinketIdByName("Supernova")
TrinketType.TRINKET_DELAYED_GRATIFICATION = Isaac.GetTrinketIdByName("Delayed gratification")
TrinketType.TRINKET_EGG = Isaac.GetTrinketIdByName("Egg")
TrinketType.TRINKET_DNA = Isaac.GetTrinketIdByName("Dna")
--------------------------------
CollectibleType.COLLECTIBLE_THE_HAND = Isaac.GetItemIdByName("The hand")
----------------------------------
Card.CARD_PACK_STANDARD = Isaac.GetCardIdByName("Standard_Pack")
Card.CARD_PACK_BUFFON =  Isaac.GetCardIdByName("Buffon_Pack")
Card.CARD_PACK_CELESTIAL =  Isaac.GetCardIdByName("Planet_Pack")
Card.CARD_PACK_SPECTRAL =  Isaac.GetCardIdByName("Spectral_Pack")
Card.CARD_PACK_TAROT =  Isaac.GetCardIdByName("Tarot_Pack")

------------------------
Balatro_Expansion.Characters = {}
Balatro_Expansion.Characters.JimboType = Isaac.GetPlayerTypeByName("Jimbo", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.

Balatro_Expansion.Sounds = {}
Balatro_Expansion.Sounds.ADDMULT = Isaac.GetSoundIdByName("ADDMULTSFX")
Balatro_Expansion.Sounds.TIMESMULT = Isaac.GetSoundIdByName("TIMESMULTSFX")
Balatro_Expansion.Sounds.ACTIVATE = Isaac.GetSoundIdByName("ACTIVATESFX")
Balatro_Expansion.Sounds.CHIPS = Isaac.GetSoundIdByName("CHIPSSFX")
Balatro_Expansion.Sounds.MONEY = Isaac.GetSoundIdByName("MONEYSFX")
Balatro_Expansion.Sounds.SLICE = Isaac.GetSoundIdByName("SLICESFX")
Balatro_Expansion.Sounds.FOIL = Isaac.GetSoundIdByName("FOILAPPEARSFX")
Balatro_Expansion.Sounds.EDITIONEFFECT = Isaac.GetSoundIdByName("EDITIONEFFECTSFX")
Balatro_Expansion.Sounds.HOLO = Isaac.GetSoundIdByName("HOLOSFX")
Balatro_Expansion.Sounds.POLY = Isaac.GetSoundIdByName("POLYCHROMESFX")
Balatro_Expansion.Sounds.NEGATIVE = Isaac.GetSoundIdByName("NEGATIVESFX")
Balatro_Expansion.Sounds.SEAL = Isaac.GetSoundIdByName("SEALSFX")
Balatro_Expansion.Sounds.EXPLOSION = Isaac.GetSoundIdByName("EXPLOSIONSFX")
Balatro_Expansion.Sounds.PLAY = Isaac.GetSoundIdByName("CARDPLAYSFX")
Balatro_Expansion.Sounds.SELECT = Isaac.GetSoundIdByName("CARDSELECTSFX")
Balatro_Expansion.Sounds.DESELECT = Isaac.GetSoundIdByName("CARDDESELECTSFX")


Balatro_Expansion.EffectColors = {}
Balatro_Expansion.EffectColors.RED = Color(238/255, 49/255, 66/255)
Balatro_Expansion.EffectColors.BLUE = Color(49/255, 140/255, 238/255)
Balatro_Expansion.EffectColors.YELLOW = Color(238/255, 186/255, 49/255)
Balatro_Expansion.EffectColors.PURPLE = Color(238/255, 186/255, 49/255)


Balatro_Expansion.Packs = {}
Balatro_Expansion.Packs.ARCANA =  Isaac.GetCardIdByName("Tarot_Pack")
Balatro_Expansion.Packs.CELESTIAL = Isaac.GetCardIdByName("Planet_Pack")
Balatro_Expansion.Packs.BUFFON  =  Isaac.GetCardIdByName("Buffon_Pack")
Balatro_Expansion.Packs.SPECTRAL =  Isaac.GetCardIdByName("Spectral_Pack")
Balatro_Expansion.Packs.STANDARD = Isaac.GetCardIdByName("Standard_Pack")

Balatro_Expansion.Planets = {}
Balatro_Expansion.Planets.PLUTO =  Isaac.GetCardIdByName("Not_So_Planet_Pluto")
Balatro_Expansion.Planets.MERCURY = Isaac.GetCardIdByName("Planet_Mercury")
Balatro_Expansion.Planets.URANUS = Isaac.GetCardIdByName("Planet_Uranus")
Balatro_Expansion.Planets.VENUS =  Isaac.GetCardIdByName("Planet_Venus")
Balatro_Expansion.Planets.Saturn = Isaac.GetCardIdByName("Planet_Saturn")
Balatro_Expansion.Planets.JUPITER = Isaac.GetCardIdByName("Planet_Jupiter")
Balatro_Expansion.Planets.EARTH =  Isaac.GetCardIdByName("Planet_Earth")
Balatro_Expansion.Planets.MARS = Isaac.GetCardIdByName("Planet_Mars")
Balatro_Expansion.Planets.NEPTUNE = Isaac.GetCardIdByName("Planet_Neptune")
Balatro_Expansion.Planets.PLANET_X =Isaac.GetCardIdByName("Planet_X")
Balatro_Expansion.Planets.CERES =  Isaac.GetCardIdByName("Planet_Ceres")
Balatro_Expansion.Planets.ERIS = Isaac.GetCardIdByName("Planet_Eris")
Balatro_Expansion.Planets.SUN = Isaac.GetCardIdByName("Planet_Sun")

Balatro_Expansion.Spectrals = {}
Balatro_Expansion.Spectrals.FAMILIAR =  Isaac.GetCardIdByName("Spectral_Familiar")
Balatro_Expansion.Spectrals.GRIM = Isaac.GetCardIdByName("Spectral_Grim")
Balatro_Expansion.Spectrals.INCANTATION = Isaac.GetCardIdByName("Spectral_Incantation")
Balatro_Expansion.Spectrals.TALISMAN =  Isaac.GetCardIdByName("Spectral_Talisman")
Balatro_Expansion.Spectrals.AURA = Isaac.GetCardIdByName("Spectral_Aura")
Balatro_Expansion.Spectrals.WRAITH = Isaac.GetCardIdByName("Spectral_Wraith")
Balatro_Expansion.Spectrals.SIGIL =  Isaac.GetCardIdByName("Spectral_Sigil")
Balatro_Expansion.Spectrals.OUIJA = Isaac.GetCardIdByName("Spectral_Ouija")
Balatro_Expansion.Spectrals.ECTOPLASM = Isaac.GetCardIdByName("Spectral_Ectoplasm")
Balatro_Expansion.Spectrals.IMMOLATE =Isaac.GetCardIdByName("Spectral_Immolate")
Balatro_Expansion.Spectrals.ANKH =  Isaac.GetCardIdByName("Spectral_Ankh")
Balatro_Expansion.Spectrals.DEJA_VU = Isaac.GetCardIdByName("Spectral_Deja_vu")
Balatro_Expansion.Spectrals.HEX =  Isaac.GetCardIdByName("Spectral_Hex")
Balatro_Expansion.Spectrals.TRANCE = Isaac.GetCardIdByName("Spectral_Trance")
Balatro_Expansion.Spectrals.MEDIUM = Isaac.GetCardIdByName("Spectral_Medium")
Balatro_Expansion.Spectrals.CRYPTID =  Isaac.GetCardIdByName("Spectral_Cryptid")
Balatro_Expansion.Spectrals.BLACK_HOLE = Isaac.GetCardIdByName("Spectral_Black_hole")
Balatro_Expansion.Spectrals.SOUL = Isaac.GetCardIdByName("Spectral_Soul")


Balatro_Expansion.Trinkets = {} --rarities used for spawn weight and stuff
Balatro_Expansion.Trinkets.common = {TrinketType.TRINKET_JOKER,
TrinketType.TRINKET_GOLDEN_JOKER, TrinketType.TRINKET_HALLUCINATION, TrinketType.TRINKET_RIFF_RAFF,
TrinketType.TRINKET_EGG, TrinketType.TRINKET_DELAYED_GRATIFICATION,
TrinketType.TRINKET_CLOUD_NINE, TrinketType.TRINKET_ABSTRACT_JOKER, TrinketType.TRINKET_MISPRINT,
TrinketType.TRINKET_GREEN_JOKER, TrinketType.TRINKET_GROS_MICHAEL, TrinketType.TRINKET_CAVENDISH,
TrinketType.TRINKET_ICECREAM, TrinketType.TRINKET_POPCORN, TrinketType.TRINKET_ODDTODD, TrinketType.TRINKET_EVENSTEVEN,
TrinketType.TRINKET_RED_CARD, TrinketType.TRINKET_FORTUNETELLER, TrinketType.TRINKET_SWASHBUCKLER,
TrinketType.TRINKET_SUPERNOVA} 
Balatro_Expansion.Trinkets.uncommon = {TrinketType.TRINKET_INVISIBLE_JOKER,
TrinketType.TRINKET_FLASH_CARD, TrinketType.TRINKET_SMEARED_JOKER,TrinketType.TRINKET_MR_BONES,
TrinketType.TRINKET_ROCKET,TrinketType.TRINKET_ROUGH_GEM, TrinketType.TRINKET_CARTOMANCER,
TrinketType.TRINKET_BULL, TrinketType.TRINKET_JOKER_STENCIL, TrinketType.TRINKET_STONE_JOKER,
TrinketType.TRINKET_RAMEN, TrinketType.TRINKET_ONIX_AGATE, TrinketType.TRINKET_MADNESS,
TrinketType.TRINKET_BLOODSTONE, TrinketType.TRINKET_ARROWHEAD,TrinketType.TRINKET_SACRIFICIAL_DAGGER,
TrinketType.TRINKET_LOYALTY_CARD}
Balatro_Expansion.Trinkets.rare = {TrinketType.TRINKET_BLUEPRINT,
TrinketType.TRINKET_BRAINSTORM,TrinketType.TRINKET_VAGABOND, TrinketType.TRINKET_DNA}
Balatro_Expansion.Trinkets.legendary = {}


Balatro_Expansion.Vouchers = {}
Balatro_Expansion.Vouchers.Grabber = Isaac.GetItemIdByName("Grabber")
Balatro_Expansion.Vouchers.NachoTong = Isaac.GetItemIdByName("Nacho Tong")
Balatro_Expansion.Vouchers.Overstock = Isaac.GetItemIdByName("Overstock")
Balatro_Expansion.Vouchers.OverstockPlus = Isaac.GetItemIdByName("Ocerstock Plus")
Balatro_Expansion.Vouchers.Wasteful = Isaac.GetItemIdByName("Wasteful")
Balatro_Expansion.Vouchers.Recyclomancy = Isaac.GetItemIdByName("Recyclomancy")
Balatro_Expansion.Vouchers.RerollSurplus = Isaac.GetItemIdByName("Reroll Surplus")
Balatro_Expansion.Vouchers.RerollGlut = Isaac.GetItemIdByName("Reroll Glut")
Balatro_Expansion.Vouchers.TarotMerch = Isaac.GetItemIdByName("Tarot Merchant")
Balatro_Expansion.Vouchers.TarotTycoon = Isaac.GetItemIdByName("Tarot Tycoon")
Balatro_Expansion.Vouchers.PlanetMerch = Isaac.GetItemIdByName("Planet Merchant")
Balatro_Expansion.Vouchers.PlanetTycoon = Isaac.GetItemIdByName("Planet Tycoon")
Balatro_Expansion.Vouchers.Liquidation = Isaac.GetItemIdByName("Liquidation")
Balatro_Expansion.Vouchers.Clearance = Isaac.GetItemIdByName("Clearance Sale")
Balatro_Expansion.Vouchers.Hone = Isaac.GetItemIdByName("Hone")
Balatro_Expansion.Vouchers.GlowUp = Isaac.GetItemIdByName("Glow Up")
Balatro_Expansion.Vouchers.Crystal = Isaac.GetItemIdByName("Crystal Ball")
Balatro_Expansion.Vouchers.Omen = Isaac.GetItemIdByName("Omen Globe")
Balatro_Expansion.Vouchers.Antimatter = Isaac.GetItemIdByName("Antimatter")
Balatro_Expansion.Vouchers.Blank = Isaac.GetItemIdByName("Blank")
Balatro_Expansion.Vouchers.Telescope = Isaac.GetItemIdByName("Telescope")
Balatro_Expansion.Vouchers.Observatory = Isaac.GetItemIdByName("Observatory")
Balatro_Expansion.Vouchers.Brush = Isaac.GetItemIdByName("Brush")
Balatro_Expansion.Vouchers.Palette = Isaac.GetItemIdByName("Palette")
Balatro_Expansion.Vouchers.Director = Isaac.GetItemIdByName("Director's Cut")
Balatro_Expansion.Vouchers.Retcon = Isaac.GetItemIdByName("Retcon")
Balatro_Expansion.Vouchers.Hieroglyph = Isaac.GetItemIdByName("Hieroglyph")
Balatro_Expansion.Vouchers.Petroglyph = Isaac.GetItemIdByName("Petroglyph")
Balatro_Expansion.Vouchers.MagicTrick = Isaac.GetItemIdByName("Magic Trick")
Balatro_Expansion.Vouchers.Illusion = Isaac.GetItemIdByName("Illusion")
Balatro_Expansion.Vouchers.MoneySeed = Isaac.GetItemIdByName("Money Seed")
Balatro_Expansion.Vouchers.MoneyTree = Isaac.GetItemIdByName("Money Tree")


Balatro_Expansion.VoucherOff = Balatro_Expansion.Vouchers.Grabber % 2 --used for interal pools and stuff


Balatro_Expansion.Suits = {}
Balatro_Expansion.Suits.Spade = 1
Balatro_Expansion.Suits.Heart = 2
Balatro_Expansion.Suits.Club = 3
Balatro_Expansion.Suits.Diamond = 4

Balatro_Expansion.Enhancement = {}
Balatro_Expansion.Enhancement.NONE = 1
Balatro_Expansion.Enhancement.MULT = 2
Balatro_Expansion.Enhancement.BONUS = 3
Balatro_Expansion.Enhancement.WILD = 4
Balatro_Expansion.Enhancement.GLASS = 5
Balatro_Expansion.Enhancement.STEEL = 6
Balatro_Expansion.Enhancement.STONE = 7
Balatro_Expansion.Enhancement.GOLDEN = 8
Balatro_Expansion.Enhancement.LUCKY = 9

Balatro_Expansion.Seals = {}
Balatro_Expansion.Seals.NONE = 0
Balatro_Expansion.Seals.RED = 1
Balatro_Expansion.Seals.GOLDEN = 2
Balatro_Expansion.Seals.BLUE = 3
Balatro_Expansion.Seals.PURPLE = 4

Balatro_Expansion.Edition = {}
Balatro_Expansion.Edition.NOT_CHOSEN = -1
Balatro_Expansion.Edition.BASE = 0
Balatro_Expansion.Edition.FOIL = 1
Balatro_Expansion.Edition.HOLOGRAPHIC = 2
Balatro_Expansion.Edition.POLYCROME = 3
Balatro_Expansion.Edition.NEGATIVE = 4

Balatro_Expansion.Rarities = {}
Balatro_Expansion.Rarities.common = 1
Balatro_Expansion.Rarities.uncommon = 2
Balatro_Expansion.Rarities.rare = 3
Balatro_Expansion.Rarities.legendary = 4

Balatro_Expansion.HandTypes = {}
Balatro_Expansion.HandTypes.NONE = 0
Balatro_Expansion.HandTypes.HIGH_CARD = 1
Balatro_Expansion.HandTypes.PAIR = 2
Balatro_Expansion.HandTypes.TWO_PAIR = 3
Balatro_Expansion.HandTypes.THREE = 4
Balatro_Expansion.HandTypes.STRAIGHT = 5
Balatro_Expansion.HandTypes.FLUSH = 6
Balatro_Expansion.HandTypes.FULL_HOUSE = 7
Balatro_Expansion.HandTypes.FOUR = 8
Balatro_Expansion.HandTypes.STRAIGHT_FLUSH = 9
Balatro_Expansion.HandTypes.ROYAL_FLUSH = 9.5
Balatro_Expansion.HandTypes.FIVE = 10
Balatro_Expansion.HandTypes.FLUSH_HOUSE = 11
Balatro_Expansion.HandTypes.FIVE_FLUSH = 12

Balatro_Expansion.CARD_TEAR_VARIANTS = {Isaac.GetEntityVariantByName("Tear Spade Card"),
                                        Isaac.GetEntityVariantByName("Tear Heart Card"),
                                        Isaac.GetEntityVariantByName("Tear Club Card"),
                                        Isaac.GetEntityVariantByName("Tear Diamond Card")}
---
Balatro_Expansion.Challenges = {}
Balatro_Expansion.Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
---
Balatro_Expansion.AllCurses = {}
Balatro_Expansion.NormalCurses = {}
Balatro_Expansion.BossCurses = {}

Balatro_Expansion.AllCurses.THE_WALL = 1 << (Isaac.GetCurseIdByName("curse of the wall") - 1)

Balatro_Expansion.NormalCurses[1] = Balatro_Expansion.AllCurses.THE_WALL

Balatro_Expansion.BLINDS = {}
Balatro_Expansion.BLINDS.SMALL = 0
Balatro_Expansion.BLINDS.BIG = 1
Balatro_Expansion.BLINDS.BOSS = 2
---------------------------------
Balatro_Expansion.WantedEffect = 0 --needed to prevent effects from overlapping


Balatro_Expansion.Fonts = {}
Balatro_Expansion.Fonts.Balatro = Font()
--4th time's a charm i guess
Balatro_Expansion.Fonts.Balatro:Load("mods/balatro_expansion/resources/font/Balatro_Font4.fnt")

---------------------
local Game = Game()
Balatro_Expansion.GameStarted = false
--local HUD = Game:GetHUD()

Balatro_Expansion.Saved = {} --every value that needs to be stored between game starts
-------------------------------
--[[Balatro_Expansion.Saved.TrinketValues = {} --contains the "progress" for every trinket that needs it
-------------BASE VALUES------------- (changed on game start or when loading data)
Balatro_Expansion.Saved.TrinketValues.LastMisprintDMG = 0
Balatro_Expansion.Saved.TrinketValues.Fortune_Teller = 0
Balatro_Expansion.Saved.TrinketValues.Stone_joker = 0
Balatro_Expansion.Saved.TrinketValues.Ice_cream = 1
Balatro_Expansion.Saved.TrinketValues.Popcorn = 2
Balatro_Expansion.Saved.TrinketValues.Ramen = 1.3
Balatro_Expansion.Saved.TrinketValues.Rocket = 3
Balatro_Expansion.Saved.TrinketValues.Green_joker = 0
Balatro_Expansion.Saved.TrinketValues.Red_card = 0
Balatro_Expansion.Saved.TrinketValues.Blueprint = 0
Balatro_Expansion.Saved.TrinketValues.Brainstorm = 0
Balatro_Expansion.Saved.TrinketValues.Madness = 1
Balatro_Expansion.Saved.TrinketValues.LastBPitem = 0
Balatro_Expansion.Saved.TrinketValues.Flash_card = 0
Balatro_Expansion.Saved.TrinketValues.Cloud_9 = 9
Balatro_Expansion.Saved.TrinketValues.Loyalty_card = 6
Balatro_Expansion.Saved.TrinketValues.Sacrificial_dagger = 0
Balatro_Expansion.Saved.TrinketValues.Swashbuckler = 0
Balatro_Expansion.Saved.TrinketValues.Egg = 3
Balatro_Expansion.Saved.TrinketValues.Supernova = {}
Balatro_Expansion.Saved.TrinketValues.MichaelDestroyed = false
Balatro_Expansion.Saved.TrinketValues.GoldenMichelGone = false
Balatro_Expansion.Saved.TrinketValues.FirstBrain = true
Balatro_Expansion.Saved.TrinketValues.Dna = true
]]

Balatro_Expansion.Saved.GeneralRNG = RNG(1) --RNG object used in various ways (Set on game start)


Balatro_Expansion.Saved.Pools = {}
Balatro_Expansion.Saved.Pools.Vouchers = {
Balatro_Expansion.Vouchers.Grabber,
Balatro_Expansion.Vouchers.Overstock,
Balatro_Expansion.Vouchers.Wasteful,
Balatro_Expansion.Vouchers.RerollSurplus,
Balatro_Expansion.Vouchers.TarotMerch,
Balatro_Expansion.Vouchers.PlanetMerch,
Balatro_Expansion.Vouchers.Clearance,
Balatro_Expansion.Vouchers.Hone,
Balatro_Expansion.Vouchers.Crystal,
Balatro_Expansion.Vouchers.Blank,
Balatro_Expansion.Vouchers.Telescope,
Balatro_Expansion.Vouchers.Brush,
Balatro_Expansion.Vouchers.Director,
Balatro_Expansion.Vouchers.Hieroglyph,
Balatro_Expansion.Vouchers.MagicTrick,
Balatro_Expansion.Vouchers.MoneySeed
}

-----------JIMBO-------------------
Balatro_Expansion.Saved.Jimbo = {}
Balatro_Expansion.Saved.Jimbo.FullDeck = {} --the full deck of cards used by jimbo
do
local index = 1
for i = 1, 4, 1 do --cycles between the suits
    for j = 1, 13, 1 do --cycles for all the values
        Balatro_Expansion.Saved.Jimbo.FullDeck[index] = {}
        Balatro_Expansion.Saved.Jimbo.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
        Balatro_Expansion.Saved.Jimbo.FullDeck[index].Value = j
        Balatro_Expansion.Saved.Jimbo.FullDeck[index].Enhancement = Balatro_Expansion.Enhancement.NONE
        Balatro_Expansion.Saved.Jimbo.FullDeck[index].Seal = Balatro_Expansion.Seals.NONE
        Balatro_Expansion.Saved.Jimbo.FullDeck[index].Edition = Balatro_Expansion.Edition.BASE
        index = index +1
    end
end
end
Balatro_Expansion.Saved.Jimbo.DeckPointer = 6 --the card that is going to be picked next
Balatro_Expansion.Saved.Jimbo.CurrentHand = {5,4,3,2,1} --the pointers of the cards in FullDeck that are stored in "the hand" active item
Balatro_Expansion.Saved.Jimbo.MaxCards = 25 --the total amount of cards you can shoot before gettign debuffed

--these two don't do anything directly and are only used to not call #table every time
Balatro_Expansion.Saved.Jimbo.HandSize = 5
Balatro_Expansion.Saved.Jimbo.InventorySize = 3
Balatro_Expansion.Saved.Jimbo.MichelDestroyed = false

Balatro_Expansion.Saved.Jimbo.SmallBlind = 0
Balatro_Expansion.Saved.Jimbo.BigBlind = 0
Balatro_Expansion.Saved.Jimbo.ClearedRooms = 0
Balatro_Expansion.Saved.Jimbo.SmallCleared = false
Balatro_Expansion.Saved.Jimbo.BigCleared = false
Balatro_Expansion.Saved.Jimbo.BossCleared = 0

Balatro_Expansion.StatEnable = false --needed cause i hate my life
Balatro_Expansion.Saved.Jimbo.StatsToAdd = {}
Balatro_Expansion.Saved.Jimbo.StatsToAdd.Damage = 0
Balatro_Expansion.Saved.Jimbo.StatsToAdd.Tears = 0
Balatro_Expansion.Saved.Jimbo.StatsToAdd.Mult = 1
Balatro_Expansion.Saved.Jimbo.StatsToAdd.JokerDamage = 0
Balatro_Expansion.Saved.Jimbo.StatsToAdd.JokerTears = 0
Balatro_Expansion.Saved.Jimbo.StatsToAdd.JokerMult = 1

Balatro_Expansion.Saved.Jimbo.Progress = {} --values used for jokers
Balatro_Expansion.Saved.Jimbo.Progress.Inventory = {0,0,0} --never reset, changed in different ways basing on the joker

Balatro_Expansion.Saved.Jimbo.Progress.Blind = {} --reset every new blind
Balatro_Expansion.Saved.Jimbo.Progress.Blind.Shots = 0

Balatro_Expansion.Saved.Jimbo.Progress.Room = {} --reset every new room
Balatro_Expansion.Saved.Jimbo.Progress.Room.SuitUsed = {}
Balatro_Expansion.Saved.Jimbo.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Spade] = 0
Balatro_Expansion.Saved.Jimbo.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Heart] = 0
Balatro_Expansion.Saved.Jimbo.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Club] = 0
Balatro_Expansion.Saved.Jimbo.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Diamond] = 0
Balatro_Expansion.Saved.Jimbo.Progress.Room.ValueUsed = {}
for Value =1, 13 do
    Balatro_Expansion.Saved.Jimbo.Progress.Room.ValueUsed[Value] = 0
end
Balatro_Expansion.Saved.Jimbo.Progress.Room.Shots = 0 --used to tell how many cards are already used

Balatro_Expansion.Saved.Jimbo.Progress.Floor = {}
Balatro_Expansion.Saved.Jimbo.Progress.Floor.Vouchers = {} --says which vouchers have already been spawned in a floor


Balatro_Expansion.Saved.Jimbo.LastUsed = {} --the last card a player used
Balatro_Expansion.Saved.Jimbo.EctoUses = 0 --how many times the Ectoplasm card got used in a run


Balatro_Expansion.Saved.Jimbo.TrueDamageValue = 1 --used to surpass the usual 0.5 minimum damage cap (got this idea from isaacguru's Utility Commands)
Balatro_Expansion.Saved.Jimbo.TrueTearsValue = 1

Balatro_Expansion.Saved.Jimbo.Inventory = {}
Balatro_Expansion.Saved.Jimbo.Inventory.Jokers = {0,0,0}
Balatro_Expansion.Saved.Jimbo.Inventory.Editions = {0,0,0}

Balatro_Expansion.Saved.Jimbo.FirstDeck = true

Balatro_Expansion.Saved.Jimbo.CardLevels = {}
for i=1, 13 do
    Balatro_Expansion.Saved.Jimbo.CardLevels[i] = 0
end

--[[
Balatro_Expansion.Saved.Jimbo.HandLevels = {}
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.HIGH_CARD] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.PAIR] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.TWO_PAIR] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.THREE] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.STRAIGHT] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.FLUSH] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.FULL_HOUSE] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.FOUR] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.ROYAL_FLUSH] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.FIVE] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.FLUSH_HOUSE] = 1
Balatro_Expansion.Saved.Jimbo.HandLevels[Balatro_Expansion.HandTypes.FIVE_FLUSH] = 1

Balatro_Expansion.Saved.Jimbo.HandsStat = {}
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.NONE] = Vector(0,0)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.HIGH_CARD] = Vector(0.05,0.2)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.PAIR] = Vector(0.1,0.4)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.TWO_PAIR] = Vector(0.1,0.8)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.THREE] = Vector(0.15,1.2)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.STRAIGHT] = Vector(0.2,1.2)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.FLUSH] = Vector(0.2,1.4)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.FULL_HOUSE] = Vector(0.2,1.6)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.FOUR] = Vector(0.35,2.4)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = Vector(0.4,4)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.ROYAL_FLUSH] = Vector(0.4,4)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.FIVE] = Vector(0.6,4.8)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.FLUSH_HOUSE] = Vector(0.7,5.6)
Balatro_Expansion.Saved.Jimbo.HandsStat[Balatro_Expansion.HandTypes.FIVE_FLUSH] = Vector(0.8,6.4)


Balatro_Expansion.HandUpgrades = {}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.HIGH_CARD] = Vector(0.05,0.4)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.PAIR] = Vector(0.05,0.6)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.TWO_PAIR] = Vector(0.05,0.6)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.THREE] = Vector(0.1,0.8)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.STRAIGHT] = Vector(0.15,1.2)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FLUSH] = Vector(0.1,0.6)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FULL_HOUSE] = Vector(0.1,1)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FOUR] = Vector(0.15,1.2)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = Vector(0.2,1.6)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.ROYAL_FLUSH] = Vector(0.2,1.6)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FIVE] = Vector(0.15,1.4)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FLUSH_HOUSE] = Vector(0.2,1.6)
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FIVE_FLUSH] = Vector(0.15,2)

Balatro_Expansion.Saved.Jimbo.FiveUnlocked = false
Balatro_Expansion.Saved.Jimbo.FlushHouseUnlocked = false
Balatro_Expansion.Saved.Jimbo.FiveFlushUnlocked = false]]--

Balatro_Expansion.Saved.Jimbo.FloorEditions = {} --used to save which trinkets have certaain edition modifiers applied

--OTHER VALUES
Balatro_Expansion.HpEnable = false
Balatro_Expansion.ShopAddedThisFloor = false

Balatro_Expansion.Counters = {}--table used for variuos counters increased every update (mainly used for animated HUD stuff)
Balatro_Expansion.Counters.SinceShift = 0
Balatro_Expansion.Counters.SinceSelect = 0
Balatro_Expansion.Counters.Activated = {}

Balatro_Expansion.Saved.Other = {}
Balatro_Expansion.Saved.Other.DamageTakenRoom = 0
Balatro_Expansion.Saved.Other.DamageTakenFloor = 0
Balatro_Expansion.Saved.Other.ShopEntered = false
Balatro_Expansion.Saved.Other.TreasureEntered = false
Balatro_Expansion.Saved.Other.Picked = {0}  --to prevent weird shenadigans
Balatro_Expansion.Saved.Other.Tags = {}
Balatro_Expansion.Saved.Other.Labyrinth = 1

Balatro_Expansion.Saved.ModConfig = {}
Balatro_Expansion.Saved.ModConfig.EffectsAllowed = true
Balatro_Expansion.Saved.ModConfig.ExtraReadability = false


Balatro_Expansion.SelectionParams = {}
Balatro_Expansion.SelectionParams.Frames = 0 -- in update frames
Balatro_Expansion.SelectionParams.SelectedCards = {false,false,false,false,false}
Balatro_Expansion.SelectionParams.Index = 1
Balatro_Expansion.SelectionParams.HandType = 0
Balatro_Expansion.SelectionParams.PossibleHandTypes = {} --this contains every kind of hand that the selected one contains
Balatro_Expansion.SelectionParams.Mode = 0
Balatro_Expansion.SelectionParams.Purpose = 0
Balatro_Expansion.SelectionParams.PackOptions = {} --the options for the selection inside of a pack
Balatro_Expansion.SelectionParams.OptionsNum = 0 --total amount of options
Balatro_Expansion.SelectionParams.MaxSelectionNum = 0 --how many things you can choose at a time
Balatro_Expansion.SelectionParams.SelectionNum = 0 --how many things you chose

Balatro_Expansion.SelectionParams.Modes = {}
Balatro_Expansion.SelectionParams.Modes.NONE = 0
Balatro_Expansion.SelectionParams.Modes.HAND = 1
Balatro_Expansion.SelectionParams.Modes.PACK = 2
Balatro_Expansion.SelectionParams.Modes.INVENTORY = 3

Balatro_Expansion.SelectionParams.Purposes = {}
Balatro_Expansion.SelectionParams.Purposes.NONE = 0
Balatro_Expansion.SelectionParams.Purposes.HAND = 1
--odd ones have 1 selectable card || even ones have 2 (why did i do this)((cause i didn't want to put like 20 if statements in a row))
Balatro_Expansion.SelectionParams.Purposes.EMPRESS = 2
Balatro_Expansion.SelectionParams.Purposes.LOVERS = 3
Balatro_Expansion.SelectionParams.Purposes.MAGICIAN = 4
Balatro_Expansion.SelectionParams.Purposes.JUSTICE = 5
Balatro_Expansion.SelectionParams.Purposes.HIEROPHANT = 6
Balatro_Expansion.SelectionParams.Purposes.CHARIOT = 7
Balatro_Expansion.SelectionParams.Purposes.STRENGTH = 8
Balatro_Expansion.SelectionParams.Purposes.TOWER = 9
Balatro_Expansion.SelectionParams.Purposes.HANGED = 10
Balatro_Expansion.SelectionParams.Purposes.DEVIL = 11
Balatro_Expansion.SelectionParams.Purposes.DEATH1 = 12
--3 selectiable cards
Balatro_Expansion.SelectionParams.Purposes.WORLD = 13
Balatro_Expansion.SelectionParams.Purposes.SUN = 14
Balatro_Expansion.SelectionParams.Purposes.MOON = 15
Balatro_Expansion.SelectionParams.Purposes.STARS = 16

Balatro_Expansion.SelectionParams.Purposes.DEJA_VU = 17
Balatro_Expansion.SelectionParams.Purposes.TALISMAN = 18
Balatro_Expansion.SelectionParams.Purposes.TRANCE = 19
Balatro_Expansion.SelectionParams.Purposes.MADIUM = 20
Balatro_Expansion.SelectionParams.Purposes.AURA = 21
Balatro_Expansion.SelectionParams.Purposes.CRYPTID = 22

Balatro_Expansion.SelectionParams.Purposes.StandardPack = 23
Balatro_Expansion.SelectionParams.Purposes.TarotPack = 24
Balatro_Expansion.SelectionParams.Purposes.CelestialPack = 25
Balatro_Expansion.SelectionParams.Purposes.SpectralPack = 26
Balatro_Expansion.SelectionParams.Purposes.BuffonPack = 27
Balatro_Expansion.SelectionParams.Purposes.SELLING = 28
Balatro_Expansion.SelectionParams.Purposes.MegaFlag = 128 --applied on top of the packs purposes to say it's a double choice
----------------------------- gaw damn those were a lot of variables


--heyo dear mod developer college! Fell free to take any of the code written here
--but please make sure to give this mod credit when you take important/big chunks of code

--also i don't know whether or not this thing is coded properly, so if you have an
--optimisation idea write it in the comments of the steam page and i'll try to implement it (giving you credit obv)

--Wanna do a big shoutuot to CATINSURANCE for making very good yt tutorial vids and also 
--because i took some inspiration from The Sheriff's code while making this

--[[
local LogoSprite = Sprite("gfx/ui/main menu/titlemenu.anm2",true)
print(LogoSprite:GetAnimation())

LogoSprite:Load("gfx/ui/main menu/titlemenu.anm2", true)

--LogoSprite:ReplaceSpritesheet(2, "gfx/ui/main menu/logo_up.png", true)
]]--



--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off with MOD CONFIG MENU)
include("Balatro_scripts.Effects")

-----------------OTHER/OFTEN USED FUNCTIONS---------------------
----------------------------------------------------------------
--general function used in the code

include("Balatro_scripts.Utility.Utility")
include("Balatro_scripts.Utility.save_manager")

---------------CURSES/CHALLENGES-----------------
-------------------------------------------------
--all the code regarding the custom challenges and curses
--since i'm a masochist, the curse callbacks are only added when needed just like the trinkets do

include("Balatro_scripts.Challenges")

-------------------CURSES FUNCTIONS--------------------------

----------------WALL--------------------------
---@param Entity EntityNPC 
function Balatro_Expansion:CurseNPCInit(Entity)
    --print(Entity.Type)
    local Level = Game:GetLevel()
    if Level:GetCurses() & Balatro_Expansion.AllCurses.THE_WALL == Balatro_Expansion.AllCurses.THE_WALL then
        --bosses gain a bit less buff
        if Entity:IsBoss() then
            Entity.MaxHitPoints = (Entity.MaxHitPoints * 1.3) + 10
            Entity.HitPoints = (Entity.HitPoints * 1.3) + 10
            Entity.Size = Entity.Size * 1.2 --Hitbox size
            Entity.Scale = Entity.Scale * 1.2 --sprite size (also increases projectile size)
        --normal enemies 
        elseif Entity.Type ~= EntityType.ENTITY_FIREPLACE and Entity.Type ~= EntityType.ENTITY_MOVABLE_TNT and Entity.Type ~= EntityType.ENTITY_SHOPKEEPER then

            Entity.MaxHitPoints = (Entity.MaxHitPoints * 1.4) + 1
            Entity.HitPoints = (Entity.HitPoints * 1.4) + 1
            Entity.Size = Entity.Size * 1.3 --hitbox size
            Entity.Scale = Entity.Scale * 1.3 --sprite size
        end
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Balatro_Expansion.CurseNPCInit)


---@param Entity EntityNPC 
function Balatro_Expansion:CurseNPCUpdate(Entity)
    --print("enemy update "..Entity.Type)
    local Level = Game:GetLevel()
    if Level:GetCurses() & Balatro_Expansion.AllCurses.THE_WALL == Balatro_Expansion.AllCurses.THE_WALL then
        --print("wall")
        if Entity:IsEnemy() then
            Entity.Velocity = Entity.Velocity * 0.85
        end
    end
end
--Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, Balatro_Expansion.CurseNPCUpdate)


--------------TRINKETS/ITEMS CALLBACKS---------------
-----------------------------------------------------

--all of the callbacks used by the trinkets and items made by this mod

--STATS TRINKETS: their value is increassed/decreades in their assingned callbacks
                --such as OnNewFloor() ecc.
                --while the statups are given in their cache evaluation functions (obv)

--ACTIVATE TRINKETS: usually all they do is put in a function called whenever it needs to activate,
                --   which can be found inside the section of the cache evaluation functions
include("Balatro_scripts.characters.jimbo.mechanics")
include("Balatro_scripts.characters.jimbo.trinkets") --jimbo trinkets/items effects
include("Balatro_scripts.characters.jimbo.items")
include("Balatro_scripts.Custom_Cards") --jimbo cards effects
include("Balatro_scripts.Synergies")

--include("Balatro_scripts.Trinket_Callbacks")

---------------------CACHE EVALUATION FUNCTIONS---------------------
--------------------------------------------------------------------
--these are all the cache evaluations for every trinekt/item
--the functions for non-statup trinkets are also here
--all the stats given by these trinkets are completely flat and can't be increset with multipliera and such


--include("Balatro_scripts.Trinkets_Effects")
--[[
function Balatro_Expansion:Joker(player, _)

    if player.HasTrinket(player, TrinketType.TRINKET_JOKER) then --controls if it has the trinket
        local JokerDMG = 0.5 --base dmg
        local DMGToAdd = JokerDMG * player.GetTrinketMultiplier(player ,TrinketType.TRINKET_JOKER) --scalable DMG up
        if Balatro_Expansion.WantedEffect == TrinketType.TRINKET_JOKER then
            Balatro_Expansion:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd --flat DMG up
    end
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Balatro_Expansion.Joker, CacheFlag.CACHE_DAMAGE)
]]--


-------------------OPTIMISATION FUNCTOINS------------------------------------
--these functions limit the ammount of callbacks the game has to consider for this mod using REPENTOGON's custom tags,
--i have no idea if this change is actually noticable or not, but i think it's pretty well done

--to see the list of all the custom tags and how they work, see the items.xml file

include("Balatro_scripts.Callback_system")



------------------EID----------------------
-------------------------------------------
include("Balatro_scripts.EID")

-------------MOD CONFIG MENU -------------
------------------------------------------
include("Balatro_scripts.ModConfigMenu")