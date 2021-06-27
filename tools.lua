vmath = require("vmath")
tools = {}

function tools.get_anchor(entity)
	return entity.anchor 
		or entity.sprite and vmath.vector:new(entity.sprite:getWidth(), entity.sprite:getHeight()) / 2 
		or vmath.vector:zero()
end

return tools