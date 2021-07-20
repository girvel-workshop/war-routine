local legs = tk.copy(require("assets.units.legs"))

return tk.concat(require "assets.units.abstract.unit", {
  name = "abstract.character",

  stamina = tk.limited:full(5),
  skills = {
    reload = 1.5,
    arm = 1.3,
    disarm = 1.3
  },
  legs = legs,
  follows = legs,

  layer = require("assets.config.layers").character
})