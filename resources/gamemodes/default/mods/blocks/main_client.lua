local definitions = require ("resources/gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local function onLoad ()

    for _, definition in ipairs (definitions.blocks) do
        local definitionId = dio.blocks.createNewDefinitionId ()
        definition.definitionId = definitionId
        dio.blocks.setDefinition (definition)
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

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings