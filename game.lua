local aspects = require_all("eros.aspects")
local assets = require_all("assets")

local systems = require_all("systems")

math.randomseed(os.time())

function love.load()
  window_size = vector:new(
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )

  world = tiny.world(
    systems.animation,
    systems.drawing,
    systems.moving,
    systems.following,
    systems.acting,
    systems.looking,
    systems.death_timing
  )

  game = {
    world = world
  }

  function game:add(prototype)
    result = tk.copy(prototype)
    tiny.add(self.world, result)
    return result
  end

  function game:remove(entity)
    tiny.remove(self.world, entity)
  end

  -- PRESETS

  mc = game:add(assets.units.characters.soldier)
  mc.follows = game:add(mc.legs)
  mc.legs = mc.follows

  game:add(assets.units.ui.help)

  controller = {
    controls = mc,
    maps = {
      keypressed = {
        q = {assets.actions.arm, assets.actions.disarm},
        r = {assets.actions.reload}
      },
      mousepressed = {
        [1] = {assets.actions.fire}
      }
    },
    use_map = function(self, map, key)
      local actions = controller.maps[map][key]
      if not actions then return end
      
      for _, action in ipairs(actions) do
        if action:order(controller.controls) then
          return
        end
      end
    end
  }

  camera = game:add({
    follows = controller.controls,
    position = controller.controls.position,
    anchor = window_size / 2,
    gamera = gamera.new(-10000, -10000, 20000, 20000) -- TODO levels
  })
end

function love.update(dt)
  world:update(dt, tiny.rejectAll("drawing_system_flag"))

  -- MOVEMENT

  mc.legs.velocity = vector:zero()

  if love.keyboard.isDown("w") then -- TODO REFACTOR
    mc.legs.velocity = vector:left():rotated(mc.rotation) * mc.legs.speed
    assets.actions.move:order(mc.legs)
  end
  if love.keyboard.isDown("s") then
    mc.legs.velocity = -vector:left():rotated(mc.rotation) * mc.legs.speed
  end
  if love.keyboard.isDown("a") then
    mc.rotation = mc.rotation - mc.rotation_speed * dt
  end
  if love.keyboard.isDown("d") then
    mc.rotation = mc.rotation + mc.rotation_speed * dt
  end

  if love.keyboard.isDown("lshift") then 
    if mc.stamina:move(-dt) then
      mc.legs.velocity = mc.legs.velocity * mc.legs.run_multiplier
    end
  else
    mc.stamina:move(dt)
  end
end

function love.keypressed(key)
  controller:use_map("keypressed", key)
end

function love.mousepressed(x, y, button, istouch)
  controller:use_map("mousepressed", button)
end

function love.draw()
  camera.gamera:setPosition(camera.position:unpack())
  camera.gamera:setAngle(camera.follows.rotation - math.pi / 2)

  camera.gamera:draw(function(l, t, w, h)
    world:update(0, tiny.requireAll("drawing_system_flag"))
  end)
end