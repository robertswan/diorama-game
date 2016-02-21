--------------------------------------------------
local Mods = require ("resources/scripts/session/mod_loader")

--------------------------------------------------
local mods = {}

--------------------------------------------------
local function main ()

	local regularPermissions = 
	{
		client = true,
		file = true,
		player = true,
	}

	-- Mods.loadMod (mods, "blocks", regularPermissions)
	Mods.loadMod (mods, "creative", regularPermissions)
end

--------------------------------------------------
main ()
