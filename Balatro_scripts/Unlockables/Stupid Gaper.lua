---@diagnostic disable: cast-local-type, need-check-nil, param-type-mismatch
local mod = Balatro_Expansion
local Game = Game()
local ItemsConfig = Isaac.GetItemConfig()


--just in case you were wondering why i created this anomaly
--my friend once drew his own version of Isaac's head during class, this cannot be undone

local REPLACEMENT_CHANCE = 1/1000


---@param NPC EntityNPC
local function SubstituteGapers(_, NPC)

    if NPC.SubType == mod.Entities.STUPID_GAPER_SUBTYPE then

        if NPC.Variant == 2 then --flaming gaper, idk why the anm2 isn't loaded autoamtically but ok
            NPC:GetSprite():Load("gfx/stupid_ass_flaminggaper.anm2")
        end

        return
    end

    local Roll = math.random()

    if Roll <= REPLACEMENT_CHANCE then

        NPC:Morph(NPC.Type, NPC.Variant, mod.Entities.STUPID_GAPER_SUBTYPE, NPC:GetChampionColorIdx())
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, SubstituteGapers, EntityType.ENTITY_GAPER)


--i am not telling you why thus happens when they die
---@param NPC EntityNPC
local function StupidGapersKill(_, NPC)

    if NPC.SubType ~= mod.Entities.STUPID_GAPER_SUBTYPE then
        return
    end

    local Target = (NPC:GetPlayerTarget() or Game:GetPlayer(0)):ToPlayer()

    local Locust = Game:Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, NPC.Position,
                              Vector.Zero, Target, LocustSubtypes.LOCUST_OF_WRATH, mod:RandomSeed(NPC:GetDropRNG())):ToFamiliar()

---@diagnostic disable-next-line: assign-type-mismatch
    Locust.Player = Target
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, StupidGapersKill, EntityType.ENTITY_GAPER)

