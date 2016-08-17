--------------------------------------------------
local Menus = require ("resources/gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("resources/gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter (menus)
    assert (self.worldFolder)
    assert (self.fromMenuId)
end

--------------------------------------------------
function c:onUpdate (menus)

    local isOk = dio.session.beginSp (self.worldFolder)

    if not isOk then
        self.fromMenu:recordWorldAlreadyExistsError ()
        return self.fromMenuId
    else
        return "playing_game_menu"
    end

end

--------------------------------------------------
function c:onExit ()
    self.worldFolder = nil
    self.fromMenuId = nil
end

--------------------------------------------------
function c:onAppShouldClose (parent_func)
    dio.session.terminate ()
    self.parent.onAppShouldClose (self)
    return "quitting_menu", true
end

--------------------------------------------------
function c:recordWorldSettings (worldFolder, fromMenuId)
    print ("recordWorldSettings")
    print (worldFolder)
    print (fromMenuId)

    self.worldFolder = worldFolder
    self.fromMenuId = fromMenuId
end

--------------------------------------------------
return function ()
    local instance = MenuClass ("Loading World")

    Mixin.CopyToAndBackupParents (instance, c)

    return instance
end
