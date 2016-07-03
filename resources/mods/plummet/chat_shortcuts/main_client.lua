local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = nil

local colors = 
{
    ok = "%8f8",
    bad = "%f88",
}

local texts =
{
    noJoin = colors.bad .. "'.join' failed.",
    okJoin = colors.ok .. "You have joined the next game. Type '.ready' to begin.",
    noReady = colors.bad .. "'.ready' failed.",
    okReady = colors.ok .. "You are now ready. Waiting for all players to be ready too.",
}

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x00000c0);
end

--------------------------------------------------
local function renderMessage (self)

    local drawString = dio.drawing.font.drawString
    local text = " Press J for .JOIN or R for .READY"
    
    if isJoined then
        text = " Press R for .READY"
    end 
    
    drawString (0, 0, text, 0xffffffff)
    
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
        scale = (scale > 2) and 2 or scale
        local x = (windowW - self.w * scale) - 20
        local y = (windowH - self.h * scale) - 20
        dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * scale, self.h * scale, 0xffffffff)    
    end
end

--------------------------------------------------
local function onChatReceived (author, text)

    local self = instance
    
    if author == "RESULT" then
        isJoined = false;
        isReady = false;
        self.isVisible = true
        self.isDirty = true
    end
        
    if text == texts.noJoin and not isJoined then
        isJoined = false
        self.isDirty = true
        return true
        
    elseif text == texts.noReady and not isReady then
        isReady = false
        self.isDirty = true
        return true
        
    elseif text == texts.okJoin then
        isJoined = true
        self.isDirty = true
        return true
        
    elseif text == texts.okReady then
        isReady = true
        self.isVisible = false
        return true
        
    end
    
    return false
end

--------------------------------------------------
local function onKeyClicked (keyCode, keyCharacter, keyModifiers)

    local self = instance
    local keyCodes = dio.inputs.keyCodes

        if keyCode == keyCodes.J then
            dio.clientChat.send (".join")
            return true
        elseif keyCode == keyCodes.R then
            dio.clientChat.send (".ready")
            return true
        end      

    return false
end

--------------------------------------------------
local function onLoadSuccessful ()

    instance = 
    {
        w = 223, 
        h = 9,

        isJoined = false;
        isReady = false;
          
        isDirty = true,
        isVisible = true,
    }
    
    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)    
    
    local types = dio.events.types
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_RECEIVED, onChatReceived)
    dio.events.addListener (types.CLIENT_KEY_CLICKED, onKeyClicked)
end

--------------------------------------------------
local modSettings = 
{
    name = "Plummet shortcuts for commands",
    description = "Keyboard shortcuts for commands .ready and .join",
    author = "RadstaR",

    permissionsRequired = 
    {
        drawing = true,
        player = true,
        input = true,
    },
     
}

--------------------------------------------------
return modSettings, onLoadSuccessful