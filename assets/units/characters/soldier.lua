local sprites = require_all("assets.sprites")
local animations = require_all("assets.animations")
local weapons = require_all("assets.weapons")

local soldier = tk.entity[[eros.units.character]]({
  name = "characters.soldier",

  sprite = sprites.characters.soldier.normal,
  cluster = sprites.characters.soldier,
  animations = animations.characters.soldier,
  weapon = weapons.default,
  fire_source = vector:new(16, -54),

  get_parts = function(self)
    return {"legs", "weapon"}
  end
})

soldier.weapon.follows = soldier -- TODO eDSL
soldier.weapon.following_offset = soldier.fire_source + vector:new(0, 32) -- FIXME

return soldier