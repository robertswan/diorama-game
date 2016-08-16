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
local function onServerClicked (menuItem, menu, serverIdx)

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
    menu.editButton.isHighlightable = menuItem.isSelected
    menu.deleteButton.isHighlightable = menuItem.isSelected

    menu.currentServerButton = menuItem.isSelected and menuItem or nil
    menu.currentServerIdx = serverIdx

    menu.warningLabel.text = ""
    menu.warningLabel2.text = ""

end

--------------------------------------------------
local function onJoinServerClicked (menuItem, menu)

    if menu.settings.profiles [1].accountId == "" then
        menu.warningLabel.text = "ERROR! Player Name must not be empty"
        menu.warningLabel2.text = "Choose EDIT PLAYER PROFILE first"
        return

    elseif menu.currentServerButton.server.password == "" then
        menu.warningLabel.text = "ERROR! Server Password must not be empty"
        menu.warningLabel2.text = "Choose EDIT SERVER first"
        return

    end

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
    menu.menus.mp_edit_server_menu:recordServerData (menu.currentServerButton.server, menu.currentServerButton.server)
    return "mp_edit_server_menu"
end

--------------------------------------------------
local function onAddServerClicked (menuItem, menu)
    local settings =
    {
        name = "NEW SERVER NAME",
        ipAddress = "0.0.0.0",
        ipPort = "25276",
        password = "",
    }

    menu.menus.mp_edit_server_menu:recordServerData (nil, settings)
    return "mp_edit_server_menu"
end

--------------------------------------------------
local function onDeleteServerClicked (menuItem, menu)
    menu.menus.mp_delete_server_menu:recordServerData (menu.currentServerButton.server, menu.currentServerButton.server)
    return "mp_delete_server_menu"
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
local function TextFromServer (server)
    return server.name .. "     " .. server.ipAddress .. " : " .. tostring (server.ipPort)
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)

    local settings = self.settings

    self.serverButtons = {}

    for idx, server in ipairs (settings.servers) do
        local button = ButtonMenuItem (TextFromServer (server), function (menuItem, menu) onServerClicked (menuItem, menu, idx) end)
        button.color = colors.deselected
        button.server = server
        table.insert (self.serverButtons, button)
    end

    for idx, button in ipairs (self.serverButtons) do

        if idx == self.currentServerIdx then
            self.currentServerButton = button
        end

        self:addMenuItem (button)
    end

    if not self.currentServerButton then
        if #settings.servers > 0 then
            self.currentServerIdx = 1
            self.currentServerButton = self.serverButtons [1]
        else
            self.currentServerIdx = 0        
        end
    end

    if self.currentServerButton then
        self.currentServerButton.color = colors.selected
        self.joinButton.isHighlightable = true
        self.editButton.isHighlightable = true
        self.deleteButton.isHighlightable = true
    else
        self.joinButton.isHighlightable = false
        self.editButton.isHighlightable = false
        self.deleteButton.isHighlightable = false
    end

    self:addMenuItem (BreakMenuItem ())

    self:addMenuItem (self.joinButton)
    self:addMenuItem (self.editButton)
    self:addMenuItem (ButtonMenuItem ("Add Server", onAddServerClicked))
    self:addMenuItem (self.deleteButton)

    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (ButtonMenuItem ("Edit Player Profile", onEditPlayerProfileClicked))
    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (ButtonMenuItem ("Return to Main Menu", onMainMenuClicked))
    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (self.warningLabel)
    self:addMenuItem (self.warningLabel2)

    self.warningLabel.text = ""
    self.warningLabel2.text = ""

    self.menus = menus
end

--------------------------------------------------
function c:onExit ()
    self.currentServerButton = nil
    self:clearAllMenuItems ();
end

--------------------------------------------------
function c:recordUpdatedServer (serverId, server)

    if not serverId then
        serverId = {}
        table.insert (self.settings.servers, serverId)
        self.currentServerIdx = #self.settings.servers
    end

    serverId.name = server.name
    serverId.ipAddress = server.ipAddress
    serverId.ipPort = server.ipPort
    serverId.password = server.password
    
    saveSettings (self)
end

--------------------------------------------------
function c:recordDeleteServer (serverId)

    for idx, server in ipairs (self.settings.servers) do
        if server == serverId then
            table.remove (self.settings.servers, idx)
            break
        end
    end

    self.currentServerIdx = 0

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
        settings = dio.file.loadLua (dio.file.locations.DEFAULTS, "default_multiplayer_settings.lua")
    end

    local properties = 
    {  
        settings = settings,
        joinButton =        ButtonMenuItem ("Join Server", onJoinServerClicked),
        editButton =        ButtonMenuItem ("Edit Server", onEditServerClicked),
        deleteButton =      ButtonMenuItem ("Delete Server", onDeleteServerClicked),
        warningLabel =      LabelMenuItem (""),
        warningLabel2 =     LabelMenuItem (""),        
        currentServerIdx =  1,
    }

    -- local iconsFromNumbers = generateIconsFromNumbers ()
    -- local iconTexture = dio.drawing.loadTexture ("resources/gamemodes/default/textures/chunks_diffuse_00.png")

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance.warningLabel.color = 0xff8000ff
    instance.warningLabel2.color = 0xff8000ff

    return instance
end
