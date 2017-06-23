local t = dio.types.updateTypes
local c = dio.types.components
local s = dio.types.sizeTerminators

local layout =
{
    create = function (versions)

        return
        {
            version =
            {
                major = 8,
                minor = 1,
            },

            structs = 
            {
                record = {{chunkEntity = t.ENTITY},},
                entity = {{components = {element = t.COMPONENT, size = s.NULL_COMPONENT}}},

                -- components
                BLOCK_LAYER =
                {
                    --{cells = {element = {{blockId = t.U8}, {gravityDir = t.U8}}, size = 32 * 32 * 32}}
                    {cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}}
                },
                BLOCKS_COLLIDER = {},
                CHILD_IDS = {{children = {element = t.ENTITY}}},
                CHUNK_ID = {{chunkId = t.IVEC3}},
                FRAME_OF_REFERENCE_TRANSFORM = {{chunkId = t.IVEC3}, {xyz = t.VEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                NAME = {{name = t.STRING}},
                PARENT = {},
                TRANSFORM = {{chunkId = t.IVEC3}, {xyz = t.VEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                WATER_LAYER = 
                {
                    --{cells = {element = {{data = t.U16}}, size = 32 * 32 * 32}},
                    {cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}},
                    {activeCellCount = t.U32}
                },
            }
        }

    end
}

return layout
