--------------------------------------------------
local BreakMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local ScrollableMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/scrollable_menu_item")
local Menus = require ("gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local function onReturnToMainMenuClicked ()
    return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)

    local lines = {}
    io.input (self.filename)
    self.filename = nil

    for line in io.lines () do
        table.insert (lines, line)
    end
    self.scrollableMenuItem = ScrollableMenuItem (lines, 16)
    self:addMenuItem (self.scrollableMenuItem)

    self:addMenuItem (LabelMenuItem (""))
    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))

end

--------------------------------------------------
function c:onExit ()
    self.scrollableMenuItem = nil
    self:clearAllMenuItems ();
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
    local scrollWheel = dio.inputs.mouse.getScrollWheelDelta ()
    if scrollWheel ~= 0 then
        self.scrollableMenuItem:scroll (-scrollWheel)
    end

    return self.parent.onUpdate (self, x, y, was_left_clicked)
end

--------------------------------------------------
function c:recordFilename (filename)
    self.title = filename
    self.filename = filename
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("")

    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
