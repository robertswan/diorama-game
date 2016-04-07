--------------------------------------------------
local BaseTerrainTypeMenu = require ("resources/mods/diorama/frontend_menus/terrain_types/base_terrain_type_menu")

--------------------------------------------------
local options =
{
    {
        id = "perlinSize",
        description = "Perlin Initial Size",
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
    {
        id = "solidityChanceOverallOffset",
        description = "Solidity Chance Overall Offset",
        default = 0.2, 
        isInteger = false
    },
}

--------------------------------------------------
return function ()

    local properties =
    {
        description = "Create Floating Islands Level",
        terrainId = "floatingIslands",
        terrainVersion = 1,
        options = options,
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
