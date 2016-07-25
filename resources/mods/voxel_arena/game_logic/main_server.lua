--------------------------------------------------
local connections = {}

--------------------------------------------------
local function onClientConnected (event)

    local playerSettings =
    {
        connectionId = event.connectionId,
        avatar =
        {
            roomFolder = "default",
            chunkId = {0, 0, 0},
            xyz = {15, 4, 15},
            ypr = {0, 0, 0}
        },    
        gravityDir = 5,    
    }

    local entityId = dio.world.createPlayer (playerSettings)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        entityId = entityId,
    }

    connections [event.connectionId] = connection

end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]
    dio.world.destroyPlayer (connection.entityId)
    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onPlayerPrimaryAction (event)

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
                dio.entities.destroy (event.entity) 
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





    -- pretend nice code on how to create a new rocket entity!

    local connection = connections [event.connectionId]
    local avatar = dio.world.getPlayerXyz (connection.accountId)

    local parent = rocketEntitySettings [components.PARENT]
    parent.parentEntityId = event.roomEntityId

    local transform = rocketEntitySettings [components.TRANSFORM]
    transform.chunkId = avatar.chunkId
    transform.xyz = avatar.xyz
    transform.ypr = avatar.ypr
    transform.xyz [2] = transform.xyz [2] + 1.0

    local rigidBody = rocketEntitySettings [components.RIGID_BODY]
    rigidBody.forwardSpeed = 30.0

    dio.entities.create (rocketEntitySettings)

    event.cancel = true
end

--------------------------------------------------
local function onPlayerSecondaryAction (event)
    event.cancel = true
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.serverTypes
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ENTITY_PLACED, onPlayerPrimaryAction)
    dio.events.addListener (types.ENTITY_DESTROYED, onPlayerSecondaryAction)

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
        world = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
