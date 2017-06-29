local Inspect = require ("versions/inspect")

local t = dio.types.updateTypes
local c = dio.types.components
local s = dio.types.sizeTerminators

local function getComponent (entity, componentName)
    for _, component in ipairs (entity.components) do
        if (component._id == componentName) then
            return component
        end
    end
    fjdsklfdjslk ()
end

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

            update =
            {
                record = function (struct)
                    
                    struct.entities = {struct.chunkEntity}

                    local parentTransform = getComponent (struct.chunkEntity, "FRAME_OF_REFERENCE_TRANSFORM")
                    
                    local child_ids_component = getComponent (struct.chunkEntity, "CHILD_IDS")
                    for _, childEntity in ipairs (child_ids_component.children) do

                        local childTransform = getComponent (childEntity, "TRANSFORM")
                        childTransform.chunkId = parentTransform.chunkId;
                        table.insert (struct.entities, childEntity)
                    end
                    
                    struct.chunkEntity = nil
                    child_ids_component.children = {}
                    
                    print (Inspect (struct))
                end,

                TRANSFORM = function (struct)
                    struct.xyz [1] = struct.xyz [1] + struct.chunkId [1] * 32
                    struct.xyz [2] = struct.xyz [2] + struct.chunkId [2] * 32
                    struct.xyz [3] = struct.xyz [3] + struct.chunkId [3] * 32
                    struct.chunkId = nil
                end,

                FRAME_OF_REFERENCE_TRANSFORM = function (struct)
                    struct.xyz [1] = struct.xyz [1] + struct.chunkId [1] * 32
                    struct.xyz [2] = struct.xyz [2] + struct.chunkId [2] * 32
                    struct.xyz [3] = struct.xyz [3] + struct.chunkId [3] * 32
                    struct.chunkId = nil
                end
            },

            structs = 
            {
                record = {{entities = {element = t.ENTITY}}},
                entity = {{components = {element = t.COMPONENT}}},

                -- components
                BLOCK_LAYER =
                {
                    --{cells = {element = {{blockId = t.U8}, {gravityDir = t.U8}}, size = 32 * 32 * 32}}
                    {cells = {element = t.BINARY, size = 32 * 32 * 32 * 2}}
                },
                BLOCKS_COLLIDER                 = {},
                CALENDAR                        = {{time = t.F32}, {deltaMultiplier = t.F32}},
                CHILD_IDS                       = {{children = {element = t.ENTITY}}},
                CHILD_IDS_WITH_CHUNKS           = {{children = {element = t.ENTITY}}},
                CHUNK_ID                        = {{chunkId = t.IVEC3}},
                CHUNKS                          = {},
                FRAME_OF_REFERENCE_TRANSFORM    = {{xyz = t.DVEC3}, {pyr = t.VEC3}, {scale = t.VEC3}},
                MOTOR_RIGID_BODY = 
                {
                    {impulse            = t.DVEC3},
                    {velocity_overlay   = t.DVEC3},
                    {velocity           = t.DVEC3},
                    {acceleration       = t.DVEC3},
                    {stickyFace         = t.U8}
                },
                NAME                            = {{name = t.STRING}},
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

return layout
