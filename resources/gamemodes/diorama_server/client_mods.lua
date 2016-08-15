--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "default",
        modFolder = "attract_mode",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "player_list",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "inventory",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "chat",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "spawn",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "diagnostics",
        versionRequired = {major = 1, minor = 0},
    },
}

local mods = {}

--------------------------------------------------
local function main ()

    local permissions =
    {
        blocks = true,
        drawing = true,
        diagnostics = true,
        file = true,
        world = true,
        inputs = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.load (modData, permissions)
    end
end

--------------------------------------------------
main ()