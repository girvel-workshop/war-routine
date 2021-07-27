return {
	empty = function(self, limit, value, lower_limit)
		return {
			limit=limit, value=value or 0, lower_limit=lower_limit or 0
		} / fnl.inherit(self)
	end,

	full = function(self, limit, value, lower_limit)
		return self:empty(limit, value or limit, lower_limit or 0)
	end,

	move = function(self, delta)
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
	end,

	is_min = function(self)
		return self.value == self.lower_limit
	end,

	fraction = function(self)
		return (self.value - self.lower_limit) / (self.limit - self.lower_limit)
	end
}