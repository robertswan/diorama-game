--------------------------------------------------
local modsToLoad =
{
    {
        folder = "diorama",
        modName = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "diagnostics",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "plummet",
        modName = "game_logic",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "plummet",
        modName = "scoreboard",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "chat",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "plummet",
        modName = "chat_shortcuts",
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
        input = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.load (modData, permissions)
        if mod then
            mods [modData.modName] = mod
        else
            print (error)
        end
    end
end

--------------------------------------------------
main ()