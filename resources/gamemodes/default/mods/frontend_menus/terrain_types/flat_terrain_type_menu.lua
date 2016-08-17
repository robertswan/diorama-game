--------------------------------------------------
local BaseTerrainTypeMenu = require ("resources/gamemodes/default/mods/frontend_menus/terrain_types/base_terrain_type_menu")

--------------------------------------------------
local basicGenerator =
{
    weightPass =
    {
        {
            type = "gradient",
            mode = "replace",

            --axis = "y",
            baseVoxel = -512,
            heightInVoxels = 512,
        },
        {
            type = "perlinNoise",
            mode = "lessThan",

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
            chanceOfTree = 0.005,
            sizeRange = 3,
            sizeMin = 2,
            trunkHeight = 2,
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
        description =       "Create a 'Normal' World",
        terrainId =         "paramaterized",
        terrainVersion =    1,
        options =           options,
        generators =        {basicGenerator},
    }

    local instance = BaseTerrainTypeMenu (properties)
    return instance
end
