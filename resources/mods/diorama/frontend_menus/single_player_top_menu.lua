--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

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

--------------------------------------------------
return function ()

    local instance = MenuClass ("SINGLE PLAYER MENU")

    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (ButtonMenuItem ("New Level", onCreateNewLevelClicked))
    instance:addMenuItem (ButtonMenuItem ("Load Level", onLoadLevelClicked))
    instance:addMenuItem (ButtonMenuItem ("Delete Level", onDeleteLevelClicked))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))

    return instance
end
