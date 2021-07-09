local sprites = require "assets.content.sprites"
local animations = require "assets.content.animations"
local tk = require "libraries.girvel_toolkit"
local weapons = require_all("assets.content.weapons")

return {
  cluster = {
    normal = sprites.soldier_normal,
    armed = sprites.soldier_armed
  },
  sprite = sprites.soldier_normal,
  position = tk.vector:new(400, 300),
  velocity = tk.vector:zero(),
  fire_source = tk.vector:new(-54, -16),
  rotation = 0,
  speed = 250,
  run_multiplier = 1.5,
  weapon = weapons.default,
  stamina = tk.limited:new(5),
  action = false,
  reload_time = 1.5,
  arming_time = 1.3,
  animation = false,
  animations = {
    fire = animations.soldier_fire
  }
}