--------------------------------------------------
local m = {}

--------------------------------------------------
function m.CopyTo (dst, src)
	for key, value in pairs (src) do
		dst [key] = value
	end
end

--------------------------------------------------
return m