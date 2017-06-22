local BlockDefinitions = require ("gamemodes/dio_tiny_galaxy/mods/blocks/block_definitions")
local Window = require ("resources/scripts/utils/window")

--------------------------------------------------
local instance = 
{
    blocks = BlockDefinitions.blocks,
}

local rooms = {}

--------------------------------------------------
local function onClientConnected (event)

    if event.isMe then
        instance.connectionId = event.connectionId
        instance.accountId = event.accountId
    end
end

--------------------------------------------------
local function teleport (data)

    local settings = dio.world.getPlayerXyz (instance.accountId)

    if data [1] == "delta" then
        settings.xyz [1] = settings.xyz [1] + data [2]
        settings.xyz [2] = settings.xyz [2] + data [3]
        settings.xyz [3] = settings.xyz [3] + data [4]
    else
        settings.xyz = {data [2], data [3], data [4]}
    end
    
    dio.world.setPlayerXyz (instance.accountId, settings)
end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "tinyGalaxy.TP" then

        local words = {}
        for word in string.gmatch (event.payload, "[^ ]+") do
            table.insert (words, word)
        end

        teleport (words)

        event.cancel = true

    elseif event.id == "tinyGalaxy.SKY" then

        local words = {}
        for word in string.gmatch (event.payload, "[^ ]+") do
            table.insert (words, word)
        end

        dio.materials.setValueVec3 (
                instance.skyboxMaterial, 
                "blend", 
                tonumber (words [1]),
                tonumber (words [2]),
                tonumber (words [3]))

        event.cancel = true
    end
end

--------------------------------------------------
local function onSkyboxVariableUpdate (event)

    dio.materials.setValueFloat (instance.skyboxMaterial, "rotation", event.now * 0.001)
end

--------------------------------------------------
local function onNamedEntityCreated (event)

    if event.name == "ROOM" then

        local materialIds =
        {
            "medium_lod_block",
            "medium_lod_block_model",
            "chunk_high",
        }

        -- local material = event.entity.components.materials.medium_lod_block

        local roomEntityId = event.entityId

        local c = dio.entities.components
        local materials = dio.entities.getComponent (roomEntityId, c.MATERIALS)

        for _, value in ipairs (materialIds) do
            local material = materials [value]
            dio.materials.setValueVec3 (material, "lightDir", 0.5, 1.0, 0.25, true)
            dio.materials.setValueVec3 (material, "lightRgb", 0.7, 0.7, 0.3)
            dio.materials.setValueVec3 (material, "ambientRgb", 0.3, 0.3, 0.7)
        end

        local skyboxMaterial = materials.skybox2
        dio.materials.setTextureId (skyboxMaterial, 0, "SKYBOX_STARS_BG")
        dio.materials.setTextureId (skyboxMaterial, 1, "SKYBOX_CLOUDS_00")
        dio.materials.setValueVec3 (skyboxMaterial, "blend", 1.0, 1.0, 1.0, 0.0)

        local c = dio.entities.components
        local skyboxComponents =
        {
            [c.CAMERA_TRACKING_TRANSFORM] = {},
            [c.MESH_RENDERER] = 
            {
                renderOrder = 1,
                blueprintId = "skybox",
                material = skyboxMaterial,
            },
            [c.PARENT] =                    {parentEntityId = roomEntityId},
            [c.VARIABLE_UPDATE] =           {onUpdate = onSkyboxVariableUpdate},
        }

        instance.skyboxEntityId = dio.entities.create (roomEntityId, skyboxComponents)
        instance.skyboxMaterial = skyboxMaterial

    end
end

--------------------------------------------------
local function onLateRender (self)

    local params = dio.resources.getTextureParams (instance.crosshairTexture)
    params.width = params.width * 3
    params.height = params.height * 3

    local windowW, windowH = dio.drawing.getWindowSize ()

    dio.drawing.drawTexture2 (
            instance.crosshairTexture,
            (windowW - params.width) * 0.5,
            (windowH - params.height) * 0.5,
            params.width,
            params.height)
end

--------------------------------------------------
local function onLoad ()

    local types = dio.types.clientEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)

    instance.crosshairTexture =  dio.resources.loadTexture ("CROSSHAIR", "textures/crosshair_00.png"),
    dio.drawing.addRenderPassAfter (1, function () onLateRender () end)

    dio.resources.loadTexture ("CHUNKS_DIFFUSE",    "textures/chunks_diffuse_tiny_galaxy.png")
    dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png")
    dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_tiny_galaxy.png", {isNearest = false})
    dio.resources.loadTexture ("SKYBOX_STARS_BG",   "textures/skybox_stars_bg_00.png", {isCubeMap = true, isNearest = false})
    dio.resources.loadTexture ("SKYBOX_CLOUDS_00",  "textures/skybox_clouds_00.png", {isCubeMap = true, isNearest = false})

    dio.resources.loadExtrudedTexture ("CHUNKS_EXTRUDED",    "textures/chunks_extruded_tiny_galaxy.png")
end

--------------------------------------------------
local function onUnload ()

    dio.resources.destroyExtrudedTexture ("CHUNKS_EXTRUDED")

    dio.resources.destroyTexture ("CHUNKS_DIFFUSE")
    dio.resources.destroyTexture ("LIQUIDS_DIFFUSE")
    dio.resources.destroyTexture ("SKY_COLOUR")
    dio.resources.destroyTexture ("CROSSHAIR")
    dio.resources.destroyTexture ("SKYBOX_STARS_BG")
    dio.resources.destroyTexture ("SKYBOX_CLOUDS_00")

    -- why no unload?
    --dio.resources.unloadModel ("SKYBOX")
    --dio.resources.unloadExtrudedTexture ("CHUNKS_EXTRUDED")

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        id = "creative",
        name = "Creative",
        description = "This is required to play the game!",
        help =
        {
        },
    },

    permissionsRequired =
    {
        drawing = true,
        entities = true,
        materials = true,
        resources = true,
        world = true,
    },

    callbacks =
    {
        onLoad = onLoad,
        onUnload = onUnload,
    }
}

--------------------------------------------------
return modSettings
