--------------------------------------------------
local function onSessionRendered ()
	-- dio.drawing.font.drawBox (0, 0, 100, 100, 0x000000)

	-- local font = dio.drawing.font
	-- font.drawString (0, 0, "HELLO WORLD", 0xffffff)

	-- font.drawString (0, 0, "Client chunks loaded", 0xffffff)
	-- font.drawString (0, 0, "Client chunks updated", 0xffffff)
	-- font.drawString (0, 0, "Client chunks rendered", 0xffffff)

	-- font.drawString (0, 0, "Server chunks loading", 0xffffff)
	-- font.drawString (0, 0, "Server chunks loaded", 0xffffff)
	-- font.drawString (0, 0, "Server chunks ", 0xffffff)
	-- font.drawString (0, 0, "Chunks loaded", 0xffffff)
end

--------------------------------------------------
local function onLoadSuccessful ()

	local types = dio.game.eventTypes
	dio.game.addListener (types.CLIENT_SESSION_RENDERED, onSessionRendered)

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
