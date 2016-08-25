local BlockDefinitions = require ("resources/gamemodes/tiny_galaxy/mods/blocks/block_definitions")

--------------------------------------------------
local instance =
{
    blocks = BlockDefinitions.blocks,

    timeOfDay = 0,
    currentWorldIdx = nil,

    initialJumpSpeed = 10.0,
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
    nextItemIdx = 1,

    inventory = 
    {
        -- smallAxe = true, 
        -- iceShield = true,
        -- belt = true,
        -- fireShield = true,
        -- teleporter = true,
        -- bean = true,
        -- bigAxe = true,
    },
    artifactsCollectedCount = 0,

    shipXyz = {-32, -8, 88},
    
    mapTopLeftChunkOrigin = {-1, -1},
    ship = {0, 15},
    worldLimits = {16, 16},
    worlds = 
    {
        {name = "Tiny Grass World 1",    xz = {0, 12},   timeOfDay = 1},
        {name = "Tiny Grass World 2",    xz = {3, 13},   timeOfDay = 2},
        {name = "Tiny Grass World 3",    xz = {5, 15},   timeOfDay = 3},
        {name = "Tiny Grass World 4",    xz = {9, 12},   timeOfDay = 4},
        {name = "Tiny Grass World 5",    xz = {4, 4},    timeOfDay = 5},
        {name = "Tiny Vector World",     xz = {3, 7},    timeOfDay = 6},
        {name = "Tiny Rot World",        xz = {1, 1},    timeOfDay = 7},
        {name = "Tiny Ice World",        xz = {15, 15},  timeOfDay = 8},
        {name = "Tiny Desert World",     xz = {9, 2},    timeOfDay = 9},
        {name = "Tiny Toxic World",      xz = {13, 3},   timeOfDay = 10},
        {name = "Tiny Binary Sun World", xz = {10, 5},   timeOfDay = 11},

        {name = "Tiny Asteroid World 1",      xz = {5, 10},   timeOfDay = 23},
        {name = "Tiny Asteroid World 2",      xz = {7, 10},   timeOfDay = 23},
        {name = "Tiny Asteroid World 3",      xz = {10, 10},  timeOfDay = 23},
        {name = "Tiny Asteroid World 4",      xz = {14, 10},  timeOfDay = 23},
        {name = "Tiny Asteroid World 5",      xz = {15, 8},   timeOfDay = 23},
        {name = "Tiny Asteroid World 6",      xz = {15, 4},   timeOfDay = 23},
        {name = "Tiny Asteroid World 7",      xz = {15, 2},   timeOfDay = 23},
        {name = "Tiny Asteroid World 8",      xz = {14, 0},   timeOfDay = 23},
        {name = "Tiny Asteroid World 9",      xz = {11, 0},   timeOfDay = 23},
        {name = "Tiny Asteroid World 10",     xz = {7, 0},    timeOfDay = 23},
        {name = "Tiny Asteroid World 11",     xz = {5, 0},    timeOfDay = 23},
        {name = "Tiny Asteroid World 12",     xz = {5, 3},    timeOfDay = 23},
        {name = "Tiny Asteroid World 13",     xz = {5, 7},    timeOfDay = 23},
    }    
}

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function calcIsSafeMove (moveDelta)
    local newX = instance.ship [1] + moveDelta [1]
    local newZ = instance.ship [2] + moveDelta [2]

    if newX < 0 or newZ < 0 or newX >= instance.worldLimits [1] or newZ >= instance.worldLimits [2] then
        return false
    end

    for _, world in ipairs (instance.worlds) do
        if newX == world.xz [1] and newZ == world.xz [2] then
            return false
        end
    end

    if not instance.inventory.iceShield then
        if newX >= 14 and newZ >= 14 then
            return false
        end
    end

    if not instance.inventory.fireShield then
        if newX >= 5 and newZ <= 10 then
            return false
        end
    end

    return true
end

--------------------------------------------------
local function convertHourToTime (hour)
    -- assume texture is 32 wide
    local time = (hour + 0.5) * 60 * 60
    return time
end

--------------------------------------------------
local function moveShipAndPlayer (connectionId, xyz, moveDelta)

    if calcIsSafeMove (moveDelta) then

        local origin = instance.mapTopLeftChunkOrigin
        local ship = instance.ship
        local minY = -8

        local newShipXyz =
        {
            (ship [1] + moveDelta [1]) * 8,
            minY,
            (ship [2] + moveDelta [2]) * 8,
        }

        local shipTo = 
        {
            chunkId = {origin [1], 0, origin [2]},
            xyz = newShipXyz,
        }

        local shipFrom = 
        {
            chunkId = {origin [1], 0, origin [2]},
            xyz = {ship [1] * 8, minY, ship [2] * 8},
            size = {8, 16, 8},
        }

        local clearAir = 
        {
            chunkId = {0, 0, 0},
            xyz = {-32, 32, 88},
            size = {8, 16, 8},
        }    

        dio.world.copyCells (instance.roomEntityId, shipTo, shipFrom)
        dio.world.copyCells (instance.roomEntityId, shipFrom, clearAir)

        local teleport = 
                "delta " .. 
                tostring (moveDelta [1] * 8) .. " " ..
                tostring (2) .. " " ..
                tostring (moveDelta [2] * 8)

        dio.network.sendEvent (connectionId, "tinyGalaxy.TP", teleport)

        instance.ship [1] = instance.ship [1] + moveDelta [1]
        instance.ship [2] = instance.ship [2] + moveDelta [2]
    end
end

--------------------------------------------------
local function createNewLevel ()

    dio.file.deleteRoom ("tiny_galaxy/")
    dio.file.copyFolder ("tiny_galaxy/", dio.file.locations.MOD_RESOURCES, "new_saves/default/tiny_galaxy/")

end

--------------------------------------------------
local function createPlayerEntity (connectionId, accountId)
    
    local roomEntityId = dio.world.ensureRoomIsLoaded ("tiny_galaxy/")

    local c = dio.entities.components
    local player =
    {
            -- [components.AABB_COLLIDER] =        {min = {-0.01, -0.01, -0.01}, size = {0.02, 0.02, 0.02},},
            -- [components.COLLISION_LISTENER] =   {onCollision = onRocketAndSceneryCollision,},
            -- [components.MESH_PLACEHOLDER] =     {blueprintId = "ROCKET",},
            -- [components.RIGID_BODY] =           {acceleration = {0.0, -9.806 * 1.0, 0.0},},
        
        [c.BASE_NETWORK] =          {},
        [c.FOCUS] =                 {connectionId = connectionId, radius = 4},
        [c.GRAVITY_TRANSFORM] =
        {
            chunkId =       {0, 0, 0},
            xyz =           {-31, 4, 95},
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
        [c.NAME] =                  {name = "PLAYER", debug = false},
        [c.PARENT] =                {parentEntityId = roomEntityId},
        [c.SERVER_CHARACTER_CONTROLLER] =
        {
            connectionId = connectionId,
            accountId = accountId,
            crouchSpeed = 1.0,
            walkSpeed = 4.0,
            sprintSpeed = 4.0,
            jumpSpeed = instance.initialJumpSpeed,
            highlightBlockIds = {80, 81}, -- todo place in own component
        },
        [c.TEMP_PLAYER] =           {connectionId = connectionId, accountId = accountId},
    }

    return dio.entities.create (roomEntityId, player)
end

--------------------------------------------------
local function onClientConnected (event)

    createNewLevel ()

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        entityId = createPlayerEntity (event.connectionId, event.accountId),
    }

    connections [event.connectionId] = connection

end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]

    dio.entities.destroy (connection.entityId)

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onRoomCreated (event)

    instance.roomEntityId = event.roomEntityId

    local components = dio.entities.components
    local calendarEntity =
    {
        [components.BASE_NETWORK] =
        {
        },
        [components.CALENDAR] =
        {
            time = convertHourToTime (instance.timeOfDay),
            timeMultiplier = 0,
        },
        [components.NAME] =
        {
            name = "CALENDAR",
            debug = false,
        },
        [components.PARENT] =
        {
            parentEntityId = event.roomEntityId,
        },
    }
    
    instance.calendarEntityId = dio.entities.create (event.roomEntityId, calendarEntity)
    print ("onRoomCreated " .. tostring (instance.calendarEntityId))

end

--------------------------------------------------
local function onRoomDestroyed (event)

    instance.roomEntityId = nil

    if instance.isRestartingGame then
        instance.isRestartingGame = false
        createNewLevel ()
        for _, connection in pairs (connections) do
            connection.entityId = createPlayerEntity (connection.connectionId, connection.accountId)
        end
    end
end

--------------------------------------------------
local blockCallbacks = {}

--------------------------------------------------
function blockCallbacks.computer (event, connection) 
        
    local xyz = dio.world.getPlayerXyz (connection.accountId)
    local yaw = xyz.ypr [2]

    local delta = {0, -1}
    if yaw < (math.pi * 0.25) then
        
    elseif yaw < (math.pi * (0.25 + 0.5 * 1)) then
        delta = {1, 0}
    elseif yaw < (math.pi * (0.25 + 0.5 * 2)) then
        delta = {0, 1}
    elseif yaw < (math.pi * (0.25 + 0.5 * 3)) then
        delta = {-1, 0}
    end

    moveShipAndPlayer (event.connectionId, xyz, delta)        

    return true
end

--------------------------------------------------
function blockCallbacks.itemChest (event, connection) 

    if event.isBlockValid then
        local item = instance.itemsAvailable [instance.nextItemIdx]
        dio.network.sendChat (connection.connectionId, "ITEM", "You have collected the " .. item.description)
        instance.inventory [item.id] = true
        instance.nextItemIdx = instance.nextItemIdx + 1
        event.sourceBlockId = event.destinationBlockId + 8

        if item.jumpSpeed then
            local component = dio.entities.getComponent (connection.entityId, dio.entities.components.SERVER_CHARACTER_CONTROLLER)
            component.jumpSpeed = item.jumpSpeed
            dio.entities.setComponent (connection.entityId, dio.entities.components.SERVER_CHARACTER_CONTROLLER, component)
        end

        return false
    end

    return true
end

--------------------------------------------------
function blockCallbacks.artifactChest (event, connection)

    if event.isBlockValid then
        instance.artifactsCollectedCount = instance.artifactsCollectedCount + 1
        dio.network.sendChat (connection.connectionId, "ARTEFACT", tostring (instance.artifactsCollectedCount) .. " collected!")
        event.sourceBlockId = event.destinationBlockId + 4

        return false
    end
    
    return true

end

--------------------------------------------------
function blockCallbacks.smallAxe (event, connection) 

    if event.isBlockValid and instance.inventory.smallAxe then
        event.sourceBlockId = 0
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.belt (event, connection) 

    if event.isBlockValid and instance.inventory.belt then
        event.sourceBlockId = 0
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.bean (event, connection) 

    if event.isBlockValid and instance.inventory.bean then
        event.sourceBlockId = event.destinationBlockId + 1
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.bigAxe (event, connection)
    
    if event.isBlockValid and instance.inventory.bigAxe then
        event.sourceBlockId = 0
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.teleporter (event, connection)
    
    if event.isBlockValid and instance.inventory.teleporter then

        local teleport = 
                "absolute " .. 
                tostring (event.chunkId [1] * 32 + event.cellId [1] + 0.5) .. " " ..
                tostring (event.chunkId [2] * 32 + event.cellId [2] + 1.5) .. " " ..
                tostring (event.chunkId [3] * 32 + event.cellId [3] + 0.5)

        dio.network.sendEvent (connection.connectionId, "tinyGalaxy.TP", teleport)
    end
    return true
end

--------------------------------------------------
local function convertPlayerXyxToMapCell (xyz)
    return 
    {
        math.floor (((xyz.chunkId [1] - instance.mapTopLeftChunkOrigin [1]) * 32 + xyz.xyz [1]) / 8),
        math.floor (((xyz.chunkId [3] - instance.mapTopLeftChunkOrigin [2]) * 32 + xyz.xyz [3]) / 8),
    }
end

--------------------------------------------------
local function doGameOver (connection, hasWonGame)
    
    dio.entities.destroy (connection.entityId)
    connection.entityId = nil

    instance.roomEntityId = nil
    instance.calendarEntityId = nil

    instance.isRestartingGame = true

    -- reset game vars
    instance.timeOfDay = 0
    instance.currentWorldIdx = nil
    instance.initialJumpSpeed = 10.0
    instance.nextItemIdx = 1
    instance.inventory = {}
    instance.artifactsCollectedCount = 0
    instance.shipXyz = {-32, -8, 88}
    instance.mapTopLeftChunkOrigin = {-1, -1}
    instance.ship = {0, 15}
end

--------------------------------------------------
local function onEntityPlaced (event)

    if event.isBlockValid then

        local blockTag = instance.blocks [event.destinationBlockId].tag
        if blockTag then
            local connection = connections [event.connectionId]
            event.cancel = blockCallbacks [blockTag] (event, connection)
            return
        end
    end

    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    event.cancel = true
end

--------------------------------------------------
local function onTick (event)

    local connection = nil
    for _, connection2 in pairs (connections) do
        connection = connection2
        break
    end

    if connection and instance.calendarEntityId then

        local xyz = dio.world.getPlayerXyz (connection.accountId)

        local mapCell = convertPlayerXyxToMapCell (xyz)

        local worldIdx = 0
        local timeOfDay = 0
        for idx, world in ipairs (instance.worlds) do
            if mapCell [1] == world.xz [1] and mapCell [2] == world.xz [2] then
                timeOfDay = world.timeOfDay
                worldIdx = idx
                break
            end
        end

        if worldIdx ~= instance.currentWorldIdx then
            instance.currentWorldIdx = worldIdx
            local description = worldIdx == 0 and "" or instance.worlds [worldIdx].name
            dio.network.sendEvent (connection.connectionId, "tinyGalaxy.WORLD", description)
        end

        if timeOfDay ~= instance.timeOfDay then
            instance.timeOfDay = timeOfDay
            local component = dio.entities.getComponent (instance.calendarEntityId, dio.entities.components.CALENDAR)
            component.time = convertHourToTime (timeOfDay)
            dio.entities.setComponent (instance.calendarEntityId, dio.entities.components.CALENDAR, component)
        end

        if xyz.chunkId [2] == -1 and xyz.xyz [2] < 2 then
            doGameOver (connection, false)
        end
    end
end

--------------------------------------------------
local function onLoad ()

    local types = dio.events.serverTypes
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    dio.events.addListener (types.ROOM_DESTROYED, onRoomDestroyed)
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.TICK, onTick)

    createNewLevel ()

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Tiny Galaxy",
    },

    permissionsRequired =
    {
        entities = true,
        file = true,
        world = true,
        network = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
