local functional = {}

function functional.filter(t, predicate)
	result = {}
	for _, v in pairs(t) do
		if predicate(v) then
			table.insert(result, v)
		end
	end
	return result
end

return functional