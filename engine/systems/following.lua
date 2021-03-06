return tiny.processingSystem {
	name = "systems.following",
	system_type = 'update',
	filter = tiny.requireAll("follows"),

	process = function(_, entity, _)
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