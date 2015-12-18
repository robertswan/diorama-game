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

	dio.inputs.bindings.setKeyBinding (menu.f.keyCode)
	-- dio.inputs.bindings.setLeft (menu.l.key_code)
	-- dio.inputs.bindings.setBackward (menu.b.key_code)
	-- dio.inputs.bindings.setRight (menu.r.key_code)
	-- dio.inputs.bindings.setJump (menu.j.key_code)
	-- dio.inputs.bindings.setTurbo (menu.t.key_code)

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
	self.checkbox.is_checked = dio.inputs.mouse.getIsInverted ()
	self.f.keyCode = dio.inputs.bindings.getKeyBinding ()
	-- self.l.keyCode = dio.inputs.bindings.getLeft ()
	-- self.b.keyCode = dio.inputs.bindings.getBackward ()
	-- self.r.keyCode = dio.inputs.bindings.getRight ()
	-- self.j.keyCode = dio.inputs.bindings.getJump ()
	-- self.t.keyCode = dio.inputs.bindings.getTurbo ()
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
		f = KeySelectMenuItem ("Forward", nil, dio.inputs.bindings.getKeyBinding ()),
		l = KeySelectMenuItem ("Left", nil, keyCodes.A),
		b = KeySelectMenuItem ("Back", nil, keyCodes.S),
		r = KeySelectMenuItem ("Right", nil, keyCodes.D),
		j = KeySelectMenuItem ("Jump", nil, keyCodes.SPACE),
		t = KeySelectMenuItem ("Turbo", nil, keyCodes.LEFT_SHIFT)
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
