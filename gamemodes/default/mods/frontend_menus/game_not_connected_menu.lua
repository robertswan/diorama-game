--------------------------------------------------
local BreakMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("gamemodes/default/mods/frontend_menus/menu_items/label_menu_item")
local MenuClass = require ("gamemodes/default/mods/frontend_menus/menu_class")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")

local reasons = dio.events.sessionShutdownBegun.reasons
local reasonStrings =
{
    [reasons.NETWORK_CONNECTION_ATTEMPT_FAILED]    =
    {
        "SERVER COULD NOT BE REACHED",
        "The server may not be running",
        "OR You may have put in an incorrect ip and port",
        "OR Your internet connection might be naff",
        "OR Your firewall settings might be naff",
    },

    [reasons.NETWORK_CONNECTION_LOST] =
    {
        "THE NETWORK CONNECTION ENDED",
        "The server may have quit",
        "OR Your internet connection might be naff",
        "",
        ""
    },

    [reasons.KICKED_FROM_SERVER] =
    {
        "SERVER TERMINATED CONNECTION",
        "You probably need to update your client...",
        "...please visit http://twitch.tv/robtheswan to check",
        "OR you are called AmazedStream",
        ""
    },
}

--------------------------------------------------
local function onReturnToMainMenuClicked (self)
    return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onSessionShutdownCompleted ()
    self.returnButton.onClicked = onReturnToMainMenuClicked
end

--------------------------------------------------
function c:onEnter ()
    self.returnButton.onClicked = nil

    local strings = reasonStrings [self.reason]

    self.reasonWarning1.text = strings [1]
    self.reasonWarning2.text = strings [2]
    self.reasonWarning3.text = strings [3]
    self.reasonWarning4.text = strings [4]
    self.reasonWarning5.text = strings [5]
    self.reason = nil
end

--------------------------------------------------
function c:setReason (reason)
    self.reason = reason
end

--------------------------------------------------
return function ()

    local properties =
    {
        reasonWarning1 = LabelMenuItem (""),
        reasonWarning2 = LabelMenuItem (""),
        reasonWarning3 = LabelMenuItem (""),
        reasonWarning4 = LabelMenuItem (""),
        reasonWarning5 = LabelMenuItem (""),
        returnButton = ButtonMenuItem ("Return To Main Menu", nil)
    }

    properties.reasonWarning1.color = 0xff8000ff

    local instance = MenuClass ("GAME NOT CONNECTED MENU")
    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)


    instance:addMenuItem (properties.reasonWarning1)
    instance:addMenuItem (LabelMenuItem (""))
    instance:addMenuItem (properties.reasonWarning2)
    instance:addMenuItem (properties.reasonWarning3)
    instance:addMenuItem (properties.reasonWarning4)
    instance:addMenuItem (properties.reasonWarning5)
    instance:addMenuItem (BreakMenuItem ())
    instance:addMenuItem (properties.returnButton)

    return instance
end
