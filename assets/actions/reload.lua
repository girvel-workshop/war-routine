return aspects.action:new[[reload | armed -> armed]]({
  [0] = function(entity)
    if entity.weapon.bullets_other <= 0 then
      return 0
    end

    entity.weapon.bullets:move(entity.weapon.bullets_other)
    entity.weapon.bullets_other = entity.weapon.bullets_other - entity.weapon.bullets.value
  end,
  [1] = function(entity)
    if entity.weapon.bullets_other > 0 then 
      game:create(-assets.units.items.magazine):put_near(entity)
    end
  end
})