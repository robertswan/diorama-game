--------------------------------------------------
local Menus = require ("resources/scripts/menus/menus")

local menus = nil

--------------------------------------------------
local function loadPlayerControls ()

	local playerSettings = dio.file.loadLua ("player_settings.lua")

	if playerSettings then

		dio.inputs.mouse.setIsInverted (playerSettings.isMouseInverted)

		dio.inputs.hackSetFov (playerSettings.fov)

		local setBinding = dio.inputs.bindings.setKeyBinding
		local types = dio.inputs.bindingTypes

		setBinding (types.FORWARD,	playerSettings.forward)
		setBinding (types.LEFT, 	playerSettings.left)
		setBinding (types.BACKWARD,	playerSettings.backward)
		setBinding (types.RIGHT, 	playerSettings.right)
		setBinding (types.JUMP, 	playerSettings.jump)
		setBinding (types.TURBO, 	playerSettings.turbo)
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
local function onSessionStarted ()
	menus:onSessionStarted ()
end

--------------------------------------------------
local reasonsStrings = 
{
	[dio.events.sessionShutdownBegun.reasons.NETWORK_CONNECTION_ATTEMPT_FAILED]	= "NETWORK_CONNECTION_ATTEMPT_FAILED",
	[dio.events.sessionShutdownBegun.reasons.PLAYER_QUIT]						= "PLAYER_QUIT",
	[dio.events.sessionShutdownBegun.reasons.NETWORK_CONNECTION_LOST]			= "NETWORK_CONNECTION_LOST",
	[dio.events.sessionShutdownBegun.reasons.KICKED_FROM_SERVER]				= "KICKED_FROM_SERVER",	
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
	dio.events.addListener (types.CLIENT_UPDATED,			 			onUpdated)
	dio.events.addListener (types.CLIENT_WINDOW_FOCUS_LOST, 			onWindowFocusLost)
	dio.events.addListener (types.CLIENT_SESSION_STARTED, 				onSessionStarted)
	dio.events.addListener (types.CLIENT_SESSION_SHUTDOWN_BEGUN, 		onSessionShutdownBegun)
	dio.events.addListener (types.CLIENT_SESSION_SHUTDOWN_COMPLETED, 	onSessionShutdownCompleted)
	dio.events.addListener (types.CLIENT_APPLICATION_SHUTDOWN, 			onApplicationShutdown)

	local individual_menus =
	{
		text_file_menu = 			require ("resources/scripts/menus/text_file_menu") (),
		main_menu = 				require ("resources/scripts/menus/main_menu") (),
		single_player_top_menu =	require ("resources/scripts/menus/single_player_top_menu") (),
		multiplayer_top_menu =		require ("resources/scripts/menus/multiplayer_top_menu") (),
		create_new_level_menu = 	require ("resources/scripts/menus/create_new_level_menu") (),
		load_level_menu = 			require ("resources/scripts/menus/load_level_menu") (),
		delete_level_menu = 		require ("resources/scripts/menus/delete_level_menu") (),
		delete_level_confirm_menu = require ("resources/scripts/menus/delete_level_confirm_menu") (),
		player_controls_menu = 		require ("resources/scripts/menus/player_controls_menu") (),
		loading_level_menu = 		require ("resources/scripts/menus/loading_level_menu") (),

		in_game_pause_menu =		require ("resources/scripts/menus/in_game_pause_menu") (),
		game_not_connected_menu =	require ("resources/scripts/menus/game_not_connected_menu") (),
		saving_game_menu =			require ("resources/scripts/menus/saving_game_menu") (),
		quitting_menu =				require ("resources/scripts/menus/quitting_menu") (),
		tetris_main_menu =			require ("resources/scripts/menus/tetris/tetris_main_menu") (),
		paint_main_menu =			require ("resources/scripts/menus/paint/paint_main") (),
	}

	individual_menus.text_file_menu:recordFilename ("readme.txt")
	menus = Menus (individual_menus, "text_file_menu")

	individual_menus.playing_game_menu = 		require ("resources/scripts/menus/playing_game_menu") (menus)
end

main ()
