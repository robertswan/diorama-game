-- global variables
current_menu = nil
menus = 
{
	splash_menu = 			require ("resources/scripts/menus/splash_menu"),
	main_menu = 			require ("resources/scripts/menus/main_menu"),
	playing_game_menu = 	require ("resources/scripts/menus/playing_game_menu")
}

--------------------------------------------------
current_menu = menus.main_menu

--------------------------------------------------
function OnUpdate ()

	if current_menu then
		local x = dio.inputs.mouse.x
		local y = dio.inputs.mouse.y
		local is_left_clicked = dio.inputs.mouse.left_button.is_clicked
	
		current_menu:onUpdate (x, y, is_left_clicked);
	end
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
