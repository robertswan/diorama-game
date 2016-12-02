--------------------------------------------------
local BreakMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local NumberMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/number_menu_item")
local Menus = require ("gamemodes/default/mods/frontend_menus/menu_construction")
local MenuClass = require ("gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")
local TextEntryMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/text_entry_menu_item")

--------------------------------------------------
local function onCreateWorldClicked (menuItem, menu)

    local newFolder = menu.filename.value

    local exists, reason = dio.file.isExistingWorldFolder (newFolder)
    
    if exists == nil then
        menu.warningLabel.text = "ERROR: " .. reason

    elseif newFolder == nil or
            newFolder == "" or
            exists == true then

        menu.warningLabel.text = "ERROR: Save folder already exists"

    else

        local gameModeVariations = dio.file.loadLua (dio.file.locations.GAME_MODE, menu.gameMode.folder .. "new_saves/options.lua")
        local folder_to_copy = menu.gameMode.folder .. "new_saves/" .. gameModeVariations.variations [menu.gameModeVariationIdx].folder

        print ("LOLCOOLKAT")
        print (folder_to_copy)
        print (newFolder)

        dio.file.copyFolder ("saves/" .. newFolder, dio.file.locations.GAME_MODE, folder_to_copy)

        menu.loadingWorldMenu:recordWorldSettings (newFolder, menu.menuKey)

        menu.warningLabel.text = ""
        return "loading_world_menu"
    end
end

--------------------------------------------------
local function onReturnToParentClicked ()
    return "create_new_world_menu"
end

-- --------------------------------------------------
-- local function onResetToDefaultsClicked (menuItem, menu)
--     for _, v in ipairs (menu.menuProperties.options) do
--         menu [v.id].value = tostring (v.default)
--     end
-- end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
    self.parent.onAppShouldClose (self)
    return "quitting_menu"
end

--------------------------------------------------
function c:onEnter (menus)
    self.loadingWorldMenu = menus.loading_world_menu

    if self.doesWorldAlreadyExistError then
        self.warningLabel.text = "World already exists. Please Rename it"
        self.doesWorldAlreadyExistError = nil
    end
end

--------------------------------------------------
function c:onExit ()
    self.warningLabel.text = ""
    self.loadingWorldMenu = nil
end

--------------------------------------------------
function c:recordWorldAlreadyExistsError ()
    self.doesWorldAlreadyExistError = true
end

--------------------------------------------------
function c:recordGameModeVariation (gameMode, variationIdx)
    self.gameMode = gameMode
    self.gameModeVariationIdx = variationIdx
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("Create New World Options")

    local properties =
    {
        loadingWorldMenu = nil,
        filename =                          TextEntryMenuItem ("Filename", nil, nil, "MyWorld", 16),
        -- randomSeed =                        TextEntryMenuItem ("Random Seed", nil, nil, "RobTheSwan", 16),
        createWorld =                       ButtonMenuItem ("Create World", onCreateWorldClicked),
        warningLabel =                      LabelMenuItem (""),

        menuProperties =                    menuProperties,
    }

    properties.warningLabel.color = 0xff8000ff

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.filename)
    -- instance:addMenuItem (properties.randomSeed)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.createWorld)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))
    instance:addMenuItem (properties.warningLabel)

    return instance
end
