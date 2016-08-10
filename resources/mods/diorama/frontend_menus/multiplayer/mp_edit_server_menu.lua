--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local IconNumberEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/icon_number_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local NumberEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/number_menu_item")
local PasswordTextEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/password_text_entry_menu_item")
local ScrollableMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/scrollable_menu_item")
local TextEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/text_entry_menu_item")

local BlockDefinitions = require ("resources/mods/diorama/blocks/block_definitions")

--------------------------------------------------
local function onConnectClicked (menuItem, menu)

    if menu.accountId.value == "" then
        menu.warningLabel.text = "ERROR! Player Name must not be empty"
        return

    elseif menu.accountPassword.value == "" then
        menu.warningLabel.text = "ERROR! Player Password must not be empty"
        return

    end

    local params =
    {
        ipAddress =         menu.ipAddress.value,
        ipPort =            menu.ipPort:getValueAsNumber (),
        accountId =         menu.accountId.value,
        accountPassword =   menu.accountPassword.value,
        avatarTop =         menu.avatarTop.value,
        avatarBottom =      menu.avatarBottom.value,
    }

    dio.file.saveLua (dio.file.locations.SETTINGS, "multiplayer_settings.lua", params, "multiplayerSettings")

    local isOk, errorString = dio.session.beginMp (params)
    if isOk then
        return "playing_game_menu"
    end
end

--------------------------------------------------
local function onCancelClicked ()
    return "mp_select_server_menu"
end


--------------------------------------------------
local function onSaveClicked (menuItem, menu)
    local server = 
    {   
        name = menu.serverName.value,
        password = menu.accountPassword.value,
        ipAddress = menu.ipAddress.value,
        ipPort = menu.ipPort:getValueAsNumber (),
    }
    menu.menus.mp_select_server_menu:recordUpdatedServer (server)
    return "mp_select_server_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    self.menus = menus
    self.warningLabel.text = ""
end

--------------------------------------------------
function c:setServerData (serverData)
    self.serverName.value = serverData.name
    self.accountPassword.value = serverData.password
    self.ipAddress.value = serverData.ipAddress
    self.ipPort.value = tostring (serverData.ipPort)
end

--------------------------------------------------
return function ()

    math.randomseed (os.time())

    local instance = MenuClass ("Edit Multiplayer Server")

    local properties =
    {
        serverName =        TextEntryMenuItem ("Server Name", nil, nil, "NAMEYNAMENAME", 24),
        accountPassword =   PasswordTextEntryMenuItem ("Password", nil, nil, "DEFAULT", 15),
        ipAddress =         TextEntryMenuItem ("IP Address", nil, nil, "DEFAULT", 16),
        ipPort =            NumberEntryMenuItem ("Port", nil, nil, 99999, true),
        warningLabel =      LabelMenuItem (""),
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (LabelMenuItem ("Passwords are per server and stored in plain text."))
    instance:addMenuItem (LabelMenuItem ("DO NOT REUSE important passwords."))
    instance:addMenuItem (LabelMenuItem ("Passwords are tied to a username when a user is promoted"))
    instance:addMenuItem (LabelMenuItem ("to a builder (type '.group' into chat to check)"))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.serverName)
    instance:addMenuItem (properties.accountPassword)
    instance:addMenuItem (properties.ipAddress)
    instance:addMenuItem (properties.ipPort)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Cancel and Return to MP menu", onCancelClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Save and Return to MP menu", onSaveClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.warningLabel)

    properties.warningLabel.color = 0xff8000ff

    return instance
end
