--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/scripts/menus/menu_items/label_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")
local NumberEntryMenuItem = require ("resources/scripts/menus/menu_items/number_menu_item")
local ScrollableMenuItem = require ("resources/scripts/menus/menu_items/scrollable_menu_item")
local TextEntryMenuItem = require ("resources/scripts/menus/menu_items/text_entry_menu_item")

--------------------------------------------------
local function onConnectClicked (menuItem, menu)

	if menu.playerName.value == "" then
		menu.warningLabel.text = "ERROR! Player Name must not be empty"
		return
	end

	local params = 
	{
		ipAddress = menu.ipAddress.value,
		ipPort = menu.ipPort:getValueAsNumber (),
		playerName = menu.playerName.value,
	}

	local isOk = dio.session.beginMp (params)
	if isOk then
		return "playing_game_menu"
	end
end

--------------------------------------------------
local function onMainMenuClicked ()
	return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
	self.warningLabel.text = ""
end

--------------------------------------------------
return function ()

	math.randomseed (os.time())

	local instance = MenuClass ("MULTIPLAYER MENU")

	local scrollLines = {}

	local properties = 
	{
		playerName = 	TextEntryMenuItem ("Player Name", nil, nil, "", 16),
		ipAddress = 	TextEntryMenuItem ("IP Address", nil, nil, "84.92.48.10", 16),
		ipPort = 		NumberEntryMenuItem ("Port", nil, nil, 25276, true),
		warningLabel = 	LabelMenuItem (""),
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (properties.playerName)
	instance:addMenuItem (properties.ipAddress)
	instance:addMenuItem (properties.ipPort)
	instance:addMenuItem (ButtonMenuItem ("Connect To Server", onConnectClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onMainMenuClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (properties.warningLabel)

	properties.warningLabel.color = 0xff8000ff

	return instance
end
