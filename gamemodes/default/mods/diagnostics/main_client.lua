
local instance = nil

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x333333A0);
end

--------------------------------------------------
local function onEarlyRender (self)
	if self.isVisible then
		local windowW, windowH = dio.drawing.getWindowSize ()
		self.position.y = windowH - (self.size.h + 50)

        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)

        if self.myAccountId then

    		local xyz, error = dio.world.getPlayerXyz (self.myAccountId)
    		local text = nil

    		if xyz then

                local xCoord = tostring (math.floor (xyz.xyz [1]))
    			local yCoord = tostring (math.floor (xyz.xyz [2]))
    			local zCoord = tostring (math.floor (xyz.xyz [3]))

                local x = self.border
                local y = self.border

                local text = "x: " .. xCoord ..  " y: " .. yCoord .. " z: " .. zCoord
                text = text .. " @ " .. xyz.roomFolder
                local drawString = dio.drawing.font.drawString
                drawString (x, y, text, 0xffAA66ff)

                self.size.w = dio.drawing.font.measureString (text)
                y = y + 10

                local times = dio.diagnostics.getTimes ()

                local weight = 0.8
                self.averageFps = self.averageFps * weight + times.fps * (1 - weight)
                text = string.format ("FPS = % 3d", math.floor (self.averageFps + 0.5))
                drawString (x, y, text, 0xffAA66ff)
                y = y + 10

                self.size.w = self.size.w + (self.border * 2)

    		end

        end

		dio.drawing.setRenderToTexture (nil)
	end
end

--------------------------------------------------
local function onLateRender (self)
	if self.isVisible then
		dio.drawing.drawTexture (self.renderToTexture, self.position.x, self.position.y, self.texture.w * self.scale, self.texture.h * self.scale, 0xffffffff)
	end
end

--------------------------------------------------
local function onKeyClicked (keyCode, keyModifiers, keyCharacter)

	local self = instance
	local keyCodes = dio.inputs.keyCodes

	if keyCode and keyCode == keyCodes.F3 then

		self.isVisible = not self.isVisible

	end
end

--------------------------------------------------
local function onClientConnected (event)
    if event.isMe then
        instance.myAccountId = event.accountId
    end
end

--------------------------------------------------
local function onClientDisconnected (event)
    local self = instance
    if event.isMe then
        self.myAccountId = nil
    end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
		position = {x = 20, y = 50},
		size = {w = 256, h = 28},
		texture = {w = 256, h = 28},
		border = 4,
		scale = 2,
		isVisible = true,
        isDirty = true,
        averageFps = 0.0,
        accountId = nil,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.texture.w, instance.texture.h)

    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
	dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.types.clientEvents
	dio.events.addListener (types.KEY_CLICKED, onKeyClicked)
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)

end

--------------------------------------------------
local modSettings =
{
    name = "diagnostics",

    description = "debug information - fps, chunks, coords etc",

    permissionsRequired =
    {
        drawing = true,
        diagnostics = true,
        world = true,
        inputs = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
