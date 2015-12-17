--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onCreateNewLevelClicked ()

	return "playing_game_menu"
end

--------------------------------------------------
local function onLoadLevel ()

	return "playing_game_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
	dio.session.terminate ()
	onAppShouldClose (self)
end

--------------------------------------------------
function c:onEnter ()
	dio.session.requestBegin ({false})
end

--------------------------------------------------
function c:onExit ()
	dio.session.terminate ()
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("MAIN MENU")

	Mixin.CopyTo (instance, c)

	Menus.addButton (instance, "Create New Level", onCreateNewLevelClicked)
	Menus.addButton (instance, "Load Level", onLoadLevel)
	Menus.addBreak (instance)
	Menus.addLabel (instance, "TEST")

	return instance
end
