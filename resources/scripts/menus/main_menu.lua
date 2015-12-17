--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function onCreateNewLevelClicked ()

	return "playing_game_menu"
end

--------------------------------------------------
function onLoadLevel ()

	return "playing_game_menu"
end

--------------------------------------------------
function createMainMenu ()

	local menu = Menus.createMenu ("MAIN MENU")

	Menus.addButton (menu, "Create New Level", onCreateNewLevelClicked)
	Menus.addButton (menu, "Load Level", onLoadLevel)
	Menus.addBreak (menu)

	Menus.addLabel (menu, "TEST")

	local onAppShouldClose = menu.onAppShouldClose 
	menu.onAppShouldClose = function ()
		dio.session.terminate ()
		onAppShouldClose (menu)
	end

	menu.onEnter = function (menu)
		dio.session.requestBegin ({false})
	end

	menu.onExit = function (menu)
		dio.session.terminate ()
	end

	return menu
end

--------------------------------------------------
return createMainMenu ()
