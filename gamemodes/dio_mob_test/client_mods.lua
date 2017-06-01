--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "dio_mob_test",
        modFolder = "game_logic",
    },
    {
        gameMode = "default",
        modFolder = "blocks",
    },
    {
        gameMode = "default",
        modFolder = "diagnostics",
    },
    {
        gameMode = "default",
        modFolder = "chat",
    }
}

local mods = {}

--------------------------------------------------
local function main ()

    local permissions =
    {
        blocks = true,
        drawing = true,
        diagnostics = true,
        entities = true,
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