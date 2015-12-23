--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)

	if self.isSelected then

		local keyCodeClicked = dio.inputs.keys.consumeKeyCodeClicked ()

		if keyCodeClicked == dio.inputs.keyCodes.ESCAPE then

			menu:setUpdateOnlySelectedMenuItems (false)
			self.isSelected = false
		
		elseif keyCodeClicked ~= nil then

			menu:setUpdateOnlySelectedMenuItems (false)
			self.keyCode = keyCodeClicked
			self.isSelected = false

			if self.onKeyUpdated then
				self.onKeyUpdated (self, menu)
			end
		end

	else
		self.isHighlighted = 
				y >= self.y and 
				y < self.y + self.height

		if was_left_clicked and self.isHighlighted then
			if not self.isSelected then
				-- somehow stop the menu from doing other things!
				--menu:lockHighlightToMenuItem (self)

				menu:setUpdateOnlySelectedMenuItems (true)
				self.isSelected = true
			end
		end
	end
end

--------------------------------------------------
function c:onRender (font, menu)

	local itemWidth = menu.width - 200
	local x = 100

	local color = self.isHighlighted and 0xffffff or 0x00ffff
	color = self.isSelected and 0xff0000 or color

	font.drawString (x, self.y, self.text, color)

	if self.isHighlighted then
		local width = font.measureString (">>>>    ")
		font.drawString (x - width, self.y, ">>>>    ", color)
		font.drawString (x + itemWidth, self.y, "    <<<<", color)
	end

	local value = "????"
	if not self.isSelected then
	 	value = dio.inputs.keys.stringFromKeyCode (self.keyCode)
	end

	local width = font.measureString (value)	
	font.drawString (itemWidth + x - width, self.y, value, color)
end

--------------------------------------------------
return function (text, onKeyUpdated, keyCode)

	local instance = MenuItemBase ()

	local properties =
	{
		text = text,
		keyCode = keyCode,
		isSelected = false,
		onKeyUpdated = onKeyUpdated
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	return instance
end
