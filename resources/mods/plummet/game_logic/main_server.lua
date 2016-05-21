--------------------------------------------------
local groups =
{
    lobby = 
    {
        canDestroy = false,
    },
    waiting = 
    {
        canDestroy = false,
    },
    playing = 
    {
        canDestroy = true,
    }
}

--------------------------------------------------
local colors = 
{
    ok = "%8f8",
    bad = "%f00",
}

--------------------------------------------------
local connections = {}

--------------------------------------------------
local gameVars = 
{
    isPlaying = false,
    waitingOrPlaying = {},
    playersReadyCount = 0,
}

--------------------------------------------------
local function createNewLevel ()
    -- create a box restricted area to join.. make a box out of glass!

    -- dio.levels.deleteAllChunks (false) -- delete all chunks, but keep the settings file

    gameVars.isNewLevel = true;
end

--------------------------------------------------
local function teleportPlayer (connectionId, tpName)

    dio.serverChat.send (connectionId, "PLUMMET", tpName)
end    


--------------------------------------------------
local function onPlayerLoad (event)

    if #connections == 0 then
        createNewLevel ()
    end

    local connection =
    {
        connectionId = event.connectionId,
        playerName = event.playerName,
        screenName = event.playerName,
        groupId = "lobby",
        gravityDir = "DOWN",
    }

    connections [event.connectionId] = connection

    -- local lobby_spawn =
    -- {
    --     chunkId = {x = 0, y = 0, z = 0},
    --     xyz = {x = 7, y = 2, z = 7},
    --     ypr = {x = 0, y = 0, z = 0}
    -- }

    teleportPlayer (event.connectionId, "lobbySpawn")

end

--------------------------------------------------
local function onPlayerSave (event)

    local connection = connections [event.connectionId]
    local group = groups [connection.groupId]

    if connections.groupId == "lobby" then
        -- do nothing

    elseif connections.groupId == "waiting" then

        gameVars.waitingOrPlaying [event.connectionId] = nil
        if connection.isReady then
            gameVars.playersReadyCount = gameVars.playersReadyCount - 1
        end

    elseif connections.groupId == "playing" then

        gameVars.waitingOrPlaying [event.connectionId] = nil
        if #gameVars.waitingOrPlaying < 2 then
            endGame ();
        end
    end

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onEntityPlaced (event)
    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    local connection = connections [event.playerId]
    local canDestroy = groups [connection.groupId].canDestroy
    event.cancel = not canDestroy
end

--------------------------------------------------
local function onChatReceived (event)

    if event.text:sub (1, 1) ~= "." then
        return
    end   

    local words = {}
    for word in string.gmatch(event.text, "[^ ]+") do
        table.insert (words, word)
    end

    local connectionId = event.authorConnectionId
    local connection = connections [connectionId]


    if words [1] == ".join" then

        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "lobby" then
            connection.groupId = "waiting"
            gameVars.waitingOrPlaying [connectionId] = connection
            -- TODO tp player to waiting area
            event.text = colors.ok .. "JOINED NEXT GAME"
        else
            event.text = colors.bad .. ".join refused"
        end

    elseif words [1] == ".leave" then

        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "waiting" then
            connection.groupId = "lobby"
            connection.isReady = false
            gameVars.waitingOrPlaying [connectionId] = nil
            event.text = colors.ok .. "LEFT NEXT GAME"
        else
            event.text = colors.bad .. ".leave refused"
            -- TODO tp player to lobby area
        end        

    elseif words [1] == ".ready" then
        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "waiting" and not connection.isReady then
            connection.isReady = true
            gameVars.playersReadyCount = gameVars.playersReadyCount + 1
            event.text = colors.ok .. "READY"
        else
            event.text = colors.bad .. ".ready refused"

            -- TODO check if game should start!
        end

    elseif words [1] == ".unready" then
        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "waiting" and connection.isReady then
            connection.isReady = false
            gameVars.playersReadyCount = gameVars.playersReadyCount - 1
            event.text = colors.ok .. "UNREADY"
        else
            event.text = colors.bad .. ".unready refused"
        end
    end
end

--------------------------------------------------
local function onChunkGenerated (event)

    if gameVars.isNewLevel and
            event.chunkId.x == 0 and
            event.chunkId.y == 0 and
            event.chunkId.z == 0 then

        for _, connection in pairs (connections) do
            dio.serverChat.send (connection.connectionId, "DEBUG", "onChunkGenerated: " .. event.chunkId.x .. ", " .. event.chunkId.y .. ", " .. event.chunkId.z)
        end

        for k, v in pairs (event) do
            print (k .. " = " .. tostring (v))
        end

        local setBlock = dio.world.setBlock
        for x = 1, 14 do
            for z = 1, 14 do
                setBlock (event.roomId, event.chunkId, x, 1, z, 15)
                for y = 2, 10 do
                    setBlock (event.roomId, event.chunkId, x, y, z, 0)
                end
            end 
        end

        gameVars.isNewLevel = false
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    -- dio.players.setPlayerAction (player, actions.LEFT_CLICK, outcomes.DESTROY_BLOCK)

    local types = dio.events.types
    dio.events.addListener (types.SERVER_PLAYER_LOAD, onPlayerLoad)
    dio.events.addListener (types.SERVER_PLAYER_SAVE, onPlayerSave)
    dio.events.addListener (types.SERVER_ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.SERVER_ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.SERVER_CHAT_RECEIVED, onChatReceived)
    dio.events.addListener (types.SERVER_CHUNK_GENERATED, onChunkGenerated)

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
            join = "blah",
            leave = "blah",
            ready = "blah",
            unready = "blah",
        },
    },

    permissionsRequired = 
    {
        file = true,
        inputs = true,
        player = true,
        serverChat = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
