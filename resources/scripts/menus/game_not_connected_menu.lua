--------------------------------------------------
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onReturnToMainMenuClicked (self)
	return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onSessionShutdownCompleted ()
	self.returnButton.onClicked = onReturnToMainMenuClicked
end

--------------------------------------------------
function c:onEnter ()
	self.returnButton.onClicked = nil
end

--------------------------------------------------
return function ()

	local properties =
	{
		returnButton = ButtonMenuItem ("Return To Main Menu", nil)
	}

	local instance = MenuClass ("GAME NOT CONNECTED MENU")
	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (properties.returnButton)	

	return instance
end
