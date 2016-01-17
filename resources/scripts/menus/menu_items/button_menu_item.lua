--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)
	self.isHighlighted = 
			x >= 0 and
			x <= menu.width and
			y >= self.y and 
			y < self.y + self.height

	if was_left_clicked and self.isHighlighted and self.onClicked then
		return self:onClicked (menu)
	end
end

--------------------------------------------------
function c:onRender (font, menu)

	local text = self.text
	if self.isHighlighted then
		text = ">>>>    " .. text .. "    <<<<"
		dio.drawing.font.drawBox (0, self.y, menu.width, self.height, 0x000000ff)
	end

	local color = self.isHighlighted and 0xffffffff or 0x00ffffff
	local width = font.measureString (text)
	local x = (menu.width - width) * 0.5
	
	font.drawString (x, self.y, text, color)
end

--------------------------------------------------
return function (text, onClicked)

	assert (text ~= nil)

	local instance = MenuItemBase ()
	local properties = 
	{
		text = text,
		onClicked = onClicked
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	return instance
end
