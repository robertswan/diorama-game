--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function onMouseReleasedCallback ()
 	dio.inputs.mouse.setExclusive (false)
-- 	dio.session.FreezePlayerInput ();
-- 	current_menu = menus.in_game_pause_menu
end

--------------------------------------------------
function createPlayingGameMenu ()
	local menu = Menus.createMenu ("PLAYING GAME MENU")

	Menus.addEventListener (menu, "MOUSE_RELEASED", onMouseReleasedCallback)

	return menu
end

--------------------------------------------------
return createPlayingGameMenu ()
