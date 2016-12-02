local settings =
{
    isMap = true,

    cameraSettings =
    {
        projectionType = dio.types.projectionTypes.FPS,
        cameraType = dio.types.cameraTypes.LOOK_AT,
        fov = 30,
        offset = {-4, 16, 16},
    },

    spawn = 
    {
        chunkId =       {-1, 0, 0},
        xyz =           {15, 4, 20},
        ypr =           {0, 0, 0},
        gravityDir =    5,
    },

    teleporters =
    {
        {
            chunkId =       {-1, 0, 0},
            xyz =           {9, 3, 19},
            targetGalaxy = "galaxy_00/",
        }
    },
}

return settings
