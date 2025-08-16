---@diagnostic disable: need-check-nil, cast-local-type

local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local TimerFixerVariable = 0
local BlindGotCleared = false --prevents blind clear callback to be called multiple times in the same frame

local HAND_POOF_COLOR = Color(1,1,1,1,0,0,0,0.27,0.59, 1.5,1) --0.95

--local LevelDescriptorFlags = {SMALL_BLIND = 1 << 20, BIG_BLIND = 1 << 21, JIMBO_SHOP = 1 << 22}

mod.FullDoorSlot = {[RoomShape.ROOMSHAPE_1x1] = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.UP0 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_1x2] = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.LEFT1 | 1 << DoorSlot.UP0 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.RIGHT1 | 1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_2x1] = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.UP0 | 1 << DoorSlot.UP1 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.DOWN1 | 1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_IH] = 1 << DoorSlot.LEFT0 |  1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_IIH] = 1 << DoorSlot.LEFT0 |  1 << DoorSlot.RIGHT0,
                    [RoomShape.ROOMSHAPE_IV] = 1 << DoorSlot.UP0 |  1 << DoorSlot.DOWN0,
                    [RoomShape.ROOMSHAPE_IIV] = 1 << DoorSlot.UP0 |  1 << DoorSlot.DOWN0,
                    FULL = 1 << DoorSlot.LEFT0 | 1 << DoorSlot.UP0 | 1 << DoorSlot.DOWN0 | 1 << DoorSlot.RIGHT0 | 1 << DoorSlot.LEFT1 | 1 << DoorSlot.UP1 | 1 << DoorSlot.DOWN1 | 1 << DoorSlot.RIGHT1}


local SCREEN_TO_WORLD_RATIO = 4

local BASE_HAND_RADIUS = 30 --this gets increased by the handtype's base mult value (considering planet upgrades)



----FUTURE GLOBALS -----


-----------------------------------




--setups variables for jimbo
---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.TaintedJimbo then
        local Data = player:GetData()

        Data.ConfirmHoldTime = 0 --used to detect if it got held or pressed
        Data.MapHoldTime = 0 --used to detect if it got held or pressed

        --player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)

        player:AddCustomCacheTag(mod.CustomCache.HAND_COOLDOWN, true)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)



local DescriptionHelperVariant = Isaac.GetEntityVariantByName("Description Helper")
local DescriptionHelperSubType = Isaac.GetEntitySubTypeByName("Description Helper")

local function CreateDescEntity()

    for i, Player in ipairs(PlayerManager.GetPlayers()) do

        if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
            local Effect = Game:Spawn(EntityType.ENTITY_EFFECT, DescriptionHelperVariant, Player.Position,
                                  Vector.Zero, nil, DescriptionHelperSubType, 1):ToEffect()
            Effect:FollowParent(Player)
            Effect:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CreateDescEntity)



--Adds the small/big blind rooms + saves the room index of shops and boss rooms
---@param RoomConfig RoomConfigRoom
---@param LevelGen LevelGeneratorRoom
local function SaveBossRoomIndex(_,LevelGen,RoomConfig,Seed)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end
    
    --print(RoomIndex)
    Game:GetLevel():GetRoomByIdx(LevelGen:Column() + LevelGen:Row()*13)

    if RoomConfig.Type == RoomType.ROOM_BOSS then --and (not RoomConfig.StageID == 26 or RoomConfig.Shape == RoomShape.ROOMSHAPE_2x2) then

        mod.Saved.BossIndex = LevelGen:Column() + LevelGen:Row()*13


    elseif RoomConfig.Type == RoomType.ROOM_ULTRASECRET then

        --the blind rooms are placed next to the ultra sectret since it has guaranteed space close to it
        --mod:PlaceBlindRooms(LevelGen:Column(), LevelGen:Row())
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, SaveBossRoomIndex)



local function FloorModifier()

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local Rooms = Game:GetLevel():GetRooms()

    for i = 0, Rooms.Size - 1 do
        
        local Room = Rooms:Get(i)

        Room.AllowedDoors = mod.FullDoorSlot[Room.Data.Shape] or mod.FullDoorSlot.FULL --(i think) helps to always give the blind rooms a valid position 
    end

    mod:PlaceBlindRoomsForReal()

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, FloorModifier)


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



--makes basically every input possible when using T jimbo (+ other stuff)
---@param Player EntityPlayer
local function JimboInputHandle(_, Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo or not mod.GameStarted then
        return
    end
    local PlayerData = Player:GetData()
    local PIndex = PlayerData.TruePlayerIndex
    local Params = mod.SelectionParams[PIndex]

    ----------------------------------------

    --local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    
    -------------INPUT HANDLING-------------------


    --confirms the current selection
    if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then

        mod:UseSelection(Player)

    elseif Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Player.ControllerIndex) then

    
        local Success = mod:DiscardSelection(Player)

    end


    if mod.AnimationIsPlaying then
        return
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

                    local JokerProgs = mod.Saved.Player[PIndex].Progress.Inventory
                    JokerProgs[Params.Index],  JokerProgs[Params.Index + Step] = 
                    JokerProgs[Params.Index + Step],  JokerProgs[Params.Index]

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

                    local JokerProgs = mod.Saved.Player[PIndex].Progress.Inventory
                    JokerProgs[Params.Index],  JokerProgs[Params.Index + Step] = 
                    JokerProgs[Params.Index + Step],  JokerProgs[Params.Index]
                end

                mod.Counters.SinceSelect = 0
        end

        Params.Index = Params.Index + Step

    
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
        local IsPackActive = Params.PackPurpose ~= mod.SelectionParams.Purposes.NONE
        local CurrentMode = Params.Mode

        if CurrentMode == mod.SelectionParams.Modes.INVENTORY
           or CurrentMode == mod.SelectionParams.Modes.CONSUMABLES then
           
           
            if mod.Saved.EnableHand then

                DestinationMode = mod.SelectionParams.Modes.HAND
            else
                DestinationMode = mod.SelectionParams.Modes.NONE
            end

        elseif CurrentMode == mod.SelectionParams.Modes.HAND and IsPackActive then
    
            DestinationMode = mod.SelectionParams.Modes.PACK
        end

        if DestinationMode then
            mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)
        end

    end

--[[
    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
        
        local CardToUse = mod:FrameToSpecialCard(mod.Saved.Player[PIndex].Consumables[#mod.Saved.Player[PIndex].Consumables].Card)
        local Success = mod:TJimboUseCard(CardToUse, Player, false)
        --print(Success)
    end]]

    
    if Input.IsActionTriggered(ButtonAction.ACTION_DROP, Player.ControllerIndex) then

        if mod.Saved.HandOrderingMode == mod.HandOrderingModes.Rank then

            mod.Saved.HandOrderingMode = mod.HandOrderingModes.Suit
        else
            mod.Saved.HandOrderingMode = mod.HandOrderingModes.Rank
        end

        mod:ReorderHand(Player)
    end

    if Input.IsActionPressed(ButtonAction.ACTION_MAP, Player.ControllerIndex) then

        if mod.Saved.DeckPreviewMode == mod.DeckPreviewModes.OFF then

            mod.Saved.DeckPreviewMode = mod.DeckPreviewModes.PARTIAL
        end

        PlayerData.MapHoldTime = PlayerData.MapHoldTime + 1

    elseif PlayerData.MapHoldTime ~= 0 then --button got released

        if PlayerData.MapHoldTime >= mod.HOLD_THRESHOLD then --released form holding
            
            if mod.Saved.DeckPreviewMode == mod.DeckPreviewModes.PARTIAL then

                mod.Saved.DeckPreviewMode = mod.DeckPreviewModes.OFF
            end

        else --realesed from pressing

            if mod.Saved.DeckPreviewMode == mod.DeckPreviewModes.PARTIAL then

                mod.Saved.DeckPreviewMode = mod.DeckPreviewModes.FULL

            elseif mod.Saved.DeckPreviewMode == mod.DeckPreviewModes.FULL then

                mod.Saved.DeckPreviewMode = mod.DeckPreviewModes.OFF
            end
        end


        PlayerData.MapHoldTime = 0
    end


end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JimboInputHandle)



local function SetupRoom()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local Room = Game:GetRoom()

    if Room:IsClear() then
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
            
            Grid:Destroy()

            if Grid:GetVariant() == GridPoopVariant.RED then
                --Grid.ReviveTimer = -1
            end

        end
    end


    local Width = Room:GetGridWidth()
    local Height = Room:GetGridHeight()

    for i=2, Width-1, 2 do
        local Position = Room:GetGridPosition(i + math.random(2, Height-1)*Width)

        Game:Spawn(mod.Entities.BALATRO_TYPE, mod.Entities.PATH_SLAVE, Position,
                   Vector.Zero, nil, 0, 1)

    end

    for i=2, Height-1, 2 do
        local Position = Room:GetGridPosition(math.random(2, Width-1) +i*Width)

        Game:Spawn(mod.Entities.BALATRO_TYPE, mod.Entities.PATH_SLAVE, Position,
                   Vector.Zero, nil, 0, 1)

    end


    
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SetupRoom)



---@param NPC EntityNPC
---@param Target Entity
local function PreventTjimboTarget(_, NPC, Target)

    local Player = Target:ToPlayer()

    if not Player or Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then

        return
    end

    --Tjimbo shouldn't be targeted by enemies, so make them move semi-randomly against entities spawned in SpawnAdditionalTargets()

    local PossibleTargets = Isaac.FindByType(mod.Entities.BALATRO_TYPE, mod.Entities.PATH_SLAVE)

    local NewTarget = mod:GetRandom(PossibleTargets)

    if NewTarget then
        NPC:TryForceTarget(NewTarget, 25) --puts a timer in between the target changes so the enemies don't look like they're having a seizure
    end

    --return NewTarget
    
end
mod:AddCallback(ModCallbacks.MC_NPC_PICK_TARGET, PreventTjimboTarget)



function mod:SpawnShopItems(Rerolled)

    local Room = Game:GetRoom()

    if Rerolled then

        --remove the old items to the spawn the new ones
        
        for _,Entity in ipairs(Isaac.GetRoomEntities()) do
        
            if Entity.Type == EntityType.ENTITY_PICKUP
               and (Entity.Variant == PickupVariant.PICKUP_TRINKET
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

        local Variant, SubType, TagActivated = mod:RandomShopItem(mod.RNGs.SHOP)


        local Grid = 66 - NumItems + i*2

        local Item = Game:Spawn(EntityType.ENTITY_PICKUP, Variant, Room:GetGridPosition(Grid),
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

    if Room:IsFirstVisit() then --removes any item that was previously put in the shop
        
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

        mod:SpawnBalatroPressurePlate(Room:GetGridPosition(56), mod.Grids.PlateVariant.SHOP_EXIT, 0)

        mod:SpawnBalatroPressurePlate(Room:GetGridPosition(48), mod.Grids.PlateVariant.REROLL, mod.Saved.RerollStartingPrice + 0)


        local Voucher = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Room:GetGridPosition(95),
                                   Vector.Zero, nil, mod.Saved.AnteVoucher, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()

---@diagnostic disable-next-line: need-check-nil
        Voucher:MakeShopItem(-2)

    else --removes everything exept for the vouchers

        for _,Entity in ipairs(Isaac.GetRoomEntities()) do
        
            if Entity.Type == EntityType.ENTITY_PICKUP
               and (Entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE
                   or Entity.SubType == mod.Saved.AnteVoucher) then

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


    mod:SpawnShopItems(false)

    for i=1, 2 do
        
        local Grid = 95 + i*2
        local Pack = mod:RandomPack(mod.RNGs.SHOP, true)

        local Booster =  Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Room:GetGridPosition(Grid),
                   Vector.Zero, nil, Pack, mod:RandomSeed(mod.RNGs.SHOP)):ToPickup()

---@diagnostic disable-next-line: need-check-nil
        Booster:MakeShopItem(-2)

        if CouponTag then
        ---@diagnostic disable-next-line: need-check-nil
            Booster.Price = PickupPrice.PRICE_FREE
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
    
        Cost = mod:GetJokerCost(SubType, mod.Saved.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(SubType).Name] or 0)

    elseif SubType >= mod.Packs.ARCANA and SubType <= mod.Packs.MEGA_SPECTRAL then


        local QualityModule = SubType%3 

        if QualityModule == mod.PackQualityModule.MEGA then
            Cost = 8
        elseif QualityModule == mod.PackQualityModule.JUMBO then
            Cost = 6
        else
            Cost = 4
        end
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

end
mod:AddCallback(mod.Callbalcks.HAND_UPDATE, mod.UpdateCurrentHandType)


local function effectTest(_, Effect)
    
    print(Effect.Variant, Effect.SubType)
end
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, effectTest)



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
            break
        end
    end

    if not TargetPosition then
        print("couldn't find shit, sorry!")
        return
    end


    local HandHype = mod.Saved.HandType

    local RadiusMultiplier = mod.Saved.HandsStat[HandHype].Mult

    local FullHandDamage = mod.Saved.TotalScore + 0

    
    --enemies inside the radius shown take damage twice, others only once

    for _, Enemy in ipairs(Isaac.FindInRadius(TargetPosition, 
                                              BASE_HAND_RADIUS * RadiusMultiplier + 5,
                                              EntityPartition.ENEMY)) do
        if Enemy:IsActiveEnemy() then

            if Enemy:IsVulnerableEnemy() then
                Enemy:TakeDamage(math.ceil(FullHandDamage*0.3),
                                 DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(Player), 0)

            else --invulnerable enemies take damage only if inside the radius
                Enemy:TakeDamage(FullHandDamage,
                                 DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(Player), 0)
            end
        end
    end

    local PoofScale = 0.5 * RadiusMultiplier

    mod:TrueBloodPoof(TargetPosition, PoofScale, HAND_POOF_COLOR)


    --second damage tick
    Isaac.CreateTimer(function ()
        for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

            if Enemy:IsActiveEnemy() and Enemy:IsVulnerableEnemy() then

                Enemy:TakeDamage(FullHandDamage*0.75,
                                 DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(Player), 0)

                local PoofScale = 0.035 * Enemy.Size

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
    end, 10, 1, true)

end
--mod:AddCallback(mod.Callbalcks.POST_HAND_PLAY, mod.ActivateCurrentHand)


local function ClearBlindOnEnemyDeath(_,NPC)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) or BlindGotCleared then
        return
    end

    --after playing the hand, checks if everyone is dead, in that case the blind is cleared
    local AllDead = true

    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:IsActiveEnemy() and Enemy:IsVulnerableEnemy()
           and (not Enemy:IsDead() or not Enemy:HasMortalDamage()) then
            
            AllDead = false
            break
        end
    end

    --print(AllDead)

    if AllDead then

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

                if mod.Saved.IsSpecialBoss then 
                
                    Player:AddCustomCacheTag(mod.CustomCache.DISCARD_NUM)
                    Player:AddCustomCacheTag(mod.CustomCache.HAND_NUM, true)

                    mod.Saved.Player[PIndex].FirstDeck = false
                else
                    sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
                    Isaac.CreateTimer(function ()
                                        Player:Kill()
                                    end, 40, 1, true)

                    return
                end
            end
        end
    
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ClearBlindOnEnemyDeath)


---@param Player EntityPlayer
function mod:SetupForHandScoring(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.Saved.HandsRemaining = mod.Saved.HandsRemaining - 1

    if mod.Saved.Player[PIndex].FirstDeck then
        mod.Saved.HandsPlayed = mod.Saved.HandsPlayed + 1
    end


    mod.Saved.HandsTypeUsed[mod.Saved.HandType] = mod.Saved.HandsTypeUsed[mod.Saved.HandType] + 1

    local TIMER_INCREASE = 4
    local CurrentTimer = TIMER_INCREASE

    mod.SelectionParams[PIndex].PlayedCards = {}

    local HandIndex = 1
    local SelectionIndex = 1

    while SelectionIndex <= #mod.Saved.Player[PIndex].CurrentHand do
        
        local IsSelected = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][SelectionIndex]

        if IsSelected then

            local TrueHandIndex = HandIndex --otherwise the value gets modified in the timer itself

            Isaac.CreateTimer(function ()

                mod.SelectionParams[PIndex].PlayedCards[#mod.SelectionParams[PIndex].PlayedCards+1] = mod.Saved.Player[PIndex].CurrentHand[TrueHandIndex] + 0

                table.remove(mod.Saved.Player[PIndex].CurrentHand, TrueHandIndex)
                table.remove(mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND], TrueHandIndex)

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

                    print(i, "is selected")

                    NumDiscarded = NumDiscarded + 1

                    local GotDestroyed

                    ExtraInterval, GotDestroyed = Isaac.RunCallback(mod.Callbalcks.CARD_DISCARD, Player, mod.Saved.Player[PIndex].CurrentHand[SelectionIndex], 
                                                 SelectionIndex, NumDiscarded == mod.SelectionParams[PIndex].SelectionNum)


                    local IndexToDestroy = i

                    if not GotDestroyed then
                        Isaac.CreateTimer(function ()

                            table.remove(HandSelectedCards, IndexToDestroy)
                            table.remove(mod.Saved.Player[PIndex].CurrentHand, IndexToDestroy)

                            print("removed", IndexToDestroy)

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

        print("second part done")

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

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_BELL then
        local BellRNG = Player:GetDropRNG()

        Isaac.CreateTimer(function ()
            mod.Saved.BossBlindVarData = BellRNG:RandomInt(mod.SelectionParams[PIndex].OptionsNum) + 1
        end, Interval, 1, true)

        Interval = Interval + 4

    elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_HEART then
        local HeartRNG = Player:GetDropRNG()
        local PIndex = Player:GetData().TruePlayerIndex

        mod.Saved.BossBlindVarData = HeartRNG:RandomInt(#mod.Saved.Player[PIndex].Inventory) + 1
        
        Isaac.CreateTimer(function ()
            
            local DebuffedSlot = mod.Saved.Player[PIndex].Inventory[mod.Saved.BossBlindVarData]
            DebuffedSlot.Modifiers = DebuffedSlot.Modifiers | mod.Modifier.DEBUFFED
        end, Interval, 1, true)

        Interval = Interval + 4
    end


    Isaac.CreateTimer(function ()

        mod.SelectionParams[PIndex].PlayedCards = {}
        
        mod.Saved.HandType = mod.HandTypes.NONE
        mod.SelectionParams[PIndex].PossibleHandType = mod.HandFlags.NONE

        mod.SelectionParams[PIndex].ScoringCards = 0


        Player:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)
        
        local Delay, DeckFinished = mod:RefillHand(Player, true)


        --print("scoring: ", mod.SelectionParams[PIndex].ScoringCards)
        mod.Counters.SinceSelect = 0
        mod.AnimationIsPlaying = false

        mod.Saved.ChipsValue = 0
        mod.Saved.MultValue = 0

        Isaac.CreateTimer(function ()

            --print("switched hand ON")
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
        end, Delay, 1, true)
        
    end, 6, 1, true)
end
mod:AddPriorityCallback(mod.Callbalcks.POST_HAND_PLAY, CallbackPriority.LATE, mod.SetupForNextHandPlay)



local LineBlue = KColor(mod.EffectKColors.BLUE.Red,mod.EffectKColors.BLUE.Green,mod.EffectKColors.BLUE.Blue,0.65)


---@param Effect EntityEffect
local function MoveHandTarget(_,Effect)

    local Player = Effect.Parent and Effect.Parent:ToPlayer() or nil

    if not Player or Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    Game:GetRoom():GetCamera():SetFocusPosition(Effect.Position + Effect.Velocity)

    Effect:AddVelocity(Player:GetAimDirection()*3.25)

    local PIndex = Player:GetData().TruePlayerIndex
    local HandHype = mod.Saved.HandType

    local Radius = BASE_HAND_RADIUS *mod.Saved.HandsStat[HandHype].Mult

    for _, Enemy in ipairs(Isaac.FindInRadius(Effect.Position, Radius, EntityPartition.ENEMY)) do
        
        Enemy:SetColor(Color(1.5,1.5,1.5,1, 0.1, 0.1, 0.1), 2, 100, true, false)

    end

    local TLClamp = Isaac.WorldToScreen(Game:GetRoom():GetTopLeftPos())
    local BRClamp = Isaac.WorldToScreen(Game:GetRoom():GetBottomRightPos())

    local NumSides = (Radius // 60)*2 + 6 --number of actually drawn lines
    local Step = 90 / NumSides

    Radius = mod:CoolLerp(5, Radius, Effect.FrameCount / 20)
     
    local StartRotation = (Isaac.GetFrameCount()*1.5) % 360

    local EffectPos = Isaac.WorldToScreen(Effect.Position)
    local FirstPoint = Isaac.WorldToScreenDistance(Vector(0, Radius)):Rotated(StartRotation)
    local SecondPoint

    for i=1, NumSides do --idk why having an odd amount of sides makes the circle not complete
        
        SecondPoint = FirstPoint:Rotated(Step)

        Isaac.DrawLine((EffectPos + FirstPoint):Clamped(TLClamp.X, TLClamp.Y, BRClamp.X, BRClamp.Y), 
                       (EffectPos + SecondPoint):Clamped(TLClamp.X, TLClamp.Y, BRClamp.X, BRClamp.Y),
                       LineBlue, mod.EffectKColors.BLUE, 3)

        FirstPoint = SecondPoint:Rotated(Step)


        Isaac.DrawLine((EffectPos + FirstPoint):Clamped(TLClamp.X, TLClamp.Y, BRClamp.X, BRClamp.Y), 
                       (EffectPos + SecondPoint):Clamped(TLClamp.X, TLClamp.Y, BRClamp.X, BRClamp.Y),
                       LineBlue, mod.EffectKColors.BLUE, 3)

        FirstPoint = FirstPoint:Rotated(Step*2)
        SecondPoint = SecondPoint:Rotated(Step*2)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, MoveHandTarget, EffectVariant.TARGET)


------------BLIND SYSTEM------------
------------------------------------


---@param Plate GridEntityPressurePlate
local function OnBlindButtonPressed(_, Plate)

    local Variant = Plate:GetVariant()
    local VarData = Plate.VarData

    --apparently when buttons are pressed the timers activate frame one so I just put a second timer inside the first one

    if Variant == mod.Grids.PlateVariant.REROLL then

        local Price = VarData

        if mod:PlayerCanAfford(Price) then

            local Player = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

            mod:SpendMoney(Price)
            

            mod.Saved.NumShopRerolls = mod.Saved.NumShopRerolls + 1


            local NumClowns = #mod:GetJimboJokerIndex(Player, mod.Jokers.CHAOS_CLOWN, true)

            if mod.Saved.NumShopRerolls < NumClowns then
                
                Plate.VarData = 0

            else
                Plate.VarData = mod.Saved.RerollStartingPrice + (mod.Saved.NumShopRerolls - NumClowns)
            end
            --print("increased to:", Plate.VarData)

            Isaac.RunCallback(mod.Callbalcks.SHOP_REROLL)

            mod:SpawnShopItems(true)

            sfx:Play(mod.Sounds.MONEY)
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        end


    elseif Variant == mod.Grids.PlateVariant.CASHOUT then

        mod.Saved.BlindBeingPlayed = mod.BLINDS.SHOP

        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            Player:AnimateTeleport(true)

            if mod.Saved.Player[Player:GetData().TruePlayerIndex].FirstDeck then
                mod.Saved.DiscardsWasted = mod.Saved.DiscardsWasted + mod.Saved.DiscardsRemaining
            end

            mod.Saved.Player[Player:GetData().TruePlayerIndex].FirstDeck = true

            --restores hands and discards available
            Player:AddCustomCacheTag(mod.CustomCache.DISCARD_NUM)
            Player:AddCustomCacheTag(mod.CustomCache.HAND_NUM, true)

            Player:AddCoins(Plate.VarData)
        end

        Isaac.CreateTimer(function ()
            Isaac.CreateTimer(function ()

                Game:StartRoomTransition(mod.Saved.ShopIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)

                sfx:Play(mod.Sounds.MONEY)
            end, 7, 1, true)
        end, 0, 1, true)

    elseif Variant == mod.Grids.PlateVariant.SHOP_EXIT then

         mod.Saved.BlindBeingPlayed = mod.BLINDS.NONE

        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            Player:AnimateTeleport(true)
        end

        Isaac.CreateTimer(function ()
                                if TimerFixerVariable == 1 then

                                    Game:StartRoomTransition(Game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                    
                                    TimerFixerVariable = 0

                                    local Interval = Isaac.RunCallback(mod.Callbalcks.SHOP_EXIT)



                                    return
                                end

                                TimerFixerVariable = TimerFixerVariable + 1

                            end, 7, 3, true)

    elseif Variant == mod.Grids.PlateVariant.SMALL_BLIND_SKIP then

        local Interval = mod:AddSkipTag(Plate.VarData)

        Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, mod.BLINDS.SMALL, Plate.VarData) --throwback

        mod.AnimationIsPlaying = true

        Isaac.CreateTimer(function ()

            mod.AnimationIsPlaying = false

        end, Interval, 1, true)
        

    elseif Variant == mod.Grids.PlateVariant.BIG_BLIND_SKIP then
    
        local Interval = mod:AddSkipTag(Plate.VarData)

        Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, mod.BLINDS.BIG) --throwback

        mod.AnimationIsPlaying = true

        Isaac.CreateTimer(function ()

            mod.AnimationIsPlaying = false

        end, Interval, 1, true)

    elseif Variant == mod.Grids.PlateVariant.BLIND then

        mod.Saved.BlindBeingPlayed = VarData

        local Lang = mod:GetEIDLanguage()

        mod.Saved.CurrentBlindName = mod.Descriptions.BlindNames[mod.Saved.BlindBeingPlayed][Lang] or mod.Descriptions.BlindNames[mod.Saved.BlindBeingPlayed]["en_us"]

        

        mod.Saved.CurrentBlindReward = mod:GetBlindReward(mod.Saved.BlindBeingPlayed)
        mod.Saved.CurrentRound = mod.Saved.CurrentRound + 1

        local InitialInterval = Isaac.RunCallback(mod.Callbalcks.BLIND_SELECTED, VarData)

        Isaac.CreateTimer(function ()

            if TimerFixerVariable == 0 then
                TimerFixerVariable = TimerFixerVariable + 1

            else

                TimerFixerVariable = 0

                for i,Player in ipairs(PlayerManager.GetPlayers()) do

                    Player:AnimateTeleport(true)
                end

                if VarData == mod.BLINDS.SMALL then

                    local Iteration = 0

                    Isaac.CreateTimer(function()
                                    
                                    Iteration = Iteration + 1
                                    --print(TimerFixerVariable)
                                    if Iteration == 1 then
                                        Game:StartRoomTransition(mod.Saved.SmallBlindIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                    
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
                                        
                                        else--if Iteration == 2 then
                                            local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                        
                                            Isaac.CreateTimer(function ()
                                                Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, VarData)
                                            end, Interval, 1, true)
                                        
                                            return
                                        end
                                    
                                    end, 7, 2, true)
                                
                else --BOSS BLIND

                    local Iteration = 0
                
                    Isaac.CreateTimer(function ()

                                        Iteration = Iteration + 1

                                        if Iteration == 1 then
                                            Game:StartRoomTransition(mod.Saved.BossIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                            TimerFixerVariable = TimerFixerVariable + 1
                                        
                                        else --if Iteration == 2 then
                                            local Interval = Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                            TimerFixerVariable = 0
                                        
                                            Isaac.CreateTimer(function ()
                                                Isaac.RunCallback(mod.Callbalcks.POST_BLIND_START, VarData)
                                            end, Interval, 1, true)
                                        end
                                    
                                    end, 7, 2, true)
                                
                end

            end
            
        end, InitialInterval, 2, true)        
    end

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


                if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_ACORN then
            
                    local PIndex = Player:GetData().TruePlayerIndex

                    local Inventory = mod.Saved.Player[PIndex].Inventory

                    for i,_ in ipairs(Inventory) do

                        Interval = Interval + 1

                        local Slot = Inventory[i]
                        
                        Slot.Modifiers = Slot.Modifiers | mod.Modifier.COVERED
                    end

                    Interval = Interval + 2

                    local ShuffleRNG = Player:GetDropRNG()

                    for i = #Inventory, 2 ,-1 do

                        Interval = Interval + 2

                        Isaac.CreateTimer(function ()

                          local j = ShuffleRNG:RandomInt(i) + 1

                          Inventory[i], Inventory[j] = Inventory[j], Inventory[i]

                        end, Interval, 1, true)
                    end
                    
                    Interval = Interval + 4

                elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_BELL then
                    local BellRNG = Player:GetDropRNG()
                    local PIndex = Player:GetData().TruePlayerIndex

                    Isaac.CreateTimer(function ()
                        mod.Saved.BossBlindVarData = BellRNG:RandomInt(mod.SelectionParams[PIndex].OptionsNum) + 1
                    end, Interval, 1, true)

                    Interval = Interval + 4
                
                elseif mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_HEART then
                    local HeartRNG = Player:GetDropRNG()
                    local PIndex = Player:GetData().TruePlayerIndex

                    mod.Saved.BossBlindVarData = HeartRNG:RandomInt(#mod.Saved.Player[PIndex].Inventory) + 1
                
                    Isaac.CreateTimer(function ()

                        local DebuffedSlot = mod.Saved.Player[PIndex].Inventory[mod.Saved.BossBlindVarData]
                        DebuffedSlot.Modifiers = DebuffedSlot.Modifiers | mod.Modifier.DEBUFFED
                    end, Interval, 1, true)

                    Interval = Interval + 4
                end


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

        mod.Saved.SmallCleared = true

    else --if BlindType == mod.BLINDS.BIG then
        mod.Saved.BigCleared = true
    end
end
mod:AddPriorityCallback(mod.Callbalcks.BLIND_SKIP, CallbackPriority.IMPORTANT, OnBlindSkip)



local function OnTagAdded(_, TagAdded)

    local Interval = 8

    local T_Jimbo = PlayerManager.FirstPlayerByType(mod.Characters.TaintedJimbo)

    if not T_Jimbo then
        
        print("wtf why isn't Jimbo here")
        return
    end

    local PIndex = T_Jimbo:GetData().TruePlayerIndex
      
    for i,Tag in ipairs(mod.Saved.SkipTags) do

        
        --TagAdded == Tag and
        if Tag == mod.SkipTags.BOSS then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                
                    local BossPlate = Game:GetRoom():GetGridEntity(70):ToPressurePlate()

                    local WasSpecialBoss = BossPlate.VarData >= mod.BLINDS.BOSS_ACORN

                    mod.Saved.AnteBoss = mod:RandomBossBlind(mod.RNGs.BOSS_BLINDS, WasSpecialBoss)

                    BossPlate.VarData = mod.Saved.AnteBoss

                    mod:TrueBloodPoof(BossPlate.Position, 1, mod.EffectColors.PURPLE)

                    mod:UpdateBalatroPlate(BossPlate, true)

                    mod:UseSkipTag(1) --boss tags are used only when obtained, so they are always first

                end, Interval, 1, true)
            end, 0, 1, true)


        elseif Tag == mod.SkipTags.HANDY then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    local Money = mod.Saved.HandsPlayed

                    T_Jimbo:AddCoins(Money)

                    mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                    mod:UseSkipTag(1)
                
                end, Interval, 1, true)
            end, 0, 1, true)

        elseif Tag == mod.SkipTags.GARBAGE then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()

                Isaac.CreateTimer(function ()
                    local Money = mod.Saved.DiscardsWasted

                    T_Jimbo:AddCoins(Money)

                    mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                    mod:UseSkipTag(1)

                end, Interval, 1, true)
            end, 0, 1, true)
        elseif Tag == mod.SkipTags.SPEED then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    local Money = 5 * (mod.Saved.NumBlindsSkipped - 1) --doesn't consider the one just skipped

                    T_Jimbo:AddCoins(Money)

                    mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                    mod:UseSkipTag(1)

                end, Interval, 1, true)
            end, 0, 1, true)
            
        elseif Tag == mod.SkipTags.ECONOMY then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    local Money = math.min(40, T_Jimbo:GetNumCoins())

                    T_Jimbo:AddCoins(Money)

                    mod:CreateBalatroEffect(T_Jimbo, mod.EffectColors.YELLOW, mod.Sounds.MONEY, "+"..tostring(Money).."$",  mod.EffectType.ENTITY, T_Jimbo)
                    mod:UseSkipTag(1)

                end, Interval, 1, true)
            end, 0, 1, true)
        elseif Tag == mod.SkipTags.TOP_UP then

            Interval = Interval + 20

            Isaac.CreateTimer(function ()
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
            end, 0, 1, true)

        elseif Tag == mod.SkipTags.STANDARD then

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    SkipTagPackOpen(mod.Packs.MEGA_STANDARD)
                end, Interval, 1, true)
            end, 0, 1, true)

        elseif Tag == mod.SkipTags.CHARM then

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    SkipTagPackOpen(mod.Packs.MEGA_ARCANA)
                end, Interval, 1, true)
            end, 0, 1, true)

        elseif Tag == mod.SkipTags.BUFFON then

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    SkipTagPackOpen(mod.Packs.MEGA_BUFFON)
                end, Interval, 1, true)
            end, 0, 1, true)

        elseif Tag == mod.SkipTags.METEOR then

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    SkipTagPackOpen(mod.Packs.MEGA_CELESTIAL)
                end, Interval, 1, true)
            end, 0, 1, true)

        elseif Tag == mod.SkipTags.ETHEREAL then

            Isaac.CreateTimer(function ()
                Isaac.CreateTimer(function ()
                    SkipTagPackOpen(mod.Packs.SPECTRAL)
                end, Interval, 1, true)
            end, 0, 1, true)

        elseif Tag & mod.SkipTags.ORBITAL ~= 0 then

            
            local HandType = Tag & ~mod.SkipTags.ORBITAL

            local PlanetInterval = mod:PlanetUpgradeAnimation(HandType, 3, Interval)
            
            Interval = Interval + PlanetInterval
        end

        i = i + 1
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

    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:ToNPC() then
            Enemy:Remove()
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

        if GridEntity:IsBreakableRock() then
            GridEntity:Destroy()

        else
            local Pit = GridEntity:ToPit()

            if Pit then

                Pit:MakeBridge()
            end
        end

        ::SKIP_TILE::
    end

    if BlindData == mod.BLINDS.SMALL then
        mod.Saved.SmallCleared = true

    elseif BlindData == mod.BLINDS.BIG then
        mod.Saved.BigCleared = true

    else --if BlindData & mod.BLINDS.BOSS ~= 0 then
        mod.Saved.BossCleared = mod.BossProgress.CLEARED
    end

    local Interval = Isaac.RunCallback(mod.Callbalcks.POST_BLIND_CLEAR, BlindData)

    Isaac.CreateTimer(function ()

        BlindGotCleared = false

        local TotalGain = Isaac.RunCallback(mod.Callbalcks.CASHOUT_EVAL, BlindData)

        mod:SpawnBalatroPressurePlate(Room:GetCenterPos(), mod.Grids.PlateVariant.CASHOUT, TotalGain)
        
    end, Interval, 1, true)
    

    mod.Saved.BlindBeingPlayed = mod.BLINDS.WAITING_CASHOUT
end
mod:AddCallback(mod.Callbalcks.BLIND_CLEAR, OnBlindClear)



local function InitializeAnte()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    if not mod.GameStarted then --wait a frame to let the variables get set up (see Callback System.lua)
        
        Isaac.CreateTimer(function ()
            InitializeAnte()
        end,0,1,true)

        return
    end

    mod.Saved.AnteLevel = mod.Saved.AnteLevel + 1

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

    local CurrentStage = Game:GetLevel():GetStage()

    local IsSpecialBoss = CurrentStage == LevelStage.STAGE4_2 --mom's heart / mother floor
                        or CurrentStage == LevelStage.STAGE6 -- dark room / chest
                        or CurrentStage == LevelStage.STAGE7 --void
                        or CurrentStage == LevelStage.STAGE8 -- home


    mod.Saved.AnteBoss = mod:RandomBossBlind(mod.RNGs.BOSS_BLINDS, IsSpecialBoss)

    if mod.Saved.AnteBoss == mod.BLINDS.BOSS_OX then
        
        local _
        --saves the currently most used card
        _,mod.Saved.BossBlindVarData = mod:GetMax(mod.Saved.HandsTypeUsed)

    elseif mod.Saved.AnteBoss == mod.BLINDS.BOSS_PILLAR then
        
        --holds a table containing the pointers of cards used (also needs to be modifies on card add/removal)
        mod.Saved.BossBlindVarData = {}

    else
        mod.Saved.BossBlindVarData = 0
    end


    mod.Saved.AnteVoucher = mod:GetRandom(mod.Saved.Pools.Vouchers, mod.RNGs.VOUCHERS)

    --print("Voucher:",mod.Saved.AnteVoucher)

    -------------CUSTOM PRESSURE PLATES-------------
    ------------------------------------------------
    
    mod.Saved.SmallCleared = false
    mod.Saved.BigCleared = false
    mod.Saved.BossCleared = mod.BossProgress.NOT_CLEARED
    

    local Room = Game:GetRoom()
    local Plate

    mod:SpawnBalatroPressurePlate(Room:GetGridPosition(49), mod.Grids.PlateVariant.BLIND, mod.BLINDS.SMALL)

    Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(52), mod.Grids.PlateVariant.BLIND, mod.BLINDS.BIG)
    Plate.State = 3
    Plate:GetSprite():Play("Switched")

    Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(70), mod.Grids.PlateVariant.BLIND, mod.Saved.AnteBoss)
    Plate.State = 3
    Plate:GetSprite():Play("Switched")


    mod:SpawnBalatroPressurePlate(Room:GetGridPosition(79), mod.Grids.PlateVariant.SMALL_BLIND_SKIP, mod:RandomSkipTag(mod.RNGs.SKIP_TAGS))


    Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(82), mod.Grids.PlateVariant.BIG_BLIND_SKIP, mod:RandomSkipTag(mod.RNGs.SKIP_TAGS))
    Plate.State = 3
    Plate:GetSprite():Play("Switched")

    --Plate:GetSprite():GetLayer(1):SetColor(Color.LaserIpecac)
    
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, InitializeAnte)




--all enemies' HP get scaled basing on how many antes have been cleared this run
local function EnemyHPScaling()

    if Game:GetRoom():IsClear() or not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then        
        return
    end

    local EnemyMaxHP = mod:GetBlindScoreRequirement(mod.Saved.BlindBeingPlayed)

    print("max score:", EnemyMaxHP)

    local HighestEnemyHP

    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:IsActiveEnemy() then
            
            HighestEnemyHP = HighestEnemyHP and math.max(Enemy.MaxHitPoints, HighestEnemyHP) or Enemy.MaxHitPoints
        end
    end

    --in the end the enemy with the highst HP will match the blind's required score
    mod.Saved.BlindScalingFactor = EnemyMaxHP / HighestEnemyHP

    for i,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:IsActiveEnemy() then
            
            Enemy.MaxHitPoints = Enemy.MaxHitPoints * mod.Saved.BlindScalingFactor
            Enemy.HitPoints = Enemy.HitPoints * mod.Saved.BlindScalingFactor

            Enemy:GetData().AlreadyAnteScaled = true
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EnemyHPScaling)



---@param SpawnedEnemy EntityNPC
local function SpawnedEnemyHPScaling(_,SpawnedEnemy)

    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    if Game:GetRoom():IsClear() then
        SpawnedEnemy:Remove()
        return
    end

    local ScalingFactor = mod.Saved.BlindScalingFactor

    local Spawner = SpawnedEnemy.SpawnerEntity

    while Spawner do
        
        ScalingFactor = ScalingFactor / 3

        Spawner = Spawner.SpawnerEntity
    end

    SpawnedEnemy.MaxHitPoints = SpawnedEnemy.MaxHitPoints * ScalingFactor
    SpawnedEnemy.HitPoints = SpawnedEnemy.HitPoints * ScalingFactor

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, SpawnedEnemyHPScaling)



------------------STATS------------------
-----------------------------------------


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
        Value = Value + mod.Saved.Player[PIndex].Progress.Inventory[Index]
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


    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_WATER then
        Value = 0
    end


    Value = math.max(Value, 0)


    local PIndex = Player:GetData().TruePlayerIndex

    mod.Saved.DiscardsRemaining = Value

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

    Value = Value - #mod:GetJimboJokerIndex(Player, mod.Jokers.TROUBADOR)

    --local PIndex = Player:GetData().TruePlayerIndex

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_NEEDLE then
        Value = 1
    end


    Value = math.max(Value, 1)

    mod.Saved.HandsRemaining = Value

    --if mod.Saved.IsSpecialBoss then
    --    Value = mod.INFINITE_HANDS
    --end

    

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
