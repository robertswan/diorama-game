--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onResumeClicked (self)
	return "playing_game_menu"
end

--------------------------------------------------
local function onReturnToMainMenuClicked (self)
	dio.session.terminate ()
	return "saving_game_menu"
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
return function ()
	local instance = MenuClass ("IN GAME PAUSE MENU")

	Mixin.CopyToAndBackupParents (instance, c)

	Menus.addBreak (instance)
	Menus.addButton (instance, "Resume", onResumeClicked)
	Menus.addBreak (instance)
	Menus.addButton (instance, "Return To Main Menu", onReturnToMainMenuClicked)
	Menus.addBreak (instance)

	return instance
end
