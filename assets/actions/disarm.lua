return aspects.action:new[[arm | armed -> normal]]({
  [0] = function(entity)
    entity.weapon.visible = false
  end
})