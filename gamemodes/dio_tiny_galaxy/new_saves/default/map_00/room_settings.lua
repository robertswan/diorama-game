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
                    baseVoxel = 2,
                    heightInVoxels = 0,
                },
                {
                    type = "perlinNoise",
                    mode = "lessThan",

                    scale = 64,
                    octaves = 5,
                    perOctaveAmplitude = 0.5,
                    perOctaveFrequency = 2.0,
                },
            },

            -- Q: where do we convert weights, into voxel data?

            voxelPass =
            {
                {
                    type = "addGrass",
                    mudHeight = 4,
                },
            }
		},
	},
    roomShape = 
    {
        x = 
        {
            max = 0,
            min = -1,
        },
        y = 
        {
            max = 0,
            min = 0,
        },        
        z = 
        {
            max = 0,
            min = -1,
        },
    },    
	randomSeedAsString = "wibble",
	terrainId = "paramaterized",
}

return roomSettings
