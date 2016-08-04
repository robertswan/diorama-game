local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = 
{
    w = 100,
    h = 14,
    isDirty = true,
    isVisible = false,
    roundTimeLeft = 0,
    lastTimeAsInteger = 0,
}

--------------------------------------------------
local function renderBg (instance)
    dio.drawing.font.drawBox (0, 0, instance.w, instance.h, 0x000000c0)
end

--------------------------------------------------
local function renderClock (instance)

    local drawString = dio.drawing.font.drawString
    drawString (4, 2, "Time left: " .. tostring (instance.lastTimeAsInteger), 0x00ffffff)
end

--------------------------------------------------
local function onEarlyRender (instance)

    if instance.isDirty then

        dio.drawing.setRenderToTexture (instance.renderToTexture)
        renderBg (instance)
        renderClock (instance)
        dio.drawing.setRenderToTexture (nil)
        instance.isDirty = false
    end
end

--------------------------------------------------
local function onLateRender (instance)

    if instance.isVisible then
        local windowW, windowH = dio.drawing.getWindowSize ()
        local scale = Window.calcBestFitScale (instance.w, instance.h, windowW, windowH)
        scale = (scale > 2) and 2 or scale
        local x = (windowW - instance.w * scale) - 20
        local y = (windowH - instance.h * scale) - 20
        dio.drawing.drawTexture (instance.renderToTexture, x, y, instance.w * scale, instance.h * scale, 0xffffffff)
    end
end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "voxel_arena.JOIN_WAITING_ROOM" then
        instance.isDirty = true

    elseif event.id == "voxel_arena.JOIN_GAME" then
        instance.roundTimeLeft = tonumber (event.payload)
        instance.lastTimeAsInteger = math.ceil (tonumber (instance.roundTimeLeft))
        instance.isVisible = true
        instance.isDirty = true

    elseif event.id == "voxel_arena.BEGIN_GAME" then
        instance.roundTimeLeft = tonumber (event.payload)
        instance.lastTimeAsInteger = math.ceil (tonumber (instance.roundTimeLeft))
        instance.isVisible = true
        instance.isDirty = true

    elseif event.id == "voxel_arena.END_GAME" then
        instance.isVisible = false

    end
end

--------------------------------------------------
local function onUpdated (event)

    if instance.isVisible then
        instance.roundTimeLeft = instance.roundTimeLeft - event.timeDelta
        if instance.roundTimeLeft < 0 then
            instance.roundTimeLeft = 0
        end

        local timeAsInteger = math.ceil (tonumber (instance.roundTimeLeft))
        if timeAsInteger < instance.lastTimeAsInteger then
            instance.lastTimeAsInteger = timeAsInteger
            instance.isDirty = true
        end
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
    dio.events.addListener (types.UPDATED, onUpdated)
end

--------------------------------------------------
local modSettings =
{
    name = "Voxel Arena Clock",

    description = "Shows round time left",

    permissionsRequired =
    {
        drawing = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
