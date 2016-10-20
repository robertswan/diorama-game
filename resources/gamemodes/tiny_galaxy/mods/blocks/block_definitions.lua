--------------------------------------------------
local tiles =
{
}

--------------------------------------------------
local entities =
{
}

--------------------------------------------------
local function expandAllFaces (a, b, c, d, e, f, g, h, i, j, k, l)
    local faces = 
    {
        n = {a, b}, e = {c, d}, s = {e, f}, w = {g, h}, t = {i, j}, b = {k, l}
    }
    return faces
end

--------------------------------------------------
local blocks =
{
    -- 0 = air
    -- 1
    {name = "ship tile",                icon = {4, 1},     faces = {neswtb = {4, 1}}},
    {name = "ship base",                icon = {3, 1},     faces = {neswtb = {3, 1}}},
    {name = "metal pillar",             icon = {6, 0},     faces = {neswtb = {6, 0}}, shape = "pole"},
    {name = "computer",                 icon = {2, 0},     faces = {newtb = {3, 0}, s = {2, 0}}, tag ="computer"},
    {name = "grass",                    icon = {10, 0},    faces = {nesw = {10, 0}, t = {9, 0}, b ={11, 0}}},
    {name = "mud",                      icon = {11, 0},    faces = {neswtb = {11, 0}}},
    {name = "tree trunk big",           icon = {2, 1},     faces = {nesw = {1, 1}, tb = {2, 1}}, tag = "bigAxe"},
    {name = "tree trunk small",         icon = {5, 0},     faces = {nesw = {5, 0}, tb = {2, 1}}, shape = "pole", tag = "smallAxe"},
    {name = "leaves",                   icon = {7, 0},     faces = {neswtb = {7, 0}}},

    -- 10    
    {name = "thin grass",               icon = {8, 0},     faces = {neswtb = {8, 0}}, shape = "cross", isSolid = false},
    {name = "concrete",                 icon = {1, 0},     faces = {neswtb = {1, 0}}},
    {name = "concrete breakable",       icon = {9, 3},     faces = {neswtb = {9, 3}}, tag = "belt"},
    {name = "vector tile",              icon = {1, 6},     faces = {neswtb = {1, 6}}},
    {name = "vector brick",             icon = {2, 6},     faces = {nesw = {2, 6}, tb = {1, 6}}},
    {name = "vector breakable brick",   icon = {3, 6},     faces = {neswtb = {3, 6}}, tag = "belt"},
    {name = "vector pole",              icon = {5, 6},     faces = {nesw = {5, 6}, tb = {1, 6}}, shape = "pole"},
    {name = "vector grass",             icon = {6, 6},     faces = {neswtb = {6, 6}}, shape = "cross", isSolid = false},
    {name = "vector glass",             icon = {4, 6},     faces = {neswtb = {4, 6}}, isTransparent = true},
    {name = "vector circle",            icon = {7, 6},     faces = {neswtb = {7, 6}}},

    -- 20
    {name = "ice rock",                 icon = {2, 3},     faces = {neswtb = {2, 3}}},
    {name = "ice layer 1",              icon = {3, 3},     faces = {nesw = {3, 3}, t = {1, 3}, b = {2, 3}}},
    {name = "ice layer 2",              icon = {4, 3},     faces = {nesw = {4, 3}, t = {1, 3}, b = {2, 3}}},
    {name = "ice breakable",            icon = {8, 3},     faces = {neswtb = {8, 3}}, tag = "belt"},
    {name = "ice tree",                 icon = {7, 3},     faces = {nesw = {7, 3}, tb = {6, 3}}},
    {name = "ice trunk thin",           icon = {5, 3},     faces = {nesw = {5, 3}, tb = {6, 3}}, shape = "pole", tag = "smallAxe"},
    {name = "sand brick",               icon = {1, 2},     faces = {nesw = {1, 2}, tb = {4, 2}}},
    {name = "sand breakable brick",     icon = {5, 2},     faces = {neswtb = {5, 2}}, tag = "belt"},
    {name = "sand",                     icon = {0, 2},     faces = {neswtb = {0, 2}}},
    {name = "sand column",              icon = {3, 2},     faces = {neswtb = {3, 2}}},

    -- 30
    {name = "sand column ridged",       icon = {2, 2},     faces = {neswtb = {2, 2}}},
    {name = "cactus",                   icon = {9, 2},     faces = {neswtb = {9, 2}}, shape = "cross", isSolid = false},
    {name = "sand jump pad",            icon = {6, 2},     faces = {nesw = {0, 2}, t = {6, 2}, b = {0, 2}}, isJumpPad = true},
    {name = "sand teleporter",          icon = {7, 2},     faces = {nesw = {0, 2}, t = {7, 2}, b = {0, 2}}, tag = "teleporter"},
    {name = "sand pole",                icon = {8, 2},     faces = {nesw = {8, 2}, tb = {0, 2}}, shape = "pole"},
    {name = "sun bright 1",             icon = {0, 7},     faces = {neswtb = {0, 7}}},
    {name = "sun bright 2",             icon = {1, 7},     faces = {neswtb = {1, 7}}},
    {name = "sun bright 3",             icon = {2, 7},     faces = {neswtb = {2, 7}}},
    {name = "sun bright 4",             icon = {3, 7},     faces = {neswtb = {3, 7}}},
    {name = "rot brick clean",          icon = {1, 4},     faces = {neswtb = {1, 4}}},

    -- 40
    {name = "rot brick roots",          icon = {2, 4},     faces = {neswtb = {2, 4}}},
    {name = "rot vines X",              icon = {4, 4},     faces = {neswtb = {4, 4}},        shape = "cross", isSolid = false},
    {name = "rot vines []",             icon = {4, 4},     faces = {neswtb = {4, 4}}, isTransparent = true, isSolid = false},
    {name = "rot trunk",                icon = {12, 4},    faces = {neswtb = {12, 4}}, tag = "bigAxe"},
    {name = "rot trunk thin",           icon = {11, 4},    faces = {nesw = {11, 4}, tb = {12, 4}}, shape = "pole", tag = "smallAxe"},
    {name = "rot leaves clean",         icon = {13, 4},    faces = {neswtb = {13, 4}}},
    {name = "rot leaves vinish",        icon = {15, 4},    faces = {nesw = {15, 4}, t = {13, 4}, b = {15, 4}}},
    {name = "rot leaves vines",         icon = {14, 4},    faces = {neswtb = {14, 4}}},
    {name = "castle brick",             icon = {5, 4},     faces = {neswtb = {5, 4}}},
    {name = "castle brick vinish",      icon = {6, 4},     faces = {nesw = {6, 4}, t = {5, 4}, b = {6, 4}}},

    -- 50
    {name = "castle roof",              icon = {7, 4},     faces = {nesw = {8, 4}, t = {7, 4}, b = {5, 4}}},
    {name = "castle door",              icon = {10, 4},    faces = expandAllFaces (10, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4)},
    {name = "castle clock",             icon = {9, 4},     faces = expandAllFaces (5, 4, 5, 4, 9, 4, 5, 4, 5, 4, 5, 4)},
    {name = "nuke brick",               icon = {0, 5},     faces = {neswtb = {0, 5}}},
    {name = "nuke scaffold",            icon = {1, 5},     faces = {neswtb = {1, 5}}, isTransparent = true},
    {name = "nuke pole",                icon = {2, 5},     faces = {neswtb = {2, 5}}, shape = "pole"},
    {name = "nuke waste",               icon = {6, 5},     faces = {nesw = {6, 5}, t = {5, 5}, b = {7, 5}}},
    {name = "nuke bean",                icon = {3, 5},     faces = {nesw = {0, 5}, t = {3, 5}, b = {0, 5}}, tag = "bean"},
    {name = "nuke jumppad",             icon = {4, 5},     faces = {nesw = {0, 5}, t = {4, 5}, b = {0, 5}}, isJumpPad = true},
    {name = "nuke teleporter",          icon = {8, 5},     faces = {nesw = {0, 5}, t = {8, 5}, b = {0, 5}}, tag = "teleporter"},

    -- 60
    {name = "DO NOT USE (item)",        icon = {15, 15},   faces = {nesw = {15, 15}, t = {0, 8}, b = {15, 15}}},
    {name = "DO NOT USE (art)",         icon = {15, 15},   faces = {nesw = {15, 15}, t = {0, 9}, b = {15, 15}}},
    {name = "small rocks",              icon = {9, 5},     faces = {neswtb = {9, 5}}},
    {name = "rock teleporter",          icon = {6, 1},     faces = {nesw = {1, 0}, t = {6, 1}, b = {1, 0}}, tag = "teleporter"},
    {name = "rock pole",                icon = {10, 6},    faces = {nesw = {10, 6}, tb = {1, 0}}, shape = "pole"},
    {name = "DO NOT USE (empty)",       icon = {15, 15},   faces = {neswb = {15, 15}, t = {5, 8}}},
    {name = "ship teleporter",          icon = {8, 6},     faces = {nesw = {4, 1}, t = {8, 6}, b = {4, 1}}, tag = "teleporter"},
    {name = "item chest N",             icon = {5, 8},     faces = expandAllFaces (5, 8, 6, 8, 7, 8, 6, 8, 2, 8, 0, 8), tag = "itemChest"}, -- 67
    {name = "item chest E",             icon = {5, 8},     faces = expandAllFaces (6, 8, 5, 8, 6, 8, 7, 8, 3, 8, 0, 8), tag = "itemChest"},
    {name = "item chest S",             icon = {5, 8},     faces = expandAllFaces (7, 8, 6, 8, 5, 8, 6, 8, 1, 8, 0, 8), tag = "itemChest"},

    -- 70
    {name = "item chest W",             icon = {5, 8},     faces = expandAllFaces (6, 8, 7, 8, 6, 8, 5, 8, 4, 8, 0, 8), tag = "itemChest"},
    {name = "artefact chest N",         icon = {5, 9},     faces = expandAllFaces (5, 9, 6, 9, 7, 9, 6, 9, 2, 9, 0, 9), tag = "artifactChest"}, -- 71
    {name = "artefact chest E",         icon = {5, 9},     faces = expandAllFaces (6, 9, 5, 9, 6, 9, 7, 9, 3, 9, 0, 9), tag = "artifactChest"},
    {name = "artefact chest S",         icon = {5, 9},     faces = expandAllFaces (7, 9, 6, 9, 5, 9, 6, 9, 1, 9, 0, 9), tag = "artifactChest"},
    {name = "artefact chest W",         icon = {5, 9},     faces = expandAllFaces (6, 9, 7, 9, 6, 9, 5, 9, 4, 9, 0, 9), tag = "artifactChest"},
    {name = "artefact chest N",         icon = {13, 8},    faces = expandAllFaces (13, 8, 14, 8, 15, 8, 14, 8, 10, 8, 8, 8)}, -- 75
    {name = "artefact chest E",         icon = {13, 8},    faces = expandAllFaces (14, 8, 13, 8, 14, 8, 15, 8, 11, 8, 8, 8)},
    {name = "artefact chest S",         icon = {13, 8},    faces = expandAllFaces (15, 8, 14, 8, 13, 8, 14, 8, 9, 8, 8, 8)},
    {name = "artefact chest W",         icon = {13, 8},    faces = expandAllFaces (14, 8, 15, 8, 14, 8, 13, 8, 12, 8, 8, 8)},
    {name = "grass jump",               icon = {10, 5},    faces = {nesw = {10, 0}, t = {10, 5}, b = {11, 0}}, isJumpPad = true},
    
    -- 80
    {name = "artifact world",           icon = {9, 6},     faces = {neswtb = {9, 6}}},
    {name = "artifact block 1",         icon = {5, 7},     faces = {nesw = {5, 7}, tb = {14, 7}}},
    {name = "artifact block 2",         icon = {6, 7},     faces = {nesw = {6, 7}, tb = {14, 7}}},
    {name = "artifact block 3",         icon = {7, 7},     faces = {nesw = {7, 7}, tb = {14, 7}}},
    {name = "artifact block 4",         icon = {8, 7},     faces = {nesw = {8, 7}, tb = {14, 7}}},
    {name = "artifact block 5",         icon = {9, 7},     faces = {nesw = {9, 7}, tb = {14, 7}}},
    {name = "artifact block 6",         icon = {10, 7},    faces = {nesw = {10, 7}, tb = {14, 7}}},
    {name = "artifact cookie",          icon = {11, 6},    faces = {neswtb = {11, 6}}, tag = "cookie"},
    {name = "vector jump",              icon = {12, 6},    faces = {nesw = {2, 6}, t = {12, 6}, b = {1, 6}}, isJumpPad = true},
    {name = "vector teleport",          icon = {13, 6},    faces = {nesw = {2, 6}, t = {13, 6}, b = {1, 6}}, tag = "teleporter"},

}

return {blocks = blocks, tiles = tiles, entities = entities}
