if arg[2] == "test" then
	arg = {}
	require("tests.main")
else
	require("game")
end