--------------------------------------------------
local instance = nil

--------------------------------------------------
local colors = 
{
    ok = "%8f8",
    bad = "%f00",
}

--------------------------------------------------
local function onLateRender (self)

    local windowW, windowH = dio.drawing.getWindowSize ()
    local params = dio.drawing.getTextureParams (self.crosshairTexture)
    params.width = params.width * 3
    params.height = params.height * 3

    dio.drawing.drawTexture2 (
            self.crosshairTexture, 
            (windowW - params.width) * 0.5, 
            (windowH - params.height) * 0.5,
            params.width,
            params.height)
end


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
        crosshairTexture = dio.drawing.loadTexture ("resources/textures/crosshair.png"),
    }

    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)
    
    local types = dio.events.types
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatReceived)
    dio.events.addListener (types.CLIENT_CLIENT_CONNECTED, onClientConnected)

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
        drawing = true,
        player = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
