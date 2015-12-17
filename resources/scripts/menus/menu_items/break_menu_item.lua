--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function ()
	local instance = 
	{
		text = "******************************************",

		onRender = function (self, font)
			font.drawString (self.x, self.y, self.text, 0xffff0000)
		end
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
