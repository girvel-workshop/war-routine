return (require "aspects.action"):new(
	"arm", "normal", "armed", nil, {start = function(entity) return entity.arming_time end}
)