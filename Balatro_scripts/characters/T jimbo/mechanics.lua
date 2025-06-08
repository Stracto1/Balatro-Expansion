
local mod = Balatro_Expansion

local Game = Game()
local Level = Game:GetLevel()
local ItemsConfig = Isaac.GetItemConfig()

local SMALL_BLIND_ROOMIDX = 0
local BIG_BLIND_ROOMIDX = 16

local SCREEN_TO_WORLD_RATIO = 4


----FUTURE GLOBALS -----
local AnteVoucher = mod.Vouchers.Grabber

local ShopRoomIndex = 0
local BossRoomIndex = 0
-----------------------------------


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

    if Params.Mode == mod.SelectionParams.Modes.NONE then
        return
    end

    ----------------------------------------

    --local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    
    -------------INPUT HANDLING------------------- (big ass if statements if lol)

    --confirming/canceling 
    if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
        and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)--usually they share buttons
        or Input.IsMouseBtnPressed(MouseButton.LEFT) then

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
               and (Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, Player.ControllerIndex)
               or Input.IsButtonPressed(Keyboard.KEY_RIGHT_ALT, Player.ControllerIndex)) then

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
            end

            Params.Index = Params.Index + Step

            mod.Counters.SinceSelect = 0
        end
    end

    
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then

        if Params.Index < Params.OptionsNum then

            local Step = 0

            if Params.Mode == mod.SelectionParams.Modes.INVENTORY then
                
                local SlotsSkipped = 1

                for i = Params.Index + 1, Params.OptionsNum do
                    
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
               and (Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, Player.ControllerIndex)
               or Input.IsButtonPressed(Keyboard.KEY_RIGHT_ALT, Player.ControllerIndex)) then

                Params.SelectedCards[Params.Mode][Params.Index], Params.SelectedCards[Params.Mode][Params.Index + Step] =
                Params.SelectedCards[Params.Mode][Params.Index + Step], Params.SelectedCards[Params.Mode][Params.Index]

                if Params.Mode == mod.SelectionParams.Modes.HAND then
                    
                    local PlayerHand = mod.Saved.Player[PIndex].CurrentHand
                    PlayerHand[Params.Index],  PlayerHand[Params.Index + Step] = 
                    PlayerHand[Params.Index + Step],  PlayerHand[Params.Index]
                else
                    
                    local PlayerInventory = mod.Saved.Player[PIndex].CurrentHand
                    PlayerInventory[Params.Index],  PlayerInventory[Params.Index + Step] = 
                    PlayerInventory[Params.Index + Step],  PlayerInventory[Params.Index]
                end
            end

            Params.Index = Params.Index + Step

            mod.Counters.SinceSelect = 0
        end
    end

    --while opening a pack, pressing up moves to the card selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, Player.ControllerIndex)
       and Params.Mode ~= mod.SelectionParams.Modes.INVENTORY then

        local DestinationMode
        --local IsPackActive = Params.PackPurpose ~= mod.SelectionParams.Purposes.NONE
        local CurrentMode = Params.Mode

        if CurrentMode == mod.SelectionParams.Modes.HAND then
            
            DestinationMode = mod.SelectionParams.Modes.INVENTORY

        elseif CurrentMode == mod.SelectionParams.Modes.PACK then
    
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

            DestinationMode = mod.SelectionParams.Modes.HAND

        elseif CurrentMode == mod.SelectionParams.Modes.HAND and IsPackActive then
    
            DestinationMode = mod.SelectionParams.Modes.PACK
        end

        mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)

    end

    --confirms the curretn selection
    if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then

        mod:UseSelection(Player)
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
        
        local CardToUse = mod:FrameToSpecialCard(mod.Saved.Player[PIndex].Consumables[#mod.Saved.Player[PIndex].Consumables].Card)
        local Success = mod:TJimboUseCard(CardToUse, Player, false)
        print(Success)
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











------------------STATS------------------
-----------------------------------------



---@param Player EntityPlayer
function mod:InventorySizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
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
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.InventorySizeCache, mod.CustomCache.INVENTORY_SIZE)


---@param Player EntityPlayer
function mod:HandSizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 5 --base starting point

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
 


    Value = Value - mod.Saved.Player[PIndex].EctoUses

    Value = math.max(1, Value) --minimum 1 card in hand

    local SizeDifference = Value - #mod.Saved.Player[PIndex].CurrentHand

    if SizeDifference > 0 then
        mod:ChangeJimboHandSize(Player, SizeDifference)
    end

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.HandSizeCache, mod.CustomCache.HAND_SIZE)


---@param Player EntityPlayer
function mod:DiscardNumCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
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

    --Value = math.max(1, Value) --minimum 1 discard

    mod.HpEnable = true
    Player:AddMaxHearts(Value*2 - Player:GetMaxHearts())
    mod.HpEnable = false

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.DiscardNumCache, mod.CustomCache.DISCARD_NUM)


---@param Player EntityPlayer
function mod:HandsCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.JimboType or not mod.GameStarted then
        return
    end

    Value = 25 --starting point

    if Player:HasCollectible(mod.Vouchers.Grabber) then
        Value = Value + 5
    end
    if Player:HasCollectible(mod.Vouchers.NachoTong) then
        Value = Value + 5
    end

    Value = Value - 5* #mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)
    
    if mod:JimboHasTrinket(Player, mod.Jokers.BURGLAR) then
        Value = 5
    end

    Value = math.max(Value ,5)

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.HandsCache, mod.CustomCache.HAND_NUM)

