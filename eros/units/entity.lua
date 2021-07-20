return setmetatable({}, {
	__tostring = function(self)
		return "<entity " .. inspect(self.name) .. ">"
	end
})