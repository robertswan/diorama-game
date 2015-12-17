--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onMouseReleasedCallback ()
	return "in_game_pause_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose (parent_func)
	dio.session.terminate ()
	parent_func (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:onEnter ()
	dio.inputs.mouse.setExclusive (true)
end

--------------------------------------------------
function c:onExit ()
	dio.inputs.mouse.setExclusive (false)	
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("PLAYING GAME MENU")

	local onAppShouldClose = instance.onAppShouldClose 

	Mixin.CopyTo (instance, c)

	local onAppShouldClose2 = instance.onAppShouldClose
	instance.onAppShouldClose = function (self) return onAppShouldClose2 (self, onAppShouldClose) end

	Menus.addEventListener (instance, "MOUSE_RELEASED", onMouseReleasedCallback)

	return instance
end