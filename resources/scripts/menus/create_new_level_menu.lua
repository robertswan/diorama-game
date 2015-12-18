--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/scripts/menus/menu_items/label_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")
local TextEntryMenuItem = require ("resources/scripts/menus/menu_items/text_entry_menu_item")

--------------------------------------------------
local function onFilenameChanged (menuItem, menu)
	-- if menuItem.value == "" then
	-- 	menu.createLevel:disable ()
	-- else
	-- 	menu.createLevel:enable ()
	-- end
end

--------------------------------------------------
local function onCreateLevelClicked (menuItem, menu)
	if menu.filename.value == nil or 
			menu.filename.value == "" or 
			dio.file.isExistingWorldFolder (menu.filename) then

		menu.warningLabel.text = "ERROR! Filename is not valid!"

	else

		menu.warningLabel.text = ""
		menu.loadingLevelMenu:recordLevelToLoad (menu.filename.value, true)
		return "loading_level_menu"
	end
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
	self.warningLabel.text = ""
	self.loadingLevelMenu = menus.loading_level_menu
end

--------------------------------------------------
function c:onExit ()
	self.loadingLevelMenu = nil
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("CREATE NEW LEVEL MENU")

	local properties =
	{
		loadingLevelMenu = nil,
		filename = TextEntryMenuItem ("Filename", onFilenameChanged, nil, "MyWorld", 16),
		randomSeed = TextEntryMenuItem ("Random Seed", nil, nil, "seed0000", 16),
		createLevel = ButtonMenuItem ("Create Level", onCreateLevelClicked),
		warningLabel = LabelMenuItem (""),
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (properties.filename)
	instance:addMenuItem (properties.randomSeed)
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (properties.createLevel)
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))
	instance:addMenuItem (properties.warningLabel)

	return instance
end
