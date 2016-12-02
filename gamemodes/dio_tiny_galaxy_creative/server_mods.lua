--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "dio_creative",
        modFolder = "world_logic",
    },
    {
        gameMode = "dio_tiny_galaxy",
        modFolder = "blocks",
    },
    {
        gameMode = "default",
        modFolder = "spawn",
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
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.loadMod (modData, regularPermissions)
    end
end

--------------------------------------------------
main ()