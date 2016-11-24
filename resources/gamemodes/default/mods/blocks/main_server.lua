local BlockDefinitions = require ("resources/gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local blockCallbacks = {}

--------------------------------------------------
function blockCallbacks.spanner (event, isPlacing) 

    if event.isBlockValid then
        if BlockDefinitions.blocks [event.pickedBlockId].isMotor then
            -- this should only work if we click on the rotating motor block, not that base motor block
            -- how to decide which one???? AARGH

            -- bodge - check its cell_id

            if event.cellId [1] == 0 and event.cellId [2] == 0 and event.cellId [3] == 0 then

                -- now what? we need to get the motor entity from the chunk... eek!
                -- can we get the parent?

                local c = dio.entities.components

                local motorEntityId = dio.entities.getComponent (event.chunkEntityId, c.PARENT).parentEntityId
                local rotatingMotor = dio.entities.getComponent (motorEntityId, c.ROTATING_MOTOR)

                if isPlacing then
                    rotatingMotor.isActive = not rotatingMotor.isActive
                else
                    if rotatingMotor.isActive then
                        local rotationSpeedInc = 0.02
                        local maxRotationSpeed = 0.2

                        rotatingMotor.rotationSpeed [1] = rotatingMotor.rotationSpeed [1] + rotationSpeedInc
                        if rotatingMotor.rotationSpeed [1] > maxRotationSpeed then
                            rotatingMotor.rotationSpeed [1] = rotationSpeedInc
                        end
                    end
                end
                
                -- -- local transform = dio.entities.getComponent (motorEntityId, c.TRANSFORM)

                -- -- need to find its rotating speed, and then modify it ?
                -- -- so lets hard code this, and toggle between rotating and off in X

                -- if rotatingMotor.rotationSpeed [1] == 0 then
                --     -- transform.ypr [1] = -0.2
                --     rotatingMotor.rotationSpeed [1] = -0.2
                -- else
                --     -- transform.ypr [1] = 0
                --     rotatingMotor.rotationSpeed [1] = 0
                -- end

                -- dio.entities.setComponent (motorEntityId, c.TRANSFORM, transform)
                dio.entities.setComponent (motorEntityId, c.ROTATING_MOTOR, rotatingMotor)
            end
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