local mod = Balatro_Expansion

local Card = Sprite("gfx/ui/main menu/Logo card.anm2")
Card:SetFrame("card",0)

local CardIdlePos = Vector(237,70)


local CARD_STATES = {}
CARD_STATES.IDLE = 0 --usual title animation
CARD_STATES.PICKED_UP = 1 --dragging card with mouse
CARD_STATES.RETURNING = 2 --returning to title position


local CardState = CARD_STATES.IDLE
local LastCardPos = Vector(237,70)
function mod:Tast()
    if MenuManager.GetActiveMenu() ~= MainMenuType.TITLE then
        return
    end

    local Title = TitleMenu:GetSprite()
    local Screen = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
    
    CardIdlePos = Vector((Screen.X-6)/2, Title:GetAnimationData("Idle"):GetLayer(2):GetFrame(Title:GetFrame()):GetPos().Y - 10)

    local MousePos = Isaac.WorldToScreen(Input.GetMousePosition(true))
    --print(MousePos)
    

    if Input.IsMouseBtnPressed(MouseButton.LEFT) then
        if CardState ~= CARD_STATES.PICKED_UP
           and MousePos.X >= (Screen.X - 30)/2 and MousePos.X <= (Screen.X + 30)/2
           and MousePos.Y >= 38 and MousePos.Y <= 98 then --sadly there isn't a way to really get where the logo id rendered vertically, so put a large window instead

            CardState = CARD_STATES.PICKED_UP
        end

    elseif CardState == CARD_STATES.PICKED_UP then
        CardState = CARD_STATES.RETURNING

    elseif CardState == CARD_STATES.RETURNING then
        local RenderPos = LastCardPos + (CardIdlePos - LastCardPos)/2
        LastCardPos = RenderPos

        Card.Rotation = 0

        Card:Render(RenderPos)

        if math.ceil(RenderPos.X) == math.ceil(CardIdlePos.X) and math.ceil(RenderPos.Y) == math.ceil(CardIdlePos.Y) then
            
            CardState = CARD_STATES.IDLE
            LastCardPos = CardIdlePos
        end
    end

    if CardState == CARD_STATES.PICKED_UP then
        Title:SetOverlayFrame("Card", 0)

        local RenderPos = LastCardPos + (MousePos - LastCardPos)/4

        Card.Rotation = (LastCardPos.X - RenderPos.X)*1.75

        Card:Render(RenderPos)
        LastCardPos = RenderPos

    elseif CardState == CARD_STATES.IDLE then
        Title:PlayOverlay("Card", false)

        local Frame = Title:GetFrame()
        Title:SetOverlayFrame("Card", Frame + 1)


    end

end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.Tast)