--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/scripts/menus/menu_items/label_menu_item")
local NumberEntryMenuItem = require ("resources/scripts/menus/menu_items/number_menu_item")
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

		local worldSettings =
		{
			path = 			menu.filename.value,
			isNew = 		true,
			shouldSave = 	true,
		}

		local roomSettings =
		{
			path = 					"default/",
			randomSeed = 			menu.randomSeed.value,
			perlinSize = 			menu.perlinSize:getValueAsNumber (),
			perlinOctavesCount = 	menu.perlinOctavesCount:getValueAsNumber (),
			perlinFrequency = 		menu.perlinFrequency:getValueAsNumber (),
			perlinAmplitude = 		menu.perlinAmplitude:getValueAsNumber (),
			blah1 = 				menu.blah1:getValueAsNumber (),
			blah2 = 				menu.blah2:getValueAsNumber (),
			blah3 = 				menu.blah3:getValueAsNumber (),
			blah4 = 				menu.blah4:getValueAsNumber (),
		}

		menu.loadingLevelMenu:recordWorldSettings (worldSettings, roomSettings)

		menu.warningLabel.text = ""
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
	self.loadingLevelMenu = menus.loading_level_menu

	if self.doesWorldAlreadyExistError then
		self.warningLabel.text = "World already exists. Please Rename it"
		self.doesWorldAlreadyExistError = nil
	end
end

--------------------------------------------------
function c:onExit ()
	self.warningLabel.text = ""
	self.loadingLevelMenu = nil
end

--------------------------------------------------
function c:recordWorldAlreadyExistsError ()
	self.doesWorldAlreadyExistError = true
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("NEW LEVEL MENU")

	local properties =
	{
		loadingLevelMenu = nil,
		filename = 				TextEntryMenuItem ("Filename", onFilenameChanged, nil, "MyWorld", 16),
		randomSeed = 			TextEntryMenuItem ("Random Seed", nil, nil, "0", 16),
		perlinSize = 			NumberEntryMenuItem ("Perlin Initial Size", nil, nil, 128, true),
		perlinOctavesCount = 	NumberEntryMenuItem ("Octaves Count", nil, nil, 5, true),
		perlinFrequency = 		NumberEntryMenuItem ("Per Octave Frequency Mulitplier", nil, nil, 2, false),
		perlinAmplitude = 		NumberEntryMenuItem ("Per Octave Amplitude Multiplier", nil, nil, 0.5, false),
		blah1 = 				NumberEntryMenuItem ("Blah1", nil, nil, 0.003, false),
		blah2 = 				NumberEntryMenuItem ("Blah2", nil, nil, 0, false),
		blah3 = 				NumberEntryMenuItem ("Blah3", nil, nil, 1, false),
		blah4 = 				NumberEntryMenuItem ("Blah4", nil, nil, 0, false),
		createLevel = 			ButtonMenuItem ("Create Level", onCreateLevelClicked),
		warningLabel = 			LabelMenuItem (""),
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (BreakMenuItem ())

	instance:addMenuItem (properties.filename)

	instance:addMenuItem (BreakMenuItem ())

	instance:addMenuItem (properties.randomSeed)
	instance:addMenuItem (LabelMenuItem (""))
	instance:addMenuItem (properties.perlinSize)
	instance:addMenuItem (properties.perlinOctavesCount)
	instance:addMenuItem (properties.perlinFrequency)
	instance:addMenuItem (properties.perlinAmplitude)
	instance:addMenuItem (LabelMenuItem (""))
	instance:addMenuItem (properties.blah1)
	instance:addMenuItem (properties.blah2)
	instance:addMenuItem (properties.blah3)
	instance:addMenuItem (properties.blah4)

	instance:addMenuItem (BreakMenuItem ())
	
	instance:addMenuItem (properties.createLevel)
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))
	instance:addMenuItem (properties.warningLabel)

	return instance
end
