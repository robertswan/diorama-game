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

	elseif string.sub (text, 1, string.len(".tp "))==".tp " then

		local author = dio.world.getPlayerNames () [1]
		firstWhiteSpace = -1
		secondWhiteSpace = -1
		thirdWhiteSpace = -1

		for i=1, string.len(text), 1 do
			if string.sub(text, i, i) == " " then
				if firstWhiteSpace == -1 then
					firstWhiteSpace = i
				elseif secondWhiteSpace == -1 then
					secondWhiteSpace = i
				elseif thirdWhiteSpace == -1 then
					thirdWhiteSpace = i
					break
				end
			end
		end

		if firstWhiteSpace ~= -1 and secondWhiteSpace ~= -1 and thirdWhiteSpace ~= -1 then
			xPosString = string.sub(text, firstWhiteSpace+1,secondWhiteSpace)
			yPosString = string.sub(text, secondWhiteSpace+1,thirdWhiteSpace)
			zPosString = string.sub(text, thirdWhiteSpace+1,string.len(text))

			teleportTo (author, math.floor(xPosString), math.floor(yPosString), math.floor(zPosString))
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
	},

	permissionsRequired =
	{
		client = true,
		player = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
