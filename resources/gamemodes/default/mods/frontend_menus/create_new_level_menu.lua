--------------------------------------------------
local BreakMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local Menus = require ("resources/gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("resources/gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local function addMenuButton (menu, text, to_menu)
    local button = ButtonMenuItem (text,      function () return to_menu end)
    menu:addMenuItem (button)
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

    local gameModes = dio.file.listGameModes ()
    for idx, gameMode in ipairs (gameModes) do

        local function onClicked ()
            if gameMode.variations == 1 then
                menus.new_world_settings_menu:recordGameModeVariation (gameMode, 1)
                return "new_world_settings_menu"
            else
                menus.choosing_game_mode_variation_menu:recordGameMode (gameMode)
                return "choosing_game_mode_variation_menu"
            end
            
        end

        local button = ButtonMenuItem (gameMode.title, onClicked)
        self:addMenuItem (button)
    end

    self:addMenuItem (BreakMenuItem ())

    addMenuButton (self, "Return To Parent Menu",       "single_player_top_menu")
end

--------------------------------------------------
function c:onExit ()
    self:clearAllMenuItems ();
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("Create New World")

    local properties =
    {
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
