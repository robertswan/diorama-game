local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")
local Dialog = require ("resources/gamemodes/default/mods/frontend_menus/paint/dialog_utils")
local Utils = require ("resources/gamemodes/default/mods/frontend_menus/paint/paint_utils")
local TimeTraveller = require ("resources/gamemodes/default/mods/frontend_menus/paint/timetraveller")

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
local colors = {
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
local alphaColors = {
	0xdbdbdbff,
	0x666666ff,
}

--------------------------------------------------
local function createNewRow (self, rowIdx)
	local row = {}
	for colIdx = 1, self.w do
		local cell = 0x00000000
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
function c:onClickerino (x, y)
	local pickerLocationX = (self.l + self.w * self.cellSize) + self.colorPickerSize / 2
	local pickerLocationY = self.t + 10
	self.colorCurrentFocus = 0

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

	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 40 and y <= pickerLocationY + 40 + self.colorPickerSize / 2 then
		self.colorCurrentFocus = 1
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 60 and y <= pickerLocationY + 60 + self.colorPickerSize / 2 then
		self.colorCurrentFocus = 2
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 80 and y <= pickerLocationY + 80 + self.colorPickerSize / 2 then
		self.colorCurrentFocus = 3
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 100 and y <= pickerLocationY + 100 + self.colorPickerSize / 2 then
		self.colorCurrentFocus = 4
	elseif x >= pickerLocationX and x <= pickerLocationX + 15 and y >= pickerLocationY + 120 and y <= pickerLocationY + 135 then
		self.currentTool = 0
	elseif x >= pickerLocationX + 17 and x <= pickerLocationX + 32 and y >= pickerLocationY + 120 and y <= pickerLocationY + 135 then
		self.currentTool = 1
	elseif x >= pickerLocationX and x <= pickerLocationX + 15 and y >= pickerLocationY + 137 and y <= pickerLocationY + 152 then
		self.currentTool = 2
	elseif x >= pickerLocationX + 17 and x <= pickerLocationX + 32 and y >= pickerLocationY + 137 and y <= pickerLocationY + 152 then
		self.currentTool = 3
	elseif x >= pickerLocationX and x <= pickerLocationX + 15 and y >= pickerLocationY + 154 and y <= pickerLocationY + 169 then
		self.canvas = TimeTraveller.undo (self.canvas)
	elseif x >= pickerLocationX + 17 and x <= pickerLocationX + 32 and y >= pickerLocationY + 154 and y <= pickerLocationY + 169 then
		self.canvas = TimeTraveller.redo (self.canvas)
	end
end

--------------------------------------------------
function c:onHoverino (x, y)
	self.saveHover = false
	self.loadHover = false
	self.colorMouseOver = 0

	local pickerLocationX = (self.l + self.w * self.cellSize) + self.colorPickerSize / 2
	local pickerLocationY = self.t + 10

	if x >= self.l + self.w * self.cellSize + 17 and y >= self.t + (#colors + 1) * self.cellSize + (#colors + 1) * 5 + 2
	and x <= self.l + self.w * self.cellSize + 17 + self.cellSize * 4 and y <= self.t + (#colors + 1) * self.cellSize + (#colors + 1) * 5 + 2 + self.cellSize * 3 then
		self.saveHover = true
	elseif x >= self.l + self.w * self.cellSize + 17 and y >= self.t + (#colors + 2) * self.cellSize + (#colors + 2) * 5 + 17
	and x <= self.l + self.w * self.cellSize + 17 + self.cellSize * 4 and y <= self.t + (#colors + 2) * self.cellSize + (#colors + 2) * 5 + 17 + self.cellSize * 3 then
		self.loadHover = true
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 40 and y <= pickerLocationY + 40 + self.colorPickerSize / 2 then
		self.colorMouseOver = 1
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 60 and y <= pickerLocationY + 60 + self.colorPickerSize / 2 then
		self.colorMouseOver = 2
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 80 and y <= pickerLocationY + 80 + self.colorPickerSize / 2 then
		self.colorMouseOver = 3
	elseif x >= pickerLocationX and x <= pickerLocationX + self.colorPickerSize and y >= pickerLocationY + 100 and y <= pickerLocationY + 100 + self.colorPickerSize / 2 then
		self.colorMouseOver = 4
	elseif x >= pickerLocationX and x <= pickerLocationX + 15 and y >= pickerLocationY + 120 and y <= pickerLocationY + 135 then
		self.colorMouseOver = 5
	elseif x >= pickerLocationX + 17 and x <= pickerLocationX + 32 and y >= pickerLocationY + 120 and y <= pickerLocationY + 135 then
		self.colorMouseOver = 6
	elseif x >= pickerLocationX and x <= pickerLocationX + 15 and y >= pickerLocationY + 137 and y <= pickerLocationY + 152 then
		self.colorMouseOver = 7
	elseif x >= pickerLocationX + 17 and x <= pickerLocationX + 32 and y >= pickerLocationY + 137 and y <= pickerLocationY + 152 then
		self.colorMouseOver = 8
	elseif x >= pickerLocationX and x <= pickerLocationX + 15 and y >= pickerLocationY + 154 and y <= pickerLocationY + 169 then
		self.colorMouseOver = 9
	elseif x >= pickerLocationX + 17 and x <= pickerLocationX + 32 and y >= pickerLocationY + 154 and y <= pickerLocationY + 169 then
		self.colorMouseOver = 10
	end
end

--------------------------------------------------
function c:setCellColor (x, y)
	self.colorCurrentFocus = 0

	for rowIdx = 1, self.h do
		for colIdx = 1, self.w do
			if x >= self.l + colIdx * self.cellSize and y >= self.t + rowIdx * self.cellSize
			and x <= self.l + colIdx * self.cellSize + self.cellSize and y <= self.t + rowIdx * self.cellSize + self.cellSize then

				if self.currentTool == 0 then
					local cell = self.canvas [rowIdx][colIdx]
					local curA = bit32.band (self.currentColor, 255)
					local cellA = bit32.band (cell, 255)

					if curA ~= 0 then
						if curA == 255 or cellA == 0 then
							self.canvas [rowIdx][colIdx] = self.currentColor
						else
						    if cellA > curA then
							    self.canvas [rowIdx][colIdx] = Utils.blendColors (self.currentColor, cell)
	                        else
	                            self.canvas [rowIdx][colIdx] = Utils.blendColors (cell, self.currentColor)
	                        end
						end

						TimeTraveller.addPenEvent (colIdx, rowIdx, cell, self.canvas [rowIdx][colIdx])
					end

				elseif self.currentTool == 1 then
					local oldCanvas = Utils.deepcopy (self.canvas)
					self.canvas = Utils.floodFill (self.currentColor, self.canvas [rowIdx][colIdx], colIdx, rowIdx, self.canvas, self.w, self.h)
					TimeTraveller.addFillEvent (oldCanvas, self.canvas)
				elseif self.currentTool == 2 then
					local oldCell = self.canvas [rowIdx][colIdx]
					self.canvas [rowIdx][colIdx] = 0x00000000
					TimeTraveller.addEraserEvent (colIdx, rowIdx, oldCell)
				elseif self.currentTool == 3 then
					self.currentColor = self.canvas [rowIdx][colIdx]
				end
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
	TimeTraveller.init ()
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
			self:onClickerino (x, y)
		else
			self:onHoverino (x, y)
		end
	elseif was_left_clicked then
		self:setCellColor (x, y)
	end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyModifiers, keyCharacter, menus)
	if overlay.isShown then
		Dialog.onKeyClicked (keyCode, keyModifiers, keyCharacter, menus)
	end

	local keyCodes = dio.inputs.keyCodes

	if self.colorCurrentFocus == 1 then

		if keyCode and keyCode >= keyCodes ["0"] and keyCode <= keyCodes ["9"] then

			if string.len (self.curRed) < 3 then
				self.curRed = self.curRed .. string.char (keyCharacter)
				local num = tonumber (self.curRed)

				if num > 255 then
					num = 255
					self.curRed = "255"
				elseif num < 0 then
					num = 0
					self.curRed = "0"
				end

				self.currentColor = bit32.lshift (num or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (tonumber (self.curAlpha) or 0)
			end

		elseif keyCode == keyCodes.BACKSPACE then

			if string.len (self.curRed) > 0 then
				self.curRed = self.curRed:sub (1, -2)
				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (tonumber (self.curAlpha) or 0)
			end

		end

	elseif self.colorCurrentFocus == 2 then

		if keyCode and keyCode >= keyCodes ["0"] and keyCode <= keyCodes ["9"] then

			if string.len (self.curGreen) < 3 then
				self.curGreen = self.curGreen .. string.char (keyCharacter)
				local num = tonumber (self.curGreen)

				if num > 255 then
					num = 255
					self.curGreen = "255"
				elseif num < 0 then
					num = 0
					self.curGreen = "0"
				end

				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (num or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (tonumber (self.curAlpha) or 0)

			end

		elseif keyCode == keyCodes.BACKSPACE then

			if string.len (self.curGreen) > 0 then
				self.curGreen = self.curGreen:sub (1, -2)
				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (tonumber (self.curAlpha) or 0)
			end

		end

	elseif self.colorCurrentFocus == 3 then

		if keyCode and keyCode >= keyCodes ["0"] and keyCode <= keyCodes ["9"] then

			if string.len (self.curBlue) < 3 then
				self.curBlue = self.curBlue .. string.char (keyCharacter)
				local num = tonumber (self.curBlue)

				if num > 255 then
					num = 255
					self.curBlue = "255"
				elseif num < 0 then
					num = 0
					self.curBlue = "0"
				end

				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (num or 0, 8) + (tonumber (self.curAlpha) or 0)
			end

		elseif keyCode == keyCodes.BACKSPACE then

			if string.len (self.curBlue) > 0 then
				self.curBlue = self.curBlue:sub (1, -2)
				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (tonumber (self.curAlpha) or 0)
			end

		end

	elseif self.colorCurrentFocus == 4 then

		if keyCode and keyCode >= keyCodes ["0"] and keyCode <= keyCodes ["9"] then

			if string.len (self.curAlpha) < 3 then
				self.curAlpha = self.curAlpha .. string.char (keyCharacter)
				local num = tonumber (self.curAlpha)

				if num > 255 then
					num = 255
					self.curAlpha = "255"
				elseif num < 0 then
					num = 0
					self.curAlpha = "0"
				end

				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (num or 0)
			end

		elseif keyCode == keyCodes.BACKSPACE then

			if string.len (self.curAlpha) > 0 then
				self.curAlpha = self.curAlpha:sub (1, -2)
				self.currentColor = bit32.lshift (tonumber (self.curRed) or 0, 24) + bit32.lshift (tonumber (self.curGreen) or 0, 16) + bit32.lshift (tonumber (self.curBlue) or 0, 8) + (tonumber (self.curAlpha) or 0)
			end
		end
	end

	if keyCode == keyCodes ["Z"] and bit32.band (keyModifiers, 2) ~= 0 then
		self.canvas = TimeTraveller.undo (self.canvas)
	elseif keyCode == keyCodes ["Y"] and bit32.band (keyModifiers, 2) ~= 0 then
		self.canvas = TimeTraveller.redo (self.canvas)
	end

	if keyCode == keyCodes.ESCAPE then
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
			local cellA = bit32.band (cell, 255)

			if cellA < 255 then
				dio.drawing.font.drawBox (self.l + colIdx * self.cellSize, self.t + rowIdx * self.cellSize, self.cellSize / 2, self.cellSize / 2, Utils.blendColors (cell, alphaColors [1]))
				dio.drawing.font.drawBox (self.l + colIdx * self.cellSize + (self.cellSize / 2), self.t + rowIdx * self.cellSize + (self.cellSize / 2), self.cellSize / 2, self.cellSize / 2, Utils.blendColors (cell, alphaColors [1]))
				dio.drawing.font.drawBox (self.l + colIdx * self.cellSize + (self.cellSize / 2), self.t + rowIdx * self.cellSize, self.cellSize / 2, self.cellSize / 2, Utils.blendColors (cell, alphaColors [2]))
				dio.drawing.font.drawBox (self.l + colIdx * self.cellSize, self.t + rowIdx * self.cellSize + (self.cellSize / 2), self.cellSize / 2, self.cellSize / 2, Utils.blendColors (cell, alphaColors [2]))
			else
				dio.drawing.font.drawBox (self.l + colIdx * self.cellSize, self.t + rowIdx * self.cellSize, self.cellSize, self.cellSize, cell)
			end

			if colIdx == self.w and rowIdx <= #colors + 2 then
				if rowIdx == #colors + 1 then
					Dialog.drawCustomButton (self.l + colIdx * self.cellSize + 17, self.t + rowIdx * self.cellSize + rowIdx * 5 + 2, self.cellSize, "Save", self.saveHover)
				elseif rowIdx == #colors + 2 then
					Dialog.drawCustomButton (self.l + colIdx * self.cellSize + 17, self.t + rowIdx * self.cellSize + rowIdx * 5 + 17, self.cellSize, "Load", self.loadHover)
				end
			end
		end
	end

	local pickerLocationX = (self.l + self.w * self.cellSize) + self.colorPickerSize / 2
	local pickerLocationY = self.t + 10
	local curColA = bit32.band (self.currentColor, 255)

	if curColA < 255 then
		dio.drawing.font.drawBox (pickerLocationX, pickerLocationY, self.colorPickerSize / 2, self.colorPickerSize / 2, Utils.blendColors (self.currentColor, alphaColors [1]))
		dio.drawing.font.drawBox (pickerLocationX + self.colorPickerSize / 2, pickerLocationY + self.colorPickerSize / 2, self.colorPickerSize / 2, self.colorPickerSize / 2, Utils.blendColors (self.currentColor, alphaColors [1]))
		dio.drawing.font.drawBox (pickerLocationX + self.colorPickerSize / 2, pickerLocationY, self.colorPickerSize / 2, self.colorPickerSize / 2, Utils.blendColors (self.currentColor, alphaColors [2]))
		dio.drawing.font.drawBox (pickerLocationX, pickerLocationY + self.colorPickerSize / 2, self.colorPickerSize / 2, self.colorPickerSize / 2, Utils.blendColors (self.currentColor, alphaColors [2]))
	else
		dio.drawing.font.drawBox (pickerLocationX, pickerLocationY, self.colorPickerSize, self.colorPickerSize, self.currentColor)
	end

	Dialog.drawCustomInputField (pickerLocationX, pickerLocationY + 40, self.colorPickerSize / 4, self.curRed, self.colorMouseOver == 1, self.colorCurrentFocus == 1)
	Dialog.drawCustomInputField (pickerLocationX, pickerLocationY + 60, self.colorPickerSize / 4, self.curGreen, self.colorMouseOver == 2, self.colorCurrentFocus == 2)
	Dialog.drawCustomInputField (pickerLocationX, pickerLocationY + 80, self.colorPickerSize / 4, self.curBlue, self.colorMouseOver == 3, self.colorCurrentFocus == 3)
	Dialog.drawCustomInputField (pickerLocationX, pickerLocationY + 100, self.colorPickerSize / 4, self.curAlpha, self.colorMouseOver == 4, self.colorCurrentFocus == 4)
	Dialog.drawPen (pickerLocationX, pickerLocationY + 120, 15, self.colorMouseOver == 5, self.currentTool == 0)
	Dialog.drawFill (pickerLocationX + 17, pickerLocationY + 120, 15, self.colorMouseOver == 6, self.currentTool == 1)
	Dialog.drawEraser (pickerLocationX, pickerLocationY + 137, 15, self.colorMouseOver == 7, self.currentTool == 2)
	Dialog.drawPicker (pickerLocationX + 17, pickerLocationY + 137, 15, self.colorMouseOver == 8, self.currentTool == 3)
	Dialog.drawUndo (pickerLocationX, pickerLocationY + 154, 15, self.colorMouseOver == 9)
	Dialog.drawRedo (pickerLocationX + 17, pickerLocationY + 154, 15, self.colorMouseOver == 10)

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
		colorPickerSize = 32,
		l = 20,
		t = 10,
		parentMenu = menu,

		canvas = nil,
		currentColor = 0x000000ff,

		saveHover = false,
		loadHover = false,
		colorMouseOver = 0,
		colorCurrentFocus = 0,
		currentTool = 0,

		curRed = "0",
		curGreen = "0",
		curBlue = "0",
		curAlpha = "255",
	}

	Mixin.CopyTo (instance, c)

	return instance
end
