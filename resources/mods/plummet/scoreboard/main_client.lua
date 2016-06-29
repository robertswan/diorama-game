local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x000000c0)
    dio.drawing.font.drawBox (110, 126, 4, 100, 0xffaa66e1)
    dio.drawing.font.drawString(110, 228, '0', 0x00ffffff)    
    dio.drawing.font.drawString(100, 116, '5000', 0x00ffffff)
end

--------------------------------------------------
local function renderPlayerList (self)

    local drawString = dio.drawing.font.drawString

    local y = self.heightPerLine
    local yScore = 0
    drawString (2, 2, "SCORE", 0xffffffff)
    
    local score = nil

    for idx = 1, #self.scores, 2 do       
        score = tonumber(self.scores [idx + 1])
        if self.isPlaying and score then
            yScore = 220 - (score / 5000 * 100)        
            drawString (8, yScore, self.scores [idx], 0x00ffffff)
            drawString (100, yScore, self.scores [idx + 1], 0x00ffffff)
        else
            y = y + self.heightPerLine
            drawString (8, y, self.scores [idx], 0x00ffffff)
            drawString (100, y, self.scores [idx + 1], 0x00ffffff)
        end
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
-- local function onClientConnected (event)
--     local self = instance
--     table.insert (self.clients, {accountId = event.accountId})
--     self.isDirty = true
-- end

-- --------------------------------------------------
-- local function onClientDisconnected (event)
--     local self = instance
--     for idx, client in ipairs (self.clients) do
--         if client.accountId == event.accountId then
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
    
    if author == "START" then
       self.isPlaying = true 
    end

    if author == "SCORE" then

        self.scores = {}

        for word in string.gmatch(text, "[^:]+") do
            table.insert (self.scores, word)
        end      

        self.isDirty = true

        return true
    end
    
    if author == "RESULT" then
        self.isPlaying = false
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
        isPlaying = false,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.types
    -- dio.events.addListener (types.CLIENT_CLIENT_CONNECTED, onClientConnected)
    -- dio.events.addListener (types.CLIENT_CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatReceived)
end

--------------------------------------------------
local modSettings = 
{
    name = "Plummet scoreboard",

    description = "Shows all players scores from the current or previous game",

    permissionsRequired = 
    {
        drawing = true,
        player = true,
        input = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
