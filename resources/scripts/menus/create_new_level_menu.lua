--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")
local TextEntryMenuItem = require ("resources/scripts/menus/menu_items/text_entry_menu_item")

-- --------------------------------------------------
-- local function onSaveClicked (self, menu)
-- 	dio.inputs.mouse.setIsInverted (menu.checkbox.is_checked)

-- 	local setBinding = dio.inputs.bindings.setKeyBinding
-- 	local types = dio.inputs.bindingTypes

-- 	setBinding (types.FORWARD,	menu.f.keyCode)
-- 	setBinding (types.LEFT, 	menu.l.keyCode)
-- 	setBinding (types.BACKWARD,	menu.b.keyCode)
-- 	setBinding (types.RIGHT, 	menu.r.keyCode)
-- 	setBinding (types.JUMP, 	menu.j.keyCode)
-- 	setBinding (types.TURBO, 	menu.t.keyCode)

-- 	local playerSettings =
-- 	{
-- 		forward = 	menu.f.keyCode,
-- 		left = 		menu.l.keyCode,
-- 		backward = 	menu.b.keyCode,
-- 		right = 	menu.r.keyCode,
-- 		jump = 		menu.j.keyCode,
-- 		turbo = 	menu.t.keyCode
-- 	}

-- 	dio.file.saveLua ("player_settings.lua", playerSettings, "playerSettings")

-- 	return "main_menu"
-- end

--------------------------------------------------
local function onCreateLevelClicked ()
	return "loading_level_menu"
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

-- --------------------------------------------------
-- function c:onEnter ()
-- end

-- --------------------------------------------------
-- function c:onExit ()
-- 	dio.session.terminate ()
-- end

--------------------------------------------------
return function ()

	local instance = MenuClass ("CREATE NEW LEVEL MENU")

	local properties =
	{
		filename = TextEntryMenuItem ("Filename", nil, "MyWorld", 8),
		randomSeed = TextEntryMenuItem ("Random Seed", nil, "seed0000", 8)
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (properties.filename)
	instance:addMenuItem (properties.randomSeed)
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Create Level", onCreateLevelClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))

	return instance
end
