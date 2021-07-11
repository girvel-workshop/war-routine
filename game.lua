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
    keyboard_map = {
      q = {assets.actions.arm, assets.actions.disarm},
      r = {assets.actions.reload}
    },
    mouse_map = {
      [1] = {assets.actions.fire}
    }
  }

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
  local a = controller.keyboard_map[key]
  if not a then return end
  
  for _, action in ipairs(a) do -- TODO unify
    if controller.controls.cluster[action.starting_state] == controller.controls.sprite then
      action:order(controller.controls) 
      break
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  local a = controller.mouse_map[button]
  if not a then return end
  
  for _, action in ipairs(a) do
    if controller.controls.cluster[action.starting_state] == controller.controls.sprite then
      action:order(controller.controls) 
      break
    end
  end
end

function love.draw()
  love.graphics.translate((camera.anchor - camera.position):unpack()) -- TODO camera system

  world:update(0, tiny.requireAll("drawing_system_flag"))
end