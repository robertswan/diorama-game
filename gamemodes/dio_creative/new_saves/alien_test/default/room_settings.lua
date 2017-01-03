-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
    version = 
    {
        id = "paramaterized",
        major = 2,    
    },
	generators = 
	{
		{
            weightPass =
            {
                {
                    type = "gradient",
                    mode = "replace",

                    baseVoxel = -16,
                    heightInVoxels = 16,
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
                    type = "addObject",
                    id = "rockpile00",
                    chance = 0.01,
                    randomModifier = 654324,
                },                
                {
                    type = "addObject",
                    id = "rockpile01",
                    chance = 0.01,
                    randomModifier = 213452,
                },                
            },
		},
	},
	randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
