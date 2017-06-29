local settings =
{
    isMap = false,

    spawn = 
    {
        xyz         = {-28, 8, 95},
        ypr         = {0, 0, 0},
        gravityDir  = 5,
    },

    cameraSettings =
    {
        fps =
        {
            cameraType = dio.types.cameraTypes.FPS,
            fov = 90,
        },
        overhead =
        {
            projectionType = dio.types.projectionTypes.PERSPECTIVE,
            cameraType = dio.types.cameraTypes.LOOK_AT,
            fov = 80,
            lookAt = {6, 0, -8},
            offset = {0, 16, 8},
        },
    },

    itemsAvailable = 
    {
        {id = "smallAxe",               description = "Small Axe"},
        {id = "smallJumpBoots",         description = "Small Jump Boots", jumpSpeed = 12.0},
        {id = "iceShield",              description = "Ice Shield"},
        {id = "belt",                   description = "Belt of Strength"},
        {id = "fireShield",             description = "Fire Shield"},
        {id = "teleporter",             description = "Teleporter"},
        {id = "largeJumpBoots",         description = "Large Jump Boots", jumpSpeed = 15.0},
        {id = "bean",                   description = "Magic Beans"},
        {id = "bigAxe",                 description = "Big Axe"},
    },
    
    --shipXyz = {-32, -8, 88},
    
    mapTopLeftChunkOrigin = {-1, -1},
    ship = {0, 15},
    worldLimits = {16, 16},
    worlds = 
    {
        {name = "Tiny Grass World 1",    xz = {0, 12},   timeOfDay = "0 1 0"},
        {name = "Tiny Grass World 2",    xz = {3, 13},   timeOfDay = "0 1 0"},
        {name = "Tiny Grass World 3",    xz = {5, 15},   timeOfDay = "0 1 0"},
        {name = "Tiny Grass World 4",    xz = {9, 12},   timeOfDay = "0 1 0"},
        {name = "Tiny Grass World 5",    xz = {4, 4},    timeOfDay = "0 1 0"},
        {name = "Tiny Vector World",     xz = {3, 7},    timeOfDay = "1 0 1"},
        {name = "Tiny Rot World",        xz = {1, 1},    timeOfDay = "1 0.5 0"},
        {name = "Tiny Ice World",        xz = {15, 15},  timeOfDay = "0 0 1"},
        {name = "Tiny Desert World",     xz = {9, 2},    timeOfDay = "1 1 0"},
        {name = "Tiny Toxic World",      xz = {13, 3},   timeOfDay = "0 1 0"},
        {name = "Tiny Binary Sun World", xz = {10, 5},   timeOfDay = "1 1 0"},

        {name = "Tiny Asteroid World 1",      xz = {5, 10},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 2",      xz = {7, 10},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 3",      xz = {10, 10},  timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 4",      xz = {14, 10},  timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 5",      xz = {15, 8},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 6",      xz = {15, 4},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 7",      xz = {15, 2},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 8",      xz = {14, 0},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 9",      xz = {11, 0},   timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 10",     xz = {7, 0},    timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 11",     xz = {5, 0},    timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 12",     xz = {5, 3},    timeOfDay = "0.3 0.3 0.3"},
        {name = "Tiny Asteroid World 13",     xz = {5, 7},    timeOfDay = "0.3 0.3 0.3"},

        {name = "Tiny Artifact Homeworld",    xz = {1, 15},    timeOfDay = "1 0 0"},
    },

    artifactHomeworldChunk = {-1, 0, 2},
    artifactBlocks =
    {
        {blockId = 81, xyz = {8, 1, 24}},
        {blockId = 82, xyz = {15, 2, 24}},
        {blockId = 83, xyz = {15, 3, 31}},
        {blockId = 84, xyz = {8, 4, 31}},
        {blockId = 85, xyz = {13, 5, 27}},
        {blockId = 86, xyz = {10, 6, 28}},
    },

    cookieBlocks = 
    {
        {13, 1, 26},
        {10, 1, 26},
        {10, 1, 29},
        {13, 1, 29},
    }
}

return settings
