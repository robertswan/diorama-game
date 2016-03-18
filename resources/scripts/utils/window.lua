--------------------------------------------------
local m = {}

--------------------------------------------------
function m.calcBestFitScale (w, h, maxW, maxH)

	if maxW == nil or maxH == nil then
		maxW, maxH = dio.drawing.getWindowSize ()
	end
	
	assert (w > 0)
	assert (h > 0)
	assert (maxW >= 0)
	assert (maxH >= 0)

	local scale = 1

	while w * (scale + 1) <= maxW and h * (scale + 1) <= maxH do
		scale = scale + 1
	end

	return scale
end

--------------------------------------------------
return m
