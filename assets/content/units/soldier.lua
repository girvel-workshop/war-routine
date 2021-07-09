local sprites = require "assets.content.sprites"
local animations = require "assets.content.animations"
local tk = require "libraries.girvel_toolkit"
local weapons = require_all("assets.content.weapons")

return tk.concat(require "assets.content.abstract.character", {
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