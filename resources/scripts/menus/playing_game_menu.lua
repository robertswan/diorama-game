--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")

local mouse_is_exclusive = true

--------------------------------------------------
function onMouseReleasedCallback ()
 	dio.inputs.mouse.setExclusive (false)
 	mouse_is_exclusive = false
-- 	dio.session.FreezePlayerInput ();
-- 	current_menu = menus.in_game_pause_menu
end

--------------------------------------------------
function createPlayingGameMenu ()
	local menu = Menus.createMenu ("PLAYING GAME MENU")

	Menus.addEventListener (menu, "MOUSE_RELEASED", onMouseReleasedCallback)

	local onUpdate = menu.onUpdate

	menu.onUpdate = function (menu, x, y, was_left_clicked)

		if was_left_clicked and not mouse_is_exclusive then
			dio.inputs.mouse.setExclusive (true)
			mouse_is_exclusive = true
		end
		onUpdate (menu, x, y, was_left_clicked)
	end

	local onAppShouldClose = menu.onAppShouldClose 
	menu.onAppShouldClose = function ()
		onAppShouldClose (menu)
		return "quitting_menu"
	end

	menu.onEnter = function (menu)
		dio.session.requestBegin ({true})
		dio.inputs.mouse.setExclusive (true)
	end

	menu.onExit = function (menu)
		dio.session.terminate ()
		dio.inputs.mouse.setExclusive (false)	
	end

	return menu
end

--------------------------------------------------
return createPlayingGameMenu ()

