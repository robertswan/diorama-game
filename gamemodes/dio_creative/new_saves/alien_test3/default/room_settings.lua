-- repeatedly generated file. not safe to hand edit

local operations = dio.types.csgOperations
local primitives = dio.types.csgPrimitives
local postProcesses = {APPLY_CRUST = 0}
--dio.types.terrainPostProcesses

local roomSettings =
{
    version = 
    {
        major = 3,    
        minor = 0,
    },

    references = 
    {
        {
            id = "torus",

            operation = operations.ADD,
            operands =
            {
                {
                    primitive = primitives.TORUS,
                    radius = 40,
                    innerRadius = 5,
                    shellSize = 15,
                    innerWeight = 0.8,
                    blockId = 1,

                    rotate = {0, 0, 3.14 * 0.5},
                },
                {
                    primitive = primitives.TORUS,
                    radius = 40,
                    innerRadius = 0,
                    shellSize = 10,
                    innerWeight = 0.6,
                    blockId = 1,

                    translate = {0, 40, 0},
                    rotate = {3.14 * 0.5, 0, 3.14 * 0.5},
                },
            },
        },
    },

    generators = 
    {
        csg =
        {
            operation = operations.MORE_THAN,
            operands =
            {
                {
                    operation = operations.ADD,
                    operands =
                    {
                        {
                            operation = operations.REPEAT,
                            operands =
                            {
                                {
                                    zoneSize = {128, 256, 128},
                                    placeableSize = {32, 0, 32},
                                    chance = 1.0,
                                    randomSeed = 54839584390,
                                },
                                {
                                    referenceId = "torus",
                                    scale = {2, 2, 2},
                                    rotate = {0, 0.5, 0},
                                    translate = {0, -128 + 32, 0},
                                }
                            }
                        },
                        {
                            primitive = primitives.BOX,
                            innerSize = {1000, 128, 1000},
                            shellSize = {0, 8, 0},
                            innerWeight = 1.0,
                            blockId = 1,

                            translate = {0, -128, 0},
                        }, 
                    }
                },
                {
                    primitive = primitives.PERLIN_NOISE,
                    randomSeed = 5743829,
                    octaveScale = 32,
                    octaves = 4,
                    perOctaveAmplitude = 0.5,
                    perOctaveFrequency = 2.0,
                },            
            },
        },

        postProcesses =
        {
            {
                postProcess = postProcesses.APPLY_CRUST,
                srcBlockId = 1,
                dstBlockIds = {1, 2, 2, 3},
            },
            {
                postProcess = postProcesses.APPLY_CRUST,
                srcBlockId = 33,
                dstBlockIds = {33, 32, 31, 30},
            },            
        }
    },
    randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
