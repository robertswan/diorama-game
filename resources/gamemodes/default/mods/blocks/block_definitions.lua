--------------------------------------------------
-- TODO turn this into an enum
local modes =
{
    repeat1x1 = 0,
    autotile4 = 1,
}

---------------------------------------------------
local tiles =
{
    -- {mode = modes.repeat1x1, faces = {3, 0}},                         -- side of grass (1)
    -- {mode = modes.repeat2x2, faces = {7, 12, 8, 12, 7, 13, 8, 13}},   -- grass (2)
    -- {mode = modes.repeat1x1, faces = {2, 0}},                         -- mud (2)
 }

--------------------------------------------------
local entities =
{
    sign = {type = "SIGN", text = "Placeholder Text"}
}


--------------------------------------------------
-- got to list 16 things... bit 1 = north, bit 2 = east, bit 3 = south, bit 4 = west, bit 5 = top, bit 6 = bottom

--------------------------------------------------
local grassTop2x2 =
{
    mode = modes.repeat2x2, 
    faces = {{7, 12}, {8, z12}, {7, 13}, {8, 13}},
}

local grassTop2x2 =
{
    mode = modes.random2x2, 
    faces = {{7, 12}, {8, z12}, {7, 13}, {8, 13}},
}

local grassTopAutotile =
{
    mode = modes.autotile4,
    uvs = {grassTop2x2, {1, 14}, {2, 14}, {3, 14}, {4, 14}, {5, 14}, {6, 14}, {7, 14}, {8, 14}, {9, 14}, {10, 14}, {11, 14}, {12, 14}, {13, 14}, {14, 14}, {15, 14}},
}

--------------------------------------------------
local blocks =
{
    -- 0 = air
    -- 1
    {name = "grass",                icon = {3, 0},      faces = {t = grassTopAutotile, b = {2, 0}, nesw = {3, 0}}},
    {name = "mud",                  icon = {2, 0},      faces = {neswtb = {2, 0}}},
    {name = "granite",              icon = {1, 0},      faces = {neswtb = {1, 0}}},
    {name = "obsidian",             icon = {5, 2},      faces = {neswtb = {5, 2}}},
    {name = "sand",                 icon = {2, 1},      faces = {neswtb = {2, 1}}},
    {name = "snowy grass",          icon = {2, 0},      faces = {t = {4, 4}, b = {2, 4}, nesw = {2, 0}}},
    {name = "brick",                icon = {7, 0},      faces = {neswtb = {7, 0}}},
    {name = "tnt",                  icon = {10, 0},     faces = {t = {8, 0}, b = {9, 0}, nesw = {10, 0}}},
    {name = "pumpkin",              icon = {7, 7},      faces = {n = {7, 7}, esw = {6, 7}, tb = {6, 6}}},

    -- 10
    {name = "jump pad",             icon = {13, 6},     faces = {t = {12, 6}, b = {11, 6}, nesw = {13, 6}},    isJumpPad = true},
    {name = "cobble",               icon = {0, 1},      faces = {neswtb = {0, 1}}},
    {name = "trunk",                icon = {5, 1},      faces = {tb = {5, 1}, nesw = {4, 1}}},
    {name = "wood",                 icon = {4, 0},      faces = {neswtb = {4, 0}}},
    {name = "leaf",                 icon = {4, 3},      faces = {neswtb = {4, 3}},                   isTransparent = false},
    {name = "glass",                icon = {1, 3},      faces = {neswtb = {1, 3}},                   isTransparent = true,    hidesMatching = true},
    {name = "lit pumpkin",          icon = {8, 7},      faces = {n = {8, 7}, esw = {6, 7}, tb = {6, 6}}},
    {name = "melon",                icon = {9, 8},      faces = {t = {8, 8}, b = {9, 8}, nesw = {9, 8}}},
    {name = "crafting table",       icon = {11, 2},     faces = {neswtb = {11, 2}}},

    -- 19
    {name = "gold",                 icon = {7, 1},      faces = {neswtb = {7, 1}}},
    {name = "slab",                 icon = {5, 0},      faces = {t = {5, 0}, b = {6, 0}, nesw = {6, 0}}},
    {name = "big slab",             icon = {6, 0},      faces = {neswtb = {6, 0}}},
    {name = "gravel",               icon = {3, 1},      faces = {neswtb = {3, 1}}},
    {name = "bedrock",              icon = {1, 1},      faces = {neswtb = {1, 1}}},
    {name = "wood panel",           icon = {9, 1},      faces = {neswtb = {9, 1}}},
    {name = "books",                icon = {4, 0},      faces = {t = {3, 2}, b = {4, 0}, nesw = {4, 0}}},
    {name = "mossy cobble",         icon = {4, 2},      faces = {neswtb = {4, 2}}},
    {name = "stone brick",          icon = {6, 3},      faces = {neswtb = {6, 3}}},

    -- 28
    {name = "sponge",               icon = {8, 4},      faces = {neswtb = {8, 4}}},
    {name = "herringbone",          icon = {10, 4},     faces = {neswtb = {10, 4}}},
    {name = "black wool",           icon = {1, 7},      faces = {neswtb = {1, 7}}},
    {name = "dark grey wool",       icon = {2, 7},      faces = {neswtb = {2, 7}}},
    {name = "light grey wool",      icon = {1, 14},     faces = {neswtb = {1, 14}}},
    {name = "white wool",           icon = {0, 4},      faces = {neswtb = {0, 4}}},
    {name = "dark cyan wool",       icon = {1, 13},     faces = {neswtb = {1, 13}}},
    {name = "brown wool",           icon = {1, 10},     faces = {neswtb = {1, 10}}},
    {name = "pink wool",            icon = {2, 8},      faces = {neswtb = {2, 8}}},

    -- 37
    {name = "light blue wool",      icon = {2, 11},     faces = {neswtb = {2, 11}}},
    {name = "light green wool",     icon = {2, 9},      faces = {neswtb = {2, 9}}},
    {name = "yellow wool",          icon = {2, 10},     faces = {neswtb = {2, 10}}},
    {name = "orange wool",          icon = {2, 13},     faces = {neswtb = {2, 13}}},
    {name = "red wool",             icon = {1, 8},      faces = {neswtb = {1, 8}}},
    {name = "violet wool",          icon = {2, 12},     faces = {neswtb = {2, 12}}},
    {name = "purple wool",          icon = {1, 12},     faces = {neswtb = {1, 12}}},
    {name = "dark blue wool",       icon = {1, 11},     faces = {neswtb = {1, 11}}},
    {name = "dark green wool",      icon = {1, 9},      faces = {neswtb = {1, 9}}},

    -- 46
    {name = "floating sign",        icon = {0, 15},     faces = {neswtb = {0, 15}},          entity = "sign"},
    {name = "grass",                icon = {7, 2},      faces = {neswtb = {7, 2}},           shape = "cross",    isSolid = false},
    {name = "red flower",           icon = {12, 0},     faces = {neswtb = {12, 0}},          shape = "cross",    isSolid = false},
    {name = "yellow flower",        icon = {13, 0},     faces = {neswtb = {13, 0}},          shape = "cross",    isSolid = false},
    {name = "red mushroom",         icon = {12, 1},     faces = {neswtb = {12, 1}},          shape = "cross",    isSolid = false},
    {name = "brown mushroom",       icon = {13, 1},     faces = {neswtb = {13, 1}},          shape = "cross",    isSolid = false},
    {name = "sapling",              icon = {15, 0},     faces = {neswtb = {15, 0}},          shape = "cross",    isSolid = false},
    {name = "bamboo",               icon = {9, 4},      faces = {neswtb = {9, 4}},           shape = "cross",    isSolid = false},
    {name = "wheat",                icon = {15, 5},     faces = {neswtb = {15, 5}},          shape = "cross",    isSolid = false},

    -- 55
    {name = "bush",                 icon = {7, 3},      faces = {neswtb = {7, 3}},           shape = "cross",    isSolid = false},
    {name = "stem",                 icon = {15, 6},     faces = {neswtb = {15, 6}},          shape = "cross",    isSolid = false},
    {name = "cactus top",           icon = {6, 4},      faces = {t = {6, 4}, b = {5, 4}, nesw = {7, 4}}},
    {name = "cactus body",          icon = {7, 4},      faces = {t = {6, 4}, b = {7, 4}, nesw = {7, 4}}},
    {name = "gravity block",        icon = {13, 6},     faces = {t = {12, 6}, b = {10, 6}, nesw = {13, 6}}},
    {name = "all grass",            icon = {0, 0},      faces = {neswtb = {0, 0}}},
    {name = "water",                icon = {14, 0},     faces = {neswtb = {14, 0}},         isLiquid = true},
    {name = "ice",                  icon = {3, 4},      faces = {neswtb = {3, 4}}},
    {name = "coal block",           icon = {14, 1},     faces = {neswtb = {14, 1}}},

    -- 64
    {name = "gold ore",             icon = {0, 2},      faces = {neswtb = {0, 2}}},
    {name = "iron ore",             icon = {1, 2},      faces = {neswtb = {1, 2}}},
    {name = "coal ore",             icon = {2, 2},      faces = {neswtb = {2, 2}}},
    {name = "diamond ore",          icon = {2, 3},      faces = {neswtb = {2, 3}}},
    {name = "red ore",              icon = {3, 3},      faces = {neswtb = {3, 3}}},
    {name = "lapis ore",            icon = {0, 10},     faces = {neswtb = {0, 10}}},
    {name = "smooth sandstone",     icon = {0, 11},     faces = {neswtb = {0, 11}}},
    {name = "sandstone brick",      icon = {0, 12},     faces = {neswtb = {0, 12}}},
    {name = "hellrock",             icon = {7, 6},      faces = {neswtb = {7, 6}}},

    -- 73
    {name = "hellsand",             icon = {8, 6},      faces = {neswtb = {8, 6}}},
    {name = "spawner",              icon = {1, 4},      faces = {neswtb = {1, 4}},           isTransparent = true},
}

return {blocks = blocks, tiles = tiles, entities = entities}
