tk = require("libraries.girvel_toolkit")
local drawing = {}

function drawing.get_anchor(entity)
	return entity.anchor 
		or entity.sprite and tk.vector:new(entity.sprite:getWidth(), entity.sprite:getHeight()) / 2 
		or tk.vector:zero()
end

return drawing