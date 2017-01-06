-- repeatedly generated file. not safe to hand edit

local operations = dio.types.csgOperations
local operations = dio.types.csgPrimitives

local roomSettings =
{
    version = 
    {
        major = 3,    
        minor = 0,
    },

    generators = 
    {
        primitive = primitives.SPHERE,
        outerRadius = 100,
        blockId = 12,
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
