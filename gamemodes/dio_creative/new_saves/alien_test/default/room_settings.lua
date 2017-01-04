-- repeatedly generated file. not safe to hand edit
local roomSettings =
{
    version = 
    {
        major = 1,    
        minor = 0,
    },

	generators = 
	{
		{
            resources = 
            {
                blockObjectFiles =
                {
                    "test_objects_00",
                },
            },

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
                -- {
                --     type = "addBlockObject",
                --     id = "rockpile00",
                --     chance = 0.005,
                --     randomModifier = 654324,
                -- },                
                -- {
                --     type = "addBlockObject",
                --     id = "rockpile01",
                --     chance = 0.005,
                --     randomModifier = 213452,
                -- },                
            },
		},
	},
	randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
