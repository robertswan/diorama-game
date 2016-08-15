--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "diorama_server",
        modFolder = "room_teleport",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "motd",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "spawn",
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
    end
end

--------------------------------------------------
main ()