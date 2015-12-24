local Mixin = require ("resources/scripts/menus/mixin")
local Tetromino = require ("resources/scripts/menus/tetris/tetromino")

--------------------------------------------------
local pieces = 
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
	[""] = 0x000000,
	["*"] = 0x808080,
	["I"] = 0xff00ff,
	["L"] = 0xff8000,
	["J"] = 0x0000ff,
	["O"] = 0xffff00,
	["S"] = 0x00ff00,
	["Z"] = 0xff0000,
	["T"] = 0xff00ff,
}

--------------------------------------------------
local function createField (self)
	local field = {}
	for rowIdx = 1, self.h do
		local row = {}
		for colIdx = 1, self.w do
			local cell = ""
			if colIdx == 1 or colIdx == self.w or rowIdx == self.h then
				cell = "*"
			end
			table.insert (row, cell)
		end
		table.insert (field, row)
	end
	return field
end

--------------------------------------------------
local function createNewPiece ()
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:startGame ()
	self.field = createField (self)
	self.currentPiece = createNewPiece ()
end

--------------------------------------------------
function c:update ()
end

--------------------------------------------------
function c:render ()
	
	for rowIdx = 1, self.h do
		for colIdx = 1, self.w do
			local cell = self.field [rowIdx][colIdx]
			local color = colors [cell]
			dio.drawing.font.drawBox (self.l + colIdx * self.cellSize, self.t + rowIdx * self.cellSize, self.cellSize, self.cellSize, color)
		end
	end	
end

--------------------------------------------------
return function ()

	local instance = 
	{
		w = 12,
		h = 21,
		cellSize = 8,
		l = 200,
		t = 20,
		score = 0,
	}

	Mixin.CopyToAndBackupParents (instance, c)

	return instance
end
