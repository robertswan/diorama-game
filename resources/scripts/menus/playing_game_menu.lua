--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

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
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers)

	local keyCodes = dio.inputs.keyCodes
	
	if keyCode == keyCodes.ESCAPE then
		dio.inputs.mouse.setExclusive (false)
		self:onWindowFocusLost ()
		return true
	end
end

--------------------------------------------------
function c:onWindowFocusLost ()

	self.menus:setIsVisible (true)
	dio.inputs.setArePlayingControlsEnabled (false)
	self.menus.next_menu_name = "in_game_pause_menu"
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

	return instance
end
