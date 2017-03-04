local Resources = require ("resources/scripts/utils/resources")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function teleportTo (x, y, z, yaw, pitch, roll)
    setting =
    {
        chunkId = {0, 0, 0},
        xyz = {x + 0.5, y + 0.5, z + 0.5},
        ypr = {yaw or 0, pitch or 0, roll or 0},
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

    if event.name == "PLAYER" then

        local c = dio.entities.components

        local player = dio.entities.getComponent (event.entityId, c.TEMP_PLAYER)
        if player.isYou then
            local controller = 
            {
                onClientUpdate = function (updateEvent)
                    local buttons = updateEvent.buttons
                    local speed = 10
                    local delta = {0, 0, 0}
                    if buttons.left then
                        delta [1] = -speed
                    elseif buttons.right then
                        delta [1] = speed
                    elseif buttons.up then
                        delta [3] = -speed
                    elseif buttons.down then
                        delta [3] = speed
                    else
                        return
                    end

                    return {velocityOverlayAbsolute = delta}

                    -- local rigidBody = dio.entities.getComponent (updateEvent.entityId, c.RIGID_BODY)            
                    -- rigidBody.velocityOverlay [1] = rigidBody.velocityOverlay [1] + delta [1]
                    -- rigidBody.velocityOverlay [2] = rigidBody.velocityOverlay [2] + delta [2]
                    -- rigidBody.velocityOverlay [3] = rigidBody.velocityOverlay [3] + delta [3]
                    -- dio.entities.setComponent (updateEvent.entityId, c.RIGID_BODY, rigidBody)
                end
            }

            dio.entities.setComponent (event.entityId, c.CHARACTER_CONTROLLER, controller)
        end


        local name = player.isYou and "YOU" or "SOMEONE ELSE"
        local nameComponents = 
        {
            [c.PARENT] =                    {parentEntityId = event.entityId},
            [c.BILLBOARD_TRANSFORM] =       {xyz = {0, 2.25, 0}, scale = {50, 50, 50}},
            [c.RENDER_TO_TEXTURE_RENDERER] =
            {
                onCreateTexture = function (event)

                    local font = dio.drawing.font
                    local w = font.measureString (name) + 3
                    local h = 11
                    event.texture = dio.drawing.createRenderToTexture (w, h)

                    dio.drawing.setRenderToTexture (event.texture)
                    font.drawBox (0, 0, w, h, 0x000000ff);
                    font.drawString (2, 0, name, 0xffffffff)
                    dio.drawing.setRenderToTexture (nil)
                end,
            },
        }

        dio.entities.create (event.roomEntityId, nameComponents)

    elseif event.name == "PLAYER_EYE_POSITION" then

        local c = dio.entities.components
        
        local parentEntityId = dio.entities.getComponent (event.entityId, c.PARENT).parentEntityId
        local player = dio.entities.getComponent (parentEntityId, c.TEMP_PLAYER)

        if player.connectionId == instance.myConnectionId then
        
            local camera = 
            {
                [c.CAMERA] =
                {
                    cameraType = dio.types.cameraTypes.LOOK_AT,
                    projectionType = dio.types.projectionTypes.PERSPECTIVE,
                    attachTo = event.entityId,
                    lookAt = {0, 0, 0},
                    offset = {0, 60, 40},
                    fov = 20,
                    nearClip = 1,
                    farClip = 1000,

                    -- cameraType = dio.types.cameraTypes.LOOK_AT,
                    -- projectionType = dio.types.projectionTypes.ORTHO,
                    -- attachTo = event.entityId,
                    -- lookAt = {0, 0, 0},
                    -- offset = {80, 100, 80},
                    -- orthoScale = {16, 16},
                    -- nearClip = 10,
                    -- farClip = 1000,

                },
                [c.PARENT] =                {parentEntityId = event.roomEntityId},
                [c.TRANSFORM] =             {},
            }

            local cameraEntityId = dio.entities.create (event.roomEntityId, camera)
            dio.drawing.setMainCamera (cameraEntityId)
        end
    end
end

--------------------------------------------------
local function addPlayerModel (id)
    return
    {
        id = id,
        filename = "models/characters/" .. id .. ".vox",
        options = {scale = {1/8, 1/8, 1/8}, translate = {-0.5, 0, -0.5}, rotate180 = true},
    }
end

--------------------------------------------------
local entityModels =
{
    chr_priest = addPlayerModel ("chr_priest"),
    alien_bot1 = addPlayerModel ("alien_bot1"),
    alien_infected1 = addPlayerModel ("alien_infected1"),
    chr_army2 = addPlayerModel ("chr_army2"),
    chr_bridget = addPlayerModel ("chr_bridget"),
    chr_headphones = addPlayerModel ("chr_headphones"),
    chr_nun = addPlayerModel ("chr_nun"),
    chr_nurse = addPlayerModel ("chr_nurse"),
}
local loadedEntityModels = {}

--------------------------------------------------
local function onResourceRequired (event)
    --if event.resourceType == dio.types.resourceTypes.REGULAR_MODEL then
        local toLoad =
        {
            entityModels [event.resourceId]
        }
        Resources.loadEntityModels (toLoad)
        table.insert (loadedEntityModels, {id = event.resourceId})
        event.cancel = true
    --end
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
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated, "PLAYER")
    -- dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated, "PLAYER_EYE_POSITION")
    dio.events.addListener (types.RESOURCE_REQUIRED, onResourceRequired)

end

--------------------------------------------------
local function onUnload ()
    Resources.unloadEntityModels (loadedEntityModels)
    loadedEntityModels = {}
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
        resources = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
        onUnload = onUnload,
    },    
}

--------------------------------------------------
return modSettings
