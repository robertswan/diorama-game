local definitions = require ("resources/gamemodes/tiny_galaxy_creative/mods/blocks/block_definitions")

--------------------------------------------------
local function onLoad ()

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

    description = "Adds the default Tiny Galaxy blocks",

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