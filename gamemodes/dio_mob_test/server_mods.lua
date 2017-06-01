--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "default",
        modFolder = "blocks",
    },
    {
        gameMode = "dio_mob_test",
        modFolder = "game_logic",
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
        local mod, error = dio.mods.loadMod (modData, regularPermissions)
    end
end

--------------------------------------------------
main ()