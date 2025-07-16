local mod = Balatro_Expansion

local Game = Game()



local function SelectionCommand(_, Cmd, Params)

    --print(Cmd)
    --print(Params)
    if Cmd == "selection" then
        
        local Mode
        local Purpose
        for Param in string.gmatch(Params, "%a+") do
            
            if Mode then
                
                Purpose = Param
                if Purpose then
                    break
                end
            else

                Mode = Param
            end
        end

        if not Mode or not Purpose then
            print("A selection parameter is missing!")
            return
        end

        if not mod.SelectionParams.Modes[Mode]
           or not mod.SelectionParams.Purposes[Purpose] then

            print("A selection parameter is Wrong!")
            return
        end

        mod:SwitchCardSelectionStates(Game:GetPlayer(0), mod.SelectionParams.Modes[Mode], mod.SelectionParams.Purposes[Purpose])

    end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, SelectionCommand)


local function AddTagCommand(_, Cmd, Params)

    --print(Cmd)
    --print(Params)
    if Cmd == "skiptag" then
        
        local TagKey = Params

        local Tag = mod.SkipTags[TagKey]

        if Tag then
            mod:AddSkipTag(Tag)
        else
            print("Specified skip tag doesn't exist!")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, AddTagCommand)