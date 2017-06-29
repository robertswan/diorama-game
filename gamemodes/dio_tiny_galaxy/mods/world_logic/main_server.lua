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
local connections = {}

--------------------------------------------------
local instance =
{
    blocks = BlockDefinitions.blocks,

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
local function restartGame (connection)

    local cg = instance.currentGalaxy

    instance.isGameOver = false

    dio.entities.destroy (connection.entityId)
    dio.entities.destroy (connection.cameraEntityId)
    connection.entityId = nil
    connection.eyeEntityId = nil
    connection.cameraEntityId = nil
    connection.roomEntityId = nil

    instance.roomEntityId = nil

    instance.isRestartingGame = true

    -- reset game vars
    instance.currentWorldIdx = nil
    instance.initialJumpSpeed = 10.0
    instance.nextItemIdx = 1
    instance.inventory = {}
    instance.artifactsCollectedCount = 0
    -- instance.mapTopLeftChunkOrigin = {-1, -1}
    instance.ship = Mixin.cloneTable (cg.ship)

    instance.isControllingShip = false
    instance.isMotorAtTarget = true
    motorTarget = {}

    connection.jumpSpeed = instance.initialJumpSpeed

end

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

        local speed = ship.speed * event.timeDelta

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

    elseif dialog then

        dio.network.sendEvent (connectionId, "tinyGalaxy.DIALOGS", dialog)

    end

    return isSafe
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
local function createCameraEntity (eyeEntityId, roomEntityId, cameraSettings)

    local c = dio.entities.components
    local cameraComponents = 
    {
        [c.BASE_NETWORK]            = {},
        [c.CAMERA]                  = cameraSettings,
        [c.PARENT]                  = {parentEntityId = roomEntityId},
        [c.TRANSFORM]               = {},
    }
    cameraComponents [c.CAMERA].attachTo = eyeEntityId
    cameraComponents [c.CAMERA].isMainCamera = true

    local cameraEntityId = dio.entities.create (roomEntityId, cameraComponents)

    return cameraEntityId    

end

--------------------------------------------------
local switchCameraToFps
local function onPlayerUpdate (event)

    if instance.isControllingShip then

        if instance.isMotorAtTarget then

            if event.isLeftMouseClicked or event.isRightMouseClicked then

                instance.isControllingShip = false

                local connection = connections [event.connectionId]
                switchCameraToFps (connection)

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
local function createPlayerEntity (connectionId, accountId, jumpSpeed, playerXyz)

    local cg = instance.currentGalaxy    
    local roomEntityId = dio.world.ensureRoomIsLoaded (instance.currentGalaxyId)

    local c = dio.entities.components
    local playerComponents =
    {
        [c.BASE_NETWORK] =          {},
        [c.CHILD_IDS] =             {},
        [c.FOCUS] =                 {connectionId = connectionId, radius = 4},
        [c.GRAVITY_TRANSFORM] =     playerXyz and playerXyz or cg.spawn,
        [c.NAME] =                  {name = "PLAYER"},
        [c.PARENT] =                {parentEntityId = roomEntityId},
        [c.SERVER_CHARACTER_CONTROLLER] =
        {
            connectionId = connectionId,
            accountId = accountId,
            crouchSpeed = 1.0,
            walkSpeed = 4.0,
            sprintSpeed = 4.0,
            jumpSpeed = jumpSpeed,
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

    local cameraSettings = cg.isMap and cg.cameraSettings.overhead or cg.cameraSettings.fps
    local cameraEntityId = createCameraEntity (eyeEntityId, roomEntityId, cameraSettings)

    local playerModelComponents =
    {
        [c.BASE_NETWORK] =              {},
        [c.MESH_PLACEHOLDER] =          {blueprintId = "player_model", isInMainPass = cg.isMap},
        [c.PARENT] =                    {parentEntityId = playerEntityId},
        [c.TRANSFORM] =                 {scale = {1/16, 1/16, 1/16}, xyz = {0, -0.25, 0}},
    }

    dio.entities.create (roomEntityId, playerModelComponents)

    return playerEntityId, eyeEntityId, cameraEntityId, roomEntityId
end

-- --------------------------------------------------
-- local chunkIdFromXyz = function (xyz)
--     return 
--     {
--         math.floor (xyz [1] / 32),
--         math.floor (xyz [2] / 32),
--         math.floor (xyz [3] / 32)
--     }
-- end

--------------------------------------------------
switchCameraToFps = function (connection)

    -- actually we will KILL the player now and respawn it in the correct position

    dio.entities.destroy (connection.entityId)
    dio.entities.destroy (connection.cameraEntityId)

    local c = dio.entities.components
    local motorXyz = dio.entities.getComponent (instance.motorEntityId, c.TRANSFORM)
    local xyz = connection.storedXyz
    xyz.xyz [1] = xyz.xyz [1] + motorXyz.xyz [1]
    xyz.xyz [2] = xyz.xyz [2] + motorXyz.xyz [2]
    xyz.xyz [3] = xyz.xyz [3] + motorXyz.xyz [3]

    local playerEntityId, eyeEntityId, cameraEntityId, roomEntityId = createPlayerEntity (
            connection.connectionId, 
            connection.accountId,
            connection.jumpSpeed,
            xyz)

    connection.storedXyz = nil    

    connection.entityId = playerEntityId
    connection.eyeEntityId = playerEntityId
    connection.cameraEntityId = cameraEntityId
    connection.roomEntityId = roomEntityId
end

--------------------------------------------------
local function switchCameraToOverhead (connection)

    -- record player xyz relative to the ship
    local c = dio.entities.components
    local motorXyz = dio.entities.getComponent (instance.motorEntityId, c.TRANSFORM)
    local playerXyz = dio.entities.getComponent (connection.entityId, c.GRAVITY_TRANSFORM)

    connection.storedXyz = playerXyz
    connection.storedXyz.xyz [1] = playerXyz.xyz [1] - motorXyz.xyz [1]
    connection.storedXyz.xyz [2] = playerXyz.xyz [2] - motorXyz.xyz [2]
    connection.storedXyz.xyz [3] = playerXyz.xyz [3] - motorXyz.xyz [3]

    dio.entities.destroy (connection.cameraEntityId)
    local cameraSettings = instance.currentGalaxy.cameraSettings.overhead
    connection.cameraEntityId = createCameraEntity (instance.motorEntityId, connection.roomEntityId, cameraSettings)
end

--------------------------------------------------
local function onClientConnected (event)

    createNewLevel ()

    local playerEntityId, eyeEntityId, cameraEntityId, roomEntityId = createPlayerEntity (
            event.connectionId, 
            event.accountId,
            instance.initialJumpSpeed)

    local connection =
    {
        connectionId    = event.connectionId,
        accountId       = event.accountId,
        entityId        = playerEntityId,
        eyeEntityId     = eyeEntityId,
        cameraEntityId  = cameraEntityId,
        roomEntityId    = roomEntityId,
        jumpSpeed       = instance.initialJumpSpeed,
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

end

--------------------------------------------------
local function onRoomDestroyed (event)

    -- if we are tracking a destroyed room, then mark it here
    if instance.roomEntityId == event.roomEntityId then
        instance.roomEntityId = nil
        instance.eyeEntityId = nil
        instance.cameraEntityId = nil
        instance.roomEntityId = nil
        instance.motorEntityId = nil
    end

    if instance.isRestartingGame then

        instance.isRestartingGame = false
        createNewLevel ()
        for _, connection in pairs (connections) do

            local playerEntityId, eyeEntityId, cameraEntityId, roomEntityId = createPlayerEntity (
                    connection.connectionId, 
                    connection.accountId,
                    connection.jumpSpeed)

            connection.entityId = playerEntityId
            connection.eyeEntityId = playerEntityId
            connection.cameraEntityId = cameraEntityId
            connection.roomEntityId = roomEntityId
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
    return true
end

--------------------------------------------------
function blockCallbacks.computer (event, connection) 
        
    if event.distance <= instance.regularItemReach then

        if instance.isMotorAtTarget and not instance.isControllingShip then

            switchCameraToOverhead (connection)
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
            connection.jumpSpeed = item.jumpSpeed
            local component = dio.entities.getComponent (connection.entityId, dio.entities.components.SERVER_CHARACTER_CONTROLLER)
            component.jumpSpeed = connection.jumpSpeed
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
                    tostring (event.globalCellId [1] + 0.5) .. " " ..
                    tostring (event.globalCellId [2] + 1.5) .. " " ..
                    tostring (event.globalCellId [3] + 0.5)

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
        math.floor ((xyz.xyz [1]) / 8 - cg.mapTopLeftChunkOrigin [1] * 32),
        math.floor ((xyz.xyz [3]) / 8 - cg.mapTopLeftChunkOrigin [2] * 32),
    }
end

--------------------------------------------------
local function onEntityPlaced (event)

    if not instance.isControllingShip then

        if event.isBlockValid then

            local blockTag = instance.blocks [event.pickedBlockId].tag
            if blockTag then
                local connection = connections [event.connectionId]
                event.isReplacing = true
                event.cancel = blockCallbacks [blockTag] (event, connection)
                return
            end
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

    if math.floor (xyz.xyz [1]) == teleporter.xyz [1] and
            math.floor (xyz.xyz [2]) == teleporter.xyz [2] and
            math.floor (xyz.xyz [3]) == teleporter.xyz [3] then

        return true

    end

    return false
end

--------------------------------------------------
local function teleportPlayerToRoom (connection, targetGalaxyId)

    dio.entities.destroy (connection.entityId)
    dio.entities.destroy (connection.cameraEntityId)

    instance.currentGalaxyId = targetGalaxyId
    instance.currentGalaxy = galaxies [instance.currentGalaxyId]

    createNewLevel ()
    
    local playerEntityId, eyeEntityId, cameraEntityId, roomEntityId = createPlayerEntity (
            connection.connectionId, 
            connection.accountId,
            connection.jumpSpeed)

    connection.entityId = playerEntityId
    connection.eyeEntityId = eyeEntityId
    connection.cameraEntityId = cameraEntityId
    connection.roomEntityId = roomEntityId
    
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

        if cg.isMap then
            
            -- check players position. see if they are standing on a teleporter
            local xyz = dio.world.getPlayerXyz (connection.accountId)

            for _, teleporter in ipairs (cg.teleporters) do
                if isInCell (teleporter, xyz) then
                    teleportPlayerToRoom (connection, teleporter.targetGalaxy)
                end
            end

        elseif connection.entityId then

            local xyz = dio.world.getPlayerXyz (connection.accountId)
            local mapCell = convertPlayerXyxToMapCell (xyz)

            local worldIdx = 0
            for idx, world in ipairs (cg.worlds) do
                if mapCell [1] == world.xz [1] and mapCell [2] == world.xz [2] then
                    worldIdx = idx
                    break
                end
            end

            if worldIdx ~= instance.currentWorldIdx then

                instance.currentWorldIdx = worldIdx

                local description = "Tiny Nowhere"
                local sky = "0 0 0"
                if worldIdx == 0 then
                    if mapCell [1] == instance.ship [1] and mapCell [2] == instance.ship [2] then
                        description = "Tiny Space ship"
                    end
                elseif cg.worlds [worldIdx] then
                    local world = cg.worlds [worldIdx]
                    description = world.name
                    sky = world.timeOfDay
                end

                dio.network.sendEvent (connection.connectionId, "tinyGalaxy.WORLD", description)
                dio.network.sendEvent (connection.connectionId, "tinyGalaxy.SKY", sky)
            end

            if not instance.isControllingShip then
                if xyz.xyz [2] < (2 - 32) then
                    doGameOver (connection, false)
                end
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

    if event.name == "MOTOR_ENTITY" then

        -- need to add some movement callback to it...

        local c = dio.entities.components

        local transform = dio.entities.getComponent (event.entityId, c.TRANSFORM)
        local entityInstance = 
        {
            xyz         = Mixin.cloneTable (transform.xyz),
            target      = Mixin.cloneTable (transform.xyz),
            speed       = 24,
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

        instance.motorEntityId = event.entityId

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
