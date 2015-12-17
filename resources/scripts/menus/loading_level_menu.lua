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
	parent_func (self)
	return "quitting_menu"
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("LOADING LEVEL MENU")

	local onAppShouldClose = instance.onAppShouldClose 

	Mixin.CopyTo (instance, c)

	local onAppShouldClose2 = instance.onAppShouldClose
	instance.onAppShouldClose = function (self) return onAppShouldClose2 (self, onAppShouldClose) end

	return instance
end
