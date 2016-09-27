--------------------------------------------------
local instance = nil

--------------------------------------------------
local icons = 
{
    smallAxe =          {idx = 1, uvs = {0, 0}},
    smallJumpBoots =    {idx = 2, uvs = {1, 0}},
    iceShield =         {idx = 3, uvs = {2, 0}},
    belt =              {idx = 4, uvs = {3, 0}},
    fireShield =        {idx = 5, uvs = {0, 1}},
    teleporter =        {idx = 6, uvs = {1, 1}},
    largeJumpBoots =    {idx = 7, uvs = {2, 1}},
    bean =              {idx = 8, uvs = {3, 1}},
    bigAxe =            {idx = 9, uvs = {0, 2}},

    artifact1 =         {idx = 1, uvs = {2, 2}, isArtifact = true},
    artifact2 =         {idx = 2, uvs = {3, 2}, isArtifact = true},
    artifact3 =         {idx = 3, uvs = {0, 3}, isArtifact = true},
    artifact4 =         {idx = 4, uvs = {1, 3}, isArtifact = true},
    artifact5 =         {idx = 5, uvs = {2, 3}, isArtifact = true},
    artifact6 =         {idx = 6, uvs = {3, 3}, isArtifact = true},
}


--------------------------------------------------
local function onEarlyRender (self)

    if instance.isDirty then

        --------------------------------------------------
        local panel = instance.panel1
        dio.drawing.setRenderToTexture (panel.renderToTexture)
        dio.drawing.font.drawBox (0, 0, panel.size.w, panel.size.h, 0x333333A0);

        local drawString = dio.drawing.font.drawString
        drawString (3, 1, panel.text, 0xffAA66ff)

        local x = -16
        local y = 14
        for idx, item in ipairs (instance.items) do

            dio.drawing.drawTextureRegion (
                    instance.itemsTexture,
                    x + idx * 18, y,
                    item [1] * 16, item [2] * 16, 
                    16, 16)
        end

        --------------------------------------------------
        panel = instance.panel2
        dio.drawing.setRenderToTexture (panel.renderToTexture)
        dio.drawing.font.drawBox (0, 0, panel.size.w, panel.size.h, 0x333333A0);

        local x = -16 + 7 * 18
        local y = 2
        for idx, artifact in ipairs (instance.artifacts) do
        -- for idx = 1, 6 do
        --     local artifact = icons ["artifact" .. tostring (idx)].uvs

            dio.drawing.drawTextureRegion (
                    instance.itemsTexture,
                    x - idx * 18, y,
                    artifact [1] * 16, artifact [2] * 16, 
                    16, 16)
        end


        dio.drawing.setRenderToTexture (nil)

        instance.isDirty = false
    end
end

--------------------------------------------------
local function onLateRender (self)

    local windowW, windowH = dio.drawing.getWindowSize ()

    local panel = instance.panel1
    dio.drawing.drawTexture (panel.renderToTexture, panel.position.x, panel.position.y, panel.texture.w * instance.scale, panel.texture.h * instance.scale, 0xffffffff)

    panel = instance.panel2
    panel.position.x = windowW - (panel.size.w * instance.scale + instance.gutter)
    dio.drawing.drawTexture (panel.renderToTexture, panel.position.x, panel.position.y, panel.texture.w * instance.scale, panel.texture.h * instance.scale, 0xffffffff)

end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "tinyGalaxy.WORLD" then

        instance.panel1.text = event.payload
        instance.isDirty = true
        event.cancel = true

    elseif event.id == "tinyGalaxy.OSD" then

        if event.payload == "RESET" then
            instance.items = {}
            instance.artifacts = {}
            crashA ()
        else
            local icon = icons [event.payload]
            if icon.isArtifact then
                instance.artifacts [icon.idx] = icon.uvs
            else
                instance.items [icon.idx] = icon.uvs
            end
        end
        
        instance.isDirty = true
        event.cancel = true            
    end    
end

--------------------------------------------------
local function onLoad ()

    local gutter = 20
    instance =
    {
        panel1 =
        {
            position = {x = gutter, y = gutter},
            size = {w = 165, h = 32},
            texture = {w = 165, h = 32},
            text = "",
        },
        panel2 =
        {
            position = {x = gutter, y = gutter},
            size = {w = 111, h = 20},
            texture = {w = 111, h = 20},
        },

        gutter = gutter,
		scale = 4,
        isDirty = true,
        items = {},
        artifacts = {},
        itemsTexture = dio.resources.loadTexture ("ITEMS_ICONS", "textures/osd.png", {isNearest = false}),
    }

    instance.panel1.renderToTexture = dio.drawing.createRenderToTexture (instance.panel1.texture.w, instance.panel1.texture.h)
    instance.panel2.renderToTexture = dio.drawing.createRenderToTexture (instance.panel2.texture.w, instance.panel2.texture.h)

    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
	dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)

end

--------------------------------------------------
local function onUnload ()
    dio.resources.destroyTexture ("ITEMS_ICONS")
end

--------------------------------------------------
local modSettings =
{
    name = "Tiny Galaxy OSD",

    description = "",

    permissionsRequired =
    {
        drawing = true,
        resources = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
        onUnload = onUnload,
    },    
}

--------------------------------------------------
return modSettings
