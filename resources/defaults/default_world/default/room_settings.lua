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
					mode = "lessThan",
					octaves = 4,
					perOctaveAmplitude = 0.5,
					perOctaveFrequency = 2,
					scale = 64,
					type = "perlinNoise",
				},
			},
		},
	},
	randomSeedAsString = "Teazel",
	terrainId = "paramaterized",
}

return roomSettings
