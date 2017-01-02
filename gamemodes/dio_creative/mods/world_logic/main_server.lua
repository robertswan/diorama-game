local BlockDefinitions = require ("gamemodes/default/mods/blocks/block_definitions")

--------------------------------------------------
local groups =
{
    tourist =
    {
        color = "%aaa",
        canChat = true,
        canColourText = false,
    },
    builder =
    {
        color = "%fff",
        canBuildAndDestroy = true,
        canChat = true,
        canColourText = true,
    },
    mod =
    {
        color = "%f44",
        canBuildAndDestroy = true,
        canChat = true,
        canUseAxlesAndHammer = true,
        canColourText = true,
        canPromoteTo = {tourist = true, builder = true},
    },
    admin =
    {
        color = "%ff4",
        canBuildAndDestroy = true,
        canChat = true,
        canUseAxlesAndHammer = true,
        canUseModels = true,
        canColourText = true,
        canPromoteTo = {tourist = true, builder = true, mod = true},
    }
}

--------------------------------------------------
local gravityDirNames =
{
    -- TODO should be using io.inputs.gravityDirs but inputs is not for the server
    [0] =  "NORTH",
    [1] =  "SOUTH",
    [2] =  "EAST",
    [3] =  "WEST",
    [4] =  "UP",
    [5] =  "DOWN",
}

--------------------------------------------------
local gravityDirIndices =
{
    -- TODO should be using io.inputs.gravityDirs but inputs is not for the server
    NORTH =  0,
    SOUTH =  1,
    EAST =   2,
    WEST =   3,
    UP =     4,
    DOWN =   5,
}

--------------------------------------------------
local connections = {}

--------------------------------------------------
local function stripColourCodes (text)

    local stripped = text:gsub ("\\%%", "{REPLACE}")
    local stripped = stripped:gsub ("%%...", "")
    local stripped = stripped:gsub ("{REPLACE}", "\\%%")
    return stripped
end

--------------------------------------------------
local function createPlayerEntity (connectionId, accountId, settings, isPasswordCorrect)
    
    local roomFolder = (settings and isPasswordCorrect) and settings.xyz.roomFolder or "default/"
    local roomEntityId = dio.world.ensureRoomIsLoaded (roomFolder)

    local components = dio.entities.components

    local playerComponents =
    {
            -- [components.AABB_COLLIDER] =        {min = {-0.01, -0.01, -0.01}, size = {0.02, 0.02, 0.02},},
            -- [components.COLLISION_LISTENER] =   {onCollision = onRocketAndSceneryCollision,},
            -- [components.MESH_PLACEHOLDER] =     {blueprintId = "ROCKET",},
            -- [components.RIGID_BODY] =           {acceleration = {0.0, -9.806 * 1.0, 0.0},},
        
        [components.BASE_NETWORK] =         {},
        [components.CHILD_IDS] =            {},
        [components.FOCUS] =                {connectionId = connectionId, radius = 4},
        [components.NAME] =                 {name = "PLAYER"},
        [components.PARENT] =               {parentEntityId = roomEntityId},
        [components.SERVER_CHARACTER_CONTROLLER] =               
        {
            connectionId = connectionId,
            accountId = accountId,
            standEyeHeight = 1.65,
            crouchEyeHeight = 0.25,
        },
        [components.TEMP_PLAYER] =          {connectionId = connectionId, accountId = accountId},
    }

    if settings and isPasswordCorrect then

        playerComponents [components.GRAVITY_TRANSFORM] =
        {
            chunkId =       settings.xyz.chunkId,
            xyz =           settings.xyz.xyz,
            ypr =           settings.xyz.ypr,
            gravityDir =    gravityDirIndices [settings.gravityDir],
        }

    else
        playerComponents [components.GRAVITY_TRANSFORM] =
        {
            chunkId =       {0, 0, 0},
            xyz =           {0, 0, 0},
            ypr =           {0, 0, 0},
            gravityDir =    gravityDirIndices.DOWN,
        }
    end

    local playerEntityId = dio.entities.create (roomEntityId, playerComponents)

    local eyeComponents =
    {
        [components.BROADCAST_WITH_PARENT] =    {},
        [components.CHILD_IDS] =                {},
        [components.NAME] =                     {name = "PLAYER_EYE_POSITION"},
        [components.PARENT] =                   {parentEntityId = playerEntityId},
        [components.TRANSFORM] =                {}
    }

    local eyeEntityId = dio.entities.create (roomEntityId, eyeComponents) 
    
    return playerEntityId, eyeEntityId
end

--------------------------------------------------
local function onClientConnected (event)

    local filename = "player_" .. event.accountId .. ".lua"
    local settings = dio.file.loadLua (dio.file.locations.WORLD_PLAYER, filename)

    local isPasswordCorrect = true
    if settings then
        isPasswordCorrect = (settings.accountPassword == event.accountPassword)
    end

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        screenName = event.accountId,
        accountPassword = event.accountPassword,
        groupId = event.isSinglePlayer and "builder" or "tourist",
        isPasswordCorrect = isPasswordCorrect,
        needsSaving = event.isSinglePlayer,
        entityId = createPlayerEntity (event.connectionId, event.accountId, settings, isPasswordCorrect),
    }

    if settings and isPasswordCorrect then
        connection.groupId = settings.permissionLevel
        connection.needsSaving = true
    end

    connection.screenName = connection.screenName .. " [" .. connection.groupId .. "]"

    connections [event.connectionId] = connection
end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]
    local group = groups [connection.groupId]

    if connection.needsSaving then

        local xyz, error = dio.world.getPlayerXyz (event.accountId)
        if xyz then

            local filename = "player_" .. event.accountId .. ".lua"
            local settings =
            {
                xyz = xyz,
                accountPassword = connection.accountPassword,
                permissionLevel = connection.groupId,
                gravityDir = gravityDirNames [dio.world.getPlayerGravity (event.accountId)],
            }

            dio.file.saveLua (dio.file.locations.WORLD_PLAYER, filename, settings, "settings")

        else
            print (error)
        end
    end

    dio.entities.destroy (connection.entityId)

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onEntityPlaced (event)
    local connection = connections [event.connectionId]
    local group = groups [connection.groupId]
    local willCancel = not group.canBuildAndDestroy

    if event.isBlockValid and not willCancel then
        local block = BlockDefinitions.blocks [event.usingBlockId]
        if (block.tag == "axle" or block.tag == "hammer") and not group.canUseAxlesAndHammer then
            willCancel = true
        elseif block.entityModel and not group.canUseModels then
            willCancel = true
        end
    end

    event.cancel = willCancel
end

--------------------------------------------------
local function onEntityDestroyed (event)
    onEntityPlaced (event)
end

--------------------------------------------------
local function onChatReceived (event)

    local connection = connections [event.authorConnectionId]
    local group = groups [connection.groupId]
    local canColourText = group.canColourText

    if not canColourText then
        print ("INCOMING CHAT " .. event.text)
        event.text = stripColourCodes (event.text)
        print ("OUTGOING CHAT " .. event.text)
    end

    if event.text:sub (1, 1) ~= "." then
        return
    end

    if event.text == ".help" then

        event.targetConnectionId = event.authorConnectionId
        event.text = ".help, .motd, .spawn, .tp <X> <Y> <Z>, .tp <player>, .coords, .coords <player>, .group, .showPassword, .listPlayerGroups, .listGroups, .setHome, .home"

    elseif event.text == ".help mod" then

        event.targetConnectionId = event.authorConnectionId
        event.text = ".setGroup <player> <group>"

    elseif event.text == ".showPassword" then

        local connection = connections [event.authorConnectionId]

        event.targetConnectionId = event.authorConnectionId
        if connection.isPasswordCorrect then
            event.text = "Your password (validated) = " .. connection.accountPassword
        else
            event.text = "Your password (UNVALIDATED) = " .. connection.accountPassword
        end

    elseif event.text == ".group" then

        local connection = connections [event.authorConnectionId]

        event.targetConnectionId = event.authorConnectionId
        event.text = "Your group = " .. connection.groupId

    elseif event.text == ".listGroups" then

        event.targetConnectionId = event.authorConnectionId
        event.text = "All groups = tourist, builder, mod, admin"

    elseif event.text == ".listPlayerGroups" then

        event.targetConnectionId = event.authorConnectionId
        event.text = ""
        for groupId, group in pairs (groups) do
            local isNewAdd = true
            for _, connection in pairs (connections) do
                if connection.groupId == groupId then
                    if isNewAdd then
                        event.text = group.color .. event.text .. "[" .. groupId .. "] = "
                        isNewAdd = false
                    end
                    event.text = event.text .. connection.accountId .. ", "
                end
            end
        end

    else

        local connection = connections [event.authorConnectionId]
        local canPromoteTo = groups [connection.groupId].canPromoteTo

        if canPromoteTo then

            local commandIdx = event.text:find (".setGroup")

            if commandIdx == 1 then

                local words = {}
                for word in event.text:gmatch ("[^ ]+") do
                    table.insert (words, word)
                end

                event.targetConnectionId = event.authorConnectionId
                event.text = "FAILED: .setGroup [accountId] [permissionLevel]";

                if #words >= 3 then

                    local groupToSet = words [3]

                    if groups [groupToSet] and canPromoteTo [groupToSet] then
                        local playerToPromote = words [2]

                        local hasPromoted = false
                        for _, promoteConnection in pairs (connections) do
                            if promoteConnection.accountId == playerToPromote and promoteConnection.isPasswordCorrect then

                                local isPlayerLowerLevel = canPromoteTo [promoteConnection.groupId]
                                if isPlayerLowerLevel then
                                    promoteConnection.groupId = groupToSet
                                    promoteConnection.needsSaving = true
                                    hasPromoted = true
                                end
                            end
                        end

                        if hasPromoted then
                            event.text = "SUCCESS: .setGroup " .. playerToPromote .. " -> " .. groupToSet;
                        end
                    end
                end
            end
        end
    end
end

--------------------------------------------------
local function onRoomCreated (event)

    local components = dio.entities.components
    local calendarEntity =
    {
        [components.BASE_NETWORK] =
        {
        },
        [components.CALENDAR] =
        {
            time = 9 * 60 * 60, -- midday
            timeMultiplier = 3000,
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
    
    local calendarEntityId = dio.entities.create (event.roomEntityId, calendarEntity)
end

--------------------------------------------------
local function onNamedEntityCreated (event)
    
    if event.name == "MOTOR" then

        -- need to add some movement callback to it...

        local c = dio.entities.components

        local transform = dio.entities.getComponent (event.entityId, c.TRANSFORM)
        local instance = 
        {
            -- also store the inital y position of the transform
            bottom = transform.xyz [2],
            top = transform.xyz [2] + 4,
            y = transform.xyz [2],
            currentVelocity = 2,
        }

        if event.isLoading then
            if dio.entities.hasComponent (event.entityId, c.SCRIPT_DISK_SERIALIZER) then
                local diskSerializer = dio.entities.getComponent (event.entityId, c.SCRIPT_DISK_SERIALIZER)
                instance = diskSerializer.data;
            end
        end

        local components =
        {
            [c.VARIABLE_UPDATE] =
            {
                onUpdate = function (event) 

                    instance.y = instance.y + (instance.currentVelocity * event.timeDelta)
                    if instance.currentVelocity > 0 and instance.y > instance.top then
                        instance.y = instance.top
                        instance.currentVelocity = -instance.currentVelocity
                    elseif instance.currentVelocity < 0 and instance.y < instance.bottom then
                        instance.y = instance.bottom
                        instance.currentVelocity = -instance.currentVelocity
                    end

                    local t = dio.entities.getComponent (event.entityId, c.TRANSFORM)
                    t.xyz [2] = instance.y
                    dio.entities.setComponent (event.entityId, c.TRANSFORM, t)

                end,
            },        
        }

        if not event.isLoading then
            components [c.SCRIPT_DISK_SERIALIZER] =
            {
                data = instance
            }
        end

        dio.entities.addComponents (event.entityId, components)

    end
end

--------------------------------------------------
local function onLoad ()

    -- dio.players.setPlayerAction (player, actions.LEFT_CLICK, outcomes.DESTROY_BLOCK)

    -- lua is GC
    -- but do we want to reference count textures? ill go for yes!
    -- what does this mean though if the lua texture is unloaded while playing the game????

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    --dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)
end

--------------------------------------------------
local modSettings =
{
    description =
    {
        id = "creative",
        name = "Creative",
        description = "This is required to play the game!",
        help =
        {
            showPassword = "Show your group.",
            group = "Show your group.",
            listGroups = "Show all available groups.",
            setGroup = "(mod, admin only) Change the group a player is in.",
        },
    },

    permissionsRequired =
    {
        entities = true,
        file = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
