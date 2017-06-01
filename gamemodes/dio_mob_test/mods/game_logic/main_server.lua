--------------------------------------------------
local connections = {}
local mob = nil

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
    local components =
    {
        [c.BASE_NETWORK] =         {},
        [c.TRANSFORM] = -- should be GRAVITY_TRANSFORM
        {
            chunkId =       {0, 0, 0},
            xyz =           {2, 2, 2},
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
        [c.MESH_PLACEHOLDER] =      {blueprintId = "test_entity_model"},
        [c.NAME] =                  {name = "MOB"},
        [c.PARENT] =                {parentEntityId = chunkEntityId},
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

    if not event.wasLoaded and not mob and
            event.chunkId [1] == 0 and
            event.chunkId [2] == 0 and
            event.chunkId [3] == 0 then

        mob = createMobEntity (event.chunkEntityId, event.roomEntityId)
    end
end

--------------------------------------------------
local function onNamedEntityCreated (event)
    if event.name == "MOB" then
        mob = event.entityId
        event.cancel = true
    end
end

-- --------------------------------------------------
-- local function onNamedEntityDestroyed (event)
--     if event.name == "MOB" then
--         mob = nil
--         event.cancel = true
--     end
-- end

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
local function onMobTick (entityId)
    
    for _, connection in pairs (connections) do

        local c = dio.entities.components

        local speed = 0.1
        local tolerance = 1

        local transform = dio.entities.getComponent (entityId, c.TRANSFORM)
        local playerTransform = dio.entities.getComponent (connection.entityId, c.TRANSFORM)

        local delta = getDelta (transform, playerTransform)
        if delta [1] < -tolerance then transform.xyz [1] = transform.xyz [1] - speed end
        if delta [1] > tolerance then transform.xyz [1] = transform.xyz [1] + speed end
        if delta [3] < -tolerance then transform.xyz [3] = transform.xyz [3] - speed end
        if delta [3] > tolerance then transform.xyz [3] = transform.xyz [3] + speed end

        dio.entities.setComponent (entityId, c.TRANSFORM, transform)

        break

    end
end

-------------------------------------------------
local function onTick ()

    if mob then
        onMobTick (mob)
    end
end

--------------------------------------------------
local function onLoad ()

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.CHUNK_GENERATED, onChunkGenerated)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)
    --dio.events.addListener (types.NAMED_ENTITY_DESTROYED, onNamedEntityDestroyed)
    dio.events.addListener (types.TICK, onTick)
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
