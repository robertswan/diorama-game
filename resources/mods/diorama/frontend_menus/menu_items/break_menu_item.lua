--------------------------------------------------
local MenuItemBase = require ("resources/mods/diorama/frontend_menus/menu_items/menu_item_base")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
return function ()
    local instance = 
    {
        text = "------------------------",

        onRender = function (self, font, menu)
            local width = font.measureString (self.text)
            font.drawString ((menu.width - width) * 0.5, self.y, self.text, 0x00b0b0ff)
        end
    }

    Mixin.CopyTo (instance, MenuItemBase ())

    return instance
end
