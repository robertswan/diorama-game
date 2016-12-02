--------------------------------------------------
local m = {}

--------------------------------------------------
function m.cloneTable (src)

    local copy = {}
    for _, value in ipairs (src) do
        table.insert (copy, value)
    end

    return copy

end

--------------------------------------------------
return m