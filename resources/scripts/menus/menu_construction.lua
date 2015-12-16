--------------------------------------------------
local function onUpdate (menu, x, y, was_left_clicked)
	-- go through every item
	-- check if the mouse is over it
	-- if so, switch the text for a HIGHLIGHTED

	local highlighted_item = nil
	for i, item in ipairs (menu.items) do

		if item.onClicked then

			local is_over = 
					x >= item.x and 
					x < item.x + item.w and
					y >= item.y and 
					y < item.y + item.h

			item.text = is_over and item.text_focused or item.text_unfocused
			if is_over then
				highlighted_item = item
			end
		end
	end

	if was_left_clicked and highlighted_item then
		highlighted_item.onClicked ()
	end
end

--------------------------------------------------
local function onRender (menu)
	-- go through every item
	-- check if the mouse is over it
	-- if so, switch the text for a HIGHLIGHTED

	local font = dio.drawing.font;
	font.drawString (200, 0, menu.title, 0xffff0000)


	local highlighted_item = nil
	for i, item in ipairs (menu.items) do

		font.drawString (item.x, item.y, item.text, 0xffff0000)
	end
end

--------------------------------------------------
local menu_construction = {}

--------------------------------------------------
function menu_construction.createMenu (title)

	local menu = 
	{
		title = title,
		items = {},
		next_y = 100,
		onUpdate = onUpdate,
		onRender = onRender
	}

	return menu
end

--------------------------------------------------
function menu_construction.addLabel (menu, text)

	local label = 
	{
		text = text,
		x = 0,
		y = menu.next_y
	}

	menu.next_y = menu.next_y + 10
	table.insert (menu.items, label)
end

--------------------------------------------------
function menu_construction.addBreak (menu)

	menu.next_y = menu.next_y + 10
	local label = 
	{
		text = "-----------------------",
		x = 0,
		y = menu.next_y
	}

	menu.next_y = menu.next_y + 20
	table.insert (menu.items, label)
end

--------------------------------------------------
function menu_construction.addButton (menu, text, onClicked)

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
end

--------------------------------------------------
return menu_construction
