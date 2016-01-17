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
	self.menus:setIsVisible (false)
	dio.inputs.mouse.setExclusive (true)
	dio.inputs.setArePlayingControlsEnabled (true)
end

--------------------------------------------------
function c:onExit ()
	self.menus:setIsVisible (true)
	dio.inputs.mouse.setExclusive (false)
	dio.inputs.setArePlayingControlsEnabled (false)
end

--------------------------------------------------
return function (menus)

	local properties = 
	{
		menus = menus
	}

	local instance = MenuClass ("PLAYING GAME MENU")
	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	Menus.addEventListener (instance, "MOUSE_RELEASED", onMouseReleasedCallback)

	return instance
end
