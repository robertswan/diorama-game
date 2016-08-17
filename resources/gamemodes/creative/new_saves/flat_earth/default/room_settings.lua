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
		},
	},
	randomSeedAsString = "wibble",
	terrainId = "paramaterized",
}

return roomSettings
