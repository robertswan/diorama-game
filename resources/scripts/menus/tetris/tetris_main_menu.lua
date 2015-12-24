--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/scripts/menus/menu_items/label_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")
local TetrisGame = require ("resources/scripts/menus/tetris/tetris_game")

--------------------------------------------------
local function onPlayTetrisClicked (menuItem, menu)
	menu.tetris = TetrisGame (menu)
	menu.tetris:startGame ()
end

--------------------------------------------------
local function onMainMenuClicked ()
	return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
end

--------------------------------------------------
function c:onExit ()
	self.tetris = nil
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)

	if self.tetris then 
		self.tetris:update ()
	else
		return self.parent.onUpdate (self, x, y, was_left_clicked)
	end
end


--------------------------------------------------
function c:onRender ()

	if self.tetris then 
		self.tetris:render ()
	else
		return self.parent.onRender (self)
	end
end

--------------------------------------------------
function c:recordTetrisGameOver ()
	self.tetris = nil
end

--------------------------------------------------
return function ()

	local instance = MenuClass ("TETRIS MENU")

	local properties = 
	{
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (ButtonMenuItem ("Play Tetris", onPlayTetrisClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onMainMenuClicked))
	instance:addMenuItem (BreakMenuItem ())

	return instance
end
