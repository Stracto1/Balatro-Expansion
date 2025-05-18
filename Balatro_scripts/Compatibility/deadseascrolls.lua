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
        Description = "While moving, Isaac leaves a trail of crayon dust which applies a different effect on enemies that step on it basing on it's color. The dust color changes every room.",
        Achievement = mod.Achievements.Items[mod.Collectibles.CRAYONS]
    },
    {
        Id = Balatro_Expansion.Collectibles.BANANA,
        Gfx = ItemsConfig:GetCollectible(Balatro_Expansion.Collectibles.BANANA).GfxFileName,
        Type = "Collectible",
        Name = "Banana",
        UnlockMethod = "Unlocked by defeating ???",
        Description = "When first used every floor, shoots a devastating banana that creates a Mama Mega! type explosion, then becomes a time-charged active that spawns banana peels able to make the enemies slip and take damamage.",
        Achievement = mod.Achievements.Items[mod.Collectibles.BANANA]
    },
    {
        Divider = true,
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

        item.buttons = {
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
                        Gfx = "gfx/ui/hud_dss_sheriff_icon.png",
                        ScaleFactor = Vector.Zero,
                        Name = "jimbo",
                        Description = "jimbo shoots cards that dealing the product of his damage and tears stat worth of damage. shoot cards and collect joker effects to increase these stats.",
                        Unlocked = true,
                        UnlockMethod = "\"beat 'a familiar game'\""
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
                table.insert(item.buttons, {
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
                                    Isaac.GetPersistentGameData():TryUnlock(Balatro_Expansion.Achievements.T_JIMBO)
                                else
                                    Isaac.ExecuteCommand("lockachievement " .. Balatro_Expansion.Achievements.T_JIMBO)
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

            local button = {
                cursoroff = Vector(-10, 0),
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

                                if REPENTOGON and Balatro_Expansion.Achievements.Items[data.Id] then
                                    if bool then
                                        Isaac.GetPersistentGameData():TryUnlock(Balatro_Expansion.Achievements.Items[data.Id])
                                    else
                                        Isaac.ExecuteCommand("lockachievement " .. Balatro_Expansion.Achievements.Items[data.Id])
                                    end
                                end
                            elseif data.Type == "Trinket" then
                                if REPENTOGON and Balatro_Expansion.Achievements.Trinkets[data.Id] then
                                    if bool then
                                        Isaac.GetPersistentGameData():TryUnlock(Balatro_Expansion.Achievements.Trinkets[data.Id])
                                    else
                                        Isaac.ExecuteCommand("lockachievement " .. Balatro_Expansion.Achievements.Trinkets[data.Id])
                                    end
                                end
                            elseif data.Type == "Entity" then
                                if data.Variant == Balatro_Expansion.Entities.Rancher.ID then --USELESS FOR NOW
                                    if bool then
                                        Isaac.GetPersistentGameData():TryUnlock(Balatro_Expansion.Achievements.Entities[data.Id])
                                    else
                                        Isaac.ExecuteCommand("lockachievement " .. Balatro_Expansion.Achievements.Entities[data.Id])
                                    end
                                end
                            elseif data.Type == "Card" then

                                if Balatro_Expansion.Achievements.Pickups[data.Id] then
                                    if bool then
                                        Isaac.GetPersistentGameData():TryUnlock(Balatro_Expansion.Achievements.Pickups[data.Id])
                                    else
                                        Isaac.ExecuteCommand("lockachievement " .. Balatro_Expansion.Achievements.Pickups[data.Id])
                                    end
                                end
                            end
                        end
                    }
                end
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
        { str = "catinsurance", tooltip = {strset = {"original","creator of", "thid menu's","setup"}} },
        { str = "gdkbb", tooltip = {strset = {"awesome","fella"}}},
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