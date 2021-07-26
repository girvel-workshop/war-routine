log.trace[[trace]]
log.info[[WAR-ROUTINE starts]]
function love.load()
  log.info[[initializing engine variables]]
	math.randomseed(os.time())

	window_size = vector:new(
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )

	game = {
    world = tiny.world(
      unpack(fnl.values(-eros.systems))
    ),
    create = function(self, prototype)
      return self:add(fnl.copy(prototype))
    end,
    add = function(self, entity)
      log.info("add", entity)
      tiny.add(self.world, entity)

      if entity.radius then
        table.insert(self.physics_subjects, entity)
        entity.collides_with = false
      end

      if entity.get_parts then
        for _, partname in ipairs(entity:get_parts()) do
          self:add(entity[partname])
        end
      end

      return entity
    end,
    remove = function(self, entity)
      if entity.radius then
        fnl.remove(self.physics_subjects, entity)
      end

      tiny.remove(self.world, entity)
    end,

    controller = {
    	maps = {},
    	use_map = function(self, map, key)
	      local actions = self.maps[map][key]
	      if not actions then return end
	      
	      for _, action in ipairs(actions) do
	        if action:order(self.controls) then
	          return
	        end
	      end
	    end
    },

    physics_subjects = {}
  }

  game.camera = game:create({
    name = "game.camera",

    follows = false,
    position = vector:zero(),
    rotation = 0,
    anchor = window_size / 2,
    gamera = gamera.new(-10000, -10000, 20000, 20000) -- TODO levels
  })

  assets = module:new[[assets]]

  log.info[[loading the game]]

	require("game")

  log.info[[initializing the game]]

  if eros.load then eros.load() end

  log.info[[game started successfully]]
end

function love.update(dt)
  for _, object in ipairs(game.physics_subjects) do 
    object.collides_with = false
  end

  for i, object1 in ipairs(game.physics_subjects) do
    for j, object2 in ipairs(game.physics_subjects) do -- TODO optimize
      if i ~= j and (object1.position - object2.position):magnitude() <= object1.radius + object2.radius then
        object1.collides_with = object2
        object2.collides_with = object1
      end
    end
  end

  TEsound.cleanup()
  game.world:update(dt, tiny.rejectAll("drawing_system_flag"))

  local subj = game.controller.controls

  -- MOVEMENT

  subj.legs.velocity = vector:zero()

  if love.keyboard.isDown("w") then -- TODO REFACTOR
    subj.legs.velocity = vector.up():rotated(subj.rotation) * subj.legs.speed
    assets.actions.move():order(mc.legs)
  end
  if love.keyboard.isDown("s") then
    subj.legs.velocity = -vector.up():rotated(subj.rotation) * subj.legs.speed
  end
  if love.keyboard.isDown("a") then
    subj.legs.rotation = subj.legs.rotation - subj.legs.rotation_speed * dt
  end
  if love.keyboard.isDown("d") then
    subj.legs.rotation = subj.legs.rotation + subj.legs.rotation_speed * dt
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
  game.camera.gamera:setAngle(game.camera.rotation)

  game.camera.gamera:draw(function(l, t, w, h)
    game.world:update(0, tiny.requireAll("drawing_system_flag"))
  end)
end