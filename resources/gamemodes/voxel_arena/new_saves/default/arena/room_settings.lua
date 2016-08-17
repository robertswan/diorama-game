-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
	generators = 
	{
		
		{
			voxelPass = 
			{
				
				{
					chanceOfTree = 0.005,
					sizeMin = 2,
					sizeRange = 3,
					trunkHeight = 2,
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
					baseVoxel = -64,
					heightInVoxels = 128,
					mode = "replace",
					type = "gradient",
				},
				
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
	randomSeedAsString = "seed0.7337565233314",
	roomShape = 
	{
		x = 
		{
			max = 2,
			min = -2,
		},
		y = 
		{
			max = 2,
			min = -2,
		},
		z = 
		{
			max = 2,
			min = -2,
		},
	},
	terrainId = "paramaterized",
}

return roomSettings
