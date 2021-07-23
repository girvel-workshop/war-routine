return eros.aspects.action():new[[fire | armed -> armed]]({
  [0] = function(entity)
    assets.actions.weapon_fire():order(entity.weapon)
  end
})