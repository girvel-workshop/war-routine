--- ECS library
local ecs = {}

local fnl = require 'fnl'

-- [[ LOCAL FUNCTIONS ]]

--- Iterates through all the system's targets
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
    for member_i, entity_i in ipairs(indices) do
      result[keys[member_i]] = values[member_i][entity_i]
    end
    return result
  end
end

--- Tries to add entity to a system as a target, calls entity.register on success
local add = function(system, entity)
  for member_name, requirement in pairs(system.filters) do
    if requirement.components/fnl.all(function(_, c) return entity[c] ~= nil end) then
      table.insert(system.system_targets[member_name], entity)
      if system.register then system:register(entity, member_name) end
    end
  end
end

--- Brute-forces .process through all the targets
local update = function(system, delta)
  for members in iterate_targets(system.system_targets) do
    system:process(members, delta)
  end
end

-- TODO remove
-- TODO full testing

-- [[ MAIN STUFF ]]

ecs.make_system = function(system)
  return fnl.extend_mut(system, {
    system_targets = system.filters/fnl.map(function() return {} end)
  })
end

ecs.make_metasystem = function(metasystem)
  return ecs.make_system(fnl.extend_mut(metasystem, {
    filters = {
      system = {components = {'filters', 'process'}}
    },

    process = function(_, members, delta)
      if members.system.system_type ~= delta.system_type then return end
      update(members.system, delta)
    end,

    register = function(self, system)
      for _, entity in ipairs(self.ecs_entities) do
        add(system, entity)
      end
    end,

    ecs_entities = {},
    add = function(self, entity)
      table.insert(self.ecs_entities, entity)
      for _, system in ipairs(self.system_targets.system) do
        add(system, entity)
      end

      add(self, entity)
      return entity
    end,
    update = function(self, delta)
      update(self, delta)
    end
  }))
end

-- [[ LOCALS EXPORT ]]

--- Locals for testing purposes
ecs.locals = {
  iterate_targets = iterate_targets,
  add = add,
  update = update,
}

return ecs