--------------------------------------------------
local BaseTerrainTypeMenu = require ("resources/mods/diorama/frontend_menus/terrain_types/base_terrain_type_menu")

--------------------------------------------------
local basicGenerator = 
{
    weightPass =
    {
        {
            type = "perlinNoise",
            mode = "replace",

            scale = 128,
            octaves = 5,
            perOctaveAmplitude = 0.5,
            perOctaveFrequency = 2.0,
        },
    },

    -- Q: where do we convert weights, into voxel data?

    voxelPass =
    {
        {
            type = "addTrees",
            chanceOfTree = 0.001,
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
        description =       "Create Floating Islands Level",
        terrainId =         "paramaterized",
        terrainVersion =    1,
        options =           options,
        generators =        {basicGenerator},
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
