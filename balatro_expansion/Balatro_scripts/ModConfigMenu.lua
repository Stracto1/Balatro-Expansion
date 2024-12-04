local json = require("json")
local mod = Balatro_Expansion

-------------MOD CONFIG MENU STUFF----------------------------
--------------------------------------------------------------

function mod:SaveStorage()
    mod:SaveData(json.encode(mod.SavedValues))
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.SaveStorage)

if ModConfigMenu then

local function SaveModConfig()
    if mod.SavedValues.ModConfig.EffectsAllowed then
        mod:SaveData("true")
    else
        mod:SaveData("false")
    end
end

ModConfigMenu.AddSetting("Balatro Expansion", "Settings", {
    Type = ModConfigMenu.OptionType.BOOLEAN,
Default = true,
CurrentSetting = function()
  return mod.SavedValues.ModConfig.EffectsAllowed
end,
Display = function()
  if mod.SavedValues.ModConfig.EffectsAllowed then return "Additional Effects: Enabled"
  else return "Additional Effects: Disabled" end
end,
OnChange = function(newvalue)
    mod.SavedValues.ModConfig.EffectsAllowed = newvalue
  --SaveModConfig()
end,
Info = {"Determines whether or not the additional Balatro VFX/SFX are used"}
})
end

