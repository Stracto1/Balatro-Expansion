local mod = RegisterMod("Balatro extension", 1)
local json = require("json")
-------------------------------
local Joker = Isaac.GetTrinketIdByName("Joker")
local Bull = Isaac.GetTrinketIdByName("Bull")
local Invisible_Joker = Isaac.GetTrinketIdByName("Invisible joker")
local Abstract_joker = Isaac.GetTrinketIdByName("Abstract joker")
local Misprint = Isaac.GetTrinketIdByName("Misprint")
local Joker_stencil = Isaac.GetTrinketIdByName("Joker stencil")
local Stone_joker = Isaac.GetTrinketIdByName("Stone joker")
local Icecream = Isaac.GetTrinketIdByName("Ice cream")
local Popcorn = Isaac.GetTrinketIdByName("Popcorn")
local Ramen = Isaac.GetTrinketIdByName("Ramen")
local Rocket = Isaac.GetTrinketIdByName("Rocket")
local Oddtodd = Isaac.GetTrinketIdByName("Odd todd")
local Evensteven = Isaac.GetTrinketIdByName("Even steven")
local Hallucination = Isaac.GetTrinketIdByName("Hallucination")
local Green_joker = Isaac.GetTrinketIdByName("Green joker")
local Red_card = Isaac.GetTrinketIdByName("Red card")
local Vagabond = Isaac.GetTrinketIdByName("Vagabond")
local Riff_raff = Isaac.GetTrinketIdByName("Riff-raff")
local Golden_joker = Isaac.GetTrinketIdByName("Golden joker")
local Fortuneteller = Isaac.GetTrinketIdByName("Fortune Teller")
local Blueprint = Isaac.GetTrinketIdByName("Blueprint")
local Brainstorm = Isaac.GetTrinketIdByName("Brainstorm")
local Smeared_joker = Isaac.GetTrinketIdByName("Smeared joker")
local Madness = Isaac.GetTrinketIdByName("Madness")
local Mr_bones = Isaac.GetTrinketIdByName("Mr. Bones")
local Onix_agate = Isaac.GetTrinketIdByName("Onyx agate")
local Arrowhead = Isaac.GetTrinketIdByName("Arrowhead")
local Bloodstone = Isaac.GetTrinketIdByName("Bloodstone")
local Rough_gem = Isaac.GetTrinketIdByName("Rough gem")
local Gros_michael = Isaac.GetTrinketIdByName("Gros Michel")
local Cavendish = Isaac.GetTrinketIdByName("Cavendish")
local Flash_card = Isaac.GetTrinketIdByName("Flash card")
local Sacrificial_dagger = Isaac.GetTrinketIdByName("Sacrificial dagger")
local Loyalty_card = Isaac.GetTrinketIdByName("Loyalty card")
local Swashbuckler = Isaac.GetTrinketIdByName("Swashbuckler")
local Cloud_nine = Isaac.GetTrinketIdByName("Cloud 9")
local Cartomancer = Isaac.GetTrinketIdByName("Cartomancer")
local Supernova = Isaac.GetTrinketIdByName("Supernova")
local Delayed_gratification = Isaac.GetTrinketIdByName("Delayed gratification")
local Egg = Isaac.GetTrinketIdByName("Egg")
local Dna = Isaac.GetTrinketIdByName("Dna")

--------------------------------
local The_Hand = Isaac.GetItemIdByName("The hand")
---
---
local AllCurses = {}
local NormalCurses = {}
local BossCurses = {}

AllCurses.THE_WALL = 1 << (Isaac.GetCurseIdByName("curse of the wall") - 1)

NormalCurses[1] = AllCurses.THE_WALL
---------------------------------
local Challenges = {}
Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")

------------------------------
local PastCoins
local PastBombs
local PastKeys
----------------------------
local MultEffect = Isaac.GetEntityVariantByName("MultEffect")
local ChipsEffect = Isaac.GetEntityVariantByName("ChipsEffect")
local ActivateEffect = Isaac.GetEntityVariantByName("ActivateEffect")
local PlayerWithEffect
local LastWanted = 0
local WantedEffect --needed to prevent effects from overlapping
local EffectText = " "
local FirtsEffect = true --to prevent errors
local LastEffect = EntityEffect
local EffectRotation
local TextTypes = {"+","X","ACTIVATE!","EXTINCT!","VALUE UP!","UPGRADE!","SAFE!","INTERESTS!","$"," REMAINING"}
---------------------
local Game = Game()
local Seed
---@type RNG
local RunRNG 
local PersistentGD
local ItemsConfig = Isaac.GetItemConfig()
local ItemPool = Game:GetItemPool()
local Font = Font()
Font:Load("resources/font/upheavalmini.fnt")
-------------------------------------------
local sfx = SFXManager()
local ADDMULTSOUND = Isaac.GetSoundIdByName("ADDMULTSFX")
local TIMESMULTSOUND = Isaac.GetSoundIdByName("TIMESMULTSFX")
local ACTIVATESOUND = Isaac.GetSoundIdByName("ACTIVATESFX")
local CHIPSSOUND = Isaac.GetSoundIdByName("CHIPSSFX")
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")
-------------------------------
local TrinketValues = {} --contains the "progress" for every trinket thet needs it and other stuff
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
TrinketValues.FullDeck = {}
TrinketValues.DeckPointer = 1
--OTHER VALUES
TrinketValues.DamageTakenRoom = 0
TrinketValues.DamageTakenFloor = 0
TrinketValues.ShopEntered = false
TrinketValues.TreasureEntered = false
TrinketValues.Picked = {0}  --to prevent weird shenadigans
TrinketValues.Tags = {}
TrinketValues.EffectsAllowed = true
local Suits = {"Spades", "Hearts", "Clubs", "Diamonds"}
-----------------------------


--heyo dear mod developer college! Fell free to take any of the code written here
--but please make sure to give this mod credit when you take important/big chunks of code

--also i don't know whether or not this is good code, so if you think you have a good
--optimisation idea write it in the comments of the steam page and ill' try to implement it (giving you credit obv)

--sadly not compatible with stats+ cause i think the API isn't available yet (TELL ME IF IT CAME OUT!!)

--P.S. don't say anything about the mod's structure please, i kind of like it this way (hope i made it kind of understandable for anyone else)

-------------------OPTIMISATION FUNCTOINS------------------------------------
--these functions limit the ammount of callbacks the game has to consider for this mod using REPENTOGON's custom tags,
--i have no idea if this change is actually noticable or not, but i think it's pretty well done

--to see the list of all the custom tags and how they work, see the items.xml file


--[[
LogoSprite:Load("gfx/ui/main menu/titlemenu.anm2", true)
function mod:LogoAnimation()
    if LogoSprite:IsLoaded() then
        LogoSprite:
        LogoSprite:ReplaceSpritesheet(2, "gfx/ui/main menu/logo_up.png", true)
    end
end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.LogoAnimation)

]]--



local jimboType = Isaac.GetPlayerTypeByName("Jimbo", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root

local JimboCards = { BaseCards = Sprite()

}

JimboCards.BaseCards:Load("gfx/ui/HUD/BaseCards.anm2", true)
---@param Player EntityPlayer
function mod:PlayerRender(Player)
    for i=0, 2, 1 do
        local Card = 13 + i
        --print(Card)
        JimboCards.BaseCards.Offset = Vector(20 * i, -55)
        JimboCards.BaseCards:SetAnimation(Suits[TrinketValues.FullDeck[Card].Suit], false)
        JimboCards.BaseCards:SetFrame(TrinketValues.FullDeck[Card].Value)
        JimboCards.BaseCards.Color.A = JimboCards.BaseCards.Color.A / (i+1)
        JimboCards.BaseCards:Render(Isaac.WorldToRenderPosition(Player.Position))
        JimboCards.BaseCards.Color:Reset()
    end
    TrinketValues.DeckPointer = TrinketValues.DeckPointer + 1
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.PlayerRender)

---@param player EntityPlayer
function mod:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= jimboType then
        player:AddNullCostume(jesterhatCostume)
        player:AddNullCostume(jesterstolesCostume)
        
        player:SetPocketActiveItem(The_Hand, ActiveSlot.SLOT_POCKET, true)
        ItemPool:RemoveCollectible(The_Hand)
    end

end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.GiveCostumesOnInit)

--VVVVV-- big ass code wall incoming -VVVVV-
function mod:OnGameStart(Continued)

    PersistentGD = Isaac.GetPersistentGameData()
    Seed = Game:GetSeeds():GetStartSeed() --gets the run's seed
    RunRNG = RNG(Seed)
    --removes every callback to prevent double callbacks on continues and to remove all of them on new runs
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)
    mod:RemoveCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)
    mod:RemoveCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)
    mod:RemoveCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)
    mod:RemoveCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate) 
    mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnSpecificRoomEnter)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)
    mod:RemoveCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)
    mod:RemoveCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)
    mod:RemoveCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)
    mod:RemoveCallback(ModCallbacks.MC_USE_ITEM, mod.OnCardUse)
    
    if  Continued then
        if mod:HasData() then
            --print("data")
            TrinketValues = json.decode(mod:LoadData())
        end
    else --new run (reset all the saved values)
        mod:RemoveData()     --removes the saved trinket progress
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
        TrinketValues.MichaelDestroyed = false
        TrinketValues.GoldenMichelGone = false
        TrinketValues.FirstBrain = true
        TrinketValues.Cloud_9 = 9
        TrinketValues.Loyalty_card = 6
        TrinketValues.Labyrinth = 1
        TrinketValues.Sacrificial_dagger = 0
        TrinketValues.Swashbuckler = 0
        TrinketValues.Egg = 3
        TrinketValues.Supernova = {}
        TrinketValues.Dna = true
        TrinketValues.FullDeck = {}
        TrinketValues.DeckPointer = 1
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
        if mod:Contained(Challenges, Game.Challenge) then
            TrinketValues.ShopEntered = true
        else
            TrinketValues.ShopEntered = false
        end
        TrinketValues.DamageTakenRoom = 0
        TrinketValues.DamageTakenFloor = 0
        TrinketValues.TreasureEntered = false
        TrinketValues.Picked = {0}  --to prevent weird shenadigans
        TrinketValues.Tags = {}
        TrinketValues.EffectsAllowed = true
        return
    end

    --all of this only happens on continue runs--
    ---------------------------------------------
    --Game:GetPlayer(0):UseCard(Card.CARD_HIEROPHANT)  just tests

    for i = 0, Game:GetNumPlayers() - 1, 1 do   --evaluates again for the mod's trinkets since closing the game
                                                --resets the callbacks and the pickedTrinkets table
        local player = Game:GetPlayer(i)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end    
    --print(#TrinketValues.Tags)
    for j = 1, #TrinketValues.Tags, 1 do
        local TagX = TrinketValues.Tags[j]
        --print(TagX)
        if not (TagX == "mult" or TagX == "chips" or TagX == "multm") then
            if TagX == "newroom" then
                mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
            
            elseif TagX == "newfloor" then
                mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)

            elseif TagX == "items" then
                mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)
                mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)
                
            elseif TagX == "coins" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_COIN)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_COIN)
            elseif TagX == "bombs" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_BOMB)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_BOMB)
            elseif TagX == "keys" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_KEY)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_KEY)
            elseif TagX == "hearts" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_HEART)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_HEART)
            elseif TagX == "cards" then --also includes runes and pills
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_TAROTCARD)
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_PILL)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_PILL)
            elseif TagX == "cardremove" then --also includes runes and pills
                mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
                mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)
            
            elseif TagX == "rocks" then
                mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy)
                
            elseif TagX == "pickupnum" then --they all give the same callvack
                mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate)
            
            elseif TagX == "roomclear" then
                mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)
                
            elseif TagX == "taken" then
                mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)
                
            elseif TagX == "specificroom" then
                mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnSpecificRoomEnter)
                
            elseif TagX == "bought" then
                mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)
                
            elseif TagX == "removal" then
                mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)
            elseif TagX == "revive" then
                mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)
            elseif TagX == "restock" then
                mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)                
            elseif TagX == "carduse" then
                mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)
                mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnPillUse)
            elseif TagX == "activeuse" then
                mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnActiveUse)
            end
        end
    end
    --print(TrinketValues.Tags)
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE ,mod.OnGameStart)
                                        --btw putting IMPORTANT as the prioriry here makes it not happen


---@param trinket TrinketType
function mod:TrinketPickup(_,trinket,_)
    --print("trinket")
    local Trinket = ItemsConfig:GetTrinket(trinket)
    WantedEffect = trinket
    --these only make effects (only one per trinket)
    if not (Trinket:HasCustomTag("mult") or Trinket:HasCustomTag("chips") or Trinket:HasCustomTag("multm") or Trinket:HasCustomTag("mult/chips") or Trinket:HasCustomTag("activate")) then
        return --not a mod's trinket
    end
    --print("mod")
    if mod:Contained(TrinketValues.Picked, trinket) then --checks if the trinket was already taken this run
        return
    else
        TrinketValues.Picked[#TrinketValues.Picked+1] = trinket
        --table.insert((TrinketValues.Picked), trinket)
        --dude i swear to god, table.insert just won't work
    end
    --print("not contained")
    for i=1, #Trinket:GetCustomTags(), 1 do --needed since certain trinkets have the same tags, whick would double the callbacks
        local TagX = Trinket:GetCustomTags()[i]
        if not mod:Contained(TrinketValues.Tags, TagX) then
            TrinketValues.Tags[#TrinketValues.Tags+1] =  TagX
            if not (TagX == "mult" or TagX == "chips" or TagX == "multm" or TagX == "mult/chips") then
                --print("idk")
                if TagX == "newroom" then
                    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
            
                elseif TagX == "newfloor" then
                    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)
                
                elseif TagX == "items" then
                    --print("callback")
                    mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)
                    mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)

                
                elseif TagX == "coins" then
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_COIN)
                    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_COIN)
                elseif TagX == "bombs" then
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_BOMB)                    
                    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_BOMB)
                elseif TagX == "keys" then
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_KEY)
                    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_KEY)
                elseif TagX == "hearts" then
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_HEART)
                    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_HEART)
                elseif TagX == "cards" then --also includes runes and pills
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_TAROTCARD)
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision, PickupVariant.PICKUP_PILL)
                    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)
                    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision, PickupVariant.PICKUP_PILL)
                    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableRemove)
                    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableRemove)
                
                elseif TagX == "rocks" then
                    mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy)
                
                elseif TagX == "pickupnum" then 
                    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate)
                
                elseif TagX == "roomclear" then
                    mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)
                elseif TagX == "taken" then --damage taken
                    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)
                elseif TagX == "specificroom" then
                    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnSpecificRoomEnter)
                elseif TagX == "bought" then
                    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)
                elseif TagX == "removal" then
                    mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)
                elseif TagX == "revive" then
                    mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnDeath)
                elseif TagX == "restock" then
                    mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)
                elseif TagX == "carduse" then
                    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)
                elseif TagX == "activeuse" then
                    mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnActiveUse)
                end
            end
            
        end

    end
    --print(TrinketValues.Tags)
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.TrinketPickup)


--------------------EFFECTS FUNCTIONS---------------------------
----------------------------------------------------------------
--These functions make the whole additional gfx system work (both sound and graphics can be turend off in MOD CONFIG MENU)


---@param effect EntityEffect
function mod:EffectSpawning(effect)
    if PlayerWithEffect.CanFly then
        effect.SpriteOffset = Vector(0, -39) * PlayerWithEffect.SpriteScale   --adjusts the position to over Isaac's head and scales it basing on how many effects there are
    else
        effect.SpriteOffset = Vector(0, -35) * PlayerWithEffect.SpriteScale
    end
    effect:FollowParent(PlayerWithEffect) --makes the effect follow Isaac
    EffectRotation = math.random(90)    --slightly changes the rotation to give a little life

    if not FirtsEffect and LastEffect.Exists(LastEffect) then   
        LastEffect:Remove()
    else
        FirtsEffect = false
    end
    LastEffect = effect
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectSpawning, MultEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectSpawning, ChipsEffect)    --calls every time the custom effects are spawned
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectSpawning, ActivateEffect)

---@param effect EntityEffect
function mod:OnEffectUpdate(effect)
    local sprite = effect:GetSprite()
    sprite.Rotation = EffectRotation      --slightly changes the rotation to give a little life
    if not sprite:IsPlaying("idle") then  --removes the entity as the animation is finished
        effect:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate, MultEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate, ChipsEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate, ActivateEffect)


function mod:OnEffectRender(_,_) 
    local TextWidth = Font:GetStringWidth(EffectText)
    local position
    if PlayerWithEffect.CanFly then
        position = Isaac.WorldToScreen(PlayerWithEffect.Position) + Vector(-TextWidth/2 ,(-39 * PlayerWithEffect.SpriteScale.Y )-4)    
    else
        position = Isaac.WorldToScreen(PlayerWithEffect.Position) + Vector(-TextWidth/2 ,(-35 * PlayerWithEffect.SpriteScale.Y )-4)
    end
    Font:DrawString(EffectText, position.X, position.Y + 1, KColor(0.6,0.6,0.6,0.7)) -- emulates little text shadow
    Font:DrawString(EffectText, position.X, position.Y, KColor(1,1,1,1)) --remember, always put these in render callbacks
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.OnEffectRender, MultEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.OnEffectRender, ChipsEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.OnEffectRender, ActivateEffect)

--TYPE | 1 = + | 2 = X | 3 = activate | 4 = DESTROYED | 5 = VALUE UP
function mod:EffectConverter(TextType, Text, player, EffectID)     
    if not TrinketValues.EffectsAllowed then
        return
    end

    if Text == 0 then --would be 0.00 otherwise
        Text = "0"
    end       

    if TextType == #TextTypes then
        Text = tostring(Text)..TextTypes[TextType]
    else
        if TextType == 9 then 
            Text = TextTypes[1]..tostring(Text)..TextTypes[9]
        elseif TextType >= 3 then --no need for numbers on certain occasions
            Text = ""
        else
            Text = TextTypes[TextType]..tostring(Text)
        end
    end
    mod:SpawnTheEffect(player, EffectID, Text)
end


--ID: 0 = noting|1 = +Mult | 2 = *Mult | 3 = Chips | 4 = Activate | 5 = slice | 6 = money
function mod:SpawnTheEffect(PlayerEffect, effectID, Text) 
    PlayerWithEffect = PlayerEffect  --needed for followparent [see on effect init]
    
    if (not FirtsEffect and LastEffect:Exists()) and (LastWanted ~= WantedEffect and 0) then
        --print("delayed")
        Isaac.CreateTimer(function()
                        mod:SpawnTheEffect(PlayerEffect, effectID, Text)
                        end, 25, 1, false)
        return
    end
    EffectText = Text
    --print(WantedEffect)
    --print("spawned")
    if effectID == 1 then --mult
        Isaac.Spawn(1000, MultEffect, 0, PlayerEffect.Position, Vector.Zero, PlayerEffect)
        sfx:Play(ADDMULTSOUND, 1, 0, false, 1, 0)

    elseif effectID == 2 then --times mult
        Isaac.Spawn(1000, MultEffect, 0, PlayerEffect.Position, Vector.Zero, PlayerEffect)
        sfx:Play(TIMESMULTSOUND, 1, 0, false, 1, 0)

    elseif effectID == 3 then --chips
        Isaac.Spawn(1000, ChipsEffect, 0, PlayerEffect.Position, Vector.Zero, PlayerEffect)
        sfx:Play(CHIPSSOUND, 1, 0, false, 1, 0)

    elseif effectID == 4 then --activate
        Isaac.Spawn(1000, ActivateEffect, 0, PlayerEffect.Position, Vector.Zero, PlayerEffect)
        sfx:Play(ACTIVATESOUND, 1, 0, false, 1, 0)
    
    elseif effectID == 5 then --slice
        Isaac.Spawn(1000, MultEffect, 0, PlayerEffect.Position, Vector.Zero, PlayerEffect)
        sfx:Play(SLICESOUND, 1, 0, false, 1, 0)
    elseif effectID == 6 then --money
        Isaac.Spawn(1000, ActivateEffect, 0, PlayerEffect.Position, Vector.Zero, PlayerEffect)
        sfx:Play(ACTIVATESOUND, 1, 0, false, 1, 0) --placeholdersound
    else
        return
    end
    LastWanted = WantedEffect
    WantedEffect = 0
end
-----------------OTHER/OFTEN USED FUNCTIONS---------------------
----------------------------------------------------------------
--general function used in the code

--rounds down to numDecimal of spaces
function mod:round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

--if X is inside of list
function mod:Contained(list, x)
	for _, v in pairs(list) do
	    if v == x then
            return true 
        end
	end
	return false
end

function mod:CalculateTearsUp(currentMaxFireDelay, TearsAdded)
    --big ass math jumpscare (CHAT GPT moment) needed to give a stable tears up (like pisces)
    local currentTearsPerSecond = 30 / (currentMaxFireDelay + 1)
    local targetTearsPerSecond = currentTearsPerSecond + TearsAdded
    local FireDelayToAdd = currentMaxFireDelay - ((30 / targetTearsPerSecond) - 1) 

    return FireDelayToAdd
end

--returns a shuffled version of the given table
function mod:Shuffle(table)
    for i = #table, 2, -1 do
        local j = RunRNG:RandomInt(i)
        table[i], table[j] = table[j], table[i]
    end
    return table
end
---------------CURSES/CHALLENGES-----------------
-------------------------------------------------
--all the code regarding the custom challenges and curses
--since i'm a masochist, the curse callbacks are only added when needed just like the trinket's do


-----------CALLBACK SYSTEM/CHALLENGE FUNCTIONALITY--------------------

--restores the callbacks for the curses
function mod:ChallengeSetup(Continued)
    --challenge functionality reset
    mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.ChallengeRoomClear)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ChallengeRoomEntrance)
    mod:RemoveCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.ShopItems)
    mod:RemoveCallback(ModCallbacks.MC_GET_CARD, mod.ChallengeCards)
    mod:RemoveCallback(ModCallbacks.MC_GET_TRINKET, mod.ChallengeTrinkets)
    mod:RemoveCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, mod.DoorBehaviour)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.CoinWaveSpawn, PickupVariant.PICKUP_COIN)

    --curse functions reset
    mod:RemoveCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CurseNPCInit)
    mod:RemoveCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.CurseNPCUpdate)

    --only adds the required callbacks if it's a challenge
    if mod:Contained(Challenges, Game.Challenge) then
        --sets starting money
        if not Continued then
            Game:GetPlayer(0):AddCoins(4)
        end
        mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.ChallengeRoomClear)
        mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.ShopItems)
        mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.ChallengeTrinkets)
        mod:AddCallback(ModCallbacks.MC_GET_CARD, mod.ChallengeCards)
        mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ChallengeRoomEntrance)
        mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, mod.DoorBehaviour)
        mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.CoinWaveSpawn, PickupVariant.PICKUP_COIN)
        
        local CurrentCurse = Game:GetLevel():GetCurses()
        if CurrentCurse == AllCurses.THE_WALL then
            mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CurseNPCInit)
            mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.CurseNPCUpdate)
        end      
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE ,mod.ChallengeSetup)



--chooses a random custom curse when needed
function mod:ChooseChallengeCurse(_)
    --print("curse eval")
    if mod:Contained(Challenges, Game.Challenge) then
        --curses callbacks reset
        mod:RemoveCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CurseNPCInit)
        mod:RemoveCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.CurseNPCUpdate)

        local RNG = RNG(Seed)
        local ChosenCurse = RNG:RandomInt(1, #NormalCurses)
        --only adds the required callbacks to make the curse function
        if NormalCurses[ChosenCurse] == AllCurses.THE_WALL then
            --print("wall chosen")
            mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CurseNPCInit)
            mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.CurseNPCUpdate)
        end
        return NormalCurses[ChosenCurse]
    end
end
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.ChooseChallengeCurse)


--sets the ammont of coins spawned when waves are cleared
function mod:ChallengeRoomClear()
    --print("clear")
    local Wave = Game:GetLevel().GreedModeWave
    --print(Wave)
    if Wave == 9 then
        local Player = Game:GetPlayer(0)

        local Interests = math.floor(Player:GetNumCoins()/5)
        if Interests > 5 then
            Interests = 5
        end

        Player:AddCoins(3)
        mod:EffectConverter(9, 3,Player,4)

        Isaac.CreateTimer(function ()
            for i = 1, Interests, 1 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position , RandomVector() * 3, Player, CoinSubType.COIN_PENNY, Seed)
                mod:EffectConverter(8,0,Player,4)
            end 
        end, 21, 1, true)
    
    elseif Wave == 11 then
        TrinketValues.ShopEntered = false
        local Player = Game:GetPlayer(0)

        local Interests = math.floor(Player:GetNumCoins()/5)
        if Interests > 5 then
            Interests = 5
        end

        Player:AddCoins(4)
        mod:EffectConverter(9, 4,Player,4)

        Isaac.CreateTimer(function ()
            for i = 1, Interests, 1 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position , RandomVector() * 3, Player, CoinSubType.COIN_PENNY, Seed)
                mod:EffectConverter(8,0,Player,4)
            end 
        end, 21, 1, true)
    elseif Wave == 12 then
        TrinketValues.ShopEntered = false
        local Player = Game:GetPlayer(0)

        local Interests = math.floor(Player:GetNumCoins()/5)
        if Interests > 5 then
            Interests = 5
        end

        Player:AddCoins(5)
        mod:EffectConverter(9, 5,Player,4)

        Isaac.CreateTimer(function ()
            for i = 1, Interests, 1 do
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position , RandomVector() * 3, Player, CoinSubType.COIN_PENNY, Seed)
                mod:EffectConverter(8,0,Player,4)
            end 
        end, 21, 1, true)
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.ChallengeRoomClear)

function mod:ChallengeRoomEntrance()
    local Room =  Game:GetRoom()
    if Room:GetType() == RoomType.ROOM_SHOP and not TrinketValues.ShopEntered then
        Room:ShopRestockFull()
    elseif Room:GetType() == RoomType.ROOM_GREED_EXIT then
        --for some reason it's bugges and the trapdoor for the next floor won't spawn
        Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Room:GetCenterPos())
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ChallengeRoomEntrance)

--this part is kind of complicated, so hope i explained it well in the code

--the shops and cursed rooms only open when you completed the wave chunks (normal-boss-nightmare) and NOT in the middle of them
--the golden treasure is always closed, while the silver one is always open 
--the nightmare wave is now mandatory to finish the floor
---@param Door GridEntityDoor
function mod:DoorBehaviour(Door)

    --door cannot be closed if it leads back to the startin room/if it's a silver treasure/if it's a secret room door
    if not(Door.TargetRoomType == RoomType.ROOM_DEFAULT or Door.TargetRoomType == RoomType.ROOM_BOSS) and Door:GetGridIndex() ~= 179 and Door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and Door.CurrentRoomType ~= RoomType.ROOM_SUPERSECRET then

        --always closes golden treasure
        if Door.TargetRoomType == RoomType.ROOM_TREASURE then
            Door:Bar()
        
        else
            local Wave = Game:GetLevel().GreedModeWave
            if Wave ~= 11 then --waves between the three segments
            
                if Wave ~= 12 then 

                    --closes the exit if it's not after the nightmare wave
                    if Door.TargetRoomType == RoomType.ROOM_GREED_EXIT then
                        Door:Bar()

                    --closes all doors when it's not an in-between of the waves
                    elseif Wave ~= 9 then
                        Door:Bar()
                    end
                end
            else --wave 10 (between boss and nightmare)
            
                --closes the exit after the boss waves
                if Door.TargetRoomType == RoomType.ROOM_GREED_EXIT then
                    Door:Bar()
                end
            end
        end
    end    
end
--mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, mod.DoorBehaviour)

---@param Pickup EntityPickup
function mod:CoinWaveSpawn(Pickup)
    --the coins given between waves in greed mode have a nil spawner variable
    if not Pickup.SpawnerEntity then
        Pickup:Remove()
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.CoinWaveSpawn, PickupVariant.PICKUP_COIN)


function mod:ShopItems(Variant, SubType, _, Price)
    local NewPrice = Price
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local Quality = ItemsConfig:GetCollectible(SubType).Quality
        NewPrice = 2 + (math.ceil(1.83 ^ Quality)) -- |Q0 2 |Q1 4|Q2 6|Q3 9|Q4 13|

        if Game:GetRoom():GetType() == RoomType.ROOM_DEVIL then --little discount for devil deals
            NewPrice = NewPrice - math.floor(NewPrice/4) -- |Q0 2|Q1 3|Q2 5|Q3 7|Q4 10|
        end

    elseif Variant == PickupVariant.PICKUP_TAROTCARD then
        local CardType = ItemsConfig:GetCard(SubType).CardType
        if CardType == ItemConfig.CARDTYPE_SPECIAL then
            NewPrice = 4
        elseif CardType == ItemConfig.CARDTYPE_SUIT or CardType == ItemConfig.CARDTYPE_TAROT_REVERSE then
            NewPrice = 5
        elseif CardType == ItemConfig.CARDTYPE_RUNE then
            NewPrice = 3
        else
            NewPrice = 2
        end

    elseif Variant == PickupVariant.PICKUP_TRINKET then
        NewPrice = 5
        local TrinketConfig = ItemsConfig:GetTrinket(SubType)
        if TrinketConfig:HasCustomTag("givescoins") then --increases cost if the trinket can give you money
            local Tags = TrinketConfig:GetCustomTags()
            NewPrice = NewPrice + 6 - #Tags
        end
    elseif Variant == PickupVariant.PICKUP_LIL_BATTERY or Variant == PickupVariant.PICKUP_BOMB or Variant == PickupVariant.PICKUP_HEART or Variant == PickupVariant.PICKUP_PILL then
        NewPrice = 2
    end

    return NewPrice
end
--mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.ShopItems)


function mod:ChallengeTrinkets(Trinket, _)
    local FirstTag = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[1] --the mod's trinkets all have a specific first customtag
    
    if not (FirstTag == "mult" or FirstTag == "chips" or FirstTag == "activate" or FirstTag == "multm") then
        repeat
            Trinket = ItemPool:GetTrinket()
            FirstTag = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[1]
        --only allows mod's trinkets to be chosen
        until FirstTag == "mult" or FirstTag == "chips" or FirstTag == "activate" or FirstTag == "multm"
        return Trinket
    end
end
--mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.ChallengeTrinkets)

---@param Rng RNG
function mod:ChallengeCards(Rng, SelectedCard, CanBeSuit, CanBeRunes, OnlyRunes)
    --does not allow cards that generate too much money/ do useless things
    if SelectedCard == Card.CARD_ACE_OF_DIAMONDS or SelectedCard == Card.CARD_SOUL_KEEPER or SelectedCard == Card.CARD_DIAMONDS_2 or SelectedCard == Card.CARD_GET_OUT_OF_JAIL then 
        repeat
            SelectedCard = ItemPool:GetCard(Rng:GetSeed(), CanBeSuit, CanBeRunes, OnlyRunes)
        until SelectedCard ~= Card.CARD_ACE_OF_DIAMONDS or SelectedCard ~= Card.CARD_SOUL_KEEPER or SelectedCard ~= Card.CARD_DIAMONDS_2 or SelectedCard ~= Card.CARD_GET_OUT_OF_JAIL
        return SelectedCard
    end
end
--mod:AddCallback(ModCallbacks.MC_GET_CARD, mod.ChallengeCards)
-------------------CURSES FUNCTIONS--------------------------

----------------WALL--------------------------
---@param Entity EntityNPC 
function mod:CurseNPCInit(Entity)
    --print(Entity.Type)
    local Level = Game:GetLevel()
    if Level:GetCurses() & AllCurses.THE_WALL == AllCurses.THE_WALL then
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
--mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CurseNPCInit)


---@param Entity EntityNPC 
function mod:CurseNPCUpdate(Entity)
    --print("enemy update "..Entity.Type)
    local Level = Game:GetLevel()
    if Level:GetCurses() & AllCurses.THE_WALL == AllCurses.THE_WALL then
        --print("wall")
        if Entity:IsEnemy() then
            Entity.Velocity = Entity.Velocity * 0.85
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.CurseNPCUpdate)


--------------TRINKETS/ITEMS CALLBACKS---------------
-----------------------------------------------------

--all of the callbacks used by the trinkets and items made by this mod

--STATS TRINKETS: their value is increassed/decreades in their assingned callbacks
                --while the statups are given in their cache evaluation functions

--ACTIVATE TRINKETS: usually all they do is put in function called whenever it needs to activate,
                --   which are inside the section of the cache evaluation functions

function mod:OnGetTrinket(Selected, SEED)
    if TrinketValues.MichaelDestroyed then--michael was destroyed previously

        if TrinketValues.GoldenMichelGone then --3% to replace with cavendish if a golden michael was destroyed
            local RNG = RNG(SEED)

            if RNG:RandomFloat() <= 0.03 then
                return Cavendish
            end
        end
        if Selected == Gros_michael  then
            local Trinket
            repeat
                Trinket = ItemPool:GetTrinket()
            until Trinket ~= Gros_michael
            return Trinket
        end

    else--michael was not destroyed

        if Selected == Cavendish then  --prevents cavemdish from being chosen
            local Trinket
            repeat
                Trinket = ItemPool:GetTrinket()
            until Trinket ~= Cavendish
            return Trinket
        end
    end
    
end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.OnGetTrinket)

---@param player EntityPlayer
function mod:SpecificTrinket(player,trinket,_)
    if trinket == Blueprint then 
        mod:BluePrint(player, true)
    end
    if trinket == Brainstorm then
        mod:BrainStorm(player, true)
    end
    if trinket == Supernova then
        for i = 0, 1, 1 do
            local Active = player:GetActiveItem(i)
            if not TrinketValues.Supernova[Active] then
                TrinketValues.Supernova[Active] = 0
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.SpecificTrinket)


function mod:OnItemRemoval(player,item)
    if player:HasTrinket(Abstract_joker) then
        WantedEffect = Abstract_joker
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Evensteven) then
        WantedEffect = Evensteven
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Joker_stencil) then
        WantedEffect = Joker_stencil
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Oddtodd) then
        WantedEffect = Oddtodd
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(Supernova) then
        local itemsconfig = ItemsConfig:GetCollectible(item)
        if itemsconfig.Type == ItemType.ITEM_ACTIVE then
            WantedEffect = Supernova
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.OnItemRemoval)

function mod:AlwaysOnItemPickup(item,_,_,_,_,_)
    local itemconfig = ItemsConfig:GetCollectible(item)
    if itemconfig.Type ~= ItemType.ITEM_ACTIVE and itemconfig.Type ~= ItemType.ITEM_TRINKET then
        --print("passive")
        --print("picked up")
        if TrinketValues.Brainstorm == 0 then
            TrinketValues.Brainstorm = item
        end
        TrinketValues.Blueprint = item
    end
    --print(TrinketValues.Brainstormitem)
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AlwaysOnItemPickup)

function mod:OnTrinketRemoval(player,trinket)
    --print("removed")
    if trinket == Blueprint then
        mod:BluePrint(player, false)
        TrinketValues.LastBPitem = 0
    end
    if trinket == Brainstorm then
        mod:BrainStorm(player,false)
    end
    if trinket == Egg then
        mod:EGG(player, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnTrinketRemoval)

function mod:OnItemPickup(item,_,first,_,_,player)
    if player:HasTrinket(Blueprint) and first then
        WantedEffect = Blueprint
        mod:BluePrint(player, true)
    end
    if TrinketValues.FirstBrain and player:HasTrinket(Brainstorm) then
        WantedEffect = Brainstorm
        mod:BrainStorm(player, true)
    end
    if player:HasTrinket(Abstract_joker) then
        WantedEffect = Abstract_joker
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Evensteven) then
        WantedEffect = Evensteven
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Joker_stencil) then
        WantedEffect = Joker_stencil
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Oddtodd) then
        WantedEffect = Oddtodd
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(Supernova) then
        local itemconfig = ItemsConfig:GetCollectible(item)
        if itemconfig.Type == ItemType.ITEM_ACTIVE then
            if not TrinketValues.Supernova[item] then
                TrinketValues.Supernova[item] = 0
            end
            WantedEffect = Supernova
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end 
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnItemPickup)

function mod:AlwaysOnNewRoom()
    Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_SHOP then
        TrinketValues.ShopEntered = true
    elseif Room == RoomType.ROOM_TREASURE then
        TrinketValues.TreasureEntered = true
    end
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if TrinketValues.Cloud_9 == 0 then
            if player:GetTrinketMultiplier(Cloud_nine) > 1 then
                TrinketValues.Cloud_9 = 5
            else
                TrinketValues.Cloud_9 = 9
            end
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM,CallbackPriority.LATE, mod.AlwaysOnNewRoom)

function mod:OnNewRoom()
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if player:HasTrinket(Misprint) then --plus mult jokers
            WantedEffect = Misprint
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(Bloodstone) then
            WantedEffect = Bloodstone
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if TrinketValues.Cloud_9 == 0 then
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)


function mod:OnSpecificRoomEnter()
   
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnSpecificRoomEnter)

--determines if shop/treasures can be skipped this floor
function mod:AlwaysOnNewFloor()
    TrinketValues.DamageTakenFloor = 0
    TrinketValues.Dna = true
    TrinketValues.Rocks = 0
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        if  player:HasTrinket(Stone_joker) then
            WantedEffect = Stone_joker
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end

    --DETERMINATION FOR THE PRESENCE OF TRESURES ROOMS/SHOPS--
    --TRUE = NO shops/treasures
    --FALSE = AVAILABLE Shops/treasures

    local Level = Game:GetLevel()
    if Level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
        TrinketValues.Labyrinth = 2
    else
        TrinketValues.Labyrinth = 1
    end
    if Level:IsAscent() then
        TrinketValues.ShopEntered = true
        TrinketValues.TreasureEntered = true
    end
    local Greed = Game:IsGreedMode()
    local Stage = Level:GetAbsoluteStage()
    TrinketValues.ShopEntered = false
    TrinketValues.TreasureEntered = false
    local LevelName = Level:GetName()
    if Stage == LevelStage.STAGE4_1 and not Greed  then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
            TrinketValues.TreasureEntered = true
        end
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_SILVER_DOLLAR) then
            TrinketValues.ShopEntered = true
        end
    elseif LevelName == "Sheol" and not Greed then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_WICKED_CROWN) then
            TrinketValues.TreasureEntered = true
            TrinketValues.ShopEntered = true
        end

    elseif LevelName == "Cathedral" then
        if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_HOLY_CROWN) then
            TrinketValues.TreasureEntered = true
            TrinketValues.ShopEntered = true
        end
    elseif LevelName == "Shop" then --greed mode floor
        TrinketValues.TreasureEntered = true
    elseif Stage >= LevelStage.STAGE6 then --anything after sheol/cathedral
        TrinketValues.TreasureEntered = true
            TrinketValues.ShopEntered = true
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, mod.AlwaysOnNewFloor)

function mod:OnNewFloor()
    --print("new floor")
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
        
        if player:HasTrinket(Invisible_Joker) then --activate jokers
            WantedEffect = Invisible_Joker
            mod:InvisibleJoker(player) --activates the invisible joker trinket
        end
        if player:HasTrinket(Popcorn) then
            TrinketValues.Popcorn = TrinketValues.Popcorn - 0.4
            WantedEffect = Popcorn
            if TrinketValues.Popcorn <= 0.3 then
                repeat
                    player:TryRemoveTrinket(Popcorn)
                    player:TryRemoveSmeltedTrinket(Popcorn)
                until not player:HasTrinket(Popcorn)
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                TrinketValues.Popcorn = 2 --resets in case the player gets another one
                return --does nothing, just stops the function
            end
                
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if  player:HasTrinket(Rocket) then
            WantedEffect = Rocket
            mod:rocket(player)
        end
        if player:HasTrinket(Red_card) then
            if TrinketValues.ShopEntered == false then
                TrinketValues.Red_card = TrinketValues.Red_card + 0.20
            end
            if TrinketValues.TreasureEntered == false then
                TrinketValues.Red_card = TrinketValues.Red_card + (0.20 * TrinketValues.Labyrinth)
            end
            WantedEffect = Red_card
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(Riff_raff) then
            WantedEffect = Riff_raff
            mod:RiffRaff(player)
        end
        if player:HasTrinket(Golden_joker) then
            WantedEffect = Golden_joker
            mod:Goldenjoker(player)
        end
        if player:HasTrinket(Madness) then
            RNG = player:GetTrinketRNG(Madness)
            if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B and  player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
                    if player:GetNumCoins() > 0 then
                        for i = 1, player:GetTrinketMultiplier(Madness), 1 do
                            TrinketValues.Madness = TrinketValues.Madness + (math.floor(player:GetNumCoins()/5) / 100)
                            player:AddCoins(- player:GetNumCoins())
                        end
                    end
                else --NON KEEPER ONLY
                    
                    for i = 1, player:GetTrinketMultiplier(Madness), 1 do
                        if player:GetMaxHearts() > 2 then
                    
                            player:AddMaxHearts(-2, true)
                            TrinketValues.Madness = TrinketValues.Madness + 0.05
                        elseif player:GetMaxHearts() == 0 then
                    
                            if player:GetSoulHearts() > 2 then
                                player:AddSoulHearts(-2)
                            TrinketValues.Madness = TrinketValues.Madness + 0.05
                            end
                        end
                    end
                end
            end
            for i = 0, player:GetTrinketMultiplier(Madness) , 1 do
                local ItemCount = player:GetCollectibleCount()
                if ItemCount == 0 then
                    break
                end
                local Item
                repeat
                    Item = RNG:RandomInt(1, CollectibleType.NUM_COLLECTIBLES)
                until player:HasCollectible(Item, true, false)
                player:RemoveCollectible(Item)
                TrinketValues.Madness = TrinketValues.Madness + 0.05
            end
            WantedEffect = Madness
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end

        if player:HasTrinket(Sacrificial_dagger) then
            local Active = player:GetActiveItem(i)
            if Active ~= 0 then
                --print("Active")
                player:RemoveCollectible(Active, true, i)
                TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                sfx:Play(SLICESOUND)
            end
            if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B and  player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
                    if player:GetNumCoins() > 0 then
                        for i = 1, player:GetTrinketMultiplier(Sacrificial_dagger), 1 do
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + player:GetNumCoins()/100
                            player:AddCoins(- player:GetNumCoins())
                            sfx:Play(SLICESOUND)
                        end
                    end
                else --KEEPER ONLY
                    for i = 1, player:GetTrinketMultiplier(Sacrificial_dagger), 1 do
                        if player:GetMaxHearts() > 2 or (player:GetMaxHearts() == 2 and player:GetSoulHearts() > 0)then
                    
                            player:AddMaxHearts(-2, true)
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                            sfx:Play(SLICESOUND)
                        elseif player:GetSoulHearts() > 2 then

                            player:AddSoulHearts(-2)
                            TrinketValues.Sacrificial_dagger = TrinketValues.Sacrificial_dagger + 0.25
                            sfx:Play(SLICESOUND)
                        end
                    end
                end
            end
            WantedEffect = Sacrificial_dagger
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        if player:HasTrinket(Gros_michael) then
            local RNG = player:GetTrinketRNG(Gros_michael) 
            local Chance = 0.34
            if RNG:RandomFloat() <= Chance then
                TrinketValues.MichaelDestroyed = true
                WantedEffect = "MCdestroyed"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                for i=0, player:GetMaxTrinkets() - 1, 1 do
                    local Trinket = player:GetTrinket(i)
                    if Trinket == (Gros_michael + TrinketType.TRINKET_GOLDEN_FLAG) then
                        TrinketValues.GoldenMichelGone = true 
                    end
                end 
                repeat
                    player:TryRemoveTrinket(Gros_michael)
                    player:TryRemoveSmeltedTrinket(Gros_michael)
                until not player:HasTrinket(Gros_michael)
            else
                WantedEffect = "MCsafe"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Cavendish) then
            local RNG = player:GetTrinketRNG(Cavendish) 
            local Chance = 0.002
            if RNG:RandomFloat() <= Chance and player:GetTrinketMultiplier(Cavendish) == 1 then --unlucky man
                WantedEffect = "MCdestroyed"
                TrinketValues.MichaelDestroyed = false
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                repeat
                    player:TryRemoveTrinket(Cavendish)
                    player:TryRemoveSmeltedTrinket(Cavendish)
                until not player:HasTrinket(Cavendish)
            else
                WantedEffect = "MCsafe"
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Cartomancer) then
            WantedEffect = Cartomancer
            mod:CArtomancer(player)
        end
        if player:HasTrinket(Egg) then
            --print("egg")
            WantedEffect = Egg
            mod:EGG(player, false)
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)


--AGGIUNGI ROBA QUANDO SERVIRà
---@param pickup EntityPickup
function mod:PrePickupCollision(pickup, collider)
    
end
--mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PrePickupCollision)



function mod:OnPickupCollision(pickup, collider,_)
    --checks who collided
    if collider.GetType(collider) == EntityType.ENTITY_PLAYER then --checks if a player collided with the pickup
        
        local player = collider:ToPlayer()
        if player:HasTrinket(Cloud_nine) then
            if TrinketValues.Cloud_9 == 0 then
                if player:GetTrinketMultiplier(Cloud_nine) == 1 then
                    TrinketValues.Cloud_9 = 5
                else
                    TrinketValues.Cloud_9 = 9
                end
            else
                TrinketValues.Cloud_9 = TrinketValues.Cloud_9 - 1
            end
            if player:GetTrinketMultiplier(Cloud_nine) > 1 and TrinketValues.Cloud_9 > 5 then
                TrinketValues.Cloud_9 = 5
            end
            WantedEffect = Cloud_nine
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
        if player:HasTrinket(Smeared_joker) then
            WantedEffect = Smeared_joker
            mod:SmearedJoker(player, pickup)
        end

        if pickup.Variant == PickupVariant.PICKUP_COIN then 
        
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB then

        elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
                
            if player:HasTrinket(Joker_stencil) then  --times mult jokers
                WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        
        elseif pickup.Variant == PickupVariant.PICKUP_PILL then
            if player.HasTrinket(Joker_stencil) then  --times mult jokers
                WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        
        end

    else
        return nil
    end       
end
--mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnPickupCollision)

function mod:AlwaysOnCardUse(card,player,_)
    --print("card used")
    --print(TrinketValues.Fortune_Teller)
    local CardConfig = ItemsConfig:GetCard(card) 
    if CardConfig.CardType == ItemConfig.CARDTYPE_TAROT then --normal tarot
        
        TrinketValues.Fortune_Teller = TrinketValues.Fortune_Teller + (0.05 * player:GetTrinketMultiplier(Fortuneteller))
    elseif CardConfig.CardType == ItemConfig.CARDTYPE_TAROT_REVERSE then --reverse tarot
        TrinketValues.Fortune_Teller = TrinketValues.Fortune_Teller - 0.05
        if TrinketValues.Fortune_Teller < 0 then
            TrinketValues.Fortune_Teller = 0
        end
    end
    if player:HasTrinket(Fortuneteller) then
        --print("fortuneteller")
        WantedEffect = Fortuneteller
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.AlwaysOnCardUse)


function mod:OnCardUse(card,player,_)
    if player:HasTrinket(Dna) then
        mod:DNA(player, PickupVariant.PICKUP_TAROTCARD, card)
    end
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse)

function mod:OnPillUse(pill,player,_)
    if player:HasTrinket(Dna) then
        mod:DNA(player, PickupVariant.PICKUP_PILL, pill)
    end
end
--mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnPillUse)

function mod:OnActiveUse(Active,_,player,_,_,_)
    if player:HasTrinket(Dna) then
        --needs a frame to maket the single use active items disappear
        Isaac.CreateTimer(function ()
            mod:DNA(player, PickupVariant.PICKUP_COLLECTIBLE, Active)
        end, 1, 1, true)
        
    end
end
--mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnActiveUse)


function mod:OnConsumableRemove(player,_,_) --whenever a card/pill is lost from the player
        if player:HasTrinket(Joker_stencil) then  --times mult jokers
            WantedEffect = Joker_stencil
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, mod.OnConsumableUse)
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_PILL, mod.OnConsumableUse)

---@param RockType GridEntityType
function mod:OnRockDestroy(_,RockType,_)
    
    for i=0, Game:GetNumPlayers()-1, 1 do --cycles through the players
        local player = Game:GetPlayer(i)
            if player:HasTrinket(Stone_joker) then
                local Multiplier = 1

                if RockType == GridEntityType.GRID_ROCKT then --tinted rocks give 3X progress
                    Multiplier = 3
                elseif RockType == GridEntityType.GRID_ROCK_SS then --super tinted rock give 5X progress
                    Multiplier = 5
                end

                if TrinketValues.Stone_joker <= 25 then
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.06 * Multiplier)
                elseif  TrinketValues.Stone_joker <= 75 then
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.03 * Multiplier)
                else
                    TrinketValues.Stone_joker = TrinketValues.Stone_joker + (0.01 * Multiplier)
                end

                WantedEffect = Stone_joker
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                break
            end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.OnRockDestroy, GridEntityType.GRID_ROCK)

---@param player EntityPlayer
function mod:OnUpdate(player)
    local NowCoins = player:GetNumCoins()
    local NowBombs = player:GetNumBombs()
    local NowKeys = player:GetNumKeys()
    --local NowHearts = player:GetHearts()
    if NowCoins ~= PastCoins then
        if player:HasTrinket(Joker_stencil) then
            if NowCoins == 0 or PastCoins == 0 then
                WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Bull) then
            WantedEffect = Bull
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
        PastCoins = NowCoins
    end

    if NowBombs ~= PastBombs then
        if player:HasTrinket(Joker_stencil) then
            if NowBombs == 0 or PastBombs == 0 then
                WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Onix_agate) then
            WantedEffect = Onix_agate
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
        PastBombs = NowBombs
    end

    if NowKeys ~= PastKeys then
        if player:HasTrinket(Joker_stencil) then
            if NowKeys == 0 or PastKeys == 0 then
                WantedEffect = Joker_stencil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
        end
        if player:HasTrinket(Arrowhead) then
            WantedEffect = Arrowhead
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
        PastKeys = NowKeys
    end

    --if NowHearts ~= PastHearts then
        
        --PastHearts = NowHearts
    --end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUpdate)

---@param player EntityPlayer
function mod:OnRoomClear(player)
    --print("cleared")

    --MANY TRINKETS ONLY ACTIVATE IN GREED MODE WHEN THE MAJOR WAVE CHUNKS ARE COMPLETED
    local Wave = Game:GetLevel().GreedModeWave --current wave in greed mode
    local WantedWaves = {}
    local IsGreed = Game:IsGreedMode()
    if IsGreed then
        if Game:IsHardMode() then
            WantedWaves = {9,11,12} --greedier last waves
        else
            WantedWaves = {8,10,11} --greed last waves
        end
    end
    --if greed then only on specific waves, else happens anyways
    if not IsGreed or mod:Contained(WantedWaves, Wave) or Game:GetLevel():GetName() == "shop" then
        --print("consider clear")
    if player:HasTrinket(Vagabond) then
        --print("vagabond")
        WantedEffect = Vagabond
        mod:VAgabond(player)
    end
    if player:HasTrinket(Rough_gem) then
        WantedEffect = Rough_gem
        mod:RoughGem(player)
    end
    if player:HasTrinket(Loyalty_card) then
        if TrinketValues.Loyalty_card == 0 then
            if player:GetTrinketMultiplier(Loyalty_card) == 1 then
                TrinketValues.Loyalty_card = 5
            else
                TrinketValues.Loyalty_card = 3
            end
        else
            TrinketValues.Loyalty_card = TrinketValues.Loyalty_card - 1
        end
        if player:GetTrinketMultiplier(Loyalty_card) > 1 and TrinketValues.Loyalty_card > 4 then
            TrinketValues.Loyalty_card = 4
        end
        WantedEffect = Loyalty_card
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Delayed_gratification) then
        mod:DelayedGratification(player)
    end
    end
    --EXCEPTIONS TO THE GREED MODE WAVE CHECK
    if player:HasTrinket(Icecream) then
        WantedEffect = Icecream
        TrinketValues.Ice_cream = TrinketValues.Ice_cream - 0.05
        if TrinketValues.Ice_cream <= 0 then
            repeat
                player:TryRemoveTrinket(Icecream)
                player:TryRemoveSmeltedTrinket(Icecream)
            until not player:HasTrinket(Icecream)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
            TrinketValues.Ice_cream = 1 --resets in case the player find another one
            return --does nothing, just stops the function
        end
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
    if player:HasTrinket(Green_joker) then
        WantedEffect = Green_joker
        TrinketValues.Green_joker = TrinketValues.Green_joker + (0.04 * player:GetTrinketMultiplier(Green_joker))
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Supernova) then
        for i = 0, 1, 1 do
            local Active = player:GetActiveItem(i)
            if Active ~= 0 then
                TrinketValues.Supernova[Active] = TrinketValues.Supernova[Active] + (0.04 * player:GetTrinketMultiplier(Supernova))
            end
        end
        WantedEffect = Supernova
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.OnRoomClear)

function mod:AlwaysOnTakenDamage(_)
    TrinketValues.DamageTakenRoom = TrinketValues.DamageTakenRoom + 1
    TrinketValues.DamageTakenFloor = TrinketValues.DamageTakenFloor + 1
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.AlwaysOnTakenDamage, EntityType.ENTITY_PLAYER)

function mod:OnTakenDamage(player,_,_,_,_)
    player = player:ToPlayer() --initially it's a generic entity
    if player:HasTrinket(Ramen) then
        WantedEffect = Ramen
        TrinketValues.Ramen = TrinketValues.Ramen - 0.02
        if TrinketValues.Ramen <= 1 then
            repeat
                player:TryRemoveTrinket(Ramen)
                player:TryRemoveSmeltedTrinket(Ramen)
            until not player:HasTrinket(Ramen)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            TrinketValues.Ramen = 1.3 --resets in case the player find another one
            return
        end
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
    if player:HasTrinket(Green_joker) then
        TrinketValues.Green_joker = TrinketValues.Green_joker - 0.5
        if TrinketValues.Green_joker < 0 then
            TrinketValues.Green_joker = 0
        end
        WantedEffect = Green_joker
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakenDamage, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function mod:OnShopPurchase(_,player,cost)
    if player:HasTrinket(Hallucination) then
        WantedEffect = Hallucination
        mod:HAllucination(player, cost)
    end
    if player:HasTrinket(Swashbuckler) then
        --print(cost)
        local increase = 0
        if cost > 0 then
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B) then
                increase = (cost * 0.01)
            else
                increase = (cost * 0.02)
            end
            
        elseif cost > PickupPrice.PRICE_FREE then
            if cost == PickupPrice.PRICE_ONE_HEART or cost == PickupPrice.PRICE_ONE_SOUL_HEART or cost == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART or cost == PickupPrice.PRICE_SOUL then
                
                increase = 0.20
            elseif cost == PickupPrice.PRICE_TWO_HEARTS or cost == PickupPrice.PRICE_TWO_SOUL_HEARTS or cost == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS then
                
                increase = 0.40
            elseif cost == PickupPrice.PRICE_THREE_SOULHEARTS then

                increase = 0.25
            elseif cost == PickupPrice.PRICE_SPIKES then

                increase = 0.10
            end
        end
        TrinketValues.Swashbuckler = TrinketValues.Swashbuckler + increase
        if increase > 0 then
            WantedEffect = Swashbuckler
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.OnShopPurchase)

function mod:OnDeath(player)
    if player:HasTrinket(Mr_bones) then
        WantedEffect = Mr_bones
        mod:MrBones(player)
    end
end
--mod:RemoveCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod:OnDeath)

function mod:OnRestock(partial)
    --print("restock")
    for i = 0, Game:GetNumPlayers() - 1, 1 do
        local player = Game:GetPlayer(i)
        if player:HasTrinket(Flash_card) then
            WantedEffect = Flash_card
            if partial then
                TrinketValues.Flash_card = TrinketValues.Flash_card + 0.05
            else
                TrinketValues.Flash_card = TrinketValues.Flash_card + 0.15
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end

    end
end
--mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, mod.OnRestock)

---------------------CACHE EVALUATION CALLBACKS---------------------
--------------------------------------------------------------------
--these are all the cache evaluations for every trinekt/item
--the functions for non-statup trinkets are also here

-------------------Joker------------------------
function mod:Joker(player, _)

    if player.HasTrinket(player, Joker) then --controls if it has the trinket
        local JokerDMG = 0.5 --base dmg
        local DMGToAdd = JokerDMG * player.GetTrinketMultiplier(player ,Joker) --scalable DMG up
        if WantedEffect == Joker then
            mod:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd --flat DMG up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Joker, CacheFlag.CACHE_DAMAGE)

------------------bull---------------------------


function mod:Bull(player, _)
    if player.HasTrinket(player, Bull) then --controls if it has the trinket
        
        local CurrentCoins = player.GetNumCoins(player)  --gets the player's coins
        local BullTears = 0

        if CurrentCoins <= 25 then
            BullTears = 0.04 * CurrentCoins 
        elseif  CurrentCoins <= 50 then
            BullTears = 1 + 0.02 * (CurrentCoins - 25)
        else
            BullTears = 1.50 + 0.01 * (CurrentCoins - 50)
        end
        BullTears = BullTears * player.GetTrinketMultiplier(player ,Bull)
        TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, BullTears)  --scalable tears up
        if WantedEffect == Bull then
            mod:EffectConverter(1, BullTears, player, 3)
        end
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd --flat tears up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Bull, CacheFlag.CACHE_FIREDELAY)

----------------------------invisible joker------------------------
function mod:InvisibleJoker(player)
    for i = 0, 3, 1 do --checks every consumable slot
        local HeldCard = player.GetCard(player, i)
        local HeldPill = player.GetPill(player, i)

        if HeldCard ~= 0 then  --if player has a card/rune

            for i = 1, player.GetTrinketMultiplier(player, Invisible_Joker), 1 do
                    
                Game:Spawn(EntityType.ENTITY_PICKUP, 300, player.Position , RandomVector() * 3, player, HeldCard, Seed)
            end
            if WantedEffect == Invisible_Joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            break --ends the initial FOR early

        elseif  HeldPill ~= 0 then --pills are a different enity to cards so this is also needed
            for i = 1, player.GetTrinketMultiplier(player, Invisible_Joker), 1 do
                    
                Game:Spawn(EntityType.ENTITY_PICKUP, 70, player.Position , RandomVector() * 3, player, HeldPill, Seed)
            end
            if WantedEffect == Invisible_Joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            break --ends the initial FOR early

        end
    end
    
end

--------------------------abstract joker--------------------

function mod:AbstractJoker(player,_)
    if player.HasTrinket(player, Abstract_joker) then
        local AbstractDMG = 0.08
        local NumItems = player.GetCollectibleCount(player)
        local DMGToAdd = (AbstractDMG * NumItems) * player.GetTrinketMultiplier(player, Abstract_joker)
        if WantedEffect == Abstract_joker then
            mod:EffectConverter(1, DMGToAdd, player, 1)
        end
        player.Damage = player.Damage + DMGToAdd 
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.AbstractJoker, CacheFlag.CACHE_DAMAGE)

--------------------------------------misprint----------------------------------------------

function mod:Misprint(player,_)
    if player.HasTrinket(player, Misprint) then
        if WantedEffect == Misprint then --basically changes the dmg up only when changing rooms
            local RNG = player:GetTrinketRNG(Misprint)
            local MisprintDMG = 1.5
            local MisprintDMGToAdd = ((MisprintDMG * RNG:RandomFloat()) * player.GetTrinketMultiplier(player, Misprint)) --random float is from 0 to 1
            MisprintDMGToAdd = mod:round(MisprintDMGToAdd, 2)
            mod:EffectConverter(1, MisprintDMGToAdd, player, 1)
            player.Damage = player.Damage + MisprintDMGToAdd
            TrinketValues.LastMisprintDMG = MisprintDMGToAdd
            return
        end
        player.Damage = player.Damage + TrinketValues.LastMisprintDMG
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Misprint, CacheFlag.CACHE_DAMAGE)

----------------------------joker stencil-------------------------------------

---@param player EntityPlayer
function mod:JokerStencil(player,_)
    if player:HasTrinket(Joker_stencil) then
        local JokerStencilMultiplier = 1
        if player.GetPlayerType(player) == PlayerType.PLAYER_ISAAC_B then --specific dmg up for Tisaac
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, true) then
                JokerStencilMultiplier = JokerStencilMultiplier + 0.1 * (13 - player.GetCollectibleCount(player))
            else
                JokerStencilMultiplier = JokerStencilMultiplier + 0.15 * (8 - player.GetCollectibleCount(player))
            end
        end
        if player:GetActiveItem() == CollectibleType.COLLECTIBLE_NULL then --chacks active item slot
            JokerStencilMultiplier = JokerStencilMultiplier + 0.1
        end
        if player:GetNumCoins() == 0 then
            JokerStencilMultiplier = JokerStencilMultiplier + 0.05
        end
        if player:GetNumBombs() == 0 then
            JokerStencilMultiplier = JokerStencilMultiplier + 0.05
        end
        if player:GetNumKeys() == 0 then
            JokerStencilMultiplier = JokerStencilMultiplier + 0.05
        end
        for i = 0, player:GetMaxPocketItems() -1, 1 do --checks every available consumable slot
            if player:GetPocketItem(i):GetSlot() == 0 then  --if the slot is empty
                JokerStencilMultiplier = JokerStencilMultiplier + 0.05
                break
            end
        end
        JokerStencilMultiplier = JokerStencilMultiplier + ((JokerStencilMultiplier - 1) * (player:GetTrinketMultiplier(Joker_stencil) - 1))
        if WantedEffect == Joker_stencil then
            mod:EffectConverter(2, JokerStencilMultiplier, player, 2)
        end
        player.Damage = player.Damage * JokerStencilMultiplier
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.JokerStencil, CacheFlag.CACHE_DAMAGE)

------------------STONE JOKER---------------------

---@param player EntityPlayer
function mod:StoneJoker(player, _)
    if player.HasTrinket(player, Stone_joker) then --controls if it has the trinket
        local StoneTears = TrinketValues.Stone_joker
        if WantedEffect == Stone_joker then
            mod:EffectConverter(1, StoneTears, player, 3)
        end
        local TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, StoneTears)
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd --flat tears up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.StoneJoker, CacheFlag.CACHE_FIREDELAY)

-----------------ICE CREAM-------------------------
---@param player EntityPlayer
function mod:IceCream(player, _)
    if player:HasTrinket(Icecream) then
        if TrinketValues.Ice_cream == 0 then
            mod:EffectConverter(4, 0, player, 6)
            return
        end
        local IceTears = TrinketValues.Ice_cream * player:GetTrinketMultiplier(Icecream)
        if WantedEffect == Icecream then
            mod:EffectConverter(1, IceTears, player, 3)
        end
        local TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, IceTears)
        player.MaxFireDelay = player.MaxFireDelay - TearsToAdd
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.IceCream, CacheFlag.CACHE_FIREDELAY)

-----------------POPCORN-------------------------
---@param player EntityPlayer
function mod:Popcorn(player, _)
    if player:HasTrinket(Popcorn) then
        if TrinketValues.Popcorn == 0 then
            mod:EffectConverter(4, 0, player, 5)
            return
        end
        local PopDamage = TrinketValues.Popcorn * player:GetTrinketMultiplier(Popcorn)
        if WantedEffect == Popcorn then
            mod:EffectConverter(1, PopDamage, player, 1)
        end
        player.Damage = player.Damage + PopDamage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Popcorn, CacheFlag.CACHE_DAMAGE)

---------------------RAMEN-------------------------
---@param player EntityPlayer
function mod:Ramen(player, _)
    if player:HasTrinket(Ramen) then
        if TrinketValues.Ramen == 0 then
            mod:EffectConverter(4, 0, player, 5)
            return
        end
        local RamenMult = TrinketValues.Ramen + ((TrinketValues.Ramen -1 ) * (player:GetTrinketMultiplier(Ramen) - 1))
        if WantedEffect == Ramen then
            mod:EffectConverter(2, RamenMult, player, 2)
        end
        player.Damage = player.Damage * RamenMult
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.Ramen, CacheFlag.CACHE_DAMAGE)

----------------------------ROCKET-----------------------------
---@param player EntityPlayer
function mod:rocket(player)
    for i = 1, TrinketValues.Rocket , 1 do --checks every consumable slot        
        Game:Spawn(EntityType.ENTITY_PICKUP, 20, player.Position, RandomVector() * 3, player, 1, Seed)
    end
    TrinketValues.Rocket = TrinketValues.Rocket + (2 * player:GetTrinketMultiplier(Rocket))
    mod:EffectConverter(3, 0, player, 4)
end

--------------------------  EVEN STEVEN---------------------------
---@param player EntityPlayer
function mod:EvenSteven(player, _)
    if player:HasTrinket(Evensteven) then --controls if it has the trinket
        if player:GetCollectibleCount() % 2 == 0 then
            local StevenDMG = 0.1
            local DMGToAdd = (StevenDMG * player:GetCollectibleCount()) * player:GetTrinketMultiplier(Evensteven) --scalable DMG up
            if WantedEffect == Evensteven then
                mod:EffectConverter(1, DMGToAdd, player, 1)
            end
            player.Damage = player.Damage + DMGToAdd --flat DMG up
        else
            if WantedEffect == Evensteven then    
                mod:EffectConverter(1, 0, player, 1)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvenSteven, CacheFlag.CACHE_DAMAGE)

------------------------ODD TODD----------------------------
---@param player EntityPlayer
function mod:OddTodd(player, _)

    if player:HasTrinket(Oddtodd) then --controls if it has the trinket
        if player:GetCollectibleCount() % 2 == 1 then
            local OddTears = 0.07
            local TearsToAdd = (OddTears * player:GetCollectibleCount()) * player:GetTrinketMultiplier(Oddtodd) --scalable DMG up
            if WantedEffect == Oddtodd then
                mod:EffectConverter(1, TearsToAdd, player, 3)
            end
            TearsToAdd = mod:CalculateTearsUp(player.MaxFireDelay, TearsToAdd)
            player.MaxFireDelay = player.MaxFireDelay - TearsToAdd--flat DMG up
        else   
            if WantedEffect == Oddtodd then
                mod:EffectConverter(1, 0, player, 3)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OddTodd, CacheFlag.CACHE_FIREDELAY)
-----------------------HALLUCINATION------------------------
function mod:HAllucination(player, cost)
    local Deal = 0
    local Chance = 0.2 + (cost * 0.02)
    if cost < 0 then --devil deal cost
        if cost == PickupPrice.PRICE_SPIKES then
            Chance = 0.3
        elseif cost == PickupPrice.PRICE_FREE then
            Chance = 0.5
            Deal = 1
        else
            Chance = 1
            Deal = 1
        end
    end

    if RNG:RandomFloat() <= Chance then
        if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
            for i = 1,player:GetTrinketMultiplier(Hallucination) + Deal, 1 do
                local RNG = player:GetTrinketRNG(Hallucination)
                local seed = RNG:GetSeed()
                local Pill = ItemPool:GetPill(seed)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position , RandomVector() * 3, player, Pill, seed)
            end
        else       
            for i = 1,player:GetTrinketMultiplier(Hallucination) + Deal, 1 do
                local RNG = player:GetTrinketRNG(Hallucination)
                local seed = RNG:GetSeed()    
                local Card = ItemPool:GetCard(seed, true, true, false)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, seed)    
            end
        end
            mod:EffectConverter(3, 0, player, 4)
    end
end
-----------------------VAGABOND---------------------------
---@param player EntityPlayer
function mod:VAgabond(player)
    local RNG = player:GetTrinketRNG(Vagabond)
    local seed = RNG:GetSeed()
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
        local Pill = ItemPool:GetPill(seed)
        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position , RandomVector() * 3, player, Pill, seed)
    else
        if player:GetTrinketMultiplier(Vagabond) > 1 then
            local Card = ItemPool:GetCard(seed, true, true, false)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, Seed)
        else
            local Card = ItemPool:GetCardEx(seed, 0,0,0, false)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, Seed)
        end
    end
    mod:EffectConverter(3, 0, player, 4)   
end
-----------------------GREEN JOKER------------------
function mod:GreenJoker(player,_)
    if player:HasTrinket(Green_joker) then
        local Damage = TrinketValues.Green_joker 
        if WantedEffect == Green_joker then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GreenJoker, CacheFlag.CACHE_DAMAGE)
--------------------RED CARD---------------------
---@param player EntityPlayer
function mod:RedCard(player,_)
    if player:HasTrinket(Red_card) then
        local Damage = TrinketValues.Red_card * player:GetTrinketMultiplier(Red_card)
        if WantedEffect == Red_card then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.RedCard, CacheFlag.CACHE_DAMAGE)
--------------------RIFF RAFF----------------------
---@param player EntityPlayer
function mod:RiffRaff(player)
    local RNG = player:GetTrinketRNG(Riff_raff)
    local seed = RNG:GetSeed()
    local Item
    local Config
    repeat
        Item = RNG:RandomInt(1, CollectibleType.NUM_COLLECTIBLES) --chooses a compleatly random item
        --print(Item)
        Config = ItemsConfig:GetCollectible(Item)
    until  (Config.Quality <= 0 + player:GetTrinketMultiplier(Riff_raff)) and (PersistentGD:Unlocked(Config.AchievementID))
        
    mod:EffectConverter(3, 0, player, 4)
    Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetFreeNearPosition(player.Position, 50), Vector.Zero, player, Item, seed)
end
-------------------GOLDEN JOKER--------------------
---@param player EntityPlayer
function mod:Goldenjoker(player)
    for i = 1, 2 + 2 * player:GetTrinketMultiplier(Golden_joker) do
        Game:Spawn(EntityType.ENTITY_PICKUP, 20, player.Position, RandomVector() * 3, player, 1, Seed)
    end
    mod:EffectConverter(3, 0, player, 4)
end
----------------FORTUNETELLER----------------------
---@param player EntityPlayer
function mod:FOrtuneteller(player)
    if player:HasTrinket(Fortuneteller) then
        --print("fortune teller")
        local Damage = TrinketValues.Fortune_Teller * player:GetTrinketMultiplier(Fortuneteller)
        if WantedEffect == Fortuneteller then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.FOrtuneteller, CacheFlag.CACHE_DAMAGE)
-------------------BLUEPRINT--------------------
---@param player EntityPlayer
function mod:BluePrint(player, Add)
    if TrinketValues.Blueprint == 0 then
        return
    end
    if Add then
        if WantedEffect == Blueprint then
            mod:EffectConverter(3, 0, player, 4)
        end
        player:AddCollectible(TrinketValues.Blueprint, 0, false)
    end
    player:RemoveCollectible(TrinketValues.LastBPitem)
    TrinketValues.LastBPitem = TrinketValues.Blueprint
end
------------------BRAINSTORM-----------------------
---@param player EntityPlayer
function mod:BrainStorm(player, Add)
    if Add and TrinketValues.Brainstorm ~= 0 then
        TrinketValues.FirstBrain = false
        if WantedEffect == Brainstorm then
            mod:EffectConverter(3, 0, player, 4)
        end
        player:AddCollectible(TrinketValues.Brainstorm, 0, false)
    else
        player:RemoveCollectible(TrinketValues.Brainstorm)
    end
end
-------------------SMEARED JOKER------------------
---@param player EntityPlayer
---@param pickup EntityPickup
function mod:SmearedJoker(player, pickup)
    local RNG = player:GetTrinketRNG(Smeared_joker)

    if pickup.Variant == PickupVariant.PICKUP_HEART then
        if pickup.SubType == HeartSubType.HEART_HALF or HeartSubType.HEART_FULL or HeartSubType.HEART_DOUBLEPACK then
            if player:CanPickRedHearts() then
                local Chance = 0.5
                if RNG:RandomFloat() <= Chance then
                    mod:EffectConverter(3, 0, player, 4)
                    player:AddCoins(1 * player:GetTrinketMultiplier(Smeared_joker))
                end
            end
        end
    elseif pickup.Variant == PickupVariant.PICKUP_COIN then
        if pickup.SubType ~= CoinSubType.COIN_STICKYNICKEL then
            if player:CanPickRedHearts() then
                local Chance = 0.4
                if RNG:RandomFloat() <= Chance then
                    mod:EffectConverter(3, 0, player, 4)
                    player:AddHearts(1 * player:GetTrinketMultiplier(Smeared_joker))
                end
            end
        end
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
        local Chance = 0.2
        if RNG:RandomFloat() <= Chance then
            if WantedEffect == Smeared_joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            player:AddKeys(1 * player:GetTrinketMultiplier(Smeared_joker))
        end
    elseif pickup.Variant == PickupVariant.PICKUP_KEY then
        local Chance = 0.2
        if RNG:RandomFloat() <= Chance then
            if WantedEffect == Smeared_joker then
                mod:EffectConverter(3, 0, player, 4)
            end
            player:AddBombs(1 * player:GetTrinketMultiplier(Smeared_joker))
        end
    end
end

------------------MADNESS-----------------------
---@param player EntityPlayer
function mod:MAdness(player,_)
    if player:HasTrinket(Madness) then
        --print("madness")

        local MadnessMult = TrinketValues.Madness + (((TrinketValues.Madness - 1)/2) * (player:GetTrinketMultiplier(Madness) - 1))
        if WantedEffect == Madness then
            mod:EffectConverter(2, MadnessMult, player, 2)
        end
        player.Damage = player.Damage * MadnessMult
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.MAdness, CacheFlag.CACHE_DAMAGE)
------------------SACRIFICIAL DAGGER-----------------
---@param player EntityPlayer
function mod:SacrificialDagger(player)
    if player:HasTrinket(Sacrificial_dagger) then
        --print("madness")
        --print(TrinketValues.Sacrificial_dagger)
        local Damage = (TrinketValues.Sacrificial_dagger +((TrinketValues.Sacrificial_dagger/2) * (player:GetTrinketMultiplier(Sacrificial_dagger)-1) ))
        if WantedEffect == Sacrificial_dagger then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SacrificialDagger, CacheFlag.CACHE_DAMAGE)
--------------------MR.BONES--------------------
---@param player EntityPlayer
function mod:MrBones(player)
    local Room = Game:GetRoom()
    if Room:GetBossID() ~= 0 then --only if there's a boss in the room
        player:Revive()
        player:SetMinDamageCooldown(120)
        mod:EffectConverter(3, 0, player, 4)
        if player:GetMaxHearts() > 2 then
            player:AddMaxHearts(-2, true)
        end
        player:SetFullHearts()
        if not player:TryRemoveTrinket(Mr_bones) then
            player:TryRemoveTrinket(Mr_bones)
        end
    end
end
------------------ONYX AGATE----------------------
---@param player EntityPlayer
function mod:OnyxAgate(player,_)
    if player:HasTrinket(Onix_agate) then
        --print("onyx")
        local Bombs = player:GetNumBombs()
        if Bombs <= 10 then
            Damage = (Bombs * 0.10) * player:GetTrinketMultiplier(Onix_agate)
        elseif Bombs <= 25 then
            Damage = (1 + Bombs * 0.05) * player:GetTrinketMultiplier(Onix_agate)
        else
            Damage = (1.75 + Bombs * 0.03) * player:GetTrinketMultiplier(Onix_agate)
        end 
        player.Damage = player.Damage + Damage
        if WantedEffect == Onix_agate then
            mod:EffectConverter(1, Damage, player, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnyxAgate, CacheFlag.CACHE_DAMAGE)
-----------------ARROWHEAD---------------------------
---@param player EntityPlayer
function mod:ArrowHead(player,_)
    if player:HasTrinket(Arrowhead) then
        --print("arrow")
        local Keys = player:GetNumKeys()
        if Keys <= 10 then
            Tears = (Keys * 0.10) * player:GetTrinketMultiplier(Arrowhead)
        elseif Keys <= 25 then
            Keys = (1 + Keys * 0.5) * player:GetTrinketMultiplier(Arrowhead)
        else
            Keys = (1.75 + Keys * 0.3) * player:GetTrinketMultiplier(Arrowhead)
        end
        if WantedEffect == Arrowhead then
            mod:EffectConverter(1, Tears, player, 3)
        end
        Tears = mod:CalculateTearsUp(player.MaxFireDelay, Tears)
        player.MaxFireDelay = player.MaxFireDelay - Tears
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ArrowHead, CacheFlag.CACHE_FIREDELAY)
----------------BLOODSTONE----------------------------
---@param player EntityPlayer
function mod:BloodStone(player,_)
    if player:HasTrinket(Bloodstone) then
        local RNG = player:GetTrinketRNG(Bloodstone)
        local Hearts = math.floor(player:GetHearts()/2)
        local Chance = 0.5 + 0.25*(player:GetTrinketMultiplier(Bloodstone)-1)
        local DamageMult = 1
        for i = 1, Hearts, 1 do
            if RNG:RandomFloat() <= Chance then
                DamageMult = DamageMult + 0.05
            end
        end
        player.Damage = player.Damage * DamageMult
        if WantedEffect == Bloodstone then
            mod:EffectConverter(2, DamageMult, player, 2)
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.BloodStone, CacheFlag.CACHE_DAMAGE)
------------------ROUGH GEM---------------------------
---@param player EntityPlayer
function mod:RoughGem(player)
    local coins = player:GetNumCoins() * player:GetTrinketMultiplier(Rough_gem)
    local RNG = player:GetTrinketRNG(Rough_gem)
    local seed = RNG:GetSeed()
    repeat
        local Random = RNG:RandomInt(1,25)
        if Random <= coins then
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, seed)
            mod:EffectConverter(3,0,player,4)
        end
        coins = coins - (Random * 2)
    until coins <= 0

end
----------------------GROS MICHAEL--------------------
---@param player EntityPlayer
function mod:GrosMichael(player, _)
    if player:HasTrinket(Gros_michael) then --controls if it has the trinket
        --print(WantedEffect)
        if TrinketValues.MichaelDestroyed then
            if WantedEffect == "MCdestroyed" then
                mod:EffectConverter(4, 0, player, 4)
                return
            elseif WantedEffect == "MCsafe" then
                mod:EffectConverter(7, 0, player, 4)
                return
            end
        end
        local Damage = 1 * player:GetTrinketMultiplier(Gros_michael) 
        if WantedEffect == Gros_michael then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage --flat DMG up
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GrosMichael, CacheFlag.CACHE_DAMAGE)
----------------------CAVENDISH--------------------
---@param player EntityPlayer
function mod:Cavendish(player, _)
    if player:HasTrinket(Cavendish) then --controls if it has the trinket
        if not TrinketValues.MichaelDestroyed then
            if WantedEffect == "MCdestroyed" then
                mod:EffectConverter(4, 0, player, 4)
                return
            elseif WantedEffect == "MCsafe" then
                mod:EffectConverter(7, 0, player, 4)
                return
            end
        end
        local DamageMult = 1.2 + (0.1 * player:GetTrinketMultiplier(Cavendish)) 
        if WantedEffect == Cavendish then
            mod:EffectConverter(2, DamageMult, player, 2)
        end
        player.Damage = player.Damage * DamageMult
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.Cavendish, CacheFlag.CACHE_DAMAGE)
-------------------FLASH CARD---------------------
---@param player EntityPlayer
function mod:FlashCard(player, _)
    if player:HasTrinket(Flash_card) then --controls if it has the trinket
        local Damage = TrinketValues.Flash_card * player:GetTrinketMultiplier(Flash_card)
        if WantedEffect == Flash_card then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.FlashCard, CacheFlag.CACHE_DAMAGE)

-------------------CLOUD 9---------------------
---@param player EntityPlayer
function mod:Cloudnine(player, _)
    local Tanscendance = ItemsConfig:GetCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
    if player:HasTrinket(Cloud_nine) then --controls if it has the trinket
    
        if TrinketValues.Cloud_9 == 0 then
            player.CanFly = true  
            player:AddCostume(Tanscendance)
            if WantedEffect == Cloud_nine then
                mod:EffectConverter(3, 0, player, 4)
            end
        else
            if WantedEffect == Cloud_nine then
                mod:EffectConverter(8, TrinketValues.Cloud_9, player, 4)
            end
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
                player:RemoveCostume(Tanscendance)
            end
        end
    else
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
            player:RemoveCostume(Tanscendance)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Cloudnine, CacheFlag.CACHE_FLYING)
-------------------CARTOMANCER---------------------
---@param player EntityPlayer
function mod:CArtomancer(player)
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
        for i = 1, 2 * player:GetTrinketMultiplier(Cartomancer), 1 do
            local RNG = player:GetTrinketRNG(Cartomancer)
            local seed = RNG:GetSeed()
            local Pill = ItemPool:GetPill(seed)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position , RandomVector() * 3, player, Pill, seed)
        end
    else
        for i = 1,2 * player:GetTrinketMultiplier(Cartomancer), 1 do
            local RNG = player:GetTrinketRNG(Cartomancer)
            local seed = RNG:GetSeed()
            local Card = ItemPool:GetCard(seed, true, true, false)
            --Print(Card)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position , RandomVector() * 3, player, Card, seed)
        end
    end      
    mod:EffectConverter(3, 0, player, 4)
end
--------------------SWASHBUCKLER-------------------------
---@param player EntityPlayer
function mod:SwashBuckler(player, _)
    if player:HasTrinket(Swashbuckler) then --controls if it has the trinket
        local Damage = TrinketValues.Swashbuckler * player:GetTrinketMultiplier(Swashbuckler)
        if WantedEffect == Swashbuckler then
            mod:EffectConverter(1, Damage, player, 1)
        end
        player.Damage = player.Damage + Damage
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SwashBuckler, CacheFlag.CACHE_DAMAGE)


--------------------LOYALTY CARD-------------------------
---@param player EntityPlayer
function mod:LoyaltyCard(player)
    if player:HasTrinket(Loyalty_card) then --controls if it has the trinket
    
        if TrinketValues.Loyalty_card == 0 then
            player.Damage = player.Damage * 1.3  
            if WantedEffect == Loyalty_card then
                mod:EffectConverter(2, 1.3, player, 2)
            end  
        else
            if WantedEffect == Loyalty_card then
                mod:EffectConverter(8, TrinketValues.Loyalty_card, player, 4)
            end
        end        
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.LoyaltyCard, CacheFlag.CACHE_DAMAGE)

---------------------SUPERNOVA----------------------------
---@param player EntityPlayer
function mod:SuperNova(player)
    local Damage = 0
    if player:HasTrinket(Supernova) then
        for i = 0, 1, 1 do --takes the higer value between the two held actives
            local Active = player:GetActiveItem(i)
            if TrinketValues.Supernova[Active] > Damage then
                Damage = TrinketValues.Supernova[Active]
            end
        end
        player.Damage = player.Damage + Damage  
        if WantedEffect == Supernova then
            mod:EffectConverter(1, Damage, player, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SuperNova, CacheFlag.CACHE_DAMAGE)

---------------DELAYED GRATIFICATION------------------
---@param player EntityPlayer
function mod:DelayedGratification(player)
    if TrinketValues.DamageTakenRoom == 0 then --gives coins if no damage is taken when compleating rooms
        for i = 1, player:GetTrinketMultiplier(Delayed_gratification), 1 do 
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, Seed)
        end
        mod:EffectConverter(3, 0, player, 4)
    end
    TrinketValues.Delayed_gratification = true
end

---------------------EGG------------------

---@param player EntityPlayer
function mod:EGG(player, Destroy)
    --print(Destroy)
    if Destroy then
        for i = 1, TrinketValues.Egg , 1 do 
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position , RandomVector() * 3, player, CoinSubType.COIN_PENNY, Seed)
        end
        local Entities = Isaac.GetRoomEntities()
        print(Entities)
        for k, Entity in ipairs(Isaac.GetRoomEntities()) do
            if Entity.Type == EntityType.ENTITY_PICKUP and Entity.Variant == PickupVariant.PICKUP_TRINKET and Entity.SubType == Egg then
                Entity:Remove()
                break
            end
        end
        
        mod:EffectConverter(3, 0, player, 4)
    else
        --print("false")
        TrinketValues.Egg = TrinketValues.Egg + (4 * player:GetTrinketMultiplier(Egg))
        mod:EffectConverter(5, 0, player, 4)
    end
end

-------------------DNA----------------------

---@param player EntityPlayer
function mod:DNA(player, Variant, SubType)
    if TrinketValues.Dna then    
    local Copied = false --needed to not make the trinket deactivate in case of a wrong active item being used
        if Variant == PickupVariant.PICKUP_COLLECTIBLE then --checks if it's an active item or card/pill
            local Activeconfig = ItemsConfig:GetCollectible(SubType)
                
            --only spawns active item with a "normal" charge type and not singular use actives
            if Activeconfig.ChargeType ~= ItemConfig.CHARGE_SPECIAL and player:HasCollectible(SubType)then 
                local Item
                Item = Game:Spawn(EntityType.ENTITY_PICKUP, Variant, Isaac.GetFreeNearPosition(player.Position, 50) , Vector.Zero, player, SubType, Seed)
                Item = Item:ToPickup()
                Item.Charge = 0  --gives the item no charges
                Copied = true
            end
        else
            Game:Spawn(EntityType.ENTITY_PICKUP, Variant, player.Position , RandomVector() * 3, player,SubType, Seed)
            Copied = true
        end
        if Copied then
            if player:GetTrinketMultiplier(Dna) > 1 then
                local RNG = player:GetTrinketRNG(Dna)
                Chance = 0.7
                if RNG:RandomFloat() < Chance then --Chance to not deactivate if a golden version is obtained
                    TrinketValues.Dna = false
                end
            else
                TrinketValues.Dna = false
            end
            mod:EffectConverter(3, 0, player, 4)
        end
    end
end

------------------EID----------------------
-------------------------------------------

if EID then
    local Description
    local ValueDescription
    ------------LIST OF ALL THE GOLDEN TRINKET EXTRA TEXT----------
    --(don't know how to put extra languages)
    local GoldenDescriptions = {"Stats up DOUBLED!",
                                "Pickups DOUBLED!",
                                "chance INCREASED!",
                                "No effect",
                                "Maximum item quality INCREASED!",
                                "Items given DOUBLED!",
                                "Activates MORE FREQUeNTLY!",
                                "Upgrades TWICE AS FAST!",
                                "HIGHER chance of finding its brother!",
                                "UNBREACKABLE and stat up INCREASED",
                                "ANY card can spawn!",
                                "Activates TWICE and gives HIGER stats!"}
    ----------------------------------------------------------------
    
    local function BalatroGoldenConditions(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType >= TrinketType.TRINKET_GOLDEN_FLAG then 
            local Trinket = descObj.ObjSubType - 32768 --gets the normal trinket subtype
            
            if Trinket >= Invisible_Joker and Trinket <= Loyalty_card then --CHECKS IF IT'S A MOD'S TRINKET
            
                local Config = ItemsConfig:GetTrinket(Trinket)
                if Config:HasCustomTag("mult") or Config:HasCustomTag("multm") or Config:HasCustomTag("chips") then
                    Description = 1 --basic description
                    --SPECIAL CASES--
                    if Trinket == Bloodstone then
                        Description = 3
                    elseif Trinket == Loyalty_card then
                        Description = 7
                    elseif Trinket == Green_joker or Trinket == Fortuneteller or Supernova then
                        Description = 8
                    elseif Trinket == Gros_michael then
                        Description = 9
                    elseif Trinket == Cavendish then
                        Description = 10
                    elseif Trinket == Madness or Trinket == Sacrificial_dagger then
                        Description = 12
                    end
                else
                    if Trinket == Hallucination or Trinket == Invisible_Joker or Trinket == Golden_joker or Trinket == Smeared_joker or Trinket == Delayed_gratification then
                        Description = 2
                    elseif Trinket == Rough_gem then
                        Description = 3
                    elseif Trinket == Mr_bones then
                        Description = 4
                    elseif Trinket == Riff_raff then
                        Description = 5
                    elseif Trinket == Blueprint or Trinket == Brainstorm then
                        Description = 6
                    elseif Trinket == Cloud_nine then
                        Description = 7
                    elseif Trinket == Rocket then
                        Description = 8
                    elseif Trinket == Vagabond then
                        Description = 11
                    end
                end
                
                return true 
            end
        end
    end
    local function BalatroGoldenCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{ArrowUp}} {{ColorFade}}{{ColorYellow}}"..GoldenDescriptions[Description])
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Golden Modifier", BalatroGoldenConditions, BalatroGoldenCallback)


    local function BalatroStencilCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType == Joker_stencil then 
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_ISAAC_B) then
                return true
            end
        end
    end
    local function BalatroStencilCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Player21}} Gives {{Damage}}{{ColorRed}}x0.15 {{CR}} Damage multiplier for each empty {{Collectible}} Item slot")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro TIsaac stencil", BalatroStencilCondition, BalatroStencilCallback)


    local function BalatroFlashCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType == Flash_card then 
            if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_RESTOCK) then
                return true
            end
        end
    end
    local function BalatroFlashCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Collectible"..CollectibleType.COLLECTIBLE_RESTOCK.."}} Gives {{Damage}} {{ColorRed}}+0.05 {{CR}} Damage for each activation")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Flash card", BalatroFlashCondition, BalatroFlashCallback)

    local function BalatroKeeperHpMadnessCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType == Madness then 
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER) or PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B) then
                return true
            end
        end
    end
    local function BalatroKeeperHpMadnessCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Player14}} Removes all {{Coin}} coins from player instead, giving {{Damage}}{{ColorRed}} X0.01 {{CR}} Damage multiplier every 5 {{Coin}} coins removed")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Keeper hp", BalatroKeeperHpMadnessCondition, BalatroKeeperHpMadnessCallback)

    local function BalatroKeeperHpDaggerCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType == Sacrificial_dagger then 
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER) or PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B) then
                return true
            end
        end
    end
    local function BalatroKeeperHpDaggerCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Player14}} Removes all {{Coin}} coins from player instead, giving {{Damage}}{{ColorRed}} +0.01 {{CR}} Damage every {{Coin}} coin removed")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Keeper hp", BalatroKeeperHpDaggerCondition, BalatroKeeperHpDaggerCallback)

    local function BalatroLostHpCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType == Sacrificial_dagger or descObj.ObjSubType == Madness then 
            if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_THELOST) or PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_THELOST_B) then
                return true
            end
        end
    end
    local function BalatroLostHpCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Player10}} Cannot lose any {{Heart}} Hp so won't gain any Stat up")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Lost hp", BalatroLostHpCondition, BalatroLostHpCallback)

    local function BalatroPillCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and (descObj.ObjSubType == Hallucination or descObj.ObjSubType == Vagabond) then 
            if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
                return true
            end        
        end
    end
    local function BalatroPillCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Collectible"..CollectibleType.COLLECTIBLE_LITTLE_BAGGY.."}} Spawns a {{Pill}} Pill instead")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Little baggy", BalatroPillCondition, BalatroPillCallback)

    local function BalatroSchoolbagCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 and descObj.ObjSubType == Supernova then 
            if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) then
                return true
            end        
        end
    end
    local function BalatroSchoolbagCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, "#{{Collectible"..CollectibleType.COLLECTIBLE_SCHOOLBAG.."}} Only the highest {{Damage}} Damage value is given")
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Schoolbag", BalatroSchoolbagCondition, BalatroSchoolbagCallback)

    local function BalatroValueCondition(descObj) -- descObj contains all informations about the currently described entity
        if descObj.ObjType == 5 and descObj.ObjVariant == 350 then 
            local Trinket = descObj.ObjSubType 
            local Config = ItemsConfig:GetTrinket(Trinket)
            if Config:HasCustomTag("value") then
                if Config:HasCustomTag("mult") then
                    --SUPERNOVA EXCEPTION--
                    if Trinket == Supernova and PlayerManager.AnyoneHasTrinket(Supernova) then
                        for i = 0, Game:GetNumPlayers() - 1, 1 do
                            local player = Game:GetPlayer(i)
                            if player:HasTrinket(Supernova) then
                                local FirstActive = player:GetActiveItem(0)
                                local SecondActive = player:GetActiveItem(1)
                                if TrinketValues.Supernova[FirstActive] and TrinketValues.Supernova[SecondActive] then
                                    if FirstActive == 0 and SecondActive == 0 then
                                        ValueDescription = "#Currently: No {{Collectible}} Active item held"
                                        return true
                                    end
                                    if TrinketValues.Supernova[FirstActive] >= TrinketValues.Supernova[SecondActive] and FirstActive ~= 0 then
                                        ValueDescription = "#Currently: {{Collectible"..tostring(FirstActive).."}} gives {{Damage}} {{ColorRed}}+"..tostring(TrinketValues.Supernova[FirstActive]).."{{CR}} Damage "
                                        return true
                                    else
                                        ValueDescription = "#Currently: {{Collectible"..tostring(SecondActive).."}} gives {{Damage}} {{ColorRed}}+"..tostring(TrinketValues.Supernova[SecondActive]).."{{CR}} Damage "
                                        return true
                                    end
                                end
                                break
                            end
                        end
                        return false
                    end

                elseif Config:HasCustomTag("multm") then
                    ValueDescription = "#Currently: {{Damage}} {{ColorRed}}X"..tostring(TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage Multiplier"
                    return true
                elseif Config:HasCustomTag("chips") then
                    ValueDescription = "#Currently: {{Tears}} {{ColorCyan}}+"..tostring(TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Tears "
                    return true
                else
                    --PUT ALL THE ACTIVATE JOKERS HERE
                    if Trinket == Rocket then
                        ValueDescription = "#Currently: "..tostring(TrinketValues.Rocket).." {{Coin}} Coins "
                        return true
                    elseif Trinket == Cloud_nine then
                        ValueDescription = "#Currently: "..tostring(TrinketValues.Cloud_9).." pickups remaining"
                        return true
                    elseif Trinket == Loyalty_card then
                        ValueDescription = "#Currently: "..tostring(TrinketValues.Loyalty_card).." rooms remaining"
                        return true
                    elseif Trinket == Blueprint then
                        if TrinketValues.Blueprint == 0 then
                            ValueDescription = "#{{Warning}} No {{Collectible}} Items picked up"
                        else
                            ValueDescription = "#Currently giving: {{Collectible"..tostring(TrinketValues.Blueprint).."}}"
                        end
                        return true
                    elseif Trinket == Brainstorm then
                        if TrinketValues.Brainstorm == 0 then
                            ValueDescription = "#{{Warning}} No {{Collectible}} Items picked up"
                        else
                            ValueDescription = "#Currently giving: {{Collectible"..tostring(TrinketValues.Brainstorm).."}}"
                        end
                        return true
                    end
                end
            end
        end
    end
    local function BalatroValueCallback(descObj)
        -- alter the description object as you like
        EID:appendToDescription(descObj, ValueDescription)
        return descObj -- return the modified description object
    end
    EID:addDescriptionModifier("Balatro Curren Values", BalatroValueCondition, BalatroValueCallback)

------------------LIST OF ALL THE BASIC DESCRIPTIONS--------------------
    EID:addTrinket(Joker, "\1 {{Damage}} {{ColorRed}}+0.5 {{CR}}Damage", "Joker", "en_us")
    EID:addTrinket(Joker, "\1 {{Damage}} {{ColorRed}}+0.5 {{CR}}Danno", "Jolly", "it")

    EID:addTrinket(Bull, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Tears for every {{Coin}} coin Isaac has#{{Warning}} Scales down basing on {{Coin}}coins held", "Bull", "en_us")
    EID:addTrinket(Bull, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Lacrime per ogni {{Coin}} moneta#{{Warning}} Diminuisce in base alle {{Coin}}Monete Avute", "Toro", "it")

    EID:addTrinket(Invisible_Joker, "On every new floor spawns the first held {{Card}}card or {{Pill}}pill", "Invisible Joker", "en_us")
    EID:addTrinket(Invisible_Joker, "Ogni nuovo piano crea la prima {{Card}}carta o {{Pill}}pillola tenuta", "Jolly invisibile", "it")

    EID:addTrinket(Abstract_joker, "\1 {{Damage}} {{ColorRed}}+0.08 {{CR}}Damage for every {{Collectible}} collectible Isaac has", "Abstract Joker", "en_us")
    EID:addTrinket(Abstract_joker, "\1 {{Damage}} {{ColorRed}}+0.08 {{CR}}Danno per ogni collezionabile avuto", "Jolly astratto", "it")

    EID:addTrinket(Misprint, "\1 {{Damage}} {{ColorRed}}+0~2 {{CR}} random Damage#Damage given changes every new room", "Misprint", "en_us")
    EID:addTrinket(Misprint, "\1 {{Damage}} {{ColorRed}}+0~2 {{CR}}Danno casuale#Danno ricevuto cambia ogni nuova stanza", "Errore di stampa", "it")

    EID:addTrinket(Joker_stencil, "\1 This gives {{Damage}}Damage Multiplier for each pickup Isaac doesn't have#Not having {{Coin}}coins, {{Bomb}}bombs, {{Key}}keys or {{Card}}cards / {{Pill}}pills each give {{ColorRed}}X0.05 #Not having an {{Collectible}}Active item gives {{ColorRed}}X0.1", "Joker Stencil", "en_us")
    EID:addTrinket(Joker_stencil, "\1 Questo conferisce {{Damage}}moltiplicatore di danno per ogni pickup non avuto#Non avere {{Coin}}monete, {{Bomb}}bombe, {{Key}}chiavi o {{Card}}carte / {{Pill}}pillole dà {{ColorRed}}X0.05 #Non avere un {{Collectible}}Oggetto attivo dà {{ColorRed}}X0.1 ", "Forma di Jolly", "it")

    EID:addTrinket(Stone_joker, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Tears for every rock destroyed on the current floor#Tinted rocks give extra stats#{{Warning}} Scales down basing on the ammount of rocks destroyed", "Stone Joker", "en_us")
    EID:addTrinket(Stone_joker, "\1 {{Tears}} {{ColorCyan}}+0.04 {{CR}}Lacrime per ogni roccia distrutta nel piano corrente#Le tinted rocks danno statistiche aggiuntive#{{Warning}} Diminuisce in base al quantitativo di roccie distrutte", "Jolly di pietra", "it")

    EID:addTrinket(Icecream, "\1 {{Tears}} {{ColorCyan}}+1 {{CR}}Tears#\2 Loses {{ColorCyan}}-0.05{{CR}} every room completed while held", "Icecream", "en_us")
    EID:addTrinket(Icecream, "\1 {{Tears}} {{ColorCyan}}+1 {{CR}}Lacrime #\2 Perde {{ColorCyan}}-0.05{{CR}} ogni completamento di stanza mentre lo tiene", "Gelato", "it")

    EID:addTrinket(Popcorn, "\1 {{Damage}} {{ColorRed}}+2 {{CR}}Damage #\2 Loses {{ColorRed}}-0.4{{CR}} Damage when entering a new floor while held", "Popcorn", "en_us")
    EID:addTrinket(Popcorn, "\1 {{Damage}} {{ColorRed}}+2 {{CR}}Danno #\2 Perde {{ColorRed}}-0.4{{CR}} Danno qunado entri in un nuovo piano mentre lo tiene", "Popcorn", "it")

    EID:addTrinket(Ramen, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Damage multiplier#\2 loses {{ColorRed}}X0.01 {{CR}} each time Isaac takes damage while held", "Ramen", "en_us")
    EID:addTrinket(Ramen, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Moltiplicatore danno#\2 Perde X0.01 ogni volta che Isaac prende danno mentre lo tiene", "Ramen", "it")

    EID:addTrinket(Rocket, "Spawns 3 {{Coin}}coins when entring a new floor#\1 {{Coin}}Coins spawned increase by 2 on each activation", "Rocket", "en_us")
    EID:addTrinket(Rocket, "Crea 3 {{Coin}} monete entrando in un nuovo piano#\1 {{Coin}}Le monete create aumentano di 2 dopo ogni attivazione", "Razzo", "it")

    EID:addTrinket(Oddtodd, "\1 {{Tears}} {{ColorCyan}}+0.07 {{CR}} Tears for every {{Collectible}} collectible Isaac has if it's an odd ammont#{{Warning}} Active items are considered", "Odd Todd", "en_us")
    EID:addTrinket(Oddtodd, "\1 {{Tears}} {{ColorCyan}}+0.07 {{CR}} Lacrime per ogni {{Collectible}} collezionabile avuto se è un quantitativo dispari#{{Warning}} Active items are considered", "Numeri dispari", "it")

    EID:addTrinket(Evensteven, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Damage for every {{Collectible}} collectible Isaac has if it's an even ammont#{{Warning}} Active items are considered", "Even Steven", "en_us")
    EID:addTrinket(Evensteven, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Danno per ogni {{Collectible}} collezionabile avuto se è un quantitativo pari#{{Warning}} Active items are considered", "Numeri pari", "it")

    EID:addTrinket(Hallucination, "{{Shop}} Chance to spawn a random {{Card}} card on every shop purchase#Chance increases basing on bought item's cost #{{DevilRoom}} Devil deals taken always spawn 2 {{Card}} cards", "Hallucination", "en_us")
    EID:addTrinket(Hallucination, "{{Shop}} Possibilità di spawnare una {{Card}} carta ogni acquisto in un negozio#La probabilità aumenta in base al costo dell'oggeto comprato #{{DevilRoom}} I patti del diavolo creano sempre 2 {{Card}}carte", "Allucinazione", "it")

    EID:addTrinket(Green_joker, "\1 {{Damage}}{{ColorRed}}+0.04 {{CR}} Damage for every for every room completed while held#\2 {{Damage}}{{ColorRed}}-0.5 {{CR}}Damage each time Isaac takes damage while held" , "Green Joker", "en_us")
    EID:addTrinket(Green_joker, "\1 {{Damage}}{{ColorRed}}+0.04 {{CR}} Danno per ogni stanza completata mentre lo si tiene#\2 {{Damage}}{{ColorRed}}-0.5 {{CR}}Danno ogni danno preso mentre lo si tiene", "Jolly verde", "it")

    EID:addTrinket(Red_card, "\1 {{Damage}}{{ColorRed}}+0.20 {{CR}} Damage if {{Shop}}Shops or all {{TreasureRoom}}Treasure room in a floor were skipped#{{Warning}} Skipping only one of 2 {{TreasureRoom}} Treasure room won't give any stat up" , "Red Card", "en_us")
    EID:addTrinket(Red_card, "\1 {{Damage}}{{ColorRed}}+0.20 {{CR}} Danno se il {{Shop}} Negozio o tutte le {{TreasureRoom}}Stanze del tesoro vengono saltate#{{Warning}} Saltare solo una delle 2 {{TreasureRoom}} Stanze del tasoro non conferirà statistiche", "Cartellino rosso", "it")

    EID:addTrinket(Vagabond, "Spawns a random {{Card}} basic Tarot card when compleating a room with 0 {{Coin}} coins#", "Vagabond", "en_us")
    EID:addTrinket(Vagabond, "Crea una {{Card}}Carta dei tarocchi completando una stanza avendo 0 {{Coin}} monete", "Vagabondo", "it")

    EID:addTrinket(Riff_raff, "Spawns a random {{Quality0}} Q0 or {{Quality1}} Q1 {{Collectible}}item at the start of a new floor", "Riff-Raff", "en_us")
    EID:addTrinket(Riff_raff, "Crea un {{Collectible}} oggetto {{Quality0}} Q0 o {{Quality1}} Q1 all'inizio di un nuovo piano", "Marmaglia", "it")

    EID:addTrinket(Golden_joker, "Spawns 5 {{Coin}} coins when entring a new floor", "Golden Joker", "en_us")
    EID:addTrinket(Golden_joker, "Crea 5 {{Coin}} monete entrando in un nuovo piano", "Jolly dorato", "it")

    EID:addTrinket(Fortuneteller, "\1 {{Damage}}{{ColorRed}}+0.05 {{CR}} Damage for every {{Card}} Tarot card used throughout the run#\2 {{Damage}}{{ColorRed}}-0.05 {{CR}} Damage for every {{Card}} Reverse tarot card used throughout the run" , "Fortune Teller", "en_us")
    EID:addTrinket(Fortuneteller, "\1 {{Damage}}{{ColorRed}}+0.05 {{CR}} Danno per ogni {{Card}} Carta dei tarocchi usata nella partita#\2 {{Damage}}{{ColorRed}}-0.05 {{CR}} Danno per ogni {{Card}} Carta dei tarocchi invertita usata nella partita", "Chiromante", "it")

    EID:addTrinket(Blueprint, "Gives Isaac a copy of the latest picked up {{Collectible}} Passive item ", "Blueprint", "en_us")
    EID:addTrinket(Blueprint, "Conferisce una copia dell'ultimo {{Collectible}} Oggetto passivo preso", "Cianografia", "it")

    EID:addTrinket(Brainstorm, "Gives Isaac a copy of the first picked up {{Collectible}} Passive item in the run", "Brainstorm", "en_us")
    EID:addTrinket(Brainstorm, "Conferisce una copia del primo {{Collectible}} Oggetto passivo preso nella partita", "Raccolta di idee", "it")

    EID:addTrinket(Madness, "\1 This gives {{Damage}}Damage Multiplier for each thing it destroyed#{{Warning}} On every new floor -1 {{Heart}} Hp down and destoys a random {{Collectible}} item Isaac has", "Madness", "en_us")
    EID:addTrinket(Madness, "\1 Questo conferisce {{Damage}}moltiplicatore di danno per ogni cosa distrutta da esso#{{Warning}} Ogni nuovo piano -1 {{Heart}} Punti vita e distrugge un {{Collectible}} Oggetto posseduto casuale", "Follia", "it")

    EID:addTrinket(Mr_bones, "Revives Isaac with -1 {{Heart}} Hp and full health if he died during any {{BossRoom}} Bossfight", "Mr. Bones", "en_us")
    EID:addTrinket(Mr_bones, "Resuscita Isaac con -1 {{Heart}} Punti vita e vita piena se è morto durante qualunque {{BossRoom}} Bossfight", "Signor Scheletro", "it")

    EID:addTrinket(Onix_agate, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Damage for every {{Bomb}} bomb Isaac has#{{Warning}} Scales down basing on {{Bomb}} boms held", "Onyx Agate", "en_us")
    EID:addTrinket(Onix_agate, "\1 {{Damage}} {{ColorRed}}+0.1 {{CR}} Danno per ogni {{Bomba}} bomba avuta#{{Warning}} Diminuisce in base alle {{Bomb}} bombe Avute", "Agata onice", "it")

    EID:addTrinket(Arrowhead, "\1 {{Tears}} {{ColorCyan}}+0.1 {{CR}} Tears for every {{Key}} key Isaac has#{{Warning}} Scales down basing on {{Key}} keys held", "Arrowhead", "en_us")
    EID:addTrinket(Arrowhead, "\1 {{Tears}} {{ColorCyan}}+0.1 {{CR}} Tears per ogni {{key}} chiave avuta#{{Warning}} Diminuisce in base alle {{Key}} chiavi avute", "Punta di freccia", "it")

    EID:addTrinket(Bloodstone, "\1 Every new room, each full {{Heart}} Red heart has a 50% chance to give {{Damage}}{{ColorRed}} X0.05{{CR}} Damage multiplier", "Bloodstone", "en_us")
    EID:addTrinket(Bloodstone, "\1 Ogni nuova stanza, 50% per ogni {{Heart}} cuore rosso di dare {{Damage}}{{ColorRed}}X0.05 {{CR}} Moltiplicatore di danno", "Diaspro sanguigno", "it")

    EID:addTrinket(Rough_gem, "\1 Every room completed, chance to spawn X {{Coin}} coins#Chance increases basing on {{Coin}} coins held", "Rough gem", "en_us")
    EID:addTrinket(Rough_gem, "\1 Ogni stanza completata, possibilità di creare X {{Coin}} monete#La possiblità aumenta in base alle {{Coin}} monete avute", "Pietra grezza", "it")
    
    EID:addTrinket(Gros_michael, "\1 {{Damage}} {{ColorRed}}+1 {{CR}}Damage #{{Warning}} 33% chance for this to destroy on a new floor #His brother is waiting his demise", "Gros Michel", "en_us")
    EID:addTrinket(Gros_michael, "\1 {{Damage}} {{ColorRed}}+1 {{CR}}Danno #{{Warning}} 33% di possibilità di distruggersi all'inizio di un nuovo piano #Suo fratello attende la sua fine", "Gros Michel", "it")

    EID:addTrinket(Cavendish, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Damage multiplier #{{Warning}} 0.05% chance for this to destroy on a new floor", "Cavendish", "en_us")
    EID:addTrinket(Cavendish, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}}Moltiplicatore di danno #{{Warning}} 0.05% di possibilità di distruggersi all'inizio di un nuovo piano", "Cavendish", "it")

    EID:addTrinket(Flash_card, "\1 {{Damage}} {{ColorRed}}+0.15 {{CR}} Damage for every {{RestockMachine}} Restock machine activated while holding this", "Flash Card", "en_us")
    EID:addTrinket(Flash_card, "\1 {{Damage}} {{ColorRed}}+0.15 {{CR}} Danno per ogni atiivazione di {{RestockMachine}}", "Carta alfabeto", "it")

    EID:addTrinket(Sacrificial_dagger, "\1 This gives {{Damage}}{{ColorRed}}+0.25 {{CR}} damage for each thing it destroyed#{{Warning}} On every new floor -1 {{Heart}} Hp down and destoys the first held {{Collectible}} Active item", "Sacrificial Dagger", "en_us")
    EID:addTrinket(Sacrificial_dagger, "\1 Questo conferisce {{Damage}}{{ColorRed}}+0.25 {{CR}} danno per ogni cosa distrutta da esso#{{Warning}} Ogni nuovo piano -1 {{Heart}} Punti vita e distrugge il primo {{Collectible}} Oggetto attivo posseduto", "Pugnale sacrificare", "it")

    EID:addTrinket(Cloud_nine, "Gain flight for the current room every 9 {{Heart}} hearts, {{Bomb}} bombs, {{Key}} keys or {{Coin}} coins picked up", "Cloud 9", "en_us")
    EID:addTrinket(Cloud_nine, "Ottieni volo per una stanza ogni 9 {{Heart}} cuori, {{Bomb}} bombe, {{Key}} chiavi o {{Coin}} monete raccolte", "Nove nuvoloso", "it")

    EID:addTrinket(Swashbuckler, "{{Shop}} This gives {{Damage}} Damage on every shop purchase# {{Damage}}Damage given increases basing on bought item's cost #{{DevilRoom}} Devil deals give specific ammount of {{Damage}} Damage Basing on cost", "Swashbucler", "en_us")
    EID:addTrinket(Swashbuckler, "{{Shop}} Questo conferisce {{Damage}} Danno ogni Oggetto comprato# il {{Damage}} Danno conferisto aumenta con colsto dell'oggetto comprato #{{DavilRoom}} Devil deals conferiscono {{Damage}} Danno specifico in base al costo", "Moschettiere", "it")

    EID:addTrinket(Cartomancer, "Spawns 2 {{Card}} Cards when entring a new floor", "Cartomancer", "en_us")
    EID:addTrinket(Cartomancer, "Crea 2 {{Card}} carte entrando in un nuovo piano", "cartomante", "it")

    EID:addTrinket(Loyalty_card, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}} Damage multiplier once every 6 rooms completed", "Loyalty Card", "en_us")
    EID:addTrinket(Loyalty_card, "\1 {{Damage}} {{ColorRed}}X1.3 {{CR}} Moltiplicatore di danno ogni 6 stanze completate", "Carta fedeltà", "it")

    EID:addTrinket(Supernova, "\1 Gains {{Damage}} {{ColorRed}} +0.04 {{CR}} Damage for every room completed while holding a {{Collectible}} active item #Each {{Collectible}}active item stores its {{Damage}} Damage value", "Supernova", "en_us")
    EID:addTrinket(Supernova, "\1 Guadagna {{Damage}} {{ColorRed}}+0.04 {{CR}} Danno ogni stanza completata con un {{Collectible}} oggetto attivo #Ogni {{Collectible}} Oggetto attivo salva il proprio {{Damage}} Danno", "Supernova", "it")

    EID:addTrinket(Delayed_gratification, "Spawns 1 {{Coin}} Coin if a room is completed without taking damage", "Delayed Gratification", "en_us")
    EID:addTrinket(Delayed_gratification, "Crea 1 {{Coin}} Moneta se una stanza viene completata senza subire danni", "Gratificazione ritardata", "it")

end


-------------MOD CONFIG MENU STUFF----------------------------
--------------------------------------------------------------

function mod:SaveStorage()
        mod:SaveData(json.encode(TrinketValues))
  end
  
  if ModConfigMenu then
  
    local function SaveModConfig()
        if TrinketValues.EffectsAllowed then
            mod:SaveData("true")
        else
            mod:SaveData("false")
        end
    end
  
    ModConfigMenu.AddSetting("Balatro Expansion", "Settings", {
        Type = ModConfigMenu.OptionType.BOOLEAN,
    Default = true,
    CurrentSetting = function()
      return TrinketValues.EffectsAllowed
    end,
    Display = function()
      if TrinketValues.EffectsAllowed then return "Additional Effects: Enabled"
      else return "Additional Effects: Disabled" end
    end,
    OnChange = function(newvalue)
        TrinketValues.EffectsAllowed = newvalue
      SaveModConfig()
    end,
    Info = {"Determines whether or not the additional Balatro VFX/SFX are used"}
    })
  end
  
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.SaveStorage)
