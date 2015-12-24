--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/scripts/menus/menu_items/label_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onCreateNewLevelClicked ()
	return "create_new_level_menu"
end

--------------------------------------------------
local function onLoadLevelClicked ()
	return "load_level_menu"
end

--------------------------------------------------
local function onDeleteLevelClicked ()
	return "delete_level_menu"
end

--------------------------------------------------
local function onEditPlayerControlsClicked ()
	return "player_controls_menu"
end

--------------------------------------------------
local function onReadmeClicked ()
	return "readme_menu"
end

--------------------------------------------------
local function onQuitClicked ()
	app_is_shutting_down = true
	return "quitting_menu"
end

--------------------------------------------------
local function onPlayTetrisClicked ()
	return "tetris_main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:onEnter ()
	-- if not self.isDemoSessionAlive then
	-- 	dio.session.requestBegin (({path = "my_world", shouldSave = false}))
	-- 	self.isDemoSessionAlive = true
	-- end
end

--------------------------------------------------
function c:onExit ()
	-- dio.session.terminate ()
end

--------------------------------------------------
function c:onRender ()

	return self.parent.onRender (self)
	-- dio.session.terminate ()
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("MAIN MENU")

	local properties = 
	{
		isDemoSessionAlive = false
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (ButtonMenuItem ("New Level", onCreateNewLevelClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Load Level", onLoadLevelClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Delete Level", onDeleteLevelClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Edit Player Controls", onEditPlayerControlsClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Read README.TXT", onReadmeClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Quit", onQuitClicked))
	instance:addMenuItem (LabelMenuItem (""))
	instance:addMenuItem (ButtonMenuItem ("PLAY TETRIS", onPlayTetrisClicked))
	instance:addMenuItem (LabelMenuItem (""))	

	local versionInfo = dio.system.getVersion ()

	instance:addMenuItem (LabelMenuItem (versionInfo.title))
	instance:addMenuItem (LabelMenuItem (versionInfo.buildDate))
	instance:addMenuItem (LabelMenuItem (""))
	instance:addMenuItem (LabelMenuItem ("See me develop live! twitch.tv/robtheswan"))
	instance:addMenuItem (LabelMenuItem ("See my website! robtheswan.com"))

	return instance
end
