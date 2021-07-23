local tk = {}

local default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

local cache = {} -- TODOLONG cache to decorator

function tk.require_all(directory) -- TODO to module module
	local path = directory:gsub("%.", "/")
  if not love.filesystem.getInfo(path) then return end

  if cache[directory] then return cache[directory] end
  
  local module = {}

  local represent = tk.get_represent_for_path(directory)
  
  for _, file in ipairs(love.filesystem.getDirectoryItems(path)) do
  	if not file:starts_with("_") then
  		local value = nil
  		if file:ends_with("." .. represent.extension) then
        value = cache[directory .. "." .. file:gsub("%.[%w%d]*", "")] or represent.repr(path .. "/" .. file)
        cache[directory .. "." .. file:gsub("%.[%w%d]*", "")] = value
  		elseif not love.filesystem.getInfo(path .. "/" .. file, 'file') then
  			value = tk.require_all(path:gsub("/", ".") .. "." .. file, represent)
  		end
  		module[file:gsub("%.[%w%d]*", "")] = value
  	end
  end

  cache[directory] = module
  return module
end

function tk.require(filepath, _parent_represent)
  if not cache[filepath] then -- TODOLONG cache decorator
    local represent = tk.get_represent_for_path(filepath)
    cache[filepath] = represent.repr(tk.to_posix(filepath) .. "." .. represent.extension)
  end
  return cache[filepath]
end

function tk.get_represent_for_path(fullpath, _parent_represent)
  local path = ""
  local represent = default_represent

  for i, element in ipairs(fullpath / ".") do
    path = i == 1 and element or (path .. "." .. element)
    
    represent = love.filesystem.getInfo(tk.to_posix(path) .. "/_representation.lua") 
      and require(path .. "._representation")
       or represent
  end

  return represent
end

function tk.module(path)
  return setmetatable({path = path}, {
    __index = function(self, item)
      return tk.module(self.path .. "." .. item)
    end,
    __unm = function(self)
      print("unm", self.path)
      if love.filesystem.getInfo(tk.to_posix(self.path), 'directory') then
        print("require_all", self.path)
        return tk.require_all(self.path)
      end
      return tk.require(self.path)
    end,
    __call = function(self)
      return -self
    end
  })
end

function tk.to_posix(path)
  return path:gsub("%.", "/")
end

return tk