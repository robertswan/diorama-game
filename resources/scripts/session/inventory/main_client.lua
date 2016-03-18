local Window = require ("resources/scripts/utils/window")

--------------------------------------------------
local blocks =
{
    "grass",            
    "mud",                
    "granite",            
    "obsidian",            
    "sand",                
    "snowy grass",        
    "brick",            
    "tnt",                
    "pumpkin",            

    "jump pad",            
    "cobble",            
    "trunk",            
    "wood",                
    "leaf",                
    "glass",            
    "lit pumpkin",        
    "melon",            
    "table",    

    "gold",                
    "slab",                
    "big slab",            
    "gravel",            
    "bedrock",            
    "panel",        
    "books",            
    "mossy",        
    "stone brick",        

    "sponge",            
    "herringbone",        
    "black",            
    "dark",        
    "light",        
    "white",            
    "dk cyan",        
    "brown",            
    "pink",            

    "blue",        
    "green",    
    "yellow",            
    "orange",            
    "red",            
    "violet",            
    "purple",            
    "dk blue",        
    "dk green",    

    "sign"    
}

local entities =
{
    sign = 
    {
        type = "SIGN", 
        text = "NOT_SET",
    }
}

-- local entities = 
-- {
--     {name = "sign", type = "SIGN", text = "NOT_SET"},
--     {name = "torch", type = "TORCH", radius = 6, rgb = 0xff00ff},
--     {name = "chest (locked)", type = "CHEST", locked = true},
--     {name = "chest (unlocked)", type = "CHEST", locked = false},
-- }

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function testIdBounds (self)
    if self.currentBlockId > self.highestBlockId then
        self.currentBlockId = self.highestBlockId
    end
    
    if self.currentBlockId < self.lowestBlockId then 
        self.currentBlockId = self.lowestBlockId
    end
end

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.w, self.h, 0x000000b0);
end

--------------------------------------------------
local function renderText (self)

    local font = dio.drawing.font

    local x = 5
    local y = 1
    for idx = 1, self.blocksPerPage do
        if blocks [idx + self.currentPage * self.blocksPerPage] ~= nil then
            local text = "[" .. tostring (idx) .. ":" .. blocks [idx + self.currentPage * self.blocksPerPage] .. "]"
            local colour = idx + self.currentPage * self.blocksPerPage == self.currentBlockId and 0xffffffff or 0x000000ff 
            font.drawString (x, y, text, colour)
            x = x + font.measureString (text);
        end
    end
end

--------------------------------------------------
local function setInventoryItem (id)
    local blockName = blocks [id]

    local entity = entities [blockName]
    if entity then
        dio.inputs.setPlayerEntityId (1, id, entity.text)
    else
        dio.inputs.setPlayerBlockId (1, id)
    end
    
end

--------------------------------------------------
local function onUpdate (self)

    local scrollWheel = dio.inputs.mouse.getScrollWheelDelta ()

    if scrollWheel ~= 0 then
        if scrollWheel > 0 then
            self.currentBlockId = self.currentBlockId - 1
        else
            self.currentBlockId = self.currentBlockId + 1
        end

        if self.currentBlockId > self.blocksPerPage + self.currentPage * self.blocksPerPage or self.currentBlockId > self.highestBlockId then
            self.currentPage = self.currentPage + 1
            
            if self.currentPage > self.pages then
                self.currentPage = 0
            end
            
            self.currentBlockId = 1 + self.currentPage * self.blocksPerPage
            
        elseif self.currentBlockId < 1 + self.currentPage * self.blocksPerPage then
            self.currentPage = self.currentPage - 1
            
            if self.currentPage < 0 then
                self.currentPage = self.pages
            end
            
            if self.blocksPerPage + self.currentPage * self.blocksPerPage > self.highestBlockId then
                self.currentBlockId = self.highestBlockId
            else 
                self.currentBlockId = self.blocksPerPage + self.currentPage * self.blocksPerPage
            end
            
        end

        setInventoryItem (self.currentBlockId)
        self.isDirty = true
    end

end

--------------------------------------------------
local function onEarlyRender (self)    
    -- Not the most ideal way to call onUpdate
    onUpdate (self)

    if self.isDirty then
        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)
        renderText (self)
        dio.drawing.setRenderToTexture (nil)
        self.isDirty = false
    end

end

--------------------------------------------------
local function onLateRender (self)
    
    local scale = Window.calcBestFitScale (self.w, self.h)
    local windowW = dio.drawing.getWindowSize ()
    local x = (windowW - (self.w * scale)) * 0.5
    local y = self.y
    dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * scale, self.h * scale, 0xffffffff)
end

--------------------------------------------------
local function onKeyClicked (keyCode, keyCharacter, keyModifiers)

    local keyCodes = dio.inputs.keyCodes

    local self = instance

    if keyCode >= keyCodes ["1"] and keyCode <= keyCodes ["9"] then
        if blocks [(keyCode - keyCodes ["1"] + 1) + self.currentPage * self.blocksPerPage] ~= nil then
            self.currentBlockId = (keyCode - keyCodes ["1"] + 1) + self.currentPage * self.blocksPerPage
            setInventoryItem (self.currentBlockId)
            self.isDirty = true
            return true
        end
        
    elseif keyCode >= keyCodes ["F1"] and keyCode <= keyCodes ["F12"] then
        if keyCode - keyCodes ["F1"] >= 0 and keyCode - keyCodes ["F1"]    <= self.pages then
            local oldPage = self.currentPage
            self.currentPage = (keyCode - keyCodes ["F1"])
            self.currentBlockId = self.currentBlockId + (self.currentPage - oldPage) * self.blocksPerPage
            testIdBounds (self)
            self.isDirty = true
        end
    
    elseif keyCode == keyCodes ["RIGHT"] then
        self.currentPage = self.currentPage + 1
        
        if self.currentPage > self.pages then
            self.currentPage = 0
            self.currentBlockId = self.currentBlockId - self.blocksPerPage * self.pages
            testIdBounds (self)
            
        else
            self.currentBlockId = self.currentBlockId + self.blocksPerPage    
            testIdBounds (self)
            
        end

        setInventoryItem (self.currentBlockId)
        self.isDirty = true
        return true
    
    elseif keyCode == keyCodes ["LEFT"] then
        self.currentPage = self.currentPage - 1
        
        if self.currentPage < 0 then
            self.currentPage = self.pages
            self.currentBlockId = self.currentBlockId + self.blocksPerPage * self.pages
            testIdBounds (self)
            
        else 
            self.currentBlockId = self.currentBlockId - self.blocksPerPage        
            testIdBounds (self)
            
        end
        
        setInventoryItem (self.currentBlockId)
        self.isDirty = true
        return true
    
    end
    
    setInventoryItem (self.currentBlockId)
    return false
end

--------------------------------------------------
local function onChatMessagePreSent (text)

    local command = ".setSign "
    local compare = text:sub (1, command:len())

    if compare == command then
        local message = text:sub (command:len() + 1)
        entities.sign.text = message
        return true    
    end

    return false
end

--------------------------------------------------
local function onLoadSuccessful ()

    local stringToMeasure = ""
    for i = 1, 9 do
        stringToMeasure = "[" .. tostring(i) .. ":" .. stringToMeasure .. blocks[i] .. "]"
    end
    local widthSize = 5 + dio.drawing.font.measureString(stringToMeasure) + 5

    instance = 
    {
        lowestBlockId = 1,
        highestBlockId = #blocks,
        currentBlockId = 7,
        currentPage = 0,
        blocksPerPage = 9,
        pages = 0, -- 0 indexed
        isDirty = true,    

        x = 20,
        y = 0,
        w = widthSize,
        h = 12,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    instance.pages = math.ceil (instance.highestBlockId / instance.blocksPerPage) - 1

    dio.drawing.addRenderPassBefore (1, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)

    local types = dio.events.types
    dio.events.addListener (types.CLIENT_KEY_CLICKED, onKeyClicked)
    dio.events.addListener (types.CLIENT_CHAT_MESSAGE_PRE_SENT, onChatMessagePreSent)

    setInventoryItem (instance.currentBlockId)

end

--------------------------------------------------
local modSettings = 
{
    name = "Inventory",
    
    description = "Allows players to change the blocks they are placing",

    permissionsRequired = 
    {
        client = true,
        player = true,
        input = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful
