local vector = {}

function vector:new(x, y)
	local v={x=x, y=y}
	setmetatable(v, self)
	self.__index = self
	return v
end

function vector:magnitude()
	return (self.x ^ 2 + self.y ^ 2) ^ .5
end

function vector:rotated(angle)
	return vector:new(
		math.cos(angle) * self.x - math.sin(angle) * self.y, 
		math.sin(angle) * self.x + math.cos(angle) * self.y
	)	
end

function vector:unpack()
	return self.x, self.y
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

function vector.__mul(v, k)
	return vector:new(v.x * k, v.y * k)
end

function vector.__div(v, k)
	return v * (1 / k)
end

function vector.zero()
	return vector:new(0, 0)
end

function vector.right()
	return vector:new(1, 0)
end

function vector.left()
	return vector:new(-1, 0)
end

function vector.up()
	return vector:new(0, -1)
end

function vector.one()
  return vector:new(1, 1)
end

return vector