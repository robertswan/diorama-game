--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "creative",
        modFolder = "world_logic",
    },  
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
        resources = true,
        world = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.loadMod (modData, permissions)
    end
end

--------------------------------------------------
main ()