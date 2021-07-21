local moving = tiny.processingSystem()
moving.filter = tiny.requireAll("velocity", "position")

function moving:process(e, dt)
	if e.collision_with then return end
	e.position = e.position + e.velocity * dt
end

return moving