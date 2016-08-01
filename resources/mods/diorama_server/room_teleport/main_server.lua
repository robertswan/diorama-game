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
        canBuild = true,
        canDestroy = true,
        canChat = true,
        canColourText = true,
    },
    mod =
    {
        color = "%f44",
        canBuild = true,
        canDestroy = true,
        canChat = true,
        canColourText = true,
        canPromoteTo = {tourist = true, builder = true},
        canPlaceTeleporters = true,
    },
    admin =
    {
        color = "%ff4",
        canBuild = true,
        canDestroy = true,
        canChat = true,
        canColourText = true,
        canPromoteTo = {tourist = true, builder = true, mod = true},
        canPlaceTeleporters = true,
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
local roomFolders =
{
    "default/",
    "room_small/",
    "plummet1/",
}

--------------------------------------------------
local roomIndices =
{
    ["default/"] = 1,
    ["room_small/"] = 2,
    ["plummet1/"] = 3,
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
local function onClientConnected (event)

    local filename = "player_" .. event.accountId .. ".lua"
    local settings = dio.file.loadLua (dio.file.locations.WORLD_PLAYER, filename)

    local isPasswordCorrect = true
    if settings then
        isPasswordCorrect = (settings.accountPassword == event.accountPassword)
    end

    local playerParams = nil

    if settings and isPasswordCorrect then
        playerParams =
        {
            connectionId = event.connectionId,
            avatar = settings.xyz,
            gravityDir = gravityDirIndices [settings.gravityDir],
        }

    else
        playerParams =
        {
            connectionId = event.connectionId,
            avatar =
            {
                roomFolder = roomFolders [1],
                chunkId = {0, 0, 0},
                xyz = {0, 0, 0},
                ypr = {0, 0, 0},
            },
            gravityDir = gravityDirIndices.DOWN,
        }

    end

    local playerEntityId = dio.world.createPlayer (playerParams)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        screenName = event.accountId,
        accountPassword = event.accountPassword,
        groupId = event.isSinglePlayer and "builder" or "tourist",
        isPasswordCorrect = isPasswordCorrect,
        needsSaving = event.isSinglePlayer,
        roomFolderIdx = roomIndices [playerParams.avatar.roomFolder],
        playerEntityId = playerEntityId,
        isInPlaceTeleporterMode = false,
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

    dio.world.destroyPlayer (connection.playerEntityId)

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function teleportPlayerToRoom (connection)

    dio.world.destroyPlayer (connection.playerEntityId)

    connection.roomFolderIdx = (connection.roomFolderIdx % #roomFolders) + 1

    local settings =
    {
        connectionId = connection.connectionId,
        avatar =
        {
            roomFolder = roomFolders [connection.roomFolderIdx],
            chunkId = {0, 0, 0},
            xyz = {0, 0, 0},
            ypr = {0, 0, 0},
        },
        gravityDir = gravityDirIndices.DOWN,
    }

    connection.playerEntityId = dio.world.createPlayer (settings)
end

--------------------------------------------------
local function onEntityPlaced (event)

    if event.isBlockValid then

        local connection = connections [event.connectionId]
        local group = groups [connection.groupId]

        local isPlacingSpongeBlock = (event.sourceBlockId == 28)
        if isPlacingSpongeBlock then
            event.cancel = not (group.canPlaceTeleporters and connection.isInPlaceTeleporterMode)
        else
            local isClickingOnSpongeBlock = (event.destinationBlockId == 28)
            if isClickingOnSpongeBlock then
                teleportPlayerToRoom (connection)
                event.cancel = true
            else
                event.cancel = not group.canBuild
            end
        end
    end
end

--------------------------------------------------
local function onEntityDestroyed (event)

    if event.isBlockValid then

        local connection = connections [event.connectionId]
        local group = groups [connection.groupId]

        local isSpongeBlock = (event.destinationBlockId == 28) -- true
        if isSpongeBlock then

            if group.canPlaceTeleporters and connection.isInPlaceTeleporterMode then
            else
                teleportPlayerToRoom (connection)
                event.cancel = true
            end

        else
            event.cancel = not group.canDestroy
        end
    end
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

    if event.text == ".togglePlaceTp" then

        -- TODO dont consume this command if group doesnt allow tp placement

        local connection = connections [event.authorConnectionId]
        connection.isInPlaceTeleporterMode = not connection.isInPlaceTeleporterMode
        event.targetConnectionId = event.authorConnectionId
        event.text = "Room Teleporters: " .. (connection.isInPlaceTeleporterMode and "PLACE MODE" or "TELEPORT MODE")

    elseif event.text == ".help" then

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
local function onLoadSuccessful ()

    -- dio.players.setPlayerAction (player, actions.LEFT_CLICK, outcomes.DESTROY_BLOCK)

    local types = dio.events.serverTypes
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)

end

--------------------------------------------------
local modSettings =
{
    description =
    {
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
        file = true,
        inputs = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
