--- Library containing all the syntax changing functions
local syntax = {}

local environment = require "env"
environment.fix()
require "strong"

local decorator_factory = function(f)
  return setmetatable({function_=f},{  -- decorator
    __call = function(decorator, ...)
      return setmetatable({decorator=decorator, args={...}}, {  -- called decorator
        __concat = function(called_decorator, value)
          return called_decorator.decorator:function_(value, unpack(called_decorator.args))
        end
      })
    end
  })
end

--- Creates a decorator from the given function
-- @param f base function(decorator, decorated, decoration_args...)
syntax.decorator = decorator_factory(function(_, f)
  return decorator_factory(f)
end)

--- Decorator making the function f(x, ...) a piped one with syntax x / f(...)
syntax.pipe = syntax.decorator() .. function(_, f)
  return setmetatable({base_function=f}, {__call = function(called, ...)
    return setmetatable({base_function=called.base_function, args={...}}, {
      __div = function(x, divided)
        return divided.base_function(x, table.unpack(divided.args))
      end
    })
  end})
end

--- Dynamically creates a function from lambda-string <args> -> <result>
-- @param source lambda source code
syntax.lambda = function(source)
  environment.push()

  local a, b = source:find(" %-> ")
  local args = source:sub(0, a - 1)
  local result = source:sub(b + 1)

  local function_text = "function(%s) return %s end" % {args, result}
  local loading_function, err = (loadstring or load)("return " .. function_text)

  if loading_function == nil then
    error(err)
  end

  return loading_function()
end

--- Decorator, making Nth argument an implicit lambda
-- If the Nth argument to the decorated function is a string, it is automatically
-- parsed to be an implicit lambda with given arguments
syntax.implicit_lambda = syntax.decorator() ..
function(_, f, argument_index, args_definition)
  return function(...)
    local args = {...}
    if type(args[argument_index]) == "string" then
      args[argument_index] = syntax.lambda(
        args_definition .. " -> " .. args[argument_index]
      )
    end

    return f(unpack(args))
  end
end

return syntax