local BlockDefinitions = require ("resources/gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local blockCallbacks = {}

--------------------------------------------------
function blockCallbacks.spanner (event, isPlacing) 

    if event.isBlockValid then

        if event.isRotatingMotorBlock then

            local c = dio.entities.components
            local motorEntityId = dio.entities.getComponent (event.chunkEntityId, c.PARENT).parentEntityId
            local rotatingMotor = dio.entities.getComponent (motorEntityId, c.ROTATING_MOTOR)

            print ("spanner " .. tostring (motorEntityId))

            if isPlacing then
                rotatingMotor.isActive = not rotatingMotor.isActive
            else
                if rotatingMotor.isActive then
                    local rotationSpeedInc = 0.2
                    local maxRotationSpeed = 10.0

                    if rotatingMotor.rotationSpeed > maxRotationSpeed or 
                            rotatingMotor.rotationSpeed < rotationSpeedInc then

                        rotatingMotor.rotationSpeed = rotationSpeedInc
                    else
                        rotatingMotor.rotationSpeed = rotatingMotor.rotationSpeed * 2
                    end
                end
            end
            
            dio.entities.setComponent (motorEntityId, c.ROTATING_MOTOR, rotatingMotor)

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