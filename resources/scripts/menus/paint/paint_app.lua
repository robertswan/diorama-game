local Mixin = require ("resources/scripts/menus/mixin")
local Dialog = require ("resources/scripts/menus/paint/dialog_utils")
local Utils = require ("resources/scripts/menus/paint/paint_utils")

--------------------------------------------------
local lastClickPos = {
    0, 0,
}

local overlay = {
    title = "title",
    isShown = false,
    canvas,
    width,
    height,
    finished = false,
    error,
}

--------------------------------------------------
local colors =
{
    0x000000ff,
    0xff0000ff,
    0xffc0cbff,
    0x008080ff,
    0x0000ffff,
    0xeeeeeeff,
    0xffff00ff,
    0x00ff00ff,
    0x660066ff,
    0x008000ff,
    0x333333ff,
    0xdaa520ff,
    0x00ffffff,
}

--------------------------------------------------
local function createNewRow (self, rowIdx)
    local row = {}
    for colIdx = 1, self.w do
        local cell = 0x000000ff
        table.insert (row, cell)
    end

    return row
end

--------------------------------------------------
local function createCanvas (self)
    local canvas = {}
    for rowIdx = 1, self.h do
        local row = createNewRow (self, rowIdx)
        table.insert (canvas, row)
    end
    return canvas
end


--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onOkClicked ()
    local textField = Dialog.getFirstElementofType (2)
    local fileName = textField.text
    local save = (overlay.title == "Save")

    if save then
        local wasSaved = Utils.savePaintFile (overlay.canvas, fileName .. ".brs", overlay.height, overlay.width)

        if wasSaved == 1 then
            overlay.isShown = false
            overlay.finished = true

        elseif wasSaved == -1 then
            overlay.error = "Filename was not specified!"

        elseif wasSaved == -2 then
            overlay.error = "Couldn't open file!"

        elseif wasSaved == 2 then
            overlay.error = "Why did you save an empty file?"

        else
            overlay.error = "Something went wrong..."
        end
    else
        local loadedFile = Utils.loadPaintFile (fileName .. ".brs")

        if loadedFile == -1 then
            overlay.error = "Filename was not specified!"

        elseif loadedFile == -2 then
            overlay.error = "Couldn't open file!"

        else
            overlay.canvas = loadedFile
            overlay.isShown = false
            overlay.finished = true
        end
    end
end

--------------------------------------------------
function c:onCancelClicked ()
    overlay.isShown = false
    overlay.finished = false
    overlay.error = nil
end

--------------------------------------------------
function c:setCurrentColor (x, y)
    for idx = 1, #colors do
        if x >= self.l + self.w * self.cellSize + 25 and y >= self.t + idx * self.cellSize + idx * 5
        and x <= self.l + self.w * self.cellSize + 25 + self.cellSize and y <= self.t + idx * self.cellSize + idx * 5 + self.cellSize then

            self.currentColor = colors [idx]
            return 1
        end
    end

    if x >= self.l + self.w * self.cellSize + 17 and y >= self.t + (#colors + 1) * self.cellSize + (#colors + 1) * 5 + 2
    and x <= self.l + self.w * self.cellSize + 17 + self.cellSize * 4 and y <= self.t + (#colors + 1) * self.cellSize + (#colors + 1) * 5 + 2 + self.cellSize * 3 then

        overlay.title = "Save"
        overlay.isShown = true
        overlay.finished = false
        overlay.canvas = self.canvas
        overlay.width = self.w
        overlay.height = self.h

    elseif x >= self.l + self.w * self.cellSize + 17 and y >= self.t + (#colors + 2) * self.cellSize + (#colors + 2) * 5 + 17
    and x <= self.l + self.w * self.cellSize + 17 + self.cellSize * 4 and y <= self.t + (#colors + 2) * self.cellSize + (#colors + 2) * 5 + 17 + self.cellSize * 3 then

        overlay.title = "Load"
        overlay.isShown = true
        overlay.finished = false
        overlay.canvas = self.canvas
        overlay.width = self.w
        overlay.height = self.h
    end
end

--------------------------------------------------
function c:onHover (x, y)
    self.saveHover = false
    self.loadHover = false

    if x >= self.l + self.w * self.cellSize + 17 and y >= self.t + (#colors + 1) * self.cellSize + (#colors + 1) * 5 + 2
    and x <= self.l + self.w * self.cellSize + 17 + self.cellSize * 4 and y <= self.t + (#colors + 1) * self.cellSize + (#colors + 1) * 5 + 2 + self.cellSize * 3 then

        self.saveHover = true

    elseif x >= self.l + self.w * self.cellSize + 17 and y >= self.t + (#colors + 2) * self.cellSize + (#colors + 2) * 5 + 17
    and x <= self.l + self.w * self.cellSize + 17 + self.cellSize * 4 and y <= self.t + (#colors + 2) * self.cellSize + (#colors + 2) * 5 + 17 + self.cellSize * 3 then

        self.loadHover = true

    end
end

--------------------------------------------------
function c:setCellColor (x, y)
    for rowIdx = 1, self.h do
        for colIdx = 1, self.w do
            if x >= self.l + colIdx * self.cellSize and y >= self.t + rowIdx * self.cellSize
            and x <= self.l + colIdx * self.cellSize + self.cellSize and y <= self.t + rowIdx * self.cellSize + self.cellSize then

                self.canvas [rowIdx][colIdx] = self.currentColor
                return 1
            end
        end
    end
end

--------------------------------------------------
function c:startApp ()
    self.canvas = createCanvas (self)
    Dialog.addButton (150, 150, 14, 8, "Ok", self.onOkClicked)
    Dialog.addButton (225, 150, 14, 8, "Cancel", self.onCancelClicked)
    Dialog.addTextField (150, 100, 40, 8, "pic")
end

--------------------------------------------------
function c:update (x, y, was_left_clicked)
    if overlay.isShown then
        local ret = Dialog.update (x, y, was_left_clicked)

        if ret then
            overlay.isShown = false
            overlay.finished = false
            overlay.error = nil
        end
        return
    end

    if overlay.finished then
        self.canvas = overlay.canvas
        overlay.finished = false
        overlay.error = nil
    end

    if was_left_clicked then
        lastClickPos [1] = x
        lastClickPos [2] = y
    end

    if x > self.l + self.w * self.cellSize + self.cellSize then
        if was_left_clicked then
            self:setCurrentColor (x, y)
        else
            self:onHover (x, y)
        end
    elseif was_left_clicked then
        self:setCellColor (x, y)
    end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
    if overlay.isShown then
        Dialog.onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
    end

    if keyCode == dio.inputs.keyCodes.ESCAPE then
        if overlay.isShown then
            overlay.isShown = false
            overlay.finished = false
            overlay.error = nil
            return
        end

        self.parentMenu:recordAppClose ()
    end
end

--------------------------------------------------
function c:render ()
    for rowIdx = 1, self.h do
        for colIdx = 1, self.w do
            local cell = self.canvas [rowIdx][colIdx]
            dio.drawing.font.drawBox (self.l + colIdx * self.cellSize, self.t + rowIdx * self.cellSize, self.cellSize, self.cellSize, cell)

            if colIdx == self.w and rowIdx <= #colors + 2 then
                if rowIdx == #colors + 1 then
                    Dialog.drawCustomButton (self.l + colIdx * self.cellSize + 17, self.t + rowIdx * self.cellSize + rowIdx * 5 + 2, self.cellSize, "Save", self.saveHover)
                elseif rowIdx == #colors + 2 then
                    Dialog.drawCustomButton (self.l + colIdx * self.cellSize + 17, self.t + rowIdx * self.cellSize + rowIdx * 5 + 17, self.cellSize, "Load", self.loadHover)
                else
                    if colors [rowIdx] == self.currentColor then
                        dio.drawing.font.drawBox (self.l + colIdx * self.cellSize + 24, self.t + rowIdx * self.cellSize + rowIdx * 5 - 1, self.cellSize * 1.25, self.cellSize * 1.25, 0xeeeeeeff)
                    end

                    dio.drawing.font.drawBox (self.l + colIdx * self.cellSize + 25, self.t + rowIdx * self.cellSize + rowIdx * 5, self.cellSize, self.cellSize, colors[rowIdx])
                end
            end
        end
    end

    if overlay.isShown then
        Dialog.drawDialog (125, 50, 250, 150, 0xaaaaaaaa, overlay.title)
        Dialog.drawAllElements ()

        if overlay.error then
            Dialog.drawErrorMessage (175, 130, overlay.error)
        end
    end

    -- debugging
    --dio.drawing.font.drawString (3, 5, string.format("%s: %i", "x", lastClickPos [1]), 0xffffffff)
    --dio.drawing.font.drawString (3, 15, string.format("%s: %i", "y", lastClickPos [2]), 0xffffffff)

    --dio.drawing.font.drawString (3, 25, string.format("%s: %x", "col", self.currentColor), 0xffffffff)
end

--------------------------------------------------
return function (menu)

    local instance =
    {
        w = 54,
        h = 27,
        cellSize = 8,
        l = 20,
        t = 10,
        parentMenu = menu,

        canvas = nil,
        currentColor = 0x000000ff,

        saveHover = false,
        loadHover = false,
    }

    Mixin.CopyTo (instance, c)

    return instance
end
