return engine.aspects.action()[[arm | normal -> armed]]{
  [1] = function(entity)
    entity.weapon.visible = true
  end
}