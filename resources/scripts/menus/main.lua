--------------------------------------------------
-- global variables
current_menu = nil
menus = 
{
	splash_menu = 			require ("resources/scripts/menus/splash_menu"),
	main_menu = 			require ("resources/scripts/menus/main_menu"),
	playing_game_menu = 	require ("resources/scripts/menus/playing_game_menu"),
	quitting_menu =			require ("resources/scripts/menus/quitting_menu")
}
app_is_shutting_down = false
app_is_ready_to_quit = false
current_menu = menus.main_menu

--------------------------------------------------
function OnUpdate ()

	if not app_is_shutting_down and dio.system.shouldAppClose () then
		current_menu:onAppShouldClose ()	
	end

	if app_is_shutting_down then
		app_is_ready_to_quit = dio.session.hasTerminated ()
		if app_is_ready_to_quit then
			return true
		end
	end

	if current_menu then
		local x = dio.inputs.mouse.x
		local y = dio.inputs.mouse.y
		local is_left_clicked = dio.inputs.mouse.left_button.is_clicked
	
		current_menu:onUpdate (x, y, is_left_clicked);
	end

	return false
end

--------------------------------------------------
function OnRender ()

	if current_menu then
		current_menu:onRender ();
	end
end

--------------------------------------------------
dio.onRender = OnRender
dio.onUpdate = OnUpdate

dio.session.requestBegin ({false})
