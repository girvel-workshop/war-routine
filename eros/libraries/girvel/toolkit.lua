local decorator = require[[eros.libraries.girvel.decorator]]

local tk = {}

tk.push_environment = function(env, delta)
  local i = 1
  while true do
    local name, value = debug.getlocal(3 + (delta or 0), i)
    if not name then return end
    env[name] = value
    i = i + 1
  end
end

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

local string = string or getmetatable('').__index
function string:to_posix()
  local str = self:gsub("%.", "/")
  return str
end

return tk