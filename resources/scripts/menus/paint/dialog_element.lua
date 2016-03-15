local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:update (x, y, was_left_clicked)
    self.mouseOver = false

    if x >= self.x and y >= self.y and x <= self.x + self.sizeX * 4 and y <= self.y + self.sizeY * 3 then
        self.mouseOver = true

        if was_left_clicked then
            if self.type == 1 then
                self.onClicked ()
            elseif self.type == 2 then
                self.isFocused = true
            end
        end
    end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
    if self.type == 2 and keyCharacter and self.isFocused then
        self.text = self.text .. string.char (keyCharacter)

    elseif keyCode == dio.inputs.keyCodes.BACKSPACE and self.type == 2 and self.isFocused then
        local stringLen = self.text:len ()
        if stringLen > 0 then
            self.text = self.text:sub (1, -2)
        end
    elseif keyCode == dio.inputs.keyCodes.ENTER and self.type == 2 and self.isFocused then
        self.isFocused = false
    end
end

--------------------------------------------------
function c:render ()
    if self.type == 1 then
        if self.mouseOver then
            dio.drawing.font.drawBox (self.x, self.y, self.sizeX * 4, self.sizeY * 3, 0xddddddff)
            dio.drawing.font.drawBox (self.x + 2, self.y + 2, self.sizeX * 4 - 4, self.sizeY * 3 - 4, 0x444444ff)
            dio.drawing.font.drawString (self.x + 5, self.y + 6, self.text, 0xeeeeeeff)
        else
            dio.drawing.font.drawBox (self.x, self.y, self.sizeX * 4, self.sizeY * 3, 0xeeeeeeff)
            dio.drawing.font.drawBox (self.x + 2, self.y + 2, self.sizeX * 4 - 4, self.sizeY * 3 - 4, 0x555555ff)
            dio.drawing.font.drawString (self.x + 5, self.y + 6, self.text, 0xffffffff)
        end

    elseif self.type == 2 then
        if self.mouseOver then
            dio.drawing.font.drawBox (self.x, self.y, self.sizeX * 4, self.sizeY * 3, 0xddddddff)
            dio.drawing.font.drawString (self.x + 5, self.y + 6, self.text, 0x000000ff)
        else
            dio.drawing.font.drawBox (self.x, self.y, self.sizeX * 4, self.sizeY * 3, 0xeeeeeeff)
            dio.drawing.font.drawString (self.x + 5, self.y + 6, self.text, 0x111111ff)
        end

        if self.isFocused then
            local textWidth = dio.drawing.font.measureString (self.text)
            dio.drawing.font.drawString (self.x + 5 + textWidth, self.y + 6, "_", 0xff0000ff)
        end
    else
        dio.drawing.font.drawString (self.x + 5, self.y + 6, "Error", 0xffffffff)
    end
end

--------------------------------------------------
-- type: 1 = button, 2 = textfield
return function (x, y, sizeX, sizeY, text, onClicked, type)
    local instance =
    {
        x = x,
        y = y,
        sizeX = sizeX,
        sizeY = sizeY,
        text = text,
        onClicked = onClicked,
        type = type,
        isFocused = false,
        mouseOver = false,
    }

    Mixin.CopyTo (instance, c)

    return instance
end
