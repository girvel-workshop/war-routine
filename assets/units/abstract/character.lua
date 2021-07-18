return tk.concat(require "assets.units.abstract.unit", {
  name = "abstract.character",

  stamina = tk.limited:new(5),
  skills = {
    reload = 1.5,
    arm = 1.3,
    disarm = 1.3
  },
  legs = require "assets.units.legs",
  follows = require "assets.units.legs",
  rotation_speed = 2 * math.pi * 1,

  layer = require("assets.config.layers").character
})