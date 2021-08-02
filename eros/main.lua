-- TODO refactor this shit
strong = require("strong")
decorator = require("eros.libraries.girvel.decorator")
fnl = require("eros.libraries.girvel.functional")
tk = require("eros.libraries.girvel.toolkit")
module = require("eros.libraries.girvel.module")

eros = module:new[[eros]]


vector = -eros.libraries.girvel.vector
limited = -eros.libraries.girvel.limited

inspect = require[[inspect]]
tiny = require[[tiny]]
gamera = -eros.libraries.girvel.gamera

require("eros.libraries.girvel.tesound")

log = -eros.libraries.girvel.log -- TODO log outfile
log.level = arg[3] == "debug" and "trace" or "info"

require("eros.modes." .. (arg[2] or "default"))