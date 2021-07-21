local units = require_all("assets.units")

return aspects.action:new[[fire | armed -> armed]]({
  [0] = function(entity)
    if not entity.weapon.bullets:move(-1) then
      return 0
    end

    assets.sounds.fire:play()
    game:create(units.items.shell):put_near(entity)
    game:create(units.items.bullet):fire_from(entity)

    require("assets.actions.weapon_fire"):order(entity.weapon)

    return entity.weapon.fire_time
  end
})