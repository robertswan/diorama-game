local settings =
{
    isMap = true,

    cameraSettings =
    {
        overhead =
        {
            projectionType = dio.types.projectionTypes.FPS,
            cameraType = dio.types.cameraTypes.LOOK_AT,
            fov = 30,
            offset = {-4, 16, 16},
        },
    },

    spawn = 
    {
        xyz =           {15 - 32, 4, 20},
        ypr =           {0, 0, 0},
        gravityDir =    5,
    },

    teleporters =
    {
        {
            xyz =           {9 - 32, 3, 19},
            targetGalaxy = "galaxy_00/",
        }
    },
}

return settings
