local Mixin = require ("resources/scripts/menus/mixin")
local Tetromino = require ("resources/scripts/menus/tetris/tetromino")

--------------------------------------------------
local scores =
{
	100,
	250,
	1000,
	5000,
}

--------------------------------------------------
local pieceTemplates = 
{
	Tetromino (2, "I", 		{{0, -1}, {0, 0}, {0, 1}, {0, 2}}), -- I
	Tetromino (4, "L",		{{0, -2}, {0, -1}, {0, 0}, {1, 0}}), -- L
	Tetromino (4, "J",		{{0, -2}, {0, -1}, {0, 0}, {-1, 0}}), -- reverse L
	Tetromino (1, "O",		{{0, 0}, {1, 0}, {0, 1}, {1, 1}}), -- box
	Tetromino (2, "S",		{{0, 0}, {1, 0}, {0, 1}, {-1, 1}}), -- S
	Tetromino (2, "Z",		{{0, 0}, {-1, 0}, {0, 1}, {1, 1}}), -- reverse S
	Tetromino (4, "T",		{{0, 0}, {1, 0}, {-1, 0}, {0, 1}}), -- T
}

--------------------------------------------------
local colors =
{
	[""] 	= 0x000000ff,
	["*"] 	= 0x808080ff,
	["I"] 	= 0xff00ffff,
	["L"] 	= 0xff8000ff,
	["J"] 	= 0x0000ffff,
	["O"] 	= 0xffff00ff,
	["S"] 	= 0x00ff00ff,
	["Z"] 	= 0xff0000ff,
	["T"] 	= 0xff00ffff,
}


--------------------------------------------------
local function createNewRow (self, rowIdx)
	local row = {}
	for colIdx = 1, self.w do
		local cell = ""
		if colIdx == 1 or colIdx == self.w or rowIdx == self.h then
			cell = "*"
		end
		table.insert (row, cell)
	end

	return row
end

--------------------------------------------------
local function createField (self)
	local field = {}
	for rowIdx = 1, self.h do
		local row = createNewRow (self, rowIdx)
		table.insert (field, row)
	end
	return field
end

--------------------------------------------------
local function createNewPiece (self)
	local template = pieceTemplates [math.random (#pieceTemplates)]
	local currentPiece =
	{
		template = template,

		x = math.floor (self.w / 2),
		y = 3, -- TODO fix the field height
		rotation = template.rotationCount,
	}

	return currentPiece
end

--------------------------------------------------
local function fillFieldWithBlocks (field, x, y, blocks, cellId)
	for blockIdx = 1, #blocks do
		local block = blocks [blockIdx]
		field [y + block [2]][x + block [1]] = cellId
	end
end	

--------------------------------------------------
local function checkCurrentPieceCollision (self, xOffset, yOffset, rotation)

	xOffset = xOffset + self.currentPiece.x
	yOffset = yOffset + self.currentPiece.y

	local current = self.currentPiece
	local blocks = current.template:getBlocks (rotation)
	local field = self.field

	for blockIdx = 1, #blocks do
		local block = blocks [blockIdx]

		if field [yOffset + block [2]][xOffset + block [1]] ~= "" then
			return true
		end
	end

	return false

end

--------------------------------------------------
local function dropPiece (self)
	local current = self.currentPiece
	local blocks = current.template:getBlocks (current.rotation)
	fillFieldWithBlocks (self.field, current.x, current.y, blocks, current.template.cellId) 
end

--------------------------------------------------
local function removeAndScoreSolidLines (self)
	local linesRemoved = {}

	local field = self.field
	for rowIdx = 1, self.h - 1 do
		local isFull = true
		for colIdx = 1, self.w do
			local cell = field [rowIdx][colIdx]
			if cell == "" then
				isFull = false
			end
		end
		if isFull then
			table.insert (linesRemoved, rowIdx)
		end
	end

	for lineIdx = 1, #linesRemoved do
		local line = linesRemoved [lineIdx]
		for moveLineIdx = line, 1, -1 do
			field [moveLineIdx] = field [moveLineIdx - 1]
		end
		field [1] = createNewRow (self, 1)
	end

	if #linesRemoved > 0 then
		self.score = self.score + self.level * scores [#linesRemoved]
	end
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:startGame ()
	self.field = createField (self)
	self.currentPiece = createNewPiece (self)
	self.dropTickCount = 0
end

--------------------------------------------------
function c:update ()

	if not self.isGameOver then

		self.dropTickCount = self.dropTickCount + 1
		if self.dropTickCount >= self.currentDropSpeed then

			self.dropTickCount = 0
			local hasCollided = checkCurrentPieceCollision (self, 0, 1, self.currentPiece.rotation)

			if hasCollided then

				dropPiece (self)
			 	removeAndScoreSolidLines (self)
				self.currentPiece = createNewPiece (self)
				local isGameOver = checkCurrentPieceCollision (self, 0, 0, self.currentPiece.rotation)

				if isGameOver then

				 	self.isGameOver = true
				else

					self.currentDropSpeed = self.dropSpeed
				 	self.dropTickCount = 0			
				end
			else
				self.currentPiece.y = self.currentPiece.y + 1
			end
		end
	end
end

--------------------------------------------------
function c:render ()
	
	-- add the current piece to the field
	local current = self.currentPiece
	local blocks = current.template:getBlocks (current.rotation)
	fillFieldWithBlocks (self.field, current.x, current.y, blocks, current.template.cellId) 

	-- draw field
	for rowIdx = 1, self.h do
		for colIdx = 1, self.w do
			local cell = self.field [rowIdx][colIdx]
			local color = colors [cell]
			dio.drawing.font.drawBox (self.l + colIdx * self.cellSize, self.t + rowIdx * self.cellSize, self.cellSize, self.cellSize, color)
		end
	end	

	-- remove field
	fillFieldWithBlocks (self.field, current.x, current.y, blocks, "") 

	dio.drawing.font.drawString (10, 10, "SCORE", 0x808080)
	dio.drawing.font.drawString (10, 20, tostring (self.score), 0xffffff)

	if self.isGameOver then
		dio.drawing.font.drawString (10, 40, "GAME OVER. Press ESCAPE to continue", 0xffffff)
	end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
	
	if self.isGameOver then

		if keyCode == dio.inputs.keyCodes.ESCAPE then
			self.parentMenu:recordTetrisGameOver ()
		end

	else

		local piece = self.currentPiece			
		if keyCode == dio.inputs.keyCodes.LEFT then

			if not checkCurrentPieceCollision (self, -1, 0, piece.rotation) then
				self.currentPiece.x = self.currentPiece.x - 1
			end

		elseif keyCode == dio.inputs.keyCodes.RIGHT then

			if not checkCurrentPieceCollision (self, 1, 0, piece.rotation) then
				self.currentPiece.x = self.currentPiece.x + 1
			end

		elseif keyCode == dio.inputs.keyCodes.DOWN then

			self.currentDropSpeed = 5

		elseif keyCode == dio.inputs.keyCodes.SPACE then

			local newRotation = piece.rotation + 1
			if newRotation > piece.template.rotationCount then
				newRotation = 1
			end
			local hasCollided = checkCurrentPieceCollision (self, 0, 0, newRotation)
			if not hasCollided then
				piece.rotation = newRotation
			end
		end
	end

	return true
end

--------------------------------------------------
return function (menu)

	local instance = 
	{
		w = 12,
		h = 21,
		cellSize = 8,
		l = 200,
		t = 20,
		score = 0,
		level = 1,
		dropSpeed = 30,
		currentDropSpeed = 30,
		dropTickCount = 0,
		parentMenu = menu,
	}

	Mixin.CopyTo (instance, c)

	return instance
end
