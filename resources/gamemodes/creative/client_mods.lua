--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "default",
        modFolder = "attract_mode",
    },
    {
        gameMode = "default",
        modFolder = "blocks",
    },
    {
        gameMode = "default",
        modFolder = "player_list",
    },
    {
        gameMode = "default",
        modFolder = "inventory",
    },
    {
        gameMode = "default",
        modFolder = "chat",
    },
    {
        gameMode = "default",
        modFolder = "spawn",
    },
    {
        gameMode = "default",
        modFolder = "diagnostics",
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
        inputs = true,
        world = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.load (modData, permissions)
    end
end

--------------------------------------------------
main ()