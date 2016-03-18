--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local function onSinglePlayerClicked ()
    return "single_player_top_menu"
end

--------------------------------------------------
local function onMultiplayerClicked ()
    return "multiplayer_top_menu"
end

--------------------------------------------------
local function onEditPlayerClicked ()
    return "player_controls_menu"
end

--------------------------------------------------
local function onTextFileClicked (menu, file)
    menu.textFileMenu:recordFilename (file)
    return "text_file_menu"
end

--------------------------------------------------
local function onQuitClicked ()
    dio.system.closeApplication ()
    return "quitting_menu"
end

--------------------------------------------------
local function onPaintClicked ()
    return "paint_main_menu"
end

--------------------------------------------------
local function onPlayTetrisClicked ()
    return "tetris_main_menu"
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
    assert (menus ~= nil)
    assert (menus.text_file_menu ~= nil)
    self.textFileMenu = menus.text_file_menu
end

--------------------------------------------------
function c:onExit ()
    self.textFileMenu = nil
end

--------------------------------------------------
function c:onRender ()
    return self.parent.onRender (self)
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("MAIN MENU")

    local properties = {}

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (ButtonMenuItem ("Single Player", onSinglePlayerClicked))
    instance:addMenuItem (ButtonMenuItem ("Multiplayer", onMultiplayerClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Edit Player", onEditPlayerClicked))
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Read 'readme.txt'", function (menuItem, menu) return onTextFileClicked (menu, "readme.txt") end))
    instance:addMenuItem (ButtonMenuItem ("Read 'contrib.txt'", function (menuItem, menu) return onTextFileClicked (menu, "contrib.txt") end))
    instance:addMenuItem (ButtonMenuItem ("Read 'licenses.txt'", function (menuItem, menu) return onTextFileClicked (menu, "licenses.txt") end))
    instance:addMenuItem (ButtonMenuItem ("Paint", onPaintClicked))
    instance:addMenuItem (ButtonMenuItem ("Play Block Falling Game", onPlayTetrisClicked))

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Quit", onQuitClicked))
    
    local versionInfo = dio.system.getVersion ()

    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (LabelMenuItem (versionInfo.title))
    instance:addMenuItem (LabelMenuItem (versionInfo.buildDate))
    instance:addMenuItem (LabelMenuItem ("twitch.tv/robtheswan             robtheswan.com"))

    return instance
end
