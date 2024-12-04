local mod = Balatro_Expansion
local Game = Game()

---@param Player EntityPlayer
---@param card Card
function mod:OnJimboUseCard(card, Player,_)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        if card == Card.CARD_FOOL then
            mod:SwitchCardSelectionStates(true, 1)
        end
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnJimboUseCard)