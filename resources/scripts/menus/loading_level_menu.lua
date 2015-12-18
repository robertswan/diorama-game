--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
	assert (self.filename ~= nil)

	local worldSettings = 
	{
		path = self.filename,
		isNew = self.isNew,
		shouldSave = true
	}

	dio.session.requestBegin (worldSettings)

	self.filename = nil
	self.isNew = nil
end

--------------------------------------------------
function c:onUpdate ()
	return "playing_game_menu"
end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
	dio.session.terminate ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:recordLevelToLoad (filename, isNew)
	self.filename = filename
	self.isNew = isNew
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("LOADING LEVEL MENU")

	Mixin.CopyToAndBackupParents (instance, c)

	return instance
end
