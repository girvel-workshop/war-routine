return tk.concat(require "assets.units.abstract.unit", {
  stamina = tk.limited:new(5),
  skills = {
    reload = 1.5,
    arm = 1.3,
    disarm = 1.3
  },
  legs = require "assets.units.legs",
  follows = false,

  layer = require("assets.config.layers").character
})