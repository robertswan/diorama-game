--------------------------------------------------
-- global variables
-- TODO get these out of globals
app_is_shutting_down = false
app_is_ready_to_quit = false

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
local function OnUpdate ()
	return menus:update ()
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
local function main ()

	loadPlayerControls ()

	dio.onUpdate = OnUpdate
	-- dio.onRenderMenus = OnRenderMenus
	-- dio.onRender = OnRender

	dio.drawing.addRenderPassBefore (onEarlyRender)
	dio.drawing.addRenderPassAfter (onLateRender)

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
		saving_game_menu =			require ("resources/scripts/menus/saving_game_menu") (),
		quitting_menu =				require ("resources/scripts/menus/quitting_menu") (),
		tetris_main_menu =			require ("resources/scripts/menus/tetris/tetris_main_menu") (),
	}

	individual_menus.text_file_menu:recordFilename ("readme.txt")
	menus = Menus (individual_menus, "text_file_menu")

	individual_menus.playing_game_menu = 		require ("resources/scripts/menus/playing_game_menu") (menus)
end

main ()
