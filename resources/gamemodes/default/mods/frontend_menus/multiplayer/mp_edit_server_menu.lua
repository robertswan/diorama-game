--------------------------------------------------
local BreakMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local IconNumberEntryMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/icon_number_menu_item")
local LabelMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("resources/gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")
local NumberEntryMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/number_menu_item")
local PasswordTextEntryMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/password_text_entry_menu_item")
local ScrollableMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/scrollable_menu_item")
local TextEntryMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/text_entry_menu_item")

local BlockDefinitions = require ("resources/gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local function onCancelClicked ()
    return "mp_select_server_menu"
end

--------------------------------------------------
local function onSaveClicked (menuItem, menu)

    local data =
    {
        name =          menu.serverName.value,
        ipAddress =     menu.serverIp.value,
        ipPort =        menu.serverPort:getValueAsNumber (),
        password =      menu.serverPassword.value,
    }

    menu.menus.mp_select_server_menu:recordUpdatedServer (menu.serverId, data)
    menu.serverId = nil
    return "mp_select_server_menu"
end

--------------------------------------------------
local function updateWarningLabel (menu)

    if menu.serverPassword.value == "" then
        menu.warningLabel.text = "PASSWORD IS EMPTY"
    elseif menu.serverPassword.value:len () <= 3 then
        menu.warningLabel.text = "PASSWORD MUST BE MORE THAN 3 CHARACTERS"
    else
        menu.warningLabel.text = ""
    end
end

--------------------------------------------------
local function onPasswordChanged (menuItem, menu)
    updateWarningLabel (menu)
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    self.menus = menus
    updateWarningLabel (self)
end

--------------------------------------------------
function c:recordServerData (serverId, server)

    self.serverId =                 serverId
    self.serverName.value =         server.name
    self.serverIp.value =           server.ipAddress
    self.serverPort.value =         tostring (server.ipPort)
    self.serverPassword.value =     server.password
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("Multiplayer Server Settings")
    local properties =
    {
        serverName =            TextEntryMenuItem ("Server Name", nil, nil, "", 30),
        serverIp =              TextEntryMenuItem ("Server Ip", nil, nil, "", 15),
        serverPort =            NumberEntryMenuItem ("Server Port", nil, nil, 10, true),
        serverPassword =        PasswordTextEntryMenuItem ("Password", onPasswordChanged, nil, "", 15),
        warningLabel =          LabelMenuItem (""),
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (LabelMenuItem ("You are responsible for choosing your own password."))
    instance:addMenuItem (LabelMenuItem ("A server requires a user generated password."))
    instance:addMenuItem (LabelMenuItem ("Passwords are stored in plain text."))
    instance:addMenuItem (LabelMenuItem ("DO NOT REUSE important passwords."))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.serverName)
    instance:addMenuItem (properties.serverIp)
    instance:addMenuItem (properties.serverPort)
    instance:addMenuItem (properties.serverPassword)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Cancel and Quit", onCancelClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Save and Quit", onSaveClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.warningLabel)

    properties.warningLabel.color = 0xff8000ff

    return instance
end
