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


        mod.Saved.HandOrderingMode = mod.HandOrderingModes.Rank
        mod.Saved.RunInfoMode = mod.RunInfoModes.OFF

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

        mod.Saved.HandOrderingMode = mod.HandOrderingModes.Rank
        mod.Saved.RunInfoMode = mod.RunInfoModes.OFF

        mod.Saved.ShowmanRemovedItems = {}
        mod.HpEnable = false
        mod.ShopAddedThisFloor = false
        mod.AnimationIsPlaying = false

        mod.Saved.Pools = {}
        mod.Saved.Pools.Vouchers = {mod.Vouchers.Grabber,
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

        mod.Saved.Pools.SkipTags = { mod.SkipTags.UNCOMMON,
                                     mod.SkipTags.RARE,
                                     mod.SkipTags.FOIL,
                                     mod.SkipTags.HOLO,
                                     mod.SkipTags.POLYCHROME,
                                     mod.SkipTags.INVESTMENT,
                                     mod.SkipTags.VOUCHER,
                                     mod.SkipTags.BOSS,
                                     mod.SkipTags.CHARM,
                                     mod.SkipTags.COUPON,
                                     mod.SkipTags.DOUBLE,
                                     mod.SkipTags.JUGGLE,
                                     mod.SkipTags.D6,
                                     mod.SkipTags.SPEED,
                                     mod.SkipTags.ECONOMY,}                                        
                                     



        mod.Saved.FloorVouchers = {}

        mod.Saved.FloorSkippedSpecials = 0
        mod.Saved.RunSkippedSpecials = 0
        mod.Saved.GlassBroken = 0
        mod.Saved.TarotsUsed = 0
        mod.Saved.PlanetTypesUsed = 0
        mod.Saved.BlindBeingPlayed = mod.BLINDS.NONE
        mod.Saved.CurrentBlindName = ""
        mod.Saved.CurrentBlindReward = 0
        mod.Saved.CurrentRound = 0
        mod.Saved.BossBlindVarData = 0
        mod.Saved.AnteCardsPlayed = {}
        mod.Saved.NumBossRerolls = 0
        mod.Saved.AnteVoucher = 0  
        mod.Saved.NumShopRerolls = 0
        mod.Saved.RerollStartingPrice = 5
        mod.Saved.NumBlindsSkipped = 0

        mod.Saved.SkipTags = {}

        mod.Saved.HandsRemaining = 4
        mod.Saved.DiscardsRemaining = 4

        mod.Saved.HandsPlayed = 0
        mod.Saved.DiscardsWasted = 0


        mod.Saved.HandLevels = {[mod.HandTypes.NONE] = 1,
                                [mod.HandTypes.HIGH_CARD] = 1,
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
        
        mod.Saved.HandsStat = {[mod.HandTypes.NONE] =    {Chips = 0, Mult = 0},
                               [mod.HandTypes.HIGH_CARD] = {Chips = 5, Mult = 1},
                               [mod.HandTypes.PAIR] =    {Chips = 10, Mult = 2},
                               [mod.HandTypes.TWO_PAIR] = {Chips = 20, Mult = 2},
                               [mod.HandTypes.THREE] =   {Chips = 30, Mult = 3},
                               [mod.HandTypes.STRAIGHT] = {Chips = 30, Mult = 4},
                               [mod.HandTypes.FLUSH] =   {Chips = 35, Mult = 4},
                               [mod.HandTypes.FULL_HOUSE] = {Chips = 40, Mult = 4},
                               [mod.HandTypes.FOUR] =        {Chips = 60, Mult = 7},
                               [mod.HandTypes.STRAIGHT_FLUSH] = {Chips = 100, Mult = 8},
                               [mod.HandTypes.ROYAL_FLUSH] = {Chips = 100, Mult = 8},
                               [mod.HandTypes.FIVE] = {Chips = 120, Mult = 12},
                               [mod.HandTypes.FLUSH_HOUSE] = {Chips = 140, Mult = 14},
                               [mod.HandTypes.FIVE_FLUSH] = {Chips = 160, Mult = 16}}

        mod.Saved.HandsTypeUsed = {[mod.HandTypes.NONE] = 0,
                                   [mod.HandTypes.HIGH_CARD] = 0,
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


        mod.Saved.MultValue = 0
        mod.Saved.ChipsValue = 0
        mod.Saved.TotalScore = 0
        mod.Saved.HandType = mod.HandTypes.NONE
        mod.Saved.PossibleHandTypes = mod.HandTypes.NONE

        mod.Saved.ClearedRooms = 0
        mod.Saved.SmallCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BigCleared = mod.BlindProgress.NOT_CLEARED
        mod.Saved.BossCleared = mod.BossProgress.NOT_CLEARED
        mod.Saved.AnteLevel = 0
        mod.Saved.MaxAnteLevel = 0
        --mod.Saved.BlindScalingFactor = 1
        mod.Saved.AnteBoss = mod.BLINDS.BOSS
        mod.Saved.SmallSkipTag = 0
        mod.Saved.BigSkipTag = 0
        mod.Saved.EncounteredStageIDs = {}

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
        mod.CardFullPoss = {}
        for k,_ in pairs(mod.Counters) do
            if type(mod.Counters[k]) == "table" then
                mod.Counters[k] = {}
            else
                mod.Counters[k] = 0
            end
        end

        if mod:Contained(Challenges, Game.Challenge) then
            mod.Saved.ShopEntered = true
        else
            mod.Saved.ShopEntered = false
        end

        mod.Saved.LastJokerRenderIndex = 6
    end

    mod.GameStarted = true

    local RNGPlayer = Game:GetPlayer(0)

    mod.RNGs.SHOP = RNG(RNGPlayer:GetTrinketRNG(mod.Jokers.JOKER):GetSeed())
    mod.RNGs.VOUCHERS = RNG(RNGPlayer:GetCollectibleRNG(mod.Vouchers.Blank):GetSeed())
    mod.RNGs.LUCKY_CARD = RNG(RNGPlayer:GetTrinketRNG(mod.Jokers.LUCKY_CAT):GetSeed())
    mod.RNGs.PURPLE_SEAL = RNG(RNGPlayer:GetTrinketRNG(mod.Jokers.FORTUNETELLER):GetSeed())
    mod.RNGs.SKIP_TAGS = RNG(RNGPlayer:GetTrinketRNG(mod.Jokers.THROWBACK):GetSeed())
    mod.RNGs.BOSS_BLINDS = RNG(RNGPlayer:GetTrinketRNG(mod.Jokers.LUCHADOR):GetSeed())
    
    for _, player in ipairs(PlayerManager.GetPlayers()) do  --evaluates again for the mod's trinkets since closing the game
                                                            --resets stuff

        mod:InitPlayerValues(player)

        if player:GetPlayerType() == mod.Characters.JimboType 
           or player:GetPlayerType() == mod.Characters.TaintedJimbo then
            
            mod:StatReset(player,true,true,false,true,true)

            for Name, Cache in pairs(mod.CustomCache) do

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

function mod:InitPlayerValues(Player)

    local PIndex = Player:GetData().TruePlayerIndex
    if not PIndex then
        PlayerIndexUpdate(Player)
        PIndex = Player:GetData().TruePlayerIndex
    end

    --print(PIndex)

    mod.Saved.Player[PIndex] = {}

    mod.SelectionParams[PIndex] = {}

    mod.SelectionParams[PIndex].Frames = 0 -- in update frames
    mod.SelectionParams[PIndex].Index = 1
    mod.SelectionParams[PIndex].Mode = 0
    mod.SelectionParams[PIndex].Purpose = 0
    mod.SelectionParams[PIndex].PackOptions = {} --the options for the selection inside of a pack
    mod.SelectionParams[PIndex].OptionsNum = 0 --total amount of options
    mod.SelectionParams[PIndex].MaxSelectionNum = 0 --how many things you can choose at a time
    mod.SelectionParams[PIndex].SelectionNum = 0 --how many things you choosing
    mod.SelectionParams[PIndex].PackPurpose = mod.SelectionParams.Purposes.NONE --used for TJimbo to not lose the current pack's purpose while doing other stuff 



    

    mod.Saved.Player[PIndex].InnateItems = {}
    mod.Saved.Player[PIndex].InnateItems.General = {} --used for things that can only give 1 kind of item
    mod.Saved.Player[PIndex].InnateItems.Planet_X = {}

    mod.Saved.Player[PIndex].LastTouchedTrinket = 0
    mod.Saved.Player[PIndex].TrinketEditions = {[0] = mod.Edition.BASE,
                                                [1] = mod.Edition.BASE,
                                                SMELTED = {[mod.Edition.FOIL] = 0,
                                                           [mod.Edition.HOLOGRAPHIC] = 0,
                                                           [mod.Edition.POLYCROME] = 0}}

    
    
    mod.Saved.Player[PIndex].ComedicState = 0

    mod.Saved.Player[PIndex].HandyCards = {0,0,0,0,0} --cards held with THE HAND collectible

    if Player:GetPlayerType() == mod.Characters.JimboType 
       or Player:GetPlayerType() == mod.Characters.TaintedJimbo then

        mod:InitJimboValues(PIndex, Player:GetPlayerType() == mod.Characters.TaintedJimbo)

        mod:SwitchCardSelectionStates(Player, mod.SelectionParams.Modes.NONE, mod.SelectionParams.Purposes.NONE)
    end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.InitPlayerValues)



function mod:InitJimboValues(PIndex, Tainted)
 

    --print(PIndex)

    mod.Saved.Player[PIndex].EctoUses = 0
    mod.Saved.Player[PIndex].OuijaUses = 0


    if not Tainted then

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
            mod.Saved.Player[PIndex].Inventory[i].RenderIndex = i
        end        

        mod.Saved.Player[PIndex].StatsToAdd = {}
        mod.Saved.Player[PIndex].StatsToAdd.Damage = 0
        mod.Saved.Player[PIndex].StatsToAdd.Tears = 1.5
        mod.Saved.Player[PIndex].StatsToAdd.Mult = 1
        mod.Saved.Player[PIndex].StatsToAdd.JokerDamage = 0
        mod.Saved.Player[PIndex].StatsToAdd.JokerTears = 0
        mod.Saved.Player[PIndex].StatsToAdd.JokerMult = 1

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
        --mod.Saved.Player[PIndex].Progress.Room.KingsAtStart = 0


        mod.Saved.Player[PIndex].Progress.Floor = {}
        mod.Saved.Player[PIndex].Progress.Floor.CardsUsed = 0

        mod.Saved.Player[PIndex].LastCardUsed = nil --the last card a player used
        mod.Saved.Player[PIndex].NumActiveCostumes = 0

    else

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
            mod.Saved.Player[PIndex].Inventory[i].RenderIndex = i
        end

        mod.Saved.Player[PIndex].Progress = {} --values used for jokers
        mod.Saved.Player[PIndex].Progress.Inventory = {0,0,0,0,0} --never reset, changed in different ways basing on the joker
        mod.Saved.Player[PIndex].Progress.GiftCardExtra = {0,0,0,0,0}
        mod.Saved.Player[PIndex].Progress.GiftCardConsumableExtra = {0,0}

        mod.Saved.Player[PIndex].Consumables = {{Card = -1, Edition = 0}, {Card = -1, Edition = 0}}

    end
    

    mod.Saved.Player[PIndex].FullDeck = mod:Shuffle(mod.Saved.Player[PIndex].FullDeck, Game:GetPlayer(0):GetDropRNG())
    

    if Tainted then --keeps in memory every different selection to make it much cooler
        
        mod.SelectionParams[PIndex].SelectedCards = {}

        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.NONE] = {}
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.HAND] = {false,false,false,false,false}
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.PACK] = {false,false,false}
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.INVENTORY] = {false,false,false,false,false}
        mod.SelectionParams[PIndex].SelectedCards[mod.SelectionParams.Modes.CONSUMABLES] = {false,false}
        
        mod.SelectionParams[PIndex].PlayedCards = {} --contains the deck indexes of cards played from your hand
        mod.SelectionParams[PIndex].ScoringCards = 0

    else
        mod.SelectionParams[PIndex].SelectedCards = {false,false,false,false,false}
    end
end



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
