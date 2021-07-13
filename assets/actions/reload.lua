local units = require_all("assets.units")

return (require "aspects.action"):new("reload", "armed", "armed", "reload", {
  start = function(entity)
    if entity.weapon.bullets_other <= 0 then
      return 0
    end

    game:add(units.items.magazine):put(entity)

    entity.weapon.bullets.value = math.min(entity.weapon.bullets.limit, entity.weapon.bullets_other)
    entity.weapon.bullets_other = entity.weapon.bullets_other - entity.weapon.bullets.value

    return entity.reload_time
  end
})