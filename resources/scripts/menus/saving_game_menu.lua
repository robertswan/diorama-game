--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c.onUpdate ()
	if dio.session.hasTerminated () then
		return "main_menu"
	end
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("SAVING GAME MENU")
	Mixin.CopyTo (instance, c)
	return instance
end
