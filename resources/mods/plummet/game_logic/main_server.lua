--------------------------------------------------
local colors = 
{
    ok = "%8f8",
    bad = "%f88",
}

--------------------------------------------------
local generators = 
{
    
    {
        voxelPass = 
        {
            
            {
                chanceOfTree = 0.03,
                sizeMin = 3,
                sizeRange = 3,
                trunkHeight = 5,
                type = "addTrees",
            },
            
            {
                mudHeight = 4,
                type = "addGrass",
            },
        },
        weightPass = 
        {
            {
                mode = "replace",
                type = "constantWeight",
                constantWeight = 0.40,
            },
            {
                mode = "lessThan",
                octaves = 3,
                perOctaveAmplitude = 0.5,
                perOctaveFrequency = 2,
                scale = 16,
                type = "perlinNoise",
            },
        },
    },
}

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function fillCube (roomEntityId, chunkId, min, max, value)

    local setBlock = dio.world.setBlock
    for x = min [1], max [1] do
        for y = min [2], max [2] do
            for z = min [3], max [3] do
                setBlock (roomEntityId, chunkId, x, y, z, value)
            end
        end 
    end    
end

--------------------------------------------------
local function buildLobby (roomEntityId, chunkId)
    fillCube (roomEntityId, chunkId, {1, 1, 1}, {30, 4, 30}, 15)
    fillCube (roomEntityId, chunkId, {2, 2, 2}, {29, 6, 29}, 0)
end

--------------------------------------------------
local function buildWaitingRoom (roomEntityId, chunkId)
    fillCube (roomEntityId, chunkId, {1, 25, 1}, {30, 28, 30}, 15)
    fillCube (roomEntityId, chunkId, {2, 26, 2}, {29, 30, 29}, 0)
end

--------------------------------------------------
local roomFolders =
{
    "plummet1/",
    "plummet2/",
}

--------------------------------------------------
local gameVars = 
{
    isPlaying = false,
    playersWaitingCount = 0,
    playersReadyCount = 0,
    playersPlayingCount = 0,
    tickCount = 0,
    gameOverScore = 4000,
    chunksToModify = 
    {
        lobby = 
        {
            chunkId = {0, 0, 0},
            isBuilt = false,
            buildFunction = buildLobby,
        },
        waitingRoom =
        {
            chunkId = {0, -1, 0},
            isBuilt = false,
            buildFunction = buildWaitingRoom,
        }
    },
    currentRoomIdx = 1
}

--------------------------------------------------
local playerColors =
{
    lobby =     "%ccc",
    waiting =   "%f88",
    ready =     "%8f8",
    playing =   "%fff",
}

--------------------------------------------------
local calcComparerScore = function (player)
    local boundary = gameVars.gameOverScore * 10
    local score = ((player.groupId == "playing") and boundary * 4 or 0)
    score = score + ((player.groupId == "ready") and boundary * 2 or 0)
    score = score + ((player.groupId == "waiting") and boundary * 1 or 0)
    score = score + player.score
    return score
end

--------------------------------------------------
local comparer = function (lhs, rhs)
    
    return calcComparerScore (lhs) > calcComparerScore (rhs)
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

        local scoreAsText = " "
        if score.score > 0 then
            scoreAsText = tostring (math.floor (score.score))
        end

        text = text .. 
                playerColors [score.groupId] ..
                score.accountId .. 
                ((score.groupId == "waiting") and " (W)" or "") ..
                ((not gameVars.isPlaying and score.groupId == "ready") and " (R)" or "") ..
                ":" .. 
                scoreAsText .. 
                ":"
    end

    -- text = text ..
    --         tostring (gameVars.playersWaitingCount) .. "," ..
    --         tostring (gameVars.playersReadyCount) .. "," ..
    --         tostring (gameVars.playersPlayingCount) ..
    --         ":" ..
    --         "Teazel" ..
    --         ":"

    for _, connection in pairs (connections) do
        dio.serverChat.send (connection.connectionId, "SCORE", text)
    end

    return scores [1]
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
local function createNewLevel (isFirstTime)

    -- create alternate room

    -- local currentRoomFolder = roomFolders [gameVars.currentRoomIdx]
    -- gameVars.currentRoomIdx = #roomFolders - gameVars.currentRoomIdx + 1
    local nextRoomFolder = roomFolders [gameVars.currentRoomIdx]

    local roomSettings =
    {
        path = nextRoomFolder,
        randomSeedAsString = nextRoomFolder,
        terrainId = "paramaterized",
        generators = generators,
        roomShape = 
        {
            x = {min = -1, max = 1},
            z = {min = -1, max = 1},
        }
    }

    -- -- teleport everyone!
    -- for connectionId, connection in pairs (connections) do
    --     dio.world.destroyPlayer (connection.entityId)
    -- end    

    -- dio.file.abortRoom (currentRoomFolder)
    -- dio.file.deleteWorld (currentRoomFolder)
    dio.file.deleteWorld (nextRoomFolder)
    dio.file.newRoom (dio.session.getWorldFolder (), roomSettings)

    -- -- teleport everyone!
    -- for connectionId, connection in pairs (connections) do

    --     -- dio.serverChat.send (connectionId, "Server", roomFolders [gameVars.currentRoomIdx])

    --     local playerParams =
    --     {
    --         connectionId = connectionId,
    --         accountId = connection.accountId,
    --         gravityDir = "DOWN",
    --         roomFolder = nextRoomFolder,
    --         xyz = {}, -- currently unused
    --     }

    --     connection.entityId = dio.world.createPlayer (playerParams)        

    --     -- hack - teleport players via client
    --     teleportPlayer (connectionId, "lobby")
    -- end

    for _, build in pairs (gameVars.chunksToModify) do
        build.isBuilt = false
    end
end

--------------------------------------------------
local function startGame ()

    fillCube (gameVars.mostRecentRoom.entityId, {0, -1, 0}, {2, 25, 2}, {29, 25, 29}, 0)

    gameVars.isPlaying = true
    gameVars.tickCount = 0

    for _, player in pairs (connections) do
        if player.groupId == "ready" then
            player.groupId = "playing"
            player.currentY = 2
        end
        player.score = 0
        dio.serverChat.send (player.connectionId, "START", "Let the game begin!")
    end

    gameVars.playersPlayingCount = gameVars.playersReadyCount
    gameVars.playersReadyCount = 0

end   

--------------------------------------------------
local function endGame ()

    local winner = updateScores ()

    if winner then
        local text = "The winner is: " .. winner.accountId

        for _, connection in pairs (connections) do
            dio.serverChat.send (connection.connectionId, "RESULT", text)
        end    
    end

    for _, connection in pairs (connections) do
        if connection.groupId == "playing" then

            teleportPlayer (connection.connectionId, "lobby")
            connection.groupId = "lobby"
        end
    end
    
    gameVars.playersPlayingCount = 0
    gameVars.isPlaying = false
    gameVars.tickCount = 0

end

--------------------------------------------------
local function onClientConnected (event)

    -- local usersCount = 0
    -- for _, _ in pairs (connections) do
    --     usersCount = usersCount + 1
    -- end

    -- -- is first player on server
    -- if usersCount == 1 then
    --     createNewLevel ()
    -- end

    createNewLevel ()

    local playerParams =
    {
        connectionId = event.connectionId,
        avatar =
        {
            roomFolder = roomFolders [gameVars.currentRoomIdx],
            chunkId = {0, 0, 0},
            xyz = {15, 4, 15},
            ypr = {0, 0, 0}
        },    
        gravityDir = 5,    
    }

    local entityId = dio.world.createPlayer (playerParams)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        -- gravityDir = "DOWN",
        currentY = 2,
        score = 0,
        groupId = "lobby",
        entityId = entityId,
    }

    connections [event.connectionId] = connection

    updateScores ()

end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]

    dio.world.destroyPlayer (connection.entityId)

    if connection.groupId == "lobby" then
        -- do nothing

    elseif connection.groupId == "waiting" then

        gameVars.playersWaitingCount = gameVars.playersWaitingCount - 1
        if gameVars.playersWaitingCount == 0 and gameVars.playersReadyCount > 1 then
            startGame ()
        end

    elseif connection.groupId == "ready" then

        gameVars.playersReadyCount = gameVars.playersReadyCount - 1

    elseif connection.groupId == "playing" then

        gameVars.playersPlayingCount = gameVars.playersPlayingCount - 1

        if gameVars.playersPlayingCount == 0 then
            endGame ();
        end
    end    

    connections [event.connectionId] = nil

    updateScores ()
end

-- --------------------------------------------------
-- local function onPlayerReady (event)
--     teleportPlayer (event.connectionId, "lobby")
-- end

--------------------------------------------------
local function onRoomCreated (event)

    gameVars.mostRecentRoom = 
    {
        folder = event.roomFolder,
        entityId = event.roomEntityId,
    }
end

--------------------------------------------------
local function onEntityPlaced (event)
    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    event.cancel = true
    -- local connection = connections [event.playerId]
    -- local canDestroy = groups [connection.groupId].canDestroy
    -- event.cancel = not canDestroy
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

        if connection.groupId == "lobby" then
            connection.groupId = "waiting"
            gameVars.playersWaitingCount = gameVars.playersWaitingCount + 1
            teleportPlayer (connectionId, "waitingRoom")
            fillCube (gameVars.mostRecentRoom.entityId, {0, -1, 0}, {2, 25, 2}, {29, 25, 29}, 15)
            updateScores ()

            event.text = colors.ok .. "You have joined the next game. Type '.ready' to begin."

        else
            event.text = colors.bad .. "'.join' failed."
        end

    elseif words [1] == ".leave" then

        event.targetConnectionId = event.authorConnectionId
        if connection.groupId == "waiting" then
            connection.groupId = "lobby"
            gameVars.playersWaitingCount = gameVars.playersWaitingCount - 1
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

            if gameVars.playersWaitingCount == 0 and gameVars.playersReadyCount > 0 then
                startGame ()
            end

            updateScores ()

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

    if event.roomEntityId == gameVars.mostRecentRoom.entityId then

        for _, build in pairs (gameVars.chunksToModify) do

            if not build.isBuilt and
                    build.chunkId [1] == event.chunkId [1] and
                    build.chunkId [2] == event.chunkId [2] and
                    build.chunkId [3] == event.chunkId [3] then

                build.buildFunction (event.roomEntityId, event.chunkId)
                build.isBuilt = true

            end
        end
    end
end

-------------------------------------------------
local function onTick ()

    if gameVars.isPlaying then

        for k, record in pairs (connections) do

            if record.groupId == "playing" then
                local player = dio.world.getPlayerXyz (record.accountId)
                if player then
                    local newY = player.chunkId [1] * 32 + player.xyz [1]
                    record.score = record.score - (newY - record.currentY)
                    record.currentY = newY
                end
            end
        end

        gameVars.tickCount = gameVars.tickCount + 1

        if gameVars.tickCount > 20 then

            gameVars.tickCount = 0

            local winner = updateScores ()
            if not winner or winner.score > gameVars.gameOverScore then
                endGame ()
                -- createNewLevel (false)
            end
        end
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    -- dio.players.setPlayerAction (player, actions.LEFT_CLICK, outcomes.DESTROY_BLOCK)

    local types = dio.events.types
    dio.events.addListener (types.SERVER_CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.SERVER_CLIENT_DISCONNECTED, onClientDisconnected)
    -- dio.events.addListener (types.SERVER_PLAYER_READY, onPlayerReady)
    dio.events.addListener (types.SERVER_ROOM_CREATED, onRoomCreated)
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
        world = true,
        serverChat = true,
        session = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
