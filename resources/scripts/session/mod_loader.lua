--------------------------------------------------
local mods = {}

--------------------------------------------------
local function loadMod (modName, permissions)
	local mod, error = dio.mods.load ("default", permissions)
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
		all = {},
	}

	-- load
	loadMod ("default", permissions.all)

	-- -- activate
	-- for _, mod in pairs (mods) do
	-- 	mod:activate ()
	-- end
end



--------------------------------------------------
main ()
