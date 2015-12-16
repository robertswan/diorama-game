--------------------------------------------------
local menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function onStartNewLevelClicked ()

	-- these are not used!
	local params =
	{
		player_mode = "single_player",
		folder_directory = "my_world",
	}

	dio.session.requestBegin (params)
end

--------------------------------------------------
function createMainMenu ()

	local menu = menus.createMenu ("MAIN MENU")

	menus.addButton (menu, "Start New Level", onStartNewLevelClicked)
	menus.addBreak (menu)
	--menus.addLabel (menu, dio.getVersionString ())
	menus.addLabel (menu, "TEST")

	return menu
end

--------------------------------------------------
return createMainMenu ()
