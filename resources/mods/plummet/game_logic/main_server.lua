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
    bad = "%f88",
}

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function fillCube (roomId, chunkId, min, max, value)

    local setBlock = dio.world.setBlock
    for x = min [1], max [1] do
        for y = min [2], max [2] do
            for z = min [3], max [3] do
                setBlock (roomId, chunkId, x, y, z, value)
            end
        end 
    end    
end

--------------------------------------------------
local function buildLobby (roomId, chunkId)
    fillCube (roomId, chunkId, {1, 1, 1}, {30, 4, 30}, 15)
    fillCube (roomId, chunkId, {2, 2, 2}, {29, 6, 29}, 0)
end

--------------------------------------------------
local function buildWaitingRoom (roomId, chunkId)
    fillCube (roomId, chunkId, {1, 25, 1}, {30, 28, 30}, 15)
    fillCube (roomId, chunkId, {2, 26, 2}, {29, 30, 29}, 0)
end

--------------------------------------------------
local gameVars = 
{
    isPlaying = false,
    playersWaitingCount = 0,
    playersReadyCount = 0,
    tickCount = 0,
    gameOverScore = 100,
    chunksToModify = 
    {
        lobby = 
        {
            chunkId = {x =0, y = 0, z = 0},
            isBuilt = false,
            buildFunction = buildLobby,
        },
        waitingRoom =
        {
            chunkId = {x =0, y = -1, z = 0},
            isBuilt = false,
            buildFunction = buildWaitingRoom,
        }
    }
}

--------------------------------------------------
local calcComparerScore = function (player)
    local boundary = gameVars.gameOverScore * 10
    local score = (player.groupId == "ready") and boundary * 2 or 0
    score = score + (player.groupId == "waiting") and boundary * 1 or 0
    score = score + player.score
    return score
end

--------------------------------------------------
local comparer = function (lhs, rhs)
    
    return v (lhs) > calcComparerScore (rhs)
end

--------------------------------------------------
local function updateScores ()

    local scores = {}
    for _, record in pairs (connections) do
        table.insert (scores, record)
    end

    table.sort (scores, comparer)

    local text = ""
    for _, score in ipairs (scores) do
        text = text .. 
                score.playerName .. 
                ((score.groupId == "waiting") and " (W)" or "") ..
                ((not gameVars.isPlaying and score.groupId == "ready") and " (R)" or "") ..
                ":" .. 
                math.floor (score.score) .. 
                ":"
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

    for _, build in pairs (gameVars.chunksToModify) do
        build.isBuilt = false
    end
end

--------------------------------------------------
local function startGame ()

    fillCube (0, {x = 0, y = -1, z = 0}, {2, 25, 2}, {29, 25, 29}, 0)

    gameVars.isPlaying = true
    gameVars.tickCount = 0

end   

--------------------------------------------------
local coordinates =
{
    lobby = "15 4 15",
    waitingRoom = "15 -3 15",
}

--------------------------------------------------
local function teleportPlayer (connectionId, coordinatesId)

    dio.serverChat.send (connectionId, "PLUMMET_TP", coordinates [coordinatesId])
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

    for _, connection in pairs (connections) do
        if connection.groupId == "ready" then

            teleportPlayer (connection.connectionId, "lobby")
            connection.groupId = "lobby"
            connection.currentY = 2
            connection.score = 0
        end
    end
    
    gameVars.playersReadyCount = 0
    gameVars.isPlaying = false
    gameVars.tickCount = 0

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
        gravityDir = "DOWN",
        currentY = 2,
        score = 0,
        groupId = "lobby",
    }

    connections [event.connectionId] = connection
    teleportPlayer (connection.connectionId, "lobby")

    updateScores ()

end

--------------------------------------------------
local function onPlayerSave (event)

    local connection = connections [event.connectionId]
    local group = groups [connection.groupId]

    if connection.groupId == "lobby" then
        -- do nothing

    elseif connection.groupId == "waiting" then

        gameVars.playersWaitingCount = gameVars.playersWaitingCount - 1

    elseif connection.groupId == "ready" then

        gameVars.playersReadyCount = gameVars.playersReadyCount - 1

        -- if gameVars.waitingOrPlayingCount < 2 then
        --     endGame ();
        --     createNewGame ();
        -- end
    end

    connections [event.connectionId] = nil

    updateScores ()
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
            gameVars.playersWaitingCount = gameVars.playersWaitingCount + 1
            event.text = colors.ok .. "You have joined the next game. Type '.ready' to begin."
            teleportPlayer (connectionId, "waitingRoom")
            fillCube (0, {x = 0, y = -1, z = 0}, {2, 25, 2}, {29, 25, 29}, 15)
            updateScores ()

        else
            event.text = colors.bad .. "'.join' failed. You have already joined the next game. Type '.ready' to begin."
        end

    elseif words [1] == ".leave" then

        event.targetConnectionId = event.authorConnectionId
        if connection.groupId == "waiting" then
            connection.groupId = "lobby"
            gameVars.playersWaitingCount = gameVars.playersWaitingCount -1
            teleportPlayer (connection.connectionId, "lobby")
            event.text = colors.ok .. "You have left the next game. Type '.join' to rejoin it."
            updateScores ()

        else
            event.text = colors.bad .. "'.leave' failed."
            -- TODO tp player to lobby area
        end        

    elseif words [1] == ".ready" then
        event.targetConnectionId = event.authorConnectionId

        if not gameVars.isPlaying and connection.groupId == "waiting" then

            connection.groupId = "ready"
            gameVars.playersWaitingCount = gameVars.playersWaitingCount - 1
            gameVars.playersReadyCount = gameVars.playersReadyCount + 1
            event.text = colors.ok .. "You are now ready. Waiting for all players to be ready too."

            updateScores ()

            if gameVars.playersWaitingCount == 0 and gameVars.playersReadyCount > 0 then
                startGame ()
            end

        else

            event.text = colors.bad .. "'.ready' failed."
        end


    elseif words [1] == ".unready" then
        event.targetConnectionId = event.authorConnectionId
        if not gameVars.isPlaying and connection.groupId == "ready" then

            connection.groupId = "waiting"
            gameVars.playersReadyCount = gameVars.playersReadyCount - 1
            gameVars.playersWaitingCount = gameVars.playersWaitingCount + 1
            event.text = colors.ok .. "You are now unready. Type '.ready' to begin."
            updateScores ()

        else
            event.text = colors.bad .. "'.unready' failed."
        end
    end
end

--------------------------------------------------
local function onChunkGenerated (event)

    for _, build in pairs (gameVars.chunksToModify) do

        if not build.isBuilt and
                build.chunkId.x == event.chunkId.x and
                build.chunkId.y == event.chunkId.y and
                build.chunkId.z == event.chunkId.z then

            build.buildFunction (event.roomId, event.chunkId)
            build.isBuilt = true

        end
    end
end

-------------------------------------------------
local function onTick ()

    if gameVars.isPlaying then

        for k, record in pairs (connections) do

            if record.groupId == "ready" then
                local player = dio.world.getPlayerXyz (record.playerName)
                local newY = player.chunkId.y * 32 + player.xyz.y
                record.score = record.score - (newY - record.currentY)
                record.currentY = newY
            end

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
