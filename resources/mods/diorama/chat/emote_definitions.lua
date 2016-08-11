--------------------------------------------------
local emoteSpecs =
{
    width = 32,
    height = 32,
    renderWidth = 16,
    renderHeight = 16,
}

--------------------------------------------------
local emotes =
{
    ["<diorama>"] =     {uvs = {0, 0}},
    ["<rob>"] =         {uvs = {1, 0}},
    ["<teazel>"] =      {uvs = {2, 0}},
    ["<jodie>"] =       {uvs = {3, 0}},
    ["Kappa"] =         {uvs = {4, 0}},
    [":)"] =            {uvs = {5, 0}},
    [":("] =            {uvs = {6, 0}},
    ["<3"] =            {uvs = {7, 0}},
    ["<pretty>"] =      {uvs = {0, 1}},
    ["<what>"] =        {uvs = {1, 1}},
    ["<dreamies>"] =   	{uvs = {2, 1}},
    ["<IRLteazel>"] = 	{uvs = {3, 1}},
    ["<boxoffivers>"] = {uvs = {4, 1}},
    [":|"] =            {uvs = {5, 1}},
    [":D"] =            {uvs = {6, 1}},
    ["</3"] =           {uvs = {7, 1}},
}

return {emoteSpecs = emoteSpecs, emotes = emotes}