--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)
	dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x0000080);
end

--------------------------------------------------
local function renderChat (self)

	local chatLinesToDraw = self.linesToDraw - 2

	local lineIdx = self.firstLineToDraw + chatLinesToDraw - 1
	local y = (chatLinesToDraw - 1) * self.heightPerLine
	if lineIdx > #self.lines then
		lineIdx = #self.lines
	end

	local drawString = dio.drawing.font.drawString

	while y > 0 and lineIdx > 0 do
		local line = self.lines [lineIdx]
		drawString (0, y, line.author, 0xffffff)
		drawString (self.textOffset, y, line.text, 0xa0a0a0)

		y = y - self.heightPerLine
		lineIdx = lineIdx - 1
	end
end

--------------------------------------------------
local function renderTextEntry (self)

	local heightPerLine = self.heightPerLine
	local y = (self.linesToDraw - 2) * heightPerLine
	
	local drawString = dio.drawing.font.drawString
	drawString (0, y, "--------------------------------------------------------", 0xffffffff)
	drawString (0, y + heightPerLine, self.text, 0xffffffff)
	local width = dio.drawing.font.measureString (self.text)
	drawString (width, y + heightPerLine, "_", 0xff0000ff)

end

--------------------------------------------------
local function resetTextEntry (self)
	self.text = ""
end

--------------------------------------------------
local function hide (self)
	self.isVisible = false
	dio.inputs.setExclusiveKeys (false)
	dio.inputs.setArePlayingControlsEnabled (true)
end

--------------------------------------------------
local function onEarlyRender (self)

	if self.isDirty then

		dio.drawing.setRenderToTexture (self.renderToTexture)
		renderBg (self)
		renderChat (self)
		renderTextEntry (self)
		dio.drawing.setRenderToTexture (nil)
		self.isDirty = false
	end
end

--------------------------------------------------
local function onLateRender (self)

	if self.isVisible then
		dio.drawing.drawTexture (self.renderToTexture, self.position.x, self.position.y, self.size.w * self.scale, self.size.h * self.scale)
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

	self.isDirty = true

end

--------------------------------------------------
local function onKeyCodeClicked (keyCode)

	local self = instance

	if self.isVisible then

		if keyCode == dio.inputs.keyCodes.ENTER then

			local isOk, errorStr = dio.clientChat.send (self.text)
			if not isOk then
				onChatMessageReceived ("Self", "Last message did not send! (" .. errorStr .. ")")
			end

			resetTextEntry (self)

		elseif keyCode == dio.inputs.keyCodes.ESCAPE then

			hide (self)
		end

		return true

	elseif keyCode == self.chatAppearKeyCode then

		self.isVisible = true
		dio.inputs.setExclusiveKeys (true)
		dio.inputs.setArePlayingControlsEnabled (false)
		resetTextEntry (self)
		return true

	end

	return false
end

--------------------------------------------------
local function onKeyCharacterClicked (character)

	local self = instance

	if self.isVisible then
		self.text = self.text .. string.char (character)
		self.isDirty = true
		return true
	end

end

--------------------------------------------------
local function onClientWindowFocusLost ()

	local self = instance

	if self.isVisible then
		hide (self)
	end	

end

--------------------------------------------------
local function onLoadSuccessful ()

	local linesToDraw = 20
	local heightPerLine = 14
	local height = linesToDraw * heightPerLine

	instance = 
	{
		firstLineToDraw = 1,
		autoScroll = true,
		linesToDraw = linesToDraw,
		position = {x = 20, y = 20},
		size = {w = 512, h = height},
		heightPerLine = heightPerLine,
		textOffset = 100,
		scale = 2,
		lines = {},
		isDirty = true,
		isVisible = false,
		chatAppearKeyCode = dio.inputs.keyCodes.T,
		text = "",
	}

	instance.renderToTexture = dio.drawing.createRenderToTexture (instance.size.w, instance.size.h)
	dio.drawing.addRenderPassBefore (function () onEarlyRender (instance) end)
	dio.drawing.addRenderPassAfter (function () onLateRender (instance) end)

	local types = dio.events.types
	dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatMessageReceived)
	dio.events.addListener (types.CLIENT_KEY_CODE_CLICKED, onKeyCodeClicked)
	dio.events.addListener (types.CLIENT_KEY_CHARACTER_CLICKED, onKeyCharacterClicked)
	dio.events.addListener (types.CLIENT_WINDOW_FOCUS_LOST, onClientWindowFocusLost)

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
