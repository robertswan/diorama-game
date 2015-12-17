--------------------------------------------------
local m = {}

--------------------------------------------------
function m.CopyTo (dst, src)
	for key, value in pairs (src) do
		dst [key] = value
	end
end

--------------------------------------------------
function m.CopyToAndBackupParents (dst, src)
	dst.parent = {}
	for key, value in pairs (src) do
		dst.parent [key] = dst [key]
		dst [key] = value
	end	
end

--------------------------------------------------
return m