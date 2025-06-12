
local mod = Balatro_Expansion

local Game = Game()
local Level = Game:GetLevel()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local SMALL_BLIND_ROOMIDX = 0
local BIG_BLIND_ROOMIDX = 16

local SCREEN_TO_WORLD_RATIO = 4


----FUTURE GLOBALS -----
local AnteVoucher = mod.Vouchers.Grabber

local ShopRoomIndex = 0
local BossRoomIndex = 0
-----------------------------------



--setups variables for jimbo
---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.TaintedJimbo then
        local Data = player:GetData()

        Data.ALThold = 0 --used to sell consumables

        --player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)

        player:AddCustomCacheTag(mod.CustomCache.HAND_COOLDOWN, true)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)

--Adds the small/big blind rooms + saves the room index of shops and boss rooms
---@param RoomConfig RoomConfigRoom
---@param LevelGen LevelGeneratorRoom
local function FloorModifier(_,LevelGen,RoomConfig,Seed)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end
    --mod.ShopAddedThisFloor = false
    local Level = Game:GetLevel()
    local RoomIndex = LevelGen:Column() + LevelGen:Row()*13
    
    --print(RoomIndex)

    if RoomConfig.Type == RoomType.ROOM_SHOP then
        --("s")
        local ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
            ShopQuality = RoomSubType.SHOP_KEEPER_LEVEL_3
        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
            ShopQuality= RoomSubType.SHOP_KEEPER_LEVEL_4
        end

        local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, ShopQuality)

        Isaac.CreateTimer(
        function()
            Level:GetRoomByIdx(RoomIndex).DisplayFlags = 5

            Level:UpdateVisibility()
        end, 1, 1, true)


            local SmallEntry = Isaac.LevelGeneratorEntry()
    SmallEntry:SetAllowedDoors(math.maxinteger)
    SmallEntry:SetColIdx(0)
    SmallEntry:SetLineIdx(0)

    local SmallRoom = RoomConfigHolder.GetRandomRoom(1,
                                                     true, 
                                                     Isaac.GetCurrentStageConfigId(),
                                                     RoomType.ROOM_DEFAULT,
                                                     RoomShape.ROOMSHAPE_1x1,
                                                     -1, -1,
                                                     7,
                                                     10,
                                                     0,-1,-1)

    local BigEntry = Isaac.LevelGeneratorEntry()
    BigEntry:SetAllowedDoors(0)
    BigEntry:SetColIdx(3)
    BigEntry:SetLineIdx(1)

    local BigRoom = RoomConfigHolder.GetRandomRoom(1,
                                                     true, 
                                                     Isaac.GetCurrentStageConfigId(),
                                                     RoomType.ROOM_DEFAULT,
                                                     RoomShape.ROOMSHAPE_2x2,
                                                     -1, -1,
                                                     7,
                                                     10,
                                                     0,-1,-1)

    
    Level:PlaceRoom(SmallEntry, SmallRoom, 1)
    Level:PlaceRoom(BigEntry, BigRoom, 1)

        return NewRoom --replaces the room with the new only
    end



end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, FloorModifier)



---@param Player EntityPlayer
function mod:TJimboAddConsumable(Player, card, Slot, StopAnimation)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local Slot = Slot or 0
    local EmptySlot

    if mod:Contained(mod.Packs, card) then
        
        Player:UseCard(card)
        goto REMOVE
    end

    
    for i = #mod.Saved.Player[PIndex].Consumables, 1, -1 do
        if mod.Saved.Player[PIndex].Consumables[i].Card == -1 then
            EmptySlot = i
            break
        end
    end

    if not EmptySlot then
        
        if not StopAnimation then
            Isaac.CreateTimer(function ()
                Player:AnimateSad()
            end,0,1,true)
        end

        goto REMOVE
    end

    mod.Saved.Player[PIndex].Consumables[EmptySlot].Card = mod:SpecialCardToFrame(card)

    ::REMOVE::

    Player:SetCard(Slot, 0)
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_ADD_CARD,CallbackPriority.IMPORTANT, mod.TJimboAddConsumable)




local function SetCustomCurses(Curses)

    return 0 --PLACEHOLDER
end
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, SetCustomCurses)



--makes basically every input possible when using T jimbo (+ other stuff)
---@param Player EntityPlayer
local function JimboInputHandle(_, Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex
    local Params = mod.SelectionParams[PIndex]

    ----------------------------------------

    --local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    
    -------------INPUT HANDLING-------------------
    
    --confirms the curretn selection
    if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then

        mod:UseSelection(Player)
    end

    
    
    if mod.AnimationIsPlaying then
        return
    end

    --confirming/canceling 
    if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
        and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then--usually they share buttons

        mod:Select(Player)

    end

    --pressing left moving the selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) then


        if Params.Index > 1 then
            local Step = 0

            if Params.Mode == mod.SelectionParams.Modes.INVENTORY then
                
                local SlotsSkipped = 1

                for i = Params.Index - 1, 1, -1 do
                    
                    if mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                        Step = -SlotsSkipped
                        break
                    end

                    SlotsSkipped = SlotsSkipped + 1
                end
            else
                Step = -1
            end

            --also holding ALT also makes you move the card itself 
            if Params.Mode ~= mod.SelectionParams.Modes.PACK
               and (Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, Player.ControllerIndex)
               or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, Player.ControllerIndex)) then

                Params.SelectedCards[Params.Mode][Params.Index], Params.SelectedCards[Params.Mode][Params.Index + Step] =
                Params.SelectedCards[Params.Mode][Params.Index + Step], Params.SelectedCards[Params.Mode][Params.Index]

                if Params.Mode == mod.SelectionParams.Modes.HAND then
                    
                    local PlayerHand = mod.Saved.Player[PIndex].CurrentHand
                    PlayerHand[Params.Index],  PlayerHand[Params.Index + Step] = 
                    PlayerHand[Params.Index + Step],  PlayerHand[Params.Index]
                else
                    
                    local PlayerInventory = mod.Saved.Player[PIndex].Inventory
                    PlayerInventory[Params.Index],  PlayerInventory[Params.Index + Step] = 
                    PlayerInventory[Params.Index + Step],  PlayerInventory[Params.Index]
                end

                mod.Counters.SinceSelect = 0
            end

            Params.Index = Params.Index + Step
        end
    end

    
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then

        if Params.Index < Params.OptionsNum then

            local Step = 0

            if Params.Mode == mod.SelectionParams.Modes.INVENTORY then
                
                local SlotsSkipped = 1

                for i = Params.Index + 1, Params.OptionsNum do
                    
                    print(i, mod.Saved.Player[PIndex].Inventory[i].Joker)
                    if mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                        Step = SlotsSkipped
                        break
                    end

                    SlotsSkipped = SlotsSkipped + 1
                end
            else
                Step = 1
            end

            --also holding ALT also makes you move the card itself 
            if Params.Mode ~= mod.SelectionParams.Modes.PACK
               and (Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, Player.ControllerIndex)
               or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, Player.ControllerIndex)) then

                Params.SelectedCards[Params.Mode][Params.Index], Params.SelectedCards[Params.Mode][Params.Index + Step] =
                Params.SelectedCards[Params.Mode][Params.Index + Step], Params.SelectedCards[Params.Mode][Params.Index]

                if Params.Mode == mod.SelectionParams.Modes.HAND then
                    
                    local PlayerHand = mod.Saved.Player[PIndex].CurrentHand
                    PlayerHand[Params.Index],  PlayerHand[Params.Index + Step] = 
                    PlayerHand[Params.Index + Step],  PlayerHand[Params.Index]
                else
                    
                    local PlayerInventory = mod.Saved.Player[PIndex].Inventory
                    PlayerInventory[Params.Index],  PlayerInventory[Params.Index + Step] = 
                    PlayerInventory[Params.Index + Step],  PlayerInventory[Params.Index]
                end

                mod.Counters.SinceSelect = 0
            end

            Params.Index = Params.Index + Step

        end
    end

    --while opening a pack, pressing up moves to the card selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, Player.ControllerIndex)
       and Params.Mode ~= mod.SelectionParams.Modes.INVENTORY then

        local DestinationMode
        --local IsPackActive = Params.PackPurpose ~= mod.SelectionParams.Purposes.NONE
        local CurrentMode = Params.Mode

        if CurrentMode == mod.SelectionParams.Modes.HAND
           or CurrentMode == mod.SelectionParams.Modes.NONE
           or not mod.Saved.EnableHand then
            
            DestinationMode = mod.SelectionParams.Modes.INVENTORY

        else --if CurrentMode == mod.SelectionParams.Modes.PACK then
    
            DestinationMode = mod.SelectionParams.Modes.HAND
        end

        mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)
    end


    --while opening a pack, pressing up moves to the pack selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, Player.ControllerIndex)
       and Params.Mode ~= mod.SelectionParams.Modes.PACK then

        local DestinationMode = Params.Mode + 0
        local IsPackActive = Params.PackPurpose ~= mod.SelectionParams.Purposes.NONE
        local CurrentMode = Params.Mode

        if CurrentMode == mod.SelectionParams.Modes.INVENTORY then
           
           
            if mod.Saved.EnableHand then

                DestinationMode = mod.SelectionParams.Modes.HAND
            else
                DestinationMode = mod.SelectionParams.Modes.NONE
            end

        elseif CurrentMode == mod.SelectionParams.Modes.HAND and IsPackActive then
    
            DestinationMode = mod.SelectionParams.Modes.PACK
        end

        mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)

    end

    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
        
        local CardToUse = mod:FrameToSpecialCard(mod.Saved.Player[PIndex].Consumables[#mod.Saved.Player[PIndex].Consumables].Card)
        local Success = mod:TJimboUseCard(CardToUse, Player, false)
        --print(Success)
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_DROP, Player.ControllerIndex) then

        local FirstCard

        for i, Consumable in ipairs(mod.Saved.Player[PIndex].Consumables) do
            
            if Consumable.Card ~= -1 then
                FirstCard = i
                break
            end
        end

        if FirstCard then
            local NumConsumables = #mod.Saved.Player[PIndex].Consumables
            
            table.insert(mod.Saved.Player[PIndex].Consumables, FirstCard, mod.Saved.Player[PIndex].Consumables[NumConsumables])
            table.remove(mod.Saved.Player[PIndex].Consumables, NumConsumables + 1)

            mod.Counters.SinceSelect = 0
        end
    end

    if Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, Player.ControllerIndex)
       or Input.IsButtonPressed(Keyboard.KEY_RIGHT_ALT, Player.ControllerIndex) then

        local Data = Player:GetData()
        if Data.ALThold ~= 0
           or Input.IsButtonTriggered(Keyboard.KEY_LEFT_ALT, Player.ControllerIndex)
           or Input.IsButtonTriggered(Keyboard.KEY_RIGHT_ALT, Player.ControllerIndex) then
            
            Data.ALThold = Data.ALThold and Data.ALThold + 1 or 0
        end

        if Data.ALThold >= 75 then

            local Success

            if mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.INVENTORY then
                
                local SelectedSlot = mod:GetValueIndex(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY], true, true) 

                if SelectedSlot then
                    Success = mod:SellJoker(Player, SelectedSlot)

                    mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY][SelectedSlot] = false
                
                    local JokerSlot

                    for i,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                        
                        if Slot.Joker ~= 0 then
                            JokerSlot = i
                            break
                        end
                    end

                    if JokerSlot then
                        mod.SelectionParams[PIndex].Index = JokerSlot

                    elseif mod.Saved.EnableHand then
                        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams[PIndex].Purpose)
                    else
                        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
                    end
                
                else
                    Success = false
                end
            else
                Success = mod:SellConsumable(Player)
            end

            if not Success then
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
            end
            Data.ALThold = 0
        end
    else
        Player:GetData().ALThold = 0
    end
    
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JimboInputHandle)


local function ActivateHandSelection()
    if not mod.GameStarted then
        return
    end

    if Game:GetRoom():IsClear() or true then
        for _,Player in ipairs(PlayerManager.GetPlayers()) do
            
            if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ActivateHandSelection)


function mod:UpdateCurrentHandType(Player)

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].PackPurpose == mod.SelectionParams.Purposes.CelestialPack then
    
        local Planet = mod.Planets.PLUTO - 1
        for i,v in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] then
                Planet = mod:FrameToSpecialCard(v)
            end
        end

        local PlanetHandType = 1 << (Planet - mod.Planets.PLUTO + 1) --gets the equivalent handtype

        mod.SelectionParams[PIndex].HandType = PlanetHandType

    elseif mod.Saved.EnableHand then
        mod.SelectionParams[PIndex].PossibleHandTypes = mod:DeterminePokerHand(Player)
        mod.SelectionParams[PIndex].HandType = mod:GetBitMaskMax(mod.SelectionParams[PIndex].PossibleHandTypes)
    end

    --print("hand type: ",mod.SelectionParams[PIndex].HandType)
    --[[
    if mod.SelectionParams[PIndex].HandType == mod.HandTypes.FIVE then
        mod.Saved.Player[PIndex].FiveUnlocked = true
    elseif mod.SelectionParams[PIndex].HandType == 11 then
        mod.Saved.Player[PIndex].FlushHouseUnlocked = true
    elseif mod.SelectionParams[PIndex].HandType == 12 then
        mod.Saved.Player[PIndex].FiveFlushUnlocked = true
    end
    ]]


end
mod:AddCallback(mod.Callbalcks.HAND_UPDATE, mod.UpdateCurrentHandType)



---@param Player EntityPlayer
function mod:SetupForHandPlay(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.SelectionParams[PIndex].PlayedCards = {}
    for i,Selected in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
        
        if Selected then
            mod.SelectionParams[PIndex].PlayedCards[#mod.SelectionParams[PIndex].PlayedCards+1] = mod.Saved.Player[PIndex].CurrentHand[i]
        end
    end

    mod.SelectionParams[PIndex].ScoringCards = mod:GetScoringCards(Player, mod.SelectionParams[PIndex].HandType)

    --[[could lead to problems with save states after leaving during a hand scoring
    for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do
        
        if mod:Contained(mod.SelectionParams[PIndex].PlayedCards, mod.Saved.Player[PIndex].CurrentHand[i]) then
            
            table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
        end
    end]]
    
    mod.AnimationIsPlaying = true
end
mod:AddPriorityCallback(mod.Callbalcks.HAND_PLAY, CallbackPriority.IMPORTANT, mod.SetupForHandPlay)




---@param Player EntityPlayer
function mod:ActivateCurrentHand(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    local TargetPosition

    for _,Target in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET)) do
        
        local Player = Target.Parent and Target.Parent:ToPlayer() or nil
        if Player and Player:GetPlayerType() == mod.Characters.TaintedJimbo then
            TargetPosition = Target.Position
            break
        end
    end

    if not TargetPosition then
        print("couldn't find shit, sorry!")
        return
    end

    

    print(Player:GetMarkedTarget())

end
mod:AddCallback(mod.Callbalcks.POST_HAND_PLAY, mod.ActivateCurrentHand)





---@param Player EntityPlayer
function mod:SetupForNextHandPlay(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex


    mod.Saved.Player[PIndex].HandsRemaining = mod.Saved.Player[PIndex].HandsRemaining - 1

    if mod.Saved.Player[PIndex].HandsRemaining <= 0 then
        Player:Kill()
    end


    for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do
        
        if mod:Contained(mod.SelectionParams[PIndex].PlayedCards, mod.Saved.Player[PIndex].CurrentHand[i]) then
            
            table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
        end
    end
    mod.SelectionParams[PIndex].PlayedCards = {}
    mod.SelectionParams[PIndex].ScoringCards = 0
    mod.SelectionParams[PIndex].HandType = mod.HandTypes.NONE
    mod.SelectionParams[PIndex].PossibleHandType = mod.HandTypes.NONE


    Player:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)
    local CurrentHandSize = Player:GetCustomCacheValue(mod.CustomCache.HAND_SIZE)
    local DeckSize = #mod.Saved.Player[PIndex].FullDeck - 1


    for i = #mod.Saved.Player[PIndex].CurrentHand, CurrentHandSize - 1 do

        if mod.Saved.Player[PIndex].DeckPointer > DeckSize then
            Player:Kill()
            return
        end
        
        table.insert(mod.Saved.Player[PIndex].CurrentHand, mod.Saved.Player[PIndex].DeckPointer)

        mod.Saved.Player[PIndex].DeckPointer = mod.Saved.Player[PIndex].DeckPointer + 1
    end
    

    --print("scoring: ", mod.SelectionParams[PIndex].ScoringCards)
    mod.Counters.SinceSelect = 0
    mod.AnimationIsPlaying = false

    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
end
mod:AddPriorityCallback(mod.Callbalcks.POST_HAND_PLAY, CallbackPriority.LATE, mod.SetupForNextHandPlay)


---@param Effect EntityEffect
local function MoveHandTarget(_,Effect)

    local Player = Effect.Parent and Effect.Parent:ToPlayer() or nil

    if not Player or Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    Game:GetRoom():GetCamera():SetFocusPosition(Effect.Position)

    Effect:AddVelocity(Player:GetAimDirection()*7)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, MoveHandTarget, EffectVariant.TARGET)


------------------STATS------------------
-----------------------------------------



---@param Player EntityPlayer
function mod:TJimboInventorySizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 3 --base starting point

    if Player:HasCollectible(mod.Vouchers.Antimatter) then
        Value = Value + 1
    end

    for _,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
        if Slot.Edition == mod.Edition.NEGATIVE then
            Value = Value + 1
        end
    end

    mod:AddJimboInventorySlots(Player, Value-#mod.Saved.Player[PIndex].Inventory)

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboInventorySizeCache, mod.CustomCache.INVENTORY_SIZE)


---@param Player EntityPlayer
function mod:TJimboHandSizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 8 --base starting point

    if Player:HasCollectible(mod.Vouchers.Brush) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Palette) then
        Value = Value + 1
    end

    Value = Value - 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.MERRY_ANDY)

    Value = Value + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)

    Value = Value - 3*#mod:GetJimboJokerIndex(Player, mod.Jokers.STUNTMAN, true)

    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, mod.Jokers.TURTLE_BEAN)) do
        Value = Value + mod.Saved.Player[PIndex].Progress.Inventory[Index]
    end

    Value = Value + #mod:GetJimboJokerIndex(Player, mod.Jokers.JUGGLER)
 

    Value = Value - mod.Saved.Player[PIndex].OuijaUses

    for i=1, mod.Saved.Player[PIndex].EctoUses do
        
        Value = Value - i
    end

    Value = math.max(0, Value) --btw it's an instant loss if your hand size is 0

    --[[
    local SizeDifference = Value - #mod.Saved.Player[PIndex].CurrentHand

    if SizeDifference > 0 then
        mod:ChangeJimboHandSize(Player, SizeDifference)
    end
    ]]

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboHandSizeCache, mod.CustomCache.HAND_SIZE)


---@param Player EntityPlayer
function mod:TJimboDiscardNumCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    Value = 3 --base starting point

    if Player:HasCollectible(mod.Vouchers.Wasteful) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Recyclomancy) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Petroglyph) then
        Value = Value - 1
    end

    Value = Value + 2*#mod:GetJimboJokerIndex(Player, mod.Jokers.MERRY_ANDY)
    
    Value = Value + #mod:GetJimboJokerIndex(Player, mod.Jokers.DRUNKARD)



    if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
        Value = 1
    end



    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboDiscardNumCache, mod.CustomCache.DISCARD_NUM)


---@param Player EntityPlayer
function mod:TJimboHandsCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    Value = 4 --starting point

    if Player:HasCollectible(mod.Vouchers.Grabber) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.NachoTong) then
        Value = Value + 1
    end

    Value = Value - 1* #mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)
    
    if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
        Value = Value + 3
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.Saved.Player[PIndex].HandsRemaining = Value

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboHandsCache, mod.CustomCache.HAND_NUM)

