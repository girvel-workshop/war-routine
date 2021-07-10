return tk.concat(require "assets.content.abstract.unit", {
  speed = 250,
  run_multiplier = 1.5,
  stamina = tk.limited:new(5),
  reload_time = 1.5,
  arming_time = 1.3
})