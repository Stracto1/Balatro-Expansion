---@diagnostic disable: undefined-field, need-check-nil, inject-field, cast-local-type, param-type-mismatch
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local HORSEY_RADIUS = 20
local HORSEY_MAX_JUMP_DELAY = 90
local HORSEY_JUMP_COOLDOWN = HORSEY_MAX_JUMP_DELAY - 35

local HorseyState = {}
HorseyState.IDLE = 1 --waiting for something to jump on or to cooldown to reache 0
HorseyState.JUMP = 2 --in mid-air
HorseyState.SLEEP = 3

local ColorSubType = {} --used to randomize familiar/effect colors
ColorSubType.RED = 1
ColorSubType.CYAN = 2
ColorSubType.ORANGE = 3
ColorSubType.WHITE = 4
ColorSubType.GREEN = 5
ColorSubType.PINK = 6
ColorSubType.PURPLE = 7
ColorSubType.GREY = 8
ColorSubType.YELLOW = 9
ColorSubType.NUM_COLORS = 9


local CrayonColors = {}
CrayonColors[ColorSubType.RED] = Color(1,1,1,1,0,0,0,0.95,0.3,0.3,1)
CrayonColors[ColorSubType.CYAN] = Color(1,1,1,1,0,0,0,0.27,0.59,0.95,1)
CrayonColors[ColorSubType.ORANGE] = Color(1,1,1,1,0,0,0,0.95,0.59,0.2,1)
CrayonColors[ColorSubType.WHITE] = Color(1,1,1,1,0,0,0,1,0.95,0.95,1)
CrayonColors[ColorSubType.GREEN] = Color(1,1,1,1,0,0,0,0.4,0.8,0.27,1)
CrayonColors[ColorSubType.PINK] = Color(1,1,1,1,0,0,0,0.89,0.48,0.8,1)
CrayonColors[ColorSubType.PURPLE] = Color(1,1,1,1,0,0,0,0.67,0.11,0.63,1)
CrayonColors[ColorSubType.GREY] = Color(1,1,1,1,0,0,0,0.6,0.6,0.6,1)
CrayonColors[ColorSubType.YELLOW] = Color(1,1,1,1,0,0,0,0.9,0.83,0.31,1)

local BananaState = {}
BananaState.IDLE = 1 --waiting for someone stupid enough to fall for it
BananaState.FLYING = 2 --in mid-air from initial throw
BananaState.SLIP = 3 --disappearing

local PUPPY_RESPAWN_TIMER = 270
local PuppyState = {}
PuppyState.IDLE = 1 --chilling with isaac while still attached
PuppyState.ATTACK = 2 --disappearing
PuppyState.EXPLODED = 3 --disappearing

local PuppyColorsSuffix = {}
PuppyColorsSuffix[ColorSubType.RED] = "_red"
PuppyColorsSuffix[ColorSubType.CYAN] = "_cyan"
PuppyColorsSuffix[ColorSubType.ORANGE] = "_orange"
PuppyColorsSuffix[ColorSubType.WHITE] = "_white"
PuppyColorsSuffix[ColorSubType.GREEN] = "_green"
PuppyColorsSuffix[ColorSubType.PINK] = "_pink"
PuppyColorsSuffix[ColorSubType.PURPLE] = "_red"
PuppyColorsSuffix[ColorSubType.GREY] = "_grey"
PuppyColorsSuffix[ColorSubType.YELLOW] = "_yellow"

local LaughEffectType = {}
LaughEffectType.GOOD = 0
LaughEffectType.BAD = 1
LaughEffectType.GASP = 2
LaughEffectType.LAUGH = 3
LaughEffectType.RANDOM = 4
LaughEffectType.TRANSITION = 5


local TomatoAnimations = {}
TomatoAnimations.IDLE = {"Idle1","Idle2"}
TomatoAnimations.SPLAT = {"Splat1","Splat2"}
TomatoAnimations.DISAPPEAR = {"Disappear1","Disappear2"}
TomatoAnimations.NUM_VARIANTS = 2

local TomatoState = {}
TomatoState.THROW = 0
TomatoState.SPLAT = TomatoAnimations.NUM_VARIANTS+1
TomatoState.DISAPPEAR = (TomatoAnimations.NUM_VARIANTS+1)*2

BASE_CARD_ANIMATION = "Base"
local SUIT_ANIMATIONS = {"Spade","Heart","Club","Diamond"}


local ComedicState = {}
ComedicState.NONE = 0
ComedicState.COMEDY = 1
ComedicState.TRAGEDY = 2
ComedicState.TRAGICOMEDY = 3

local MaskCostume = {}
MaskCostume[ComedicState.NONE] = 0
MaskCostume[ComedicState.COMEDY] = Isaac.GetCostumeIdByPath("gfx/characters/comedy_mask_costume.anm2")
MaskCostume[ComedicState.TRAGEDY] = Isaac.GetCostumeIdByPath("gfx/characters/tragic_mask_costume.anm2")
MaskCostume[ComedicState.TRAGICOMEDY] = Isaac.GetCostumeIdByPath("gfx/characters/tragicomedy_mask_costume.anm2")

local TragicomedyCaches = CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_SPEED 


local AnvilStates = {}
AnvilStates.FALLING = 0
AnvilStates.REFLECTED = 30

local ANVIL_FOLLOW_TIME = 35
local ANVIL_START_HEIGHT = -1200
local UMBRELLA_HEIGHT = -42 --no idea why it needs to be doubled, the position looked fine to me but it aparently wasn't
local UMBRELLA_VAR = {OPENED = 1, CLOSED = 0}
--local UMBRELLA_CAPSULE = {MULTI = Vector(4.5, 2.5), SIZE = 10}


local MAX_LOLLYPOP_COOLDOWN = 750
local LollypopPicker = WeightedOutcomePicker()
LollypopPicker:AddOutcomeFloat(1, 1)
LollypopPicker:AddOutcomeFloat(2, 1)
LollypopPicker:AddOutcomeFloat(3, 0.01)

local CandySheets = {[SlotVariant.BEGGAR] = "gfx/sprites/slot_004_beggar.png",
                     [SlotVariant.DEVIL_BEGGAR] = "gfx/sprites/slot_005_devil_beggar.png",
                     [SlotVariant.KEY_MASTER] = "gfx/sprites/slot_007_key_master.png",
                     [SlotVariant.BOMB_BUM] = "gfx/sprites/slot_009_bomb_bum.png",
                     [SlotVariant.BATTERY_BUM] = "gfx/sprites/slot_013_battery_bum.png",
                     [SlotVariant.ROTTEN_BEGGAR] = "gfx/sprites/rotten_beggar.png"}

local CandySheet = "gfx/sprites/tasty_candy_shard.png"


local BombBumPayoutPicker = WeightedOutcomePicker()
BombBumPayoutPicker:AddOutcomeWeight(1, 26) --coins
BombBumPayoutPicker:AddOutcomeWeight(2, 9) --hearts
BombBumPayoutPicker:AddOutcomeWeight(3, 5) --collectibles


local MAX_TEETH_CHARGE = 225
local MIN_TEETH_CHARGE = 120
local TeethStates = {}
TeethStates.IDLE = 0
TeethStates.CHASE = 1
TeethStates.CHARGE = 2
TeethStates.TIRED = 3
TeethStates.START_SLEEP = 4


--for whatever reason the collisionInterval in .xml does nothing by itself so gotta do stuff manually
local FamiliarCollisionInterval = {}
FamiliarCollisionInterval[mod.Familiars.BLOON_PUPPY] = EntityConfig.GetEntity(EntityType.ENTITY_FAMILIAR, mod.Familiars.BLOON_PUPPY):GetCollisionInterval()
FamiliarCollisionInterval[mod.Familiars.TEETH] = EntityConfig.GetEntity(EntityType.ENTITY_FAMILIAR, mod.Familiars.TEETH):GetCollisionInterval()
FamiliarCollisionInterval[mod.Familiars.CERES] = EntityConfig.GetEntity(EntityType.ENTITY_FAMILIAR, mod.Familiars.CERES):GetCollisionInterval()

local CERES_PIECE_PATH = "gfx/familiar/familiar_ceres_piece.png"
local CERES_FIRE_COOLDOWN = 35
local COLOR_CERES = Color(1,1,1,1,0,0,0,0.55, 0.55, 0.6, 1)

local PLANET_X_PICKER = WeightedOutcomePicker() --setup as the game starts to include any item inside the planetarium pool

local ERIS_MAX_RADIUS = 165
local ERIS_MIN_RADIUS = 20
local ERIS_MAX_SLOW = 0.075
local ERIS_MIN_SLOW = 0.005


local PENNY_TRINKET_POOLS = {[BackdropType.BASEMENT] = {TrinketType.TRINKET_BUTT_PENNY,
                                                        TrinketType.TRINKET_COUNTERFEIT_PENNY,
                                                        },
                             [BackdropType.BURNT_BASEMENT] = {TrinketType.TRINKET_BUTT_PENNY,
                                                             TrinketType.TRINKET_BURNT_PENNY,
                                                             },
                             [BackdropType.CELLAR] = {TrinketType.TRINKET_BUTT_PENNY,
                                                      TrinketType.TRINKET_FLAT_PENNY,
                                                      },
                             [BackdropType.DOWNPOUR] = {TrinketType.TRINKET_SWALLOWED_PENNY,
                                                        TrinketType.TRINKET_BLESSED_PENNY,
                                                        },
                             [BackdropType.DROSS] = {TrinketType.TRINKET_SWALLOWED_PENNY,
                                                     TrinketType.TRINKET_ROTTEN_PENNY,
                                                     },
                             [BackdropType.CAVES] = {TrinketType.TRINKET_FLAT_PENNY,
                                                     TrinketType.TRINKET_CHARGED_PENNY,
                                                     },
                             [BackdropType.FLOODED_CAVES] = {TrinketType.TRINKET_FLAT_PENNY,
                                                             TrinketType.TRINKET_SWALLOWED_PENNY,
                                                             },
                             [BackdropType.CATACOMBS] = {TrinketType.TRINKET_FLAT_PENNY,
                                                         TrinketType.TRINKET_CURSED_PENNY,
                                                         },
                             [BackdropType.MINES] = {TrinketType.TRINKET_COUNTERFEIT_PENNY,
                                                     TrinketType.TRINKET_CHARGED_PENNY,
                                                     },
                             [BackdropType.ASHPIT] = {TrinketType.TRINKET_COUNTERFEIT_PENNY,
                                                      TrinketType.TRINKET_CURSED_PENNY,
                                                      },           
                             [BackdropType.NECROPOLIS] = {TrinketType.TRINKET_CURSED_PENNY,
                                                          TrinketType.TRINKET_BLESSED_PENNY,
                                                          },
                             [BackdropType.DEPTHS] = {TrinketType.TRINKET_CURSED_PENNY,
                                                      TrinketType.TRINKET_COUNTERFEIT_PENNY,
                                                      },
                             [BackdropType.DANK_DEPTHS] = {TrinketType.TRINKET_CURSED_PENNY,
                                                            TrinketType.TRINKET_SWALLOWED_PENNY,
                                                            },
                             [BackdropType.MAUSOLEUM] = {TrinketType.TRINKET_CURSED_PENNY,
                                                         TrinketType.TRINKET_BLESSED_PENNY,
                                                         },
                             [BackdropType.GEHENNA] = {TrinketType.TRINKET_CURSED_PENNY,
                                                       TrinketType.TRINKET_BLOODY_PENNY,
                                                       },
                             [BackdropType.WOMB] = {TrinketType.TRINKET_BLOODY_PENNY,
                                                    TrinketType.TRINKET_CHARGED_PENNY,
                                                    },
                             [BackdropType.SCARRED_WOMB] = {TrinketType.TRINKET_BLOODY_PENNY,
                                                            TrinketType.TRINKET_BURNT_PENNY,
                                                            },
                             [BackdropType.UTERO] = {TrinketType.TRINKET_BLOODY_PENNY,
                                                     TrinketType.TRINKET_SWALLOWED_PENNY,
                                                     },
                             [BackdropType.BLUE_WOMB] = {TrinketType.TRINKET_ROTTEN_PENNY,
                                                         TrinketType.TRINKET_BLESSED_PENNY,
                                                         },
                             [BackdropType.CORPSE] = {TrinketType.TRINKET_ROTTEN_PENNY,
                                                      TrinketType.TRINKET_CURSED_PENNY,
                                                      },
                             [BackdropType.CATHEDRAL] = {TrinketType.TRINKET_BLESSED_PENNY,
                                                         TrinketType.TRINKET_SWALLOWED_PENNY,
                                                         },
                             [BackdropType.CHEST] = {TrinketType.TRINKET_BLESSED_PENNY,
                                                     TrinketType.TRINKET_ROTTEN_PENNY,
                                                     TrinketType.TRINKET_FLAT_PENNY,
                                                     },
                             [BackdropType.SHEOL] = {TrinketType.TRINKET_CURSED_PENNY,
                                                     TrinketType.TRINKET_COUNTERFEIT_PENNY
                                                    },
                             [BackdropType.DARKROOM] = {TrinketType.TRINKET_CURSED_PENNY,
                                                        TrinketType.TRINKET_BLOODY_PENNY,
                                                        },
                             [BackdropType.ARCADE] = {TrinketType.TRINKET_CHARGED_PENNY,
                                                      TrinketType.TRINKET_COUNTERFEIT_PENNY,
                                                      },
                             [BackdropType.SHOP] = {TrinketType.TRINKET_CHARGED_PENNY,
                                                    TrinketType.TRINKET_ROTTEN_PENNY,
                                                    },
                             [BackdropType.PLANETARIUM] = {TrinketType.TRINKET_BLESSED_PENNY,
                                                          },
                             [BackdropType.MOMS_BEDROOM] = {TrinketType.TRINKET_CURSED_PENNY,
                                                            TrinketType.TRINKET_BLESSED_PENNY,
                                                            },
                             [BackdropType.DICE] = {TrinketType.TRINKET_FLAT_PENNY,
                                                    TrinketType.TRINKET_BURNT_PENNY,
                                                    TrinketType.TRINKET_BLOODY_PENNY,
                                                    TrinketType.TRINKET_CURSED_PENNY,
                                                    TrinketType.TRINKET_ROTTEN_PENNY,
                                                    TrinketType.TRINKET_BLESSED_PENNY,
                                                    TrinketType.TRINKET_CHARGED_PENNY,
                                                    TrinketType.TRINKET_SWALLOWED_PENNY,
                                                    TrinketType.TRINKET_COUNTERFEIT_PENNY}}

local GROUND_PARTICLE = { DEFAULT = EffectVariant.TOOTH_PARTICLE,
                         [BackdropType.WOMB] = EffectVariant.BLOOD_PARTICLE,
                         [BackdropType.SCARRED_WOMB] = EffectVariant.BLOOD_PARTICLE,
                         [BackdropType.UTERO] = EffectVariant.BLOOD_PARTICLE,
                        
                         [BackdropType.CORPSE] = EffectVariant.BLOOD_PARTICLE,
                         [BackdropType.CORPSE2] = EffectVariant.BLOOD_PARTICLE,
                         [BackdropType.CORPSE3] = EffectVariant.BLOOD_PARTICLE,
                         [BackdropType.CORPSE_ENTRANCE] = EffectVariant.BLOOD_PARTICLE,

                         [BackdropType.BLUE_WOMB] = EffectVariant.BLOOD_PARTICLE,
                         [BackdropType.BLUE_WOMB_PASS] = EffectVariant.BLOOD_PARTICLE,

                         [BackdropType.CELLAR] = EffectVariant.WOOD_PARTICLE,
                         [BackdropType.CHEST] = EffectVariant.WOOD_PARTICLE,
                         [BackdropType.SHOP] = EffectVariant.WOOD_PARTICLE,
                         [BackdropType.GREED_SHOP] = EffectVariant.WOOD_PARTICLE}


local CLOWN_RANGE = 110


do --specific backdorps

    PENNY_TRINKET_POOLS.DEFAULT = {TrinketType.TRINKET_FLAT_PENNY,
                                  TrinketType.TRINKET_BURNT_PENNY,
                                  TrinketType.TRINKET_SWALLOWED_PENNY,
                                  TrinketType.TRINKET_CHARGED_PENNY}

    PENNY_TRINKET_POOLS[BackdropType.ASHPIT_SHAFT] = PENNY_TRINKET_POOLS[BackdropType.ASHPIT]
    PENNY_TRINKET_POOLS[BackdropType.MINES_SHAFT] = PENNY_TRINKET_POOLS[BackdropType.MINES]
    PENNY_TRINKET_POOLS[BackdropType.MINES_ENTRANCE] = PENNY_TRINKET_POOLS[BackdropType.MINES]

    PENNY_TRINKET_POOLS[BackdropType.CORPSE2] = PENNY_TRINKET_POOLS[BackdropType.CORPSE]
    PENNY_TRINKET_POOLS[BackdropType.CORPSE3] = PENNY_TRINKET_POOLS[BackdropType.CORPSE]
    PENNY_TRINKET_POOLS[BackdropType.CORPSE_ENTRANCE] = PENNY_TRINKET_POOLS[BackdropType.CORPSE]

    PENNY_TRINKET_POOLS[BackdropType.GREED_SHOP] = PENNY_TRINKET_POOLS[BackdropType.SHOP]

    PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM2] = PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM]
    PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM3] = PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM]
    PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM4] = PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM]
    PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM_ENTRANCE] = PENNY_TRINKET_POOLS[BackdropType.MAUSOLEUM]

    PENNY_TRINKET_POOLS[BackdropType.DOWNPOUR_ENTRANCE] = PENNY_TRINKET_POOLS[BackdropType.DOWNPOUR]
    PENNY_TRINKET_POOLS[BackdropType.MEGA_SATAN] = PENNY_TRINKET_POOLS[BackdropType.SHEOL]
end


local HEIRLOOM_COIN_UPGRADES = {[CoinSubType.COIN_PENNY] = {NewSubType = CoinSubType.COIN_DOUBLEPACK, Chance = 0.5},
                                [CoinSubType.COIN_DOUBLEPACK] = {NewSubType = CoinSubType.COIN_NICKEL, Chance = 0.4},
                                [CoinSubType.COIN_NICKEL] = {NewSubType = CoinSubType.COIN_DIME, Chance = 0.12},
                                [CoinSubType.COIN_DIME] = {NewSubType = CoinSubType.COIN_GOLDEN, Chance = 0.2},}

local PICKUP_GOLDEN_SUB = {[PickupVariant.PICKUP_BOMB] = {NewSubType = BombSubType.BOMB_GOLDEN, Chance = 0.075},
                           [PickupVariant.PICKUP_KEY] = {NewSubType = KeySubType.KEY_GOLDEN, Chance = 0.075},
                           [PickupVariant.PICKUP_HEART] = {NewSubType = HeartSubType.HEART_GOLDEN, Chance = 0.06},
                           [PickupVariant.PICKUP_LIL_BATTERY] = {NewSubType = BatterySubType.BATTERY_GOLDEN, Chance = 0.08},}
                
local GOLDEN_PILL_CHANCE = 0.095
local GOLDEN_TRINKET_CHANCE = 0.075

local PICKUP_GOLDEN_VARIANT = {[PickupVariant.PICKUP_CHEST] = {NewVariant = PickupVariant.PICKUP_LOCKEDCHEST, Chance = 0.065},
                               [PickupVariant.PICKUP_MIMICCHEST] = {NewVariant = PickupVariant.PICKUP_LOCKEDCHEST, Chance = 0.065},
                               [PickupVariant.PICKUP_SPIKEDCHEST] = {NewVariant = PickupVariant.PICKUP_LOCKEDCHEST, Chance = 0.065},
                               }

local GOLDEN_PICKUP_ACHIEVEMENTS = {[PickupVariant.PICKUP_COIN] = Achievement.GOLDEN_PENNY,
                                    [PickupVariant.PICKUP_BOMB] = Achievement.GOLDEN_BOMBS,
                                    [PickupVariant.PICKUP_HEART] = Achievement.GOLDEN_HEARTS,
                                    [PickupVariant.PICKUP_LIL_BATTERY] = Achievement.GOLDEN_BATTERY,
                                    }

local GOLDEN_ITEM_CHANCE = 0.015 --only if Epiphany is active and they are unlocked

local GoldTurnSfx

local function GetEpiphanySound()

    GoldTurnSfx = Isaac.GetSoundIdByName("Gold Turn") --useless if Epiphany isn't there
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, GetEpiphanySound)



local function SetupPlanetXPool()

    PLANET_X_PICKER:ClearOutcomes()

    local PlanetPool = Game:GetItemPool():GetCollectiblesFromPool(ItemPoolType.POOL_PLANETARIUM)

    for _,Registration in ipairs(PlanetPool) do

        local Config = ItemsConfig:GetCollectible(Registration.itemID)
        
        if Registration.itemID ~= mod.Collectibles.PLANET_X and Isaac.GetPersistentGameData():Unlocked(Config.AchievementID) then
            
            PLANET_X_PICKER:AddOutcomeFloat(Registration.itemID, Registration.weight)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, SetupPlanetXPool)



local function UnlockNormalItems(_,Type)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        
        local GameData = Isaac.GetPersistentGameData()

        if Type == CompletionType.MOMS_HEART then
            GameData:TryUnlock(mod.Achievements.Trinkets[mod.Jokers.JOKER])

        elseif Type == CompletionType.ISAAC then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.HORSEY])

        elseif Type == CompletionType.BLUE_BABY then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.CRAYONS])

        elseif Type == CompletionType.SATAN then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.BALOON_PUPPY])

        elseif Type == CompletionType.LAMB then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.FUNNY_TEETH])

        elseif Type == CompletionType.BOSS_RUSH then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.LOLLYPOP])

        elseif Type == CompletionType.HUSH then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.LAUGH_SIGN])

        elseif Type == CompletionType.MEGA_SATAN then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.UMBRELLA])

        elseif Type == CompletionType.MOTHER then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.TRAGICOMEDY])

        elseif Type == CompletionType.BEAST then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.BANANA])

        elseif Type == CompletionType.DELIRIUM then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.POCKET_ACES])

        elseif Type == CompletionType.ULTRA_GREED then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.CLOWN])
        elseif Type == CompletionType.ULTRA_GREEDIER then
            GameData:TryUnlock(mod.Achievements.Items[mod.Trinkets.TASTY_CANDY[1]])
        end
    end

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        
        local GameData = Isaac.GetPersistentGameData()

        if Type == CompletionType.ISAAC or Type == CompletionType.BLUE_BABY
           or Type == CompletionType.SATAN or Type == CompletionType.LAMB then

            if Isaac.AllTaintedCompletion(mod.Characters.TaintedJimbo, TaintedMarksGroup.POLAROID_NEGATIVE) ~= 0 then
                GameData:TryUnlock(mod.Achievements.Trinkets[mod.Trinkets.PENNY_SEEDS])
            end

        elseif Type == CompletionType.BOSS_RUSH or Type == CompletionType.HUSH then

            if Isaac.AllTaintedCompletion(mod.Characters.TaintedJimbo, TaintedMarksGroup.SOULSTONE) ~= 0 then
                GameData:TryUnlock(mod.Achievements.Consumables[mod.JIMBO_SOUL])
            end

        elseif Type == CompletionType.MEGA_SATAN then
            GameData:TryUnlock(mod.Achievements.TRINKET_EDITIONS)

        elseif Type == CompletionType.MOTHER then
            GameData:TryUnlock(mod.Achievements.Trinkets[mod.Jokers.CHAOS_THEORY])

        elseif Type == CompletionType.BEAST then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.HEIRLOOM])

        elseif Type == CompletionType.DELIRIUM then
            GameData:TryUnlock(mod.Achievements.Items[mod.Collectibles.THE_HAND])

        elseif Type == CompletionType.ULTRA_GREEDIER then
            GameData:TryUnlock(mod.Achievements.Entities.A_STUPID_IDEA)
        end

        if Isaac.AllMarksFilled(mod.Characters.TaintedJimbo) ~= 0 then
            GameData:TryUnlock(mod.Achievements.Items.FORGOTTEN_PLANETS)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, UnlockNormalItems)



---@param Familiar EntityFamiliar
---@param Force boolean --TRUE: forces to choose random direction different from the last one
local function GetHorseyGridTarget(Familiar, Force)

    local Room = Game:GetRoom()
    local RoomWidth = Room:GetGridWidth()

    local LastGrid = Familiar:GetData().LastGrid or 0
    --local LastCollum = LastGrid % RoomWidth
    --local LastRow = LastGrid//RoomWidth

    local HorseGrid = Room:GetGridIndex(Familiar.Position)
    local HorseCollum = HorseGrid % RoomWidth
    local HorseRow = HorseGrid//RoomWidth

    --print("horse:", HorseCollum, HorseRow)

    local PossibleGrids = {}

    --searches for horse movements with a stompable enemy in it
    for CollumOffset=-2, 2, 1 do

        if CollumOffset ~= 0 then
            
            local StartRowOffset = math.abs(CollumOffset) - 3 --either -2 or -1

            for RowOffset = StartRowOffset, -StartRowOffset, -2*StartRowOffset do

                local TargetRow = HorseRow+RowOffset
                local TargetCollum = HorseCollum+CollumOffset
                local TargetGrid = TargetCollum + TargetRow*RoomWidth

                local TargetGridEntity = Room:GetGridEntity(TargetGrid)

                --print(TargetGrid, TargetRow, TargetCollum)
                if not TargetGridEntity
                   or TargetGridEntity:IsBreakableRock()
                   or TargetGridEntity:GetType() == GridEntityType.GRID_NULL
                   or TargetGridEntity.CollisionClass == GridCollisionClass.COLLISION_NONE then

                    -- cannot go on unbreakable rocks

                    if Force 
                       and TargetGrid ~= LastGrid
                       --and (math.abs(TargetCollum-LastCollum) > 1 or math.abs(TargetRow-LastRow) > 1)
                       and TargetCollum > 1 and math.abs(TargetCollum - RoomWidth) > 2 --can't go on the room's borders
                       and TargetRow > 1 and math.abs(TargetRow - Room:GetGridHeight()) > 2
                       and Room:IsPositionInRoom(Room:GetGridPosition(TargetGrid), 40) then
                        --cannot go back to where it came from 

                        PossibleGrids[#PossibleGrids+1] = TargetGrid

                    else
                        for i, Entity in ipairs(Isaac.FindInRadius(Room:GetGridPosition(TargetGrid), HORSEY_RADIUS)) do

                            ---@diagnostic disable-next-line: cast-local-type
                            Entity = Entity:ToNPC()

                            if Entity and Entity:IsActiveEnemy() and Entity:IsVulnerableEnemy() then

                                PossibleGrids[#PossibleGrids+1] = TargetGrid
                                break
                            end
                        end
                    end
                end --GridEntity check
            end -- RowOffset for
        end

    end--CollumOffset for

    return mod:GetRandom(PossibleGrids)
end

------------FAMILIARS--------------
-----------------------------------

---@param Player EntityPlayer
function mod:GiveFamiliars(Player, _)

    local FamiliarCount = Player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.HORSEY) + Player:GetCollectibleNum(mod.Collectibles.HORSEY)
    Player:CheckFamiliar(mod.Familiars.HORSEY, FamiliarCount, RNG(mod:RandomSeed()), ItemsConfig:GetCollectible(mod.Collectibles.HORSEY))

    FamiliarCount = Player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.BALOON_PUPPY) + Player:GetCollectibleNum(mod.Collectibles.BALOON_PUPPY)
    Player:CheckFamiliar(mod.Familiars.BLOON_PUPPY, FamiliarCount, RNG(mod:RandomSeed()), ItemsConfig:GetCollectible(mod.Collectibles.BALOON_PUPPY))

    FamiliarCount = Player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.FUNNY_TEETH) + Player:GetCollectibleNum(mod.Collectibles.FUNNY_TEETH)
    Player:CheckFamiliar(mod.Familiars.TEETH, FamiliarCount, RNG(mod:RandomSeed()), ItemsConfig:GetCollectible(mod.Collectibles.FUNNY_TEETH))

    FamiliarCount = Player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.CERES) + Player:GetCollectibleNum(mod.Collectibles.CERES)
    Player:CheckFamiliar(mod.Familiars.CERES, FamiliarCount, RNG(mod:RandomSeed()), ItemsConfig:GetCollectible(mod.Collectibles.CERES))
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveFamiliars, CacheFlag.CACHE_FAMILIARS)


---@param Familiar EntityFamiliar
function mod:FamiliarInit(Familiar)


    if Familiar.Variant == mod.Familiars.HORSEY then
        local Room = Game:GetRoom()

        Familiar.Position = Room:GetGridPosition(Room:GetGridIndex(Familiar.Position))

        Familiar.State = HorseyState.IDLE
        Familiar.FireCooldown = HORSEY_JUMP_COOLDOWN

    elseif Familiar.Variant == mod.Familiars.BLOON_PUPPY then

        Familiar.DepthOffset = Familiar.DepthOffset + 1000
        Familiar.Position = Familiar.Player.Position

        Familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        Familiar.State = PuppyState.IDLE
        Familiar.FireCooldown = 0
        Familiar.MaxHitPoints = 16 * Familiar:GetMultiplier()

        Familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_Baloon_Puppy"..PuppyColorsSuffix[math.random(ColorSubType.NUM_COLORS)]..".png", true)

    elseif Familiar.Variant == mod.Familiars.CERES then

        Familiar:AddToOrbit(5074)
        Familiar.OrbitDistance = Vector(110, 109.6)
        Familiar.OrbitSpeed = 0.07

        Familiar.FireCooldown = 0

        Familiar:GetSprite().PlaybackSpeed = 0.02 --orbits real slow

    elseif Familiar.Variant == mod.Familiars.TEETH then
        Familiar.State = TeethStates.IDLE
        Familiar.FireCooldown = 300
        Familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.FamiliarInit)


---@param Familiar EntityFamiliar
function mod:FamiliarUpdate(Familiar)

    if Familiar.Variant == mod.Familiars.HORSEY then
        local Room = Game:GetRoom()
        local HorseSprite = Familiar:GetSprite()

        if Familiar.State == HorseyState.IDLE then

            Familiar.Position = Room:GetGridPosition(Room:GetGridIndex(Familiar.Position))

            if Room:IsClear() then
                Familiar.State = HorseyState.SLEEP

                HorseSprite:Play("StartSleep")
            
            elseif Familiar.FireCooldown < HORSEY_JUMP_COOLDOWN then
                local DestinationGrid = GetHorseyGridTarget(Familiar, Familiar.FireCooldown == 0)

                if DestinationGrid then

                    Familiar:GetData().LastGrid = Room:GetGridIndex(Familiar.Position)
                    Familiar:GetData().TargetGrid = DestinationGrid

                    Familiar.State = HorseyState.JUMP
                    HorseSprite:Play("Jump")
                end
            end

        elseif Familiar.State == HorseyState.JUMP then

            if Familiar.Position.X == Room:GetGridPosition(Familiar:GetData().TargetGrid).X
               and Familiar.Position.Y == Room:GetGridPosition(Familiar:GetData().TargetGrid).Y then

                Familiar.Velocity = Vector.Zero
            end

            if HorseSprite:IsEventTriggered("Landing") then

                local Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Familiar.Position, Vector.Zero,
                                         Familiar, 0, 1):ToEffect()

                ---@diagnostic disable-next-line: need-check-nil
                Shock:SetRadii(15, 20 + 20*Familiar:GetMultiplier())
                --Shock.CollisionDamage = 1 or Familiar.Player.Damage*1.5 + 1 :( no work

                Shock.Parent = Familiar.Player

                SFXManager():Play(SoundEffect.SOUND_CHEST_DROP) --PLACEHOLDER

                Game:MakeShockwave(Familiar.Position, 0.015, 0.01, 5)
                --Entity:AddKnockback(EntityRef(Familiar), (Entity.Position - Familiar.Position):Normalized(), 4, false)

            elseif HorseSprite:IsEventTriggered("StartMove") then

                Familiar.Velocity = (Room:GetGridPosition(Familiar:GetData().TargetGrid) - Familiar.Position) / 5

                HorseSprite.FlipX = Familiar.Velocity.X >= 0

            elseif HorseSprite:IsFinished("Jump") then

                HorseSprite:Play("Idle")

                Familiar.State = HorseyState.IDLE
                Familiar.FireCooldown = HORSEY_MAX_JUMP_DELAY
            end

        elseif Familiar.State == HorseyState.SLEEP then

            if not Room:IsClear() then

                Familiar.State = HorseyState.IDLE
                Familiar.FireCooldown = HORSEY_JUMP_COOLDOWN

                HorseSprite:Play("Idle")

            elseif HorseSprite:IsFinished("StartSleep") then
                HorseSprite:Play("Sleep")
            end
        end

        Familiar.FireCooldown = math.max(Familiar.FireCooldown - 1, 0)

    elseif Familiar.Variant == mod.Familiars.BLOON_PUPPY then


        Familiar.FlipX = Familiar.Velocity.X < 0

        local Grid = Game:GetRoom():GetGridEntityFromPos(Familiar.Position)

        if Familiar.State ~= PuppyState.EXPLODED
           and Grid and Grid:GetType() == GridEntityType.GRID_ROCK_SPIKED
           and Grid.State ~= 4 and Grid.State ~= 2 then --4 means a flat file-like effect is active | 2 means it's destroyed

            Familiar.State = PuppyState.EXPLODED
            Familiar:GetSprite():Play("Explode")
            Familiar.FireCooldown = PUPPY_RESPAWN_TIMER
            sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2,false,1.2)

        end

        if Familiar.State == PuppyState.IDLE then
            
            local PlayerDistance = Familiar.Position + Familiar.SpriteOffset - Familiar.Player.Position
            local DistanceLength = PlayerDistance:Length()
            local DistanceAngle = PlayerDistance:GetAngleDegrees()

            if DistanceLength > 90 then --reached maximum string length
                
                Familiar.Velocity = Familiar.Velocity*0.98 --gradually slows down

                Familiar:AddVelocity(PlayerDistance/-100 * (1+((DistanceLength-90)/50)))
                
                --Familiar.Position = Familiar.Position - PlayerDistance/(DistanceLength/4)

            elseif DistanceLength > 80 and DistanceAngle > -120 and DistanceAngle < -60 then --almost maximum length but not quite

                Familiar.Velocity = Familiar.Velocity*0.95 --gradually slows down

            else --string is loose
                Familiar.Velocity = Familiar.Velocity*0.95
                Familiar:AddVelocity(Vector(0,-0.15))
            end

        elseif Familiar.State == PuppyState.ATTACK then

            Familiar:PickEnemyTarget(350, 13, 9) --switch target + prioritize low hp

            local TargetDistance = (Familiar.Target and Familiar.Target.Position or Familiar.Player.Position) - Familiar.Position
            local Speed = Familiar.Target and 3.75 or 1.75
            local MinDistance = Familiar.Target and 10 or 25


            if TargetDistance:Length() >= MinDistance then

                Familiar.Velocity = TargetDistance:Resized(Speed)
                --Familiar:GetPathFinder():FindGridPath(Familiar.Player.Position, 0.5, 0, true)
            end

            Familiar.FireCooldown = Familiar.FireCooldown + 1

        elseif Familiar.State == PuppyState.EXPLODED then

            Familiar.FireCooldown = Familiar.FireCooldown - 1
            if Familiar.FireCooldown == 0 then

                Familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_Baloon_Puppy"..PuppyColorsSuffix[math.random(ColorSubType.NUM_COLORS)]..".png", true)

                Familiar.Position = Familiar.Player.Position
                Familiar:GetSprite():Play("Idle")

                Familiar.HitPoints = Familiar.MaxHitPoints
                Familiar.State = PuppyState.IDLE
                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, Familiar.Position, Vector.Zero, Familiar, 0, 1)
            end
        end

    elseif Familiar.Variant == mod.Familiars.TEETH then

        Familiar.FlipX = Familiar.Velocity.X < 0

        if Familiar.State == TeethStates.IDLE
           or Familiar.State == TeethStates.CHASE then

            --Familiar.FireCooldown =  math.max(Familiar.FireCooldown - 5, 0) --for tests
            
            Familiar:PickEnemyTarget(400, 13, 10)

            if Familiar.Target then

                local Speed = 1.65 + 0.4*Familiar.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DOG_TOOTH)

                Familiar:GetPathFinder():FindGridPath(Familiar.Target.Position, Speed, 0, true)

                Familiar.State = TeethStates.CHASE

            elseif (Familiar.Player.Position - Familiar.Position):Length() > 60 then

                Familiar:GetPathFinder():FindGridPath(Familiar.Player.Position, 0.9, 0, false)

                Familiar.State = TeethStates.IDLE
            else
                Familiar.State = TeethStates.IDLE
            end

            local Sprite = Familiar:GetSprite()
            local CanStop = Sprite:IsEventTriggered("CanSleep") or Sprite:IsPlaying("Idle")

            if Familiar.Velocity:Length() > 1 then
                
                Sprite:Play("Chase")

            elseif CanStop then

                Sprite:Play("Idle")
            end

            --only decrease charge if it's chasing something
            if Familiar.State == TeethStates.CHASE 
               and next(Isaac.FindInRadius(Familiar.Position, 200, EntityPartition.ENEMY)) then

                Familiar.FireCooldown =  math.max(Familiar.FireCooldown - 1, 0)
            end

            --Familiar.FireCooldown = Familiar.FireCooldown - 1
            if Familiar.FireCooldown <= 0 and CanStop then
                
                Sprite:Play("StartSleep")

                Familiar.State = TeethStates.START_SLEEP
            end

        elseif Familiar.State == TeethStates.START_SLEEP then

            local Sprite = Familiar:GetSprite()

            if Sprite:IsFinished("StartSleep") then
                
                Familiar:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
                Familiar.State = TeethStates.TIRED

            elseif Sprite:IsEventTriggered("CloseMouth") then
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
            end

        elseif Familiar.State == TeethStates.TIRED then --currently not being charged by anyone
        

            if Familiar.FireCooldown >= MIN_TEETH_CHARGE
               and (Familiar.FireCooldown >= MAX_TEETH_CHARGE
                    or not next(Isaac.FindInRadius(Familiar.Position, Familiar.Size, EntityPartition.PLAYER))) then
                
                local Sprite = Familiar:GetSprite()

                Sprite:Play("EndSleep")
                Familiar:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)

                if Sprite:IsFinished("EndSleep") then
                    
                    Sprite:Play("Idle")
                    Familiar.State = TeethStates.IDLE
                
                elseif Sprite:IsEventTriggered("OpenMouth") then

                    sfx:Play(SoundEffect.SOUND_THUMBSUP, 0.7)

                    if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID) then
                        
                        local ExtraItems = Familiar.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID)-1

                        local Laser = Familiar.Player:SpawnMawOfVoid(55 + 20*ExtraItems)
                    
                        Laser.Parent = Familiar
                        Laser:SetDisableFollowParent(false)
                        Laser:SetDamageMultiplier((0.75+0.25*ExtraItems)*Familiar:GetMultiplier())

                        Laser.Radius = 45
                    
                    end
                end
            end
        end

        if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_APPLE) then
            
            if Game:GetFrameCount() % 17 == 0 
               or Game:GetFrameCount() % 23 == 0 then
                
                local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Familiar.Position,
                                     Vector.Zero, Familiar, 0, 1):ToEffect()

                Creep.SpriteScale = Vector.One * (0.65 + math.random()*0.5*Familiar:GetMultiplier())
                Creep:Update()

                Creep.CollisionDamage = 0.65*Familiar:GetMultiplier()
            end
        end

    elseif Familiar.Variant == mod.Familiars.CERES then

        Familiar.OrbitLayer = 5074
        Familiar.OrbitDistance = Vector(110, 109.6)
        Familiar.OrbitSpeed = 0.01

        Familiar.FireCooldown = math.max(Familiar.FireCooldown - 1, 0)

        local OrbitPosition = Familiar:GetOrbitPosition(Familiar.Player.Position) + Vector(2, 0) --slight off center like the actual planet's orbit

        Familiar:AddVelocity((OrbitPosition - Familiar.Position)*0.2)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.FamiliarUpdate)


---@param Familiar EntityFamiliar
function mod:FamiliarRender(Familiar)

    if Familiar.Variant == mod.Familiars.BLOON_PUPPY then

        if Familiar.State == PuppyState.IDLE or Familiar.State == PuppyState.ATTACK then
            
            local PlayerDistance = Familiar.Position + Familiar.SpriteOffset - Familiar.Player.Position
            local DistanceLength = PlayerDistance:Length()

            local NumPoints = (DistanceLength // 50)+2
            local FamiliarScreenPos = Isaac.WorldToScreen(Familiar.Position)
            local PlayerScreenPos = mod:CoolVectorLerp(Isaac.WorldToScreen(Familiar.Player.Position), FamiliarScreenPos, Familiar.FireCooldown/35)

            local LastPoint = PlayerScreenPos
            local CurveExp = mod:CoolLerp(math.min(DistanceLength/100, 1.1), 1, Familiar.FireCooldown/20)

            if PlayerDistance.Y < 0 then
                
                for i=0, 1, 1/NumPoints do

                    local MidPoint = Vector.Zero

                    MidPoint.X = mod:ExponentLerp(PlayerScreenPos.X, FamiliarScreenPos.X, i, CurveExp)
                    MidPoint.Y = mod:ExponentLerp(PlayerScreenPos.Y, FamiliarScreenPos.Y, i, 1/CurveExp)

                    Isaac.DrawLine(LastPoint,MidPoint,KColor.Black, KColor.Black, 1)

                    LastPoint = MidPoint + Vector.Zero
                end
            else
                for i=0, 1, 1/NumPoints do

                    local MidPoint = Vector.Zero

                    MidPoint.Y = mod:ExponentLerp(PlayerScreenPos.Y, FamiliarScreenPos.Y, i, CurveExp)
                    MidPoint.X = mod:ExponentLerp(PlayerScreenPos.X, FamiliarScreenPos.X, i, 1/CurveExp)

                    Isaac.DrawLine(LastPoint,MidPoint,KColor.Black, KColor.Black, 1)

                    LastPoint = MidPoint + Vector.Zero
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, mod.FamiliarRender)



---@param Familiar EntityFamiliar
---@param Collider Entity
function mod:FamiliarCollision(Familiar, Collider,_)

    if FamiliarCollisionInterval[Familiar.Variant] 
       and Familiar.FrameCount % FamiliarCollisionInterval[Familiar.Variant] ~= 0 then --aparently the collisionInterval in entities.xml doesn't do what i think it should
        return
    end

    if Familiar.Variant == mod.Familiars.BLOON_PUPPY then

        if Familiar.State == PuppyState.EXPLODED then
            return
        end

        local Bullet = Collider:ToProjectile()
        local NPC = Collider:ToNPC()

        if Bullet and not Bullet:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
            
            Familiar:TakeDamage(1, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(Bullet), 7)
            
            if Familiar.HitPoints == 2 then --one hit away from death (take damage takes place next frame)
                
                sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2,false,1.2)
                Familiar.State = PuppyState.EXPLODED
                Familiar:GetSprite():Play("Explode")
                Familiar.FireCooldown = PUPPY_RESPAWN_TIMER

                for _, Entity in ipairs(Isaac.FindInRadius(Familiar.Position,30,EntityPartition.ENEMY|EntityPartition.BULLET)) do

                    local NPC = Entity:ToNPC()
                    local Bullet = Entity:ToProjectile()
                    if NPC then
                        NPC:TakeDamage((Familiar.Player.Damage * 3 + 2)*Familiar:GetMultiplier(), DamageFlag.DAMAGE_EXPLOSION, EntityRef(Familiar), 2)
                        NPC:AddKnockback(EntityRef(Familiar), (NPC.Position - Familiar.Position):Resized(8), 30, true)

                    elseif Bullet then

                        Bullet.Velocity = -1.5*Bullet.Velocity
                        Bullet:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES|ProjectileFlags.CANT_HIT_PLAYER)
                        Bullet.Damage = Bullet.Damage*2*Familiar:GetMultiplier()
                    end
                end
            else
---@diagnostic disable-next-line: param-type-mismatch
                Familiar:AddVelocity(Collider.Velocity/3) 
            end

            Bullet.Velocity = -Bullet.Velocity
            Bullet:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES|ProjectileFlags.CANT_HIT_PLAYER)
            Bullet.Damage = Bullet.Damage*Familiar:GetMultiplier()
            sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE, 0.9)

        elseif NPC then

            if NPC.Type == EntityType.ENTITY_SPIKEBALL
               or NPC.Type == EntityType.ENTITY_BALL_AND_CHAIN then
                
                Familiar.State = PuppyState.EXPLODED
                Familiar:GetSprite():Play("Explode")
                Familiar.FireCooldown = PUPPY_RESPAWN_TIMER
                sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2,false,1.2)
            end
        end

    elseif Familiar.Variant == mod.Familiars.TEETH then
        
        if Familiar.State == TeethStates.TIRED
           or Familiar.State == TeethStates.CHARGE then
            
            Collider = Collider:ToPlayer()

            if not Collider then
                return
            end

            local Sprite = Familiar:GetSprite()

            if Familiar.FireCooldown < MAX_TEETH_CHARGE then

                Familiar.FireCooldown = Familiar.FireCooldown + 5

                if not Sprite:IsPlaying("Charge") then
                    Sprite:Play("Charge")
                end

                Sprite:Update()

                if Familiar.FireCooldown % 40 == 0 then
                    sfx:Play(SoundEffect.SOUND_BEEP, 0.8, 2, false, 0.45 + 0.8*Familiar.FireCooldown/MAX_TEETH_CHARGE)
                end

                if Familiar.FireCooldown >= MIN_TEETH_CHARGE then

                    Familiar:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
                    Familiar.State = TeethStates.TIRED --will wake up next frame
                else
                    Familiar:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
                    Familiar.State = TeethStates.CHARGE
                end
            end

        elseif Familiar.State == TeethStates.CHASE then
            
            local Enemy = Collider:ToNPC()

            if not (Enemy and Enemy:IsVulnerableEnemy() and Enemy:IsActiveEnemy())then
                return
            end

            local AdditionalMult = 1 + 0.15*Familiar.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DOG_TOOTH)
                                     + 0.35*Familiar.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TOUGH_LOVE)

            local DamageDealt = 1.4 + 0.2*Game:GetLevel():GetAbsoluteStage()
            DamageDealt = DamageDealt * Familiar:GetMultiplier() * AdditionalMult

            --Familiar.CollisionDamage = DamageDealt

            Enemy:TakeDamage(DamageDealt, 0, EntityRef(Familiar), 0)

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_JUMPER_CABLES) then

                if Enemy:HasMortalDamage() 
                   or Enemy.HitPoints <= DamageDealt then --sometimes misses idk
                    Familiar.FireCooldown = Familiar.FireCooldown + math.min(120, math.floor(Enemy.MaxHitPoints*1.5))

                    local Effect = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, Familiar.Position + RandomVector() * 5,Vector.Zero,nil,0,1)

                    sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.35, 2, false, 1.15)
                    Familiar:SetColor(Color(1,1,0.6, 1, 0.15, 0.15, 0), 10, 10, true, false)
                end
            end

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_CHARM_VAMPIRE) then

                if Enemy:HasMortalDamage() and math.random() <= 0.33 then

                    Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, Familiar.Player.Position + RandomVector() * 5,Vector.Zero,nil,0,1)

                    sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.8)
                end
            end

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) then

                if Enemy:HasMortalDamage() and math.random() <= 0.33 then

                    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, Familiar.Player.Position + RandomVector() * 5,Vector.Zero,nil,HeartSubType.HEART_BLACK,1)

                    sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.8)
                end

                if math.random() < 0.01 then
                    
                    Enemy:AddPoison(EntityRef(Familiar), 46, DamageDealt * 2)
                end
            end

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH) then
                
                if math.random() < 0.01 then
                    
                    Enemy:AddMidasFreeze(EntityRef(Familiar), 90)
                end
            end

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_DEAD_TOOTH) then
                
                if math.random() < 0.01 then
                    Enemy:AddPoison(EntityRef(Familiar), 46, DamageDealt * 2)
                end
            end

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
                
                if math.random() < 0.01 then

                    local EffectRoll = math.random()

                    local Effect = EffectRoll//(1/8) --1/num. of effects

                    if Effect == 0 then
                        Enemy:AddBurn(EntityRef(Familiar), 23, DamageDealt)
                    elseif Effect == 1 then
                        Enemy:AddFreeze(EntityRef(Familiar), 20)
                    elseif Effect == 2 then
                        Enemy:AddCharmed(EntityRef(Familiar), 30)
                    elseif Effect == 3 then
                        Enemy:AddSlowing(EntityRef(Familiar), 30, 0.75, Color(0.6, 0.6, 0.6))
                    elseif Effect == 4 then
                        Enemy:AddIce(EntityRef(Familiar), 15)
                    elseif Effect == 5 then
                        Enemy:AddPoison(EntityRef(Familiar), 23, DamageDealt)
                    elseif Effect == 6 then
                        Enemy:AddFear(EntityRef(Familiar), 30)
                    elseif Effect == 7 then
                        Enemy:AddBaited(EntityRef(Familiar), 30)
                    end

                end
            end

            if Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) then
                
                if math.random() < 0.01 then
                    Enemy:AddBaited(EntityRef(Familiar), 60)
                end
            end
        end

    elseif Familiar.Variant == mod.Familiars.CERES then

        local Bullet = Collider:ToProjectile()
        local NPC = Collider:ToNPC()
        
        local Collided = false
        local Multiplier = Familiar:GetMultiplier()

        if Bullet and not Bullet:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then

            Collided = true

            Familiar:AddVelocity(Bullet.Velocity/1.5)
            Bullet:Kill()

        elseif NPC and NPC:IsActiveEnemy() then

            Collided = true

            if NPC:IsVulnerableEnemy() then
                NPC:TakeDamage(0.1*Multiplier, 0, EntityRef(Familiar), 2)
            end
        end

        if Familiar.FireCooldown <= 0 and Collided then
            
            local MinPieces = math.floor(Multiplier)

            local NumPieces = math.random(MinPieces, MinPieces + 2)

            local CeresRNG = Familiar.Player:GetCollectibleRNG(mod.Collectibles.CERES)

            local SpecialDropRoll = CeresRNG:RandomFloat()

            if SpecialDropRoll <= 0.001 then -- 1 in 1000 chance
            
                local ColliderAngle = math.ceil((-Collider.Velocity):GetAngleDegrees())

                local RockSpeed = Vector.FromAngle(math.random(ColliderAngle-60, ColliderAngle+60))
                RockSpeed = RockSpeed * (math.random()*2 + 2.5)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Familiar.Position,
                           RockSpeed, Familiar, TrinketType.TRINKET_LUCKY_ROCK, mod:RandomSeed(Familiar:GetDropRNG()))
            
                NumPieces = NumPieces - 1
            
            elseif SpecialDropRoll >= 0.999 then -- also 1 in 1000 chance

                local ColliderAngle = math.ceil((-Collider.Velocity):GetAngleDegrees())

                local RockSpeed = Vector.FromAngle(math.random(ColliderAngle-60, ColliderAngle+60))
                RockSpeed = RockSpeed * (math.random()*2 + 2.5)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Familiar.Position,
                           RockSpeed, Familiar, TrinketType.TRINKET_SHINY_ROCK, mod:RandomSeed(Familiar:GetDropRNG()))
            
                NumPieces = NumPieces - 1
            end

            for i = 1, NumPieces do

                --local PlayerDisctanceAngle = (Familiar.Position - Familiar.Player.Position):GetAngleDegrees()
                local ColliderAngle = math.ceil((-Collider.Velocity):GetAngleDegrees())

                local BoneSpeed = Vector.FromAngle(math.random(ColliderAngle-60, ColliderAngle+60))
                BoneSpeed = BoneSpeed * (math.random()*2.5 + 2)
            
                local Meteor = Game:Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_SPUR, Familiar.Position,
                                          BoneSpeed, Familiar, 0, mod:RandomSeed(Familiar:GetDropRNG())):ToFamiliar()

                Meteor.Player = Familiar.Player
                Meteor:GetSprite():ReplaceSpritesheet(0, CERES_PIECE_PATH, true)


                Meteor:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                Game:SpawnParticles(Familiar.Position, EffectVariant.TOOTH_PARTICLE, 5, 2, COLOR_CERES)
            end
            
            if NumPieces > 0 then
                Familiar.FireCooldown = CERES_FIRE_COOLDOWN

                sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.5, 2, false, math.random()*0.2 + 0.9)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, mod.FamiliarCollision, mod.Familiars.BLOON_PUPPY)
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, mod.FamiliarCollision, mod.Familiars.TEETH)
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, mod.FamiliarCollision, mod.Familiars.CERES)


--------------EFFECTS--------------
----------------------------------

---@param Effect EntityEffect
function mod:EffectInit(Effect)

    --print(Effect.Variant, Effect.SubType)

    if Effect.Variant == mod.Effects.CRAYON_POWDER then
        
        local Sprite = Effect:GetSprite()

        Sprite:SetFrame(math.random(0, Sprite:GetAnimationData("Idle"):GetLength()))

        Effect:SetColor(CrayonColors[Effect.SubType], -1, 2, false, true)
        
        Effect.SpriteRotation = Effect.SpawnerEntity.Velocity:GetAngleDegrees()

        Effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
        Effect:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)

    elseif Effect.Variant == mod.Effects.UMBRELLA then
        --Effect.PositionOffset = Vector(0, -1750)
        Effect:GetData().REG_SinceDrop = 100 --just a random high number
        Effect:GetData().REG_RainPitch = 1
        Effect:GetData().REG_RainVolume = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectInit)


---@param Effect EntityEffect
function mod:EffectUpdate(Effect)

    if Effect.Variant == mod.Effects.CRAYON_POWDER then
        if Effect.Timeout <= 0 then
            Effect.SpriteScale = Vector(Effect.SpriteScale.X - 0.05, Effect.SpriteScale.Y - 0.05)
            Effect.Color.A = Effect.Color.A - 0.05

            if Effect.SpriteScale.X < 0.1 then
                Effect:Remove()
            end
            return
        end

        if Effect.FrameCount % 6 ~= 0 then
            return
        end

        local PowderRef = EntityRef(Effect)
        local Player = Effect.SpawnerEntity:ToPlayer()
        local Damage = Player and Player.Damage/2 or 1

        for _,Entity in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule())) do

            ---@diagnostic disable-next-line: cast-local-type
            Entity = Entity:ToNPC()

            if Entity and Entity:IsActiveEnemy() and not Entity:IsFlying() then

                if Effect.SubType == ColorSubType.RED then

                    Entity:AddBaited(PowderRef, 20)
                    Entity:SetBaitedCountdown(20)

                elseif Effect.SubType == ColorSubType.ORANGE then

                    Entity:AddBurn(PowderRef, 23, Damage)
                    Entity:SetBurnCountdown(23)


                elseif Effect.SubType == ColorSubType.CYAN then
                
                    Entity:AddIce(PowderRef, 20)

                    Entity:AddSlowing(PowderRef, 20, 0.85, Color(1.5,1.5,1.5,1)) --PLACEHOLDER COLOR
                    Entity:SetSlowingCountdown(20)

                elseif Effect.SubType == ColorSubType.GREEN then

                    Entity:AddPoison(PowderRef, 23, Damage)
                    Entity:SetPoisonCountdown(23)


                elseif Effect.SubType == ColorSubType.WHITE then

                    Entity:AddSlowing(PowderRef, 30, 0.7, Color(1.5,1.5,1.5,1)) --PLACEHOLDER COLOR
                    Entity:SetSlowingCountdown(30)


                elseif Effect.SubType == ColorSubType.PINK then

                    Entity:AddCharmed(PowderRef, 30)
                    Entity:SetCharmedCountdown(30)

                elseif Effect.SubType == ColorSubType.PURPLE then

                    Entity:AddFear(PowderRef, 20)
                    Entity:SetFearCountdown(20)

                elseif Effect.SubType == ColorSubType.GREY then

                    Entity:AddMagnetized(PowderRef, 15)
                    Entity:SetMagnetizedCountdown(15)

                elseif Effect.SubType == ColorSubType.YELLOW then

                    local Laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC, Entity.Position, math.random(-180, 180), 2, Vector.Zero, Effect)
                    Laser.MaxDistance = math.random()*45 + 40
                    Laser.CollisionDamage = Damage
                end
            end
        end

    elseif Effect.Variant == mod.Effects.BANANA_PEEL then

        if RoomTransition:GetTransitionMode() ~= 0 then
            Effect:Remove()
            return
        end

        if Effect.State == BananaState.FLYING then

            Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

            local Data = Effect:GetData()
            
            Effect.SpriteOffset.Y = math.min(Effect.SpriteOffset.Y,0)

            if Effect.SpriteOffset.Y == 0 then
                Effect.State = BananaState.IDLE
                sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS)

                Data.REG_SpriteSpeed = nil
                Data.REG_SpriteAccel = nil

                Effect:AddVelocity(-Effect.Velocity)
                Effect:GetSprite():Play("land")

                Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
                Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
        elseif Effect.State == BananaState.SLIP then

            Effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            Effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

            if Effect:GetSprite():IsFinished("disappear") then
                Effect:Remove()
            end

        elseif Effect.State == BananaState.IDLE then

            for i,Collider in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule(), EntityPartition.ENEMY)) do
                ---@diagnostic disable-next-line: cast-local-type
                Collider = Collider:ToNPC()

                local ColliderSpeed = Collider.Velocity:Length()
                local Data = Collider:GetData()
            
                if Collider and Collider:IsActiveEnemy() and ColliderSpeed >= 0.25
                    and not Data.HasBananaSlipped then
                    
                    sfx:Play(mod.Sounds.SLIP, 0.55)
                    Effect.State = BananaState.SLIP
                    Effect:AddVelocity(Collider.Velocity * 3)
                    Effect:GetSprite():Play("disappear")

                    Collider:AddConfusion(EntityRef(Effect), 90, false)
                    Data.HasBananaSlipped = EntityRef(Effect)
                    Data.BananaSlipSpeed = -2*ColliderSpeed
                    Data.BananaSlipAcceleration = ColliderSpeed / 9

                    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) then
                        mod:LaughSignEffect(LaughEffectType.LAUGH)
                    end

                    break
                end
            end
        end

    elseif Effect.Variant == mod.Effects.ANVIL then

        local Data = Effect:GetData()

        --for whaterver reason shadows can be rendered only if an effect has 2 or more as the timeout(??)
        --alr also works if it's less than 0 but still wtf
        Effect:SetTimeout(math.max(Effect.Timeout, 2))

        if Effect.State == AnvilStates.FALLING then
            
            if Effect.Timeout <= 2 then
                Effect.IsFollowing = false
                Effect.Velocity = Vector.Zero
            else
                Effect.IsFollowing = true
            end

            local AnvilCapsule = mod:CreateCapsule(Effect.Position, Effect.Size, Effect.SizeMulti)
            AnvilCapsule.Position = AnvilCapsule.Position + Isaac.ScreenToWorldDistance(Effect.SpriteOffset)
            AnvilCapsule.Position.Y = AnvilCapsule.Position.Y


            for _,Umbrella in ipairs(Isaac.FindInCapsule(Effect:GetCollisionCapsule(), EntityPartition.EFFECT)) do

                if Umbrella.Variant ~= mod.Effects.UMBRELLA then
                    goto CONTINUE
                end

                local UmbrellaCapsule = mod:CreateCapsule(Umbrella.Position + Vector(0, UMBRELLA_HEIGHT*Umbrella.SizeMulti.Y), 
                                                          Umbrella.Size, 
                                                          Umbrella.SizeMulti)
                
                --UmbrellaCapsule.Position = UmbrellaCapsule.Position + Isaac.ScreenToWorldDistance(Umbrella.SpriteOffset)
                --UmbrellaCapsule.Position = UmbrellaCapsule.Position + Vector(0, UMBRELLA_HEIGHT) WHY TF DOESN?T THIS MOVE THE HITBOX DUDE

                Isaac.FindInRadius(UmbrellaCapsule.Position, 20)
                Isaac.FindInRadius(AnvilCapsule.Position, 20)

                if mod:TryCollision(UmbrellaCapsule, AnvilCapsule) then--mod:TryCollision(UmbrellaCapsule, AnvilCapsule) then
                
                    Umbrella:GetSprite():Play("Bounce", true)
                    sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE)

                    local Enemies = Isaac.FindInRadius(Effect.Position, 240, EntityPartition.ENEMY)

                    Data.REG_SpriteSpeed = Vector(0,-6 - math.random()*4)
                    Data.REG_SpriteAccel = Vector(0,0.75 + math.random()*0.5)

                    if next(Enemies) then
                        local Target = mod:GetRandom(Enemies)

                        local FlightTime = ((Data.Reg_SpriteSpeed.Y^2 + 2*Data.REG_SpriteAccel.Y*Effect.SpriteOffset.Y)^0.5 - Data.Reg_SpriteSpeed.Y)*2/Data.REG_SpriteAccel.Y

                        Effect.Velocity = (Target.Position + Target.Velocity - Effect.Position)/FlightTime

                    else
                        Effect.Velocity = RandomVector() * (math.random()*5 + 2)
                    end

                    Effect.State = AnvilStates.REFLECTED
                    return
                end

                ::CONTINUE::
            end

            if Effect.SpriteOffset.Y < 0 then
                return
            end
            
            local Room = Game:GetRoom()
            local AnvilGridIndex = Room:GetGridIndex(Effect.Position)

            local Grid = Room:GetGridEntityFromPos(Effect.Position)
            local FellOnWater = Room:GetWaterAmount() >= 0.2
            local FellInPit = Grid and Grid:ToPit()


            Game:MakeShockwave(Effect.Position, 0.025, 0.02, 10)

            if not FellInPit then --fell on ground/rock

                if Grid then

                    Grid:Destroy(true)
                    Room:RemoveGridEntityImmediate(AnvilGridIndex, 1, false)
                end

                if mod:CanTileBeBlocked(AnvilGridIndex) then
                    local Pit = Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, Effect.Position)

                    if Pit then
                        Pit = Pit:ToPit()

                        Pit:UpdateCollision()
                    end
                end
                

                local Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Effect.Position,
                                         Vector.Zero, nil, 0, 1):ToEffect()

                Shock:SetRadii(10,25)

                Isaac.CreateTimer(function ()
                    Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Effect.Position,
                                       Vector.Zero, nil, 0, 1):ToEffect()

                    Shock:SetRadii(35,75)
                end, 10, 1, false)
                    
                --Shock.Parent = Effect.SpawnerEntity
            end

            if FellOnWater then

                Effect:SpawnWaterImpactEffects(Effect.Position, Vector.One, 100)

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, Effect.Position,
                           Vector.Zero, nil, 0, 1)
                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1,2,false, 0.9 + math.random()*0.1)

                for i=1, math.random(5,10) do

                    local Tear = Game:Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, Effect.Position,
                                            RandomVector()* (4.5 + math.random()*2.5), nil, 0, math.max(1, Random())):ToTear()

                    Tear.FallingSpeed = - (10 + math.random()*20)
                    Tear.FallingAcceleration = 1.5 + math.random()*1.5

                    Tear.Scale = 0.7 + math.random()*0.25
                end
            else
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 0.8)
                local Dust = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, Effect.Position,
                                RandomVector(), nil,0, math.max(1, Random())):ToEffect()
                Dust.SpriteScale = Vector(1.25, 1.25)
                Dust:SetTimeout(20)
            end

            Effect:Remove()

        elseif Effect.State == AnvilStates.REFLECTED then

            Effect.SpriteRotation = Effect.SpriteRotation + (Effect.Velocity.X > 0 and 10 or -10)
            local Room = Game:GetRoom()
            local Grid = Room:GetGridEntityFromPos(Effect.Position)


            if Effect.SpriteOffset.Y < 0
               and not (Grid and Grid:GetType() == GridEntityType.GRID_WALL) then --break stuff when touching a wall or when landing
                return
            end


            local FellOnWater = Room:GetWaterAmount() >= 0.2

            if FellOnWater then
                Effect:SpawnWaterImpactEffects(Effect.Position, Vector.One, 100)

                Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, Effect.Position,
                           Vector.Zero, nil, 0, 1)
                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1,2,false, 0.9 + math.random()*0.1)

            else
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 0.8)

                local Dust = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, Effect.Position,
                                RandomVector(), nil,0, math.max(1, Random())):ToEffect()
                Dust.SpriteScale = Vector(1.25, 1.25)
                Dust:SetTimeout(20)
            end

            local Shock = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, Effect.Position,
                                         Vector.Zero, nil, 0, 1):ToEffect()

            Shock:SetRadii(10,35)
            Shock.Parent = Game:GetPlayer(0)

            Effect:Remove()
        end

    elseif Effect.Variant == mod.Effects.UMBRELLA then

        local Sprite = Effect:GetSprite()

        if not Sprite:IsPlaying("Retreat") then

            local UmbrellaData = Effect:GetData()

            local AnvilSpawnFrame = UmbrellaData.REG_AnvilFrame or 0
            
            if Effect.FrameCount >= AnvilSpawnFrame then
                
                local Anvil = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.ANVIL, Effect.Position, 
                                         Vector.Zero, Effect.Parent, 0, 1):ToEffect()

                Anvil:FollowParent(Effect.Parent)
                Anvil:SetTimeout(ANVIL_FOLLOW_TIME) --will follow the player for this many frames

                Anvil.State = AnvilStates.FALLING
                Anvil.SpriteOffset = Vector(0, ANVIL_START_HEIGHT)

                local Data = Anvil:GetData()
                Data.REG_SpriteSpeed = Vector(0, 15)


                UmbrellaData.REG_AnvilFrame = AnvilSpawnFrame + math.random(90, 150)+60*Effect.SubType


                local Player = Effect.Parent and Effect.Parent:ToPlayer() or nil

                for i=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
                    
                    if Player:GetActiveItem(i) == mod.Collectibles.UMBRELLA then
                        Player:AddActiveCharge(1, i, true, false, true)
                    end
                end

                if Player and Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then

                    Player:AddWisp(mod.Collectibles.UMBRELLA, Effect.Position)
                end
            end

            -----COOL RAINDROP SOUND------

            local UmbrellaHeight = UMBRELLA_HEIGHT*Effect.SizeMulti.Y

            local CloseDistance = Effect.Size*Effect.SizeMulti.X + 7
            local FarDistance = CloseDistance + 20

            local CloseDrops = 0
            local FarDrops = 0

            for _,Rain in ipairs(Isaac.FindByType(1000, EffectVariant.RAIN_DROP)) do

                local Distance = Rain.Position:Distance(Effect.Position)

                if Distance <= CloseDistance then

                    CloseDrops = CloseDrops + 1

                    local Height = 260 -26.5*Rain:GetSprite():GetFrame()

                    if Height <= UmbrellaHeight then
                        Rain:Remove()
                    end

                elseif Distance <= FarDistance then

                    FarDrops = FarDrops + 1
                end
            end

            
            local Volume = 0.4 + 0.08*CloseDrops
            local Pitch = math.min(0.8 + 0.05*UmbrellaData.REG_SinceDrop, 1)

            if CloseDrops == 0 then
                Volume = math.min(0.2 + 0.05*FarDrops, Volume)
            end

            if sfx:IsPlaying(mod.Sounds.UMBRELLA_RAIN) then

                if FarDrops == 0 then
                    
                    sfx:Stop(mod.Sounds.UMBRELLA_RAIN)
                else
                    sfx:AdjustVolume(mod.Sounds.UMBRELLA_RAIN, Volume)
                    sfx:AdjustPitch(mod.Sounds.UMBRELLA_RAIN, Pitch)
                end

            elseif CloseDrops ~= 0 then
                --sfx:SetAmbientSound(mod.Sounds.UMBRELLA_RAIN, Volume, Pitch)
                sfx:Play(mod.Sounds.UMBRELLA_RAIN, Volume, 0, true, Pitch)
            end
        end

        if Sprite:IsEventTriggered("open") then
            
            sfx:Play(SoundEffect.SOUND_GOOATTACH0)
        elseif Sprite:IsFinished("Retreat") then
            Effect:Remove()
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.EffectUpdate)

---@param Effect EntityEffect
local function EffectRender(_,Effect)

    if Effect.Variant == mod.Effects.TOMATO then

        local Data = Effect:GetData()
        if not Data.LaughingSpawn then --already landed

            local AnimIdx = Effect.State % (TomatoAnimations.NUM_VARIANTS + 1)

            if Effect.FrameCount == 150 then
                Effect:GetSprite():Play("Disappear"..tostring(AnimIdx))
            elseif Effect:GetSprite():IsFinished("Disappear"..tostring(AnimIdx)) then

                Effect:Remove()
                return
            end
            return
        end

        if Effect.SpriteScale.Y == 1 then --just landed

            Data.RenderFrames = nil
            Data.LaughingSpawn = nil
            Data.StartThrowOffset = nil
            Data.StartThrowRotation = nil
            Data.TargetThrowRotation = nil
            Effect.DepthOffset = 0
            Effect.SpriteRotation = 0

            local Sprite = Effect:GetSprite()
            local AnimIdx = Effect.State % (TomatoAnimations.NUM_VARIANTS+1)
            Effect.State = TomatoState.SPLAT + AnimIdx
            Sprite:Play("Splat"..tostring(AnimIdx))

            sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS)
            Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, Effect.Position,
                       RandomVector()*3,Effect,0,1)



            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Effect.Position, 
                                     Vector.Zero, Effect, 0, math.max(Random(),1)):ToEffect()
            Creep.CollisionDamage = Effect.SpawnerEntity:ToPlayer().Damage/4 or 0.5
            Creep.SpriteScale = Vector.One * (2 + math.random()*1.5)
            Creep.Timeout = 600
            Creep:Update()

            for _,Enemy in ipairs(Isaac.FindInRadius(Effect.Position, 35, EntityPartition.ENEMY)) do

                Enemy:AddBaited(EntityRef(Effect), 120)
            end
        else

            Data.RenderFrames = Data.RenderFrames + 1

            Effect.SpriteOffset.Y = mod:ExponentLerp(Data.StartThrowOffset.Y, 0, Data.RenderFrames/300, 0.95)
            Effect.SpriteOffset.X = mod:Lerp(Data.StartThrowOffset.X, 0, Data.RenderFrames/900)

            Effect.SpriteScale = Vector.One * mod:ExponentLerp(2.25, 1, Data.RenderFrames/75, 2.5)
            Effect.SpriteRotation = mod:ExponentLerp(Data.StartThrowRotation, Data.TargetThrowRotation, Data.RenderFrames/75, 0.9)
        end

    elseif Effect.Variant == mod.Effects.ANVIL then

        Effect:SetShadowSize(mod:ExponentLerp(0.25, 0.8, Effect.SpriteOffset.Y/ANVIL_START_HEIGHT, 2))
        Effect:RenderShadowLayer(Vector.Zero)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, EffectRender)

-------------PICKUPS---------------
-----------------------------------


---@param Pickup EntityPickup
---@param Player Entity
local function PickupCollision(_, Pickup, Player)

    Player = Player:ToPlayer()

    if not Player then
        return
    end

    if Pickup.Variant == mod.Pickups.LOLLYPOP then
        
        if Player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
            Player = Player:GetOtherTwin()
        end

        local Effects = Player:GetEffects()
        Effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_GAMEKID, true, 1)
        Effects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_GAMEKID).Cooldown = 165

        Pickup:GetSprite():Play("Collect")
        Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(mod.Sounds.EAT, 1, 10, false, 0.95 + math.random()*0.1)
        Pickup.Velocity = Vector.Zero
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PickupCollision)


---@param Pickup EntityPickup
local function PickupUpdate(_, Pickup)

    if Pickup.Variant == mod.Pickups.LOLLYPOP then

        local Sprite = Pickup:GetSprite()

        if Sprite:IsEventTriggered("DropSound") then

            sfx:Play(SoundEffect.SOUND_SCAMPER)

        elseif Sprite:IsPlaying("Collect") then
            Pickup.Velocity = Vector.Zero
            Pickup:SetShadowSize(0)

        elseif Sprite:IsFinished("Collect") then
            Pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PickupUpdate)

----------ITEM EFFECTS---------
-------------------------------


local function OnNewRoom()

    if not mod.GameStarted then
        return
    end
    local Room = Game:GetRoom()

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        local PIndex = Player:GetData().TruePlayerIndex

        if Player:HasCollectible(mod.Collectibles.CRAYONS) then
            
            local RandomColor
            local Data = Player:GetData()
            repeat
                RandomColor = math.random(ColorSubType.NUM_COLORS)

            until not Data.CrayonColor or RandomColor ~= Data.CrayonColor

            Player:GetData().CrayonColor = RandomColor
        end
        if Player:HasCollectible(mod.Collectibles.BALOON_PUPPY) then

            for _, Puppy in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.BLOON_PUPPY)) do

                if Puppy.State ~= PuppyState.EXPLODED then
                    Puppy = Puppy:ToFamiliar()
                    Puppy.State = PuppyState.IDLE
                    Puppy.FireCooldown = 0
                end
            end
        end
    end

    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) and Room:IsFirstVisit() and Room:GetType() == RoomType.ROOM_TREASURE then
        mod:LaughSignEffect(LaughEffectType.GASP, PlayerManager.FirstCollectibleOwner(mod.Collectibles.LAUGH_SIGN))
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnNewRoom)


function mod:ChooseRoomCrayonColor2(Type,_,_,_,_, Player)
    if Type == mod.Collectibles.CRAYONS then

        local RandomColor
        local Data = Player:GetData()
        repeat
            RandomColor = math.random(ColorSubType.NUM_COLORS)

        until not Data.CrayonColor or RandomColor ~= Data.CrayonColor

        Player:GetData().CrayonColor = RandomColor
        return
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.ChooseRoomCrayonColor2)


local function IsPlayersUmbrella(Player, Umbrella)

    local Player2 = Umbrella.Parent and Umbrella.Parent:ToPlayer() or nil

    return GetPtrHash(Player) == GetPtrHash(Player2)
end


---@param Player EntityPlayer
---@param Rng RNG
function mod:ActiveUse(Item, Rng, Player, Flags, Slot, VarData)

    local ReturnTable = {Discharge = true,
                         Remove = false,
                         ShowAnim = false}
                         
    if Item == mod.Collectibles.BANANA then

        if Player:GetItemState() == mod.Collectibles.BANANA then

            Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)
            Player:AnimateCollectible(mod.Collectibles.BANANA, "HideItem")
        else

            Player:SetItemState(mod.Collectibles.BANANA)
            Player:AnimateCollectible(mod.Collectibles.BANANA, "LiftItem")
        end

        ReturnTable.Discharge = false
        return ReturnTable

    elseif Item == mod.Collectibles.EMPTY_BANANA then

        local BananaSpeed = RandomVector()*(math.random() + 2)

        local Banan = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BANANA_PEEL, Player.Position,
                   BananaSpeed + Player:GetTearMovementInheritance(BananaSpeed), Player, 0, mod:RandomSeed()):ToEffect()
        
        sfx:Play(SoundEffect.SOUND_SUMMON_POOF)

        Banan:GetSprite():Play("throw")

        local Data = Banan:GetData()

        Banan.State = BananaState.FLYING

        Data.REG_SpriteSpeed = Vector(0,-math.random()*10 - 6)
        Data.REG_SpriteAccel = 1 or math.random()*1.5 + 1

        --local RotOffset = (Game:GetFrameCount()%360)/360

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            
            for i=1, 2 do
                
                local Wisp = Player:AddWisp(mod.Collectibles.EMPTY_BANANA, Banan.Position)

                ---@diagnostic disable-next-line: assign-type-mismatch
                Wisp.Parent = Banan

                Wisp:AddToOrbit(7094)
                --Wisp.OrbitAngleOffset = RotOffset + 0.5*i
            end
        end

    elseif Item == mod.Collectibles.UMBRELLA then

        local TrueVar 
        if Slot ~= -1 then
            TrueVar = Player:GetActiveItemDesc(Slot).VarData --idk Callback's value is always 0
        end

        if not TrueVar 
           or TrueVar == UMBRELLA_VAR.CLOSED then

            local NumUmbrellas = 0

            for UmbSlot=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do

                if Player:GetActiveItem(UmbSlot) == mod.Collectibles.UMBRELLA then
                    Player:SetActiveVarData(UMBRELLA_VAR.OPENED, UmbSlot)
                    Player:DischargeActiveItem(UmbSlot)

                    NumUmbrellas = NumUmbrellas + 1
                end
            end

            if Flags & UseFlag.USE_CARBATTERY ~= 0 then
                NumUmbrellas = NumUmbrellas *2
            end

            for i = 1, NumUmbrellas do

                Isaac.CreateTimer(function ()

                    local Umbrella = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.UMBRELLA, Player.Position, 
                                                Vector.Zero, Player, i, 1):ToEffect()

                    local SizeMult = 1.3^(i-1)


                    Umbrella.SpriteScale = Player.SpriteScale*SizeMult
                    Umbrella.DepthOffset = 10 + i
                    
                    Umbrella.Parent = Player
                    Umbrella:FollowParent(Player)

                    Umbrella:SetSize(Umbrella.Size, Umbrella.SizeMulti*SizeMult, 12)

                    if Flags & UseFlag.USE_MIMIC == 0 then
                        Umbrella:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                    end

                    if i == NumUmbrellas then
                        Umbrella.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                    end
                end, 10*(i-1), 1, Flags & UseFlag.USE_MIMIC ~= 0)
            end

        elseif TrueVar == UMBRELLA_VAR.OPENED then

            for UmbSlot=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do

                if Player:GetActiveItem(UmbSlot) == mod.Collectibles.UMBRELLA then
                    Player:SetActiveVarData(UMBRELLA_VAR.CLOSED, UmbSlot)
                    Player:DischargeActiveItem(UmbSlot)
                end
            end

            local MaxSubType = 0
            local Umbrellas = {}

            for _,Umbrella in ipairs(Isaac.FindByType(1000, mod.Effects.UMBRELLA)) do

                if IsPlayersUmbrella(Player, Umbrella) then

                    MaxSubType = math.max(MaxSubType, Umbrella.SubType)
                    Umbrellas[#Umbrellas+1] = Umbrella
                end
            end

            for _, Umbrella in ipairs(Umbrellas) do

                Isaac.CreateTimer(function ()
                    Umbrella:GetSprite():Play("Retreat")
                end, 10*(MaxSubType - Umbrella.SubType), 1, true)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ActiveUse)


---@param Player EntityPlayer
local function OnPlayerUpdate(_,Player)

    local ShootDirection = Player:GetShootingInput()

    if Player:GetItemState() == mod.Collectibles.BANANA
       and ShootDirection:Length() > 0 then

        
        Player:AnimateCollectible(mod.Collectibles.BANANA, "HideItem")
        Player:SetItemState(CollectibleType.COLLECTIBLE_NULL)

        Player:AddCollectible(mod.Collectibles.EMPTY_BANANA, 0, true, Player:GetActiveItemSlot(mod.Collectibles.BANANA))
        Player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY)
        --Player:DischargeActiveItem() this would also activate book of virtuef
        
        local Tear = Game:Spawn(EntityType.ENTITY_TEAR, mod.Tears.BANANA_VARIANT, Player.Position, ShootDirection*Player.ShotSpeed*2.75, Player, 0, 1):ToTear()
        Tear.Parent = Player

        Tear.CanTriggerStreakEnd = false

        sfx:Play(SoundEffect.SOUND_PLOP)
        Tear.CollisionDamage = 0
        Tear.FallingAcceleration = 0

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then

            for i=1, 8 do
                Player:AddWisp(mod.Collectibles.BANANA, Player.Position, true)
            end
        end

    end


    if Player:HasCollectible(mod.Collectibles.CLOWN) then
        
        local TotalModule = 4

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_BOZO) then
            TotalModule = 2
        end


        for _,Enemy in ipairs(Isaac.FindInRadius(Player.Position, CLOWN_RANGE, EntityPartition.ENEMY)) do
            
            if Enemy:IsVulnerableEnemy()
               and Enemy:IsActiveEnemy() then
                
                local FakeRoll = Enemy.InitSeed%TotalModule

                if FakeRoll == 0 then
                    
                    Enemy:AddCharmed(EntityRef(Player), 65)
                    --Enemy:SetCharmedCountdown(math.min(Enemy:GetCharmedCountdown(), 120))

                elseif FakeRoll == 1 then
                    
                    Enemy:AddFear(EntityRef(Player), 65)
                    --Enemy:SetFearCountdown(math.min(Enemy:GetFearCountdown(), 120))
                end
            end
        end

    end

    if Player:HasCollectible(mod.Collectibles.CRAYONS) then
        
        if Player.Velocity:Length() > 0.25 and Player.FrameCount % math.floor(3/Player.MoveSpeed) == 0 then
 
            local Powder = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.CRAYON_POWDER,
                                      Player.Position, Vector.Zero, Player, Player:GetData().CrayonColor or 1, 1):ToEffect()

            Powder:SetTimeout(100)
        end
    end


    if Player:HasCollectible(mod.Collectibles.LOLLYPOP) then

        if Game:GetRoom():IsClear() then
            return
        end

        local Data = Player:GetData()

        --if Player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_GAMEKID) > 0 then --timer advances only while vulnerable
        --    return
        --end

        Data.REG_LollypopCD = Data.REG_LollypopCD and (Data.REG_LollypopCD - 1) or MAX_LOLLYPOP_COOLDOWN

        if Data.REG_LollypopCD <= 0 then

            local LollypopNum = 0
            for _, _ in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.Pickups.LOLLYPOP)) do
                LollypopNum = LollypopNum + 1
            end

            if LollypopNum >= 3 then
                return
            end

            local Pos = Game:GetRoom():GetRandomPosition(20)

            Game:Spawn(EntityType.ENTITY_PICKUP, mod.Pickups.LOLLYPOP, Pos, Vector.Zero,
                       nil, LollypopPicker:PickOutcome(Player:GetCollectibleRNG(mod.Collectibles.LOLLYPOP)), math.max(Random(), 1))

            Data.REG_LollypopCD = MAX_LOLLYPOP_COOLDOWN
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, OnPlayerUpdate)


local function OnUpdate()

    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) then
        
        if math.random() <= 0.00001 then
            mod:LaughSignEffect(LaughEffectType.RANDOM)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, OnUpdate)


local function OnStageTransition()
    if PlayerManager.AnyoneHasCollectible(mod.Collectibles.LAUGH_SIGN) then
        
        mod:LaughSignEffect(LaughEffectType.TRANSITION)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY_JINGLE, OnStageTransition, Music.MUSIC_JINGLE_NIGHTMARE)



---@param Tear EntityTear
function mod:BananaInfiniteRange(Tear)

    if Tear.Variant == mod.Tears.BANANA_VARIANT then
        Tear.FallingSpeed = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.BananaInfiniteRange)


---@param Tear EntityTear
function mod:BananaExplosion(Tear)

    if Tear.Variant == mod.Tears.BANANA_VARIANT then
        
        Game:GetRoom():MamaMegaExplosion(Tear.Position)

        Isaac.CreateTimer(function ()
            for _, Cloud in ipairs(Isaac.FindByType(1000, EffectVariant.DUST_CLOUD)) do

                Cloud:SetColor(CrayonColors[ColorSubType.YELLOW], -1, 1, true, true)
            end
        end,5,1, false)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.BananaExplosion)


function mod:ResetBananaCharge()

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        for Slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do    
            local Item = Player:GetActiveItem(Slot)

            if Item == mod.Collectibles.EMPTY_BANANA then
                
                Player:AnimateCollectible(mod.Collectibles.BANANA, "UseItem")
                Player:AddCollectible(mod.Collectibles.BANANA, 1, true, Slot)
                sfx:Play(SoundEffect.SOUND_BEEP)
            end
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetBananaCharge)


---@param Entity Entity
function mod:EntityBananaSlip(Entity)

    local Data = Entity:GetData()

    if not Data.HasBananaSlipped then
        return
    end

    Entity.SpriteRotation = Entity.SpriteRotation + 30
    Entity.SpriteOffset.Y = Entity.SpriteOffset.Y + Data.BananaSlipSpeed
    Data.BananaSlipSpeed = Data.BananaSlipSpeed + Data.BananaSlipAcceleration

    if Entity.SpriteOffset.Y >= 0 then
        
        Entity.SpriteRotation = 0
        Entity.SpriteOffset.Y = 0

        Entity:TakeDamage(2.5*Data.BananaSlipSpeed, DamageFlag.DAMAGE_CRUSH, Data.HasBananaSlipped, 1)

        if Entity:HasMortalDamage() then
            Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
        end

        Data.BananaSlipSpeed = nil
        Data.HasBananaSlipped = nil
        Data.BananaSlipAcceleration = nil
    end
    
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.EntityBananaSlip)

---@param Entity Entity
local function OnPlayerTakeDamage(_,Entity)
    
    local Player = Entity:ToPlayer()

    if not Player then
        return
    end

    if Player:HasCollectible(mod.Collectibles.BALOON_PUPPY) then
        
        for _, Puppy in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.Familiars.BLOON_PUPPY)) do

            Puppy = Puppy:ToFamiliar()
            if Puppy.State == PuppyState.IDLE and Player:GetPlayerIndex() == Puppy.Player:GetPlayerIndex() then
                Puppy = Puppy:ToFamiliar()
                Puppy.State = PuppyState.ATTACK
                Puppy.FireCooldown = 0 --used as a timer for how long it has been attacking
            end
        end
    end
    if Player:HasCollectible(mod.Collectibles.LAUGH_SIGN) then

        mod:LaughSignEffect(LaughEffectType.BAD, Player)

    end
    if Player:HasCollectible(mod.Collectibles.CLOWN) then

        sfx:Play(mod.Sounds.CLOWN_HONK,1,2,false, 0.75 + math.random()*0.5)
        Isaac.CreateTimer(function ()
            sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
        end,0,1, true)

        --[[
        for _, Enemy in ipairs(Isaac.GetRoomEntities()) do
            
            Enemy = Enemy:ToNPC()
            if Enemy and Enemy:IsActiveEnemy() then
                
                local ClownRNG = Player:GetCollectibleRNG(mod.Collectibles.CLOWN)
                local EffectRoll = ClownRNG:RandomFloat()

                if EffectRoll <= 0.33 then
                    Enemy:AddFear(EntityRef(Player), 100)

                elseif EffectRoll >= 0.66 then
                    Enemy:AddCharmed(EntityRef(Player), 100)

                end
            end
        end]]
    end

end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, OnPlayerTakeDamage, EntityType.ENTITY_PLAYER)


---@param Player EntityPlayer
local function OnRoomClear(_, Player)

    local Type = Game:GetRoom():GetType()
    if Type == RoomType.ROOM_BOSS or Type == RoomType.ROOM_MINIBOSS then

        for _,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:HasCollectible(mod.Collectibles.LAUGH_SIGN) then

                mod:LaughSignEffect(LaughEffectType.GOOD, Player)
            end
        end
    end

    local PIndex = Player:GetData().TruePlayerIndex

    if Player:HasCollectible(mod.Collectibles.TRAGICOMEDY) then


        ---@diagnostic disable-next-line: param-type-mismatch
        Player:AddCacheFlags(TragicomedyCaches)
        Player:TryRemoveNullCostume(MaskCostume[mod.Saved.Player[PIndex].ComedicState])
        mod.Saved.Player[PIndex].ComedicState = ComedicState.NONE
        

        if Player:GetPlayerType() == mod.Characters.JimboType and mod:JimboHasTrinket(Player, mod.Jokers.SOCK_BUSKIN)
           or Player:HasTrinket(mod.Jokers.SOCK_BUSKIN) 
           or Player:HasCollectible(CollectibleType.COLLECTIBLE_DUALITY) then --set both tragic and comedy

            mod.Saved.Player[PIndex].ComedicState = ComedicState.TRAGICOMEDY + 0

        else

            local MaskRNG = Player:GetCollectibleRNG(mod.Collectibles.TRAGICOMEDY)
            local ComedicChance = MaskRNG:RandomFloat()

            if ComedicChance <= 0.4 
               or Player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID)
               or Player:HasCollectible(CollectibleType.COLLECTIBLE_SOCKS) then
                mod.Saved.Player[PIndex].ComedicState = mod.Saved.Player[PIndex].ComedicState + ComedicState.COMEDY

            end

            ComedicChance = MaskRNG:RandomFloat()

            if ComedicChance <= 0.4 or Player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
                mod.Saved.Player[PIndex].ComedicState = mod.Saved.Player[PIndex].ComedicState + ComedicState.TRAGEDY

            end

            Player:AddNullCostume(MaskCostume[mod.Saved.Player[PIndex].ComedicState])
        end

        Player:EvaluateItems()

    else --does not have tragicomedy
    
        Player:TryRemoveNullCostume(MaskCostume[mod.Saved.Player[PIndex].ComedicState])
        mod.Saved.Player[PIndex].ComedicState = ComedicState.NONE

    end


    local PlanetX_Items = mod.Saved.Player[PIndex].InnateItems.Planet_X

    for _, Item in ipairs(PlanetX_Items) do

        Player:AddInnateCollectible(Item, -1)
        Player:RemoveCostume(ItemsConfig:GetCollectible(Item))
    end

    mod.Saved.Player[PIndex].InnateItems.Planet_X = {}

    for i = 1, Player:GetCollectibleNum(mod.Collectibles.PLANET_X) do

        local PickedItem = PLANET_X_PICKER:PickOutcome(Player:GetCollectibleRNG(mod.Collectibles.PLANET_X))
        
        PlanetX_Items[i] = PickedItem

        Player:AddInnateCollectible(PickedItem, 1)
        mod.Saved.Player[PIndex].InnateItems.Planet_X[i] = PickedItem
    end
    


    for i = 0, Player:GetMaxTrinkets() - 1 do

        local HeldTrinket = Player:GetTrinket(i)

        local TrueTrinket = HeldTrinket & ~TrinketType.TRINKET_GOLDEN_FLAG
        
        if mod:Contained(mod.Trinkets.TASTY_CANDY, TrueTrinket) and TrueTrinket ~= HeldTrinket then
            
            local NewCandy = HeldTrinket + 1

            if mod:Contained(mod.Trinkets.TASTY_CANDY, NewCandy & ~TrinketType.TRINKET_GOLDEN_FLAG) then
                
                Player:TryRemoveTrinket(HeldTrinket)
                Player:AddTrinket(NewCandy)
            end
        end
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, OnRoomClear)


---@param Player EntityPlayer?
function mod:LaughSignEffect(Type, Player)

    if Type == LaughEffectType.BAD then --throw tomatoes randomly in the room
    
        sfx:Play(mod.Sounds.BOO, 1, 120, false, math.random()*0.1 + 0.95)

        local Timer = 10
        for i=1, 5 + Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO)*2 do
            
            Isaac.CreateTimer(function ()

                local Tomato = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.TOMATO, 
                                          Isaac.GetRandomPosition(), Vector.Zero, Player, 0, 1):ToEffect()

                local Data = Tomato:GetData()
                Data.LaughingSpawn = true
                Data.RenderFrames = 0

                local RandomAnimIdx = math.random(1, TomatoAnimations.NUM_VARIANTS)

                Tomato:GetSprite():Play("Idle"..tostring(RandomAnimIdx))
                Tomato.State = TomatoState.THROW + RandomAnimIdx


                --starts from off screen
                Tomato.SpriteOffset = Vector(math.random(-110, 110),Isaac.GetScreenHeight() - Isaac.WorldToScreen(Tomato.Position).Y + 40)
                Tomato.SpriteScale = Vector.One * 2.25
                Data.StartThrowOffset = Tomato.SpriteOffset
                Data.StartThrowRotation = math.random()*-360 - 360
                Data.TargetThrowRotation = RandomAnimIdx == 1 and -45 or 45 --replace this with a table if more animations appear(not gonna happen)

                Tomato.DepthOffset = 1000

            end, Timer, 1, true)

            Timer = Timer + math.random(10,35)
        end

    elseif Type == LaughEffectType.GOOD then --throw pickups at player

        sfx:Play(mod.Sounds.APPLAUSE, 1, 120, false, math.random()*0.1 + 0.95)
        local Timer = 10
        local Room = Game:GetRoom()
        for i=1, 5 do
            
            Isaac.CreateTimer(function ()

                local Pickup = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 
                                          Room:FindFreePickupSpawnPosition(Player.Position, 100), Vector.Zero, Player,
                                          NullPickupSubType.NO_COLLECTIBLE_CHEST, math.max(Random(),1))

                local Data = Pickup:GetData()
                Data.LaughingSpawn = true
                Data.RenderFrames = 0

                --starts from off screen
                Pickup.SpriteOffset = Vector(math.random(-110, 110),Isaac.GetScreenHeight() - Isaac.WorldToScreen(Pickup.Position).Y + 40)
                Pickup.SpriteScale = Vector.One * 2.25
                Data.StartThrowOffset = Pickup.SpriteOffset
                Data.StartThrowRotation = math.random()*-360 - 360
                Pickup.DepthOffset = 1000


                Pickup:GetSprite():Play("Idle")

            end, Timer, 1, true)

            Timer = Timer + math.random(10,30)
        end

    elseif Type == LaughEffectType.GASP then

        sfx:Play(mod.Sounds.GASP, 1, 120)

    elseif Type == LaughEffectType.LAUGH then
        sfx:Play(mod.Sounds.LAUGH, 1, 120)

    elseif Type == LaughEffectType.RANDOM then
        sfx:Play(mod.Sounds.RANDOM_CROWD, 1, 300, false, math.random()*0.1 + 0.95)

    elseif Type == LaughEffectType.TRANSITION then
        sfx:Play(mod.Sounds.CROWD_TRANSITION, 1, 2, false, math.random()*0.1 + 0.95)
    
    end

end


local function WaitForPickupLanding(_, Pickup, Collider)

    local Data = Pickup:GetData()

    if Data.LaughingSpawn then
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, WaitForPickupLanding)


---@param Pickup EntityPickup
local function PickupThrowParabola(_, Pickup)

    local Data = Pickup:GetData()
    if not Data.LaughingSpawn then
        return
    end

    if Pickup.SpriteScale.Y == 1 then --pickup landed
        
        Data.RenderFrames = nil
        Data.LaughingSpawn = nil
        Data.StartThrowOffset = nil
        Data.StartThrowRotation = nil

        if Pickup.Variant == PickupVariant.PICKUP_BOMB
           and Pickup.SubType == BombSubType.BOMB_TROLL or Pickup.SubType == BombSubType.BOMB_SUPERTROLL then
            
            Isaac.Explode(Pickup.Position, Pickup, 100)
        else
            Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL --make the pickupable like normal
            Pickup.DepthOffset = 0
            sfx:Play(SoundEffect.SOUND_SCAMPER)
        end
    else
        
        Data.RenderFrames = Data.RenderFrames + 1

        Pickup.SpriteOffset.Y = mod:ExponentLerp(Data.StartThrowOffset.Y, 0, Data.RenderFrames/300, 0.95)
        Pickup.SpriteOffset.X = mod:Lerp(Data.StartThrowOffset.X, 0, Data.RenderFrames/900)

        Pickup.SpriteScale = Vector.One * mod:ExponentLerp(2.25, 1, Data.RenderFrames/75, 2,5)
        Pickup.SpriteRotation =mod:ExponentLerp(Data.StartThrowRotation, 0, Data.RenderFrames/75, 0.9)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, PickupThrowParabola)



---@param Player EntityPlayer
local function OnItemAdded(_, Item, Charge, FirstTime, Slot, Var, Player)

    if Item == mod.Collectibles.UMBRELLA then

        if not Player:HasCollectible(mod.Collectibles.UMBRELLA) then

            local Return = {mod.Collectibles.UMBRELLA, Charge, FirstTime, Slot, UMBRELLA_VAR.CLOSED}
            
            for i=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
                
                local ItemDesc = Player:GetActiveItemDesc(i)

                if ItemDesc and ItemDesc.Item == mod.Collectibles.UMBRELLA then
                    
                    Return[2] = ItemDesc.Charge
                    Return[5] = ItemDesc.VarData

                    break
                end
            end

            return Return
        end

    elseif Item == mod.Collectibles.HEIRLOOM then
        if Player:HasCollectible(CollectibleType.COLLECTIBLE_TELEKINESIS) then
            Player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
        end
    elseif Item == CollectibleType.COLLECTIBLE_TELEKINESIS then
        if Player:HasCollectible(mod.Collectibles.HEIRLOOM) then
            Player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, OnItemAdded)


---@param Tear EntityTear
local function PocketAcesTrigger(_, Tear)

    local Player = Tear.Parent:ToPlayer()

    if not Player or Player:GetPlayerType() == mod.Characters.JimboType
       or not Player:HasCollectible(mod.Collectibles.POCKET_ACES) then
        return
    end

    local CardChance = (1 + Player.Luck/3)/13

    if math.random() >= CardChance then
        return
    end

    if Tear:ToTear() then --change the variant as well

        Tear:ChangeVariant(mod.Tears.CARD_TEAR_VARIANT)

        local TearSprite = Tear:GetSprite()
        TearSprite:Play(BASE_CARD_ANIMATION, true)
        TearSprite:PlayOverlay(SUIT_ANIMATIONS[math.random(1,4)], true)

        Tear.CollisionDamage = math.max(Tear.CollisionDamage, Player.Damage * mod:CalculateTears(Player.MaxFireDelay))
    
    else --only change the damage dealt
    
        local Laser = Tear:ToLaser()
        local Multiplier = math.max(1, Player.Damage * mod:CalculateTears(Player.MaxFireDelay)/Laser.CollisionDamage)
        Laser:SetDamageMultiplier(Laser:GetDamageMultiplier() * Multiplier)
        Tear.CollisionDamage = Player.Damage * mod:CalculateTears(Player.MaxFireDelay)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PocketAcesTrigger)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, PocketAcesTrigger)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE_BALL, PocketAcesTrigger)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TECH_LASER, PocketAcesTrigger)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TECH_X_LASER, PocketAcesTrigger)



local function EvaluateOnCandySmelt(_,_,_, Player)

    local HasCandy = false
    for i = 1, mod.TastyCandyNum do
        if Player:HasTrinket(mod.Trinkets.TASTY_CANDY[i]) then
            HasCandy = true
            break
        end
    end
    if HasCandy then
        Player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
    end

end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, EvaluateOnCandySmelt, CollectibleType.COLLECTIBLE_SMELTER)


---@param Player EntityPlayer
local function ErisAreaEffect(_, Player)

    if not Player:HasCollectible(mod.Collectibles.ERIS) or Game:GetFrameCount() % 3 ~= 0 then
        return
    end

    for _, Enemy in ipairs(Isaac.GetRoomEntities()) do

        if not Enemy:IsActiveEnemy() then
            goto SKIP_ENEMY
        end

        do

        local Data = Enemy:GetData()

        Data.ErisUnfreezeTime = Data.ErisUnfreezeTime or 0
        Data.CurrentErisSlowValue = Data.CurrentErisSlowValue or 0

        local Distance = Enemy.Position:Distance(Player.Position)

        if Distance <= ERIS_MAX_RADIUS then

            local SlowFactor = 1 - math.min(ERIS_MAX_RADIUS, Distance + ERIS_MIN_RADIUS)/ERIS_MAX_RADIUS
            local ExtraSlowValue = mod:ExponentLerp(ERIS_MIN_SLOW, ERIS_MAX_SLOW, SlowFactor, 1.85)
            local StartingSlow = Data.CurrentErisSlowValue or 0

            local FinalSlow =ExtraSlowValue + StartingSlow

            Data.CurrentErisSlowValue = FinalSlow
            Data.ErisUnfreezeTime = 0

        else --enemy starts to unfreeze if outside of the radius

            Data.ErisUnfreezeTime = Data.ErisUnfreezeTime + 1

            Data.CurrentErisSlowValue = Data.CurrentErisSlowValue - 0.01*(1+Data.ErisUnfreezeTime*0.05) 
        end

        Data.CurrentErisSlowValue = mod:Clamp(Data.CurrentErisSlowValue, 0, 0.95)

        local SlowValue = Data.CurrentErisSlowValue
    

        local PLAYER_REF = EntityRef(Player)

        if SlowValue >= 0.9 then

            Enemy:AddIce(PLAYER_REF, 3)

            Enemy:TakeDamage(math.max(Enemy.HitPoints*0.03, 0.1), 0, PLAYER_REF, 2)

            --Enemy:TakeDamage(Player.Damage*0.25+0.1, 0, PLAYER_REF, 2)
        end

        if SlowValue >= 0.02 then
            
            local SlowColor = Color()
            SlowColor:SetColorize(0, 0.75, 0.85, SlowValue)

            Enemy:AddSlowing(PLAYER_REF, 7, SlowValue, Color.Default)
            Enemy:SetColor(SlowColor, 5, 10, true, false)

            Enemy:SetSlowingCountdown(7)
        end

        end

        ::SKIP_ENEMY::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ErisAreaEffect)


local function PennySeedsPayout()

    for _, Player in ipairs(PlayerManager.GetPlayers()) do

        if not Player:HasTrinket(mod.Trinkets.PENNY_SEEDS) then
            goto SKIP_PLAYER
        end

        do
        local Multiplier = Player:GetTrinketMultiplier(mod.Trinkets.PENNY_SEEDS)

        local CoinsPlanted = (Player:GetNumCoins() // 5) * Multiplier

        Isaac.CreateTimer(function ()
            
        Isaac.CreateTimer(function ()
            
            local CoinVariant
            local CoinSub
            local CoinPosition

            local PennyRNG = Player:GetTrinketRNG(mod.Trinkets.PENNY_SEEDS)

            local VariantRoll = PennyRNG:RandomFloat()

            if VariantRoll <= 0.001 then

                CoinVariant = PickupVariant.PICKUP_COLLECTIBLE
                CoinSub = CollectibleType.COLLECTIBLE_QUARTER

                CoinPosition = Isaac.GetCollectibleSpawnPosition(Player.Position)

                Player:AnimateHappy()
                --sfx:Play(SoundEffect.SOUND_)


            elseif VariantRoll <= 0.01 then

                CoinVariant = PickupVariant.PICKUP_TRINKET

                local Pool = PENNY_TRINKET_POOLS[Game:GetRoom():GetBackdropType()] or PENNY_TRINKET_POOLS.DEFAULT
                CoinSub = mod:GetRandom(Pool, PennyRNG)

                if not Isaac.GetPersistentGameData():Unlocked(ItemsConfig:GetTrinket(CoinSub).AchievementID) then
                    CoinVariant = nil
                    CoinSub = nil
                else
                    Player:AnimateHappy()
                end
            end

            CoinVariant = CoinVariant or PickupVariant.PICKUP_COIN
            CoinSub = CoinSub or CoinSubType.COIN_PENNY
            CoinPosition = CoinPosition or Player.Position

            if Player:HasGoldenTrinket(mod.Trinkets.PENNY_SEEDS) then
            
                if PennyRNG:RandomFloat() <= 0.05 then

                    if CoinVariant == PickupVariant.PICKUP_TRINKET then
                        CoinSub = CoinSub + TrinketType.TRINKET_GOLDEN_FLAG

                    elseif CoinVariant == PickupVariant.PICKUP_COIN then
                        CoinSub = CoinSubType.COIN_GOLDEN
                    end
                end
            end

            Game:Spawn(EntityType.ENTITY_PICKUP, CoinVariant, CoinPosition, RandomVector()*3,
                       Player, CoinSub, mod:RandomSeed(PennyRNG))


            local BackType = Game:GetRoom():GetBackdropType()
            local ParticleVariant = GROUND_PARTICLE[BackType] or GROUND_PARTICLE.DEFAULT

            local Slave = Game:Spawn(mod.Entities.BALATRO_TYPE, mod.Entities.NPC_SLAVE, Player.Position, Vector.Zero, nil, mod.Entities.DIRT_COLOR_HELPER_SUBTYPE, 1):ToNPC()
            Slave:UpdateDirtColor(true)
            
            local ParticleColor = Color(1,1,1,1,0,0,0,Slave:GetDirtColor().R,Slave:GetDirtColor().G,Slave:GetDirtColor().B,1)
            
            Game:SpawnParticles(Player.Position, ParticleVariant, 3, 2.5, ParticleColor)
            Game:SpawnParticles(Player.Position, ParticleVariant, 3, 0.75, ParticleColor)

            
            if BackType == BackdropType.WOMB
               or BackType == BackdropType.SCARRED_WOMB
               or BackType == BackdropType.UTERO
               or BackType == BackdropType.SCARRED_WOMB
               or BackType == BackdropType.CORPSE
               or BackType == BackdropType.CORPSE2
               or BackType == BackdropType.CORPSE3
               or BackType == BackdropType.CORPSE_ENTRANCE then

                sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.35, 2, false, math.random()*0.2 + 0.9)

            else
                sfx:Play(SoundEffect.SOUND_SHOVEL_DIG, 0.35, 2, false, math.random()*0.2 + 1.2)
            end

        end, 4, CoinsPlanted, true)

        end, 7, 1, true)
        
        end
        ::SKIP_PLAYER::
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, PennySeedsPayout)


local function ModifyPickups(_, Pickup, Variant, SubType, ReqVariant, ReqSubType, Rng)

    if ReqVariant ~= 0 and ReqSubType ~= 0 then
        return
    end

    if GOLDEN_PICKUP_ACHIEVEMENTS[Variant] 
       and not Isaac.GetPersistentGameData():Unlocked(GOLDEN_PICKUP_ACHIEVEMENTS[Variant]) then
        return
    end

    local ReturnTable = {Variant, SubType, true}

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        if not ReturnTable[3] then
            break
        end

        local GoldenRNG = Player:GetCollectibleRNG(mod.Collectibles.HEIRLOOM)

        for i = 1, Player:GetCollectibleNum(mod.Collectibles.HEIRLOOM) do

            if not ReturnTable[3] then
                break
            end

            local UpgradeRoll = GoldenRNG:RandomFloat()

            if PICKUP_GOLDEN_SUB[Variant] then

                if UpgradeRoll <= PICKUP_GOLDEN_SUB[Variant].Chance then

                    if Variant == PickupVariant.PICKUP_BOMB 
                       and (SubType == BombSubType.BOMB_TROLL
                            or SubType == BombSubType.BOMB_SUPERTROLL) then

                        ReturnTable[2] = BombSubType.BOMB_GOLDENTROLL
                    else
                        ReturnTable[2] = PICKUP_GOLDEN_SUB[Variant].NewSubType
                    end

                    local Effect = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.HEIRLOOM_TRIGGER, Pickup.Position,
                                              Vector.Zero, Pickup, 0, 1):ToEffect()

                    Effect:FollowParent(Pickup)
                    Effect.ParentOffset = RandomVector()*8

                    ReturnTable[3] = false
                end

            elseif PICKUP_GOLDEN_VARIANT[Variant] then

                if UpgradeRoll <= PICKUP_GOLDEN_VARIANT[Variant].Chance then

                    ReturnTable[1] = PICKUP_GOLDEN_VARIANT[Variant].NewVariant


                    local Effect = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.HEIRLOOM_TRIGGER, Pickup.Position,
                                              Vector.Zero, Pickup, 0, 1):ToEffect()

                    Effect:FollowParent(Pickup)
                    Effect.ParentOffset = RandomVector()*20

                    ReturnTable[3] = false
                end       

            elseif Variant == PickupVariant.PICKUP_COIN and HEIRLOOM_COIN_UPGRADES[ReturnTable[2]] then

                if UpgradeRoll <= HEIRLOOM_COIN_UPGRADES[ReturnTable[2]].Chance then

                    ReturnTable[2] = HEIRLOOM_COIN_UPGRADES[ReturnTable[2]].NewSubType

                    local Effect = Game:Spawn(EntityType.ENTITY_EFFECT, mod.Effects.HEIRLOOM_TRIGGER, Pickup.Position,
                                              Vector.Zero, Pickup, 0, 1):ToEffect()

                    Effect:FollowParent(Pickup)
                    Effect.ParentOffset = RandomVector()*8
                end
            end
        end
    end

    

    return ReturnTable
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, CallbackPriority.LATE, ModifyPickups)


local function ModifyPills()

    if not Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_PILLS) then
        return
    end

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        local GoldenRNG = Player:GetCollectibleRNG(mod.Collectibles.HEIRLOOM)

        for i = 1, Player:GetCollectibleNum(mod.Collectibles.HEIRLOOM) do

            local UpgradeRoll = GoldenRNG:RandomFloat()

            if UpgradeRoll <= GOLDEN_PILL_CHANCE then
                
                return PillColor.PILL_GOLD
            end
        end
    end

end
mod:AddCallback(ModCallbacks.MC_GET_PILL_COLOR, ModifyPills)


local function ModifyTrinkets(_, SelectedTrinket)

    if SelectedTrinket & TrinketType.TRINKET_GOLDEN_FLAG ~= 0
       or not Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) then
        return
    end

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        local GoldenRNG = Player:GetCollectibleRNG(mod.Collectibles.HEIRLOOM)

        for i = 1, Player:GetCollectibleNum(mod.Collectibles.HEIRLOOM) do

            local UpgradeRoll = GoldenRNG:RandomFloat()

            if UpgradeRoll <= GOLDEN_TRINKET_CHANCE then
                
                return SelectedTrinket | TrinketType.TRINKET_GOLDEN_FLAG
            end
        end
    end

end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, ModifyTrinkets)


--taken straight up from Epiphany but with some removed parts since RGON is needed for mod
local function TurnItemGold(pickup, playSfx)

    if playSfx == nil then
		playSfx = true
	end
	if not pickup or pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        return
    end

    --in the originl file I only see this table empty so I guess i can not check this(?)
	--if GOLDEN_ITEM.ActiveSpawnBlacklist[pickup.SubType] then
	--	return
	--end

	local id = pickup.SubType
	local ItemPedestal = pickup

	local pData = Epiphany:GetRerollPersistentData(pickup)

	pData.IsGoldenCollectible = true

	--if REPENTOGON then RGON is needed anyway for this mod to run
	ItemPedestal:GetSprite():SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
	--end

	if playSfx == true then
		sfx:Play(GoldTurnSfx)
	end
end

--synergises with the golden items made by Ephiphany
--DisableGoldPedestal used in the original code isn't necessary since with RGON there no need to morph the pickup
local function EpiphanyGoldenItems(_, Pickup)

    if not Ephiphany then
        return
    end

    --all the code in this function was taken from the mod itself with some removed part which weren't necessary

    local pData = Ephiphany:GetRerollPersistentData(Pickup)

	local run_save = Ephiphany:RunSave()

	if pData.IsGoldenCollectible == true or Ephiphany:HasGoldenItem(Pickup.SubType) then
		TurnItemGold(Pickup, false)
		return
	end
	if pData.IsGoldenCollectible == false then
		return
	end

	local rng = Pickup:GetDropRNG()

	local roll = rng:RandomFloat()

	run_save.goldActiveList = run_save.goldActiveList or {}

	local isGold = GOLDEN_ITEM_CHANCE >= roll or run_save.goldActiveList[tostring(Pickup.SubType)]


	if Ephiphany:GetAchievement("GOLDEN_COLLECTIBLE") > 0
		and Epiphany.IsDeathCertificateFloor() == false
		and (pData.IsGoldenCollectible == true or isGold)
		and not Ephiphany.itemconfig:GetCollectible(Pickup.SubType):HasTags(ItemConfig.TAG_QUEST) then

		TurnItemGold(Pickup, false)
	else
		-- If IsGoldenCollectible is nil and random check fails,
		-- set it to false to prevent any future checks
		pData.IsGoldenCollectible = false
	end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, EpiphanyGoldenItems, PickupVariant.PICKUP_COLLECTIBLE)



---@param Player EntityPlayer
local function StatEvaluation(_,Player, Cache)

    if not mod.GameStarted then
        return
    end

    if Player:HasCollectible(mod.Collectibles.TRAGICOMEDY) then
        
        local PIndex = Player:GetData().TruePlayerIndex

        if mod.Saved.Player[PIndex].ComedicState & ComedicState.COMEDY == ComedicState.COMEDY then
            
            if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
                Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, 1)
            end
            if Cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
                Player.MoveSpeed = Player.MoveSpeed + 0.2
            end
            if Cache & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
                Player.Luck = Player.Luck + 2
            end
        end
        if mod.Saved.Player[PIndex].ComedicState & ComedicState.TRAGEDY == ComedicState.TRAGEDY then

            if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
                Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, 0.5)
            end
            if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
                Player.Damage = Player.Damage + 1
            end
            if Cache & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
                Player.TearRange = Player.TearRange + 100
            end
        end
    end
    if Player:HasCollectible(mod.Collectibles.LOLLYPOP) then

        if Cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
            
            Player.MoveSpeed = Player.MoveSpeed + 0.15*Player:GetCollectibleNum(mod.Collectibles.LOLLYPOP)
        end
    end

    if Player:HasTrinket(mod.Jokers.JOKER) then
        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            
            Player.Damage = Player.Damage + 1 * Player:GetTrinketMultiplier(mod.Jokers.JOKER)
        end
    end

    if Cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then

        local Trinkets = Player:GetSmeltedTrinkets()


        for i,Candy in ipairs(mod.Trinkets.TASTY_CANDY) do
            local CandyAmounts = Trinkets[Candy]

            local ExtraSpeed = (CandyAmounts.trinketAmount + CandyAmounts.goldenTrinketAmount) * 0.03 * i

            Player.MoveSpeed = Player.MoveSpeed + ExtraSpeed
        end

    end

    if Cache & CacheFlag.CACHE_TEARFLAG == CacheFlag.CACHE_TEARFLAG then

        if Player:HasCollectible(CollectibleType.COLLECTIBLE_TELEKINESIS)
           and Player:HasCollectible(mod.Collectibles.HEIRLOOM) then

            Player.TearFlags = Player.TearFlags | TearFlags.TEAR_HOMING
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, StatEvaluation)


---@param Slot EntitySlot
---@param Player EntityPlayer
local function GuaranteeBeggarPayout(_, Slot, Player)

    if not (Slot.Variant == SlotVariant.BEGGAR
        or Slot.Variant == SlotVariant.KEY_MASTER
        or Slot.Variant == SlotVariant.BOMB_BUM
        or Slot.Variant == SlotVariant.BATTERY_BUM
        or Slot.Variant == SlotVariant.DEVIL_BEGGAR
        or Slot.Variant == SlotVariant.ROTTEN_BEGGAR) then
                
        return
    end

    Player = Player:ToPlayer()

    if not Player then
        return
    end

    local Sprite = Slot:GetSprite()

    if Sprite:IsPlaying("PayPrize") or Slot:GetState() == 2 then --if it's alredy paying out
        return
    end

    local CandySlot = -1
    local HasGoldenCandy = false

    for i = 0, Player:GetMaxTrinkets() - 1 do

        local HeldTrinket = Player:GetTrinket(i)

        local TrueTrinket = HeldTrinket & ~TrinketType.TRINKET_GOLDEN_FLAG
        
        if mod:Contained(mod.Trinkets.TASTY_CANDY, TrueTrinket) then
            
            HasGoldenCandy = TrueTrinket ~= HeldTrinket

            CandySlot = i
            break
        end
    end

    if CandySlot == -1 then --has no candy
        Sprite:Reload()
        return
    end


    Sprite:ReplaceSpritesheet(2, CandySheet, true) --puts the candy in the bum's sprite

    if HasGoldenCandy then
        Sprite:GetLayer(2):SetRenderFlags(AnimRenderFlags.GOLDEN)
    end

    --degrades the candy by one use

    --if not HasGoldenCandy then

        local CurrentCandy = Player:GetTrinket(CandySlot)
        local NewCandy = CurrentCandy - 1

        if mod:Contained(mod.Trinkets.TASTY_CANDY, NewCandy) then 
            Player:TryRemoveTrinket(CurrentCandy)
            Player:AddTrinket(NewCandy, false)

        else
            Player:TryRemoveTrinket(mod.Trinkets.TASTY_CANDY[1])

        end
    --end

    Sprite:Play("PayPrize")
    Slot:SetState(2)

    --if not set manually bomb bums always give a collectible
    Slot:SetPrizeType(Slot.Variant == SlotVariant.BOMB_BUM and BombBumPayoutPicker:PickOutcome(Slot:GetDropRNG()) or 0)

end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, GuaranteeBeggarPayout)


---@param Wisp EntityFamiliar
local function WispUpdate(_, Wisp)

    local Item = Wisp.SubType

    if Item == mod.Collectibles.EMPTY_BANANA then

        local Target = Wisp.Parent or Wisp.Player

        Wisp.OrbitDistance = Vector(20, 20)
        Wisp.OrbitSpeed = 0.05
        
        
        --Wisp.Position = 

        Wisp.Velocity = (Wisp:GetOrbitPosition(Target.Position) - Wisp.Position)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, WispUpdate, FamiliarVariant.WISP)


local function RemoveUnwantedEntities()

    for i, Wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.Collectibles.EMPTY_BANANA)) do
        Wisp:Remove()
    end

    for i, Umbrella in ipairs(Isaac.FindByType(1000, mod.Effects.UMBRELLA)) do
        if not Umbrella:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) then
            
            Umbrella:GetSprite():Play("Retreat")
            Umbrella:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, RemoveUnwantedEntities)

