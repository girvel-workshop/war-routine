local sprites = require_all("assets.sprites")
local animations = require_all("assets.animations")
local weapons = require_all("assets.weapons")

return tk.concat(require "assets.units.abstract.character", {
  sprite = sprites.soldier_normal,
  cluster = {
    normal = sprites.soldier_normal,
    armed = sprites.soldier_armed
  },
  animations = {
    fire = animations.soldier_fire
  },
  weapon = weapons.default,
  fire_source = tk.vector:new(-54, -16)
})