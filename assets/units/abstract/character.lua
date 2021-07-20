local legs = fnl.copy(require("assets.units.legs"))

return fnl.concat(require "assets.units.abstract.unit", {
  name = "abstract.character",

  stamina = limited:full(5),
  skills = {
    reload = 1.5,
    arm = 1.3,
    disarm = 1.3
  },
  legs = legs,
  follows = legs,

  layer = require("assets.config.layers").character
})