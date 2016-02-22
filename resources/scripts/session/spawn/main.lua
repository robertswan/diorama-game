
--------------------------------------------------
local function teleportTo (author, x, y, z)
	setting =
	{
		chunkId = {x = 0, y = 0, z = 0},
		xyz = {x = x, y = y, z = z},
		ypr = {x = 0, y = 0, z = 0}
	}

	dio.world.setPlayerXyz (author, setting)
end

--------------------------------------------------
local function onChatMessagePreSent (text)

	if text == ".spawn" then
		
		local author = dio.world.getPlayerNames () [1]
		teleportTo (author, 0, 128, 0)
        
    elseif text == ".sethome" then
        homelocxyz = dio.world.getPlayerXyz (dio.world.getPlayerNames () [1])
        dio.clientChat.send ("set their home")
    
    elseif text == ".home" then
        local author = dio.world.getPlayerNames () [1]
        local xyz, error = homelocxyz
			if xyz then
				local x = math.floor (xyz.chunkId.x * 16 + xyz.xyz.x)
				local y = math.floor (xyz.xyz.y)
				local z = math.floor (xyz.chunkId.z * 16 + xyz.xyz.z)
				teleportTo (author , math.floor(x), math.floor(y), math.floor(z))
            end
                

	elseif string.sub (text, 1, string.len(".tp "))==".tp " then

		local author = dio.world.getPlayerNames () [1]
		local words = {}

		for word in string.gmatch(text, "[^ ]+") do
			table.insert (words, word)
		end

		print ("input = " .. text)
		for _, word in ipairs (words) do
			print (" word = " .. word)
		end

		if #words == 2 then
			local xyz, error = dio.world.getPlayerXyz (words [2])
			if xyz then
				local x = math.floor (xyz.chunkId.x * 16 + xyz.xyz.x)
				local y = math.floor (xyz.xyz.y)
				local z = math.floor (xyz.chunkId.z * 16 + xyz.xyz.z)
				teleportTo (author, math.floor(x), math.floor(y), math.floor(z))
			end

		elseif #words == 4 then
			teleportTo (author, math.floor(words [2]), math.floor(words [3]), math.floor(words [4]))

		end
		
	elseif string.sub(text,1,string.len(".coords"))==".coords" then

		local nameCount = 0
		for playerName in string.gmatch (text, "[%S]+") do

			nameCount = nameCount + 1
			if nameCount > 1 then
				local xyz, error = dio.world.getPlayerXyz (playerName)
				if xyz then
					local x = math.floor (xyz.chunkId.x * 16 + xyz.xyz.x)
					local y = math.floor (xyz.xyz.y)
					local z = math.floor (xyz.chunkId.z * 16 + xyz.xyz.z)
					dio.clientChat.send ("Coords for " .. playerName .. " = (" .. x .. ", " .. y .. ", " .. z .. ")")
				end
			end
		end

		if nameCount == 1 then
			local author = dio.world.getPlayerNames () [1]
			local xyz, error = dio.world.getPlayerXyz (author)
			if xyz then
				local x = math.floor (xyz.chunkId.x * 16 + xyz.xyz.x)
				local y = math.floor (xyz.xyz.y)
				local z = math.floor (xyz.chunkId.z * 16 + xyz.xyz.z)
				dio.clientChat.send ("Coords for " .. author .. " = (" .. x .. ", " .. y .. ", " .. z .. ")")
			end
		end
	
	else
		return false
	end

	return true
end

--------------------------------------------------
local function onLoadSuccessful ()

	local types = dio.events.types
	dio.events.addListener (types.CLIENT_CHAT_MESSAGE_PRE_SENT, onChatMessagePreSent)
end

--------------------------------------------------
local modSettings =
{
	name = "Spawn",

	description = "Coordinate related shenanigans",
	author = "AmazedStream",
	help = 
	{
		[".spawn"] = 	{usage = ".spawn", 		description = "teleports you to the safe spawn"},
		[".tp"] = 		{usage = ".tp x y z", 	description = "teleports you coordinates (x, y, z)"},
		[".coords"] = 	{usage = ".coords ", 	description = "prints your or N players coordinates"},
        [".sethome"] =  {usage = ".sethome",    description = "sets a home location for the current session"},
        [".home"] =     {usage = ".home",       description = "teleports you back to your set home location"},
	},

	permissionsRequired =
	{
		client = true,
		player = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
