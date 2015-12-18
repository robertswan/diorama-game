--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
	assert (self.worldSettings ~= nil)
end

--------------------------------------------------
function c:onUpdate ()

	local isNew = self.worldSettings.isNew
	local isOk = dio.session.requestBegin (self.worldSettings, self.roomSettings)

	self.worldSettings = nil
	self.roomSettings = nil

	if isOk then
		return "playing_game_menu"

	elseif isNew then
		return "create_new_level_menu"

	else
		return "load_level_menu"
	end
end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
	dio.session.terminate ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:recordWorldSettings (worldSettings, roomSettings)
	self.worldSettings = worldSettings
	self.roomSettings = roomSettings
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("LOADING LEVEL MENU")

	Mixin.CopyToAndBackupParents (instance, c)

	return instance
end
