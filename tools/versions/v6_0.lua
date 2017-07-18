local Inspect = require ("versions/inspect")

local b = dio.types.binaryConversions
local s = dio.types.sizeCalculations
local t = dio.types.updateTypes

--------------------------------------------------
local layout =
{
    create = function (versions)

        return
        {
            --------------------------------------------------
            version =
            {
                major = 6,
                minor = 0,
            },

            --------------------------------------------------
            componentTypes =
            {
                -- "NULL_TYPE", -- should be zero - but the name is never needed anyway so ignore
                "AABB_COLLIDER",
                "BASE_FIXED_UPDATE",
                "BASE_NETWORK",
                "BASE_UPDATE",
                "BEHAVIOR",
                "BILLBOARD_TRANSFORM",
                "BLOCK_DEFINIITIONS",
                "BLOCK_HIGHLIGHT",
                "BLOCK_LAYER",
                "CALENDAR",
                "CAMERA_TRACKING_TRANSFORM",
                "CELL_ID",
                "CHARACTER_CONTROLLER",
                "CHILD_IDS",
                "CHILD_IDS_WITH_CHUNKS",
                "CHUNK_ID",
                "CHUNKS",
                "COLLISION_LAYER",
                "COLLISION_LISTENER",
                "EXPLOSION_EVENT",
                "UNUSED_EYE_POSITION",
                "FOCUS",
                "GRAVITY_TRANSFORM",
                "NAME",
                "PARENT",
                "RIGID_BODY",
                "ROOM_SHAPE",
                "SERVER_CHARACTER_CONTROLLER",
                "SERVER_CONNECTION",
                "TEMP_PLAYER",
                "TEMP_ROOM",
                "TEMP_WORLD",
                "TRANSFORM",
                "WATER_LAYER",
                "BASE_COLLIDER", 
                "BLOCKS_COLLIDER", 
                "MESH_PLACEHOLDER", 
                "NAME_TAG", 
                "CHUNK_RENDERER",
                "CLIENT_CONNECTION",
                "MATERIALS",
                "MESH_RENDERER",
                "RENDERABLE",
                "WATER_RENDERER",
                "PARTICLE_EMITTER",
                "CAMERA",
                "BROADCAST_WITH_PARENT",
                "EXTRUDED_TEXTURE_INSTANCES",
                "PADDED_CELLS",
                "ROOM_RENDERER",
                "TERRAIN_GEN_CACHE",
                "CLIENT_DIRTY_CHUNK",
                "SERVER_CHUNK_HISTORY_COMPONENT",
            },

            --------------------------------------------------
            update =
            {
                record = function (struct, details)

                    --print ("BEFORE")
                    --print (Inspect (struct))

                    dio.binary.update (b.V6_CELL_FROM_V3, struct.blockLayerCells);

                    struct.chunkEntity = 
                    {
                        _id = "entity",
                        components = 
                        {
                            {_id = "BLOCK_LAYER", cells = struct.blockLayerCells},       -- TODO need to upgrade the binary data :(
                            {_id = "CHILD_IDS", children = {}},
                            {_id = "CHUNK_ID", chunkId = details.chunkId},
                            {_id = "NAME", name = "CHUNK"},
                            {_id = "PARENT"},
                            {_id = "TRANSFORM", chunkId = details.chunkId, xyz = {0, 0, 0}, pyr = {0, 0, 0}, scale = {1, 1, 1}},
                            {_id = "WATER_LAYER", cells = dio.binary.create (32 * 32 * 32 * 2), activeCellCount = 0},
                            {_id = "BLOCKS_COLLIDER"},
                        }
                    }

                    struct.blockLayerCells = nil
                    struct.blockLayerDirtyNeighbours = nil
                    struct.entities = nil
                    struct.floatingSigns = nil

                    --print ("AFTER")
                    --print (Inspect (struct))

                end,
            },

            --------------------------------------------------
            structs = 
            {
                record                  = {{chunkEntity = t.ENTITY}},
                entity                  = {{components = {element = t.COMPONENT, size = s.NULL_COMPONENT}}},

                -- components
                BILLBOARD_TRANSFORM             = {{chunkId = t.IVEC3}, {xyz = t.VEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                BLOCK_LAYER                     = {{cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}}},
                BLOCKS_COLLIDER                 = {},
                --CALENDAR                        = {{time = t.F32}, {deltaMultiplier = t.F32}},
                CELL_ID                         = {{xyz = t.IVEC3}},
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
                NAME_TAG                        = {{text = t.STRING}},
                PARENT                          = {},
                TRANSFORM                       = {{chunkId = t.IVEC3}, {xyz = t.VEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                WATER_LAYER = 
                {
                    {cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}},
                    {activeCellCount = t.U32}
                },
            }
        }

    end
}

--------------------------------------------------
return layout
