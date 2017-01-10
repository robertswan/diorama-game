-- repeatedly generated file. not safe to hand edit

local operations = dio.types.csgOperations
local primitives = dio.types.csgPrimitives

local roomSettings =
{
    version = 
    {
        major = 3,    
        minor = 0,
    },

    references = 
    {
        bigObject =
        {
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
                    innerWeight = 0.75,
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
                            innerWeight = 0.75,
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
                    innerRadius = 20,
                    shellSize = 60,
                    blockId = 3,

                    translate = {0, 85, 0},
                    scale = {2.0, 0.5, 1.0},
                },
            },            
        },        
    },

    generators = 
    {
        rotate = {0.3, 0.0, -0.3},
        operation = operations.MORE_THAN,
        operands =
        {
            {   
                scale = {1.1, 0.7, 1.1},
                referenceId = "bigObject",
            },
            {
                primitive = primitives.PERLIN_NOISE,
                randomSeed = 5743829,
                octaveScale = 16,
                octaves = 3,
                perOctaveAmplitude = 0.5,
                perOctaveFrequency = 2.0,
            },            
        },
    },
    randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
