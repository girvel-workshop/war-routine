return tiny.sortedProcessingSystem {
	name = 'systems.drawing',
	system_type = 'draw',
	filter = tiny.requireAll("sprite", "position"),

	compare = function(_, e1, e2) return e1.layer < e2.layer end,

	preProcess = function()
		love.graphics.setBackgroundColor(.75, .75, .75)

		game.camera.gamera:setPosition(unpack(game.camera.position))
		game.camera.gamera:setAngle(game.camera.rotation)
	end,

	process = function(_, entity)
		if not entity.sprite or entity.visible == false then return end

		local anchor = engine.aspects.sprite().get_anchor(entity)

		game.camera.gamera:draw(function(l, t, w, h) -- TODO optimization
			love.graphics.draw(
				entity.sprite,
				entity.position.x, entity.position.y,
				entity.rotation,
				1, 1,
				unpack(anchor)
			)
		end)
	end
}
