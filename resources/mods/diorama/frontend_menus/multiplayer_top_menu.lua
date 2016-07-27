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
local function onMainMenuClicked ()
    return "main_menu"
end

--------------------------------------------------
local function generateIconsFromNumbers ()
    local map = {}

    for idx, block in ipairs (BlockDefinitions.blocks) do
        local uvs = block.uvs
        if not uvs then
            local tiles = BlockDefinitions.tiles [block.tiles [1]]
            uvs = tiles.uvs
        end
        map [idx] = {uvs [1], uvs [2]}
        -- map [idx] = {1, 1}
    end

    return map
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
    self.warningLabel.text = ""
end

--------------------------------------------------
return function ()

    math.randomseed (os.time())

    local instance = MenuClass ("Multiplayer")

    local scrollLines = {}

    local properties = nil

    local savedMultiplayerSettings = dio.file.loadLua (dio.file.locations.SETTINGS, "multiplayer_settings.lua")

    local iconsFromNumbers = generateIconsFromNumbers ()
    local iconTexture = dio.drawing.loadTexture ("resources/textures/diorama_terrain_harter_00.png")

    if savedMultiplayerSettings then

        properties =
        {
            accountId =         TextEntryMenuItem ("Username", nil, nil, savedMultiplayerSettings.accountId, 15),
            accountPassword =   PasswordTextEntryMenuItem ("Password", nil, nil, savedMultiplayerSettings.accountPassword, 15),
            ipAddress =         TextEntryMenuItem ("IP Address", nil, nil, savedMultiplayerSettings.ipAddress, 16),
            ipPort =            NumberEntryMenuItem ("Port", nil, nil, savedMultiplayerSettings.ipPort, true),

            -- avatarTop =         NumberEntryMenuItem ("Avatar Top Block", nil, nil, savedMultiplayerSettings.avatarTop, true),
            -- avatarBottom =      NumberEntryMenuItem ("Avatar Bottom Block", nil, nil, savedMultiplayerSettings.avatarBottom, true),

            avatarTop =         IconNumberEntryMenuItem ("Avatar Top Block", nil, nil, savedMultiplayerSettings.avatarTop, iconsFromNumbers, iconTexture),
            avatarBottom =      IconNumberEntryMenuItem ("Avatar Bottom Block", nil, nil, savedMultiplayerSettings.avatarBottom, iconsFromNumbers, iconTexture),

            warningLabel =      LabelMenuItem (""),
        }
    else

        properties =
        {
            accountId =         TextEntryMenuItem ("Username", nil, nil, "", 15),
            accountPassword =   PasswordTextEntryMenuItem ("Password", nil, nil, "", 15),
            ipAddress =         TextEntryMenuItem ("IP Address", nil, nil, "84.92.48.10", 16),
            ipPort =            NumberEntryMenuItem ("Port", nil, nil, 25276, true),
            -- avatarTop =         NumberEntryMenuItem ("Avatar Top Block", nil, nil, 10, true),
            -- avatarBottom =      NumberEntryMenuItem ("Avatar Bottom Block", nil, nil, 11, true),
            avatarTop =         NumberEntryMenuItem ("Avatar Top Block", nil, nil, 9, iconsFromNumbers, iconTexture),
            avatarBottom =      NumberEntryMenuItem ("Avatar Bottom Block", nil, nil, 8, iconsFromNumbers, iconTexture),
            warningLabel =      LabelMenuItem (""),
        }
    end

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (LabelMenuItem ("Passwords are per server and stored in plain text."))
    instance:addMenuItem (LabelMenuItem ("DO NOT REUSE important passwords."))
    instance:addMenuItem (LabelMenuItem ("Passwords are tied to a username when a user is promoted"))
    instance:addMenuItem (LabelMenuItem ("to a builder (type '.group' into chat to check)"))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.accountId)
    instance:addMenuItem (properties.accountPassword)
    instance:addMenuItem (properties.ipAddress)
    instance:addMenuItem (properties.ipPort)
    instance:addMenuItem (properties.avatarTop)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.avatarBottom)
    instance:addMenuItem (ButtonMenuItem ("Join Server", onConnectClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onMainMenuClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.warningLabel)

    properties.warningLabel.color = 0xff8000ff

    return instance
end
