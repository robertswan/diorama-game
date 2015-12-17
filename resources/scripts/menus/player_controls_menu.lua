--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onSaveClicked (self, menu)
	dio.inputs.mouse.setIsInverted (menu.invert_mouse_checkbox.is_checked)
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
	self.invert_mouse_checkbox:setIsChecked (dio.inputs.mouse.getIsInverted ())
end

-- --------------------------------------------------
-- function c:onExit ()
-- 	dio.session.terminate ()
-- end

--------------------------------------------------
return function ()

	local instance = MenuClass ("PLAYER CONTROLS MENU")

	-- local onAppShouldClose = instance.onAppShouldClose 

	Mixin.CopyTo (instance, c)

	-- TODO add in way to easily access parent class functions that you've overridden
	-- Menus.AddParentFuncParameter (instance, c, onAppShouldClose)

	-- local onAppShouldClose2 = instance.onAppShouldClose
	-- instance.onAppShouldClose = function (self) return onAppShouldClose2 (self, onAppShouldClose) end

	local is_mouse_inverted = dio.inputs.mouse.getIsInverted ()

	Menus.addBreak (instance)
	local checkbox = Menus.addCheckbox (instance, "Invert Mouse", nil, is_mouse_inverted)
	local f = Menus.addKeyEntry (instance, "Forward", nil, "W")
	local l = Menus.addKeyEntry (instance, "Left", nil, "A")
	local b = Menus.addKeyEntry (instance, "Back", nil, "S")
	local r = Menus.addKeyEntry (instance, "Right", nil, "D")
	local j = Menus.addKeyEntry (instance, "Jump", nil, "SPACE")
	local t = Menus.addKeyEntry (instance, "Turbo", nil, "LEFT SHIFT")
	Menus.addBreak (instance)
	Menus.addButton (instance, "Save", onSaveClicked)
	Menus.addBreak (instance)
	Menus.addButton (instance, "Cancel", onCancelClicked)

	instance.invert_mouse_checkbox = checkbox

	return instance
end
