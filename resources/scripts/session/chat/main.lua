--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderChat (self)

	-- local drawString = dio.drawing.font.drawString
	-- local line = instance.lines [1]

	-- if line then
	-- 	drawString (100, 100, instance.lines [1].author, 0xffffff)
	-- 	drawString (200, 100, instance.lines [1].text, 0xffffff)
	-- end

	local self = instance

	local lineIdx = self.firstLineToDraw + self.linesToDraw - 1
	local y = (self.linesToDraw - 1) * self.linesToDraw
	if lineIdx > #self.lines then
		lineIdx = #self.lines
	end

	local drawString = dio.drawing.font.drawString

	while y > 0 and lineIdx > 0 do
		local line = self.lines [lineIdx]
		drawString (self.position.x, self.position.y + y, line.author, 0xffffff)
		drawString (self.position.x + self.textOffset, self.position.y + y, line.text, 0xa0a0a0)

		y = y - self.heightPerY
		lineIdx = lineIdx - 1
	end
end

--------------------------------------------------
local function renderTextBox (self)
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
local function onClientRendered ()

	local self = instance
	-- if self.isVisible then

		renderChat (self)
		renderTextBox (self)

	-- end
end

--------------------------------------------------
local function onLoadSuccessful ()

	instance = 
	{
		firstLineToDraw = 1,
		autoScroll = true,
		linesToDraw = 20,
		position = {x = 20, y = 20},
		heightPerY = 14,
		textOffset = 100,
		lines = {}
	}

	local types = dio.game.eventTypes
	dio.game.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatMessageReceived)
	-- dio.game.events.addListener (types.CLIENT_UPDATED, onClientUpdated)
	dio.game.addListener (types.CLIENT_RENDERED, onClientRendered)

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
