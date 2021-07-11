tiny = require("libraries.tiny")

local looking = tiny.processingSystem()
looking.filter = tiny.requireAll("look")

function looking:process(entity, _)
	local at = entity.look()
  entity.rotation = math.atan2(entity.position.y - at.y, entity.position.x - at.x)
end

return looking