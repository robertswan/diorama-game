--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local CheckboxMenuItem = require ("resources/scripts/menus/menu_items/checkbox_menu_item")
local KeySelectMenuItem = require ("resources/scripts/menus/menu_items/key_select_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onSaveClicked (self, menu)
	dio.inputs.mouse.setIsInverted (menu.checkbox.is_checked)

	local setBinding = dio.inputs.bindings.setKeyBinding
	local types = dio.inputs.bindingTypes

	setBinding (types.FORWARD,	menu.f.keyCode)
	setBinding (types.LEFT, 	menu.l.keyCode)
	setBinding (types.BACKWARD,	menu.b.keyCode)
	setBinding (types.RIGHT, 	menu.r.keyCode)
	setBinding (types.JUMP, 	menu.j.keyCode)
	setBinding (types.TURBO, 	menu.t.keyCode)

	local playerSettings =
	{
		forward = 	menu.f.keyCode,
		left = 		menu.l.keyCode,
		backward = 	menu.b.keyCode,
		right = 	menu.r.keyCode,
		jump = 		menu.j.keyCode,
		turbo = 	menu.t.keyCode
	}

	dio.file.saveLua ("player_settings.lua", playerSettings, "playerSettings")

	return "main_menu"
end

--------------------------------------------------
local function onCancelClicked ()
	return "main_menu"
end

--------------------------------------------------
local c = {}

-- --------------------------------------------------
-- function c:onAppShouldClose (parent_func)
-- 	parent_func (self)
-- 	return "quitting_menu"
-- end

--------------------------------------------------
function c:onEnter ()

	local getBinding = dio.inputs.bindings.getKeyBinding
	local types = dio.inputs.bindingTypes

	self.checkbox.is_checked = dio.inputs.mouse.getIsInverted ()
	self.f.keyCode = getBinding (types.FORWARD)
	self.l.keyCode = getBinding (types.LEFT)
	self.b.keyCode = getBinding (types.BACKWARD)
	self.r.keyCode = getBinding (types.RIGHT)
	self.j.keyCode = getBinding (types.JUMP)
	self.t.keyCode = getBinding (types.TURBO)
end

-- --------------------------------------------------
-- function c:onExit ()
-- 	dio.session.terminate ()
-- end

--------------------------------------------------
return function ()

	local is_mouse_inverted = dio.inputs.mouse.getIsInverted ()
	local keyCodes = dio.inputs.keyCodes

	local properties =
	{
		checkbox = CheckboxMenuItem ("Invert Mouse", nil, is_mouse_inverted),
		f = KeySelectMenuItem ("Forward", nil, 0),
		l = KeySelectMenuItem ("Left", nil, 0),
		b = KeySelectMenuItem ("Back", nil, 0),
		r = KeySelectMenuItem ("Right", nil, 0),
		j = KeySelectMenuItem ("Jump", nil, 0),
		t = KeySelectMenuItem ("Turbo", nil, 0)
	}


	local instance = MenuClass ("PLAYER CONTROLS MENU")

	Mixin.CopyTo (instance, properties)
	Mixin.CopyTo (instance, c)

	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (properties.checkbox)
	instance:addMenuItem (properties.f)
	instance:addMenuItem (properties.l)
	instance:addMenuItem (properties.b)
	instance:addMenuItem (properties.r)
	instance:addMenuItem (properties.j)
	instance:addMenuItem (properties.t)
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Save", onSaveClicked))	
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Cancel", onCancelClicked))	

	return instance
end
