--------------------------------------------------
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")
local Window = require ("resources/_scripts/utils/window")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:changeMenu (newMenuName)

    if newMenuName then

        -- if self.current_menu then
        --     print ("changing to menu " .. newMenuName .. " from " .. self.current_menu_name)
        -- else
        --     print ("changing to menu " .. newMenuName)
        -- end

        if self.current_menu then
            self.current_menu:onExit (self.menus)
        end
        self.current_menu = self.menus [newMenuName]
        self.current_menu_name = newMenuName

        if self.current_menu then
            self.current_menu:onEnter (self.menus)
        end
    end
end

--------------------------------------------------
function c:update ()

    local windowW, windowH = dio.drawing.getWindowSize ()
    self.scale = Window.calcBestFitScale (self.w, self.h)
    self.x = (windowW - self.w * self.scale) / 2
    self.y = (windowH - self.h * self.scale) / 2

    local mouse = dio.inputs.getMouse ()    

    local x = (mouse.x - self.x) / self.scale
    local y = (mouse.y - self.y) / self.scale
    local leftClicked = mouse.leftClicked

    local nextMenuName = self.current_menu:onUpdate (x, y, leftClicked);
    self:changeMenu (nextMenuName)
end

--------------------------------------------------
function c:renderEarly ()
    if self.isVisible and self.current_menu then
        dio.drawing.setRenderToTexture (self.renderToTexture)
        self.current_menu:onRender ()
        dio.drawing.setRenderToTexture (nil)
    end
end

--------------------------------------------------
function c:renderLate ()
    if self.isVisible and self.current_menu then

        if self.current_menu.onRenderLate then
            self.current_menu:onRenderLate ()
        end

        dio.drawing.drawTexture (self.renderToTexture, self.x, self.y, self.w * self.scale, self.h * self.scale, 0xffffffff)
    end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyModifiers, keyCharacter)
    if self.current_menu then
        return self.current_menu:onKeyClicked (keyCode, keyModifiers, keyCharacter, self)
    end
end

--------------------------------------------------
function c:onWindowFocusLost ()
    if self.current_menu and self.current_menu.onWindowFocusLost then
        local nextMenuName = self.current_menu:onWindowFocusLost ()
        self:changeMenu (nextMenuName)
    end
end

--------------------------------------------------
function c:onSessionShutdownBegun (reason)
    if self.current_menu and self.current_menu.onSessionShutdownBegun then
        local nextMenuName = self.current_menu:onSessionShutdownBegun (reason)
        self:changeMenu (nextMenuName)
    end
end

--------------------------------------------------
function c:onSessionShutdownCompleted ()
    if self.current_menu and self.current_menu.onSessionShutdownCompleted then
        local nextMenuName = self.current_menu:onSessionShutdownCompleted ()
        self:changeMenu (nextMenuName)
    end
end

--------------------------------------------------
function c:onApplicationShutdown ()
    if self.current_menu and self.current_menu.onAppShouldClose then
        local nextMenuName, shouldCancel = self.current_menu:onAppShouldClose ()
        self:changeMenu (nextMenuName)
        return shouldCancel
    end
    return false
end

--------------------------------------------------
function c:setIsVisible (isVisible)
    self.isVisible = isVisible
end

--------------------------------------------------
return function (all_menus, initial_menu_name)

    local instance =
    {
        menus = all_menus,
        current_menu = nil,
        w = 512,
        h = 256,
        scale = 1,
        isVisible = true,
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)

    local types = dio.types.clientEvents
    dio.events.addListener (types.KEY_CLICKED, function (keyCode, keyModifier, keyCharacter) return instance:onKeyClicked (keyCode, keyModifier, keyCharacter) end)

    Mixin.CopyTo (instance, c)

    instance:changeMenu (initial_menu_name)

    return instance
end
