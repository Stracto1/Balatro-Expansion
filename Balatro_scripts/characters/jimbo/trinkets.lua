local mod = Balatro_Expansion
-- \_(T_T)_/

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()

--local INVENTORY_RENDERING_POSITION = Vector(20,220) 

local EFFECT_COLORS = {}
EFFECT_COLORS.Red = 1
EFFECT_COLORS.Blue = 2
EFFECT_COLORS.Yellow = 3

local ADDMULTSOUND = Isaac.GetSoundIdByName("ADDMULTSFX")
local TIMESMULTSOUND = Isaac.GetSoundIdByName("TIMESMULTSFX")
local ACTIVATESOUND = Isaac.GetSoundIdByName("ACTIVATESFX")
local CHIPSSOUND = Isaac.GetSoundIdByName("CHIPSSFX")
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")


--a couple of trinkets still have their effects/ callbacks in Trinket_Effects.lua and Trinket_Callbacks.lua
--MR.Bones || ...



--effects when a card is shot
function mod:OnCardShot(Player,ShotCard,Evaluate)
    if not Evaluate then --basically if the room is hostile
        return
    end

    local Triggers = 1 --how many times the card needs to be activated again
    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --crash fix
    ---
    --retrigger calculation
    ---
    ----- PROGRESS CALCULATION------------------
    for _,RanOutOfNames in ipairs(mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, 0, true)) do
        for i = 1, Triggers do
            mod.SavedValues.Jimbo.Progress.SuitUsed[RanOutOfNames] = mod.SavedValues.Jimbo.Progress.SuitUsed[RanOutOfNames] + 1
        end
    end
    --------------------------------------------------

    if mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, mod.Suits.Diamond, false) then

        if mod:JimboHasTrinket(Player, TrinketType.TRINKET_ROUGH_GEM) then

            for i = 1, Triggers do
                if mod:TryGamble(Player, nil, 0.5) then
                    local Coin = Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Player.Position,
                                            RandomVector()*3, nil, CoinSubType.COIN_PENNY, RandomSeed)
                    Coin:ToPickup().Timeout = 50
                    mod:CreateBalatroEffect(Index,EFFECT_COLORS.Yellow, ACTIVATESOUND, "ACTIVATE!")
                end
            end
        end
    end
    


    --after the first deck got finished, no longer activate card effects
    --(joker effects always activate no matter what)
    Isaac.RunCallback("CARD_SHOT_FINAL",Player,ShotCard,Triggers, mod.SavedValues.Jimbo.FirstDeck)
end
mod:AddCallback("CARD_SHOT", mod.OnCardShot)

--effects when a joker gets sold
---@param Player EntityPlayer
function mod:OnJokerSold(Player,Joker,SlotSold)
    --print("sold")
    if Joker == TrinketType.TRINKET_INVISIBLE_JOKER then
        if mod.SavedValues.Jimbo.Progress.Inventory[SlotSold] ~= 3 then
            return
        end
        local HasSomethingElse = false
        for _, trinket in ipairs(mod.SavedValues.Jimbo.Inventory) do
            --can only copy something other than itself and nothing
            if trinket ~= 0 and trinket ~= TrinketType.TRINKET_INVISIBLE_JOKER then
                HasSomethingElse = true
                break
            end
        end

        if HasSomethingElse then --no need if player is poor
            local RandomJoker
            local Rng = Player:GetTrinketRNG(TrinketType.TRINKET_INVISIBLE_JOKER)
            repeat
                RandomJoker = mod.SavedValues.Jimbo.Inventory[Rng:RandomInt(1, #mod.SavedValues.Jimbo.Inventory)]
            until RandomJoker ~= 0 and RandomJoker ~= TrinketType.TRINKET_INVISIBLE_JOKER
            --print(RandomJoker)
            mod.SavedValues.Jimbo.Inventory[SlotSold] = RandomJoker
        end
    elseif false then

    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback("JOKER_SOLD", mod.OnJokerSold)

--effects when a blind gets completed
function mod:OnBlindClear(BlindType)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_INVISIBLE_JOKER)) do
        mod.SavedValues.Jimbo.Progress.Inventory[Index] = mod.SavedValues.Jimbo.Progress.Inventory[Index] + 1
        local Value = mod.SavedValues.Jimbo.Progress.Inventory[Index]

        if Value < 3 then --still charging
            mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, 
                                    ACTIVATESOUND, tostring(Value).."/3")
        else --usable
            mod:CreateBalatroEffect(Index,EFFECT_COLORS.Yellow, 
                                    ACTIVATESOUND, "READY!")
        end
    end
    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_ROCKET)) do
        
        --spawns this many coins
        local MoneyAmount = mod.SavedValues.Jimbo.Progress.Inventory[Index]
        for i=1, MoneyAmount do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                       Player.Position, RandomVector()*3, Player,
                       CoinSubType.COIN_PENNY, RandomSeed)
        end
        mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, 
                                ACTIVATESOUND, "+"..tostring(MoneyAmount).." $")
        --on boss beaten it upgrades
        if BlindType == mod.BLINDS.BOSS then
            mod.SavedValues.Jimbo.Progress.Inventory[Index] = mod.SavedValues.Jimbo.Progress.Inventory[Index] + 1
            mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, 
                                ACTIVATESOUND, "UPGRADE!")
        end

    end
    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_GOLDEN_JOKER)) do
        
        --spawns this many coins
        local MoneyAmmount = 3
        for i=1, MoneyAmmount do
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                       Player.Position, RandomVector()*3, Player,
                       CoinSubType.COIN_PENNY, RandomSeed)
        end
        mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, 
                                ACTIVATESOUND, "+"..tostring(MoneyAmmount).." $")
    end
    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_RIFF_RAFF)) do

        local RandomJoker = mod:GetRandom(mod.Trinkets, Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF), true)
        Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                   RandomVector()*3, nil, RandomJoker, RandomSeed)

        mod:CreateBalatroEffect(Index,EFFECT_COLORS.Yellow, ACTIVATESOUND, "ACTIVATE!")
        
    end


    ::skip_player::

    end
end
mod:AddCallback("BLIND_CLEARED", mod.OnBlindClear)

function mod:OnBlindStart(BlindType)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do
        if Player:GetPlayerType() ~= mod.Characters.JimboType then
            goto skip_player
        end
        local RandomSeed = Random()
        if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

        if mod:JimboHasTrinket(Player, TrinketType.TRINKET_RIFF_RAFF) then
            local JokerIndexes = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_RIFF_RAFF)
            for _, Index in ipairs(JokerIndexes) do

                local RandomJoker = mod:GetRandom(mod.Trinkets, Player:GetTrinketRNG(TrinketType.TRINKET_RIFF_RAFF), true)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Player.Position,
                           RandomVector()*3, nil, RandomJoker, RandomSeed)

                mod:CreateBalatroEffect(Index,EFFECT_COLORS.Yellow, 
                                        ACTIVATESOUND, "ACTIVATE!")
                
            end

        end


        ::skip_player::
    end
end
--mod:AddCallback("BLIND_STARTED", mod.OnBlindStart)


---@param Player EntityPlayer
function mod:OnPackOpened(Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    for _, Index in ipairs(mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_HALLUCINATION)) do
        local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_HALLUCINATION)
        if TrinketRNG:RandomFloat() < 0.5 then

            local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)
            Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                       RandomVector()*3, nil, RandomTarot, RandomSeed)
            mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, ACTIVATESOUND, "ACTIVATE!")
        end

    end

end
mod:AddCallback("PACK_OPENED", mod.OnPackOpened)

function mod:OnPackSkipped(Player,Pack)

end
mod:AddCallback("PACK_SKIPPED", mod.OnPackSkipped)


--usually used as a kind of hand played (ex. Vagabond)
function mod:OnRoomClear(IsBoss)
    for _, Player in ipairs(PlayerManager.GetPlayers()) do

    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        goto skip_player
    end

    local RandomSeed = Random()
    if RandomSeed == 0 then RandomSeed = 1 end --would crash the game otherwise

    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_VAGABOND) then
        if Player:GetNumCoins() < 4 then
            local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_VAGABOND)
            local JokerIndexes = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_VAGABOND)
            for _, Index in ipairs(JokerIndexes) do

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, RandomTarot, RandomSeed)
                mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, ACTIVATESOUND, "ACTIVATE!")


            end
        end
    end

    ::skip_player::
    end
end
mod:AddCallback("TRUE_ROOM_CLEAR", mod.OnRoomClear)

--adjusts the "copy" values for brainstorm and blueprint whenever the inventory is changed
function mod:CopyAdjustments(Player)

    for i,Joker in ipairs(mod.SavedValues.Jimbo.Inventory.Jokers) do
        local StartI = i
        repeat

            if Joker == TrinketType.TRINKET_BLUEPRINT then --copies the joker to its right
                i = i + 1
                Joker = mod.SavedValues.Jimbo.Inventory.Jokers[i] or 0 --if nothing is there then just put 0
            
                if i == StartI then --some combinations can lead to an infinite loop
                    Joker = 0
                end

            elseif Joker == TrinketType.TRINKET_BRAINSTORM then --copies the leftmost joker
                i = 1
                Joker = mod.SavedValues.Jimbo.Inventory.Jokers[i] or 0 --if nothing is there then just put 0
            
                if i == StartI then --some combinations can lead to an infinite loop
                    Joker = 0
                end
            end
        until (Joker ~= TrinketType.TRINKET_BLUEPRINT and Joker ~= TrinketType.TRINKET_BRAINSTORM)


        if Joker == 0 then --ItemsConfig:GetTrinket(Joker) is nil otherwise
            mod.SavedValues.Jimbo.Progress.Inventory[StartI] = 0

        elseif ItemsConfig:GetTrinket(Joker):HasCustomTag("copy") then --not every joker can be copied
            mod.SavedValues.Jimbo.Progress.Inventory[StartI] = Joker
        else
            mod.SavedValues.Jimbo.Progress.Inventory[StartI] = 0
        end

    end

    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback("INVENTORY_CHANGE", mod.CopyAdjustments)