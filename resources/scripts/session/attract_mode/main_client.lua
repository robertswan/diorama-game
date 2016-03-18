local Window = require ("resources/scripts/utils/window")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)
	dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x000000c0);
end

--------------------------------------------------
local function renderMessage (self)

	local drawString = dio.drawing.font.drawString

	local w = dio.drawing.font.measureString ("Diorama")
	drawString ((self.w - w) / 2, 1, "Diorama", 0x000000ff)
	drawString ((self.w - w) / 2, 0, "Diorama", 0xffffffff)

	w = dio.drawing.font.measureString (self.message)
	local y = 10
	drawString ((self.w - w) / 2, y + 1, self.message, 0x000000ff)
	drawString ((self.w - w) / 2, y, self.message, 0xffff00ff)
end

--------------------------------------------------
local function onEarlyRender (self)

	if self.isDirty then

		dio.drawing.setRenderToTexture (self.renderToTexture)
		renderBg (self)
		renderMessage (self)
		dio.drawing.setRenderToTexture (nil)
		self.isDirty = false
	end
end

--------------------------------------------------
local function onLateRender (self)

	if self.isVisible then
		local windowW, windowH = dio.drawing.getWindowSize ()
		local scale = Window.calcBestFitScale (self.w, self.h, windowW, windowH)
		local x = (windowW - self.w * scale) * 0.5
		local y = (windowH - self.h * scale)
		dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * scale, self.h * scale, 0xffffffff)
	end
end

--------------------------------------------------
local function onChatMessagePreSent (text)

	local self = instance

	local command = ".attract"
	local found = text:sub (1, command:len())

	if found == command then

		local message = text:sub (command:len() + 1)
		if message ~= "" then
			self.message = message
			self.isVisible = true
			self.isDirty = true
		else
			self.isVisible = false
		end

		return true
	end

	return false
end

--------------------------------------------------
local function onClientUpdated ()

	local self = instance
	if self.isVisible then
		local author = dio.world.getPlayerNames () [1]
		local xyz, error = dio.world.getPlayerXyz (author)
		if xyz then
			xyz.ypr.y = xyz.ypr.y + 0.005
			dio.world.setPlayerXyz (author, xyz)
		end
	end
end


--------------------------------------------------
local function onLoadSuccessful ()

	local types = dio.events.types
	dio.events.addListener (types.CLIENT_CHAT_MESSAGE_PRE_SENT, onChatMessagePreSent)

	instance = 
	{
		w = 128, 
		h = 20,
		isDirty = false,
		isVisible = false,
	}

	instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
	dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
	dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

	dio.events.addListener (types.CLIENT_UPDATED, onClientUpdated)
end

--------------------------------------------------
local modSettings = 
{
	name = "Attract Mode",

	description = "silly attract mode stuff",

	permissionsRequired = 
	{
		client = true,
		player = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
