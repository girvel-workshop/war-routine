local sprite = require("eros.aspects.sprite")

local drawing = tiny.sortedProcessingSystem({drawing_system_flag = true})
drawing.filter = tiny.requireAll("sprite", "position")

function drawing:compare(e1, e2)
	return e1.layer < e2.layer
end

function drawing:preProcess(_)
	love.graphics.setBackgroundColor(.75, .75, .75)
end

function drawing:process(entity, _)
	if not entity.sprite then return end

	local anchor = sprite.get_anchor(entity)

	love.graphics.draw(
		entity.sprite,
		entity.position.x, entity.position.y,
		entity.rotation, 
		1, 1, 
		anchor:unpack()
	)
end

return drawing