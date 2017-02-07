local Resources = require ("resources/scripts/utils/resources")

--------------------------------------------------
local entityModels =
{
    {
        id = "player_model",
        filename = "models/characters/chr_priest.vox",
        options = {scale = {1/8, 1/8, 1/8}, translate = {-0.5, 0, -0.5}},
    },
}

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function onLoad ()

    dio.resources.loadTexture ("CHUNKS_DIFFUSE",    "textures/chunks_diffuse_00.png")
    dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png")
    dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_00.png", {isNearest = false})

    dio.resources.loadExtrudedTexture ("CHUNKS_EXTRUDED",    "textures/chunks_extruded_00.png")

    Resources.loadEntityModels (entityModels);

end

--------------------------------------------------
local function onUnload ()

    dio.resources.destroyExtrudedTexture ("CHUNKS_EXTRUDED")

    dio.resources.destroyTexture ("CHUNKS_DIFFUSE")
    dio.resources.destroyTexture ("LIQUIDS_DIFFUSE")
    dio.resources.destroyTexture ("SKY_COLOUR")

    Resources.unloadEntityModels (entityModels);    
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
    },

    callbacks =
    {
        onLoad = onLoad,
        onUnload = onUnload,
    }
}

--------------------------------------------------
return modSettings
