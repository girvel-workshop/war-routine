--- Library for quick importing libraries and assets
local module = {}
local mt = {}
setmetatable(module, mt)

local lfs = require "lfs"
local fnl = require "fnl"
require "strong"
require "tk"

local function is_directory(path)
  return io.open(path) and lfs.attributes(path).mode == "directory"
end

local function is_file(path)
  return io.open(path) and lfs.attributes(path).mode == "file"
end

module.default_represent = {
  repr = function(path)
    return require(path:gsub(".lua", ""):gsub("/", "."))
  end,
  extension = "lua"
}

--- Creates wrapper for importing modules with the given root path
function mt:__call(path)
  return setmetatable({path = path}, {
    __index = function(self, item)
      return module(self.path .. "." .. item)
    end,
    __unm = function(self)
      local represent = module.get_represent_for_path(self.path)
      if not io.open(self.path:to_posix() .. "." .. represent.extension)
        and not io.open(self.path:to_posix()) then
        return
      end

      if io.open(self.path:to_posix() .. "." .. represent.extension) then
        return module.require(self.path)
      end

      return module.require_all(self.path)
    end,
    __call = function(self)
      return -self
    end
  })
end

module.require_all = fnl.cache() .. function(luapath)
  if not io.open(luapath:to_posix()) then return end
  
  local result = {}

  local represent = module.get_represent_for_path(luapath)
  
  for file in lfs.dir(luapath:to_posix()) do
    if not file:startsWith("_") and file ~= "." and file ~= ".." then
      local value
      if file:endsWith("." .. represent.extension) then
        file = file:sub(1, #file - #represent.extension - 1)
        value = module.require(luapath .. "." .. file)
      elseif is_directory(luapath:to_posix() .. "/" .. file, 'file') then
        value = module.require_all(luapath .. "." .. file)
      end
      result[file] = value
    end
  end

  return result
end

module.require = fnl.cache() .. function(luapath)
  local represent = module.get_represent_for_path(luapath)
  return represent.repr(luapath:to_posix() .. "." .. represent.extension)
end

function module.get_represent_for_path(luapath)
  local path = ""
  local represent = module.default_represent

  for i, element in ipairs(luapath / ".") do
    path = i == 1 and element or (path .. "." .. element)
    
    represent = is_file(path:to_posix() .. "/_representation.lua") 
      and require(path .. "._representation")
       or represent
  end

  return represent
end

return module
