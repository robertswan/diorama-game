--------------------------------------------------
-- global variables
-- TODO get these out of globals
app_is_shutting_down = false
app_is_ready_to_quit = false

--------------------------------------------------
local Menus = require ("resources/scripts/menus/menus")


local menus = nil

--------------------------------------------------
function OnUpdate ()
	return menus:update ();
end

--------------------------------------------------
function OnRender ()
	menus:render ();
end

--------------------------------------------------
local function main ()

	dio.onRender = OnRender
	dio.onUpdate = OnUpdate

	local individual_menus = 
	{
		main_menu = 			require ("resources/scripts/menus/main_menu") (),
		loading_level_menu = 	require ("resources/scripts/menus/loading_level_menu") (),
		playing_game_menu = 	require ("resources/scripts/menus/playing_game_menu") (),
		in_game_pause_menu =	require ("resources/scripts/menus/in_game_pause_menu") (),
		saving_game_menu =		require ("resources/scripts/menus/saving_game_menu") (),
		quitting_menu =			require ("resources/scripts/menus/quitting_menu") ()
	}

	menus = Menus (individual_menus, "main_menu")

end

main ()
