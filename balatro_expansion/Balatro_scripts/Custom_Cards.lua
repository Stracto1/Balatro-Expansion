---@diagnostic disable: inject-field
local mod = Balatro_Expansion
local Game = Game()

Card.CARD_PACK_STANDARD = Isaac.GetCardIdByName("Standard_Pack")
print(Card.CARD_PACK_STANDARD)

---@param Player EntityPlayer
---@param card Card
function mod:NewTarotEffects(card, Player,_)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        if card == Card.CARD_FOOL then
            mod:SwitchCardSelectionStates(Player, true, 1)
            return false
        end
        
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.NewTarotEffects)


---@param Player EntityPlayer
---@param card Card
function mod:CardPacks(card, Player,_)
    if Player:GetPlayerType() == mod.Characters.JimboType then
        if card == Card.CARD_PACK_STANDARD then
            local PackRng = Player:GetCardRNG(Card.CARD_PACK_STANDARD)

            for i = 1, 3, 1 do
                local RandomCard = {}
                RandomCard.Suit = PackRng:RandomInt(1, 4)
                RandomCard.Value = PackRng:RandomInt(1,13)
                RandomCard.Enhancement = PackRng:RandomInt(1,2)
                RandomCard.Edition = 1

                mod.CardSelectionParams.PackOptions[i] = RandomCard
            end

            mod:SwitchCardSelectionStates(Player, true, mod.CardSelectionParams.SelectionModes.PackSelection)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.CardPacks)