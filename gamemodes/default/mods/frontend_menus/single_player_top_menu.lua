--------------------------------------------------
local BreakMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local Menus = require ("gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local function onCreateNewLevelClicked ()
    return "create_new_world_menu"
end

--------------------------------------------------
local function onLoadLevelClicked ()
    return "load_world_menu"
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

    local instance = MenuClass ("Single Player")

    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (ButtonMenuItem ("New World", onCreateNewLevelClicked))
    instance:addMenuItem (ButtonMenuItem ("Load World", onLoadLevelClicked))
    instance:addMenuItem (ButtonMenuItem ("Delete World", onDeleteLevelClicked))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (ButtonMenuItem ("Back To Main Menu", onReturnToMainMenuClicked))

    return instance
end
