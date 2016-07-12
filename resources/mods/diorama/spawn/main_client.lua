--------------------------------------------------
local instance = nil

--------------------------------------------------
local function teleportTo (x, y, z)
    setting =
    {
        chunkId = {0, 0, 0},
        xyz = {x, y, z},
        ypr = {0, 0, 0},
    }

    dio.world.setPlayerXyz (instance.myAccountId, setting)
end

--------------------------------------------------
local function onChatMessagePreSent (text)

    if text == ".spawn" then
        
        teleportTo (0, 128, 0)
        
    elseif string.sub (text, 1, string.len(".tp "))==".tp " then

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
                local x = math.floor (xyz.chunkId [1] * 32 + xyz.xyz [1])
                local y = math.floor (xyz.chunkId [2] * 32 + xyz.xyz [2])
                local z = math.floor (xyz.chunkId [3] * 32 + xyz.xyz [3])
                teleportTo (math.floor(x), math.floor(y), math.floor(z))
            end

        elseif #words == 4 then
            teleportTo (math.floor(words [2]), math.floor(words [3]), math.floor(words [4]))

        end
        
    elseif string.sub(text,1,string.len(".coords"))==".coords" then

        local nameCount = 0
        for accountId in string.gmatch (text, "[%S]+") do

            nameCount = nameCount + 1
            if nameCount > 1 then
                local xyz, error = dio.world.getPlayerXyz (accountId)
                if xyz then
                    local x = math.floor (xyz.chunkId [1] * 32 + xyz.xyz [1])
                    local y = math.floor (xyz.chunkId [2] * 32 + xyz.xyz [2])
                    local z = math.floor (xyz.chunkId [3] * 32 + xyz.xyz [3])
                    dio.clientChat.send ("Coords for " .. accountId .. " = (" .. x .. ", " .. y .. ", " .. z .. ")")
                end
            end
        end

        if nameCount == 1 then
            local xyz, error = dio.world.getPlayerXyz (instance.myAccountId)
            if xyz then
                local x = math.floor (xyz.chunkId [1] * 32 + xyz.xyz [1])
                local y = math.floor (xyz.chunkId [2] * 32 + xyz.xyz [2])
                local z = math.floor (xyz.chunkId [3] * 32 + xyz.xyz [3])
                dio.clientChat.send ("Coords for " .. instance.myAccountId .. " = (" .. x .. ", " .. y .. ", " .. z .. ")")
            end
        end
    
    else
        return false
    end

    return true
end

--------------------------------------------------
local function onChatMessageReceived (author, text)
    if author == ".home" then

        local words = {}
        for word in string.gmatch(text, "[^ ]+") do
            table.insert (words, word)
        end

        local x = tonumber (words [1])
        local y = tonumber (words [2])
        local z = tonumber (words [3])

        local playerId = dio.world.getPlayerNames () [1]
        teleportTo (x, y, z)
    end
end

--------------------------------------------------
local function onClientConnected (event)
    if event.isMe then
        instance.myAccountId = event.accountId
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance =
    {
        myAccountId = nil,
    }

    local types = dio.events.types
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_PRE_SENT, onChatMessagePreSent)
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatMessageReceived)
    dio.events.addListener (types.CLIENT_CLIENT_CONNECTED, onClientConnected)
end

--------------------------------------------------
local modSettings =
{
    name = "Spawn",

    description = "Coordinate related shenanigans",
    author = "AmazedStream",
    help = 
    {
        [".spawn"] =    {usage = ".spawn",         description = "teleports you to the safe spawn"},
        [".tp"] =       {usage = ".tp x y z",     description = "teleports you coordinates (x, y, z)"},
        [".coords"] =   {usage = ".coords ",     description = "prints your or N players coordinates"},
        [".sethome"] =  {usage = ".sethome",    description = "sets a home location for the current session"},
        [".home"] =     {usage = ".home",       description = "teleports you back to your set home location"},
    },

    permissionsRequired =
    {
        drawing = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
