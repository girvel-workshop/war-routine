strong = require("strong")

-- TODO initialize globals
decorator = require("decorator")
fnl = require("fnl")
tk = require("tk")
module = require("module")
vector = require("vector")
limited = require("limited")

eros = module:new[[eros]]

inspect = require[[inspect]]
tiny = require[[tiny]]
gamera = require("gamera")
require "tesound"

log = require "log" -- TODO log outfile
log.level = arg[3] == "debug" and "trace" or "info"

require("eros.modes." .. (arg[2] or "default"))
