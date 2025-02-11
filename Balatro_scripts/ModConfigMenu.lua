local mod = Balatro_Expansion
-------------MOD CONFIG MENU STUFF----------------------------
--------------------------------------------------------------


if ModConfigMenu then

ModConfigMenu.AddSetting("Balatro Expansion", "Settings", {
    Type = ModConfigMenu.OptionType.BOOLEAN,
Default = true,
CurrentSetting = function()
  return mod.Saved.ModConfig.EffectsAllowed
end,
Display = function()
  if mod.Saved.ModConfig.EffectsAllowed then return "Additional Effects: Enabled"
  else return "Additional Effects: Disabled" end
end,
OnChange = function(newvalue)
    mod.Saved.ModConfig.EffectsAllowed = newvalue
    mod:SaveStorage()
end,
Info = {"Determines whether or not the additional Balatro VFX/SFX are used"}
})



ModConfigMenu.AddSetting("Balatro Expansion", "Settings", {
  Type = ModConfigMenu.OptionType.BOOLEAN,
Default = false,
CurrentSetting = function()
return mod.Saved.ModConfig.ExtraReadability
end,
Display = function()
if mod.Saved.ModConfig.ExtraReadability then return "Cards HUD: Readable"
else return "Cards HUD: Normal" end
end,
OnChange = function(newvalue)
  mod.Saved.ModConfig.ExtraReadability = newvalue
  mod:SaveStorage()
end,
Info = {"Changes the sprites used for cards in the HUD"}
})


end



