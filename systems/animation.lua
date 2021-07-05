tiny = require("libraries.tiny")

local animation = tiny.processingSystem()
animation.filter = tiny.requireAll("sprite", "animation")

function animation:process(entity, dt)
	if not entity.animation then return end

	fr = entity.animation.duration:fraction()
	if entity.animation.duration:move(-dt) then
		entity.sprite = entity.animation.frames[
			1 + math.floor(fr * #entity.animation.frames)
		]
	else
		entity.sprite = entity.animation.ending_sprite
		entity.animation = nil
	end
end

return animation