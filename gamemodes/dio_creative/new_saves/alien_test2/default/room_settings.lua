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
        operation = operations.ADD,
        operands =
        {
            {
                primitive = primitives.SPHERE,
                outerRadius = 30,
                blockId = 3,
                origin = {40, 40, 0},
            },
            {
                primitive = primitives.SPHERE,
                outerRadius = 30,
                blockId = 4,
            },
            {
                primitive = primitives.BOX,
                size = {100, 10, 10},
                blockId = 1,
            },
        },
    },

    -- generators = 
    -- {

    --     operation = operations.LESS_THAN,
    --     operands =
    --     {
    --             {
    --                 primitive = primitives.SPHERE,
    --                 outerRadius = 100,
    --                 blockId = 12,
    --             },
    --         {
    --             primitive = primitives.PERLIN_NOISE,

    --             scale = 128,
    --             octaves = 5,
    --             perOctaveAmplitude = 0.5,
    --             perOctaveFrequency = 2.0,
    --         },    
    --     }
    -- },

    randomSeedAsString = "jgfkdlosgjfkesd",
}

return roomSettings
