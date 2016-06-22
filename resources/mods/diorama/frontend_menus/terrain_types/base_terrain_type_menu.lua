--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local NumberMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/number_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local TextEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/text_entry_menu_item")

--------------------------------------------------
local function onCreateLevelClicked (menuItem, menu)
    if menu.filename.value == nil or
            menu.filename.value == "" or
            dio.file.isExistingWorldFolder (menu.filename) then

        menu.warningLabel.text = "ERROR: Filename is not valid"

    else

        local worldSettings =
        {
            modFolder = "creative",
            dataFolder = menu.filename.value,
            shouldSave = true,
        }

        local isOk = dio.file.newWorld (worldSettings)

        local roomSettings =
        {
            path = "default",
            randomSeedAsString = menu.randomSeed.value,
            terrainId = menu.menuProperties.terrainId,
            generators = menu.menuProperties.generators,
        }

        isOk = isOk and dio.file.newRoom (worldSettings.dataFolder, roomSettings)

        if isOk then

            menu.loadingLevelMenu:recordWorldSettingsNew (worldSettings.dataFolder, menu)

            menu.warningLabel.text = ""
            return "loading_level_menu"

        else
            menu.warningLabel.text = "ERROR: Level creation failed"

        end

        -- local worldSettings =
        -- {
        --     path =              menu.filename.value,
        --     isNew =             true,
        --     shouldSave =        true,
        -- }

        -- local roomSettings =
        -- {
        --     path =                              "default/",
        --     terrainId =                         menu.menuProperties.terrainId,
        --     randomSeedAsString =                menu.randomSeed.value,
        --     generators =                        menu.menuProperties.generators,
        -- }

        -- for _, v in ipairs (menu.menuProperties.options) do
        --     roomSettings [v.id] = menu [v.id]:getValueAsNumber ()
        -- end

        -- menu.loadingLevelMenu:recordWorldSettings (worldSettings, roomSettings, menu)

    end
end

--------------------------------------------------
local function onReturnToParentClicked ()
    return "create_new_level_menu"
end

--------------------------------------------------
local function onResetToDefaultsClicked (menuItem, menu)
    for _, v in ipairs (menu.menuProperties.options) do
        menu [v.id].value = tostring (v.default)
    end
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
    self.loadingLevelMenu = menus.loading_level_menu

    if self.doesWorldAlreadyExistError then
        self.warningLabel.text = "World already exists. Please Rename it"
        self.doesWorldAlreadyExistError = nil
    end
end

--------------------------------------------------
function c:onExit ()
    self.warningLabel.text = ""
    self.loadingLevelMenu = nil
end

--------------------------------------------------
function c:recordWorldAlreadyExistsError ()
    self.doesWorldAlreadyExistError = true
end

--------------------------------------------------
return function (menuProperties)

    local instance = MenuClass (menuProperties.description)

    local properties =
    {
        loadingLevelMenu = nil,
        filename =                          TextEntryMenuItem ("Filename", nil, nil, "MyWorld", 16),
        randomSeed =                        TextEntryMenuItem ("Random Seed", nil, nil, "RobTheSwan", 16),
        createLevel =                       ButtonMenuItem ("Create Level", onCreateLevelClicked),
        warningLabel =                      LabelMenuItem (""),

        menuProperties =                    menuProperties,
    }

    for _, v in ipairs (menuProperties.options) do
        properties [v.id] = NumberMenuItem (v.description, nil, nil, v.default, v.isInteger)
    end

    properties.warningLabel.color = 0xff8000ff

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (properties.filename)
    instance:addMenuItem (properties.randomSeed)

    for _, v in ipairs (menuProperties.options) do
        instance:addMenuItem (properties [v.id])
    end

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (properties.createLevel)

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))
    instance:addMenuItem (ButtonMenuItem ("Reset To Defaults", onResetToDefaultsClicked))

    instance:addMenuItem (properties.warningLabel)

    return instance
end
