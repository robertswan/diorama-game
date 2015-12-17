--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
return function (text, onClicked)
	local instance = 
	{
		text_unfocused = "  " .. text .. "  ",
		text_focused = "[ " .. text .. " ]",
		text = text,
		onClicked = onClicked
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
