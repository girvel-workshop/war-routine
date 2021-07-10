tk = require "libraries.girvel_toolkit"
require_all = tk.require_all

if arg[2] == "test" then
	arg = {}
	result = pcall(function() require("tests.main") end)
	love.event.quit(result)
else
	require("game")
end