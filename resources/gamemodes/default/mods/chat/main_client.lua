local Chat = require ("resources/_scripts/utils/chat")
local EmoteDefinitions = require ("resources/gamemodes/default/mods/chat/emote_definitions")
local TickerLine = require ("resources/gamemodes/default/mods/chat/ticker_line")

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
local function renderChatLine (self, line, y)

    local drawString = dio.drawing.font.drawString

    -- Draw the author part (with shadow)
    drawString (0, y, line.author, 0x000000ff, true)
    drawString (0, y + 2, line.author, 0xffff00ff, true)
    Chat.renderLine (self.textOffset, y, line.textList, EmoteDefinitions, self.emoteTexture)
end

--------------------------------------------------
local function renderChat (self)

    local lineIdx = self.firstLineToDraw + self.chatLinesToDraw
    local y = self.heightPerLine * 2
    if lineIdx > #self.lines then
        lineIdx = #self.lines
    end

    while y >= 0 and lineIdx > 0 do
        local line = self.lines [lineIdx]
        renderChatLine (self, line, y)
        y = y + self.heightPerLine
        lineIdx = lineIdx - 1
    end
end

--------------------------------------------------
local function renderTextEntry (self)

    local heightPerLine = self.heightPerLine
    local x = 0
    local y = 0

    if self.text ~= "" then
        local textLength = dio.drawing.font.measureString (self.text .. "_")

         if textLength > self.size.w then
             x = self.size.w - textLength
         end
     end

    local drawString = dio.drawing.font.drawString
    drawString (0, y + heightPerLine, string.rep ("-", 40), 0xffffffff)
    drawString (x, y, self.text, 0xffffffff, true, true)

    local width = dio.drawing.font.measureString (self.text)
    drawString (x + width, y, "_", 0xff0000ff)

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
local function addNewTickerLine (self, line)

    local ticker = self.ticker

    if #ticker.lines == ticker.linesToDraw then
        for idx = 2, #ticker.lines do
            ticker.lines [idx - 1] = ticker.lines [idx]
        end
        table.remove (ticker.lines)
    end

    local newTickerLine = TickerLine (line, self.size.w, self.heightPerLine,
                                      self.textOffset, self.emoteTexture)

    table.insert (ticker.lines, newTickerLine)
end

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
local function onChatMessageReceived (event)

    local self = instance

    local spaceLeft = self.size.w - self.textOffset
    
    local linesAdded = {}
    local lines = Chat.linesFromSentence (event.text, spaceLeft, EmoteDefinitions)

    for _, lineText in ipairs (lines) do
        local line = {author = event.author, textList = lineText}
        table.insert (self.lines, line)
        table.insert (linesAdded, line)
    end

    while #self.lines > self.chatLinesToDraw do
        table.remove (self.lines, 1)
    end    

    if self.autoScroll then
        self.firstLineToDraw = #self.lines - self.chatLinesToDraw + 1
        if self.firstLineToDraw < 1 then
            self.firstLineToDraw = 1
        end
    end

    -- create the ticker lines
    for _, line in ipairs (linesAdded) do
        addNewTickerLine (self, line)
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
    local keyCodes = dio.inputs.keyCodes

    if self.isVisible then

        if keyCharacter then

             self.text = self.text .. string.char (keyCharacter)
             self.isDirty = true

        elseif keyCode == keyCodes.ENTER then

            local trimmedText = self.text:gsub ("^%s*", "")

            if (trimmedText ~= "") then
                currentElement = 0
                addToChatHistory (trimmedText)

                local isOk, errorStr = dio.clientChat.send (trimmedText)
                if not isOk then
                    onChatMessageReceived ({author = "Self", text = "Last message did not send! (" .. errorStr .. ")"})
                end
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

    elseif keyCode == keyCodes.KP_SUBTRACT then
        
        dio.drawing.disableDrawing ()

    elseif keyCode == keyCodes.KP_ADD then

        dio.drawing.enableDrawing ()

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
local function onClientConnected (event)
    onChatMessageReceived ({author = "SERVER", text = event.accountId .. " connected."})
end

--------------------------------------------------
local function onClientDisconnected (event)
    onChatMessageReceived ({author = "SERVER", text = event.accountId .. " disconnected."})
end

--------------------------------------------------
local function onLoad ()

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
        emoteTexture = dio.resources.loadTexture ("EMOTES", "textures/emotes_00.png"),

        ticker =
        {
            linesToDraw = chatLinesToDraw,
            lines = {}
        },
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.size.w, instance.size.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.CHAT_RECEIVED, onChatMessageReceived)
    dio.events.addListener (types.KEY_CLICKED, onKeyClicked)
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)

end

--------------------------------------------------
local modSettings =
{
    name = "Chat",

    description = "Can draw a chat window and allow players to type in it",

    permissionsRequired =
    {
        drawing = true,
        inputs = true,
        resources = true,
        world = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
        onUnload = function () dio.resources.destroyTexture ("EMOTES") end,
    },    
}

--------------------------------------------------
return modSettings
