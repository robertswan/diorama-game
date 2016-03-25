
local instance = nil

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x333333A0);
end

--------------------------------------------------
local function renderCoords (self, text)
	dio.drawing.font.drawString (self.border, self.border, text, 0xffAA66ff)
end

--------------------------------------------------
local function onEarlyRender (self)
	if self.isVisible then
		local windowW, windowH = dio.drawing.getWindowSize ()
		self.position.y = windowH - (self.size.h + 50)
		
		local author = dio.world.getPlayerNames () [1]
		local xyz, error = dio.world.getPlayerXyz (author)
		local text = nil

		if xyz then
			local x = math.floor (xyz.chunkId.x * 32 + xyz.xyz.x)
			local y = math.floor (xyz.chunkId.y * 32 + xyz.xyz.y)
			local z = math.floor (xyz.chunkId.z * 32 + xyz.xyz.z)

			text = "x: " .. x ..  " y: " .. y .. " z: " .. z

			self.size.w = dio.drawing.font.measureString(text) + (self.border * 2)
		end

		dio.drawing.setRenderToTexture (self.renderToTexture)
		renderBg (self)
		renderCoords (self, text)
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
local function onLoadSuccessful ()

    instance = 
    {
		position = {x = 20, y = 50},
		size = {w = 100, h = 14},
		texture = {w = 150, h = 14},
		border = 4,
		scale = 2,
		isVisible = true,
        isDirty = true,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.texture.w, instance.texture.h)

    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)
end

--------------------------------------------------
local modSettings = 
{
    name = "coords",

    description = "coords",

    permissionsRequired = 
    {
        client = true,
        player = true,
        input = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
