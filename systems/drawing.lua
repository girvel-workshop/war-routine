tiny = require("libraries.tiny")
tools = require("tools")

drawing = tiny.processingSystem({drawing_system_flag = true})
drawing.filter = tiny.requireAll("sprite", "position")

function drawing:preProcess(_)
	love.graphics.setBackgroundColor(.75, .75, .75)
end

function drawing:process(e, _)
	local anchor = tools.get_anchor(e)

	love.graphics.draw(
		e.sprite,
		e.position.x, e.position.y,
		e.rotation, 
		1, 1, 
		anchor:unpack()
	)
end