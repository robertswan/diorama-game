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
                    radius = 80,
                    innerRadius = 5,
                    innerWeight = 0.7,
                    shellSize = 20,
                    blockId = 1,
                },
                {
                    primitive = primitives.TORUS,
                    radius = 80,
                    innerRadius = 5,
                    innerWeight = 0.7,
                    shellSize = 20,
                    blockId = 33,

                    translate = {80, 0, 0},
                    rotate = {3.14 * 0.5, 0, 0},
                },
            },
        },
        {
            id = "torii",
            operation = operations.ADD,
            operands =
            {
                {
                    referenceId = "torus",
                },
                {
                    referenceId = "torus",
                    translate = {200, 0, 0},
                }
            },
        },
        {
            id = "bigObject",
            operation = operations.ADD,
            operands =
            {
                {
                    primitive = primitives.BOX,
                    innerSize = {32, 32, 32},
                    shellSize = {32, 32, 32},
                    blockId = 1,
                },
                {
                    primitive = primitives.BOX,
                    innerSize = {1, 128, 1},
                    shellSize = {25, 25, 25},
                    innerWeight = 1.0,
                    blockId = 1,

                    translate = {48, 32, 48},
                    rotate = {0.5, 0, 0},
                }, 
                {
                    translate = {40, 85, 0},
                    rotate = {0, 0, 0.2},

                    operation = operations.SUBTRACT,
                    operands =
                    {
                        {
                            primitive = primitives.BOX,
                            innerSize = {80, 3, 80},
                            shellSize = {25, 25, 25},
                            innerWeight = 1.0,
                            blockId = 1,

                            translate = {40, 0, 0},
                        },
                        {
                            primitive = primitives.BOX,
                            innerSize = {60, 20, 60},
                            shellSize = {25, 25, 25},
                            innerWeight = 1.0,
                            blockId = 1,

                            translate = {40, 0, 0},
                        },
                    },                    
                },
                {
                    primitive = primitives.SPHERE,
                    innerRadius = 50,
                    shellSize = 30,
                    blockId = 3,

                    translate = {0, 85, 0},
                    scale = {2.0, 0.5, 1.0},
                },
            },            
        },        
    },

    generators = 
    {
        csg =
        {
            rotate = {0.3, 0.0, -0.3},
            scale = {0.3, 0.3, 0.3},
            operation = operations.MORE_THAN,
            operands =
            {
                {   
                    scale = {1.1, 0.7, 1.1},
                    referenceId = "torii",
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
