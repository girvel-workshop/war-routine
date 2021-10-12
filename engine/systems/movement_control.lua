return tiny.processingSystem {  -- TODO redo this
  name = 'engine.systems.movement_control',
  system_type = 'update',
  filter = tiny.requireAll 'controls',

  update = function(_, controller, dt)
    local controls = controller.controls
    local legs = controls.legs

    legs.velocity = vector.zero

    if love.keyboard.isDown("w") then -- TODO REFACTOR
      legs.velocity = vector.up:rotated(legs.rotation) * legs.speed
      assets.actions.move():order(subj.legs)
    end
    if love.keyboard.isDown("s") then
      legs.velocity = -vector.up:rotated(legs.rotation) * legs.speed
    end
    if love.keyboard.isDown("a") then
      legs.rotation = legs.rotation - legs.rotation_speed * dt
    end
    if love.keyboard.isDown("d") then
      legs.rotation = legs.rotation + legs.rotation_speed * dt
    end

    if love.keyboard.isDown("lshift") then
      if subj.stamina:move(-dt) then
        legs.velocity = legs.velocity * legs.run_multiplier
      end
    else
      subj.stamina:move(dt)
    end
  end
}