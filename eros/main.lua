-- TODO refactor this shit
strong = require("eros.libraries.strong")
decorator = require("eros.libraries.girvel.decorator")
fnl = require("eros.libraries.girvel.functional")
tk = require("eros.libraries.girvel.toolkit")
module = require("eros.libraries.girvel.module")

eros = module:new[[eros]]


vector = -eros.libraries.girvel.vector
limited = -eros.libraries.girvel.limited

inspect = -eros.libraries.inspect
tiny = -eros.libraries.tiny
gamera = -eros.libraries.gamera

require("eros.libraries.tesound")

log = -eros.libraries.log -- TODO log outfile
log.level = arg[3] == "debug" and "trace" or "info"

require("eros.modes." .. (arg[2] or "default"))