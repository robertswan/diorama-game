local Resources = require ("resources/scripts/utils/resources")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function addPlayerModel (id)
    return
    {
        id = id,
        filename = "models/characters/" .. id .. ".vox",
        options = {scale = {1/8, 1/8, 1/8}, translate = {-0.5, 0, -0.5}, rotate180 = true},
    }
end

--------------------------------------------------
local entityModels =
{
    chr_nurse = addPlayerModel ("chr_nurse"),
}
local loadedEntityModels = {}

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
                [c.CAMERA] =                
                {   
                    fov = 90, 
                    attachTo = event.entityId, 
                    isMainCamera = true,
                },
                [c.PARENT] =                {parentEntityId = event.roomEntityId},
                [c.TRANSFORM] =             {},
            }

            local cameraEntityId = dio.entities.create (event.roomEntityId, camera)
            dio.drawing.setMainCamera (cameraEntityId)
        end
    end
end

--------------------------------------------------
local function onResourceRequired (event)
    --if event.resourceType == dio.types.resourceTypes.REGULAR_MODEL then
        local toLoad =
        {
            entityModels [event.resourceId]
        }
        Resources.loadEntityModels (toLoad)
        table.insert (loadedEntityModels, {id = event.resourceId})
        event.cancel = true
    --end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
        myConnectionId = nil,
        myAccountId = nil,
        crosshairTexture = dio.resources.loadTexture ("CROSSHAIR", "textures/crosshair_00.png"),
    }

    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)

    local types = dio.types.clientEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)
    --dio.events.addListener (types.RESOURCE_REQUIRED, onResourceRequired)

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
        name = "Mob Test",
        description = "This is required to play the mob test!",
        help =
        {
        },
    },

    permissionsRequired =
    {
        drawing = true,
        entities = true,
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
