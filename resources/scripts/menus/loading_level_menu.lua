--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
	dio.session.requestBegin ({true})
end

--------------------------------------------------
function c:onUpdate ()
	return "playing_game_menu"
end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
	dio.session.terminate ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu"
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("LOADING LEVEL MENU")

	Mixin.CopyToAndBackupParents (instance, c)

	return instance
end
