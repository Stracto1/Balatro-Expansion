local mod = Balatro_Expansion
local JimboCards = {PlayingCards = Sprite("gfx/ui/PlayingCards.anm2"), 
                    Pack_PlayingCards = Sprite("gfx/ui/PackPlayCards.anm2"), 
                    SpecialCards = Sprite("gfx/ui/PackSpecialCards.anm2")}

local Edition_Overlay = Sprite("gfx/ui/Edition Overlay.anm2", true) --used on the cards sprites instead of the shaders
local EditionShaders ={ --sadly these don't work for the bigger card spritesheet, if you know how to fix this please let me know!!
    "shaders/Foil_effect",
    "shaders/Holographic_effect",
    "shaders/Polychrome_effect",
    "shaders/Negative_effect"
}
EditionShaders[0] = "shaders/Nothing"

local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local DiscardChargeSprite = Sprite("gfx/chargebar.anm2")
local HandChargeSprite = Sprite("gfx/chargebar.anm2")
local CardFrame = Sprite("gfx/ui/CardSelection.anm2")
CardFrame:SetAnimation("Frame")
local HUD_FRAME = {}

local TrinketSprite = Sprite("gfx/005.350_custom.anm2", true)

local ENHANCEMENTS_ANIMATIONS = {"Base","Mult","Bonus","Wild","Glass","Steel","Stone","Golden","Lucky"}
local HAND_TYPE_NAMES = {"high card","pair","Two pair","three of a kind","straight","flush","full house","four of a kind", "straight flush", "royal flush","five of a kind","fluah house","flush five"}
HAND_TYPE_NAMES[0] = "none"

local HandCooldown = 75  -- can be changed to lower/increase the charge time
local CHARGED_ANIMATION = 11 --the length of an animation for chargebars
local CHARGED_LOOP_ANIMATION = 5

local DECK_RENDERING_POSITION = Vector(135,25) --in screen coordinates
local INVENTORY_RENDERING_POSITION = Vector(20,250)
--local DECK_RENDERING_POSITION = Isaac.WorldToRenderPosition(Isaac.ScreenToWorld(Vector(760,745)))

local EFFECT_COLORS = {}
EFFECT_COLORS.Red = 1
EFFECT_COLORS.Blue = 2
EFFECT_COLORS.Yellow = 3

local ADDMULTSOUND = Isaac.GetSoundIdByName("ADDMULTSFX")
local TIMESMULTSOUND = Isaac.GetSoundIdByName("TIMESMULTSFX")
local ACTIVATESOUND = Isaac.GetSoundIdByName("ACTIVATESFX")
local CHIPSSOUND = Isaac.GetSoundIdByName("CHIPSSFX")
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")

HUD_FRAME.Frame = 0
HUD_FRAME.Arrow = 1
HUD_FRAME.Hand = 2
HUD_FRAME.Confirm = 3

local CardHUDWidth = 13
local PACK_CARD_DISTANCE = 10

local BasicRoomNum = 0
local ShopAddedThisFloor = false
local DeathCopyCard
local PurposeEnh = {nil,2,4,9,5,3,6,nil,7,8}

--charge bars color modifiers
do
    --SETS THE COLOR FOR THE DISCARD CHARGE BAR
    local DiscardProgressBar = DiscardChargeSprite:GetLayer(1)
    
    ---@diagnostic disable-next-line: need-check-nil
    local BarColor = DiscardProgressBar:GetColor()
    BarColor.BO = -1
    BarColor.GO = -0.8
    BarColor.RO = 1

    ---@diagnostic disable-next-line: need-check-nil
    DiscardProgressBar:SetColor(BarColor)
    DiscardChargeSprite.Offset = Vector(20,-20)

    --SETS THE COLOR FOR THE HAND CHARGE BAR
    local HandProgressBar = HandChargeSprite:GetLayer(1)

    ---@diagnostic disable-next-line: need-check-nil
    BarColor = HandProgressBar:GetColor()
    BarColor.BO = 0.9
    BarColor.GO = -0.3
    BarColor.RO = -1

    ---@diagnostic disable-next-line: need-check-nil
    HandProgressBar:SetColor(BarColor)
    HandChargeSprite.Offset = Vector(-20,-20)
    HandChargeSprite:SetAnimation("Charging")
end

--local jesterhatCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_hair.anm2") -- Exact path, with the "resources" folder as the root
--local jesterstolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root
local Game = Game()
local ItemPool = Game:GetItemPool()

--------------HUD RENDER-----------------
-----------------------------------------

function mod:JimboInventoryRender(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    for i,trinket in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do

        if trinket ~= 0 then
            local RenderPos = INVENTORY_RENDERING_POSITION + Vector(16*i,0)

            if mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY and 
               mod.SelectionParams.SelectedCards[i] then
                RenderPos.Y = RenderPos.Y - 9
            end
            TrinketSprite:ReplaceSpritesheet(0, ItemsConfig:GetTrinket(trinket).GfxFileName, true)
            TrinketSprite:SetFrame("Idle", 0)
            TrinketSprite:SetCustomShader(EditionShaders[mod.SavedValues.Jimbo.Inventory.Editions[i]])
            TrinketSprite:Render(RenderPos)
        end
    end

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY then
        local RenderPos 
        if mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] then
            RenderPos = INVENTORY_RENDERING_POSITION + Vector(16 * mod.SelectionParams.Index, -9)
        else
            RenderPos = INVENTORY_RENDERING_POSITION + Vector(16 * mod.SelectionParams.Index, 0)
        end

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = INVENTORY_RENDERING_POSITION + Vector(16 * (mod.SavedValues.Jimbo.InventorySize + 1) + 4, 0)
        CardFrame:SetFrame(HUD_FRAME.Confirm)
        CardFrame:Render(RenderPos)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboInventoryRender)


--renders the entirety of the extra HUD for Jimbo
function mod:JimboDeckHUD(offset,_,Position,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    ----DECK RENERING----
    for i, Pointer in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
        local Card = mod.SavedValues.Jimbo.FullDeck[Pointer]
        if Card then
            local RenderPos = DECK_RENDERING_POSITION + Vector(14 * i, 0)
            --JimboCards.R_PlayingCards.Scale=Vector(0.8,0.8)
            --JimboCards.PlayingCards.Scale=Vector(0.8,0.8)

            if mod.SelectionParams.SelectedCards[i] and mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
                RenderPos.Y = RenderPos.Y - 9 --moves up selected cards
            end

            JimboCards.PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
            --JimboCards.PlayingCards:PlayOverlay("Seals")
            JimboCards.PlayingCards:SetOverlayFrame("Seals", Card.Seal)
            Edition_Overlay:SetFrame("Editions", Card.Edition)

            -------------------------------------------------------------
            JimboCards.PlayingCards:Render(RenderPos)
            Edition_Overlay:Render(RenderPos)
            --150 // 10.4
            --360//122

        end
    end

    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        local RenderPos = DECK_RENDERING_POSITION + Vector(14 * mod.SelectionParams.Index, 0)
        
        if mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] then

            RenderPos.Y = RenderPos.Y - 9
        end    

        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(RenderPos)

        --last confirm option
        RenderPos = DECK_RENDERING_POSITION + Vector(14 * (mod.SavedValues.Jimbo.HandSize + 1), 0)
        CardFrame:SetFrame(HUD_FRAME.Hand)
        CardFrame:Render(RenderPos)


        --HAND TYPE TEXT RENDER--
        mod.Fonts.upheavalmini:DrawString(HAND_TYPE_NAMES[mod.SelectionParams.HandType],DECK_RENDERING_POSITION.X + 50,DECK_RENDERING_POSITION.Y -100,KColor(1,1,1,1))

        --allows mouse controls to be used as a way to select cards--
        local MousePosition = Isaac.WorldToScreen(Input.GetMousePosition(true))
        if MousePosition.X >= DECK_RENDERING_POSITION.X and MousePosition.Y >= DECK_RENDERING_POSITION.Y  then
            local HandMousePosition = math.ceil((MousePosition.X - (DECK_RENDERING_POSITION.X))/CardHUDWidth)
            if HandMousePosition <= mod.SavedValues.Jimbo.HandSize + 1 then
                mod.SelectionParams.Index = HandMousePosition
            end
        end

    else--not selecting
        local CardsLeft = (#mod.SavedValues.Jimbo.FullDeck - mod.SavedValues.Jimbo.DeckPointer) + 1
        --shows how many cards are left in the deck
        if CardsLeft > 0 then
            local RenderPos = DECK_RENDERING_POSITION + Vector(14 * (mod.SavedValues.Jimbo.HandSize + 1),-3)
            mod.Fonts.upheavalmini:DrawStringScaled("+"..tostring(CardsLeft),RenderPos.X + Minimap:GetShakeOffset().X,RenderPos.Y + Minimap:GetShakeOffset().Y,0.8,1,KColor(1,1,1,1))
        end
    end

    --BLIND COUNTER--
    if Minimap:GetState()== MinimapState.NORMAL then
        if not mod.SavedValues.Jimbo.SmallCleared then
            mod.Fonts.upheavalmini:DrawString(tostring(mod.SavedValues.Jimbo.ClearedRooms).."/"..tostring(mod.SavedValues.Jimbo.SmallBlind),100 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,KColor(1,1,1,1))
            --mod.Fonts.upheavalmini:DrawString(tostring(ClearedRooms).."/"..tostring(BigBlind),Isaac.WorldToScreen(Player.Position).X+20,Isaac.WorldToScreen(Player.Position).Y+30,KColor(1,1,1,1))        

        elseif not mod.SavedValues.Jimbo.BigCleared then
            mod.Fonts.upheavalmini:DrawString(tostring(mod.SavedValues.Jimbo.ClearedRooms).."/"..tostring(mod.SavedValues.Jimbo.BigBlind),100 + Minimap:GetShakeOffset().X,Minimap:GetShakeOffset().Y,KColor(1,1,1,1))        
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS,CallbackPriority.LATE, mod.JimboDeckHUD)


--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboPackRender(_,_,_,_,Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    
    if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.PACK then
        return
    end

    local PlayerPos = Isaac.WorldToScreen(Player.Position)
    local RenderPos = Vector(0,0)
    RenderPos.Y = PlayerPos.Y + 20 
    --base point, increased while rendering 
    RenderPos.X = PlayerPos.X - CardHUDWidth * mod.SelectionParams.OptionsNum /2 - PACK_CARD_DISTANCE * (mod.SelectionParams.OptionsNum - 1) /2
    RenderPos.X = RenderPos.X + 6.5--makes it centered

    if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.StandardPack then
        --SHOWS THE CHOICES AVAILABLE

        for i,Card in ipairs(mod.SelectionParams.PackOptions) do --for every option

        JimboCards.Pack_PlayingCards:SetFrame(ENHANCEMENTS_ANIMATIONS[Card.Enhancement], 4 * (Card.Value - 1) + Card.Suit-1) --sets the frame corresponding to the value and suit
        JimboCards.Pack_PlayingCards:SetOverlayFrame("Seals", Card.Seal)
        Edition_Overlay:SetFrame("Editions", Card.Edition)

        JimboCards.Pack_PlayingCards:Render(RenderPos)
        Edition_Overlay:Render(RenderPos)

        if i == mod.SelectionParams.Index then 
            --RENDERS THE SELECTOR
            CardFrame:SetFrame(HUD_FRAME.Frame)
            CardFrame:Render(RenderPos)

        end

        RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.BuffonPack then
        


    else--TAROT, PLANET or SPECTRAL
    
        --SHOWS THE CHOICES AVAILABLE
        for i,Option in ipairs(mod.SelectionParams.PackOptions) do

            if Option == 53 then --equivalent to the soul card
                JimboCards.SpecialCards:SetFrame("Soul Stone",mod.SelectionParams.Frames % 47) --sets the frame corresponding to the value and suit
            else
                JimboCards.SpecialCards:SetFrame("idle",  Option)
            end
            JimboCards.SpecialCards:Render(RenderPos)

            if i == mod.SelectionParams.Index then
                --RENDERS THE SELECTOR
                CardFrame:SetFrame(HUD_FRAME.Frame)
                CardFrame:Render(RenderPos)

            end

            RenderPos.X = RenderPos.X + PACK_CARD_DISTANCE + CardHUDWidth

        end--end FOR

    end--end PURPOSES

    CardFrame:SetFrame(HUD_FRAME.Confirm)
    CardFrame:Render(RenderPos)

    if mod.SelectionParams.Index == mod.SelectionParams.OptionsNum + 1 then
        CardFrame:SetFrame(HUD_FRAME.Frame)
        CardFrame:Render(RenderPos)
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.JimboPackRender)



--handles the charge bar when the player is selecting cards
---@param Player EntityPlayer
function mod:JimboBarRender(Player)

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    

    local Data = Player:GetData()
    if Data.DiscardCD < HandCooldown then --charging frames needed

        DiscardChargeSprite:SetAnimation("Charging")
        DiscardChargeSprite:SetFrame(math.floor(Data.DiscardCD * 1.33))

    elseif Data.DiscardCD < HandCooldown + CHARGED_ANIMATION then --Charging frames + StartCharged frames
        DiscardChargeSprite:SetAnimation("StartCharged")
        DiscardChargeSprite:SetFrame(Data.DiscardCD - HandCooldown)

    else
        DiscardChargeSprite:SetAnimation("Charged")
        DiscardChargeSprite:SetFrame(Data.DiscardCD - (HandCooldown + CHARGED_ANIMATION + CHARGED_LOOP_ANIMATION))
    end

    --renders a timer as a charge bar next to the player
    DiscardChargeSprite:Render(Isaac.WorldToScreen(Player.Position))


    --------------HAND SELECTION COOLDOWN------------------
    if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.NONE then
        mod.SelectionParams.Frames = mod.SelectionParams.Frames + 1
    else
        mod.SelectionParams.Frames = 0
        return
    end

    local HandFrame = 100 - math.ceil(mod.SelectionParams.Frames/4.5)
    
    if HandFrame == 0 then
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE)
        
    elseif HandFrame > 0 then
        HandChargeSprite:SetFrame(HandFrame)
        --makes the bar flicker more as the timer runs out
        if HandFrame < 25 then
            if HandFrame % 3 == 0 then
                HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        
        elseif HandFrame < 40 then
            if HandFrame % 3 ~=0 then
                HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        
        elseif HandFrame < 70 then
            if HandFrame % 5 ~= 0 then
                HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
            end
        else
            HandChargeSprite:Render(Isaac.WorldToScreen(Player.Position))
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JimboBarRender)


---------------PLAYER MECHANICS----------------------
-----------------------------------------------------

--setups variables for jimbo
---@param player EntityPlayer
function mod:JimboInit(player)
    if player:GetPlayerType() == mod.Characters.JimboType then
        local Data = player:GetData()
        Data.DiscardCD = 0 --shoot cooldown

        Data.NotAlrPressed = {} --general controls stuff
        Data.NotAlrPressed.left = true
        Data.NotAlrPressed.right = true
        Data.NotAlrPressed.confirm = true
        Data.CTRLhold = 0 --used to activate the inventory selection

        Data.JustPickedEdition = 0 --used for inventory jokers' edition

        --player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_THE_HAND,ActiveSlot.SLOT_POCKET)
        --ItemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_HAND)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.JimboInit)


--makes basically every input possible when using jimbo (+ other stuff)
---@param Player EntityPlayer
function mod:JimboInputHandle(Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    for i,v in pairs(mod.Counters) do
        if type(v) == "table" then
            for j,w in ipairs(v) do
                mod.Counters[i][j] = mod.Counters[i][j] + 1
            end
        else
            mod.Counters[i] = mod.Counters[i] + 1
        end
    end

    local Data = Player:GetData()
    --print(Isaac.WorldToScreen(Player.Position))
    -----------DISCARD COOLDOWN-------------
    if Data.DiscardCD <= HandCooldown + CHARGED_ANIMATION + CHARGED_LOOP_ANIMATION then
        Data.DiscardCD = Data.DiscardCD + 1
    else
        Data.DiscardCD = HandCooldown + CHARGED_ANIMATION
    end


    ----------SELECTION INPUT / INPUT COOLDOWN------------
    if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.NONE then --while in the card selection menu cheks for inputs
        -------------INPUT HANDLING-------------------(big ass if statements ik lol)
        
        --confirming/canceling 
        if  Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, Player.ControllerIndex)
            and not Input.IsActionPressed(ButtonAction.ACTION_ITEM, Player.ControllerIndex)--usually they share buttons
            or Input.IsMouseBtnPressed(MouseButton.LEFT) then

            if  Data.NotAlrPressed.confirm then
                mod:Select(Player)
                Data.NotAlrPressed.confirm = false
            end
        else --not pressed
            Data.NotAlrPressed.confirm = true
        end


        --pressing left moving the selection
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, Player.ControllerIndex) then

            if  Data.NotAlrPressed.left and mod.SelectionParams.Index > 1 then
                mod.SelectionParams.Index = mod.SelectionParams.Index - 1
                Data.NotAlrPressed.left = false
            end
        else--not pressed
            Data.NotAlrPressed.left = true
        end

        --pressing right moving the selection
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, Player.ControllerIndex) then
            if Data.NotAlrPressed.right and mod.SelectionParams.Index <= mod.SelectionParams.OptionsNum then

            mod.SelectionParams.Index = mod.SelectionParams.Index + 1
            Data.NotAlrPressed.right = false
            end
        else --not pressed
            Data.NotAlrPressed.right = true
        end
    
        Player.Velocity = Vector.Zero
    else --not selecting anything
        
        if Input.IsActionPressed(ButtonAction.ACTION_DROP, Player.ControllerIndex) then
            Data.CTRLhold = Data.CTRLhold + 1
            if Data.CTRLhold == 45 then --if held long enough starts the inventory selection
                mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
                Data.CTRLhold = 0
            end
        else
            Data.CTRLhold = 0
        end

        -----------SHOOTING HANDLING---------------
        local AimDirection = Player:GetAimDirection()
        if Data.DiscardCD >= HandCooldown and (AimDirection.X ~= 0 or AimDirection.Y ~= 0) then
            mod:JimboShootCardTear(Player, AimDirection)
            Data.DiscardCD = 0
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.JimboInputHandle)


---@param Pickup EntityPickup
---@param RNG RNG
function mod:ShopItemChanger(Pickup,_, _, ReqVariant, ReqSubType, RNG)
    local Room = Game:GetRoom()
    if (ReqSubType == 0 or ReqVariant == 0) and 
        Pickup:IsShopItem() and Room:GetType() == RoomType.ROOM_SHOP then

        if Pickup.ShopItemId < 2 then
            return{PickupVariant.PICKUP_TAROTCARD,mod:GetRandom(mod.Packs, RNG),true}
        
        elseif Pickup.ShopItemId < 5 then
            local Trinket
            repeat
                local RarityRoll = RNG:RandomFloat()
                if RarityRoll < 0.75 then
                    Trinket = mod:GetRandom(mod.Trinkets.common,RNG,true)
                elseif RarityRoll < 0.95 then
                    Trinket = mod:GetRandom(mod.Trinkets.uncommon,RNG,true)
                else
                    Trinket = mod:GetRandom(mod.Trinkets.rare,RNG,true)
                end
            until not PlayerManager.AnyoneHasTrinket(Trinket)
            return{PickupVariant.PICKUP_TRINKET, Trinket ,false}
        else 
            return {PickupVariant.PICKUP_COLLECTIBLE,
                    ItemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, RNG:GetSeed())}
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, mod.ShopItemChanger)


--makes every item a paid shop item (also see SetItemPrices)
---@param Pickup EntityPickup
function mod:SetItemAsShop(Pickup)
    if not Pickup:IsShopItem() then
        Pickup:MakeShopItem(-1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,mod.SetItemAsShop, PickupVariant.PICKUP_COLLECTIBLE)


--sets the price for every item basing on quality and room
function mod:SetItemPrices(Variant,SubType,_,Price)
    if Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local Quality = ItemsConfig:GetCollectible(SubType).Quality
        return (Quality+2)*2

    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.SetItemPrices)


--modifies the floor generation and calculates the number of normal rooms
---@param RoomConfig RoomConfigRoom
---@param RoomLevel LevelGeneratorRoom
function mod:FloorModifier(RoomLevel,RoomConfig,Seed)
    if PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        --changes all the shops and treasures with Tkeeper's shops
        local RoomIndex = RoomLevel:Column() + RoomLevel:Row()*13
        if RoomConfig.Type == RoomType.ROOM_TREASURE or RoomConfig.Type == RoomType.ROOM_SHOP then
            --("t or s")
            
            local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, RoomSubType.SHOP_KEEPER_LEVEL_3)

            return NewRoom --replaces the room with the new one

        elseif RoomConfig.Type == RoomType.ROOM_DEFAULT and (RoomIndex ~= Game:GetLevel():GetStartingRoomIndex())  then
            --adds a shop in floors where there usually wouldn't be
            --print("normal")
            
            if not mod:FloorHasShopOrTreasure().Shop and RoomLevel:IsDeadEnd() and not ShopAddedThisFloor and RoomLevel:Shape()==RoomShape.ROOMSHAPE_1x1 then
                --local RoomRNG = RNG(Seed)
                --local ChosenSubType = RoomRNG:RandomInt(RoomSubType.SHOP_KEEPER_LEVEL_3, RoomSubType.SHOP_KEEPER_LEVEL_5)
                
                local NewRoom = RoomConfigHolder.GetRandomRoom(Seed,false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.ROOMSHAPE_1x1,-1,-1,0,10,0, RoomSubType.SHOP_KEEPER_LEVEL_3)
                ShopAddedThisFloor = true
                return NewRoom --replaces the room with the new one
            end
            BasicRoomNum = BasicRoomNum + 1 --idk why but this is always much higher than needed
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, mod.FloorModifier)

--calculates how big the blinds are 
function mod:CalculateBlinds()

    mod.SavedValues.Jimbo.SmallCleared = false
    mod.SavedValues.Jimbo.BigCleared = false
    mod.SavedValues.Jimbo.BossCleared = false
    mod.SavedValues.Jimbo.ClearedRooms = 0

    --the more rooms the less you need to complete
    if BasicRoomNum < 40 then
        BasicRoomNum = math.ceil(BasicRoomNum * (1 - BasicRoomNum/100))
    else
        BasicRoomNum = BasicRoomNum * 0.60
    end
 
    mod.SavedValues.Jimbo.SmallBlind = math.ceil(BasicRoomNum/3) -- about 1/3 of the rooms
    mod.SavedValues.Jimbo.BigBlind = BasicRoomNum - mod.SavedValues.Jimbo.SmallBlind --about 2/3 of the rooms
    
    BasicRoomNum = 0 --resets the counter
    ShopAddedThisFloor = false

    Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.SMALL)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.CalculateBlinds)
--mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE,mod.CalculateBlinds)

--handles the rooms which cleared by default 
function mod:NoHarmRooms()
    local Desc = Game:GetLevel():GetCurrentRoomDesc()
    
    if Desc.VisitedCount == 1 and Desc.Clear and Desc.GridIndex ~= Game:GetLevel():GetStartingRoomIndex() then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",false)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NoHarmRooms)

--handles the shooting 
---@param Player EntityPlayer
---@param Direction Vector
function mod:JimboShootCardTear(Player,Direction)
    local CardShot = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[mod.SavedValues.Jimbo.HandSize]]
    CardShot.Index = mod.SavedValues.Jimbo.CurrentHand[mod.SavedValues.Jimbo.HandSize] --could be useful
    
    --considers the possible ammounts of tears fired
    local ShotParams = Player:GetMultiShotParams()

    local MaxSpread = ShotParams:GetSpreadAngle(WeaponType.WEAPON_TEARS) --half the total angle the tears spread 
    local EyeAngle = ShotParams:GetMultiEyeAngle() --angle used to determine if player has Wiz or not
    local NumTears = ShotParams:GetNumTears() --tears the player fires simultaneusly
    local NumLanes = ShotParams:GetNumLanesPerEye() --similar to numtears, but dicates how the tears get shot

    local Spread = 0
    if NumLanes > 1 then
        Spread = (MaxSpread / (NumLanes - 1)) * 2
    end
    if EyeAngle == 45 then --if player has the wiz
        for i=1,-1,-2 do 
            local BaseAngle = EyeAngle * i --sets +45° and -45° as the base angle

            for j=0, NumTears/2 -1 do --for each eye
                --modifies additionally the angle if you also have stuff like QuadShot
                local FireAngle = (BaseAngle+(MaxSpread - Spread*j)) + Direction:GetAngleDegrees()
                local ShootDirection = (Vector.FromAngle(FireAngle) *10 + Player.Velocity)*Player.ShotSpeed

                local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)
                local TearData = Tear:GetData()

                mod:AddCardTearFalgs(Tear, CardShot)
            end
        end
    else --player does not have the wiz
        for i=0, NumTears-1 do
            local FireAngle = (MaxSpread - Spread*i) + Direction:GetAngleDegrees()
            local ShootDirection = (Vector.FromAngle(FireAngle) + Player.Velocity/10)*10*Player.ShotSpeed

            local Tear = Player:FireTear(Player.Position, ShootDirection, false, false, true, Player)

            mod:AddCardTearFalgs(Tear, CardShot)
        end
    end

    mod:StatReset(Player,true,true,false,true)

    mod:AddValueToTable(mod.SavedValues.Jimbo.CurrentHand, mod.SavedValues.Jimbo.DeckPointer,false,true)
    mod.SavedValues.Jimbo.DeckPointer = mod.SavedValues.Jimbo.DeckPointer + 1

    Isaac.RunCallback("DECK_SHIFT",Player)
    Isaac.RunCallback("CARD_SHOT", Player, CardShot ,true)

end


function mod:AddRoomsCleared(IsBoss)
    if IsBoss and not mod.SavedValues.Jimbo.BossCleard then
        Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BOSS)
        mod.SavedValues.Jimbo.BossCleard = true
    else
        mod.SavedValues.Jimbo.ClearedRooms = mod.SavedValues.Jimbo.ClearedRooms + 1
        if mod.SavedValues.Jimbo.ClearedRooms == mod.SavedValues.Jimbo.SmallBlind and not mod.SavedValues.Jimbo.SmallCleared then
            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.SMALL)
            mod.SavedValues.Jimbo.SmallCleared = true
            mod.SavedValues.Jimbo.ClearedRooms = 0
        elseif mod.SavedValues.Jimbo.ClearedRooms == mod.SavedValues.Jimbo.BigBlind and not mod.SavedValues.Jimbo.BigCleared then
            Isaac.RunCallback("BLIND_CLEARED", mod.BLINDS.BIG)
            mod.SavedValues.Jimbo.BigCleared = true
            mod.SavedValues.Jimbo.ClearedRooms = 0
        end
    end
end
mod:AddPriorityCallback("TRUE_ROOM_CLEAR",CallbackPriority.LATE, mod.AddRoomsCleared)


--activates whenever the deckpointer is shifted
---@param Player EntityPlayer
function mod:OnDeckShift(Player)

    --take damage if the deck is finished
    if mod.SavedValues.Jimbo.DeckPointer > #mod.SavedValues.Jimbo.FullDeck + mod.SavedValues.Jimbo.HandSize then
        if mod.SavedValues.Jimbo.FirstDeck then
            Player:AnimateSad()
        end
        mod:FullDeckShuffle(Player)
    end
end
mod:AddCallback("DECK_SHIFT", mod.OnDeckShift)

function mod:GiveRewards(BlindType)

    local Seed = Game:GetSeeds():GetStartSeed()
    local Jimbo

    --calculates the ammount of interests BEFORE giving the clear money
    local Interests = math.floor(Game:GetPlayer(0):GetNumCoins()/5)
    if Interests > 5 then Interests = 5 end

    --gives coins basing on the blind cleared and finds jimbo
    for _,Player in ipairs(PlayerManager:GetPlayers()) do
        if Player:GetPlayerType() == mod.Characters.JimboType then
            mod:StatReset(Player, true, true, true, false, true)

            Jimbo = Player
            Isaac.CreateTimer(function ()
                if BlindType == mod.BLINDS.SMALL then
                    
                    Player:AddCoins(4)
                    mod:CreateBalatroEffect(Player,EFFECT_COLORS.Yellow ,ACTIVATESOUND, "+4 $", Vector(0,20))
                    Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BIG)

                elseif BlindType == mod.BLINDS.BIG then
                    Player:AddCoins(5)
                    mod:CreateBalatroEffect(Player,EFFECT_COLORS.Yellow ,ACTIVATESOUND, "+5 $", Vector(0,20))
                    Isaac.RunCallback("BLIND_STARTED", mod.BLINDS.BOSS)
                    
                elseif BlindType == mod.BLINDS.BOSS then
                    Player:AddCoins(6)
                    mod:CreateBalatroEffect(Player,EFFECT_COLORS.Yellow ,ACTIVATESOUND, "+6 $", Vector(0,20))
    
                end
            end, 15,1, true)
            
        end
    end
    for _,index in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
        if mod.SavedValues.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.GOLDEN then
            Game:GetPlayer(0):AddCoins(3)
        end
    end
    --gives interest
    Isaac.CreateTimer(function ()
        for i = 1, Interests, 1 do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Jimbo.Position, RandomVector() * 4, Jimbo, CoinSubType.COIN_PENNY, Seed)
            --Balatro_Expansion:EffectConverter(8,0,Jimbo,4)
        end 
    end, 15, 1, true)

    for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
        if mod.SavedValues.Jimbo.FullDeck[v].Seal == mod.Seals.BLUE then
            
        end
    end



end
mod:AddPriorityCallback("BLIND_CLEARED",CallbackPriority.LATE, mod.GiveRewards)


---@param Player EntityPlayer
function mod:JimboAddTrinket(Player, Trinket, _)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        
        Player:TryRemoveTrinket(Trinket) -- a custom array is used instead since he needs to hold many of them

        local Slot = mod:AddValueToTable(mod.SavedValues.Jimbo.Inventory.Jokers, Trinket, true, false)
        local JokerEdition = mod.SavedValues.Jimbo.FloorEditions[Game:GetLevel():GetCurrentRoomDesc().ListIndex][ItemsConfig:GetTrinket(Trinket).Name] or mod.Edition.BASE 

        mod.SavedValues.Jimbo.Inventory.Editions[Slot] = JokerEdition --gives the correct edition to the inventory slot

        if JokerEdition == mod.Edition.NEGATIVE then
            mod:AddJimboInventorySlots(Player, 1)
        end

        local InitialProg = ItemsConfig:GetTrinket(Trinket):GetCustomTags()[2]
        mod.SavedValues.Jimbo.Progress.Inventory[Slot] = tonumber(InitialProg)

        Isaac.RunCallback("INVENTORY_CHANGE", Player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.JimboAddTrinket)

---@param RNG RNG 
function mod:JimboTrinketPool(_, RNG)
    if not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    local RarityRoll = RNG:RandomFloat()

    if RarityRoll < 0.70 then --common
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.common, RNG)
        until not mod:JimboHasTrinket(nil, Joker) --no duplicates
        return Joker
    elseif RarityRoll < 0.95 then --uncommon
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.uncommon, RNG)
        until not mod:JimboHasTrinket(nil, Joker)
        return Joker
    else --rare
        local Joker
        repeat
            Joker = mod:GetRandom(mod.Trinkets.rare, RNG)
        until not mod:JimboHasTrinket(nil, Joker)
        return Joker
    end


end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.JimboTrinketPool)

---@param Trinket EntityPickup
function mod:TrinketEditionsRender(Trinket, Offset)
    local Index = Game:GetLevel():GetCurrentRoomDesc().ListIndex

    if mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] then --just a precaution
        if mod.SavedValues.Jimbo.FloorEditions[Index][Trinket.SubType] ~= mod.Edition.BASE then
            Trinket:GetSprite():SetCustomShader(EditionShaders[mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name]])
        end
    else
        mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.TrinketEditionsRender, PickupVariant.PICKUP_TRINKET)

---@param Trinket EntityPickup
function mod:GiveEditions(Trinket)
    if mod.GameStarted and ItemsConfig:GetTrinket(Trinket.SubType):HasCustomTag("balatro")
       and PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then

        local Index = Game:GetLevel():GetCurrentRoomDesc().ListIndex

        local EdRoll = Trinket:GetDropRNG():RandomFloat()
        if EdRoll <= 0.02 then --foil chance
            mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = mod.Edition.FOIL
        elseif EdRoll <= 0.034 then --holo chance
            mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = mod.Edition.HOLOGRAPHIC
        elseif EdRoll <= 0.037 then --poly chance
            mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = mod.Edition.POLYCROME
        elseif EdRoll <= 0.03 + 0.037 then --niggative chance (fixed chance)
            mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = mod.Edition.NEGATIVE
        else
            mod.SavedValues.Jimbo.FloorEditions[Index][ItemsConfig:GetTrinket(Trinket.SubType).Name] = mod.Edition.NONE
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.GiveEditions, PickupVariant.PICKUP_TRINKET)

function mod:EnableTrinketEditions()
    mod.SavedValues.Jimbo.FloorEditions = {}
    local AllRoomsDesc = Game:GetLevel():GetRooms()
    for i=1, Game:GetLevel():GetRoomCount()-1 do
        local RoomDesc = AllRoomsDesc:Get(i)
        mod.SavedValues.Jimbo.FloorEditions[RoomDesc.ListIndex] = {}
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.EnableTrinketEditions)

--jimbo can only take one heart container worth of damage per time
---@param Player Entity
function mod:JimboTakeDamage(Player,Amount,_,Source,_)
    ---@diagnostic disable-next-line: cast-local-type
    Player = Player:ToPlayer()
    if Player and Player:GetPlayerType() == mod.Characters.JimboType and Amount ~= 0 then

        --fixes problems with rotten/ete
        if Player:GetHearts() % 2 == 1 then
            --on 1 damage go down (-1) || on 2 damage go up (1)
            Player:AddHearts(Amount * 2 - 3)
        end
    
        


        --[[only remove one eternal/rotten heart if he has any
        if Player:GetEternalHearts() ~= 0  then

            Player:AddEternalHearts(-1)
            Player:TakeDamage(0, DamageFlag.DAMAGE_EXPLOSION, Source, 30) --take fake damage
            return false

        elseif Player:GetRottenHearts() ~= 0 then

            Player:AddRottenHearts(-1)
            Player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, Source, 30) --take fake damage
            return false

        else
            Player:AddHearts(Amount - 2)
        end]]
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.JimboTakeDamage)


---@param Player EntityPlayer
---@param HpType AddHealthType
function mod:JimboOnlyRedHearts(Player, Amount, HpType, _)

    if Amount == 0 then
        return
    end

    if (HpType | AddHealthType.SOUL == AddHealthType.SOUL or
       HpType | AddHealthType.BLACK == AddHealthType.BLACK) then

        Player:AddBlueFlies(Amount * 2, Player.Position, Player)
        return 0 -- no hearts given

    elseif HpType | AddHealthType.MAX == AddHealthType.MAX  then

    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, mod.JimboOnlyRedHearts)



---@param Familiar EntityFamiliar
function mod:JimboBlueFliesSpiders(Familiar)

    local Player = Familiar.Player
    if Player:GetPlayerType() == mod.Characters.JimboType then

        --for whaterver reason i need to set a timer or it won't do anything
        Isaac.CreateTimer(function () 
            Familiar.CollisionDamage = (Player.Damage + mod:CalculateTearsValue(Player)) * 1.5
        end, 1,1,true)
        

        --print(Familiar.CollisionDamage)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.JimboBlueFliesSpiders, FamiliarVariant.BLUE_FLY)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.JimboBlueFliesSpiders, FamiliarVariant.BLUE_SPIDER)


--shuffles the deck
---@param Player EntityPlayer
function mod:JimboRoomClear(Player)
    mod:FullDeckShuffle(Player)
    local Room = Game:GetRoom():GetType()
    if Room == RoomType.ROOM_DEFAULT then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",false)
    elseif Room == RoomType.ROOM_BOSS then
        Isaac.RunCallback("TRUE_ROOM_CLEAR",true)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.JimboRoomClear)

-----------------------JIMBO STATS-----------------------
----------------------------------------------------------

---@param Player EntityPlayer
function mod:CardShotFinal(Player,ShotCard,Retriggers,Evaluate)

    local RandomSeed=Random()
    if RandomSeed == 0 then RandomSeed = 1 end

    ----SEAL EFFECTS-----
    ---------------------
    if ShotCard.Seal == mod.Seals.RED then
        Retriggers = Retriggers + 1
    elseif ShotCard.Seal == mod.Seals.GOLDEN then
        for i=0, Retriggers do
            local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                    RandomVector()*4, nil, CoinSubType.COIN_PENNY, RandomSeed)

            Coin:ToPickup().Timeout = 45
        end
    end

    --------EDITIONS EFFECTS----------
    ----------------------------------
    if ShotCard.Edition == mod.Edition.FOIL then
        mod:IncreaseJimboStats(Player,0, 0.5, 1,false,true)
    elseif ShotCard.Edition == mod.Edition.HOLOGRAPHIC then
        mod:IncreaseJimboStats(Player,0.15, 0, 1,false,true)
    elseif ShotCard.Edition == mod.Edition.POLYCROME then
        mod:IncreaseJimboStats(Player,0, 0, 1.2,false,true)
    end

    --increases the chips basing on the card value
    local TearsToGet = mod:GetActualCardValue(ShotCard.Value)/75 + mod.SavedValues.Jimbo.CardLevels[ShotCard.Value]*0.01
    
    ---------ENHANCEMENT EFFECTS----------
    --------------------------------------
    if ShotCard.Enhancement == mod.Enhancement.STONE then
        TearsToGet = 0.35

    elseif ShotCard.Enhancement == mod.Enhancement.MULT then
        mod:IncreaseJimboStats(Player,0.04, 0,1, false,true)

    elseif ShotCard.Enhancement == mod.Enhancement.BONUS then
        mod:IncreaseJimboStats(Player,0, 0.3, 1,false,true)

    elseif ShotCard.Enhancement == mod.Enhancement.GLASS then
        mod:IncreaseJimboStats(Player,0, 0, 1.3, false,true)
        if mod:TryGamble(Player, RNG(RandomSeed), 0.1) then
            table.remove(mod.SavedValues.Jimbo.FullDeck, ShotCard.Index)
            mod:CreateBalatroEffect(Player, EFFECT_COLORS.Yellow, ACTIVATESOUND, "BROKEN!", Vector(0, 20))
        end

    elseif ShotCard.Enhancement == mod.Enhancement.LUCKY then
        if mod:TryGamble(Player, RNG(RandomSeed), 0.20) then
            mod:IncreaseJimboStats(Player, 0.2, 0, 1, false,true)
        end

        if mod:TryGamble(Player, RNG(RandomSeed), 0.07) then
            mod:IncreaseJimboStats(Player, 0.2, 0, 1, false,true)
            Player:AddCoins(10)
            mod:CreateBalatroEffect(Player, EFFECT_COLORS.Yellow, ACTIVATESOUND, "+10 $", Vector(0, 20))
        end
    end
    for _,index in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
        if mod.SavedValues.Jimbo.FullDeck[index] then
            if mod.SavedValues.Jimbo.FullDeck[index].Enhancement == mod.Enhancement.STEEL then
                mod:IncreaseJimboStats(Player,0, 0,1.02, false,true)
            end
        end
    end
    mod:IncreaseJimboStats(Player, 0, TearsToGet, 1,false, true)

    if Evaluate then
        mod.StatEnable = true
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        mod.StatEnable = false
    end
end
mod:AddCallback("CARD_SHOT_FINAL", mod.CardShotFinal)


--these calculations are used for normal items, NOT stats given by jokers or mod related stuff
---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboStatCalculator(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end
    --i swear to god making tear stat calculations is one of the hardest things to understand 
    --so PLEASE if you're looking at this and have some suggestions tell me
    local PositiveDamageMult = 0.15
    local NegativeDamageMult = 0.55

    local TearsMult = 1 --works a little funky, even i don't exactly know how it acts
    local DamageMult = 1

    if Player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        mod.SavedValues.Jimbo.MinimumTears = 0.6
        PositiveDamageMult = 0.25
        TearsMult = 0.7
    elseif Player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        mod.SavedValues.Jimbo.MinimumTears = 0.7
        PositiveDamageMult = 0.125
        TearsMult = 0.7
        DamageMult = 0.85
    end

    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local AddedDamage = Player.Damage - 1

        if AddedDamage >= 0 then
            Player.Damage = AddedDamage * PositiveDamageMult + 1 *DamageMult
        else
            Player.Damage = AddedDamage * NegativeDamageMult + 1 *DamageMult
        end
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local JimboBaseTears = 1
        local JimboBaseDelay = mod:CalculateMaxFireDelay(JimboBaseTears)
        local AddedTears = (mod:CalculateTearsValue(Player) - JimboBaseTears)
        
        AddedTears = AddedTears * TearsMult

        if AddedTears < 0 then
            if AddedTears < -0.4 then
                Player.MaxFireDelay = JimboBaseDelay + mod:CalculateTearsUp(JimboBaseDelay, AddedTears + (1/(0.15*AddedTears + 0.2))*(-AddedTears))*TearsMult
            else
                Player.MaxFireDelay = JimboBaseDelay + mod:CalculateTearsUp(JimboBaseDelay, AddedTears + (1/(0.35*AddedTears + 0.5))*(-AddedTears))*TearsMult
            end
        elseif AddedTears <= 4 then
            Player.MaxFireDelay = JimboBaseDelay - mod:CalculateTearsUp(JimboBaseDelay, (1/(0.75*AddedTears+1))*AddedTears)
        else
            AddedTears = AddedTears - 4
            JimboBaseDelay = JimboBaseDelay - mod:CalculateTearsUp(JimboBaseDelay, 1)
            Player.MaxFireDelay = JimboBaseDelay - mod:CalculateTearsUp(JimboBaseDelay, (1/(0.5*AddedTears+1))*AddedTears)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.JimboStatCalculator)


---@param Player EntityPlayer
---@param Cache CacheFlag
function mod:JimboMinimumStats(Player, Cache)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    --print(mod:CalculateMaxFireDelay(Tears))
    if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        if Player.Damage < mod.SavedValues.Jimbo.MinimumDamage then
            Player.Damage = mod.SavedValues.Jimbo.MinimumDamage
        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.Damage = 4.5 / Tears
        end]]--
    end
    if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        local Tears = mod:CalculateTearsValue(Player)
        if Tears < mod.SavedValues.Jimbo.MinimumTears then
            Player.MaxFireDelay = mod:CalculateMaxFireDelay(mod.SavedValues.Jimbo.MinimumTears)

        end
        --[[if Player.Damage * Tears < 4.5 then
            Player.MaxFireDelay =  mod:CalculateMaxFireDelay(4.5 / Player.Damage)
        end]]--
    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.JimboMinimumStats)
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE + 1, mod.JimboMinimumStats)

---@param Player EntityPlayer 
function mod:StatReset(Player, Damage, Tears, Evaluate, Jokers, Basic)
    if Damage then
        if Basic then
            mod.SavedValues.Jimbo.StatsToAdd.Damage = 0
            mod.SavedValues.Jimbo.StatsToAdd.Mult = 1
        end
        if Jokers then
            mod.SavedValues.Jimbo.StatsToAdd.JokerDamage = 0
            mod.SavedValues.Jimbo.StatsToAdd.JokerMult = 1
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end
    end
    if Tears then
        if Basic then
            mod.SavedValues.Jimbo.StatsToAdd.Tears = 0
        end
        if Jokers then
            mod.SavedValues.Jimbo.StatsToAdd.JokerTears = 0
        end
        if Evaluate then
            Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        end
    end
end
--mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.IMPORTANT, mod.StatReset)

--finally gives the actual stat changes to jimbo, also used for always active buffs
function mod:StatGiver(Player, Cache)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local stats = mod.SavedValues.Jimbo.StatsToAdd

        if Cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            --print(stats.Damage + stats.JokerDamage)
            --print(Player.Damage * stats.JokerMult * stats.Mult)
            Player.Damage = (Player.Damage + (stats.Damage + stats.JokerDamage)) * Player.Damage * stats.JokerMult * stats.Mult
        end
        if Cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            --print(mod.CalculateTearsValue(Player))
            Player.MaxFireDelay = Player.MaxFireDelay - mod:CalculateTearsUp(Player.MaxFireDelay, (stats.Tears +  stats.JokerTears)* mod:CalculateTearsValue(Player))
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE,CallbackPriority.LATE, mod.StatGiver)


function mod:IncreaseJimboStats(Player,DamageUp,TearsUp,Mult, Evaluate, Basic)
    if Basic then
        mod.SavedValues.Jimbo.StatsToAdd.Damage = mod.SavedValues.Jimbo.StatsToAdd.Damage + DamageUp
        mod.SavedValues.Jimbo.StatsToAdd.Tears = mod.SavedValues.Jimbo.StatsToAdd.Tears + TearsUp
        mod.SavedValues.Jimbo.StatsToAdd.Mult = mod.SavedValues.Jimbo.StatsToAdd.Mult * Mult
    else
        mod.SavedValues.Jimbo.StatsToAdd.JokerDamage = mod.SavedValues.Jimbo.StatsToAdd.JokerDamage + DamageUp
        mod.SavedValues.Jimbo.StatsToAdd.JokerTears = mod.SavedValues.Jimbo.StatsToAdd.JokerTears + TearsUp
        mod.SavedValues.Jimbo.StatsToAdd.JokerMult = mod.SavedValues.Jimbo.StatsToAdd.JokerMult * Mult
    end
    
    if Evaluate then
        mod.StatEnable = true
        Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
        mod.StatEnable = false
        --print(mod.SavedValues.Jimbo.StatsToAdd.Tears)
    end

end

-------------CARD TEARS-----------------------
----------------------------------------------


--applies the additional effects for the card tears
---@param Tear EntityTear
---@param Collider Entity
function mod:OnTearCardCollision(Tear,Collider,_)
    if not mod:Contained(mod.CARD_TEAR_VARIANTS, Tear.Variant) then
        return
    end

    if Collider:IsActiveEnemy() then
        local TearRNG = Tear:GetDropRNG()
        local TearData = Tear:GetData()

        if mod:IsSuit(nil, TearData.Suit, TearData.Enhancement, mod.Suits.Heart) then --Hearts
            local Creep = Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, Tear.Position, Vector.Zero, Tear, 0, TearRNG:GetSeed()):ToEffect()
            Creep.SpriteScale = Vector(1.2,1.2)
            ---@diagnostic disable-next-line: need-check-nil
            Creep:Update()
            if TearRNG:RandomFloat() < 0.2 then
                Collider:AddCharmed(EntityRef(Tear.Parent), 120)
            end
        end
        if mod:IsSuit(nil, TearData.Suit, TearData.Enhancement, mod.Suits.Club) then --Clubs
            if TearRNG:RandomFloat() < 0.2 then
                Game:BombExplosionEffects(Tear.Position, Tear.CollisionDamage / 2, TearFlags.TEAR_NORMAL, Color.Default, Tear.Parent, 0.5)
                --Isaac.Explode(Tear.Position, Tear, Tear.CollisionDamage / 2)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.OnTearCardCollision)


---@param Tear EntityTear
function mod:AddCardTearFalgs(Tear, CardShot)
    local Player = Tear.Parent:ToPlayer()
    local Incubus = Tear.Parent:ToFamiliar()
    if Tear.SpawnerType == EntityType.ENTITY_PLAYER then
        --print("from player")
    end
    if Incubus then
        --print("Incubus")
    end
    if Player then
       -- print("player")
    end

    if Player and Player:GetPlayerType() == mod.Characters.JimboType then
        --damage dealt = Damage * TearRate of the player
        Tear.CollisionDamage = Player.Damage * mod:CalculateTearsValue(Player)
        Tear.Scale = 1
        --local TearSuit = mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[mod.SavedValues.Jimbo.HandSize]].Suit
        Tear:ChangeVariant(mod.CARD_TEAR_VARIANTS[CardShot.Suit])

        if mod:IsSuit(Player, CardShot.Suit, CardShot.Enhancement, mod.Suits.Spade, false) then --SPADES
            Tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        elseif mod:IsSuit(Player, CardShot.Suit, CardShot.Enhancement, mod.Suits.Diamond, false) then
            Tear:AddTearFlags(TearFlags.TEAR_BACKSTAB)
            Tear:AddTearFlags(TearFlags.TEAR_BOUNCE)
        end

        local TearSprite = Tear:GetSprite()
        TearSprite:Play(ENHANCEMENTS_ANIMATIONS[CardShot.Enhancement], true)
    end
end


--adjusts the card rotation basing on its movement every few frames
---@param Tear EntityTear
function mod:AdjustCardRotation(Tear)
    local Data = Tear:GetData()
    local TearSprite = Tear:GetSprite()
    Tear.Color = Color.Default

    if not Data.Counter then
        Data.Counter = 2
    end
    if Data.Counter == 2 then
        TearSprite.Rotation = Tear.Velocity:GetAngleDegrees()

        Data.LastRotation = TearSprite.Rotation
        Data.Counter = 0
    else
        TearSprite.Rotation = Data.LastRotation
        Data.Counter = Data.Counter + 1
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Spade])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Heart])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Club])
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.AdjustCardRotation, mod.CARD_TEAR_VARIANTS[mod.Suits.Diamond])


------------------VARIOUS/UTILITY------------------
------------------------------------------------

--shuffles the deck
---@param Player EntityPlayer
function mod:FullDeckShuffle(Player)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        local PlayerRNG = Player:GetDropRNG()
        mod.SavedValues.Jimbo.FullDeck = mod:Shuffle(mod.SavedValues.Jimbo.FullDeck, PlayerRNG)

        mod.SavedValues.Jimbo.DeckPointer = 1
        for i,v in ipairs(mod.SavedValues.Jimbo.CurrentHand) do
            mod.SavedValues.Jimbo.CurrentHand[i] = mod.SavedValues.Jimbo.DeckPointer
            mod.SavedValues.Jimbo.DeckPointer = mod.SavedValues.Jimbo.DeckPointer + 1
        end
    end
end

--allows to activate/disable selection states easly
function mod:SwitchCardSelectionStates(Player,NewMode,NewPurpose)

    if NewMode == mod.SelectionParams.Modes.NONE then

        mod.SelectionParams.Index = 1
        mod.SelectionParams.SelectionNum = 0
        Game:GetRoom():SetPauseTimer(0)

    else
        if mod.SelectionParams.Mode ~= mod.SelectionParams.Modes.NONE
           and mod.SelectionParams.Purpose ~= mod.SelectionParams.Purposes.DEATH1 then
            --if changing from an "active" state to another
            mod:UseSelection(Player)
        end
        Game:GetRoom():SetPauseTimer(225)

        if NewMode == mod.SelectionParams.Modes.HAND then
            mod.SelectionParams.OptionsNum = mod.SavedValues.Jimbo.HandSize

            if NewPurpose == mod.SelectionParams.Purposes.HAND then
                mod.SelectionParams.MaxSelectionNum = 5
                mod.SelectionParams.HandType = mod.HandTypes.NONE
                return
            elseif NewPurpose >= mod.SelectionParams.Purposes.TALISMAN then
                mod.SelectionParams.MaxSelectionNum = 1

            else --various tarot cards
                if NewPurpose == mod.SelectionParams.Purposes.DEATH1 then

                    mod.SelectionParams.MaxSelectionNum = 2

                elseif NewPurpose >= mod.SelectionParams.Purposes.WORLD then --any suit based tarot
                    --WORLD, SUN, MOON, STAR
                    mod.SelectionParams.MaxSelectionNum = 3

                else --any other card
                    local Size = -(NewPurpose % 2) + 2 --se main.lua to understand why this works
                    if Player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
                        Size = Size + 1
                    end
                    mod.SelectionParams.MaxSelectionNum = Size
                end
            end
                
        elseif NewMode == mod.SelectionParams.Modes.PACK then

            if NewPurpose == mod.SelectionParams.Purposes.StandardPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 3
    
            elseif NewPurpose == mod.SelectionParams.Purposes.TarotPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 3

            elseif NewPurpose == mod.SelectionParams.Purposes.CelestialPack then
                mod.SelectionParams.MaxSelectionNum = 1
                mod.SelectionParams.OptionsNum = 3
            end
        elseif NewMode == mod.SelectionParams.Modes.INVENTORY then
            mod.SelectionParams.MaxSelectionNum = 2
            mod.SelectionParams.OptionsNum = #mod.SavedValues.Jimbo.Inventory.Jokers
        end
    end
    mod.SelectionParams.Mode = NewMode
    mod.SelectionParams.Purpose = NewPurpose

end

--handles the single card selection
---@param Player EntityPlayer
function mod:Select(Player)
    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        --if its an actual option
        if mod.SelectionParams.Index <= mod.SavedValues.Jimbo.HandSize then
            local Choice = mod.SelectionParams.SelectedCards[mod.SelectionParams.Index]
            
            if Choice then

                mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = false                    
                mod.SelectionParams.SelectionNum = mod.SelectionParams.SelectionNum - 1

            --if it's not currently selected and it doesn't surpass the limit
            elseif mod.SelectionParams.SelectionNum < mod.SelectionParams.MaxSelectionNum then   
                
                --confirm the selection
                mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = true

                mod.SelectionParams.SelectionNum = mod.SelectionParams.SelectionNum + 1

                if mod.SelectionParams.MaxSelectionNum == mod.SelectionParams.SelectionNum then
                    --makes things faster by automatically activating if you chose the maximum number of cards
                    mod:UseSelection(Player)
                    mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
                    return

                elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.DEATH1 then
                    for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                        if v then
                            DeathCopyCard = mod.SavedValues.Jimbo.CurrentHand[i]
                            break
                        end
                    end
                end 
            end
            if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.HAND then
                --Isaac.RunCallback("HAND_TYPE_UPDATE")
            end

        else--if its the additional confirm button
            --print("confirm")
            mod:UseSelection(Player)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,0)
        end

    elseif mod.SelectionParams.Mode == mod.SelectionParams.Modes.PACK then

        if mod.SelectionParams.Index > mod.SelectionParams.OptionsNum then--skip button
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
            Isaac.RunCallback("PACK_SKIPPED", Player)
            return
        end

        if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.StandardPack then
            local SelectedCard = mod.SelectionParams.PackOptions[mod.SelectionParams.Index]
            table.insert(mod.SavedValues.Jimbo.FullDeck, SelectedCard)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)

        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.BuffonPack then

            local Tarot = mod.SelectionParams.PackOptions[mod.SelectionParams.Index]
            Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD, Player.Position, RandomVector()*3,nil,Tarot,Game:GetSeeds():GetStartSeed())
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)

        else --tarot/planet/Spectral pack
            local card = mod:FrameToSpecialCard(mod.SelectionParams.PackOptions[mod.SelectionParams.Index])
            local RndSeed = Random()
            if RndSeed == 0 then RndSeed = 1 end
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position, RandomVector()* 2, nil, card, RndSeed)
            mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE, 0)
        end
        
    elseif mod.SelectionParams.Mode == mod.SelectionParams.Modes.INVENTORY then

        if  mod.SelectionParams.Index <= #mod.SavedValues.Jimbo.Inventory.Jokers then
            --a joker is selected
            local Choice = mod.SelectionParams.SelectedCards[mod.SelectionParams.Index]

            if Choice then

                mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = false
                mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE

            --if it's not currently selected
            else
                if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.SELLING then
                    local FirstI
                    local SecondI = mod.SelectionParams.Index
                    for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                        if v then
                           FirstI = i
                           mod.SelectionParams.SelectedCards[i] = false
                           break
                        end
                    end

                    mod.SavedValues.Jimbo.Inventory.Jokers[FirstI],mod.SavedValues.Jimbo.Inventory.Jokers[SecondI] =
                    mod.SavedValues.Jimbo.Inventory.Jokers[SecondI],mod.SavedValues.Jimbo.Inventory.Jokers[FirstI]

                    mod.SavedValues.Jimbo.Progress.Inventory[FirstI],mod.SavedValues.Jimbo.Progress.Inventory[SecondI] =
                    mod.SavedValues.Jimbo.Progress.Inventory[SecondI],mod.SavedValues.Jimbo.Progress.Inventory[FirstI]

                    Isaac.RunCallback("INVENTORY_CHANGE", Player)
                    
                    mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE
                else
                    if mod.SavedValues.Jimbo.Inventory.Jokers[mod.SelectionParams.Index] ~= 0 then
                        mod.SelectionParams.SelectedCards[mod.SelectionParams.Index] = true
                        mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.SELLING
                    end
                end
            end
        else--the confirm button is pressed
            
            if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.SELLING then
                local SoldSlot
                for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                    if v then
                        SoldSlot = i
                       v = false
                       break
                    end
                end
                --print(FirstI)
                local Trinket = mod.SavedValues.Jimbo.Inventory.Jokers[SoldSlot]

                mod:SellJoker(Player, Trinket, SoldSlot)
                mod.SelectionParams.Purpose = mod.SelectionParams.Purposes.NONE
            else
                mod:SwitchCardSelectionStates(Player,mod.SelectionParams.Modes.NONE,mod.SelectionParams.Purposes.NONE)
            end
        end
    end
end

function mod:SellJoker(Player, Trinket, Slot)
    mod.SavedValues.Jimbo.Inventory.Jokers[Slot] = 0
    local SellValue = mod:GetJokerCost(Trinket)

    if mod.SavedValues.Jimbo.Inventory.Editions[Slot] == mod.Edition.NEGATIVE then
        --selling a negative joker reduces your inventory size
        mod:AddJimboInventorySlots(Player, -1)
        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.INVENTORY, mod.SelectionParams.Purposes.NONE)
        mod.SelectionParams.Index = mod.SelectionParams.Index - 1
    end

    for i=1, SellValue do
        Game:Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,Player.Position,RandomVector()*2,Player,CoinSubType.COIN_PENNY,RNG():GetSeed())
    end

    Isaac.RunCallback("INEVNTORY_CHANGED", Player)
    Isaac.RunCallback("JOKER_SOLD", Player, Trinket, Slot)
end


--activates the current selection when finished
---@param Player EntityPlayer
function mod:UseSelection(Player)
    if mod.SelectionParams.Mode == mod.SelectionParams.Modes.HAND then
        --could've done something nicer then teese elseifs but works anyways
        if mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.HAND then
            --effects
            mod:ActivateHandEffect(Player)
            --card substitution
            mod:SubstituteCards(mod.SelectionParams.SelectedCards)

        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.DEATH1 then --then the card that will become a copy
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    local selection = mod.SavedValues.Jimbo.CurrentHand[i] --gets the card that will be modified
                    mod.SavedValues.Jimbo.FullDeck[selection] = mod.SavedValues.Jimbo.FullDeck[DeathCopyCard]
                end
            end
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.HANGED then
            local selection
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    table.insert(selection, mod.SavedValues.Jimbo.CurrentHand[i]) --gets the card that will be modified
                end
            end
            table.sort(selection, function (a, b) --sorts it so table.remove doesn't move needed values
                if a > b then
                    return true
                end
                return false
            end)
            for _,v in ipairs(selection) do
                table.remove(mod.SavedValues.Jimbo.FullDeck, v)
            end
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.STRENGTH then
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    if mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Value == 13 then
                        mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Value = 1 --kings become aces
                    else
                        mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Value = 
                        mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Value + 1
                    end
                end
            end
        
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.CRYPTID then
            local Chosen
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    Chosen =mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]]
                    break
                end
            end
            for i=1, 2 do
                table.insert(mod.SavedValues.Jimbo.FullDeck, Chosen)
            end
        elseif mod.SelectionParams.Purpose == mod.SelectionParams.Purposes.AURA then
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    local EdRoll = Player:GetCardRNG(mod.Spectrals.AURA):RandomFloat()
                    if EdRoll <= 0.5 then
                        mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Edition = mod.Edition.FOIL
                    elseif EdRoll <= 0.85 then
                        mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Edition = mod.Edition.HOLOGRAPHIC
                    else
                        mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Edition = mod.Edition.POLYCROME
                    end
                    break
                end
            end

        --didn't want to put ~20 more elseifs so did this instead
        elseif mod.SelectionParams.Purpose >= mod.SelectionParams.Purposes.DEJA_VU then
            local NewSeal = mod.SelectionParams.Purpose - 17 --put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Seal = NewSeal --kings become aces
                    break
                end
            end

        elseif mod.SelectionParams.Purpose >= mod.SelectionParams.Purposes.WORLD then 
            local NewSuit = mod.SelectionParams.Purpose - mod.SelectionParams.Purposes.WORLD + 1--put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Suit = NewSuit
                end
            end
        elseif mod.SelectionParams.Purpose >= mod.SelectionParams.Purposes.EMPRESS then
            local NewEnh = PurposeEnh[mod.SelectionParams.Purpose] --put the purposes in order to make this work
            for i,v in ipairs(mod.SelectionParams.SelectedCards) do
                if v then
                    mod.SavedValues.Jimbo.FullDeck[mod.SavedValues.Jimbo.CurrentHand[i]].Enhancement = NewEnh
                end
            end
        end
    end
    for i,_ in ipairs(mod.SelectionParams.SelectedCards) do
        mod.SelectionParams.SelectedCards[i] = false
    end
end


------------ TRASH BIN -------------
-----------------------------------
--[[
function mod:ChangeCurrentHandType()
    
    mod.SelectionParams.PossibleHandTypes = mod:DeterminePokerHand()
    mod.SelectionParams.HandType = mod:GetMax(mod.SelectionParams.PossibleHandTypes)
    if mod.SelectionParams.HandType == 10 then
        mod.SavedValues.Jimbo.FiveUnlocked = true
    elseif mod.SelectionParams.HandType == 11 then
        mod.SavedValues.Jimbo.FlushHouseUnlocked = true
    elseif mod.SelectionParams.HandType == 12 then
        mod.SavedValues.Jimbo.FiveFlushUnlocked = true
    end

end
mod:AddCallback("HAND_TYPE_UPDATE", mod.ChangeCurrentHandType)


function mod:ActivateHandEffect(Player)
    Isaac.RunCallback("HAND_TYPE_UPDATE") --updates a last time to be sure

    --print(mod.SelectionParams.HandType)
    --print(mod.SavedValues.Jimbo.HandsStat[1])
    local StatsToGain = mod.SavedValues.Jimbo.HandsStat[mod.SelectionParams.HandType]

    
    --local StatsToGain = mod:HandStatCalculatorA(Player)

    --mod:IncreaseJimboStats(Player, StatsToGain.X , StatsToGain.Y)
end

-----------SHADERS----------------
----------------------------------
--man i hate working with shaders... jk i like it now
function mod:PackShader(Name)
    if Name == "Balatro_Pack_Opened" then
        if Game:GetHUD():IsVisible() then
            Game:GetHUD():Render()
            Isaac.RunCallback(ModCallbacks.MC_POST_HUD_RENDER)
        end
        --time is the amount of seconds the player has been choosing for
        local Time = math.min(255, mod.SelectionParams.Frames)
        local BackgroundColor = {200,0,0,1}

        local Params = {Time, BackgroundColor}
        return Params
    end
end
--mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.PackShader)
]]--


