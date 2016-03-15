--------------------------------------------------
local motdAuthor = "MOTD"
local motd = "(http://twitch.tv/RobTheSwan) Press T to chat. Type '.help' in chat for available commands."

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function onPlayerLoad (event)

    dio.serverChat.send (event.connectionId, motdAuthor, motd)

end

--------------------------------------------------
local function onChatReceived (event)

    if event.text:sub (1, 1) ~= "." then
        return
    end

    if event.text == ".motd" then

        event.targetConnectionId = event.authorConnectionId
        event.author = motdAuthor
        event.text = motd

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
