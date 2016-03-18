--------------------------------------------------
local m = {}

--------------------------------------------------
function m.addKeyEntry (menu, text, onClicked, initial_key)

    local function decorateText (text, initial_key)
        return text .. "           [" .. initial_key .. "]"
    end

    local key_entry = 
    {
        decorateText = decorateText,
        initial_key = initial_key,
        text_original = text,
        text_unfocused = "  " .. decorateText (text, initial_key) .. "  ",
        text_focused = "[ " .. decorateText (text, initial_key) .. " ]",
        text = "  " .. decorateText (text, initial_key) .. "  ",
        x = 100,
        y = menu.next_y,
        width = 200,
        height = 10,
        onClicked = function (self) 
            if onClicked then
                onClicked (self)
            end
        end,
    }

    menu.next_y = menu.next_y + 10
    table.insert (menu.items, key_entry)

    return key_entry
end

--------------------------------------------------
return m
