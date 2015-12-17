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
function c:onAppShouldClose ()
	dio.session.terminate ()
	self.parent.onAppShouldClose (self)
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

	local instance = MenuClass ("")

	Mixin.CopyToAndBackupParents (instance, c)

	Menus.addEventListener (instance, "MOUSE_RELEASED", onMouseReleasedCallback)

	return instance
end
