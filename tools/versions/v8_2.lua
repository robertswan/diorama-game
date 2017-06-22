local t = dio.types.updateTypes
local c = dio.types.components

--------------------------------------------------
local layout =
{
    version =
    {
        major = 8,
        minor = 2,
    },

    update =
    {
        record = function (previous)
            return 
            {
                entities = {previous.chunkEntity},
            }
        end,

        components = 
        {
            c.TRANSFORM = function (previous)
                previous.xyz [1] = previous.xyz [1] + previous.chunkId [1] * 32
                previous.xyz [2] = previous.xyz [2] + previous.chunkId [2] * 32
                previous.xyz [3] = previous.xyz [3] + previous.chunkId [3] * 32
                previous.chunkId = nil
                return previous
            end
        }
    },

    structs = 
    {
        record =
        {
            {entities       = {element = t.ENTITY}},
        },

        entity =
        {
            {id                     = t.U32},
            {roomEntityId           = t.U32},
            {components             = {element = t.COMPONENT, size = s.NULL_COMPONENT}},
            {componentTerminator    = t.STRING}
        },

        components =
        {
            c.TRANSFORM =
            {
                {xyz = t.DVEC3},
                {pyr = t.DVEC3},
                {scale = t.DVEC3},
            }

            c.CHUNK_ID = versions.v1.structs.components [c.CHUNK_ID],

        }
    }
}

return layout