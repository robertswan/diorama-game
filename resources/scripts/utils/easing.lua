--------------------------------------------------
local m = {}

--------------------------------------------------
function m.tween (coeff, a, b)
    return (a * (1.0 - coeff)) + (b * coeff)
end

--------------------------------------------------
function m.linear (t)
    return t
end

--------------------------------------------------
function m.easeInQuad (t)
    return (t * t)
end

--------------------------------------------------
function m.easeOutQuad (t)
    return m.easeInQuad (1 - t)
end

--------------------------------------------------
function m.easeInCubic (t)
    return (t * t * t)
end

--------------------------------------------------
function m.easeOutCubic (t)
    return m.easeInCubic (1 - t)
end

--------------------------------------------------
function m.easeInBounce (t)
    return m.easeOutBounce (1 - t)
end

--------------------------------------------------
function m.backIn (t)
    local s = 1.70158
    return t * t * ((s + 1) * t - s)
end

--------------------------------------------------
function m.backOut (t)
    local s = 1.70158
    t = t - 1
    return t * t * ((s + 1) * t + s) + 1
end

--------------------------------------------------
function m.easeOutBounce (t)

    if t < 4 / 11.0 then
        return (121 * t * t) / 16.0
    elseif t < 8 / 11.0 then
        return (363 / 40.0 * t * t) - (99 / 10.0 * t) + 17/5.0
    elseif t < 9 / 10.0 then
        return (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + 16061 / 1805.0
    else
        return (54 / 5.0 * t * t) - (513 / 25.0 * t) + 268 / 25.0
    end
end

--------------------------------------------------
function m.easeInElastic (t)

    if t == 0 then
        return 0
    elseif t == 1 then
        return 1
    else
        return -math.pow (2, 10 * (t - 1)) * math.sin ((t - 1.1) * 5 * math.pi)  
    end

    --return math.sin (13 * math.pi * 2 * t) * math.pow (2, 10 * (t - 1))
end

--------------------------------------------------
return m
