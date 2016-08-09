--------------------------------------------------
local instance = 
{
    isPlaying = false,
    connections = {},
    connectionsCount = 0,
    readyCount = 0,
    roomEntityIds = {},
    roundTimeLeft = 0,
    timePerRound = 60,
}

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
            onCollision = function (event)

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
                -- dio.blocks.destroySphere (event.entity.getXyz (), 10)
            end
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
local function getCurrentRoomFolder ()
    return instance.isPlaying and "default/" or "waiting_room/"
end

--------------------------------------------------
local function createNewPlayerEntity (connectionId)

    local chunkId = {0, 0, 0}
    local xyz = {0.5, 0, 0.5}

    if instance.isPlaying then
        local chunkRadius = 2
        chunkId = {math.random (-chunkRadius, chunkRadius), 0, math.random (-chunkRadius, chunkRadius)}
        xyz = {math.random (0, 31) + 0.5, 29, math.random (0, 31) + 0.5}
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
local function calcComparerScore (connection)
    local score = connection.kills
    return score
end

--------------------------------------------------
local function comparer (lhs, rhs)
    return calcComparerScore (lhs) > calcComparerScore (rhs)
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
local function checkForRoundStart (connectionId)

    if instance.readyCount > instance.connectionsCount / 2 then
    --if instance.readyCount > 1 and instance.readyCount > instance.connectionsCount / 2 then

        instance.isPlaying = true
        instance.readyCount = 0
        instance.roundTimeLeft = instance.timePerRound

        for _, connection in pairs (instance.connections) do

            dio.network.sendEvent (connection.connectionId, "voxel_arena.BEGIN_GAME", tostring (instance.roundTimeLeft))

            dio.world.destroyPlayer (connection.entityId)
            connection.entityId = createNewPlayerEntity (connection.connectionId)
            connection.isReady = false
            connection.kills = 0
            connection.deaths = 0
        end

        broadcastScore ()
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
    }

    instance.connections [event.connectionId] = connection
    instance.connectionsCount = instance.connectionsCount + 1

    if instance.isPlaying then
        dio.network.sendEvent (connection.connectionId, "voxel_arena.JOIN_GAME", tostring (instance.roundTimeLeft))
    else
        dio.network.sendEvent (connection.connectionId, "voxel_arena.JOIN_WAITING_ROOM")
    end

    broadcastScore (connection.connectionId)
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

    dio.entities.create (roomEntityId, rocketEntitySettings)
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
            else

                dio.network.sendChat (connection.connectionId, "SERVER", "You are now READY")

                instance.readyCount = instance.readyCount + 1
                connection.isReady = true
                checkForRoundStart (event.connectionId)
            end
        end
    end

    event.cancel = true
end

--------------------------------------------------
local function onPlayerSecondaryAction (event)
    event.cancel = true
end

--------------------------------------------------
local function onRoomCreated (event)
    instance.roomEntityIds [event.roomFolder] = event.roomEntityId
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
    dio.events.addListener (types.ENTITY_DESTROYED, onPlayerSecondaryAction)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    dio.events.addListener (types.TICK, onServerTick)

    math.randomseed (os.time ())

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Voxel Arena",
        description = "This is required to play the plummet game!",
    },

    permissionsRequired =
    {
        entities = true,
        events = true,
        network = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
