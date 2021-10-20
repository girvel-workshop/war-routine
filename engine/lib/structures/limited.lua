--- Library structure to work with values locked in the predefined range
local limited, module_mt = require("tk").setmetatable({}, {})

local limited_mt = {__index={}}

--- Creates limited value
module_mt.__call = function(_, value, min, max)
  return setmetatable({
    value=value,
    min=min,
    max=max
  }, limited_mt)
end

--- Creates limited value set to minimal (default is 0)
limited.minimized = function(max, min)
  return limited(min or 0, min or 0, max)
end

--- Creates limited value set to maximal
limited.maximized = function(max, min)
  return limited(max, min or 0, max)
end

--- Try to move value and return success
limited_mt.__index.move = function(self, delta)
  if delta < 0 then
    if self.value > 0 then
      self.value = math.max(self.min, self.value + delta)
      return true
    end

    return false
  else
    if self.value < self.max then
      self.value = math.min(self.max, self.value + delta)
      return true
    end

    return false
  end
end

--- Is the value minimized
limited_mt.__index.is_min = function(self)
  return self.value == self.min
end

--- Is the value maximized
limited_mt.__index.is_max = function(self)
  return self.value == self.max
end

--- Get the value in [0; 1] indicating current state of the limited value
limited_mt.__index.fraction = function(self)
  return (self.value - self.min) / (self.max - self.min)
end

return limited