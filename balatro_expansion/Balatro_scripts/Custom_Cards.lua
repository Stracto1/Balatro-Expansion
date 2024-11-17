---@param Player EntityPlayer
---@param card Card
function Balatro_Expansion:OnJimboUseCard(card, Player,_)
    if Player:GetPlayerType() == Balatro_Expansion.Characters.JimboType then
        if card == Card.CARD_FOOL then
            print("Jimbo used fool")
            Player:AnimateCard(card)
            return false
        end
    end
end
Balatro_Expansion:AddCallback(ModCallbacks.MC_PRE_USE_CARD, Balatro_Expansion.OnJimboUseCard)