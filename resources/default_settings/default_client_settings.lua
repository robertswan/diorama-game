local clientSettings =
{
    video =
    {
        monitorIdx = 0,
        swapInterval = 1,
        window = {x = 100, y = 100, w = 1600, h = 800},
        hasBorders = true,
    },
    audio =
    {
        mainVolume = 1.0,
    },
    openGl =
    {
        isCoreProfile = true,
        majorVersion = 3,
        minorVersion = 3,
    },
    experimental =
    {
        raymarchSmoothing = false,
        raymarchSmoothingWeight = 0.5,
        mediumLodMeshes = true,
        highLodMeshes = true,
        shadowMaps = true,
        shadowMapResolution = 2048,
        shadowMapRange = 128.0, 
        multiSamples = 0,    
    },
}

return clientSettings
