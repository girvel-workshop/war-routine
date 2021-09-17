package.path = package.path .. ";engine/lib/?.lua"

log = require "log" -- TODO log outfile
log.level = arg[3] == "debug" and "trace" or "info"

strong = require "strong"

env = require 'env'
fnl = require 'fnl'
module = require 'module'
syntax = require 'syntax'
vector = require 'structures.vector'
limited = require 'structures.limited'
tk = require 'tk'

env.fix()

engine = module 'engine'

inspect = require 'inspect'
tiny = require 'tiny'
gamera = require 'gamera'
yaml = require "lyaml"
require "tesound"

require("engine.modes." .. (arg[2] or "default"))
