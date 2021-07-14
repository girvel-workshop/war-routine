return (require "eros.aspects.action"):new("move", nil, nil, {
  start = function(entity)
    return 128 / entity.velocity:magnitude()
  end,
  update = function(entity, dt)
    entity.rotation = math.atan2(entity.velocity.y, entity.velocity.x)
  end
})