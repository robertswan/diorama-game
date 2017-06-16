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
            xyz =           {2.5, 22.5, 2.5},
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
        [components.NAME] =                 {name = "PLAYER"},
        [components.PARENT] =               {parentEntityId = roomEntityId},
        [components.ROOM_SCOPE] =           {},
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
local function onMobTick (entityId)
    
    for _, connection in pairs (connections) do

        local c = dio.entities.components
        local mob = dio.entities.getComponent (entityId, c.TRANSFORM)
        local player = dio.entities.getComponent (connection.entityId, c.TRANSFORM)
        local speed = 0.2

        if mob.xyz [1] < player.xyz [1] then mob.xyz [1] = math.min (mob.xyz [1] + speed, player.xyz [1]) end
        if mob.xyz [1] > player.xyz [1] then mob.xyz [1] = math.max (mob.xyz [1] - speed, player.xyz [1]) end
        if mob.xyz [3] < player.xyz [3] then mob.xyz [3] = math.min (mob.xyz [3] + speed, player.xyz [3]) end
        if mob.xyz [3] > player.xyz [3] then mob.xyz [3] = math.max (mob.xyz [3] - speed, player.xyz [3]) end

        --if dio.world.isChunkAroundPointLoaded (transform) then
            local res, err = dio.entities.setComponent (entityId, c.TRANSFORM, mob)
        --end

        break

    end
end

--------------------------------------------------
local function createMobEntity (chunkEntityId, roomEntityId)
    local c = dio.entities.components
    local e = dio.entities.events
    
    local mob =
    {
        [c.BASE_NETWORK] =          {},
        [c.CHILD_IDS] =             {},
        --[c.EVENTS] =                {{event = e.ON_TICK, callbackId = "UNUSED_REMOVE_ME", shouldBroadcast = false}},
        [c.MESH_PLACEHOLDER] =      {blueprintId = "test_entity_model"},
        [c.NAME] =                  {name = "MOB"},
        [c.PARENT] =                {parentEntityId = roomEntityId},
        [c.TRANSFORM] = -- should be GRAVITY_TRANSFORM
        {
            xyz =           {2, 12, 2},
            ypr =           {0, 0, 0},
            scale =         {0.1, 0.1, 0.1},
            gravityDir =    5,
        },
    }

    local mobEntityId = dio.entities.create (roomEntityId, mob)
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
local function onNamedEntityCreated (event)
    if event.name == "MOB" then
        local e = dio.entities.entityEvents

        -- dio.entities.addListener (event.entityId, e.ON_TICK, onMobTick)
        dio.entities.addListener (event.entityId, onMobTick)
    end
end

--------------------------------------------------
local function onLoad ()

    local e = dio.types.serverEvents
    dio.events.addListener (e.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (e.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (e.CHUNK_GENERATED, onChunkGenerated)
    dio.events.addListener (e.NAMED_ENTITY_CREATED, onNamedEntityCreated)

    -- remove this!
    --dio.events.registerEntityCreatedCallbacks ("MOB", onMobTick)
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
