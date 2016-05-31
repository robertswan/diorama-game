local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x00000c0);
end

--------------------------------------------------
local function onEarlyRender (self)

    if self.isDirty then

        local drawString = dio.drawing.font.drawString
      
        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)
        drawString (0, 0, " Press J for .JOIN, R for .READY or G for BOTH", 0xffffffff)
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
   
    if author == "RESULT" then
        isJoined = false;
        isReady = false; 

        return true
    end
end

--------------------------------------------------
local function onKeyClicked (keyCode, keyCharacter, keyModifiers)

    local self = instance
    local keyCodes = dio.inputs.keyCodes

        if keyCode == keyCodes.J then
            isJoined = true
            dio.clientChat.send (".join")
            return true
        end
    
        if keyCode == keyCodes.R then
            isReady = true
            dio.clientChat.send (".ready")
            return true
        end
    
        if keyCode == keyCodes.G then
            isJoined = true
            isReady = true
            dio.clientChat.send (".join")
            dio.clientChat.send (".ready")
            return true
        end          

    return false
end

--------------------------------------------------
local function onClientUpdated ()

    local self = instance
    
    if isJoined and isReady then
        self.isVisible = false
    else
        self.isVisible = true
    end
    
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
    dio.events.addListener (types.CLIENT_UPDATED, onClientUpdated)
end

--------------------------------------------------
local modSettings = 
{
    name = "Plummet shortcuts for commands",
    description = "Keyboard shortcuts for commands .ready and .join",
    author = "RadstaR",

    permissionsRequired = 
    {
        client = true,
        player = true,
        input = true,
    },
     
}

--------------------------------------------------
return modSettings, onLoadSuccessful