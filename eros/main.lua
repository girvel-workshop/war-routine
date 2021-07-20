strong = require("eros.libraries.strong")

tk = require("eros.libraries.girvel.toolkit")
fnl = require("eros.libraries.girvel.functional")
vector = require("eros.libraries.girvel.vector")
limited = require("eros.libraries.girvel.limited")

require_all = tk.require_all

inspect = require("eros.libraries.inspect")
tiny = require("eros.libraries.tiny")
gamera = require("eros.libraries.gamera")

require("eros.libraries.tesound")

aspects = require_all("eros.aspects")


if arg[2] == "selftest" then
  arg = {}
  result = pcall(function() require("eros.tests.main") end)
  love.event.quit(result)
elseif arg[2] == "test" then
	arg = {}
	result = pcall(function() require("tests.main") end)
	love.event.quit(result)
else
  function love.load()
  	math.randomseed(os.time())

  	window_size = vector:new(
      love.graphics.getWidth(),
      love.graphics.getHeight()
    )

  	game = {
      world = tiny.world(
        unpack(fnl.values(require_all("eros.systems")))
      ),
      add = function(self, prototype)
        result = fnl.copy(prototype)

        if prototype.get_parts then
          for _, partname in ipairs(prototype:get_parts()) do
            tiny.add(self.world, result[partname])
          end
        end

        print("tiny.add", result)
        tiny.add(self.world, result)

        if result.radius then
          table.insert(self.physics_subjects, result)
          result.collision_with = false
        end
        
        return result
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

    game.camera = game:add({
      name = "game.camera",

      follows = false,
      position = vector:zero(),
      rotation = 0,
      anchor = window_size / 2,
      gamera = gamera.new(-10000, -10000, 20000, 20000) -- TODO levels
    })

    assets = require_all("assets")

    eros = {}

  	require("game")

    if eros.load then eros.load() end
  end

  function love.update(dt)
    -- for _, object in ipairs(game.physics_subjects) do 

    for i, object1 in ipairs(game.physics_subjects) do
      for j, object2 in ipairs(game.physics_subjects) do -- TODO optimize
        if i ~= j and (object1.position - object2.position):magnitude() <= object1.radius + object2.radius then
          object1.collision_with = object2
          object2.collision_with = object1
        end
      end
    end

    TEsound.cleanup()
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
    game.camera.gamera:setAngle(game.camera.rotation - math.pi / 2) -- TODO rotate MC sprite!!!

    game.camera.gamera:draw(function(l, t, w, h)
      game.world:update(0, tiny.requireAll("drawing_system_flag"))
    end)
  end
end