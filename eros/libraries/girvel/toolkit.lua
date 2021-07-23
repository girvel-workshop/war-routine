local tk = {}

tk.cache = decorator:new(function(self, f) 
  return function(argument)
    if not self.global_cache[f] then
      self.global_cache[f] = {}
    end

    if not self.global_cache[f][argument] then
      self.global_cache[f][argument] = f(argument)
    end
    
    return self.global_cache[f][argument]
  end
end)

tk.cache.global_cache = {}

function string:to_posix()
  local str = self:gsub("%.", "/")
  return str
end

local default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

tk.require_all = tk.cache() .. function(luapath) -- TODO to module module
  if not love.filesystem.getInfo(luapath:to_posix()) then return end
  
  local module = {}

  local represent = tk.get_represent_for_path(luapath)
  
  for _, file in ipairs(love.filesystem.getDirectoryItems(luapath:to_posix())) do
  	if not file:starts_with("_") then
  		local value
  		if file:ends_with("." .. represent.extension) then
        value = tk.require(luapath .. "." .. file)
        file = file:gsub("%.[%w%d]*", "")
  		elseif not love.filesystem.getInfo(luapath:to_posix() .. "/" .. file, 'file') then
  			value = tk.require_all(luapath .. "." .. file)
  		end
  		module[file] = value
  	end
  end

  return module
end

tk.require = tk.cache() .. function(luapath)
  local represent = tk.get_represent_for_path(luapath)
  return represent.repr(luapath:to_posix() .. "." .. represent.extension)
end

function tk.get_represent_for_path(luapath)
  local path = ""
  local represent = default_represent

  for i, element in ipairs(luapath / ".") do
    path = i == 1 and element or (path .. "." .. element)
    
    represent = love.filesystem.getInfo(path:to_posix() .. "/_representation.lua") 
      and require(path .. "._representation")
       or represent
  end

  return represent
end

return tk