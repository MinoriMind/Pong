local
function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end

local
function split(s, delimiter)
	result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end


utils = {clamp = clamp,
         split = split}

return utils



