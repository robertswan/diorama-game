--------------------------------------------------
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local EmoteDefinitions = require ("resources/mods/diorama/chat/emote_definitions")

--------------------------------------------------
local params =
{
    visibleDuration = 60 * 5,
    fadeOutDuration = 60 * 0.5,
}

local emotes = EmoteDefinitions.emotes
local emoteSpecs = EmoteDefinitions.emoteSpecs

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:update ()

    self.tickCount = self.tickCount + 1
    if self.tickCount > params.visibleDuration + params.fadeOutDuration then
        return false
    elseif self.tickCount > params.visibleDuration then
        self.alpha = 1 - ((self.tickCount - params.visibleDuration) / params.fadeOutDuration)
    end

    return true
end

--------------------------------------------------
-- DUPE CODE
local function getEmoteID (text)
    -- Returns the emote ID or -1 if unsucessful
    local emoteID = -1

    if string.sub (text, 1, 1) == emoteSpecs.emoteStartChar then
        local newString = string.sub (text, 2, string.len(text))

        local i = 1
        while emotes[i] ~= nil do
            local emoteName = emotes[i].name
            if newString == emoteName then
                emoteID = i
            end
            i = i + 1
        end

    end

    return emoteID
end

--------------------------------------------------
-- DUPE CODE
local function renderChatLine (self, line, y)
    
    local drawString = dio.drawing.font.drawString

    drawString (0, y, line.author, 0x000000ff, true)
    drawString (0, y + 2, line.author, 0xffff00ff, true)

    local i = 1;
    local x = self.textOffset

    while line.textList[i] ~= nil do
        local curText = line.textList[i]
        local emoteID = getEmoteID(curText)

        if emoteID > 0 then
            -- draw the emote
            local u, v = emotes[emoteID].uvs[1], emotes[emoteID].uvs[2]
            dio.drawing.drawTextureRegion2 (self.emoteTexture,      x, y, 
                                            emoteSpecs.renderWidth, emoteSpecs.renderHeight, 
                                            u * emoteSpecs.width,   v * emoteSpecs.height, 
                                            emoteSpecs.width,       emoteSpecs.height)
            x = x + emoteSpecs.renderWidth
        else
            -- draw the string (with shadow)
            drawString (x, y, curText, 0x000000ff, true)
            drawString (x, y+2, curText, 0xffffffff, true)
            x = x + dio.drawing.font.measureString (line.textList[i])
        end 

        i = i + 1
    end
end

--------------------------------------------------
function c:earlyRender ()

    dio.drawing.setRenderToTexture (self.renderToTexture)

    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x000000b0)
    renderChatLine (self, self.line, 0)

    dio.drawing.setRenderToTexture (nil)

    self.isDirty = false
end

--------------------------------------------------
function c:lateRender (x, y)
    
    local rgba = 0xffffff00 + (self.alpha * 255)

    dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * self.scale, self.h * self.scale, rgba)
end

--------------------------------------------------
return function (line, w, h, textOffset, emoteTexture)
    
    local instance = 
    {
        line = line,
        textOffset = textOffset,
        w = w,
        h = h,
        scale = 2,
        alpha = 1,
        tickCount = 0,
        renderToTexture = dio.drawing.createRenderToTexture (w, h),
        emoteTexture = emoteTexture, 
        isDirty = true,
    }

    Mixin.CopyTo (instance, c)
    return instance
end
