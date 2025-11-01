---@diagnostic disable: need-check-nil, cast-local-type

local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local TimerFixerVariable = 0
local BlindGotCleared = false --prevents blind clear callback to be called multiple times in the same frame

local MAX_BOSSRUSH_WAVES = 5

local AmbushWasActive = false
local PreviousWave = 0



local HAND_POOF_COLOR = Color(1,1,1,1,0,0,0,0.27,0.59, 1.5,1) --0.95

--local LevelDescriptorFlags = {SMALL_BLIND = 1 << 20, BIG_BLIND = 1 << 21, JIMBO_SHOP = 1 << 22}

mod.FullDoorSlot = {[RoomShape.ROOMSHAPE_1x1] = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_1x2] = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.LEFT1  | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.RIGHT1 | 1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_2x1] = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.DOWN1 | 1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_IH] = 1 << DoorSlot.LEFT0 |  1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_IIH] = 1 << DoorSlot.LEFT0 |  1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_IV] = 1 << DoorSlot.DOWN0,
                    [RoomShape.ROOMSHAPE_IIV] = 1 << DoorSlot.DOWN0,
                    FULL = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.RIGHT0 | 1 << DoorSlot.LEFT1 | 1 << DoorSlot.DOWN1 | 1 << DoorSlot.RIGHT1}


local SCREEN_TO_WORLD_RATIO = 4

local BASE_HAND_RADIUS = 30 --this gets increased by the handtype's base mult value (considering planet upgrades)


--due to *AHEM* design reasons greed mode is unplayable as TJimbo
--i cooould like try to remake everything just for that but like no one likes greed mode anyway
local function NO_GREED_MODE()

    if Game:IsGreedMode() and PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then

        Game:Spawn(1000, mod.Effects.JIMBO_THE_KILLER.VARIANT, Game:GetRoom():GetCenterPos(),
                   Vector.Zero, nil, mod.Effects.JIMBO_THE_KILLER.SUBTYPE.PLAYERS, 1)

        for i,v in ipairs(PlayerManager.GetPlayers()) do

            v:AnimateSad()

            if v:GetPlayerType() == mod.Characters.TaintedJimbo then

                if Game:IsHardMode() then

                    Isaac.SetCompletionMark(mod.Characters.TaintedJimbo, CompletionType.ULTRA_GREED, 2)
                    Isaac.SetCompletionMark(mod.Characters.TaintedJimbo, CompletionType.ULTRA_GREEDIER, 2)
                else
                    Isaac.SetCompletionMark(mod.Characters.TaintedJimbo, CompletionType.ULTRA_GREED, 1)
                    --Isaac.SetCompletionMark(mod.Characters.TaintedJimbo, CompletionType.ULTRA_GREEDIER, 2)
                end
            end
        end

        if Game:IsHardMode() then

            Game:RecordPlayerCompletion(CompletionType.ULTRA_GREEDIER)
        else
            Game:RecordPlayerCompletion(CompletionType.ULTRA_GREED)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, NO_GREED_MODE)



--setups variables for jimbo
---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.TaintedJimbo then
        local Data = player:GetData()

        Data.ConfirmHoldTime = 0 --used to detect if it got held or pressed
        Data.MapHoldTime = 0 --used to detect if it got held or pressed
        Data.ItemHoldTime = 0

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
local function SaveSpecialRoomsIndex(_,LevelGen,RoomConfig,Seed)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end
    
    local Level = Game:GetLevel()
    --print(RoomIndex)
    Level:GetRoomByIdx(LevelGen:Column() + LevelGen:Row()*13)

    if RoomConfig.Type == RoomType.ROOM_BOSS and (Level:GetStage() ~= LevelStage.STAGE7 or RoomConfig.Shape == RoomShape.ROOMSHAPE_2x2) then

        mod.Saved.BossIndex = LevelGen:Column() + LevelGen:Row()*13

    elseif RoomConfig.Type == RoomType.ROOM_SHOP then

        mod.Saved.ShopIndex = LevelGen:Column() + LevelGen:Row()*13
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, SaveSpecialRoomsIndex)




local function ResetSavedIndexes()

    mod.Saved.ShopIndex = nil
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, ResetSavedIndexes)



---@param Player EntityPlayer
function mod:TJimboAddConsumable(Player, card, Slot, StopAnimation, Edition)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Slot = Slot or 0
    Edition = Edition or mod.Edition.BASE

    local EmptySlot

    if mod:Contained(mod.Packs, card) then
        
        Player:UseCard(card)
        
        goto FINISH
    end

    
    for i = #mod.Saved.Player[PIndex].Consumables, 1, -1 do

        local Consumable = mod.Saved.Player[PIndex].Consumables[i]

        if Consumable.Card == -1 then
            EmptySlot = i
            break
        end
    end

    if Edition == mod.Edition.NEGATIVE then --puts the new negative as the first to be used
          
        EmptySlot = EmptySlot or #mod.Saved.Player[PIndex].Consumables + 1

        mod.Saved.Player[PIndex].Consumables[EmptySlot] = {}
    end

    if not EmptySlot then
        
        if not StopAnimation then
            Isaac.CreateTimer(function ()
                Player:AnimateSad()
            end,0,1,true)
        end

        return false
    end

    mod.Saved.Player[PIndex].Consumables[EmptySlot].Card = mod:SpecialCardToFrame(card)
    mod.Saved.Player[PIndex].Consumables[EmptySlot].Edition = Edition

    ::FINISH::

    Player:SetCard(Slot, Card.CARD_NULL)

    return true
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_ADD_CARD,CallbackPriority.IMPORTANT, mod.TJimboAddConsumable)




local function SetCustomCurses(Curses)

    return 0 --PLACEHOLDER
end
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, SetCustomCurses)



--makes basically every input possible when using T jimbo
---@param Player EntityPlayer
local function JimboInputHandle(_, Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end
    local PlayerData = Player:GetData()
    local PIndex = PlayerData.TruePlayerIndex
    local Params = mod.SelectionParams[PIndex]

    local IsInfoMenuActive = mod.Saved.RunInfoMode ~= mod.RunInfoModes.OFF
                             and mod.Saved.RunInfoMode ~= mod.RunInfoModes.PARTIAL_DECK

    ----------------------------------------

    --local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    
    -------------INPUT HANDLING-------------------

    if not IsInfoMenuActive then
        --confirms the current selection
        if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then

            mod:UseSelection(Player)
        end
    end


    if mod.AnimationIsPlaying then
        return
    end


    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then

        if mod.Saved.RunInfoMode == mod.RunInfoModes.POKER_HANDS then

            mod.Saved.RunInfoMode = mod.RunInfoModes.FULL_DECK

        elseif mod.Saved.RunInfoMode == mod.RunInfoModes.FULL_DECK then

            mod.Saved.RunInfoMode = mod.RunInfoModes.BLINDS

        elseif mod.Saved.RunInfoMode == mod.RunInfoModes.BLINDS then

            mod.Saved.RunInfoMode = mod.RunInfoModes.POKER_HANDS

        end
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) then

        if mod.Saved.RunInfoMode == mod.RunInfoModes.POKER_HANDS then

            mod.Saved.RunInfoMode = mod.RunInfoModes.BLINDS

        elseif mod.Saved.RunInfoMode == mod.RunInfoModes.FULL_DECK then

            mod.Saved.RunInfoMode = mod.RunInfoModes.POKER_HANDS

        elseif mod.Saved.RunInfoMode == mod.RunInfoModes.BLINDS then

            mod.Saved.RunInfoMode = mod.RunInfoModes.FULL_DECK

        end
    end


    if Input.IsActionPressed(ButtonAction.ACTION_MAP, Player.ControllerIndex) then

        if mod.Saved.RunInfoMode == mod.RunInfoModes.OFF then

            mod.Saved.RunInfoMode = mod.RunInfoModes.PARTIAL_DECK
        end

        PlayerData.MapHoldTime = PlayerData.MapHoldTime + 1

    elseif PlayerData.MapHoldTime ~= 0 then --button got released

        if PlayerData.MapHoldTime >= mod.HOLD_THRESHOLD then --released form holding
            
            if mod.Saved.RunInfoMode == mod.RunInfoModes.PARTIAL_DECK then

                mod.Saved.RunInfoMode = mod.RunInfoModes.OFF
            end

        else --realesed from pressing

            if mod.Saved.RunInfoMode == mod.RunInfoModes.PARTIAL_DECK then

                mod.Saved.RunInfoMode = mod.RunInfoModes.FULL_DECK

            else --if mod.Saved.RunInfoMode ~= mod.RunInfoModes.OFF then

                mod.Saved.RunInfoMode = mod.RunInfoModes.OFF
            end
        end


        PlayerData.MapHoldTime = 0
    end


    --checks again in case it changed during input reading above
    IsInfoMenuActive = mod.Saved.RunInfoMode ~= mod.RunInfoModes.OFF
                       and mod.Saved.RunInfoMode ~= mod.RunInfoModes.PARTIAL_DECK

    
    if IsInfoMenuActive then
        return
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Player.ControllerIndex) then
        local Success = mod:DiscardSelection(Player)
    end

    
    if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) then
        
        --confirming/canceling 

        --if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex) 
        --   and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
        --
        --    mod:Select(Player)
        --end

        PlayerData.ConfirmHoldTime = PlayerData.ConfirmHoldTime + 1

    else
        if PlayerData.ConfirmHoldTime > 0 
           and PlayerData.ConfirmHoldTime <= mod.HOLD_THRESHOLD then --button got released while pressing (not holding)

            mod:Select(Player)
        end

        PlayerData.ConfirmHoldTime = 0
    end


    local MinHoldTime = 9
    
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then

        local Step = 0

        if Params.Mode == mod.SelectionParams.Modes.INVENTORY then
                
                local SlotsSkipped = 1

                for i = Params.Index + 1, Params.OptionsNum do

                    local Slot = mod.Saved.Player[PIndex].Inventory[i]
                    
                    --print(i, mod.Saved.Player[PIndex].Inventory[i].Joker)
                    if Slot and Slot.Joker ~= 0 then
                        Step = SlotsSkipped
                        break
                    end

                    SlotsSkipped = SlotsSkipped + 1
                end

        elseif Params.Mode == mod.SelectionParams.Modes.CONSUMABLES then
                
                local SlotsSkipped = 1

                for i = Params.Index + 1, Params.OptionsNum do

                    local Slot = mod.Saved.Player[PIndex].Consumables[i]
                    
                    --print(i, mod.Saved.Player[PIndex].Inventory[i].Joker)
                    if Slot and Slot.Card ~= -1 then
                        Step = SlotsSkipped
                        break
                    end

                    SlotsSkipped = SlotsSkipped + 1
                end

        elseif Params.Mode == mod.SelectionParams.Modes.HAND then

            if Params.Index == Params.OptionsNum then --last card in hand
                Step = 0
            else
                Step = 1
            end

        elseif Params.Mode == mod.SelectionParams.Modes.PACK then

                if Params.Index == #Params.PackOptions then --last card in hand
                    Step = 0
                else
                    Step = 1
                end
        else
            Step = 1
        end


        if Step == 0 then --can't move cause it's the last option
            
            if Params.Mode == mod.SelectionParams.Modes.INVENTORY then --only thing after the jokers are the consumables

                local First
            
                for i = 1, #mod.Saved.Player[PIndex].Consumables do

                    if mod.Saved.Player[PIndex].Consumables[i].Card ~= -1 then
                        
                        First = i
                        break
                    end
                end
            
                if First then
                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.CONSUMABLES, mod.SelectionParams.Purposes.NONE)
                    
                    Params.Index = First

                else
                    local First = 1

                    for i = 1, #mod.Saved.Player[PIndex].Inventory do

                        if mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then

                            First = i
                            break
                        end
                    end

                    Params.Index = First
                end
                
            elseif Params.Mode == mod.SelectionParams.Modes.CONSUMABLES then

                local First = 1

                for i = 1, #mod.Saved.Player[PIndex].Consumables do

                    if mod.Saved.Player[PIndex].Consumables[i].Card ~= -1 then
                        
                        First = i
                        break
                    end
                end

                Params.Index = First


            else

                Params.Index = 1
            end
        
        --also holding ALT also makes you move the card itself 
        elseif Params.Mode ~= mod.SelectionParams.Modes.PACK
               and PlayerData.ConfirmHoldTime >= MinHoldTime then

                Params.SelectedCards[Params.Mode][Params.Index], Params.SelectedCards[Params.Mode][Params.Index + Step] =
                Params.SelectedCards[Params.Mode][Params.Index + Step], Params.SelectedCards[Params.Mode][Params.Index]

                if Params.Mode == mod.SelectionParams.Modes.HAND then
                    
                    local PlayerHand = mod.Saved.Player[PIndex].CurrentHand
                    PlayerHand[Params.Index],  PlayerHand[Params.Index + Step] = 
                    PlayerHand[Params.Index + Step],  PlayerHand[Params.Index]

                elseif Params.Mode == mod.SelectionParams.Modes.CONSUMABLES then
                    
                    local PlayerConsumables = mod.Saved.Player[PIndex].Consumables
                    PlayerConsumables[Params.Index],  PlayerConsumables[Params.Index + Step] = 
                    PlayerConsumables[Params.Index + Step],  PlayerConsumables[Params.Index]
                else
                    
                    local PlayerInventory = mod.Saved.Player[PIndex].Inventory
                    PlayerInventory[Params.Index],  PlayerInventory[Params.Index + Step] = 
                    PlayerInventory[Params.Index + Step],  PlayerInventory[Params.Index]

                    --local JokerProgs = mod.Saved.Player[PIndex].Inventory
                    --JokerProgs[Params.Index],  JokerProgs[Params.Index + Step] = 
                    --JokerProgs[Params.Index + Step],  JokerProgs[Params.Index]

                end

                mod.Counters.SinceSelect = 0
        end

        Params.Index = Params.Index + Step

    end



    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) then


        local Step = 0

        if Params.Mode == mod.SelectionParams.Modes.INVENTORY then
                
            local SlotsSkipped = 1

            for i = Params.Index - 1, 1, -1 do

                local Slot = mod.Saved.Player[PIndex].Inventory[i]
                
                --print(i, mod.Saved.Player[PIndex].Inventory[i].Joker)
                if Slot and Slot.Joker ~= 0 then
                    Step = -SlotsSkipped
                    break
                end

                SlotsSkipped = SlotsSkipped + 1
            end

        elseif Params.Mode == mod.SelectionParams.Modes.CONSUMABLES then
                
            local SlotsSkipped = 1

            for i = Params.Index - 1, 1, -1 do

                local Slot = mod.Saved.Player[PIndex].Consumables[i]
                
                --print(i, mod.Saved.Player[PIndex].Inventory[i].Joker)
                if Slot and Slot.Card ~= -1 then
                    Step = -SlotsSkipped
                    break
                end

                SlotsSkipped = SlotsSkipped + 1
            end

        elseif Params.Mode == mod.SelectionParams.Modes.HAND then

            if Params.Index == 1 then --last card in hand
                Step = 0
            else
                Step = -1
            end

        elseif Params.Mode == mod.SelectionParams.Modes.PACK then

            if Params.Index == 1 then --first card in hand
                Step = 0
            else
                Step = -1
            end

        end


        if Step == 0 then --can't move cause it's the first option
            
            if Params.Mode == mod.SelectionParams.Modes.CONSUMABLES then --only thing before consumables are the jokers

                local Last

                for i = #mod.Saved.Player[PIndex].Inventory, 1, -1  do

                    if mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                        
                        Last = i
                        break
                    end
                end
            
                if Last then --if he has a joker, go to that seciton
            
                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
                
                    Params.Index = Last

                else --otherwise go to the last consumable

                    Last = 1

                    for i = #mod.Saved.Player[PIndex].Consumables, 1, -1 do

                        if mod.Saved.Player[PIndex].Consumables[i].Card ~= -1 then

                            Last = i
                            break
                        end
                    end

                    Params.Index = Last

                end

            elseif Params.Mode == mod.SelectionParams.Modes.INVENTORY then

                local Last = 1

                for i = #mod.Saved.Player[PIndex].Inventory, 1, -1 do

                    if mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                        
                        Last = i
                        break
                    end
                end

                Params.Index = Last


            else
                Params.Index = Params.OptionsNum
            end
        
        --also holding ALT also makes you move the card itself 
        elseif Params.Mode ~= mod.SelectionParams.Modes.PACK
               and PlayerData.ConfirmHoldTime >= MinHoldTime then

            Params.SelectedCards[Params.Mode][Params.Index], Params.SelectedCards[Params.Mode][Params.Index + Step] =
            Params.SelectedCards[Params.Mode][Params.Index + Step], Params.SelectedCards[Params.Mode][Params.Index]

            if Params.Mode == mod.SelectionParams.Modes.HAND then
                
                local PlayerHand = mod.Saved.Player[PIndex].CurrentHand
                PlayerHand[Params.Index],  PlayerHand[Params.Index + Step] = 
                PlayerHand[Params.Index + Step],  PlayerHand[Params.Index]


            elseif Params.Mode == mod.SelectionParams.Modes.CONSUMABLES then
                
                local PlayerConsumables = mod.Saved.Player[PIndex].Consumables
                PlayerConsumables[Params.Index],  PlayerConsumables[Params.Index + Step] = 
                PlayerConsumables[Params.Index + Step],  PlayerConsumables[Params.Index]
            else
                    
                local PlayerInventory = mod.Saved.Player[PIndex].Inventory
                PlayerInventory[Params.Index],  PlayerInventory[Params.Index + Step] = 
                PlayerInventory[Params.Index + Step],  PlayerInventory[Params.Index]

                --local JokerProgs = mod.Saved.Player[PIndex].Inventory
                --JokerProgs[Params.Index],  JokerProgs[Params.Index + Step] = 
                --JokerProgs[Params.Index + Step],  JokerProgs[Params.Index]
            end

            mod.Counters.SinceSelect = 0
        end

        Params.Index = Params.Index + Step

        ::END_INPUT::
    end


    if (Player:HasCollectible(mod.Vouchers.Director)
       or Player:HasCollectible(mod.Vouchers.Retcon))
       and mod.Saved.BlindBeingPlayed == mod.BLINDS.NONE then
       
        if Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
        
            PlayerData.ItemHoldTime = PlayerData.ItemHoldTime + 1
        else


            if PlayerData.ItemHoldTime ~= 0
               and (mod:PlayerCanAfford(10)
                    and (mod.Saved.NumBossRerolls == 0
                         or Player:HasCollectible(mod.Vouchers.Retcon))) then
                
                mod:SpendMoney(10)

                mod:RerollBossBlind()

                mod.Saved.NumBossRerolls = mod.Saved.NumBossRerolls + 1
            end

            PlayerData.ItemHoldTime = 0
        end
    end

    
    if Input.IsActionTriggered(ButtonAction.ACTION_DROP, Player.ControllerIndex) then

        if mod.Saved.HandOrderingMode == mod.HandOrderingModes.Rank then

            mod.Saved.HandOrderingMode = mod.HandOrderingModes.Suit
        else
            mod.Saved.HandOrderingMode = mod.HandOrderingModes.Rank
        end

        mod:ReorderHand(Player)
    end


    if Params.Purpose & mod.SelectionParams.Purposes.FORCED_FLAG ~= 0 then
        return
    end


    --while opening a pack, pressing up moves to the card selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, Player.ControllerIndex) then

        local DestinationMode
        --local IsPackActive = Params.PackPurpose ~= mod.SelectionParams.Purposes.NONE
        local CurrentMode = Params.Mode

        if CurrentMode == mod.SelectionParams.Modes.HAND
           or CurrentMode == mod.SelectionParams.Modes.NONE
           or not mod.Saved.EnableHand then

            local First 

            for i = 1, #mod.Saved.Player[PIndex].Inventory do
                
                if mod.Saved.Player[PIndex].Inventory[i].Joker ~= 0 then
                    First = i
                    break
                end
            end

            if First then
                DestinationMode = mod.SelectionParams.Modes.INVENTORY

            else --try going to the consumables instead

                for i = 1, #mod.Saved.Player[PIndex].Consumables do

                    if mod.Saved.Player[PIndex].Consumables[i].Card ~= -1 then
                        First = i
                        break
                    end
                end

                if First then
                    DestinationMode = mod.SelectionParams.Modes.CONSUMABLES
                end

            end

        elseif CurrentMode == mod.SelectionParams.Modes.PACK then
    
            DestinationMode = mod.SelectionParams.Modes.HAND
        end

        if DestinationMode then
            mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)
        end
    end


    --while opening a pack, pressing up moves to the pack selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, Player.ControllerIndex) then

        local DestinationMode
        local DestinationPurpose
        local IsPackActive = Params.PackPurpose ~= mod.SelectionParams.Purposes.NONE
        local CurrentMode = Params.Mode

        if CurrentMode == mod.SelectionParams.Modes.INVENTORY
           or CurrentMode == mod.SelectionParams.Modes.CONSUMABLES then
           
           
            if mod.Saved.EnableHand then

                DestinationMode = mod.SelectionParams.Modes.HAND
                DestinationPurpose = mod.SelectionParams.Purposes.HAND
            else
                DestinationMode = mod.SelectionParams.Modes.NONE
            end

        elseif CurrentMode == mod.SelectionParams.Modes.HAND and IsPackActive then
    
            DestinationMode = mod.SelectionParams.Modes.PACK
        end

        


        if DestinationMode then
            mod:SwitchCardSelectionStates(Player, DestinationMode, DestinationPurpose or Params.Purpose)
        end

    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JimboInputHandle)



local function SetupRoom()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    BlindGotCleared = false

    local Room = Game:GetRoom()

    local RoomDesc = Game:GetLevel():GetCurrentRoomDesc()

    --RoomDesc:AddRestrictedGridIndex(Room:GetGridIndex(Room:GetDoorSlotPosition(DoorSlot.UP0)))
    --RoomDesc:AddRestrictedGridIndex(Room:GetGridIndex(Room:GetDoorSlotPosition(DoorSlot.UP1)))

    if Room:GetType() == RoomType.ROOM_BOSSRUSH then
        Ambush.SetMaxBossrushWaves(MAX_BOSSRUSH_WAVES)
    end


    if Room:IsClear() then
        return
    end


    --print("ROOM HOLSTILE AAAAAAAAAAAAAAAAAaa")

    local RoomIndex = RoomDesc.SafeGridIndex

    if mod:IsRotgutDungeon() then
        
        if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_NEEDLE then
            
            mod.Saved.HandsRemaining = 1 --restores one hand per room since it would be impossible otherwise
        else
            mod.Saved.HandsRemaining = math.max(mod.Saved.HandsRemaining, 1)
        end

    elseif RoomIndex ~= mod.Saved.SmallBlindIndex
       and RoomIndex ~= mod.Saved.BigBlindIndex
       and RoomIndex ~= mod.Saved.BossIndex
       and not mod:IsMotherBossRoom()
       and not mod:IsTaintedHeartBossRoom()
       and not mod:IsBeastBossRoom()
       and not mod:IsMegaSatanBossRoom() then

        --print("REMOVEIN ALL")
        
        for _,Entity in ipairs(Isaac.GetRoomEntities()) do --just to be safe

            if Entity:IsActiveEnemy() then
                Entity:Remove()
            end
        end

        return
    end
       

    ---remove all fires

    for i,Entity in ipairs(Isaac.GetRoomEntities()) do

        if Entity:IsEnemy() and not Entity:IsActiveEnemy() and not Entity:IsVulnerableEnemy() then
            Entity:Kill()
        end
    end

    --remove all poops

    for i = 0, Room:GetGridSize() do

        local Grid = Room:GetGridEntity(i)

        --Grid = Grid and Grid:ToPoop() or Grid

        if Grid and Grid:ToPoop() then

            Grid = Grid:ToPoop()
            
            Grid:Destroy()

            if Grid:GetVariant() == GridPoopVariant.RED then
               
                Grid.ReviveTimer = -1
            end

        end
    end


    local Width = Room:GetGridWidth()
    local Height = Room:GetGridHeight()

    for i=2, Width-1, 2 do
        local Position = Room:GetGridPosition(i + math.random(2, Height-1)*Width)

        local Ent = Game:Spawn(mod.Entities.BALATRO_TYPE, mod.Entities.NPC_SLAVE, Position,
                               Vector.Zero, nil, 0, 1)

        Ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    end

    for i=2, Height-1, 2 do
        local Position = Room:GetGridPosition(math.random(2, Width-1) +i*Width)

        Game:Spawn(mod.Entities.BALATRO_TYPE, mod.Entities.NPC_SLAVE, Position,
                   Vector.Zero, nil, 0, 1)

    end


    
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SetupRoom)


---@param Player EntityPlayer
local function NoJokerCollision(_, Player, Collider, _)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo
       and (Player:GetPlayerType() ~= mod.Characters.JimboType
            or mod:GetPlayerTrinketAmount(Player, mod.Jokers.CAMPFIRE) ~= 0)  then
        return    
    end

    ---@type EntityPickup
    local Pickup = Collider:ToPickup()

    if not Pickup 
       or Pickup.Variant ~= PickupVariant.PICKUP_TRINKET
       or (Pickup.SubType & mod.EditionFlag.ALL) >> mod.EDITION_FLAG_SHIFT == mod.Edition.NEGATIVE then
        return
    end

    local HasEmpty = false

    for _,Slot in ipairs(mod.Saved.Player[Player:GetData().TruePlayerIndex].Inventory) do
        
        if Slot.Joker == 0 then
            HasEmpty = true
            break
        end
    end

    if not HasEmpty then
        
        if Pickup:IsShopItem() then
            return true
        else
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, NoJokerCollision, PlayerVariant.PLAYER)



---@param NPC EntityNPC
---@param Target Entity
local function PreventTjimboTarget(_, NPC, Target)

    local Player = Target:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.TaintedJimbo
       or mod:IsTJimboVulnerable() then
        return
    end

    --Tjimbo shouldn't be targeted by enemies, so make them move semi-randomly against entities spawned in SpawnAdditionalTargets()

    local PossibleTargets = Isaac.FindByType(mod.Entities.BALATRO_TYPE, mod.Entities.NPC_SLAVE)

    local NewTarget = mod:GetRandom(PossibleTargets)

    if NewTarget then
        NPC:TryForceTarget(NewTarget, 25) --puts a timer in between the target changes so the enemies don't look like they're having a seizure
    end

    return NewTarget
end
mod:AddCallback(ModCallbacks.MC_NPC_PICK_TARGET, PreventTjimboTarget)



function mod:SpawnShopItems(Rerolled, CouponUsed)

    local Room = Game:GetRoom()

    if Rerolled then

        --remove the old items to the spawn the new ones
        
        for _,Entity in ipairs(Isaac.GetRoomEntities()) do
        
            if Entity.Type == EntityType.ENTITY_PICKUP
               and (Entity.Variant == PickupVariant.PICKUP_TRINKET
                   or Entity.Variant == mod.Pickups.PLAYING_CARD
                   or (Entity.Variant == PickupVariant.PICKUP_TAROTCARD
                       and not mod:Contained(mod.Packs, Entity.SubType))) then

                Entity:Remove()
            end
        end
    end

    local NumItems = 2

    if PlayerManager.AnyoneHasCollectible(mod.Vouchers.OverstockPlus) then
        NumItems = 4
    elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Overstock) then
        NumItems = 3
    end

    for i=1, NumItems do

        local Variant, SubType, TagActivated, Item

        local Grid = 66 - NumItems + i*2

        local ItemPos = Room:GetGridPosition(Grid)

        if not Rerolled --the removed items still appear in FindInRadius even if updated
           and Isaac.FindInRadius(ItemPos, 10, EntityPartition.PICKUP)[1] then

            goto SKIP_ITEM
        end

        Variant, SubType, TagActivated = mod:RandomShopItem(mod.RNGs.SHOP)


        Item = Game:Spawn(EntityType.ENTITY_PICKUP, Variant, ItemPos,
                                Vector.Zero, nil, SubType, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()


        if TagActivated or not CouponUsed then
            ---@diagnostic disable-next-line: need-check-nil
            Item:MakeShopItem(-2)
        end

        ::SKIP_ITEM::
    end

    local Level = Game:GetLevel()

    if Level:GetStage() == LevelStage.STAGE1_2 and Level:IsAltStage() then
        
        local Grid = 78

        local ItemPos = Room:GetGridPosition(Grid)

        local Variant, SubType = 100, CollectibleType.COLLECTIBLE_KNIFE_PIECE_1


        Item = Game:Spawn(EntityType.ENTITY_PICKUP, Variant, ItemPos,
                                Vector.Zero, nil, SubType, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()


        ---@diagnostic disable-next-line: need-check-nil
        Item:MakeShopItem(-2)
    end

end


--changes the shop items to be in a specific pattern
local function ShopItemChanger()

    local Room = Game:GetRoom()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo)
       or Room:GetType() ~= RoomType.ROOM_SHOP then

        return
    end

    if Room:IsFirstVisit() then --removes any item that was previously put in the shop ant the restock machine
        
        for _,Entity in ipairs(Isaac.GetRoomEntities()) do
        
            if Entity.Type == EntityType.ENTITY_PICKUP or Entity.Type == EntityType.ENTITY_SLOT then

                Entity:Remove()
            end
        end


        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.RerollGlut) then
            mod.Saved.RerollStartingPrice = 1
        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.RerollSurplus) then
            mod.Saved.RerollStartingPrice = 3
        else
            mod.Saved.RerollStartingPrice = 5
        end
        
        for i, Tag in ipairs(mod.Saved.SkipTags) do
            
            if Tag == mod.SkipTags.D6 then
                
                mod:UseSkipTag(i)
                mod.Saved.RerollStartingPrice = 0

                break --don't use more then one
            end
        end

        local OnSpawnPrice

        for _, Player in ipairs(PlayerManager.GetPlayers()) do
            
            if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
                
                local PIndex = Player:GetData().TruePlayerIndex

                for i, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                    
                    if Slot.Joker == mod.Jokers.CHAOS_CLOWN then
                    
                        if mod.Saved.Player[PIndex].Inventory[i].Progress == 1 then
                            
                            mod.Saved.Player[PIndex].Inventory[i].Progress = 0

                            OnSpawnPrice = 0

                            break
                        end
                    end
                end

                if OnSpawnPrice then
                    break
                end
            end
        end

        OnSpawnPrice = OnSpawnPrice or (mod.Saved.RerollStartingPrice + 0)


        mod:SpawnBalatroPressurePlate(Room:GetGridPosition(86), mod.Grids.PlateVariant.SHOP_EXIT, 0)

        mod:SpawnBalatroPressurePlate(Room:GetGridPosition(56), mod.Grids.PlateVariant.REROLL, OnSpawnPrice)


        local Voucher = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Room:GetGridPosition(95),
                                   Vector.Zero, nil, mod.Saved.AnteVoucher, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()

---@diagnostic disable-next-line: need-check-nil
        Voucher:MakeShopItem(-2)

    else --removes everything exept for the booster packs and the ante voucher
        for _,Entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        
            if (Entity.Variant ~= PickupVariant.PICKUP_TAROTCARD 
                or not mod:Contained(mod.Packs, Entity.SubType))
               and (Entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE
                    or Entity.SubType ~= mod.Saved.AnteVoucher) then

                Entity:Remove()
            end
        end

    end

    local CouponTag = false

    for i, Tag in ipairs(mod.Saved.SkipTags) do

        if Tag == mod.SkipTags.VOUCHER then

            mod:UseSkipTag(i)
            
            local Voucher = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Room:FindFreePickupSpawnPosition(Room:GetGridPosition(95),0, true),
                                   Vector.Zero, nil, mod.Saved.AnteVoucher, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()

            ---@diagnostic disable-next-line: need-check-nil
            Voucher:MakeShopItem(-2)

        elseif Tag == mod.SkipTags.COUPON and not CouponTag then

            CouponTag = true
            mod:UseSkipTag(i)
        end
    end


    mod:SpawnShopItems(false, CouponTag)

    for i=1, 2 do
        
        local Grid = 95 + i*2
        local Pack = mod:RandomPack(mod.RNGs.SHOP, true)

        local Booster =  Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Room:GetGridPosition(Grid),
                   Vector.Zero, nil, Pack, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()

        if not CouponTag then
            ---@diagnostic disable-next-line: need-check-nil
            Booster:MakeShopItem(-2)
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ShopItemChanger)


local function SetItemPrices(_,Variant,SubType,ShopID,Price)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    Game:GetLevel():GetCurrentRoomDesc().ShopItemDiscountIdx = -1 --no discounts ever

    if Price == PickupPrice.PRICE_FREE then
        return Price
    end


    local Cost = 1
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then

        Cost = 10

    elseif Variant == PickupVariant.PICKUP_TRINKET then --jokers

        local Joker = SubType & ~mod.EditionFlag.ALL
        local Edition = (SubType & mod.EditionFlag.ALL)>>mod.EDITION_FLAG_SHIFT
    
        Cost = mod:GetJokerCost(Joker, Edition)

    elseif Variant == PickupVariant.PICKUP_TAROTCARD then
        
        if SubType >= mod.Packs.ARCANA and SubType <= mod.Packs.MEGA_SPECTRAL then

            local QualityModule = SubType%3

            if QualityModule == mod.PackQualityModule.MEGA then
                Cost = 8
            elseif QualityModule == mod.PackQualityModule.JUMBO then
                Cost = 6
            else
                Cost = 4
            end

        elseif SubType >= mod.Spectrals.FAMILIAR and SubType <= mod.Spectrals.SOUL then
            Cost = 4
        else
            Cost = 3
        end

    elseif Variant == mod.Pickups.PLAYING_CARD then

        Cost = 1
    end

    if Variant ~= PickupVariant.PICKUP_TRINKET then --these are already included in GetJokerCost()

        if PlayerManager.AnyoneHasCollectible(mod.Vouchers.Liquidation) then --50% off
        
            Cost = Cost * 0.5

        elseif PlayerManager.AnyoneHasCollectible(mod.Vouchers.Clearance) then --25% off
            Cost = Cost * 0.75

        end
    end

    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        if mod:JimboHasTrinket(Player, mod.Jokers.ASTRONOMER) then

            if Variant ~= PickupVariant.PICKUP_TAROTCARD then

                break
            end

            if not ((SubType > mod.Planets.PLUTO and SubType < mod.Planets.SUN)
                    or SubType == mod.Packs.CELESTIAL
                    or SubType == mod.Packs.JUMBO_CELESTIAL
                    or SubType == mod.Packs.MEGA_CELESTIAL) then

                break
            end

            Cost = 0

        end
    end


    Cost = math.floor(Cost) --rounds it down 
    Cost = math.max(Cost, 1)

    return Cost
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, SetItemPrices)


function mod:UpdateRerollPrice(RerollPlate)

    if not RerollPlate then
        
        for i = 0, Game:GetRoom():GetGridSize() do

            local GridEntity = Game:GetRoom():GetGridEntity(i)

            if GridEntity
               and GridEntity:GetType() == GridEntityType.GRID_PRESSURE_PLATE
               and GridEntity:GetVariant() == mod.Grids.PlateVariant.REROLL then

                RerollPlate = GridEntity

                break --only 1 per room usually
            end
        end

    end

    if not RerollPlate then
        return
    end


    local OldPrice = RerollPlate.VarData + 0
    local NewPrice

    local NumClowns = 0

    for _, Player in ipairs(PlayerManager.GetPlayers()) do
            
        if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
            
            local PIndex = Player:GetData().TruePlayerIndex

            for i, Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do
                
                if Slot.Joker == mod.Jokers.CHAOS_CLOWN then
                
                    NumClowns = NumClowns + 1

                    if mod.Saved.Player[PIndex].Inventory[i].Progress == 1 then
                        
                        if not NewPrice and OldPrice ~= 0 then --only the first time deactivates a chaos clown
                            
                            mod.Saved.Player[PIndex].Inventory[i].Progress = 0
                        end

                        NewPrice = 0
                    end
                end
            end
        end
    end


    NewPrice = NewPrice or (mod.Saved.RerollStartingPrice + (mod.Saved.NumShopRerolls - NumClowns))
    

    RerollPlate.VarData = NewPrice
end



----------HANDS SYSTEM----------
--------------------------------


function mod:UpdateCurrentHandType(Player)

    local PIndex = Player:GetData().TruePlayerIndex

    if mod.SelectionParams[PIndex].PackPurpose & ~mod.SelectionParams.Purposes.MegaFlag == mod.SelectionParams.Purposes.CelestialPack then
    
        local Planet = mod.Planets.PLUTO - 1
        for i,v in ipairs(mod.SelectionParams[PIndex].PackOptions) do
            if mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK][i] then
                Planet = mod:FrameToSpecialCard(v)
            end
        end

        local PlanetHandType = (Planet - mod.Planets.PLUTO + 2) --gets the equivalent handtype

        mod.Saved.HandType = PlanetHandType

    elseif mod.Saved.EnableHand then
        mod.Saved.PossibleHandTypes = mod:DeterminePokerHand(Player)
        mod.Saved.HandType = mod:GetHandTypeFromFlag(mod.Saved.PossibleHandTypes)
    end


    mod.Saved.MultValue = mod.Saved.HandsStat[mod.Saved.HandType].Mult
    mod.Saved.ChipsValue = mod.Saved.HandsStat[mod.Saved.HandType].Chips


    local ShouldWarn = false

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_PSYCHIC then
        
        local PlayedCards = {}

        for i,v in ipairs(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]) do
            if v then
                PlayedCards[#PlayedCards+1] = i
            end
        end

        if #PlayedCards < 5 then
            ShouldWarn = true
        end

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_EYE then
        
        local HandFlag = 1 << mod.Saved.HandType

        if mod.Saved.BossBlindVarData & HandFlag ~= 0 then --if hand got already played
            ShouldWarn = true
        end

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_MOUTH then
        
        local HandFlag = 1 << mod.Saved.HandType

        if mod.Saved.BossBlindVarData ~= 0  --if no hand was played yet
           and mod.Saved.BossBlindVarData & HandFlag == 0 then --if hand didn't get played
            ShouldWarn = true
        end
    end

    if ShouldWarn then
        mod.ScreenStrings.Warning = {Name = mod:GetEIDString("Warning", "Title"),
                                     String = "["..string.upper(mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)).."]: "..mod:GetEIDString("Warning", mod.Saved.BlindBeingPlayed),
                                     StartFrame = Isaac.GetFrameCount(),
                                     Type = mod.Saved.BlindBeingPlayed}

        mod.ScreenStrings.Warning.String = mod:ReplaceBalatroMarkups(mod.ScreenStrings.Warning.String, mod.EID_DescType.WARNING, mod.Saved.BlindBeingPlayed, true)
        
    else
        mod.ScreenStrings.Warning = {}
    end
end
mod:AddCallback(mod.Callbalcks.HAND_UPDATE, mod.UpdateCurrentHandType)



---@param Player EntityPlayer
function mod:ActivateCurrentHand(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    mod.AnimationIsPlaying = true

    local PIndex = Player:GetData().TruePlayerIndex

    local TargetPosition
    

    for _,Target in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET)) do
        
        local Player = Target.Parent and Target.Parent:ToPlayer() or nil
        if Player and Player:GetPlayerType() == mod.Characters.TaintedJimbo then
            TargetPosition = Target.Position
            Target:Remove()
        end
    end

    if not TargetPosition then
        print("couldn't find shit, sorry!")
        return
    end


    local HandHype = mod.Saved.HandType

    local BaseHandMult = mod.Saved.HandsStat[HandHype].Mult

    local FullHandDamage = mod.Saved.TotalScore + 0


    local EFFECT_RANGE = BASE_HAND_RADIUS*BaseHandMult
    EFFECT_RANGE = EFFECT_RANGE * (EFFECT_RANGE/40)^0.85


    local BloodColor = Color()
    BloodColor:SetColorize(mod.EffectColors.BLUE.R, mod.EffectColors.BLUE.G, mod.EffectColors.BLUE.B, 1.5)


    sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK,0.6,0)
    sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.6, 2, false, 0.75)
    Game:SpawnParticles(TargetPosition, EffectVariant.BLOOD_DROP, 3, 10, BloodColor, nil, 1)

    for i=1, 3 + EFFECT_RANGE//10 do
        
        local drop = Game:Spawn(1000, 70, TargetPosition, RandomVector()*math.random(5,8), nil, 1, mod:RandomSeed())
        drop.PositionOffset = Vector(0,-15)
        drop:SetColor(BloodColor, -1, 1, false, false)
    end

    local PoofScale = 0.45 * BaseHandMult
    mod:TrueBloodPoof(TargetPosition, PoofScale, HAND_POOF_COLOR)

    Game:MakeShockwave(TargetPosition, 0.0003*EFFECT_RANGE, 0.025, 6)


    --enemies inside the radius shown take damage twice, others only once


    local OutOfRangeMult = mod.Saved.DSS.T_Jimbo.OutOfRangeDamage
    local DamageFlags = DamageFlag.DAMAGE_IGNORE_ARMOR | DamageFlag.DAMAGE_CRUSH

    for _, Enemy in ipairs(Isaac.FindInRadius(TargetPosition, 
                                              EFFECT_RANGE,
                                              EntityPartition.ENEMY)) do
        if Enemy:IsActiveEnemy() then

            --print(Enemy:IsVulnerableEnemy())

            if Enemy:IsVulnerableEnemy() then

                Enemy:TakeDamage(math.ceil(FullHandDamage*(1 - OutOfRangeMult)),
                                 DamageFlags, EntityRef(Player), 0)

                Game:SpawnParticles(Enemy.Position, EffectVariant.BLOOD_PARTICLE, 3, 3.5, BloodColor)

            else--if not Enemy:IsBoss() then --invulnerable enemies take damage only if inside the radius

                Enemy:TakeDamage(0, DamageFlags, EntityRef(Player), 0)
            
                Enemy.HitPoints = Enemy.HitPoints - FullHandDamage*0.5

                HitColor = Color(1.5, 1,1,1, 0.25)

                Enemy:SetColor(HitColor, 2, 50, false, false)
            end
        end
    end


    --second damage tick
    Isaac.CreateTimer(function ()
        for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

            if Enemy:IsActiveEnemy() and Enemy:IsVulnerableEnemy() then

                Enemy:TakeDamage(FullHandDamage*OutOfRangeMult,
                                 DamageFlags, EntityRef(Player), 0)

                local PoofScale = 0.032 * Enemy.Size

                mod:TrueBloodPoof(Enemy.Position, PoofScale, HAND_POOF_COLOR)

            end
        end
    end, 2, 1, true)

    

    for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do
        
        if mod:Contained(mod.SelectionParams[PIndex].PlayedCards, mod.Saved.Player[PIndex].CurrentHand[i]) then

            table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
        end
    end

    Isaac.CreateTimer(function ()

        local AnimLength = 8

        for i=1, AnimLength do

            Isaac.CreateTimer(function ()

                mod.Saved.TotalScore = math.floor(mod:Lerp(FullHandDamage, 0, i/AnimLength))
            end, i, 1, true)
        end


        if not BlindGotCleared then

            print("room isn't cleared")

            Isaac.RunCallback(mod.Callbalcks.POST_HAND_PLAY, Player)
        end
    end, 12, 1, true)

end
--mod:AddCallback(mod.Callbalcks.POST_HAND_PLAY, mod.ActivateCurrentHand)



local function ClearBlindOnEnemyDeath(_,NPC)

    --print("try")

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) or BlindGotCleared
       or not NPC:IsActiveEnemy() and NPC.Type ~= EntityType.ENTITY_ROTGUT then

        return
    end

    local WAIT_FRAMES = 4

    Isaac.CreateTimer(function ()

    if BlindGotCleared then

        --print("Blind is already cleared")
        return
    end

    --print("damage")
        
    if Game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
        
        local AllDead = true

        for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

            if Enemy:IsBoss() and Enemy:IsActiveEnemy() and mod:IsValidScalingEnemy(Enemy) then

                if not (Enemy:IsDead() or Enemy:HasMortalDamage()) then
                    AllDead = false
                    break
                end
            end
        end

        if AllDead and (Ambush:GetCurrentWave() ~= PreviousWave) then
    
            BlindGotCleared = true

            local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

            local PIndex = T_Jimbo:GetData().TruePlayerIndex


            mod:SwitchCardSelectionStates(T_Jimbo, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)

            local Interval = 17 + 5 * #mod.Saved.Player[PIndex].CurrentHand

            Isaac.CreateTimer(function ()

                if Ambush:GetCurrentWave() ~= MAX_BOSSRUSH_WAVES then

                    ---sfx:Play(SoundEffect.SOUND_MEGA_BLAST_START)

                    mod.Saved.DiscardsWasted = mod.Saved.DiscardsWasted + mod.Saved.DiscardsRemaining

                    mod:SwitchCardSelectionStates(T_Jimbo, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)


                    mod.Saved.HandsRemaining = math.ceil(T_Jimbo:GetCustomCacheValue(mod.CustomCache.HAND_NUM))
                    mod.Saved.DiscardsRemaining = math.ceil(T_Jimbo:GetCustomCacheValue(mod.CustomCache.DISCARD_NUM))

                    BlindGotCleared = false
                else
                    mod.AnimationIsPlaying = true
                    local ClearInterval = Isaac.RunCallback(mod.Callbalcks.BLIND_CLEAR, mod.Saved.BlindBeingPlayed)
                
                    Isaac.CreateTimer(function ()
                        mod.AnimationIsPlaying = false
                    end, ClearInterval, 1, false)
                end

                PreviousWave = Ambush:GetCurrentWave()

            end, Interval, 1, true)

        end
        
        return
    end

    --after playing the hand, checks if everyone is dead, in that case the blind is cleared
    local AllDead = true


    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:IsActiveEnemy() and mod:IsValidScalingEnemy(Enemy) then

            if not (mod:EnemySpawnsOnDeath(Enemy) 
                    or Enemy:IsDead() or Enemy:HasMortalDamage() or Enemy:GetSprite():IsPlaying("Death")) then

                --print(Entity.Type,".",Entity.Variant,".",Entity.SubType, " is still alive")

                AllDead = false
                break
            end
        end
    end

    --print("Alldead:", AllDead)

    if AllDead and not mod:IsRotgutDungeon()
               and not mod:IsDogmaBossRoom()
               and not mod:IsBeastBossRoom() then

        BlindGotCleared = true

        Isaac.CreateTimer(function ()
            mod.AnimationIsPlaying = true
            Isaac.RunCallback(mod.Callbalcks.BLIND_CLEAR, mod.Saved.BlindBeingPlayed)

        end, 5, 1, true)

        return
    end

    if mod.Saved.HandsRemaining <= 0 then

        for i, Player in ipairs(PlayerManager.GetPlayers()) do

            if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
                --special bosses give you unlimited hands 

                local PIndex = Player:GetData().TruePlayerIndex

                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
                Isaac.CreateTimer(function ()
                                    Player:AnimatePitfallIn()
                                    Player:Kill()
                                end, 40, 1, true)

                return
            end
        end
    
    end

    end, WAIT_FRAMES, 1, true)

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, ClearBlindOnEnemyDeath)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ClearBlindOnEnemyDeath, EntityType.ENTITY_ROTGUT) --needs a specific callback due to the last room transition
--mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, ClearBlindOnEnemyDeath)


---@param Player EntityPlayer
function mod:SetupForHandScoring(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.ScreenStrings.Warning = {}

    mod.Saved.HandsRemaining = mod.Saved.HandsRemaining - 1

    mod.Saved.HandsPlayed = mod.Saved.HandsPlayed + 1
    mod.Saved.BlindHandsPlayed = mod.Saved.BlindHandsPlayed + 1


    mod.Saved.HandsTypeUsed[mod.Saved.HandType] = mod.Saved.HandsTypeUsed[mod.Saved.HandType] + 1

    if mod.Saved.HandType == mod.HandTypes.ROYAL_FLUSH then
        
        mod.Saved.HandsTypeUsed[mod.HandTypes.STRAIGHT_FLUSH] = mod.Saved.HandsTypeUsed[mod.HandTypes.STRAIGHT_FLUSH] + 1
    end

    local TIMER_INCREASE = 4
    local CurrentTimer = TIMER_INCREASE

    mod.SelectionParams[PIndex].PlayedCards = {}
    mod.SelectionParams[PIndex].ScoringCards = 0

    local HandIndex = 1
    local SelectionIndex = 1

    while SelectionIndex <= #mod.Saved.Player[PIndex].CurrentHand do
        
        local IsSelected = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][SelectionIndex]

        if IsSelected then

            local TrueHandIndex = HandIndex --otherwise the value gets modified in the timer itself

            Isaac.CreateTimer(function ()

                local CardIndex = mod.Saved.Player[PIndex].CurrentHand[TrueHandIndex] + 0

                mod.Saved.Player[PIndex].FullDeck[CardIndex].Modifiers = mod.Saved.Player[PIndex].FullDeck[CardIndex].Modifiers & ~mod.Modifier.COVERED

                mod.SelectionParams[PIndex].PlayedCards[#mod.SelectionParams[PIndex].PlayedCards+1] = CardIndex

                table.remove(mod.Saved.Player[PIndex].CurrentHand, TrueHandIndex)
                table.remove(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND], TrueHandIndex)

                sfx:Play(mod.Sounds.SELECT, 1,2,false, mod:Lerp(0.7,1.3, #mod.SelectionParams[PIndex].PlayedCards/mod.SelectionParams[PIndex].SelectionNum))

            end, CurrentTimer, 1, true)

            CurrentTimer = CurrentTimer + TIMER_INCREASE
        else
            HandIndex = HandIndex + 1
        end

        SelectionIndex = SelectionIndex + 1
    end


    --I REALLY suggest you not to look at what's inside this if statement (ultra unreadable code)
    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_HOOK then

        if not next(mod.Saved.Player[PIndex].CurrentHand) then
            --nothing to discard if hand is empty
            goto SKIP_HOOK_BOSS
        end

        CurrentTimer = CurrentTimer + 4

        Isaac.CreateTimer(function ()
            
            local PossibleIndexes = {}
            for i=1, #mod.Saved.Player[PIndex].CurrentHand do

                PossibleIndexes[i] = i
            end

            mod.SelectionParams[PIndex].SelectionNum = 0

            for i=1, 2 do --get up to 2 random cards to discard
                
                if not next(PossibleIndexes) then
                    break
                end

                local Random = mod.RNGs.LUCKY_CARD:RandomInt(1,#PossibleIndexes)
                
                mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][PossibleIndexes[Random]] = true

                table.remove(PossibleIndexes, Random)
                mod.SelectionParams[PIndex].SelectionNum = mod.SelectionParams[PIndex].SelectionNum + 1
            end

        end, CurrentTimer, 1, true)


        CurrentTimer = CurrentTimer + 8

        --this is where the timers get funky
        Isaac.CreateTimer(function ()

            local NumDiscarded = 0

            local HandSelectedCards = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND]


            local ExtraInterval = Isaac.RunCallback(mod.Callbalcks.DISCARD, Player, 0) --needed to reset the CurrentInterval in scoring system.lua

            for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do

                if HandSelectedCards[i] then

                    --print(i, "is selected")

                    NumDiscarded = NumDiscarded + 1

                    local GotDestroyed

                    ExtraInterval, GotDestroyed = Isaac.RunCallback(mod.Callbalcks.CARD_DISCARD, Player, mod.Saved.Player[PIndex].CurrentHand[i], 
                                                 i, NumDiscarded == mod.SelectionParams[PIndex].SelectionNum)


                    local IndexToDestroy = i

                    if not GotDestroyed then
                        Isaac.CreateTimer(function ()

                            table.remove(HandSelectedCards, IndexToDestroy)
                            table.remove(mod.Saved.Player[PIndex].CurrentHand, IndexToDestroy)

                            --print("removed", IndexToDestroy)

                            sfx:Play(mod.Sounds.DESELECT)
                        end, ExtraInterval, 1, true)
                    end
                end
            end

            --CurrentTimer = CurrentTimer + ExtraInterval

            mod.AnimationIsPlaying = true

            Isaac.CreateTimer(function ()
                mod.SelectionParams[PIndex].ScoringCards = mod:GetScoringCards(Player, mod.Saved.HandType)

            end, ExtraInterval + 7, 1, true)
        
            Isaac.CreateTimer(function ()
                Isaac.RunCallback(mod.Callbalcks.HAND_PLAY, Player)
            end, ExtraInterval + 10, 1, true)

        end, CurrentTimer, 1, true)

        --print("second part done")

        return
    end

    ::SKIP_HOOK_BOSS::
    
    --IF THIS GETS MODIFIED THEN ALSO MODIFY ITS REPLICA INSIDE ON HOOK BOSS
    
    mod.AnimationIsPlaying = true

    Isaac.CreateTimer(function ()
        mod.SelectionParams[PIndex].ScoringCards = mod:GetScoringCards(Player, mod.Saved.HandType)
        
    end, CurrentTimer + 7, 1, true)

    Isaac.CreateTimer(function ()
        Isaac.RunCallback(mod.Callbalcks.HAND_PLAY, Player)
    end, CurrentTimer + 10, 1, true)
end
mod:AddCallback(mod.Callbalcks.PRE_HAND_PLAY, mod.SetupForHandScoring)



---@param Player EntityPlayer
function mod:SetupForNextHandPlay(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local Interval = 8

    local PIndex = Player:GetData().TruePlayerIndex

    mod.SelectionParams[PIndex].ScoringCards = 0

    mod.Saved.TotalScore = 0

    
    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_HEART then
        
        Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, mod.BLINDS.BOSS_HEART)

        Interval = Interval + 4
    end


    Isaac.CreateTimer(function ()

        mod.SelectionParams[PIndex].PlayedCards = {}
        
        mod.Saved.HandType = mod.HandTypes.NONE
        mod.SelectionParams[PIndex].PossibleHandType = mod.HandFlags.NONE

        mod.SelectionParams[PIndex].ScoringCards = 0
        
        local Delay, DeckFinished = mod:RefillHand(Player, true)

        --mod.Counters.SinceSelect = 0
        mod.AnimationIsPlaying = false

        mod.Saved.ChipsValue = 0
        mod.Saved.MultValue = 0

        Isaac.CreateTimer(function ()

            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
        
        end, Delay, 1, true)
        
    end, 6, 1, true)
end
mod:AddPriorityCallback(mod.Callbalcks.POST_HAND_PLAY, CallbackPriority.LATE, mod.SetupForNextHandPlay)




---@param Effect EntityEffect
local function MoveHandTarget(_,Effect)

    local Player = Effect.Parent and Effect.Parent:ToPlayer() or nil

    if not Player or Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end


    if not mod:IsBeastBossRoom() then
        Game:GetRoom():GetCamera():SetFocusPosition(Effect.Position + Effect.Velocity)
    end

    Effect:AddVelocity(Player:GetAimDirection()*3.25)

    --local PIndex = Player:GetData().TruePlayerIndex
    local HandHype = mod.Saved.HandType

    local Radius = BASE_HAND_RADIUS *mod.Saved.HandsStat[HandHype].Mult

    mod:RenderCoolCircle(Isaac.WorldToScreen(Effect.Position), Radius, mod.EffectKColors.BLUE, true, true, Effect.FrameCount)


    for _, Enemy in ipairs(Isaac.FindInRadius(Effect.Position, Radius, EntityPartition.ENEMY)) do
        
        Enemy:SetColor(Color(1.5,1.5,1.5,1, 0.1, 0.1, 0.1), 2, 100, true, false)

    end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, MoveHandTarget, EffectVariant.TARGET)


------------BLIND SYSTEM------------
------------------------------------


---@param Plate GridEntityPressurePlate
local function OnBlindButtonPressed(_, Plate)

    local Variant = Plate:GetVariant()
    local VarData = Plate.VarData
    local Level = Game:GetLevel()

    Isaac.CreateTimer(function () --apparently when buttons are pressed the timers activate frame one so I just put a second timer inside the first one

    if Variant == mod.Grids.PlateVariant.RUN_STARTER then

        --Game:GetRoom():RemoveGridEntity(Plate:GetGridIndex(), 0, false)
        Plate:Destroy(true)

        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)

        mod:InitializeAnte(false)
    
    elseif Variant == mod.Grids.PlateVariant.REROLL then

        local Price = VarData

        if mod:PlayerCanAfford(Price) then

            local Player = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

            mod:SpendMoney(Price)
            

            mod.Saved.NumShopRerolls = mod.Saved.NumShopRerolls + 1

            mod:UpdateRerollPrice(Plate)

            --print("increased to:", Plate.VarData)

            Isaac.RunCallback(mod.Callbalcks.SHOP_REROLL)

            mod:SpawnShopItems(true)

            sfx:Play(mod.Sounds.MONEY)
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        end


    elseif Variant == mod.Grids.PlateVariant.CASHOUT then

        local ShouldGoToShop = mod.Saved.BossCleared == mod.BlindProgress.NOT_CLEARED or Level:IsAscent()

        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            if ShouldGoToShop then
                Player:AnimateTeleport(true)
            end

            if mod.Saved.Player[Player:GetData().TruePlayerIndex].FirstDeck then
                mod.Saved.DiscardsWasted = mod.Saved.DiscardsWasted + mod.Saved.DiscardsRemaining
            end

            mod.Saved.Player[Player:GetData().TruePlayerIndex].FirstDeck = true

            --restores hands and discards available
            Player:AddCustomCacheTag(mod.CustomCache.DISCARD_NUM)
            Player:AddCustomCacheTag(mod.CustomCache.HAND_NUM, true)

            Player:AddCoins(Plate.VarData)

            sfx:Play(mod.Sounds.MONEY)

        end

        if ShouldGoToShop then

            mod.Saved.BlindBeingPlayed = mod.BLINDS.SHOP

            Isaac.CreateTimer(function ()

                Game:StartRoomTransition(mod.Saved.ShopIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)

            end, 7, 1, true)

        else
            mod.Saved.BlindBeingPlayed = mod.BLINDS.SHOP | mod.BLINDS.WAITING_CASHOUT


            if mod:IsChestDarkRoomBossRoom() then

                Game:GetRoom():TrySpawnMegaSatanRoomDoor(true)
            end
        end

    elseif Variant == mod.Grids.PlateVariant.SHOP_EXIT then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.NONE

        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            Player:AnimateTeleport(true)
        end

        Isaac.CreateTimer(function ()

            Game:StartRoomTransition(Game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
            

            local Interval = Isaac.RunCallback(mod.Callbalcks.SHOP_EXIT)

        end, 7, 1, true)

    elseif Variant == mod.Grids.PlateVariant.SMALL_BLIND_SKIP then

        mod.AnimationIsPlaying = true

        local Interval = mod:AddSkipTag(Plate.VarData)

        Interval = math.max(Interval, Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, mod.BLINDS.SMALL)) --throwback

        if Level:IsAscent() then
            Isaac.CreateTimer(function ()

                for i,v in ipairs(PlayerManager:GetPlayers()) do
                    
                    v:AnimateTeleport(true)
                end

                Isaac.CreateTimer(function ()

                    Game:StartRoomTransition(Game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)                
                end, 7, 1, true)

            end, Interval, 1, true)
        end

    elseif Variant == mod.Grids.PlateVariant.BIG_BLIND_SKIP then
    
        mod.AnimationIsPlaying = true

        local Interval = mod:AddSkipTag(Plate.VarData)

        Interval = math.max(Interval, Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, mod.BLINDS.BIG)) --throwback

        if Level:IsAscent() then

            Isaac.CreateTimer(function ()

                for i,v in ipairs(PlayerManager:GetPlayers()) do
                    
                    v:AnimateTeleport(true)
                end

                Isaac.CreateTimer(function ()

                    Game:StartRoomTransition(Game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)                
                end, 7, 1, true)

            end, Interval, 1, true)
        end

    elseif Variant == mod.Grids.PlateVariant.BOSS_BLIND_SKIP then
    
        mod.AnimationIsPlaying = true
        

        mod:AddSkipTag(Plate.VarData, true)

        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, mod.BLINDS.BOSS) --throwback

        Isaac.CreateTimer(function ()
            
            local TagInterval = Isaac.RunCallback(mod.Callbalcks.POST_SKIP_TAG_ADDED, Plate.VarData)


            Isaac.CreateTimer(function ()

                for i,Player in ipairs(PlayerManager.GetPlayers()) do
                    
                    Player:AnimateTeleport(true)
                end

            end, TagInterval - 7, 1, true)


            Isaac.CreateTimer(function ()

                Game:StartRoomTransition(mod.Saved.ShopIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)

            end, TagInterval, 1, true)


        end, Interval, 1, true)

        

    elseif Variant == mod.Grids.PlateVariant.BLIND then

        mod.Saved.CurrentRound = mod.Saved.CurrentRound + 1

        local IsCorpseII = Level:GetStage() == LevelStage.STAGE4_2 and Level:IsAltStage()
        local IsSpecialMausoleum = Level:IsPreAscent()
        local IsPreHome = Level:IsAscent() and Level:GetStage() == LevelStage.STAGE1_1


        if not (IsCorpseII or IsSpecialMausoleum or IsPreHome) then --set after entring the actual boss room

            mod.Saved.BlindBeingPlayed = VarData
            mod.Saved.CurrentBlindName = mod:GetEIDString("BlindNames", mod.Saved.BlindBeingPlayed)

            mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)
        end

        local InitialInterval = Isaac.RunCallback(mod.Callbalcks.BLIND_SELECTED, VarData)

        Isaac.CreateTimer(function ()

            for i,Player in ipairs(PlayerManager.GetPlayers()) do

                Player:AnimateTeleport(true)
            end

            if VarData == mod.BLINDS.SMALL then

                    local Iteration = 0

                    Isaac.CreateTimer(function()
                                    
                                    Iteration = Iteration + 1

                                    if Iteration == 1 then
                                        Game:StartRoomTransition(mod.Saved.SmallBlindIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                        sfx:Play(mod.Sounds.TIMPANI)

                                    else --if Iteration == 2 then
                                        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                    
                                        --yahoo! triple timer indentation
                                        Isaac.CreateTimer(function ()
                                            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, VarData)
                                        end, Interval, 1, true)
                                    
                                        return
                                    end
                                
                    end, 8, 2, true)
                
            elseif VarData == mod.BLINDS.BIG then

                    local Iteration = 0
                
                    Isaac.CreateTimer(function ()

                                        Iteration = Iteration + 1
                    
                                        if Iteration == 1 then
                                            Game:StartRoomTransition(mod.Saved.BigBlindIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                            sfx:Play(mod.Sounds.TIMPANI)

                                        else--if Iteration == 2 then
                                        
                                        
                                            local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                        
                                            Isaac.CreateTimer(function ()
                                                Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, VarData)
                                            end, Interval, 1, true)
                                        
                                            return
                                        end
                                    
                                    end, 7, 2, true)
                                
            else --BOSS BLIND
            
                if IsPreHome then

                    --mod.Saved.AnteBoss = VarData --keeps in memory to then use it for dogma
                    
                    Isaac.CreateTimer(function ()

                        Game:StartRoomTransition(Game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                    end, 7, 1, true)

                    return
                end

                local Iteration = 0
            
                Isaac.CreateTimer(function ()

                    Iteration = Iteration + 1

                    if Iteration == 1 then

                        if Level:IsAscent() then
                            Game:StartRoomTransition(mod.Saved.SmallBlindIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                        else
                            Game:StartRoomTransition(mod.Saved.BossIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                        end
                        sfx:Play(mod.Sounds.TIMPANI)
                    
                    elseif not IsCorpseII and not IsSpecialMausoleum then --if Iteration == 2 then
                
                        local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                        
                        Isaac.CreateTimer(function ()
                            Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, VarData)
                        end, Interval, 1, true)
                    end
                
                end, 7, 2, true)
                            
            end

        end, InitialInterval, 1, true)        
    end

    end, 0, 1, true)

    mod:ResetPlatesData()
end
mod:AddCallback(mod.Callbalcks.BALATRO_PLATE_PRESSED, OnBlindButtonPressed)


local function OnBlindStart(_, BlindData)

    mod.AnimationIsPlaying = true

    local Interval = 8
    local JuggleIndex

    mod.Saved.NumJuggleUsed = 0

    for i,Tag in ipairs(mod.Saved.SkipTags) do
        
        if Tag == mod.SkipTags.JUGGLE then

            JuggleIndex = i
            
            mod.Saved.NumJuggleUsed = mod.Saved.NumJuggleUsed + 1

            Isaac.CreateTimer(function ()
                mod:UseSkipTag(JuggleIndex)
                print("juggle is used at", JuggleIndex )
            end, Interval, 1, true)

            Interval = Interval + 20
        else
            JuggleIndex = 0
        end
    end


    Isaac.CreateTimer(function ()

        mod.AnimationIsPlaying = false
    
        for _,Player in ipairs(PlayerManager.GetPlayers()) do

            if Player:GetPlayerType() == mod.Characters.TaintedJimbo then

                Player:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)

                --give modifiers to cards basing on the current blind (or remove its effect (chicot))
                local Interval = Isaac.RunCallback(mod.Callbalcks.BOSS_BLIND_EVAL, true)


                Isaac.CreateTimer(function ()

                    --also shuffles the deck in this case (applying the house boss blind as well)
                    mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
                    
                end, Interval, 1, true)
                
            end
        end

    end, Interval, 1, true)

    
    return Interval + 8

end
mod:AddCallback(mod.Callbalcks.BLIND_START, OnBlindStart)



-----FUNCTION NEEDED FOR PACK SKIP TAGS-----
---------------------------------------------

local function SkipTagPackOpen(PackType)
                         
    local SomeoneIsSelecting = false

    for i,Player in ipairs(PlayerManager.GetPlayers()) do

        local PIndex = Player:GetData().TruePlayerIndex
    
        if mod.SelectionParams[PIndex].Mode ~= mod.SelectionParams.Modes.NONE then
            SomeoneIsSelecting = true
        
            break
        end
    end

    if SomeoneIsSelecting then

        Isaac.CreateTimer(function ()
            SkipTagPackOpen(PackType)
        end, 1, 1, true)
    else
        PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo):AddCard(PackType)
        mod:UseSkipTag(1)
    end
end

--------------------------------------------


local function OnBlindSkip(_, BlindType)

    mod.Saved.NumBlindsSkipped = mod.Saved.NumBlindsSkipped + 1

    if BlindType == mod.BLINDS.SMALL then

        mod.Saved.SmallCleared = mod.BlindProgress.SKIPPED

    else --if BlindType == mod.BLINDS.BIG then
        mod.Saved.BigCleared = mod.BlindProgress.SKIPPED
    end
end
mod:AddPriorityCallback(mod.Callbalcks.BLIND_SKIP, CallbackPriority.IMPORTANT, OnBlindSkip)



local function OnTagAdded(_, TagAdded)

    local Interval = 4

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        
        print("wtf why isn't Jimbo here")
        return
    end

    local PIndex = T_Jimbo:GetData().TruePlayerIndex
      
    for i,Tag in ipairs(mod.Saved.SkipTags) do

        if Tag == mod.SkipTags.BOSS then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
            
                mod:RerollBossBlind()

                mod:UseSkipTag(1) --boss tags are used only when obtained, so they are always first

            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.HANDY then

            Isaac.CreateTimer(function ()
                local Money = mod.Saved.HandsPlayed

                T_Jimbo:AddCoins(Money)

                mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                mod:UseSkipTag(1)
            
            end, Interval, 1, true)

            Interval = Interval + 20


        elseif Tag == mod.SkipTags.GARBAGE then

            Interval = Interval + 20


            Isaac.CreateTimer(function ()
                local Money = mod.Saved.DiscardsWasted

                T_Jimbo:AddCoins(Money)

                mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                mod:UseSkipTag(1)

            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.SPEED then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                local Money = 5 * mod.Saved.NumBlindsSkipped

                T_Jimbo:AddCoins(Money)

                mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                mod:UseSkipTag(1)

            end, Interval, 1, true)
            
        elseif Tag == mod.SkipTags.ECONOMY then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                    local Money = math.min(40, T_Jimbo:GetNumCoins())

                    T_Jimbo:AddCoins(Money)

                    mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                    mod:UseSkipTag(1)

            end, Interval, 1, true)
        elseif Tag == mod.SkipTags.TOP_UP then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                for i = 1, 2 do

                    for Index,Slot in ipairs(mod.Saved.Player[PIndex].Inventory) do

                        if Slot.Joker == TrinketType.TRINKET_NULL then

                            local CommonJoker = mod:RandomJoker(mod.RNGs.SKIP_TAGS, true, "common", false)

                            mod.Saved.Player[PIndex].Inventory[Index].Joker = CommonJoker.Joker
                            mod.Saved.Player[PIndex].Inventory[Index].Edition = CommonJoker.Edition

                            break
                        end
                    end
                end
                mod:UseSkipTag(1)

            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.STANDARD then

            Isaac.CreateTimer(function ()
                SkipTagPackOpen(mod.Packs.MEGA_STANDARD)
            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.CHARM then

            Isaac.CreateTimer(function ()
                SkipTagPackOpen(mod.Packs.MEGA_ARCANA)
            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.BUFFON then

            Isaac.CreateTimer(function ()
                SkipTagPackOpen(mod.Packs.MEGA_BUFFON)
            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.METEOR then

            Isaac.CreateTimer(function ()
                SkipTagPackOpen(mod.Packs.MEGA_CELESTIAL)
            end, Interval, 1, true)

        elseif Tag == mod.SkipTags.ETHEREAL then

            Isaac.CreateTimer(function ()
                SkipTagPackOpen(mod.Packs.SPECTRAL)
            end, Interval, 1, true)

        elseif Tag & mod.SkipTags.ORBITAL ~= 0 then
            
            local HandType = Tag & ~mod.SkipTags.ORBITAL

            Isaac.CreateTimer(function ()

                mod:UseSkipTag(1)

            end, Interval, 1, true)

            local PlanetInterval = mod:PlanetUpgradeAnimation(HandType, 3, Interval)
            
            Interval = Interval + PlanetInterval

        elseif Tag == mod.SpecialSkipTags.KEY_PIECE_1 then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()

                local Money = 10

                if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1) then
                    
                    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2) then
                        
                        Money = Money + 5
                    else
                        T_Jimbo:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
                    end
                else
                    T_Jimbo:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
                end


                mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                mod:UseSkipTag(1)

            end, Interval, 1, true)

        elseif Tag == mod.SpecialSkipTags.KEY_PIECE_2 then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()

                local Money = 10

                if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2) then
                        
                    Money = Money + 5
                else
                    T_Jimbo:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
                end

                mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                mod:UseSkipTag(1)

            end, Interval, 1, true)

        elseif Tag == mod.SpecialSkipTags.ANTE then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()

                mod.Saved.AnteLevel = mod.Saved.AnteLevel + 1

            end, Interval, 1, true)

        end
    end

    return Interval --after this many frames do  AnimationIsPlaying = false
end
mod:AddCallback(mod.Callbalcks.POST_SKIP_TAG_ADDED, OnTagAdded)


local function OnBlindClear(_, BlindData)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    --print("blind cleared")

    local Room = Game:GetRoom()

    mod.Saved.BlindScalingFactor = 1
    mod.Saved.BlindHandsPlayed = 0
    mod.Saved.BlindDiscardsUsed = 0

    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:ToNPC() then
            Enemy:Kill()
        end
    end

    
    for _,Player in ipairs(PlayerManager.GetPlayers()) do

        local PIndex = Player:GetData().TruePlayerIndex

        for i, _ in ipairs(mod.Saved.Player[PIndex].Inventory) do
        
            mod.Saved.Player[PIndex].Inventory[i].Modifiers = 0 --no modifiers (not covered or debuffed)
        end

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
    end

    for i = 0, Room:GetGridSize() do

        local GridEntity = Room:GetGridEntity(i)

        if not GridEntity then
            goto SKIP_TILE
        end

        local RoomCenter = Room:GetCenterPos()

        local Timer = 3 + (GridEntity.Position - RoomCenter):Length() // 20

        Isaac.CreateTimer(function ()
            
        

        if GridEntity:IsBreakableRock() then

            local CurrentBackdrop = Room:GetBackdropType()

            local CanBePot = CurrentBackdrop == BackdropType.BASEMENT 
                          or CurrentBackdrop == BackdropType.CELLAR 
                          or CurrentBackdrop == BackdropType.BURNT_BASEMENT

            local CanBeSkull = CurrentBackdrop == BackdropType.DANK_DEPTHS 
                            or CurrentBackdrop == BackdropType.DEPTHS 
                            or CurrentBackdrop == BackdropType.NECROPOLIS

            

            if GridEntity:GetType() == GridEntityType.GRID_ROCK_ALT
               and (CanBePot or CanBeSkull) then 
            

                Room:RemoveGridEntityImmediate(i, 0, true) --prevents spiders/hosts to spawn after the room was alredy cleared


                if CanBePot then 

                    --make the pot breaking sound
                    
                    if math.random() > 0.5 then
                        sfx:Play(SoundEffect.SOUND_POT_BREAK)
                    else
                        sfx:Play(SoundEffect.SOUND_POT_BREAK_2)
                    end
                else
                    --generic sound
                    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)

                end
            else
                GridEntity:Destroy()
            end

        elseif GridEntity:GetType() == GridEntityType.GRID_PIT then

            local Pit = GridEntity:ToPit()

            if Pit then

                Pit:MakeBridge(nil)
            end
        end

        end, Timer, 1, true)

        ::SKIP_TILE::
    end

    if BlindData == mod.BLINDS.SMALL then
        mod.Saved.SmallCleared = mod.BlindProgress.DEFEATED

    elseif BlindData == mod.BLINDS.BIG then
        mod.Saved.BigCleared = mod.BlindProgress.DEFEATED

    else --if BlindData & mod.BLINDS.BOSS ~= 0 then
        mod.Saved.BossCleared = mod.BlindProgress.DEFEATED
    end


    local Interval = Isaac.RunCallback(mod.Callbalcks.POST_BLIND_CLEAR, BlindData)

    Isaac.CreateTimer(function ()

        local TotalGain = Isaac.RunCallback(mod.Callbalcks.CASHOUT_EVAL, BlindData)

        if TotalGain == 0 then

            mod.Saved.BlindBeingPlayed = mod.BLINDS.WAITING_CASHOUT | mod.BLINDS.SHOP
        else
            local PlatePos = Room:GetCenterPos() + Vector(0, 80)

            mod:SpawnBalatroPressurePlate(PlatePos, mod.Grids.PlateVariant.CASHOUT, TotalGain)

            local Level = Game:GetLevel()

            if mod:IsBlindFinisher(BlindData)
               and Level:GetStage() == LevelStage.STAGE2_2 and Level:IsAltStage() then --completed the extra challenge in Mines II

                local ItemPos = Isaac.GetCollectibleSpawnPosition(PlatePos - Vector(80, 0))
            
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ItemPos,
                           Vector.Zero, nil, CollectibleType.COLLECTIBLE_KNIFE_PIECE_2, 1)
            end
        end


    end, Interval, 1, true)

    mod.Saved.BlindBeingPlayed = mod.BLINDS.WAITING_CASHOUT

    return Interval --does not consider the time spent for CASHOUT_EVL
end
mod:AddCallback(mod.Callbalcks.BLIND_CLEAR, OnBlindClear)



function mod:InitializeAnte(NewFloor)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local Level = Game:GetLevel()
    local Room = Game:GetRoom()

    local CurrentStage = Level:GetStage()
    local IsAscent = Level:IsAscent()


    if not mod.GameStarted then --wait a frame to let the variables get set up (see Callback System.lua)
        
        if CurrentStage == LevelStage.STAGE1_1 and not IsAscent then --just to be safe
                    
            mod:SpawnBalatroPressurePlate(Room:GetCenterPos()-Vector(0,40), mod.Grids.PlateVariant.RUN_STARTER, 0)
        end

        return
        
    end

    

    local IsHome = CurrentStage == LevelStage.STAGE8

    if IsHome then

        mod.Saved.SmallCleared = mod.BlindProgress.DEFEATED
        mod.Saved.BigCleared = mod.BlindProgress.DEFEATED
        mod.Saved.BossCleared = mod.BlindProgress.DEFEATED --ante boss got decided in the previous floor

        return --things will be handled as the fight starts (see Special enemies.lua)
    end

    local IsBlueWomb = CurrentStage == LevelStage.STAGE4_3
    local IsMinesII = CurrentStage == LevelStage.STAGE2_2 and Level:IsAltStage()
                      and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)
    local IsSpecialMausoleum = Level:IsPreAscent()
    local IsCorpseII = Level:GetStage() == LevelStage.STAGE4_2 and Level:IsAltStage()
    local IsVoid = Level:GetStage() == LevelStage.STAGE7


    local IsSpecialBoss = CurrentStage == LevelStage.STAGE4_2 --mom's heart / mother floor
                    --or CurrentStage == LevelStage.STAGE6 -- dark room / chest
                    --or CurrentStage == LevelStage.STAGE7 --void
                    --or IsAscent and CurrentStage == LevelStage.STAGE1_1



    if IsAscent then

        --print("Ascent", CurrentStage)

        local TrueLevel = Level:GetStage()

        if Level:IsAltStage() then
            TrueLevel = TrueLevel + 1
        end

        if TrueLevel % 2 == 0 then

            print("old stage:", Level:GetStage())


            Level:SetNextStage()
            
            CurrentStage = TrueLevel - 1 --fixes the offset created

            print("new stage:", TrueLevel)
        end
    end

    AmbushWasActive = false
    PreviousWave = 0

    if not (IsAscent or IsSpecialMausoleum) then
        mod.Saved.AnteLevel = mod.Saved.AnteLevel + 1
    end

    -------BOSS / SKIP TAGS POOL MANAGER---------
    ---------------------------------------------
    
    if mod.Saved.AnteLevel == 2 and mod.Saved.MaxAnteLevel ~= 2 then

        -------BOSSES---------

        local InitialBossNum = #mod.Saved.Pools.BossBlinds

        mod.Saved.Pools.BossBlinds[InitialBossNum+1] = mod.BLINDS.BOSS_HOUSE
        mod.Saved.Pools.BossBlinds[InitialBossNum+2] = mod.BLINDS.BOSS_WALL
        mod.Saved.Pools.BossBlinds[InitialBossNum+3] = mod.BLINDS.BOSS_WHEEL
        mod.Saved.Pools.BossBlinds[InitialBossNum+4] = mod.BLINDS.BOSS_ARM
        mod.Saved.Pools.BossBlinds[InitialBossNum+5] = mod.BLINDS.BOSS_FISH
        mod.Saved.Pools.BossBlinds[InitialBossNum+6] = mod.BLINDS.BOSS_WATER
        mod.Saved.Pools.BossBlinds[InitialBossNum+7] = mod.BLINDS.BOSS_MOUTH
        mod.Saved.Pools.BossBlinds[InitialBossNum+8] = mod.BLINDS.BOSS_NEEDLE


        ---------TAGS---------
        
        local InitialTagsNum = #mod.Saved.Pools.SkipTags

        mod.Saved.Pools.SkipTags[InitialTagsNum+1] = mod.SkipTags.NEGATIVE
        mod.Saved.Pools.SkipTags[InitialTagsNum+2] = mod.SkipTags.STANDARD
        mod.Saved.Pools.SkipTags[InitialTagsNum+3] = mod.SkipTags.METEOR
        mod.Saved.Pools.SkipTags[InitialTagsNum+4] = mod.SkipTags.BUFFON
        mod.Saved.Pools.SkipTags[InitialTagsNum+5] = mod.SkipTags.HANDY
        mod.Saved.Pools.SkipTags[InitialTagsNum+6] = mod.SkipTags.GARBAGE
        mod.Saved.Pools.SkipTags[InitialTagsNum+7] = mod.SkipTags.ETHEREAL
        mod.Saved.Pools.SkipTags[InitialTagsNum+8] = mod.SkipTags.TOP_UP
        mod.Saved.Pools.SkipTags[InitialTagsNum+8] = mod.SkipTags.ORBITAL

    elseif mod.Saved.AnteLevel == 3 and mod.Saved.MaxAnteLevel ~= 3 then

        local InitialBossNum = #mod.Saved.Pools.BossBlinds

        mod.Saved.Pools.BossBlinds[InitialBossNum+1] = mod.BLINDS.BOSS_EYE
        mod.Saved.Pools.BossBlinds[InitialBossNum+2] = mod.BLINDS.BOSS_TOOTH

    elseif mod.Saved.AnteLevel == 4 and mod.Saved.MaxAnteLevel ~= 4 then

        mod.Saved.Pools.BossBlinds[#mod.Saved.Pools.BossBlinds+1] = mod.BLINDS.BOSS_PLANT

    elseif mod.Saved.AnteLevel == 5 and mod.Saved.MaxAnteLevel ~= 5 then

        mod.Saved.Pools.BossBlinds[#mod.Saved.Pools.BossBlinds+1] = mod.BLINDS.BOSS_SERPENT

    elseif mod.Saved.AnteLevel == 6 and mod.Saved.MaxAnteLevel ~= 6 then

        mod.Saved.Pools.BossBlinds[#mod.Saved.Pools.BossBlinds+1] = mod.BLINDS.BOSS_OX

    end

    mod.Saved.MaxAnteLevel = math.max(mod.Saved.AnteLevel, mod.Saved.MaxAnteLevel)


    mod.Saved.AnteCardsPlayed = {}

    mod:EvaluateBlindData(mod.Saved.AnteBoss)

    mod.Saved.NumBossRerolls = 0
    mod.Saved.AnteVoucher = mod:GetRandom(mod.Saved.Pools.Vouchers, mod.RNGs.VOUCHERS)



    --print("Voucher:",mod.Saved.AnteVoucher)

    -------------CUSTOM PRESSURE PLATES-------------
    ------------------------------------------------

    local Plate

    local SMALL_POSITION
    local BIG_POSITION
    local BOSS_POSITION
    local SMALL_SKIP_POSITION
    local BIG_SKIP_POSITION
    local BOSS_SKIP_POSITION --ye crazy ik
    local SHOP_POSITION

    local ForcedBossBlind

    if IsBlueWomb then
        
        if NewFloor ~= false then
            SHOP_POSITION = 170
        end

        ForcedBossBlind = mod.BLINDS.BOSS
        BOSS_POSITION = 174

        mod.Saved.SmallCleared = mod.BlindProgress.DEFEATED
        mod.Saved.BigCleared = mod.BlindProgress.DEFEATED
        mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED

    elseif IsMinesII then

        SMALL_POSITION = 49
        BIG_POSITION = 51
        BOSS_POSITION = 69
        SMALL_SKIP_POSITION = 79
        BIG_SKIP_POSITION = 81
        SHOP_POSITION = nil

        if NewFloor ~= false then
            SHOP_POSITION = 62
        end

        mod.Saved.SmallCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BigCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED

    elseif IsCorpseII then

        ForcedBossBlind = mod.BLINDS.BOSS_MOTHER

        SMALL_POSITION = 49
        BIG_POSITION = 52
        BOSS_POSITION = 70
        SMALL_SKIP_POSITION = 79
        BIG_SKIP_POSITION = 82
        SHOP_POSITION = nil

        if NewFloor ~= false then
            SHOP_POSITION = 62
        end

        mod.Saved.SmallCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BigCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED

    elseif IsVoid then

        ForcedBossBlind = mod.BLINDS.BOSS_DELIRIUM

        SMALL_POSITION = 49
        BIG_POSITION = 52
        BOSS_POSITION = 70
        SMALL_SKIP_POSITION = 79
        BIG_SKIP_POSITION = 82
        SHOP_POSITION = nil

        if NewFloor ~= false then
            SHOP_POSITION = 62
        end

        mod.Saved.SmallCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BigCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED

    elseif IsAscent then
        
        if CurrentStage == LevelStage.STAGE3_2 then
            
            SMALL_POSITION = 52
            SMALL_SKIP_POSITION = 82

            mod.Saved.SmallSkipTag = mod:RandomSkipTag(mod.RNGs.SKIP_TAGS)
            mod.Saved.BigSkipTag = mod:RandomSkipTag(mod.RNGs.SKIP_TAGS)

            mod.Saved.SmallCleared = mod.BlindProgress.NOT_CLEARED
            mod.Saved.BigCleared = mod.BlindProgress.NOT_CLEARED
            mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED

        elseif CurrentStage == LevelStage.STAGE3_1 then

            ForcedBossBlind = mod.Saved.AnteBoss
            
            BIG_POSITION = 52
            BIG_SKIP_POSITION = 82

        elseif CurrentStage == LevelStage.STAGE2_1 then

            ForcedBossBlind = mod.Saved.AnteBoss
            
            BOSS_POSITION = 67
            --BOSS_SKIP_POSITION = 81

        elseif CurrentStage == LevelStage.STAGE1_1 then

            BOSS_POSITION = 67
            --BOSS_SKIP_POSITION = 81

            ForcedBossBlind = mod.BLINDS.BOSS
            mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED
        end

    else
        SMALL_POSITION = 49
        BIG_POSITION = 52
        BOSS_POSITION = 70
        SMALL_SKIP_POSITION = 79
        BIG_SKIP_POSITION = 82
        SHOP_POSITION = nil

        if NewFloor ~= false then
            SHOP_POSITION = 62
        end

        mod.Saved.SmallCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BigCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BossCleared = mod.BlindProgress.NOT_CLEARED
    end
    
    local _, AngelChance = mod:GetDevilAngelRoomChance()

    local HasKey1 = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
    local HasKey2 = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)



    if SMALL_POSITION then
        mod:SpawnBalatroPressurePlate(Room:GetGridPosition(SMALL_POSITION), mod.Grids.PlateVariant.BLIND, mod.BLINDS.SMALL)
    end

    if SMALL_SKIP_POSITION then

        if not (HasKey1 and HasKey2)
           and mod:CanReachMegaSatan()
           and Level:GetDevilAngelRoomRNG():RandomFloat() <= AngelChance then

            if HasKey1 then
                mod.Saved.SmallSkipTag = mod.SpecialSkipTags.KEY_PIECE_2
            else
                mod.Saved.SmallSkipTag = mod.SpecialSkipTags.KEY_PIECE_1
            end
        else
            mod.Saved.SmallSkipTag = mod:RandomSkipTag(mod.RNGs.SKIP_TAGS)
        end

        mod:SpawnBalatroPressurePlate(Room:GetGridPosition(SMALL_SKIP_POSITION), mod.Grids.PlateVariant.SMALL_BLIND_SKIP, mod.Saved.SmallSkipTag)
    end

    if BIG_POSITION then
        Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(BIG_POSITION), mod.Grids.PlateVariant.BLIND, mod.BLINDS.BIG)
        Plate.State = 3
        Plate:GetSprite():Play("Switched")
    end

    if BIG_SKIP_POSITION then

        mod.Saved.BigSkipTag = mod:RandomSkipTag(mod.RNGs.SKIP_TAGS)

        Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(BIG_SKIP_POSITION), mod.Grids.PlateVariant.BIG_BLIND_SKIP, mod.Saved.BigSkipTag)
        Plate.State = 3
        Plate:GetSprite():Play("Switched")
    end

    if BOSS_POSITION then

        if ForcedBossBlind then
            
            mod.Saved.AnteBoss = ForcedBossBlind
        else
            mod.Saved.AnteBoss = mod:RandomBossBlind(mod.RNGs.BOSS_BLINDS, IsSpecialBoss)
        end


        Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(BOSS_POSITION), mod.Grids.PlateVariant.BLIND, mod.Saved.AnteBoss)
        --Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(BOSS_POSITION), mod.Grids.PlateVariant.BLIND, mod.BLINDS.BOSS_SERPENT)
        Plate.State = 3
        Plate:GetSprite():Play("Switched")

        if IsMinesII then
            
            local SecondaryBoss = mod:RandomBossBlind(mod.RNGs.BOSS_BLINDS, true)

            Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(BOSS_POSITION + 3), mod.Grids.PlateVariant.BLIND, SecondaryBoss)
            Plate.State = 3
            Plate:GetSprite():Play("Switched")
        end
    end

    if BOSS_SKIP_POSITION then

        Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(BIG_SKIP_POSITION), mod.Grids.PlateVariant.BOSS_BLIND_SKIP, mod.SpecialSkipTags.ANTE)
        Plate.State = 3
        Plate:GetSprite():Play("Switched")
    end


    if SHOP_POSITION then

        Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(SHOP_POSITION), mod.Grids.PlateVariant.CASHOUT, 0)
        Plate.State = 3
        Plate:GetSprite():Play("Switched")
    end


    

    mod:PlaceBlindRoomsForReal()

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.InitializeAnte)




--all enemies' HP get scaled basing on how many antes have been cleared this run
local function EnemyHPScaling()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then        
        return
    end


    local HighestEnemyHP

    local ScoreRequirement = mod:GetBlindScoreRequirement(mod.Saved.BlindBeingPlayed)


    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if mod:IsValidScalingEnemy(Enemy) then

            --print("Found Enemy With",Enemy.MaxHitPoints, "MaxHP,","("..tostring(Enemy.Type).."."..tostring(Enemy.Variant).."."..tostring(Enemy.SubType)..")")

            HighestEnemyHP = HighestEnemyHP and math.max(Enemy.MaxHitPoints, HighestEnemyHP) or Enemy.MaxHitPoints
        end
    end

    if not HighestEnemyHP then
        
        --print("no enemies")

        mod.Saved.BlindScalingFactor = 0
        return
    end

    --in the end the enemy with the highest HP will match the blind's required score
    mod.Saved.BlindScalingFactor = ScoreRequirement / HighestEnemyHP

    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:IsActiveEnemy() then

            if Enemy:IsBoss() then

                Enemy.MaxHitPoints = ScoreRequirement
                Enemy.HitPoints = ScoreRequirement
            else
                Enemy.MaxHitPoints = Enemy.MaxHitPoints * mod.Saved.BlindScalingFactor
                Enemy.HitPoints = Enemy.HitPoints * mod.Saved.BlindScalingFactor
            end

            Enemy:GetData().AlreadyAnteScaled = true
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EnemyHPScaling)




---@param SpawnedEnemy EntityNPC
local function SpawnedEnemyHPScaling(_,SpawnedEnemy)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) or not mod:IsValidScalingEnemy(SpawnedEnemy) then
        return
    end
    
    local Room = Game:GetRoom()

    --print("IS ROOM INITED?:", Room:IsInitialized())

    if not Room:IsInitialized() or SpawnedEnemy:GetData().AlreadyAnteScaled then
        return --the NEW_ROOM scaling will take care of it
    end

    if Room:IsClear() and not Room:GetType() == RoomType.ROOM_BOSSRUSH then
        SpawnedEnemy:Remove()
        return
    end

    local ScalingFactor
    
    if Room:GetType() == RoomType.ROOM_BOSSRUSH then
        
        if not AmbushWasActive then
            
            AmbushWasActive = true

            --PreviousWave = Ambush:GetCurrentWave()

            local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, mod.BLINDS.BOSS)

            Interval = math.max(16, Interval) --might break stuff if it's too low
                                    
            Isaac.CreateTimer(function ()
                Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, mod.BLINDS.BOSS)
            end, Interval, 1, true)

            mod.Saved.BlindBeingPlayed = mod.BLINDS.BOSS
        end
    end

    if SpawnedEnemy.MaxHitPoints == 0 then

        Isaac.CreateTimer(function ()
            SpawnedEnemyHPScaling(_,SpawnedEnemy)
        end, 1, 1, false)

        --print("delayed", "("..tostring(SpawnedEnemy.Type).."."..tostring(SpawnedEnemy.Variant).."."..tostring(SpawnedEnemy.SubType)..")")

        return
    end
    
    ScalingFactor = mod.Saved.BlindScalingFactor + 0


    local Spawner = SpawnedEnemy.SpawnerEntity

    local Multiplier = 1

    while Spawner do
        
        Multiplier = Multiplier * 0.4

        if Spawner.Type == EntityType.ENTITY_MOMS_HEART
           or Spawner.Type == EntityType.ENTITY_GIDEON then --bro spawns a bit too much
            Multiplier = Multiplier * 0.75
        end

        Spawner = Spawner.SpawnerEntity
    end

    --print("---------ENEMY--------")

    --print(SpawnedEnemy.Type, SpawnedEnemy.Variant)
    --print("PRE INIT", SpawnedEnemy.MaxHitPoints, "HP")


    if SpawnedEnemy:IsBoss() then

        if SpawnedEnemy.Type == EntityType.ENTITY_DOGMA then
            Multiplier = 1

        else
            Multiplier = Multiplier^0.5
        end

        SpawnedEnemy.MaxHitPoints = mod:GetBlindScoreRequirement(mod.Saved.BlindBeingPlayed) * Multiplier
        SpawnedEnemy.HitPoints = SpawnedEnemy.MaxHitPoints

        --print("BOSS init with", SpawnedEnemy.MaxHitPoints, "HP", "MULT:", Multiplier)

    elseif ScalingFactor == 0 then
        
        ScalingFactor = mod:GetBlindScoreRequirement(mod.Saved.BlindBeingPlayed) / SpawnedEnemy.MaxHitPoints
        ScalingFactor = ScalingFactor / 5

        SpawnedEnemy.MaxHitPoints = SpawnedEnemy.MaxHitPoints * ScalingFactor * Multiplier
        SpawnedEnemy.HitPoints = SpawnedEnemy.HitPoints * ScalingFactor * Multiplier

        --print("Enemy init with", SpawnedEnemy.MaxHitPoints, "HP (no initial scaling)", "MULT:", Multiplier)

    else

        SpawnedEnemy.MaxHitPoints = SpawnedEnemy.MaxHitPoints * ScalingFactor * Multiplier
        SpawnedEnemy.HitPoints = SpawnedEnemy.HitPoints * ScalingFactor * Multiplier

        --print("Enemy init with", SpawnedEnemy.MaxHitPoints, "HP", "MULT:", Multiplier)
    end

    SpawnedEnemy:GetData().AlreadyAnteScaled = true

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, SpawnedEnemyHPScaling)



------------------STATS------------------
-----------------------------------------

local function PreventTJimboDamage(_, Player)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo and not mod:IsTJimboVulnerable() then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, PreventTJimboDamage)


--sometimes TJimbo is supposed to take damage, but not to kill him
local function NullifyTJimboDamage(_, Player, Amount, Flags, Source)

    Player = Player:ToPlayer()

    if Player and Player:GetPlayerType() == mod.Characters.TaintedJimbo
       and Amount > 0 then

        Isaac.RunCallback(mod.Callbalcks.DAMAGE_TAKEN, Player)


        Player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, Source, 0) --take fake damage
        Player:SetMinDamageCooldown(80)

        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, NullifyTJimboDamage, EntityType.ENTITY_PLAYER)




---@param Player EntityPlayer
function mod:TJimboInventorySizeCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    Value = 5 --base starting point

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
        Value = Value + mod.Saved.Player[PIndex].Inventory[Index].Progress
    end

    Value = Value + #mod:GetJimboJokerIndex(Player, mod.Jokers.JUGGLER)

    Value = Value + 3*mod.Saved.NumJuggleUsed
 

    Value = Value - mod.Saved.Player[PIndex].OuijaUses

    for i=1, mod.Saved.Player[PIndex].EctoUses do
        
        Value = Value - i
    end

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_MANACLE then
        Value = Value - 1
    end


    if Value <= 0 then
        
        Player:AnimateSad()

        Isaac.CreateTimer(function ()
            Player:Kill()
        end,20, 1, true)

        return
    end

    local NumCardsInHand = #mod.Saved.Player[PIndex].CurrentHand
    local SizeDifference = Value - NumCardsInHand
    --print(SizeDifference)

    if SizeDifference > 0 
       and NumCardsInHand ~= 0 then

        Isaac.CreateTimer(function () --wait a frame so that the cache value gets returned
            mod:RefillHand(Player, false)
        end, 0, 1, true)
    end

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboHandSizeCache, mod.CustomCache.HAND_SIZE)


---@param Player EntityPlayer
function mod:TJimboDiscardNumCache(Player, Cache, Value)
    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo 
       or not mod.GameStarted then
        return
    end

    Value = mod.Saved.DSS.T_Jimbo.BaseDiscards --base starting point

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


    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_WATER then
        Value = 0
    end

    Value = Value - mod.Saved.BlindDiscardsUsed

    Value = math.max(Value, 0)

    mod.Saved.DiscardsRemaining = Value

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboDiscardNumCache, mod.CustomCache.DISCARD_NUM)


---@param Player EntityPlayer
function mod:TJimboHandsCache(Player, Cache, Value)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo 
       or not mod.GameStarted then
        return
    end

    Value = mod.Saved.DSS.T_Jimbo.BaseHands --starting point

    if Player:HasCollectible(mod.Vouchers.Grabber) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.NachoTong) then
        Value = Value + 1
    end
    if Player:HasCollectible(mod.Vouchers.Hieroglyph) then
        Value = Value - 1
    end


    Value = Value - #mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)

    --local PIndex = Player:GetData().TruePlayerIndex

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_NEEDLE then
        Value = 1
    end

    Value = Value - mod.Saved.BlindHandsPlayed

    Value = math.max(Value, 1)

    mod.Saved.HandsRemaining = Value

    
    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboHandsCache, mod.CustomCache.HAND_NUM)


--technically no money cap
function mod:AlwaysMaxCoins(Player, CustomCache, _)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then

        return math.maxinteger
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.AlwaysMaxCoins, "maxcoins")


----------------OTHER-------------
----------------------------------

---@param Door GridEntityDoor
local function RemoveUnwantedDoors(_, Door)

    --T.HEART BOSS index -10
    --MOTHER room SECRET_EXIT
    --M:SATAN room BOSS index -7
    --BEAST room SECRET_EXIT index -10 || normal BOSS_ROOM
    --BOSS_RUSH room BOSSRUSH (wowie) index -5
    --HUSH room DEFAULT index -8 || normal ROOM_BOSS


    --print(mod:GetValueIndex(DoorSlot, Door.Slot, true), Door.VarData, Door.State, mod:GetValueIndex(RoomType, Door.TargetRoomType, true), Door.TargetRoomIndex)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        return
    end

    local Room = Game:GetRoom()
    local Level = Game:GetLevel()
    local Stage = Level:GetStage()


    local ShouldKeep = (Door.TargetRoomType == RoomType.ROOM_BOSS and (Stage == LevelStage.STAGE4_3
                                                                       or Stage == LevelStage.STAGE6 and Door.TargetRoomIndex == -7 and Room:GetType() == RoomType.ROOM_BOSS))
                       or (Door.TargetRoomType == RoomType.ROOM_DEFAULT and Door.TargetRoomIndex < 0)
                       or Door.TargetRoomType == RoomType.ROOM_SECRET_EXIT
                       or Door.TargetRoomType == RoomType.ROOM_BOSSRUSH
                       or Door.CurrentRoomType == RoomType.ROOM_BOSSRUSH
                       or Level:GetStage() == LevelStage.STAGE8
                       or mod:IsTaintedHeartBossRoom()




    if ShouldKeep then

        if mod.AnimationIsPlaying or mod.Saved.BlindBeingPlayed == mod.BLINDS.WAITING_CASHOUT then

            Door:Close(true)
        else
            Door:TryUnlock(T_Jimbo)
        end

    else
        --print("removed door at: ", mod:GetValueIndex(DoorSlot, Door.Slot, true), Door.VarData, Door.State, mod:GetValueIndex(RoomType, Door.TargetRoomType, true), Door.TargetRoomIndex)


        Room:RemoveDoor(Door.Slot)
    end


end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, RemoveUnwantedDoors, GridEntityType.GRID_DOOR)


---@param Door GridEntityDoor
local function PreventDoorRendering(_, Door)

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        return
    end

    local Level = Game:GetLevel()

    local ShouldKeep = (Door.TargetRoomType == RoomType.ROOM_BOSS and Level:GetStage() ~= LevelStage.STAGE4_3)
                       or (Door.TargetRoomType == RoomType.ROOM_DEFAULT and Door.TargetRoomIndex < 0)
                       or Door.TargetRoomType == RoomType.ROOM_SECRET_EXIT
                       or Door.TargetRoomType == RoomType.ROOM_BOSSRUSH
                       or Door.CurrentRoomType == RoomType.ROOM_BOSSRUSH
                       or Level:GetStage() == LevelStage.STAGE8 -- home
                       or mod:IsTaintedHeartBossRoom()


    if not ShouldKeep then

        Game:GetRoom():RemoveDoor(Door.Slot)

        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, PreventDoorRendering, GridEntityType.GRID_DOOR)


---@param TrapDoor GridEntityStairs
local function RemoveCrawlSpaces(_, TrapDoor)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    Game:GetRoom():RemoveGridEntityImmediate(TrapDoor:GetGridIndex(), 0, true)

    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_STAIRCASE_RENDER, RemoveCrawlSpaces, GridEntityType.GRID_STAIRS)


---@param TrapDoor GridEntityTrapDoor
local function KeepTrapdoorsClosed(_, TrapDoor)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    --print(TrapDoor.State)

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.WAITING_CASHOUT then
        
        if TrapDoor.State ~= 0 then
            TrapDoor:GetSprite():SetAnimation("Closed")
        end

        --print("close")
        TrapDoor.State = 0

        return false
    else

        --print("open")
        TrapDoor.State = 1
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_TRAPDOOR_UPDATE, KeepTrapdoorsClosed, GridEntityType.GRID_TRAPDOOR)
--mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_TRAPDOOR_UPDATE, KeepTrapdoorsClosed, GridEntityType.GRID_TRAPDOOR)



local function RemoveUnwantedPickups(_, Pickup)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local Room = Game:GetRoom():GetType()

    if Room ~= RoomType.ROOM_SHOP and Room ~= RoomType.ROOM_BOSSRUSH
       and Pickup.Variant ~= PickupVariant.PICKUP_BIGCHEST
       and Pickup.Variant ~= PickupVariant.PICKUP_TROPHY
       and Pickup.Variant ~= PickupVariant.PICKUP_BED
       and Pickup.Variant ~= PickupVariant.PICKUP_MOMSCHEST
       and (Pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE
            or not (ItemsConfig:GetCollectible(Pickup.SubType):HasTags(ItemConfig.TAG_QUEST)
                    and not ItemsConfig:GetCollectible(Pickup.SubType):HasCustomTag("balatro"))) then
 
        Pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, RemoveUnwantedPickups)


---@param Door GridEntity
local function OpenStrangeDoor(_, Player, Index, Door)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not Door then
        return
    end

    Door = Door:ToDoor()

    if not Door then
        return
    end

    if Door:IsOpen() then
        return
    end

    local Mode = mod.SelectionParams[Player:GetData().TruePlayerIndex].Mode

    if Mode ~= mod.SelectionParams.Modes.NONE then
        return
    end


    if Door.TargetRoomIndex == -10 and Door.TargetRoomType == RoomType.ROOM_SECRET_EXIT then
        
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.SECRET_EXIT) --| mod.SelectionParams.Purposes.FORCED_FLAG)
    end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_GRID_COLLISION, OpenStrangeDoor, PlayerVariant.PLAYER)



local function PrintRoomInfo()

    --LIVES BOSS 1092 25
    --T.HEART 6040 90 --> BOSS 6030 89
    --ISAAC BOSS 3383 39
    --SATAN BOSS 3600  24
    --LAMB BOSS 5130 54
    --BB BOSS 3393 40
    --MOM BOSS 1060 (6)
    --RUSH 0 0
    --M.SATAN BOSS 5000 55
    --HUSH BOSS 0 63
    --BEAST MAUS. SECRET_EXIT (18) 3
    --BEAST NOTE BOSS 1 89
    --HOME [START DEF. 1 0] [HALL DEF. 2 1] [R.C. DEF. 5 10] [TV DEF. 4 3] [R.C. DEF. 6 11] [MOM DEF. 3 2]
    --DOGMA DEF. 1000 3
    --BEAST DUNGEON 666 4
    --MOTHER BOSS 6000 88 || BOSS 1 88

    --ROTGUT DUNGEON 1010 2 ---> 1020 3

    local Data = Game:GetLevel():GetCurrentRoomDesc().Data
    print("------ROOM--------")
    print(mod:GetValueIndex(RoomType, Data.Type, true), Data.Variant, Data.Subtype)
    --print(mod.Saved.SmallCleared)
    print("--------------")


end
--mod:AddCallback(ModCallbacks.MC_POST_UPDATE, PrintRoomInfo)
