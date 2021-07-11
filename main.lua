tk = require "libraries.girvel.toolkit"
fnl = require "libraries.girvel.functional"
vector = require "libraries.girvel.vector"

require_all = tk.require_all
inspect = require "libraries.inspect"

if arg[2] == "test" then
	arg = {}
	result = pcall(function() require("tests.main") end)
	love.event.quit(result)
else
	require("game")
end