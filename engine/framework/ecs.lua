--- ECS framework, based on girvel's vision
local ecs = {}

local fnl = require 'fnl'


-- ecs.system = function(t) add cache end
-- ecs.metasystem = ecs.system
--   .add: adds entity or system
--   .update: switch system_cache to a given system type & update
--   .register: add entities to a new system & cache it
--   .process: update(system, ...)


--- Tool to brute-force entities
-- @return arguments for :process packed in a table; returned table is reused for optimization purposes, copy before
-- changing outside!
-- TODO make it use filter.repeat_pairs
local iterate_targets = function(targets, delta)
  -- early exit if targets is {} and there should be only one iteration
  if #targets == 0 then
    return fnl.static(delta or {})
  end

  -- early exit if one of the collections of the targets is empty
  if targets/fnl.any(function(_, t) return #t == 0 end) then
    return fnl.static()
  end

  local args = {}
  for i, target_collection in ipairs(targets) do
    args[i] = target_collection[1]
  end
  for i, delta_element in ipairs(delta) do
    args[#targets + i] = delta_element
  end

  local indices = {0}
  for i = 2, #targets + #delta do
    indices[i] = 1
  end

  return function()
    indices[1] = indices[1] + 1
    for i = 1, #indices - 1 do
      if indices[i] <= #targets[i] then
        break
      end

      indices[i] = 1
      indices[i + 1] = indices[i + 1] + 1
    end
  end
end

--- Makes table a system
ecs.system = function(t)
  t.system_targets = t.filters/fnl.map(function() return {} end)
  return t
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

-- [[ OBSOLETE ]]

ecs.metasystem = ecs.system {
  name = 'ecs.metasystem',
  all_systems = {},
  systems = {},

  register = function(self, entity, ...)
    if entity == nil then return end


  end,
  process = function(self, system_type, ...)
    for i, system in ipairs(self.systems[system_type]) do -- this is system's loop
      system:update(...)
    end
  end
}

-- [[ END OF OBSOLETE ]]

return ecs