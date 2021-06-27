drawing = tiny.processingSystem()
drawing.filter = tiny.requireAll("sprite", "position")

function drawing:process(e, _)
	love.graphics.draw(
		e.sprite,
		e.position.x, e.position.y,
		e.rotation, 
		1, 1, 
		e.sprite_anchor and e.sprite_anchor.x or e.sprite:getWidth() / 2,
		e.sprite_anchor and e.sprite_anchor.y or e.sprite:getHeight() / 2
	)
end