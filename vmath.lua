vector = {}

function vector:new(x, y)
	local v={x=x, y=y}
	setmetatable(v, self)
	self.__index = self
	return v
end

function vector:rotated(angle)
	return vector:new(
		math.cos(angle) * self.x - math.sin(angle) * self.y, 
		math.sin(angle) * self.x + math.cos(angle) * self.y
	)	
end

function vector.__unm(v)
	return v * -1
end

function vector.__add(v, u)
	return vector:new(v.x + u.x, v.y + u.y)
end	

function vector.__sub(v, u)
	return v + -u
end

function vector.__mul(v, angle)
	return vector:new(v.x * angle, v.y * angle)
end

vector.zero = function()
	return vector:new(0, 0)
end

vector.right = function()
	return vector:new(1, 0)
end

vector.left = function()
	return vector:new(-1, 0)
end