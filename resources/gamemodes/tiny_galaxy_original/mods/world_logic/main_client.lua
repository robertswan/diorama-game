local BlockDefinitions = require ("resources/gamemodes/tiny_galaxy/mods/blocks/block_definitions")
local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = 
{
    blocks = BlockDefinitions.blocks,
}

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
        settings.chunkId = {0, 0, 0}
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

    instance.crosshairTexture =  dio.resources.loadTexture ("CROSSHAIR", "textures/crosshair_00.png"),
    dio.drawing.addRenderPassAfter (1, function () onLateRender () end)

    dio.resources.loadTexture ("CHUNKS_DIFFUSE",    "textures/chunks_diffuse_tiny_galaxy.png")
    dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png")
    dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_tiny_galaxy.png", {isNearest = false})

    dio.resources.loadExtrudedTexture ("CHUNKS_EXTRUDED",    "textures/chunks_extruded_tiny_galaxy.png")

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
