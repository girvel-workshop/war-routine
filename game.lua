local tiny = require("libraries.tiny")
local inspect = require("libraries.inspect")
local aspects = tk.require_all("aspects")
local assets = require_all("assets")

local systems = tk.require_all("systems")

math.randomseed(os.time())

function love.load()
  window_size = tk.vector:new(
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )

  world = tiny.world(
    systems.animation,
    systems.drawing,
    systems.moving,
    systems.following,
    systems.acting
  )

  game = {
    world = world
  }

  function game:add(prototype)
    result = tk.copy(prototype)
    tiny.add(self.world, result)
    return result
  end

  -- PRESETS

  mc = game:add(assets.units.characters.soldier)

  controller = { -- TODO :use_map
    controls = mc,
    maps = {
      keypressed = {
        q = {assets.actions.arm, assets.actions.disarm},
        r = {assets.actions.reload}
      },
      mousepressed = {
        [1] = {assets.actions.fire}
      }
    }
  }

  function controller:use_map(map, key)
    local actions = controller.maps[map][key]
    if not actions then return end
    
    for _, action in ipairs(actions) do
      if action:order(controller.controls) then
        return
      end
    end
  end

  camera = {
    follows = controller.controls,
    position = controller.controls.position,
    anchor = window_size / 2,
  }

  tiny.add(world, camera)
end

function love.update(dt)
  world:update(dt, tiny.rejectAll("drawing_system_flag"))

  -- MOVEMENT

  mc.velocity = tk.vector:zero()

  if love.keyboard.isDown("w") then -- TODO REFACTOR
    mc.velocity.y = -mc.speed
  end
  if love.keyboard.isDown("s") then
    mc.velocity.y = mc.speed
  end
  if love.keyboard.isDown("a") then
    mc.velocity.x = -mc.speed
  end
  if love.keyboard.isDown("d") then
    mc.velocity.x = mc.speed
  end

  if love.keyboard.isDown("lshift") then 
    if mc.stamina:move(-dt) then
      mc.velocity = mc.velocity * mc.run_multiplier
    end
  else
    mc.stamina:move(dt)
  end

  -- MOUSE

  local mx, my = love.mouse.getPosition()
  mc.rotation = math.atan2(window_size.y / 2 - my, window_size.x / 2 - mx)
end

function love.keypressed(key)
  controller:use_map("keypressed", key)
end

function love.mousepressed(x, y, button, istouch)
  controller:use_map("mousepressed", button)
end

function love.draw()
  love.graphics.translate((camera.anchor - camera.position):unpack()) -- TODO camera system

  world:update(0, tiny.requireAll("drawing_system_flag"))
end