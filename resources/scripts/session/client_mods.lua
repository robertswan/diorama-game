--------------------------------------------------
local Mods = require ("resources/scripts/session/mod_loader")

--------------------------------------------------
local mods = {}

--------------------------------------------------
local function main ()

    local permissions = 
    {
        blocks = true,
        client = true,
        file = true,
        player = true,
    }

    Mods.loadMod (mods, "attract_mode", permissions)
    Mods.loadMod (mods, "blocks", permissions)
    Mods.loadMod (mods, "inventory", permissions)
    Mods.loadMod (mods, "chat", permissions)
    Mods.loadMod (mods, "player_list", permissions)
    Mods.loadMod (mods, "spawn", permissions)
    -- Mods.loadMod (mods, "compass", permissions)
    -- Mods.loadMod (mods, "diagnostics", permissions)
end

--------------------------------------------------
main ()
