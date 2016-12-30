local BlockDefinitions = require ("gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local blockCallbacks = {}

--------------------------------------------------
function blockCallbacks.default (event, isPlacing) 
    
    if event.isBlockValid then

        if isPlacing then

        else

            -- if we are deleting motor block then prevent it

            local tag = BlockDefinitions.blocks [event.pickedBlockId].tag

            if tag == "axle" or tag == "motor" then
                return true
            end

        end
        
    end

    return false
end

--------------------------------------------------
function blockCallbacks.axle (event, isPlacing) 

    if isPlacing and event.isBlockValid then

        if not event.isAxle then

            if event.pickedBlockId == event.usingBlockId then

                event.specialProperties = "axle"

            end

        else

            return true
            
        end

    end

end

--------------------------------------------------
function blockCallbacks.spanner (event, isPlacing) 

    if event.isBlockValid then

        if event.isAxle then

            local c = dio.entities.components
            local motorEntityId = dio.entities.getComponent (event.chunkEntityId, c.PARENT).parentEntityId
            local axle = dio.entities.getComponent (motorEntityId, c.AXLE)

            if isPlacing then
                axle.isActive = not axle.isActive
            else
                if axle.isActive then
                    local rotationSpeedInc = 0.2
                    local maxRotationSpeed = 10.0

                    if axle.rotationSpeed > maxRotationSpeed or 
                            axle.rotationSpeed < rotationSpeedInc then

                        axle.rotationSpeed = rotationSpeedInc
                    else
                        axle.rotationSpeed = axle.rotationSpeed * 2
                    end
                end
            end
            
            dio.entities.setComponent (motorEntityId, c.AXLE, axle)

        end
    end

    return true
end

--------------------------------------------------
function blockCallbacks.hammer (event, isPlacing) 

    if isPlacing then

        return true

    else

        return false

    end

    -- if event.isBlockValid then

    --     if event.isAxle then

    --         local c = dio.entities.components
    --         local motorEntityId = dio.entities.getComponent (event.chunkEntityId, c.PARENT).parentEntityId
    --         local axle = dio.entities.getComponent (motorEntityId, c.AXLE)

    --         if isPlacing then
    --             axle.isActive = not axle.isActive
    --         else
    --             if axle.isActive then
    --                 local rotationSpeedInc = 0.2
    --                 local maxRotationSpeed = 10.0

    --                 if axle.rotationSpeed > maxRotationSpeed or 
    --                         axle.rotationSpeed < rotationSpeedInc then

    --                     axle.rotationSpeed = rotationSpeedInc
    --                 else
    --                     axle.rotationSpeed = axle.rotationSpeed * 2
    --                 end
    --             end
    --         end
            
    --         dio.entities.setComponent (motorEntityId, c.AXLE, axle)

    --     end
    -- end

    -- return true

    return false

end

--------------------------------------------------
local function onEntityPlaced (event)

    if event.isBlockValid then

        event.cancel = nil

        local blockTag = BlockDefinitions.blocks [event.usingBlockId].tag
        if blockTag then
            event.cancel = blockCallbacks [blockTag] (event, true)
        end

        if event.cancel == nil then
            event.cancel = blockCallbacks.default (event, true)
        end

    end
end

--------------------------------------------------
local function onEntityDestroyed (event)

    if event.isBlockValid then

        event.cancel = nil

        local blockTag = BlockDefinitions.blocks [event.usingBlockId].tag
        if blockTag then
            event.cancel = blockCallbacks [blockTag] (event, false)
        end

        if event.cancel == nil then
            event.cancel = blockCallbacks.default (event, false)
        end

    end
end

--------------------------------------------------
local function onLoad ()

    for _, definition in ipairs (BlockDefinitions.blocks) do
        local definitionId = dio.blocks.createNewDefinitionId ()
        definition.definitionId = definitionId
        dio.blocks.setDefinition (definition)
    end

    local types = dio.types.serverEvents
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)

end

--------------------------------------------------
local modSettings =
{
    name = "Blocks",

    description = "Adds the default Diorama blocks",

    permissionsRequired =
    {
        blocks = true,
        entities = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings