--------------------------------------------------
local connections = {}

--------------------------------------------------
local function createPlayerEntity (connectionId, accountId)
    
    local roomEntityId = dio.world.ensureRoomIsLoaded ("default/")

    local components = dio.entities.components
    local playerComponents =
    {
        [components.BASE_NETWORK] =         {},
        [components.CHILD_IDS] =            {},
        [components.FOCUS] =                {connectionId = connectionId, radius = 4},
        [components.GRAVITY_TRANSFORM] =
        {
            chunkId =       {0, 0, 0},
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
    
    return playerEntityId, eyeEntityId, roomEntityId
end

--------------------------------------------------
local function createMobEntity (chunkEntityId, roomEntityId)
    local c = dio.entities.components
    local e = dio.entities.events
    local components =
    {
        [c.BASE_NETWORK] =          {},
        [c.EVENTS] =                {{event = e.ON_TICK, callbackId = "MOB_ON_TICK", shouldBroadcast = false}},
        [c.MESH_PLACEHOLDER] =      {blueprintId = "test_entity_model"},
        [c.NAME] =                  {name = "MOB"},
        [c.PARENT] =                {parentEntityId = chunkEntityId},
        [c.TRANSFORM] = -- should be GRAVITY_TRANSFORM
        {
            chunkId =       {0, 0, 0},
            xyz =           {2, 2, 2},
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
    }

    local mobEntityId = dio.entities.create (roomEntityId, components)
    return mobEntityId
end

--------------------------------------------------
local function onClientConnected (event)

    local playerEntityId, eyeEntityId, roomEntityId = createPlayerEntity (event.connectionId, event.accountId)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        entityId = playerEntityId,
    }

    connections [event.connectionId] = connection
end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]

    if connection.entityId then
        dio.entities.destroy (connection.entityId)
        connection.entityId = nil
    end

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onChunkGenerated (event)

    if not event.wasLoaded and
            event.chunkId [1] == 0 and
            event.chunkId [2] == 0 and
            event.chunkId [3] == 0 then

        createMobEntity (event.chunkEntityId, event.roomEntityId)
    end
end

--------------------------------------------------
local function getDelta (t1, t2)
    return 
    {
        (t2.xyz [1] - t1.xyz [1]) + (t2.chunkId [1] - t1.chunkId [1]) * 32,
        (t2.xyz [2] - t1.xyz [2]) + (t2.chunkId [2] - t1.chunkId [2]) * 32,
        (t2.xyz [3] - t1.xyz [3]) + (t2.chunkId [3] - t1.chunkId [3]) * 32,
    }
end

--------------------------------------------------
local function onMobTick (event)
    
    for _, connection in pairs (connections) do

        local c = dio.entities.components

        local speed = 0.1
        local tolerance = 1

        local transform = dio.entities.getComponent (event.entityId, c.TRANSFORM)
        local playerTransform = dio.entities.getComponent (connection.entityId, c.TRANSFORM)

        local delta = getDelta (transform, playerTransform)
        if delta [1] < -tolerance then transform.xyz [1] = transform.xyz [1] - speed end
        if delta [1] > tolerance then transform.xyz [1] = transform.xyz [1] + speed end
        if delta [3] < -tolerance then transform.xyz [3] = transform.xyz [3] - speed end
        if delta [3] > tolerance then transform.xyz [3] = transform.xyz [3] + speed end

        -- if dio.entities.isLoadedChunk (transform) then
             dio.entities.setComponent (event.entityId, c.TRANSFORM, transform)
        -- end

        break

    end
end

--------------------------------------------------
local function onLoad ()

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.CHUNK_GENERATED, onChunkGenerated)

    local callbacks =
    {
        MOB_ON_TICK =       onMobTick,
    }

    dio.entities.registerEventCallbacks (callbacks)
end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Mob Test",
        description = "This is required to play the mob test!",
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
