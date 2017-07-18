local Inspect = require ("versions/inspect")

local t = dio.types.updateTypes

--------------------------------------------------
local layout =
{
    --------------------------------------------------
    create = function (versions)

        return
        {
            --------------------------------------------------
            version =
            {
                major = 8,
                minor = 3,
            },

            --------------------------------------------------
            update =
            {
                record = function (struct)
                    --print (Inspect (struct))
                end,

                FRAME_OF_REFERENCE_TRANSFORM = function (struct)
                    struct._id = "TRANSFORM"
                end,
            },

            --------------------------------------------------
            structs = 
            {
                record = {{entities = {element = t.ENTITY}}},
                entity = {{components = {element = t.COMPONENT}}},

                -- components
                BILLBOARD_TRANSFORM             = {{xyz = t.DVEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                BLOCK_LAYER =
                {
                    --{cells = {element = {{blockId = t.U8}, {gravityDir = t.U8}}, size = 32 * 32 * 32}}
                    {cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}}
                },
                BLOCKS_COLLIDER                 = {},
                CALENDAR                        = {{time = t.F32}, {deltaMultiplier = t.F32}},
                CELL_ID                         = {{xyz = t.IVEC3}},
                CHILD_IDS                       = {{children = {element = t.ENTITY}}},
                CHILD_IDS_WITH_CHUNKS           = {{children = {element = t.ENTITY}}},
                CHUNK_ID                        = {{chunkId = t.IVEC3}},
                CHUNKS                          = {},
                TRANSFORM                       = {{xyz = t.DVEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                MOTOR_RIGID_BODY = 
                {
                    {impulse            = t.DVEC3},
                    {velocity_overlay   = t.DVEC3},
                    {velocity           = t.DVEC3},
                    {acceleration       = t.DVEC3},
                    {stickyFace         = t.U8}
                },
                NAME                            = {{name = t.STRING}},
                NAME_TAG                        = {{text = t.STRING}},
                PARENT                          = {},
                TRANSFORM                       = {{xyz = t.DVEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                WATER_LAYER = 
                {
                    --{cells = {element = {{data = t.U16}}, size = 32 * 32 * 32}},
                    {cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}},
                    {activeCellCount = t.U32}
                },
            },
        }

    end
}

--------------------------------------------------
return layout
