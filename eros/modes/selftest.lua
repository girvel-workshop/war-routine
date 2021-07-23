arg = {}
result = pcall(function() require("eros.tests") end)
love.event.quit(result)