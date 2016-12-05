local BlockDefinitions = require ("gamemodes/dio_tiny_galaxy/mods/blocks/block_definitions")
local Mixin = require ("resources/scripts/utils/mixin")

--------------------------------------------------
local galaxyPath = "gamemodes/dio_tiny_galaxy/mods/world_logic/galaxy_settings/"
local galaxies = 
{
    ["map_00/"] = require (galaxyPath .. "map_00_settings"),
    ["galaxy_00/"] = require (galaxyPath .. "galaxy_00_settings"),
}

--------------------------------------------------
local instance =
{
    blocks = BlockDefinitions.blocks,

    timeOfDay = 0,
    currentWorldIdx = nil,
    initialJumpSpeed = 10.0,
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
    regularItemReach = 2.1,
    openChestBlockId = 70,

    isControllingShip = false,
    isMotorAtTarget = true,
    motorTarget = {},
}

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function calcIsSafeMove (moveDelta)

    local cg = instance.currentGalaxy

    local newX = instance.ship [1] + moveDelta [1]
    local newZ = instance.ship [2] + moveDelta [2]

    if newX < 0 or newZ < 0 or newX >= cg.worldLimits [1] or newZ >= cg.worldLimits [2] then
        return false
    end

    for _, world in ipairs (cg.worlds) do
        if newX == world.xz [1] and newZ == world.xz [2] then
            return false
        end
    end

    if not instance.inventory.iceShield then
        if newX >= 14 and newZ >= 14 then
            return false, "WARN_COLD"
        end
    end

    if not instance.inventory.fireShield then
        if newX >= 5 and newZ <= 10 then
            return false, "WARN_HEAT"
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
local function shipUpdate (event, ship)

    ship.target = Mixin.cloneTable (instance.motorTarget)

    if not ship.isAtTarget or not instance.isMotorAtTarget then

        local speed = ship.speed * event.timeDelta * 0.5

        for idx, value in ipairs (ship.xyz) do
            local target = ship.target [idx]
            if value < target then
                value = value + speed
                if value > target then
                    value = target
                end
                ship.xyz [idx] = value
            elseif value > target then
                value = value - speed
                if value < target then
                    value = target
                end
                ship.xyz [idx] = value
            end
        end

        local c = dio.entities.components
        local t = dio.entities.getComponent (event.entityId, c.TRANSFORM)
        t.xyz [1] = ship.xyz [1]
        t.xyz [2] = ship.xyz [2]
        t.xyz [3] = ship.xyz [3]
        dio.entities.setComponent (event.entityId, c.TRANSFORM, t)

        if ship.xyz [1] == ship.target [1] and
                ship.xyz [2] == ship.target [2] and
                ship.xyz [3] == ship.target [3] then

            ship.isAtTarget = true
            instance.isMotorAtTarget = true
        end

    end
end

--------------------------------------------------
local function moveShipAndPlayer (connectionId, moveDelta)

    local isSafe, dialog = calcIsSafeMove (moveDelta)
    -- local isSafe, dialog = true, nil
    if isSafe then

        -- update NEW

        instance.motorTarget [1] = instance.motorTarget [1] + moveDelta [1] * 8
        instance.motorTarget [3] = instance.motorTarget [3] + moveDelta [2] * 8

        instance.ship [1] = instance.ship [1] + moveDelta [1]
        instance.ship [2] = instance.ship [2] + moveDelta [2]        

        instance.isMotorAtTarget = false

        -- -- update OLD

        -- local cg = instance.currentGalaxy

        -- local origin = cg.mapTopLeftChunkOrigin
        -- local ship = instance.ship
        -- local minY = -8

        -- local newShipXyz =
        -- {
        --     (ship [1] + moveDelta [1]) * 8,
        --     minY,
        --     (ship [2] + moveDelta [2]) * 8,
        -- }

        -- local shipTo = 
        -- {
        --     chunkId = {origin [1], 0, origin [2]},
        --     xyz = newShipXyz,
        -- }

        -- local shipFrom = 
        -- {
        --     chunkId = {origin [1], 0, origin [2]},
        --     xyz = {ship [1] * 8, minY, ship [2] * 8},
        --     size = {8, 16, 8},
        -- }

        -- local clearAir = 
        -- {
        --     chunkId = {0, 0, 0},
        --     xyz = {-32, 32, 88},
        --     size = {8, 16, 8},
        -- }    

        -- dio.world.copyCells (instance.roomEntityId, shipTo, shipFrom)
        -- dio.world.copyCells (instance.roomEntityId, shipFrom, clearAir)

        -- local teleport = 
        --         "delta " .. 
        --         tostring (moveDelta [1] * 8) .. " " ..
        --         tostring (2) .. " " ..
        --         tostring (moveDelta [2] * 8)

        -- dio.network.sendEvent (connectionId, "tinyGalaxy.TP", teleport)

        -- instance.ship [1] = instance.ship [1] + moveDelta [1]
        -- instance.ship [2] = instance.ship [2] + moveDelta [2]

    elseif dialog then

        dio.network.sendEvent (connectionId, "tinyGalaxy.DIALOGS", dialog)

    end
end

--------------------------------------------------
local function createNewLevel ()

    local cg = instance.currentGalaxy
    if cg.ship then
        instance.ship = Mixin.cloneTable (cg.ship)
    end

    dio.file.deleteRoom (instance.currentGalaxyId)
    dio.file.copyFolder (
            instance.currentGalaxyId, 
            dio.file.locations.MOD_RESOURCES, 
            "new_saves/default/" .. instance.currentGalaxyId)

end

--------------------------------------------------
local function onPlayerUpdate (event)

    if instance.isControllingShip then

        if instance.isMotorAtTarget then

            if event.isLeftMouseClicked or event.isRightMouseClicked then
                instance.isControllingShip = false                
            else

                local delta
                if event.isUpPressed then
                    delta = {0, -1}
                elseif event.isDownPressed then
                    delta = {0, 1}
                elseif event.isLeftPressed then
                    delta = {-1, 0}
                elseif event.isRightPressed then
                    delta = {1, 0}
                end

                if delta then
                    moveShipAndPlayer (event.connectionId, delta)
                end
            end
        end
            
        event.cancel = true

    end
end

--------------------------------------------------
local function createPlayerEntity (connectionId, accountId)

    local cg = instance.currentGalaxy    
    local roomEntityId = dio.world.ensureRoomIsLoaded (instance.currentGalaxyId)

    local c = dio.entities.components
    local playerComponents =
    {
            -- [components.AABB_COLLIDER] =        {min = {-0.01, -0.01, -0.01}, size = {0.02, 0.02, 0.02},},
            -- [components.COLLISION_LISTENER] =   {onCollision = onRocketAndSceneryCollision,},
            -- [components.MESH_PLACEHOLDER] =     {blueprintId = "ROCKET",},
            -- [components.RIGID_BODY] =           {acceleration = {0.0, -9.806 * 1.0, 0.0},},
        
        [c.BASE_NETWORK] =          {},
        [c.CHILD_IDS] =             {},
        [c.FOCUS] =                 {connectionId = connectionId, radius = 4},
        [c.GRAVITY_TRANSFORM] =     instance.currentGalaxy.spawn,
        [c.NAME] =                  {name = "PLAYER"},
        [c.PARENT] =                {parentEntityId = roomEntityId},
        [c.SERVER_CHARACTER_CONTROLLER] =
        {
            connectionId = connectionId,
            accountId = accountId,
            crouchSpeed = 1.0,
            walkSpeed = 4.0,
            sprintSpeed = 4.0,
            jumpSpeed = instance.initialJumpSpeed,
            selectionDistance = 20,
            hasHighlight = false,
            onUpdate = onPlayerUpdate,
        },
        [c.TEMP_PLAYER] =           {connectionId = connectionId, accountId = accountId},
    }

    local playerEntityId = dio.entities.create (roomEntityId, playerComponents)

    local eyeComponents =
    {
        [c.BROADCAST_WITH_PARENT] = {},
        [c.CHILD_IDS] =             {},
        [c.NAME] =                  {name = "PLAYER_EYE_POSITION"},
        [c.PARENT] =                {parentEntityId = playerEntityId},
        [c.TRANSFORM] =             {}
    }

    local eyeEntityId = dio.entities.create (roomEntityId, eyeComponents)

    local cameraComponents = 
    {
        [c.BASE_NETWORK]            = {},
        [c.CAMERA]                  = cg.cameraSettings,
        [c.PARENT] =                {parentEntityId = roomEntityId},
        [c.TRANSFORM] =             {},
    }
    cameraComponents [c.CAMERA].attachTo = eyeEntityId
    cameraComponents [c.CAMERA].isMainCamera = true

    local cameraEntityId = dio.entities.create (roomEntityId, cameraComponents)
    
    if cg.isMap then

        local playerModelComponents =
        {
            [c.BASE_NETWORK] =             {},
            [c.MESH_PLACEHOLDER] =         {blueprintId = "player_model"},
            [c.PARENT] =                   {parentEntityId = playerEntityId},
            [c.TRANSFORM] =                {scale = {0.1, 0.1, 0.1}},
        }

        dio.entities.create (roomEntityId, playerModelComponents)

    end

    return playerEntityId, eyeEntityId, cameraEntityId
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

    dio.network.sendEvent (event.connectionId, "tinyGalaxy.DIALOGS", "BEGIN_GAME")

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

    -- if we are tracking a destroyed room, then mark it here
    if instance.roomEntityId == event.roomEntityId then
        instance.roomEntityId = nil
    end

    if instance.isRestartingGame then
        instance.isRestartingGame = false
        createNewLevel ()
        for _, connection in pairs (connections) do

            connection.entityId = createPlayerEntity (connection.connectionId, connection.accountId)
            dio.network.sendEvent (connection.connectionId, "tinyGalaxy.DIALOGS", "BEGIN_GAME")
        end
    end
end

--------------------------------------------------
local function doGameOver (connection, hasWonGame)
    
    if not instance.isGameOver then
        if hasWonGame then
            dio.network.sendEvent (connection.connectionId, "tinyGalaxy.DIALOGS", "SUCCESS")
        else
            dio.network.sendEvent (connection.connectionId, "tinyGalaxy.DIALOGS", "DIED")
        end
        dio.network.sendEvent (connection.connectionId, "tinyGalaxy.OSD", "RESET")
        instance.isGameOver = true
    end
end

--------------------------------------------------
local blockCallbacks = {}

--------------------------------------------------
function blockCallbacks.cookie (event, connection) 
    doGameOver (connection, true)
end

--------------------------------------------------
function blockCallbacks.computer (event, connection) 
        
    if event.distance <= instance.regularItemReach then

        if instance.isMotorAtTarget then
            instance.isControllingShip = true
        end
    end
    return true
end

--------------------------------------------------
function blockCallbacks.itemChest (event, connection) 

    if event.distance <= instance.regularItemReach then

        local cg = instance.currentGalaxy
        local item = cg.itemsAvailable [instance.nextItemIdx]
        
        dio.network.sendChat (connection.connectionId, "ITEM", "You have collected the " .. item.description)
        dio.network.sendEvent (connection.connectionId, "tinyGalaxy.DIALOGS", item.id)
        dio.network.sendEvent (connection.connectionId, "tinyGalaxy.OSD", item.id)

        instance.inventory [item.id] = true
        instance.nextItemIdx = instance.nextItemIdx + 1
        event.replacementBlockId = instance.openChestBlockId

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
function blockCallbacks.artefactChest (event, connection)

    if event.distance <= instance.regularItemReach then

        local cg = instance.currentGalaxy

        instance.artifactsCollectedCount = instance.artifactsCollectedCount + 1
        local count = tostring (instance.artifactsCollectedCount);
        dio.network.sendChat (connection.connectionId, "ARTEFACT", count .. " collected!")
        event.replacementBlockId = instance.openChestBlockId

        local artifactBlock = cg.artifactBlocks [instance.artifactsCollectedCount]
        dio.world.setBlock (
                event.roomEntityId, 
                cg.artifactHomeworldChunk,
                artifactBlock.xyz [1],
                artifactBlock.xyz [2],
                artifactBlock.xyz [3],
                artifactBlock.blockId)

        dio.network.sendEvent (event.connectionId, "tinyGalaxy.DIALOGS", "ARTIFACT_" .. count)
        dio.network.sendEvent (connection.connectionId, "tinyGalaxy.OSD", "artifact" .. count)

        if instance.artifactsCollectedCount == #cg.artifactBlocks then
            for _, cookie in ipairs (cg.cookieBlocks) do
                dio.world.setBlock (
                        event.roomEntityId, 
                        cg.artifactHomeworldChunk,
                        cookie [1],
                        cookie [2],
                        cookie [3],
                        87)
            end
        end

        return false
    end
    
    return true

end

--------------------------------------------------
function blockCallbacks.specialChest (event, connection)

    if event.distance <= instance.regularItemReach then

        dio.network.sendChat (connection.connectionId, "SPECIAL", "Special item collected!")
        event.replacementBlockId = instance.openChestBlockId

        dio.network.sendEvent (event.connectionId, "tinyGalaxy.DIALOGS", "SPECIAL")

        return false
    end
    
    return true

end

--------------------------------------------------
function blockCallbacks.smallAxe (event, connection) 

    if instance.inventory.smallAxe and event.distance <= instance.regularItemReach then
        event.replacementBlockId = 0
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.belt (event, connection) 

    if instance.inventory.belt and event.distance <= instance.regularItemReach then
        event.replacementBlockId = 0
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.bean (event, connection) 

    if instance.inventory.bean and event.distance <= instance.regularItemReach then
        event.replacementBlockId = event.pickedBlockId + 1
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.bigAxe (event, connection)
    
    if instance.inventory.bigAxe and event.distance <= instance.regularItemReach then
        event.replacementBlockId = 0
        return false
    end
    return true
end

--------------------------------------------------
function blockCallbacks.teleporter (event, connection)
    
    if instance.inventory.teleporter then

        -- FACE_NORTH = 0,
        -- FACE_SOUTH = 1,
        -- FACE_EAST = 2,
        -- FACE_WEST = 3,
        -- FACE_TOP = 4,
        -- FACE_BOTTOM = 5,

        if event.face == 4 then
            local teleport = 
                    "absolute " .. 
                    tostring (event.chunkId [1] * 32 + event.cellId [1] + 0.5) .. " " ..
                    tostring (event.chunkId [2] * 32 + event.cellId [2] + 1.5) .. " " ..
                    tostring (event.chunkId [3] * 32 + event.cellId [3] + 0.5)

            dio.network.sendEvent (connection.connectionId, "tinyGalaxy.TP", teleport)
        end
    end
    return true
end

--------------------------------------------------
local function convertPlayerXyxToMapCell (xyz)
    local cg = instance.currentGalaxy
    return 
    {
        math.floor (((xyz.chunkId [1] - cg.mapTopLeftChunkOrigin [1]) * 32 + xyz.xyz [1]) / 8),
        math.floor (((xyz.chunkId [3] - cg.mapTopLeftChunkOrigin [2]) * 32 + xyz.xyz [3]) / 8),
    }
end

--------------------------------------------------
local function restartGame (connection)

    local cg = instance.currentGalaxy

    instance.isGameOver = false

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
    -- instance.mapTopLeftChunkOrigin = {-1, -1}
    instance.ship = Mixin.cloneTable (cg.ship)
end

--------------------------------------------------
local function onEntityPlaced (event)

    if event.isBlockValid then

        local blockTag = instance.blocks [event.pickedBlockId].tag
        if blockTag then
            local connection = connections [event.connectionId]
            event.isReplacing = true
            event.cancel = blockCallbacks [blockTag] (event, connection)
            return
        end
    end

    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    onEntityPlaced (event)
end

--------------------------------------------------
local function isInCell (teleporter, xyz)

    if xyz.chunkId [1] == teleporter.chunkId [1] and
            xyz.chunkId [2] == teleporter.chunkId [2] and
            xyz.chunkId [3] == teleporter.chunkId [3] then

        if math.floor (xyz.xyz [1]) == teleporter.xyz [1] and
                math.floor (xyz.xyz [2]) == teleporter.xyz [2] and
                math.floor (xyz.xyz [3]) == teleporter.xyz [3] then

            return true

        end

    end
    return false

end

--------------------------------------------------
local function teleportPlayerToRoom (connection, targetGalaxyId)

    dio.entities.destroy (connection.entityId)

    instance.currentGalaxyId = targetGalaxyId
    instance.currentGalaxy = galaxies [instance.currentGalaxyId]

    createNewLevel ()
    
    connection.entityId = createPlayerEntity (connection.connectionId, connection.accountId)
    
end

--------------------------------------------------
local function onTick (event)

    local connection = nil
    for _, connection2 in pairs (connections) do
        connection = connection2
        break
    end

    if connection then

        local cg = instance.currentGalaxy
        local xyz = dio.world.getPlayerXyz (connection.accountId)

        if cg.isMap then
            
            -- check players position. see if they are standing on a teleporter

            for _, teleporter in ipairs (cg.teleporters) do
                if isInCell (teleporter, xyz) then
                    teleportPlayerToRoom (connection, teleporter.targetGalaxy)
                end
            end

        elseif instance.calendarEntityId then

            local mapCell = convertPlayerXyxToMapCell (xyz)

            local worldIdx = 0
            local timeOfDay = 0
            for idx, world in ipairs (cg.worlds) do
                if mapCell [1] == world.xz [1] and mapCell [2] == world.xz [2] then
                    timeOfDay = world.timeOfDay
                    worldIdx = idx
                    break
                end
            end

            if worldIdx ~= instance.currentWorldIdx then

                instance.currentWorldIdx = worldIdx

                local description = "Tiny Nowhere"
                if worldIdx == 0 then
                    if mapCell [1] == instance.ship [1] and mapCell [2] == instance.ship [2] then
                        description = "Tiny Space ship"
                    end
                elseif cg.worlds [worldIdx] then
                    description = cg.worlds [worldIdx].name
                end

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
end

--------------------------------------------------
local function onChatReceived (event)

    if event.text == "DIALOG_CLOSED" then
        if instance.isGameOver then
            restartGame (connections [event.authorConnectionId])
        end
        event.cancel = true
    end
end

--------------------------------------------------
local function onNamedEntityCreated (event)

    if event.name == "MOTOR" then

        -- need to add some movement callback to it...

        local c = dio.entities.components

        local transform = dio.entities.getComponent (event.entityId, c.TRANSFORM)
        local entityInstance = 
        {
            xyz         = Mixin.cloneTable (transform.xyz),
            target      = Mixin.cloneTable (transform.xyz),
            speed       = 8,
            isAtTarget  = true,
        }

        local hasSerialized = (event.isLoading and dio.entities.hasComponent (event.entityId, c.SCRIPT_DISK_SERIALIZER))

        if hasSerialized then
            local diskSerializer = dio.entities.getComponent (event.entityId, c.SCRIPT_DISK_SERIALIZER)
            entityInstance = diskSerializer.data;
        end

        instance.motorTarget = Mixin.cloneTable (entityInstance.target)

        local components =
        {
            -- [c.FIXED_UPDATE] =
            -- {
            --     onUpdate = function (event) shipUpdate (event, entityInstance) end,
            -- }, 
            [c.VARIABLE_UPDATE] =
            {
                onUpdate = function (event) shipUpdate (event, entityInstance) end,
            },        
        }

        if not hasSerialized then
            components [c.SCRIPT_DISK_SERIALIZER] =
            {
                data = entityInstance
            }
        end

        dio.entities.addComponents (event.entityId, components)

    end    
end

--------------------------------------------------
local function onLoad ()

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    dio.events.addListener (types.ROOM_DESTROYED, onRoomDestroyed)
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.TICK, onTick)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)

    instance.currentGalaxyId = "map_00/"
    instance.currentGalaxy = galaxies [instance.currentGalaxyId]

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
        drawing = true,
        entities = true,
        file = true,
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
