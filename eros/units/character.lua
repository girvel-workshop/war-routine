local legs = assets.units.legs() / fnl.copy()

return fnl.extend(-eros.units.unit, {
  name = "abstract.character",

  stamina = limited:full(5),
  skills = {
    reload = 1.5,
    arm = 1.3,
    disarm = 1.3,
    fire = .1
  },
  legs = legs,
  follows = legs,

  layer = assets.config.layers().character,
})