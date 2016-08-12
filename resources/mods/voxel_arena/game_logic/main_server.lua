--------------------------------------------------
local generators =
{
    {
        voxelPass =
        {
            {
                chanceOfTree = 0.005,
                sizeMin = 2,
                sizeRange = 3,
                trunkHeight = 2,
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
                baseVoxel = -64,
                heightInVoxels = 128,
                mode = "replace",
                type = "gradient",
            },
            {
                mode = "lessThan",
                octaves = 4,
                perOctaveAmplitude = 0.5,
                perOctaveFrequency = 2,
                scale = 64,
                type = "perlinNoise",
            },
        },
    },
}

--------------------------------------------------
local roomSettings =
{
    ["arena/"] =
    {
        time = 12 * 60 * 60,
        timeMultiplier = 0,
    },

    ["waiting_room/"] =
    {
        time = 0 * 60 * 60,
        timeMultiplier = 2000,
    },
}

--------------------------------------------------
local instance = 
{
    isPlaying = false,
    connections = {},
    connectionsCount = 0,
    readyCount = 0,
    roomEntityIds = {},
    roundTimeLeft = 0,
    timePerRound = 60 * 3,
    livesPerPlayer = 5,
    rocketEntityIds = {},
    nextRoundCanBePlayed = true,
}

--------------------------------------------------
local function comparer (lhs, rhs)

    if lhs.kills == rhs.kills then
        if lhs.deaths == rhs.deaths then
            return lhs.accountId < rhs.accountId
        else
            return (lhs.deaths < rhs.deaths)
        end
    else
        return (lhs.kills > rhs.kills)
    end
end

--------------------------------------------------
local function broadcastScore (connectionId)

    local scores = {}
    for _, record in pairs (instance.connections) do
        table.insert (scores, record)
    end

    table.sort (scores, comparer)

    local text = ""
    for _, score in ipairs (scores) do

        text = text ..
                score.accountId ..
                ":" ..
                tostring (score.kills) ..
                ":" ..
                tostring (score.deaths) ..
                ":"
    end

    if connectionId then
        dio.network.sendEvent (connectionId, "voxel_arena.SCORE_UPDATE", text)
    else
        for _, connection in pairs (instance.connections) do
            dio.network.sendEvent (connection.connectionId, "voxel_arena.SCORE_UPDATE", text)
        end
    end

    return scores [1]
end

--------------------------------------------------
local function getCurrentRoomFolder ()
    return instance.isPlaying and "arena/" or "waiting_room/"
end

--------------------------------------------------
local function createNewPlayerEntity (connectionId)

    local chunkId = {0, 0, 0}
    local xyz = {0.5, 0, 0.5}

    if instance.isPlaying then
        local chunkRadius = 2
        chunkId = {math.random (-chunkRadius, chunkRadius), 0, math.random (-chunkRadius, chunkRadius)}
        xyz = {math.random (0, 31) + 0.5, chunkRadius * 32 - 5, math.random (0, 31) + 0.5}
    end

    local playerSettings =
    {
        connectionId = connectionId,
        avatar =
        {
            roomFolder = getCurrentRoomFolder (),
            chunkId = chunkId,
            xyz = xyz,
            ypr = {0, 0, 0}
        },
        gravityDir = 5,
    }

    return dio.world.createPlayer (playerSettings)
end

--------------------------------------------------
local function calcDistanceSqr (chunkIdA, xyzA, chunkIdB, xyzB)
    local chunkSize = 32
    local x = (chunkIdA [1] * chunkSize + xyzA [1]) - (chunkIdB [1] * 32 + xyzB [1])
    local y = (chunkIdA [2] * chunkSize + xyzA [2]) - (chunkIdB [2] * 32 + xyzB [2])
    local z = (chunkIdA [3] * chunkSize + xyzA [3]) - (chunkIdB [3] * 32 + xyzB [3])
    return x * x + y * y + z * z
end

--------------------------------------------------
local function onRocketAndSceneryCollision (event)

    -- dio.entities.destroy (event.entity)

    local payload = 
            tostring (event.roomEntityId) .. ":" ..
            tostring (event.chunkId [1]) .. ":" ..
            tostring (event.chunkId [2]) .. ":" ..
            tostring (event.chunkId [3]) .. ":" ..
            tostring (event.xyz [1]) .. ":" ..
            tostring (event.xyz [2]) .. ":" ..
            tostring (event.xyz [3])

    for _, connection in pairs (instance.connections) do

        dio.network.sendEvent (
                connection.connectionId, 
                "voxel_arena.EXPLOSION", 
                payload);
    end

    local wasScoreUpdated = false
    local rocketFiredBy = instance.rocketEntityIds [event.entityId]

    if rocketFiredBy then

        for _, connection in pairs (instance.connections) do
            local player = dio.world.getPlayerXyz (connection.accountId)
            local distanceSqr = calcDistanceSqr (event.chunkId, event.xyz, player.chunkId, player.xyz)

            if distanceSqr < (4 * 4) then

                connection.livesLeft = connection.livesLeft - 1

                if connection.livesLeft == 0 then

                    local deathText = connection.accountId .. " was killed by " .. rocketFiredBy.accountId
                    local isSuicide = false

                    if connection == rocketFiredBy then
                        isSuicide = true
                        deathText = connection.accountId .. " killed themself"
                    end

                    for _, connection2 in pairs (instance.connections) do
                        dio.network.sendChat (
                                connection2.connectionId, 
                                "SERVER", 
                                deathText)
                    end

                    connection.livesLeft = instance.livesPerPlayer
                    dio.world.destroyPlayer (connection.entityId)
                    connection.entityId = createNewPlayerEntity (connection.connectionId)

                    connection.deaths = connection.deaths + 1
                    if not isSuicide then
                        rocketFiredBy.kills = rocketFiredBy.kills + 1
                    end
                    wasScoreUpdated = true

                end

                dio.network.sendEvent (connection.connectionId, "voxel_arena.HEALTH_UPDATE", tostring (connection.livesLeft))

            end
        end
    end

    if wasScoreUpdated then
        broadcastScore ()
    end

    instance.rocketEntityIds [event.entityId] = nil
end

--------------------------------------------------
local function getRocketEntitySettings ()

    local components = dio.entities.components
    local rocketEntitySettings =
    {
        [components.AABB_COLLIDER] =
        {
            min = {-0.1, -0.1, -0.1},
            size = {0.2, 0.2, 0.2},
        },

        [components.BASE_NETWORK] =
        {
            -- with this line out, we use the regular chooser
            --shouldSync = function (event) return true end,
        },

        [components.COLLISION_LISTENER] =
        {
            onCollision = onRocketAndSceneryCollision,
        },

        [components.MESH_PLACEHOLDER] =
        {
            blueprintId = "ROCKET",
        },

        [components.NAME] =
        {
            name = "ROCKET",
            debug = true,
        },

        [components.PARENT] =
        {
        },

        [components.RIGID_BODY] =
        {
            --velocity = {0.0, 0.0, 0.0},
            --acceleration = {0.0, 0.0, 0.0}
            acceleration = {0.0, -9.806 * 1.0, 0.0},
        },

        [components.TRANSFORM] =
        {
        },
    }

    return rocketEntitySettings
end

--------------------------------------------------
local function createRandomSeed ()
    local seed = "seed" .. tostring (math.random ())
    return seed
end

--------------------------------------------------
local function checkForRoundStart (connectionId)

    if instance.readyCount > instance.connectionsCount / 2 then
    --if instance.readyCount > 1 and instance.readyCount > instance.connectionsCount / 2 then

        dio.file.deleteRoom ("arena/")

        local roomSettings =
        {
            path = "arena/",
            randomSeedAsString = createRandomSeed (),
            terrainId = "paramaterized",
            generators = generators,
            roomShape =
            {
                x = {min = -2, max = 2},
                y = {min = -2, max = 2},
                z = {min = -2, max = 2},
            }
        }

        dio.file.newRoom (dio.session.getWorldFolder (), roomSettings)

        instance.isPlaying = true
        instance.readyCount = 0
        instance.roundTimeLeft = instance.timePerRound

        for _, connection in pairs (instance.connections) do

            dio.network.sendEvent (connection.connectionId, "voxel_arena.BEGIN_GAME", tostring (instance.roundTimeLeft))
            dio.network.sendEvent (connection.connectionId, "voxel_arena.HEALTH_UPDATE", tostring (instance.livesPerPlayer))

            dio.world.destroyPlayer (connection.entityId)
            connection.entityId = createNewPlayerEntity (connection.connectionId)
            connection.isReady = false
            connection.kills = 0
            connection.deaths = 0
        end

        broadcastScore ()

        instance.nextRoundCanBePlayed = false
    end
end

--------------------------------------------------
local function doGameOver ()
    instance.roundTimeLeft = 0
    instance.isPlaying = false

    local winning_connection = broadcastScore ()
    local winning_text = "The winner is " .. winning_connection.accountId

    for _, connection in pairs (instance.connections) do

        dio.network.sendEvent (connection.connectionId, "voxel_arena.END_GAME")

        dio.world.destroyPlayer (connection.entityId)
        connection.entityId = createNewPlayerEntity (connection.connectionId)

        dio.network.sendChat (connection.connectionId, "SERVER", winning_text)
    end    

    instance.rocketEntityIds = {}
end

--------------------------------------------------
local function onClientConnected (event)

    local entityId = createNewPlayerEntity (event.connectionId)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        entityId = entityId,
        kills = 0,
        deaths = 0,
        livesLeft = instance.livesPerPlayer,
    }

    instance.connections [event.connectionId] = connection
    instance.connectionsCount = instance.connectionsCount + 1

    if instance.isPlaying then
        dio.network.sendEvent (connection.connectionId, "voxel_arena.JOIN_GAME", tostring (instance.roundTimeLeft))
        dio.network.sendEvent (connection.connectionId, "voxel_arena.HEALTH_UPDATE", tostring (instance.livesPerPlayer))
    else
        dio.network.sendEvent (connection.connectionId, "voxel_arena.JOIN_WAITING_ROOM")
    end

    broadcastScore ()
end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = instance.connections [event.connectionId]
    dio.world.destroyPlayer (connection.entityId)
    instance.connections [event.connectionId] = nil

    instance.connectionsCount = instance.connectionsCount - 1

    if connection.isReady then
        instance.readyCount = instance.readyCount - 1
    end

    -- check if the game now has zero players
    if instance.connectionsCount == 0 then
        instance.isPlaying = false
    end

    broadcastScore ()

    checkForRoundStart (event.connectionId)
end

--------------------------------------------------
local function fireWeapon (connection)

    local roomEntityId = instance.roomEntityIds [getCurrentRoomFolder ()]

    local avatar = dio.world.getPlayerXyz (connection.accountId)

    local rocketEntitySettings = getRocketEntitySettings ()
    local components = dio.entities.components

    local parent = rocketEntitySettings [components.PARENT]
    parent.parentEntityId = roomEntityId

    local transform = rocketEntitySettings [components.TRANSFORM]
    transform.chunkId = avatar.chunkId
    transform.xyz = avatar.xyz
    transform.ypr = avatar.ypr
    transform.xyz [2] = transform.xyz [2] + 1.0

    local rigidBody = rocketEntitySettings [components.RIGID_BODY]
    rigidBody.forwardSpeed = 30.0

    local rocketEntityId = dio.entities.create (roomEntityId, rocketEntitySettings)
    instance.rocketEntityIds [rocketEntityId] = connection
end

--------------------------------------------------
local function onPlayerPrimaryAction (event)

    local connection = instance.connections [event.connectionId]

    if instance.isPlaying then

        fireWeapon (connection)

    else

        if event.isBlockValid and event.destinationBlockId == 18 then -- READY button
            if connection.isReady then

                dio.network.sendChat (connection.connectionId, "SERVER", "You are already READY")
            
            elseif instance.nextRoundCanBePlayed then

                dio.network.sendChat (connection.connectionId, "SERVER", "You are now READY")

                instance.readyCount = instance.readyCount + 1
                connection.isReady = true
                checkForRoundStart (event.connectionId)

            else

                dio.network.sendChat (connection.connectionId, "SERVER", "You are NOT READY. Please try again in a few seconds!")

            end
        end
    end

    event.cancel = true
end

--------------------------------------------------
local function onPlayerSecondaryAction (event)
    -- if event.isBlockValid then
    --     event.sourceBlockId = 10 -- jump pad
    -- end
end

--------------------------------------------------
local function onRoomCreated (event)

    instance.roomEntityIds [event.roomFolder] = event.roomEntityId

    local roomSettings = roomSettings [event.roomFolder]

    local components = dio.entities.components
    local calendarEntity =
    {
        [components.BASE_NETWORK] =
        {
        },
        [components.CALENDAR] =
        {
            time =  roomSettings.time,
            timeMultiplier = roomSettings.timeMultiplier,
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

    if event.roomFolder == "arena/" then
        dio.file.deleteRoom ("arena/")
        instance.nextRoundCanBePlayed = true
    end

end

--------------------------------------------------
local function onServerTick (event)

    if instance.isPlaying then
        instance.roundTimeLeft = instance.roundTimeLeft - event.timeDelta
        if instance.roundTimeLeft < 0 then
            doGameOver ()
        end
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.serverTypes
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ENTITY_PLACED, onPlayerPrimaryAction)
    -- dio.events.addListener (types.ENTITY_DESTROYED, onPlayerSecondaryAction)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    dio.events.addListener (types.ROOM_DESTROYED, onRoomDestroyed)
    dio.events.addListener (types.TICK, onServerTick)

    math.randomseed (os.time ())

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Voxel Arena",
        description = "This is required to play the SHOOT IN FACE game!",
    },

    permissionsRequired =
    {
        entities = true,
        events = true,
        file = true,
        network = true,
        session = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
