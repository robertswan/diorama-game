local splash_menu = require ("resources/scripts/menus/splash_menu")
local main_menu = require ("resources/scripts/menus/main_menu")

local current_menu = nil

-- --------------------------------------------------
 current_menu = main_menu

--------------------------------------------------
function OnUpdate ()

	local x = dio.inputs.mouse.x
	local y = dio.inputs.mouse.y
	local is_left_clicked = dio.inputs.mouse.left_button.is_clicked
	
	current_menu:onUpdate (x, y, is_left_clicked);
end

--------------------------------------------------
function OnRender ()

	current_menu:onRender ();
end

dio.onRender = OnRender
dio.onUpdate = OnUpdate


local params =
{
	save_folder_directory = nil,
}
dio.session.requestBegin (params)
