local units = require_all("assets/units")

return (require "aspects.action"):new("fire", "armed", "armed", nil, {
  start = function(entity)
    if not entity.weapon.bullets:move(-1) then
      return 0
    end

    game:add(units.items.shell):put(entity)
    game:add(units.items.bullet):fire(entity)

    return entity.weapon.fire_time
  end
})