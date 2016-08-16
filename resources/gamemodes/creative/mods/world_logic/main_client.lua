--------------------------------------------------
local instance = nil

--------------------------------------------------
local function onLoadSuccessful ()

    instance = 
    {
        resources =
        {
            dio.resources.loadTexture ("CHUNKS_DIFFUSE",     "textures/chunks_diffuse_00.png"),
            dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png"),
            dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_00.png"),
        }        
    }

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
}

--------------------------------------------------
return modSettings, onLoadSuccessful
