--------------------------------------------------
local modsToLoad =
{
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
        modFolder = "game_logic",
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