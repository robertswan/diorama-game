
--------------------------------------------------
local Mixin = require ("resources/gamemodes/default/mods/frontend_menus/mixin")

local transforms = 
{
    [1] = {{1, 0}, {0, 1}},
    [2] = {{0, 1}, {-1, 0}},
    [3] = {{-1, 0}, {0, -1}},
    [4] = {{0, -1}, {1, 0}},
}

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:getBlocks (rotation)
    local blocks2 = {}

    local copyFrom = self.blocks

    local transform = transforms [rotation]

    for blockIdx = 1, #copyFrom do
        local block = {}
        local x = copyFrom [blockIdx][1]
        local y = copyFrom [blockIdx][2]
        block [1] = x * transform [1][1] + y * transform [2][1]
        block [2] = x * transform [1][2] + y * transform [2][2]
        table.insert (blocks2, block)
    end

    return blocks2
end

--------------------------------------------------
return function (rotationCount, cellId, blocks)
    local instance = 
    {
        rotationCount = rotationCount,
        cellId = cellId,
        blocks = blocks,
    }

    Mixin.CopyTo (instance, c)

    return instance
end