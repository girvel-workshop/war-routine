function love.load()
  mc = game:add(assets.units.characters.soldier)
  mc.follows = game:add(mc.legs)
  mc.legs = mc.follows

  game:add(assets.units.ui.help)

  game.controller.controls = mc

  game.controller.maps.keypressed = {
    q = {assets.actions.arm, assets.actions.disarm},
    r = {assets.actions.reload}
  }

  game.controller.maps.mousepressed = {
    [1] = {assets.actions.fire}
  }

  game.camera.follows = mc
end

function love.update(dt)
  game.world:update(dt, tiny.rejectAll("drawing_system_flag"))

  local subj = game.controller.controls

  -- MOVEMENT

  subj.legs.velocity = vector:zero()

  if love.keyboard.isDown("w") then -- TODO REFACTOR
    subj.legs.velocity = vector:left():rotated(subj.rotation) * subj.legs.speed
    assets.actions.move:order(mc.legs)
  end
  if love.keyboard.isDown("s") then
    subj.legs.velocity = -vector:left():rotated(subj.rotation) * subj.legs.speed
  end
  if love.keyboard.isDown("a") then
    subj.rotation = subj.rotation - subj.rotation_speed * dt
  end
  if love.keyboard.isDown("d") then
    subj.rotation = subj.rotation + subj.rotation_speed * dt
  end

  if love.keyboard.isDown("lshift") then 
    if subj.stamina:move(-dt) then
      subj.legs.velocity = subj.legs.velocity * subj.legs.run_multiplier
    end
  else
    subj.stamina:move(dt)
  end
end

function love.keypressed(key)
  game.controller:use_map("keypressed", key)
end

function love.mousepressed(x, y, button, istouch)
  game.controller:use_map("mousepressed", button)
end

function love.draw()
  game.camera.gamera:setPosition(game.camera.position:unpack())
  game.camera.gamera:setAngle(game.camera.follows.rotation - math.pi / 2)

  game.camera.gamera:draw(function(l, t, w, h)
    game.world:update(0, tiny.requireAll("drawing_system_flag"))
  end)
end