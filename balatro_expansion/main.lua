
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
TrinketType.TRINEKT_BLUEPRINT = Isaac.GetTrinketIdByName("Blueprint")
TrinketType.TRINKET_BRAINSTORM = Isaac.GetTrinketIdByName("Brainstorm")
TrinketType.TRINKET_SMEARED_JOKER = Isaac.GetTrinketIdByName("Smeared joker")
TrinketType.TRINEKT_MADNESS = Isaac.GetTrinketIdByName("Madness")
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
local HandHoldingFrames = 0
----------------------------------

Balatro_Expansion.JimboType = Isaac.GetPlayerTypeByName("Jimbo", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root

local JimboCards = {BaseCards = Sprite()
}
JimboCards.BaseCards:Load("gfx/ui/HUD/BaseCards.anm2", true)
---
Balatro_Expansion.Challenges = {}
Balatro_Expansion.Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
---
Balatro_Expansion.AllCurses = {}
Balatro_Expansion.NormalCurses = {}
Balatro_Expansion.BossCurses = {}

Balatro_Expansion.AllCurses.THE_WALL = 1 << (Isaac.GetCurseIdByName("curse of the wall") - 1)

Balatro_Expansion.NormalCurses[1] = Balatro_Expansion.AllCurses.THE_WALL
---------------------------------
Balatro_Expansion.WantedEffect = 0 --needed to prevent effects from overlapping
---------------------
local Game = Game()
--local HUD = Game:GetHUD()

local ItemPool = Game:GetItemPool()
local sfx = SFXManager()
local ChargeSprite = Sprite("gfx/chargebar.anm2")
-------------------------------
TrinketValues = {} --contains the "progress" for every trinket thet needs it and other stuff
-------------BASE VALUES------------- (changed on game start or when loading data)
TrinketValues.LastMisprintDMG = 0
TrinketValues.Fortune_Teller = 0
TrinketValues.Stone_joker = 0
TrinketValues.Ice_cream = 1
TrinketValues.Popcorn = 2
TrinketValues.Ramen = 1.3
TrinketValues.Rocket = 3
TrinketValues.Green_joker = 0
TrinketValues.Red_card = 0
TrinketValues.Blueprint = 0
TrinketValues.Brainstorm = 0
TrinketValues.Madness = 1
TrinketValues.LastBPitem = 0
TrinketValues.Flash_card = 0
TrinketValues.Cloud_9 = 9
TrinketValues.Loyalty_card = 6
TrinketValues.Labyrinth = 1
TrinketValues.Sacrificial_dagger = 0
TrinketValues.Swashbuckler = 0
TrinketValues.Egg = 3
TrinketValues.Supernova = {}
TrinketValues.MichaelDestroyed = false
TrinketValues.GoldenMichelGone = false
TrinketValues.FirstBrain = true
TrinketValues.Dna = true
TrinketValues.FullDeck = {} --the full deck of cards used by jimbo
do
local index = 1
for i = 1, 4, 1 do --cycles between the suits
    for j = 1, 13, 1 do --cycles for all the values
        TrinketValues.FullDeck[index] = {}
        TrinketValues.FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
        TrinketValues.FullDeck[index].Value = j
        TrinketValues.FullDeck[index].Enhancement = 1
        TrinketValues.FullDeck[index].Edition = 1
        index = index +1
    end
end
end
TrinketValues.DeckPointer = 1 --the card thet is going to be used
TrinketValues.CurrentHand = {0,0,0,0,0} --the pointers of the cards in FullDeck that are stored in "the hand" active item
--OTHER VALUES
TrinketValues.DamageTakenRoom = 0
TrinketValues.DamageTakenFloor = 0
TrinketValues.ShopEntered = false
TrinketValues.TreasureEntered = false
TrinketValues.Picked = {0}  --to prevent weird shenadigans
TrinketValues.Tags = {}

TrinketValues.EffectsAllowed = true

local CARD_TEAR_VARIANTS = {Isaac.GetEntityVariantByName("TearSpadeCard")}
local ENHANCEMENTS_ANIMATIONS = {"Base"}
local WasTheHandHeld = false
local IsHoldingCard = false --used to determine the effect of The Hand item
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

require("Balatro_scripts.Callback_system")

local LogoSprite = Sprite()
LogoSprite:Load("gfx/ui/main menu/titlemenu.anm2", true)
LogoSprite:ReplaceSpritesheet(2, "gfx/ui/main menu/logo_up.png", true)




---@param Player EntityPlayer
function Balatro_Expansion:PlayerHeartsRender(_,HeartSprite,Position,HasCoTU,Player)
    if Player:GetPlayerType() == Balatro_Expansion.JimboType then
        --local Pindex = Player:GetPlayerIndex()

        ----DECK RENERING----
        JimboCards.BaseCards.Scale = Vector.One
        for i=0, 2, 1 do
            local Card = TrinketValues.FullDeck[TrinketValues.DeckPointer + i]
            if Card then
                JimboCards.BaseCards.Offset = Vector(85 + 17 * i, 0)
                --SEE THE anm2 FILE TO UNDERSTAND BETTER THIS PART--
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the enhancement animation
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit) --sets the frame corresponding to the value and suit
                -------------------------------------------------------------
                JimboCards.BaseCards.Color.A = JimboCards.BaseCards.Color.A / (i+1) --reduces the transparency based on its order position
                
                --JimboCards.BaseCards:Render(Isaac.WorldToRenderPosition(Player.Position))
                JimboCards.BaseCards:Render(Position)
                JimboCards.BaseCards.Color:Reset()
            end
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, Balatro_Expansion.PlayerHeartsRender)

function Balatro_Expansion:OnJimboPocketRender(Player,CardSlot,Position,_,Scale)
    if CardSlot == ActiveSlot.SLOT_POCKET then
        ----HAND RENDERING----
        JimboCards.BaseCards.Scale = Vector(0.8,0.8) * Scale

        if Scale < 1 then --scale is lower if it's in a seconary slot (ex. holding a card in the primary slot)
            JimboCards.BaseCards.Color.A = 0.5
        end
        for i=1, 5, 1 do --cycles between cards the plyer's hand
            local Card = TrinketValues.FullDeck[TrinketValues.CurrentHand[i]]
            if Card then
                JimboCards.BaseCards.Offset = Vector(-30 + 13 * i, -15) * Scale
                JimboCards.BaseCards:SetAnimation(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], false) --sets the suit of the rendered card
                JimboCards.BaseCards:SetFrame(4 * (Card.Value - 1) + Card.Suit) --sets the value of the randered card

                JimboCards.BaseCards:Render(Position)
            end
        end
        JimboCards.BaseCards.Color:Reset()
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, Balatro_Expansion.OnJimboPocketRender)

---@param player EntityPlayer
function Balatro_Expansion:GiveCostumesOnInit(player)
    if player:GetPlayerType() == Balatro_Expansion.JimboType then
        player:AddNullCostume(jesterhatCostume)
        player:AddNullCostume(jesterstolesCostume)
        --print(The_Hand)
        --player:AddCollectible(The_Hand, 0, true, ActiveSlot.SLOT_PRIMARY)
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND, ActiveSlot.SLOT_POCKET, true)
        ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Balatro_Expansion.GiveCostumesOnInit)

---@param player EntityPlayer
function Balatro_Expansion:TheHandUse(_,_, player, _,_,_)
    if player:GetPlayerType() == Balatro_Expansion.JimboType then
        Isaac.CreateTimer(function()
            if HandHoldingFrames < 5 then --the button got released (add card to hand)
                
                if IsHoldingCard and TrinketValues.DeckPointer <= #TrinketValues.FullDeck then
                    --jimbo is currently holding up a card 
                    TrinketValues.CurrentHand = Balatro_Expansion:AddCardToHand(TrinketValues.CurrentHand, TrinketValues.DeckPointer)
                    TrinketValues.DeckPointer = TrinketValues.DeckPointer + 1
                else 
                    --play the animation
                    --(con animazione sparando onupdate spara la carta)
                end
    
            else--player has held down the button (use the cards in hand)
                --print("should use hand")
                WasTheHandHeld = true
                player:AnimateCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
            end
        end, 6, 1, true)
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_USE_ITEM, Balatro_Expansion.TheHandUse, CollectibleType.COLLECTIBLE_THE_HAND)

---@param Player EntityPlayer
function Balatro_Expansion:OnJimboRender(Player)
    if Player:GetPlayerType() ~= Balatro_Expansion.JimboType then
        return
    end

    local pocketItem = Player:GetPocketItem(PillCardSlot.PRIMARY)
    if pocketItem:GetType() ~= PocketItemType.ACTIVE_ITEM then --if player holds a pocketactive
        return
    end

    local activeItemID = Player:GetActiveItem(pocketItem:GetSlot() - 1)
    if activeItemID == CollectibleType.COLLECTIBLE_THE_HAND then --if that pocketactive is the hand

        if Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then
            HandHoldingFrames = HandHoldingFrames + 1    
            if WasTheHandHeld then
                if HandHoldingFrames == 50 then --activates
                    Balatro_Expansion:DeterminePokerHand(TrinketValues.CurrentHand)
                    TrinketValues.CurrentHand = {0,0,0,0,0}
                    sfx:Play(SoundEffect.SOUND_1UP)
                    WasTheHandHeld = false
                else
                    ChargeSprite:SetAnimation("Charging")
                    ChargeSprite:SetFrame(HandHoldingFrames * 2)
                    local ProgressBar = ChargeSprite:GetLayer(1)

                    ---@diagnostic disable-next-line: need-check-nil
                    local BarColor = ProgressBar:GetColor()
                    BarColor.BO = 0.9
                    BarColor.GO = -0.3
                    BarColor.RO = -1

                    ---@diagnostic disable-next-line: need-check-nil
                    ProgressBar:SetColor(BarColor)
                    ChargeSprite.Offset = Vector(20,-20)
                    ChargeSprite:Render(Isaac.WorldToRenderPosition(Player.Position))

                    
                end
            end
        else
            HandHoldingFrames = 0
            WasTheHandHeld = false
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, Balatro_Expansion.OnJimboRender)


function Balatro_Expansion:DeterminePokerHand(HandTable)
    local ValidCardsNumber = 0
    for _,Card in pairs(HandTable) do
        if Card ~= 0 then
            ValidCardsNumber = ValidCardsNumber + 1
        end
    end
    --print(ValidCardsNumber)
    local IsFlush = false
    if ValidCardsNumber >= 4 then --no need to check if there aren't enough cards
        IsFlush = Balatro_Expansion:IsFlush(HandTable)
    end
    local EqualCards = Balatro_Expansion:GetCardValueRepetitions(HandTable)

    if EqualCards == 5 then
        if IsFlush then
            print("flush 5")
            return
        else
            print("5 of a kind")
            return
        end
    elseif EqualCards == 3.5 then
        if IsFlush then
            print("flush house")
            return
        else
            print("full house")
            return
        end
    end
    local IsStraight = false
    local IsRoyal = false

    if ValidCardsNumber >= 4 then --no need to check if there aren't enough cards
        local ValueTable = {}
        for i, v in ipairs(HandTable) do
            if v == 0 then
                ValueTable[i] = 0
            else
                ValueTable[i] = TrinketValues.FullDeck[v].Value
            end
            print(ValueTable[i])
        end
        IsStraight,IsRoyal = Balatro_Expansion:IsStraight(ValueTable)
    end

    if IsFlush and not IsStraight then
        print("flush")
    end

    if IsStraight then
        if IsFlush then
            if IsRoyal then
                print("royal flush")
                return
            else
                print("straight flush")
                return
            end
        else
            print("straight")
            return
        end
    elseif EqualCards == 4 then
        print("4 of a kind")
        return
    elseif EqualCards == 3 then
        print("3 of a kind")
        return
    elseif EqualCards == 2.5 then
        print("two pairs")
        return
    elseif EqualCards == 2 then
        print("pair")
        return
    else
        print("high card")
    end

    
    
end

---@param Player EntityPlayer
function Balatro_Expansion:FullDeckShuffle(Player)
    if Player:GetPlayerType() == Balatro_Expansion.JimboType then
        local HandRNG = Player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_THE_HAND)
        TrinketValues.FullDeck = Balatro_Expansion:Shuffle(TrinketValues.FullDeck, HandRNG)
        TrinketValues.DeckPointer = 1
        TrinketValues.CurrentHand = {0,0,0,0,0}
    end 
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, Balatro_Expansion.FullDeckShuffle)

---@param Tear EntityTear
function Balatro_Expansion:OnJimboShoot(Tear)
    local Player = Tear.Parent:ToPlayer()
    if Player and Player:GetPlayerType() == Balatro_Expansion.JimboType then

        Tear:ChangeVariant(CARD_TEAR_VARIANTS[1])
        --Tear:ChangeVariant(CARD_TEAR_VARIANTS[TrinketValues.FullDeck[TrinketValues.DeckPointer].Suit])
        --print(Tear.BaseScale)
        local TearSprite = Tear:GetSprite()
        TearSprite:Play("idle", true)
        if TrinketValues.DeckPointer <= #TrinketValues.FullDeck then
            TrinketValues.DeckPointer = TrinketValues.DeckPointer + 1
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Balatro_Expansion.OnJimboShoot)


---@param Tear EntityTear
function Balatro_Expansion:OnTearUpdate(Tear)
    local TearSprite = Tear:GetSprite()
    TearSprite.Rotation = math.deg(math.atan(Tear.Velocity.Y,Tear.Velocity.X))
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, Balatro_Expansion.OnTearUpdate, CARD_TEAR_VARIANTS[1])


--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work (both sound and graphics can be turend off in MOD CONFIG MENU)

require("Balatro_scripts.Effects")

-----------------OTHER/OFTEN USED FUNCTIONS---------------------
----------------------------------------------------------------
--general function used in the code

require("Balatro_scripts.Utility")

---------------CURSES/CHALLENGES-----------------
-------------------------------------------------
--all the code regarding the custom challenges and curses
--since i'm a masochist, the curse callbacks are only added when needed just like the trinket's do

require("Balatro_scripts.Challenges")

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

require("Balatro_scripts.Trinket_Callbacks")

---------------------CACHE EVALUATION FUNCTIONS---------------------
--------------------------------------------------------------------
--these are all the cache evaluations for every trinekt/item
--the functions for non-statup trinkets are also here

require("Balatro_scripts.Trinkets_Effects")
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
require("Balatro_scripts.EID")

-------------MOD CONFIG MENU -------------
------------------------------------------
require("Balatro_scripts.ModConfigMenu")

