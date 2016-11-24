local BlockDefinitions = require ("resources/gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local function onLoad ()

    for _, model in ipairs (BlockDefinitions.models) do
        dio.resources.loadMediumModel (model.id, model.filename, model.options)
    end

    for _, definition in ipairs (BlockDefinitions.blocks) do
        local definitionId = dio.blocks.createNewDefinitionId ()
        definition.definitionId = definitionId
        dio.blocks.setDefinition (definition)
    end

end

--------------------------------------------------
local function onUnload ()

    for _, model in ipairs (BlockDefinitions.models) do
        dio.resources.destroyMediumModel (model.id)
    end

end

--------------------------------------------------
local modSettings =
{
    name = "Blocks",

    description = "Adds the default Diorama blocks",

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