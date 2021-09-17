local drawing = {}

function drawing.get_anchor(entity)
	return entity.anchor 
		or entity.sprite and vector(entity.sprite:getWidth(), entity.sprite:getHeight()) * .5
		or vector.zero
end

return drawing