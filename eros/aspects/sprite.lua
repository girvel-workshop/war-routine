local vector = require "libraries.girvel.vector"

local drawing = {}

function drawing.get_anchor(entity)
	return entity.anchor 
		or entity.sprite and vector:new(entity.sprite:getWidth(), entity.sprite:getHeight()) / 2 
		or vector:zero()
end

return drawing