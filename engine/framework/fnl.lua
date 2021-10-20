--- Functional-style library
local fnl = {}

local syntax = require "syntax"
local tk = require "tk"


-- [[ STANDARD PIPED FUNCTIONS ]]

--- Filters the table by ipairs & predicate
fnl.filter = syntax.pipe() .. syntax.implicit_lambda(2, "k, v") ..
function(t, predicate)
  local result = {}
  for k, v in ipairs(t) do
    if predicate(k, v) then
      table.insert(result, v)
    end
  end
  return result
end

--- Maps the table by ipairs & function
fnl.map = syntax.pipe() .. syntax.implicit_lambda(2, "k, v") ..
function(t, f)
  local result = {}
  for k, v in ipairs(t) do
    table.insert(result, f(k, v))
  end
  return result
end

local binary_operators_to_functions = {
  ["+"] =   {function(a, b) return a + b end},
  ["-"] =   {function(a, b) return a - b end},
  ["*"] =   {function(a, b) return a * b end,   function(x) return x == 0 end},
  ["/"] =   {function(a, b) return a / b end},
  ["^"] =   {function(a, b) return a ^ b end,   function(x) return x == 1 end},
  [".."] =  {function(a, b) return a .. b end},
  ["and"] = {function(a, b) return a and b end, function(x) return not x end},
  ["or"] =  {function(a, b) return a or b end,  function(x) return x end},
  ["=="] =  {function(a, b) return a == b end},
  ["~="] =  {function(a, b) return a ~= b end}
}

--- Folds the table by given predicate or metamethod
-- @param f folding function
-- @param break_predicate condition of breaking return
fnl.fold = syntax.pipe() .. function(t, f, break_predicate)
  if #t == 0 then return end
  local result = t[1]

  if f == nil then
    f = function(a, b) return a .. b end
  elseif type(f) == "string" then
    if f:sub(1, 2) == "__" then
      f = getmetatable(result)[f]
    else
      f, break_predicate = table.unpack(binary_operators_to_functions[f])
    end
  end

  break_predicate = break_predicate or fnl.static(false)

  for i = 2, #t do
    if break_predicate(result) then
      return result
    end
    result = f(result, t[i])
  end
  return result
end

local to_boolean = function(_, x) return not not x end

--- Checks by ipairs whether all values in sequence are truthy
-- If f is given pre-maps table by f
fnl.all = syntax.pipe() ..
function(t, predicate)
  if predicate ~= nil then
    t = t / fnl.map(predicate)
  end

  return t / fnl.map(to_boolean) / fnl.fold "and"
end

--- Checks by ipairs whether any value in sequence is truthy
-- If f is given pre-maps table by f
fnl.any = syntax.pipe() ..
function(t, predicate)
  if predicate ~= nil then
    t = t / fnl.map(predicate)
  end

  return t / fnl.map(to_boolean) / fnl.fold "or"
end

--- Separates the table by ipairs & given separator
fnl.separate = syntax.pipe() ..
function(t, separator)
  if #t == 0 then return {} end

  local result = {t[1]}
  for i = 2, #t do
    table.insert(result, separator)
    table.insert(result, t[i])
  end
  return result
end

-- TODO optimization: pipe + ipairs
--- Slices the table by ipairs
fnl.slice = syntax.pipe() .. function(t, first, last, step)
  if last and last < 0 then
    last = #t + last + 1
  end

  local result = {}
  for i = first or 1, last or #t, step or 1 do
    table.insert(result, t[i])
  end
  return result
end

--- Returns pretty string representation of the value
fnl.inspect = syntax.pipe() .. require "inspect"

--- Piped unpack, does not work as piped in 5.1
fnl.unpack = syntax.pipe() .. table.unpack

--- Copies & extends one table by another
fnl.extend = syntax.pipe() .. function(self, ...)
  return fnl.extend_mut(self / fnl.copy(), ...)
end

--- Creates a copy of the given table
fnl.copy = nil
fnl.copy = syntax.pipe() .. function(t, cache, not_deep)
  if t == nil then return nil end

  if type(t) ~= "table" then return t end
  cache = cache or {}
  if cache[t] then return cache[t] end

  if t.copy ~= nil then
    return t:copy()
  end

  local result = {}

  setmetatable(result, getmetatable(t))
  cache[t] = result

  for k, v in pairs(t) do
    if not_deep or type(v) ~= "table" then
      result[k] = v
    else
      result[k] = v / fnl.copy(cache)
    end
  end
  return result
end

--- Checks by ipairs whether the table contains given value
fnl.contains = syntax.pipe() .. function(collection, element)
  return #(collection / fnl.filter(function(ix, it) return it == element end)) > 0
end

-- [[ CONVERSION PIPED FUNCTIONS ]]

--- Gets all the values by pairs & puts them into the sequence
fnl.values = syntax.pipe() .. function(t)
  result = {}
  for _, v in pairs(t) do
    table.insert(result, v)
  end
  return result
end

--- Transforms the sequence to a set
fnl.set = syntax.pipe() .. function(t)
  local result = {}
  for _, v in pairs(t) do
    result[v] = true
  end
  return result
end

-- [[ MUTATING FUNCTIONS ]]

--- Mutates the given table by removing the first occurrence of value
fnl.remove_mut = function(t, value)
  for i, v in ipairs(t) do
    if v == value then
      table.remove(t, i)
      return self
    end
  end
end

--- Mutates the given table by extending it by other tables
fnl.extend_mut = function(self, head, ...)
  if head == nil then
    return self
  end

  for k, v in pairs(head) do
    self[k] = v
  end

  return fnl.extend_mut(self, ...)
end

-- [[ FUNCTIONAL TOOLS ]]

--- Caches results for the given argument
fnl.cache = syntax.decorator() .. function(self, f)
  return function(...)
    return tk.get(self.global_cache, f, ...)
        or tk.set(self.global_cache, f(...), f, ...)
  end
end

fnl.cache.global_cache = {}

--- Generates clojure f() = x
fnl.static = function(x) return function() return x end end

-- [[ FUTURE FEATURES ]]

fnl.future = {}

fnl.future.range_generator = function(a, b, c)
  return setmetatable({}, {
    __index=function(_, index)
      if index < 1 or index > math.floor((b - a) / c) + 1 then
        return
      end

      return a + (index - 1) * c
    end
  })
end


return fnl