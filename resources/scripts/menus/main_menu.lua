--------------------------------------------------
local menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function onStartNewLevelClicked ()

	dio.session.terminate () -- kills it immediately

	-- these are not used!
	local params =
	{
		should_save = true,
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
