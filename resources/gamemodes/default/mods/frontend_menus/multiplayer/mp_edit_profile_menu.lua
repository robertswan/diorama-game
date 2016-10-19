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
        accountId =         menu.accountId.value,
        avatarBottom =      menu.avatarBottom:getValueAsNumber (),
        avatarTop =         menu.avatarTop:getValueAsNumber (),
    }

    menu.menus.mp_select_server_menu:recordUpdatedPlayer (data)
    return "mp_select_server_menu"
end

--------------------------------------------------
local function generateIconsFromNumbers ()
    local map = {}

    for idx, block in ipairs (BlockDefinitions.blocks) do
        map [idx] = block.icon
    end

    return map
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    self.menus = menus
    self.warningLabel.text = ""
end

--------------------------------------------------
function c:recordPlayerData (playerSettings)

    self.accountId.value =      playerSettings.accountId
    self.avatarTop.value =      tostring (playerSettings.avatarTop)
    self.avatarBottom.value =   tostring (playerSettings.avatarBottom)
end

--------------------------------------------------
return function ()

    local iconsFromNumbers = generateIconsFromNumbers ()
    local iconTexture = dio.resources.getTexture ("MENU_CHUNKS_DIFFUSE")

    local instance = MenuClass ("Multiplayer")
    local properties =
    {
        accountId =         TextEntryMenuItem ("Username", nil, nil, "", 15),
        avatarTop =         IconNumberEntryMenuItem ("Avatar Top Block", nil, nil, 9, iconsFromNumbers, iconTexture),
        avatarBottom =      IconNumberEntryMenuItem ("Avatar Bottom Block", nil, nil, 8, iconsFromNumbers, iconTexture),
        warningLabel =      LabelMenuItem (""),
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (properties.accountId)
    instance:addMenuItem (properties.avatarTop)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.avatarBottom)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Cancel and Quit", onCancelClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Save and Quit", onSaveClicked))

    properties.warningLabel.color = 0xff8000ff

    return instance
end
