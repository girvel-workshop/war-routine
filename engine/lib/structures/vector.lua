--- Library structure to work with vectors; 2D vectors are preferred.
local vector, module_mt = require("tk").setmetatable({}, {})
local vector_constants = {}

local vector_methods = {}
local vector_mt = {

}

local fnl = require 'fnl'
require('env').fix()

-- [[ MODULE OPERATORS ]]

--- Creates vector w/ varargs
module_mt.__call = function(self, ...)
  return setmetatable({
    dimensions={
      x=1,
      y=2,
      z=3,
      w=4
    },
    ...
  }, vector_mt)
end

--- Returns constants
module_mt.__index = vector_constants

-- [[ VECTOR METHODS ]]

--- Calculates vector's squared magnitude (for optimization purposes)
vector_methods.squared_magnitude = function(self)
  return self / fnl.map(function(k, v) return v^2 end) / fnl.fold "+"
end

--- Calculates vector's magnitude
vector_methods.magnitude = function(self)
  return self:squared_magnitude() ^ 0.5
end

--- Rotates 2D vector
vector_methods.rotated = function(self, angle)
  assert(#self == 2, "Vector should be two-dimensional")
  return vector(
    math.cos(angle) * self.x - math.sin(angle) * self.y,
    math.sin(angle) * self.x + math.cos(angle) * self.y
  )
end

-- [[ VECTOR OPERATORS -- ESSENTIAL ]]

--- Allows to get v[1], v[2], ... as v.x, v.y, ...
vector_mt.__index=function(self, index)
  return rawget(self, self.dimensions[index]) or vector_methods[index]
end

--- Adds two vectors
vector_mt.__add = function(v, u)
  assert(#v == #u, "added vectors should have the same size")
  return vector(table.unpack(
    v / fnl.map(function(i, x) return x + u[i] end)
  ))
end

--- Multiplies vector by a number
vector_mt.__mul = function(v, k)
  return vector(table.unpack(
    v / fnl.map(function(i, x) return x * k end)
  ))
end

-- [[ VECTOR OPERATORS -- SHORTCUTS ]]

--- Negates vector
vector_mt.__unm = function(v) return v * -1 end

--- Substracts one vector by another
vector_mt.__sub = function(v, u) return v +- u end

-- [[ MODULE CONSTANTS ]]

fnl.extend_mut(vector_constants, {
  zero=vector(0, 0),
  right=vector(1, 0),
  left=vector(-1, 0),
  up=vector(0, -1),
  down=vector(0, 1),
  one=vector(1, 1)
})

-- [[ MAKE CONSTANTS IMMUTABLE ]]

module_mt.__newindex = function()
  error "You should not change this module outside of it"
end

return vector