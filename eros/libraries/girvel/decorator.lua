local decorator = {}

function decorator:new(f)
	result = setmetatable({_function = f}, self)
	self.__index = self
	return result
end

function decorator:__call(...)
	return setmetatable({args = {...}}, {
		__concat = function(self1, other)
			return self:_function(other, unpack(self1.args))
		end
	})
end

return decorator