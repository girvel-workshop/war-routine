return {
	repr = function(path)
		return engine.aspects.level()(module.default_represent.repr(path))
	end,
	extension = "lua"
}
