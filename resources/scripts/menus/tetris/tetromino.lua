
--------------------------------------------------
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function (rotationCount, blocks)
	local instance = 
	{
		rotationCount = rotationCount,
		blocks = blocks,
	}



	return instance
end