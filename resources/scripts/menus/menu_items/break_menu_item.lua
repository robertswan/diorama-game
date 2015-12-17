--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function ()
	local instance = 
	{
		text = "******************************************",
		x = 0,
		y = 0,
		width = 200,
		height = 20
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
