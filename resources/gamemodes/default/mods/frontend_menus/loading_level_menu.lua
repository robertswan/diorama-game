--------------------------------------------------
local Menus = require ("resources/gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("resources/gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    assert (self.isNew)
    assert (self.dataFolder)
    -- assert (self.worldSettings ~= nil)
    -- assert (not self.worldSettings.isNew or self.fromMenu ~= nil)
end

--------------------------------------------------
function c:onUpdate (menus)

    if self.isNew then

        local isOk = dio.session.beginSp (self.dataFolder)

        self.dataFolder = nil
        self.isNew = nil

        if not isOk then
            self.fromMenu:recordWorldAlreadyExistsError ()
            return self.fromMenu.menuKey
        else
            return "playing_game_menu"
        end

    else

        self.fromMenu:recordWorldAlreadyExistsError ()
        return self.fromMenu.menuKey

    end

end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
    dio.session.terminate ()
    self.parent.onAppShouldClose (self)
    return "quitting_menu", true
end

-- --------------------------------------------------
-- function c:recordWorldSettings (worldSettings, roomSettings, fromMenu)
--     self.isNew = nil
--     self.worldSettings = worldSettings
--     self.roomSettings = roomSettings
--     self.fromMenu = fromMenu
-- end

--------------------------------------------------
function c:recordWorldSettingsNew (dataFolder, fromMenu)
    self.isNew = true
    self.dataFolder = dataFolder
    self.fromMenu = fromMenu
end

--------------------------------------------------
return function ()
    local instance = MenuClass ("Load World")

    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
