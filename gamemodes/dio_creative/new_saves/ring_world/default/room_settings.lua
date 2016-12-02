-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
	generators = 
	{
		{
            weightPass =
            {
                {
                    type = "cubeGradient",
                    mode = "replace",

                    x = -24,
                    y = -80,
                    z = -80,
                    w = 48,
                    h = 160,
                    d = 160,

                    rangeInVoxels = 32,
                },
                {
                    type = "hollowCubeGradient",
                    mode = "min",

                    x = -128,
                    y = -32,
                    z = -32,
                    w = 256,
                    h = 64,
                    d = 64,

                    rangeInVoxels = 32,
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
            },
		},
	},
	randomSeedAsString = "wibble",
	terrainId = "paramaterized",
}

return roomSettings
