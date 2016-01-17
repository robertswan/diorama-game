--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)
	dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x0000080);
end

--------------------------------------------------
local function renderChat (self)

	local self = instance

	local lineIdx = self.firstLineToDraw + self.linesToDraw - 1
	local y = (self.linesToDraw - 1) * self.heightPerY
	if lineIdx > #self.lines then
		lineIdx = #self.lines
	end

	local drawString = dio.drawing.font.drawString

	while y > 0 and lineIdx > 0 do
		local line = self.lines [lineIdx]
		drawString (0, y, line.author, 0xffffff)
		drawString (self.textOffset, y, line.text, 0xa0a0a0)

		y = y - self.heightPerY
		lineIdx = lineIdx - 1
	end
end

--------------------------------------------------
local function onChatMessageReceived (author, text)

	local self = instance

	local line = 
	{
		author = author, 
		text = text
	}

	self.lines [#self.lines + 1] = line;

	if self.autoScroll then
		self.firstLineToDraw = #self.lines - self.linesToDraw
		if self.firstLineToDraw < 1 then
			self.firstLineToDraw = 1
		end
	end

	-- table.insert (, line);

end

--------------------------------------------------
local function onEarlyRender (self)

	local self = instance
	-- if self.isVisible then

		dio.drawing.setRenderToTexture (self.renderToTexture)

		renderBg (self)
		renderChat (self)

		dio.drawing.setRenderToTexture (nil)

	-- end
end

--------------------------------------------------
local function onLateRender (self)

	dio.drawing.drawTexture (self.renderToTexture, self.position.x, self.position.y, self.size.w * self.scale, self.size.h * self.scale)
end

--------------------------------------------------
local function onLoadSuccessful ()

	instance = 
	{
		firstLineToDraw = 1,
		autoScroll = true,
		linesToDraw = 20,
		position = {x = 20, y = 20},
		size = {w = 300, h = 20 * 14},
		heightPerY = 14,
		textOffset = 100,
		scale = 2,
		lines = {}
	}

	instance.renderToTexture = dio.drawing.createRenderToTexture (instance.size.w, instance.size.h)
	dio.drawing.addRenderPassBefore (function () onEarlyRender (instance) end)
	dio.drawing.addRenderPassAfter (function () onLateRender (instance) end)

	local types = dio.game.eventTypes
	dio.game.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatMessageReceived)
	-- dio.game.events.addListener (types.CLIENT_UPDATED, onClientUpdated)
	-- dio.game.addListener (types.CLIENT_RENDERED, onClientRendered)

	onChatMessageReceived ("Self", "World loaded")

end

--------------------------------------------------
local modSettings = 
{
	name = "Chat",

	description = "Can draw a chat window and allow players to type in it",

	permissionsRequired = 
	{
		client = true,
		player = true,
	},
}

--------------------------------------------------
return modSettings, onLoadSuccessful
