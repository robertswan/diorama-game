
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
    			
                local xCoord = math.floor (xyz.chunkId.x * 32 + xyz.xyz.x)
    			local yCoord = math.floor (xyz.chunkId.y * 32 + xyz.xyz.y)
    			local zCoord = math.floor (xyz.chunkId.z * 32 + xyz.xyz.z)

                local x = self.border
                local y = self.border

                local text = "x: " .. xCoord ..  " y: " .. yCoord .. " z: " .. zCoord
                local drawString = dio.drawing.font.drawString
                drawString (x, y, text, 0xffAA66ff)
                self.size.w = dio.drawing.font.measureString(text)                
                y = y + 10

                local times = dio.diagnostics.getTimes ()

                local weight = 0.8
                self.averageFps = self.averageFps * weight + times.fps * (1 - weight)
                text = string.format ("FPS = % 3d", math.floor (self.averageFps + 0.5))
                drawString (x, y, text, 0xffAA66ff)
                y = y + 10

                -- text = string.format ("U = %.4f", times.update * 1000.0)
                -- drawString (x, y, text, 0xffAA66ff)
                -- y = y + 10

                -- text = string.format ("RE (ms) = %.4f", times.renderEarly * 1000.0)
                -- drawString (x, y, text, 0xffAA66ff)
                -- y = y + 10

                -- text = string.format ("R = %.4f", times.render * 1000.0)
                -- drawString (x, y, text, 0xffAA66ff)
                -- y = y + 10

                -- text = string.format ("RL = %.4f", times.renderLate * 1000.0)
                -- drawString (x, y, text, 0xffAA66ff)
                -- y = y + 10

                -- text = string.format ("OGL = %.4f", times.openGl * 1000.0)
                -- drawString (x, y, text, 0xffAA66ff)
                -- y = y + 10

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
local function onKeyClicked (keyCode, keyCharacter, keyModifiers)
	
	local self = instance
	local keyCodes = dio.inputs.keyCodes
	
	if keyCode == keyCodes.F3 then
		
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
local function onLoadSuccessful ()

    instance = 
    {
		position = {x = 20, y = 50},
		size = {w = 100, h = 28},
		texture = {w = 150, h = 28},
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
	
    local types = dio.events.types
	dio.events.addListener (types.CLIENT_KEY_CLICKED, onKeyClicked)
    dio.events.addListener (types.CLIENT_CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_CLIENT_DISCONNECTED, onClientDisconnected)

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
        player = true,
        input = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
