
local instance = nil

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x333333A0);
end

--------------------------------------------------
local function onEarlyRender (self)

    if instance.isDirty then

        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)

        local drawString = dio.drawing.font.drawString
        drawString (3, 1, instance.text, 0xffAA66ff)

        dio.drawing.setRenderToTexture (nil)

        instance.isDirty = false
    end
end

--------------------------------------------------
local function onLateRender (self)

    local windowW, windowH = dio.drawing.getWindowSize ()
    self.position.y = windowH - (self.size.h + 50)

    dio.drawing.drawTexture (self.renderToTexture, self.position.x, self.position.y, self.texture.w * self.scale, self.texture.h * self.scale, 0xffffffff)
end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "tinyGalaxy.WORLD" then

        instance.text = event.payload
        instance.isDirty = true
        event.cancel = true
    end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
		position = {x = 30, y = 50},
		size = {w = 256, h = 13},
		texture = {w = 256, h = 13},
		border = 4,
		scale = 4,
        isDirty = true,
        text = "",
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.texture.w, instance.texture.h)

    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
	dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)

end

--------------------------------------------------
local modSettings =
{
    name = "Tiny Galaxy OSD",

    description = "",

    permissionsRequired =
    {
        drawing = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
