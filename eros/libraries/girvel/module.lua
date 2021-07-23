local module = {}

module.default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

function module:new(path)
	return fnl.inherit(self, {path = path})
end

function module:__unm()
	if love.filesystem.getInfo(tk.to_posix(self.path), 'directory') then
    return self.require_all(self.path)
  end
  return self.require(self.path)
end

function module:__call()
	return -self
end

module.require_all = tk.cache() .. function(luapath)
  if not love.filesystem.getInfo(luapath:to_posix()) then return end
  
  local result = {}

  local represent = module.get_represent_for_path(luapath)
  
  for _, file in ipairs(love.filesystem.getDirectoryItems(luapath:to_posix())) do
  	if not file:starts_with("_") then
  		local value
  		if file:ends_with("." .. represent.extension) then
        value = module.require(luapath .. "." .. file)
        file = file:gsub("%.[%w%d]*", "")
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