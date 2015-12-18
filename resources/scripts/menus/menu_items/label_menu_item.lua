--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function (text)
	local instance = 
	{
		text = text,

		onRender = function (self, font)
			font.drawString (self.x + 20, self.y, self.text, 0xffffff)
		end
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
