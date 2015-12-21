--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)

	if self.isSelected then

		self.flashCount = self.flashCount < 16 and self.flashCount + 1 or 0

		local keyCodeClicked = dio.inputs.keys.consumeKeyCodeClicked ()

		if keyCodeClicked == dio.inputs.keyCodes.ESCAPE then
			self.value = self.initial_value
			self.initial_value = nil
			self.isSelected = false
			menu:setUpdateOnlySelectedMenuItems (false)
			if self.onTextChanged then
				self:onTextChanged (menu)
			end

		elseif keyCodeClicked == dio.inputs.keyCodes.ENTER then
			self.initial_value = nil
			self.isSelected = false
			menu:setUpdateOnlySelectedMenuItems (false)
			if self.onTextChangeConfirmed then
				self:onTextChangeConfirmed (menu)
			end

		elseif keyCodeClicked == dio.inputs.keyCodes.BACKSPACE then

			local stringLen = self.value:len ()
			if stringLen > 0 then
				self.value = self.value:sub (1, -2)
				if self.onTextChanged then
					self:onTextChanged (menu)
				end
			end
		end

		local characterClicked = dio.inputs.keys.consumeCharacterClicked ()

		if characterClicked ~= nil then

			local isDigit = (characterClicked >= string.byte ("0") and characterClicked <= string.byte ("9"))
			local isPeriod = (characterClicked == string.byte (".") and not self.isInteger)
			if isPeriod then
				isPeriod = not string.find (self.value, "%.")
			end

			if isDigit or isPeriod then
		
				self.value = self.value .. string.char (characterClicked)
				if self.onTextChanged then
					self:onTextChanged (menu)
				end
			end
		end

	else
		self.isHighlighted = 
				x >= self.x and 
				x < self.x + self.width and
				y >= self.y and 
				y < self.y + self.height

		if was_left_clicked and self.isHighlighted then
			if not self.isSelected then
				-- somehow stop the menu from doing other things!
				--menu:lockHighlightToMenuItem (self)
				self.flashCount = 0
				self.initial_value = self.value
				self.isSelected = true
				menu:setUpdateOnlySelectedMenuItems (true)
			end
		end
	end
end

--------------------------------------------------
function c:onRender (font)
	local color = self.isHighlighted and 0xffffff or 0x00ffff
	color = self.isSelected and 0xff0000 or color
	if self.isHighlighted then
		font.drawString (self.x, self.y, ">", color)
	end
	font.drawString (self.x + 20, self.y, self.text, color)
	font.drawString (self.x + 200, self.y, "[", color)
	font.drawString (self.x + 281, self.y, "]", color)

	local value = self.value
	if self.isSelected and self.flashCount < 8 then
		value = value .. "_"
	end
	font.drawString (self.x + 205, self.y, value, color)
end

--------------------------------------------------
function c:getValueAsNumber ()
	return tonumber (self.value)
end

--------------------------------------------------
return function (text, onTextChanged, onTextChangeConfirmed, initialValue, isInteger)

	local instance = MenuItemBase ()

	local properties =
	{
		text = text,
		value = tostring (initialValue),
		isInteger = isInteger,
		flashCount = 0,
		isSelected = false,
		onTextChanged = onTextChanged,
		onTextChangeConfirmed = onTextChangeConfirmed
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	return instance
end
