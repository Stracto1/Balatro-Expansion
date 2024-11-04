local json = require("json")


-------------MOD CONFIG MENU STUFF----------------------------
--------------------------------------------------------------

function Balatro_Expansion:SaveStorage()
    Balatro_Expansion:SaveData(json.encode(TrinketValues))
end

if ModConfigMenu then

local function SaveModConfig()
    if TrinketValues.EffectsAllowed then
        Balatro_Expansion:SaveData("true")
    else
        Balatro_Expansion:SaveData("false")
    end
end

ModConfigMenu.AddSetting("Balatro Expansion", "Settings", {
    Type = ModConfigMenu.OptionType.BOOLEAN,
Default = true,
CurrentSetting = function()
  return TrinketValues.EffectsAllowed
end,
Display = function()
  if TrinketValues.EffectsAllowed then return "Additional Effects: Enabled"
  else return "Additional Effects: Disabled" end
end,
OnChange = function(newvalue)
    TrinketValues.EffectsAllowed = newvalue
  --SaveModConfig()
end,
Info = {"Determines whether or not the additional Balatro VFX/SFX are used"}
})
end

Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Balatro_Expansion.SaveStorage)
Balatro_Expansion:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Balatro_Expansion.SaveStorage)