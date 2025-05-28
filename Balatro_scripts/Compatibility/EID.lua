---@diagnostic disable: need-check-nil
if not EID then
    return
end

local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
--local TrinketSprite = Sprite("gfx/005.350_custom.anm2")

local SUIT_FLAG = 7 --111 00..
local VALUE_FLAG = 120 --000 1111 00..
local YORIK_VALUE_FLAG = 63 --000 1111 00..

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



--------------LIST OF ALL THE BASIC DESCRIPTIONS--------------------

local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")
EID:addEntity(1000, DescriptionHelperVariant, DescriptionHelperSubType,"Description Overview", "")


local Descriptions = {}

for _, LanguageCode in ipairs(SupportedLanguages) do

    Descriptions[LanguageCode] = include("Balatro_scripts.Compatibility.EID translations."..LanguageCode)
end




--uses a hacky entity to simulate the options being descripted, no idea if this is an optimal way or not
local function BalatroInventoryCondition(descObj)
    if descObj.ObjType == EntityType.ENTITY_EFFECT and descObj.ObjVariant == DescriptionHelperVariant and descObj.ObjSubType == DescriptionHelperSubType then
        if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
            return true
        end
    end
end
local function BalatroInventoryCallback(descObj)


    local Language = EID:getLanguage()
    if not mod:Contained(SupportedLanguages, Language) then --defaults to english if the language is not supported
        Language = "en_us"
    end

    descObj.Name = Descriptions[Language].Other.Name --PLACEHOLDER


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
                    Name = Descriptions[Language].Other.SellJoker
                    Description = "#{{CurrentCard}} "..Descriptions[Language].Other.SellsFor.." {{ColorYellow}}"..mod:GetJokerCost(SelectedCard, SelectedSlots, Player).."${{CR}}"

                else --not selling anything and confirm button

                    Icon = ""
                    Name = Descriptions[Language].Other.Exit
                    Description = ""
                end
                goto FINISH
            end

            SelectedCard = SelectedCard.Joker

            if SelectedCard == 0 then --empty slot

                Icon = ""
                Name = "{{Blank}} "..Descriptions[Language].Other.Nothing
                Description = Descriptions[Language].Other.EmptySlot

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

                local Edition = mod.Saved.Player[PIndex].Inventory[mod.SelectionParams[PIndex].Index].Edition

                local EditionDesc = Descriptions[Language].JokerEdition[Edition]

                Description = Description..EditionDesc

                --PROGRESS--

                local JokerConfig = ItemsConfig:GetTrinket(SelectedCard)
                if JokerConfig:HasCustomTag("Value") then

                    local Value = Balatro_Expansion.Saved.Player[PIndex].Progress.Inventory[mod.SelectionParams[PIndex].Index]
                    if JokerConfig:HasCustomTag("chips") then
                        if SelectedCard == mod.Jokers.WALKIE_TALKIE then

                            Description = Description.." #!!! "..Descriptions[Language].Other.CompatibleTriggered..tostring(Value)
                        
                        elseif SelectedCard == mod.Jokers.CASTLE then

                            Description = Description.."#!!!"..Descriptions[Language].Other.SuitChosen..mod:CardSuitToName(Value & SUIT_FLAG, true).."#!!! "..Descriptions[Language].Other.CompatibleDiscarded.." {{ColorChips}} "..tostring((Value & ~SUIT_FLAG)/8)
                        else
                            Description = Description.." #!!! "..Descriptions[Language].Other.Currently.."{{ColorChips}} +"..tostring(Value).."{{CR}}"
                        end
                    elseif JokerConfig:HasCustomTag("mult") then
                        Description = Description.." #!!! "..Descriptions[Language].Other.Currently.."{{ColorMult}} +"..tostring(Value).."{{CR}}"

                    elseif JokerConfig:HasCustomTag("multm") then
                        if SelectedCard == mod.Jokers.LOYALTY_CARD then
                            if Value == 0 then
                                Description = Description.." #!!! "..Descriptions[Language].Other.Active
                            else
                                Description = Description.." #!!! "..Descriptions[Language].Other.RoomsRemaining.."{{ColorYellorange}} "..tostring(Value).."{{CR}}"
                            end

                        elseif SelectedCard == mod.Jokers.ANCIENT_JOKER then
                            
                            Description = Description.." #!!! "..Descriptions[Language].Other.SuitChosen..mod:CardSuitToName(Value & SUIT_FLAG).."{{CR}}".."#!!! "..Descriptions[Language].Other.CompatibleTriggered..tostring((Value & ~SUIT_FLAG)/8)
                        
                        elseif SelectedCard == mod.Jokers.IDOL then
                            Description = Description.." #!!! "..Descriptions[Language].Other.CardChosen..mod:CardValueToName(Value & VALUE_FLAG, true).." of "..mod:CardSuitToName(Value & SUIT_FLAG, true).."#!!! "..Descriptions[Language].Other.CompatibleTriggered..tostring((Value & ~(SUIT_FLAG|VALUE_FLAG))/128)
                        
                        elseif SelectedCard == mod.Jokers.YORICK then

                            Description = Description.." #!!! "..Descriptions[Language].Other.Currently.."{{ColorMult}} X"..tostring(1+(Value & ~YORIK_VALUE_FLAG/(YORIK_VALUE_FLAG+1))*0.2).."{{CR}}#!!! "..Descriptions[Language].Other.DiscardsRemeining..tostring(Value & YORIK_VALUE_FLAG)
                        else
                            Description = Description.." #!!! "..Descriptions[Language].Other.Currently.."{{ColorMult}} X"..tostring(Value).."{{CR}}"
                        end


                    elseif JokerConfig:HasCustomTag("money") then
                        
                        if SelectedCard == mod.Jokers.TO_DO_LIST then

                            Description = Description.." #!!! "..Descriptions[Language].Other.ValueChosen.."{{ColorYellorange}} "..tostring(Value).."{{CR}}"
                        else
                            Description = Description.." #!!! "..Descriptions[Language].Other.Currently.."{{ColorYellorange}} "..tostring(Value).."${{CR}}"
                        end
                    elseif JokerConfig:HasCustomTag("activate") then

                        if SelectedCard == mod.Jokers.BLUEPRINT or SelectedCard == mod.Jokers.BRAINSTORM then

                            if Value ~= 0 then
                                Description = Description.." #!!! "..Descriptions[Language].Other.Currently..Descriptions[Language].Other.Compatible
                            else
                                Description = Description.." #!!! "..Descriptions[Language].Other.Currently..Descriptions[Language].Other.Incompatible
                            end

                        elseif SelectedCard == mod.Jokers.INVISIBLE_JOKER then

                            if Value == 3 then
                                Description = Description.." #!!! "..Descriptions[Language].Other.Ready
                            else
                                Description = Description.." #!!! "..Descriptions[Language].Other.BlindsCleared.."{{ColorYellorange}}"..tostring(Value).."/3{{CR}}"
                            end

                        elseif SelectedCard == mod.Jokers.DNA then
                            if Balatro_Expansion.Saved.Player[PIndex].Progress.Blind.Shots == 0 then
                                Description = Description.." #!!! "..Descriptions[Language].Other.Ready

                            else
                                Description = Description.." #!!! "..Descriptions[Language].Other.NotReady

                            end

                        elseif SelectedCard == mod.Jokers.SIXTH_SENSE then
                            if Balatro_Expansion.Saved.Player[PIndex].Progress.Blind.Shots == 0 then
                                Description = Description.." #!!! "..Descriptions[Language].Other.Currently..Descriptions[Language].Other.Ready

                            else
                                Description = Description.." #!!! "..Descriptions[Language].Other.Currently..Descriptions[Language].Other.NotReady

                            end
                        elseif SelectedCard == mod.Jokers.TURTLE_BEAN then

                            Description = Description.." #!!! "..Descriptions[Language].Other.Currently.." {{ColorCyan}}+"..tostring(Value).." "..Descriptions[Language].Other.HandSize.."{{CR}}"
                        elseif SelectedCard == mod.Jokers.SELTZER then

                            Description = Description.." #!!! "..Descriptions[Language].Other.RoomsRemaining..tostring(Value)
                        end
                    end

                end

                --SELL VALUE--

                if SelectedCard == mod.Jokers.EGG then
                    Description = Description.." #{{Shop}}"..Descriptions[Language].Other.SellsFor.."{{ColorYellorange}}"..tostring(mod.Saved.Player[PIndex].Progress.Inventory[mod.SelectionParams[PIndex].Index]).."${{CR}}"

                else
                    Description = Description.." #{{Shop}}"..Descriptions[Language].Other.SellsFor.."{{ColorYellorange}}"..tostring(mod:GetJokerCost(SelectedCard, mod.SelectionParams[PIndex].Index, Player)).."${{CR}}"

                end
            end

        elseif Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.PACK then

            SelectedCard = Balatro_Expansion.SelectionParams[PIndex].PackOptions[mod.SelectionParams[PIndex].Index]
            SelectedSlots = mod.SelectionParams[PIndex].Index

            if not SelectedCard then -- the skip option

                Icon = ""
                Name = Descriptions[Language].Other.SkipName.."#{{Blank}}"
                Description = Descriptions[Language].Other.SkipDesc --wasn't able to find an api function for this

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
                    RarityColor = "{{ColorLime}}"
                elseif Rarity == "rare" then
                    RarityColor = "{{ColorRed}}"
                else
                    RarityColor = "{{ColorRainbow}}"
                end

                Icon = "{{CurrentCard}}"
                Name = RarityColor..EID:getObjectName(5, 350, SelectedCard.Joker).."#{{Blank}}"
                Description =""..EID:getDescriptionEntry("custom", Tstring)[3]


                local EditionDesc = Descriptions[Language].JokerEdition[SelectedCard.Edition] or Descriptions["en_us"].JokerEdition[SelectedCard.Edition]

                Description = Description..EditionDesc

            elseif Balatro_Expansion.SelectionParams[PIndex].Purpose == Balatro_Expansion.SelectionParams.Purposes.StandardPack then 

                Icon = "{{RedCard}}"

                local CardName 
                if SelectedCard.Enhancement == mod.Enhancement.STONE then
                    CardName = Descriptions[Language].EhancementName[mod.Enhancement.STONE]

                else
                    CardName = mod:CardValueToName(SelectedCard.Value, true).." of "..mod:CardSuitToName(SelectedCard.Suit, true)

                    CardName = CardName.."{{ColorCyan}} "..Descriptions[Language].Other.LV..tostring(mod.Saved.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
                end

                Name = CardName

                local CardAttributes = Descriptions[Language].Enhancement[SelectedCard.Enhancement]..Descriptions[Language].Seal[SelectedCard.Seal]..Descriptions[Language].CardEdition[SelectedCard.Edition]

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

        elseif Balatro_Expansion.SelectionParams[PIndex].Mode == Balatro_Expansion.SelectionParams.Modes.HAND then

            SelectedCard = mod.Saved.Player[PIndex].FullDeck[mod.Saved.Player[PIndex].CurrentHand[mod.SelectionParams[PIndex].Index]]
            SelectedSlots = mod.SelectionParams[PIndex].Index

            if not SelectedCard then -- the skip option

                Icon = ""
                Name = Descriptions[Language].Other.ConfirmName.."#{{Blank}}"
                Description = Descriptions[Language].Other.ConfirmDesc

                goto FINISH
            end

            Icon = "{{RedCard}}"

            local CardName
            if SelectedCard.Enhancement == mod.Enhancement.STONE then
                CardName = Descriptions[Language].EhancementName[mod.Enhancement.STONE]

            else
                CardName = mod:CardValueToName(SelectedCard.Value, true).." of "..mod:CardSuitToName(SelectedCard.Suit, true)

                CardName = CardName.."{{ColorCyan}} "..Descriptions[Language].Other.LV..tostring(mod.Saved.CardLevels[SelectedCard.Value] + 1).."{{CR}}"
            end

            Name = CardName

            local CardAttributes = Descriptions[Language].Enhancement[SelectedCard.Enhancement]..Descriptions[Language].Seal[SelectedCard.Seal]..Descriptions[Language].CardEdition[SelectedCard.Edition]

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
    
    local Language = EID:getLanguage()
    if not mod:Contained(SupportedLanguages, Language) then
        Language = "en_us"
    end

    local BaseDesc = ""

    if descObj.ObjSubType <= Card.CARD_WORLD then

        BaseDesc = Descriptions[Language].Tarot[descObj.ObjSubType] or Descriptions["en_us"].Tarot[descObj.ObjSubType]


        if descObj.ObjSubType == Card.CARD_FOOL then


            local CardName = mod.Saved.LastCardUsed and "{{ColorLime}}"..EID:getObjectName(5,300,mod.Saved.LastCardUsed).."{{CR}}" or "{{ColorRed}}None{{CR}}"

            BaseDesc = BaseDesc..CardName

        elseif descObj.ObjSubType == Card.CARD_MAGICIAN then
            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.LUCKY]
        elseif descObj.ObjSubType== Card.CARD_LOVERS then
            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.WILD] 
        
        elseif descObj.ObjSubType== Card.CARD_DEVIL then
            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.GOLDEN] 
        
        elseif descObj.ObjSubType== Card.CARD_TOWER then
            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.STONE]
        
        elseif descObj.ObjSubType== Card.CARD_EMPRESS then
            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.MULT]
        
        elseif descObj.ObjSubType== Card.CARD_HIEROPHANT then

            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.BONUS]
        elseif descObj.ObjSubType== Card.CARD_CHARIOT then

            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.STEEL]
        elseif descObj.ObjSubType== Card.CARD_JUSTICE then

            BaseDesc = BaseDesc..Descriptions[Language].Enhancement[mod.Enhancement.GLASS]
        end
    end
    
    if descObj.ObjSubType== mod.Spectrals.TALISMAN then

        BaseDesc = BaseDesc..Descriptions[Language].Seal[mod.Seals.GOLDEN]
    elseif descObj.ObjSubType== mod.Spectrals.DEJA_VU then

        BaseDesc = BaseDesc..Descriptions[Language].Seal[mod.Seals.RED]
    elseif descObj.ObjSubType== mod.Spectrals.TRANCE then

        BaseDesc = BaseDesc..Descriptions[Language].Seal[mod.Seals.BLUE]
    elseif descObj.ObjSubType== mod.Spectrals.MEDIUM then

        BaseDesc = BaseDesc..Descriptions[Language].Seal[mod.Seals.PURPLE]
    elseif descObj.ObjSubType== mod.Spectrals.ECTOPLASM then

        BaseDesc = BaseDesc..Descriptions[Language].JokerEdition[mod.Edition.NEGATIVE]
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