--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function ()
	local instance = 
	{
		text = "------------------------",

		onRender = function (self, font)
			font.drawString (self.x + 20, self.y, self.text, 0x606060)
		end
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
