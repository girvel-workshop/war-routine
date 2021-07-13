local units = require_all("assets.units")

return (require "aspects.action"):new("reload", "armed", "armed", {
  start = function(entity)
    if entity.weapon.bullets_other <= 0 then
      return 0
    end

    entity.weapon.bullets.value = math.min(entity.weapon.bullets.limit, entity.weapon.bullets_other)
    entity.weapon.bullets_other = entity.weapon.bullets_other - entity.weapon.bullets.value

    return entity.skills.reload
  end,
  stop = function(entity)
    game:add(units.items.magazine):put(entity)
  end
})