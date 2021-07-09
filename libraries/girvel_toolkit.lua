require("love.filesystem")

local toolkit = {}

function toolkit.copy(t)
	if t.copy ~= nil then
		return t:copy()
	end

	local u = {}
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

function toolkit.require_all(directory)
	path = directory:gsub("%.", "/")
  if not love.filesystem.getInfo(path) then return end
  
  local module = {}
  
  for _, file in ipairs(love.filesystem.getDirectoryItems(path)) do
    if love.filesystem.getInfo(directory:gsub("%.", "/") .. "/" .. file, 'file') then
      module[file:gsub(".lua", "")] = require(directory .. "." .. file:gsub(".lua", ""))
    else
      module[file] = toolkit.require_all(directory .. "." .. file)
    end
  end

  return module
end

toolkit.loop = {}

function toolkit.loop:new(collection, index)
	index = index or 1
	obj={collection=collection, index=index, value=collection[index]}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function toolkit.loop:next()
	self.index = self.index + 1
	
	if self.index > #self.collection then 
		self.index = 1
	end

	self.value = self.collection[self.index]
	return self.value
end

toolkit.limited = {}

function toolkit.limited:new(limit, value, lower_limit)
	obj = {limit=limit, value=value or limit, lower_limit=lower_limit or 0}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function toolkit.limited:move(delta)
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
end

function toolkit.limited:is_min()
	return self.value == self.lower_limit
end

function toolkit.limited:fraction()
	return (self.limit - self.value) / (self.limit - self.lower_limit)
end

toolkit.vector = {}

function toolkit.vector:new(x, y)
	local v={x=x, y=y}
	setmetatable(v, self)
	self.__index = self
	return v
end

function toolkit.vector:rotated(angle)
	return toolkit.vector:new(
		math.cos(angle) * self.x - math.sin(angle) * self.y, 
		math.sin(angle) * self.x + math.cos(angle) * self.y
	)	
end

function toolkit.vector:unpack()
	return self.x, self.y
end

function toolkit.vector.__unm(v)
	return v * -1
end

function toolkit.vector.__add(v, u)
	return toolkit.vector:new(v.x + u.x, v.y + u.y)
end	

function toolkit.vector.__sub(v, u)
	return v + -u
end

function toolkit.vector.__mul(v, k)
	return toolkit.vector:new(v.x * k, v.y * k)
end

function toolkit.vector.__div(v, k)
	return v * (1 / k)
end

function toolkit.vector:zero()
	return toolkit.vector:new(0, 0)
end

function toolkit.vector:right()
	return toolkit.vector:new(1, 0)
end

function toolkit.vector:left()
	return toolkit.vector:new(-1, 0)
end

function toolkit.vector:one()
  return toolkit.vector:new(1, 1)
end

return toolkit