return fnl.entity[[eros.units.unit]]({
	power = 2300,
	fire_time = .12,
	bullets = limited:full(30),
	bullets_other = 90,
	sprite = tk.require("assets.sprites.weapons.default"),
	cluster = require_all("assets.sprites").weapons, -- FIXME
	visible = false,
	animations = require_all("assets.animations").weapons.default,
	skills = {
		fire = .05,
	}
	-- anchor = vector:new(20, 0) TODO anchor
})
-- TODO move to units