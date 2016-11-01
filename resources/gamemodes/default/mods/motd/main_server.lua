--------------------------------------------------
local motdAuthor = "MOTD"
local motd = "(http://twitch.tv/RobTheSwan) Press T to chat. Type '.help' in chat for available commands."

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function onClientConnected (event)

    dio.network.sendChat (event.connectionId, motdAuthor, motd)

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
local function onLoad ()

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)

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
        network = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
