return tk.concat(require "assets.units.abstract.unit", {
  stamina = tk.limited:new(5),
  reload_time = 1.5,
  arming_time = 1.3,
  legs = require "assets.units.legs",
  follows = false
})