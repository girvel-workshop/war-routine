return (require "aspects.action"):new(
	"disarm", "armed", "normal", nil, {start = function(entity) return entity.arming_time end}
)