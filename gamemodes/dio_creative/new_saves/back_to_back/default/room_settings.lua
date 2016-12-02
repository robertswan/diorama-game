-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
	generators = 
	{
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
            },
		},
	},
	randomSeedAsString = "wibble",
	terrainId = "paramaterized",
}

return roomSettings
