--------------------------------------------------
local Menus = require ("resources/mods/diorama/frontend_menus/menus")

local menus = nil

--------------------------------------------------
local function loadPlayerControls ()

    local playerSettings = dio.file.loadLua ("player_settings.lua")

    if playerSettings then

        dio.inputs.mouse.setIsInverted (playerSettings.isMouseInverted)

        dio.inputs.hackSetFov (playerSettings.fov)
        dio.inputs.hackSetGravityBlend (playerSettings.gravity)

        local setBinding = dio.inputs.bindings.setKeyBinding
        local types = dio.inputs.bindingTypes

        setBinding (types.FORWARD,      playerSettings.forward)
        setBinding (types.LEFT,         playerSettings.left)
        setBinding (types.BACKWARD,     playerSettings.backward)
        setBinding (types.RIGHT,        playerSettings.right)
        setBinding (types.JUMP,         playerSettings.jump)
        setBinding (types.CROUCH,       playerSettings.crouch)
        setBinding (types.TURBO,        playerSettings.turbo)
    end
end

--------------------------------------------------
local function onUpdated ()
    menus:update ()
end

--------------------------------------------------
local function onEarlyRender ()
    menus:renderEarly ()
end

--------------------------------------------------
local function onLateRender ()
    menus:renderLate ()
end

--------------------------------------------------
local function onWindowFocusLost ()
    menus:onWindowFocusLost ()
end

--------------------------------------------------
local reasonsStrings =
{
    [dio.events.sessionShutdownBegun.reasons.NETWORK_CONNECTION_ATTEMPT_FAILED]    = "NETWORK_CONNECTION_ATTEMPT_FAILED",
    [dio.events.sessionShutdownBegun.reasons.PLAYER_QUIT]                          = "PLAYER_QUIT",
    [dio.events.sessionShutdownBegun.reasons.NETWORK_CONNECTION_LOST]              = "NETWORK_CONNECTION_LOST",
    [dio.events.sessionShutdownBegun.reasons.KICKED_FROM_SERVER]                   = "KICKED_FROM_SERVER",
}

local function onSessionShutdownBegun (reason)
    print ("onSessionShutdownBegun = " .. reasonsStrings [reason])
    menus:onSessionShutdownBegun (reason)
end

--------------------------------------------------
local function onSessionShutdownCompleted ()
    print ("onSessionShutdownCompleted")
    menus:onSessionShutdownCompleted ()
end

--------------------------------------------------
local function onApplicationShutdown ()
    print ("onApplicationShutdown")
    return menus:onApplicationShutdown ()
end

--------------------------------------------------
local function main ()

    loadPlayerControls ()

    dio.drawing.addRenderPassBefore (10.0, onEarlyRender)
    dio.drawing.addRenderPassAfter (10.0, onLateRender)

    local types = dio.events.types
    dio.events.addListener (types.CLIENT_UPDATED,                         onUpdated)
    dio.events.addListener (types.CLIENT_WINDOW_FOCUS_LOST,               onWindowFocusLost)
    dio.events.addListener (types.CLIENT_SESSION_SHUTDOWN_BEGUN,          onSessionShutdownBegun)
    dio.events.addListener (types.CLIENT_SESSION_SHUTDOWN_COMPLETED,      onSessionShutdownCompleted)
    dio.events.addListener (types.CLIENT_APPLICATION_SHUTDOWN,            onApplicationShutdown)

    local menu_path = "resources/mods/diorama/frontend_menus/"
    local terrain_path = menu_path .. "terrain_types/"

    local individual_menus =
    {
        text_file_menu =                require (menu_path .. "text_file_menu") (),
        main_menu =                     require (menu_path .. "main_menu") (),
        single_player_top_menu =        require (menu_path .. "single_player_top_menu") (),
        multiplayer_top_menu =          require (menu_path .. "multiplayer_top_menu") (),
        create_new_level_menu =         require (menu_path .. "create_new_level_menu") (),
        load_level_menu =               require (menu_path .. "load_level_menu") (),
        delete_level_menu =             require (menu_path .. "delete_level_menu") (),
        delete_level_confirm_menu =     require (menu_path .. "delete_level_confirm_menu") (),
        player_controls_menu =          require (menu_path .. "player_controls_menu") (),
        player_controls_menu_in_game =  require (menu_path .. "player_controls_menu_in_game") (),
        loading_level_menu =            require (menu_path .. "loading_level_menu") (),

        back_to_back_terrain_type_menu =        require (terrain_path .. "back_to_back_terrain_type_menu") (),
        cubic_terrain_type_menu =               require (terrain_path .. "cubic_terrain_type_menu") (),
        flat_terrain_type_menu =                require (terrain_path .. "flat_terrain_type_menu") (),
        parallel_facing_terrain_type_menu =     require (terrain_path .. "parallel_facing_terrain_type_menu") (),
        square_ring_terrain_type_menu =         require (terrain_path .. "square_ring_terrain_type_menu") (),
        hollow_earth_terrain_type_menu =        require (terrain_path .. "hollow_earth_terrain_type_menu") (),
        floating_islands_terrain_type_menu =    require (terrain_path .. "floating_islands_terrain_type_menu") (),

        in_game_pause_menu =            require (menu_path .. "in_game_pause_menu") (),
        game_not_connected_menu =       require (menu_path .. "game_not_connected_menu") (),
        saving_game_menu =              require (menu_path .. "saving_game_menu") (),
        quitting_menu =                 require (menu_path .. "quitting_menu") (),
        tetris_main_menu =              require (menu_path .. "tetris/tetris_main_menu") (),
        paint_main_menu =               require (menu_path .. "paint/paint_main") (),

    }

    for k, v in pairs (individual_menus) do
        v.menuKey = k
    end


    individual_menus.text_file_menu:recordFilename ("readme.txt")
    menus = Menus (individual_menus, "main_menu")

    individual_menus.playing_game_menu =         require (menu_path .. "playing_game_menu") (menus)
end

main ()
