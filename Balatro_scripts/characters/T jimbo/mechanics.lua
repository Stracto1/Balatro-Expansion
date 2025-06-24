
local mod = Balatro_Expansion

local Game = Game()
local Level = Game:GetLevel()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()

local TimerFixerVariable = 0

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
local FIXED_HAND_RADIUS = 10


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
function mod:TJimboAddConsumable(Player, card, Slot, StopAnimation)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end
    local PIndex = Player:GetData().TruePlayerIndex

    local Slot = Slot or 0
    local EmptySlot

    if mod:Contained(mod.Packs, card) then
        
        Player:UseCard(card)
        
        return false
    end

    
    for i, Consumable in ipairs(mod.Saved.Player[PIndex].Consumables) do
        if Consumable.Card == -1 then
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

        return false
    end

    mod.Saved.Player[PIndex].Consumables[EmptySlot].Card = mod:SpecialCardToFrame(card)

    return false
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_ADD_CARD,CallbackPriority.IMPORTANT, mod.TJimboAddConsumable)




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
    local PIndex = Player:GetData().TruePlayerIndex
    local Params = mod.SelectionParams[PIndex]

    ----------------------------------------

    --local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))

    ----------SELECTION INPUT / INPUT COOLDOWN------------
    
    -------------INPUT HANDLING-------------------

    if mod.AnimationIsPlaying then
        return
    end

        --confirms the curretn selection
    if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Player.ControllerIndex) then

        mod:UseSelection(Player)

    elseif Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Player.ControllerIndex) then

        if mod.Saved.Player[PIndex].DiscardsRemaining <= 0 then
            print("not enough discards loser!")
            return
        end

        mod.Saved.Player[PIndex].DiscardsRemaining = mod.Saved.Player[PIndex].DiscardsRemaining - 1

        mod:DiscardSelection(Player)
    end

    --confirming/canceling 
    if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
        and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then--usually they share buttons

        mod:Select(Player)

    end

    --pressing left moving the selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex)
       and Params.Index > 1 then

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

        -- holding SHIFT also makes you move the card itself 
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

            Isaac.RunCallback(mod.Callbalcks.INVENTORY_CHANGE, Player)
        end

        Params.Index = Params.Index + Step
    end

    
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then

        if Params.Index < Params.OptionsNum then

            local Step = 0

            if Params.Mode == mod.SelectionParams.Modes.INVENTORY then
                
                local SlotsSkipped = 1

                for i = Params.Index + 1, Params.OptionsNum do
                    
                    --print(i, mod.Saved.Player[PIndex].Inventory[i].Joker)
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

        if DestinationMode then
            mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)
        end
    end


    --while opening a pack, pressing up moves to the pack selection
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, Player.ControllerIndex)
       and Params.Mode ~= mod.SelectionParams.Modes.PACK then

        local DestinationMode
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

        if DestinationMode then
            mod:SwitchCardSelectionStates(Player, DestinationMode, Params.Purpose)
        end

    end


    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, Player.ControllerIndex) then
        
        local CardToUse = mod:FrameToSpecialCard(mod.Saved.Player[PIndex].Consumables[1].Card)
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



local function SpawnAdditionalTargets()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    local Room = Game:GetRoom()

    if Room:IsClear() then
        return
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
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SpawnAdditionalTargets)



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




----------HANDS SYSTEM----------
--------------------------------


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


    mod.Saved.Player[PIndex].MultValue = mod.Saved.Player[PIndex].HandsStat[mod.SelectionParams[PIndex].HandType][mod.Stats.MULT]
    mod.Saved.Player[PIndex].ChipsValue = mod.Saved.Player[PIndex].HandsStat[mod.SelectionParams[PIndex].HandType][mod.Stats.CHIPS]


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


    local HandHype = mod.SelectionParams[PIndex].HandType

    if HandHype == mod.HandTypes.HIGH_CARD then
        print("idk cacati addosso")
    end

    local RadiusMultiplier = mod.Saved.Player[PIndex].HandsStat[HandHype][mod.Stats.MULT]
    local FullHandDamage = mod.Saved.Player[PIndex].ChipsValue * mod.Saved.Player[PIndex].MultValue
    local FullyDamagedEnemies = {}

    for _, Enemy in ipairs(Isaac.FindInRadius(TargetPosition, 
                                              BASE_HAND_RADIUS * RadiusMultiplier,
                                              EntityPartition.ENEMY)) do

        if Enemy:IsActiveEnemy() and Enemy:IsVulnerableEnemy() then

            Enemy:TakeDamage(FullHandDamage,
                             DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(Player), 0)

            FullyDamagedEnemies[#FullyDamagedEnemies+1] = GetPtrHash(Enemy)
        end
    end

    local Poof = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, TargetPosition,
                            Vector.Zero, nil, 3, 1)

    Poof.SpriteScale = Vector.One * 0.8 * RadiusMultiplier
    Poof:SetColor(HAND_POOF_COLOR, -1, 100, false, false)

    local Poof = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, TargetPosition,
                            Vector.Zero, nil, 4, 1)

    Poof.SpriteScale = Vector.One * 0.8 * RadiusMultiplier
    Poof:SetColor(HAND_POOF_COLOR, -1, 100, false, false)
    --Poof:SetColor(Color.ProjectileHushBlue, -1, 1, false, false)




    for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

        if Enemy:IsActiveEnemy() and not mod:Contained(FullyDamagedEnemies, GetPtrHash(Enemy)) then
            
            Enemy:TakeDamage(FullHandDamage / 2.5,
                             DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(Player), 0)


            local Poof = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, Enemy.Position,
                                    Vector.Zero, nil, 3, 1)

            Poof.SpriteScale = Vector.One * 0.33
            Poof:SetColor(HAND_POOF_COLOR, -1, 100, false, false)

            local Poof = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, Enemy.Position,
                                    Vector.Zero, nil, 4, 1)

            Poof.SpriteScale = Vector.One * 0.33
            Poof:SetColor(HAND_POOF_COLOR, -1, 100, false, false)
            --Poof:SetColor(Color.ProjectileHushBlue, -1, 1, false, false)
        end
    end

    mod.Saved.Player[PIndex].HandsRemaining = mod.Saved.Player[PIndex].HandsRemaining - 1

    for i = #mod.Saved.Player[PIndex].CurrentHand, 1, -1 do
        
        if mod:Contained(mod.SelectionParams[PIndex].PlayedCards, mod.Saved.Player[PIndex].CurrentHand[i]) then

            table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
        end
    end

    Isaac.CreateTimer(function ()

                        --after playing the hand, checks if everyone is dead, in that case the blind is cleared
                        local AllDead = true

                        for _,Enemy in ipairs(Isaac.GetRoomEntities()) do

                            if Enemy:IsActiveEnemy() and Enemy:IsVulnerableEnemy()
                               and (not Enemy:IsDead() or not Enemy:HasMortalDamage()) then
                                
                                AllDead = false
                            end
                        end

                        --print(AllDead)

                        if AllDead then
                            
                            Isaac.RunCallback(mod.Callbalcks.BLIND_CLEAR, mod.Saved.BlindBeingPlayed)

                            return
                        end

                        if mod.Saved.Player[PIndex].HandsRemaining <= 0 then
                        
                            if mod.Saved.BlindBeingPlayed >= mod.BLINDS.BOSS_ACORN then --special bosses give you unlimited hands 
                            
                                Player:AddCustomCacheTag(mod.CustomCache.DISCARD_NUM)
                                Player:AddCustomCacheTag(mod.CustomCache.HAND_NUM, true)
                            else
                                sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
                                Isaac.CreateTimer(function ()
                                                    Player:Kill()
                                                end, 40, 1, true)

                                return
                            end
                        
                        end

                        Isaac.RunCallback(mod.Callbalcks.POST_HAND_PLAY, Player)
                    end, 10, 1, true)

end
--mod:AddCallback(mod.Callbalcks.POST_HAND_PLAY, mod.ActivateCurrentHand)



---@param Player EntityPlayer
function mod:SetupForHandScoring(Player)

    if Player:GetPlayerType() ~= mod.Characters.TaintedJimbo then
        return
    end

    local PIndex = Player:GetData().TruePlayerIndex

    mod.SelectionParams[PIndex].ScoringCards = mod:GetScoringCards(Player, mod.SelectionParams[PIndex].HandType)

    mod.Saved.Player[PIndex].HandsUsed[mod.SelectionParams[PIndex].HandType] = mod.Saved.Player[PIndex].HandsUsed[mod.SelectionParams[PIndex].HandType] + 1

    local TIMER_INCREASE = 4
    local CurrentTimer = TIMER_INCREASE

    mod.SelectionParams[PIndex].PlayedCards = {}
    for i = #mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND], 1, -1 do
        
        local IsSelected = mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i]

        if IsSelected then
            Isaac.CreateTimer(function ()
                mod.SelectionParams[PIndex].PlayedCards[#mod.SelectionParams[PIndex].PlayedCards+1] = mod.Saved.Player[PIndex].CurrentHand[i] + 0
                mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND][i] = false

                table.remove(mod.Saved.Player[PIndex].CurrentHand, i)
                --print(mod.SelectionParams[PIndex].PlayedCards[#mod.SelectionParams[PIndex].PlayedCards+1])
            end, CurrentTimer, 1, true)

            CurrentTimer = CurrentTimer + TIMER_INCREASE
        end
    end

    
    mod.AnimationIsPlaying = true

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

    local PIndex = Player:GetData().TruePlayerIndex


    mod.SelectionParams[PIndex].PlayedCards = {}
    mod.SelectionParams[PIndex].ScoringCards = 0
    mod.SelectionParams[PIndex].HandType = mod.HandTypes.NONE
    mod.SelectionParams[PIndex].PossibleHandType = mod.HandTypes.NONE


    Player:AddCustomCacheTag(mod.CustomCache.HAND_SIZE, true)
    
    local DeckFinished = mod:RefillHand(Player)


    

    --print("scoring: ", mod.SelectionParams[PIndex].ScoringCards)
    mod.Counters.SinceSelect = 0
    mod.AnimationIsPlaying = false

    mod.Saved.Player[PIndex].ChipsValue = 0
    mod.Saved.Player[PIndex].MultValue = 0

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

    Effect:AddVelocity(Player:GetAimDirection()*6.25)

    local PIndex = Player:GetData().TruePlayerIndex
    local HandHype = mod.SelectionParams[PIndex].HandType

    local RadiusMultiplier = mod.Saved.Player[PIndex].HandsStat[HandHype][mod.Stats.MULT]

    for _, Enemy in ipairs(Isaac.FindInRadius(Effect.Position, BASE_HAND_RADIUS * RadiusMultiplier, EntityPartition.ENEMY)) do
        
        Enemy:SetColor(Color(1.5,1.5,1.5,1, 0.1, 0.1, 0.1), 2, 100, true, false)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, MoveHandTarget, EffectVariant.TARGET)



------------BLIND SYSTEM------------
------------------------------------


local function OnBlindButtonPressed(_, VarData)

    
    mod.Saved.BlindBeingPlayed = VarData

    --the first timer activates frame-one for some reason...
    --so only do this on the second timer

    if VarData == mod.BLINDS.CASHOUT then
        
        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            Player:AnimateTeleport(true)
        end

        Isaac.CreateTimer(function ()
                                if TimerFixerVariable == 0 then
                                    Game:StartRoomTransition(mod.Saved.ShopIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                    TimerFixerVariable = TimerFixerVariable + 1

                                elseif TimerFixerVariable == 1 then
                                    --Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                    TimerFixerVariable = 0
                                end

                            end, 7, 2, true)


    elseif VarData & mod.BLINDS.SKIP == mod.BLINDS.SKIP then
        
        Isaac.RunCallback(mod.Callbalcks.BLIND_SKIP, VarData)
    
    else
        for i,Player in ipairs(PlayerManager.GetPlayers()) do

            Player:AnimateTeleport(true)
        end

        --print(mod.Saved.SmallBlindIndex)

        if VarData == mod.BLINDS.SMALL then

            Isaac.CreateTimer(function ()
                                
                                if TimerFixerVariable == 0 then
                                    Game:StartRoomTransition(mod.Saved.SmallBlindIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)

                                    TimerFixerVariable = TimerFixerVariable + 1

                                elseif TimerFixerVariable == 1 then
                                    Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                    TimerFixerVariable = 0
                                end

                            end, 7, 2, true)

        elseif VarData == mod.BLINDS.BIG then

            Isaac.CreateTimer(function ()
                                if TimerFixerVariable == 0 then
                                    Game:StartRoomTransition(mod.Saved.BigBlindIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                    TimerFixerVariable = TimerFixerVariable + 1

                                elseif TimerFixerVariable == 1 then
                                    Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                    TimerFixerVariable = 0
                                end

                            end, 7, 2, true)

        else --BOSS BLIND

            Isaac.CreateTimer(function ()
                                if TimerFixerVariable == 0 then
                                    Game:StartRoomTransition(mod.Saved.BossIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
                                    TimerFixerVariable = TimerFixerVariable + 1

                                elseif TimerFixerVariable == 1 then
                                    Isaac.RunCallback(mod.Callbalcks.BLIND_START, VarData)
                                    TimerFixerVariable = 0

                                end

                            end, 7, 2, true)

        end
    end

    mod:ResetPlatesData()
end
mod:AddCallback(mod.Callbalcks.BALATRO_PLATE_PRESSED, OnBlindButtonPressed)


local function OnBlindStart(_, BlindData)

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        
        if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
            mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.HAND, mod.SelectionParams.Purposes.HAND)
        
            Player:AddCustomCacheTag(mod.CustomCache.DISCARD_NUM)
            Player:AddCustomCacheTag(mod.CustomCache.HAND_NUM, true)
        end
    end

end
mod:AddPriorityCallback(mod.Callbalcks.BLIND_START, CallbackPriority.IMPORTANT, OnBlindStart)


local function OnBlindSkip(_, BlindType)

    --BlindType = BlindType & ~mod.BLINDS.SKIP
    local BlindLevel = mod:GetBlindLevel(BlindType)


    if BlindLevel == mod.BLINDS.SMALL then
        
        mod.Saved.SmallCleared = true

    else
        mod.Saved.BigCleared = true
    end

end
mod:AddPriorityCallback(mod.Callbalcks.BLIND_SKIP, CallbackPriority.IMPORTANT, OnBlindSkip)


local function OnBlindClear(_, BlindData)

    local Room = Game:GetRoom()

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
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


    if mod:GetBlindLevel(BlindData) == mod.BLINDS.BOSS then
        return
    end

    mod:SpawnBalatroPressurePlate(Room:GetCenterPos(), mod.BLINDS.CASHOUT)
end
mod:AddPriorityCallback(mod.Callbalcks.BLIND_CLEAR, CallbackPriority.IMPORTANT, OnBlindClear)



--STATE = 3 IF PRESSED

local function InitializeAnte()
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.TaintedJimbo) then
        return
    end

    mod.Saved.AnteLevel = mod.Saved.AnteLevel + 1

    -------BOSS POOL MANAGER---------
    ---------------------------------
    
    if mod.Saved.AnteLevel == 2 and mod.Saved.MaxAnteLevel ~= 2 then

        local InitialBossNum = #mod.Saved.Pools.BossBlinds

        mod.Saved.Pools.BossBlinds[InitialBossNum+1] = mod.BLINDS.BOSS_HOUSE
        mod.Saved.Pools.BossBlinds[InitialBossNum+2] = mod.BLINDS.BOSS_WALL
        mod.Saved.Pools.BossBlinds[InitialBossNum+3] = mod.BLINDS.BOSS_WHEEL
        mod.Saved.Pools.BossBlinds[InitialBossNum+4] = mod.BLINDS.BOSS_ARM
        mod.Saved.Pools.BossBlinds[InitialBossNum+5] = mod.BLINDS.BOSS_FISH
        mod.Saved.Pools.BossBlinds[InitialBossNum+6] = mod.BLINDS.BOSS_WATER
        mod.Saved.Pools.BossBlinds[InitialBossNum+7] = mod.BLINDS.BOSS_MOUTH
        mod.Saved.Pools.BossBlinds[InitialBossNum+8] = mod.BLINDS.BOSS_NEEDLE

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

    local SpecialBoss = CurrentStage == LevelStage.STAGE4_2 --mom's heart / mother floor
                        or CurrentStage == LevelStage.STAGE6 -- dark room / chest
                        or CurrentStage == LevelStage.STAGE7 --void
                        or CurrentStage == LevelStage.STAGE8 -- home

    mod:ChooseBossBlind(SpecialBoss)


    -------------CUSTOM PRESSURE PLATES-------------
    ------------------------------------------------
    
    mod.Saved.SmallCleared = false
    mod.Saved.BigCleared = false
    mod.Saved.BossCleared = mod.BossProgress.NOT_CLEARED
    

    local Room = Game:GetRoom()
    local Plate

    mod:SpawnBalatroPressurePlate(Room:GetGridPosition(49), mod.BLINDS.SMALL)

    Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(52), mod.BLINDS.BIG)
    Plate.State = 3
    Plate:GetSprite():Play("Switched")

    Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(70), mod.Saved.AnteBoss)
    Plate.State = 3
    Plate:GetSprite():Play("Switched")

    mod:SpawnBalatroPressurePlate(Room:GetGridPosition(79), mod.BLINDS.SKIP | mod.BLINDS.SMALL)

    Plate = mod:SpawnBalatroPressurePlate(Room:GetGridPosition(82), mod.BLINDS.SKIP | mod.BLINDS.BIG)
    Plate.State = 3
    Plate:GetSprite():Play("Switched")

    --Plate:GetSprite():GetLayer(1):SetColor(Color.LaserIpecac)
    
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, InitializeAnte)


--all enemies' HP get scaled basing on how many antes have been cleared this run
---@param Enemy EntityNPC
local function EnemyHPScaling(_,Enemy)

    local ScalingFactor

    if mod.Saved.AnteLevel <= 0 then

        ScalingFactor = 1/(1 - mod.Saved.AnteLevel) --(0 --> 1 || -1 --> 0.5 and so on)
    else
        ScalingFactor = mod.Saved.AnteLevel + 0.5*mod:GetBlindLevel(mod.Saved.BlindBeingPlayed)
    end

    if Enemy:IsActiveEnemy() then
        
        if Enemy:IsBoss() then
            
            Enemy.MaxHitPoints = Enemy.MaxHitPoints * 5 * ScalingFactor^0.85
            Enemy.HitPoints = Enemy.HitPoints * 5 * ScalingFactor^0.85

            --print("Boss HP:", Enemy.MaxHitPoints)
        else
            Enemy.MaxHitPoints = Enemy.MaxHitPoints * 5 * ScalingFactor
            Enemy.HitPoints = Enemy.HitPoints * 5 * ScalingFactor

            --print("Enemy HP:", Enemy.MaxHitPoints)
        end

    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, EnemyHPScaling)



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

    if mod.Saved.BlindBeingPlayed == mod.BLINDS.BOSS_MANACLE then
        Value = Value - 1
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
        Value = 0
    end


    Value = math.max(Value, 0)


    local PIndex = Player:GetData().TruePlayerIndex

    mod.Saved.Player[PIndex].DiscardsRemaining = Value

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


    Value = math.max(Value, 1)


    if mod.Saved.BlindBeingPlayed >=  mod.BLINDS.BOSS_ACORN then
        Value = mod.INFINITE_HANDS
    end

    mod.Saved.Player[PIndex].HandsRemaining = Value

    return Value
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.TJimboHandsCache, mod.CustomCache.HAND_NUM)

