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
                    baseVoxel = 0,
                    heightInVoxels = 80,
                },
                {
                    type = "gradient",
                    mode = "max",

                    --axis = "y",
                    baseVoxel = 128,
                    heightInVoxels = -80,
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
                    chanceOfTree = 0.001,
                    sizeRange = 3,
                    sizeMin = 3,
                    trunkHeight = 20,
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
