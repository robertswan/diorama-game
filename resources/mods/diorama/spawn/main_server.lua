--------------------------------------------------
local connections = {}

--------------------------------------------------
local function onClientConnected (event)

    local filename = "player_" .. event.accountId .. ".lua"
    local settings = dio.file.loadLua (dio.file.locations.WORLD_PLAYER, filename)

    local isPasswordCorrect = true
    if settings then
        isPasswordCorrect = (settings.accountPassword == event.accountPassword)
    end

    local connection =
    {
        connectionId = event.connectionId,
        groupId = event.isSinglePlayer and "builder" or "tourist",
        isPasswordCorrect = isPasswordCorrect,
    }

    if settings and isPasswordCorrect then
        connection.homeLocation = settings.homeLocation
        connection.needsSaving = true
    end

    connections [event.connectionId] = connection
end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]

    if connection.needsSaving and connection.homeLocation then

        local filename = "player_" .. event.accountId .. ".lua"
        local settings = dio.file.loadLua (dio.file.locations.WORLD_PLAYER, filename)
        if settings then
            settings.homeLocation = connection.homeLocation
            dio.file.saveLua (dio.file.locations.WORLD_PLAYER, filename, settings, "settings")
        end
    end

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onChatReceived (event)

    if event.text:sub (1, 1) ~= "." then
        return
    end

    if event.text == ".home" then

        local connection = connections [event.authorConnectionId]

        if connection.homeLocation then
            local t = connection.homeLocation
            event.author = ".home"
            event.text = 
                tostring (t.chunkId [1] * 32 + t.xyz [1]) .. " " .. 
                tostring (t.chunkId [2] * 32 + t.xyz [2]) .. " " .. 
                tostring (t.chunkId [3] * 32 + t.xyz [3])
        else
            event.author = "SERVER"
            event.text = "No home position set."
        end

        event.targetConnectionId = event.authorConnectionId

    elseif event.text == ".setHome" then

        homeLocation = dio.world.getPlayerXyz (event.author)
        if homeLocation then
            local connection = connections [event.authorConnectionId]
            connection.homeLocation = homeLocation
    
            event.text = "Home successfully set."

        else
            event.text = "Home NOT successfully set."
        end

        event.author = "SERVER"
        event.targetConnectionId = event.authorConnectionId
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.types
    dio.events.addListener (types.SERVER_CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.SERVER_CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.SERVER_CHAT_RECEIVED, onChatReceived)
end

--------------------------------------------------
local modSettings = 
{
    description =
    {
        name = "Spawn",
        description = "Coordinate related shenanigans",
    },

    permissionsRequired = 
    {
        player = true,
        file = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
