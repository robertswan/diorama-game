local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)

    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x000000c0)

    if self.isPlaying then

        dio.drawing.font.drawString(self.barX - 9, self.barY + self.barHeight + 4, 'GOAL', 0xffff00ff)    
        -- dio.drawing.font.drawString(100, 116, '4000', 0x00ffffff)

        dio.drawing.font.drawBox (self.barX, self.barY, self.barWidth, self.barHeight, 0xffaa66e1)
    end
end

--------------------------------------------------
local function renderPlayerList (self)

    local drawBox = dio.drawing.font.drawBox
    local drawString = dio.drawing.font.drawString

    if self.isPlaying then

        local yScore = self.barHeight -- top of the bar
        local textOffsetY = 3

        for idx = 1, #self.scores, 2 do       
            local score = tonumber(self.scores [idx + 1])

            if score then
                local y = (score / self.dropDistance * self.barHeight)        

                drawBox (self.barX - 1, y + self.barY - 1, self.barWidth + 2, self.barWidth + 2, 0xffffffff)

                if y > yScore then
                    y = yScore
                else
                    yScore = y
                end
                yScore = yScore - self.heightPerLine + 5

                drawString (8, y + self.barY - textOffsetY, self.scores [idx], 0x00ffffff)
                drawString (100, y + self.barY - textOffsetY, self.scores [idx + 1], 0x00ffffff)

            end
        end
    else

        local notPlayingY = self.h - self.heightPerLine * 2

        for idx = 1, #self.scores, 2 do       

            drawString (8, notPlayingY, self.scores [idx], 0x00ffffff)
            drawString (100, notPlayingY, self.scores [idx + 1], 0x00ffffff)
            notPlayingY = notPlayingY - self.heightPerLine
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
        self.isDirty = true
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance = 
    {
        w = 128, 
        h = 356,
        heightPerLine = 14,
        barX = 94,
        barY = 80,
        barHeight = 250,
        barWidth = 4,
        dropDistance = 4000,
        scores = {},
        isDirty = true,
        isVisible = true,
        isPlaying = false,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.types
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
        world = true,
        input = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
