local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
--local TrinketSprite = Sprite("gfx/005.350_custom.anm2")

local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..

local EID_DescType = {NONE = 0,
                      CARD = 1,
                      JOKER = 2,
                      CONSUMABLE = 4,
                      BOOSTER = 8,
                      VOUCHER = 16,
                      SELECTION_FLAG = 256}

local EID_DescAllingnment = {TOP = 1,
                             BOTTOM = 2,
                             LEFT = 4,
                             RIGHT = 8,
                             CENTER = 0}


local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")
EID:addEntity(1000, DescriptionHelperVariant, DescriptionHelperSubType, "", "")


mod.Descriptions = {}

mod.EIDSupportedLanguages = {"en_us"}


for _, LanguageCode in ipairs(mod.EIDSupportedLanguages) do

    local LangDescriptions = include("Balatro_scripts.Compatibility.EID translations."..LanguageCode)


    for Type, v in pairs(LangDescriptions) do

        mod.Descriptions[Type] = mod.Descriptions[Type] or {}
        
        for Variant ,Description in pairs(v) do

            mod.Descriptions[Type][Variant] = mod.Descriptions[Type][Variant] or {}
        
            if type(Description) == "table" then

                for SubType, String in pairs(Description) do

                    mod.Descriptions[Type][Variant][SubType] = mod.Descriptions[Type][Variant][SubType] or {}

                    mod.Descriptions[Type][Variant][SubType][LanguageCode] = String
                end

            else

                mod.Descriptions[Type][Variant][LanguageCode] = Description
            end
        end
    end
end


---@diagnostic disable: need-check-nil
if not EID then
    return
end



do
    local CoopMenu = Sprite("gfx/sprites/EID Icons.anm2")

    EID:addIcon("PlayerJimbo","Jimbo",0,16,16,-7,-6, CoopMenu)
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


function mod:GetEIDString(Type, Variant, SubType)

    local Lang = mod:GetEIDLanguage()

    if SubType then
        return mod.Descriptions[Type][Variant][SubType][Lang] or mod.Descriptions[Type][Variant][SubType]["en_us"]
    else
        return mod.Descriptions[Type][Variant][Lang] or mod.Descriptions[Type][Variant]["en_us"]
    end
end


---@return table ([[VALUE"X"]] = string)
local function GetT_JimboDescriptionValues(Type, Subtype, Index)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    local PIndex = T_Jimbo:GetData().TruePlayerIndex

    Values = {}

    if Type == EID_DescType.JOKER then

        local Progress
        if Index then
            Progress = mod.Saved.Player[PIndex].Progress.Inventory[Index]
        end

        local Joker = Subtype

        local JokerConfig = ItemsConfig:GetTrinket(Joker)

        if JokerConfig:HasCustomTag("chips") then

            if Joker == mod.Jokers.CASTLE then

                Values[1] = mod:CardSuitToName(mod:GetJokerInitialProgress(Joker, true), true)
            
                if Progress then

                    Values[2] = (Progress & ~SUIT_FLAG)/SUIT_FLAG + 1 --chips accumulated
                end

            elseif Joker == mod.Jokers.BLUE_JOKER then

            Values[1] = 2*(#mod.Saved.Player[PIndex].FullDeck - mod.Saved.Player[PIndex].DeckPointer + 1)

            elseif Joker == mod.Jokers.BULL then

            Values[1] = (T_Jimbo:GetNumCoins()*2)


            elseif Joker == mod.Jokers.STONE_JOKER
                   or Joker == mod.Jokers.ICECREAM
                   or Joker == mod.Jokers.RUNNER
                   or Joker == mod.Jokers.SQUARE_JOKER
                   or Joker == mod.Jokers.WEE_JOKER then

                if Progress then
                    Values[1] = tostring(Progress) --chips accumulated
                end
            end

        elseif JokerConfig:HasCustomTag("mult") then

            if Joker == mod.Jokers.ABSTRACT_JOKER 
               or Joker == mod.Jokers.RED_CARD
               or Joker == mod.Jokers.FORTUNETELLER
               or Joker == mod.Jokers.SACRIFICIAL_DAGGER
               or Joker == mod.Jokers.FLASH_CARD
               or Joker == mod.Jokers.SWASHBUCKLER
               or Joker == mod.Jokers.RIDE_BUS
               or Joker == mod.Jokers.SPARE_TROUSERS then

                Values[1] = tostring(Progress)

            elseif Joker == mod.Jokers.BOOTSTRAP then
            
               Values[1] = (T_Jimbo:GetNumCoins()//5) * 2
            end

        elseif JokerConfig:HasCustomTag("multm") then

            if Joker == mod.Jokers.ANCIENT_JOKER then

                Values[1] = mod:CardSuitToName(mod:GetJokerInitialProgress(Joker, true),true)
            
            elseif Joker == mod.Jokers.IDOL then
            Values[1] = mod:GetCardName(mod:GetJokerInitialProgress(Joker, true), true)
        
            elseif Joker == mod.Jokers.YORICK then

                if Progress then
                    Values[1] = tostring(23 - (Progress % 23))
                end
            elseif Joker == mod.Jokers.JOKER_STENCIL
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
                   or Joker == mod.Jokers.DRIVER_LICENSE then

                if Progress then
                    Values[1] = tostring(Progress)
                end
            end


        elseif JokerConfig:HasCustomTag("money") then

            if Joker == mod.Jokers.TO_DO_LIST then

                local Value = mod:GetJokerInitialProgress(T_Jimbo, Joker)

                local Hand = mod:GetEIDString("HandTypeName", Value)

                Values[1] = Hand

            elseif Joker == mod.Jokers.SATELLITE then

                local Value = Progress

                local Money = 0

                for i=1, mod.HandTypes.FIVE_FLUSH do

                    if Value & 2^i ~= 0 then
                        Money = Money + 1
                    end
                end
                
                Values[1] = tostring(Money)
        
            elseif Joker == mod.Jokers.MAIL_REBATE then

            local Value = mod:GetJokerInitialProgress(T_Jimbo, Joker)

            Values[1] = mod:CardValueToName(Value, true)
            end
        elseif JokerConfig:HasCustomTag("activate") then

            if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            if Progress ~= 0 then
                Values[1] = mod:GetEIDString("Other", "Compatible")
            else
                Values[1] = mod:GetEIDString("Other", "Incompatible")
            end

            elseif Joker == mod.Jokers.INVISIBLE_JOKER then

                if Progress then
                    if Progress == 2 then
                        Values[1] = mod:GetEIDString("Other", "Ready")
                    else
                        Values[1] = "{{ColorYellorange}}"..tostring(Progress).."/2{{ColorGray}}"..mod:GetEIDString("Other", "Rounds")
                    end
                end

                for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                    if Slot.Edition == mod.Edition.NEGATIVE then
                        Values[2] = "#{{ColorGray}}("..mod:GetEIDString("Other","RemovesNeg")..")"
                        break
                    end
                end

            elseif Joker == mod.Jokers.DNA then

            if mod.Saved.HandsRemaining == T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM) - 1 then
                Values[1] = mod:GetEIDString("Other", "Ready")
            else
                Values[1] = mod:GetEIDString("Other", "NotReady")
            end

            elseif Joker == mod.Jokers.SIXTH_SENSE then

            if mod.Saved.HandsRemaining == T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM) - 1 then
                Values[1] = mod:GetEIDString("Other", "Ready")
            else
                Values[1] = mod:GetEIDString("Other", "NotReady")
            end

            elseif Joker == mod.Jokers.TURTLE_BEAN then

            if Progress then
                Values[1] = tostring(Progress)
            else
                Values[1] = mod:GetJokerInitialProgress(Joker, true)
            end
            
            elseif Joker == mod.Jokers.SELTZER then

            if Progress then
                Values[1] = tostring(Progress)
            else
                Values[1] = mod:GetJokerInitialProgress(Joker, true)
            end
            end
        end


    elseif Type == EID_DescType.CONSUMABLE then

        local card = Subtype
        
        if card == mod.Spectrals.ECTOPLASM then
            
            Values[1] = tostring(mod.Saved.Player[PIndex].EctoUses + 1)

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

        Values["[[VALUE"..tostring(i).."]]"] = v
    end

    return Values
end



---@param String string
---@param DescType integer
---@param DescSubType integer
---@param Index integer?
function mod:ReplaceBalatroMarkups(String, DescType, DescSubType, Index)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)


    String = string.gsub(String, "[[CHANCE]]", function ()
        
        local NumDice = #mod:GetJimboJokerIndex(T_Jimbo, mod.Jokers.OOPS_6)

        return tostring(2^NumDice) --usually chance based things are 1/X chance so no problem in doing this
    end)


    if DescType & EID_DescType.JOKER ~= 0
       and DescType & EID_DescType.SELECTION_FLAG == 0 then

        local s = string.find(String, "#{{ColorGray}}", 1, true)
        
        String = string.sub(String, 1, s)
    end

    local Values = GetT_JimboDescriptionValues(DescType & ~EID_DescType.SELECTION_FLAG, DescSubType, Index)

    String = string.gsub(String, "[[VALUE%d]]", Values)
end





local function GetProgressString(Joker, Value, Player)

    local JokerConfig = ItemsConfig:GetTrinket(Joker)

    local Lang = mod:GetEIDLanguage()

    Player = Player or PlayerManager.FirstPlayerByType(mod.Characters.JimboType)

    local PIndex = Player:GetData().TruePlayerIndex

    local String = ""

    if JokerConfig:HasCustomTag("chips") then

        if Joker == mod.Jokers.WALKIE_TALKIE then

            String = " #!!! "..mod.Descriptions.Other.CompatibleTriggered[Lang]..tostring(Value)
        
        elseif Joker == mod.Jokers.CASTLE then

            String = "#!!!"..mod.Descriptions.Other.SuitChosen[Lang]..mod:CardSuitToName(Value & SUIT_FLAG, true).."#!!! "..mod.Descriptions[Lang].Other.CompatibleDiscarded.." {{ColorChips}} "..tostring((Value & ~SUIT_FLAG)/8)
        else
            String = " #!!! "..mod.Descriptions.Other.Currently[Lang].."{{ColorChips}} +"..tostring(Value).."{{CR}}"
        end
    elseif JokerConfig:HasCustomTag("mult") then
        String = " #!!! "..mod.Descriptions.Other.Currently[Lang].."{{ColorMult}} +"..tostring(Value).."{{CR}}"

    elseif JokerConfig:HasCustomTag("multm") then

        if Joker == mod.Jokers.LOYALTY_CARD then
            if Value == 0 then
                String = " #!!! "..mod.Descriptions.Other.Active[Lang]
            else
                String = " #!!! "..mod.Descriptions.Other.RoomsRemaining[Lang].."{{ColorYellorange}} "..tostring(Value).."{{CR}}"
            end

        elseif Joker == mod.Jokers.ANCIENT_JOKER then
            
            String = " #!!! "..mod.Descriptions.Other.SuitChosen[Lang]..mod:CardSuitToName(Value & SUIT_FLAG).."{{CR}}".."#!!! "..mod.Descriptions.Other.CompatibleTriggered[Lang]..tostring((Value & ~SUIT_FLAG)/8)
        
        elseif Joker == mod.Jokers.IDOL then
            String = " #!!! "..mod.Descriptions.Other.CardChosen[Lang]..mod:CardValueToName((Value & VALUE_FLAG)/8, true).." of "..mod:CardSuitToName(Value & SUIT_FLAG, true).."#!!! "..mod.Descriptions.Other.CompatibleTriggered[Lang]..tostring((Value & ~(SUIT_FLAG|VALUE_FLAG))/128)
        
        elseif Joker == mod.Jokers.YORICK then

            String = " #!!! "..mod.Descriptions.Other.Currently[Lang].."{{ColorMult}} X"..tostring((1+(Value//23))*0.25).."{{CR}}#!!! "..mod.Descriptions.Other.DiscardsRemaining[Lang]..tostring(23-(Value%23))
        else
            String = " #!!! "..mod.Descriptions.Other.Currently[Lang].."{{ColorMult}} X"..tostring(Value).."{{CR}}"
        end


    elseif JokerConfig:HasCustomTag("money") then
        
        if Joker == mod.Jokers.TO_DO_LIST then

            local Hand = mod.Descriptions.HandTypeName[Value][Lang] or mod.Descriptions.HandTypeName[Value]["en_us"]

            String = " #!!! "..mod.Descriptions.Other.HandTypeChosen[Lang].."{{ColorYellorange}} "..Hand.."{{CR}}"
        
        elseif Joker == mod.Jokers.MAIL_REBATE then

            String = " #!!! "..mod.Descriptions.Other.ValueChosen[Lang].."{{ColorYellorange}} "..mod:CardValueToName(Value).."{{CR}}"
        
        else
            --String = " #!!! "..mod.Descriptions.Other.Currently[Lang].."{{ColorYellorange}} "..tostring(Value).."${{CR}}"
        end
    elseif JokerConfig:HasCustomTag("activate") then

        if Joker == mod.Jokers.BLUEPRINT or Joker == mod.Jokers.BRAINSTORM then

            if Value ~= 0 then
                String = " #!!! "..mod.Descriptions.Other.Currently[Lang]..mod.Descriptions.Other.Compatible[Lang]
            else
                String = " #!!! "..mod.Descriptions.Other.Currently[Lang]..mod.Descriptions.Other.Incompatible[Lang]
            end

        elseif Joker == mod.Jokers.INVISIBLE_JOKER then

            if Value == 3 then
                String = " #!!! "..mod.Descriptions.Other.Ready[Lang]
            else
                String = " #!!! "..mod.Descriptions.Other.BlindsCleared[Lang].."{{ColorYellorange}}"..tostring(Value).."/3{{CR}}"
            end

        elseif Joker == mod.Jokers.DNA then
            if Balatro_Expansion.Saved.Player[PIndex].Progress.Blind.Shots == 0 then
                String = " #!!! "..mod.Descriptions.Other.Ready[Lang]

            else
                String = " #!!! "..mod.Descriptions.Other.NotReady[Lang]

            end

        elseif Joker == mod.Jokers.SIXTH_SENSE then
            if Balatro_Expansion.Saved.Player[PIndex].Progress.Blind.Shots == 0 then
                Description = Description.." #!!! "..mod.Descriptions.Other.Currently[Lang]..mod.Descriptions.Other.Ready[Lang]

            else
                String = " #!!! "..mod.Descriptions.Other.Currently[Lang]..mod.Descriptions.Other.NotReady[Lang]

            end
        elseif Joker == mod.Jokers.TURTLE_BEAN then

            String = " #!!! "..mod.Descriptions.Other.Currently[Lang].." {{ColorCyan}}+"..tostring(Value).." "..mod.Descriptions.Other.HandSize[Lang].."{{CR}}"
        elseif Joker == mod.Jokers.SELTZER then

            String = " #!!! "..mod.Descriptions.Other.RoomsRemaining[Lang]..tostring(Value)
        end
    end

    return String

end






--uses a hacky entity to simulate the options being described, no idea if this is an optimal way or not
local function BalatroInventoryCondition(descObj)

    if descObj.ObjType == EntityType.ENTITY_EFFECT and descObj.ObjVariant == DescriptionHelperVariant and descObj.ObjSubType == DescriptionHelperSubType then
        if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
            return true
        end
    end
end

local function BalatroInventoryCallback(descObj)


    local Lang = mod:GetEIDLanguage()


    descObj.Name = mod.Descriptions.Other.Name[Lang] --PLACEHOLDER


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


        if Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.INVENTORY then

            SelectedCard = Balatro_Expansion.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index]

            if not SelectedCard then --the extra confirm button

                if Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.SELLING then

                    for i,selected in ipairs(mod.SelectionParams[PIndex].SelectedCards) do
                        if selected then
                            SelectedCard = mod.Saved.Player[PIndex].Inventory[i].Joker
                            SelectedSlots = i
                            break
                        end
                    end

                    local CardIcon = EID:createItemIconObject("Trinket"..tostring(SelectedCard))

                    EID:addIcon("CurrentCard", CardIcon[1], CardIcon[2], CardIcon[3], CardIcon[4], CardIcon[5], CardIcon[6], CardIcon[7])

                    Icon = "{{Shop}}"
                    Name = mod.Descriptions.Other.SellJoker[Lang]
                    Description = "#{{CurrentCard}} "..mod.Descriptions.Other.SellsFor[Lang].." {{ColorYellow}}"..mod:GetJokerCost(SelectedCard, SelectedSlots, Player).."${{CR}}"

                else --not selling anything and confirm button

                    Icon = ""
                    Name = mod.Descriptions.Other.Exit[Lang]
                    Description = ""
                end
                goto FINISH
            end


            if SelectedCard.Joker == 0 then --empty slot

                Icon = ""
                Name = "{{Blank}} "..mod.Descriptions.Other.Nothing[Lang]
                Description = mod.Descriptions.Other.EmptySlot[Lang]

            else --slot with something

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
                    RarityColor = "{{ColorMint}}"
                elseif Rarity == "rare" then
                    RarityColor = "{{ColorRed}}"
                else
                    RarityColor = "{{ColorRainbow}}"
                end

                Icon = "{{CurrentCard}}"
                Name = RarityColor..EID:getObjectName(5, 350, SelectedCard.Joker).."{{CR}}#{{Blank}}"

                Description = ""..mod.Descriptions.Jimbo.Jokers[SelectedCard.Joker][Lang] --EID:getDescriptionEntry("custom", Tstring)[3]

                local Edition = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index].Edition

                local EditionDesc = mod.Descriptions.JokerEdition[Edition][Lang]

                Description = Description..EditionDesc

                --PROGRESS--

                local JokerConfig = ItemsConfig:GetTrinket(SelectedCard.Joker)

                if JokerConfig:HasCustomTag("Value") then

                    local Value = mod.Saved.Player[PIndex].Progress.Inventory[mod.SelectionParams[PIndex].Index]
                    

                    Description = Description..GetProgressString(SelectedCard.Joker, Value, Player)

                end

                --SELL VALUE--

                if SelectedCard.Joker == mod.Jokers.EGG then
                    Description = Description.." #{{Shop}}"..mod.Descriptions.Other.SellsFor[Lang].."{{ColorYellorange}}"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[mod.SelectionParams[PIndex].Index]).."${{CR}}"

                else
                    Description = Description.." #{{Shop}}"..mod.Descriptions.Other.SellsFor[Lang].."{{ColorYellorange}}"..tostring(mod:GetJokerCost(SelectedCard.Joker, SelectedCard.Edition, mod.SelectionParams[PIndex].Index, Player)).."${{CR}}"
                end
            end

        elseif Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.PACK then

            SelectedCard = Balatro_Expansion.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index]
            SelectedSlots = mod.SelectionParams[PIndex].Index

            if not SelectedCard then -- the skip option

                Icon = ""
                Name = mod.Descriptions.Other.SkipName[Lang].."#{{Blank}}"
                Description = mod.Descriptions.Other.SkipDesc[Lang] --wasn't able to find an api function for this

                goto FINISH
            end


            if Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.BuffonPack then

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
                    RarityColor = "{{ColorMint}}"
                elseif Rarity == "rare" then
                    RarityColor = "{{ColorRed}}"
                else
                    RarityColor = "{{ColorRainbow}}"
                end

                Icon = "{{CurrentCard}}"
                Name = RarityColor..EID:getObjectName(5, 350, SelectedCard.Joker).."#{{Blank}}"

                local BaseDesc = mod.Descriptions.Jimbo.Jokers[SelectedCard.Joker][Lang] or mod.Descriptions.Jimbo.Jokers[SelectedCard.Joker]["en_us"]

                Description = BaseDesc..GetProgressString(SelectedCard.Joker, SelectedCard.Progress, Player)


                local EditionDesc = mod.Descriptions.JokerEdition[SelectedCard.Edition][Lang] or mod.Descriptions.JokerEdition[SelectedCard.Edition]["en_us"]

                Description = Description..EditionDesc

            elseif Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.StandardPack then 

                Icon = "{{RedCard}}"

                local CardName = mod:GetCardName(SelectedCard, true)
                if SelectedCard.Enhancement ~= mod.Enhancement.STONE then
                    CardName = mod.Descriptions.EnhancementName[mod.Enhancement.STONE][Lang]

                    CardName = CardName.."{{ColorCyan}} "..mod.Descriptions.Other.LV[Lang]..tostring(mod.Saved.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
                end

                Name = CardName

                local EnhancementEffect = mod.Descriptions.Jimbo.Enhancement[SelectedCard.Enhancement][Lang] or mod.Descriptions.Jimbo.Enhancement[SelectedCard.Enhancement]["en_us"]
                local SealEffect = mod.Descriptions.Seal[SelectedCard.Seal][Lang] --PLACEHOLDER
                local EditionEffect = mod.Descriptions.CardEdition[SelectedCard.Edition][Lang] --PLACEHOLDER

                local CardAttributes = EnhancementEffect..SealEffect..EditionEffect

                Description = CardAttributes

            
            else
                local TrueCard = Balatro_Expansion:FrameToSpecialCard(SelectedCard)


                descObj.ObjType = 5
                descObj.ObjVariant = 300
                descObj.ObjSubType = TrueCard


                Icon = ""
                Name = EID:getObjectName(5, 300, TrueCard).."#{{Blank}}"


                Description = mod.Descriptions.Jimbo.Consumables[TrueCard][Lang] or mod.Descriptions.Consumables[TrueCard]["en_us"]
            end

        elseif Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.HAND then

            SelectedCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]
            SelectedSlots = mod.SelectionParams[PIndex].Index

            if not SelectedCard then -- the skip option

                Icon = ""
                Name = mod.Descriptions.Other.ConfirmName[Lang].."#{{Blank}}"
                Description = mod.Descriptions.Other.ConfirmDesc[Lang]

                goto FINISH
            end

            Icon = "{{RedCard}}"

            local CardName = mod:GetCardName(SelectedCard, true)

            if SelectedCard.Enhancement ~= mod.Enhancement.STONE then

                CardName = CardName.."{{ColorCyan}} "..mod.Descriptions.Other.LV[Lang]..tostring(mod.Saved.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
            end

            Name = CardName

            local EnhancementEffect = mod.Descriptions.Jimbo.Enhancement[SelectedCard.Enhancement][Lang] or mod.Descriptions.Jimbo.Enhancement[SelectedCard.Enhancement]["en_us"]
            local SealEffect = mod.Descriptions.Seal[SelectedCard.Seal][Lang] --PLACEHOLDER
            local EditionEffect = mod.Descriptions.CardEdition[SelectedCard.Edition][Lang] --PLACEHOLDER

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
    
    local Lang = mod:GetEIDLanguage()


    local BaseDesc = ""

    if descObj.ObjSubType <= Card.CARD_WORLD then

        --BaseDesc = mod.Descriptions.Jimbo.Consumables[descObj.ObjSubType][Lang] or mod.Descriptions.Jimbo.Consumables[descObj.ObjSubType]["en_us"]


        if descObj.ObjSubType == Card.CARD_FOOL then


            local CardName = mod.Saved.LastCardUsed and "{{ColorMint}}"..EID:getObjectName(5,300,mod.Saved.LastCardUsed).."{{CR}}" or "{{ColorRed}}None{{CR}}"

            BaseDesc = BaseDesc..CardName

        elseif descObj.ObjSubType == Card.CARD_MAGICIAN then
            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.LUCKY][Lang]
        elseif descObj.ObjSubType== Card.CARD_LOVERS then
            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.WILD][Lang]
        
        elseif descObj.ObjSubType== Card.CARD_DEVIL then
            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.GOLDEN][Lang] 
        
        elseif descObj.ObjSubType== Card.CARD_TOWER then
            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.STONE][Lang]
        
        elseif descObj.ObjSubType== Card.CARD_EMPRESS then
            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.MULT][Lang]
        
        elseif descObj.ObjSubType== Card.CARD_HIEROPHANT then

            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.BONUS][Lang]
        elseif descObj.ObjSubType== Card.CARD_CHARIOT then

            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.STEEL][Lang]
        elseif descObj.ObjSubType== Card.CARD_JUSTICE then

            BaseDesc = BaseDesc..mod.Descriptions.Jimbo.Enhancement[mod.Enhancement.GLASS][Lang]
        end
    end
    
    if descObj.ObjSubType== mod.Spectrals.TALISMAN then

        BaseDesc = BaseDesc..mod.Descriptions.Seal[mod.Seals.GOLDEN][Lang]
    elseif descObj.ObjSubType== mod.Spectrals.DEJA_VU then

        BaseDesc = BaseDesc..mod.Descriptions.Seal[mod.Seals.RED][Lang]
    elseif descObj.ObjSubType== mod.Spectrals.TRANCE then

        BaseDesc = BaseDesc..mod.Descriptions.Seal[mod.Seals.BLUE][Lang]
    elseif descObj.ObjSubType== mod.Spectrals.MEDIUM then

        BaseDesc = BaseDesc..mod.Descriptions.Seal[mod.Seals.PURPLE][Lang]
    elseif descObj.ObjSubType== mod.Spectrals.ECTOPLASM then

        BaseDesc = BaseDesc..mod.Descriptions.JokerEdition[mod.Edition.NEGATIVE][Lang]
    end


    EID:appendToDescription(descObj, BaseDesc)
    return descObj
end

EID:addDescriptionModifier("Balatro Extra descriptions", BalatroExtraDescCondition, BalatroExtraDescCallback)


local function JimboGroundtrinketsCondition(descObj)

    if PlayerManager.AnyoneIsPlayerType(Balatro_Expansion.Characters.JimboType) 
       and descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET 
       and ItemsConfig:GetTrinket(descObj.ObjSubType):HasCustomTag("balatro") then

        return true
    end
end

local function JimboGroundtrinketsCallback(descObj)

    local Lang = mod:GetEIDLanguage()


    descObj.Description = mod.Descriptions.Jimbo.Jokers[descObj.ObjSubType][Lang] or mod.Descriptions.Jimbo.Jokers[descObj.ObjSubType]["en_us"]

    descObj.Description = descObj.Description..GetProgressString(descObj.ObjSubType, mod:GetJokerInitialProgress(descObj.ObjSubType, false))

    return descObj
end
EID:addDescriptionModifier("Balatro Jimbo ground trinkets", JimboGroundtrinketsCondition, JimboGroundtrinketsCallback)





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

EID:addDescriptionModifier("Balatro mod.Descriptions Offset", BalatroOffsetCondition, BalatroOffsetCallback)



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
local ObjectToDescribe = {Type = EID_DescType.NONE,
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
                  FilteredDescription = nil,}


local EID_BubbleFrame = {Name = 1,
                         Description = 0}


--I hate myself for doing this
local function TJimboDescriptionsCondition(descObj)

    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
       --and descObj.ObjVariant == DescriptionHelperVariant
       --and descObj.ObjSubType == DescriptionHelperSubType then

        return true
    end
end

local function TJimboDescriptionsCallback(descObj)


    local Result = false
    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        goto FINISH
    end

    local PIndex = T_Jimbo:GetData().TruePlayerIndex
    local PlayerSelection = mod.SelectionParams[PIndex]

    --first check if the selection has something to describe
    

    if descObj.ObjVariant ~= DescriptionHelperVariant and descObj.ObjSubType ~= DescriptionHelperSubType
       or PlayerSelection.Mode == mod.SelectionParams.Modes.NONE then

        goto ENTITY_CHECK
    end

    if T_Jimbo:GetData().ConfirmHoldTime < mod.HOLD_THRESHOLD then --needs to hold to show text
        goto FINISH
    end

    if ObjectToDescribe.Entity == PlayerSelection.Index then --caches the previous description to save time
        
        --only updates the position and goes straight to rendering
        ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -20)

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

            ObjectToDescribe.Params = card
            ObjectToDescribe.Position = mod.CardFullPoss[Pointer] + Vector(0, -30)
            ObjectToDescribe.Allignment = EID_DescAllingnment.BOTTOM

            ObjectToDescribe.Type = EID_DescType.CARD
            ObjectToDescribe.SubType = 0 --not really needed

            goto FINISH
        end

    elseif PlayerSelection.Mode == mod.SelectionParams.Modes.CONSUMABLES then

        Result = T_Jimbo:GetData().ConfirmHoldTime >= mod.HOLD_THRESHOLD

        if Result then

            local Consumable = mod.Saved.Player[PIndex].Consumables[PlayerSelection.Index]

            ObjectToDescribe.Params = Consumable
            ObjectToDescribe.Position = mod.ConsumableFullPosition[PlayerSelection.Index] + Vector(0, -30)
            ObjectToDescribe.Allignment = EID_DescAllingnment.TOP | EID_DescAllingnment.RIGHT

            ObjectToDescribe.Type = EID_DescType.CONSUMABLE
            ObjectToDescribe.SubType = mod:FrameToSpecialCard(Consumable.Card)


            goto FINISH
        end

    elseif PlayerSelection.Mode == mod.SelectionParams.Modes.INVENTORY then

        Result = T_Jimbo:GetData().ConfirmHoldTime >= mod.HOLD_THRESHOLD

        if Result then

            local Slot = mod.Saved.Player[PIndex].Inventory[PlayerSelection.Index]

            ObjectToDescribe.Params = Slot
            ObjectToDescribe.Params.Index = PlayerSelection.Index
            ObjectToDescribe.Position = mod.JokerFullPosition[Slot.RenderIndex] + Vector(0, 30)
            ObjectToDescribe.Allignment = EID_DescAllingnment.TOP

            ObjectToDescribe.Type = EID_DescType.JOKER
            ObjectToDescribe.SubType = Slot.Joker


            goto FINISH
        end

    elseif PlayerSelection.Mode == mod.SelectionParams.Modes.PACK then

        Result = true
        ObjectToDescribe.Allignment = EID_DescAllingnment.BOTTOM

        if PlayerSelection.PackPurpose == mod.SelectionParams.Purposes.BuffonPack then

            local Slot = PlayerSelection.PackOptions[PlayerSelection.Index]

            ObjectToDescribe.Params = Slot
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -30)

            ObjectToDescribe.Type = EID_DescType.JOKER
            ObjectToDescribe.SubType = Slot.Joker
        
        elseif PlayerSelection.PackPurpose == mod.SelectionParams.Purposes.StandardPack then


            local card = PlayerSelection.PackOptions[PlayerSelection.Index]

            ObjectToDescribe.Params = card
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -20)

            ObjectToDescribe.Position.Y = ObjectToDescribe.Position.Y - ObjectToDescribe.Position.Y%0.5
            ObjectToDescribe.Position.X = ObjectToDescribe.Position.X - ObjectToDescribe.Position.X%0.5

            ObjectToDescribe.Type = EID_DescType.CARD
            ObjectToDescribe.SubType = 0 --not really needed
        
        else
            local Consumable = PlayerSelection.PackOptions[PlayerSelection.Index]

            ObjectToDescribe.Params = {Edition = mod.Edition.BASE}
            ObjectToDescribe.Position = mod.PackOptionFullPosition[PlayerSelection.Index] + Vector(0, -30)

            ObjectToDescribe.Type = EID_DescType.CONSUMABLE
            ObjectToDescribe.SubType = mod:FrameToSpecialCard(Consumable)
        end

        goto FINISH
    end


    if Result then
        ObjectToDescribe.Type = ObjectToDescribe.Type | EID_DescType.SELECTION_FLAG
    end


    ::ENTITY_CHECK::

    if descObj.ObjType == EntityType.ENTITY_PICKUP then

        local NewHash = GetPtrHash(descObj.Entity)

        if ObjectToDescribe.Entity == NewHash then --caches the previous variables to save time
            
            Result = true
            return descObj
        end

        ObjectToDescribe.Entity = GetPtrHash(descObj.Entity)

        EID_Desc.NumLines = nil
        EID_Desc.FilteredName = nil
        EID_Desc.FilteredDescription = nil


        ObjectToDescribe.Allignment = EID_DescAllingnment.TOP | EID_DescAllingnment.LEFT

        if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then

            if ItemsConfig:GetCollectible(descObj.ObjSubType):HasCustomTag("balatro") then

                ObjectToDescribe.Params = {}

                ObjectToDescribe.Position = EID:getTextPosition()


                ObjectToDescribe.Type = EID_DescType.VOUCHER
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true 
            end

        elseif descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD then

            if descObj.ObjSubType <= Card.CARD_WORLD 
               or descObj.ObjSubType >= mod.Planets.PLUTO and descObj.ObjSubType <= mod.Spectrals.SOUL then
                
                ObjectToDescribe.Params = {Edition = mod.Edition.BASE}

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

                ObjectToDescribe.Type = EID_DescType.CONSUMABLE
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

                ObjectToDescribe.Type = EID_DescType.BOOSTER
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true
            end

        elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then

            local JokerConfig = ItemsConfig:GetTrinket(descObj.ObjSubType)

            if JokerConfig:HasCustomTag("balatro") then

                ObjectToDescribe.Params = {Edition = mod.Saved.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][JokerConfig.Name],
                                           Modifiers = 0}

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

                ObjectToDescribe.Type = EID_DescType.JOKER
                ObjectToDescribe.SubType = descObj.ObjSubType --not really needed

                Result = true
                return true
            end
        end
    end



    ::FINISH::

    local Lang = mod:GetEIDLanguage()

    --save the object's description and name
    if ObjectToDescribe.Type & EID_DescType.CARD ~= 0 then

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
            
                TriggerDesc = TriggerDesc.."{{ColorChips}}+"..tostring(mod:GetValueScoring(card.Value)).."{{B_Black}}Chips"
            end

            TriggerDesc = TriggerDesc..(mod.Descriptions.T_Jimbo.Enhancement[card.Enhancement][Lang] or mod.Descriptions.T_Jimbo.Enhancement[card.Enhancement]["en_us"])

            --hiker upgrades
            if card.Upgrades > 0 then

                TriggerDesc = TriggerDesc.."#{{ColorChips}}+"..tostring(5*card.Upgrades).."{{B_Black}} Extra Chips"
            end

            EID_Desc.Description = TriggerDesc

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = card.Edition
            EID_Desc.Extras.Seal = card.Seal
        end

    elseif ObjectToDescribe.Type & EID_DescType.JOKER ~= 0 then

        if ObjectToDescribe.Params.Modifiers & mod.Modifier.DEBUFFED ~= 0 then

            local Config = ItemsConfig:GetTrinket(ObjectToDescribe.SubType)

            EID_Desc.Name = Config.Name
            
            EID_Desc.Description = mod:GetEIDString("T_Jimbo","Debuffed")

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = mod.Edition.BASE
            EID_Desc.Extras.Seal = mod.Seals.NONE

        elseif ObjectToDescribe.Params.Modifiers & mod.Modifier.COVERED ~= 0 then
            
            EID_Desc.Name = "???"

            EID_Desc.Description = "?????"

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = mod.Edition.BASE
            EID_Desc.Extras.Seal = mod.Seals.NONE
        else

            local Config = ItemsConfig:GetTrinket(ObjectToDescribe.SubType)

            EID_Desc.Name = Config.Name

            EID_Desc.Description = mod:GetEIDString("T_Jimbo","Jokers",ObjectToDescribe.SubType)

            EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
            EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
            EID_Desc.Extras.Seal = mod.Seals.NONE
        end

    elseif ObjectToDescribe.Type & EID_DescType.CONSUMABLE ~= 0 then

        local Config = ItemsConfig:GetCard(ObjectToDescribe.SubType)

        EID_Desc.Name = Config.Name

        EID_Desc.Description = mod:GetEIDString("T_Jimbo","Consumables",ObjectToDescribe.SubType)

        EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
        EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
        EID_Desc.Extras.Seal = mod.Seals.NONE

    elseif ObjectToDescribe.Type & EID_DescType.VOUCHER ~= 0 then

        local Config = ItemsConfig:GetCollectible(ObjectToDescribe.SubType)

        EID_Desc.Name = Config.Name

        EID_Desc.Description = mod:GetEIDString("T_Jimbo","Vouchers",ObjectToDescribe.SubType)

        EID_Desc.Extras.Enhancement = mod.Enhancement.NONE
        EID_Desc.Extras.Edition = ObjectToDescribe.Params.Edition
        EID_Desc.Extras.Seal = mod.Seals.NONE
    end

    EID_Desc.Description = mod:ReplaceBalatroMarkups(EID_Desc.Description, ObjectToDescribe.Type, ObjectToDescribe.SubType, PlayerSelection.Index)


    if not Result then

        EID_Desc.NumLines = nil
        EID_Desc.FilteredName = nil
        EID_Desc.FilteredDescription = nil


        ObjectToDescribe.Entity = nil
        ObjectToDescribe.Params = {}

        ObjectToDescribe.Position = Vector.Zero

        ObjectToDescribe.Type = EID_DescType.NONE
        ObjectToDescribe.SubType = 0 --not really needed

        EID:alterTextPos(Vector(-1000, -1000)) --basically erases the description form existence (prob not the best way to do that)
    
        return descObj
    end

    

    
    return descObj -- return the modified description object
end
EID:addDescriptionModifier("Tainted Jimbo Special descripions", TJimboDescriptionsCondition, TJimboDescriptionsCallback)


function mod:RenderObjectDescription()

    if ObjectToDescribe.Type == EID_DescType.NONE then

        --resets the cached values
        EID_Desc.NumLines = nil 
        EID_Desc.FilteredName = nil 
        EID_Desc.FilteredDescription = nil

        return
    end

    EID_Bubble:SetFrame("Any", 0)

    
    if ObjectToDescribe.Type & EID_DescType.CARD ~= 0 then

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

    if ObjectToDescribe.Type & EID_DescType.CARD ~= 0 then

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
        
        RenderPos.Y = ObjectToDescribe.Position.Y - BubbleScale.Y*5 - EID_BUBBLE_BASE_SIZE.Y/2
    end
    if ObjectToDescribe.Allignment & EID_DescAllingnment.TOP ~= 0 then
        
        RenderPos.Y = ObjectToDescribe.Position.Y + BubbleScale.Y*5 + EID_BUBBLE_BASE_SIZE.Y/2
    end
    if ObjectToDescribe.Allignment & EID_DescAllingnment.RIGHT ~= 0 then
        
        RenderPos.X = ObjectToDescribe.Position.X - BubbleScale.X*5 - EID_BUBBLE_BASE_SIZE.X/2
    end
    if ObjectToDescribe.Allignment & EID_DescAllingnment.LEFT ~= 0 then
        
        RenderPos.X = ObjectToDescribe.Position.X - BubbleScale.X*5 - EID_BUBBLE_BASE_SIZE.X/2
    end


    local Y_BorderOffset = Vector(0,BubbleScale.Y*5)
    local X_BorderOffset = Vector(BubbleScale.X*5,0)

    EID_Bubble.Scale = BubbleScale


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

    mod:RenderBalatroStyle(EID_Desc.Name, NamePos, Params, 0, NameScale, mod.BalatroKColorBlack, BoxWidth)


    EID_Bubble:SetFrame(EID_BubbleFrame.Description)

    NullFrame = EID_Bubble:GetNullFrame("String Position")

    local DescScale = Vector.One * NullFrame:GetScale().Y*100

    local DescPos = RenderPos + NullFrame:GetPos()
    DescPos.Y = DescPos.Y - BubbleScale.Y*5

    EID_Desc.NumLines = mod:RenderBalatroStyle(EID_Desc.Description, DescPos, Params, 0, DescScale, mod.BalatroKColorBlack, BoxWidth)

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.RenderObjectDescription)


