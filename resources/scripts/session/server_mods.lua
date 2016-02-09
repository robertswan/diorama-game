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

	-- Mods.loadMod (mods, "blocks", permissions)
	Mods.loadMod (mods, "default", permissions)
end

--------------------------------------------------
main ()
