--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/scripts/menus/menu_items/label_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local populateMenus = nil

--------------------------------------------------
local function onDeleteLevelClicked (menu, worldName)
    menu.deleteLevelConfirmMenu:recordWorldToDelete  (worldName)
    return "delete_level_confirm_menu"
end

--------------------------------------------------
local function onReturnToParentClicked ()
    return "single_player_top_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
    self.parent.onAppShouldClose (self)
    return "quitting_menu"
end

--------------------------------------------------
function c:onEnter (menus)
    
    self.deleteLevelConfirmMenu = menus.delete_level_confirm_menu

    local levels = dio.file.listExistingWorlds ()
    for idx, worldName in ipairs (levels) do

        local function onClicked ()
            return onDeleteLevelClicked (self, worldName)
        end

        local button = ButtonMenuItem ("Delete " .. worldName, onClicked)
        self:addMenuItem (button)
    end

    if #levels == 0 then
        self:addMenuItem (LabelMenuItem ("No Levels Found"))
    end

    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))

end

--------------------------------------------------
function c:onExit ()
    self.deleteLevelConfirmMenu = nil
    self:clearAllMenuItems ();
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("DELETE LEVEL MENU")

    local properties =
    {
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
