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

    generators = 
    {
        operation = operations.MORE_THAN,
        operands =
        {
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
                        shellSize = {5, 5, 5},
                        innerWeight = 0.75,
                        blockId = 1,

                        translate = {48, 32, 48},
                        rotate = {0.5, 0, 0},
                    },                    
                    {
                        primitive = primitives.BOX,
                        innerSize = {200, 3, 3},
                        shellSize = {5, 5, 5},
                        innerWeight = 0.75,
                        blockId = 1,

                        translate = {50, 85, 0},
                        rotate = {0, 0, 0.2},
                    },                    
                    {
                        primitive = primitives.SPHERE,
                        innerRadius = 20,
                        shellSize = 20,
                        blockId = 3,

                        translate = {0, 85, 0},
                    },
                },            
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
