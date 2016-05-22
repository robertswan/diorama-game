local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x00000c0);
end

--------------------------------------------------
local function renderPlayerList (self)

    local drawString = dio.drawing.font.drawString

    local y = self.heightPerLine * 2
    drawString (0, 0, "SCORE", 0xffffffff)

    for idx = 1, #self.scores, 2 do
        y = y + self.heightPerLine
        drawString (0, y, self.scores [idx], 0x00ffffff)
        drawString (100, y, self.scores [idx + 1], 0x00ffffff)
    end
end

--------------------------------------------------
local function onEarlyRender (self)

    if self.isDirty then

        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)
        renderPlayerList (self)
        dio.drawing.setRenderToTexture (nil)
        self.isDirty = false
    end
end

--------------------------------------------------
local function onLateRender (self)

    if self.isVisible then
        local windowW, windowH = dio.drawing.getWindowSize ()
        local scale = Window.calcBestFitScale (self.w, self.h, windowW, windowH)
        scale = (scale > 2) and 2 or scale
        local x = (windowW - self.w * scale) - 20
        local y = 20
        dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * scale, self.h * scale, 0xffffffff)
        --dio.drawing.drawTexture (self.renderToTexture, 0, 0, self.w * scale, self.h * scale, 0xffffffff)
    end
end

-- --------------------------------------------------
-- local function onOtherClientConnected (clientId)
--     local self = instance
--     table.insert (self.clients, {accountId = clientId})
--     self.isDirty = true
-- end

-- --------------------------------------------------
-- local function onOtherClientDisconnected (clientId)
--     local self = instance
--     for idx, client in ipairs (self.clients) do
--         if client.accountId == clientId then
--             table.remove (self.clients, idx)
--             self.isDirty = true
--             return
--         end
--     end
-- end

--------------------------------------------------
local function onChatReceived (author, text)

    local self = instance

    -- self.scores = {}
    -- table.insert (self.scores, "yo")
    -- table.insert (self.scores, "momma")
    -- self.isDirty = true

    if author == "SCORE" then

        self.scores = {}

        for word in string.gmatch(text, "[^:]+") do
            table.insert (self.scores, word)
        end      

        self.isDirty = true

        return true
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance = 
    {
        w = 128, 
        h = 256,
        heightPerLine = 14,
        scores = {},
        isDirty = true,
        isVisible = true,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.types
    -- dio.events.addListener (types.CLIENT_OTHER_CLIENT_CONNECTED, onOtherClientConnected)
    -- dio.events.addListener (types.CLIENT_OTHER_CLIENT_DISCONNECTED, onOtherClientDisconnected)
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatReceived)
end

--------------------------------------------------
local modSettings = 
{
    name = "Plummet scoreboard",

    description = "Shows all players scores from the current or previous game",

    permissionsRequired = 
    {
        client = true,
        player = true,
        input = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
