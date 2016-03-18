local ListUtils = require ("resources/scripts/menus/paint/list_utils")

--------------------------------------------------
local d = {}

--------------------------------------------------
local rx = { 0, 1, 0, -1 } -- x relative neighbors
local ry = { -1, 0, 1, 0 } -- y relative neighbors

--------------------------------------------------
function d.savePaintFile (canvas, fileName, h, w)
    if fileName == nil or fileName == ".brs" then
        return -1
    end

    local file = io.open (fileName, "w")

    if file == nil then
        return -2
    end

    local emptyFile = true

    for rowIdx = 1, h do
		for colIdx = 1, w do
            local color = canvas [rowIdx][colIdx]

            if emptyFile and color ~= 1 then
                emptyFile = false
            end

            file:write (tostring (color))
            file:write (" ")
        end

        if rowIdx ~= h then
            file:write ("\n")
        end
    end

    file:close()

    if emptyFile then
        return 2
    end

    return 1
end

--------------------------------------------------
function d.loadPaintFile (fileName)
    if fileName == nil or fileName == ".brs" then
        return -1
    end

    local file = io.open (fileName, "r")

    if file == nil then
        return -2
    end

    local canvas = {}
    local h = 1
    local w = 1
    local lines = file:lines ()

    for line in lines do
        canvas [h] = {}

        for num in string.gmatch (line, "%S+") do
            canvas [h][w] = tonumber (num)
            w = w + 1
        end

        w = 1
        h = h + 1
    end

    file:close ()
    return canvas
end

--------------------------------------------------
function d.blendColors (color1, color2)
    local r1 = bit32.band (bit32.rshift (color1, 24), 255)
    local r2 = bit32.band (bit32.rshift (color2, 24), 255)
    local g1 = bit32.band (bit32.rshift (color1, 16), 255)
    local g2 = bit32.band (bit32.rshift (color2, 16), 255)
    local b1 = bit32.band (bit32.rshift (color1, 8), 255)
    local b2 = bit32.band (bit32.rshift (color2, 8), 255)
    local a1 = bit32.band (color1, 255) / 255.0
    local a2 = bit32.band (color2, 255) / 255.0

    local r = a1 * r1 + a2 * (1 - a1) * r2
    local g = a1 * g1 + a2 * (1 - a1) * g2
    local b = a1 * b1 + a2 * (1 - a1) * b2
    local a = 255 * (a1 + a2 * (1 - a1))

    return bit32.lshift (r, 24) + bit32.lshift (g, 16) + bit32.lshift (b, 8) + a
end

--------------------------------------------------
function d.floodFill (newColor, oldColor, x, y, canvas, canvasW, canvasH)
    if newColor == oldColor then return canvas end

    local list = ListUtils.new ()
    list = ListUtils.pushright (list, {x = x, y = y})

    local x1 = x
    local y1 = y
    local keepOn = true
    local recursedNum = 0

    while keepOn do
        local val
        list, val = ListUtils.popright (list)
        if val == nil then
            keepOn = false
        else
            x1 = val.x
            y1 = val.y

            canvas [y1][x1] = newColor

            for i = 1, 4 do
                nx = x1 + rx [i]
                ny = y1 + ry [i]

                if nx > 0 and nx <= canvasW and ny > 0 and ny <= canvasH and canvas [ny][nx] == oldColor then
                    list = ListUtils.pushright (list, {x = nx, y = ny})
                end
            end

            recursedNum = recursedNum + 1
        end
    end

    return canvas
end

--------------------------------------------------
function d.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[d.deepcopy(orig_key)] = d.deepcopy(orig_value)
        end
        setmetatable(copy, d.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return d
