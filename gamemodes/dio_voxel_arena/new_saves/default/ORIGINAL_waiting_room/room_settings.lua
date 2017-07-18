-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
	generators = 
	{
		
		{
			voxelPass = 
			{
				{
					mudHeight = 4,
					type = "addGrass",
				},
			},
			weightPass = 
			{
				
				{
					baseVoxel = -64,
					heightInVoxels = 96,
					mode = "replace",
					type = "gradient",
				},
				
				{
					mode = "lessThan",
					octaves = 2,
					perOctaveAmplitude = 0.5,
					perOctaveFrequency = 2,
					scale = 8,
					type = "perlinNoise",
				},
			},
		},
	},
    roomShape = 
    {
        x = 
        {
            max = 1,
            min = -1,
        },
        y = 
        {
            max = 1,
            min = -1,
        },
        z = 
        {
            max = 1,
            min = -1,
        },
    },
    path = "waiting_room",
	randomSeedAsString = "skik",
	terrainId = "paramaterized",
}

return roomSettings
