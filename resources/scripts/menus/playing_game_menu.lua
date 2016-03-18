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
	return "quitting_menu", true
end

--------------------------------------------------
function c:onSessionShutdownBegun (reason)

	local reasons = dio.events.sessionShutdownBegun.reasons
	if reason == reasons.PLAYER_QUIT then
		return "saving_game_menu"

	else
		self.allMenus.game_not_connected_menu:setReason (reason)
		return "game_not_connected_menu"
	end
end

--------------------------------------------------
function c:onEnter (allMenus)
	self.menus:setIsVisible (false)
	dio.inputs.mouse.setExclusive (true)
	dio.inputs.setArePlayingControlsEnabled (true)
	self.allMenus = allMenus
end

--------------------------------------------------
function c:onExit (allMenus)
	self.menus:setIsVisible (true)
	dio.inputs.mouse.setExclusive (false)
	dio.inputs.setArePlayingControlsEnabled (false)
	self.allMenus = nil
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
	self.menus:changeMenu ("in_game_pause_menu")
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
