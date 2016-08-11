--------------------------------------------------
local modsToLoad =
{
    {
        folder = "diorama",
        modName = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "plummet",
        modName = "game_logic",
        versionRequired = {major = 1, minor = 0},
    },
}

--------------------------------------------------
local mods = {}

--------------------------------------------------
local function main ()

    local regularPermissions =
    {
        blocks = true,
        drawing = true,
        entities = true,
        file = true,
        network = true,
        world = true,
        session = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.load (modData, regularPermissions)
        if mod then
            mods [modData.modName] = mod
        else
            print (error)
        end
    end
end

--------------------------------------------------
main ()