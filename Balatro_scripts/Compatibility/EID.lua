---@diagnostic disable: param-type-mismatch, cast-local-type, need-check-nil
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
--local TrinketSprite = Sprite("gfx/005.350_custom.anm2")

local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..

mod.EID_DescType = {NONE = 0,
                    CARD = 1,
                    JOKER = 2,
                    CONSUMABLE = 4,
                    BOOSTER = 8,
                    VOUCHER = 16,
                    BLIND = 32,
                    PLATE = 64,
                    WARNING = 128,
                    SELECTION_FLAG = 2048}

local EID_DescAllingnment = {TOP = 1,
                             BOTTOM = 2,
                             LEFT = 4,
                             RIGHT = 8,
                             CENTER = 0}


local EID_Descriptions = {}

mod.EIDSupportedLanguages = {"en_us","it"}


for _, LanguageCode in ipairs(mod.EIDSupportedLanguages) do

    local LangDescriptions = include("Balatro_scripts.Compatibility.EID translations."..LanguageCode)


    for Type, v in pairs(LangDescriptions) do

        EID_Descriptions[Type] = EID_Descriptions[Type] or {}
        
        for Variant ,Description in pairs(v) do

            EID_Descriptions[Type][Variant] = EID_Descriptions[Type][Variant] or {}
        
            if type(Description) == "table" then

                for SubType, String in pairs(Description) do

                    EID_Descriptions[Type][Variant][SubType] = EID_Descriptions[Type][Variant][SubType] or {}

                    EID_Descriptions[Type][Variant][SubType][LanguageCode] = String
                end

            else

                EID_Descriptions[Type][Variant][LanguageCode] = Description
            end
        end
    end
end


---@param Type string
---@param Variant string|number?
---@param SubType string|number?
---@param Raw boolean? return the desc's table instead of its translated string
function mod:GetEIDString(Type, Variant, SubType, Raw)

    if Raw then
        if SubType then
            return EID_Descriptions[Type][Variant][SubType]
        elseif Variant then
            return EID_Descriptions[Type][Variant]
        else
            return EID_Descriptions[Type]
        end
    else
        local Lang = mod:GetEIDLanguage()

        if SubType then
            return EID_Descriptions[Type][Variant][SubType] 
                   and (EID_Descriptions[Type][Variant][SubType][Lang] or EID_Descriptions[Type][Variant][SubType]["en_us"])
                   or nil
        else
            return EID_Descriptions[Type][Variant][Lang] or EID_Descriptions[Type][Variant]["en_us"]
        end
    end
end

function mod:HasEIDString(Type, Variant, SubType)

    local Result = EID_Descriptions[Type]
 
    if not Variant then
        return Result
    end
        
    Result = EID_Descriptions[Type][Variant] 

    if not SubType then
        return Result
    end
            
    return EID_Descriptions[Type][Variant][SubType]
end



---@return table ([[VALUE"X"]] = string)
local function GetT_JimboDescriptionValues(Type, Subtype, Index)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    local PIndex = T_Jimbo:GetData().TruePlayerIndex

    local Values = {}

    if Type == mod.EID_DescType.JOKER then

        local Joker = Subtype

        local JokerConfig = ItemsConfig:GetTrinket(Joker)


        local Progress
        if Index then
            Progress = mod.Saved.Player[PIndex].Inventory[Index].Progress
        end

        if JokerConfig:HasCustomTag("chips") then

            if Joker == mod.Jokers.CASTLE then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = mod:CardSuitToName(Progress & SUIT_FLAG, true)
            
                Values[2] = tostring((Progress & ~SUIT_FLAG)/(SUIT_FLAG + 1)) --chips accumulated

            elseif Joker == mod.Jokers.BLUE_JOKER then

                Progress = mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = tostring(Progress)

            elseif Joker == mod.Jokers.BULL then

                Progress = mod:GetJokerInitialProgress(Joker, true, T_Jimbo)
            
                Values[1] = tostring(T_Jimbo:GetNumCoins()*2)

            else--[[if Joker == mod.Jokers.STONE_JOKER
                   or Joker == mod.Jokers.ICECREAM
                   or Joker == mod.Jokers.RUNNER
                   or Joker == mod.Jokers.SQUARE_JOKER
                   or Joker == mod.Jokers.WEE_JOKER then]]

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = tostring(Progress)
            end

        elseif JokerConfig:HasCustomTag("mult") then

            if Joker == mod.Jokers.BOOTSTRAP then

                Progress = mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = tostring(Progress)

            else
               
                Progress = Progress or mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = tostring(Progress)
            end

        elseif JokerConfig:HasCustomTag("multm") then

            if Joker == mod.Jokers.ANCIENT_JOKER then

                local Suit = Progress or mod:GetJokerInitialProgress(Joker, true)

                Values[1] = mod:CardSuitToName(Suit,true)
            
            elseif Joker == mod.Jokers.IDOL then

                local card = Progress or mod:GetJokerInitialProgress(Joker, true)

                Values[1] = mod:GetCardName(card, true)
        
            elseif Joker == mod.Jokers.YORICK then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = tostring(1 + (Progress // 23)) --X mult
                Values[2] = tostring(23 - (Progress % 23)) --discards before upgrade

            elseif Joker == mod.Jokers.LOYALTY_CARD then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                if Progress == 0 then
                    
                    Values[1] = mod:GetEIDString("Other", "Ready")

                else
                    Values[1] = tostring(Progress)..mod:GetEIDString("Other", "Remaining")

                end


            else --[[Joker == mod.Jokers.JOKER_STENCIL
                   or Joker == mod.Jokers.LOYALTY_CARD
                   or Joker == mod.Jokers.MADNESS
                   or Joker == mod.Jokers.CONSTELLATION
                   or Joker == mod.Jokers.VAMPIRE
                   or Joker == mod.Jokers.HOLOGRAM
                   or Joker == mod.Jokers.OBELISK
                   or Joker == mod.Jokers.LUCKY_CAT
                   or Joker == mod.Jokers.CAMPFIRE
                   or Joker == mod.Jokers.THROWBACK
                   or Joker == mod.Jokers.GLASS_JOKER
                   or Joker == mod.Jokers.HIT_ROAD
                   or Joker == mod.Jokers.DRIVER_LICENSE]]

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true, T_Jimbo)

                Values[1] = tostring(Progress)
            end


        elseif JokerConfig:HasCustomTag("money") then

            if Joker == mod.Jokers.TO_DO_LIST then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true)

                local Hand = mod:GetEIDString("HandTypeName", Progress)

                Values[1] = Hand

            elseif Joker == mod.Jokers.SATELLITE then

                Progress = mod:GetJokerInitialProgress(Joker, true)
                    
                Values[1] = tostring(Progress)
                        
            elseif Joker == mod.Jokers.MAIL_REBATE then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true)

                Values[1] = mod:CardValueToName(Progress, true)

            elseif Joker == mod.Jokers.ROCKET then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true)

                Values[1] = tostring(Progress)
            end
        elseif JokerConfig:HasCustomTag("activate") then

            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                if not Progress then
                
                    Values[1] = ""
                elseif Progress ~= 0 then
                    Values[1] = mod:GetEIDString("Other", "Compatible")
                else
                    Values[1] = mod:GetEIDString("Other", "Incompatible")
                end

            elseif Joker == mod.Jokers.INVISIBLE_JOKER then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true)

                if Progress == 2 then
                    Values[1] = mod:GetEIDString("Other", "Ready")
                else
                    Values[1] = "{{ColorYellorange}}"..tostring(Progress).."/2{{ColorGray}}"..mod:GetEIDString("Other", "Rounds")
                end

                    
                Values[2] = ""

                for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                    if Slot.Edition == mod.Edition.NEGATIVE then
                        Values[2] = "#{{ColorGray}}("..mod:GetEIDString("Other","RemovesNeg")..")"
                        break
                    end
                end

            elseif Joker == mod.Jokers.DNA then

                if not Progress then

                    Values[1] = ""

                elseif mod.Saved.HandsRemaining == T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM) - 1 then
                    Values[1] = mod:GetEIDString("Other", "Ready")
                else
                    Values[1] = mod:GetEIDString("Other", "NotReady")
                end

            elseif Joker == mod.Jokers.SIXTH_SENSE then

                if not Progress then

                    Values[1] = ""

                elseif mod.Saved.HandsRemaining == T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM) - 1 then
                    Values[1] = mod:GetEIDString("Other", "Ready")
                else
                    Values[1] = mod:GetEIDString("Other", "NotReady")
                end

            
            
            else--[[ Joker == mod.Jokers.SELTZER 
                   or Joker == mod.Jokers.TURTLE_BEAN then]]

                Progress = Progress or mod:GetJokerInitialProgress(Joker, true)

                Values[1] = Progress
            end
        end

    elseif Type == mod.EID_DescType.CONSUMABLE then

        local card = Subtype
        
        if card == mod.Spectrals.ECTOPLASM then
            
            Values[1] = tostring(mod.Saved.Player[PIndex].EctoUses + 1)

        elseif card == mod.Spectrals.ANKH then

            Values[1] = ""

            for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if Slot.Edition == mod.Edition.NEGATIVE then
                    Values[1] = "#{{ColorGray}}("..mod:GetEIDString("Other","RemovesNeg")..")"
                    break
                end
            end
        
        elseif card == Card.CARD_FOOL then

            local LastUsed = mod.Saved.Player[PIndex].LastCardUsed
        
            if not LastUsed then
                
                Values[1] = "{{ColorMult}}"..mod:GetEIDString("Other","NONE").."{{B_Black}}"

            elseif LastUsed == Card.CARD_FOOL then

                Values[1] = "{{ColorMult}}"..mod:GetEIDString("ConsumablesName", Card.CARD_FOOL).."{{B_Black}}"

            elseif LastUsed <= Card.CARD_WORLD then

                Values[1] = "{{ColorMint}}"..mod:GetEIDString("ConsumablesName", LastUsed).."{{B_Black}}"
            else
                local Config = ItemsConfig:GetCard(card)

                Values[1] = Config.Name
            end


        elseif card == Card.CARD_TEMPERANCE then

            local TOtalSell = 0

            for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                
                if Slot.Joker ~= 0 then
                    
                    TOtalSell = TOtalSell + mod:GetJokerCost(Slot.Joker, Slot.Edition, i, T_Jimbo)
                end
            end

            Values[1] = "{{ColorYellow}}"..tostring(math.min(50, TOtalSell)).."{{B_Black}}"
        end

    elseif Type == mod.EID_DescType.BLIND then
    
        local Blind = Subtype

        if Blind == mod.BLINDS.OX then

            Values[1] = "["..mod:GetEIDString("HandTypeName", mod.Saved.BossBlindVarData).."]"
        end

    elseif Type == mod.EID_DescType.WARNING then

        local Blind = Subtype

        if Blind == mod.BLINDS.BOSS_EYE then

            Values[1] = "["..mod:GetEIDString("HandTypeName", mod.Saved.HandType).."]"

        elseif Blind == mod.BLINDS.BOSS_MOUTH then

            local AllowedHand = math.log(mod.Saved.BossBlindVarData, 2)

            Values[1] = "["..mod:GetEIDString("HandTypeName", AllowedHand).."]"
        end

    elseif Type == mod.EID_DescType.PLATE then

        local Tag = Subtype

        if Tag == mod.SkipTags.SPEED then
            Values[1] = tostring(5 * (mod.Saved.NumBlindsSkipped+1))

        elseif Tag == mod.SkipTags.GARBAGE then
            Values[1] = tostring(mod.Saved.DiscardsWasted)

        elseif Tag == mod.SkipTags.HANDY then
            Values[1] = tostring(mod.Saved.HandsPlayed)
        end


    end


    --converts the normal indexes to what we need for string.gsub (this made it easier to write the stuff above)
    for i,v in ipairs(Values) do

        v = string.gsub(v, "%.0$", "")

        Values["[[VALUE"..tostring(i).."]]"] = v
    end

    return Values
end

---@return table ([[VALUE"X"]] = string)
local function GetJimboDescriptionValues(Type, Subtype, Index)

    local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)

    local PIndex = Jimbo:GetData().TruePlayerIndex

    local Values = {}

    if Type == mod.EID_DescType.JOKER then

        local Progress
        if Index then
            Progress = mod.Saved.Player[PIndex].Inventory[Index].Progress
        end

        local Joker = Subtype

        local JokerConfig = ItemsConfig:GetTrinket(Joker)

        if JokerConfig:HasCustomTag("chips") then

            if Joker == mod.Jokers.CASTLE then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                Values[1] = mod:CardSuitToName(Progress & SUIT_FLAG, true)
            
                Values[2] = (Progress & ~SUIT_FLAG)/(SUIT_FLAG + 1) --chips accumulated

            elseif Joker == mod.Jokers.RUNNER then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                Values[1] = Progress + 2*Jimbo.MoveSpeed
                

            else --[[if Joker == mod.Jokers.STONE_JOKER
                   or Joker == mod.Jokers.ICECREAM
                   or Joker == mod.Jokers.RUNNER
                   or Joker == mod.Jokers.SQUARE_JOKER
                   or Joker == mod.Jokers.WEE_JOKER
                   or Joker == mod.Jokers.BULL then]]


                Values[1] = Progress or mod:GetJokerInitialProgress(Joker, false) --usually chips accumulated
            end

        elseif JokerConfig:HasCustomTag("mult") then

            if Joker == mod.Jokers.BOOTSTRAP then
            
               Values[1] = mod:GetJokerInitialProgress(Joker, false)

            else
                Values[1] = Progress or mod:GetJokerInitialProgress(Joker, false)
            end

        elseif JokerConfig:HasCustomTag("multm") then

            if Joker == mod.Jokers.ANCIENT_JOKER then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                Values[1] = mod:CardSuitToName(Progress,true)
            
            elseif Joker == mod.Jokers.IDOL then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                Values[1] = mod:GetCardName(Progress, true)

                local ItemChosen = Progress >> 7
                Values[2] = ItemChosen
                Values[3] = EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ItemChosen)
        
            elseif Joker == mod.Jokers.YORICK then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                Values[2] = 23 - (Progress % 23)
                Values[1] = 1 + (Progress // 23)

            elseif Joker == mod.Jokers.DRIVER_LICENSE then
            
                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                if Progress ~= 1 then --if it's giving mult
                    
                    Values[1] = mod:GetEIDString("Other", "Active")
                else

                    local Enahncements = 0
                    for _,card in ipairs(mod.Saved.Player[PIndex].FullDeck) do
                        if card.Enhancement ~= mod.Enhancement.NONE then
                            Enahncements = Enahncements + 1
                        end
                    end

                    Values[1] = "{{ColorYellorange}}"..Enahncements.."{{ColorGray}} "..mod:GetEIDString("Other", "Enhanced")
                end

            elseif Joker == mod.Jokers.LOYALTY_CARD then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                if Progress == 0 then
                    
                    Values[1] = mod:GetEIDString("Other", "Ready")

                else
                    Values[1] = Progress.." "..mod:GetEIDString("Other", "Remaining")

                end

            elseif Joker == mod.Jokers.ACROBAT then

                if Game:GetRoom():GetBossID() ~= 0 then

                    Values[1] = mod:GetEIDString("Other", "Active")
                else
                    Values[1] = mod:GetEIDString("Other", "NotActive")
                end

            elseif Joker == mod.Jokers.FLOWER_POT
                   or Joker == mod.Jokers.SEE_DOUBLE
                   or Joker == mod.Jokers.DUO
                   or Joker == mod.Jokers.TRIO
                   or Joker == mod.Jokers.FAMILY
                   or Joker == mod.Jokers.ORDER
                   or Joker == mod.Jokers.TRIBE then

                if Progress ~= 1 then
                    
                    Values[1] = mod:GetEIDString("Other", "Active")
                else
                    Values[1] = mod:GetEIDString("Other", "NotActive")
                end


            else --[[Joker == mod.Jokers.JOKER_STENCIL
                   or Joker == mod.Jokers.MADNESS
                   or Joker == mod.Jokers.CONSTELLATION
                   or Joker == mod.Jokers.VAMPIRE
                   or Joker == mod.Jokers.HOLOGRAM
                   or Joker == mod.Jokers.OBELISK
                   or Joker == mod.Jokers.LUCKY_CAT
                   or Joker == mod.Jokers.CAMPFIRE
                   or Joker == mod.Jokers.THROWBACK
                   or Joker == mod.Jokers.GLASS_JOKER
                   or Joker == mod.Jokers.HIT_ROAD then]]


                Values[1] = Progress or mod:GetJokerInitialProgress(Joker, false)
            end


        elseif JokerConfig:HasCustomTag("money") then

            if Joker == mod.Jokers.TO_DO_LIST then

                Progress = Progress or mod:GetJokerInitialProgress(Joker, false)

                local Hand = mod:CardValueToName(Progress, true)

                Values[1] = Hand

            elseif Joker == mod.Jokers.SATELLITE then

                local PlanetsUsed = 0

                for i=1, mod.Values.KING do
                    if mod.Saved.PlanetTypesUsed & (1<<i) ~= 0 then
                        PlanetsUsed = PlanetsUsed + 1
                    end
                end
                
                Values[1] = PlanetsUsed
        
            elseif Joker == mod.Jokers.MAIL_REBATE then

                local Value = mod:GetJokerInitialProgress(Joker, false)

                Values[1] = mod:CardValueToName(Value, true)

            else--if Joker == mod.Jokers.ROCKET
                --   or Joker == mod.Jokers.CLOUD_NINE then

                Values[1] = Progress or mod:GetJokerInitialProgress(Joker, false)
            end
        elseif JokerConfig:HasCustomTag("activate") then

            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

                if Progress then
                    if Progress ~= 0 then
                        Values[1] = mod:GetEIDString("Other", "Compatible")
                    else
                        Values[1] = mod:GetEIDString("Other", "Incompatible")
                    end
                end

            elseif Joker == mod.Jokers.INVISIBLE_JOKER then

                if not Progress then
                    Values[1] = ""
                elseif Progress == 3 then
                    Values[1] = mod:GetEIDString("Other", "Ready")
                else
                    Values[1] = "{{ColorYellorange}}"..Progress.."/3{{ColorGray}}"..mod:GetEIDString("Other", "Rounds")
                end
                

                for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                    if Slot.Edition == mod.Edition.NEGATIVE then
                        Values[2] = "#{{ColorGray}}("..mod:GetEIDString("Other","RemovesNeg")..")"
                        break
                    end
                end

            elseif Joker == mod.Jokers.DNA then

                if mod.Saved.Player[PIndex].Progress.Room.Shots == 1 then
                    Values[1] = mod:GetEIDString("Other", "Ready")
                else
                    Values[1] = mod:GetEIDString("Other", "NotReady")
                end

            elseif Joker == mod.Jokers.SIXTH_SENSE then

                if mod.Saved.Player[PIndex].Progress.Room.Shots == 1 then
                    Values[1] = mod:GetEIDString("Other", "Ready")
                else
                    Values[1] = mod:GetEIDString("Other", "NotReady")
                end

            elseif Joker == mod.Jokers.DUSK then

                local CardsRemaining = Jimbo:GetCustomCacheValue("hands") - mod.Saved.Player[PIndex].Progress.Room.Shots

                if CardsRemaining <= 10 and CardsRemaining >= 0 then
                    Values[1] = mod:GetEIDString("Other", "Active")
                else
                    Values[1] = mod:GetEIDString("Other", "NotActive")
                end

            elseif Joker == mod.Jokers.TURTLE_BEAN 
                   or Joker == mod.Jokers.SELTZER then

                Values[1] = Progress or mod:GetJokerInitialProgress(Joker, false)
                


            end
        end

        Values.Synergy = ""

        if mod:HasEIDString("JokerSynergies", Joker) then
            
            for Item,_ in ipairs(mod:GetEIDString("JokerSynergies", Joker, nil, true)) do
                
                if PlayerManager.AnyoneHasCollectible(Item) then
                    
                    Values.Synergy = Values.Synergy.."#{{Collectible"..Item.."}}"..mod:GetEIDString("JokerSynergies", Joker, Item)
                end
            end
        end

    elseif Type == mod.EID_DescType.CONSUMABLE then

        local card = Subtype

        if card == Card.CARD_FOOL then

            local LastUsed = mod.Saved.Player[PIndex].LastCardUsed
        
            if not LastUsed then
                
                Values[2] = "{{ColorMult}}"..mod:GetEIDString("Other","NONE").."{{CR}}"

                Values[1] = "!!! "
            elseif LastUsed == Card.CARD_FOOL then

                Values[2] = "{{ColorMult}}"..mod:GetEIDString("ConsumablesName", Card.CARD_FOOL).."{{CR}}"

                Values[1] = "!!! "

            elseif LastUsed <= Card.CARD_WORLD then --the vanilla tarots have their name fucked up 

                Values[2] = "{{ColorMint}}"..mod:GetEIDString("ConsumablesName", LastUsed).."{{CR}}"

                Values[1] = "{{Card"..LastUsed.."}} "
            else
                local Config = ItemsConfig:GetCard(LastUsed)

                Values[2] = "{{ColorMint}}"..Config.Name.."{{CR}}"

                Values[1] = "{{Card"..LastUsed.."}} "
            end

        elseif card == mod.Spectrals.ANKH then
            for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                if Slot.Edition == mod.Edition.NEGATIVE then
                    Values[1] = "#{{ColorGray}}("..mod:GetEIDString("Other","RemovesNeg")..")"
                    break
                end
            end
        end

    end


    --converts the normal indexes to what we need for string.gsub (this made it easier to write the stuff above)
    for i,v in ipairs(Values) do

        v = string.gsub(tostring(v), "%.0$", "")

        Values["[[VALUE"..i.."]]"] = v
    end

    return Values
end




---@param String string
---@param DescType integer
---@param DescSubType integer
---@param Index integer?
function mod:ReplaceBalatroMarkups(String, DescType, DescSubType, Tainted, Index)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)
    local Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.JimboType)


    String = string.gsub(String, "%[%[CHANCE%]%]", function ()
        
        local NumDice = #mod:GetJimboJokerIndex(T_Jimbo or Jimbo, mod.Jokers.OOPS_6)

        return tostring(math.floor(2^NumDice)) --usually chance based things are 1/X chance so no problem in doing this
    end)

    if Tainted then
        
        if mod.Saved.DSS.T_Jimbo.CustomEID then
            String = String.gsub(String, "%{%{CR%}%}", "{{B_Black}}")
        end
    end

    if DescType ~= mod.EID_DescType.NONE then

        local Values 
        if Tainted then
            Values = GetT_JimboDescriptionValues(DescType & ~mod.EID_DescType.SELECTION_FLAG, DescSubType, Index)
        else
            Values = GetJimboDescriptionValues(DescType & ~mod.EID_DescType.SELECTION_FLAG, DescSubType, Index)
        end

        String = string.gsub(String, "%[%[VALUE%d%]%]", Values)

        String = String..(Values.Synergy or "")
    end

    return String
end


--Isaac.DebugString("EID STRING INIT")

---@diagnostic disable: need-check-nil
if  EID then

EID:setModIndicatorName("TBoI: Regambled")
EID:setModIndicatorIcon("REG_Jimbo")

EID:addEntity(1000, mod.Effects.DESC_HELPER, 0, "", "")
EID:addEntity(1000, mod.Effects.DESC_HELPER, mod.Effects.PLATE_HELPER_SUBTYPE, "", "")



do
    local CoopMenu = Sprite("gfx/ui/hud_eid_jimbo.anm2")

    EID:addIcon("REG_Jimbo","Idle",0,12,8,6,5, CoopMenu)

    EID:addIcon("REG_Spade","Spade",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Heart","Heart",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Club","Club",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Diamond","Diamond",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Retrigger","Retrigger",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Face","Face",0,12,8,6,5, CoopMenu)

    EID:addIcon("REG_Bonus","Bonus",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Mult","Mult",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Glass","Glass",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Steel","Steel",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Gold","Gold",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Wild","Wild",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Stone","Stone",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Lucky","Lucky",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Joker","Joker",0,12,8,6,5, CoopMenu)

    EID:addIcon("REG_Foil","Foil",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Holo","Holo",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Poly","Poly",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Nega","Nega",0,12,8,6,5, CoopMenu)

    EID:addIcon("REG_Red","Red",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Purple","Purple",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Golden","Golden",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Blue","Blue",0,12,8,6,5, CoopMenu)
    
    EID:addIcon("REG_Planet","Planet",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Spectral","Spectral",0,12,8,6,5, CoopMenu)

    EID:addIcon("REG_Hand","Hands",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_HSize","HSize",0,12,8,6,5, CoopMenu)

    EID:addIcon("REG_Comedy","Comedy",0,12,8,6,5, CoopMenu)
    EID:addIcon("REG_Tragedy","Tragedy",0,12,8,6,5, CoopMenu)
end

EID:addColor("B_Black", mod.BalatroKColorBlack)

EID:addColor("ColorMint", mod.EffectKColors.GREEN)--KColor(0.36, 0.87, 0.51, 1)) --taken from the Balatro Jokers mod
EID:addColor("ColorYellorange", mod.EffectKColors.YELLOW)--KColor(238/255, 186/255, 49/255, 1))
EID:addColor("ColorChips",  mod.EffectKColors.BLUE)--KColor(49/255, 140/255, 238/255, 1))
EID:addColor("ColorMult", mod.EffectKColors.RED)-- KColor(238/255, 49/255, 66/255, 1))
EID:addColor("ColorGlass", KColor(0.85, 0.85, 1, 0.6))
EID:addColor("ColorSpade", KColor(33/255, 6/255, 54/255, 1))



function mod:GetFilteredEIDString(EIDstr)

    local FilteredStr = ""

    EIDstr = EID:replaceShortMarkupStrings(EIDstr)
	local textPartsTable = EID:filterColorMarkup(EIDstr, KColor.White)
	for i, textPart in ipairs(textPartsTable) do

		local PartialStr = EID:filterIconMarkup(textPart[1], false)

		if PartialStr then -- prevent possible crash when strFiltered is nil

            --print(i, PartialStr)

            FilteredStr = FilteredStr..PartialStr
		end
	end

    FilteredStr = string.gsub(FilteredStr, "#", " ")

    --print(FilteredStr)

    return FilteredStr
end


--uses a hacky entity to simulate the options being described, no idea if this is an optimal way or not
local function BalatroInventoryCondition(descObj)

    if descObj.ObjType == EntityType.ENTITY_EFFECT 
       and descObj.ObjVariant == mod.Effects.DESC_HELPER
       and descObj.ObjSubType == 0 then
        if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
            return true
        end
    end
end

local function BalatroInventoryCallback(descObj)

    descObj.Name = mod:GetEIDString("Other", "Name")

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end

        local PIndex = Player:GetData().TruePlayerIndex

        local SelectedCard
        local SelectedSlots

        local Icon = ""
        local Name = ""
        local Description = ""


        local SelectIndex = mod.SelectionParams[PIndex].Index

        if Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.INVENTORY then

            
            SelectedCard = Balatro_Expansion.Saved.Player[PIndex].Inventory[SelectIndex]

            if not SelectedCard then --the extra confirm button

                if Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.SELLING then

                    for i,selected in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                        if selected then
                            SelectedCard = mod.Saved.Player[PIndex].Inventory[i]
                            SelectedSlots = i
                            break
                        end
                    end

                    local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard.Joker))

                    EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])


                    local JokerName = ItemsConfig:GetTrinket(SelectedCard.Joker).Name

                    Icon = "{{Shop}}"
                    Name = mod:GetEIDString("Other", "SellJoker")
                    Description = "#{{CurrentCard}} {{ColorYellorange}}"..JokerName.."{{CR}} "..mod:GetEIDString("Other", "SellsFor").." {{ColorYellow}}"..tostring(mod:GetJokerCost(SelectedCard.Joker, SelectedCard.Edition, SelectedSlots, Player)).."${{CR}}"

                else --not selling anything and confirm button

                    Icon = ""
                    Name = mod:GetEIDString("Other", "Exit")
                    Description = ""
                end
                goto FINISH
            end


            if SelectedCard.Joker == 0 then --empty slot

                Icon = ""
                Name = "{{Blank}} "..mod:GetEIDString("Other", "Nothing")
                Description = mod:GetEIDString("Other", "EmptySlot")

            else --slot with something

                --descObj.ObjType = 5
                --descObj.ObjVariant = 350
                --descObj.ObjSubType = SelectedCard.Joker


                --local Tstring = "5.350."..tostring(SelectedCard.Joker)

                local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard.Joker))

                EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

                local Rarity = mod:GetJokerRarity(SelectedCard.Joker)
                local RarityColor
                if Rarity == "common" then
                    RarityColor = "{{ColorCyan}}"
                elseif Rarity == "uncommon" then
                    RarityColor = "{{ColorMint}}"
                elseif Rarity == "rare" then
                    RarityColor = "{{ColorRed}}"
                else
                    RarityColor = "{{ColorRainbow}}"
                end

                Icon = "{{CurrentCard}}"
                Name = RarityColor..EID:getObjectName(5, 350, SelectedCard.Joker).."{{CR}}#{{Blank}}"



                local Edition = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index].Edition

                local EditionDesc = mod:GetEIDString("Jimbo", "JokerEdition", Edition)

                --SELL VALUE--
                local SellString

                if SelectedCard.Joker == mod.Jokers.EGG then
                    SellString = " #{{Shop}} "..mod:GetEIDString("Other", "SellsFor").." {{ColorYellorange}}"..mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index].Progress.."${{CR}}"
                else
                    SellString = " #{{Shop}} "..mod:GetEIDString("Other", "SellsFor").." {{ColorYellorange}}"..mod:GetJokerCost(SelectedCard.Joker, SelectedCard.Edition, mod.SelectionParams[PIndex].Index, Player).."${{CR}}"
                end


                Description = mod:GetEIDString("Jimbo", "Jokers", SelectedCard.Joker)..EditionDesc..SellString

                --PROGRESS--
                
                Description = mod:ReplaceBalatroMarkups(Description, mod.EID_DescType.JOKER, SelectedCard.Joker, false, SelectIndex)
            
            end

        elseif Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.PACK then

            SelectedCard = Balatro_Expansion.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index]
            SelectedSlots = mod.SelectionParams[PIndex].Index

            if not SelectedCard then -- the skip option

                Icon = ""
                Name = mod:GetEIDString("Other", "SkipName").."#{{Blank}}"
                Description = mod:GetEIDString("Other", "SkipDesc") --wasn't able to find an api function for this

                goto FINISH
            end


            if Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.BuffonPack then

                --descObj.ObjType = 5
                --descObj.ObjVariant = 350
                --descObj.ObjSubType = SelectedCard.Joker


                local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard.Joker))

                EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

                local Rarity = mod:GetJokerRarity(SelectedCard.Joker)
                local RarityColor
                if Rarity == "common" then
                    RarityColor = "{{ColorCyan}}"
                elseif Rarity == "uncommon" then
                    RarityColor = "{{ColorMint}}"
                elseif Rarity == "rare" then
                    RarityColor = "{{ColorRed}}"
                else
                    RarityColor = "{{ColorRainbow}}"
                end

                Icon = "{{CurrentCard}}"
                Name = RarityColor..EID:getObjectName(5, 350, SelectedCard.Joker).."#{{Blank}}"

                local BaseDesc = mod:GetEIDString("Jimbo","Jokers",SelectedCard.Joker)

                Description = mod:ReplaceBalatroMarkups(BaseDesc, mod.EID_DescType.JOKER, SelectedCard.Joker, false, SelectIndex)


                local EditionDesc = mod:GetEIDString("Jimbo", "JokerEdition", SelectedCard.Edition)

                Description = Description..EditionDesc

            elseif Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.StandardPack then 

                Icon = "{{RedCard}}"

                local CardName = mod:GetCardName(SelectedCard, true)
                
                if SelectedCard.Enhancement ~= mod.Enhancement.STONE then
                    
                    CardName = CardName.."{{ColorCyan}} "..mod:GetEIDString("Other", "LV")..tostring(mod.Saved.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
                end

                Name = CardName

                local BaseEffect = "{{ColorChips}}+"..mod:RoundBalatroStyle(mod:GetValueScoring(SelectedCard.Value) + 0.02*SelectedCard.Upgrades, 8).."{{CR}} "..mod:GetEIDString("Other", "ChipsScored")
                local EnhancementEffect = mod:GetEIDString("Jimbo", "Enhancement", SelectedCard.Enhancement)
                local SealEffect = mod:GetEIDString("Jimbo", "Seal", SelectedCard.Seal)
                local EditionEffect = mod:GetEIDString("Jimbo", "CardEdition", SelectedCard.Edition)

                local CardAttributes = BaseEffect..EnhancementEffect..SealEffect..EditionEffect

                Description = CardAttributes

            
            else
                local TrueCard = Balatro_Expansion:FrameToSpecialCard(SelectedCard)


                descObj.ObjType = 5
                descObj.ObjVariant = 300
                descObj.ObjSubType = TrueCard


                Icon = ""
                Name = EID:getObjectName(5, 300, TrueCard).."#{{Blank}}"

                Description = mod:GetEIDString("Jimbo", "Consumables", TrueCard)
            end

        elseif Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.HAND then

            SelectedCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]
            SelectedSlots = mod.SelectionParams[PIndex].Index

            if not SelectedCard then -- the skip option

                Icon = ""
                Name = mod:GetEIDString("Other", "ConfirmName").."#{{Blank}}"
                Description = mod:GetEIDString("Other", "ConfirmDesc")

                goto FINISH
            end

            Icon = "{{RedCard}}"

            local CardName = mod:GetCardName(SelectedCard, true)

            if SelectedCard.Enhancement ~= mod.Enhancement.STONE then

                CardName = CardName.."{{ColorCyan}} "..mod:GetEIDString("Other", "LV")..tostring(mod.Saved.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
            end

            Name = CardName

            local EnhancementEffect = mod:GetEIDString("Jimbo", "Enhancement", SelectedCard.Enhancement)
            local SealEffect = mod:GetEIDString("Jimbo", "Seal", SelectedCard.Seal)

            local EditionEffect = mod:GetEIDString("Jimbo", "CardEdition", SelectedCard.Edition)

            local CardAttributes = EnhancementEffect..SealEffect..EditionEffect

            Description = CardAttributes
        end

        ::FINISH::

        EID:appendToDescription(descObj, "#"..Icon.." "..Name.."# "..Description)

        ::skip_player::
    end
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Balatro Inventory Overview", BalatroInventoryCondition, BalatroInventoryCallback)


local function JimboGroundPickupsCondition(descObj)

    if PlayerManager.AnyoneIsPlayerType(Balatro_Expansion.Characters.JimboType) 
       and descObj.ObjType == EntityType.ENTITY_PICKUP then

        return true
    end
end

local function JimboGroundPickupsCallback(descObj)

    if descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD then
        
        local Desc = mod:GetEIDString("Jimbo","Consumables", descObj.ObjSubType)

        if Desc then
            
            local OnlyJimbo = true

            for i,v in ipairs(PlayerManager.GetPlayers()) do
                if v:GetPlayerType() ~= mod.Characters.JimboType then
                    OnlyJimbo = false
                    break
                end
            end

            if OnlyJimbo then
                descObj.Description = Desc
            else
                EID:appendToDescription(descObj, "#{{REG_Jimbo}} "..Desc)
            end

            descObj.Description = mod:ReplaceBalatroMarkups(descObj.Description, mod.EID_DescType.CONSUMABLE, descObj.ObjSubType, false)
        end

    elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then

        local Joker = descObj.ObjSubType & ~mod.EditionFlag.ALL
        local Edition = (descObj.ObjSubType & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT
        
        descObj.Description = (mod:GetEIDString("Jimbo", "Jokers", Joker) or "")..mod:GetEIDString("Jimbo", "JokerEdition", Edition)
        
        descObj.Description = mod:ReplaceBalatroMarkups(descObj.Description, mod.EID_DescType.JOKER, Joker, false)
    
    else
        descObj.Description = mod:ReplaceBalatroMarkups(descObj.Description, mod.EID_DescType.NONE, descObj.ObjSubType, false)
    end
    
    return descObj
end
EID:addDescriptionModifier("Balatro Jimbo ground pickups", JimboGroundPickupsCondition, JimboGroundPickupsCallback)



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
    
    local BaseDesc = ""

    if descObj.ObjSubType <= Card.CARD_WORLD then

        --BaseDesc = EID_Descriptions.Jimbo.Consumables[descObj.ObjSubType][Lang] or EID_Descriptions.Jimbo.Consumables[descObj.ObjSubType]["en_us"]


        if descObj.ObjSubType == Card.CARD_FOOL then


            local CardName = mod.Saved.LastCardUsed and "{{ColorMint}}"..EID:getObjectName(5,300,mod.Saved.LastCardUsed).."{{CR}}" or "{{ColorRed}}None{{CR}}"

            BaseDesc = BaseDesc..CardName

        elseif descObj.ObjSubType == Card.CARD_MAGICIAN then
            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.LUCKY)
        elseif descObj.ObjSubType== Card.CARD_LOVERS then
            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.WILD)
        
        elseif descObj.ObjSubType== Card.CARD_DEVIL then
            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.GOLDEN)
        
        elseif descObj.ObjSubType== Card.CARD_TOWER then
            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.STONE)
        
        elseif descObj.ObjSubType== Card.CARD_EMPRESS then
            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.MULT)
        
        elseif descObj.ObjSubType== Card.CARD_HIEROPHANT then

            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.BONUS)
        elseif descObj.ObjSubType== Card.CARD_CHARIOT then

            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.STEEL)
        elseif descObj.ObjSubType== Card.CARD_JUSTICE then

            BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Enhancement", mod.Enhancement.GLASS)
        end
    end
    
    if descObj.ObjSubType== mod.Spectrals.TALISMAN then

        BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Seal", mod.Seals.GOLDEN)
    elseif descObj.ObjSubType== mod.Spectrals.DEJA_VU then

        BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Seal", mod.Seals.RED)
    elseif descObj.ObjSubType== mod.Spectrals.TRANCE then

        BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Seal", mod.Seals.BLUE)
    elseif descObj.ObjSubType== mod.Spectrals.MEDIUM then

        BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "Seal", mod.Seals.PURPLE)

    elseif descObj.ObjSubType== mod.Spectrals.ECTOPLASM then

        BaseDesc = BaseDesc..mod:GetEIDString("Jimbo", "JokerEdition", mod.Edition.NEGATIVE)
    end

    EID:appendToDescription(descObj, BaseDesc)

    return descObj
end
EID:addDescriptionModifier("Balatro Extra descriptions", BalatroExtraDescCondition, BalatroExtraDescCallback)


local function BalatroItemSynergyCondition(descObj)
    if descObj.ObjType == EntityType.ENTITY_PICKUP 
       and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
        return true
    end
end
local function BalatroTiemSynergyCallback(descObj)

    if PlayerManager.AnyoneIsPlayerType(Balatro_Expansion.Characters.JimboType) then
        
        if mod:HasEIDString("JimboSynergies", descObj.ObjSubType) then

            EID:appendToDescription(descObj, mod:GetEIDString("JimboSynergies", descObj.ObjSubType))
        end

        if mod:HasEIDString("ItemJokerSynergies", descObj.ObjSubType) then

            for Joker,_ in pairs(mod:GetEIDString("ItemJokerSynergies", descObj.ObjSubType, nil, true)) do

                if mod:GetTotalTrinketAmount(Joker) > 0 then

                    EID:appendToDescription(descObj, "#{{Trinket"..Joker.."}}"..mod:GetEIDString("ItemJokerSynergies", descObj.ObjSubType, Joker))
                end
            end
        end
    end

    if mod:HasEIDString("ItemItemSynergies", descObj.ObjSubType) then

        for Item,_ in pairs(mod:GetEIDString("ItemItemSynergies", descObj.ObjSubType, nil, true)) do

            if PlayerManager.AnyoneHasCollectible(Item) then

                EID:appendToDescription(descObj, mod:GetEIDString("ItemItemSynergies", descObj.ObjSubType, Item))
            end
        end
    end





    return descObj
end
EID:addDescriptionModifier("Balatro Item Synergies", BalatroItemSynergyCondition, BalatroTiemSynergyCallback)


local function BalatroOffsetCondition(descObj)
    --specifically player 0 cause its in the top left
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






local function TBalatroOffsetCondition(descObj)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then 
       
        if mod.Saved.DSS.T_Jimbo.CustomEID then
            EID:addTextPosModifier("TJimbo HUD", Vector(-1000,0))
        else
            EID:addTextPosModifier("TJimbo HUD", Vector(25,15))
        end
        return true
    else
        EID:removeTextPosModifier("TJimbo HUD")
    end
end

local function TBalatroOffsetCallback(descObj)
    return descObj
end

EID:addDescriptionModifier("T Balatro Descriptions Offset", TBalatroOffsetCondition, TBalatroOffsetCallback)



local EID_Bubble = Sprite("gfx/ui/Balatro_EID_desc_bubble.anm2")
local EID_BUBBLE_BASE_SIZE = Vector(16, 30)

local EID_BubbleLayers = {TOP_LEFT = 1,
                          TOP = 2,
                          TOP_RIGHT = 3,
                          CENTER_LEFT = 4,
                          CENTER = 0,
                          CENTER_RIGHT = 5,
                          BOTTOM_LEFT = 6,
                          BOTTOM = 7,
                          BOTTOM_RIGHT = 8}

---@class Balatro_EID_Object
---@field Type integer
---@field SubType integer
---@field Position Vector
---@field Params table
---@field Entity integer? --PtrHash of entity or selection index

---@type Balatro_EID_Object
local ObjectToDescribe = {Type = mod.EID_DescType.NONE,
                          SubType = 0,
                          Entity = nil,
                          Params = {},
                          Position = Vector.Zero,
                          Allignment = 0
                          }

local EID_Desc = {Name = "",
                  Description = "",
                  Extras = {Enhancement = mod.Enhancement.NONE,
                            Seal = mod.Seals.NONE,
                            Edition = mod.Edition.BASE},
                  NumLines = nil,
                  FilteredName = nil,
                  FilteredDescription = nil,
                  StartFrame = 0}


local EID_BubbleFrame = {Name = 1,
                         Description = 0}

local function ResetDescription()

    EID_Desc.NumLines = nil
    EID_Desc.FilteredName = nil
    EID_Desc.FilteredDescription = nil


    ObjectToDescribe.Entity = nil
    ObjectToDescribe.Params = {}

    ObjectToDescribe.Position = Vector.Zero

    ObjectToDescribe.Type = mod.EID_DescType.NONE
    ObjectToDescribe.SubType = 0 --not really needed

    EID:alterTextPos(Vector(-1000, -1000)) --basically erases the description form existence (prob not the best way to do that)

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ResetDescription)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ResetDescription)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ResetDescription)


--I hate myself for doing this
local function TJimboDescriptionsCondition(descObj)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then

       --and descObj.ObjVariant == mod.Effects.DESC_HELPER
       --and descObj.ObjSubType == DescriptionHelperSubType then
        return true

    else
        ResetDescription()
    end
end

local function TJimboDescriptionsCallback(descObj)

    local Result = false
    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    local PIndex 
    local PlayerSelection

    if not T_Jimbo 
       or mod.Saved.RunInfoMode ~= mod.RunInfoModes.OFF then
        --goto FINISH
        ResetDescription()
        return descObj
    end

    PIndex = T_Jimbo:GetData().TruePlayerIndex
    PlayerSelection = mod.SelectionParams[PIndex]

    --first check if the selection has something to describe
    if descObj.ObjType ~= 1000
       or descObj.ObjVariant ~= mod.Effects.DESC_HELPER
       or PlayerSelection.Mode == mod.SelectionParams.Modes.NONE then

        goto ENTITY_CHECK
    end

    if T_Jimbo:GetData().ConfirmHoldTime < mod.HOLD_THRESHOLD then --needs to hold to show text
        goto FINISH
    end

    if ObjectToDescribe.Entity == PlayerSelection.Index then --caches the previous description to save time
        
        --only updates the position and goes straight to rendering
        if PlayerSelection.Mode == mod.SelectionParams.Modes.PACK then
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -20)

        elseif PlayerSelection.Mode == mod.SelectionParams.Modes.INVENTORY then

            local Slot = mod.Saved.Player[PIndex].Inventory[PlayerSelection.Index]

            ObjectToDescribe.Position = mod.JokerFullPosition[Slot.RenderIndex] + Vector(0, 20)

        elseif PlayerSelection.Mode == mod.SelectionParams.Modes.CONSUMABLES then

            ObjectToDescribe.Position = mod.ConsumableFullPosition[PlayerSelection.Index] + Vector(0, 25)

        elseif PlayerSelection.Mode == mod.SelectionParams.Modes.HAND then

            local Pointer = mod.Saved.Player[PIndex].CurrentHand[PlayerSelection.Index]

            ObjectToDescribe.Position = mod.CardFullPoss[Pointer] + Vector(0, -20)
        end

        ObjectToDescribe.Position.Y = ObjectToDescribe.Position.Y - ObjectToDescribe.Position.Y%0.5
        ObjectToDescribe.Position.X = ObjectToDescribe.Position.X - ObjectToDescribe.Position.X%0.5
    
        --Result = true
        return descObj
    end

    ObjectToDescribe.Entity = PlayerSelection.Index

    EID_Desc.NumLines = nil
    EID_Desc.FilteredName = nil
    EID_Desc.FilteredDescription = nil
    

    if PlayerSelection.Mode == mod.SelectionParams.Modes.HAND then
        --only describable thing are the playing cards


        Result = T_Jimbo:GetData().ConfirmHoldTime >= mod.HOLD_THRESHOLD

        if Result then

            local Pointer = mod.Saved.Player[PIndex].CurrentHand[PlayerSelection.Index]

            local card = mod.Saved.Player[PIndex].FullDeck[Pointer]

            ObjectToDescribe.Allignment = EID_DescAllingnment.BOTTOM

            ObjectToDescribe.Params = card
            ObjectToDescribe.Position = mod.CardFullPoss[Pointer] + Vector(0, -20)

            ObjectToDescribe.Type = mod.EID_DescType.CARD
            ObjectToDescribe.SubType = 0 --not really needed

            goto FINISH
        end

    elseif PlayerSelection.Mode == mod.SelectionParams.Modes.CONSUMABLES then

        Result = T_Jimbo:GetData().ConfirmHoldTime >= mod.HOLD_THRESHOLD

        if Result then

            local Consumable = mod.Saved.Player[PIndex].Consumables[PlayerSelection.Index]

            ObjectToDescribe.Params = Consumable
            ObjectToDescribe.Position = mod.ConsumableFullPosition[PlayerSelection.Index] + Vector(0, 25)

            ObjectToDescribe.Allignment = EID_DescAllingnment.TOP

            ObjectToDescribe.Type = mod.EID_DescType.CONSUMABLE
            ObjectToDescribe.SubType = mod:FrameToSpecialCard(Consumable.Card)


            goto FINISH
        end

    elseif PlayerSelection.Mode == mod.SelectionParams.Modes.INVENTORY then

        Result = T_Jimbo:GetData().ConfirmHoldTime >= mod.HOLD_THRESHOLD

        if Result then

            local Slot = mod.Saved.Player[PIndex].Inventory[PlayerSelection.Index]

            ObjectToDescribe.Params = Slot
            ObjectToDescribe.Params.Index = PlayerSelection.Index
            ObjectToDescribe.Position = mod.JokerFullPosition[Slot.RenderIndex] + Vector(0, 20)

            ObjectToDescribe.Allignment = EID_DescAllingnment.TOP

            ObjectToDescribe.Type = mod.EID_DescType.JOKER
            ObjectToDescribe.SubType = Slot.Joker


            goto FINISH
        end

    elseif PlayerSelection.Mode == mod.SelectionParams.Modes.PACK then

        Result = true
        ObjectToDescribe.Allignment = EID_DescAllingnment.BOTTOM

        local PackPurpose = PlayerSelection.PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag

        if PackPurpose == mod.SelectionParams.Purposes.BuffonPack then

            local Slot = PlayerSelection.PackOptions[PlayerSelection.Index]

            ObjectToDescribe.Params = Slot
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -30)

            ObjectToDescribe.Type = mod.EID_DescType.JOKER
            ObjectToDescribe.SubType = Slot.Joker
        
        elseif PackPurpose == mod.SelectionParams.Purposes.StandardPack then


            local card = PlayerSelection.PackOptions[PlayerSelection.Index]

            ObjectToDescribe.Params = card
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -20)

            ObjectToDescribe.Type = mod.EID_DescType.CARD
            ObjectToDescribe.SubType = 0 --not really needed
        
        else
            local Consumable = PlayerSelection.PackOptions[PlayerSelection.Index]

            ObjectToDescribe.Params = {Edition = mod.Edition.BASE}
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -30)

            ObjectToDescribe.Type = mod.EID_DescType.CONSUMABLE
            ObjectToDescribe.SubType = mod:FrameToSpecialCard(Consumable)
        end

        goto FINISH
    end


    if Result then
        
        ObjectToDescribe.Type = ObjectToDescribe.Type | mod.EID_DescType.SELECTION_FLAG

        ObjectToDescribe.Position.Y = ObjectToDescribe.Position.Y - ObjectToDescribe.Position.Y%0.5
        ObjectToDescribe.Position.X = ObjectToDescribe.Position.X - ObjectToDescribe.Position.X%0.5

        EID_Desc.StartFrame = Isaac.GetFrameCount()

        return descObj
    else
        return descObj
    end


    ::ENTITY_CHECK::


    if descObj.ObjType == 1000 
       and descObj.ObjVariant == mod.Effects.DESC_HELPER 
       and descObj.ObjSubType == mod.Effects.PLATE_HELPER_SUBTYPE then


        if ObjectToDescribe.Entity == GetPtrHash(descObj.Entity) then --caches the previous variables to save time
        
            Result = true
            return descObj
        end

        ---@type GridEntityDesc
        local Desc = descObj.Entity:GetData().GridEntityDesc

        if (Desc.Variant ~= mod.Grids.PlateVariant.SMALL_BLIND_SKIP
           and Desc.Variant ~= mod.Grids.PlateVariant.BIG_BLIND_SKIP
           and Desc.Variant ~= mod.Grids.PlateVariant.BOSS_BLIND_SKIP)
           or not Desc.Initialized then

            Result = false
            goto FINISH
        end

        Result = true
        ObjectToDescribe.Entity = GetPtrHash(descObj.Entity)

        EID_Desc.NumLines = nil
        EID_Desc.FilteredName = nil
        EID_Desc.FilteredDescription = nil

        --local PlateVariant = descObj.ObjVariant
        local VarData = Desc.VarData

        ObjectToDescribe.Params = {}

        ObjectToDescribe.Type = mod.EID_DescType.PLATE
        ObjectToDescribe.SubType = VarData

        ObjectToDescribe.Allignment = EID_DescAllingnment.TOP

        ObjectToDescribe.Position = mod:HUDWorldToScreen(descObj.Entity.Position) + Vector(0, 13)


    elseif descObj.ObjType == EntityType.ENTITY_PICKUP then

        if ObjectToDescribe.Entity == GetPtrHash(descObj.Entity) then --caches the previous variables to save time
        
            local Histeresys = 15
        
            local RenderLeft


            if ObjectToDescribe.Allignment & EID_DescAllingnment.RIGHT ~= 0 then

                RenderLeft = T_Jimbo.Position.X > descObj.Entity.Position.X - Histeresys
            else --if ObjectToDescribe.Allignment & EID_DescAllingnment.LEFT ~= 0 then

                RenderLeft = T_Jimbo.Position.X > descObj.Entity.Position.X + Histeresys
            end


            local LateralOffset

            if RenderLeft then
                
                ObjectToDescribe.Allignment = EID_DescAllingnment.RIGHT
                LateralOffset = Vector(-12, 0)
            else
                ObjectToDescribe.Allignment = EID_DescAllingnment.LEFT
                LateralOffset = Vector(12, 0)
            end

            ObjectToDescribe.Position = mod:HUDWorldToScreen(descObj.Entity.Position) + LateralOffset
        
            Result = true
            return descObj
        end


        EID_Desc.StartFrame = Isaac.GetFrameCount()

        ObjectToDescribe.Entity = GetPtrHash(descObj.Entity)

        EID_Desc.NumLines = nil
        EID_Desc.FilteredName = nil
        EID_Desc.FilteredDescription = nil


        --ObjectToDescribe.Allignment = EID_DescAllingnment.TOP | EID_DescAllingnment.LEFT

        if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then

            if ItemsConfig:GetCollectible(descObj.ObjSubType):HasCustomTag("balatro") then

                ObjectToDescribe.Params = {}


                ObjectToDescribe.Type = mod.EID_DescType.VOUCHER
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true 
            end

        elseif descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD then

            if descObj.ObjSubType <= Card.CARD_WORLD 
               or descObj.ObjSubType >= mod.Planets.PLUTO and descObj.ObjSubType <= mod.Spectrals.SOUL then
                
                ObjectToDescribe.Params = {Edition = mod.Edition.BASE}

                --[[
                if ObjectToDescribe.Entity then

                    ObjectToDescribe.Position = Isaac.WorldToScreen(ObjectToDescribe.Entity.Position)

                    if ObjectToDescribe.Position.Y >= Isaac.GetScreenHeight()/2 then
                        
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, -30)
                    else
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, 30)
                    end
                else
                    ObjectToDescribe.Position = Isaac.WorldToScreen(T_Jimbo.Position)

                    if ObjectToDescribe.Position.Y >= Isaac.GetScreenHeight()/2 then
                        
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, -45)
                    else
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, 30)
                    end
                end]]

                ObjectToDescribe.Type = mod.EID_DescType.CONSUMABLE
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true

            elseif descObj.ObjSubType >= mod.Packs.ARCANA and descObj.ObjSubType <= mod.Packs.MEGA_SPECTRAL then
                
                ObjectToDescribe.Params = {}

                ObjectToDescribe.Position = EID:getTextPosition()

                --[[
                if ObjectToDescribe.Entity then

                    ObjectToDescribe.Position = Isaac.WorldToScreen(ObjectToDescribe.Entity.Position)

                    if ObjectToDescribe.Position.Y >= Isaac.GetScreenHeight()/2 then
                        
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, -30)
                    else
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, 30)
                    end
                else
                    ObjectToDescribe.Position = Isaac.WorldToScreen(T_Jimbo.Position)

                    if ObjectToDescribe.Position.Y >= Isaac.GetScreenHeight()/2 then
                        
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, -45)
                    else
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, 30)
                    end
                end]]

                ObjectToDescribe.Type = mod.EID_DescType.BOOSTER
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true
            end

        elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then

            local JokerConfig = ItemsConfig:GetTrinket(descObj.ObjSubType & ~mod.EditionFlag.ALL)

            if JokerConfig:HasCustomTag("balatro") then

                ObjectToDescribe.Params = {Joker = descObj.ObjSubType & ~mod.EditionFlag.ALL,
                                           Edition = (descObj.ObjSubType & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT,
                                           Modifiers = 0}
                
                --[[
                if ObjectToDescribe.Entity then

                    ObjectToDescribe.Position = Isaac.WorldToScreen(ObjectToDescribe.Entity.Position)

                    if ObjectToDescribe.Position.Y >= Isaac.GetScreenHeight()/2 then
                        
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, -30)
                    else
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, 30)
                    end
                else
                    ObjectToDescribe.Position = Isaac.WorldToScreen(T_Jimbo.Position)

                    if ObjectToDescribe.Position.Y >= Isaac.GetScreenHeight()/2 then
                        
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, -45)
                    else
                        ObjectToDescribe.Position = ObjectToDescribe.Position + Vector(0, 30)
                    end
                end]]

                ObjectToDescribe.Type = mod.EID_DescType.JOKER
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true
            else
                print("not balatrational")
            end


        elseif descObj.ObjVariant == mod.Pickups.PLAYING_CARD then

            local card = mod:PlayingCardSubTypeToParams(descObj.ObjSubType)

            ObjectToDescribe.Params = card
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -20)

            ObjectToDescribe.Type = mod.EID_DescType.CARD
            ObjectToDescribe.SubType = 0 --not really needed
        end

        if Result then

            local RenderLeft = T_Jimbo.Position.X > descObj.Entity.Position.X

            local LateralOffset

            if RenderLeft then
                
                ObjectToDescribe.Allignment = EID_DescAllingnment.RIGHT
                LateralOffset = Vector(-12, 0)
            else
                ObjectToDescribe.Allignment = EID_DescAllingnment.LEFT
                LateralOffset = Vector(12, 0)
            end

            ObjectToDescribe.Position = mod:HUDWorldToScreen(descObj.Entity.Position) + LateralOffset
        end
    end



    ::FINISH::

    --save the object's description and name
    if ObjectToDescribe.Type & mod.EID_DescType.CARD ~= 0 then

        EID_Bubble:SetFrame("Card", 0)

        local card = ObjectToDescribe.Params

        if card.Modifiers & mod.Modifier.DEBUFFED ~= 0 then
            
            EID_Desc.Name = mod:GetCardName(card, true)

            EID_Desc.Description = mod:GetEIDString("T_Jimbo","Debuffed")

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = mod.Edition.BASE
            EID_Desc.Extras.Seal = mod.Seals.NONE

        elseif card.Modifiers & mod.Modifier.COVERED ~= 0 then
            
            EID_Desc.Name = "???"

            EID_Desc.Description = "?????"

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = mod.Edition.BASE
            EID_Desc.Extras.Seal = mod.Seals.NONE
        else

            EID_Desc.Name = mod:GetCardName(card, true)


            local TriggerDesc = ""

            if card.Enhancement ~= mod.Enhancement.STONE then
            
                TriggerDesc = TriggerDesc.."{{ColorChips}}+"..tostring(mod:GetValueScoring(card.Value) + 5*card.Upgrades).."{{B_Black}}Chips"
            end

            --hiker upgrades
            --if card.Upgrades > 0 then
            --    TriggerDesc = TriggerDesc.."#{{ColorChips}}+"..tostring(5*card.Upgrades).."{{B_Black}} Extra Chips"
            --end

            TriggerDesc = TriggerDesc..mod:GetEIDString("T_Jimbo","Enhancement",card.Enhancement)

            if card.Edition == mod.Edition.NEGATIVE then
                
                TriggerDesc = TriggerDesc..mod:GetEIDString("T_Jimbo","CardNEGATIVE")
            else
                TriggerDesc = TriggerDesc..mod:GetEIDString("T_Jimbo","Edition",card.Edition)
            end

            TriggerDesc = TriggerDesc..mod:GetEIDString("T_Jimbo","Seal",card.Seal)


            EID_Desc.Description = TriggerDesc

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = card.Edition
            EID_Desc.Extras.Seal = card.Seal
        end

    elseif ObjectToDescribe.Type & mod.EID_DescType.JOKER ~= 0 then

        local Slot = ObjectToDescribe.Params

        if Slot.Modifiers & mod.Modifier.DEBUFFED ~= 0 then

            local Config = ItemsConfig:GetTrinket(ObjectToDescribe.SubType)

            EID_Desc.Name = Config.Name
            
            EID_Desc.Description = mod:GetEIDString("T_Jimbo","Debuffed")

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = mod.Edition.BASE
            EID_Desc.Extras.Seal = mod.Seals.NONE

        elseif Slot.Modifiers & mod.Modifier.COVERED ~= 0 then
            
            EID_Desc.Name = "???"

            EID_Desc.Description = "?????"

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = mod.Edition.BASE
            EID_Desc.Extras.Seal = mod.Seals.NONE
        else

            local Config = ItemsConfig:GetTrinket(ObjectToDescribe.Params.Joker)

            EID_Desc.Name = Config.Name



            EID_Desc.Description = mod:GetEIDString("T_Jimbo","Jokers", ObjectToDescribe.Params.Joker)..mod:GetEIDString("T_Jimbo","Edition", Slot.Edition)

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
            EID_Desc.Extras.Seal = mod.Seals.NONE
        end

    elseif ObjectToDescribe.Type & mod.EID_DescType.CONSUMABLE ~= 0 then

        if mod:HasEIDString("ConsumablesName", ObjectToDescribe.SubType) then
            
            EID_Desc.Name = mod:GetEIDString("ConsumablesName", ObjectToDescribe.SubType)

        else
            local Config = ItemsConfig:GetCard(ObjectToDescribe.SubType)

            EID_Desc.Name = Config.Name
        end

        EID_Desc.Description = mod:GetEIDString("T_Jimbo","Consumables",ObjectToDescribe.SubType)

        EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
        EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
        EID_Desc.Extras.Seal = mod.Seals.NONE

    elseif ObjectToDescribe.Type & mod.EID_DescType.VOUCHER ~= 0 then

        local Config = ItemsConfig:GetCollectible(ObjectToDescribe.SubType)

        EID_Desc.Name = Config.Name

        EID_Desc.Description = mod:GetEIDString("T_Jimbo","Vouchers",ObjectToDescribe.SubType)

        EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
        EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
        EID_Desc.Extras.Seal = mod.Seals.NONE

    elseif ObjectToDescribe.Type & mod.EID_DescType.BOOSTER ~= 0 then

        local Config = ItemsConfig:GetCard(ObjectToDescribe.SubType)

        EID_Desc.Name = Config.Name

        EID_Desc.Description = mod:GetEIDString("T_Jimbo", "Boosters", ObjectToDescribe.SubType)

        EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
        EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
        EID_Desc.Extras.Seal = mod.Seals.NONE


    elseif ObjectToDescribe.Type & mod.EID_DescType.PLATE ~= 0 then


        EID_Desc.Name = mod:GetEIDString("T_Jimbo", "SkipName", ObjectToDescribe.SubType)

        EID_Desc.Description = mod:GetEIDString("T_Jimbo", "SkipTag", ObjectToDescribe.SubType)

    end

    EID_Desc.Name = mod:ReplaceBalatroMarkups(EID_Desc.Name, mod.EID_DescType.NONE, 0, true, PlayerSelection.Index)
    EID_Desc.Description = mod:ReplaceBalatroMarkups(EID_Desc.Description, ObjectToDescribe.Type, ObjectToDescribe.SubType, true, PlayerSelection.Index)

    ObjectToDescribe.Position.Y = ObjectToDescribe.Position.Y - ObjectToDescribe.Position.Y%0.5
    ObjectToDescribe.Position.X = ObjectToDescribe.Position.X - ObjectToDescribe.Position.X%0.5

    EID_Desc.StartFrame = Isaac.GetFrameCount()

    if not mod.Saved.DSS.T_Jimbo.CustomEID then
        descObj.Name = EID_Desc.Name
        descObj.Description = EID_Desc.Description

        Result = false
    end


    if not Result then
        ResetDescription()
    end
    
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Tainted Jimbo Special descripions", TJimboDescriptionsCondition, TJimboDescriptionsCallback)


function mod:RenderObjectDescription()

    if ObjectToDescribe.Type == mod.EID_DescType.NONE then

        --resets the cached values
        EID_Desc.NumLines = nil 
        EID_Desc.FilteredName = nil 
        EID_Desc.FilteredDescription = nil

        return
    end

    EID_Bubble:SetFrame("Any", 0)

    
    if ObjectToDescribe.Type & mod.EID_DescType.CARD ~= 0 then

        EID_Bubble:SetFrame("Card", 0)
    end

    


    if not EID_Desc.FilteredName then
        EID_Desc.FilteredName = mod:GetFilteredEIDString(EID_Desc.Name)
    end

    if not EID_Desc.FilteredDescription then
        EID_Desc.FilteredDescription = mod:GetFilteredEIDString(EID_Desc.Description)
    end



    local BubbleScale = Vector.One

    BubbleScale.X = mod.Fonts.Balatro:GetStringWidth(EID_Desc.FilteredName) + 24

    if ObjectToDescribe.Type & mod.EID_DescType.CARD ~= 0 then

        BubbleScale.X = BubbleScale.X / 2
    end

    BubbleScale.X = math.max(BubbleScale.X, string.len(EID_Desc.Description) // 2)

    local BoxWidth = BubbleScale.X + 0

    if not EID_Desc.NumLines then
        
        local Params = mod.StringRenderingParams.EID
        
        EID_Desc.NumLines = mod:RenderBalatroStyle(EID_Desc.Description, Vector(-1000,-1000), Params, 0, Vector.One/2, mod.BalatroKColorBlack, BoxWidth)
    end

    local LineHeight = mod.Fonts.Balatro:GetLineHeight()
    local _,NumLineForced = string.gsub(EID_Desc.Description, "#", "#")

    BubbleScale.Y = math.ceil(((EID_Desc.NumLines-NumLineForced-1)*LineHeight + NumLineForced*LineHeight*1.5)/2 + 10)

    BubbleScale = BubbleScale/10

    local RenderPos = ObjectToDescribe.Position + Vector.Zero
    
    
    if ObjectToDescribe.Allignment & EID_DescAllingnment.BOTTOM ~= 0 then

        local Offset = BubbleScale.Y*5 + EID_BUBBLE_BASE_SIZE.Y/2
        
        RenderPos.Y = ObjectToDescribe.Position.Y - Offset

    end
    if ObjectToDescribe.Allignment & EID_DescAllingnment.TOP ~= 0 then

        local Offset = BubbleScale.Y*5 + EID_BUBBLE_BASE_SIZE.Y/2
        
        RenderPos.Y = ObjectToDescribe.Position.Y + Offset
    end
    if ObjectToDescribe.Allignment & EID_DescAllingnment.RIGHT ~= 0 then

        local Offset = BubbleScale.X*5 + EID_BUBBLE_BASE_SIZE.X/2
        
        RenderPos.X = ObjectToDescribe.Position.X - Offset
    end
    if ObjectToDescribe.Allignment & EID_DescAllingnment.LEFT ~= 0 then
        
        local Offset = BubbleScale.X*5 + EID_BUBBLE_BASE_SIZE.X/2

        RenderPos.X = ObjectToDescribe.Position.X + Offset
    end

    --prevent the bubble form going off screen
    local TL_Border = BubbleScale*5 + EID_BUBBLE_BASE_SIZE/2
    local BR_Border = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) - (BubbleScale*5 + EID_BUBBLE_BASE_SIZE/2)

    RenderPos:Clamp(TL_Border.X, TL_Border.Y, BR_Border.X, BR_Border.Y)





    local Y_BorderOffset = Vector(0,BubbleScale.Y*5)
    local X_BorderOffset = Vector(BubbleScale.X*5,0)

    EID_Bubble.Scale = BubbleScale
    RenderPos = RenderPos

    EID_Bubble:SetFrame(0)

    EID_Bubble:RenderLayer(EID_BubbleLayers.CENTER, RenderPos)

    do
    EID_Bubble.Scale.X = 1

    EID_Bubble:RenderLayer(EID_BubbleLayers.CENTER_LEFT, RenderPos - X_BorderOffset)
    EID_Bubble:RenderLayer(EID_BubbleLayers.CENTER_RIGHT, RenderPos + X_BorderOffset)


    EID_Bubble.Scale.X = BubbleScale.X
    EID_Bubble.Scale.Y = 1

    EID_Bubble:RenderLayer(EID_BubbleLayers.TOP, RenderPos - Y_BorderOffset)
    EID_Bubble:RenderLayer(EID_BubbleLayers.BOTTOM, RenderPos + Y_BorderOffset)


    EID_Bubble.Scale = Vector.One

    EID_Bubble:RenderLayer(EID_BubbleLayers.TOP_LEFT, RenderPos - Y_BorderOffset - X_BorderOffset)
    EID_Bubble:RenderLayer(EID_BubbleLayers.TOP_RIGHT, RenderPos - Y_BorderOffset + X_BorderOffset)
    
    EID_Bubble:RenderLayer(EID_BubbleLayers.BOTTOM_LEFT, RenderPos + Y_BorderOffset - X_BorderOffset)
    EID_Bubble:RenderLayer(EID_BubbleLayers.BOTTOM_RIGHT, RenderPos + Y_BorderOffset + X_BorderOffset)
    end

    EID_Bubble:SetFrame(EID_BubbleFrame.Name)

    local NullFrame = EID_Bubble:GetNullFrame("String Position")

    local NameScale = Vector.One * NullFrame:GetScale().Y*100
    local NamePos = NullFrame:GetPos() + RenderPos - Y_BorderOffset

    local Params = mod.StringRenderingParams.EID | mod.StringRenderingParams.Centered
    local Kcolor 

    if ObjectToDescribe.Type & mod.EID_DescType.CARD == 0 then

        Kcolor = KColor.White
        
        Params = Params | mod.StringRenderingParams.Swoosh
    else
        Kcolor = mod.BalatroKColorBlack
    end

    mod:RenderBalatroStyle(EID_Desc.Name, NamePos, Params, EID_Desc.StartFrame, NameScale, Kcolor, BoxWidth)




    EID_Bubble:SetFrame(EID_BubbleFrame.Description)

    NullFrame = EID_Bubble:GetNullFrame("String Position")

    local DescScale = Vector.One * NullFrame:GetScale().Y*100

    local DescPos = RenderPos + NullFrame:GetPos()
    DescPos.Y = DescPos.Y - BubbleScale.Y*5

    EID_Desc.NumLines = mod:RenderBalatroStyle(EID_Desc.Description, DescPos, Params, 0, DescScale, mod.BalatroKColorBlack, BoxWidth)

end
--mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.RenderObjectDescription)

else --END EID EXCLUSIVE

--empty function so I don't have to put an extra if in a render callback

function mod:RenderObjectDescription()
end

end 




