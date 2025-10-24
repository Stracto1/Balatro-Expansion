---@diagnostic disable: param-type-mismatch
local mod = Balatro_Expansion

local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()
local sfx = SFXManager()


--SOME VOUCHERS HAVE THEIR EFFECT IN mechanics.lua 
--(Wasteful/recyclomancy - clearance/liquidation - Overstock/plus - Hone/Glow Up - magic trick - money seed/tree - tarot/planet merchant/tycoon)

--OTHERS HAVE IT IN Custom_Cards.lua
--(Illusion - Crystal Ball/Omen Globe)



--prevents duplicate vouchers to be chosen/picked up in a run (2 players can have the same vouchers)
--also prevents upgraded vouchers from being taken without having their normal version
---@param Player EntityPlayer
local function VoucherPool(_,Type,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType
       and Player:GetPlayerType() ~= mod.Characters.TaintedJimbo
        or not ItemsConfig:GetCollectible(Type):HasCustomTag("balatro") then
        return
    end

    if Player:HasCollectible(Type, true) then --there shouldn't be duplicate vouchers

        if Type % 2 == mod.VoucherOff then --if it's a base voucher

            Type = Type + 1 --gives its upgraded version instead

            if Player:HasCollectible(Type) then --but again no duplicates
                Type = 0

            else--if it's new then remove it form the pool

                table.remove(mod.Saved.Pools.Vouchers, mod:GetValueIndex(mod.Saved.Pools.Vouchers, Type, true))

                if mod.Saved.Pools.Vouchers == {} then
                    table.insert(mod.Saved.Pools.Vouchers, mod.Vouchers.Blank) --the breakfasting of balatro
                end
            end

        else
            Type = CollectibleType.COLLECTIBLE_NULL
        end

    else --player doesn't have the pickued up voucher

        if Type % 2 == mod.VoucherOff then --and if it's a base voucher
            table.remove(mod.Saved.Pools.Vouchers, mod:GetValueIndex(mod.Saved.Pools.Vouchers, Type, true))
            table.insert(mod.Saved.Pools.Vouchers, Type + 1) --add it's upgraded counterpart to the pool

        else
            if not Player:HasCollectible(Type - 1) then
                
                if Type == mod.Vouchers.Retcon then --needs special checks

                    if mod:Contained(mod.Saved.Pools.Vouchers, mod.Vouchers.Director) then
                        Type = Type - 1 --gives the normal version instead
                    end
                else
                    Type = Type - 1 --gives the normal version instead
                end
                table.remove(mod.Saved.Pools.Vouchers, mod:GetValueIndex(mod.Saved.Pools.Vouchers, Type , true))

            end

        end
    end

    return Type
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, VoucherPool)

---@param Player EntityPlayer
local function VoucherPool2(_,Player, Type)
    if Player:GetPlayerType() ~= mod.Characters.JimboType
       and Player:GetPlayerType() ~= mod.Characters.TaintedJimbo
        or not ItemsConfig:GetCollectible(Type):HasCustomTag("balatro") then
        return
    end

    if Type % 2 == mod.VoucherOff then --if it's a base voucher

        if Player:HasCollectible(Type + 1) then --if he has its upgraded version
        
            --remove the upgreded one for the base one
            Player:AddCollectible(Type)
            Player:RemoveCollectible(Type + 1)

            --brings the upgraded one back into the pool
            table.insert(mod.Saved.Pools.Vouchers, Type + 1)

            return
        end
    end

    if Type ~= mod.Vouchers.Director
       and Type ~= mod.Vouchers.Retcon then
        
        table.insert(mod.Saved.Pools.Vouchers, Type)
    end

    
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, VoucherPool2)


--vouchers cannot get rerolled in any way
local function NoRerolls(_,Pickup,Type,Variant,SubType)
    if Pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        return
    end

    if ItemsConfig:GetCollectible(Pickup.SubType):HasCustomTag("balatro") then
        return {5,100,Pickup.SubType}
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, NoRerolls)



---@param Player EntityPlayer
local function VouchersAdded(_,Item,_,_,_,_,Player)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Item == mod.Vouchers.Hieroglyph or Item == mod.Vouchers.Petroglyph then
        Player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, UseFlag.USE_NOANIM|UseFlag.USE_MIMIC)
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,CallbackPriority.LATE, VouchersAdded)


local function VouchersRemoved(_,Player, Item)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Item == mod.Vouchers.Wasteful or Item == mod.Vouchers.Recyclomancy then
        mod.HpEnable = true
        Player:AddMaxHearts(-2)
        mod.HpEnable = false

    elseif Item == mod.Vouchers.Brush or Item == mod.Vouchers.Palette then

        mod:ChangeJimboHandSize(Player, -1)
    
    end


end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED,CallbackPriority.LATE, VouchersRemoved)


local function RerollVoucher(_,Partial)
    if Partial or not PlayerManager.AnyoneIsPlayerType(mod.Characters.JimboType) then
        return
    end

    local DidSomething = false --needs to actually reroll a shop item to work

    for i,Pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP,-1,-1, true)) do
        if Pickup:ToPickup():IsShopItem() then
            DidSomething = true
            break
        end
    end

    if not DidSomething then
        return
    end


    local GlutOwner = PlayerManager.FirstCollectibleOwner(mod.Vouchers.RerollGlut)

    if GlutOwner then
        GlutOwner:AddCoins(2)
        mod:CreateBalatroEffect(GlutOwner, mod.EffectColors.YELLOW,
                                mod.Sounds.MONEY, "+2 $", mod.EffectType.ENTITY, GlutOwner)
        return
    end
    
    local SurplusOwner = PlayerManager.FirstCollectibleOwner(mod.Vouchers.RerollSurplus)
    
    if SurplusOwner then
        Game:GetPlayer(0):AddCoins(1)
        mod:CreateBalatroEffect(SurplusOwner, mod.EffectColors.YELLOW,
                                mod.Sounds.MONEY, "+1 $", mod.EffectType.ENTITY, SurplusOwner)
        return
    end
    
end
mod:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, RerollVoucher)



local function PackSkipVouchers(_,Player,Pack)
    if Player:GetPlayerType() ~= mod.Characters.JimboType then
        return
    end

    if Pack == mod.SelectionParams.Purposes.CelestialPack then
        if Player:HasCollectible(mod.Vouchers.Telescope) then
            local CardRNG = Player:GetCardRNG(mod.Packs.CELESTIAL)

            local RadnomSeed = Random()
            if RadnomSeed == 0 then RadnomSeed = 1 end

            for i=1, 2 do

                local Rplanet = CardRNG:RandomInt(mod.Planets.PLUTO, mod.Planets.SUN)

                Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Player.Position,
                               RandomVector()*2, Player, Rplanet, RadnomSeed)
            end
        end
    end

    

end
mod:AddCallback("PACK_SKIPPED", PackSkipVouchers)



local PlanetariumToValue = {
    CollectibleType.COLLECTIBLE_PLUTO,
    CollectibleType.COLLECTIBLE_MERCURIUS,
    CollectibleType.COLLECTIBLE_URANUS,
    CollectibleType.COLLECTIBLE_VENUS,
    CollectibleType.COLLECTIBLE_SATURNUS,
    CollectibleType.COLLECTIBLE_JUPITER,
    CollectibleType.COLLECTIBLE_TERRA,
    CollectibleType.COLLECTIBLE_MARS,
    CollectibleType.COLLECTIBLE_NEPTUNUS,
    nil,nil,nil,
    CollectibleType.COLLECTIBLE_SOL}

---@param Player EntityPlayer
local function CardShotVouchers(_,Player,ShotCard,Evaluate)
    if not Evaluate then 
        return
    end

    if Player:HasCollectible(mod.Vouchers.Observatory) then

        if Player:HasCollectible(PlanetariumToValue[ShotCard.Value]) then
            mod:IncreaseJimboStats(Player, 0,0,1.15, true, true)
            mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.15", mod.EffectType.ENTITY, Player)
            return
        end

        for i=PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY do
            local card = Player:GetCard(i)

            if card - mod.Planets.PLUTO == ShotCard.Value - 1 then
                mod:IncreaseJimboStats(Player, 0,0,1.15, true, true)
                mod:CreateBalatroEffect(Player, mod.EffectColors.RED, mod.Sounds.TIMESMULT, "X1.15", mod.EffectType.ENTITY, Player)
                return
            end
        end

    end

end
mod:AddCallback("CARD_SHOT", CardShotVouchers)



---@param Rng RNG
---@param Player EntityPlayer
local function DirectorVoucher(_,Item,Rng, Player, Flags,_,_)

    if Player:GetPlayerType() == mod.Characters.TaintedJimbo then
        return
    end

    if Item == mod.Vouchers.Director then

        if mod:PlayerCanAfford(5) then

            Player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM|UseFlag.USE_MIMIC) --easiest way to reroll
            mod:SpendMoney(5)

            sfx:Play(mod.Sounds.MONEY)

            Player:AddWisp(Item, Player.Position)

            return true
        end

        return false

    elseif Item == mod.Vouchers.Retcon then
        if mod:PlayerCanAfford(5) then

            Player:UseActiveItem(CollectibleType.COLLECTIBLE_D100, UseFlag.USE_NOANIM|UseFlag.USE_MIMIC) --easiest way to reroll
            mod:SpendMoney(5)

            sfx:Play(mod.Sounds.MONEY)

            Player:AddWisp(Item, Player.Position)

            return true
        end

        return false

    end

end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, DirectorVoucher)



---@param Familiar EntityFamiliar
local function VoucherWispCollision(_, Familiar,  Collider)

    local PtrHash = GetPtrHash(Collider)

    local Data = Familiar:GetData()
    Data.REG_HitList = Data.REG_HitList or {}

    if Familiar.SubType ~= mod.Vouchers.Director
       and Familiar.SubType ~= mod.Vouchers.Retcon
       or mod:Contained(Data.REG_HitList, PtrHash) then
        return
    end

    ---@type EntityNPC?
    Collider = Collider:ToNPC()

    if not Collider
       or not Collider:IsActiveEnemy() then
        return    
    end

    Data.REG_HitList[#Data.REG_HitList+1] = PtrHash

    Game:DevolveEnemy(Collider)
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, VoucherWispCollision, FamiliarVariant.WISP)

