--------------------------------------------------
local instance = nil

--------------------------------------------------
local function teleportTo (x, y, z, yaw, pitch, roll)
    setting =
    {
        chunkId = {0, 0, 0},
        xyz = {x, y, z},
        ypr = {yaw, pitch, roll},
    }

    dio.world.setPlayerXyz (instance.myAccountId, setting)
end

--------------------------------------------------
local function onChatMessagePreSent (text)

    if text == ".spawn" then

        teleportTo (0, 128, 0)

    elseif string.sub (text, 1, string.len(".tp "))==".tp " then

        local words = {}

        for word in string.gmatch(text, "[^ ]+") do
            table.insert (words, word)
        end

        print ("input = " .. text)
        for _, word in ipairs (words) do
            print (" word = " .. word)
        end

        if #words == 2 then
            local xyz, error = dio.world.getPlayerXyz (words [2])
            if xyz then
                local x = math.floor (xyz.chunkId [1] * 32 + xyz.xyz [1])
                local y = math.floor (xyz.chunkId [2] * 32 + xyz.xyz [2])
                local z = math.floor (xyz.chunkId [3] * 32 + xyz.xyz [3])
                teleportTo (math.floor(x), math.floor(y), math.floor(z))
            end

        elseif #words == 4 then
            teleportTo (math.floor(words [2]), math.floor(words [3]), math.floor(words [4]))

        end

    elseif string.sub(text,1,string.len(".coords"))==".coords" then

        local nameCount = 0
        for accountId in string.gmatch (text, "[%S]+") do

            nameCount = nameCount + 1
            if nameCount > 1 then
                local xyz, error = dio.world.getPlayerXyz (accountId)
                if xyz then
                    local x = math.floor (xyz.chunkId [1] * 32 + xyz.xyz [1])
                    local y = math.floor (xyz.chunkId [2] * 32 + xyz.xyz [2])
                    local z = math.floor (xyz.chunkId [3] * 32 + xyz.xyz [3])
                    dio.clientChat.send ("Coords for " .. accountId .. " = (" .. x .. ", " .. y .. ", " .. z .. ")")
                end
            end
        end

        if nameCount == 1 then
            local xyz, error = dio.world.getPlayerXyz (instance.myAccountId)
            if xyz then
                local x = math.floor (xyz.chunkId [1] * 32 + xyz.xyz [1])
                local y = math.floor (xyz.chunkId [2] * 32 + xyz.xyz [2])
                local z = math.floor (xyz.chunkId [3] * 32 + xyz.xyz [3])
                dio.clientChat.send ("Coords for " .. instance.myAccountId .. " = (" .. x .. ", " .. y .. ", " .. z .. ")")
            end
        end

    else
        return false
    end

    return true
end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "spawn.HOME" then

        local words = {}
        for word in string.gmatch (event.payload, "[^ ]+") do
            table.insert (words, word)
        end

        local x = tonumber (words [1])
        local y = tonumber (words [2])
        local z = tonumber (words [3])

        local yaw = tonumber (words [4])
        local pitch = tonumber (words [5])
        local roll = tonumber (words [6])

        teleportTo (x, y, z, yaw, pitch, roll)

        event.cancel = true
    end
end

--------------------------------------------------
local function onClientConnected (event)
    if event.isMe then
        instance.myConnectionId = event.connectionId
        instance.myAccountId = event.accountId
    end
end

--------------------------------------------------
local function onNamedEntityCreated (event)

    if event.name == "PLAYER_EYE_POSITION" then

        local c = dio.entities.components
        
        local parentEntityId = dio.entities.getComponent (event.entityId, c.PARENT).parentEntityId
        local player = dio.entities.getComponent (parentEntityId, c.TEMP_PLAYER)

        if player.connectionId == instance.myConnectionId then
        
            local camera = 
            {
                [c.CAMERA] =
                {
                    cameraType = dio.types.cameraTypes.FPS,
                    projectionType = dio.types.projectionTypes.PERSPECTIVE,
                    fov = 90,
                    attachTo = event.entityId,
                },
                -- {
                --     cameraType = dio.types.cameraTypes.LOOK_AT,
                --     fov = 90,
                --     attachTo = event.entityId,
                --     offset = {-16, 16, -16},
                -- },
                [c.PARENT] =                {parentEntityId = event.roomEntityId},
                [c.TRANSFORM] =             {},
            }

            local cameraEntityId = dio.entities.create (event.roomEntityId, camera)
            dio.drawing.setMainCamera (cameraEntityId)
        end
    end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
        myAccountId = nil,
    }

    local types = dio.types.clientEvents
    dio.events.addListener (types.CHAT_MESSAGE_PRE_SENT, onChatMessagePreSent)
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)
end

--------------------------------------------------
local modSettings =
{
    name = "Spawn",

    description = "Coordinate related shenanigans",
    author = "AmazedStream",
    help =
    {
        [".spawn"] =    {usage = ".spawn",         description = "teleports you to the safe spawn"},
        [".tp"] =       {usage = ".tp x y z",     description = "teleports you coordinates (x, y, z)"},
        [".coords"] =   {usage = ".coords ",     description = "prints your or N players coordinates"},
        [".sethome"] =  {usage = ".sethome",    description = "sets a home location for the current session"},
        [".home"] =     {usage = ".home",       description = "teleports you back to your set home location"},
    },

    permissionsRequired =
    {
        drawing = true,
        entities = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
