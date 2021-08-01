require "strong"
local exception = require "eros.libraries.girvel.exception"
local tk = require "eros.libraries.girvel.toolkit"

return function(text)
	tk.push_environment(_ENV or getfenv())

  local a, b = text:find(" %-> ")
  local args = text:sub(0, a - 1)
  local result = text:sub(b + 1)  
  
  local function_text = "function(%s) return %s end" % {args, result}
  local loading_function = load("return " .. function_text)
  
  if loading_function == nil then
    exception.throw{author = "girvel.lambda", message = "Incorrect lambda `%s`" % function_text}
    -- TODO auto author
  end
  
  return loading_function()
end