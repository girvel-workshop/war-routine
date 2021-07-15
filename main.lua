tk = require("eros.libraries.girvel.toolkit")
fnl = require("eros.libraries.girvel.functional")
vector = require("eros.libraries.girvel.vector")

require_all = tk.require_all

inspect = require("eros.libraries.inspect")
tiny = require("eros.libraries.tiny")
gamera = require("eros.libraries.gamera")

if arg[2] == "test" then
	arg = {}
	result = pcall(function() require("tests.main") end)
	love.event.quit(result)
else
	require("game")
end