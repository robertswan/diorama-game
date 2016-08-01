--------------------------------------------------
local modsToLoad =
{
    {
        folder = "diorama_server",
        modName = "room_teleport",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "motd",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "spawn",
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
        file = true,
        network = true,
        world = true,
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