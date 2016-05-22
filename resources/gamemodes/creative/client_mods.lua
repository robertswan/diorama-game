--------------------------------------------------
local modsToLoad = 
{
    {
        folder = "diorama",
        modName = "attract_mode",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "inventory",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "chat",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "spawn",
        versionRequired = {major = 1, minor = 0},
    },
    {
        folder = "diorama",
        modName = "diagnostics",
        versionRequired = {major = 1, minor = 0},
    },
}

local mods = {}

--------------------------------------------------
local function main ()

    local permissions = 
    {
        blocks = true,
        client = true,
        diagnostics = true,
        file = true,
        player = true,
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
