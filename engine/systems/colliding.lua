return tiny.processingSystem {
  name = "engine.systems.colliding",
  system_type = "update",
  filter = tiny.requireAll('collides_with', 'damage'),

  preProcess = function(_, dt)
    for _, object in ipairs(game.physics_subjects) do
      object.collides_with = false
    end

    for i, object1 in ipairs(game.physics_subjects) do
      for j, object2 in ipairs(game.physics_subjects) do -- TODO optimize
        if i ~= j and (object1.position - object2.position):magnitude() <= object1.radius + object2.radius then
          object1.collides_with = object2
          object2.collides_with = object1
        end
      end
    end
  end,
  
  process = function(_, entity, _)
    if entity.collides_with then
      if entity.collides_with.health then
        entity.collides_with.health:move(-entity.damage)

        if entity.collides_with.health:is_min() then
          game:remove(entity.collides_with)
        end
      end
      game:remove(entity)
    end
  end
}