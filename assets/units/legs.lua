return fnl.extend(require "eros.units.unit", {
  name = "legs",

  run_multiplier = 1.5,
  speed = 250,
  rotation_speed = 2 * math.pi * 1,
  skills = {
    move = 0.5
  },

  radius = 25,

  animations = require_all("assets.animations").legs,
  cluster = {},
  layer = require("assets.config.layers").under_character
})