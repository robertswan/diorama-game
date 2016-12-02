--------------------------------------------------
local m = {}

--------------------------------------------------
function m.linesFromSentence (sentence, width, emoteDefinitions)

    local emoteSpecs = emoteDefinitions.emoteSpecs
    local emotes = emoteDefinitions.emotes

    local spaceWidth = dio.drawing.font.measureString (" ") -- this should probably be in instance properties

    local lines = {}

    local currentLine = {}
    local currentString = ""
    local widthRemaining = width

    for word in string.gmatch (sentence, "%S+") do

        local wordLength = dio.drawing.font.measureString (word)
        local isEmote = false

        -- Check if word is an emote
        if emotes [word] then
            wordLength = emoteSpecs.renderWidth
            isEmote = true
        end

        if wordLength + spaceWidth > widthRemaining then
            -- Line has exceed maximum line length, split rest into another line
            currentLine.width = width - widthRemaining
            table.insert (currentLine, currentString)
            table.insert (lines, currentLine)
            currentLine = {}

            if isEmote then
                table.insert (currentLine, word)
                currentString = " "
            else
                currentString = word .. " "
            end

            widthRemaining = width - wordLength
        else
            -- Else add the word/emote onto the current line
            if isEmote then
                table.insert (currentLine, currentString)
                table.insert (currentLine, word)
                currentString = " "
            else
                currentString = currentString .. word .. " "
            end

            widthRemaining = widthRemaining - (wordLength + spaceWidth)
        end
    end

    currentLine.width = width - widthRemaining
    table.insert (currentLine, currentString)
    table.insert (lines, currentLine)

    return lines
end

--------------------------------------------------
function m.renderLine (x, y, line, emoteDefinitions, emoteTexture)

    local drawString = dio.drawing.font.drawString
    local emoteSpecs = emoteDefinitions.emoteSpecs
    local emotes = emoteDefinitions.emotes

    for _, word in ipairs (line) do

        if word then

            local emote = emotes [word]

            if emote then
                -- draw the emote
                local u, v = emote.uvs [1], emote.uvs [2]

                dio.drawing.drawTextureRegion2 (emoteTexture,      x, y,
                                                emoteSpecs.renderWidth, emoteSpecs.renderHeight,
                                                u * emoteSpecs.width,   v * emoteSpecs.height,
                                                emoteSpecs.width,       emoteSpecs.height)

                x = x + emoteSpecs.renderWidth

            else
                -- draw the string (with shadow)
                drawString (x, y, word, 0x000000ff, true)
                drawString (x, y+2, word, 0xffffffff, true)
                x = x + dio.drawing.font.measureString (word)
            end
        end
    end
end

--------------------------------------------------
return m