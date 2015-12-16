--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function createMenu ()

	local menu = Menus.createMenu ("QUITTING MENU")

	return menu
end

--------------------------------------------------
return createMenu ()
