--- Engine initialization library
local engine_lib = {}

engine_lib.put_globals = function()
  package.path = "engine/lib/?.lua;" .. package.path

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
    world = tiny.world(log.trace(unpack(
      engine.systems()/fnl.values()
    ))),
    create = function(self, prototype)
      return self:add(prototype/fnl.copy())
    end,
    add = function(self, entity)
      log.stack_delta = 1
      log.info("add", entity)
      log.stack_delta = nil

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

    game.main_character = game:add(configuration.main_character)

    game.camera = game:add(engine.units.entity()/fnl.extend {
      name = "game.camera",

      follows = game.main_character,
      position = vector.zero,
      rotation = 0,
      anchor = window_size * .5,
      gamera = gamera.new(-10000, -10000, 20000, 20000) -- TODO levels sizes
    })

    game.controller = game:create(configuration.controller)
    game.controller.controls = game.main_character

    configuration.first_level:load()
  end

  for _, callback in ipairs {'update', 'keypressed', 'mousepressed', 'draw'} do
    love[callback] = function(...)
      game.world:update(
        select('#', ...) == 1 and select(1, ...) or {...},
        function(_, x) return x.system_type == callback end
      )
      end
  end
end

return engine_lib