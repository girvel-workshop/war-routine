return engine.aspects.action()[[fire | normal -> normal]]({
	[0] = function(entity)
    if not entity.bullets:move(-1) then
      return 0
    end

    log.trace(inspect(-assets.sounds))
    assets.sounds.fire():play()
    game:create(-assets.units.items.shell):put_near(entity)
    game:create(-assets.units.items.bullet):fire_from(entity)
  end
})