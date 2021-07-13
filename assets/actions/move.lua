return (require "aspects.action"):new("move", nil, nil, {
  update = function(entity, dt)
    entity.rotation = math.atan2(entity.velocity.y, entity.velocity.x)
  end
})