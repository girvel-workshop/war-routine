local aspects = require_all("aspects")
return {
	repr = function(path)
		return aspects.animation:new(path)
	end,
	extension = "anm"
}