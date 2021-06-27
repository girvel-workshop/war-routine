vector = {}

function vector:new(x, y)
	local v={x=x, y=y}
	setmetatable(v, self)
	self.__index = self
	return v
end

function vector.__add(v, u)
	return vector:new(v.x + u.x, v.y + u.y)
end	

function vector.__mul(v, angle)
	return vector:new(v.x * angle, v.y * angle)
end

vector.zero = function()
	return vector:new(0, 0)
end