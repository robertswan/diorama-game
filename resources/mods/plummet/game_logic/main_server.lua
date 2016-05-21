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
    waitingOrPlayingCount = 0,
    playersReadyCount = 0,
    tickCount = 0,
    gameOverScore = 5000,
}

--------------------------------------------------
local function buildLobby (chunkId)

    -- glass walls and air above it

    local setBlock = dio.world.setBlock
    for x = 2, 29 do
        for y = 2, 10 do
            for z = 2, 29 do
                setBlock (0, chunkId, x, y, z, 15)
            end
        end 
    end

    for x = 3, 28 do
        for y = 3, 9 do
            for z = 3, 28 do
                setBlock (0, chunkId, x, y, z, 0)
            end
        end
    end
end

--------------------------------------------------
local function openLobby (chunkId)

    local setBlock = dio.world.setBlock
    for x = 2, 29 do
        for z = 2, 29 do
            setBlock (0, chunkId, x, 2, z, 0)
        end 
    end
end

--------------------------------------------------
local comparer = function (lhs, rhs)
    return lhs.score > rhs.score
end

--------------------------------------------------
local function updateScores ()

    local scores = {}
    for _, record in pairs (gameVars.waitingOrPlaying) do
        table.insert (scores, record)
    end

    table.sort (scores, comparer)

    local text = ""
    for _, score in ipairs (scores) do
        text = text .. score.playerName .. ":" .. math.floor (score.score) .. ":"
    end

    for _, connection in pairs (connections) do
        dio.serverChat.send (connection.connectionId, "SCORE", text)
    end

    return scores [1]
end

--------------------------------------------------
local function createNewLevel ()
    -- create a box restricted area to join.. make a box out of glass!

    -- dio.levels.deleteAllChunks (false) -- delete all chunks, but keep the settings file

    gameVars.isNewLevel = true;
end

--------------------------------------------------
local function startGame ()

    local chunkId = {x = 0, y = 0, z = 0}
    openLobby (chunkId)

    gameVars.isPlaying = true
    gameVars.tickCount = 0

end   

--------------------------------------------------
local function teleportPlayer (connectionId, tpName)

    dio.serverChat.send (connectionId, "PLUMMET", tpName)
end    

--------------------------------------------------
local function endGame ()

    local winner = updateScores ()

    if winner then
        local text = "The winner is: " .. winner.playerName

        for _, connection in pairs (connections) do
            dio.serverChat.send (connection.connectionId, "RESULT", text)
        end    
    end

    for _, connection in pairs (gameVars.waitingOrPlaying) do
        teleportPlayer (connection.connectionId, "lobbySpawn")
        connection.isReady = false
        connection.groupId = "lobby"
        connection.currentY = 2
        connection.score = 0
        gameVars.waitingOrPlaying [connection.connectionId] = nil
        gameVars.waitingOrPlayingCount = gameVars.waitingOrPlayingCount - 1
    end
    
    gameVars.playersReadyCount = 0
    gameVars.isPlaying = false
    gameVars.tickCount = 0
    gameVars.isNewLevel = true

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
        groupId = "lobby",
        gravityDir = "DOWN",
        currentY = 2,
        score = 0,
    }

    connections [event.connectionId] = connection
    teleportPlayer (event.connectionId, "lobbySpawn")

end

--------------------------------------------------
local function onPlayerSave (event)

    local connection = connections [event.connectionId]
    local group = groups [connection.groupId]

    if connection.groupId == "lobby" then
        -- do nothing

    elseif connection.groupId == "waiting" then

        gameVars.waitingOrPlaying [event.connectionId] = nil
        gameVars.waitingOrPlayingCount = gameVars.waitingOrPlayingCount - 1
        if connection.isReady then
            gameVars.playersReadyCount = gameVars.playersReadyCount - 1
        end

    elseif connection.groupId == "playing" then

        gameVars.waitingOrPlaying [event.connectionId] = nil
        gameVars.waitingOrPlayingCount = gameVars.waitingOrPlayingCount - 1

        if gameVars.waitingOrPlayingCount < 2 then
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
            gameVars.waitingOrPlayingCount = gameVars.waitingOrPlayingCount + 1
            -- TODO tp player to waiting area
            event.text = colors.ok .. "JOINED NEXT GAME: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
        else
            event.text = colors.bad .. ".join refused: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
        end

    elseif words [1] == ".leave" then

        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "waiting" then
            connection.groupId = "lobby"
            connection.isReady = false
            gameVars.waitingOrPlaying [connectionId] = nil
            gameVars.waitingOrPlayingCount = gameVars.waitingOrPlayingCount -1
            event.text = colors.ok .. "LEFT NEXT GAME: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
        else
            event.text = colors.bad .. ".leave refused: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
            -- TODO tp player to lobby area
        end        

    elseif words [1] == ".ready" then
        event.targetConnectionId = event.authorConnectionId

        if not gameVars.isPlaying and connection.groupId == "waiting" and not connection.isReady then

            connection.isReady = true
            gameVars.playersReadyCount = gameVars.playersReadyCount + 1
            event.text = colors.ok .. "READY: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount

            updateScores ()

            if gameVars.waitingOrPlayingCount == gameVars.playersReadyCount then
                startGame ()
            end

        else

            event.text = colors.bad .. ".ready refused: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
        end


    elseif words [1] == ".unready" then
        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "waiting" and connection.isReady then
            connection.isReady = false
            gameVars.playersReadyCount = gameVars.playersReadyCount - 1
            event.text = colors.ok .. "UNREADY: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
        else
            event.text = colors.bad .. ".unready refused: " .. gameVars.waitingOrPlayingCount .. ", " .. gameVars.playersReadyCount
        end
    end
end

--------------------------------------------------
local function onChunkGenerated (event)

    if gameVars.isNewLevel and
            event.chunkId.x == 0 and
            event.chunkId.y == 0 and
            event.chunkId.z == 0 then

        -- for _, connection in pairs (connections) do
        --     dio.serverChat.send (connection.connectionId, "DEBUG", "onChunkGenerated: " .. event.chunkId.x .. ", " .. event.chunkId.y .. ", " .. event.chunkId.z)
        -- end

        -- for k, v in pairs (event) do
        --     print (k .. " = " .. tostring (v))
        -- end

        
        buildLobby (event.chunkId)

        gameVars.isNewLevel = false
    end
end

-------------------------------------------------
local function onTick ()

    if gameVars.isPlaying then

        for k, record in pairs (gameVars.waitingOrPlaying) do

            local player = dio.world.getPlayerXyz (record.playerName)
            local newY = player.chunkId.y * 32 + player.xyz.y
            record.score = record.score - (newY - record.currentY)
            record.currentY = newY

        end

        gameVars.tickCount = gameVars.tickCount + 1

        if gameVars.tickCount > 20 then

            gameVars.tickCount = 0

            local winner = updateScores ()
            if winner.score > gameVars.gameOverScore then
                endGame ()
            end
        end
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
    dio.events.addListener (types.SERVER_TICK, onTick)

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
