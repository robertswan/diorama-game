--------------------------------------------------
local colors = 
{
    ok = "%8f8",
    bad = "%f00",
}

--------------------------------------------------
local function teleportTo (author, x, y, z)
    setting =
    {
        chunkId = {x = 0, y = 0, z = 0},
        xyz = {x = tonumber (x), y = tonumber (y), z = tonumber (z)},
        ypr = {x = 0, y = 0, z = 0}
    }

    dio.world.setPlayerXyz (author, setting)
end

--------------------------------------------------
local function onChatReceived (author, text)

    if author == "PLUMMET_TP" then

        local words = {}
        for word in string.gmatch(text, "[^ ]+") do
            table.insert (words, word)
        end        

        local author = dio.world.getPlayerNames () [1]
        teleportTo (author, words [1], words [2], words [3])

        return true

    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.types
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
