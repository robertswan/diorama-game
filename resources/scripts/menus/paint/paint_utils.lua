--------------------------------------------------
local d = {}

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

return d
