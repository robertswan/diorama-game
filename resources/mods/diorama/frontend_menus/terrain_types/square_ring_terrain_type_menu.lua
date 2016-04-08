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
local basicGenerator = 
{
    weightPass =
    {
        {
            type = "perlinNoise",
            mode = "replace",

            scale = 128,
            octaves = 5,
            perOctaveAmplitude = 0.5,
            perOctaveFrequency = 2.0,
            normalize = true,
        },
        -- {
        --     type = "treePass",
        --     frequency = 1,
        -- }
    },

    voxelPass =
    {
        {
            type = "addGrass",

            mudHeight = 4,
        }
    }
}

--------------------------------------------------
local function onCreateLevelClicked (menuItem, menu)
    if menu.filename.value == nil or 
            menu.filename.value == "" or 
            dio.file.isExistingWorldFolder (menu.filename) then

        menu.warningLabel.text = "ERROR! Filename is not valid!"

    else

        local worldSettings =
        {
            path =              menu.filename.value,
            isNew =             true,
            shouldSave =        true,
        }

        local roomSettings =
        {
            path =                              "default/",
            generators =                        {basicGenerator},
            terrainId =                         "paramaterized",
            randomSeedAsString =                menu.randomSeed.value,
        }

        menu.loadingLevelMenu:recordWorldSettings (worldSettings, roomSettings)

        menu.warningLabel.text = ""
        return "loading_level_menu"
    end
end

--------------------------------------------------
local function onReturnToParentClicked ()
    return "create_new_level_menu"
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
return function ()

    local instance = MenuClass ("Test new generation")

    local properties =
    {
        loadingLevelMenu = nil,
        filename =                          TextEntryMenuItem ("Filename", nil, nil, "MyWorld", 16),
        randomSeed =                        TextEntryMenuItem ("Random Seed", nil, nil, "Wauteurz", 16),
        createLevel =                       ButtonMenuItem ("Create Level", onCreateLevelClicked),
        warningLabel =                      LabelMenuItem (""),
    }

    properties.warningLabel.color = 0xff8000ff

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.filename)
    instance:addMenuItem (properties.randomSeed)
    
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.createLevel)

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))
    instance:addMenuItem (ButtonMenuItem ("Reset To Defaults", onResetToDefaultsClicked))
    instance:addMenuItem (properties.warningLabel)

    return instance
end
