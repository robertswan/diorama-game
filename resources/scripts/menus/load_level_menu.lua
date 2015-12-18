--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local CheckboxMenuItem = require ("resources/scripts/menus/menu_items/checkbox_menu_item")
local KeySelectMenuItem = require ("resources/scripts/menus/menu_items/key_select_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onPlayLevelClicked (menu, levelName)
	menu.loadingLevelMenu:recordLevelToLoad (levelName, false)
end

--------------------------------------------------
local function onReturnToMainMenuClicked ()
	return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:onEnter (menus)

	self.loadingLevelMenu = menus.loading_level_menu

	local levels = dio.file.listExistingWorlds ()
	for idx, levelName in ipairs (levels) do

		local function onClicked ()
			onPlayLevelClicked (self, levelName)
			return "loading_level_menu"
		end

		local button = ButtonMenuItem ("Load " .. levelName, onClicked)
		self:addMenuItem (button)
	end

	self:addMenuItem (BreakMenuItem ())
	self:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))

end

--------------------------------------------------
function c:onExit ()
	self.loadingLevelMenu = nil
	self:clearAllMenuItems ();
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("LOAD LEVEL MENU")

	local properties =
	{
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	return instance
end
