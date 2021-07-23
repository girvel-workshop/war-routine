local decorator = {}

function decorator:new(f)
	return fnl.inherit(self, {_function = f})
end

function decorator:__call(...)
	return setmetatable({args = {...}}, {
		__concat = function(self1, other)
			return self._function(other, unpack(self1.args))
		end
	})
end

return decorator