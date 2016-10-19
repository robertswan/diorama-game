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
    {name = "ship tile",                faces = {neswtb = {4, 1}}},
    {name = "ship base",                faces = {neswtb = {3, 1}}},
    {name = "metal pillar",             faces = {neswtb = {6, 0}}, shape = "pole"},
    {name = "computer",                 faces = {newtb = {3, 0}, s = {2, 0}}, tag ="computer"},
    {name = "grass",                    faces = {nesw = {10, 0}, t = {9, 0}, b ={11, 0}}},
    {name = "mud",                      faces = {neswtb = {11, 0}}},
    {name = "tree trunk big",           faces = {nesw = {1, 1}, tb = {2, 1}}, tag = "bigAxe"},
    {name = "tree trunk small",         faces = {nesw = {5, 0}, tb = {2, 1}}, shape = "pole", tag = "smallAxe"},
    {name = "leaves",                   faces = {neswtb = {7, 0}}},

    -- 10    
    {name = "thin grass",               faces = {neswtb = {8, 0}}, shape = "cross", isSolid = false},
    {name = "concrete",                 faces = {neswtb = {1, 0}}},
    {name = "concrete breakable",       faces = {neswtb = {9, 3}}, tag = "belt"},
    {name = "vector tile",              faces = {neswtb = {1, 6}}},
    {name = "vector brick",             faces = {nesw = {2, 6}, tb = {1, 6}}},
    {name = "vector breakable brick",   faces = {neswtb = {3, 6}}, tag = "belt"},
    {name = "vector pole",              faces = {nesw = {5, 6}, tb = {1, 6}}, shape = "pole"},
    {name = "vector grass",             faces = {neswtb = {6, 6}}, shape = "cross", isSolid = false},
    {name = "vector glass",             faces = {neswtb = {4, 6}}, isTransparent = true},
    {name = "vector circle",            faces = {neswtb = {7, 6}}},

    -- 20
    {name = "ice rock",                 faces = {neswtb = {2, 3}}},
    {name = "ice layer 1",              faces = {nesw = {3, 3}, t = {1, 3}, b = {2, 3}}},
    {name = "ice layer 2",              faces = {nesw = {4, 3}, t = {1, 3}, b = {2, 3}}},
    {name = "ice breakable",            faces = {neswtb = {8, 3}}, tag = "belt"},
    {name = "ice tree",                 faces = {nesw = {7, 3}, tb = {6, 3}}},
    {name = "ice trunk thin",           faces = {nesw = {5, 3}, tb = {6, 3}}, shape = "pole", tag = "smallAxe"},
    {name = "sand brick",               faces = {nesw = {1, 2}, tb = {4, 2}}},
    {name = "sand breakable brick",     faces = {neswtb = {5, 2}}, tag = "belt"},
    {name = "sand",                     faces = {neswtb = {0, 2}}},
    {name = "sand column",              faces = {neswtb = {3, 2}}},

    -- 30
    {name = "sand column ridged",       faces = {neswtb = {2, 2}}},
    {name = "cactus",                   faces = {neswtb = {9, 2}}, shape = "cross", isSolid = false},
    {name = "sand jump pad",            faces = {nesw = {0, 2}, t = {6, 2}, b = {0, 2}}, isJumpPad = true},
    {name = "sand teleporter",          faces = {nesw = {0, 2}, t = {7, 2}, b = {0, 2}}, tag = "teleporter"},
    {name = "sand pole",                faces = {nesw = {8, 2}, tb = {0, 2}}, shape = "pole"},
    {name = "sun bright 1",             faces = {neswtb = {0, 7}}},
    {name = "sun bright 2",             faces = {neswtb = {1, 7}}},
    {name = "sun bright 3",             faces = {neswtb = {2, 7}}},
    {name = "sun bright 4",             faces = {neswtb = {3, 7}}},
    {name = "rot brick clean",          faces = {neswtb = {1, 4}}},

    -- 40
    {name = "rot brick roots",          faces = {neswtb = {2, 4}}},
    {name = "rot vines X",              faces = {neswtb = {4, 4}},        shape = "cross", isSolid = false},
    {name = "rot vines []",             faces = {neswtb = {4, 4}}, isTransparent = true, isSolid = false},
    {name = "rot trunk",                faces = {neswtb = {12, 4}}, tag = "bigAxe"},
    {name = "rot trunk thin",           faces = {nesw = {11, 4}, tb = {12, 4}}, shape = "pole", tag = "smallAxe"},
    {name = "rot leaves clean",         faces = {neswtb = {13, 4}}},
    {name = "rot leaves vinish",        faces = {nesw = {15, 4}, t = {13, 4}, b = {15, 4}}},
    {name = "rot leaves vines",         faces = {neswtb = {14, 4}}},
    {name = "castle brics",             faces = {neswtb = {5, 4}}},
    {name = "castle brics vinish",      faces = {nesw = {6, 4}, t = {5, 4}, b = {6, 4}}},

    -- 50
    {name = "castle roof",              faces = {nesw = {8, 4}, t = {7, 4}, b = {5, 4}}},
    {name = "castle door",              faces = expandAllFaces (10, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4)},
    {name = "castle clock",             faces = expandAllFaces (5, 4, 5, 4, 9, 4, 5, 4, 5, 4, 5, 4)},
    {name = "nuke brick",               faces = {neswtb = {0, 5}}},
    {name = "nuke scaffold",            faces = {neswtb = {1, 5}}, isTransparent = true},
    {name = "nuke pole",                faces = {neswtb = {2, 5}}, shape = "pole"},
    {name = "nuke waste",               faces = {nesw = {6, 5}, t = {5, 5}, b = {7, 5}}},
    {name = "nuke bean",                faces = {nesw = {0, 5}, t = {3, 5}, b = {0, 5}}, tag = "bean"},
    {name = "nuke jumppad",             faces = {nesw = {0, 5}, t = {4, 5}, b = {0, 5}}, isJumpPad = true},
    {name = "nuke teleporter",          faces = {nesw = {0, 5}, t = {8, 5}, b = {0, 5}}, tag = "teleporter"},

    -- 60
    {name = "DO NOT USE (item)",        faces = {nesw = {15, 15}, t = {0, 8}, b = {15, 15}}},
    {name = "DO NOT USE (art)",         faces = {nesw = {15, 15}, t = {0, 9}, b = {15, 15}}},
    {name = "small rocks",              faces = {neswtb = {9, 5}}},
    {name = "rock teleporter",          faces = {nesw = {1, 0}, t = {6, 1}, b = {1, 0}}, tag = "teleporter"},
    {name = "rock pole",                faces = {nesw = {10, 6}, tb = {1, 0}}, shape = "pole"},
    {name = "DO NOT USE (empty)",       faces = {neswb = {15, 15}, t = {5, 8}}},
    {name = "ship teleporter",          faces = {nesw = {4, 1}, t = {8, 6}, b = {4, 1}}, tag = "teleporter"},
    {name = "item chest N",             faces = expandAllFaces (5, 8, 6, 8, 7, 8, 6, 8, 2, 8, 0, 8), tag = "itemChest"}, -- 67
    {name = "item chest E",             faces = expandAllFaces (6, 8, 5, 8, 6, 8, 7, 8, 3, 8, 0, 8), tag = "itemChest"},
    {name = "item chest S",             faces = expandAllFaces (7, 8, 6, 8, 5, 8, 6, 8, 1, 8, 0, 8), tag = "itemChest"},

    -- 70
    {name = "item chest W",             faces = expandAllFaces (6, 8, 7, 8, 6, 8, 5, 8, 4, 8, 0, 8), tag = "itemChest"},
    {name = "artefact chest N",         faces = expandAllFaces (5, 9, 6, 9, 7, 9, 6, 9, 2, 9, 0, 9), tag = "artifactChest"}, -- 71
    {name = "artefact chest E",         faces = expandAllFaces (6, 9, 5, 9, 6, 9, 7, 9, 3, 9, 0, 9), tag = "artifactChest"},
    {name = "artefact chest S",         faces = expandAllFaces (7, 9, 6, 9, 5, 9, 6, 9, 1, 9, 0, 9), tag = "artifactChest"},
    {name = "artefact chest W",         faces = expandAllFaces (6, 9, 7, 9, 6, 9, 5, 9, 4, 9, 0, 9), tag = "artifactChest"},
    {name = "artefact chest N",         faces = expandAllFaces (13, 8, 14, 8, 15, 8, 14, 8, 10, 8, 8, 8)}, -- 75
    {name = "artefact chest E",         faces = expandAllFaces (14, 8, 13, 8, 14, 8, 15, 8, 11, 8, 8, 8)},
    {name = "artefact chest S",         faces = expandAllFaces (15, 8, 14, 8, 13, 8, 14, 8, 9, 8, 8, 8)},
    {name = "artefact chest W",         faces = expandAllFaces (14, 8, 15, 8, 14, 8, 13, 8, 12, 8, 8, 8)},
    {name = "grass jump",               faces = {nesw = {10, 0}, t = {10, 5}, b = {11, 0}}, isJumpPad = true},
    
    -- 80
    {name = "artifact world",           faces = {neswtb = {9, 6}}},
    {name = "artifact block 1",         faces = {nesw = {5, 7}, tb = {14, 7}}},
    {name = "artifact block 2",         faces = {nesw = {6, 7}, tb = {14, 7}}},
    {name = "artifact block 3",         faces = {nesw = {7, 7}, tb = {14, 7}}},
    {name = "artifact block 4",         faces = {nesw = {8, 7}, tb = {14, 7}}},
    {name = "artifact block 5",         faces = {nesw = {9, 7}, tb = {14, 7}}},
    {name = "artifact block 6",         faces = {nesw = {10, 7}, tb = {14, 7}}},
    {name = "artifact cookie",          faces = {neswtb = {11, 6}}, tag = "cookie"},
}

return {blocks = blocks, tiles = tiles, entities = entities}
