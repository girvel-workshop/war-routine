return tiny.processingSystem()/fnl.extend{
	name = "systems.following",
	filter = tiny.requireAll("follows"),

	process = function(self, entity, dt)
		if not entity.follows then return end

		local offset = vector.zero
		if entity.following_offset then
			offset = entity.following_offset:rotated(entity.follows.rotation or 0)
		end

		entity.position = entity.follows.position + offset
		if entity.rotation and entity.follows.rotation then
			entity.rotation = entity.follows.rotation
		end
	end
}