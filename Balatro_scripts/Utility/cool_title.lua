local mod = Balatro_Expansion





function mod:Tast()
    if MenuManager.GetActiveMenu() ~= MainMenuType.TITLE then
        return
    end
    --print("Title")

    local Title = TitleMenu:GetSprite()

end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.Tast)