--------------------------------------------------
local Window = require ("resources/scripts/utils/window")

--------------------------------------------------
local instance = 
{
    target =
    {
        x = 0,
        y = 0,
        scale = 1,
    },

    texture = 
    {   
        w = 512,
        h = 256,
        object = nil,
    },

    gamemodes = {},
}
local menus = nil

--------------------------------------------------
local function onUpdated ()

    local windowW, windowH = dio.drawing.getWindowSize ()
    local target = instance.target
    local texture = instance.texture
    
    target.scale = Window.calcBestFitScale (instance.texture.w, instance.texture.h)
    target.x = (windowW - texture.w * target.scale) / 2
    target.y = (windowH - texture.h * target.scale) / 2

end

--------------------------------------------------
local function onEarlyRender ()

    local font = dio.drawing.font;
    local texture = instance.texture

    dio.drawing.setRenderToTexture (texture.object)

    font.drawBox (0, 0, texture.w, texture.h, 0x404040b0);

    for idx, gamemode in ipairs (instance.gamemodes) do
        local y = (idx - 1) * 100
        dio.drawing.drawTexture2 (gamemode.icon, 0, y)
        font.drawString (200, y, gamemode.title, 0xffffffff, true)
    end
    
    dio.drawing.setRenderToTexture (nil)
end

--------------------------------------------------
local function onLateRender ()

    local windowW, windowH = dio.drawing.getWindowSize ()
    local target = instance.target
    local texture = instance.texture

    local font = dio.drawing.font;
    font.drawBox (0, 0, windowW, windowH, 0x000000ff);

    dio.drawing.drawTexture (texture.object, target.x, target.y, texture.w * target.scale, texture.h * target.scale, 0xffffffff)

end

--------------------------------------------------
local function onWindowFocusLost ()
    -- menus:onWindowFocusLost ()
end

-- --------------------------------------------------
-- local reasons = dio.events.sessionShutdownBegun.reasons
-- local reasonsStrings =
-- {
--     [reasons.NETWORK_CONNECTION_ATTEMPT_FAILED]    = "NETWORK_CONNECTION_ATTEMPT_FAILED",
--     [reasons.PLAYER_QUIT]                          = "PLAYER_QUIT",
--     [reasons.NETWORK_CONNECTION_LOST]              = "NETWORK_CONNECTION_LOST",
--     [reasons.KICKED_FROM_SERVER]                   = "KICKED_FROM_SERVER",
-- }

-- local function onSessionShutdownBegun (reason)
--     print ("onSessionShutdownBegun = " .. reasonsStrings [reason])
--     menus:onSessionShutdownBegun (reason)
-- end

-- --------------------------------------------------
-- local function onSessionShutdownCompleted ()
--     print ("onSessionShutdownCompleted")
--     menus:onSessionShutdownCompleted ()
-- end

--------------------------------------------------
local function onApplicationShutdown ()
    -- print ("onApplicationShutdown")
    -- return menus:onApplicationShutdown ()
end

--------------------------------------------------
local function listAvailableGameModes ()

    -- iterate over all folders

    local gamemodes = {}
    local folders = dio.file.listGameModeFolders ()

    for _, folder in ipairs (folders) do
        local description = dio.file.loadLua (dio.file.locations.GAME_MODE, folder .. "summary/description.lua")

        description.icon = dio.resources.loadTexture (folder .. "icon", folder .. "summary/" .. description.icon)

        table.insert (gamemodes, description)
    end

    instance.gamemodes = gamemodes;

end

--------------------------------------------------
local function load ()

    -- loadPlayerControls ()

    dio.drawing.addRenderPassBefore (10.0, onEarlyRender)
    dio.drawing.addRenderPassAfter (10.0, onLateRender)

    local types = dio.types.clientEvents
    dio.events.addListener (types.UPDATED,                         onUpdated)
    dio.events.addListener (types.WINDOW_FOCUS_LOST,               onWindowFocusLost)
    -- instance.eventIds.onSessionShutdownBegun = dio.events.addListener (types.SESSION_SHUTDOWN_BEGUN,          onSessionShutdownBegun)
    -- instance.eventIds.onSessionShutdownCompleted = dio.events.addListener (types.SESSION_SHUTDOWN_COMPLETED,      onSessionShutdownCompleted)
    dio.events.addListener (types.APPLICATION_SHUTDOWN,            onApplicationShutdown)

    instance.texture.object = dio.drawing.createRenderToTexture (instance.texture.w, instance.texture.h)

    listAvailableGameModes ()

    -- local menu_path = "gamemodes/dio_default/mods/frontend_menus/"
    -- local individual_menus =
    -- {
    --     text_file_menu =                require (menu_path .. "text_file_menu") (),
    -- }

    -- for k, v in pairs (individual_menus) do
    --     v.menuKey = k
    -- end

    --menus = Menus (individual_menus, "main_menu")
end

--------------------------------------------------
local function unload ()

    local types = dio.types.clientEvents
    dio.events.removeListener (types.UPDATED,                         onUpdate)
    dio.events.removeListener (types.WINDOW_FOCUS_LOST,               onWindowFocusLost)
    dio.events.removeListener (types.APPLICATION_SHUTDOWN,            onApplicationShutdown)
    instance.eventIds = {}

end

--------------------------------------------------
-- TODO: make this like a mod - can use permissions
load ()
