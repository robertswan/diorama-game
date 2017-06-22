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
                minor = 2,
            },

            -- update =
            -- {
            --     record = function (previous)
            --         return 
            --         {
            --             entities = {previous.chunkEntity},
            --         }
            --     end,

            --     components = 
            --     {
            --         c.TRANSFORM = function (previous)
            --             previous.xyz [1] = previous.xyz [1] + previous.chunkId [1] * 32
            --             previous.xyz [2] = previous.xyz [2] + previous.chunkId [2] * 32
            --             previous.xyz [3] = previous.xyz [3] + previous.chunkId [3] * 32
            --             previous.chunkId = nil
            --             return previous
            --         end
            --     }
            -- },

            structs = 
            {
                record = {{entities = {element = t.ENTITY}}},
                entity = {{components = {element = t.COMPONENT}}},

                -- components
                BLOCK_LAYER =
                {
                    {cells = {element = {{blockId = t.U8}, {gravityDir = t.U8}}, size = 32 * 32 * 32}}
                    --{cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}}
                },
                BLOCKS_COLLIDER = {},
                CALENDAR = {{time = t.F32}, {deltaMultiplier = t.F32}},
                CHILD_IDS = {{children = {element = t.ENTITY}}},
                CHUNK_ID = {{chunkId = t.IVEC3}},
                FRAME_OF_REFERENCE_TRANSFORM = {{xyz = t.DVEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                NAME = {{name = t.STRING}},
                PARENT = {},
                TRANSFORM = {{xyz = t.DVEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                WATER_LAYER = 
                {
                    {cells = {element = {{data = t.U16}}, size = 32 * 32 * 32}},
                    {activeCellCount = t.U32}
                },
            },
        }

    end
}

return layout
