--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "plummet",
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
        gameMode = "plummet",
        modFolder = "scoreboard",
    },
    {
        gameMode = "default",
        modFolder = "chat",
    },
    {
        gameMode = "plummet",
        modFolder = "chat_shortcuts",
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