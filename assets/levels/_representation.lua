return {
	repr = function(path)
		return eros.aspects.level():new(module.default_represent.repr(path))
	end,
	extension = "lua"
}
