--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)
	self.isHighlighted = 
			x >= self.x and 
			x < self.x + self.width and
			y >= self.y and 
			y < self.y + self.height

	if was_left_clicked and self.isHighlighted and self.onClicked then
		return self:onClicked (menu)
	end		
end

--------------------------------------------------
function c:onRender (font)
	local color = self.isHighlighted and 0xffffff or 0x00ffff
	if self.isHighlighted then
		font.drawString (self.x, self.y, ">", color)
	end
	font.drawString (self.x + 20, self.y, self.text, color)
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
