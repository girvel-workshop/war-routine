tiny = require("libraries.tiny")

moving = tiny.processingSystem()
moving.filter = tiny.requireAll("velocity", "position")

function moving:process(e, dt)
	e.position = e.position + e.velocity * dt
end