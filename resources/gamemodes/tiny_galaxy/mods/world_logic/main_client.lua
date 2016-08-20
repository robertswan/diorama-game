local BlockDefinitions = require ("resources/gamemodes/tiny_galaxy/mods/blocks/block_definitions")

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
local function teleportBy (x, y, z)

    local settings = dio.world.getPlayerXyz (instance.accountId)

    settings.xyz [1] = settings.xyz [1] + x
    settings.xyz [2] = settings.xyz [2] + y
    settings.xyz [3] = settings.xyz [3] + z
    
    dio.world.setPlayerXyz (instance.accountId, settings)
end


--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "tinyGalaxy.TP" then

        print ("tinyGalaxy.TP = " .. event.payload)

        local words = {}
        for word in string.gmatch (event.payload, "[^ ]+") do
            table.insert (words, word)
        end

        teleportBy (words [1], words [2], words [3])

        event.cancel = true

    end
end

--------------------------------------------------
local function onLoad ()

    local types = dio.events.clientTypes
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived) 

    dio.resources.loadTexture ("CHUNKS_DIFFUSE",    "textures/chunks_diffuse_tiny_galaxy.png")
    dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png")
    dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_tiny_galaxy.png", {isNearest = false})

end

--------------------------------------------------
local function onUnload ()

    dio.resources.destroyTexture ("CHUNKS_DIFFUSE")
    dio.resources.destroyTexture ("LIQUIDS_DIFFUSE")
    dio.resources.destroyTexture ("SKY_COLOUR")

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
