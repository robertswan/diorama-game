--------------------------------------------------
local Menus = require ("gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onSessionShutdownCompleted ()
    return "main_menu"
end

--------------------------------------------------
return function ()
    local instance = MenuClass ("SAVING GAME MENU")
    Mixin.CopyToAndBackupParents (instance, c)
    return instance
end
