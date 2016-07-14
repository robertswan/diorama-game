--------------------------------------------------
local instance = nil

--------------------------------------------------
local function onLateRender (self)

    local windowW, windowH = dio.drawing.getWindowSize ()
    local params = dio.drawing.getTextureParams (self.crosshairTexture)
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
local function onLoadSuccessful ()

    instance = 
    {
        crosshairTexture = dio.drawing.loadTexture ("resources/textures/crosshair.png"),
    }

    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)
    
    -- local types = dio.events.types
    -- dio.events.addListener (types.CLIENT_CLIENT_CONNECTED, onClientConnected)

    -- dio.meshes.loadMesh ("ROCKET", "resources/meshes/rocket_mesh_00.dm")

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
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
