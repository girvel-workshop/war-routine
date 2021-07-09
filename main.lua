if arg[2] == "test" then
	arg = {}
	result = pcall(function() require("tests.main") end)
	love.event.quit(result)
else
	require("game")
end