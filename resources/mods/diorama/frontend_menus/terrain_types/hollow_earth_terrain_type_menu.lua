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

            x = -16,
            y = -32,
            z = -16,
            w = 32,
            h = 32,
            d = 32,

            rangeInVoxels = -8,
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
        description =       "Create Hollow Cubic Level",
        terrainId =         "paramaterized",
        terrainVersion =    1,
        options =           options,
        generators =        {basicGenerator},
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
