local TickerLine = require ("resources/scripts/session/chat/ticker_line")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local chatHistory = {}
local currentElement = 0

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x000000b0);
end

--------------------------------------------------
local function renderChat (self)

    local lineIdx = self.firstLineToDraw + self.chatLinesToDraw
    local y = (self.chatLinesToDraw - 1) * self.heightPerLine
    if lineIdx > #self.lines then
        lineIdx = #self.lines
    end

    local drawString = dio.drawing.font.drawString

    while y >= 0 and lineIdx > 0 do
        local line = self.lines [lineIdx]
        drawString (0, y + 2, line.author, 0x000000ff, true)
        drawString (0, y, line.author, 0xffff00ff, true)
        drawString (self.textOffset, y + 2, line.text, 0x000000ff, true)
        drawString (self.textOffset, y, line.text, 0xffffffff)

        y = y - self.heightPerLine
        lineIdx = lineIdx - 1
    end
end

--------------------------------------------------
local function renderTextEntry (self)

    local heightPerLine = self.heightPerLine
    local x = 0
    local y = self.chatLinesToDraw * heightPerLine

    if self.text ~= "" then
        local textLength = dio.drawing.font.measureString (self.text .. "_")

         if textLength > self.size.w then
             x = self.size.w - textLength
         end
     end

    local drawString = dio.drawing.font.drawString
    drawString (0, y, string.rep ("-", 40), 0xffffffff)
    drawString (x, y + heightPerLine, self.text, 0xffffffff, true, true)
    local width = dio.drawing.font.measureString (self.text)
    drawString (x + width, y + heightPerLine, "_", 0xff0000ff)

end

--------------------------------------------------
local function resetTextEntry (self)
    self.text = ""
    self.isDirty = true
end

--------------------------------------------------
local function hide (self)
    self.isVisible = false
    dio.inputs.mouse.setExclusive (true)
    dio.inputs.setExclusiveKeys (false)
    dio.inputs.setArePlayingControlsEnabled (true)
end

--------------------------------------------------
local function addNewTickerLine (self, author, text)

    local ticker = self.ticker

    if #ticker.lines == ticker.linesToDraw then
        for idx = 2, #ticker.lines do
            ticker.lines [idx - 1] = ticker.lines [idx]
        end
        table.remove (ticker.lines)
    end

    local newTickerLine = TickerLine (author, text, self.size.w, self.heightPerLine, self.textOffset)
    table.insert (ticker.lines, newTickerLine)
end

-- TODO
-- --------------------------------------------------
-- local function onUpdate (self)
-- end

--------------------------------------------------
local function onEarlyRender (self)

    self.isDirty = true

    if self.isDirty then

        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)
        renderChat (self)
        renderTextEntry (self)

        dio.drawing.setRenderToTexture (nil)
        self.isDirty = false

    end

    local lines = self.ticker.lines
    local idx = 1

    while idx <= #lines do

        local tickerLine = lines [idx]
        local isOk = tickerLine:update ()

        if not isOk then
            table.remove (lines, 1)

        else
            if tickerLine.isDirty then
                tickerLine:earlyRender ()
            end
            idx = idx + 1
        end
    end
end

--------------------------------------------------
local function onLateRender (self)

    if self.isVisible then
        dio.drawing.drawTexture (self.renderToTexture, self.position.x, self.position.y, self.size.w * self.scale, self.size.h * self.scale, 0xffffffff)

    else
        local lines = self.ticker.lines
        local y = self.position.y + ((self.textEntryLinesToDraw + #lines) * self.heightPerLine * self.scale)

        for _, tickerLine in ipairs (lines) do
            y = y - self.heightPerLine * self.scale
            tickerLine:lateRender (self.position.x, y)
        end
    end
end

--------------------------------------------------
local function onChatMessageReceived (author, text)

    local self = instance

    local spaceLeft = self.size.w - self.textOffset
    local spaceWidth = dio.drawing.font.measureString (" ") -- this should probably be in instance properties
    local currentLine = ""
    local linesAdded = {}

    local author2 = author

    for word in string.gmatch (text, "%S+") do
        local wordLength = dio.drawing.font.measureString (word)

        if wordLength + spaceWidth > spaceLeft then
            table.insert (self.lines, { author = author2, text = currentLine })
            table.insert (linesAdded, currentLine)
            currentLine = word .. " "
            spaceLeft = self.size.w - self.textOffset - wordLength
            author2 = ""
        else
            spaceLeft = spaceLeft - (wordLength + spaceWidth)
            currentLine = currentLine .. word .. " "
        end
    end

    if currentLine ~= "" then
        table.insert (self.lines, { author = author2, text = currentLine })
        table.insert (linesAdded, currentLine)
    end

    if self.autoScroll then
        self.firstLineToDraw = #self.lines - self.chatLinesToDraw + 1
        if self.firstLineToDraw < 1 then
            self.firstLineToDraw = 1
        end
    end

    if #linesAdded == 0 then
        addNewTickerLine (self, author, text)
    else
        author2 = author
        for idx = 1, #linesAdded do 
            addNewTickerLine (self, author2, linesAdded [idx])
            author2 = ""
        end
    end
    
    self.isDirty = true

end

--------------------------------------------------
local function addToChatHistory (text)
    local tmpArray = {}
    for idx = 1, #chatHistory do
        tmpArray [idx] = chatHistory [idx]
    end

    for idx = 1, #tmpArray do
        chatHistory [idx + 1] = tmpArray [idx]
    end

    if #chatHistory > 10 then
        for idx = 11, #chatHistory do
            chatHistory [idx] = nil
        end
    end

    chatHistory [1] = text
end

--------------------------------------------------
local function onKeyClicked (keyCode, keyCharacter, keyModifiers)

    local self = instance

    if self.isVisible then

        local keyCodes = dio.inputs.keyCodes

        if keyCharacter then

             self.text = self.text .. string.char (keyCharacter)
             self.isDirty = true

        elseif keyCode == keyCodes.ENTER then

            currentElement = 0
            addToChatHistory (self.text)

            local isOk, errorStr = dio.clientChat.send (self.text)
            if not isOk then
                onChatMessageReceived ("Self", "Last message did not send! (" .. errorStr .. ")")
            end

            resetTextEntry (self)
            hide (self)

        elseif keyCode == keyCodes.ESCAPE then

            currentElement = 0
            hide (self)

        elseif keyCode == keyCodes.BACKSPACE then

            local stringLen = self.text:len ()
            if stringLen > 0 then
                self.text = self.text:sub (1, -2)
                self.isDirty = true

            else
                currentElement = 0

            end

        elseif keyCode == keyCodes.UP then

            currentElement = currentElement + 1

            if currentElement > 10 or currentElement > #chatHistory then
                currentElement = 1
            end

            self.text = chatHistory [currentElement] or ""
            self.isDirty = true

        elseif keyCode == keyCodes.DOWN then

            currentElement = currentElement - 1

            if currentElement < 1 then
                currentElement = #chatHistory
            end

            self.text = chatHistory [currentElement] or ""
            self.isDirty = true

        end

        return true

    elseif keyCode == self.chatAppearKeyCode then

        self.isVisible = true
        dio.inputs.mouse.setExclusive (false)
        dio.inputs.setExclusiveKeys (true)
        dio.inputs.setArePlayingControlsEnabled (false)
        resetTextEntry (self)

        return true

    end

    return false
end

--------------------------------------------------
local function onOtherClientConnected (playerId)
    onChatMessageReceived ("SERVER", playerId .. " connected.")
end

--------------------------------------------------
local function onOtherClientDisconnected (playerId)
    onChatMessageReceived ("SERVER", playerId .. " disconnected.")
end

--------------------------------------------------
local function onLoadSuccessful ()

    local chatLinesToDraw = 18
    local textEntryLinesToDraw = 2
    local heightPerLine = 14
    local height = (chatLinesToDraw + textEntryLinesToDraw) * heightPerLine

    instance =
    {
        firstLineToDraw = 1,
        autoScroll = true,
        chatLinesToDraw = chatLinesToDraw,
        textEntryLinesToDraw = textEntryLinesToDraw,
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

        ticker =
        {
            linesToDraw = chatLinesToDraw,
            lines = {}
        },
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.size.w, instance.size.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.types
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatMessageReceived)
    dio.events.addListener (types.CLIENT_KEY_CLICKED, onKeyClicked)
    dio.events.addListener (types.CLIENT_OTHER_CLIENT_CONNECTED, onOtherClientConnected)
    dio.events.addListener (types.CLIENT_OTHER_CLIENT_DISCONNECTED, onOtherClientDisconnected)
    -- dio.events.addListener (types.CLIENT_KEY_BINDINGS_MENU_OPENED, onThing)

end

-- --------------------------------------------------
-- local function onThing (menu)
-- {
--     menu.addBindingOption ("CHAT", function (keyCode) instance.chatAppearKeyCode = keyCode end)
-- }

--------------------------------------------------
local modSettings =
{
    name = "Chat",

    description = "Can draw a chat window and allow players to type in it",

    permissionsRequired =
    {
        client = true,
        player = true,
        input = true,
    },

    -- keyBindingsAvailable = 
    -- {
    --     {name = "Chat", default = dio.inputs.keyCodes.T}
    -- }
}

--------------------------------------------------
return modSettings, onLoadSuccessful
