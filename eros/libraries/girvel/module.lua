local module = {}

module.default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

function module:new(path)
	return setmetatable({path = path}, {
		__index = function(self, item)
  		return module:new(self.path .. "." .. item)
		end,
		__unm = function(self)
			if love.filesystem.getInfo(self.path:to_posix(), 'directory') then
		    return module.require_all(self.path)
		  end
		  return module.require(self.path)
		end,
		__call = function(self)
			return -self
		end
	})
end

module.require_all = tk.cache() .. function(luapath)
  if not love.filesystem.getInfo(luapath:to_posix()) then return end
  
  local result = {}

  local represent = module.get_represent_for_path(luapath)
  
  for _, file in ipairs(love.filesystem.getDirectoryItems(luapath:to_posix())) do
  	if not file:startsWith("_") then
  		local value
  		if file:endsWith("." .. represent.extension) then
        file = file:gsub("%.[%w%d]*", "")
        value = module.require(luapath .. "." .. file)
  		elseif not love.filesystem.getInfo(luapath:to_posix() .. "/" .. file, 'file') then
  			value = module.require_all(luapath .. "." .. file)
  		end
  		result[file] = value
  	end
  end

  return result
end

module.require = tk.cache() .. function(luapath)
  local represent = module.get_represent_for_path(luapath)
  return represent.repr(luapath:to_posix() .. "." .. represent.extension)
end

function module.get_represent_for_path(luapath)
  local path = ""
  local represent = module.default_represent

  for i, element in ipairs(luapath / ".") do
    path = i == 1 and element or (path .. "." .. element)
    
    represent = love.filesystem.getInfo(path:to_posix() .. "/_representation.lua") 
      and require(path .. "._representation")
       or represent
  end

  return represent
end

return module