--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local CheckboxMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/checkbox_menu_item")
local KeySelectMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/key_select_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local NumberMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/number_menu_item")
local SliderMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/slider_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local function warnAgainstIdenticalKeyBindings (menu)
    menu.multiKeySelectWarning.text = ""

    for startIdx = 1, (#menu.keyMenuItems - 1) do
        local startMenuItem = menu.keyMenuItems [startIdx]
        for compareIdx = startIdx + 1, #menu.keyMenuItems do
            local compareMenuItem = menu.keyMenuItems [compareIdx]
            if startMenuItem.keyCode == compareMenuItem.keyCode then

                menu.multiKeySelectWarning.text =
                    "WARNING: " ..
                    startMenuItem.text ..
                    " and " ..
                    compareMenuItem.text ..
                    " CLASH!"

                return
            end
        end
    end
end

--------------------------------------------------
local function onKeyUpdated (menuItem, menu)
    warnAgainstIdenticalKeyBindings (menu)
end

--------------------------------------------------
local function onSaveClicked (self, menu)

    dio.inputs.mouse.setIsInverted (menu.invertMouse.isChecked)

    dio.inputs.hackSetFov (menu.fov:getValueAsNumber ())
    dio.inputs.hackSetGravityBlend (menu.gravity:getValueAsNumber ())

    local setBinding = dio.inputs.bindings.setKeyBinding
    local types = dio.inputs.bindingTypes

    setBinding (types.FORWARD,      menu.keyMenuItems [1].keyCode)
    setBinding (types.LEFT,         menu.keyMenuItems [2].keyCode)
    setBinding (types.BACKWARD,     menu.keyMenuItems [3].keyCode)
    setBinding (types.RIGHT,        menu.keyMenuItems [4].keyCode)
    setBinding (types.JUMP,         menu.keyMenuItems [5].keyCode)
    setBinding (types.CROUCH,       menu.keyMenuItems [6].keyCode)
    setBinding (types.TURBO,        menu.keyMenuItems [7].keyCode)

    local playerSettings =
    {
        isMouseInverted =       menu.invertMouse.isChecked,
        fov =                   menu.fov:getValueAsNumber (),
        gravity =               menu.gravity:getValueAsNumber (),
        forward =               menu.keyMenuItems [1].keyCode,
        left =                  menu.keyMenuItems [2].keyCode,
        backward =              menu.keyMenuItems [3].keyCode,
        right =                 menu.keyMenuItems [4].keyCode,
        jump =                  menu.keyMenuItems [5].keyCode,
        crouch =                menu.keyMenuItems [6].keyCode,
        turbo =                 menu.keyMenuItems [7].keyCode
    }

    dio.file.saveLua (dio.file.locations.SETTINGS, "player_settings.lua", playerSettings, "playerSettings")

    return "in_game_pause_menu"
end

--------------------------------------------------
local function onCancelClicked ()
    return "in_game_pause_menu"
end

--------------------------------------------------
local function onResetToDefaultsClicked (menuItem, menu)

    local keyCodeFromString = dio.inputs.keys.keyCodeFromString
    menu.fov.value = "90"
    menu.gravity.value = "0.075"

    menu.invertMouse.isChecked = false
    menu.keyMenuItems [1].keyCode = keyCodeFromString ("W")
    menu.keyMenuItems [2].keyCode = keyCodeFromString ("A")
    menu.keyMenuItems [3].keyCode = keyCodeFromString ("S")
    menu.keyMenuItems [4].keyCode = keyCodeFromString ("D")
    menu.keyMenuItems [5].keyCode = keyCodeFromString ("SPACE")
    menu.keyMenuItems [6].keyCode = keyCodeFromString ("LEFT_CONTROL")
    menu.keyMenuItems [7].keyCode = keyCodeFromString ("LEFT_SHIFT")

    onSaveClicked (menuItem, menu)

    warnAgainstIdenticalKeyBindings (menu)
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose (parent_func)
    self.parent.onAppShouldClose (self)
    return "quitting_menu"
end

--------------------------------------------------
function c:onEnter ()

    local getBinding = dio.inputs.bindings.getKeyBinding
    local types = dio.inputs.bindingTypes

    self.fov.value = tostring (dio.inputs.hackGetFov ())
    self.gravity.value = tostring (dio.inputs.hackGetGravityBlend ())

    self.invertMouse.isChecked = dio.inputs.mouse.getIsInverted ()
    self.keyMenuItems [1].keyCode = getBinding (types.FORWARD)
    self.keyMenuItems [2].keyCode = getBinding (types.LEFT)
    self.keyMenuItems [3].keyCode = getBinding (types.BACKWARD)
    self.keyMenuItems [4].keyCode = getBinding (types.RIGHT)
    self.keyMenuItems [5].keyCode = getBinding (types.JUMP)
    self.keyMenuItems [6].keyCode = getBinding (types.CROUCH)
    self.keyMenuItems [7].keyCode = getBinding (types.TURBO)

    warnAgainstIdenticalKeyBindings (self)
end

--------------------------------------------------
return function ()

    local isMouseInverted = dio.inputs.mouse.getIsInverted ()
    local keyCodes = dio.inputs.keyCodes

    local properties =
    {
        invertMouse = CheckboxMenuItem ("Invert Mouse", nil, isMouseInverted),
        fov = SliderMenuItem ("Field Of View", nil, nil, "90", true),
        gravity = NumberMenuItem ("Gravity Blend", nil, nil, 0.075, false),

        keyMenuItems =
        {
            KeySelectMenuItem ("Forward", onKeyUpdated, 0),
            KeySelectMenuItem ("Left", onKeyUpdated, 0),
            KeySelectMenuItem ("Back", onKeyUpdated, 0),
            KeySelectMenuItem ("Right", onKeyUpdated, 0),
            KeySelectMenuItem ("Jump", onKeyUpdated, 0),
            KeySelectMenuItem ("Crouch", onKeyUpdated, 0),
            KeySelectMenuItem ("Turbo", onKeyUpdated, 0),
        },

        multiKeySelectWarning = LabelMenuItem (""),
    }

    properties.multiKeySelectWarning.color = 0xff8000ff

    local instance = MenuClass ("PLAYER CONTROLS MENU")

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.invertMouse)
    instance:addMenuItem (properties.fov)
    instance:addMenuItem (properties.gravity)
    instance:addMenuItem (properties.keyMenuItems [1])
    instance:addMenuItem (properties.keyMenuItems [2])
    instance:addMenuItem (properties.keyMenuItems [3])
    instance:addMenuItem (properties.keyMenuItems [4])
    instance:addMenuItem (properties.keyMenuItems [5])
    instance:addMenuItem (properties.keyMenuItems [6])
    instance:addMenuItem (properties.keyMenuItems [7])
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (ButtonMenuItem ("Save", onSaveClicked))
    instance:addMenuItem (ButtonMenuItem ("Cancel", onCancelClicked))
    instance:addMenuItem (ButtonMenuItem ("Reset To Defaults", onResetToDefaultsClicked))
    instance:addMenuItem (properties.multiKeySelectWarning)

    return instance
end
