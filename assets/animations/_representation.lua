local aspects = require_all("eros.aspects")
return {
	repr = function(path)
		return aspects.animation:new(path)
	end,
	extension = "anm"
}