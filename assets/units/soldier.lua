local sprites = require_all("assets.sprites")
local animations = require_all("assets.animations")
local weapons = require_all("assets.weapons")

return tk.concat(require "assets.units.abstract.character", {
  sprite = sprites.soldier.normal,
  cluster = sprites.soldier,
  animations = {
    fire = animations.soldier_fire
  },
  weapon = weapons.default,
  fire_source = vector:new(-54, -16)
})