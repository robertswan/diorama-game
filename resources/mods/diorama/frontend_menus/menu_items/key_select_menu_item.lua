--------------------------------------------------
local MenuItemBase = require ("resources/mods/diorama/frontend_menus/menu_items/menu_item_base")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)

    if not self.isSelected then
        
        self.isHighlighted = 
                x >= 0 and
                x <= menu.width and
                y >= self.y and 
                y < self.y + self.height

        if was_left_clicked and self.isHighlighted then

            if not self.isSelected then
                menu:setUpdateOnlySelectedMenuItems (true)
                self.isSelected = true
            end
        end
    end
end

--------------------------------------------------
function c:onRender (font, menu)

    local itemWidth = menu.width - 200
    local x = 100

    local color = self.isHighlighted and 0xffffffff or 0x00ffffff
    color = self.isSelected and 0xff0000ff or color

    if self.isHighlighted or self.isSelected then
        dio.drawing.font.drawBox (0, self.y, menu.width, self.height, 0x000000ff)
    end

    font.drawString (x, self.y, self.text, color)

    if self.isHighlighted then
        local width = font.measureString (">>>>    ")
        font.drawString (x - width, self.y, ">>>>    ", color)
        font.drawString (x + itemWidth, self.y, "    <<<<", color)
    end

    local value = "????"
    if not self.isSelected then
         value = dio.inputs.keys.stringFromKeyCode (self.keyCode)
    end

    local width = font.measureString (value)    
    font.drawString (itemWidth + x - width, self.y, value, color)
end

--------------------------------------------------
function c:onKeyClicked (menu, keyCode, keyCharacter, keyModifiers)

    assert (self.isSelected)

    menu:setUpdateOnlySelectedMenuItems (false)
    self.isSelected = false

    if keyCode ~= dio.inputs.keyCodes.ESCAPE then

        self.keyCode = keyCode

        if self.onKeyUpdated then
            self.onKeyUpdated (self, menu)
        end
    end

    return true
end

--------------------------------------------------
return function (text, onKeyUpdated, keyCode)

    local instance = MenuItemBase ()

    local properties =
    {
        text = text,
        keyCode = keyCode,
        isSelected = false,
        onKeyUpdated = onKeyUpdated
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyTo (instance, c)

    return instance
end
