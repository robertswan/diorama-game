--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function (text)
	local instance = 
	{
		text = text,

		onRender = function (self, font, menus)
			local width = font.measureString (self.text)
			font.drawString ((menus.width - width) * 0.5, self.y, self.text, 0xffffff)
		end
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
