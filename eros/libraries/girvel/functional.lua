local fnl = {}

fnl.pipe = decorator:new(function(_, f)
	return function(...)
		return setmetatable({args = {...}}, {
			__div = function(table, self)
				return f(table, unpack(self.args))
			end
		})
	end
end)

fnl.filter = fnl.pipe() .. function(t, predicate)
	result = {}
	for _, v in pairs(t) do
		if predicate(v) then
			table.insert(result, v)
		end
	end
	return result
end

fnl.values = fnl.pipe() .. function(t)
	result = {}
	for k, v in pairs(t) do
		table.insert(result, v)
	end
	return result
end

function fnl.remove(table_, value)
	for i, v in ipairs(table_) do
		if v == value then
			table.remove(table_, i)
			return true
		end
	end
	return false
end

-- fnl.extend = fnl.pipe() .. function(table1, table2) -- TODO
function fnl.extend(table1, table2)
	result = table1 / fnl.copy()
	for k, v in pairs(table2) do
		result[k] = v
	end
	return result
end

fnl.copy = nil
fnl.copy = fnl.pipe() .. function(t, cache, not_deep)
	if t == nil then return nil end

	if type(t) ~= "table" then return t end
	if not cache then cache = {} end
	if cache[t] then return cache[t] end

	if t.copy ~= nil then
		return t:copy()
	end

	local result = {}

	setmetatable(result, getmetatable(t))
	cache[t] = result

	for k, v in pairs(t) do
		if not_deep or type(v) ~= "table" then
			result[k] = v
		else
			result[k] = v / fnl.copy(cache)
		end
	end
	return result
end

fnl.inherit = fnl.pipe() .. function(child, parent)
	setmetatable(child, parent)
	parent.__index = parent
	return child
end

fnl.contains = fnl.pipe() .. function(collection, element)
	return #(collection / fnl.filter(function(v) return v == element end)) > 0
end

return fnl