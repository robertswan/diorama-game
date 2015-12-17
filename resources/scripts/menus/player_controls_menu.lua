--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onInvertMouseClicked ()
end

--------------------------------------------------
local function onSaveClicked ()
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

-- --------------------------------------------------
-- function c:onEnter ()
-- 	dio.session.requestBegin ({false})
-- end

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

	Menus.addBreak (instance)
	Menus.addCheckbox (instance, "Invert Mouse", onInvertMouseClicked, true)
	Menus.addBreak (instance)
	Menus.addButton (instance, "Save", onSaveClicked)
	Menus.addBreak (instance)
	Menus.addButton (instance, "Cancel", onCancelClicked)

	return instance
end
