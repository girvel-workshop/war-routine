return setmetatable({}, {
	__tostring = function(self)
		return "<entity %s>" % (self.name and inspect(self.name) or 'without name')
	end
})