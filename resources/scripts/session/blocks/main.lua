--------------------------------------------------
local definitions =
{
	{name = "grass",		uvs = {3, 0, 0, 0, 2, 0}},
	{name = "mud",			uvs = {2, 0}},
	{name = "granite",		uvs = {1, 0}},
	{name = "obsidian"},	uvs = {5, 2}},
	{name = "sand",			uvs = {2, 1}},
	{name = "snowy grass",	uvs = {4, 4, 2, 4, 2, 0}},
	{name = "brick",		uvs = {7, 0}},
	{name = "tnt",			uvs = {8, 0, 9, 0, 10, 0}},
	{name = "pumpkin",		uvs = {7, 7, 6, 7, 6, 7, 6, 7, 6, 6, 6, 6}},
	{name = "jump pad",		uvs = {12, 6, 11, 6, 13, 6}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "trunk",		uvs = {4, 1, 5, 1, 5, 1}},
	{name = "wood",			uvs = {4, 0}},
	{name = "leaf",			uvs = {4, 3}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
	{name = "cobble",		uvs = {0, 1}},
}

--------------------------------------------------
local function onLoadSuccessful ()
	
	for idx, definition in ipairs (definitions) do
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
}

--------------------------------------------------
return modSettings, onLoadSuccessful
