-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
    version = 
    {
        major = 2,    
        minor = 0,
    },

    generators = 
    {
        {
            resources = 
            {
                blockModelFiles =
                {
                    "test_models_00.lua",
                },
            },

            weightPass =
            {
                {
                    type = "gradient",
                    mode = "replace",

                    baseVoxel = -256,
                    heightInVoxels = 256,
                },
                {
                    type = "pillars",
                    mode = "add",

                    baseVoxel = -256,
                    heightInVoxels = 256,
                    --heightInVoxels = {min = 128, max = 256},
                    min = 0,
                    max = 0.8,
                    outerRadius = 6,
                    --outerRadius = {min = 4, max = 6},
                    innerRadius = 2,
                    chance = 0.0005,
                    randomSeed = 12356,
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

            voxelPass =
            {
                {
                    type = "addBlockModel",
                    id = "fence",
                    chance = 0.01,
                    randomSeed = 908322,
                },               
                {
                    type = "addBlockModel",
                    id = "rockpile00",
                    chance = 0.002,
                    randomSeed = 654324,
                },    
                {
                    type = "addBlockModel",
                    id = "rockpile01",
                    chance = 0.004,
                    randomSeed = 57483,
                },    
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
            },
        },
    },
    randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
