--------------------------------------------------
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

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
