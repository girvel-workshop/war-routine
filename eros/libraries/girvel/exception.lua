local exception = {}

function exception.throw(message)
	error(setmetatable(message, {
		__tostring = function(self) return message.message end
	}))
end

return exception