local exception = {}

function exception.throw(ex)
	error(setmetatable(ex, {
		__tostring = function(self) return self.message end
	}))
end

return exception