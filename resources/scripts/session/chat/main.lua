--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderChat (self)

	local y = (self.linesToDraw - 1) * self.linesToDraw
	local lineIdx = self.firstLineToDraw + self.linesToDraw - 1
	if lineIdx >= #self.lines then
		lineIdx = #self.lines
	end

	local drawString = dio.drawing.font.drawString

	while y > 0 and lineIdx > 0 do
		local line = self.lines [lineIdx]
		drawString (self.x, instance.y + y, line.author, 0xffffff)
		drawString (self.x + self.textOffset, instance.y + y, line.text, 0xa0a0a0)

		y = y - self.heightPerY
		lineIdx = lineIdx - 1
	end
end

--------------------------------------------------
local function renderTextBox (self)
end

--------------------------------------------------
local function onChatMessageReceived (author, text)

	local line = 
	{
		author = author, 
		text = text
	}

	instance.lines [#instance.lines] = line;

	-- table.insert (, line);

end

--------------------------------------------------
local function onClientRendered ()

	local self = instance
	if self.isVisible then

		renderChat (self)
		renderTextBox (self)

	end
end

--------------------------------------------------
local function onLoadSuccessful ()

	instance = 
	{
		firstLineToDraw = 1,
		linesToDraw = 10,
		position = {x = 20, y = 20},
		heightPerY = 14,
		textOffset = 30,
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
