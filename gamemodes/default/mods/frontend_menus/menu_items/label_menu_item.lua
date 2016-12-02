--------------------------------------------------
local MenuItemBase = require ("gamemodes/default/mods/frontend_menus/menu_items/menu_item_base")
local Mixin = require ("gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
return function (text)
    local instance =
    {
        text = text,

        onRender = function (self, font, menus)
            local width = font.measureString (self.text)
            font.drawString ((menus.width - width) * 0.5, self.y, self.text, self.color)
        end,

        color = 0xffffffff,
    }

    Mixin.CopyTo (instance, MenuItemBase ())

    return instance
end
