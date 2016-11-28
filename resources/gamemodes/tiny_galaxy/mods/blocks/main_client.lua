local BlockDefinitions = require ("resources/gamemodes/tiny_galaxy/mods/blocks/block_definitions")

--------------------------------------------------
local function onLoad ()

    for _, model in ipairs (BlockDefinitions.mediumModels) do
        dio.resources.loadMediumModel (model.id, model.filename, model.options)
    end

    for _, model in ipairs (BlockDefinitions.entityModels) do
        dio.resources.loadEntityModel (model.id, model.filename, model.options)
    end

    for _, definition in ipairs (BlockDefinitions.blocks) do
        local definitionId = dio.blocks.createNewDefinitionId ()
        definition.definitionId = definitionId
        dio.blocks.setDefinition (definition)
    end

end

--------------------------------------------------
local function onUnload ()

    for _, model in ipairs (BlockDefinitions.mediumModels) do
        dio.resources.destroyMediumModel (model.id)
    end

    for _, model in ipairs (BlockDefinitions.entityModels) do
        dio.resources.destroyEntityModel (model.id)
    end

end

--------------------------------------------------
local modSettings =
{
    name = "Blocks",

    description = "Adds the default Tiny Galaxy blocks",

    permissionsRequired =
    {
        blocks = true,
        resources = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
        onUnload = onUnload,        
    },    
}

--------------------------------------------------
return modSettings