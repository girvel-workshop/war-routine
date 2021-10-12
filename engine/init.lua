--- Engine initialization library
local engine_lib = {}

engine_lib.put_globals = function()
  package.path = package.path .. ";engine/lib/?.lua"

  -- external libraries
  log = require "log" -- TODO log outfile
  log.level = "trace"

  strong = require "strong"

  inspect = require 'inspect'
  tiny = require 'tiny'
  gamera = require 'gamera'
  yaml = require "lyaml"
  require "tesound"

  -- girvel framework
  env = require 'env'
  fnl = require 'fnl'
  module = require 'module'
  syntax = require 'syntax'
  vector = require 'structures.vector'
  limited = require 'structures.limited'
  tk = require 'tk'

  env.fix()

  -- engine module
  engine = module 'engine'

  -- constants
  math.randomseed(os.time())

  -- game
  game = {
    world = tiny.world(unpack(
      engine.systems()/fnl.values()
    )),
    create = function(self, prototype)
      return self:add(prototype/fnl.copy())
    end,
    add = function(self, entity)
      log.info("add", entity)
      tiny.add(self.world, entity)

      if entity.radius then
        table.insert(self.physics_subjects, entity)
        entity.collides_with = false
      end

      if entity.get_parts then
        for _, part_name in ipairs(entity:get_parts()) do
          self:add(entity[part_name])
        end
      end

      return entity
    end,
    remove = function(self, entity)
      if entity.radius then
        fnl.remove_mut(self.physics_subjects, entity)
      end

      tiny.remove(self.world, entity)
    end,

    physics_subjects = {}
  }

  -- assets module
  assets = module "assets"
end

engine_lib.initialize = function(configuration)
  love.load = function()
    window_size = vector(
      love.graphics.getWidth(),
      love.graphics.getHeight()
    )

    game.camera = game:add {
      name = "game.camera",

      follows = false,
      position = vector.zero,
      rotation = 0,
      anchor = window_size * .5,
      gamera = gamera.new(-10000, -10000, 20000, 20000) -- TODO levels sizes
    }

    game:add(game.main_character)
    game.controller = game:create(configuration.controller)
    game.controller.controls = game.main_character
  end

  for _, callback in ipairs {'update', 'keypressed', 'mousepressed', 'draw'} do
    love[callback] = function(...)
      game.world:update({...}, function(x) return x.system_type == callback end)
    end
  end

  game.main_character = configuration.main_character
  configuration.first_level:load()
end

return engine_lib