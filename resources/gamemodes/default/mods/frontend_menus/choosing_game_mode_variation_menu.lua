--------------------------------------------------
local BreakMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("resources/gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local function onReturnToParentClicked ()
    return "single_player_top_menu"
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

    local variations = dio.file.loadLua (dio.file.locations.GAME_MODE, self.gameMode.folder .. "new_saves/options.lua")

    for idx, variation in ipairs (variations.variations) do

        local function onClicked ()
            local idxCopy = idx
            menus.new_world_settings_menu:recordGameModeVariation (self.gameMode, idxCopy)
            return "new_world_settings_menu"
        end

        local button = ButtonMenuItem (variation.title, onClicked)
        self:addMenuItem (button)
    end

    if #variations.variations == 0 then
        self:addMenuItem (LabelMenuItem ("No Variations Found"))
    end

    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))

end

--------------------------------------------------
function c:onExit ()
    self:clearAllMenuItems ();
end

--------------------------------------------------
function c:recordGameMode (gameMode)
    self.gameMode = gameMode
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("CHOOSE GAME MODE VARIATION")

    local properties =
    {
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
