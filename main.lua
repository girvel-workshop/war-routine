local engine = require 'engine'

engine.put_globals()
engine.initialize {
  main_character = -assets.units.characters.soldier,
  first_level = -assets.levels.prototype,
  controller = -assets.units.controller
}
