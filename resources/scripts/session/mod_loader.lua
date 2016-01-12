--------------------------------------------------
local mods = {}

--------------------------------------------------
local function loadMod (modName, permissions)
	local mod, error = dio.mods.load (modName, permissions)
	if mod then
		mods [modName] = mod
	else
		print (error)
	end
end

--------------------------------------------------
local function main ()

	local permissions = 
	{
		all = false,
		client = true,
		file = true,
		player = true,
	}

	-- load
	-- loadMod ("default", permissions.all)
	-- loadMod ("diagnostics", permissions)

	-- -- activate
	-- for _, mod in pairs (mods) do
	-- 	mod:activate ()
	-- end
end



--------------------------------------------------
main ()
