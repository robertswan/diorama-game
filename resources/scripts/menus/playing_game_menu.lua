--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

local mouse_is_exclusive = true

--------------------------------------------------
local function onMouseReleasedCallback ()
 	dio.inputs.mouse.setExclusive (false)
 	mouse_is_exclusive = false
-- 	dio.session.FreezePlayerInput ();
-- 	current_menu = menus.in_game_pause_menu
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (parent_func, x, y, was_left_clicked)

	if was_left_clicked and not mouse_is_exclusive then
		dio.inputs.mouse.setExclusive (true)
		mouse_is_exclusive = true
	end
	parent_func (self, x, y, was_left_clicked)
end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
	Menus.addBreak (self)
	parent_func (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:onEnter ()
	dio.session.requestBegin ({true})
	dio.inputs.mouse.setExclusive (true)
end

--------------------------------------------------
function c:onExit ()
	dio.session.terminate ()
	dio.inputs.mouse.setExclusive (false)	
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("PLAYING GAME MENU")

	local onUpdate = instance.onUpdate 
	local onAppShouldClose = instance.onAppShouldClose 

	Mixin.CopyTo (instance, c)

	local onUpdate2 = instance.onUpdate
	instance.onUpdate = function (self, x, y, was_left_clicked) onUpdate2 (self, onUpdate, x, y, was_left_clicked) end

	local onAppShouldClose2 = instance.onAppShouldClose
	instance.onAppShouldClose = function (self) return onAppShouldClose2 (self, onAppShouldClose) end

	Menus.addEventListener (instance, "MOUSE_RELEASED", onMouseReleasedCallback)

	return instance
end
