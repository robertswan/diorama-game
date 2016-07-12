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
    local settings = 
    {
        [components.TRANSFORM] =
        {
            chunk_id = {0, 0, 0},
            xyz = {0.0, 0.0, 0.0},
        },

        [components.RIGID_BODY] = 
        {
            min = {-0.25, -0.25, -0.25},
            max = {0.25, 0.25, 0.25},
            velocity = {1.0, 0.0, 0.0},

            onCollision = function (event) 
                dio.entities.destroy (event.entity) 
                -- dio.blocks.destroySphere (event.entity.getXyz (), 10)
            end
        },

        [components.MESH_PLACEHOLDER] =
        {
            modelId = "ROCKET",
        }
    }

    local rocketEntity = dio.entities.create (settings)

    event.cancel = true
end

--------------------------------------------------
local function onPlayerSecondaryAction (event)
    event.cancel = true
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.types
    dio.events.addListener (types.SERVER_CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.SERVER_CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.SERVER_ENTITY_PLACED, onPlayerPrimaryAction)
    dio.events.addListener (types.SERVER_ENTITY_DESTROYED, onPlayerSecondaryAction)

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
        player = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
