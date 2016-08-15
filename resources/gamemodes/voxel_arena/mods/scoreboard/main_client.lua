local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = 
{
    w = 160,
    h = 356,
    heightPerLine = 14,
    scores = {},
    isDirty = true,
    isVisible = true,
    isPlaying = false,
}

--------------------------------------------------
local function renderBg (instance)
    dio.drawing.font.drawBox (0, 0, instance.w, instance.h, 0x000000c0)
end

--------------------------------------------------
local function renderPlayerList (instance)

    local drawBox = dio.drawing.font.drawBox
    local drawString = dio.drawing.font.drawString

    local y = instance.h - instance.heightPerLine * 2

    for idx = 1, #instance.scores, 3 do

        drawString (8, y, instance.scores [idx], 0x00ffffff)
        drawString (100, y, "K:" .. instance.scores [idx + 1], 0x00ffffff)
        drawString (130, y, "D:" .. instance.scores [idx + 2], 0x00ffffff)
        y = y - instance.heightPerLine
    end

end

--------------------------------------------------
local function onEarlyRender (instance)

    if instance.isDirty then

        dio.drawing.setRenderToTexture (instance.renderToTexture)
        renderBg (instance)
        renderPlayerList (instance)
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
        local y = 20
        dio.drawing.drawTexture (instance.renderToTexture, x, y, instance.w * scale, instance.h * scale, 0xffffffff)
        --dio.drawing.drawTexture (instance.renderToTexture, 0, 0, instance.w * scale, instance.h * scale, 0xffffffff)
    end
end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "voxel_arena.JOIN_WAITING_ROOM" then

    elseif event.id == "voxel_arena.JOIN_GAME" then
        instance.isPlaying = true

    elseif event.id == "voxel_arena.BEGIN_GAME" then
        instance.isPlaying = true
        instance.isDirty = true

    elseif event.id == "voxel_arena.END_GAME" then
        instance.isPlaying = false
        instance.isDirty = true

    elseif event.id == "voxel_arena.SCORE_UPDATE" then

        instance.scores = {}
        for word in string.gmatch (event.payload, "[^:]+") do
            table.insert (instance.scores, word)
        end
        instance.isDirty = true
        event.cancel = true
    
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
end

--------------------------------------------------
local modSettings =
{
    name = "Voxel Arena Scoreboard",

    description = "Shows all players scores from the current or previous game",

    permissionsRequired =
    {
        drawing = true,
        world = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
