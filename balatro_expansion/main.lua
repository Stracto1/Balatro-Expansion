
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
TrinketType.TRINKET_SACRIFICIAL_DAGGER = Isaac.GetTrinketIdByName("Sacrificial dagger")
TrinketType.TRINKET_LOYALTY_CARD = Isaac.GetTrinketIdByName("Loyalty card")
TrinketType.TRINEKT_SWASHBUCKLER = Isaac.GetTrinketIdByName("Swashbuckler")
TrinketType.TRINKET_CLOUD_NINE = Isaac.GetTrinketIdByName("Cloud 9")
TrinketType.TRINKET_CARTOMANCER = Isaac.GetTrinketIdByName("Cartomancer")
TrinketType.TRINKET_SUPERNOVA = Isaac.GetTrinketIdByName("Supernova")
TrinketType.TRINKET_DELAYED_GRATIFICATION = Isaac.GetTrinketIdByName("Delayed gratification")
TrinketType.TRINKET_EGG = Isaac.GetTrinketIdByName("Egg")
TrinketType.TRINKET_DNA = Isaac.GetTrinketIdByName("Dna")
--------------------------------
CollectibleType.COLLECTIBLE_THE_HAND = Isaac.GetItemIdByName("The hand")
----------------------------------
Balatro_Expansion.Characters = {}
Balatro_Expansion.Characters.JimboType = Isaac.GetPlayerTypeByName("Jimbo", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
Balatro_Expansion.Suits = {}
Balatro_Expansion.Suits.Spade = 1
Balatro_Expansion.Suits.Heart = 2
Balatro_Expansion.Suits.Club = 3
Balatro_Expansion.Suits.Diamond = 4

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
Balatro_Expansion.Fonts.upheavalmini = Font()
Balatro_Expansion.Fonts.upheavalmini:Load("resources/font/upheavalmini.fnt")
---------------------
local Game = Game()
--local HUD = Game:GetHUD()

Balatro_Expansion.SavedValues = {} --every value thet needs to be store between game starts
-------------------------------
Balatro_Expansion.SavedValues.TrinketValues = {} --contains the "progress" for every trinket thet needs it
-------------BASE VALUES------------- (changed on game start or when loading data)
Balatro_Expansion.SavedValues.TrinketValues.LastMisprintDMG = 0
Balatro_Expansion.SavedValues.TrinketValues.Fortune_Teller = 0
Balatro_Expansion.SavedValues.TrinketValues.Stone_joker = 0
Balatro_Expansion.SavedValues.TrinketValues.Ice_cream = 1
Balatro_Expansion.SavedValues.TrinketValues.Popcorn = 2
Balatro_Expansion.SavedValues.TrinketValues.Ramen = 1.3
Balatro_Expansion.SavedValues.TrinketValues.Rocket = 3
Balatro_Expansion.SavedValues.TrinketValues.Green_joker = 0
Balatro_Expansion.SavedValues.TrinketValues.Red_card = 0
Balatro_Expansion.SavedValues.TrinketValues.Blueprint = 0
Balatro_Expansion.SavedValues.TrinketValues.Brainstorm = 0
Balatro_Expansion.SavedValues.TrinketValues.Madness = 1
Balatro_Expansion.SavedValues.TrinketValues.LastBPitem = 0
Balatro_Expansion.SavedValues.TrinketValues.Flash_card = 0
Balatro_Expansion.SavedValues.TrinketValues.Cloud_9 = 9
Balatro_Expansion.SavedValues.TrinketValues.Loyalty_card = 6
Balatro_Expansion.SavedValues.TrinketValues.Sacrificial_dagger = 0
Balatro_Expansion.SavedValues.TrinketValues.Swashbuckler = 0
Balatro_Expansion.SavedValues.TrinketValues.Egg = 3
Balatro_Expansion.SavedValues.TrinketValues.Supernova = {}
Balatro_Expansion.SavedValues.TrinketValues.MichaelDestroyed = false
Balatro_Expansion.SavedValues.TrinketValues.GoldenMichelGone = false
Balatro_Expansion.SavedValues.TrinketValues.FirstBrain = true
Balatro_Expansion.SavedValues.TrinketValues.Dna = true

-----------JIMBO-------------------
Balatro_Expansion.SavedValues.Jimbo = {}
Balatro_Expansion.SavedValues.Jimbo.FullDeck = {} --the full deck of cards used by jimbo
do
local index = 1
for i = 1, 4, 1 do --cycles between the suits
    for j = 1, 13, 1 do --cycles for all the values
        Balatro_Expansion.SavedValues.Jimbo.FullDeck[index] = {}
        Balatro_Expansion.SavedValues.Jimbo.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
        Balatro_Expansion.SavedValues.Jimbo.FullDeck[index].Value = j
        Balatro_Expansion.SavedValues.Jimbo.FullDeck[index].Enhancement = 1
        Balatro_Expansion.SavedValues.Jimbo.FullDeck[index].Edition = 1
        index = index +1
    end
end
end
Balatro_Expansion.SavedValues.Jimbo.DeckPointer = 6 --the card thet is going to be picked next
Balatro_Expansion.SavedValues.Jimbo.CurrentHand = {1,2,3,4,5} --the pointers of the cards in FullDeck that are stored in "the hand" active item

Balatro_Expansion.SavedValues.Jimbo.SmallBlind = 0
Balatro_Expansion.SavedValues.Jimbo.BigBlind = 0
Balatro_Expansion.SavedValues.Jimbo.ClearedRooms = 0
Balatro_Expansion.SavedValues.Jimbo.SmallCleared = false
Balatro_Expansion.SavedValues.Jimbo.BigCleared = false
Balatro_Expansion.SavedValues.Jimbo.BossCleard = false
Balatro_Expansion.SavedValues.Jimbo.StatsToAdd = {}
Balatro_Expansion.SavedValues.Jimbo.StatsToAdd.Damage = 0
Balatro_Expansion.SavedValues.Jimbo.StatsToAdd.Tears = 0
--OTHER VALUES
Balatro_Expansion.SavedValues.Other = {}
Balatro_Expansion.SavedValues.Other.DamageTakenRoom = 0
Balatro_Expansion.SavedValues.Other.DamageTakenFloor = 0
Balatro_Expansion.SavedValues.Other.ShopEntered = false
Balatro_Expansion.SavedValues.Other.TreasureEntered = false
Balatro_Expansion.SavedValues.Other.Picked = {0}  --to prevent weird shenadigans
Balatro_Expansion.SavedValues.Other.Tags = {}
Balatro_Expansion.SavedValues.Other.Labyrinth = 1

Balatro_Expansion.SavedValues.ModConfig = {}
Balatro_Expansion.SavedValues.ModConfig.EffectsAllowed = true
-----------------------------


--heyo dear mod developer college! Fell free to take any of the code written here
--but please make sure to give this mod credit when you take important/big chunks of code

--also i don't know whether or not this is good code, so if you think you have a good
--optimisation idea write it in the comments of the steam page and ill' try to implement it (giving you credit obv)

--Wanna do a big shoutuot to CATINSURANCE for making very good tutorial vids and because i took
--some inspiration from The Sheriff's code while making this


-------------------OPTIMISATION FUNCTOINS------------------------------------
--these functions limit the ammount of callbacks the game has to consider for this mod using REPENTOGON's custom tags,
--i have no idea if this change is actually noticable or not, but i think it's pretty well done

--to see the list of all the custom tags and how they work, see the items.xml file

include("Balatro_scripts.Callback_system")

--[[
local LogoSprite = Sprite("gfx/ui/main menu/titlemenu.anm2",true)
print(LogoSprite:GetAnimation())

--LogoSprite:Load("gfx/ui/main menu/titlemenu.anm2", true)

--LogoSprite:ReplaceSpritesheet(2, "gfx/ui/main menu/logo_up.png", true)
]]--



--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work (both sound and graphics can be turend off in MOD CONFIG MENU)
include("Balatro_scripts.Effects")

-----------------OTHER/OFTEN USED FUNCTIONS---------------------
----------------------------------------------------------------
--general function used in the code

include("Balatro_scripts.Utility")

---------------CURSES/CHALLENGES-----------------
-------------------------------------------------
--all the code regarding the custom challenges and curses
--since i'm a masochist, the curse callbacks are only added when needed just like the trinket's do

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
                --while the statups are given in their cache evaluation functions

--ACTIVATE TRINKETS: usually all they do is put in a function called whenever it needs to activate,
                --   which are inside the section of the cache evaluation functions
include("Balatro_scripts.characters.jimbo")
include("Balatro_scripts.Custom_Cards")
include("Balatro_scripts.Synergies")

include("Balatro_scripts.Trinket_Callbacks")

---------------------CACHE EVALUATION FUNCTIONS---------------------
--------------------------------------------------------------------
--these are all the cache evaluations for every trinekt/item
--the functions for non-statup trinkets are also here

include("Balatro_scripts.Trinkets_Effects")
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

------------------EID----------------------
-------------------------------------------
include("Balatro_scripts.EID")

-------------MOD CONFIG MENU -------------
------------------------------------------
include("Balatro_scripts.ModConfigMenu")
