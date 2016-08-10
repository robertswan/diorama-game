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
local defaultServerSettings =
{
    servers =
    {
        {
            ipAddress = "84.92.48.10",
            ipPort = 25276,
            name = "DIO Primary",
            password = "password",
        },
        {
            ipAddress = "84.92.48.10",
            ipPort = 25274,
            name = "DIO Secondary",
            password = "password",
        },
        {
            ipAddress = "localhost",
            ipPort = 25276,
            name = "localhost",
            password = "password",
        },
    },
    profiles =
    {
        {
            accountId = "NoName",
            avatarBottom = 18,
            avatarTop = 9,
        }
    },
}

--------------------------------------------------
local colors = 
{
    selected = 0x80ff80ff,
    deselected = 0x004000ff,
}

--------------------------------------------------
local function saveSettings (menu)
    dio.file.saveLua (dio.file.locations.SETTINGS, "multiplayer_settings.lua", menu.settings, "multiplayerSettings")
end

--------------------------------------------------
local function onServerClicked (menuItem, menu)

    for idx, button in ipairs (menu.serverButtons) do
        if button ~= menuItem then
            button.color = colors.deselected
            button.isSelected = nil
        end
    end

    menuItem.isSelected = not menuItem.isSelected
    menuItem.color = menuItem.isSelected and colors.selected or colors.deselected

    -- update the buttons here as appropriate
    menu.joinButton.isHighlightable = menuItem.isSelected
    -- menu.editButton.isHighlightable = menuItem.isSelected
    menu.deleteButton.isHighlightable = menuItem.isSelected

    menu.currentServerButton = menuItem.isSelected and menuItem or nil

end

--------------------------------------------------
local function onJoinServerClicked (menuItem, menu)

    -- if menu.currentServer.accountId.value == "" then
    --     menu.warningLabel.text = "ERROR! Player Name must not be empty"
    --     return

    -- elseif menu.currentServer.accountPassword.value == "" then
    --     menu.warningLabel.text = "ERROR! Player Password must not be empty"
    --     return

    -- end

    local server = menu.currentServerButton.server
    local profile = menu.settings.profiles [1]

    local params =
    {
        ipAddress =         server.ipAddress,
        ipPort =            server.ipPort,
        accountId =         profile.accountId,
        accountPassword =   server.password,
        avatarTop =         profile.avatarTop,
        avatarBottom =      profile.avatarBottom,
    }

    saveSettings (menu)

    local isOk, errorString = dio.session.beginMp (params)
    if isOk then
        return "playing_game_menu"
    end
end

--------------------------------------------------
local function onEditServerClicked (menuItem, menu)
    menu.menus.mp_edit_server_menu:setServerData (menu.currentServerButton.server)
    return "mp_edit_server_menu"
end

--------------------------------------------------
local function onEditPlayerProfileClicked (menuItem, menu)
    menu.menus.mp_edit_profile_menu:recordPlayerData (menu.settings.profiles [1])
    return "mp_edit_profile_menu"
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
function c:onEnter (menus)

    self.warningLabel.text = ""
    self.menus = menus

    for idx, button in ipairs (self.serverButtons) do
        button.color = colors.deselected
        button.isSelected = nil
    end

    self.joinButton.isHighlightable = false
    -- self.editButton.isHighlightable = false
    self.deleteButton.isHighlightable = false
    self.currentServerButton = nil
end

--------------------------------------------------
local function TextFromServer (server)
    return server.name .. "     " .. server.ipAddress .. " : " .. tostring (server.ipPort)
end

--------------------------------------------------
function c:recordUpdatedServer (server)

    local currentServer = self.currentServerButton.server
    currentServer.name = server.name
    currentServer.ipAddress = server.ipAddress
    currentServer.ipPort = server.ipPort
    currentServer.password = server.password
    
    self.currentServerButton.text = TextFromServer (currentServer)

    saveSettings (self)
end

--------------------------------------------------
function c:recordUpdatedPlayer (player)

    local currentProfile = self.settings.profiles [1]
    currentProfile.accountId =      player.accountId
    currentProfile.avatarBottom =   player.avatarBottom
    currentProfile.avatarTop =      player.avatarTop

    saveSettings (self)
end

--------------------------------------------------
return function ()

    math.randomseed (os.time())

    local instance = MenuClass ("Multiplayer")
    local settings = dio.file.loadLua (dio.file.locations.SETTINGS, "multiplayer_settings.lua")
    if not settings then
        settings = defaultServerSettings
    end

    local properties = 
    {  
        settings = settings,
        serverButtons = {},
        joinButton =        ButtonMenuItem ("Join Server", onJoinServerClicked),
        -- editButton =        ButtonMenuItem ("Edit Server", onEditServerClicked),
        deleteButton =      ButtonMenuItem ("Delete Server", onDeleteServerClicked),
        warningLabel =      LabelMenuItem (""),
    }

    -- local iconsFromNumbers = generateIconsFromNumbers ()
    -- local iconTexture = dio.drawing.loadTexture ("resources/textures/diorama_terrain_harter_00.png")

    properties.joinButton.isHighlightable = false
    -- properties.editButton.isHighlightable = false
    -- properties.deleteButton.isHighlightable = false

    for idx, server in ipairs (settings.servers) do
        local button = ButtonMenuItem (TextFromServer (server), onServerClicked)
        button.color = colors.deselected
        button.server = server
        table.insert (properties.serverButtons, button)
    end

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    for idx, button in ipairs (properties.serverButtons) do
        instance:addMenuItem (button)
    end

    -- instance:addMenuItem (LabelMenuItem ("Passwords are per server and stored in plain text."))
    -- instance:addMenuItem (LabelMenuItem ("DO NOT REUSE important passwords."))
    -- instance:addMenuItem (LabelMenuItem ("Passwords are tied to a username when a user is promoted"))
    -- instance:addMenuItem (LabelMenuItem ("to a builder (type '.group' into chat to check)"))
    -- instance:addMenuItem (BreakMenuItem ())
    -- instance:addMenuItem (properties.accountId)
    -- instance:addMenuItem (properties.avatarTop)
    -- instance:addMenuItem (BreakMenuItem ())
    -- instance:addMenuItem (properties.avatarBottom)
    -- instance:addMenuItem (ButtonMenuItem ("Join Server", onJoinServerClicked))
    -- instance:addMenuItem (BreakMenuItem ())
    -- instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onMainMenuClicked))

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (properties.joinButton)
    -- instance:addMenuItem (properties.editButton)
    -- instance:addMenuItem (ButtonMenuItem ("Add Server", onAddServerClicked))
    -- instance:addMenuItem (properties.deleteButton)

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Edit Player Profile", onEditPlayerProfileClicked))

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.warningLabel)

    properties.warningLabel.color = 0xff8000ff

    return instance
end
