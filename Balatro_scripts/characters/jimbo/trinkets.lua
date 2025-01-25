local mod = Balatro_Expansion
local Game = Game()

--local INVENTORY_RENDERING_POSITION = Vector(20,220)<== should be this but \_(T_T)_/

local EFFECT_COLORS = {}
EFFECT_COLORS.Red = 1
EFFECT_COLORS.Blue = 2
EFFECT_COLORS.Yellow = 3

local ADDMULTSOUND = Isaac.GetSoundIdByName("ADDMULTSFX")
local TIMESMULTSOUND = Isaac.GetSoundIdByName("TIMESMULTSFX")
local ACTIVATESOUND = Isaac.GetSoundIdByName("ACTIVATESFX")
local CHIPSSOUND = Isaac.GetSoundIdByName("CHIPSSFX")
local SLICESOUND = Isaac.GetSoundIdByName("SLICESFX")

--effects when a card is shot
function mod:OnCardShot(Player,ShotCard,Evaluate)
    local Retriggers = 0 --how many times the card needs to be activated again

    if not Game:GetRoom():IsClear() then

        mod:StatReset(Player,true, true, false, true, false)

        for _,RanOutOfNames in ipairs(mod:IsSuit(Player, ShotCard.Suit,ShotCard.Enhancement, 0, true)) do
            for i = 0, Retriggers do
                mod.SavedValues.Jimbo.Progress.SuitUsed[RanOutOfNames] = mod.SavedValues.Jimbo.Progress.SuitUsed[RanOutOfNames] + 1
            end
        end   
        Isaac.RunCallback("CARD_SHOT_FINAL",Player,ShotCard,Retriggers,Evaluate)
    end
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
    elseif ACTIVATESOUND==0 then

    end
    mod:StatReset(Player,true,true,false,false,true)
    mod.StatEnable = true
    Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, false)
    Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    mod.StatEnable = false
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

    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_INVISIBLE_JOKER) then
        local JokerIndexes = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_INVISIBLE_JOKER)
        for _, Index in ipairs(JokerIndexes) do
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
    end
    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_ROCKET) then
        local JokerIndex = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_ROCKET)
        for Index, v in pairs(JokerIndex) do
            
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
        
    end
    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_GOLDEN_JOKER) then
        local JokerIndex = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_GOLDEN_JOKER)
        for Index, v in pairs(JokerIndex) do
            
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
        
    end
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

    if mod:JimboHasTrinket(Player, TrinketType.TRINKET_HALLUCINATION) then
        local TrinketRNG = Player:GetTrinketRNG(TrinketType.TRINKET_HALLUCINATION)
        local JokerIndexes = mod:GetJimboJokerIndex(Player, TrinketType.TRINKET_HALLUCINATION)
        for _, Index in ipairs(JokerIndexes) do
            if TrinketRNG:RandomFloat() < 0.5 then

                local RandomTarot = TrinketRNG:RandomInt(Card.CARD_FOOL, Card.CARD_WORLD)
                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                           RandomVector()*3, nil, RandomTarot, RandomSeed)
                mod:CreateBalatroEffect(Index, EFFECT_COLORS.Yellow, ACTIVATESOUND, "ACTIVATE!")
            end

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