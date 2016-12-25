--------------------------------------------------
local function makeMediumModel (model, options)
    return
    {
        id = model,
        filename = "models/" .. model .. ".vox",
        options = options,
    }
end

--------------------------------------------------
local mediumModels =
{
    makeMediumModel ("rob", {isDetailedModel = true}),
    makeMediumModel ("stairs"),
    makeMediumModel ("cube"),
    makeMediumModel ("cross"),
    makeMediumModel ("pole"),
    makeMediumModel ("pole_n"),
    makeMediumModel ("pole_ne"),
    makeMediumModel ("pole_ns"),
    makeMediumModel ("pole_nes"),
    makeMediumModel ("pole_nesw"),
    makeMediumModel ("wall"),
    makeMediumModel ("wall_n"),
    makeMediumModel ("wall_ne"),
    makeMediumModel ("wall_ns"),
    makeMediumModel ("wall_nes"),
    makeMediumModel ("wall_nesw"),
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
    makeEntityModel ("test_entity_model"),
}

--------------------------------------------------
local entities =
{
    sign = {type = "SIGN", text = "Placeholder Text"}
}

--------------------------------------------------
local modes = dio.types.tileModes

local grassRandom =
{
    mode = modes.RANDOM_4, 
    uvs = {{4, 13}, {5, 13}, {6, 13}, {7, 13}},
}

--------------------------------------------------
local function grass (x, y)
    return
    {
        mode = modes.RANDOM_2,
        uvs = {{x, y}, {x, y + 1}},
    }
end

--------------------------------------------------
local grassTopAutotile =
{
    mode = modes.AUTOTILE_4,
    uvs = 
    {
        grass (0, 14), grass (1, 14), grass (2, 14), grass (3, 14), 
        grass (4, 14), grass (5, 14), grass (6, 14), grass (7, 14), 
        grass (8, 14), grass (9, 14), grass (10, 14), grass (11, 14), 
        grass (12, 14), grass (13, 14), grass (14, 14), grassRandom
    },
}

--------------------------------------------------
local granite =
{
    mode = modes.RANDOM_16,
    uvs ={{6, 10}, {7, 10}, {7, 10}, {8, 10}},
}

--------------------------------------------------
local leafRandom =
{
    mode = modes.RANDOM_8,
    uvs ={{4, 3}, {5, 3}, {5, 3}, {8, 3}},
}

--------------------------------------------------
local trunkRandomN =
{
    mode = modes.RANDOM_256,
    uvs =
    {
        {8, 5}, {4, 1}, 
    },
}

--------------------------------------------------
local trunkRandomE =
{
    mode = modes.RANDOM_256,
    uvs =
    {
        {4, 1}, {8, 5}, {4, 1}, 
    },
}

--------------------------------------------------
local trunkRandomS =
{
    mode = modes.RANDOM_256,
    uvs =
    {
        {4, 1}, {4, 1}, {8, 5}, {4, 1}, 
    },
}

--------------------------------------------------
local trunkRandomW =
{
    mode = modes.RANDOM_256,
    uvs =
    {
        {4, 1}, {4, 1}, {4, 1}, {8, 5}, {4, 1}, 
    },
}

--------------------------------------------------
local function fences (model, textures, textures2)
    return 
    {
        mode = 1,--dio.types.blockModes.AUTOTILE_4,
        models = 
        {   
            {model = model,        textures = {neswtb = textures}, isTransparent = true},
            {model = model .. "_n",      textures = {neswtb = textures}, isTransparent = true},
            {model = model .. "_n",      textures = {neswtb = textures}, isTransparent = true, rotateY = 3},
            {model = model .. "_ne",     textures = {neswtb = textures}, isTransparent = true},
            {model = model .. "_n",      textures = {neswtb = textures}, isTransparent = true, rotateY = 2},
            {model = model .. "_ns",     textures = {neswtb = textures2 or textures}, isTransparent = true},
            {model = model .. "_ne",     textures = {neswtb = textures}, isTransparent = true, rotateY = 3},
            {model = model .. "_nes",    textures = {neswtb = textures}, isTransparent = true},

            {model = model .. "_n",      textures = {neswtb = textures}, isTransparent = true, rotateY = 1},
            {model = model .. "_ne",     textures = {neswtb = textures}, isTransparent = true, rotateY = 1},
            {model = model .. "_ns",     textures = {neswtb = textures2 or textures}, isTransparent = true, rotateY = 1},
            {model = model .. "_nes",    textures = {neswtb = textures}, isTransparent = true, rotateY = 1},
            {model = model .. "_ne",     textures = {neswtb = textures}, isTransparent = true, rotateY = 2},
            {model = model .. "_nes",    textures = {neswtb = textures}, isTransparent = true, rotateY = 2},
            {model = model .. "_nes",    textures = {neswtb = textures}, isTransparent = true, rotateY = 3},
            {model = model .. "_nesw",   textures = {neswtb = textures}, isTransparent = true},
        }
    }

end

--------------------------------------------------
local blocks =
{
    -- 0 = air
    -- 1
    {name = "grass",                icon = {3, 0},      textures = {t = grassTopAutotile, b = {2, 0}, nesw = {3, 0}}},
    {name = "mud",                  icon = {2, 0},      textures = {neswtb = {2, 0}}},
    {name = "granite",              icon = {1, 0},      textures = {neswtb = granite}},
    {name = "obsidian",             icon = {5, 2},      textures = {neswtb = {5, 2}}},
    {name = "sand",                 icon = {2, 1},      textures = {neswtb = {2, 1}}},
    {name = "snowy grass",          icon = {2, 0},      textures = {t = {2, 4}, b = {2, 0}, nesw = {4, 4}}},
    {name = "brick",                icon = {7, 0},      textures = {neswtb = {7, 0}}},
    {name = "tnt",                  icon = {10, 0},     textures = {t = {9, 0}, b = {10, 0}, nesw = {8, 0}}},
    {name = "pumpkin",              icon = {7, 7},      textures = {n = {7, 7}, esw = {6, 7}, t = {6, 6}, b = {10, 8}}},

    -- 10
    {name = "jump pad",             icon = {13, 6},     textures = {t = {11, 6}, b = {13, 6}, nesw = {12, 6}},    isJumpPad = true},
    {name = "cobble",               icon = {0, 1},      textures = {neswtb = {0, 1}}},
    {name = "trunk",                icon = {5, 1},      textures = {tb = {5, 1}, n = trunkRandomN, e = trunkRandomE, s = trunkRandomS, w = trunkRandomW}},
    {name = "wood",                 icon = {4, 0},      textures = {neswtb = {4, 0}}},
    {name = "leaf",                 icon = {4, 3},      textures = {neswtb = leafRandom}},
    {name = "glass",                icon = {1, 3},      textures = {neswtb = {1, 3}},                   isTransparent = true,    hidesMatching = true},
    {name = "lit pumpkin",          icon = {8, 7},      textures = {n = {8, 7}, esw = {6, 7}, t = {6, 6}, b = {10, 8}}},
    {name = "melon",                icon = {9, 8},      textures = {tb = {9, 8}, nesw = {8, 8}}},
    {name = "crafting table",       icon = {11, 2},     textures = {neswtb = {11, 2}}},

    -- 19
    {name = "gold",                 icon = {7, 1},      textures = {neswtb = {7, 1}}},
    {name = "slab",                 icon = {5, 0},      textures = {tb = {6, 0}, nesw = {5, 0}}},
    {name = "big slab",             icon = {6, 0},      textures = {neswtb = {6, 0}}},
    {name = "gravel",               icon = {3, 1},      textures = {neswtb = {3, 1}}},
    {name = "bedrock",              icon = {1, 1},      textures = {neswtb = {1, 1}}},
    {name = "wood panel",           icon = {9, 1},      textures = {neswtb = {9, 1}}},
    {name = "books",                icon = {4, 0},      textures = {tb = {4, 0}, nesw = {3, 2}}},
    {name = "mossy cobble",         icon = {4, 2},      textures = {neswtb = {4, 2}}},
    {name = "stone brick",          icon = {6, 3},      textures = {neswtb = {6, 3}}},

    -- 28
    {name = "sponge",               icon = {8, 4},      textures = {neswtb = {8, 4}}},
    {name = "herringbone",          icon = {10, 4},     textures = {neswtb = {10, 4}}},
    {name = "black wool",           icon = {1, 7},      textures = {neswtb = {1, 7}}},
    {name = "dark grey wool",       icon = {2, 7},      textures = {neswtb = {2, 7}}},
    {name = "light grey wool",      icon = {3, 13},     textures = {neswtb = {3, 13}}},
    {name = "white wool",           icon = {0, 4},      textures = {neswtb = {0, 4}}},
    {name = "dark cyan wool",       icon = {1, 13},     textures = {neswtb = {1, 13}}},
    {name = "brown wool",           icon = {1, 10},     textures = {neswtb = {1, 10}}},
    {name = "pink wool",            icon = {2, 8},      textures = {neswtb = {2, 8}}},

    -- 37
    {name = "light blue wool",      icon = {2, 11},     textures = {neswtb = {2, 11}}},
    {name = "light green wool",     icon = {2, 9},      textures = {neswtb = {2, 9}}},
    {name = "yellow wool",          icon = {2, 10},     textures = {neswtb = {2, 10}}},
    {name = "orange wool",          icon = {2, 13},     textures = {neswtb = {2, 13}}},
    {name = "red wool",             icon = {1, 8},      textures = {neswtb = {1, 8}}},
    {name = "violet wool",          icon = {2, 12},     textures = {neswtb = {2, 12}}},
    {name = "purple wool",          icon = {1, 12},     textures = {neswtb = {1, 12}}},
    {name = "dark blue wool",       icon = {1, 11},     textures = {neswtb = {1, 11}}},
    {name = "dark green wool",      icon = {1, 9},      textures = {neswtb = {1, 9}}},

    -- 46
    {name = "floating sign",        icon = {15, 13},    textures = {neswtb = {15, 13}},         entity = "sign"},
    {name = "grass",                icon = {7, 2},      textures = {neswtb = {7, 2}},           model = "cross",    isSolid = false},
    {name = "red flower",           icon = {12, 0},     textures = {neswtb = {12, 0}},          model = "cross",    isSolid = false},
    {name = "yellow flower",        icon = {13, 0},     textures = {neswtb = {13, 0}},          model = "cross",    isSolid = false},
    {name = "red mushroom",         icon = {12, 1},     textures = {neswtb = {12, 1}},          model = "cross",    isSolid = false},
    {name = "brown mushroom",       icon = {13, 1},     textures = {neswtb = {13, 1}},          model = "cross",    isSolid = false},
    {name = "sapling",              icon = {15, 0},     textures = {neswtb = {15, 0}},          model = "cross",    isSolid = false},
    {name = "bamboo",               icon = {9, 4},      textures = {neswtb = {9, 4}},           model = "cross",    isSolid = false},
    {name = "wheat",                icon = {15, 5},     textures = {neswtb = {15, 5}},          model = "cross",    isSolid = false},

    -- 55
    {name = "bush",                 icon = {7, 3},      textures = {neswtb = {7, 3}},           model = "cross",    isSolid = false},
    {name = "stem",                 icon = {15, 6},     textures = {neswtb = {15, 6}},          model = "cross",    isSolid = false},
    {name = "cactus top",           icon = {6, 4},      textures = {t = {5, 4}, b = {7, 4}, nesw = {6, 4}}},
    {name = "cactus body",          icon = {7, 4},      textures = {tb = {7, 4}, nesw = {6, 4}}},
    {name = "gravity block",        icon = {13, 6},     textures = {t = {10, 6}, b = {13, 6}, nesw = {12, 6}}},
    {name = "all grass",            icon = {0, 0},      textures = {neswtb = {0, 0}}},
    {name = "water",                icon = {14, 0},     textures = {neswtb = {14, 0}},         isLiquid = true},
    {name = "ice",                  icon = {3, 4},      textures = {neswtb = {3, 4}}},
    {name = "coal block",           icon = {14, 1},     textures = {neswtb = {14, 1}}},

    -- 64
    {name = "gold ore",             icon = {0, 2},      textures = {neswtb = {0, 2}}},
    {name = "iron ore",             icon = {1, 2},      textures = {neswtb = {1, 2}}},
    {name = "coal ore",             icon = {2, 2},      textures = {neswtb = {2, 2}}},
    {name = "diamond ore",          icon = {2, 3},      textures = {neswtb = {2, 3}}},
    {name = "red ore",              icon = {3, 3},      textures = {neswtb = {3, 3}}},
    {name = "lapis ore",            icon = {0, 10},     textures = {neswtb = {0, 10}}},
    {name = "smooth sandstone",     icon = {0, 11},     textures = {neswtb = {0, 11}}},
    {name = "sandstone brick",      icon = {0, 12},     textures = {neswtb = {0, 12}}},
    {name = "hellrock",             icon = {7, 6},      textures = {neswtb = {7, 6}}},

    -- 73
    {name = "hellsand",             icon = {8, 6},      textures = {neswtb = {8, 6}}},
    {name = "spawner",              icon = {1, 4},      textures = {neswtb = {1, 4}},       isTransparent = true},
    {name = "stairs",               icon = {4, 0},      textures = {neswtb = {4, 0}},       model = "stairs",   rotatable = true},
    {name = "wood fence",           icon = {1, 0},      models = fences ("pole", {1, 0})},
    {name = "stone fence",          icon = {0, 12},     models = fences ("pole", {0, 12})},
    {name = "black fence",          icon = {1, 1},      models = fences ("pole", {1, 1})},
    {name = "wall",                 icon = {15, 1},     models = fences ("wall", {15, 1}, {15, 2})},
    {name = "head",                 icon = {15, 1},     model = "rob"},
    {name = "axle block",           icon = {15, 4},     textures = {neswtb = {15, 4}}, isAxle = true},

    -- 82
    {name = "spanner",              icon = {14, 4},     textures = {neswtb = {15, 4}}, tag = "spanner"},
    {name = "test_model",           icon = {3, 3},      entityModel = "test_entity_model"}
}

return {blocks = blocks, entities = entities, mediumModels = mediumModels, entityModels = entityModels}
