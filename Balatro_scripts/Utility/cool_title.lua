local mod = Balatro_Expansion

local Card = Sprite("gfx/ui/main menu/Logo card.anm2")
Card:SetFrame("card",0)

local CardIdlePos = Vector(237,69)


local CARD_STATES = {}
CARD_STATES.IDLE = 0 --usual title animation
CARD_STATES.PICKED_UP = 1 --dragging card with mouse
CARD_STATES.RETURNING = 2 --returning to title position

local PICKED_TIME = 0
local CardState = CARD_STATES.IDLE
local LastCardPos = Vector(237,69)


function mod:Tast()
    if MenuManager.GetActiveMenu() ~= MainMenuType.TITLE then
        return
    end

    local Title = TitleMenu:GetSprite()
    local Screen = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
    
    CardIdlePos = Vector((Screen.X-6)/2, 
                          Screen.Y/2 + Title:GetAnimationData("Idle"):GetLayer(2):GetFrame(Title:GetFrame()):GetPos().Y - 146)

    local MousePos = Isaac.WorldToScreen(Input.GetMousePosition(true))
    --print(MousePos)
    


    if CardState == CARD_STATES.RETURNING then

        local RenderPos = LastCardPos + (CardIdlePos - LastCardPos)/2
        LastCardPos = RenderPos

        Card.Rotation = 0

        Card:Render(RenderPos)

        if math.ceil(RenderPos.X) == math.ceil(CardIdlePos.X) and math.ceil(RenderPos.Y) == math.ceil(CardIdlePos.Y) then
            
            CardState = CARD_STATES.IDLE
            LastCardPos = CardIdlePos
        end

    elseif Input.IsMouseBtnPressed(MouseButton.LEFT) then

        if Options.MouseControl
           and CardState ~= CARD_STATES.PICKED_UP
           and MousePos.X >= CardIdlePos.X - 20 and MousePos.X <= CardIdlePos.X + 20
           and MousePos.Y >= CardIdlePos.Y - 30 and MousePos.Y <= CardIdlePos.Y + 30 then

            CardState = CARD_STATES.PICKED_UP
            SFXManager():Play(mod.Sounds.PLAY)
        end

    elseif CardState == CARD_STATES.PICKED_UP then

        CardState = CARD_STATES.RETURNING

        PICKED_TIME = 0

        --got an idea from a dude on telegram but sadly i don't think it's possible unlless luadebug is active
        --os.execute('"C:\\Program Files (x86)\\Steam\\steam.exe" -applaunch 220')

    end

    

    if CardState == CARD_STATES.PICKED_UP then
        Title:SetOverlayFrame("Card", 0)

        local RenderPos = LastCardPos + (MousePos - LastCardPos)/5

        Card.Rotation = (RenderPos.X - LastCardPos.X)*2

        if PICKED_TIME ~= 0 then --prevents some funky rendering as it is first picked up
            Card:Render(RenderPos)
        end

        PICKED_TIME = PICKED_TIME + 1

        LastCardPos = RenderPos

    elseif CardState == CARD_STATES.IDLE then
        Title:PlayOverlay("Card", false)

        LastCardPos = CardIdlePos

        local SpriteSuffix = ""

        if Options.MouseControl then

            local Difference = MousePos - CardIdlePos
            local Distance = MousePos:Distance(CardIdlePos)
            
            if Distance > 9 and Distance < 27 then
                SpriteSuffix = mod:HeadDirectionToString(Difference)
            end
        end

        Title:ReplaceSpritesheet(4, "gfx/ui/main menu/logo card"..SpriteSuffix..".png", true)


        local Frame = Title:GetFrame()
        Title:SetOverlayFrame("Card", Frame + 1)
    end

end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.Tast)