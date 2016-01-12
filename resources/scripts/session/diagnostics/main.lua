--------------------------------------------------
local function onSessionRendered ()
	-- dio.drawing.font.drawBox (0, 0, 100, 100, 0x000000)
	-- dio.drawing.font.drawString (0, 0, "HELLO WORLD", 0xffffff)
end

--------------------------------------------------
local function onLoadSuccessful ()

	local types = dio.events.types
	dio.events.server.addListener (types.CLIENT_SESSION_RENDERED, onSessionRendered)

end

--------------------------------------------------
local modSettings = 
{
	name = "Diagnostics",

	description = "Prints out debug data during a session",

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
		client = true,
		file = true,
		player = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
