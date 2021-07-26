return {
	repr = function(path)
		return eros.aspects.level():new(eros.libraries.girvel.module().default_represent.repr(path))
	end,
	extension = "lua"
}