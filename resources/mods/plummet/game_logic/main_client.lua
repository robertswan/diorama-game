--------------------------------------------------
local instance = nil

--------------------------------------------------
local colors = 
{
    ok = "%8f8",
    bad = "%f00",
}

--------------------------------------------------
local function teleportTo (x, y, z)
    setting =
    {
        chunkId = {x = 0, y = 0, z = 0},
        xyz = {x = tonumber (x), y = tonumber (y), z = tonumber (z)},
        ypr = {x = 0, y = 0, z = 0}
    }

    dio.world.setPlayerXyz (instance.myAccountId, setting)
end

--------------------------------------------------
local function onChatReceived (author, text)

    if author == "PLUMMET_TP" then

        local words = {}
        for word in string.gmatch(text, "[^ ]+") do
            table.insert (words, word)
        end        

        teleportTo (words [1], words [2], words [3])

        return true

    end
end

--------------------------------------------------
local function onClientConnected (event)
    local self = instance
    if event.isMe then
        self.myAccountId = event.accountId
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance = 
    {
        myAccountId = nil,
    }
    
    local types = dio.events.types
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatReceived)
    dio.events.addListener (types.CLIENT_CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatReceived)

end

--------------------------------------------------
local modSettings = 
{
    description =
    {
        name = "Plummet",
        description = "This is required to play the plummet game!",
        help =
        {
        },
    },

    permissionsRequired = 
    {
        player = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
