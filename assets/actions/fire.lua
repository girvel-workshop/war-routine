local units = require_all("assets.units")

return (require "eros.aspects.action"):new("fire", "armed", "armed", {
  start = function(entity)
    if not entity.weapon.bullets:move(-1) then
      return 0
    end

    assets.sounds.fire:play()
    game:add(units.items.shell):put_near(entity)
    game:add(units.items.bullet):fire_from(entity)

    return entity.weapon.fire_time
  end
})

-- return aspects.action[[fire | armed -> armed]]({
--   [0] = function(entity)
--     if not entity.weapon.bullets.move(-1) then
--       return 0
--     end

--     assets.sounds.fire.play()
--     game:add(units.items.shell):put_near(entity)
--     game:add(units.items.bullet):fire_from(entity)
--   end
-- })