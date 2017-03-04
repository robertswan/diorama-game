--------------------------------------------------
local function makeMediumModel (model, options)
    return
    {
        id = model,
        filename = "models/" .. model .. ".vox",
        options = options,
    }
end

local mediumModels =
{
    makeMediumModel ("chest_item_closed",       {isDetailedModel = true}),
    makeMediumModel ("chest_artefact_closed",   {isDetailedModel = true}),
    makeMediumModel ("chest_special_closed",    {isDetailedModel = true}),
    makeMediumModel ("chest_open",              {isDetailedModel = true}),
    makeMediumModel ("cactus",                  {isDetailedModel = true}),
    makeMediumModel ("pole"),
}

--------------------------------------------------
local function makeEntityModel (model, options)
    return
    {
        id = model,
        filename = "models/" .. model .. ".vox",
        options = options,
    }
end

--------------------------------------------------
local entityModels = 
{
    makeEntityModel ("player_model", {scale = {4, 4, 4}, rotate180 = true, translate = {-4.5, 0.0, -4.5}}),
}

--------------------------------------------------
local entities =
{
}

--------------------------------------------------
local modes = dio.types.tileModes

local grass =
{
    mode = modes.RANDOM_4,
    uvs = {{12, 2}, {13, 2}, {12, 3}, {13, 3}},
}

local concrete = 
{
    mode = modes.REPEAT_2X2,
    uvs = {{10, 2}, {11, 2}, {10, 3}, {11, 3}},
}

local leaves =
{
    mode = modes.AUTOTILE_4,
    uvs = 
    {
        {0, 14}, {1, 14}, {2, 14}, {3, 14}, 
        {4, 14}, {5, 14}, {6, 14}, {7, 14}, 
        {8, 14}, {9, 14}, {10, 14}, {11, 14}, 
        {12, 14}, {13, 14}, {14, 14}, {15, 14},
    },
}

--------------------------------------------------
local function expandAllFaces (a, b, c, d, e, f, g, h, i, j, k, l)
    local textures = 
    {
        n = {a, b}, e = {c, d}, s = {e, f}, w = {g, h}, t = {i, j}, b = {k, l}
    }
    return textures
end

--------------------------------------------------
local blocks =
{
    -- 0 = air
    -- 1
    {name = "ship tile",                icon = {4, 1},     textures = {neswtb = {4, 1}}},
    {name = "ship base",                icon = {3, 1},     textures = {neswtb = {3, 1}}},
    {name = "metal pillar",             icon = {6, 0},     textures = {neswtb = {6, 0}}, model = "pole"},
    {name = "computer",                 icon = {2, 0},     textures = {newtb = {3, 0}, s = {2, 0}}, tag ="computer"},
    {name = "grass",                    icon = {10, 0},    textures = {nesw = {10, 0}, t = grass, b ={11, 0}}},
    {name = "mud",                      icon = {11, 0},    textures = {neswtb = {11, 0}}},
    {name = "tree trunk big",           icon = {2, 1},     textures = {nesw = {1, 1}, tb = {2, 1}}, tag = "bigAxe"},
    {name = "tree trunk small",         icon = {5, 0},     textures = {nesw = {5, 0}, tb = {2, 1}}, model = "pole", tag = "smallAxe"},
    {name = "leaves",                   icon = {7, 0},     textures = {neswtb = leaves}},

    -- 10    
    {name = "thin grass",               icon = {8, 0},     textures = {neswtb = {13, 0}}, isSolid = false},
    {name = "concrete",                 icon = {12, 0},    textures = {neswtb = concrete}},
    {name = "concrete breakable",       icon = {9, 3},     textures = {neswtb = {9, 3}}, tag = "belt"},
    {name = "vector tile",              icon = {1, 6},     textures = {neswtb = {1, 6}}},
    {name = "vector brick",             icon = {2, 6},     textures = {nesw = {2, 6}, tb = {1, 6}}},
    {name = "vector breakable brick",   icon = {3, 6},     textures = {neswtb = {3, 6}}, tag = "belt"},
    --{name = "vector breakable brick",   icon = {3, 6},     model = "breakable_vector", tag = "belt"},
    {name = "vector pole",              icon = {5, 6},     textures = {nesw = {5, 6}, tb = {14, 6}}, model = "pole"},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "vector glass",             icon = {4, 6},     textures = {neswtb = {4, 6}}, isTransparent = true},
    {name = "vector circle",            icon = {7, 6},     textures = {neswtb = {7, 6}}},

    -- 20
    {name = "ice rock",                 icon = {2, 3},     textures = {neswtb = {2, 3}}},
    {name = "ice layer 1",              icon = {3, 3},     textures = {nesw = {3, 3}, t = {1, 3}, b = {2, 3}}},
    {name = "ice layer 2",              icon = {4, 3},     textures = {nesw = {4, 3}, t = {1, 3}, b = {2, 3}}},
    {name = "ice breakable",            icon = {8, 3},     textures = {neswtb = {8, 3}}, tag = "belt"},
    {name = "ice tree",                 icon = {7, 3},     textures = {nesw = {7, 3}, tb = {6, 3}}},
    {name = "ice trunk thin",           icon = {5, 3},     textures = {neswtb = {5, 3}}, model = "pole", tag = "smallAxe"},
    {name = "sand brick",               icon = {1, 2},     textures = {nesw = {1, 2}, tb = {4, 2}}},
    {name = "sand breakable brick",     icon = {5, 2},     textures = {neswtb = {5, 2}}, tag = "belt"},
    {name = "sand",                     icon = {0, 2},     textures = {neswtb = {0, 2}}},
    {name = "sand column",              icon = {3, 2},     textures = {neswtb = {3, 2}}},

    -- 30
    {name = "sand column ridged",       icon = {2, 2},     textures = {neswtb = {2, 2}}},
    {name = "cactus",                   icon = {9, 2},     model = "cactus", isSolid = false},
    {name = "sand jump pad",            icon = {6, 2},     textures = {nesw = {0, 2}, t = {6, 2}, b = {0, 2}}, isJumpPad = true},
    {name = "sand teleporter",          icon = {7, 2},     textures = {nesw = {0, 2}, t = {7, 2}, b = {0, 2}}, tag = "teleporter"},
    {name = "sand pole",                icon = {8, 2},     textures = {neswtb = {8, 2}},    model = "pole"},
    {name = "sun bright 1",             icon = {0, 7},     textures = {neswtb = {0, 7}}},
    {name = "sun bright 2",             icon = {1, 7},     textures = {neswtb = {1, 7}}},
    {name = "sun bright 3",             icon = {2, 7},     textures = {neswtb = {2, 7}}},
    {name = "sun bright 4",             icon = {3, 7},     textures = {neswtb = {3, 7}}},
    {name = "rot brick clean",          icon = {1, 4},     textures = {neswtb = {1, 4}}},

    -- 40
    {name = "rot brick roots",          icon = {2, 4},     textures = {neswtb = {2, 4}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "rot vines nonsolid",       icon = {4, 4},     textures = {neswtb = {4, 4}},    isTransparent = true, isSolid = false},
    {name = "rot trunk",                icon = {12, 4},    textures = {neswtb = {12, 4}},   tag = "bigAxe"},
    {name = "rot trunk thin",           icon = {11, 4},    textures = {neswtb = {11, 4}},   model = "pole", tag = "smallAxe"},
    {name = "rot leaves clean",         icon = {13, 4},    textures = {neswtb = {13, 4}}},
    {name = "rot leaves vinish",        icon = {15, 4},    textures = {nesw = {15, 4}, t = {13, 4}, b = {15, 4}}},
    {name = "rot leaves vines",         icon = {14, 4},    textures = {neswtb = {14, 4}}},
    {name = "castle brick",             icon = {5, 4},     textures = {neswtb = {5, 4}}},
    {name = "castle brick vinish",      icon = {6, 4},     textures = {nesw = {6, 4}, t = {5, 4}, b = {6, 4}}},

    -- 50
    {name = "castle roof",              icon = {7, 4},     textures = {nesw = {8, 4}, t = {7, 4}, b = {5, 4}}},
    {name = "castle door",              icon = {10, 4},    textures = expandAllFaces (10, 4, 5, 4, 10, 4, 5, 4, 5, 4, 5, 4)},
    {name = "castle clock",             icon = {9, 4},     textures = expandAllFaces (5, 4, 5, 4, 9, 4, 5, 4, 5, 4, 5, 4)},
    {name = "nuke brick",               icon = {0, 5},     textures = {neswtb = {0, 5}}},
    {name = "nuke scaffold",            icon = {1, 5},     textures = {neswtb = {1, 5}}, isTransparent = true},
    {name = "nuke pole",                icon = {2, 5},     textures = {neswtb = {2, 5}}, model = "pole"},
    {name = "nuke waste",               icon = {6, 5},     textures = {nesw = {6, 5}, t = {5, 5}, b = {7, 5}}},
    {name = "nuke bean",                icon = {3, 5},     textures = {nesw = {0, 5}, t = {3, 5}, b = {0, 5}}, tag = "bean"},
    {name = "nuke jumppad",             icon = {4, 5},     textures = {nesw = {0, 5}, t = {4, 5}, b = {0, 5}}, isJumpPad = true},
    {name = "nuke teleporter",          icon = {8, 5},     textures = {nesw = {0, 5}, t = {8, 5}, b = {0, 5}}, tag = "teleporter"},

    -- 60
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "small rocks",              icon = {9, 5},     textures = {neswtb = {9, 5}}},
    {name = "rock teleporter",          icon = {6, 1},     textures = {neswb = concrete, t = {6, 1}}, tag = "teleporter"},
    {name = "rock pole",                icon = {12, 0},    textures = {neswtb = {12, 0}}, model = "pole"},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "ship teleporter",          icon = {8, 6},     textures = {nesw = {4, 1}, t = {8, 6}, b = {4, 1}}, tag = "teleporter"},
    {name = "item chest",               icon = {5, 8},     model = "chest_item_closed", tag = "itemChest"},
    {name = "artefact chest",           icon = {5, 9},     model = "chest_artefact_closed", tag = "artefactChest"},
    {name = "special chest",            icon = {13, 9},    model = "chest_special_closed", tag = "specialChest"},

    -- 70
    {name = "open chest",               icon = {13, 8},    model = "chest_open"},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "UNUSED",                   icon = {15, 15},   textures = {neswtb = {15, 15}}},
    {name = "ship motor",               icon = {15, 0},     textures = {neswtb = {15, 0}}, isMotor = true},
    {name = "grass jump",               icon = {10, 5},    textures = {nesw = {10, 0}, t = {10, 5}, b = {11, 0}}, isJumpPad = true},
    
    -- 80
    {name = "artifact world",           icon = {9, 6},     textures = {neswtb = {9, 6}}},
    {name = "artifact block 1",         icon = {5, 7},     textures = {nesw = {5, 7}, tb = {14, 7}}},
    {name = "artifact block 2",         icon = {6, 7},     textures = {nesw = {6, 7}, tb = {14, 7}}},
    {name = "artifact block 3",         icon = {7, 7},     textures = {nesw = {7, 7}, tb = {14, 7}}},
    {name = "artifact block 4",         icon = {8, 7},     textures = {nesw = {8, 7}, tb = {14, 7}}},
    {name = "artifact block 5",         icon = {9, 7},     textures = {nesw = {9, 7}, tb = {14, 7}}},
    {name = "artifact block 6",         icon = {10, 7},    textures = {nesw = {10, 7}, tb = {14, 7}}},
    {name = "artifact cookie",          icon = {11, 6},    textures = {neswtb = {11, 6}}, tag = "cookie"},
    {name = "vector jump",              icon = {12, 6},    textures = {nesw = {2, 6}, t = {12, 6}, b = {1, 6}}, isJumpPad = true},
    {name = "vector teleport",          icon = {13, 6},    textures = {nesw = {2, 6}, t = {13, 6}, b = {1, 6}}, tag = "teleporter"},
}

return {blocks = blocks, entities = entities, mediumModels = mediumModels, entityModels = entityModels}
