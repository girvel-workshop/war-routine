return (require "aspects.action"):new(
	"disarm", "armed", "normal", "disarm", {start = function(entity) return entity.arming_time end}
)