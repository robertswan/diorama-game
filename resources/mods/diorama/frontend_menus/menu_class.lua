--------------------------------------------------
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:addMenuItem (menuItem)
    menuItem.x = 0
    menuItem.y = self.next_y
    self.next_y = self.next_y + menuItem.height + menuItem.gapY
    table.insert (self.items, menuItem)

    return menuItem
end

--------------------------------------------------
function c:clearAllMenuItems ()
    self.items = {}
    self.next_y = 40
end

--------------------------------------------------
function c:setUpdateOnlySelectedMenuItems (isSet)
    self.isUpdatingOnlySelectedMenuItems = isSet
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
    -- go through every item
    -- check if the mouse is over it
    -- if so, switch the text for a HIGHLIGHTED

    local next_menu = nil

    for i, item in ipairs (self.items) do

        if item.onUpdate then

            if not self.isUpdatingOnlySelectedMenuItems or item.isSelected then

                local next_menu_2 = item:onUpdate (self, x, y, was_left_clicked)
                if next_menu_2 then
                    next_menu = next_menu_2
                end

            end
        end
    end

    return next_menu
end

--------------------------------------------------
function c:onRender ()
    local font = dio.drawing.font;

    dio.drawing.font.drawBox (0, 0, self.width, self.height, 0x000000b0);

    if self.title then
        local width = font.measureString (self.title)
        font.drawString ((self.width - width) * 0.5, 0, self.title, 0xffffffff)
    end

    local highlighted_item = nil
    for idx, menuItem in ipairs (self.items) do

        if menuItem.onRender then
            menuItem:onRender (font, self)
        end

        -- font.drawString (item.x, item.y, item.text, 0xffff0000)
    end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers)
    for i, item in ipairs (self.items) do

        if item.onKeyClicked and item.isSelected then

            local wasConsumed = item:onKeyClicked (self, keyCode, keyCharacter, keyModifiers)
            if wasConsumed then
                return true
            end
        end
    end
end

--------------------------------------------------
function c:onWindowFocusLost ()
    local next_menu = nil

    for i, item in ipairs (self.items) do
        if item.onWindowFocusLost then
            item:onWindowFocusLost (self, character)
        end
    end
end

--------------------------------------------------
function c:onAppShouldClose ()
end

--------------------------------------------------
function c:onEnter ()
end

--------------------------------------------------
function c:onExit ()
end

--------------------------------------------------
return function (title)

    local instance =
    {
        title = title,
        items = {},
        next_y = 30,
        events = {},
        width = 512,
        height = 256,
    }

    Mixin.CopyTo (instance, c)

    return instance
end
