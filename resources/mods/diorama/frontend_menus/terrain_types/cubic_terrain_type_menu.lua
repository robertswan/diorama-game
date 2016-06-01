--------------------------------------------------
local BaseTerrainTypeMenu = require ("resources/mods/diorama/frontend_menus/terrain_types/base_terrain_type_menu")

--------------------------------------------------
local basicGenerator =
{
    weightPass =
    {
        {
            type = "cubeGradient",
            mode = "replace",

            x = -64,
            y = -128,
            z = -64,
            w = 128,
            h = 128,
            d = 128,

            rangeInVoxels = 48,
        },
        {
            type = "perlinNoise",
            mode = "lessThan",

            scale = 16,
            octaves = 2,
            perOctaveAmplitude = 0.5,
            perOctaveFrequency = 2.0,
        },
    },

    -- Q: where do we convert weights, into voxel data?

    voxelPass =
    {
        {
            type = "addTrees",
            chanceOfTree = 0.01,
            sizeRange = 4,
            sizeMin = 2,
            trunkHeight = 3,
        },
        {
            type = "addGrass",
            mudHeight = 4,
        },
    }
}

--------------------------------------------------
local options =
{
}

--------------------------------------------------
return function ()

    local properties =
    {
        description =       "Create a Cubic Level",
        terrainId =         "paramaterized",
        terrainVersion =    1,
        options =           options,
        generators =        {basicGenerator},
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
