return engine.aspects.action()[[arm | armed -> normal]]({
  [0] = function(entity)
    entity.weapon.visible = false
  end
})