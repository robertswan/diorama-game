local definitions = require ("resources/mods/diorama/blocks/block_definitions")

--------------------------------------------------
local function onLoadSuccessful ()
    
    for _, definition in ipairs (definitions.blocks) do
        local definitionId = dio.blocks.createNewDefinitionId ()
        definition.definitionId = definitionId
        dio.blocks.setDefinition (definition, definitions.tiles)
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
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
