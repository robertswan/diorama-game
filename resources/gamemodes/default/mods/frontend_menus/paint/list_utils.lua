--------------------------------------------------
local List = {}

--------------------------------------------------
function List.new ()
    local list = { first = 0, last = -1 }
    return list
end

--------------------------------------------------
function List.pushleft (list, value)
    local first = list.first - 1
    list.first = first
    list [first] = value
    return list
end

--------------------------------------------------
function List.pushright (list, value)
    local last = list.last + 1
    list.last = last
    list [last] = value
    return list
end

--------------------------------------------------
function List.popleft (list)
    local first = list.first
    if first > list.last then return list, nil end
    local value = list [first]
    list [first] = nil
    list.first = first + 1
    return list, value
end

--------------------------------------------------
function List.popright (list)
    local last = list.last
    if list.first > last then return list, nil end
    local value = list [last]
    list [last] = nil
    list.last = last - 1
    return list, value
end

--------------------------------------------------
function List.getSize (list)
    return list.last - list.first
end

return List
