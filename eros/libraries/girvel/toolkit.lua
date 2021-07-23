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

return tk