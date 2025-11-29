do
    return --not worth it (and also doesn't look great)
end

local mod = Balatro_Expansion


---@param Player EntityPlayer
local function ChargeSprite(_, Player)

    local Weapon = Player:GetWeapon(1)

    if not Weapon then
        return
    end

    local weaponType = Weapon:GetWeaponType()
    local Modifiers = Weapon:GetModifiers()

    if Modifiers & (WeaponModifier.CHOCOLATE_MILK | WeaponModifier.MONSTROS_LUNG | WeaponModifier.NEPTUNUS) == 0
       or weaponType == WeaponType.WEAPON_BRIMSTONE
       or weaponType == WeaponType.WEAPON_MONSTROS_LUNGS then
        
        return
    end

    

    local HeadCostume
    local HeadSprite

    for _,Costume in ipairs(Player:GetCostumeSpriteDescs()) do

        HeadSprite = Costume:GetSprite()

        if HeadSprite:GetLayer("head")
           and HeadSprite:GetAnimationData("HeadDownCharge")
           and Player:IsItemCostumeVisible(Costume:GetItemConfig(), PlayerSpriteLayer.SPRITE_HEAD) then

            HeadCostume = Costume
            break
        end
    end

    if not HeadCostume then
        return
    end

    local LayerID = HeadSprite:GetLayer("head"):GetLayerID()

    local MaxCharge
    local FifthMaxCharge

    if Modifiers & WeaponModifier.CHOCOLATE_MILK ~= 0 then
        MaxCharge = Weapon:GetMaxFireDelay() * 2.65
        FifthMaxCharge = (MaxCharge / 5)*0.93 --0.93 to prevent errors

    elseif Modifiers & WeaponModifier.MONSTROS_LUNG ~= 0 then

        MaxCharge = Weapon:GetMaxFireDelay()
        FifthMaxCharge = MaxCharge/5
    
    elseif weaponType == WeaponType.WEAPON_BRIMSTONE then

        MaxCharge = Weapon:GetMaxFireDelay()
        FifthMaxCharge = MaxCharge/5
    end

    HeadSprite:SetAnimation("HeadDownCharge")
    HeadSprite:SetLayerFrame(LayerID, 3*((Weapon:GetCharge()) // FifthMaxCharge))

    print(Weapon:GetCharge(), MaxCharge, Weapon:GetMaxFireDelay())
    
end
mod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, ChargeSprite)


