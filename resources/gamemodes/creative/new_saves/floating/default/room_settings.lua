-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
	generators = 
	{
		{
            voxelPass =
            {

                {
                    chanceOfTree = 0.03,
                    sizeMin = 3,
                    sizeRange = 3,
                    trunkHeight = 5,
                    type = "addTrees",
                },

                {
                    mudHeight = 4,
                    type = "addGrass",
                },
            },
            weightPass =
            {
                {
                    mode = "replace",
                    type = "constantWeight",
                    constantWeight = 0.40,
                },
                {
                    mode = "lessThan",
                    octaves = 3,
                    perOctaveAmplitude = 0.5,
                    perOctaveFrequency = 2,
                    scale = 64,
                    type = "perlinNoise",
                },
            },
		},
	},
	randomSeedAsString = "wibble",
	terrainId = "paramaterized",
}

return roomSettings
