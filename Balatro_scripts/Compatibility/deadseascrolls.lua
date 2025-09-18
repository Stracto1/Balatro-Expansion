---@diagnostic disable: undefined-global
--i'm gonna be honest i just copy-pasted the file from "The Sheriff"
--why? cause i'm lazy af

local MenuProvider = {}
local mod = Balatro_Expansion

function MenuProvider.SaveSaveData()
    mod:SaveStorage()
end

function MenuProvider.GetPaletteSetting()
    return mod.Saved.DSS.MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    mod.Saved.DSS.MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    return Options.HUDOffset * 10
end

function MenuProvider.SaveHudOffsetSetting(var)
    return
end

function MenuProvider.GetGamepadToggleSetting()
    return mod.Saved.DSS.GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    mod.Saved.DSS.GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return mod.Saved.DSS.MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    mod.Saved.DSS.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return mod.Saved.DSS.MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    mod.Saved.DSS.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return mod.Saved.DSS.MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    mod.Saved.DSS.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return mod.Saved.DSS.MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    mod.Saved.DSS.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return mod.Saved.DSS.MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    mod.Saved.DSS.MenusPoppedUp = var
end

local function splitLine(str, splitLength)
	local endTable = {}
	local currentString = ""
	for w in str:gmatch("%S+") do
		local newString = currentString .. w .. " "
		if newString:len() >= splitLength then
			table.insert(endTable, currentString)
			currentString = ""
		end

		currentString = currentString .. w .. " "
	end

	table.insert(endTable, currentString)
	return endTable
end

local dss = include("Balatro_scripts.Utility.dssmenucore")
local dssMod = dss.init("Dead Sea Scrolls (Tboi: Regambled)", MenuProvider)

local LINE_BREAK = {str="", nosel=true}

local ItemsConfig = Isaac.GetItemConfig()

local itemData = {
    {
        Id = Balatro_Expansion.Jokers.JOKER,
        Gfx = ItemsConfig:GetTrinket(Balatro_Expansion.Jokers.JOKER).GfxFileName,
        Type = "Trinket",
        Name = "Joker",
        UnlockMethod = "Unlocked by defeating Mom's Heart",
        Description = "1 flat damage up",
        Achievement = mod.Achievements.Trinkets[mod.Jokers.JOKER]
    },
    {
        Id = Balatro_Expansion.Collectibles.HORSEY,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.HORSEY).GfxFileName,
        Type = "Collectible",
        Name = "Horsey",
        UnlockMethod = "Unlocked by defeating Isaac",
        Description = "Summons a horse familiar that periodically jumps, moving in an L shape and creating shockwaves that damage enemies upon landing.",
        Achievement = mod.Achievements.Items[mod.Collectibles.HORSEY]
    },
    {
        Id = Balatro_Expansion.Collectibles.CRAYONS,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.CRAYONS).GfxFileName,
        Type = "Collectible",
        Name = "Box of Crayons",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "While moving, Isaac leaves a trail of crayon dust which applies various status effects on enemies that step on it basing on it's color. The dust color changes every room.",
        Achievement = mod.Achievements.Items[mod.Collectibles.CRAYONS]
    },
    {
        Id = Balatro_Expansion.Collectibles.BANANA,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.BANANA).GfxFileName,
        Type = "Collectible",
        Name = "Banana",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "When first used on every floor, shoots a devastating banana that creates a Mama Mega! type explosion, then becomes a time-charged active that spawns banana peels able to make the enemies slip and take damamage.",
        Achievement = mod.Achievements.Items[mod.Collectibles.BANANA]
    },
    {
        Id = Balatro_Expansion.Collectibles.UMBRELLA,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.UMBRELLA).GfxFileName,
        Type = "Collectible",
        Name = "Umbrella",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "Causes anvils to fall on Isaac every 5 - 7 seconds. Anvils can be reflected by the umbrella, sending them thorwards a random near enemy. Using the item again closes the umbrella and stops the anvils from falling",
        Achievement = mod.Achievements.Items[mod.Collectibles.UMBRELLA]
    },
    {
        Id = Balatro_Expansion.Collectibles.CLOWN,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.CLOWN).GfxFileName,
        Type = "Collectible",
        Name = "Clown Costume",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "When taking damage, every enemy has a 33% chance to get either fear or charm effect applied",
        Achievement = mod.Achievements.Items[mod.Collectibles.CLOWN]
    },
    {
        Id = Balatro_Expansion.Collectibles.BALOON_PUPPY,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.BALOON_PUPPY).GfxFileName,
        Type = "Collectible",
        Name = "Baloon Puppy",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "Spawns a floating puppy as a familiar able to reflect projectiles that hit it, exploding after taking enough damage. If Isaac gets damaged the puppy starts chasing down enemies dealing contact damage",
        Achievement = mod.Achievements.Items[mod.Collectibles.BALOON_PUPPY]
    },
    {
        Id = Balatro_Expansion.Collectibles.TRAGICOMEDY,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.TRAGICOMEDY).GfxFileName,
        Type = "Collectible",
        Name = "Tragicomedy",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "Upon entering a room, Isaac has a 40% chance to wear either a comedy pr tragedy mask, gaining stats basing on the mask worn. Both masks can be worn at the same time.",
        Achievement = mod.Achievements.Items[mod.Collectibles.TRAGICOMEDY]
    },
    {
        Id = Balatro_Expansion.Collectibles.LAUGH_SIGN,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.LAUGH_SIGN).GfxFileName,
        Type = "Collectible",
        Name = "Laugh Sign",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "An audience reacts live to Isaac's actions, throwing objects into the room and making noise in the process",
        Achievement = mod.Achievements.Items[mod.Collectibles.LAUGH_SIGN]
    },
    {
        Id = Balatro_Expansion.Collectibles.LOLLYPOP,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.LOLLYPOP).GfxFileName,
        Type = "Collectible",
        Name = "Lollypop",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "Spawns a lollypop on the ground every 20 seconds spent in an uncleared room. Picking up these lollypops temporarely grants the Gamekid effect",
        Achievement = mod.Achievements.Items[mod.Collectibles.LOLLYPOP]
    },
    {
        Id = Balatro_Expansion.Collectibles.FUNNY_TEETH,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.FUNNY_TEETH).GfxFileName,
        Type = "Collectible",
        Name = "Funny Teeth",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "Spawns a familiar that chases enemies and deals high contact damage. Afer being active for some time, a player needs to recharge it by standing near it for a few seconds",
        Achievement = mod.Achievements.Items[mod.Collectibles.FUNNY_TEETH]
    },
    {
        Id = Balatro_Expansion.Collectibles.POCKET_ACES,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.POCKET_ACES).GfxFileName,
        Type = "Collectible",
        Name = "Pocket Aces",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "Tears and lasers fired have a luck-based chance to become ace cards that deal damage equal to the product of the player's damage and tears stat",
        Achievement = mod.Achievements.Items[mod.Collectibles.POCKET_ACES]
    },
    {
        Id = Balatro_Expansion.Trinkets.TASTY_CANDY[1],
        Gfx = ItemsConfig:GetTrinket(Balatro_Expansion.Trinkets.TASTY_CANDY[mod.TastyCandyNum]).GfxFileName,
        Type = "Trinket",
        Name = "Tasty Candy",
        UnlockMethod = "Unlocked by defeating Ultra Greedier",
        Description = "Gives 5 free beggar payouts. If gulped gives a speed up that scales with the amount of uses remaining",
        Achievement = mod.Achievements.Trinkets[mod.Trinkets.TASTY_CANDY[1]],

        Last = true --added  by me cause my menu was broken idk
    },

    {
        Gfx = "gfx/ui/jimbob_dss_icon.png",
        Type = "Character",
        Name = "The Joker",
        UnlockMethod = "Visit Home's wardrobe as jimbo",
        Description = "balatro balatrez",
        Achievement = mod.Achievements.T_JIMBO,
        Tainted = true,
    },

    {
        Id = Balatro_Expansion.Collectibles.PLANET_X,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.PLANET_X).GfxFileName,
        Type = "Collectible",
        Name = "Planet X",
        UnlockMethod = "Unlocked by compleating all marks as T. Jimbo",
        Description = "Gain the effect of a random planetarium item every new room",
        Achievement = mod.Achievements.Items[mod.Collectibles.PLANET_X]
    },
    {
        Id = Balatro_Expansion.Collectibles.ERIS,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.ERIS).GfxFileName,
        Type = "Collectible",
        Name = "Eris",
        UnlockMethod = "Unlocked by compleating all marks as T. Jimbo",
        Description = "Enemies close to Isaac are slowed as they approach him, eventually starting to take damage",
        Achievement = mod.Achievements.Items[mod.Collectibles.ERIS]
    },
    {
        Id = Balatro_Expansion.Collectibles.CERES,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.CERES).GfxFileName,
        Type = "Collectible",
        Name = "Ceres",
        UnlockMethod = "Unlocked by compleating all marks as T. Jimbo",
        Description = "Gain an orbital that leaves behind floating meteors as it gets hit. The meteors deal Isaac's damage and disappear after taking 2 hits",
        Achievement = mod.Achievements.Items[mod.Collectibles.CERES]
    },

    {
        Id = Balatro_Expansion.Collectibles.THE_HAND,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.THE_HAND).GfxFileName,
        Type = "Collectible",
        Name = "The Hand",
        UnlockMethod = "Unlocked by aaaaaaaaaaaaa",
        Description = "Up to 5 cards can be stored inside the active item. Holding the item activates all cards stored in order",
        Achievement = mod.Achievements.Items[mod.Collectibles.THE_HAND]
    },

    {
        Id = Balatro_Expansion.Collectibles.HEIRLOOM,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.HEIRLOOM).GfxFileName,
        Type = "Collectible",
        Name = "Heirloom",
        UnlockMethod = "Unlocked by aaaaaaaaaaaaa",
        Description = "Coins have a chance to get their value upgraded. Pickups have a chance to become their golden variant",
        Achievement = mod.Achievements.Items[mod.Collectibles.HEIRLOOM]
    },

    {
        Id = Balatro_Expansion.Trinkets.PENNY_SEEDS,
        Gfx = ItemsConfig:GetTrinket(Balatro_Expansion.Trinkets.PENNY_SEEDS).GfxFileName,
        Type = "Trinket",
        Name = "Penny Seed",
        UnlockMethod = "Unlocked by aaaaaaaaaaaaa",
        Description = "Gain a coin per 5 cents held on new floor",
        Achievement = mod.Achievements.Trinkets[mod.Trinkets.PENNY_SEEDS]
    },

    {
        Id = Balatro_Expansion.Jokers.CHAOS_THEORY,
        Gfx = ItemsConfig:GetTrinket(Balatro_Expansion.Jokers.CHAOS_THEORY).GfxFileName,
        Type = "Trinket",
        Name = "Chaos Theory",
        UnlockMethod = "Unlocked by aaaaaaaaaaaaa",
        Description = "All pickups are randomized",
        Achievement = mod.Achievements.Trinkets[mod.Jokers.CHAOS_THEORY],

        Last = true
    },


    --[[
    {
        Id = Balatro_Expansion.Items.LightningRod.ID,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Items.LightningRod.ID).GfxFileName,
        Type = "Ultimate",
        Name = "Lightning Rod",
        UnlockMethod = "Unlocked by unlocking everything else",
        Description = "While held, rain will start to fall from above. Periodically, a powerful strike of lightning will hit a random location in the room, causing an explosion. Use the item to place a lightning rod, summoning three sequential, extra powerful strikes.",
        SingleRow = true,
    }]]
}

local activeItem
local dividerOffset = Vector(-75, 0)
local menu = {}

local fullLineDivider = Sprite()
fullLineDivider:Load("gfx/ui/hud_dss_divider.anm2", true)
fullLineDivider:Play("FullLine", true)



menu.main = {
    title = "tboi: regambled",
    tooltip = dssMod.menuOpenToolTip,
    buttons = {
        { str = "resume game", action = "resume" },
        { str = "unlock manager", dest = "unlockManager"},
        { str = "mod settings", dest = "regambledGeneralSettings"},
        {
            str = "menu settings",
            dest = "menuSettings",
            displayif = function ()
                return not DeadSeaScrollsMenu.CanOpenGlobalMenu()
            end
        },
        dssMod.changelogsButton,
        { str = "credits", dest = "credits"}
    }
}

menu.menuSettings = {
    title = "menu settings",
    buttons = {
        dssMod.gamepadToggleButton,
        dssMod.menuKeybindButton,
        dssMod.paletteButton,
        dssMod.menuHintButton,
        dssMod.menuBuzzerButton,
    }
}

menu.regambledGeneralSettings = {
    title = "mod settings",
    buttons = {
        { str = 'jimbo settings',dest = 'regambledJimboSettings'},
        { str = 't.jimbo settings',dest = 'regambledTaintedJimboSettings'}
    },

    dssMod.gamepadToggleButton,
    dssMod.menuKeybindButton,
    dssMod.paletteButton,
    dssMod.menuHintButton,
    dssMod.menuBuzzerButton,
}

menu.regambledJimboSettings = {
    title = "jimbo settings",
    buttons = {
        {   str = 'hand card scale',
            choices = {'100%','150%','200%',},
            setting = 1,
            variable = 'ragambledHandScale',

            load = function ()
                return mod.Saved.DSS.Jimbo.HandScale or 1
            end,

            store = function (var)
                mod.Saved.DSS.Jimbo.HandScale = var
            end,

            tooltip = {strset = {"which do you", "prefer?"}}
        },

        {   str = 'hand hud position',
            choices = {'player','hearts',},
            setting = 1,
            variable = 'ragambledHandPosition',

            load = function ()
                return mod.Saved.DSS.Jimbo.HandHUDPosition or 1
            end,

            store = function (var)
                mod.Saved.DSS.Jimbo.HandHUDPosition = var
            end,

            tooltip = {strset = {"which do you", "prefer?"}}
        },

    }
}

menu.regambledTaintedJimboSettings = {
    title = "t.jimbo settings",
    buttons = {
        {   str = 'Custom Desc',
            choices = {'disabled','enabled'},
            setting = 2,
            variable = 'ragambledTJimboDesc',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.CustomEID and 2 or 1
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.CustomEID = var == 2
            end,

            tooltip = {strset = {"eid", "required!"}}
        },

        {   str = 'Hand combat opacity',
            choices = {'0.25','0.5','0.75','1',},
            setting = 2,
            variable = 'ragambledTJimboOpacity',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.VulnerableHandOpacity * 4
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.VulnerableHandOpacity = var / 4
            end,

            tooltip = {strset = {"which do you", "prefer?"}}
        },

        {   str = 'Show full deck',
            choices = {'disabled','enabled',},
            setting = 1,
            variable = 'ragambledTJimboFullDeck',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.ShowUnavailableCards and 2 or 1
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.VulnerableHandOpacity = var == 2
            end,

            tooltip = {strset = {"show used", "cards in","run info"}}
        },

        LINE_BREAK,

        {   str = 'Base hands',
            choices = {'1','2','3','4','5','6',},
            setting = 4,
            variable = 'ragambledTJimboBaseHands',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.BaseHands
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.BaseHands = var
            end,

            tooltip = {strset = {"how", "many?"}}
        },
        {   str = 'Base discards',
            choices = {'1','2','3','4','5','6',},
            setting = 4,
            variable = 'ragambledTJimboBaseDiscards',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.BaseDiscards
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.BaseDiscards = var
            end,

            tooltip = {strset = {"how", "many?"}}
        },
        {   str = 'Out of range damage',
            choices = {'0%','25%','50%','75%','100%'},
            setting = 4,
            variable = 'ragambledTJimboOoRDamage',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.OutOfRangeDamage/0.25 + 1
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.OutOfRangeDamage = (var-1)*0.25
            end,

            tooltip = {strset = {"how", "much?"}}
        },
        {   str = 'Constant vulnerability',
            choices = {'disabled','enabled'},
            setting = 4,
            variable = 'ragambledTJimboVulnerability',

            load = function ()
                return mod.Saved.DSS.T_Jimbo.Vulnerability and 2 or 1
            end,

            store = function (var)
                mod.Saved.DSS.T_Jimbo.Vulnerability = var == 2
            end,

            tooltip = {strset = {"are you", "up for","it?"}}
        },

    }
}


menu.unlockManager = {
    title = "unlock manager",
    gridx = 2,
    centeritems = true,
    buttons = {},
    generate = function (item)
        -- Do the first divider manually since we don't want it to be selectable.
        local dividerLine = Sprite()
        dividerLine:Load("gfx/ui/hud_dss_divider.anm2", true)
        dividerLine:Play("Line", true)

        local dividerA = Sprite()
        dividerA:Load("gfx/ui/hud_dss_divider.anm2", true)
        dividerA:Play("Normal", true)
        dividerA:ReplaceSpritesheet(1, "gfx/ui/jimbo_dss_icon.png", true)
        dividerA.Offset = Vector(75,0)

        item.buttons = {
            {
                inline = true,
                str = "lock all",
                dest = "lockAllConfirmation",
                fullrow = true,
            },
            {
                inline = true,
                str = "unlock all",
                dest = "unlockAllConfirmation",
                fullrow = true,
            },
            {str = "", nosel = true, fullrow = true, fsize = 1},
            {
                cursoroff = dividerOffset,
                nosel = false,
                spr = {
                    color = DeadSeaScrollsMenu:GetPalette()[2],
                    sprite = dividerLine,
                    width = 0,
                    height = 1,

                    scale = Vector.One,
                    invisible = false,
                },
                func = function ()
                    activeItem = {
                        Gfx = "gfx/ui/jimbo_dss_icon.png",
                        ScaleFactor = Vector.Zero,
                        Name = "Jimbo",
                        Description = "Instead of shooting tears, Jimbo trows cards at enemies, which deal damage equal to the product of his tears and damage stat. Cards can be score a limited amount if times per room, giving him extra stats. Shops have special stocks of of jokers for jim to use.",
                        Unlocked = true,
                        UnlockMethod = "\"Have fun\""
                    }
                end,
                dest = "unlockInspection"
            },
            {
                nosel = true,
                spr = {
                    color = Color.Default,
                    sprite = dividerA,
                    width = 0,
                    height = 1,
                    scale = Vector.One,
                    invisible = false,
                }
            },
            {str = "", nosel = true, fullrow = true, fsize = 3},
            {str = "", nosel = true, fullrow = true, fsize = 1},
        }
        for i, data in ipairs(itemData) do
            if data.Divider then
                table.insert(item.buttons, {
                    nosel = true,
                    fullrow = true,
                    spr = {
                        color = DeadSeaScrollsMenu:GetPalette()[2],
                        sprite = fullLineDivider,
                        width = 0,
                        height = 1,
                        scale = Vector.One,
                        invisible = false,
                    },
                })
                table.insert(item.buttons, {str = "", nosel = true, fullrow = true, fsize = 3})
                table.insert(item.buttons, {str = "", nosel = true, fullrow = true, fsize = 1})
                goto skip
            end

            local spr = Sprite()
            spr:Load("gfx/ui/hud_dss_item.anm2", true)
            spr:ReplaceSpritesheet(0, data.Gfx)
            spr:LoadGraphics()
            spr:Play("Idle", true)
            local unlocked = Isaac.GetPersistentGameData():Unlocked(data.Achievement)
            local scaleFactor = 1

            local color = unlocked and Color.Default or Color(0, 0, 0, 1)


            if data.Type == "Character" then
                local dividerB = Sprite()
                dividerB:Load("gfx/ui/hud_dss_divider.anm2", true)
                dividerB:Play("Tainted", true)
                dividerB:ReplaceSpritesheet(3, data.Gfx, true)
                dividerB.Offset = Vector(75, 0)


                --dividerLine.Offset = Vector(-75, 75) --idfk man it was just broken

                table.insert(item.buttons, {
                    nosel = false,
                    fullrow = true,
                    cursoroff = dividerOffset,
                    spr = {
                        color = DeadSeaScrollsMenu:GetPalette()[2],
                        sprite = dividerLine,
                        width = 0,
                        height = 1,

                        scale = Vector.One,
                        invisible = false,
                    },
                    func = function ()
                        activeItem = {
                            Gfx = data.Gfx,
                            ScaleFactor = scaleFactor,
                            Name = data.Name:lower(),
                            Description = data.Description:lower(),
                            Unlocked = unlocked,
                            UnlockMethod = data.UnlockMethod,
                            ToggleFunction = function (bool)

                                if bool then
                                    Isaac.GetPersistentGameData():TryUnlock(Sheriff.RepentogonAchievements.Tainted)
                                else
                                    Isaac.ExecuteCommand("lockachievement " .. Sheriff.RepentogonAchievements.Tainted)
                                end
                            end
                        }
                    end,
                    dest = "unlockInspection",
                })
                table.insert(item.buttons, {
                    nosel = true,
                    spr = {
                        color = color,
                        sprite = dividerB,
                        width = 0,
                        height = 1,
                        scale = Vector.One,
                        invisible = false,
                    },
                })
                table.insert(item.buttons, {str = "", nosel = true, fullrow = true, fsize = 3})
                table.insert(item.buttons, {str = "", nosel = true, fullrow = true, fsize = 1})

                goto skip
            end

            local FullRow = false
            local CursorOff = Vector(-10, 0)

            if i % 2 == 1 and data.Last then
                spr.Offset = Vector(30, 0)
                FullRow = true
                CursorOff = CursorOff + spr.Offset
            end

            local button = {
                fullrow = FullRow,
                cursoroff = CursorOff,
                spr = {
                    color = color,
                    sprite = spr,
                    width = data.SingleRow and 0 or 64,
                    height = 32,

                    scale = Vector.One * scaleFactor,
                    invisible = false,
                },
                dest = "unlockInspection",
                func = function ()
                    activeItem = {
                        Gfx = data.Gfx,
                        ScaleFactor = scaleFactor,
                        Name = data.Name:lower(),
                        Description = data.Description:lower(),
                        Unlocked = unlocked,
                        UnlockMethod = data.UnlockMethod,
                        ToggleFunction = function (bool)
                            -- this is all so hacky... i hate unlockapi
                            if data.Type == "Collectible" then
  
                                if bool then
                                    Isaac.GetPersistentGameData():TryUnlock(data.Achievement)
                                else
                                    Isaac.ExecuteCommand("lockachievement " .. data.Achievement)
                                end
                                
                            elseif data.Type == "Trinket" then

                                if bool then
                                    Isaac.GetPersistentGameData():TryUnlock(data.Achievement)
                                else
                                    Isaac.ExecuteCommand("lockachievement " .. data.Achievement)
                                end
                               
                            elseif data.Type == "Entity" then
                                for _, unlockData in ipairs(UnlockAPI.Unlocks.Entities) do
                                    if data.Id == unlockData.Type and data.Variant == (unlockData.Variant or data.Variant) and data.Subtype == (unlockData.SubType or data.Subtype) then
                                        UnlockAPI.Helper.SetRequirements(unlockData.UnlockRequirements, data.Tainted and "t.The Sheriff" or "The Sheriff", bool)
                                    end

                                    if bool then
                                        Isaac.GetPersistentGameData():TryUnlock(Sheriff.RepentogonAchievements.Rancher)
                                    else
                                        Isaac.ExecuteCommand("lockachievement " .. Sheriff.RepentogonAchievements.Rancher)
                                    end
                                    
                                end
                            elseif data.Type == "Card" then

                                if bool then
                                    Isaac.GetPersistentGameData():TryUnlock(data.Achievement)
                                else
                                    Isaac.ExecuteCommand("lockachievement " .. data.Achievement)
                                end
                            elseif data.Type == "Ultimate" then

                                if bool then
                                    Isaac.GetPersistentGameData():TryUnlock(data.Achievement)
                                else
                                    Isaac.ExecuteCommand("lockachievement " .. data.Achievement)
                                end
                            end
                        end
                    }
                end,
            }




            table.insert(item.buttons, button)

            ::skip::
        end
    end
}


menu.lockAllConfirmation = {
    title = "confirmation",
    tooltip = {strset = {"are you sure", "you want to", "do this?"}},
    buttons = {
        {
            strset = {"are you sure", "you want to", "lock all items?"},
            nosel = true,
            fsize = 3,
        },
        LINE_BREAK,
        LINE_BREAK,
        {
            str = "Nope!",
            inline = true,
            func = function (_, _, tbl)
                dssMod.back(tbl)
            end
        },
        {
            str = "Yessir!",
            inline = true,
            func = function (_, _, tbl)

                for _, tab in pairs(Balatro_Expansion.Achievements) do
                    if type(tab) == "table" then
                        for _, ach in pairs(tab) do
                            Isaac.ExecuteCommand("lockachievement " .. ach)
                        end
                    else
                        Isaac.ExecuteCommand("lockachievement " .. tab)
                    end
                end

                dssMod.back(tbl)
            end
        }
    }
}

menu.unlockAllConfirmation = {
    title = "confirmation",
    tooltip = {strset = {"are you sure", "you want to", "do this?"}},
    buttons = {
        {
            strset = {"are you sure", "you want to", "unlock all items?"},
            nosel = true,
            fsize = 3,
        },
        LINE_BREAK,
        LINE_BREAK,
        {
            str = "Nope!",
            inline = true,
            func = function (_, _, tbl)
                dssMod.back(tbl)
            end
        },
        {
            str = "Yessir!",
            inline = true,
            func = function (_, _, tbl)

                for _, tab in pairs(Balatro_Expansion.RepentogonAchievements) do
                    if type(tab) == "table" then
                        for _, ach in pairs(tab) do
                            Isaac.GetPersistentGameData():TryUnlock(ach, true)
                        end
                    else
                        Isaac.GetPersistentGameData():TryUnlock(tab, true)
                    end
                end
                
                dssMod.back(tbl)
            end
        }
    }
}

menu.unlockInspection = {
    title = "unlock inspector",
    tooltip = {strset = {"currently", "inspecting an", "unlock"}},
    buttons = {},
    scroller = true,
    scroll = 100,
    generate = function (item, tbl)
        if not activeItem then
            mod.SFX:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
            dssMod.back(tbl)
        end

        local spr = Sprite()
        spr:Load("gfx/ui/hud_dss_item.anm2", true)
        spr:ReplaceSpritesheet(0, activeItem.Gfx)
        spr:LoadGraphics()
        spr:Play("Idle", true)

        item.buttons = {
            {
                str = activeItem.Unlocked and activeItem.Name or string.rep("?", activeItem.Name:len()),
                nosel = true,
                fsize = 3
            },
            {
                fsize = 1,
                strset = splitLine(activeItem.UnlockMethod:lower(), 35),
                nosel = true
            },
            {
                spr = {
                    color = activeItem.Unlocked and Color.Default or Color(0, 0, 0, 1),
                    sprite = spr,
                    width = 16,
                    height = 16,
                    scale = Vector.One,
                    invisible = false,
                },
                nosel = true
            },
            LINE_BREAK,
            {
                fsize = 1,
                strset = splitLine(activeItem.Unlocked and activeItem.Description or string.gsub(activeItem.Description, "%w", "?"), 35),
                nosel = true
            },
            LINE_BREAK,
            {
                str = 'unlock status',
                choices = { 'locked', 'unlocked' },
                setting = 1,
                variable = 'Regambled_AnyUnlock',

                generate = function(button)
                    button.setting = activeItem.Unlocked and 2 or 1
                end,

                displayif = function ()
                    return activeItem.ToggleFunction ~= nil
                end,

                changefunc = function(button)
                    if not activeItem.ToggleFunction then return end
                    activeItem.ToggleFunction(button.setting == 2)

                    item.buttons[1].str = button.setting == 2 and activeItem.Name or string.rep("?", activeItem.Name:len())
                    item.buttons[3].spr.color  = button.setting == 2 and Color.Default or Color(0, 0, 0, 1)
                    item.buttons[5].strset = splitLine(button.setting == 2 and activeItem.Description or string.gsub(activeItem.Description, "%w", "?"), 35)

                end,
            },
        }
    end
}

menu.credits = {
    title = "credits",
    buttons = {
        { str = "first things first", fsize = 3, nosel = true},
        { str = "=================================", fsize = 1, nosel = true},
        { str = "catinsurance", tooltip = {strset = {"original","creator of", "this menu's","setup"}} },
        { str = "NegativeNEV", tooltip = {strset = {"awesome","fella"}}},
        { str = "balatro/local thunk", tooltip = {strset = {"original", "inspiration"}}},
        LINE_BREAK,
        { str = "active contributors", fsize = 3, nosel = true},
        { str = "=================================", fsize = 1, nosel = true},
        { str = "stracto", tooltip = {strset = {"programmer","spriter","item ideas"}}},
        LINE_BREAK,
        LINE_BREAK,
        {nosel = true, str = "", fsize = 1},
        {str = "if you're reading this, you're awesome!!", nosel = true, fsize = 1}
    }
}

local awesomeDirectoryKey = {
    Item = menu.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Tboi: Regambled", {

    Run = dssMod.runMenu,

    Open = dssMod.openMenu,

    Close = dssMod.closeMenu,

    UseSubMenu = false,
    Directory = menu,
    DirectoryKey = awesomeDirectoryKey
})