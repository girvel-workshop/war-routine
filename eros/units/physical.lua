return fnl.extend(require("eros.units.entity"), {
  name = "abstract.physical",

	position = vector:zero(),
  velocity = vector:zero(),
  rotation = 0,

  sprite = false,
  layer = 0,
  cluster = {}
})