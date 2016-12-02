--------------------------------------------------
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")
local EmoteDefinitions = require ("gamemodes/default/mods/chat/emote_definitions")

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
local function renderChatLine (self, line, y)

    local drawString = dio.drawing.font.drawString

    drawString (0, y, line.author, 0x000000ff, true)
    drawString (0, y + 2, line.author, 0xffff00ff, true)

    local x = self.textOffset

    for _, word in ipairs (line.textList) do

        if word then

            local emote = emotes [word]

            if emote then
                -- draw the emote
                local u, v = emote.uvs [1], emote.uvs [2]

                dio.drawing.drawTextureRegion2 (self.emoteTexture,      x, y,
                                                emoteSpecs.renderWidth, emoteSpecs.renderHeight,
                                                u * emoteSpecs.width,   v * emoteSpecs.height,
                                                emoteSpecs.width,       emoteSpecs.height)

                x = x + emoteSpecs.renderWidth

            else
                -- draw the string (with shadow)
                drawString (x, y, word, 0x000000ff, true)
                drawString (x, y+2, word, 0xffffffff, true)
                x = x + dio.drawing.font.measureString (word)
            end
        end
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
