--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
-- key_entry starts deselected
-- can be highlighted, unhighlighted while deselected
-- if clicked (must be highlighted) then it becomes selected

-- when selected
	-- current text line has _ appended

	-- mouse input is ignored by the rest of the menu (or is it???? TBD)

		-- if another menu item is clicked, then its the same as ESCAPE being pressed
	
	-- CHOICES
	-- player presses ESCAPE ... (???)
		 -- original value is put back into the window
		 -- menu item becomes deselected

	-- press a valid key...
		-- onKeyEntryUpdated ()
		-- key value is put into the window

	-- press ENTER
		-- menu item becomes deselected

	-- what happens if its selected and the player clicks it again????
		-- (assuming nothing! it stays selected)

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

		if characterClicked ~= nil and self.value:len () < self.max_length then
			self.value = self.value .. string.char (characterClicked)
			if self.onTextChanged then
				self:onTextChanged (menu)
			end
		end

		-- elseif keyCodeClicked ~= nil then
		-- 	self.value = self.value .. dio.inputs.keys.keyCodeToString (keyCodeClicked)
		-- end

		-- 	--menu:unlockHighlightToMenuItem (self)
		-- 	self.isSelected = false
		
		-- elseif keyCodeClicked ~= nil then

		-- 	--menu:unlockHighlightToMenuItem (self)
		-- 	self.keyCode = keyCodeClicked
		-- 	self.isSelected = false
		-- end

	else
		self.isHighlighted = 
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

	local value = self.value
	local width = font.measureString (value)	
	if self.isSelected then
		width = width + font.measureString ("_")
		if self.flashCount < 8 then
			value = value .. "_"
		end
	end
	font.drawString (itemWidth + x - width, self.y, value, color)
end

--------------------------------------------------
return function (text, onTextChanged, onTextChangeConfirmed, initial_value, max_length)

	local instance = MenuItemBase ()

	local properties =
	{
		text = text,
		value = initial_value,
		max_length = max_length,
		flashCount = 0,
		isSelected = false,
		onTextChanged = onTextChanged,
		onTextChangeConfirmed = onTextChangeConfirmed
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	return instance
end
