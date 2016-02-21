--------------------------------------------------
local motd = "(http://twtich.tv/RobTheSwan) Press T to chat. Type '.help' in chat for available commands."

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function onPlayerLoad (event)

	dio.serverChat.send (event.connectionId, motd)

end

--------------------------------------------------
local function onChatReceived (event)

	print ("onChatReceived START")

	if event.text:sub (1, 1) ~= "." then
		return
	end

	print ("onChatReceived MIDDLE")

	if event.text == ".motd" then

		print ("onChatReceived END")
		print (motd)

		event.targetConnectionId = event.authorConnectionId
		event.text = motd

		print (event.text)

	end
end

--------------------------------------------------
local function onLoadSuccessful ()

	local types = dio.events.types
	dio.events.addListener (types.SERVER_PLAYER_LOAD, onPlayerLoad)
	dio.events.addListener (types.SERVER_CHAT_RECEIVED, onChatReceived)

end

--------------------------------------------------
local modSettings = 
{
	description =
	{
		name = "Message of the Day",
		description = "Displays a message when players join.",
		help =
		{
			motd = "Show the message of the day again.",
		},
	},

	permissionsRequired = 
	{
		serverChat = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
