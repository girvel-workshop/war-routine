return tiny.processingSystem {
	name = 'engine.systems.moving',
	system_type = 'update',
	filter = tiny.requireAll("velocity", "position"),

	process = function(_, e, dt)
		if e.collides_with then return end
		e.position = e.position + e.velocity * dt
	end
}

