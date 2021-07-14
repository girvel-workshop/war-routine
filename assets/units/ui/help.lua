return tk.concat(require("assets.units.abstract.physical"), {
	sprite = require_all("assets.sprites").ui.help,
	death_delay = tk.limited:new(15),
	rotation = -math.pi / 2
})