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
                    baseVoxel = -16,
                    heightInVoxels = 32,
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
                    type = "addGrass",
                    mudHeight = 4,
                },
            },
		},
	},
    roomShape = 
    {
        y = 
        {
            max = 0,
            min = -1,
        },        
    },  
	randomSeedAsString = "wobble",
	terrainId = "paramaterized",
}

return roomSettings
