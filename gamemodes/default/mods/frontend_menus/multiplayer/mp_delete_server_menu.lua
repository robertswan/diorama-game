--------------------------------------------------
local BreakMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local Menus = require ("gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local populateMenus = nil

--------------------------------------------------
local function onConfirmDeleteClicked (menuItem, menu)
    menu.menus.mp_select_server_menu:recordDeleteServer (menu.serverId)
    menu.serverId = nil
    return "mp_select_server_menu"
end

--------------------------------------------------
local function onCancelDeleteClicked ()
    return "mp_select_server_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    self.menus = menus
    assert (self.serverLabel.text ~= "")
end

--------------------------------------------------
function c:onExit ()
    self.serverLabel.text = ""
end

--------------------------------------------------
function c:recordServerData (serverId, server)
    self.serverId = serverId
    self.serverLabel.text = server.name
    self.deleteConfirmedButton.text = "Confirm Delete " .. server.name
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("Confirm Server Deletion")

    local properties =
    {
        serverLabel = LabelMenuItem (""),
        deleteConfirmedButton = ButtonMenuItem ("", onConfirmDeleteClicked),
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (LabelMenuItem ("WARNING"))
    instance:addMenuItem (LabelMenuItem ("Are you sure you want to"))
    instance:addMenuItem (LabelMenuItem ("delete the following server:"))
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (properties.serverLabel)
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
