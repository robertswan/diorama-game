--------------------------------------------------
local function onPlayerLoad (playerId)

	local filename = "player_" .. playerId .. ".lua"
	local settings = dio.file.loadLua (filename);

	if settings then
		dio.world.setPlayerXyz (playerId, settings.xyz)
	end

end

--------------------------------------------------
local function onPlayerSave (playerId)

	local xyz, error = dio.world.getPlayerXyz (playerId)
	if xyz then

		local filename = "player_" .. playerId .. ".lua"
		local settings =
		{
			playerId = playerId, 
			xyz = xyz
		}

		dio.file.saveLua (filename, settings, "settings")

	else
		print (error)
	end
end

-- --------------------------------------------------
-- local function onPlayerRightClick (event)
-- 	if event.blockType == blockTypes.GRANITE then
-- 		event.cancel ()
-- 	else
-- 		event.player.inventory.addItems (event.blockType)
-- 		dio.audio.playSound (sounds.CRUNCH)
-- 	end
-- end

-- --------------------------------------------------
-- local function onComputerActivated (event)
-- 	event.player.inventory.addItems (blockType.Gold, 100)
-- end

--------------------------------------------------
local function onLoadSuccessful ()

	-- dio.players.setPlayerAction (player, actions.LEFT_CLICK, outcomes.DESTROY_BLOCK)

	local types = dio.events.types
	dio.events.server.addListener (types.SERVER_PLAYER_LOAD, onPlayerLoad)
	dio.events.server.addListener (types.SERVER_PLAYER_SAVE, onPlayerSave)

	-- dio.events.server.addListener (types.PLAYER_RIGHT_CLICK, onPlayerRightClick)
	
	-- local block = dio.blockTypes.addNewBLock ("computer", "texture_default", 54, 54, 54, 54, 54, 54)
	-- block.onAction (permissions.MOD, action.PLACE)
	-- block.onAction (permissions.MOD, action.DESTROY)
	-- block.onAction (permissions.EVERYONE, action.ACTIVATE, 
	-- 		function (event)
	-- 			-- can only be used once per 10 seconds by any player
	-- 			if event.instance.lastUsedTime + 1000 * 10 > event.timeNow then
	-- 				event.player.inventory.addItems (blockType.Gold, 100)
	-- 				event.instance.lastUsedTime = event.timeNow
	-- 			end
	-- 		end)

	-- block.onAction (permissions.EVERYONE, action.ACTIVATE, 
	-- 	function (event)
	-- 		-- each player can only use it once per 10 seconds
	-- 		local player = event.player
	-- 		local computer = player.computerBlocks [event.instanceId]
	-- 		if computer.lastUsedTime + 1000 * 10 > event.timeNow then
	-- 			player.inventory.addItems (blockType.Gold, 100)
	-- 			computer.lastUsedTime = event.timeNow|
	-- 		end
	-- 	end)

end

--------------------------------------------------
local modSettings = 
{
	name = "Base Game",

	description = "This is required to play the game!",

	urls = 
	{
		latest = "http://www.robtheswan.com/game/mods/rest.html",
		website = "http://www.robtheswan.com/game/mods/blah.html",
		forums = "http://www.robtheswan.com/game/mods/forums.html",
		bugs = "http://www.robtheswan.com/game/mods/forums.html",
		wiki = "http://www.robtheswan.com/game/mods/forums.html",
	},

	dependencies =
	{
		gameApi =
		{
			minimumVersion = {major = 0, minor = 1},
			maximumVersion = {major = 0, minor = 1},
		},
	},

	permissionsRequired = 
	{
		player = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
