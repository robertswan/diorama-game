--------------------------------------------------
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local params =
{
    visibleDuration = 60 * 5,
    fadeOutDuration = 60 * 0.5,
}

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
function c:earlyRender ()

    dio.drawing.setRenderToTexture (self.renderToTexture)

    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x000000b0);

    local drawString = dio.drawing.font.drawString

    drawString (0, 2, self.author, 0x000000ff)
    drawString (0, 0, self.author, 0xffff00ff)
    drawString (self.textOffset, 2, self.text, 0x000000ff, true)
    drawString (self.textOffset, 0, self.text, 0xffffffff)

    dio.drawing.setRenderToTexture (nil)

    self.isDirty = false
end

--------------------------------------------------
function c:lateRender (x, y)
    
    local rgba = 0xffffff00 + (self.alpha * 255)

    dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * self.scale, self.h * self.scale, rgba)
end

--------------------------------------------------
return function (author, text, w, h, textOffset)
    
    local instance = 
    {
        author = author,
        text = text,
        textOffset = textOffset,
        w = w,
        h = h,
        scale = 2,
        alpha = 1,
        tickCount = 0,
        renderToTexture = dio.drawing.createRenderToTexture (w, h),
        isDirty = true,
    }

    Mixin.CopyTo (instance, c)
    return instance
end
