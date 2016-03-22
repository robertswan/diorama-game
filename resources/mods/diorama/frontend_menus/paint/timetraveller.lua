local ListUtils = require ("resources/mods/diorama/frontend_menus/paint/list_utils")
local PaintUtils = require ("resources/mods/diorama/frontend_menus/paint/paint_utils")

--------------------------------------------------
local s = {}

--------------------------------------------------
local maxBufferSize = 32
local undoList, redoList

--------------------------------------------------
-- pen, pos_x, pos_y, old_color
-- fill, old_canvas_state
-- eraser, pos_x, pos_y, old_color
-- picker, old_color
function s.addPenEvent (x, y, oldColor, newColor)
    undoList = ListUtils.pushright (undoList, { evtId = 1, x = x, y = y, oldColor = oldColor, newColor = newColor })

    if ListUtils.getSize (undoList) > maxBufferSize then
        undoList = ListUtils.popleft (undoList)
    end

    if ListUtils.getSize (redoList) ~= -1 then
        redoList = ListUtils.new ()
    end
end

--------------------------------------------------
function s.addFillEvent (oldCanvas, newCanvas)
    undoList = ListUtils.pushright (undoList, { evtId = 2, oldCanvas = oldCanvas, newCanvas = newCanvas })

    if ListUtils.getSize (undoList) > maxBufferSize then
        undoList = ListUtils.popleft (undoList)
    end

    if ListUtils.getSize (redoList) ~= -1 then
        redoList = ListUtils.new ()
    end
end

--------------------------------------------------
function s.addEraserEvent (x, y, oldColor)
    undoList = ListUtils.pushright (undoList, { evtId = 3, x = x, y = y, oldColor = oldColor })

    if ListUtils.getSize (undoList) > maxBufferSize then
        undoList = ListUtils.popleft (undoList)
    end

    if ListUtils.getSize (redoList) ~= -1 then
        redoList = ListUtils.new ()
    end
end

--------------------------------------------------
function s.undo (canvas)
    local size = ListUtils.getSize (undoList)

    if ListUtils.getSize (undoList) < 0 then return canvas end

    local event
    undoList, event = ListUtils.popright (undoList)

    if event.evtId == 1 then
        canvas [event.y][event.x] = event.oldColor
    elseif event.evtId == 2 then
        canvas = event.oldCanvas
    elseif event.evtId == 3 then
        canvas [event.y][event.x] = event.oldColor
    end

    ListUtils.pushright (redoList, event)
    return canvas
end

--------------------------------------------------
function s.redo (canvas)
    local size = ListUtils.getSize (redoList)

    if ListUtils.getSize (redoList) < 0 then return canvas end

    local event
    redoList, event = ListUtils.popright (redoList)

    if event.evtId == 1 then
        canvas [event.y][event.x] = event.newColor
    elseif event.evtId == 2 then
        canvas = event.newCanvas
    elseif event.evtId == 3 then
        canvas [event.y][event.x] = 0
    end

    ListUtils.pushright (undoList, event)
    return canvas
end

--------------------------------------------------
function s.init ()
    undoList = ListUtils.new ()
    redoList = ListUtils.new ()
end

return s
