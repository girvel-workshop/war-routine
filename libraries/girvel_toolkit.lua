require "love.filesystem"

function copy(t)
	local u = {}
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

local toolkit = {}

function toolkit.require_all(directory)
	local module = {}

	for _, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
		name = string.gsub(file, ".lua", "")
		module[name] = require(directory .. "." .. name)
	end

	return module
end

toolkit.loop = {}

function toolkit.loop:new(collection, index)
	index = index or 1
	obj={collection=collection, index=index, value=collection[index]}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function toolkit.loop:next()
	self.index = self.index + 1
	
	if self.index > #self.collection then 
		self.index = 1
	end

	self.value = self.collection[self.index]
	return self.value
end

toolkit.limited = {}

function toolkit.limited:new(limit, value, lower_limit)
	obj = {limit=limit, value=value or limit, lower_limit=lower_limit or 0}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function toolkit.limited:move(delta)
	if delta < 0 then
		if self.value > 0 then
			self.value = math.max(self.lower_limit, self.value + delta)
			return true
		end

		return false
	else
		if self.value < self.limit then
			self.value = math.min(self.limit, self.value + delta)
			return true
		end

		return false
	end
end

function toolkit.limited:is_min()
	return self.value == self.lower_limit
end

return toolkit