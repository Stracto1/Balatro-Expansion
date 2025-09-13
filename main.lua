---@diagnostic disable: redundant-parameter

Balatro_Expansion = RegisterMod("Balatro Expansion", 1)


Balatro_Expansion.HOLD_THRESHOLD = 10 --if time is EQUAL OR HIGHER then it's probably holding


local ItemsConfig = Isaac.GetItemConfig()

Balatro_Expansion.Jokers = {}
------------------------------
---@diagnostic disable: inject-field
Balatro_Expansion.Jokers.JOKER = Isaac.GetTrinketIdByName("Joker")
--print(Balatro_Expansion.Jokers.JOKER)

do --all jokers enum
Balatro_Expansion.Jokers.BULL = Isaac.GetTrinketIdByName("Bull")
Balatro_Expansion.Jokers.INVISIBLE_JOKER = Isaac.GetTrinketIdByName("Invisible joker")
Balatro_Expansion.Jokers.ABSTRACT_JOKER = Isaac.GetTrinketIdByName("Abstract joker")
Balatro_Expansion.Jokers.MISPRINT = Isaac.GetTrinketIdByName("Misprint")
Balatro_Expansion.Jokers.JOKER_STENCIL = Isaac.GetTrinketIdByName("Joker stencil")
Balatro_Expansion.Jokers.STONE_JOKER = Isaac.GetTrinketIdByName("Stone joker")
Balatro_Expansion.Jokers.ICECREAM = Isaac.GetTrinketIdByName("Ice cream")
Balatro_Expansion.Jokers.POPCORN = Isaac.GetTrinketIdByName("Popcorn")
Balatro_Expansion.Jokers.RAMEN = Isaac.GetTrinketIdByName("Ramen")
Balatro_Expansion.Jokers.ROCKET = Isaac.GetTrinketIdByName("Rocket")
Balatro_Expansion.Jokers.ODDTODD = Isaac.GetTrinketIdByName("Odd todd")
Balatro_Expansion.Jokers.EVENSTEVEN = Isaac.GetTrinketIdByName("Even steven")
Balatro_Expansion.Jokers.HALLUCINATION = Isaac.GetTrinketIdByName("Hallucination")
Balatro_Expansion.Jokers.GREEN_JOKER = Isaac.GetTrinketIdByName("Green joker")
Balatro_Expansion.Jokers.RED_CARD = Isaac.GetTrinketIdByName("Red card")
Balatro_Expansion.Jokers.VAGABOND = Isaac.GetTrinketIdByName("Vagabond")
Balatro_Expansion.Jokers.RIFF_RAFF = Isaac.GetTrinketIdByName("Riff-raff")
Balatro_Expansion.Jokers.GOLDEN_JOKER = Isaac.GetTrinketIdByName("Golden joker")
Balatro_Expansion.Jokers.FORTUNETELLER = Isaac.GetTrinketIdByName("Fortune Teller")
Balatro_Expansion.Jokers.BLUEPRINT = Isaac.GetTrinketIdByName("Blueprint")
Balatro_Expansion.Jokers.BRAINSTORM = Isaac.GetTrinketIdByName("Brainstorm")
Balatro_Expansion.Jokers.SMEARED_JOKER = Isaac.GetTrinketIdByName("Smeared joker")
Balatro_Expansion.Jokers.MADNESS = Isaac.GetTrinketIdByName("Madness")
Balatro_Expansion.Jokers.MR_BONES = Isaac.GetTrinketIdByName("Mr. Bones")
Balatro_Expansion.Jokers.ONIX_AGATE = Isaac.GetTrinketIdByName("Onyx agate")
Balatro_Expansion.Jokers.ARROWHEAD = Isaac.GetTrinketIdByName("Arrowhead")
Balatro_Expansion.Jokers.BLOODSTONE = Isaac.GetTrinketIdByName("Bloodstone")
Balatro_Expansion.Jokers.ROUGH_GEM = Isaac.GetTrinketIdByName("Rough gem")
Balatro_Expansion.Jokers.GROS_MICHAEL = Isaac.GetTrinketIdByName("Gros Michel")
Balatro_Expansion.Jokers.CAVENDISH = Isaac.GetTrinketIdByName("Cavendish")
Balatro_Expansion.Jokers.FLASH_CARD = Isaac.GetTrinketIdByName("Flash card")
Balatro_Expansion.Jokers.SACRIFICIAL_DAGGER = Isaac.GetTrinketIdByName("Cerimonial dagger")
Balatro_Expansion.Jokers.LOYALTY_CARD = Isaac.GetTrinketIdByName("Loyalty card")
Balatro_Expansion.Jokers.SWASHBUCKLER = Isaac.GetTrinketIdByName("Swashbuckler")
Balatro_Expansion.Jokers.CLOUD_NINE = Isaac.GetTrinketIdByName("Cloud 9")
Balatro_Expansion.Jokers.CARTOMANCER = Isaac.GetTrinketIdByName("Cartomancer")
Balatro_Expansion.Jokers.SUPERNOVA = Isaac.GetTrinketIdByName("Supernova")
Balatro_Expansion.Jokers.DELAYED_GRATIFICATION = Isaac.GetTrinketIdByName("Delayed gratification")
Balatro_Expansion.Jokers.EGG = Isaac.GetTrinketIdByName("Egg")
Balatro_Expansion.Jokers.DNA = Isaac.GetTrinketIdByName("Dna")

Balatro_Expansion.Jokers.CLEVER_JOKER = Isaac.GetTrinketIdByName("Clever Joker")
Balatro_Expansion.Jokers.CRAFTY_JOKER = Isaac.GetTrinketIdByName("Crafty Joker")
Balatro_Expansion.Jokers.CRAZY_JOKER = Isaac.GetTrinketIdByName("Crazy Joker")
Balatro_Expansion.Jokers.DEVIOUS_JOKER = Isaac.GetTrinketIdByName("Devious Joker")
Balatro_Expansion.Jokers.DROLL_JOKER = Isaac.GetTrinketIdByName("Droll Joker")
Balatro_Expansion.Jokers.JOLLY_JOKER = Isaac.GetTrinketIdByName("Jolly Joker")
Balatro_Expansion.Jokers.MAD_JOKER = Isaac.GetTrinketIdByName("Mad Joker")
Balatro_Expansion.Jokers.WILY_JOKER = Isaac.GetTrinketIdByName("Wily Joker")
Balatro_Expansion.Jokers.ZANY_JOKER = Isaac.GetTrinketIdByName("Zany Joker")
Balatro_Expansion.Jokers.SLY_JOKER = Isaac.GetTrinketIdByName("Sly Joker")
Balatro_Expansion.Jokers.LUSTY_JOKER = Isaac.GetTrinketIdByName("Lusty Joker")
Balatro_Expansion.Jokers.WRATHFUL_JOKER = Isaac.GetTrinketIdByName("Wrathful Joker")
Balatro_Expansion.Jokers.GREEDY_JOKER = Isaac.GetTrinketIdByName("Greedy Joker")
Balatro_Expansion.Jokers.GLUTTONOUS_JOKER = Isaac.GetTrinketIdByName("Gluttonous Joker")
Balatro_Expansion.Jokers.MIME = Isaac.GetTrinketIdByName("Mime")
Balatro_Expansion.Jokers.FOUR_FINGER = Isaac.GetTrinketIdByName("Four Fingers")
Balatro_Expansion.Jokers.MERRY_ANDY = Isaac.GetTrinketIdByName("Merry Andy")
Balatro_Expansion.Jokers.HALF_JOKER = Isaac.GetTrinketIdByName("Half Joker")
Balatro_Expansion.Jokers.CREDIT_CARD = Isaac.GetTrinketIdByName("Credit Card")

Balatro_Expansion.Jokers.BANNER = Isaac.GetTrinketIdByName("Banner")
Balatro_Expansion.Jokers.MYSTIC_SUMMIT = Isaac.GetTrinketIdByName("Mystic Summit")
Balatro_Expansion.Jokers.MARBLE_JOKER = Isaac.GetTrinketIdByName("Marble Joker")
Balatro_Expansion.Jokers._8_BALL = Isaac.GetTrinketIdByName("8 Ball")
Balatro_Expansion.Jokers.DUSK = Isaac.GetTrinketIdByName("Dusk")
Balatro_Expansion.Jokers.RAISED_FIST = Isaac.GetTrinketIdByName("Raised Fist")
Balatro_Expansion.Jokers.CHAOS_CLOWN = Isaac.GetTrinketIdByName("Chaos the Clown")
Balatro_Expansion.Jokers.FIBONACCI = Isaac.GetTrinketIdByName("Fibonacci")
Balatro_Expansion.Jokers.STEEL_JOKER = Isaac.GetTrinketIdByName("Steel Joker")
Balatro_Expansion.Jokers.SCARY_FACE = Isaac.GetTrinketIdByName("Scary Face")
Balatro_Expansion.Jokers.HACK = Isaac.GetTrinketIdByName("Hack")
Balatro_Expansion.Jokers.PAREIDOLIA = Isaac.GetTrinketIdByName("Pareidolia")

Balatro_Expansion.Jokers.SCHOLAR = Isaac.GetTrinketIdByName("Scholar")
Balatro_Expansion.Jokers.BUSINESS_CARD = Isaac.GetTrinketIdByName("Business Card")
Balatro_Expansion.Jokers.RIDE_BUS = Isaac.GetTrinketIdByName("Ride the Bus")
Balatro_Expansion.Jokers.SPACE_JOKER = Isaac.GetTrinketIdByName("Space Joker")
Balatro_Expansion.Jokers.BURGLAR = Isaac.GetTrinketIdByName("Burglar")
Balatro_Expansion.Jokers.BLACKBOARD = Isaac.GetTrinketIdByName("Blackboard")
Balatro_Expansion.Jokers.RUNNER = Isaac.GetTrinketIdByName("Runner")
Balatro_Expansion.Jokers.SPLASH = Isaac.GetTrinketIdByName("Splash")
Balatro_Expansion.Jokers.BLUE_JOKER = Isaac.GetTrinketIdByName("Blue Joker")
Balatro_Expansion.Jokers.SIXTH_SENSE = Isaac.GetTrinketIdByName("Sixth Sense")
Balatro_Expansion.Jokers.CONSTELLATION = Isaac.GetTrinketIdByName("Constellation")
Balatro_Expansion.Jokers.HIKER = Isaac.GetTrinketIdByName("Hiker")
Balatro_Expansion.Jokers.FACELESS = Isaac.GetTrinketIdByName("Faceless Joker")
Balatro_Expansion.Jokers.SUPERPOSISION = Isaac.GetTrinketIdByName("Superposition")
Balatro_Expansion.Jokers.TO_DO_LIST = Isaac.GetTrinketIdByName("To Do List")

Balatro_Expansion.Jokers.CARD_SHARP = Isaac.GetTrinketIdByName("Card Sharp")
Balatro_Expansion.Jokers.SQUARE_JOKER = Isaac.GetTrinketIdByName("Square Joker")
Balatro_Expansion.Jokers.SEANCE = Isaac.GetTrinketIdByName("Sèance")
Balatro_Expansion.Jokers.VAMPIRE = Isaac.GetTrinketIdByName("Vampire")
Balatro_Expansion.Jokers.SHORTCUT = Isaac.GetTrinketIdByName("Shortcut")
Balatro_Expansion.Jokers.HOLOGRAM = Isaac.GetTrinketIdByName("Hologram")

Balatro_Expansion.Jokers.BARON = Isaac.GetTrinketIdByName("Baron")
Balatro_Expansion.Jokers.OBELISK = Isaac.GetTrinketIdByName("Obelisk")
Balatro_Expansion.Jokers.MIDAS = Isaac.GetTrinketIdByName("Midas Mask")
Balatro_Expansion.Jokers.LUCHADOR = Isaac.GetTrinketIdByName("Luchador")
Balatro_Expansion.Jokers.PHOTOGRAPH = Isaac.GetTrinketIdByName("Photograph")
Balatro_Expansion.Jokers.GIFT_CARD = Isaac.GetTrinketIdByName("Gift Card")
Balatro_Expansion.Jokers.TURTLE_BEAN = Isaac.GetTrinketIdByName("Turtle Bean")
Balatro_Expansion.Jokers.EROSION = Isaac.GetTrinketIdByName("Erosion")
Balatro_Expansion.Jokers.RESERVED_PARK = Isaac.GetTrinketIdByName("Reserved Parking")

Balatro_Expansion.Jokers.MAIL_REBATE = Isaac.GetTrinketIdByName("Mail-in Rebate")
Balatro_Expansion.Jokers.TO_THE_MOON = Isaac.GetTrinketIdByName("To the Moon")
Balatro_Expansion.Jokers.JUGGLER = Isaac.GetTrinketIdByName("Juggler")
Balatro_Expansion.Jokers.DRUNKARD = Isaac.GetTrinketIdByName("Drunkard")
Balatro_Expansion.Jokers.LUCKY_CAT = Isaac.GetTrinketIdByName("Lucky Cat")
Balatro_Expansion.Jokers.BASEBALL = Isaac.GetTrinketIdByName("Baseball Card")
Balatro_Expansion.Jokers.DIET_COLA = Isaac.GetTrinketIdByName("Diet Cola")

Balatro_Expansion.Jokers.TRADING_CARD = Isaac.GetTrinketIdByName("Trading Card")
Balatro_Expansion.Jokers.SPARE_TROUSERS = Isaac.GetTrinketIdByName("Spare Trousers")
Balatro_Expansion.Jokers.ANCIENT_JOKER = Isaac.GetTrinketIdByName("Ancient Joker")
Balatro_Expansion.Jokers.WALKIE_TALKIE = Isaac.GetTrinketIdByName("Walkie Talkie")
Balatro_Expansion.Jokers.SELTZER = Isaac.GetTrinketIdByName("Seltz")
Balatro_Expansion.Jokers.SMILEY_FACE = Isaac.GetTrinketIdByName("Smiley Face")
Balatro_Expansion.Jokers.CAMPFIRE = Isaac.GetTrinketIdByName("Campfire")

Balatro_Expansion.Jokers.CASTLE = Isaac.GetTrinketIdByName("Castle")
Balatro_Expansion.Jokers.GOLDEN_TICKET = Isaac.GetTrinketIdByName("Golden Ticket")
Balatro_Expansion.Jokers.ACROBAT = Isaac.GetTrinketIdByName("Acrobat")
Balatro_Expansion.Jokers.SOCK_BUSKIN = Isaac.GetTrinketIdByName("Sock and Buskin")
Balatro_Expansion.Jokers.TROUBADOR = Isaac.GetTrinketIdByName("Troubador")
Balatro_Expansion.Jokers.CERTIFICATE = Isaac.GetTrinketIdByName("Certificate")
Balatro_Expansion.Jokers.THROWBACK = Isaac.GetTrinketIdByName("Throwback")
Balatro_Expansion.Jokers.HANG_CHAD = Isaac.GetTrinketIdByName("Hanging Chad")
Balatro_Expansion.Jokers.GLASS_JOKER = Isaac.GetTrinketIdByName("Glass Joker")
Balatro_Expansion.Jokers.SHOWMAN = Isaac.GetTrinketIdByName("Showman")
Balatro_Expansion.Jokers.FLOWER_POT = Isaac.GetTrinketIdByName("Flower Pot")
Balatro_Expansion.Jokers.WEE_JOKER = Isaac.GetTrinketIdByName("Wee Joker")

Balatro_Expansion.Jokers.OOPS_6 = Isaac.GetTrinketIdByName("Oops! All 6s")
Balatro_Expansion.Jokers.IDOL = Isaac.GetTrinketIdByName("The Idol")
Balatro_Expansion.Jokers.SEE_DOUBLE = Isaac.GetTrinketIdByName("Seeing Double")
Balatro_Expansion.Jokers.MATADOR = Isaac.GetTrinketIdByName("Matador")
Balatro_Expansion.Jokers.HIT_ROAD = Isaac.GetTrinketIdByName("Hit the Road")
Balatro_Expansion.Jokers.DUO = Isaac.GetTrinketIdByName("The Duo")
Balatro_Expansion.Jokers.TRIO = Isaac.GetTrinketIdByName("The Trio")
Balatro_Expansion.Jokers.FAMILY = Isaac.GetTrinketIdByName("The Family")
Balatro_Expansion.Jokers.ORDER = Isaac.GetTrinketIdByName("The Order")
Balatro_Expansion.Jokers.TRIBE = Isaac.GetTrinketIdByName("The Tribe")

Balatro_Expansion.Jokers.STUNTMAN = Isaac.GetTrinketIdByName("Stuntman")
Balatro_Expansion.Jokers.SATELLITE = Isaac.GetTrinketIdByName("Satellite")
Balatro_Expansion.Jokers.SHOOT_MOON = Isaac.GetTrinketIdByName("Shoot the Moon")
Balatro_Expansion.Jokers.DRIVER_LICENSE = Isaac.GetTrinketIdByName("Driver's License")
Balatro_Expansion.Jokers.ASTRONOMER = Isaac.GetTrinketIdByName("Astronomer")
Balatro_Expansion.Jokers.BURNT_JOKER = Isaac.GetTrinketIdByName("Burnt Joker")
Balatro_Expansion.Jokers.BOOTSTRAP = Isaac.GetTrinketIdByName("Bootstraps")
Balatro_Expansion.Jokers.CANIO = Isaac.GetTrinketIdByName("Canio")
Balatro_Expansion.Jokers.TRIBOULET = Isaac.GetTrinketIdByName("Triboulet")
Balatro_Expansion.Jokers.YORICK = Isaac.GetTrinketIdByName("Yorick")
Balatro_Expansion.Jokers.CHICOT = Isaac.GetTrinketIdByName("Chicot")
Balatro_Expansion.Jokers.PERKEO = Isaac.GetTrinketIdByName("Perkeo")
Balatro_Expansion.Jokers.CHAOS_THEORY = Isaac.GetTrinketIdByName("Chaos Theory")

end


Balatro_Expansion.Trinkets = {} 
Balatro_Expansion.Trinkets.common = {} --rarities used for spawn weight and stuff
Balatro_Expansion.Trinkets.uncommon = {}
Balatro_Expansion.Trinkets.rare = {}
Balatro_Expansion.Trinkets.legendary = {}

Balatro_Expansion.Trinkets.TASTY_CANDY = {}
Balatro_Expansion.TastyCandyNum = 5
for i = 1, Balatro_Expansion.TastyCandyNum do --puts every candy stage
    Balatro_Expansion.Trinkets.TASTY_CANDY[i] = Balatro_Expansion.Jokers.PERKEO + i
end
Balatro_Expansion.Trinkets.PENNY_SEEDS = Isaac.GetTrinketIdByName("Penny Seeds")

Balatro_Expansion.INFINITE_HANDS = -1

Balatro_Expansion.Callbalcks = {CARD_SHOT = "CARD_SHOT",
                                CARD_HIT = "CARD_HIT",
                                DISCARD = "HAND_DISCARD",
                                DAMAGE_TAKEN = "TJIMBO_DAMAGE_TAKEN",
                                CARD_DISCARD = "CARD_DISCARD",
                                POST_DISCARD = "POST_HAND_DISCARD",
                                JOKER_SOLD = "JOKER_SOLD",
                                JOKER_REMOVED = "JOKER_REMOVED",
                                CONSUMABLE_SOLD = "CONSUMABLE_SOLD",
                                CONSUMABLE_USE = "CONSUMABLE_USED",
                                BLIND_CLEAR = "BLIND_CLEARED",
                                POST_BLIND_CLEAR = "POST_BLIND_CLEARED",
                                SHOP_REROLL = "BALATRO_SHOP_REROLL",
                                SHOP_EXIT = "BALATRO_SHOP_END",
                                CASHOUT_EVAL = "CASHOUT_EVALUATION",
                                BOSS_BLIND_EVAL = "BOSS_BLIND_EFFECT_EVALUATION",
                                BLIND_SELECTED = "BLIND_SELECTED",
                                BLIND_START = "BLIND_STARTED",
                                POST_BLIND_START = "POST_BLIND_STARTED",
                                POST_SKIP_TAG_ADDED = "POST_SKIP_TAG_ADDED",
                                BLIND_SKIP = "BLIND_SKIPPED",
                                PACK_OPEN = "PACK_OPENED",
                                PACK_SKIP = "PACK_SKIPPED",
                                TRUE_CLEAR = "TRUE_ROOM_CLEAR",
                                INVENTORY_CHANGE = "INVENTORY_CHANGE",
                                JOKER_ADDED = "JOKER_ADDED",
                                DECK_SHIFT = "DECK_SHIFT",
                                DECK_MODIFY = "DECK_MODIFY",
                                PRE_HAND_PLAY = "PRE_HAND_PLAYED",
                                HAND_PLAY = "HAND_PLAYED",
                                POST_HAND_PLAY = "POST_HAND_PLAYED",
                                HAND_UPDATE = "HAND_TYPE_UPDATE",
                                BALATRO_PLATE_PRESSED = "BALATRO_PLATE_PRESSED",}


Balatro_Expansion.ScreenStrings = {Warning = {}, --{Name, String, StartFrame, Type}
                                   CashOut = {}} --{Name, String, StartFrame, Type}

Balatro_Expansion.StringTypes = {Hand = -1,
                                 General = -2,
                                 Interest = -3,
                                 Joker = -4}

Balatro_Expansion.HandOrderingModes = {Rank = 1,
                                       Suit = 2}

Balatro_Expansion.RunInfoModes = {OFF = 1,
                                  PARTIAL_DECK = 2,
                                  FULL_DECK = 3,
                                  BLINDS = 4,
                                  POKER_HANDS = 5}

Balatro_Expansion.JokerTypes = {}
Balatro_Expansion.JokerTypes.ECON = "money"
Balatro_Expansion.JokerTypes.MULT = "mult"
Balatro_Expansion.JokerTypes.XMULT = "multm"
Balatro_Expansion.JokerTypes.CHIPS = "chips"
Balatro_Expansion.JokerTypes.EFFECT = "activate"

Balatro_Expansion.Collectibles = {} --rarities used for spawn weight and stuff
Balatro_Expansion.Collectibles.HORSEY = Isaac.GetItemIdByName("Horsey")
Balatro_Expansion.Collectibles.CRAYONS = Isaac.GetItemIdByName("Box of Crayons")
Balatro_Expansion.Collectibles.BANANA = Isaac.GetItemIdByName("Banana")
Balatro_Expansion.Collectibles.EMPTY_BANANA = Isaac.GetItemIdByName("Empty Banana")
Balatro_Expansion.Collectibles.BALOON_PUPPY = Isaac.GetItemIdByName("Baloon Puppy")
Balatro_Expansion.Collectibles.LAUGH_SIGN = Isaac.GetItemIdByName("Laugh Sign")
Balatro_Expansion.Collectibles.CLOWN = Isaac.GetItemIdByName("Clown Costume")
Balatro_Expansion.Collectibles.POCKET_ACES = Isaac.GetItemIdByName("Pocket Aces")
Balatro_Expansion.Collectibles.TRAGICOMEDY = Isaac.GetItemIdByName("Tragicomedy")
Balatro_Expansion.Collectibles.UMBRELLA = Isaac.GetItemIdByName("Umbrella")
Balatro_Expansion.Collectibles.OPENED_UMBRELLA = Isaac.GetItemIdByName("Opened Umbrella")
Balatro_Expansion.Collectibles.LOLLYPOP = Isaac.GetItemIdByName("Lollypop")
Balatro_Expansion.Collectibles.FUNNY_TEETH = Isaac.GetItemIdByName("Funny Teeth")
Balatro_Expansion.Collectibles.PLANET_X = Isaac.GetItemIdByName("Planet X")
Balatro_Expansion.Collectibles.CERES = Isaac.GetItemIdByName("Ceres")
Balatro_Expansion.Collectibles.ERIS = Isaac.GetItemIdByName("Eris")
Balatro_Expansion.Collectibles.HEIRLOOM = Isaac.GetItemIdByName("Heirloom")
Balatro_Expansion.Collectibles.THE_HAND = Isaac.GetItemIdByName("The hand")




Balatro_Expansion.Familiars = {}
Balatro_Expansion.Familiars.HORSEY = Isaac.GetEntityVariantByName("Horsey")
Balatro_Expansion.Familiars.BLOON_PUPPY = Isaac.GetEntityVariantByName("Baloon Puppy")
Balatro_Expansion.Familiars.TEETH = Isaac.GetEntityVariantByName("Funny Teeth")
Balatro_Expansion.Familiars.CERES = Isaac.GetEntityVariantByName("Planet Ceres")



Balatro_Expansion.Effects = {}
Balatro_Expansion.Effects.CRAYON_POWDER = Isaac.GetEntityVariantByName("Crayon Powder")
Balatro_Expansion.Effects.BANANA_PEEL = Isaac.GetEntityVariantByName("Banana Peel")
Balatro_Expansion.Effects.TOMATO = Isaac.GetEntityVariantByName("Thrown Tomato")
Balatro_Expansion.Effects.ANVIL = Isaac.GetEntityVariantByName("Falling Anvil")
Balatro_Expansion.Effects.UMBRELLA = Isaac.GetEntityVariantByName("Player Umbrella")
Balatro_Expansion.Effects.HAND_SWING = Isaac.GetEntityVariantByName("The Hand Swing")
Balatro_Expansion.Effects.HEIRLOOM_TRIGGER = Isaac.GetEntityVariantByName("Heirloom Upgrade")
Balatro_Expansion.Effects.JIMBO_THE_KILLER = {VARIANT = Isaac.GetEntityVariantByName("Jimbo the Killer"),
                                              SUBTYPE = {PLAYERS = 1,
                                                         ENEMIES = 2}} --used to hide some character design flaws ;)

Balatro_Expansion.Effects.DIALOG_BUBBLE = Isaac.GetEntityVariantByName("Blind Cashout Bubble")

Balatro_Expansion.DialogBubbleSubType = {CASHOUT = Isaac.GetEntitySubTypeByName("Blind Cashout Bubble"),
                                         BLIND_INFO = Isaac.GetEntitySubTypeByName("Blind Info Bubble"),
                                         REROLL_PRICE = Isaac.GetEntitySubTypeByName("Reroll Price Bubble"),
                                         }




Balatro_Expansion.Pickups = {}
Balatro_Expansion.Pickups.LOLLYPOP = Isaac.GetEntityVariantByName("Base Lollypop")
Balatro_Expansion.Pickups.PLAYING_CARD = Isaac.GetEntityVariantByName("Balatro Playing Card")


Balatro_Expansion.Entities = {}
Balatro_Expansion.Entities.BALATRO_TYPE = Isaac.GetEntityTypeByName("Pathfinder Slave")
Balatro_Expansion.Entities.PATH_SLAVE = Isaac.GetEntityVariantByName("Pathfinder Slave")
--Balatro_Expansion.Entities.SHOP_MIMIC = Isaac.GetEntityVariantByName("Shop Mimic")

Balatro_Expansion.Grids = {}
Balatro_Expansion.Grids.PlateVariant = {BLIND = 146,
                                        CASHOUT = 147,
                                        REROLL = 148,
                                        SHOP_EXIT = 149,
                                        SMALL_BLIND_SKIP = 150,
                                        BIG_BLIND_SKIP = 151,
                                        BOSS_BLIND_SKIP = 152} --only usen on last floor of ascent


Balatro_Expansion.Grids.PLATE_ANM2_PATH = "gfx/grid/grid_balatro_pressureplate.anm2"


for i, Joker in pairs(Balatro_Expansion.Jokers) do
    local Rarity = string.gsub(ItemsConfig:GetTrinket(Joker):GetCustomTags()[4],"%?","")

    Balatro_Expansion.Trinkets[Rarity][#Balatro_Expansion.Trinkets[Rarity] + 1] = Joker
end


--------------------------------
--CollectibleType.COLLECTIBLE_THE_HAND = Isaac.GetItemIdByName("The hand")
----------------------------------
------------------------


--Balatro_Expansion.SPECIAL_BOSSES = {BossType.MOTHER, BossType.MEGA_SATAN, BossType.HUSH, BossType.DELIRIUM, BossType.BEAST, BossType.DOGMA}

Balatro_Expansion.Characters = {}
Balatro_Expansion.Characters.JimboType = Isaac.GetPlayerTypeByName("Jimbo", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
Balatro_Expansion.Characters.TaintedJimbo = Isaac.GetPlayerTypeByName("Jimbo", true)

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
Balatro_Expansion.Sounds.DEBUFFED = Isaac.GetSoundIdByName("HONKSFX")

Balatro_Expansion.Sounds.SLIP = Isaac.GetSoundIdByName("SLIPSFX")
Balatro_Expansion.Sounds.LAUGH = Isaac.GetSoundIdByName("LAUGHSFX")
Balatro_Expansion.Sounds.APPLAUSE = Isaac.GetSoundIdByName("APPLAUSESFX")
Balatro_Expansion.Sounds.BOO = Isaac.GetSoundIdByName("BOOSFX")
Balatro_Expansion.Sounds.GASP = Isaac.GetSoundIdByName("GASPSFX")
Balatro_Expansion.Sounds.RANDOM_CROWD = Isaac.GetSoundIdByName("CROWDRANDOMSFX")
Balatro_Expansion.Sounds.CROWD_TRANSITION = Isaac.GetSoundIdByName("TRANSITIONCROWDSFX")
Balatro_Expansion.Sounds.CLOWN_HONK = Isaac.GetSoundIdByName("HONKSFX")
Balatro_Expansion.Sounds.EAT = Isaac.GetSoundIdByName("EATSFX")


Balatro_Expansion.BalatroColorBlack = Color(41/255, 51/255, 53/255, 1)
Balatro_Expansion.EffectColors = {}
Balatro_Expansion.EffectColors.RED = Color(238/255, 49/255, 66/255)
Balatro_Expansion.EffectColors.BLUE = Color(49/255, 140/255, 238/255)
Balatro_Expansion.EffectColors.YELLOW = Color(238/255, 186/255, 49/255)
Balatro_Expansion.EffectColors.PURPLE = Color(238/255, 186/255, 49/255)
Balatro_Expansion.EffectColors.GREEN = Color(55/255, 194/255, 14/255)

Balatro_Expansion.BalatroKColorBlack = KColor(41/255, 51/255, 53/255, 1)
Balatro_Expansion.EffectKColors = {}
Balatro_Expansion.EffectKColors.RED = KColor(238/255, 49/255, 66/255, 1)
Balatro_Expansion.EffectKColors.BLUE = KColor(49/255, 140/255, 238/255, 1)
Balatro_Expansion.EffectKColors.YELLOW = KColor(238/255, 186/255, 49/255, 1)
Balatro_Expansion.EffectKColors.PURPLE = KColor(238/255, 186/255, 49/255, 1)--PLACEHOLDER
Balatro_Expansion.EffectKColors.GREEN = KColor(55/255, 194/255, 14/255, 1)

Balatro_Expansion.EffectType = {NULL = -1,
                                JOKER = -2,
                                HAND = -3,
                                CONSUMABLE = -4,
                                ENTITY = -5,
                                HAND_FROM_JOKER = 0}



Balatro_Expansion.Packs = {}
Balatro_Expansion.Packs.ARCANA =  Isaac.GetCardIdByName("Tarot_Pack") --base
Balatro_Expansion.Packs.JUMBO_ARCANA =  Isaac.GetCardIdByName("Jumbo_Tarot_Pack")
Balatro_Expansion.Packs.MEGA_ARCANA =  Isaac.GetCardIdByName("Mega_Tarot_Pack")
Balatro_Expansion.Packs.CELESTIAL = Isaac.GetCardIdByName("Planet_Pack") --base
Balatro_Expansion.Packs.JUMBO_CELESTIAL = Isaac.GetCardIdByName("Jumbo_Planet_Pack")
Balatro_Expansion.Packs.MEGA_CELESTIAL = Isaac.GetCardIdByName("Mega_Planet_Pack")
Balatro_Expansion.Packs.BUFFON  =  Isaac.GetCardIdByName("Buffon_Pack") --base
Balatro_Expansion.Packs.JUMBO_BUFFON  =  Isaac.GetCardIdByName("Jumbo_Buffon_Pack")
Balatro_Expansion.Packs.MEGA_BUFFON  =  Isaac.GetCardIdByName("Mega_Buffon_Pack")
Balatro_Expansion.Packs.SPECTRAL =  Isaac.GetCardIdByName("Spectral_Pack") --base
Balatro_Expansion.Packs.JUMBO_SPECTRAL =  Isaac.GetCardIdByName("Jumbo_Spectral_Pack")
Balatro_Expansion.Packs.MEGA_SPECTRAL =  Isaac.GetCardIdByName("Mega_Spectral_Pack")
Balatro_Expansion.Packs.STANDARD = Isaac.GetCardIdByName("Standard_Pack") --base
Balatro_Expansion.Packs.JUMBO_STANDARD = Isaac.GetCardIdByName("Jumbo_Standard_Pack")
Balatro_Expansion.Packs.MEGA_STANDARD = Isaac.GetCardIdByName("Mega_Standard_Pack")

Balatro_Expansion.PackQualityModule = {BASE = Balatro_Expansion.Packs.ARCANA % 3,
                                       JUMBO = Balatro_Expansion.Packs.JUMBO_ARCANA % 3,
                                       MEGA = Balatro_Expansion.Packs.MEGA_ARCANA % 3}

Balatro_Expansion.PackQuality = {} --these get summed to the base variants above to also specify the quality
Balatro_Expansion.PackQuality.BASE =  0
Balatro_Expansion.PackQuality.JUMBO = 1
Balatro_Expansion.PackQuality.MEGA  =  2


Balatro_Expansion.Planets = {}
Balatro_Expansion.Planets.PLUTO =  Isaac.GetCardIdByName("Not_So_Planet_Pluto")
Balatro_Expansion.Planets.MERCURY = Isaac.GetCardIdByName("Planet_Mercury")
Balatro_Expansion.Planets.URANUS = Isaac.GetCardIdByName("Planet_Uranus")
Balatro_Expansion.Planets.VENUS =  Isaac.GetCardIdByName("Planet_Venus")
Balatro_Expansion.Planets.SATURN = Isaac.GetCardIdByName("Planet_Saturn")
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


Balatro_Expansion.Vouchers = {}
Balatro_Expansion.Vouchers.Grabber = Isaac.GetItemIdByName("Grabber")
Balatro_Expansion.Vouchers.NachoTong = Isaac.GetItemIdByName("Nacho Tong")
Balatro_Expansion.Vouchers.Overstock = Isaac.GetItemIdByName("Overstock")
Balatro_Expansion.Vouchers.OverstockPlus = Isaac.GetItemIdByName("Overstock Plus")
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
Balatro_Expansion.Suits.ALL = 5

Balatro_Expansion.Values = {}
Balatro_Expansion.Values.JACK = 11
Balatro_Expansion.Values.QUEEN = 12
Balatro_Expansion.Values.KING = 13
Balatro_Expansion.Values.FACE = 14

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

Balatro_Expansion.EDITION_FLAG_SHIFT = 16
Balatro_Expansion.EditionFlag = {[Balatro_Expansion.Edition.BASE] = 0,
                                 [Balatro_Expansion.Edition.FOIL] = Balatro_Expansion.Edition.FOIL << 16,
                                 [Balatro_Expansion.Edition.HOLOGRAPHIC] = Balatro_Expansion.Edition.HOLOGRAPHIC << 16,
                                 [Balatro_Expansion.Edition.POLYCROME] = Balatro_Expansion.Edition.POLYCROME << 16,
                                 [Balatro_Expansion.Edition.NEGATIVE] = Balatro_Expansion.Edition.NEGATIVE << 16,
                                 ALL = 7 << 16}



Balatro_Expansion.Modifier = {DEBUFFED = 1 << 0,
                              COVERED = 1 << 1}

Balatro_Expansion.EditionShaders ={
    "shaders/Foil_effect",
    "shaders/Holographic_effect",
    "shaders/Polychrome_effect",
    "shaders/Negative_effect_test",
    DEBUFF = "shaders/Debuff_modifier"
}
Balatro_Expansion.EditionShaders[Balatro_Expansion.Edition.BASE] = "shaders/Nothing" --prevents extra if statements on render


Balatro_Expansion.Rarities = {}
Balatro_Expansion.Rarities.common = 1
Balatro_Expansion.Rarities.uncommon = 2
Balatro_Expansion.Rarities.rare = 3
Balatro_Expansion.Rarities.legendary = 4

Balatro_Expansion.HandTypes = {}
Balatro_Expansion.HandTypes.NONE = 1
Balatro_Expansion.HandTypes.HIGH_CARD = 2
Balatro_Expansion.HandTypes.PAIR = 3
Balatro_Expansion.HandTypes.TWO_PAIR = 4
Balatro_Expansion.HandTypes.THREE = 5
Balatro_Expansion.HandTypes.STRAIGHT = 6
Balatro_Expansion.HandTypes.FLUSH = 7
Balatro_Expansion.HandTypes.FULL_HOUSE = 8
Balatro_Expansion.HandTypes.FOUR = 9
Balatro_Expansion.HandTypes.STRAIGHT_FLUSH = 10
Balatro_Expansion.HandTypes.FIVE = 11
Balatro_Expansion.HandTypes.FLUSH_HOUSE = 12
Balatro_Expansion.HandTypes.FIVE_FLUSH = 13
Balatro_Expansion.HandTypes.ROYAL_FLUSH = 14

Balatro_Expansion.HandFlags = {}
Balatro_Expansion.HandFlags.NONE = 1 << 1
Balatro_Expansion.HandFlags.HIGH_CARD = 1 << 2
Balatro_Expansion.HandFlags.PAIR = 1 << 3
Balatro_Expansion.HandFlags.TWO_PAIR = 1 << 4
Balatro_Expansion.HandFlags.THREE = 1 << 5
Balatro_Expansion.HandFlags.STRAIGHT = 1 << 6
Balatro_Expansion.HandFlags.FLUSH = 1 << 7
Balatro_Expansion.HandFlags.FULL_HOUSE = 1 << 8
Balatro_Expansion.HandFlags.FOUR = 1 << 9
Balatro_Expansion.HandFlags.STRAIGHT_FLUSH = 1 << 10
Balatro_Expansion.HandFlags.FIVE = 1 << 11
Balatro_Expansion.HandFlags.FLUSH_HOUSE = 1 << 12
Balatro_Expansion.HandFlags.FIVE_FLUSH = 1 << 13
Balatro_Expansion.HandFlags.ROYAL_FLUSH = 1 << 14
--Balatro_Expansion.HandTypes.NUM_HANDS = 12


Balatro_Expansion.Tears = {}
Balatro_Expansion.Tears.CARD_TEAR_VARIANT = Isaac.GetEntityVariantByName("Tear Card")   

Balatro_Expansion.Tears.SUIT_TEAR_VARIANTS = {Isaac.GetEntityVariantByName("Tear Spade Suit"),
                                                Isaac.GetEntityVariantByName("Tear Heart Suit"),
                                                Isaac.GetEntityVariantByName("Tear Club Suit"),
                                                Isaac.GetEntityVariantByName("Tear Diamond Suit")}
Balatro_Expansion.Tears.BANANA_VARIANT = Isaac.GetEntityVariantByName("Tear Banana")




---
Balatro_Expansion.Challenges = {}
Balatro_Expansion.Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
---
Balatro_Expansion.AllCurses = {}
Balatro_Expansion.NormalCurses = {}
Balatro_Expansion.BossCurses = {}

Balatro_Expansion.AllCurses.THE_WALL = 1 << (Isaac.GetCurseIdByName("curse of the wall") - 1)

Balatro_Expansion.NormalCurses[1] = Balatro_Expansion.AllCurses.THE_WALL

Balatro_Expansion.BLINDS = {WAITING_CASHOUT = 8192,
                            SHOP = 2048,
                            NONE = 4096,
                            SMALL = 1,
                            BIG = 2,
                            BOSS = 4, --used as a flag along with a specific boss type
                            BOSS_HOOK = 12,
                            BOSS_OX = 20,
                            BOSS_HOUSE = 28,
                            BOSS_WALL = 36,
                            BOSS_WHEEL = 44,
                            BOSS_ARM = 52,
                            BOSS_CLUB = 60,
                            BOSS_FISH = 68,
                            BOSS_PSYCHIC = 76,
                            BOSS_GOAD = 84,
                            BOSS_WATER = 92,
                            BOSS_WINDOW = 100,
                            BOSS_MANACLE = 108,
                            BOSS_EYE = 116,
                            BOSS_MOUTH = 124,
                            BOSS_PLANT = 132,
                            BOSS_SERPENT = 140,
                            BOSS_PILLAR = 148,
                            BOSS_NEEDLE = 156,
                            BOSS_HEAD = 164,
                            BOSS_TOOTH = 172,
                            BOSS_FLINT = 180,
                            BOSS_MARK = 188,
                            BOSS_LAMB = 196,
                            BOSS_MOTHER = 204,
                            BOSS_DELIRIUM = 212,
                            BOSS_BEAST = 220,
                            BOSS_ACORN = 228,--keep this the lowest finisher blind
                            BOSS_LEAF = 236,
                            BOSS_HEART = 244,
                            BOSS_VESSEL = 252,
                            BOSS_BELL = 260}


Balatro_Expansion.SkipTags = {UNCOMMON = 0,
                              RARE = 1,
                              NEGATIVE = 2,
                              FOIL = 3,
                              HOLO = 4,
                              POLYCHROME = 5,
                              INVESTMENT = 6,
                              VOUCHER = 7,
                              BOSS = 8,
                              STANDARD = 9,
                              CHARM = 10,
                              METEOR = 11,
                              BUFFON = 12,
                              HANDY = 13,
                              GARBAGE = 14,
                              ETHEREAL = 15,
                              COUPON = 16,
                              DOUBLE = 17,
                              JUGGLE = 18,
                              D6 = 19,
                              TOP_UP = 20,
                              SPEED = 21,
                              ECONOMY = 22,
                              ORBITAL = 32} --USED WITH A HAND FLAG 

Balatro_Expansion.SpecialSkipTags = {KEY_PIECE_1 = 23,
                                     KEY_PIECE_2 = 24,
                                     ANTE = 25}



Balatro_Expansion.CustomCache = {}
Balatro_Expansion.CustomCache.HAND_SIZE = "handsize"
Balatro_Expansion.CustomCache.HAND_COOLDOWN = "playcd"
Balatro_Expansion.CustomCache.DISCARD_NUM = "discards"
Balatro_Expansion.CustomCache.INVENTORY_SIZE = "inventory"
Balatro_Expansion.CustomCache.HAND_NUM = "hands"

---------------------------------
Balatro_Expansion.CardFullPoss = {}
Balatro_Expansion.JokerFullPosition = {} --used to save where a certain joker is when using T jimbo
Balatro_Expansion.ConsumableFullPosition = {}
Balatro_Expansion.PackOptionFullPosition = {}

Balatro_Expansion.StringRenderingParams = {Swoosh = 1,--appears slowly (30 chars per second)
                                           Wavy = 2, --sine wave 
                                           Peaking = 4, --single letters peaking on top
                                           Wrap = 8, --goes new line when needed (BoxWidth is necessary!)
                                           Centered = 16, --centers the text
                                           Enlarge = 32, --enlarges chars starting from the first (alligned with swoosh)
                                           RightAllinged = 64, --allignaes to tthe right
                                           EID = 128 --also includes wrap, but doesn't center the lines height wise
                                           }

Balatro_Expansion.Fonts = {}
do

local loaded
Balatro_Expansion.Fonts.Balatro, loaded = Font("mods/balatro_expansion/resources/font/Balatro_Font4.fnt")

if not loaded then
    Balatro_Expansion.Fonts.Balatro:Load("mods/balatro_expansion_3308293502/resources/font/Balatro_Font4.fnt")
end


Balatro_Expansion.Fonts.Balatro_Small, loaded = Font("mods/balatro_expansion/resources/font/Balatro_Font3.fnt")

if not loaded then
    Balatro_Expansion.Fonts.Balatro_Small:Load("mods/balatro_expansion_3308293502/resources/font/Balatro_Font3.fnt")
end

---print(Balatro_Expansion.Fonts.Balatro:GetLineHeight(), Balatro_Expansion.Fonts.Balatro:GetBaselineHeight())


end
---@diagnostic disable-next-line: redundant-parameter
Balatro_Expansion.Fonts.pftempest = Font("font/pftempestasevencondensed.fnt")

---------------------
local Game = Game()
Balatro_Expansion.GameStarted = false
--local HUD = Game:GetHUD()

Balatro_Expansion.RNGs = {SHOP = RNG(), VOUCHERS = RNG(), LUCKY_CARD = RNG(), BOSS_BLINDS = RNG(), SKIP_TAGS = RNG(), PURPLE_SEAL = RNG(),}

Balatro_Expansion.Saved = {} --every value that needs to be stored between game starts
-------------------------------
--this right here is a relic of the first ever design this mod had (sucked so much ass ngl)
--Balatro_Expansion.Saved.TrinketValues = {} --contains the "progress" for every trinket that needs it


Balatro_Expansion.Saved.Pools = {}
Balatro_Expansion.Saved.Pools.Vouchers = { Balatro_Expansion.Vouchers.Grabber,
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

Balatro_Expansion.Saved.Pools.BossBlinds = { Balatro_Expansion.BLINDS.BOSS_HOOK,
                                             Balatro_Expansion.BLINDS.BOSS_CLUB,
                                             Balatro_Expansion.BLINDS.BOSS_PSYCHIC,
                                             Balatro_Expansion.BLINDS.BOSS_GOAD,
                                             Balatro_Expansion.BLINDS.BOSS_WINDOW,
                                             Balatro_Expansion.BLINDS.BOSS_MANACLE,
                                             Balatro_Expansion.BLINDS.BOSS_PILLAR,
                                             Balatro_Expansion.BLINDS.BOSS_HEAD,
                                             }

Balatro_Expansion.Saved.Pools.SpecialBossBlinds = { Balatro_Expansion.BLINDS.BOSS_HEART,
                                                    Balatro_Expansion.BLINDS.BOSS_BELL,
                                                    Balatro_Expansion.BLINDS.BOSS_VESSEL,
                                                    Balatro_Expansion.BLINDS.BOSS_ACORN,
                                                    Balatro_Expansion.BLINDS.BOSS_LEAF,
                                                    }

Balatro_Expansion.Saved.NumJuggleUsed = 0 --used to keep in memory the hand size change through multiple shuffles
Balatro_Expansion.Saved.Pools.SkipTags = {  Balatro_Expansion.SkipTags.UNCOMMON,
                                            Balatro_Expansion.SkipTags.RARE,
                                            Balatro_Expansion.SkipTags.FOIL,
                                            Balatro_Expansion.SkipTags.HOLO,
                                            Balatro_Expansion.SkipTags.POLYCHROME,
                                            Balatro_Expansion.SkipTags.INVESTMENT,
                                            Balatro_Expansion.SkipTags.VOUCHER,
                                            Balatro_Expansion.SkipTags.BOSS,
                                            Balatro_Expansion.SkipTags.CHARM,
                                            Balatro_Expansion.SkipTags.COUPON,
                                            Balatro_Expansion.SkipTags.DOUBLE,
                                            Balatro_Expansion.SkipTags.JUGGLE,
                                            Balatro_Expansion.SkipTags.D6,
                                            Balatro_Expansion.SkipTags.SPEED,
                                            Balatro_Expansion.SkipTags.ECONOMY,                                            
                                           }

Balatro_Expansion.Saved.FloorSkippedSpecials = 0
Balatro_Expansion.Saved.RunSkippedSpecials = 0
Balatro_Expansion.Saved.GlassBroken = 0
Balatro_Expansion.Saved.TarotsUsed = 0
Balatro_Expansion.Saved.PlanetTypesUsed = 0
Balatro_Expansion.Saved.BlindBeingPlayed = Balatro_Expansion.BLINDS.NONE
Balatro_Expansion.Saved.CurrentBlindName = ""
Balatro_Expansion.Saved.CurrentBlindReward = 0
Balatro_Expansion.Saved.CurrentRound = 0
Balatro_Expansion.Saved.BossBlindVarData = 0

Balatro_Expansion.Saved.HandOrderingMode = Balatro_Expansion.HandOrderingModes.Rank
Balatro_Expansion.Saved.RunInfoMode = Balatro_Expansion.RunInfoModes.OFF

Balatro_Expansion.Saved.AnteVoucher = 0
Balatro_Expansion.Saved.NumBossRerolls = 0
Balatro_Expansion.Saved.AnteCardsPlayed = {}
Balatro_Expansion.Saved.NumShopRerolls = 0
Balatro_Expansion.Saved.RerollStartingPrice = 5
Balatro_Expansion.Saved.NumBlindsSkipped = 0


Balatro_Expansion.Saved.SkipTags = {}

Balatro_Expansion.Saved.HandsRemaining = 4
Balatro_Expansion.Saved.DiscardsRemaining = 4
Balatro_Expansion.Saved.HandsUsed = 0
Balatro_Expansion.Saved.DiscardsWasted = 0

Balatro_Expansion.Saved.MultValue = 0
Balatro_Expansion.Saved.ChipsValue = 0
Balatro_Expansion.Saved.TotalScore = 0

Balatro_Expansion.Saved.HandType = 0
Balatro_Expansion.Saved.PossibleHandTypes = 0


Balatro_Expansion.Saved.HandLevels = {[Balatro_Expansion.HandTypes.NONE] = 1,
                                      [Balatro_Expansion.HandTypes.HIGH_CARD] = 1,
                                      [Balatro_Expansion.HandTypes.PAIR] = 1,
                                      [Balatro_Expansion.HandTypes.TWO_PAIR] = 1,
                                      [Balatro_Expansion.HandTypes.THREE] = 1,
                                      [Balatro_Expansion.HandTypes.STRAIGHT] = 1,
                                      [Balatro_Expansion.HandTypes.FLUSH] = 1,
                                      [Balatro_Expansion.HandTypes.FULL_HOUSE] = 1,
                                      [Balatro_Expansion.HandTypes.FOUR] = 1,
                                      [Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = 1,
                                      [Balatro_Expansion.HandTypes.ROYAL_FLUSH] = 1,
                                      [Balatro_Expansion.HandTypes.FIVE] = 1,
                                      [Balatro_Expansion.HandTypes.FLUSH_HOUSE] = 1,
                                      [Balatro_Expansion.HandTypes.FIVE_FLUSH] = 1}

Balatro_Expansion.Saved.HandsStat = {[Balatro_Expansion.HandTypes.NONE] =    {Chips = 0, Mult = 0},
                                     [Balatro_Expansion.HandTypes.HIGH_CARD] = {Chips = 5, Mult = 1},
                                     [Balatro_Expansion.HandTypes.PAIR] =    {Chips = 10, Mult = 2},
                                     [Balatro_Expansion.HandTypes.TWO_PAIR] = {Chips = 20, Mult = 2},
                                     [Balatro_Expansion.HandTypes.THREE] =   {Chips = 30, Mult = 3},
                                     [Balatro_Expansion.HandTypes.STRAIGHT] = {Chips = 30, Mult = 4},
                                     [Balatro_Expansion.HandTypes.FLUSH] =   {Chips = 35, Mult = 4},
                                     [Balatro_Expansion.HandTypes.FULL_HOUSE] = {Chips = 40, Mult = 4},
                                     [Balatro_Expansion.HandTypes.FOUR] =        {Chips = 60, Mult = 7},
                                     [Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = {Chips = 100, Mult = 8},
                                     [Balatro_Expansion.HandTypes.ROYAL_FLUSH] = {Chips = 100, Mult = 8},
                                     [Balatro_Expansion.HandTypes.FIVE] = {Chips = 120, Mult = 12},
                                     [Balatro_Expansion.HandTypes.FLUSH_HOUSE] = {Chips = 140, Mult = 14},
                                     [Balatro_Expansion.HandTypes.FIVE_FLUSH] = {Chips = 160, Mult = 16}}

Balatro_Expansion.Saved.HandsTypeUsed = {[Balatro_Expansion.HandTypes.NONE] = 0,
                                         [Balatro_Expansion.HandTypes.HIGH_CARD] = 0,
                                         [Balatro_Expansion.HandTypes.PAIR] = 0,
                                         [Balatro_Expansion.HandTypes.TWO_PAIR] = 0,
                                         [Balatro_Expansion.HandTypes.THREE] = 0,
                                         [Balatro_Expansion.HandTypes.STRAIGHT] = 0,
                                         [Balatro_Expansion.HandTypes.FLUSH] = 0,
                                         [Balatro_Expansion.HandTypes.FULL_HOUSE] = 0,
                                         [Balatro_Expansion.HandTypes.FOUR] = 0,
                                         [Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = 0,
                                         [Balatro_Expansion.HandTypes.ROYAL_FLUSH] = 0,
                                         [Balatro_Expansion.HandTypes.FIVE] = 0,
                                         [Balatro_Expansion.HandTypes.FLUSH_HOUSE] = 0,
                                         [Balatro_Expansion.HandTypes.FIVE_FLUSH] = 0}



-----------JIMBO-------------------
Balatro_Expansion.Saved.Player = {}
--Balatro_Expansion.Saved.Player.FullDeck = {} --the full deck of cards used by jimbo
do
local index = 1
for i = 1, 4 do --cycles between the suits
    for j = 1, 13 do --cycles for all the values
        --Balatro_Expansion.Saved.Player.FullDeck[index] = {}
        --Balatro_Expansion.Saved.Player.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
        --Balatro_Expansion.Saved.Player.FullDeck[index].Value = j
        --Balatro_Expansion.Saved.Player.FullDeck[index].Enhancement = Balatro_Expansion.Enhancement.NONE
        --Balatro_Expansion.Saved.Player.FullDeck[index].Seal = Balatro_Expansion.Seals.NONE
        --Balatro_Expansion.Saved.Player.FullDeck[index].Edition = Balatro_Expansion.Edition.BASE
        --Balatro_Expansion.Saved.Player.FullDeck[index].Upgrades = 0 --only used for the Hiker joker
        index = index +1
    end
end
end
--Balatro_Expansion.Saved.Player.DeckPointer = 6 --the card that is going to be picked next
--Balatro_Expansion.Saved.Player.CurrentHand = {5,4,3,2,1} --the indexes leding to the cards in FullDeck
--Balatro_Expansion.Saved.Player.LastShotIndex = 0

Balatro_Expansion.Saved.MichelDestroyed = false

Balatro_Expansion.Saved.HasDebt = false
Balatro_Expansion.Saved.EnableHand = false

Balatro_Expansion.Saved.SmallBlind = 0
Balatro_Expansion.Saved.BigBlind = 0
Balatro_Expansion.Saved.ClearedRooms = 0
Balatro_Expansion.Saved.SmallCleared = false
Balatro_Expansion.Saved.BigCleared = false
Balatro_Expansion.Saved.BossCleared = 0  --0 = no | 1 = partially | 2 = yes
Balatro_Expansion.Saved.AnteLevel = 0
Balatro_Expansion.Saved.MaxAnteLevel = 0 --used to add correctly bosses to the pool (getting hierogliph could trigger the addition more than once)
Balatro_Expansion.Saved.BlindScalingFactor = 1 --factor that increases the enemies' HP
Balatro_Expansion.Saved.AnteBoss = Balatro_Expansion.BLINDS.BOSS
Balatro_Expansion.Saved.SmallSkipTag = 0
Balatro_Expansion.Saved.BigSkipTag = 0


Balatro_Expansion.Saved.SmallBlindIndex = 6
Balatro_Expansion.Saved.BigBlindIndex = 1
Balatro_Expansion.Saved.ShopIndex = 1
Balatro_Expansion.Saved.BossIndex = 1


Balatro_Expansion.BlindProgress = {NOT_CLEARED = 0,
                                   SKIPPED = 1,
                                   DEFEATED = 2}

--Balatro_Expansion.BossProgress = {NOT_CLEARED = 0,
--                                  PARTIAL = 1,
--                                  CLEARED = 2}


Balatro_Expansion.JokerProgress = {NOT_ACTIVE = 0, ACTIVE = 1}


Balatro_Expansion.StatEnable = false --needed cause i hate my life
--Balatro_Expansion.Saved.Player.StatsToAdd = {}
--basic stat ups that always apply 
--Balatro_Expansion.Saved.Player.StatsToAdd.Damage = 0
--Balatro_Expansion.Saved.Player.StatsToAdd.Tears = 1.5
--Balatro_Expansion.Saved.Player.StatsToAdd.Mult = 1
--joker stat ups which need to be re-evaluated each time
--Balatro_Expansion.Saved.Player.StatsToAdd.JokerDamage = 0
--Balatro_Expansion.Saved.Player.StatsToAdd.JokerTears = 0
--Balatro_Expansion.Saved.Player.StatsToAdd.JokerMult = 1

--Balatro_Expansion.Saved.Player.TrueDamageValue = 1 --used to surpass the usual 0.5 minimum damage cap (got this idea from isaacguru's Utility Commands)
--Balatro_Expansion.Saved.Player.TrueTearsValue = 2.5

--list keeping in memory every "invisible" item given by jokers and such 
--Balatro_Expansion.Saved.Player.InnateItems = {}
--Balatro_Expansion.Saved.Player.InnateItems.General = {}
--Balatro_Expansion.Saved.Player.InnateItems.Hack = {}

--Balatro_Expansion.Saved.Player.Progress = {} --values used for jokers and stuff
--Balatro_Expansion.Saved.Player.Progress.Inventory = {0,0,0} --never reset, changed in different ways basing on the joker
--Balatro_Expansion.Saved.Player.Progress.GiftCardExtra = {0,0,0}

--Balatro_Expansion.Saved.Player.ShowmanRemovedItems = {}

--Balatro_Expansion.Saved.Player.Progress.Blind = {} --reset every new blind
--Balatro_Expansion.Saved.Player.Progress.Blind.Shots = 0

--Balatro_Expansion.Saved.Player.Progress.Room = {} --reset every new room
--Balatro_Expansion.Saved.Player.Progress.Room.SuitUsed = {}
--Balatro_Expansion.Saved.Player.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Spade] = 0
--Balatro_Expansion.Saved.Player.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Heart] = 0
--Balatro_Expansion.Saved.Player.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Club] = 0
--Balatro_Expansion.Saved.Player.Progress.Room.SuitUsed[Balatro_Expansion.Suits.Diamond] = 0
--Balatro_Expansion.Saved.Player.Progress.Room.ValueUsed = {}
--for Value =1, 14 do
    --Balatro_Expansion.Saved.Player.Progress.Room.ValueUsed[Value] = 0
--end
--Balatro_Expansion.Saved.Player.Progress.Room.Shots = 0 --used to tell how many cards are already used

--Balatro_Expansion.Saved.Player.Progress.Floor = {}
--Balatro_Expansion.Saved.Player.Progress.Floor.CardsUsed = 0
Balatro_Expansion.Saved.FloorVouchers = {} --says which vouchers have already been spawned in a floor


--Balatro_Expansion.Saved.Player.LastCardUsed = nil --the last card a player used
--Balatro_Expansion.Saved.Player.EctoUses = 0 --how many times the Ectoplasm card got used in a run
--Balatro_Expansion.Saved.Player.NumActiveCostumes = 0


--Balatro_Expansion.Saved.Player.Inventory = {}
for i=1,3 do
    --Balatro_Expansion.Saved.Player.Inventory[i] = {}
    --Balatro_Expansion.Saved.Player.Inventory[i].Joker = 0
    --Balatro_Expansion.Saved.Player.Inventory[i].Edition = Balatro_Expansion.Edition.BASE
end


--Balatro_Expansion.Saved.Player.FirstDeck = true



Balatro_Expansion.Saved.CardLevels = {}
for i=1, 13 do
    Balatro_Expansion.Saved.CardLevels[i] = 0
end



Balatro_Expansion.HandUpgrades = {}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.HIGH_CARD] = {Chips = 10, Mult = 1}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.PAIR] = {Chips = 15, Mult = 1}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.TWO_PAIR] = {Chips = 20, Mult = 1}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.THREE] = {Chips = 20, Mult = 2}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.STRAIGHT] = {Chips = 30, Mult = 3}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FLUSH] = {Chips = 15, Mult = 2}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FULL_HOUSE] = {Chips = 25, Mult = 2}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FOUR] = {Chips = 30, Mult = 3}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = {Chips = 40, Mult = 4}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.ROYAL_FLUSH] = {Chips = 40, Mult = 4}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FIVE] = {Chips = 35, Mult = 3}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FLUSH_HOUSE] ={Chips = 40, Mult = 4}
Balatro_Expansion.HandUpgrades[Balatro_Expansion.HandTypes.FIVE_FLUSH] = {Chips = 50, Mult = 3}

--Balatro_Expansion.Saved.Player.HandsUsed = {}
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.HIGH_CARD] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.PAIR] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.TWO_PAIR] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.THREE] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.STRAIGHT] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.FLUSH] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.FULL_HOUSE] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.FOUR] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.STRAIGHT_FLUSH] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.ROYAL_FLUSH] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.FIVE] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.FLUSH_HOUSE] = 0
--Balatro_Expansion.Saved.Player.HandsUsed[Balatro_Expansion.HandTypes.FIVE_FLUSH] = 0


--  VALUES SHARED BETWWEN JIMBO AND NORMALS

--Balatro_Expansion.Saved.Player.ComedicState = 0



Balatro_Expansion.Saved.FloorEditions = {} --used to save which trinkets have certaain edition modifiers applied

--OTHER VALUES
Balatro_Expansion.HpEnable = false
--Balatro_Expansion.NumShops = 0
Balatro_Expansion.AnimationIsPlaying = false

Balatro_Expansion.Counters = {}--table used for variuos counters increased every update (mainly used for animated HUD stuff)
Balatro_Expansion.Counters.SinceShift = 0
Balatro_Expansion.Counters.SinceSelect = 0

--t.jimbo counters
Balatro_Expansion.Counters.SinceCardTriggered = {}
Balatro_Expansion.Counters.SinceConsumableTriggered = {}
Balatro_Expansion.Counters.Activated = {}


Balatro_Expansion.TearCardEnable = true --used in AddCardTearFlags()

Balatro_Expansion.Saved.ShopEntered = false
Balatro_Expansion.Saved.TreasureEntered = false

Balatro_Expansion.Saved.Labyrinth = 1
Balatro_Expansion.Saved.LastJokerRenderIndex = 0 --used to interpolate joker render positions

Balatro_Expansion.Saved.ModConfig = {}
Balatro_Expansion.Saved.ModConfig.EffectsAllowed = true
Balatro_Expansion.Saved.ModConfig.ExtraReadability = false


Balatro_Expansion.SelectionParams = {}
Balatro_Expansion.SelectionParams[1] = {}
Balatro_Expansion.SelectionParams[1].Frames = 0 -- in update frames
Balatro_Expansion.SelectionParams[1].SelectedCards = {false,false,false,false,false}
Balatro_Expansion.SelectionParams[1].Index = 1
Balatro_Expansion.SelectionParams[1].Mode = 0
Balatro_Expansion.SelectionParams[1].Purpose = 0
Balatro_Expansion.SelectionParams[1].PackOptions = {} --the options for the selection inside of a pack
Balatro_Expansion.SelectionParams[1].OptionsNum = 0 --total amount of options
Balatro_Expansion.SelectionParams[1].MaxSelectionNum = 0 --how many things you can choose at a time
Balatro_Expansion.SelectionParams[1].SelectionNum = 0 --how many things you chose


Balatro_Expansion.SelectionParams.Modes = {}
Balatro_Expansion.SelectionParams.Modes.NONE = 0
Balatro_Expansion.SelectionParams.Modes.HAND = 1 --used fo T.jimbo to make the enum more clear
Balatro_Expansion.SelectionParams.Modes.PACK = 2
Balatro_Expansion.SelectionParams.Modes.INVENTORY = 3
Balatro_Expansion.SelectionParams.Modes.CONSUMABLES = 4

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
--these don't follow the rules above
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
Balatro_Expansion.SelectionParams.Purposes.SMELTER = 29
Balatro_Expansion.SelectionParams.Purposes.AIMING = 30
Balatro_Expansion.SelectionParams.Purposes.SECRET_EXIT = 31
Balatro_Expansion.SelectionParams.Purposes.MegaFlag = 128 --applied on top of the packs purposes to say it's a double choice
Balatro_Expansion.SelectionParams.Purposes.FORCED_FLAG = 256


Balatro_Expansion.Saved.DSS = { 
                                Jimbo={
                                        HandHUDPosition = 1,
                                        HandScale = 1
                                    }, 
                                T_Jimbo={
                                         BaseHands = 4,
                                         BaseDiscards = 4,
                                         OutOfRangeDamage = 0.5,
                                         Vulnerability = false,
                                         VulnerableHandOpacity = 0.5,
                                         ShowUnavailableCards = false,
                                         CustomEID = true,
                                         LowerScaling = false,
                                },
                                
                                General={},
                                MenuPalette = {},
                                GamepadToggle = 1,
                                MenuKeyBind = Keyboard.KEY_C,
                                MenuHint = 1,
                                MenuBuzzer = 1,
                                MenusNotified = false,
                                MenusPoppedUp = false,-- not sure
                            }

Balatro_Expansion.Achievements = {
                                    PERMA_LOCK = Isaac.GetAchievementIdByName("PermaLocked"), --achievement used to block certain pickups from appearing outside of forced spawning
                                    T_JIMBO = Isaac.GetAchievementIdByName("T_JimboUnlock"),
                                    TRINKET_EDITIONS = Isaac.GetAchievementIdByName("TrinketEditionsUnlock"),
                                    Items = {   
                                            [Balatro_Expansion.Collectibles.HORSEY] = Isaac.GetAchievementIdByName("HorseyUnlock"),
                                            [Balatro_Expansion.Collectibles.CRAYONS] = Isaac.GetAchievementIdByName("CrayonsUnlock"),
                                            [Balatro_Expansion.Collectibles.BANANA] = Isaac.GetAchievementIdByName("BananaUnlock"),
                                            [Balatro_Expansion.Collectibles.BALOON_PUPPY] = Isaac.GetAchievementIdByName("BaloonPuppyUnlock"),
                                            [Balatro_Expansion.Collectibles.LAUGH_SIGN] = Isaac.GetAchievementIdByName("LaughSignUnlock"),
                                            [Balatro_Expansion.Collectibles.TRAGICOMEDY] = Isaac.GetAchievementIdByName("TragicomedyUnlock"),
                                            [Balatro_Expansion.Collectibles.UMBRELLA] = Isaac.GetAchievementIdByName("UmbrellaUnlock"),    
                                            [Balatro_Expansion.Collectibles.FUNNY_TEETH] = Isaac.GetAchievementIdByName("FunnyTeethUnlock"),
                                            [Balatro_Expansion.Collectibles.LOLLYPOP] = Isaac.GetAchievementIdByName("LollypopUnlock"),    
                                            [Balatro_Expansion.Collectibles.CLOWN] = Isaac.GetAchievementIdByName("ClownUnlock"), 
                                            [Balatro_Expansion.Collectibles.POCKET_ACES] = Isaac.GetAchievementIdByName("PocketAcesUnlock"), 

                                            [Balatro_Expansion.Collectibles.CERES] = Isaac.GetAchievementIdByName("BalatroPlanetsUnlock"), 
                                            [Balatro_Expansion.Collectibles.ERIS] = Isaac.GetAchievementIdByName("BalatroPlanetsUnlock"), 
                                            [Balatro_Expansion.Collectibles.PLANET_X] = Isaac.GetAchievementIdByName("BalatroPlanetsUnlock"), 
                                            [Balatro_Expansion.Collectibles.HEIRLOOM] = Isaac.GetAchievementIdByName("HeirloomUnlock"), 
                                            [Balatro_Expansion.Collectibles.THE_HAND] = Isaac.GetAchievementIdByName("TheHandUnlock"), 

                                        },
                                    Trinkets = {
                                                [Balatro_Expansion.Jokers.JOKER] = Isaac.GetAchievementIdByName("JokerTrinketUnlock"),
                                                [Balatro_Expansion.Trinkets.TASTY_CANDY[1]] = Isaac.GetAchievementIdByName("TastyCandyUnlock"),
                                                [Balatro_Expansion.Jokers.CHAOS_THEORY] = Isaac.GetAchievementIdByName("ChaosTheoryUnlock"),
                                                [Balatro_Expansion.Trinkets.PENNY_SEEDS] = Isaac.GetAchievementIdByName("PennySeedsUnlock"),

                                        },
                                    Entities = {},
                                    Pickups = {}
                                 
                                }

----------------------------- gaw damn those were a lot of variables


--heyo dear mod developer college! Fell free to take any of the code written here
--but please make sure to give this mod credit when you take important/big chunks of code

--also i don't know wether or not this thing is coded properly, so if you have an
--optimisation idea write it in the comments of the steam page and i'll try to implement it (giving you credit obv)

--Wanna do a big shoutuot to CATINSURANCE for making very good yt tutorial vids and also 
--because i took some inspiration from The Sheriff's code while making this




--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work 
--(both sound and graphics can be turend off with MOD CONFIG MENU)
include("Balatro_scripts.Effects")

-----------------OTHER/OFTEN USED FUNCTIONS---------------------
----------------------------------------------------------------
--general function used in the code

include("Balatro_scripts.Utility.Utility")
include("Balatro_scripts.Utility.Console Commands")
--Balatro_Expansion.ItemManager = include("Balatro_scripts.Utility.hidden_item_manager")
--Balatro_Expansion.ItemManager = Balatro_Expansion.ItemManager:Init(Balatro_Expansion)
--Balatro_Expansion.Saved.HiddenItemsData = {}

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


include("Balatro_scripts.characters.jimbo.mechanics") --general mechanics such as blind progression
include("Balatro_scripts.characters.jimbo.trinkets") --jimbo trinkets/items effects
include("Balatro_scripts.characters.jimbo.items") --most items (vouchers) effects
include("Balatro_scripts.characters.jimbo.hud") --hud handling
include("Balatro_scripts.characters.jimbo.Custom_Cards") --jimbo cards effects
include("Balatro_scripts.characters.jimbo.Synergies") --specific synergies


include("Balatro_scripts.characters.T jimbo.mechanics")
include("Balatro_scripts.characters.T jimbo.Special enemies")
include("Balatro_scripts.characters.T jimbo.hud")
include("Balatro_scripts.characters.T jimbo.Custom_Cards")
include("Balatro_scripts.characters.T jimbo.scoring system") --hand scoring handling
include("Balatro_scripts.characters.T jimbo.items")


include("Balatro_scripts.characters.DebtManager")

include("Balatro_scripts.custom_grid")


include("Balatro_scripts.Unlockables.Unlockable Items")
include("Balatro_scripts.Unlockables.The Hand")
include("Balatro_scripts.Unlockables.Trinket Editions")
--include("Balatro_scripts.Trinket_Callbacks")

---------------------CUSTOM UI ANIMATIONS---------------------
--------------------------------------------------------------------
---
include("Balatro_scripts.Utility.cool_title")
include("Balatro_scripts.characters.T jimbo.Versus Screen")



-------------------SETUP FUNCTIOINS------------------------------------

--to see the list of all the custom tags and how they work, see the items.xml file

include("Balatro_scripts.Callback_system")



------------------EID----------------------
-------------------------------------------
include("Balatro_scripts.Compatibility.EID")

-------------DSS MENU -------------
------------------------------------------
include("Balatro_scripts.Compatibility.deadseascrolls")