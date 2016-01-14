--------------------------------------------------
local m = {}

--------------------------------------------------
m.loadMod = function (modName, permissions)
	local mod, error = dio.mods.load (modName, permissions)
	if mod then
		mods [modName] = mod
	else
		print (error)
	end
end

--------------------------------------------------
return m
