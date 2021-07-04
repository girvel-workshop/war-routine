tiny = require("libraries.tiny")

acting = tiny.processingSystem()
acting.filter = tiny.requireAll("action")

local actions = {
	fire = function(entity)
		tiny.add(world, {
			sprite = sprites.shell,
			position = entity.position + entity.fire_source:rotated(entity.rotation) / 2,
			rotation = entity.rotation
		})

		tiny.add(world, {
			sprite = sprites.bullet,
			position = entity.position + entity.fire_source:rotated(entity.rotation),
			rotation = entity.rotation,
			velocity = vmath.vector.left():rotated(entity.rotation) * 1000
		})
	end
}

function acting:process(entity, dt)
	if entity.action == false then return end

	local act = actions[entity.action.name]
	if act then
		if entity.action.duration:is_min() then
			act(entity)
		end

		if not entity.action.duration:move(-dt) then
			entity.action = false
		end
	end
end