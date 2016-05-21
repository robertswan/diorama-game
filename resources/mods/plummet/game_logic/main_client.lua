--------------------------------------------------
local colors = 
{
    ok = "%8f8",
    bad = "%f00",
}

--------------------------------------------------
local locations =
{
    lobbySpawn = 
    {
        x = 7, y = 4, z = 7,
    },
}

--------------------------------------------------
local function teleportTo (author, xyz)
    setting =
    {
        chunkId = {x = 0, y = 0, z = 0},
        xyz = xyz,
        ypr = {x = 0, y = 0, z = 0}
    }

    dio.world.setPlayerXyz (author, setting)
end

--------------------------------------------------
local function onChatReceived (author, text)

    if author == "PLUMMET" then

        local words = {}
        for word in string.gmatch(text, "[^ ]+") do
            table.insert (words, word)
        end        

        local author = dio.world.getPlayerNames () [1]
        teleportTo (author, locations [words [1]])

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
