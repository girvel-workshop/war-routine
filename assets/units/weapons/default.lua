return -engine.units.unit/fnl.extend{
	name = "weapons.default",
	power = 2300,
	fire_time = .12,
	bullets = limited.maximized(30),
	bullets_other = 90,
	sprite = -assets.sprites.weapons.default.normal,
	cluster = -assets.sprites.weapons.default,
	visible = false,
	animations = -assets.animations.weapons.default,
	skills = {
		fire = .05,
	}
	-- anchor = vector(20, 0) TODO anchor
}
-- TODO move to units