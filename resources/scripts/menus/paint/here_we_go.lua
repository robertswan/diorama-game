--------------------------------------------------
local s = {}

--dio.drawing.font.drawBox (x + , y + , scale - , scale - , isMouseOver and  or )
--------------------------------------------------
-- and or works good enough here
function s.drawPen (x, y, scale, isMouseOver, isCurrentTool)
    if isCurrentTool then
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0xdd0000ff or 0xee0000ff) -- border
    else
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0x454545ff or 0x555555ff)
    end

    dio.drawing.font.drawBox (x + 1, y + 1, scale - 2, scale - 2, isMouseOver and 0xefefefff or 0xffffffff) -- inside

    -- here we go
    dio.drawing.font.drawBox (x + 2, y + 12, scale - 14, scale - 14, isMouseOver and 0x111111ff or 0x222222ff)
    dio.drawing.font.drawBox (x + 2, y + 11, scale - 14, scale - 14, isMouseOver and 0xcbc57fff or 0xdbd58fff)
    dio.drawing.font.drawBox (x + 3, y + 11, scale - 14, scale - 13, isMouseOver and 0xcbc57fff or 0xdbd58fff)
    dio.drawing.font.drawBox (x + 4, y + 11, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 3, y + 10, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 4, y + 10, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 5, y + 10, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 4, y + 9, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 5, y + 9, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 6, y + 9, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 5, y + 8, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 6, y + 8, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 7, y + 8, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 6, y + 7, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 7, y + 7, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 8, y + 7, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 7, y + 6, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 8, y + 6, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 9, y + 6, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 8, y + 5, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 9, y + 5, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 10, y + 5, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 9, y + 4, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 10, y + 4, scale - 14, scale - 14, isMouseOver and 0x656565ff or 0x757575ff)

    dio.drawing.font.drawBox (x + 11, y + 2, scale - 14, scale - 12, isMouseOver and 0xeda300ff or 0xfdb300ff)
    dio.drawing.font.drawBox (x + 10, y + 3, scale - 14, scale - 14, isMouseOver and 0xeda300ff or 0xfdb300ff)
    dio.drawing.font.drawBox (x + 12, y + 3, scale - 14, scale - 14, isMouseOver and 0xeda300ff or 0xfdb300ff)
end

--------------------------------------------------
-- totally worth it :)
-- 0x555555ff 0x454545ff
-- 0x656565ff 0x555555ff
-- 0x757575ff 0x656565ff
-- 0x858585ff 0x757575ff
-- 0x959595ff 0x858585ff
-- 0xa5a5a5ff 0x959595ff
function s.drawFill (x, y, scale, isMouseOver, isCurrentTool)
    if isCurrentTool then
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0xdd0000ff or 0xee0000ff) -- border
    else
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0x454545ff or 0x555555ff)
    end

    dio.drawing.font.drawBox (x + 1, y + 1, scale - 2, scale - 2, isMouseOver and 0xefefefff or 0xffffffff) -- inside

    -- paint
    dio.drawing.font.drawBox (x + 2, y + 6, scale - 14, scale - 10, isMouseOver and 0x2981b9ff or 0x3991c9ff)
    dio.drawing.font.drawBox (x + 3, y + 5, scale - 14, scale - 13, isMouseOver and 0x2981b9ff or 0x3991c9ff)
    dio.drawing.font.drawBox (x + 4, y + 5, scale - 14, scale - 14, isMouseOver and 0x2981b9ff or 0x3991c9ff)

    -- bucket (yeah... :/)
    dio.drawing.font.drawBox (x + 3, y + 7, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 4, y + 8, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 5, y + 9, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 6, y + 10, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 7, y + 11, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 8, y + 12, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 4, y + 7, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 5, y + 8, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 6, y + 9, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 7, y + 10, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 8, y + 11, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)

    dio.drawing.font.drawBox (x + 4, y + 6, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 5, y + 7, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 6, y + 8, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 7, y + 9, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 8, y + 10, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 9, y + 11, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 5, y + 6, scale - 14, scale - 14, isMouseOver and 0x959595ff or 0xa5a5a5ff)
    dio.drawing.font.drawBox (x + 6, y + 7, scale - 14, scale - 14, isMouseOver and 0x959595ff or 0xa5a5a5ff)
    dio.drawing.font.drawBox (x + 7, y + 8, scale - 14, scale - 14, isMouseOver and 0x959595ff or 0xa5a5a5ff)
    dio.drawing.font.drawBox (x + 8, y + 9, scale - 14, scale - 14, isMouseOver and 0x959595ff or 0xa5a5a5ff)
    dio.drawing.font.drawBox (x + 9, y + 10, scale - 14, scale - 14, isMouseOver and 0x959595ff or 0xa5a5a5ff)

    dio.drawing.font.drawBox (x + 5, y + 5, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 6, y + 6, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 7, y + 7, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 8, y + 8, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 9, y + 9, scale - 14, scale - 14, isMouseOver and 0x858585ff or 0x959595ff)
    dio.drawing.font.drawBox (x + 10, y + 10, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 6, y + 5, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 7, y + 6, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 8, y + 7, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 9, y + 8, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)
    dio.drawing.font.drawBox (x + 10, y + 9, scale - 14, scale - 14, isMouseOver and 0x757575ff or 0x858585ff)

    dio.drawing.font.drawBox (x + 6, y + 4, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 7, y + 5, scale - 14, scale - 14, isMouseOver and 0x656565ff or 0x757575ff)
    dio.drawing.font.drawBox (x + 8, y + 6, scale - 14, scale - 14, isMouseOver and 0x656565ff or 0x757575ff)
    dio.drawing.font.drawBox (x + 9, y + 7, scale - 14, scale - 14, isMouseOver and 0x656565ff or 0x757575ff)
    dio.drawing.font.drawBox (x + 10, y + 8, scale - 14, scale - 14, isMouseOver and 0x656565ff or 0x757575ff)
    dio.drawing.font.drawBox (x + 11, y + 9, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 7, y + 4, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 8, y + 5, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 9, y + 6, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 10, y + 7, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)
    dio.drawing.font.drawBox (x + 11, y + 8, scale - 14, scale - 14, isMouseOver and 0x555555ff or 0x656565ff)

    dio.drawing.font.drawBox (x + 7, y + 3, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 8, y + 4, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 9, y + 5, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 10, y + 6, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 11, y + 7, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 12, y + 8, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
end

--------------------------------------------------
function s.drawEraser (x, y, scale, isMouseOver, isCurrentTool)
    if isCurrentTool then
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0xdd0000ff or 0xee0000ff) -- border
    else
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0x454545ff or 0x555555ff)
    end

    dio.drawing.font.drawBox (x + 1, y + 1, scale - 2, scale - 2, isMouseOver and 0xefefefff or 0xffffffff) -- inside
    dio.drawing.font.drawBox (x + 3, y + 3, scale - 6, scale - 11, isMouseOver and 0xee6979ff  or 0xff7979ff) -- eraser top
    dio.drawing.font.drawBox (x + 3, y + 7, scale - 6, scale - 9, isMouseOver and 0x454545ff or 0x555555ff) -- eraser bot border
    dio.drawing.font.drawBox (x + 4, y + 8, scale - 8, scale - 11, isMouseOver and 0xeea500ff or 0xffb500ff) -- eraser bot inside
end

--------------------------------------------------
function s.drawPicker (x, y, scale, isMouseOver, isCurrentTool)
    if isCurrentTool then
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0xdd0000ff or 0xee0000ff) -- border
    else
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0x454545ff or 0x555555ff)
    end

    dio.drawing.font.drawBox (x + 1, y + 1, scale - 2, scale - 2, isMouseOver and 0xefefefff or 0xffffffff) -- inside
    dio.drawing.font.drawBox (x + 2, y + 11, scale - 13, scale - 13, isMouseOver and 0x2981b9ff or 0x3991c9ff) -- blue color at the tip
    dio.drawing.font.drawBox (x + 8, y + 3, scale - 11, scale - 11, isMouseOver and 0x454545ff or 0x555555ff) -- dark end tip
    -- here we go again
    dio.drawing.font.drawBox (x + 4, y + 11, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 3, y + 10, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 4, y + 10, scale - 14, scale - 14, isMouseOver and 0x2981b9ff or 0x3991c9ff)
    dio.drawing.font.drawBox (x + 5, y + 10, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 4, y + 9, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 5, y + 9, scale - 14, scale - 14, isMouseOver and 0x2981b9ff or 0x3991c9ff)
    dio.drawing.font.drawBox (x + 6, y + 9, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 5, y + 8, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 6, y + 8, scale - 14, scale - 14, isMouseOver and 0x2981b9ff or 0x3991c9ff)
    dio.drawing.font.drawBox (x + 7, y + 8, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 6, y + 7, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 7, y + 7, scale - 14, scale - 14, isMouseOver and 0x2981b9ff or 0x3991c9ff)
    dio.drawing.font.drawBox (x + 8, y + 7, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)

    dio.drawing.font.drawBox (x + 7, y + 6, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
end

--------------------------------------------------
function s.drawUndo (x, y, scale, isMouseOver)
        dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0x454545ff or 0x555555ff) -- border
        dio.drawing.font.drawBox (x + 1, y + 1, scale - 2, scale - 2, isMouseOver and 0xefefefff or 0xffffffff) -- inside

        -- the arrow
        dio.drawing.font.drawBox (x + 3, y + 11, scale - 6, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
        dio.drawing.font.drawBox (x + 11, y + 3, scale - 14, scale - 7, isMouseOver and 0x454545ff or 0x555555ff)
        dio.drawing.font.drawBox (x + 3, y + 3, scale - 7, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
        dio.drawing.font.drawBox (x + 3, y + 4, scale - 14, scale - 12, isMouseOver and 0x454545ff or 0x555555ff)
        dio.drawing.font.drawBox (x + 2, y + 5, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
end

--------------------------------------------------
function s.drawRedo (x, y, scale, isMouseOver)
    dio.drawing.font.drawBox (x, y, scale, scale, isMouseOver and 0x454545ff or 0x555555ff) -- border
    dio.drawing.font.drawBox (x + 1, y + 1, scale - 2, scale - 2, isMouseOver and 0xefefefff or 0xffffffff) -- inside

    -- the arrow
    dio.drawing.font.drawBox (x + 3, y + 11, scale - 6, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 3, y + 3, scale - 14, scale - 7, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 4, y + 3, scale - 7, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 11, y + 4, scale - 14, scale - 12, isMouseOver and 0x454545ff or 0x555555ff)
    dio.drawing.font.drawBox (x + 12, y + 5, scale - 14, scale - 14, isMouseOver and 0x454545ff or 0x555555ff)
end

return s
