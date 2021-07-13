tiny = require("libraries.tiny")
sprite = require("aspects.sprite")

local drawing = tiny.processingSystem({drawing_system_flag = true})
drawing.filter = tiny.requireAll("sprite", "position")

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