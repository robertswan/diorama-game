local splash_menu = require ("resources/scripts/menus/splash_menu")
local main_menu = require ("resources/scripts/menus/main_menu")

-- --------------------------------------------------
 dio.menus.current_menu = main_menu

--------------------------------------------------
function Render ()
	
	dio.menus.current_menu:onRender ();

	-- local drawing = dio.graphics.drawing;
	-- drawing:FilledSquare (0, 0, 100, 100, 0x000000ff);
	-- drawing:Square (0, 0, 100, 100, 0xffffffff);

end

dio.onRender = Render
