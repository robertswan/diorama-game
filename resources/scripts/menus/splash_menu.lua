--------------------------------------------------
local menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function createSplashMenu ()

	local menu = menus.createMenu ("MAIN MENU")

	menus.addBreak (menu)
	menus.addLabel (menu, "SPLASH SCREEN")
	menus.addBreak (menu)

	return menu
end

--------------------------------------------------

return createSplashMenu ()
