--------------------------------------------------
local BaseTerrainTypeMenu = require ("resources/mods/diorama/frontend_menus/terrain_types/base_terrain_type_menu")

--------------------------------------------------
local basicGenerator = 
{
    weightPass =
    {
        {
            type = "gradient",
            mode = "replace",

            --axis = "y",
            baseVoxel = -64,
            heightInVoxels = 128,
        },        
        {
            type = "gradient",
            mode = "min",

            --axis = "y",
            baseVoxel = 64,
            heightInVoxels = -128,
        },        
        {
            type = "perlinNoise",
            mode = "lessThan",

            scale = 64,
            octaves = 4,
            perOctaveAmplitude = 0.5,
            perOctaveFrequency = 2.0,
        },
    },

    -- Q: where do we convert weights, into voxel data?

    voxelPass =
    {
        {
            type = "addTrees",
            chanceOfTree = 0.003,
            sizeRange = 2,
            sizeMin = 3,
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
        description =       "Create Two Plane Opposite Level",
        terrainId =         "paramaterized",
        terrainVersion =    1,
        options =           options,
        generators =        {basicGenerator},
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
