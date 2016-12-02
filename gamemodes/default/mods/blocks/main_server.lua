local BlockDefinitions = require ("gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local blockCallbacks = {}

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
local function onEntityPlaced (event)

    if event.isBlockValid then

        local blockTag = BlockDefinitions.blocks [event.usingBlockId].tag
        if blockTag then
            event.cancel = blockCallbacks [blockTag] (event, true)
            return
        end
    end
end

--------------------------------------------------
local function onEntityDestroyed (event)

    if event.isBlockValid then

        local blockTag = BlockDefinitions.blocks [event.usingBlockId].tag
        if blockTag then
            event.cancel = blockCallbacks [blockTag] (event, false)
            return
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