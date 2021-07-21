local cluster = require_all("assets.sprites").weapons -- TODO wtf?!

return fnl.extend(require("eros.units.unit"), { -- TODO eDSL
	power = 2300,
	fire_time = .12,
	bullets = limited:full(30),
	bullets_other = 90,
	sprite = cluster.default, -- TODO eDSL for require_all
	cluster = cluster, -- FIXME
	visible = false,
	animations = require_all("assets.animations").weapons.default,
	skills = {
		fire = .05,
	}
	-- anchor = vector:new(20, 0) TODO anchor
})
-- TODO move to units