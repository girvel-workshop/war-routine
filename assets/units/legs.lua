return tk.concat(require "assets.units.abstract.unit", {
  name = "legs",

  run_multiplier = 1.5,
  speed = 250,
  skills = {
    move = 0.5
  },

  animations = require_all("assets.animations").legs,
  layer = require("assets.config.layers").under_character
})