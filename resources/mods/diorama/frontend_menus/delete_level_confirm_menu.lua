--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local populateMenus = nil

--------------------------------------------------
local function onConfirmDeleteClicked (menuItem, menu)
    dio.file.deleteWorld (menu.filenameLabel.text)
    return "delete_level_menu"
end

--------------------------------------------------
local function onCancelDeleteClicked ()
    return "delete_level_menu"
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
    assert (self.filenameLabel.text ~= "")
end

--------------------------------------------------
function c:onExit ()
    self.filenameLabel.text = ""
end

--------------------------------------------------
function c:recordWorldToDelete (worldFilename)
    self.filenameLabel.text = worldFilename
    self.deleteConfirmedButton.text = "Confirm Delete " .. worldFilename
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("Confirm Level Deletion")

    local properties =
    {
        filenameLabel = LabelMenuItem (""),
        deleteConfirmedButton = ButtonMenuItem ("", onConfirmDeleteClicked),
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (LabelMenuItem ("WARNING"))
    instance:addMenuItem (LabelMenuItem ("Are you sure you want to"))
    instance:addMenuItem (LabelMenuItem ("delete the following world:"))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (properties.filenameLabel)
    instance:addMenuItem (LabelMenuItem (""))

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Cancel Delete", onCancelDeleteClicked))

    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.deleteConfirmedButton)

    return instance
end
