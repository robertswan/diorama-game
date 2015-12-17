--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function decorateText (text, is_checked)
	if is_checked then
		return text .. "           [X]"
	else
		return text .. "           [   ]"
	end
end

--------------------------------------------------
return function (text, onClicked, is_checked)

	local instance = 
	{
		decorateText = decorateText,
		is_checked = is_checked,
		text_original = text,
		text_unfocused = "  " .. decorateText (text, is_checked) .. "  ",
		text_focused = "[ " .. decorateText (text, is_checked) .. " ]",
		text = "  " .. decorateText (text) .. "  ",
		onClicked = function (self) 
			self:setIsChecked (not self.is_checked)
			if onClicked then
				onClicked (self)
			end
		end,
		setIsChecked = function (self, is_checked)
			self.is_checked = is_checked
			self.text_unfocused = "  " .. self.decorateText (self.text_original, self.is_checked) .. "  "
			self.text_focused = "[ " .. self.decorateText (self.text_original, self.is_checked) .. " ]"
			self.text = "  " .. decorateText (text) .. "  "
		end
	}

	Mixin.CopyTo (instance, MenuItemBase ())

	return instance
end
