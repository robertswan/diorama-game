--------------------------------------------------
local MenuItemBase = require ("resources/gamemodes/default/mods/frontend_menus/menu_items/menu_item_base")
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (menu, x, y, was_left_clicked)

    if self.sliderPinSet == false then
        self.sliderPinX = (self.sliderEndX - self.sliderStartX) * ((self.value - self.sliderMinVal) / (self.sliderMaxVal - self.sliderMinVal))
        self.sliderPinSet = true
    end

    if self.isSelected then
        self.sliderPinX = x - self.sliderStartX;

        if self.sliderPinX > (self.sliderEndX - self.sliderStartX) then
            self.sliderPinX = (self.sliderEndX - self.sliderStartX)
        elseif self.sliderPinX < 0 then
            self.sliderPinX = 0
        end

        self.value = math.floor((self.sliderMaxVal - self.sliderMinVal) * (self.sliderPinX / (self.sliderEndX - self.sliderStartX)) + self.sliderMinVal)

        if was_left_clicked then

            self.initial_value = nil
            self.isSelected = false
            self.isHighlighted = false

            menu:setUpdateOnlySelectedMenuItems (false)
            if self.onTextChangeConfirmed then
                self:onTextChangeConfirmed (menu)
            end
        end

    else
        self.isHighlighted =
                    x >= 0 and
                    x <= menu.width and
                    y >= self.y and
                    y < self.y + self.height

            if was_left_clicked and self.isHighlighted then

                if not self.isSelected then
                    -- somehow stop the menu from doing other things!
                    --menu:lockHighlightToMenuItem (self)
                    self.flashCount = 0
                    self.initial_value = self.value
                    self.isSelected = true
                    menu:setUpdateOnlySelectedMenuItems (true)
                end
            end
    end
end

--------------------------------------------------
function c:onRender (font, menu)
    local x = 100

    local color = self.isHighlighted and 0xffffffff or 0x00ffffff
    color = self.isSelected and 0xffffffff or color

    if self.isHighlighted or self.isSelected then
        dio.drawing.font.drawBox (0, self.y, menu.width, self.height, 0x00CCCCCC)
    end

    font.drawString (x, self.y, self.text, color)

    local value = self.value

    local numberWidth = font.measureString (value)
    dio.drawing.font.drawBox (self.sliderStartX, self.y, self.sliderEndX - self.sliderStartX + self.sliderPinWidth, 10, 0x00FFFFFF)
    dio.drawing.font.drawBox (self.sliderStartX + self.sliderPinX, self.y, self.sliderPinWidth, 10, 0x0066CCFF)
    font.drawString (self.sliderStartX + ((self.sliderEndX - self.sliderStartX - numberWidth)/2), self.y, value, 0x000000FF)
end

--------------------------------------------------
function c:onKeyClicked (menu, keyCode)

    local keyCodes = dio.inputs.keyCodes

    if keyCode == keyCodes.ENTER or keyCode == keyCodes.KP_ENTER then

        self.initial_value = nil
        self.isSelected = false
        self.isHighlighted = false

        menu:setUpdateOnlySelectedMenuItems (false)
        if self.onTextChangeConfirmed then
            self:onTextChangeConfirmed (menu)
        end

        return true
    end
end

--------------------------------------------------
function c:getValueAsNumber ()
    return tonumber (self.value)
end

--------------------------------------------------
return function (text, onTextChanged, onTextChangeConfirmed, initialValue, isInteger)
    local instance = MenuItemBase ()

    local properties =
    {
        text = text,
        value = tostring (initialValue),
        isInteger = isInteger,
        flashCount = 0,
        isSelected = false,
        onTextChanged = onTextChanged,
        onTextChangeConfirmed = onTextChangeConfirmed,
        sliderPinWidth = 5,
        sliderStartX = 250,
        sliderEndX = 420,
        sliderMinVal = 30,
        sliderMaxVal = 150,
        sliderPinX = 0,
        sliderPinSet = false
    }

    Mixin.CopyTo (instance, properties)
    Mixin.CopyTo (instance, c)

    return instance
end
