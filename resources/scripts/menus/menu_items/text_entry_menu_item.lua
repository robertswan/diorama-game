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

		local keyCodeClicked = dio.inputs.keys.consumeKeyCodeClicked ()

		if keyCodeClicked == dio.inputs.keyCodes.ESCAPE then
			self.value = self.initial_value
			self.initial_value = nil
			self.isSelected = false

		elseif keyCodeClicked == dio.inputs.keyCodes.ENTER then
			self.initial_value = nil
			self.isSelected = false

		elseif keyCodeClicked == dio.inputs.keyCodes.BACKSPACE then

			local stringLen = self.value:len ()
			if stringLen > 0 then
				self.value = self.value:sub (1, -2)
			end

		end

		local characterClicked = dio.inputs.keys.consumeCharacterClicked ()

		if characterClicked ~= nil and self.value:len () < self.max_length then
			self.value = self.value .. string.char (characterClicked)
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
				x >= self.x and 
				x < self.x + self.width and
				y >= self.y and 
				y < self.y + self.height

		if was_left_clicked and self.isHighlighted then
			if not self.isSelected then
				-- somehow stop the menu from doing other things!
				--menu:lockHighlightToMenuItem (self)
				self.initial_value = self.value
				self.isSelected = true
			end
		end
	end
end

--------------------------------------------------
function c:onRender (font)
	if self.isHighlighted then
		font.drawString (self.x, self.y, ">", 0xffff0000)
	end
	font.drawString (self.x + 20, self.y, self.text, 0xffff0000)
	font.drawString (self.x + 200, self.y, "[", 0xffff0000)
	font.drawString (self.x + 281, self.y, "]", 0xffff0000)

	local value = self.value
	if self.isSelected then
		value = value .. "_"
	end
	font.drawString (self.x + 205, self.y, value, 0xffff0000)
end

--------------------------------------------------
return function (text, onTextUpdated, initial_value, max_length)

	local instance = MenuItemBase ()

	local properties =
	{
		text = text,
		value = initial_value,
		max_length = max_length,
		isSelected = false,
		onTextUpdated = onTextUpdated
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	return instance
end
