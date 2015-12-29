--------------------------------------------------
local function onPlayerLoad (playerId)

	local filename = "player_0.lua"
	local settings = dio.file.loadLua (filename);

	if settings then
		dio.world.setPlayerXyz (playerId, settings.xyz)
	end

end

--------------------------------------------------
local function onPlayerSave (playerId)

	local xyz, error = dio.world.getPlayerXyz (playerId)
	if xyz then

		local filename = "player_0.lua"
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

--------------------------------------------------
local function onLoadSuccessful ()

	local types = dio.events.serverTypes
	dio.events.server.addListener (types.PLAYER_LOAD, onPlayerLoad);
	dio.events.server.addListener (types.PLAYER_SAVE, onPlayerSave);

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
