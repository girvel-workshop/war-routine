require("love.filesystem")

local toolkit = {}

function string:startswith(prefix) -- TODO replace w/ strong
	return self:sub(1, #prefix) == prefix
end

function string:endswith(postfix)
	return postfix == "" or self:sub(-#postfix) == postfix
end

function toolkit.values(t)
	result = {}
	for k, v in pairs(t) do
		table.insert(result, v)
	end
	return result -- TODO move to functional
end

function toolkit.remove(table_, value) -- TODO move to functional
	for i, v in ipairs(table_) do
		if v == value then
			table.remove(table_, i)
			return true
		end
	end
	return false
end

function toolkit.copy(t, cache)
	if t == nil then return nil end

	if type(t) ~= "table" then return t end
	if not cache then cache = {} end
	if cache[t] then return cache[t] end

	if t.copy ~= nil then
		return t:copy()
	end

	local u = {}
	for k, v in pairs(t) do 
		u[k] = toolkit.copy(v, cache) 
	end

	local result = setmetatable(u, getmetatable(t))
	cache[t] = result
	return result
end

function toolkit.concat(table1, table2)
	result = toolkit.copy(table1)
	for k, v in pairs(table2) do
		result[k] = v -- TODO copy here
	end
	return result -- TODO to functional & rename to extend
end

local default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

function toolkit.require_all(directory, parent_represent) -- TODO cache
	local path = directory:gsub("%.", "/")
  if not love.filesystem.getInfo(path) then return end
  
  local module = {}

  local items = love.filesystem.getDirectoryItems(path)

  local represent = #fnl.filter(items, function(value) return value == "_representation.lua" end) > 0 
  	and require(directory .. "._representation")
  	or parent_represent or default_represent
  
  for _, file in ipairs(items) do
  	if not file:startswith("_") then
  		local value = nil
  		if file:endswith("." .. represent.extension) then
  			value = represent.repr(path .. "/" .. file)
  		elseif not love.filesystem.getInfo(path .. "/" .. file, 'file') then
  			value = toolkit.require_all(path:gsub("/", ".") .. "." .. file, represent)
  		end
  		module[file:gsub("%.[%w%d]*", "")] = value
  	end
  end

  return module
end

toolkit.loop = {} -- TODO to separate file

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

toolkit.limited = {} -- TODO to separate file

function toolkit.limited:empty(limit, value, lower_limit) -- TODO tk.inherit
	obj = {limit=limit, value=value or 0, lower_limit=lower_limit or 0}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function toolkit.limited:full(limit, value, lower_limit)
	return self:empty(limit, value or limit, lower_limit or 0)
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
	return (self.value - self.lower_limit) / (self.limit - self.lower_limit)
end

return toolkit