return fnl.extend(tiny.processingSystem(), {
	name = "systems.following",
	filter = tiny.requireAll("follows"),

	process = function(self, entity, dt)
		if not entity.follows then return end

		entity.position = fnl.copy(entity.follows.position)
		if entity.rotation and entity.follows.rotation then
			entity.rotation = entity.follows.rotation
		end
	end
})