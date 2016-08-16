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

        dio.entities.createParticleEmitter (data)

        event.cancel = true
    end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
        crosshairTexture = dio.resources.getTexture ("CHUNKS_DIFFUSE")
    }

    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)

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
    },
}

--------------------------------------------------
return modSettings
