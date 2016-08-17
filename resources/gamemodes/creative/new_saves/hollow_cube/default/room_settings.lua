-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
	generators = 
	{
		{
            weightPass =
            {
                {
                    type = "hollowCubeGradient",
                    mode = "replace",

                    x = -32,
                    y = 0,
                    z = -32,
                    w = 64,
                    h = 64,
                    d = 64,

                    rangeInVoxels = 64,
                },
                {
                    type = "perlinNoise",
                    mode = "lessThan",

                    scale = 32,
                    octaves = 3,
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
                    sizeRange = 4,
                    sizeMin = 2,
                    trunkHeight = 3,
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
