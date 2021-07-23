return fnl.entity[[eros.units.unit]]({
	power = 2300,
	fire_time = .12,
	bullets = limited:full(30),
	bullets_other = 90,
	sprite = -assets.sprites.weapons.default,
	cluster = -assets.sprites.weapons, -- TODO fixme
	visible = false,
	animations = -assets.animations.weapons.default,
	skills = {
		fire = .05,
	}
	-- anchor = vector:new(20, 0) TODO anchor
})
-- TODO move to units