return fnl.extend(require("eros.units.physical"), { -- TODO eDSL
	power = 2300,
	fire_time = .12,
	bullets = limited:full(30),
	bullets_other = 90,
	sprite = require_all("assets.sprites").weapons.default,
	visible = false,
	-- anchor = vector:new(20, 0)
})