--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function onStartNewLevelClicked ()

	dio.session.terminate () -- kills it immediately

	-- these are not used!
	local params =
	{
		should_save = true,
	}

	dio.session.requestBegin (params)

	dio.inputs.mouse.setExclusive (true)

	current_menu = menus.playing_game_menu
end

--------------------------------------------------
function createMainMenu ()

	local menu = Menus.createMenu ("MAIN MENU")

	Menus.addButton (menu, "Start New Level", onStartNewLevelClicked)
	Menus.addBreak (menu)
	--menus.addLabel (menu, dio.getVersionString ())
	Menus.addLabel (menu, "TEST")

	local onAppShouldClose = menu.onAppShouldClose 
	menu.onAppShouldClose = function ()
		dio.session.terminate ()
		onAppShouldClose (menu)
	end

	return menu
end

--------------------------------------------------
return createMainMenu ()
