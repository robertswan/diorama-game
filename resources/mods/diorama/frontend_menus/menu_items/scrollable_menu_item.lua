--------------------------------------------------
local MenuItemBase = require ("resources/mods/diorama/frontend_menus/menu_items/menu_item_base")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onRender (font, menus)

    local y = self.y
    for idx = 0, self.linesVisibleCount do
         local lineIdx = idx + self.firstLine
         if lineIdx < #self.lines + 1 then
             font.drawString (self.x, y, self.lines [lineIdx], 0x808080ff)
             y = y + 10
         end
    end
end

--------------------------------------------------
function c:scroll (scrollBy)
    self.firstLine = self.firstLine + scrollBy
    self.firstLine = math.min (self.firstLine, #self.lines - self.linesVisibleCount)
    self.firstLine = math.max (self.firstLine, 1)
end

--------------------------------------------------
return function (lines, linesVisibleCount)

    local instance = MenuItemBase ()

    local properties =
    {
        lines = lines,
        firstLine = 1,
        linesVisibleCount = linesVisibleCount,
        height = 10 * (linesVisibleCount + 1)
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyTo (instance, c)

    return instance
end
