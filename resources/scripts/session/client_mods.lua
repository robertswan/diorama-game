--------------------------------------------------
local Mods = require ("resources/scripts/session/mod_loader")

--------------------------------------------------
local mods = {}

--------------------------------------------------
local function main ()

	local permissions = 
	{
		client = true,
		file = true,
		player = true,
	}

	Mods.loadMod (mods, "chat", permissions)
	Mods.loadMod (mods, "inventory", permissions)
	-- Mods.loadMod (mods, "player_list", permissions)
	-- Mods.loadMod (mods, "diagnostics", permissions)
end

--------------------------------------------------
main ()
