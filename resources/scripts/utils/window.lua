--------------------------------------------------
local m = {}

--------------------------------------------------
function m.calcBestFitScale (w, h)

	local windowW, windowH = dio.drawing.getWindowSize ()
	
	assert (w > 0)
	assert (h > 0)
	assert (windowW >= 0)
	assert (windowH >= 0)

	local scale = 1

	while w * (scale + 1) <= windowW and h * (scale + 1) <= windowH do
		scale = scale + 1
	end

	return scale
end

--------------------------------------------------
return m
