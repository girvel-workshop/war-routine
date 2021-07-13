return tk.concat(require "assets.units.abstract.unit", {
  run_multiplier = 1.5,
  speed = 250,

  animations = require_all("assets.animations").legs
})