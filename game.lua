local tiny = require("libraries.tiny")
local tk = require("libraries.girvel_toolkit")
local inspect = require("libraries.inspect")
local aspects = tk.require_all("aspects")
local content = require_all("assets.content")

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

  -- PRESETS
  
  actions = {
    fire = aspects.action:new("fire", "armed", "armed", "fire", {
      start = function(entity)
        if entity.sprite ~= entity.cluster.armed or not entity.weapon.bullets:move(-1) then
          return 0
        end

        tiny.add(world, { -- TODO to content
          sprite = content.sprites.shell,
          position = entity.position
          + (entity.fire_source 
             + (tk.vector:new(math.random(), math.random()) * 2 - tk.vector:one()) * 15
            ):rotated(entity.rotation) / 2,
          rotation = entity.rotation + 60 * (math.random() * 2 - 1)
        })

        tiny.add(world, { -- TODO to content
          sprite = content.sprites.bullet,
          position = entity.position + entity.fire_source:rotated(entity.rotation),
          rotation = entity.rotation,
          velocity = tk.vector.left():rotated(entity.rotation) * 1000
        })

        return entity.weapon.fire_time
      end
    }),
    reload = aspects.action:new("reload", "armed", "armed", nil, {
      start = function(entity)
        if entity.sprite ~= entity.cluster.armed or entity.weapon.bullets_other <= 0 then
          return 0
        end

        tiny.add(world, {
          sprite = content.sprites.magazine,
          position = entity.position 
          + (entity.fire_source 
             + tk.vector:new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
            ):rotated(entity.rotation) / 2
        })

        entity.weapon.bullets.value = math.min(entity.weapon.bullets.limit, entity.weapon.bullets_other)
        entity.weapon.bullets_other = entity.weapon.bullets_other - entity.weapon.bullets.value

        return entity.reload_time
      end
    }),
    arm = aspects.action:new("arm", "normal", "armed", nil, {start = function(entity) return entity.arming_time end}),
    disarm = aspects.action:new("disarm", "armed", "normal", nil, {start = function(entity) return entity.arming_time end})
  }

  mc = tk.copy(content.units.mc)

  controller = {
    controls = mc,
    keyboard_map = {
      q = {actions.arm, actions.disarm},
      r = {actions.reload}
    },
    mouse_map = {
      [1] = {actions.fire}
    }
  }

  camera = {
    follows = controller.controls,
    position = controller.controls.position,
    anchor = window_size / 2,
  }

  tiny.add(world, camera)
  tiny.add(world, mc)
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