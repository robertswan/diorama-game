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
                        origin = {48, 32, 48},
                        innerWeight = 0.75,
                        blockId = 1,
                    },                    
                    {
                        primitive = primitives.BOX,
                        innerSize = {100, 3, 3},
                        shellSize = {5, 5, 5},
                        origin = {50, 85, 0},
                        innerWeight = 0.75,
                        blockId = 1,
                    },                    
                    {
                        primitive = primitives.SPHERE,
                        innerRadius = 20,
                        shellSize = 20,
                        blockId = 3,
                        origin = {0, 85, 0},
                    },
                },            
            },
            {
                primitive = primitives.PERLIN_NOISE,
                randomSeed = 5743829,
                scale = 32,
                octaves = 3,
                perOctaveAmplitude = 0.5,
                perOctaveFrequency = 2.0,
            },            
        },
    },
    randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
