--- Library containing functions to work with lua environments
local env = {}

--- Removes compatibility issues
env.fix = function()
  table.unpack = unpack or table.unpack
  unpack = table.unpack
end

env.fix()

-- TODO make it work at lua5.2+
--- Pushes upper local variables into the current scope
env.push = function(delta)
  local env_ = getfenv(2)
  local i = 1
  while true do
    local name, value = debug.getlocal(3 + (delta or 0), i)
    if not name then return end
    env_[name] = value
    i = i + 1
  end
end

local function get_last_index(x)
  local mt = getmetatable(x)

  if mt == nil or mt.__index == nil then
    return x
  end

  return get_last_index(mt.__index)
end

--- Makes names from the given table available inside the given function
env.append = function(env_, f, ...)
  local last_index = get_last_index(_G)

  local result
  local mt = getmetatable(last_index)
  if mt == nil then
    setmetatable(last_index, {__index= env_, __newindex= env_})
    result = f(...)
    setmetatable(last_index, nil)
  else
    old_index = mt.__index
    old_newindex = mt.__newindex

    mt.__index = env_
    mt.__newindex = env_

    result = f(...)

    mt.__index = old_index
    mt.__newindex = old_newindex
  end

  return result
end

--- Isolates environment to the given one
env.use = function(env_, f, ...)
  local old_env = _G
  _G = env_
  local result = f(...)
  _G = old_env
  return result
end

return env
