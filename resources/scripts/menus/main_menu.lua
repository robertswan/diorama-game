--------------------------------------------------
function onUpdate (menu, x, y, was_left_clicked)
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
function createMenu (title)

	local menu = 
	{
		title = title,
		items = {},
		next_y = 0
	}

	menu.onUpdate = function (x, y, was_left_clicked)
		onUpdate (menu, x, y, was_left_clicked)
	end

	return menu
end

--------------------------------------------------
function addLabel (menu, text)

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
function addBreak (menu)

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
function addButton (menu, text, onClicked)

	local button = 
	{
		text_unfocused = text,
		text_focused = "[ " .. text .. " ]",
		text = text,
		x = 0,
		y = menu.next_y,
		w = 200,
		h = 10,
		onClicked = onClicked
	}

	menu.next_y = menu.next_y + 10
	table.insert (menu.items, button)
end

--------------------------------------------------
function onStartNewLevelClicked ()
	addLabel (dio.menus.current_menu, "was clicked!")
end

--------------------------------------------------
function createMainMenu ()

	local menu = createMenu ("MAIN MENU")

	addButton (menu, "Start New Level", onStartNewLevelClicked)

	addBreak (menu)

	addLabel (menu, dio.getVersionString ())
	addLabel (menu, "TEST")

-- --	addButton (menu, "Load Level", onLoadLevelClicked)
-- --	addButton (menu, "Options", onOptionsClicked)
-- --	addButton (menu, "Read readme.txt", onReadReadmeClicked)

	addBreak (menu)

	dio.menus.current_menu = menu

end

createMainMenu ();
