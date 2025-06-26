local mod = Balatro_Expansion
local json = require("json")

local Game = Game()

local Challenges = {}
Challenges.Balatro = Isaac.GetChallengeIdByName("Balatro")
--local ItemsConfig = Isaac.GetItemConfig()


---@param InitPlayer EntityPlayer
local function PlayerIndexUpdate(InitPlayer)

    --local ControllersFound = {}
    --local TrueIndex = 1

    for _,Player in ipairs(PlayerManager.GetPlayers()) do
        local Data = Player:GetData()
        --print("index: ",Player:GetPlayerIndex())
        Data.TruePlayerIndex = Player:GetPlayerIndex() + 1 --needs to start from 1 or the json says no
        
        --if not mod:Contained(ControllersFound, Player.ControllerIndex) then
        --    ControllersFound[#ControllersFound+1] = Player.ControllerIndex
        --    TrueIndex = TrueIndex + 1
        --end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PlayerIndexUpdate)


function mod:OnGameStart(Continued)

    if Continued and mod:HasData()then

        mod.Saved = json.decode(mod:LoadData()) --restores every saved progress from the last run

        --mod.ItemManager:LoadData(mod.Saved.HiddenItemsData)

        --also restores the invisible collectibles added previously
        for _,Player in ipairs(PlayerManager.GetPlayers()) do

            local PIndex = Player:GetData().TruePlayerIndex
            if not PIndex then
                PlayerIndexUpdate(Player)
                PIndex = Player:GetData().TruePlayerIndex
            end

            for _,Group in pairs(mod.Saved.Player[PIndex].InnateItems or {}) do
                for _,Item in ipairs(Group) do
                    Player:AddInnateCollectible(Item)
                end
            end
        end
        
    else

        mod.Saved.ShowmanRemovedItems = {}
        mod.HpEnable = false
        mod.ShopAddedThisFloor = false
        mod.AnimationIsPlaying = false

        mod.Saved.Pools = {}
        mod.Saved.Pools.Vouchers = {
        mod.Vouchers.Grabber,
        mod.Vouchers.Overstock,
        mod.Vouchers.Wasteful,
        mod.Vouchers.RerollSurplus,
        mod.Vouchers.TarotMerch,
        mod.Vouchers.PlanetMerch,
        mod.Vouchers.Clearance,
        mod.Vouchers.Hone,
        mod.Vouchers.Crystal,
        mod.Vouchers.Blank,
        mod.Vouchers.Telescope,
        mod.Vouchers.Brush,
        mod.Vouchers.Director,
        mod.Vouchers.Hieroglyph,
        mod.Vouchers.MagicTrick,
        mod.Vouchers.MoneySeed}

        mod.Saved.Pools.BossBlinds = { mod.BLINDS.BOSS_HOOK,
                                       mod.BLINDS.BOSS_CLUB,
                                       mod.BLINDS.BOSS_PSYCHIC,
                                       mod.BLINDS.BOSS_GOAD,
                                       mod.BLINDS.BOSS_WINDOW,
                                       mod.BLINDS.BOSS_MANACLE,
                                       mod.BLINDS.BOSS_PILLAR,
                                       mod.BLINDS.BOSS_HEAD,
                                       }

        mod.Saved.Pools.SpecialBossBlinds = { mod.BLINDS.BOSS_HEART,
                                              mod.BLINDS.BOSS_BELL,
                                              mod.BLINDS.BOSS_VESSEL,
                                              mod.BLINDS.BOSS_ACORN,
                                              mod.BLINDS.BOSS_LEAF,
                                              }


        mod.Saved.FloorVouchers = {}

        mod.Saved.FloorSkippedSpecials = 0
        mod.Saved.RunSkippedSpecials = 0
        mod.Saved.GlassBroken = 0
        mod.Saved.TarotsUsed = 0
        mod.Saved.PlanetTypesUsed = 0
        mod.Saved.BlindBeingPlayed = mod.BLINDS.SKIP

        mod.Saved.ClearedRooms = 0
        mod.Saved.SmallCleared = false
        mod.Saved.BigCleared = false
        mod.Saved.BossCleared = mod.BossProgress.NOT_CLEARED
        mod.Saved.AnteLevel = 0
        mod.Saved.MaxAnteLevel = 0
        mod.Saved.AnteBoss = mod.BLINDS.BOSS

        --mod.Saved.SmallBlindIndex = 1
        --mod.Saved.BigBlindIndex = 1
        --mod.Saved.ShopIndex = 1
        --mod.Saved.BossIndex = 1

        mod.Saved.HasDebt = false
        mod.Saved.MichelDestroyed = false

        mod.Saved.CardLevels = {}
        for i=1, 13 do
            mod.Saved.CardLevels[i] = 0
        end

        mod.ConsumableFullPosition = {}
        mod.JokerFullPosition = {}
        mod.LastCardFullPoss = {}
        for k,_ in pairs(mod.Counters) do
            if type(mod.Counters[k]) == "table" then
                mod.Counters[k] = {}
            else
                mod.Counters[k] = 0
            end
        end

        if mod:Contained(Challenges, Game.Challenge) then
            mod.Saved.Other.ShopEntered = true
        else
            mod.Saved.Other.ShopEntered = false
        end
    end

    mod.GameStarted = true

    
    for _, player in ipairs(PlayerManager.GetPlayers()) do  --evaluates again for the mod's trinkets since closing the game
        --resets stuff

        mod:InitJimboValues(player, not Continued) -- on new run always initialise jimbo values

        if player:GetPlayerType() == mod.Characters.JimboType 
           or player:GetPlayerType() == mod.Characters.TaintedJimbo then

            
            mod:StatReset(player,true,true,false,true,true)

            for _, Cache in pairs(mod.CustomCache) do
                player:AddCustomCacheTag(Cache, true)
            end


            Isaac.RunCallback("INVENTORY_CHANGE", player) --this evaluates everithing anyway
            --player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        end

        
    end

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED ,mod.OnGameStart)
                                        --btw putting IMPORTANT as the prioriry here makes it not happen

--Counter = 60
--Counter2 = 36

---@param Player EntityPlayer
function mod:InitJimboValues(Player, Force)

    
    local PIndex = Player:GetData().TruePlayerIndex
    if not PIndex then
        PlayerIndexUpdate(Player)
        PIndex = Player:GetData().TruePlayerIndex
    end

    --print(PIndex)

    mod.Saved.Player[PIndex] = {}
    local PType =  Player:GetPlayerType()
    
    if PType ~= mod.Characters.JimboType
       and PType ~= mod.Characters.TaintedJimbo then
        goto shared_values
    end

    do
    ---(T.)Jimbo Values -----


    mod.Saved.Player[PIndex].EctoUses = 0
    mod.Saved.Player[PIndex].OuijaUses = 0

    -------------------------
    
        

    if PType == mod.Characters.JimboType then

        mod.Saved.Player[PIndex].FullDeck = {}

        local index = 1
        for i = 1, 4, 1 do --cycles between the suits
            for j = 1, 13, 1 do --cycles for all the values
                mod.Saved.Player[PIndex].FullDeck[index] = {}
                mod.Saved.Player[PIndex].FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
                mod.Saved.Player[PIndex].FullDeck[index].Value = j --1 ~ 13
                mod.Saved.Player[PIndex].FullDeck[index].Enhancement = mod.Enhancement.NONE
                mod.Saved.Player[PIndex].FullDeck[index].Seal = mod.Seals.NONE
                mod.Saved.Player[PIndex].FullDeck[index].Edition = mod.Edition.BASE
                mod.Saved.Player[PIndex].FullDeck[index].Upgrades = 0 --only used for the Hiker joker
                index = index +1
            end
        end
    
        mod.Saved.Player[PIndex].DeckPointer = 6
        mod.Saved.Player[PIndex].CurrentHand = {5,4,3,2,1} --basically 5 different cards
        mod.Saved.Player[PIndex].LastShotIndex = 0

        mod.Saved.Player[PIndex].Inventory = {}
        for i=1,3 do
            mod.Saved.Player[PIndex].Inventory[i] = {}
            mod.Saved.Player[PIndex].Inventory[i].Joker = 0
            mod.Saved.Player[PIndex].Inventory[i].Edition = mod.Edition.BASE
        end
        

        mod.Saved.Player[PIndex].StatsToAdd = {}
        mod.Saved.Player[PIndex].StatsToAdd.Damage = 0
        mod.Saved.Player[PIndex].StatsToAdd.Tears = 1.5
        mod.Saved.Player[PIndex].StatsToAdd.Mult = 1
        mod.Saved.Player[PIndex].StatsToAdd.JokerDamage = 0
        mod.Saved.Player[PIndex].StatsToAdd.JokerTears = 0
        mod.Saved.Player[PIndex].StatsToAdd.JokerMult = 1

        mod.Saved.Player[PIndex].InnateItems = {}
        mod.Saved.Player[PIndex].InnateItems.General = {}
        mod.Saved.Player[PIndex].InnateItems.Hack = {}

        mod.Saved.Player[PIndex].FirstDeck = true

        mod.Saved.Player[PIndex].TrueDamageValue = 1 --used to surpass the usual 0.5 minimum damage cap
        mod.Saved.Player[PIndex].TrueTearsValue = 1

        mod.Saved.Player[PIndex].Progress = {} --values used for jokers
        mod.Saved.Player[PIndex].Progress.Inventory = {0,0,0} --never reset, changed in different ways basing on the joker
        mod.Saved.Player[PIndex].Progress.GiftCardExtra = {0,0,0}

        mod.Saved.Player[PIndex].Progress.Blind = {} --reset every new blind
        mod.Saved.Player[PIndex].Progress.Blind.Shots = 0

        mod.Saved.Player[PIndex].Progress.Room = {} --reset every new room
        mod.Saved.Player[PIndex].Progress.Room.SuitUsed = {}
        mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Spade] = 0
        mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Heart] = 0
        mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Club] = 0
        mod.Saved.Player[PIndex].Progress.Room.SuitUsed[mod.Suits.Diamond] = 0
        mod.Saved.Player[PIndex].Progress.Room.ValueUsed = {}
        for Value =1, 14 do
            mod.Saved.Player[PIndex].Progress.Room.ValueUsed[Value] = 0
        end
        mod.Saved.Player[PIndex].Progress.Room.Shots = 0
        mod.Saved.Player[PIndex].Progress.Room.ChampKills = 0
        mod.Saved.Player[PIndex].Progress.Room.KingsAtStart = 0


        mod.Saved.Player[PIndex].Progress.Floor = {}
        mod.Saved.Player[PIndex].Progress.Floor.CardsUsed = 0

        mod.Saved.Player[PIndex].LastCardUsed = nil --the last card a player used
        mod.Saved.Player[PIndex].NumActiveCostumes = 0

    elseif PType == mod.Characters.TaintedJimbo then

        mod.Saved.Player[PIndex].FullDeck = {}

        local index = 1
        for i = 1, 4, 1 do --cycles between the suits
            for j = 1, 13, 1 do --cycles for all the values
                mod.Saved.Player[PIndex].FullDeck[index] = {}
                mod.Saved.Player[PIndex].FullDeck[index].Suit = i --Spades - Hearts - clubs - diamonds
                mod.Saved.Player[PIndex].FullDeck[index].Value = j --1 ~ 13
                mod.Saved.Player[PIndex].FullDeck[index].Enhancement = mod.Enhancement.NONE
                mod.Saved.Player[PIndex].FullDeck[index].Seal = mod.Seals.NONE
                mod.Saved.Player[PIndex].FullDeck[index].Edition = mod.Edition.BASE
                mod.Saved.Player[PIndex].FullDeck[index].Upgrades = 0 --only used for the Hiker joker
                mod.Saved.Player[PIndex].FullDeck[index].Modifiers = 0
                --mod.Saved.Player[PIndex].FullDeck[index].Debuffed = false
                --mod.Saved.Player[PIndex].FullDeck[index].Covered = false
                index = index +1
            end
        end
    
        mod.Saved.Player[PIndex].DeckPointer = 1
        mod.Saved.Player[PIndex].CurrentHand = {} --basically 5 different cards
        mod.Saved.Player[PIndex].LastShotIndex = 0

        mod.Saved.Player[PIndex].Inventory = {}
        for i=1,5 do
            mod.Saved.Player[PIndex].Inventory[i] = {}
            mod.Saved.Player[PIndex].Inventory[i].Joker = 0
            mod.Saved.Player[PIndex].Inventory[i].Edition = mod.Edition.BASE
            mod.Saved.Player[PIndex].Inventory[i].Modifiers = 0
        end

        mod.Saved.Player[PIndex].Progress = {} --values used for jokers
        mod.Saved.Player[PIndex].Progress.Inventory = {0,0,0} --never reset, changed in different ways basing on the joker
        mod.Saved.Player[PIndex].Progress.GiftCardExtra = {0,0,0}

        mod.Saved.Player[PIndex].Consumables = {{Card = -1, Edition = 0}, {Card = -1, Edition = 0}}

        mod.Saved.Player[PIndex].MultValue = 0
        mod.Saved.Player[PIndex].ChipsValue = 0


        mod.Saved.Player[PIndex].HandsRemaining = 4
        mod.Saved.Player[PIndex].DiscrdsRemaining = 4

        mod.Saved.Player[PIndex].HandLevels = {[mod.HandTypes.HIGH_CARD] = 1,
                                               [mod.HandTypes.PAIR] = 1,
                                               [mod.HandTypes.TWO_PAIR] = 1,
                                               [mod.HandTypes.THREE] = 1,
                                               [mod.HandTypes.STRAIGHT] = 1,
                                               [mod.HandTypes.FLUSH] = 1,
                                               [mod.HandTypes.FULL_HOUSE] = 1,
                                               [mod.HandTypes.FOUR] = 1,
                                               [mod.HandTypes.STRAIGHT_FLUSH] = 1,
                                               [mod.HandTypes.ROYAL_FLUSH] = 1,
                                               [mod.HandTypes.FIVE] = 1,
                                               [mod.HandTypes.FLUSH_HOUSE] = 1,
                                               [mod.HandTypes.FIVE_FLUSH] = 1}
        
        --[[
        mod.Saved.Player[PIndex].HandsStat = {[mod.HandTypes.NONE] = Vector(0,0),
                                              [mod.HandTypes.HIGH_CARD] = Vector(1,1),
                                              [mod.HandTypes.PAIR] = Vector(2,2),
                                              [mod.HandTypes.TWO_PAIR] = Vector(4,2),
                                              [mod.HandTypes.THREE] = Vector(6,3),
                                              [mod.HandTypes.STRAIGHT] = Vector(6,4),
                                              [mod.HandTypes.FLUSH] = Vector(7,4),
                                              [mod.HandTypes.FULL_HOUSE] = Vector(8,4),
                                              [mod.HandTypes.FOUR] = Vector(12,7),
                                              [mod.HandTypes.STRAIGHT_FLUSH] = Vector(20,8),
                                              [mod.HandTypes.ROYAL_FLUSH] = Vector(20,8),
                                              [mod.HandTypes.FIVE] = Vector(24,6),
                                              [mod.HandTypes.FLUSH_HOUSE] = Vector(28,14),
                                              [mod.HandTypes.FIVE_FLUSH] = Vector(32,16)}]]

        mod.Saved.Player[PIndex].HandsStat = {[mod.HandTypes.NONE] = Vector(0, 0),
                                              [mod.HandTypes.HIGH_CARD] = Vector(5, 1),
                                              [mod.HandTypes.PAIR] = Vector(10, 2),
                                              [mod.HandTypes.TWO_PAIR] = Vector(20, 2),
                                              [mod.HandTypes.THREE] = Vector(30, 3),
                                              [mod.HandTypes.STRAIGHT] = Vector(30, 4),
                                              [mod.HandTypes.FLUSH] = Vector(35, 4),
                                              [mod.HandTypes.FULL_HOUSE] = Vector(40, 4),
                                              [mod.HandTypes.FOUR] = Vector(60, 7),
                                              [mod.HandTypes.STRAIGHT_FLUSH] = Vector(100, 8),
                                              [mod.HandTypes.ROYAL_FLUSH] = Vector(100, 8),
                                              [mod.HandTypes.FIVE] = Vector(120, 12),
                                              [mod.HandTypes.FLUSH_HOUSE] = Vector(140, 14),
                                              [mod.HandTypes.FIVE_FLUSH] = Vector(160, 16)}

        mod.Saved.Player[PIndex].HandsUsed = {[mod.HandTypes.HIGH_CARD] = 0,
                                      [mod.HandTypes.PAIR] = 0,
                                      [mod.HandTypes.TWO_PAIR] = 0,
                                      [mod.HandTypes.THREE] = 0,
                                      [mod.HandTypes.STRAIGHT] = 0,
                                      [mod.HandTypes.FLUSH] = 0,
                                      [mod.HandTypes.FULL_HOUSE] = 0,
                                      [mod.HandTypes.FOUR] = 0,
                                      [mod.HandTypes.STRAIGHT_FLUSH] = 0,
                                      [mod.HandTypes.ROYAL_FLUSH] = 0,
                                      [mod.HandTypes.FIVE] = 0,
                                      [mod.HandTypes.FLUSH_HOUSE] = 0,
                                      [mod.HandTypes.FIVE_FLUSH] = 0}
        

    end
    end

    mod.Saved.Player[PIndex].FullDeck = mod:Shuffle(mod.Saved.Player[PIndex].FullDeck, Game:GetPlayer(0):GetDropRNG())
    
    ::shared_values::

    mod.SelectionParams[PIndex] = {}
    mod.SelectionParams[PIndex].Frames = 0 -- in update frames
    mod.SelectionParams[PIndex].Index = 1
    mod.SelectionParams[PIndex].Mode = 0
    mod.SelectionParams[PIndex].Purpose = 0
    mod.SelectionParams[PIndex].PackOptions = {} --the options for the selection inside of a pack
    mod.SelectionParams[PIndex].OptionsNum = 0 --total amount of options
    mod.SelectionParams[PIndex].MaxSelectionNum = 0 --how many things you can choose at a time
    mod.SelectionParams[PIndex].SelectionNum = 0 --how many things you choosing


    if PType == mod.Characters.TaintedJimbo then --keeps in memory every different selection to make it much cooler
        
        mod.SelectionParams[PIndex].SelectedCards = {}

        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND] = {false,false,false,false,false}
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK] = {false,false,false}
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY] = {false,false,false,false,false}

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
    
        mod.SelectionParams[PIndex].PackPurpose = 0
        mod.SelectionParams[PIndex].HandType = mod.HandTypes.NONE
        mod.SelectionParams[PIndex].PossibleHandTypes = mod.HandTypes.NONE
        mod.SelectionParams[PIndex].PlayedCards = {} --contains the deck indexes of cards played from your hand
        mod.SelectionParams[PIndex].ScoringCards = 0
    else
        mod.SelectionParams[PIndex].SelectedCards = {false,false,false,false,false}

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
    end



    

    mod.Saved.Player[PIndex].ComedicState = 0
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.InitJimboValues)



function mod:SaveStorage(IsExit)

    if mod.GameStarted then --needed since POST_NEW_LEVEL goes before GAME_STARTED 

        --mod.Saved.HiddenItemsData = mod.ItemManager:GetSaveData()

        mod:SaveData(json.encode(mod.Saved))
    end
    if type(IsExit) ~= "nil" then --this variable exists only when the GAME_EXIT callback is called
        mod.GameStarted = false

        --[[
        for _,Player in ipairs(PlayerManager.GetPlayers()) do
            if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
                local PIndex = Player:GetData().TruePlayerIndex

                for _ , v in ipairs(mod.SelectionParams[PIndex].PlayedCards) do
                
                    table.insert(mod.Saved.Player[PIndex].CurrentHand, v)
                end
            end
        end]]
        --print("is now false")
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL,CallbackPriority.LATE, mod.SaveStorage)


local function ResetJimboValues()
    mod.Saved.Player = {}
    if mod.GameStarted then
        for _, Player in ipairs(PlayerManager.GetPlayers()) do
            mod:InitJimboValues(Player, true)

        end
    end
    mod.GameStarted = false --prevents errors when using luamod in the console
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ResetJimboValues)
