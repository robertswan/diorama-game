--------------------------------------------------
local BaseTerrainTypeMenu = require ("resources/mods/diorama/frontend_menus/terrain_types/base_terrain_type_menu")

--------------------------------------------------
local options =
{
    {
        id = "base",
        description = "Height Base (voxels)",
        default = 128, 
        isInteger = true
    },
    {
        id = "height",
        description = "Height (voxels above base)",
        default = 128, 
        isInteger = true
    },
    {
        id = "water",
        description = "Water Level (voxels above base)",
        default = 128, 
        isInteger = true
    },
    {
        id = "perlinSize",
        description = "Perlin Start Size (voxels)",
        default = 128, 
        isInteger = true
    },
    {
        id = "perlinOctavesCount",
        description = "Octaves Count",
        default = 5, 
        isInteger = true
    },
    {
        id = "frequencyPerOctave",
        description = "Per Octave Frequency Mulitplier",
        default = 2, 
        isInteger = false
    },
    {
        id = "amplitudePerOctave",
        description = "Per Octave Amplitude Multiplier",
        default = 0.5, 
        isInteger = false
    },
}

--------------------------------------------------
return function ()

    local properties =
    {
        description = "Create Flat Level",
        terrainId = "flat",
        terrainVersion = 1,
        options = options,
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
