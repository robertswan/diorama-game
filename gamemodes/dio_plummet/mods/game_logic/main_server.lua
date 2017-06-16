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
local gameVars =
{
    state = "waiting", -- "waiting", "playing", "saving"

    playersWaitingCount = 0,
    playersReadyCount = 0,
    playersPlayingCount = 0,
    tickCount = 0,
    gameOverScore = 100,
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
                ((gameVars.state ~= "playing" and score.groupId == "ready") and " (R)" or "") ..
                ":" ..
                scoreAsText ..
                ":"
    end

    for _, connection in pairs (connections) do
        dio.network.sendEvent (connection.connectionId, "plummet.SCORE", text)
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

    dio.network.sendEvent (connectionId, "plummet.TP", coordinates [coordinatesId])
end

--------------------------------------------------
local function createNewLevel ()

    -- create alternate room
    dio.file.deleteRoom ("dio_plummet/")

    local roomSettings =
    {
        randomSeedAsString = "seed" .. tostring (math.random ()),
        terrainId = "paramaterized",
        generators = generators,
        roomShape =
        {
            x = {min = -1, max = 1},
            z = {min = -1, max = 1},
        }
    }

    dio.file.createFolder (dio.file.locations.WORLD, "dio_plummet/")
    dio.file.saveLua (dio.file.locations.WORLD, "dio_plummet/room_settings.lua", roomSettings, "roomSettings")

end

--------------------------------------------------
local function startGame ()

    fillCube (gameVars.roomEntityId, {0, -1, 0}, {2, 25, 2}, {29, 25, 29}, 0)

    gameVars.state = "playing"
    gameVars.tickCount = 0

    for _, player in pairs (connections) do

        if player.groupId == "ready" then
            player.groupId = "playing"
            player.currentY = 2
        end

        player.score = 0
        dio.network.sendEvent (player.connectionId, "plummet.START")
        dio.network.sendChat (player.connectionId, "START", "Let the game begin!")
    end

    gameVars.playersPlayingCount = gameVars.playersReadyCount
    gameVars.playersWaitingCount = 0
    gameVars.playersReadyCount = 0

end

--------------------------------------------------
local function createPlayerEntity (connectionId, accountId)
    
    local roomEntityId = dio.world.ensureRoomIsLoaded ("dio_plummet/")

    local components = dio.entities.components
    local playerComponents =
    {
            -- [components.AABB_COLLIDER] =        {min = {-0.01, -0.01, -0.01}, size = {0.02, 0.02, 0.02},},
            -- [components.COLLISION_LISTENER] =   {onCollision = onRocketAndSceneryCollision,},
            -- [components.MESH_PLACEHOLDER] =     {blueprintId = "ROCKET",},
            -- [components.RIGID_BODY] =           {acceleration = {0.0, -9.806 * 1.0, 0.0},},
        
        [components.BASE_NETWORK] =         {},
        [components.CHILD_IDS] =            {},
        [components.FOCUS] =                {connectionId = connectionId, radius = 4},
        [components.GRAVITY_TRANSFORM] =
        {
            xyz =           {15, 4, 15},
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
        [components.NAME] =                 {name = "PLAYER"},
        [components.PARENT] =               {parentEntityId = roomEntityId},
        [components.SERVER_CHARACTER_CONTROLLER] =               
        {
            connectionId = connectionId,
            accountId = accountId,
        },
        [components.TEMP_PLAYER] =          {connectionId = connectionId, accountId = accountId},
    }

    local playerEntityId = dio.entities.create (roomEntityId, playerComponents)

    local eyeComponents =
    {
        [components.BROADCAST_WITH_PARENT] =    {},
        [components.CHILD_IDS] =                {},
        [components.NAME] =                     {name = "PLAYER_EYE_POSITION"},
        [components.PARENT] =                   {parentEntityId = playerEntityId},
        [components.TRANSFORM] =                {},
    }

    local eyeEntityId = dio.entities.create (roomEntityId, eyeComponents) 
    
    return playerEntityId, eyeEntityId
end

--------------------------------------------------
local function endGame ()

    local winner = updateScores ()

    if winner then
        local text = "The winner is: " .. winner.accountId

        for _, connection in pairs (connections) do
            dio.network.sendEvent (connection.connectionId, "plummet.RESULT")
            dio.network.sendChat (connection.connectionId, "RESULT", text)
        end
    end

    for connectionId, connection in pairs (connections) do
        if connection.entityId then
            dio.entities.destroy (connection.entityId)
            connection.entityId = nil
        end
    end

    gameVars.state = "saving"

    gameVars.playersPlayingCount = 0
    gameVars.tickCount = 0

end

--------------------------------------------------
local function onClientConnected (event)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        currentY = 2,
        score = 0,
        groupId = "lobby",
    }

    if gameVars.state == "waiting" or gameVars.state == "playing" then
        connection.entityId = createPlayerEntity (event.connectionId, event.accountId)
    end

    connections [event.connectionId] = connection

    updateScores ()

end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]

    if connection.entityId then
        dio.entities.destroy (connection.entityId)
        connection.entityId = nil
    end

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

--------------------------------------------------
local function onRoomCreated (event)

    gameVars.roomEntityId = event.roomEntityId

    local components = dio.entities.components
    local calendarEntity =
    {
        [components.BASE_NETWORK] =
        {
        },
        [components.CALENDAR] =
        {
            time = 12 * 60 * 60,
            timeMultiplier = 2000,
        },
        [components.NAME] =
        {
            name = "CALENDAR",
            debug = false,
        },
        [components.PARENT] =
        {
            parentEntityId = event.roomEntityId,
        },
    }
    
    local calendarEntityId = dio.entities.create (event.roomEntityId, calendarEntity)

end

--------------------------------------------------
local function onRoomDestroyed (event)

    gameVars.roomEntityId = nil

    for _, build in pairs (gameVars.chunksToModify) do
        build.isBuilt = false
    end

    gameVars.state = "waiting"

    createNewLevel ()

    for connectionId, connection in pairs (connections) do
        connection.entityId = createPlayerEntity (connectionId, connection.accountId)
        connection.groupId = "lobby"
    end
end

--------------------------------------------------
local function onEntityPlaced (event)
    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    event.cancel = true
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

        if gameVars.state == "waiting" and connection.groupId == "lobby" then
            connection.groupId = "waiting"
            gameVars.playersWaitingCount = gameVars.playersWaitingCount + 1
            teleportPlayer (connectionId, "waitingRoom")
            fillCube (gameVars.roomEntityId, {0, -1, 0}, {2, 25, 2}, {29, 25, 29}, 15)
            updateScores ()

            event.text = colors.ok .. "You have joined the next game. Type '.ready' to begin."

        else
            event.text = colors.bad .. "'.join' failed."
        end

    elseif words [1] == ".leave" then

        event.targetConnectionId = event.authorConnectionId
        if gameVars.state == "waiting" and connection.groupId == "waiting" then
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

        if gameVars.state == "waiting" and connection.groupId == "waiting" then

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
        if gameVars.state == "waiting" and connection.groupId == "ready" then

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
                build.chunkId [1] == event.chunkId [1] and
                build.chunkId [2] == event.chunkId [2] and
                build.chunkId [3] == event.chunkId [3] then

            build.buildFunction (event.roomEntityId, event.chunkId)
            build.isBuilt = true

        end
    end
end

-------------------------------------------------
local function onTick ()

    if gameVars.state == "playing" then

        for k, record in pairs (connections) do

            if record.groupId == "playing" then
                local player = dio.world.getPlayerXyz (record.accountId)
                if player then
                    local newY = player.xyz [2]
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
            end
        end
    end
end

--------------------------------------------------
local function onLoad ()

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    dio.events.addListener (types.ROOM_DESTROYED, onRoomDestroyed)
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)
    dio.events.addListener (types.CHUNK_GENERATED, onChunkGenerated)
    dio.events.addListener (types.TICK, onTick)

    math.randomseed (os.time ())

    createNewLevel ()

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
        entities = true,
        file = true,
        world = true,
        network = true,
        session = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
