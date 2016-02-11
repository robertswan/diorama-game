--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onResumeClicked (self)
	return "playing_game_menu"
end

--------------------------------------------------
local function onReturnToMainMenuClicked (self)
	print ("onReturnToMainMenuClicked")
	dio.session.terminate ()
end

--------------------------------------------------
local c = {}

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
function c:onAppShouldClose ()
	dio.session.terminate ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu", true
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
	return self.parent.onUpdate(self, x, y, was_left_clicked)
end

--------------------------------------------------
function c:onEnter (allMenus)
	self.allMenus = allMenus
end

--------------------------------------------------
function c:onExit (allMenus)
	self.allMenus = nil
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)

	local keyCodes = dio.inputs.keyCodes
	
	if keyCode == keyCodes.ESCAPE then
		menus:changeMenu ("playing_game_menu")
	end

	return true
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("IN GAME PAUSE MENU")

	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Resume", onResumeClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))	
	instance:addMenuItem (BreakMenuItem ())

	return instance
end
