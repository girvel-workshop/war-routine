--- ECS library
local ecs = {}

local fnl = require 'fnl'


-- [[ LOCAL FUNCTIONS ]]

--- iterates through all the system's targets
local iterate_targets = function(targets)
  local keys = {}
  local values = {}

  for k, v in pairs(targets) do
    table.insert(keys, k)
    table.insert(values, v)
  end

  local indices = {0}
  for i = 2, #values do
    indices[i] = 1
  end

  return function()
    indices[1] = indices[1] + 1
    for i = 1, #indices - 1 do
      if indices[i] <= #values[i] then
        break
      end

      indices[i] = 1
      indices[i + 1] = indices[i + 1] + 1
    end

    if indices[#indices] > #values[#values] then
      return
    end

    local result = {}
    for i, v in ipairs(indices) do
      result[keys[i]] = values[i][v]
    end
    return result
  end
end

--- Tries to add entity to a system as a target, calls entity.register on success
local add = function(system, entity)
  for i, requirement in ipairs(system.filters) do
    if requirement.components/fnl.all(function(_, c) return entity[c] ~= nil end) then
      table.insert(system.targets[i], entity)
      if system.register then system:register(entity, i) end
    end
  end
end

--- Brute-forces .process through all the targets
local update = function(system, delta)
  for args in iterate_targets(system.targets, delta) do
    system:process(unpack(args))
  end
end

-- [[ LOCALS EXPORT ]]

ecs.locals = {
  iterate_targets = iterate_targets,
  add = add,
  update = update,
}

return ecs