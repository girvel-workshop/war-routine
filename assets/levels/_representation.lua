return {
	repr = function(path)
		return eros.aspects.level():new(eros.libraries.girvel.module().default_represent)
	end,
	extension = "lua"
}