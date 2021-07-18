return tk.concat(tiny.processingSystem(), {
	name = "systems.following",
	filter = tiny.requireAll("follows"),

	process = function(self, entity, dt)
		if not entity.follows then return end
		entity.position = entity.follows.position
	end
})
