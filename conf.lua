function love.conf(c)
	c.identity = "war-routine"
	c.appendidentity = true
	c.console = arg[2] == "--debug"

	c.window.title = "War routine"
	c.window.icon = nil
	c.window.borderless = true
end