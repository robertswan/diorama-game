--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
return function ()
	local instance = MenuClass ("QUITTING MENU")
	Mixin.CopyTo (instance, c)
	return instance
end
