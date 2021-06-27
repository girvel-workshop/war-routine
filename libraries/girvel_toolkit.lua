require "love.filesystem"

function require_all(directory)
	for _, lua in ipairs(love.filesystem.getDirectoryItems(directory)) do
		require("systems." .. string.gsub(lua, ".lua", ""))
	end
end

limited = {}

function limited:new(limit, value, lower_limit)
	obj = {limit=limit, value=value or limit, lower_limit=lower_limit or 0}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function limited:move(delta)
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