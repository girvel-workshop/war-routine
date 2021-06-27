local vmath = {}

vmath.vector = {}

function vmath.vector:new(x, y)
	local v={x=x, y=y}
	setmetatable(v, self)
	self.__index = self
	return v
end

function vmath.vector:rotated(angle)
	return vmath.vector:new(
		math.cos(angle) * self.x - math.sin(angle) * self.y, 
		math.sin(angle) * self.x + math.cos(angle) * self.y
	)	
end

function vmath.vector.__unm(v)
	return v * -1
end

function vmath.vector.__add(v, u)
	return vmath.vector:new(v.x + u.x, v.y + u.y)
end	

function vmath.vector.__sub(v, u)
	return v + -u
end

function vmath.vector.__mul(v, angle)
	return vmath.vector:new(v.x * angle, v.y * angle)
end

vmath.vector.zero = function()
	return vmath.vector:new(0, 0)
end

vmath.vector.right = function()
	return vmath.vector:new(1, 0)
end

vmath.vector.left = function()
	return vmath.vector:new(-1, 0)
end

return vmath