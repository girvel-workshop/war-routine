local fnl = {}

function fnl.filter(t, predicate)
	result = {}
	for _, v in pairs(t) do
		if predicate(v) then
			table.insert(result, v)
		end
	end
	return result
end

function fnl.values(t)
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

function fnl.extend(table1, table2)
	result = fnl.copy(table1)
	for k, v in pairs(table2) do
		result[k] = v
	end
	return result
end

function fnl.copy(t, cache, not_deep)
	if t == nil then return nil end

	if type(t) ~= "table" then return t end
	if not cache then cache = {} end
	if cache[t] then return cache[t] end

	if t.copy ~= nil then
		return t:copy()
	end

	local u = {}
	for k, v in pairs(t) do
		if not_deep then
			u[k] = v
		else
			u[k] = fnl.copy(v, cache)
		end
	end

	local result = setmetatable(u, getmetatable(t))
	cache[t] = result
	return result
end

function fnl.inherit(parent, child)
	setmetatable(child, parent)
	parent.__index = parent
	return child
end

return fnl