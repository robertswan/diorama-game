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

    local worlds = dio.file.listExistingWorlds ()
    for idx, worldFolder in ipairs (worlds) do

        local function onClicked ()
            menus.loading_level_menu:recordWorldSettings (worldFolder, self.menuKey)
            return "loading_level_menu"
        end

        local button = ButtonMenuItem ("Load " .. worldFolder, onClicked)
        self:addMenuItem (button)
    end

    if #worlds == 0 then
        self:addMenuItem (LabelMenuItem ("No Worlds Found"))
    end

    self:addMenuItem (BreakMenuItem ())
    self:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))

end

--------------------------------------------------
function c:onExit ()
    self.loadingLevelMenu = nil
    self:clearAllMenuItems ();
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("LOAD WORLD MENU")

    local properties =
    {
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
