local t = dio.types.updateTypes
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
                BLOCK_LAYER                     = {{cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}}},
                BLOCKS_COLLIDER                 = {},
                CHILD_IDS                       = {{children = {element = t.ENTITY}}},
                CHILD_IDS_WITH_CHUNKS           = {{children = {element = t.ENTITY}}},
                CHUNK_ID                        = {{chunkId = t.IVEC3}},
                CHUNKS                          = {},
                FRAME_OF_REFERENCE_TRANSFORM    = {{chunkId = t.IVEC3}, {xyz = t.VEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                MOTOR_RIGID_BODY = 
                {
                    {impulse            = t.VEC3},
                    {velocity_overlay   = t.VEC3},
                    {velocity           = t.VEC3},
                    {acceleration       = t.VEC3},
                    {stickyFace         = t.U8}
                },
                NAME                            = {{name = t.STRING}},
                PARENT                          = {},
                TRANSFORM                       = {{chunkId = t.IVEC3}, {xyz = t.VEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
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
