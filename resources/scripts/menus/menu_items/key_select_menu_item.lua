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
	-- current text in the textbox is replaced with flashing question mark

	-- mouse input is ignored by the rest of the menu (or is it???? TBD)

		-- if another menu item is clicked, then its the same as ESCAPE being pressed
	
	-- CHOICES
	-- player presses ESCAPE ...
		 -- original value is put back into the window
		 -- menu item becomes deselected

	-- press a valid key...
		-- onKeyEntryUpdated ()
		-- key value is put into the window
		-- menu item becomes deselected

	-- what happens if its selected and the player clicks it again????
		-- (assuming nothing! it stays selected)

function c:onUpdate (menu, x, y, was_left_clicked)

	if self.isSelected then

		local keyCodeClicked = dio.inputs.keys.consumeKeyCodeClicked ()

		if keyCodeClicked == dio.inputs.keyCodes.ESCAPE then

			--menu:unlockHighlightToMenuItem (self)
			self.isSelected = false
		
		elseif keyCodeClicked ~= nil then

			--menu:unlockHighlightToMenuItem (self)
			self.keyCode = keyCodeClicked
			self.keyText = dio.inputs.keys.keyCodeToString (keyCodeClicked)
			self.isSelected = false
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

	if self.isSelected then
		font.drawString (self.x + 205, self.y, "????", 0xffff0000)
	else
		font.drawString (self.x + 205, self.y, self.keyText, 0xffff0000)
	end
end

--------------------------------------------------
return function (text, onKeyUpdated, keyCode)

	local instance = MenuItemBase ()

	local properties =
	{
		text = text,
		keyCode = keyCode,
		keyText = dio.inputs.keys.keyCodeToString (keyCode),
		isSelected = false,
		onKeyUpdated = onKeyUpdated
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	return instance
end
