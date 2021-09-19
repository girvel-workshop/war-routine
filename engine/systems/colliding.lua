return tiny.processingSystem()/fnl.extend{ -- TODO eDSL
  name = "systems.colliding",
  filter = tiny.requireAll("collides_with", "damage"),

  process = function(self, entity, dt)
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