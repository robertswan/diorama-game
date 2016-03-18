--------------------------------------------------
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    assert (self.worldSettings ~= nil)
    self.createNewLevelMenu = menus.create_new_level_menu
end

--------------------------------------------------
function c:onUpdate (menus)

    local isNew = self.worldSettings.isNew
    local isOk = dio.session.beginSp (self.worldSettings, self.roomSettings)

    self.worldSettings = nil
    self.roomSettings = nil

    if isOk then
        return "playing_game_menu"

    elseif isNew then
        self.createNewLevelMenu:recordWorldAlreadyExistsError ()
        return "create_new_level_menu"

    else
        return "load_level_menu"
    end
end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
    dio.session.terminate ()
    self.parent.onAppShouldClose (self)
    return "quitting_menu", true
end

--------------------------------------------------
function c:recordWorldSettings (worldSettings, roomSettings)
    self.worldSettings = worldSettings
    self.roomSettings = roomSettings
end

--------------------------------------------------
return function ()
    local instance = MenuClass ("LOADING LEVEL MENU")

    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
