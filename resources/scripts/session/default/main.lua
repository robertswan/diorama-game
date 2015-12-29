--------------------------------------------------
local function onPlayerLoad (playerId, settings)

	dio.session.player.SetXyz (playerId, settings.xyz)

end

--------------------------------------------------
local function onPlayerSave (playerId, settings)

	local xyz, error = dio.session.player.GetPosition (playerId)
	if xyz then
		settings.xyz = xyz
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
