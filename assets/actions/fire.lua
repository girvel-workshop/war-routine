local units = require_all("assets/units")

return (require "aspects.action"):new("fire", "armed", "armed", "fire", {
  start = function(entity)
    if not entity.weapon.bullets:move(-1) then
      return 0
    end

    game:add(units.shell):put(entity)
    game:add(units.bullet):fire(entity)

    return entity.weapon.fire_time
  end
})