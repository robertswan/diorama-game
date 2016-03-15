--------------------------------------------------
local MenuItemBase = require ("resources/scripts/menus/menu_items/menu_item_base")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)
    self.isHighlighted = 
            x >= 0 and
            x <= menu.width and
            y >= self.y and 
            y < self.y + self.height

    if was_left_clicked and self.isHighlighted then
        self.isChecked = not self.isChecked
        if self.onClicked then
            return self:onClicked (menu)
        end
    end
end

--------------------------------------------------
function c:onRender (font, menu)

    local itemWidth = menu.width - 200
    local x = 100

    local color = self.isHighlighted and 0xffffffff or 0x00ffffff

    if self.isHighlighted then
        dio.drawing.font.drawBox (0, self.y, menu.width, self.height, 0x000000ff)
    end

    font.drawString (x, self.y, self.text, color)

    if self.isHighlighted then
    
        local width = font.measureString (">>>>    ")
        font.drawString (x - width, self.y, ">>>>    ", color)
        font.drawString (x + itemWidth, self.y, "    <<<<", color)
    end

    local width = font.measureString ("[   ]")
    local rightAlignX = itemWidth + x - width

    font.drawString (rightAlignX, self.y, "[   ]", color)
    if self.isChecked then
        font.drawString (rightAlignX + 5, self.y, "X", color)
    end
end

--------------------------------------------------
return function (text, onClicked, isChecked)

    local instance = MenuItemBase ()

    local properties =
    {
        text = text,
        isChecked = isChecked,
        onClicked = onClicked
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyTo (instance, c)

    return instance
end
