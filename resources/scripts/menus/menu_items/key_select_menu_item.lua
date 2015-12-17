--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function decorateText (text, initial_key)
	return text .. "           [" .. initial_key .. "]"
end

--------------------------------------------------
return function (text, onKeyEntryUpdated, initial_key)

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


	-- lowerCamelCase (also just called camel case)
	-- UpperCamelCase (also called pascal)
	-- MACRO_STYLE

	local instance = MenuItemBase ()

	local properties =
	{
		decorateText = decorateText,
		initial_key = initial_key,
		text_original = text,
		text_unfocused = "  " .. decorateText (text, initial_key) .. "  ",
		text_focused = "[ " .. decorateText (text, initial_key) .. " ]",
		text = "  " .. decorateText (text, initial_key) .. "  ",

		isSelected = false,

		onClicked = function (self) 
		 	if not self.isSelected then
		 		self.text = "?????"
		 		self.isSelected = true
			end
		end,

		onRender = function (self, font)
			font.drawString (self.x, self.y, self.text, 0xffff0000)
		end
	}

	Mixin.CopyTo (instance, properties)

	return instance
end
