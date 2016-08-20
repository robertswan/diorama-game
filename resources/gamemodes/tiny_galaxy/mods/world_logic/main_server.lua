local BlockDefinitions = require ("resources/gamemodes/tiny_galaxy/mods/blocks/block_definitions")

--------------------------------------------------
local instance =
{
    blocks = BlockDefinitions.blocks,

    itemsAvailable = 
    {
        {id = "smallAxe",             description = "Small Axe"},
        {id = "smallJumpBoots",       description = "Small Jump Boots"},
        {id = "iceShield",            description = "Ice Shield"},
        {id = "belt",                 description = "Belt of Strength"},
        {id = "fireShield",           description = "Fire Shield"},
        {id = "teleporter",           description = "Teleporter"},
        {id = "largeJumpBoots",       description = "Large Jump Boots"},
        {id = "beans",                description = "Magic Beans"},
        {id = "bigAxe",               description = "Big Axe"},
    },
    nextItemIdx = 1,

    inventory = {},
    artifactsCollectedCount = 0,

    shipXyz = {-32, -8, 88},
    
    mapTopLeftChunkOrigin = {-1, -1},
    ship = {0, 15},
    worldLimits = {16, 16},
    worlds = 
    {
        {name = "Grass World 1",    xz = {0, 12}},
        {name = "Grass World 2",    xz = {3, 13}},
        {name = "Grass World 3",    xz = {5, 15}},
        {name = "Grass World 4",    xz = {9, 12}},
        {name = "Grass World 5",    xz = {4, 4}},
        {name = "Vector World",     xz = {3, 7}},
        {name = "Rot World",        xz = {1, 1}},
        {name = "Ice World",        xz = {15, 15}},
        {name = "Desert World",     xz = {9, 2}},
        {name = "Toxic World",      xz = {13, 3}},
        {name = "Binary Sun World", xz = {10, 5}},

        {name = "Asteroids 1",      xz = {5, 10}},
        {name = "Asteroids 2",      xz = {7, 10}},
        {name = "Asteroids 3",      xz = {10, 10}},
        {name = "Asteroids 4",      xz = {14, 10}},
        {name = "Asteroids 5",      xz = {15, 8}},
        {name = "Asteroids 6",      xz = {15, 4}},
        {name = "Asteroids 7",      xz = {15, 2}},
        {name = "Asteroids 8",      xz = {14, 0}},
        {name = "Asteroids 9",      xz = {11, 0}},
        {name = "Asteroids 10",     xz = {7, 0}},
        {name = "Asteroids 11",     xz = {5, 0}},
        {name = "Asteroids 12",     xz = {5, 3}},
        {name = "Asteroids 13",     xz = {5, 7}},
    }    
}

--------------------------------------------------
local connections = {}

-- --------------------------------------------------
-- local function fillCube (roomEntityId, chunkId, min, max, value)

--     local setBlock = dio.world.setBlock
--     for x = min [1], max [1] do
--         for y = min [2], max [2] do
--             for z = min [3], max [3] do
--                 setBlock (roomEntityId, chunkId, x, y, z, value)
--             end
--         end
--     end
-- end

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

    local components = dio.entities.components
    local playerComponents =
    {
            -- [components.AABB_COLLIDER] =        {min = {-0.01, -0.01, -0.01}, size = {0.02, 0.02, 0.02},},
            -- [components.COLLISION_LISTENER] =   {onCollision = onRocketAndSceneryCollision,},
            -- [components.MESH_PLACEHOLDER] =     {blueprintId = "ROCKET",},
            -- [components.RIGID_BODY] =           {acceleration = {0.0, -9.806 * 1.0, 0.0},},
        
        [components.BASE_NETWORK] =         {},
        [components.EYE_POSITION] =         {offset = {0, 1.65, 0}},
        [components.FOCUS] =                {connectionId = connectionId, radius = 4},
        [components.GRAVITY_TRANSFORM] =
        {
            chunkId =       {0, 0, 0},
            xyz =           {-31, 4, 95},
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
        [components.NAME] =                 {name = "PLAYER", debug = true}, -- temp for debugging
        [components.PARENT] =               {parentEntityId = roomEntityId},
        [components.SERVER_CHARACTER_CONTROLLER] =               
        {
            connectionId = connectionId,
            accountId = accountId,
        },
        [components.TEMP_PLAYER] =
        {
            connectionId = connectionId,
            accountId = accountId,
        },
    }

    return dio.entities.create (roomEntityId, playerComponents)
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
            time = 12 * 60 * 60,
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
    
    dio.entities.create (event.roomEntityId, calendarEntity)

end

--------------------------------------------------
local function onRoomDestroyed (event)

    instance.roomEntityId = nil

end

--------------------------------------------------
local blockCallbacks =
{
    computer = function (event, connection) 
        
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
    end,

    itemChest = function (event, connection) 

        if event.isBlockValid then
            local item = instance.itemsAvailable [instance.nextItemIdx]
            dio.network.sendChat (connection.connectionId, "ITEM", "You have collected the " .. item.description)
            instance.inventory [item.id] = true
            instance.nextItemIdx = instance.nextItemIdx + 1
            dio.world.setBlock (event.roomEntityId, event.chunkId, event.xyz [1], event.xyz [2], event.xyz [3], 0)
        end

    end,

    artifactChest = function (event, connection)

        if event.isBlockValid then
            instance.artifactsCollectedCount = instance.artifactsCollectedCount + 1
            dio.network.sendChat (connection.connectionId, "ARTEFACT", tostring (instance.artifactsCollectedCount) .. " collected!")
            dio.world.setBlock (event.roomEntityId, event.chunkId, event.xyz [1], event.xyz [2], event.xyz [3], 0)
        end

    end,

    smallAxe = function (event, connection) 
        if event.isBlockValid and instance.inventory.smallAxe then
            dio.world.setBlock (event.roomEntityId, event.chunkId, event.xyz [1], event.xyz [2], event.xyz [3], 0)
        end
    end,

    belt = function (event, connection) 
        if event.isBlockValid and instance.inventory.belt then
            dio.world.setBlock (event.roomEntityId, event.chunkId, event.xyz [1], event.xyz [2], event.xyz [3], 0)
        end
    end,

    beans = function (event, connection) 
        if event.isBlockValid and instance.inventory.beans then
            dio.world.setBlock (
                    event.roomEntityId,
                    event.chunkId, 
                    event.xyz [1], event.xyz [2], event.xyz [3],
                    event.destinationBlockId + 1)
        end
    end,

    bigAxe = function (event, connection)
        if event.isBlockValid and instance.inventory.bigAxe then
            dio.world.setBlock (event.roomEntityId, event.chunkId, event.xyz [1], event.xyz [2], event.xyz [3], 0)
        end
    end,
}

--------------------------------------------------
local function onEntityPlaced (event)

    if event.isBlockValid then

        local blockTag = instance.blocks [event.destinationBlockId].tag

        if blockTag then
            local connection = connections [event.connectionId]
            blockCallbacks [blockTag] (event, connection)
        end
    end

    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    event.cancel = true
end

--------------------------------------------------
local function onChunkGenerated (event)

    -- for _, build in pairs (gameVars.chunksToModify) do

    --     if not build.isBuilt and
    --             build.chunkId [1] == event.chunkId [1] and
    --             build.chunkId [2] == event.chunkId [2] and
    --             build.chunkId [3] == event.chunkId [3] then

    --         build.buildFunction (event.roomEntityId, event.chunkId)
    --         build.isBuilt = true

    --     end
    -- end
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
    dio.events.addListener (types.CHUNK_GENERATED, onChunkGenerated)

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
