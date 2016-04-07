--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local function onReturnToParentClicked ()
    return "create_new_level_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
return function ()

    local instance = MenuClass ("Create Cubic Level")

    local properties =
    {
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (LabelMenuItem ("PLACEHOLDER!"))

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))
    
    return instance
end
