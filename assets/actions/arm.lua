return (require "aspects.action"):new(
	"arm", "normal", "armed", "arm", {start = function(entity) return entity.arming_time end}
)