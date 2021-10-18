--- Toolkit module, containing all the unclassified functionality
local tk = {}

local string = string or getmetatable('').__index

--- Converts lua path to posix format
function string:to_posix()
  local str = self:gsub("%.", "/")
  return str
end

--- Sets metatable and returns both an object & the metatable
function tk.setmetatable(object, mt)
  return setmetatable(object, mt), mt
end

--- Creates a tree: the table, who creates subtables when __index
function tk.tree()
  return setmetatable({}, {
    __index=function(self, index)
      self[index] = tk.tree()
      return self[index]
    end
  })
end

--- Gets a custom tree path
function tk.get(tree_, head, ...)
  if tree_ == nil then
    return
  end

  if head == nil then
    return tree_
  end

  return tk.get(tree_[head], ...)
end

--- Sets a value of the tree by a variadic path
function tk.set(tree_, value, head, ...)
  if #{...} == 0 then
    tree_[head] = value
    return value
  end

  if not tree_[head] and #{...} > 0 then
    tree_[head] = {}
  end

  return tk.set(tree_[head], value,...)
end

return tk
