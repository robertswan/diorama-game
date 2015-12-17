--------------------------------------------------
local m = {}

--------------------------------------------------
function m.addLabel (menu, text)

	local label = 
	{
		text = text,
		x = 0,
		y = menu.next_y
	}

	menu.next_y = menu.next_y + 10
	table.insert (menu.items, label)

	return label
end

--------------------------------------------------
function m.addBreak (menu)

	menu.next_y = menu.next_y + 10
	local label = 
	{
		text = "******************************************",
		x = 0,
		y = menu.next_y
	}

	menu.next_y = menu.next_y + 20
	table.insert (menu.items, label)

	return label
end

--------------------------------------------------
function m.addButton (menu, text, onClicked)

	local button = 
	{
		text_unfocused = "  " .. text .. "  ",
		text_focused = "[ " .. text .. " ]",
		text = text,
		x = 100,
		y = menu.next_y,
		w = 200,
		h = 10,
		onClicked = onClicked
	}

	menu.next_y = menu.next_y + 10
	table.insert (menu.items, button)

	return button
end

--------------------------------------------------
function m.addCheckbox (menu, text, onClicked, is_checked)

	local function decorateText (text, is_checked)
		if is_checked then
			return text .. "           [X]"
		else
			return text .. "           [ ]"
		end
	end

	local checkbox = 
	{
		decorateText = decorateText,
		is_checked = is_checked,
		text_original = text,
		text_unfocused = "  " .. decorateText (text, is_checked) .. "  ",
		text_focused = "[ " .. decorateText (text, is_checked) .. " ]",
		text = "  " .. decorateText (text) .. "  ",
		x = 100,
		y = menu.next_y,
		w = 200,
		h = 10,
		onClicked = function (self) 
			self:setIsChecked (not self.is_checked)
			onClicked (self)
		end,
		setIsChecked = function (self, is_checked)
			self.is_checked = is_checked
			self.text_unfocused = "  " .. self.decorateText (self.text_original, self.is_checked) .. "  "
			self.text_focused = "[ " .. self.decorateText (self.text_original, self.is_checked) .. " ]"
			self.text = "  " .. decorateText (text) .. "  "
		end
	}

	menu.next_y = menu.next_y + 10
	table.insert (menu.items, checkbox)

	return checkbox
end

--------------------------------------------------
function m.addEventListener (menu, event, onFired)
	menu.events [event] = onFired
end

--------------------------------------------------
return m
