--------------------------------------------------
local definitions =
{
	{name = "grass",			uvs = {3, 0, 0, 0, 2, 0}},
	{name = "mud",				uvs = {2, 0}},
	{name = "granite",			uvs = {1, 0}},
	{name = "obsidian",			uvs = {5, 2}},
	{name = "sand",				uvs = {2, 1}},
	{name = "snowy grass",		uvs = {4, 4, 2, 4, 2, 0}},
	{name = "brick",			uvs = {7, 0}},
	{name = "tnt",				uvs = {8, 0, 9, 0, 10, 0}},
	{name = "pumpkin",			uvs = {7, 7, 6, 7, 6, 7, 6, 7, 6, 6, 6, 6}},

	{name = "jump pad",			uvs = {12, 6, 11, 6, 13, 6}, 	properties = {"JUMP"}},
	{name = "cobble",			uvs = {0, 1}},
	{name = "trunk",			uvs = {4, 1, 5, 1, 5, 1}},
	{name = "wood",				uvs = {4, 0}},
	{name = "leaf",				uvs = {4, 3}, 					properties = {"TRANSPARENT"}},
	{name = "glass",			uvs = {1, 3}},
	{name = "lit pumpkin",		uvs = {8, 7, 6, 7, 6, 7, 6, 7, 6, 6, 6, 6}},
	{name = "melon",			uvs = {8, 8, 9, 8, 9, 8}},
	{name = "crafting table",	uvs = {11, 2}},
	
	{name = "gold",				uvs = {7, 1}},
	{name = "slab",				uvs = {5, 0, 6, 0, 6, 0}},
	{name = "big slab",			uvs = {6, 0}},
	{name = "gravel",			uvs = {3, 1}},
	{name = "bedrock",			uvs = {1, 1}},
	{name = "wood panel",		uvs = {9, 1}},
	{name = "books",			uvs = {3, 2, 4, 0, 4, 0}},
	{name = "mossy cobble",		uvs = {4, 2}},
	{name = "stone brick",		uvs = {6, 3}},

	{name = "sponge",			uvs = {8, 4}},
	{name = "herringbone",		uvs = {10, 4}},
	{name = "black W",			uvs = {1, 7}},
	{name = "dark grey W",		uvs = {2, 7}},
	{name = "light grey W",		uvs = {1, 14}},
	{name = "white W",			uvs = {0, 4}},
	{name = "dark cyan W",		uvs = {1, 13}},
	{name = "brown W",			uvs = {1, 10}},
	{name = "pink W",			uvs = {2, 8}},

	{name = "light blue W",		uvs = {2, 11}},
	{name = "light green W",	uvs = {2, 9}},
	{name = "yellow W",			uvs = {2, 10}},
	{name = "orange W",			uvs = {2, 13}},
	{name = "red W",			uvs = {1, 8}},
	{name = "violet W",			uvs = {2, 12}},
	{name = "purple W",			uvs = {1, 12}},
	{name = "dark blue W",		uvs = {1, 11}},
	{name = "dark green W",		uvs = {1, 9}},
}

--------------------------------------------------
local function onLoadSuccessful ()
	
	for _, definition in ipairs (definitions) do
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
