local sprites = require_all("assets.sprites")
local animations = require_all("assets.animations")
local weapons = require_all("assets.weapons")

return fnl.extend(require("assets.units.abstract.character"), {
  name = "characters.soldier",

  sprite = sprites.characters.soldier.normal,
  cluster = sprites.characters.soldier,
  animations = animations.characters.soldier,
  weapon = weapons.default,
  fire_source = vector:new(-54, -16),
  radius = 34,

  get_parts = function(self)
    return {"legs"}
  end
})