tk = require("eros.libraries.girvel.toolkit")
fnl = require("eros.libraries.girvel.functional")
vector = require("eros.libraries.girvel.vector")

require_all = tk.require_all

inspect = require("eros.libraries.inspect")
tiny = require("eros.libraries.tiny")
gamera = require("eros.libraries.gamera")


if arg[2] == "test" then
	arg = {}
	result = pcall(function() require("tests.main") end)
	love.event.quit(result)
else
	math.randomseed(os.time())

	window_size = vector:new(
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )

	game = {
    world = tiny.world(
      unpack(tk.values(require_all("systems")))
    ),
    add = function(self, prototype)
      result = tk.copy(prototype)
      tiny.add(self.world, result)
      return result
    end,
    remove = function(self, entity)
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
    }
  }

  game.camera = game:add({
    follows = false,
    position = vector:zero(),
    anchor = window_size / 2,
    gamera = gamera.new(-10000, -10000, 20000, 20000) -- TODO levels
  })

  aspects = require_all("eros.aspects")
  assets = require_all("assets")

	require("game")
end