--------------------------------------------------
function createMenu (title)

	local menu = 
	{
		title = title,
		items = {},
		item_count = 0
	}

	return menu
end

--------------------------------------------------
function addLabel (menu, text)

	local label = 
	{
		text = text,
		x = 0,
		y = #menu.items * 10
	}

	table.insert (menu.items, label)
	menu.item_count = #menu.items
end

--------------------------------------------------
function createMainMenu ()

	local menu = createMenu ("MAIN MENU")

	addLabel (menu, "Hello World")
	addLabel (menu, "Hello World2")
-- --	addLabel (menu, dio.getVersionString ())

-- --	addButton (menu, "Start New Level", onStartNewLevelClicked)
-- --	addButton (menu, "Load Level", onLoadLevelClicked)
-- --	addButton (menu, "Options", onOptionsClicked)
-- --	addButton (menu, "Read readme.txt", onReadReadmeClicked)

-- --	dio.menus.setCurrentMenu (menu);

	main_menu = menu

end

createMainMenu ();
