
local mod = Balatro_Expansion

local Game = Game()

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



local function Test()

    Game:ChangeRoom(16)
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Test)


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

    ----------------------------------------

    local Data = Player:GetData()
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

        if mod.SelectionParams[PIndex].Index > 1 then
            mod.SelectionParams[PIndex].Index = mod.SelectionParams[PIndex].Index - 1

        end
    end

    
    --pressing down moves the selection to hand cards
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then

        if mod.SelectionParams[PIndex].Index < mod.SelectionParams[PIndex].OptionsNum then

            mod.SelectionParams[PIndex].Index = mod.SelectionParams[PIndex].Index + 1
        end
    end

    --while opening a pack, pressing up moves to the card selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, Player.ControllerIndex)
       and mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.PACK then

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams[PIndex].Purpose)
    end


    --while opening a pack, pressing up moves to the pack selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, Player.ControllerIndex)
       and mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.PACK, mod.SelectionParams[PIndex].Purpose)

    end

    --confirms the curretn selection
    if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex)
       and mod.SelectionParams[PIndex].Mode == mod.SelectionParams.Modes.HAND then

        mod:UseSelection(Player)
    end



    if Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, Player.ControllerIndex)
       or Input.IsButtonPressed(Keyboard.KEY_RIGHT_ALT, Player.ControllerIndex) then

        Data.ALThold = Data.ALThold + 1
        if Data.ALThold == 40 then --if held long enough starts the inventory selection
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
            Data.ALThold = 0
        end
    else
        Data.ALThold = 0
    end
    
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JimboInputHandle)


local function ActivateHandSelection()
    if not mod.GameStarted then
        return
    end

    if Game:GetRoom():IsClear() or true then
        for _,Player in ipairs(PlayerManager.GetPlayers()) do
            

            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ActivateHandSelection)