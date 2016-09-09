local Chat = require ("resources/_scripts/utils/chat")
local EmoteDefinitions = require ("resources/gamemodes/default/mods/chat/emote_definitions")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local messages = 
{
    BEGIN_GAME = "<3 You live on a tiny, tiny world... in a tiny, tiny galaxy. If only you could collect all the hidden artifacts then maybe the 'collect all the artifacts and be happy for ever' legend could come true. All your tiny, tiny world has is a computer and thrusters. Use your computer and scour the galaxy...! You have but one life.",

    smallAxe =          "You have found an AXE. You can chop thin tree trunks with the left mouse button!",
    smallJumpBoots =    "You have found JUMPS BOOTS. You can jump just a little bit higher!",
    iceShield =         "You have found an ICE SHIELD. You can get close to ice worlds!",
    belt =              "You have found a BELT OF STRENGTH. You can now crush broken rocks with the left mouse button!",
    fireShield =        "You have found a HEAT SHIELD. You can get closer to the sun and pass the asteroid belt!",
    teleporter =        "You have found a TELEPORTER. Look at a red target and the left mouse button to teleport!",
    largeJumpBoots =    "You have found SUPER JUMP BOOTS. You can jump even higher still!",
    bean =              "You have found SOME MAGIC BEANS. Plant on BEAN squares with the left mouse button to grow a jump pad plant!",
    bigAxe =            "You have found the BIG AXE. Chop down bigger tree trunks! You have all the items. Now collect all the artifacts!",

    ARTIFACT_1 = "You have found artifact 1 of 6! Remember - collect them all and be happy for! YMMV.",
    ARTIFACT_2 = "You have found artifact 1 of 6! Remember - collect them all and be happy for! YMMV.",
    ARTIFACT_3 = "You have found artifact 1 of 6! Remember - collect them all and be happy for! YMMV.",
    ARTIFACT_4 = "You have found artifact 1 of 6! Remember - collect them all and be happy for! YMMV.",
    ARTIFACT_5 = "You have found artifact 1 of 6! Remember - collect them all and be happy for! YMMV.",
    ARTIFACT_6 = "You have found artifact 1 of 6! Remember - collect them all and be happy for! YMMV.",
    
    SUCCESS = "You have found all the artifacts. But are you any happier, really? You shouldn't believe in legends at your age. Still, YOU BEAT THE TINY GAME!",

    DIED = "You died. And you were warned this game only gives you one life per attempt. Don't like it? Add the code yourself.",

    WARN_HEAT = "You are too close to the SUN. You can not pass the asteroid belt until you have found a HEAT SHIELD.",
    WARN_COLD = "You are too close to an ICE WORLD. You can not get any closer until you have found an ICE SHIELD.",
}

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.size.w, self.size.h, 0x333333A0);
end

--------------------------------------------------
local function onEarlyRender (self)
    
    if instance.isDirty then

        local width = 100

        local lines = Chat.linesFromSentence (messages [instance.eventId], instance.size.w, EmoteDefinitions)


        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)

        local lineHeight = 14
        local y = (instance.size.h * 0.5) + (#lines * lineHeight * 0.5);

        for _, line in ipairs (lines) do
            y = y - lineHeight
            Chat.renderLine ((instance.size.w - line.width) * 0.5, y, line, EmoteDefinitions, instance.emoteTexture)
        end

        dio.drawing.setRenderToTexture (nil)

        instance.isDirty = false

    end

end

--------------------------------------------------
local function onLateRender (self)
    if instance.isVisible then

        local windowW, windowH = dio.drawing.getWindowSize ()
        local x = (windowW - self.size.w * self.scale) * 0.5
        local y = (windowH - self.size.h * self.scale) * 0.5

        dio.drawing.drawTexture (self.renderToTexture, x, y, self.texture.w * self.scale, self.texture.h * self.scale, 0xffffffff)
    end
end



--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "tinyGalaxy.DIALOGS" then

        instance.eventId = event.payload
        instance.isVisible = true
        instance.isDirty = true
        event.cancel = true
    end
end

--------------------------------------------------
local function onLoad ()

    instance =
    {
        size = {w = 256, h = 128},
        texture = {w = 256, h = 128},
        border = 4,
        scale = 3,
        isVisible = false,
        isDirty = false,
        eventId = "TEST",
        emoteTexture = dio.resources.loadTexture ("DIALOG_EMOTES", "textures/emotes_00.png"),
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.texture.w, instance.texture.h)

    dio.drawing.addRenderPassBefore (1.0, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1.0, function () onLateRender (instance) end)

    local types = dio.events.clientTypes
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)

end


--------------------------------------------------
local modSettings =
{
    name = "Tiny Galaxy Dialogs",

    description = "",

    permissionsRequired =
    {
        drawing = true,
        resources = true,
    },

    callbacks = 
    {
        onLoad = onLoad,
    },    
}

--------------------------------------------------
return modSettings
