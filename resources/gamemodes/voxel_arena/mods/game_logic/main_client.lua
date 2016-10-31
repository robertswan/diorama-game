--------------------------------------------------
local instance = nil

--------------------------------------------------
local function onLateRender (self)

    local windowW, windowH = dio.drawing.getWindowSize ()
    local params = dio.resources.getTextureParams (self.crosshairTexture)
    params.width = params.width * 3
    params.height = params.height * 3

    dio.drawing.drawTexture2 (
            self.crosshairTexture,
            (windowW - params.width) * 0.5,
            (windowH - params.height) * 0.5,
            params.width,
            params.height)
end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "voxel_arena.JOIN_GAME" or event.id == "voxel_arena.BEGIN_GAME" then

        -- dio.inputs.setPlayerBlockId (1, 0) -- air, but will be changed to jump pad (10)

    elseif event.id == "voxel_arena.EXPLOSION" then
        
        -- unpack the data
        local unpacked_payload = {}
        for word in string.gmatch (event.payload, "[^:]+") do
            table.insert (unpacked_payload, word)
        end

        local data =
        {
            roomEntityId = tonumber (unpacked_payload [1]),
            chunkId = 
            {
                tonumber (unpacked_payload [2]),
                tonumber (unpacked_payload [3]),
                tonumber (unpacked_payload [4]),
            },
            xyz = 
            {
                tonumber (unpacked_payload [5]),
                tonumber (unpacked_payload [6]),
                tonumber (unpacked_payload [7]),
            },
        }

        --dio.entities.createParticleEmitter (data)

        event.cancel = true
    end
end

--------------------------------------------------
local function onClientConnected (event)
    local self = instance
    if event.isMe then
        self.myConnectionId = event.connectionId
        self.myAccountId = event.accountId
    end
end

--------------------------------------------------
local function onNamedEntityCreated (event)

    if event.name == "PLAYER_EYE_POSITION" then

        local c = dio.entities.components
        
        local parentEntityId = dio.entities.getComponent (event.entityId, c.PARENT).parentEntityId
        local player = dio.entities.getComponent (parentEntityId, c.TEMP_PLAYER)

        if player.connectionId == instance.myConnectionId then
        
            local camera = 
            {
                [c.CAMERA] =                {fov = 90},
                [c.PARENT] =                {parentEntityId = event.entityId},
                [c.TRANSFORM] =             {},
            }

            local cameraEntityId = dio.entities.create (event.roomEntityId, camera)
            dio.drawing.setMainCamera (cameraEntityId)
        end
    end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
        crosshairTexture = dio.resources.loadTexture ("CROSSHAIR", "textures/crosshair_00.png")
    }

    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)

    local types = dio.types.clientEvents
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)

    dio.resources.loadTexture ("CHUNKS_DIFFUSE",    "textures/chunks_diffuse_00.png")
    dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png")
    dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_00.png", {isNearest = false})

    dio.resources.loadExtrudedTexture ("CHUNKS_EXTRUDED",    "textures/chunks_extruded_00.png")

end

--------------------------------------------------
local function onUnload ()

    dio.resources.destroyExtrudedTexture ("CHUNKS_EXTRUDED")

    dio.resources.destroyTexture ("CHUNKS_DIFFUSE")
    dio.resources.destroyTexture ("LIQUIDS_DIFFUSE")
    dio.resources.destroyTexture ("SKY_COLOUR")
    dio.resources.destroyTexture ("CROSSHAIR")

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Voxel Arena",
        description = "This is required to play the plummet game!",
        help =
        {
        },
    },

    permissionsRequired =
    {
        drawing = true,
        entities = true,
        inputs = true,
        resources = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
        onUnload = onUnload,
    },
}

--------------------------------------------------
return modSettings
