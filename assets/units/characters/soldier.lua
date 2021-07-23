local soldier = fnl.extend(-eros.units.character, {
  name = "characters.soldier",

  sprite = -assets.sprites.characters.soldier.normal,
  cluster = -assets.sprites.characters.soldier,
  animations = -assets.animations.characters.soldier,
  weapon = -assets.units.weapons.default,
  fire_source = vector:new(16, -54),

  get_parts = function(self)
    return {"legs", "weapon"}
  end
})

soldier.weapon.follows = soldier -- TODO eDSL
soldier.weapon.following_offset = soldier.fire_source + vector:new(0, 32) -- TODO FIXME

return soldier