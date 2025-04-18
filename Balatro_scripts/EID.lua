---@diagnostic disable: need-check-nil
if not EID then
    return
end

local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local TrinketSprite = Sprite("gfx/005.350_custom.anm2")

local SupportedLanguages = {"en_us"}


----------------------------------------------------------------
do
    local CoopMenu = Sprite("gfx/sprites/EID Icons.anm2")

    EID:addIcon("PlayerJimbo","Jimbo",0,16,16,-7,-6, CoopMenu)
end

EID:addColor("ColorMint", KColor(0.36, 0.87, 0.51, 1)) --taken from the Balatro Jokers mod
EID:addColor("ColorYellorange", KColor(238/255, 186/255, 49/255, 1))
EID:addColor("ColorChips", KColor(49/255, 140/255, 238/255, 1))
EID:addColor("ColorMult", KColor(238/255, 49/255, 66/255, 1))
EID:addColor("ColorGlass", KColor(0.85, 0.85, 1, 0.6))


--[[
local function BalatroValueCondition(descObj) -- descObj contains all informations about the currently described entity
    if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then 
        local Trinket = descObj.ObjSubType
        local Config = ItemsConfig:GetTrinket(Trinket)
        --chacks if it's mad trinket and if it needs a value description
        if Config:HasCustomTag("value") and Config:HasCustomTag("balatro") then
            if Config:HasCustomTag("mult") then
                --SUPERNOVA EXCEPTION--
                if Trinket == mod.Jokers.SUPERNOVA then
                    for _, player in ipairs(PlayerManager:GetPlayers()) do
                        if player:HasTrinket(mod.Jokers.SUPERNOVA) then
                            
                            local FirstActive = player:GetActiveItem(0)
                            local SecondActive = player:GetActiveItem(1)
                            if mod.Saved.TrinketValues.Supernova[FirstActive] and mod.Saved.TrinketValues.Supernova[SecondActive] then
                                if FirstActive == 0 and SecondActive == 0 then
                                    ValueDescription = "#Currently: No {{Collectible}} Active item held"
                                    return true
                                
                                elseif mod.Saved.TrinketValues.Supernova[FirstActive] >= mod.Saved.TrinketValues.Supernova[SecondActive] and FirstActive ~= 0 then
                                    ValueDescription = "#Currently: {{Collectible"..tostring(FirstActive).."}} gives {{Damage}} {{ColorMult}}+"..tostring(mod.Saved.TrinketValues.Supernova[FirstActive]).."{{CR}} Damage "
                                    return true
                                else
                                    ValueDescription = "#Currently: {{Collectible"..tostring(SecondActive).."}} gives {{Damage}} {{ColorMult}}+"..tostring(mod.Saved.TrinketValues.Supernova[SecondActive]).."{{CR}} Damage "
                                    return true
                                end
                            end
                            break
                        end
                    end
                    return false
                else --anything other than supernova
                    ValueDescription = "#Currently: {{Damage}} {{ColorMult}}+"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage"
                    return true
                end
            elseif Config:HasCustomTag("multm") then
                ValueDescription = "#Currently: {{Damage}} {{ColorMult}}X"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Damage Multiplier"
                return true
            elseif Config:HasCustomTag("chips") then
                ValueDescription = "#Currently: {{Tears}} {{ColorChips}}+"..tostring(mod.Saved.TrinketValues[Config.Name:gsub(" ","_")]).."{{CR}} Tears "
                return true
            else
                --PUT ALL THE ACTIVATE JOKERS HERE
                if Trinket == mod.Jokers.ROCKET then
                    ValueDescription = "#Currently: "..tostring(mod.Saved.TrinketValues.Rocket).." {{Coin}} Coins "
                    return true
                elseif Trinket == mod.Jokers.CLOUD_NINE then
                    ValueDescription = "#Currently: "..tostring(mod.Saved.TrinketValues.Cloud_9).." pickups remaining"
                    return true
                elseif Trinket == mod.Jokers.LOYALTY_CARD then
                    ValueDescription = "#Currently: "..tostring(mod.Saved.TrinketValues.Loyalty_card).." rooms remaining"
                    return true
                elseif Trinket == mod.Jokers.BLUEPRINT then
                    if mod.Saved.TrinketValues.Blueprint == 0 then
                        ValueDescription = "#{{Warning}} No {{Collectible}} Items picked up"
                    else
                        ValueDescription = "#Currently giving: {{Collectible"..tostring(mod.Saved.TrinketValues.Blueprint).."}}"
                    end
                    return true
                elseif Trinket == mod.Jokers.BRAINSTORM then
                    if mod.Saved.TrinketValues.Brainstorm == 0 then
                        ValueDescription = "#{{Warning}} No {{Collectible}} Items picked up"
                    else
                        ValueDescription = "#Currently giving: {{Collectible"..tostring(mod.Saved.TrinketValues.Brainstorm).."}}"
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
--EID:addDescriptionModifier("Balatro Current Values", BalatroValueCondition, BalatroValueCallback)]]






--------------LIST OF ALL THE BASIC DESCRIPTIONS--------------------

local EnhancementDesc = {}
EnhancementDesc["en_us"] = {}
EnhancementDesc["en_us"][mod.Enhancement.NONE] = ""
EnhancementDesc["en_us"][mod.Enhancement.BONUS] = "# {{ColorChips}}Bonus Card{{CR}}: When triggered gives {{ColorChips}}+0.75 Tears{{CR}}"
EnhancementDesc["en_us"][mod.Enhancement.MULT] = "# {{ColorMult}}Mult Card{{CR}}: When triggered gives {{ColorMult}}+0.05 Damage{{CR}}"
EnhancementDesc["en_us"][mod.Enhancement.GOLDEN] = "# {{ColorYellorange}}Gold Card{{CR}}: Holding it when a {{ColorYellorange}}blind{{CR}} is cleared gives {{ColorYellow}}2${{CR}} #!!! Cards played need to be {{ColorCyan}}Triggerable{{CR}} for the effect to occur"
EnhancementDesc["en_us"][mod.Enhancement.GLASS] = "# {{ColorGlass}}Glass Card{{CR}}: When triggered gives {{ColorMult}}x1.3 Damage Multiplier{{CR}} #!!! When played {{ColorMint}}10% chance{{CR}} to get destroyed"
EnhancementDesc["en_us"][mod.Enhancement.LUCKY] = "# {{ColorMint}}Lucky Card{{CR}}: When triggered {{ColorMint}}20% chance{{CR}} to give {{ColorMult}}+0.2 Mult{{CR}} and {{ColorMint}}5% chance{{CR}} to spawn {{ColorYellow}}10 {{Coin}}Coins{{CR}}"
EnhancementDesc["en_us"][mod.Enhancement.STEEL] = "# {{ColorSilver}}Steel Card{{CR}}: When held in hand gives {{ColorMult}}x1.2 Damage Multiplier{{CR}}"
EnhancementDesc["en_us"][mod.Enhancement.WILD] = "# {{ColorRainbow}}Wild Card{{CR}}: This card counts as every Suit"
EnhancementDesc["en_us"][mod.Enhancement.STONE] = "# {{ColorGray}}Stone Card{{CR}}: When triggered gives {{ColorChips}}+1.25 Tears{{CR}} #!!! Has no Value or Suit"


local SealDesc = {}
SealDesc["en_us"] = {}
SealDesc["en_us"][mod.Seals.NONE] = ""
SealDesc["en_us"][mod.Seals.RED] = "# {{ColorRed}}Red Seal{{CR}}: This card's abilities are {{ColorYellorange}}Triggered one more time{{CR}}"
SealDesc["en_us"][mod.Seals.BLUE] = "# {{ColorCyan}}Blue Seal{{CR}}: Holding this when a Blind is{{ColorYellorange}} Cleared{{CR}} spawns the card's respective {{ColorCyan}}Planet Card{{CR}}"
SealDesc["en_us"][mod.Seals.GOLDEN] = "# {{ColorYellorange}}Golden Seal{{CR}}: {{ColorYellorange}}Triggering{{CR}} this card spawn a {{Coin}} Penny which disappears soon after if not taken"
SealDesc["en_us"][mod.Seals.PURPLE] = "# {{ColorPink}}Purple Seal{{CR}}: {{ColorRed}}Discarding{{CR}} spawns a random {{ColorPink}}Tarot Card{{CR}} #!!! Lower chance for the effect to occur if multiple are discarded {{ColorYellorange}}at the same time{{CR}}"

local CardEditionDesc = {}
CardEditionDesc["en_us"] = {}
CardEditionDesc["en_us"][mod.Edition.BASE] = ""
CardEditionDesc["en_us"][mod.Edition.FOIL] = "# {{ColorChips}}Foil{{CR}}: Gives {{ColorChips}}+1.25 Tears{{CR}} when triggered"
CardEditionDesc["en_us"][mod.Edition.HOLOGRAPHIC] = "# {{ColorMult}}Holographic{{CR}}: Gives {{ColorMult}}+0.25 Damage{{CR}} when triggered"
CardEditionDesc["en_us"][mod.Edition.POLYCROME] = "# {{ColorRainbow}}Polychrome{{CR}}: Gives {{ColorMult}}x1.2 Damage Multiplier{{CR}} when triggered"
CardEditionDesc["en_us"][mod.Edition.NEGATIVE] = "# {{ColorGray}}{{ColorFade}}Negative{{CR}}: wtf how did you even get this"


local JokerEditionDesc = {}
JokerEditionDesc["en_us"] = {}
JokerEditionDesc["en_us"][mod.Edition.NOT_CHOSEN] = ""
JokerEditionDesc["en_us"][mod.Edition.BASE] = ""
JokerEditionDesc["en_us"][mod.Edition.FOIL] = "# {{ColorChips}}Foil{{CR}}: Gives {{ColorChips}}+2.5 Tears{{CR}} while held"
JokerEditionDesc["en_us"][mod.Edition.HOLOGRAPHIC] = "# {{ColorMult}}Holographic{{CR}}: Gives {{ColorMult}}+0.5 Damage{{CR}} while held"
JokerEditionDesc["en_us"][mod.Edition.POLYCROME] = "# {{ColorRainbow}}Polychrome{{CR}}: Gives {{ColorMult}}x1.25 Damage Multiplier{{CR}} while held"
JokerEditionDesc["en_us"][mod.Edition.NEGATIVE] = "# {{ColorGray}}{{ColorFade}}Negative{{CR}}: {{ColorYellorange}}+1 Joker Slot{{CR}} while held"


local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")
EID:addEntity(1000, DescriptionHelperVariant, DescriptionHelperSubType,"Description Overview", "")


----------------------------------------
-------------####JOKERS####-------------
-----------------------------------------
EID:addTrinket(mod.Jokers.JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.2 {{CR}}Damage", "Joker", "en_us")
EID:addTrinket(mod.Jokers.BULL, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.15 {{CR}}Tears for every {{Coin}} coin held", "Bull", "en_us")
EID:addTrinket(mod.Jokers.INVISIBLE_JOKER, "{{PlayerJimbo}} Selling this joker after clearing 3 Blinds while holding it gives a copy of another held Joker", "Invisible Joker", "en_us")
EID:addTrinket(mod.Jokers.ABSTRACT_JOKER, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.15 {{CR}} Damage per Joker held #{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.03 {{CR}} Damage per Collectible held", "Abstract Joker", "en_us")
EID:addTrinket(mod.Jokers.MISPRINT, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0-1 {{CR}} random Damage Up every new room #{{PlayerJimbo}} {{ColorMint}}10% Chance{{CR}} for any item to become a gliched one upon spawning", "Misprint", "en_us")
EID:addTrinket(mod.Jokers.JOKER_STENCIL, "{{PlayerJimbo}} {{ColorMult}}+0.75X{{CR}} Damage Multiplier for every Joker slot being {{ColorYellorange}}empty{{CR}} or containing another {{ColorYellorange}}Joker Stencil{{CR}}#Not having any {{Collectible}}Active item gives and additional {{ColorMult}}+0.25X{{CR}} Damage Multiplier", "Joker Stencil", "en_us")
EID:addTrinket(mod.Jokers.STONE_JOKER, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+1.25 {{CR}}Tears for every for every stone card in the player's full deck", "Stone Joker", "en_us")
EID:addTrinket(mod.Jokers.ICECREAM, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+4 {{CR}}Tears#Loses {{ColorChips}}-0.16{{CR}} Tears every room completed while held", "Icecream", "en_us")
EID:addTrinket(mod.Jokers.POPCORN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+1 {{CR}}Damage #Loses {{ColorMult}}-0.2{{CR}} Damage when clearing any blind", "Popcorn", "en_us")
EID:addTrinket(mod.Jokers.RAMEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage Multiplier#loses {{ColorMult}}-0.02X {{CR}} on every hand discard", "Ramen", "en_us")
EID:addTrinket(mod.Jokers.ROCKET, "{{PlayerJimbo}} Gives 2 {{Coin}}Coins on Blind clear#{{Coin}}Coin payout increases by {{ColorYellorange}}1${{CR}} when a boss blind is defeated #{{PlayerJimbo}} Grants the {{Collectible583}}Rocket in Jar effect", "Rocket", "en_us")
EID:addTrinket(mod.Jokers.ODDTODD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.31 {{CR}} Tears for every Odd numbered card triggered this room #{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.07{{CR}} Tears per Collectible held if the total amount is odd", "Odd Todd", "en_us")
EID:addTrinket(mod.Jokers.EVENSTEVEN, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.04 {{CR}} Damage per Even numbered card triggered this room #{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage per Collectible held if the total amount is even", "Even Steven", "en_us")
EID:addTrinket(mod.Jokers.HALLUCINATION, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}} to spawn a random {{Card}}{{ColorPink}} Tarot Card {{CR}}when opening a Booster Pack #{{PlayerJimbo}} {{ColorMint}}50% chance{{CR}} to give a {{Collectible431}} Multidimansional Baby every room entered", "Hallucination", "en_us")
EID:addTrinket(mod.Jokers.GREEN_JOKER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage per room completed while held#{{Damage}}{{ColorMult}}-0.16 {{CR}}Damage on every hand discard" , "Green Joker", "en_us")
EID:addTrinket(mod.Jokers.RED_CARD, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.15 {{CR}} Damage when skipping a Booster Pack" , "Red Card", "en_us")
EID:addTrinket(mod.Jokers.VAGABOND, "{{PlayerJimbo}} Spawns a random {{Card}}{{ColorPink}} Tarot Card {{CR}}when compleating a room with 2 {{Coin}} Coins or less#", "Vagabond", "en_us")
EID:addTrinket(mod.Jokers.RIFF_RAFF, "{{PlayerJimbo}} Spawns a random {{ColorChips}} common {{CR}} Joker on every Blind Clear", "Riff-Raff", "en_us")
EID:addTrinket(mod.Jokers.GOLDEN_JOKER, "{{PlayerJimbo}} Gives 4 {{Coin}} Coins on every Blind clear #{{Coin}} Every enemy touched becomes golden for a short time", "Golden Joker", "en_us")
EID:addTrinket(mod.Jokers.FORTUNETELLER, "{{PlayerJimbo}} {{Damage}}{{ColorMult}}+0.04 {{CR}} Damage for every {{Card}}{{ColorPink}} Tarot Card {{CR}}used throughout the run" , "Fortuneteller", "en_us")
EID:addTrinket(mod.Jokers.BLUEPRINT, "{{PlayerJimbo}} Copies the effect of the Joker to its right", "Blueprint", "en_us")
EID:addTrinket(mod.Jokers.BRAINSTORM, "{{PlayerJimbo}} Copies the effect of the leftmost held Joker", "Brainstorm", "en_us")
EID:addTrinket(mod.Jokers.MADNESS, "{{PlayerJimbo}} Destroys another random Joker and gains {{ColorMult}}+0.01X{{CR}} Damage Multiplier every {{ColorYellorange}}Small and Big Blind{{CR}} cleared", "Madness", "en_us")
EID:addTrinket(mod.Jokers.MR_BONES, "{{PlayerJimbo}}Revives jimbo at Full Hp if he died after clearing at least half of the current Blind or during any {{BossRoom}} Bossfight #{{ColorMint}}20% chance{{CR}} to use the {{Collectible545}} Book of the Dead on every Room Clear", "Mr. Bones", "en_us")
EID:addTrinket(mod.Jokers.ONIX_AGATE, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.07 {{CR}} Damage for every Club card triggered in the room", "Onyx Agate", "en_us")
EID:addTrinket(mod.Jokers.ARROWHEAD, "{{PlayerJimbo}} {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per {{ColorGray}}Spade{{CR}} card triggered in the room # {{Tears}} {{ColorChips}}+0.5 {{CR}} Tears per {{Key}} Key held", "Arrowhead", "en_us")
EID:addTrinket(mod.Jokers.BLOODSTONE, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Heart card triggered to give {{Damage}} {{ColorMult}}X1.05 {{CR}} Damage Multiplier", "Bloodstone", "en_us")
EID:addTrinket(mod.Jokers.ROUGH_GEM, "{{PlayerJimbo}} {{ColorMint}} 1/2 chance {{CR}}for every Diamond card triggered to spawn a {{Coin}}Coin that disappears shortly after #Every {{ColorYellorange}}Dimaond{{CR}} card shot also has the {{Collectible506}} Backstabber effect", "Rough gem", "en_us")

EID:addTrinket(mod.Jokers.GROS_MICHAEL, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.75 {{CR}}Damage #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destoroyed on every Blind cleared", "Gros Michel", "en_us")
EID:addTrinket(mod.Jokers.CAVENDISH, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X1.5 {{CR}}Damage multiplier #{{Warning}} {{ColorMint}}1/6 chance{{CR}} of getting destroyed on every Blind cleared", "Cavendish", "en_us")
EID:addTrinket(mod.Jokers.FLASH_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{RestockMachine}} Restock machine activated while holding this #{{Collectible105}} {{Damage}} {{ColorMult}}+0.02 {{CR}} Damage for every {{ColorYellorange}}Dice Item{{CR}} ussed while holding this", "Flash Card", "en_us")
EID:addTrinket(mod.Jokers.SACRIFICIAL_DAGGER, "{{PlayerJimbo}} Destroys the Joker to it's right and gains {{Damage}}{{ColorMult}} +0.08 x the destroyed Joker's sell value{{CR}} Damage on every Blind cleared", "Sacrificial Dagger", "en_us")
EID:addTrinket(mod.Jokers.CLOUD_NINE, "{{PlayerJimbo}} Gain 1 {{Coin}} Coin for every {{ColorYellorange}}9{{CR}} in your FullvDeck on every Blind clear #{{Seraphim}} Gives Flight", "Cloud 9", "en_us")
EID:addTrinket(mod.Jokers.SWASHBUCKLER, "{{PlayerJimbo}} {{Shop}} Gives {{Damage}}{{ColorMult}} +0.05 x the total sell value of other held Jokers{{CR}} Damage", "Swashbucler", "en_us")
EID:addTrinket(mod.Jokers.CARTOMANCER, "{{PlayerJimbo}} Spawns 1 random {{Card}} {{ColorPink}} Tarot Card {{CR}}on every Blind clear", "Cartomancer", "en_us")
EID:addTrinket(mod.Jokers.LOYALTY_CARD, "{{PlayerJimbo}} {{Damage}} {{ColorMult}}X2 {{CR}} Damage multiplier once every 6 rooms cleares", "Loyalty Card", "en_us")
EID:addTrinket(mod.Jokers.SUPERNOVA, "{{PlayerJimbo}} When a card is played, gives {{Damage}}{{ColorMult}} +0.01 {{CR}} Damage for every time a card with the same value got played in the current room", "Supernova", "en_us")
EID:addTrinket(mod.Jokers.DELAYED_GRATIFICATION, "{{PlayerJimbo}} Gives 1 coin per {{Heart}} Heart when clearing a room at full health #{{Timer}} Both the {{Boss}}Bossrush and {{Hush}} Hush door open regardless of the ingame timer", "Delayed Gratification", "en_us")
EID:addTrinket(mod.Jokers.EGG, "{{PlayerJimbo}} The sell value of this Joker increases by{{ColorYellorange}} +2$ {{CR}} every {{ColorYellorange}}Blind cleared{{CR}}", "Egg", "en_us")
EID:addTrinket(mod.Jokers.DNA, "{{PlayerJimbo}} If the {{ColorYellorange}} First {{CR}}card triggered in a {{ColorYellorange}}Blind{{CR}} hits an enemy, a copy of that card is added to the deck #{{Collectible658}} Spawns a Mini-Isaac every Hostile room cleared", "DNA", "en_us")
EID:addTrinket(mod.Jokers.SMEARED_JOKER, "{{PlayerJimbo}} {{ColorMult}}Hearts{{CR}} and {{ColorYellorange}}Diamonds{{CR}} count as the same suit #{{ColorGray}}Spades{{CR}} and {{ColorBlue}}Clubs{{CR}} count as the same suit", "Smeared Joker", "en_us")

EID:addTrinket(mod.Jokers.SLY_JOKER, "{{PlayerJimbo}} {{ColorChips}}+4 {{CR}}Tears if a {{ColorYellorange}}Pair{{CR}} is held when entering a room", "Sly Joker", "en_us")
EID:addTrinket(mod.Jokers.WILY_JOKER, "{{PlayerJimbo}} {{ColorChips}}+8 {{CR}}Tears if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room", "Wily Joker", "en_us")
EID:addTrinket(mod.Jokers.CLEVER_JOKER, "{{PlayerJimbo}} {{ColorChips}}+7 {{CR}}Tears if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room", "Clever Joker", "en_us")
EID:addTrinket(mod.Jokers.DEVIOUS_JOKER, "{{PlayerJimbo}} {{ColorChips}}+12 {{CR}}Tears if a {{ColorYellorange}}Straight{{CR}} is held when entering a room", "Devious Joker", "en_us")
EID:addTrinket(mod.Jokers.CRAFTY_JOKER, "{{PlayerJimbo}} {{ColorChips}}+9 {{CR}}Tears if a {{ColorYellorange}}Flush{{CR}} is held when entering a room", "Crafty Joker", "en_us")
EID:addTrinket(mod.Jokers.JOLLY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+1 {{CR}}Damage if a {{ColorYellorange}}Pair{{CR}} is held when entering a room", "Jolly Joker", "en_us")
EID:addTrinket(mod.Jokers.ZANY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+2 {{CR}}Damage if a {{ColorYellorange}}Three of a kind{{CR}} is held when entering a room", "Zany Joker", "en_us")
EID:addTrinket(mod.Jokers.MAD_JOKER, "{{PlayerJimbo}} {{ColorMult}}+1.75 {{CR}}Damage if a {{ColorYellorange}}Two-pair{{CR}} is held when entering a room", "Mad Joker", "en_us")
EID:addTrinket(mod.Jokers.CRAZY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+3 {{CR}}Damage if a {{ColorYellorange}}Straight{{CR}} is held when entering a room", "Crazy Joker", "en_us")
EID:addTrinket(mod.Jokers.DROLL_JOKER, "{{PlayerJimbo}} {{ColorMult}}+2.25 {{CR}}Damage if a {{ColorYellorange}}Flush{{CR}} is held when entering a room", "Droll Joker", "en_us")

EID:addTrinket(mod.Jokers.MIME, "{{PlayerJimbo}} {{ColorYellorange}}Retriggers{{CR}} {{ColorYellorange}}all held in hand{{CR}} effects #{{ColorMint}}20% Chance{{CR}} to copy the effect of an Active Item or consumable used", "Mime", "en_us")
EID:addTrinket(mod.Jokers.FOUR_FINGER, "{{PlayerJimbo}} {{ColorYellorange}}Flushes{{CR}} and {{ColorYellorange}}Straights{{CR}} only need 4 compatible cards #Every fifth non-boss enemy spawned gets killed immediantly", "Fpur Fingers", "en_us")
EID:addTrinket(mod.Jokers.LUSTY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorMult}}Heart{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Luty Joker", "en_us")
EID:addTrinket(mod.Jokers.GREEDY_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorYellorange}}Diamond{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Greedy Joker", "en_us")
EID:addTrinket(mod.Jokers.WRATHFUL_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorGray}}Spade{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Wrathful Joker", "en_us")
EID:addTrinket(mod.Jokers.GLUTTONOUS_JOKER, "{{PlayerJimbo}} {{ColorMult}}+0.03 {{CR}}Damage per triggered {{ColorChips}}Club{{CR}} card {{ColorYellorange}}triggered{{CR}}", "Gluttonous Joker", "en_us")
EID:addTrinket(mod.Jokers.MERRY_ANDY, "{{PlayerJimbo}} {{ColorRed}}+2 Hp{{CR}} and {{ColorCyan}}-1 Hand size{{CR}} while held", "Merry Andy", "en_us")
EID:addTrinket(mod.Jokers.HALF_JOKER, "{{PlayerJimbo}} {{ColorMult}}+1.5 {{CR}}Damage when {{CR}}5 or less{{CR}} card have been played in the current room #{{PlayerJimbo}} {{ColorMult}}+1 {{CR}}Damage when holding {{ColorYellorange}}3 or less{{CR}} cards", "Half Joker", "en_us")
EID:addTrinket(mod.Jokers.CREDIT_CARD, "{{PlayerJimbo}} Allows to go in {{ColorYellorange}}debt{{CR}} by spending more coins than you have#{{Shop}} Items on sale can be bought with a maximum of {{ColorMult}}-20${{CR}} debt #!!! Interest and coin-based effect cannot trigger while in debt", "Credit Card", "en_us")

EID:addTrinket(mod.Jokers.BANNER, "{{PlayerJimbo}} {{ColorChips}}+1.5 {{CR}}Tears per Red heart Jimbo has", "Banner", "en_us")
EID:addTrinket(mod.Jokers.MYSTIC_SUMMIT, "{{PlayerJimbo}} {{ColorMult}}+0.75 {{CR}}Damage while having only 1 full Red Heart", "Mystic Summit", "en_us")
EID:addTrinket(mod.Jokers.MARBLE_JOKER, "{{PlayerJimbo}} Adds a {{ColorGray}}Stone card{{CR}} to the deck every blind cleared", "Marble Joker", "en_us")
EID:addTrinket(mod.Jokers._8_BALL, "{{PlayerJimbo}} {{ColorMint}}1/8 Chance{{CR}} to spawn a random {{Card}} {{ColorPink}}Tarot card{{CR}} when an {{ColorYellorange}}8{{CR}} is triggered", "8 Ball", "en_us")
EID:addTrinket(mod.Jokers.DUSK, "{{PlayerJimbo}} The {{ColorYellorange}}last 10{{CR}} triggerable cards shot get retriggered an additional time", "Dusk", "en_us")
EID:addTrinket(mod.Jokers.RAISED_FIST, "{{PlayerJimbo}} The held card with the {{ColorYellorange}}lowest value{{CR}} gives {{ColorMult}}0.05{{CR}} {{ColorYellorange}} X its value{{CR}} Damage", "Raised Fist", "en_us")
EID:addTrinket(mod.Jokers.CHAOS_CLOWN, "{{PlayerJimbo}} Every {{Shop}} Shop visited has an additional Restock Machine", "Chaos the Clown", "en_us")
EID:addTrinket(mod.Jokers.FIBONACCI, "{{PlayerJimbo}} {{ColorMult}}+0.08 {{CR}}Damage per {{ColorYellorange}}Ace, 2, 3, 5 and 8{{CR}} triggered this room", "Fibonacci", "en_us")
EID:addTrinket(mod.Jokers.STEEL_JOKER, "{{PlayerJimbo}} This gains {{ColorMult}}+0.15X {{CR}}Damage Multiplier per {{ColorSilver}}Steel card{{CR}} in your deck", "Steel Joker", "en_us")
EID:addTrinket(mod.Jokers.SCARY_FACE, "{{PlayerJimbo}} {{ColorChips}}+0.3 {{CR}}Tears per {{ColorYellorange}}Face card{{CR}} triggered #{{ColorChips}}+1 {{CR}}Tears per {{ColorYellorange}}Champion enemy{{CR}} killed this room", "Scary Face", "en_us")
EID:addTrinket(mod.Jokers.HACK, "{{PlayerJimbo}} Played {{ColorYellorange}}2, 3, 4 and 5{{CR}} get retrigged #Jimbo gains a copy of every {{Quality0}} and {{Quality1}} Item held", "Hack", "en_us")
EID:addTrinket(mod.Jokers.PAREIDOLIA, "{{PlayerJimbo}} Every played card counts as a {{ColorYellorange}}Face card{{CR}} #{{ColorMint}}1/5 Chance{{CR}} for any non-boss enemy to become a {{ColorYellorange}}Champion{{CR}}", "Pareidolia", "en_us")

EID:addTrinket(mod.Jokers.SCHOLAR, "{{PlayerJimbo}} {{ColorMult}}+0.04{{CR}} Damage and {{ColorChips}}+0.1{{CR}} Tears per {{ColorYellorange}}Ace{{CR}} triggered", "Scholar", "en_us")
EID:addTrinket(mod.Jokers.BUSINESS_CARD, "{{PlayerJimbo}} {{ColorMint}}1/2 Chance{{CR}} to spawn 2 vanishing Pennies when a {{ColorYellorange}}Face card{{CR}} is triggered #Gain the {{Collectible602}} Member Card effect", "Business Card", "en_us")
EID:addTrinket(mod.Jokers.RIDE_BUS, "{{PlayerJimbo}} {{ColorMult}}+0.01 {{CR}}Damage per consecutive {{ColorYellorange}}non-Face card{{CR}} triggered", "Ride the Bus", "en_us")
EID:addTrinket(mod.Jokers.SPACE_JOKER, "{{PlayerJimbo}} {{ColorMint}}1/20 Chance{{CR}} to upgrade the played card value's level #Gains an additional {{ColorMint}}1/20 Chance{{CR}} per {{ColorYellorange}}Star-related{{CR}} Item held", "Space Joker", "en_us")
EID:addTrinket(mod.Jokers.BURGLAR, "{{PlayerJimbo}} Sets your Hp to {{ColorRed}}1{{CR}}#Cards can be triggered until the deck gets {{ColorYellorange}}reshuffled{{CR}} every room", "Burglar", "en_us")
EID:addTrinket(mod.Jokers.BLACKBOARD, "{{PlayerJimbo}} {{ColorMult}}x2 {{CR}}Damage Multiplier if all cards held in hand are {{ColorGray}}Spades{{CR}} or {{ColorChips}}Clubs{{CR}}", "Blackboard", "en_us")
EID:addTrinket(mod.Jokers.RUNNER, "{{PlayerJimbo}} This joker gains {{ColorChips}}+2 {{CR}}Tears when entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} in hand #Gives {{ColorChips}}+Tears{{CR}} equal to your speed stat#{{Speed}} +0.1 Speed", "Runner", "en_us")
EID:addTrinket(mod.Jokers.SPLASH, "{{PlayerJimbo}} Triggers all cards in hand upon entering a hostile room", "Splash", "en_us")
EID:addTrinket(mod.Jokers.BLUE_JOKER, "{{PlayerJimbo}} {{ColorChips}}+0.1 {{CR}}Tears per remaining card in your deck", "Blue Joker", "en_us")
EID:addTrinket(mod.Jokers.SIXTH_SENSE, "{{PlayerJimbo}} If the {{ColorYellorange}}First{{CR}} card played in a {{ColorYellorange}}Blind{{CR}} is a {{ColorYellorange}}6{{CR}} and hits an enemy, it gets destroyed and spawns a {{ColorBlue}}Spectral Pack{{CR}}", "Sixth Sense", "en_us")
EID:addTrinket(mod.Jokers.CONSTELLATION, "{{PlayerJimbo}} This Jokers gains {{ColorMult}}+0.04X{{CR}} Damage Multiplier every time a {{ColorCyan}}Planet Card{{CR}} is used while holding it", "Constellation", "en_us")
EID:addTrinket(mod.Jokers.HIKER, "{{PlayerJimbo}} {{ColorYellorange}}Triggering{{CR}} a card gives it a {{ColorYellorange}}permanent{{CR}} {{ColorMult}}+0.02{{CR}} Tears upgrade", "Hiker", "en_us")
EID:addTrinket(mod.Jokers.FACELESS, "{{PlayerJimbo}} Gain {{ColorMult}}+3${{CR}} when discarding {{ColorYellorange}}at least 2 Face cards{{CR}} at the same time #If only {{ColorYellorange}}Non-boss champion{{CR}} enemies are left in the room, they are {{ColorYellorange}}killed instantly{{CR}} spawning a vanishing penny", "Faceless Joker", "en_us")
EID:addTrinket(mod.Jokers.SUPERPOSISION, "{{PlayerJimbo}} Entering an {{ColorYellorange}}unexplored{{CR}} room while holding a {{ColorYellorange}}Straight{{CR}} and an {{ColorYellorange}}Ace{{CR}} spawns an {{ColorPink}}Arcana Pack{{CR}} #Grants 2 {{Collectible128}} Forever Alone Flies", "Superposition", "en_us")
EID:addTrinket(mod.Jokers.TO_DO_LIST, "{{PlayerJimbo}} A random {{ColorYellorange}}Card value{{CR}} is chosen upon entering an hostile room #{{ColorYellorange}}Playing{{CR}} a card with that value spawns a vanishing penny", "To Do List", "en_us")



----------------------------------------
-------------####VOUCHERS####------------
-----------------------------------------

EID:addCollectible(mod.Vouchers.Grabber, "{{PlayerJimbo}} {{ColorBlue}} +5 playable cards{{CR}} every room", "Grabber", "en_us")
EID:addCollectible(mod.Vouchers.NachoTong, "{{PlayerJimbo}} {{ColorBlue}} +5 additional playable cards{{CR}} every room", "Nacko Tong", "en_us")

EID:addCollectible(mod.Vouchers.Wasteful, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}}", "Wasteful", "en_us")
EID:addCollectible(mod.Vouchers.Recyclomancy, "{{PlayerJimbo}} {{Heart}}{{ColorBlue}} +1 Health up{{CR}}", "Recyclomancy", "en_us")

EID:addCollectible(mod.Vouchers.Overstock, "{{PlayerJimbo}} Every future shop will have 1 additional Joker for sale", "Overstock", "en_us")
EID:addCollectible(mod.Vouchers.OverstockPlus, "{{PlayerJimbo}} Every future shop will have 1 additional Joker for sale", "Overstock Plus", "en_us")

EID:addCollectible(mod.Vouchers.Clearance, "{{PlayerJimbo}} Everything is discounted by {{ColorYellorange}} 25%{{CR}} #!!! Prices are rounded down", "Clearance Sale", "en_us")
EID:addCollectible(mod.Vouchers.Liquidation, "{{PlayerJimbo}} Everything is discounted by {{ColorYellorange}} 50%{{CR}} #!!! Prices are rounded down", "Liquidation", "en_us")

EID:addCollectible(mod.Vouchers.Hone, "{{PlayerJimbo}} Special {{ColorRainbow}}Editions{{CR}} become {{ColorYellorange}}2x{{CR}} more likely to appear", "Hone", "en_us")
EID:addCollectible(mod.Vouchers.GlowUp, "{{PlayerJimbo}} Special {{ColorRainbow}}Editions{{CR}} become {{ColorYellorange}}4x{{CR}} more likely to appear", "Glow Up", "en_us")

EID:addCollectible(mod.Vouchers.RerollSurplus, "{{PlayerJimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{ColorYellorange}}1 {{Coin}} Coins{{CR}}", "Reroll Surplus", "en_us")
EID:addCollectible(mod.Vouchers.RerollGlut, "{{PlayerJimbo}} Activating a {{RestockMachine}} Restock Machine gives back {{ColorYellorange}}2 {{Coin}} Coins{{CR}}", "Reroll Glut", "en_us")

EID:addCollectible(mod.Vouchers.Crystal, "{{PlayerJimbo}} Every {{ColorYellorange}}Booster Pack{{CR}} has 1 more option to choose from", "Crystal Ball", "en_us")
EID:addCollectible(mod.Vouchers.Omen, "{{PlayerJimbo}} {{ColorPink}}Arcana Packs{{CR}} may contain spectral cards", "Omen Globe", "en_us")

EID:addCollectible(mod.Vouchers.Telescope, "{{PlayerJimbo}} Skipping a {{ColorCyan}}Celestial Pack{{CR}} creates {{ColorYellorange}}2{{CR}} additional random {{ColorCyan}}Planet Cards{{CR}}", "Telescope", "en_us")
EID:addCollectible(mod.Vouchers.Observatory, "{{PlayerJimbo}} Triggering a card while holding it's respective {{ColorCyan}}Planet Card{{CR}} gives {{Damage}}{{ColorMult}} X1.15{{CR}} Damage Multiplier#{{Planetarium}} Having the respective Planetarium item also counts", "Observatory", "en_us")

EID:addCollectible(mod.Vouchers.Blank, "{{PlayerJimbo}} {{ColorFade}}Nothing?{{CR}}", "Blank", "en_us")
EID:addCollectible(mod.Vouchers.Antimatter, "{{PlayerJimbo}} Adds a permanent {{ColorYellorange}}Joker Slot{{CR}} to the inventorycon pickup", "Antimatter", "en_us")

EID:addCollectible(mod.Vouchers.Brush, "{{PlayerJimbo}} Gives {{ColorChips}}+1 Hand Size{{CR}}", "Brush", "en_us")
EID:addCollectible(mod.Vouchers.Palette, "{{PlayerJimbo}} Gives {{ColorChips}}+1 additional Hand Size{{CR}}", "Palette", "en_us")

EID:addCollectible(mod.Vouchers.Director, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible105}} D6 effect", "Director's Cut", "en_us")
EID:addCollectible(mod.Vouchers.Retcon, "{{Coin}} Using this Item costs {{ColorYellorange}}10 Cents{{CR}} #{{Blank}} #{{PlayerJimbo}} Triggers the {{Collectible283}} D100 effect", "Retcon", "en_us")

EID:addCollectible(mod.Vouchers.Hieroglyph, "{{PlayerJimbo}} Activates the {{Collectible127}} Forget Me Now! effect upon pickup", "Hieroglyph", "en_us")
EID:addCollectible(mod.Vouchers.Petroglyph, "{{PlayerJimbo}} Activates the {{Collectible127}} Forget Me Now! effect upon pickup", "Petroglyph", "en_us")

EID:addCollectible(mod.Vouchers.MagicTrick, "{{PlayerJimbo}} {{ColorMint}} 25% chance{{CR}} to be able to choose one more option from a pack #Can trigger Multiple times", "Magic Trick", "en_us")
EID:addCollectible(mod.Vouchers.Illusion, "{{PlayerJimbo}} Every pack opened has a{{ColorMint}} 55% chance{{CR}} to contain {{ColorYellorange}}2{{CR}} more options and a {{ColorMint}} 15% chance{{CR}} to let the player choose {{ColorYellorange}}1{{CR}} more option", "Observatory", "en_us")

EID:addCollectible(mod.Vouchers.MoneySeed, "{{PlayerJimbo}} Maximum interest increased to {{ColorYellow}}10${{CR}}", "Money Seed", "en_us")
EID:addCollectible(mod.Vouchers.MoneyTree, "{{PlayerJimbo}} Maximum interest increased to {{ColorYellow}}20${{CR}}", "Money Tree", "en_us")

EID:addCollectible(mod.Vouchers.PlanetMerch, "{{PlayerJimbo}} Every pickup has a {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card{{CR}}", "Planet Merchant", "en_us")
EID:addCollectible(mod.Vouchers.PlanetTycoon, "{{PlayerJimbo}} Every pickup has an additional {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorCyan}}Planet Card{{CR}}", "Planet Tycoon", "en_us")

EID:addCollectible(mod.Vouchers.TarotMerch, "{{PlayerJimbo}} Every pickup has a {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Tarot Merchant", "en_us")
EID:addCollectible(mod.Vouchers.TarotTycoon, "{{PlayerJimbo}} Every pickup has an additional {{ColorMint}}7% chance{{CR}} to be replaced with a random {{ColorPink}}Tarot Card{{CR}}", "Tarot Tycoon", "en_us")


----------------------------------------
-------------####TAROTS####------------
-----------------------------------------

local TarotDescriptions = {}
TarotDescriptions["en_us"] = {}
TarotDescriptions["en_us"][Card.CARD_FOOL] = "#{{PlayerJimbo}} Spawns copy of your last used card #!!! Cannot spawn itself #Currently: "
TarotDescriptions["en_us"][Card.CARD_MAGICIAN] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMint}}Lucky Cards{{CR}}"
TarotDescriptions["en_us"][Card.CARD_HIGH_PRIESTESS] = "#{{PlayerJimbo}} Spawns {{ColorYellorange}}2{{CR}} random {{ColorCyan}}Planet Cards{{CR}}"
TarotDescriptions["en_us"][Card.CARD_EMPRESS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorMult}}Mult Cards{{CR}}"
TarotDescriptions["en_us"][Card.CARD_EMPEROR] = "#{{PlayerJimbo}} Spawns {{ColorYellorange}}2{{CR}} random {{ColorPink}}Tarot Cards{{CR}} #!!! Cannot spawn itself"
TarotDescriptions["en_us"][Card.CARD_HIEROPHANT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 2{{CR}} cards from your hand into {{ColorChips}}Bonus Cards{{CR}}"
TarotDescriptions["en_us"][Card.CARD_LOVERS] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorRainbow}}Wild Card{{CR}}"
TarotDescriptions["en_us"][Card.CARD_CHARIOT] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorSilver}}Steel Card{{CR}}"
TarotDescriptions["en_us"][Card.CARD_JUSTICE] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorGlass}}Glass Card{{CR}}"
TarotDescriptions["en_us"][Card.CARD_HERMIT] = "#{{PlayerJimbo}} Doubles you current money #!!! Can give up to {{ColorYellow}}20${{CR}}"
TarotDescriptions["en_us"][Card.CARD_WHEEL_OF_FORTUNE] = "#{{PlayerJimbo}} {{ColorMint}}25% chance{{CR}} to give a random {{ColorRainbow}}Edition{{CR}} to a joker in your inventory #!!! Cannot replace an Edition a Joker already has"
TarotDescriptions["en_us"][Card.CARD_STRENGTH] = "#{{PlayerJimbo}} Raise the value of {{ColorYellorange}}up to 2{{CR}} cards by 1 #!!! Kings chosen become Aces"
TarotDescriptions["en_us"][Card.CARD_HANGED_MAN] = "#{{PlayerJimbo}} Removes from the deck {{ColorYellorange}}up to 2{{CR}} cards"
TarotDescriptions["en_us"][Card.CARD_DEATH] = "#{{PlayerJimbo}} Choose {{ColorYellorange}}2{{CR}} cards, the {{ColorYellorange}}Second{{CR}} card chosen becomes the {{ColorYellorange}}First{{CR}}"
TarotDescriptions["en_us"][Card.CARD_TEMPERANCE] = "#{{PlayerJimbo}} Gives the total {{ColorYellow}}Sell value{{CR}} of you Jokers in {{Coni}}Pennies"
TarotDescriptions["en_us"][Card.CARD_DEVIL] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorYellorange}}Gold Card{{CR}}"
TarotDescriptions["en_us"][Card.CARD_TOWER] = "#{{PlayerJimbo}} Turn {{ColorYellorange}}up to 1{{CR}} card from your hand into a {{ColorGray}}Stone Card{{CR}}"
TarotDescriptions["en_us"][Card.CARD_STARS] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorYellorange}}Diamonds{{CR}}"
TarotDescriptions["en_us"][Card.CARD_MOON] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorChips}}Clubs{{CR}}"
TarotDescriptions["en_us"][Card.CARD_SUN] = "#{{PlayerJimbo}} Sets the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorMult}}Hearts{{CR}}"
TarotDescriptions["en_us"][Card.CARD_JUDGEMENT] = "#{{PlayerJimbo}} Gives random {{ColorYellorange}}Joker{{CR}} #!!! Requires an empty Inventory slot"
TarotDescriptions["en_us"][Card.CARD_WORLD] = "#{{PlayerJimbo}} Set the Suit of {{ColorYellorange}}up to 3{{CR}} cards from your hand into {{ColorGray}}Spades{{CR}}"

--TarotDescriptions["en_us"][Card.CARD_FOOL] = "#{{PlayerJimbo}}"

----------------------------------------
-------------####PLANETS####------------
-----------------------------------------

EID:addCard(mod.Planets.PLUTO, "{{PlayerJimbo}} {{ColorYellorange}}Aces{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Pluto", "en_us")
EID:addCard(mod.Planets.MERCURY, "{{PlayerJimbo}} {{ColorYellorange}}2s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Mercury", "en_us")
EID:addCard(mod.Planets.URANUS, "{{PlayerJimbo}} {{ColorYellorange}}3s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Uranus", "en_us")
EID:addCard(mod.Planets.VENUS, "{{PlayerJimbo}} {{ColorYellorange}}4s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Venus", "en_us")
EID:addCard(mod.Planets.SATURN, "{{PlayerJimbo}} {{ColorYellorange}}5s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Saturn", "en_us")
EID:addCard(mod.Planets.JUPITER, "{{PlayerJimbo}} {{ColorYellorange}}6s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Jupiter", "en_us")
EID:addCard(mod.Planets.EARTH, "{{PlayerJimbo}} {{ColorYellorange}}7s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Earth", "en_us")
EID:addCard(mod.Planets.MARS, "{{PlayerJimbo}} {{ColorYellorange}}8s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Mars", "en_us")
EID:addCard(mod.Planets.NEPTUNE, "{{PlayerJimbo}} {{ColorYellorange}}9s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Neptune", "en_us")
EID:addCard(mod.Planets.PLANET_X, "{{PlayerJimbo}} {{ColorYellorange}}10s{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Planet X", "en_us")
EID:addCard(mod.Planets.CERES, "{{PlayerJimbo}} {{ColorYellorange}}Jacks{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Ceres", "en_us")
EID:addCard(mod.Planets.ERIS, "{{PlayerJimbo}} {{ColorYellorange}}Queens{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Eris", "en_us")
EID:addCard(mod.Planets.SUN, "{{PlayerJimbo}} {{ColorYellorange}}Kings{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Sun", "en_us")


----------------------------------------
-------------####SPECTRALS####------------
-----------------------------------------

EID:addCard(mod.Spectrals.FAMILIAR, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}3{{CR}} random {{ColorYellorange}}Enhanced Face cards{{CR}} to your deck", "Familiar", "en_us")
EID:addCard(mod.Spectrals.GRIM, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}2{{CR}} random {{ColorYellorange}}Enhanced Aces cards{{CR}} to your deck", "Grim", "en_us")
EID:addCard(mod.Spectrals.INCANTATION, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} one random card from your hand and adds {{ColorYellorange}}4{{CR}} random {{ColorYellorange}}Enhanced Numbered cards{{CR}} to your deck", "Incantation", "en_us")
EID:addCard(mod.Spectrals.TALISMAN, "{{PlayerJimbo}} Put a {{ColorYellorange}}Golden Seal{{CR}} on one selected card", "Talisman", "en_us")
EID:addCard(mod.Spectrals.AURA, "{{PlayerJimbo}} Give a random {{ColorRainbow}}Edition{{CR}} to a selected card", "Aura", "en_us")
EID:addCard(mod.Spectrals.WRAITH, "{{PlayerJimbo}} Sets your money to {{ColorYellorange}}0{{CR}} and gives a random {{ColorMult}}Rare Joker{{CR}}#!!! Requires an empty Inventory slot", "Wraith", "en_us")
EID:addCard(mod.Spectrals.SIGIL, "{{PlayerJimbo}} Turns all the cards in your hand to the same random {{ColorYellorange}}Suit{{CR}}", "Sigil", "en_us")
EID:addCard(mod.Spectrals.OUIJA, "{{PlayerJimbo}} Turns all the cards in your hand to the same random {{ColorYellorange}}Rank{{CR}}", "Ouija", "en_us")
EID:addCard(mod.Spectrals.ECTOPLASM, "{{PlayerJimbo}} Turns a random Joker {{ColorGray}}{{ColorFade}}Negative{{CR}} and gives {{ColorRed}}-1{{CR}} Hand size #!!! Cannot replace any {{ColorYellorange}}Edition{{CR}} a Joker alredy has #!!! The effect won't occur if hand size cannot be lowered", "Ectoplasm", "en_us")
EID:addCard(mod.Spectrals.IMMOLATE, "{{PlayerJimbo}} {{ColorYellorange}}Destroys{{CR}} up to {{ColorYellorange}}3{{CR}} cards from your hand and gives {{ColorYellow}}4${{CR}} for every card destroyed", "Immolate", "en_us")
EID:addCard(mod.Spectrals.ANKH, "{{PlayerJimbo}} Gives a copy a of random Joker held and destroys all the others #!!! Removes the {{ColorGray}}{{ColorFade}}Negative{{CR}} Edition from the copied Joker", "Ankh", "en_us")
EID:addCard(mod.Spectrals.DEJA_VU, "{{PlayerJimbo}} Put a {{ColorRed}}Red Seal{{CR}} on one selected card", "Deja Vu", "en_us")
EID:addCard(mod.Spectrals.HEX, "{{PlayerJimbo}} Gives the {{ColorRainbow}}Polychrome{{CR}} Edition to random Joker held and destroys all the others", "Hex", "en_us")
EID:addCard(mod.Spectrals.TRANCE, "{{PlayerJimbo}} Put a {{ColorCyan}}Blue Seal{{CR}} on one selected card", "Trance", "en_us")
EID:addCard(mod.Spectrals.MEDIUM, "{{PlayerJimbo}} Put a {{ColorPink}}Purple Seal{{CR}} on one selected card", "Medium", "en_us")
EID:addCard(mod.Spectrals.CRYPTID, "{{PlayerJimbo}} Add {{ColorYellorange}}2{{CR}} copies of a selected card to your deck", "Cryptid", "en_us")
EID:addCard(mod.Spectrals.BLACK_HOLE, "{{PlayerJimbo}} {{ColorYellorange}}All Cards{{CR}} triggered give an additional {{ColorChips}}+0.02 Tears{{CR}} and {{ColorMult}}+0.02 Damage{{CR}}", "Black Hole", "en_us")
EID:addCard(mod.Spectrals.SOUL, "{{PlayerJimbo}} Gives a random {{ColorRainbow}}Legendary{{CR}} Joker#!!! Requires an empty Inventory slot", "The Soul", "en_us")




--uses a hacky entity to simulate the options being descripted, no idea if this is an optimal way or not
local function BalatroInventoryCondition(descObj)
    if descObj.ObjType == EntityType.ENTITY_EFFECT and descObj.ObjVariant == DescriptionHelperVariant and descObj.ObjSubType == DescriptionHelperSubType then
        if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType)
           and Balatro_Expansion.SelectionParams.Mode ~= Balatro_Expansion.SelectionParams.Modes.NONE then
            return true
        end
    end
end
local function BalatroInventoryCallback(descObj)
    -- alter the description object as you like

    descObj.Name = "Selection Helper" --PLACEHOLDER

    local Language = EID:getLanguage()
    if not mod:Contained(SupportedLanguages, Language) then
        Language = "en_us"
    end

    local SelectedCard
    local SelectedSlots

    local Icon = ""
    local Name = ""
    local Description = ""


    if Balatro_Expansion.SelectionParams.Mode == Balatro_Expansion.SelectionParams.Modes.INVENTORY then

        SelectedCard = Balatro_Expansion.Saved.Jimbo.Inventory[mod.SelectionParams.Index]

        if not SelectedCard then --the extra confirm button

            if Balatro_Expansion.SelectionParams.Purpose == Balatro_Expansion.SelectionParams.Purposes.SELLING then

                for i,selected in ipairs(mod.SelectionParams.SelectedCards) do
                    if selected then
                        SelectedCard = mod.Saved.Jimbo.Inventory[i].Joker
                        SelectedSlots = i
                        break
                    end
                end

                local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard))
                
                EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

                Icon = "{{Shop}}"
                Name = "Sell the selected joker"
                Description = "#{{CurrentCard}} Currently gives {{ColorYellorange}}"..Balatro_Expansion:GetJokerCost(SelectedCard, SelectedSlots).."${{CR}}"

            else --not selling anything and confirm button

                Icon = ""
                Name = "Exit overview"
                Description = ""
            end
            goto FINISH
        end

        SelectedCard = SelectedCard.Joker

        if SelectedCard == 0 then --emtoy slot

            Icon = ""
            Name = "{{Blank}} Nothing"
            Description = "Empty!"

        else --slot with something

            descObj.ObjType = 5
            descObj.ObjVariant = 350
            descObj.ObjSubType = SelectedCard


            local Tstring = "5.350."..tostring(SelectedCard)
            
            local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard))

            EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

            local Rarity = mod:GetJokerRarity(SelectedCard)
            local RarityColor
            if Rarity == "common" then
                RarityColor = "{{ColorCyan}}"
            elseif Rarity == "uncommon" then
                RarityColor = "{{ColorLime}}"
            elseif Rarity == "rare" then
                RarityColor = "{{ColorRed}}"
            else
                RarityColor = "{{ColorRainbow}}"
            end

            Icon = "{{CurrentCard}}"
            Name = RarityColor..EID:getObjectName(5, 350, SelectedCard).."{{CR}}#{{Blank}}"
            Description = EID:getDescriptionEntry("custom", Tstring)[3]

            local Edition = mod.Saved.Jimbo.Inventory[mod.SelectionParams.Index].Edition

            local EditionDesc = JokerEditionDesc[Language][Edition]

            Description = Description..EditionDesc

            --PROGRESS--

            local JokerConfig = ItemsConfig:GetTrinket(SelectedCard)
            if JokerConfig:HasCustomTag("Value") then

                local Value = Balatro_Expansion.Saved.Jimbo.Progress.Inventory[mod.SelectionParams.Index]
                if JokerConfig:HasCustomTag("chips") then
                    Description = Description.." #!!! Currently:{{ColorChips}} +"..tostring(Value).."{{CR}}"

                elseif JokerConfig:HasCustomTag("mult") then
                    Description = Description.." #!!! Currently:{{ColorMult}} +"..tostring(Value).."{{CR}}"

                elseif JokerConfig:HasCustomTag("multm") then
                    if SelectedCard == mod.Jokers.LOYALTY_CARD then
                        if Value == 0 then
                            Description = Description.." #!!! {{ColorYellorange}}Active!{{CR}}"
                        else
                            Description = Description.." #!!! Rooms left:{{ColorYellorange}} "..tostring(Value).."{{CR}}"
                        end
                    else
                        Description = Description.." #!!! Currently:{{ColorMult}} X"..tostring(Value).."{{CR}}"
                    end


                elseif JokerConfig:HasCustomTag("money") then
                    if SelectedCard == mod.Jokers.CLOUD_NINE then
                        Description = Description.." #!!! Currently gives:{{ColorYellorange}} "..tostring(Value).."${{CR}}"

                    elseif SelectedCard == mod.Jokers.TO_DO_LIST then

                        Description = Description.." #!!! -Play {{ColorYellorange}} "..tostring(Value).."s{{CR}}"
                    else
                        Description = Description.." #!!! Currently:{{ColorYellorange}} "..tostring(Value).."${{CR}}"
                    end
                elseif JokerConfig:HasCustomTag("activate") then

                    if SelectedCard == mod.Jokers.BLUEPRINT or SelectedCard == mod.Jokers.BRAINSTORM then

                        local CopiedJoker = Balatro_Expansion.Saved.Jimbo.Inventory[Value].Joker or 0
                        if CopiedJoker ~= 0 and ItemsConfig:GetTrinket(CopiedJoker):HasCustomTag("copy")  then
                            Description = Description.." #!!! Currently:{{ColorLime}} Compatible{{CR}}"
                        else
                            Description = Description.." #!!! Currently:{{ColorMult}} Incompatible{{CR}}"
                        end

                    elseif SelectedCard == mod.Jokers.INVISIBLE_JOKER then

                        if Value == 3 then
                            Description = Description.." #!!! Currently cleared Blinds:{{ColorYellorange}} Ready!{{CR}}"
                        else
                            Description = Description.." #!!! Currently cleared Blinds: {{ColorYellorange}}"..tostring(Value).."/3{{CR}}"
                        end
                    elseif SelectedCard == mod.Jokers.DNA then
                        if Balatro_Expansion.Saved.Jimbo.Progress.Blind.Shots == 0 then
                            Description = Description.." #!!! Currently: {{ColorYellorange}}Ready!{{CR}}"

                        else
                            Description = Description.." #!!! Currently: {{ColorRed}}Not Active!{{CR}}"

                        end
                    end
                end
                
            end

            --SELL VALUE--

            if SelectedCard == mod.Jokers.EGG then
                Description = Description.." #{{Shop}} Sells for {{ColorYellorange}}"..tostring(mod.Saved.Jimbo.Progress.Inventory[mod.SelectionParams.Index]).."${{CR}}"

            else
                Description = Description.." #{{Shop}} Sells for {{ColorYellorange}}"..tostring(mod:GetJokerCost(SelectedCard, mod.SelectionParams.Index)).."${{CR}}"

            end
        end

    elseif Balatro_Expansion.SelectionParams.Mode == Balatro_Expansion.SelectionParams.Modes.PACK then

        SelectedCard = Balatro_Expansion.SelectionParams.PackOptions[mod.SelectionParams.Index]
        SelectedSlots = mod.SelectionParams.Index

        if not SelectedCard then -- the skip option
            
            Icon = ""
            Name = "{{ColorSilver}}Skip{{CR}}#{{Blank}}"
            Description = "Skip the remaining pack options" --wasn't able to find an api function for this

            goto FINISH
        end


        if Balatro_Expansion.SelectionParams.Purpose == Balatro_Expansion.SelectionParams.Purposes.BuffonPack then
            
            descObj.ObjType = 5
            descObj.ObjVariant = 350
            descObj.ObjSubType = SelectedCard.Joker


            local Tstring = "5.350."..tostring(SelectedCard.Joker)
            
            local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard.Joker))

            EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

            local Rarity = mod:GetJokerRarity(SelectedCard.Joker)
            local RarityColor
            if Rarity == "common" then
                RarityColor = "{{ColorCyan}}"
            elseif Rarity == "uncommon" then
                RarityColor = "{{ColorLime}}"
            elseif Rarity == "rare" then
                RarityColor = "{{ColorRed}}"
            else
                RarityColor = "{{ColorRainbow}}"
            end

            Icon = "{{CurrentCard}}"
            Name = RarityColor..EID:getObjectName(5, 350, SelectedCard.Joker).."{{CR}}#{{Blank}}"
            Description =""..EID:getDescriptionEntry("custom", Tstring)[3]


            local EditionDesc = JokerEditionDesc[Language][SelectedCard.Edition] or JokerEditionDesc["en_us"][SelectedCard.Edition]

            Description = Description..EditionDesc

        elseif Balatro_Expansion.SelectionParams.Purpose == Balatro_Expansion.SelectionParams.Purposes.StandardPack then 
            
            Icon = "{{RedCard}}"

            local CardName 
            if SelectedCard.Enhancement == mod.Enhancement.STONE then
                CardName = "{{ColorGray}}Stone Card{{CR}}"

            else
                CardName = mod:CardValueToName(SelectedCard.Value, true).." of "..mod:CardSuitToName(SelectedCard.Suit, true)

                CardName = CardName.."{{ColorCyan}} LV."..tostring(mod.Saved.Jimbo.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
            end
            
            Name = CardName

            local CardAttributes = EnhancementDesc[Language][SelectedCard.Enhancement]..SealDesc[Language][SelectedCard.Seal]..CardEditionDesc[Language][SelectedCard.Edition]
            
            Description = CardAttributes

        
        else
            local TrueCard = Balatro_Expansion:FrameToSpecialCard(SelectedCard)
            

            descObj.ObjType = 5
            descObj.ObjVariant = 300
            descObj.ObjSubType = TrueCard


            Icon = ""
            Name = EID:getObjectName(5, 300, TrueCard).."#{{Blank}}"
            if TrueCard <= Card.CARD_WORLD then
                Description = EID.descriptions[Language].cards[TrueCard][3] --wasn't able to find an api function for this
            else
                local CardString = "5.300."..tostring(TrueCard)

                Description = EID:getDescriptionEntry("custom", CardString)[3]
            end

        end

    elseif Balatro_Expansion.SelectionParams.Mode == Balatro_Expansion.SelectionParams.Modes.HAND then

        SelectedCard = mod.Saved.Jimbo.FullDeck[mod.Saved.Jimbo.CurrentHand[mod.SelectionParams.Index]]
        SelectedSlots = mod.SelectionParams.Index

        if not SelectedCard then -- the skip option
            
            Icon = ""
            Name = "{{ColorSilver}}Confirm{{CR}}#{{Blank}}"
            Description = "Confirm the current card selection as is" 

            goto FINISH
        end

        Icon = "{{RedCard}}"

        local CardName
        if SelectedCard.Enhancement == mod.Enhancement.STONE then
            CardName = "{{ColorGray}}Stone Card{{CR}}"

        else
            CardName = mod:CardValueToName(SelectedCard.Value, true).." of "..mod:CardSuitToName(SelectedCard.Suit, true)

            CardName = CardName.."{{ColorCyan}} LV."..tostring(mod.Saved.Jimbo.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
        end
        
        Name = CardName

        local CardAttributes = EnhancementDesc[Language][SelectedCard.Enhancement]..SealDesc[Language][SelectedCard.Seal]..CardEditionDesc[Language][SelectedCard.Edition]
        
        Description = CardAttributes

    end


    ::FINISH::

    EID:appendToDescription(descObj, "#"..Icon.." "..Name.."# "..Description)
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Balatro Inventory Overview", BalatroInventoryCondition, BalatroInventoryCallback)



local function BalatroExtraDescCondition(descObj)
    if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD 
       and descObj.ObjSubType <= Card.CARD_WORLD 
       or descObj.ObjSubType >= mod.Planets.PLUTO and descObj.ObjSubType <= mod.Spectrals.SOUL then
        if PlayerManager.AnyoneIsPlayerType(Balatro_Expansion.Characters.JimboType) then
            return true
        end
    end
end

local function BalatroExtraDescCallback(descObj)
    
    local Language = EID:getLanguage()
    if not mod:Contained(SupportedLanguages, Language) then
        Language = "en_us"
    end

    local BaseDesc = ""

    if descObj.ObjSubType <= Card.CARD_WORLD then

        BaseDesc = TarotDescriptions[Language][descObj.ObjSubType] or TarotDescriptions["en_us"][descObj.ObjSubType]


        if descObj.ObjSubType == Card.CARD_FOOL then


            local CardName = mod.Saved.LastCardUsed and "{{ColorLime}}"..EID:getObjectName(5,300,mod.Saved.LastCardUsed).."{{CR}}" or "{{ColorRed}}None{{CR}}"

            BaseDesc = BaseDesc..CardName

        elseif descObj.ObjSubType == Card.CARD_MAGICIAN then
            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.LUCKY]
        elseif descObj.ObjSubType== Card.CARD_LOVERS then
            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.WILD] 
        
        elseif descObj.ObjSubType== Card.CARD_DEVIL then
            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.GOLDEN] 
        
        elseif descObj.ObjSubType== Card.CARD_TOWER then
            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.STONE]
        
        elseif descObj.ObjSubType== Card.CARD_EMPRESS then
            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.MULT]
        
        elseif descObj.ObjSubType== Card.CARD_HIEROPHANT then

            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.BONUS]
        elseif descObj.ObjSubType== Card.CARD_CHARIOT then

            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.STEEL]
        elseif descObj.ObjSubType== Card.CARD_JUSTICE then

            BaseDesc = BaseDesc..EnhancementDesc[Language][mod.Enhancement.GLASS]
        end
    end
    
    if descObj.ObjSubType== mod.Spectrals.TALISMAN then

        BaseDesc = BaseDesc..SealDesc[Language][mod.Seals.GOLDEN]
    elseif descObj.ObjSubType== mod.Spectrals.DEJA_VU then

        BaseDesc = BaseDesc..SealDesc[Language][mod.Seals.RED]
    elseif descObj.ObjSubType== mod.Spectrals.TRANCE then

        BaseDesc = BaseDesc..SealDesc[Language][mod.Seals.BLUE]
    elseif descObj.ObjSubType== mod.Spectrals.MEDIUM then

        BaseDesc = BaseDesc..SealDesc[Language][mod.Seals.PURPLE]
    elseif descObj.ObjSubType== mod.Spectrals.ECTOPLASM then

        BaseDesc = BaseDesc..JokerEditionDesc[Language][mod.Edition.NEGATIVE]
    end


    EID:appendToDescription(descObj, BaseDesc)
    return descObj
end

EID:addDescriptionModifier("Balatro Extra descriptions", BalatroExtraDescCondition, BalatroExtraDescCallback)



local function BalatroOffsetCondition(descObj)
    if Game:GetPlayer(0):GetPlayerType() == mod.Characters.JimboType then 
       
        EID:addTextPosModifier("Jimbo HUD", Vector(0,10))
        return true
    else
        EID:removeTextPosModifier("Jimbo HUD")
    end
end

local function BalatroOffsetCallback(descObj)
    return descObj
end

EID:addDescriptionModifier("Balatro Descriptions Offset", BalatroOffsetCondition, BalatroOffsetCallback)