return (require "aspects.action"):new("move", nil, nil, "move", {
  start = function(entity)
    return 0.5
  end,
  update = function(entity, dt)
    entity.rotation = math.atan2(entity.velocity.y, entity.velocity.x)
  end
})